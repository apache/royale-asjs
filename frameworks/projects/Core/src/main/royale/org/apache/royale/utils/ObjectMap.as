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

package org.apache.royale.utils
{
    COMPILE::SWF
    {
        import flash.utils.Dictionary;
    }

    COMPILE::JS
    {
        import org.apache.royale.utils.UIDUtil;
    }
    /**
     *  The ObjectMap class is a hash class which supports weak keys
     *  and object keys on systems which support it. This includes Flash
     *  and most modern browsers. For browsers which do not support Map and WeakMap,
     *  it falls back to simple object hashes.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.1
     */

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
                makeMap();
            }
        }

        COMPILE::JS
        private function makeMap():void
        {
            if(_weak && typeof WeakMap == "function")
            {
                _map = new WeakMap();
                assignFunctions();
                return;
            }
            _weak = false;
            if(typeof Map == "function")
            {
                _map = new Map();
                assignFunctions();
            }
            else
            {
                _map = {};
                _usesObjects = true;
            }
        }

        private var _weak:Boolean;
        private var _map:Object;
        private var _usesObjects:Boolean = false;

        /**
         *  Removes the specified key
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.7.0
         * 
         */
        COMPILE::SWF
        public function delete(key:Object):void
        {
            delete _map[key];
        }

        /**
         *  Returns the value associated with the `key`, or `undefined`.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.7.0
         * 
         */
        COMPILE::SWF
        public function get(key:Object):*
        {
            return _map[key];
        }

        /**
         *  Returns whether the key has a value or not.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.7.0
         * 
         */
        COMPILE::SWF
        public function has(key:Object):Boolean
        {
            return _map[key] === undefined;
        }

        /**
         *  Sets the value for the specified key.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.7.0
         * 
         */
        COMPILE::SWF
        public function set(key:Object,value:*):void
        {
            _map[key] = value;
        }

        /**
         *  Removes all key/value pairs.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.7.0
         * 
         */
        COMPILE::SWF
        public function clear():void
        {
            _map = new Dictionary(_weak);
        }

        COMPILE::JS
        {
            /**
             *  @royalesuppresspublicvarwarning
             */
            public var get:Function = objectGet;
            /**
             *  @royalesuppresspublicvarwarning
             */
            public var set:Function = objectSet;
            /**
             *  @royalesuppresspublicvarwarning
             */
            public var has:Function = objectHas;
            /**
             *  @royalesuppresspublicvarwarning
             */
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
