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
package org.apache.royale.reflection
{
    
    /**
     *  The description of a MetaData tag attached to a class member or a class
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public class MetaDataDefinition extends DefinitionBase
	{
        public function MetaDataDefinition(name:String, rawData:Object, owner:DefinitionWithMetaData)
        {
            super(name, rawData);
            _owner = owner;
        }

        private var _owner:DefinitionWithMetaData;
        /**
         * reference to the owner of this MetaDataDefinition (either a class member MemberDefinitionBase, or a class TypeDefinition)
         */
        public function get owner():DefinitionWithMetaData{
            return _owner;
        }

        private var _args:Array;
        /**
         * The argument pairs (if any) associated with a Metadata tag
         * in [Event(name="boom")]
         * the args array would be of length 1
         * the array contains MetaDataArgDefinitions
         */
        public function get args():Array
        {
            if (_args) return _args.slice();
            var results:Array = [];

            COMPILE::SWF
            {
                var xml:XML = rawData as XML;
                var data:XMLList = xml.arg;
                var n:int = data.length();
                for (var i:int = 0; i < n; i++)
                {
                    var item:XML = data[i] as XML;
                    var key:String = item.@key;
                    var value:String = item.@value;
                    results.push(new MetaDataArgDefinition(key, value, this));
                }
            }
            COMPILE::JS
            {
                var rdata:* = rawData;
                if (rdata !== undefined)
                {
                    var args:Array = rdata.args;
                    if (args)
                    {
                        args = args.slice();
                        while(args.length) {
                            var argDef:Object = args.shift();
                            results.push(new MetaDataArgDefinition(argDef.key, argDef.value, this));
                        }
                    }
                }
            }
            //fully populated, so release rawData ref
            _rawData = null;
            _args = results.slice();
            return  results;
        }

        /**
         * convenience method for retrieving a set of args with a specific key
         * Most often this would be of length 1, but it is possible for there to be
         * multiple MetaDataArgDefinitions with the same key
         * @param key the key to search for
         * @return an array of MetaDataArgDefinitions with the matching key.
         */
        public function getArgsByKey(key:String):Array{
            var ret:Array=[];
            var source:Array = _args || args;
            var i:uint=0, l:uint=source.length;
            for (;i<l;i++) {
                var arg:MetaDataArgDefinition = source[i];
                if (arg.key == key) ret.push(arg);
            }
            return ret;
        }

        /**
         * Used primarily for debugging purposes, this provides a string representation of this
         * MetaDataDefinition
         * @return a String representation of this MetaDataDefinition
         */
        public function toString():String
        {
            var s:String="item: '"+_name +"', ";
            var args:Array = this.args;
            var i:uint;
            var l:uint = args.length;
            if (!l) s+= "args:{none}";
            else {
                s+= "args:";
                for (i=0;i<l;i++) {
                    s+="\n\t"+args[i].toString();
                }
            }
            return s;
        }
    }
}
