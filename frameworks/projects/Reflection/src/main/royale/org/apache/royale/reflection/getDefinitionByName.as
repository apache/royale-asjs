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
    import flash.utils.getDefinitionByName;
}
COMPILE::JS
{
    import goog.global;
}
    
    /**
     *  The equivalent of flash.utils.getDefinitionByName.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function getDefinitionByName(name:String):*
	{
        COMPILE::SWF
        {
            //convenience 'top level' re-mapping for Vector names:
            if (name.indexOf("Vector.<") == 0)
            {
                name = '__AS3__.vec.' + name;
            }
            if (name == '__AS3__.vec.Vector.<*>') {
                //this does not work via native getDefinitionByName
                return Vector.<*>;
            }
            return flash.utils.getDefinitionByName(name);
        }
        COMPILE::JS
        {
            var parts:Array = name.split('.');
            var o:Object;
            if (parts[0] != 'Vector') {
                var n:int = parts.length;
                //use goog.global instead of window to support node too
                o = goog.global;
                for (var i:int = 0; i < n; i++) {
                    o = o[parts[i]];
                }
            } else {
                if (parts[1] != '<*>') {
                    if (!ExtraData.hasData(name)) {
                        //not already populated
                        if (ExtraData.hasData('Vector.<*>')) {
                            const newVectorData:Object = ExtraData.getData('Vector.<*>')['variant'](name);
                            ExtraData.addExternDefintion(newVectorData);
                            o = newVectorData['classRef']
                        } //otherwise not possible
                    } else {
                        o = ExtraData.getData(name)['classRef'];
                    }
                }
            }
            if (o == null && ExtraData.hasData(name)) o = ExtraData.getData(name)['classRef'];
            if (o == null) {
                if (name == 'undefined') return undefined;
                throw new ReferenceError('Error #1065: Variable '+name+' is not defined.')
            }
            return o;
        }
    }
}
