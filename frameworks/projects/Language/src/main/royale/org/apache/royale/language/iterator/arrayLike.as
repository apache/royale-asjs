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
package org.apache.royale.language.iterator
{
    /**
     * Used by the compiler for classes with [RoyaleArrayLike] metadata when processing for-in/for-each-in loops
     * @param forInstance the instance to be checked
     * @param lengthCheck either a string that represents a property to return length value, or a function method reference, e.g. instance.length()
     * @param getAt the String name of the accessor for the item at index... e.g. 'getItemAt'. If null it will default to Array Access []
     * @param lengthIsMethodCall true if the length accessor is an explicit method call instead of a getter
     * @param keys true if the request is to iterate over keys (as opposed to values)
     * @return a lightweight iterator Object with hasNext() and next() methods
     *
     * @royalesuppressexport
     */
    public function arrayLike(forInstance:Object, lengthCheck:String, getAt:String, lengthIsMethodCall:Boolean, keys:Boolean = false):Object{
        if (forInstance) {
            var i:int = 0;
            var ret:Object = { };
            if (lengthIsMethodCall) {
                ret['hasNext'] = function():Boolean{
                    return i < forInstance[lengthCheck]();
                }
            } else {
                ret['hasNext'] = function():Boolean{
                    return i < forInstance[lengthCheck]
                }
            }
            if (getAt != null){
                ret['next']  = function():*{
                    if (keys) return (i++)+''; //for-in: for (var key:String in target)
                    return forInstance[getAt](i++);//for-each-in: for each(var something:Something in target)
                }
            } else {
                ret['next'] = function():*{
                    if (keys) return (i++)+''; //for-in: for (var key:String in target)
                    return forInstance[i++];//for-each-in: for each(var something:Something in target)
                }
            }
        } else {
            //no need to create a new instance:
            ret = NULL_ITERABLE;
        }
        return ret;
    }
}
/**
 * @royalesuppressexport
 */
const NULL_ITERABLE:* = {
    'hasNext':function():Boolean{
        return false;
    },
    'next':function():*{ 
        //this should never be called in compiler-generated code in any case
        throw new TypeError('Cannot iterate over a null object reference');
    }
};


