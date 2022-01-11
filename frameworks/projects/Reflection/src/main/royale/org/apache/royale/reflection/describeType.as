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
     *  The equivalent of flash.utils.describeType.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     *  
     *  @royaleignorecoercion Class
     */
    public function describeType(value:Object):TypeDefinition
	{
        COMPILE::SWF
        {
            var xml:XML = getDataInternal(value);
            return TypeDefinition.getDefinition(xml.@name, getDataInternal(value), value as Class);
        }
        COMPILE::JS
        {
            const qname:String = getQualifiedClassName(value);
            var clazz:Class = value ? (value.prototype ? value : value.constructor) as Class : null;
            return TypeDefinition.getDefinition(qname, getDataInternal(value, qname), clazz);
        }
    }
}
