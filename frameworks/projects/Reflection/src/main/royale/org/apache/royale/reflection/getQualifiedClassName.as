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
    import flash.utils.getQualifiedClassName;
}
COMPILE::JS{
    import org.apache.royale.utils.Language
}
    
    /**
     *  The equivalent of flash.utils.getQualifiedClassName.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function getQualifiedClassName(value:*):String
	{
        COMPILE::SWF
        {
            //normalize for Vector:
            return flash.utils.getQualifiedClassName(value).replace('__AS3__.vec::','').replace('::','.');
        }
        COMPILE::JS
        {
            var defName:String = typeof(value);
            if (defName === "string") return "String";
            if (defName === "number") {
                if (value === value>>0 && ExtraData.hasData('int') && (value >= -268435456 && value <= 268435455)) return 'int';
                return "Number";
            }
            if (defName === "boolean") return "Boolean";
            if (defName === "undefined") return null;
            if (value === null) return null;
            if (Array.isArray(value)) {
                //exclude Vector emulation:
                if (Language.SYNTH_TAG_FIELD in value) return value[Language.SYNTH_TAG_FIELD]['type'];
                return "Array";
            }
            var classInfo:Object = value.ROYALE_CLASS_INFO;
            
            if (!classInfo)
            {
                if (!value.prototype) {
                    //instance
                    if (ExtraData.hasData(value.constructor)) {
                        //value is instance of a 'native class'
                        classInfo =  ExtraData.getData(value.constructor)['ROYALE_CLASS_INFO'];
                    } else {
                        if (Language.isSynthType(value.constructor)) {
                            return value.constructor['type'];
                        }
                    }
                } else {
                    //class
                    classInfo = value.prototype.ROYALE_CLASS_INFO;
                    if (!classInfo) {
                        if (ExtraData.hasData(value)) {
                            //value is a native 'class'
                            classInfo =  ExtraData.getData(value)['ROYALE_CLASS_INFO'];
                        }
                    }
                    if (!classInfo) {
                        if (Language.isSynthType(value)) {
                            return value['type'];
                        }
                    }
                }
                if (!classInfo) {
                    //fallback
                    return "Object";
                }
            }
            return classInfo.names[0].qName;
        }
    }
}
