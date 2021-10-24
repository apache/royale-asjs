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
import org.apache.royale.reflection.getClosureQualifiedName;

    /**
     * Provides data for a stand-in TypeDefinition of the native as3 type for javascript
     */
    COMPILE::JS
    public function AS3Function():Object{
        if (singleton) return singleton;
        var contents:Array
        var funcDef:Object= {};
        funcDef['classRef'] = Function;
        funcDef['name'] = 'Function';
        funcDef['NATIVE_TYPE'] = true;
        funcDef['NATIVE_BASE'] = Object;

        funcDef['ROYALE_CLASS_INFO'] = { names: [{ name: 'Function', qName: 'Function', kind: 'class', isDynamic: true }] };

        funcDef['ROYALE_REFLECTION_INFO'] = function():Object {
            return {
                'accessors':function():Object {
                    return {
                        'length':{'access':'readonly','type':'int','declaredBy':'Function'}
                    };
                },
                'methods':function():Object {
                    return {
                        'Function':{'declaredBy':'Function','type':''}
                    };
                }
            };
        };
        contents = [funcDef];
        const methodClosureQName:String = getClosureQualifiedName();
        const methodClosureName:String = methodClosureQName.substr(methodClosureQName.lastIndexOf('.') + 1);
        //now for "Closure"
        funcDef = {};
        funcDef['classRef'] = Function; //this is not correct, but there is no reference to 'Closure' as a subclass of 'Function'
        funcDef['name'] = methodClosureQName;
        funcDef['NATIVE_TYPE'] = true;
        funcDef['NATIVE_BASE'] = Function;

        funcDef['ROYALE_CLASS_INFO'] = { names: [{ name: methodClosureName, qName: methodClosureQName, kind: 'class', isDynamic: true }] };

        funcDef['ROYALE_REFLECTION_INFO'] = function():Object {
            return {
                'accessors':function():Object {
                    return {
                        'prototype':{'access':'readwrite','type':'int','declaredBy':methodClosureQName}
                    };
                },
                'methods':function():Object {
                    var obj:Object = {};
                    obj[methodClosureName] = {'declaredBy':methodClosureQName,'type':''};
                    return obj;
                }
            };
        };
        contents[1] = funcDef;
        singleton = contents;
        return contents;
    }
}
var singleton:* = null; //the explicit assignment with null is necessary here