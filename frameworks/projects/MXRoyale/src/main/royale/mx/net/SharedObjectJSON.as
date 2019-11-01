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
    
    import org.apache.royale.events.EventDispatcher;
    
    /**
     * An lighter weight emulation class to support the swf based Local SharedObject support.
     * This implementation does not support AMF encoded content. It is intended for javascript 
     * implementations that require persistence, but do not already have the AMF support dependency as part of the application
     */
    public class SharedObjectJSON extends org.apache.royale.events.EventDispatcher
    {
        private static const map:Object = {};
        private static var unlocked:Boolean;
        
        public static function getLocal(name:String, localPath:String = null, secure:Boolean = false):mx.net.SharedObjectJSON
        {
            var pathKey:String = localPath == null ? '$null$' : localPath;
            COMPILE::JS {
                localPath = pathKey;
            }
            var cached:mx.net.SharedObjectJSON = map[pathKey + '::' + name];
            if (!cached)
            {
                unlocked = true;
                cached = new mx.net.SharedObjectJSON();
                unlocked = false;
                map[pathKey + '::' + name] = cached;
                cached.setName(name);
                cached.setLocalPath(localPath);
                cached.createSO(secure);
            }
            return cached;
        }
        
        public function SharedObjectJSON()
        {
            if (!unlocked) throw new Error('ArgumentError: Error #2012: SharedObjectJSON class cannot be instantiated.')
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
                    _ls.setItem(_localPath + "::" + _name, JSON.stringify(_data));
                }
                return SharedObjectFlushStatus.FLUSHED;
            }
            COMPILE::SWF
            {
                if (_data) {
                    _so.data['jsonContent'] = JSON.stringify(_data);
                }
                return _so.flush(minDiskSpace);
            }
        }
        
        public function clear():void{
            COMPILE::SWF{
                _so.data['jsonContent'] = '{}';
                _so.flush();
                _data = {};
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
        

        private var _data:Object;
        
        public function get data():Object
        {
            COMPILE::SWF
            {
                if (!_data) {
                    if (_so.data['jsonContent']) {
                        try{
                            _data = JSON.parse(_so.data['jsonContent']);
                        } catch(e:Error) {
                            throw new Error('Error #2134: Bad data. Cannot create SharedObjectJSON.')
                        }
                    } else _data = {};
                }
                return _data;
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
                if (/[~%&\\;:"',<>?#\s]/.test(name)) throw new Error('Error #2134: Cannot create SharedObjectJSON.')
            }
            _name = name;
        }
        
        private var _localPath:String;
        private function setLocalPath(localPath:String):void
        {
            COMPILE::JS{
                localPath+='$jsonContent$';
            }
            _localPath = localPath;
        }
        
        private function createSO(secure:Boolean):void
        {
            COMPILE::SWF{
                _so = flash.net.SharedObject.getLocal(_name, _localPath, secure);
                
            }
            COMPILE::JS{
                _ls = window.localStorage;
                if (!_ls && typeof Storage != undefined) {
                    //this gets around an issue with local testing with file:// protocol in IE11
                    var p:String = window.location.pathname.replace(/(^..)(:)/, "$1$$");
                    window.location.href = window.location.protocol + "//127.0.0.1" + p;
                    _ls = window.localStorage;
                }
                if (!_ls) {
                    throw new Error('local storage not supported');
                }
                var json:String = _ls.getItem(_localPath + "::" + _name);
                if (json) {
                    try{
                        _data = JSON.parse(json);
                    } catch(e:Error) {
                        throw new Error('Error #2134: Bad data. Cannot create SharedObjectJSON.')
                    }
                }
            }
        }
    }
    
}
