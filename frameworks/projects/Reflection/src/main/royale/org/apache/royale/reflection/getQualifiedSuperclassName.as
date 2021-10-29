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
    import flash.utils.getQualifiedSuperclassName;
}
    
    /**
     *  The equivalent of flash.utils.getQualifiedSuperclassName,
     *  except that qualified names do not include '::' between the package naming sequence and the definition name.
     *  The '.' is always used to separate parts of the qualified name.
     *  An example would be "my.package.path.MyClassName"
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function getQualifiedSuperclassName(value:*):String
	{
        COMPILE::SWF
        {
            const val:String = flash.utils.getQualifiedSuperclassName(value);
            return val && val.replace('::','.');
        }
        COMPILE::JS
        {
            if (value === null || typeof value === 'undefined') return null;
            var constructorAsObject:Object = (value is Class) ? value : value["constructor"];
            var superRef:Object = constructorAsObject.superClass_;
            if (!superRef && ExtraData.hasData(constructorAsObject)) {
                if (constructorAsObject == Function && value.prototype == undefined) {
                    //special case - a Closure has Function as its Superclass.
                    superRef = ExtraData.getData(Function)
                } else {
                    superRef = ExtraData.getData(constructorAsObject)['NATIVE_BASE'];
                    if (superRef) {
                        //we only have a reference to the native base-class constructor itself, we now need to get the extra data for it:
                        superRef = ExtraData.getData(superRef)
                    }
                }
                if (superRef) {
                    superRef = superRef['ROYALE_CLASS_INFO'];
                }
            } else {
                if (superRef == null) return null;
                superRef = superRef.ROYALE_CLASS_INFO;
            }

            return superRef ? superRef.names[0].qName : null;
        }
    }
}
