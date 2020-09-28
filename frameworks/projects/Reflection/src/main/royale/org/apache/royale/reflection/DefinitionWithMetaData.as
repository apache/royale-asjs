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
     *  The base class for definition types that can be decorated with metadata in actionscript
     *  source code
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public class DefinitionWithMetaData extends DefinitionBase
	{
        public function DefinitionWithMetaData(name:String, rawData:Object = null)
        {
            super(name, rawData);
        }

        COMPILE::SWF
        protected var useFactory:Boolean;


        private var _metaData:Array;
        /**
         * gets a copy of the metadata collection array
         */
        public function get metadata():Array
        {
            if (_metaData) return _metaData.slice();
            var results:Array = [];
            COMPILE::SWF
            {
                var xml:XML = useFactory ? rawData.factory[0] as XML : rawData as XML;
                var data:XMLList = xml.metadata;
                var n:int = data.length();
                for (var i:int = 0; i < n; i++)
                {
                    var item:XML = data[i] as XML;
                    var metaName:String = item.@name;
                    results[i] = new MetaDataDefinition(metaName, item, this);
                }
            }
            COMPILE::JS
            {
                var rdata:*;
                var data:Object = rawData;
                if (data.names !== undefined)
                {
                    var name:String = data.names[0].qName;
                    var def:Object = getDefinitionByName(name);
                    if (def.prototype.ROYALE_REFLECTION_INFO)
                        rdata = def.prototype.ROYALE_REFLECTION_INFO();
                    else rdata = data;
                }
                else
                    rdata = data;
                if (rdata !== undefined && rdata.metadata !== undefined)
                {
                    var metadatas:Array = rdata.metadata();
                    if (metadatas)
                    {
                        var i:uint = 0;
                        var l:int = metadatas.length;
                        for (;i<l;i++) {
                            var mdDef:Object = metadatas[i];
                            results[i] = new MetaDataDefinition(mdDef.name, mdDef, this);
                        }
                    }
                }
            }
            _metaData = results.slice();
            return results;                        
        }

        /**
         * A convenience method for retrieving metadatas
         * @param name the name of the metadata item to retrieve.
         *        It can occur more than once, so an array is returned
         * @return an array of all MetaDataDefinition items with matching 'name'
         *
         */
        public function retrieveMetaDataByName(name:String):Array {
            var source:Array = _metaData || metadata;
            var results:Array = [];
            var i:uint=0, l:uint = source.length;
            if (l != 0) {
                for(;i<l;i++) if (source[i].name == name) results.push(source[i]);
            }
            return results;
        }
    }
}
