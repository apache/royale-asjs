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
package org.apache.royale.reflection.nativejs {
    
    COMPILE::JS{
        import org.apache.royale.utils.Language
    }
    
    /**
     * Provides data for a stand-in TypeDefinition of the native as3 type for javascript
     */
    COMPILE::JS
    public function AS3int():Object{
        if (singleton) return singleton;
        var ret:Object= {};
        ret['classRef'] = int;
        ret['name'] = 'int';
        ret['SYNTHETIC_TYPE'] = true;
        
        ret['ROYALE_CLASS_INFO'] = { names: [{ name: 'int', qName: 'int', kind: 'class' }] };
    
        ret['ROYALE_REFLECTION_INFO'] = function():Object {
            return {
                'methods':function():Object {
                    return {
                        'int':{'parameters':function():Object {return ['*', true]},'type':'','declaredBy':'int'}
                    };
                }
            };
        };
        singleton = ret;
        return ret;
    
    }
    
}
var singleton:* = null; //the explicit assignment with null is necessary here