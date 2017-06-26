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

package org.apache.flex.utils
{
    COMPILE::SWF
    {
        import flash.utils.Dictionary;
    }

    COMPILE::JS
    {
        import org.apache.flex.utils.UIDUtil;
    }

    public class ObjectMap
    {
        public function ObjectMap(weak:Boolean=false)
        {
            _weak = weak;
            COMPILE::SWF
            {
                _map = new Dictionary(weak);
            }
            COMPILE::JS
            {
                if(weak)
                {
                    if(typeof WeakMap == "function")
                    {
                        _map = new WeakMap();
                        assignFunctions();
                    }
                    else if(typeof Map == "function")//Map is supported, fall back to that
                    {
                        _map = new Map();
                        assignFunctions();
                        _weak = false;
                    }
                    else
                    {
                        _map = {};
                        _usesObjects = true;
                    }
                }
                else if(typeof Map == "function")
                {
                    _map = new Map();
                    assignFunctions();
                }
                else
                {
                    _map = {};
                    _usesObjects = true;
                    assignFunctions();
                }
            }

        }
        private var _weak:Boolean;
        private var _map:Object;
        private var _usesObjects:Boolean = false;

        COMPILE::SWF
        public function delete(key:Object):void
        {
            delete _map[key];
        }

        COMPILE::SWF
        public function get(key:Object):*
        {
            return _map[key];
        }
        COMPILE::SWF
        public function has(key:Object):Boolean
        {
            return _map[key] === undefined;
        }
        COMPILE::SWF
        public function set(key:Object,value:*):void
        {
            _map[key] = value;
        }
        COMPILE::SWF
        public function clear():void
        {
            _map = new Dictionary(_weak);
        }

        COMPILE::JS
        {
            public var get:Function = objectGet;
            public var set:Function = objectSet;
            public var has:Function = objectHas;
            public var delete:Function = objectDelete;
        }

        COMPILE::JS
        private function assignFunctions():void
        {
            this.get = _map.get.bind(_map);
            this.has = _map.has.bind(_map);
            this.set = _map.set.bind(_map);
            this.delete = _map.delete.bind(_map);
        }

        COMPILE::JS
        private function objectDelete(key:Object):void
        {
            delete _map[key];
        }
        COMPILE::JS
        private function objectGet(key:Object):*
        {
            switch(key.constructor)
            {
                case Number:
                case String:
                    return _map[key];
                case Object:
                    if(key.object_map_uid)
                        return _map[key["object_map_uid"]];
                    else
                        return undefined;
                default:
                    return undefined;
            }
        }
        COMPILE::JS
        private function objectHas(key:Object):Boolean
        {
            return _map[key] === undefined;
        }
        COMPILE::JS
        private function objectSet(key:Object,value:*):void
        {
            switch(key.constructor)
            {
                case Number:
                case String:
                    _map[key] = value;
                case Object:
                    if(!key.object_map_uid)
                        key.object_map_uid = UIDUtil.createUID();
                        _map[key["object_map_uid"]] = value;
                default:
                    return;
            }
        }
        COMPILE::JS
        public function clear():void
        {
            if(_usesObjects)
                _map = {};
            else if(_weak)
            {
                _map = new WeakMap();
                assignFunctions();
            }
            else
            {
                _map = new Map();
                assignFunctions();
            }
        }

    }    
}
