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
    }
    
    COMPILE::JS{
        import org.apache.royale.net.remoting.amf.AMFBinaryData;
    }
    
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
            return cached;
        }
        
        public function SharedObject()
        {
            if (!unlocked) throw new Error('ArgumentError: Error #2012: SharedObject class cannot be instantiated.')
        }
        
        COMPILE::SWF
        private var _so:flash.net.SharedObject;
        
        COMPILE::JS
        private var _ls:Storage;
        
        
        public function flush(minDiskSpace:int = 0):String
        {
            COMPILE::JS
            {
                if (_data)
                {
                    var amf:AMFBinaryData = new AMFBinaryData();
                    amf.writeObject(_data);
                    var base64:String = window['btoa'](String.fromCharCode.apply(null, amf.array));
                    _ls.setItem(_localPath + "::" + _name, base64);
                }
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
        
        private function createSO(secure:Boolean):void
        {
            COMPILE::SWF{
                _so = flash.net.SharedObject.getLocal(_name, _localPath, secure);
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
