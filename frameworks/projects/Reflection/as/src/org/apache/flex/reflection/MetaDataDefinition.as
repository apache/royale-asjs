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
    public class MetaDataDefinition extends DefinitionBase
	{
        public function MetaDataDefinition(name:String, rawData:Object)
        {
            super(name, rawData);
        }
        
        public function get args():Array
        {
            var results:Array = [];
            
            COMPILE::AS3
            {
                var xml:XML = rawData as XML;
                var data:XMLList = xml.args;
                var n:int = data.length();
                for (var i:int = 0; i < n; i++)
                {
                    var item:XML = data[i] as XML;
                    var key:String = item.@key;
                    var value:String = item.@value;
                    results.push(new MetaDataArgDefinition(key, value));
                }
            }
            COMPILE::JS
            {
                var data:Object = rawData;
                var name:String = data.names[0].qName;
                var def:Object = getDefinitionByName(name);
                var rdata:* = def.prototype.FLEXJS_REFLECTION_INFO();
                if (rdata !== undefined)
                {
                    var args:Array = rdata.args();
                    if (args)
                    {
                        var n:int = args.length;
                        for each (var argDef:Object in args)
                        results.push(new MetaDataArgDefinition(argDef.key, argDef.value));
                    }
                }
            }
            return results;            
        }
    }
}
