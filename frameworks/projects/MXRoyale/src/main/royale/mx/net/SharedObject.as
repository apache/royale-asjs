////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////

package mx.net
{
    
    COMPILE::SWF
    {
        import flash.net.SharedObject;
        import flash.events.Event;
        import flash.events.NetStatusEvent;
        import flash.events.Event;
    }
    
    COMPILE::JS{
        import org.apache.royale.net.remoting.amf.AMFBinaryData;
    }
    import mx.events.NetStatusEvent;
    import org.apache.royale.events.EventDispatcher;
    
    /**
     * An emulation class to support the swf based Local SharedObject support.
     * This implementation supports AMF encoded content (requires registerClassAlias before reading and writing to roundtrip instances of custom classes)
     */
    public class SharedObject extends org.apache.royale.events.EventDispatcher
    {
        private static const map:Object = {};
        private static var unlocked:Boolean;
        
        public static function getLocal(name:String, localPath:String = null, secure:Boolean = false):mx.net.SharedObject
        {
            var pathKey:String = localPath == null ? '$null$' : localPath;
            COMPILE::JS {
                localPath = pathKey;
            }
            var cached:mx.net.SharedObject = map[pathKey + '::' + name];
            if (!cached)
            {
                unlocked = true;
                cached = new mx.net.SharedObject();
                unlocked = false;
                map[pathKey + '::' + name] = cached;
                cached.setName(name);
                cached.setLocalPath(localPath);
                cached.createSO(secure);
            }
            COMPILE::JS{
                if (!map['#']) {
                    window.addEventListener('pagehide', unloadHandler);
                    map['#'] = true;
                }
            }
            return cached;
        }
        
        COMPILE::JS
        private static function unloadHandler(event:PageTransitionEvent):void{
            //@todo consider whether we do anything different if event.persisted is true or false
            for (var key:String in map) {
                if (key != '#') {
                    var so:SharedObject = map[key];
                    //@todo what to do with errors here:
                    so.flush();
                }
            }
        }
        
        public function SharedObject()
        {
            if (!unlocked) throw new Error('ArgumentError: Error #2012: SharedObject class cannot be instantiated.')
        }
        
        COMPILE::SWF
        private var _so:flash.net.SharedObject;
        
        COMPILE::JS
        private var _ls:Storage;
    
        /**
         *
         * @param minDiskSpace ignored for javascript targets
         * @return a string indicating the flush status. This can be (on swf) SharedObjectFlushStatus.FLUSHED or SharedObjectFlushStatus.PENDING on swf. For JS is it SharedObjectFlushStatus.FLUSHED or SharedObjectFlushStatus.FAILED
         *
         * @throws Error #2044: Unhandled NetStatusEvent
         */
        public function flush(minDiskSpace:int = 0):String
        {
            COMPILE::JS
            {
                if (_data)
                {
                    try{
                        var amf:AMFBinaryData = new AMFBinaryData();
                        amf.writeObject(_data);
                        var base64:String = window['btoa'](String.fromCharCode.apply(null, amf.array));
                        _ls.setItem(_localPath + "::" + _name, base64);
                    } catch(e:Error) {
                        if (hasEventListener(NetStatusEvent.NET_STATUS)) {
                            var event:NetStatusEvent = new NetStatusEvent(NetStatusEvent.NET_STATUS);
                            event.info = {"code":"SharedObject.Flush.Failed","level":"error"};
                            dispatchEvent(event);
                            return SharedObjectFlushStatus.FAILED;
                        } else {
                            throw new Error('Error #2044: Unhandled NetStatusEvent:. level=error, code=SharedObject.Flush.Failed');
                        }
                    }
                }
                //js never returns pending, because there is no way for the user to accept or decline the byte size storage limits
                return SharedObjectFlushStatus.FLUSHED;
            }
            COMPILE::SWF
            {
                return _so.flush(minDiskSpace);
            }
        }
        
        public function clear():void{
            COMPILE::SWF{
                _so.clear();
            }
            COMPILE::JS{
                if (_data) {
                    if (_ls) {
                        _ls.removeItem(_localPath + "::" + _name);
                    }
                    _data = null;
                }
            }
        }
        
        COMPILE::JS
        private var _data:Object;
        
        public function get data():Object
        {
            COMPILE::SWF
            {
                return _so.data;
            }
            COMPILE::JS
            {
                if (!_data)
                {
                    _data = {};
                }
                return _data;
            }
        }
        
        private var _name:String;
        private function setName(name:String):void
        {
            COMPILE::JS{
                //apply same limits as swf
                if (/[~%&\\;:"',<>?#\s]/.test(name)) throw new Error('Error #2134: Cannot create SharedObject.')
            }
            _name = name;
        }
        
        private var _localPath:String;
        private function setLocalPath(localPath:String):void
        {
            _localPath = localPath;
        }
        COMPILE::SWF
        private function redispatch(event:flash.events.Event):void{
            if (event is flash.events.NetStatusEvent) {
                var nse:flash.events.NetStatusEvent = flash.events.NetStatusEvent(event);
                var mxnse:mx.events.NetStatusEvent = new mx.events.NetStatusEvent(nse.type,false, false, nse.info);
                dispatchEvent(mxnse);
            } else {
                //just redispatch?
                dispatchEvent(event.clone());
            }
        }
        
        private function createSO(secure:Boolean):void
        {
            COMPILE::SWF{
                _so = flash.net.SharedObject.getLocal(_name, _localPath, secure);
                _so.addEventListener('netStatus', redispatch);
                _so.addEventListener('asyncError', redispatch); //not sure about this one for LSO..
                //_so.addEventListener('sync', redispatch); //only relevant for RSO, not LSO
            }
            COMPILE::JS{
                _ls = window.localStorage;
                if (!_ls && typeof Storage != "undefined") {
                    //this gets around an issue with local testing with file:// protocol in IE11
                    var p:String = window.location.pathname.replace(/(^..)(:)/, "$1$$");
                    window.location.href = window.location.protocol + "//127.0.0.1" + p;
                    _ls = window.localStorage;
                }
                if (!_ls) {
                    throw new Error('local storage not supported');
                }
                var base64:String = _ls.getItem(_localPath + "::" + _name);
                if (base64)
                {
                    var binary_string:String = window['atob'](base64);
                    var arr:Uint8Array = new Uint8Array(
                            binary_string.split('')
                                    .map(
                                            function (charStr:String):uint
                                            {
                                                return charStr.charCodeAt(0);
                                            }
                                    )
                    );
                    var amf:AMFBinaryData = new AMFBinaryData(arr.buffer);
                    _data = amf.readObject();
                }
            }
        }
    }
    
}
