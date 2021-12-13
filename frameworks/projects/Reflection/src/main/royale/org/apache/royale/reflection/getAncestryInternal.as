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
COMPILE::SWF
{
    import flash.utils.describeType;
}
COMPILE::JS
{
    import org.apache.royale.utils.Language;
}   

    /**
     *  @private
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     *
     */
    internal function getAncestryInternal(value:Object, into:Array=null, transformer:Function = null):Array
	{
        var results:Array = into ? into : [];
        COMPILE::SWF
        {
            var xml:XML = value as XML;
            var data:XMLList = xml.factory.extendsClass;
            var n:int = data.length();
            for (var i:int = 0; i < n; i++)
            {
                var item:XML = data[i] as XML;
                var qname:String = item.@type.replace('::','.');
                var push:Object = transformer != null ? transformer(qname) : qname;

                results.push(push);
            }
        }
        COMPILE::JS
        {
            var data:Object = value;
            var qname:String = data.names[0].qName;
            var def:Object = getDefinitionByName(qname);
            var superClass:Object = def.superClass_;
            if (!superClass) {
                if (ExtraData.hasData(qname)) {
                    superClass = ExtraData.getData(qname)['NATIVE_BASE'];
                }

            }
            while (superClass) {
                var superData:Object;
                var js_native:Boolean = false;
                if (superClass.ROYALE_CLASS_INFO !== undefined) {
                    superData = superClass.ROYALE_CLASS_INFO;
                } else {
                    if (ExtraData.hasData(superClass)) {
                        superData = ExtraData.getData(getQualifiedClassName(superClass))['ROYALE_CLASS_INFO'];
                        if (superData) {
                            js_native = true;
                        } else {
                            //exit
                            superClass = null;
                        }
                    } else {
                        //exit
                        superClass = null;
                        superData = null;
                    }
                }
                if (superData) {
                    qname = superData.names[0].qName;
                    var push:Object = transformer != null ? transformer(qname) : qname;
                    results.push(push);
                    if (!js_native) {
                        def = getDefinitionByName(qname);
                        superClass = def.superClass_;
                    } else {
                        if (ExtraData.hasData(qname)) {
                            superClass = ExtraData.getData(qname)['NATIVE_BASE']
                        } else {
                            superClass = null;
                        }
                    }
                }
            }
        }

        return results;
    }
}
