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
COMPILE::SWF
{
    import flash.utils.describeType;
}
    
    /**
     *  The equivalent of flash.utils.describeType.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    public function describeType(value:Object):TypeDefinition
	{
        COMPILE::SWF
        {

            var untyped:* = value;
            if (value !== null && untyped !== undefined) {
                //normalize the query object to the static Class or interface level
                while (value['constructor'] !== Class) {
                    value = value['constructor'];
                }
            }
            var xml:XML = flash.utils.describeType(value);
            return TypeDefinition.getDefinition(xml.@name, xml);
        }
        COMPILE::JS
        {
            var qname:String = getQualifiedClassName(value);
            return TypeDefinition.getDefinition(qname, value.FLEXJS_CLASS_INFO || value.prototype.FLEXJS_CLASS_INFO);
        }
    }
}
