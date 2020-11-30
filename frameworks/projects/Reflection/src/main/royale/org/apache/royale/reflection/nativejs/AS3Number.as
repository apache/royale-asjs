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
    
    /**
     * Provides data for a stand-in TypeDefinition of the native as3 type for javascript
     */
    COMPILE::JS
    public function AS3Number():Object{
        if (singleton) return singleton;
        var ret:Object= {};
        ret['classRef'] = Number;
        ret['name'] = 'Number';
        ret['NATIVE_TYPE'] = true;
        
        ret['ROYALE_CLASS_INFO'] = { names: [{ name: 'Number', qName: 'Number', kind: 'class' }] };
    
        ret['ROYALE_REFLECTION_INFO'] = function():Object {
            return {
                'methods':function():Object {
                    return {
                        'Number':{'parameters':function():Object { return ['*',true]},'type':'','declaredBy':'Number'},
                        '|sin':{'parameters':function():Object {return ['Number', false]},'declaredBy':'Number','type':'Number'},
                        '|random':{'declaredBy':'Number','type':'Number'},
                        '|atan2':{'parameters':function():Object {return ['Number', false,{'index':2,'optional':false,'type':'Number'}]},'declaredBy':'Number','type':'Number'},
                        '|sqrt':{'parameters':function():Object {return ['Number', false]},'declaredBy':'Number','type':'Number'},
                        '|cos':{'parameters':function():Object {return ['Number', false]},'declaredBy':'Number','type':'Number'},
                        '|asin':{'parameters':function():Object {return ['Number', false]},'declaredBy':'Number','type':'Number'},
                        '|tan':{'parameters':function():Object {return ['Number', false]},'declaredBy':'Number','type':'Number'},
                        '|floor':{'parameters':function():Object {return ['Number', false]},'declaredBy':'Number','type':'Number'},
                        '|max':{'parameters':function():Object {return ['Number', true, 'Number', true]},'declaredBy':'Number','type':'Number'},
                        '|abs':{'parameters':function():Object {return ['Number', false]},'declaredBy':'Number','type':'Number'},
                        '|exp':{'parameters':function():Object {return ['Number', false]},'declaredBy':'Number','type':'Number'},
                        '|atan':{'parameters':function():Object {return ['Number', false]},'declaredBy':'Number','type':'Number'},
                        '|round':{'parameters':function():Object {return ['Number', false]},'declaredBy':'Number','type':'Number'},
                        '|log':{'parameters':function():Object {return ['Number', false]},'declaredBy':'Number','type':'Number'},
                        '|min':{'parameters':function():Object {return ['Number', true, 'Number', true]},'declaredBy':'Number','type':'Number'},
                        '|acos':{'parameters':function():Object {return ['Number', false]},'declaredBy':'Number','type':'Number'},
                        '|ceil':{'parameters':function():Object {return ['Number', false]},'declaredBy':'Number','type':'Number'},
                        '|pow':{'parameters':function():Object {return ['Number', false,{'index':2,'optional':false,'type':'Number'}]},'declaredBy':'Number','type':'Number'}
                    };
                }
            };
        };
        singleton = ret;
        return ret;
    
    }
    
}
var singleton:* = null; //the explicit assignment with null is necessary here