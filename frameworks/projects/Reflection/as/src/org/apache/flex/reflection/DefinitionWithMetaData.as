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
package org.apache.flex.reflection
{
    
    /**
     *  The description of a Class or Interface
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    public class DefinitionWithMetaData extends DefinitionBase
	{
        public function DefinitionWithMetaData(name:String, rawData:Object = null)
        {
            super(name, rawData);
        }
        
        public function getMetaData():Array
        {
            var results:Array = [];
            
            COMPILE::AS3
            {
                var xml:XML = rawData as XML;
                var data:XMLList = xml.metadata;
                var n:int = data.length();
                for (var i:int = 0; i < n; i++)
                {
                    var item:XML = data[i] as XML;
                    var qname:String = item.@name;
                    results.push(new MetaDataDefinition(qname, item));
                }
            }
            COMPILE::JS
            {
                var rdata:* = rawData;
                if (rdata !== undefined)
                {
                    var metadatas:Array = rdata.metadata();
                    if (metadatas)
                    {
                        var n:int = metadatas.length;
                        for each (var mdDef:Object in metadatas)
                        results.push(new MetaDataDefinition(mdDef.name, mdDef));
                    }
                }
            }
            return results;                        
        }
    }
}
