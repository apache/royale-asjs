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
    COMPILE::JS{
        import org.apache.royale.utils.Language;
    }
    
    /**
     *  The description of a method inside a class or interface
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public class MethodDefinition extends MemberDefinitionBase
	{
        public function MethodDefinition(name:String, isStatic:Boolean, owner:TypeDefinition, rawData:Object = null)
        {
            super(name,isStatic, owner, rawData);
        }

        /**
         * The type that defined this method
         * This could be an ancestor class of the method's containing TypeDefinition
         */
        public function get declaredBy():TypeDefinition
        {
            /* possible alternate here, @todo review:
                return owner;
            */
            COMPILE::SWF{
                var declareBy:String = _rawData.@declaredBy;
            }
            COMPILE::JS{
                var declareBy:String = _rawData.declaredBy;
            }

            return TypeDefinition.internalGetDefinition(declareBy);
        }

        private var _parameters:Array;
        /**
         * The collection of parameters defined for this method
         * each parameter is represented by a ParameterDefinition instance
         */
        public function get parameters():Array {
            var results:Array;
            if (_parameters) {
                results = _parameters.slice();
               if (!TypeDefinition.useCache) _parameters = null;
               return results;
            }
            results = [];
            COMPILE::SWF {
                var xml:XML = rawData as XML;
                var data:XMLList = xml.parameter;
                var n:int = data.length();
                for (var i:int = 0; i < n; i++)
                {
                    var item:XML = data[i] as XML;
                    results.push(new ParameterDefinition(uint(item.@index),item, this));
                }
            }
            COMPILE::JS {
                if (rawData.parameters != null) {
                    var data:Array = rawData.parameters();
                    var n:int = data.length;
                    for (var i:int = 0; i < n; i+=2)
                    {
                        var index:uint = (i*.5) + 1;
                        var item:Object = {type:data[i], optional:data[i+1], index:index};
                        results.push(new ParameterDefinition(index,item, this));
                    }
                }
            }

            if (TypeDefinition.useCache) _parameters = results;
            return results;
        }
        /**
         * The return type for this method
         * note: a return type may be "*" or "void"
         */
        public function get returnType():TypeDefinition {
            COMPILE::SWF{
                var returnType:String = _rawData.@returnType;
            }

            COMPILE::JS{
                var returnType:String = _rawData.type;
            }

            return TypeDefinition.internalGetDefinition(returnType);
        }
        
        /**
         * Provides easy access to the method described by this definition
         * For instance member definitions it requires the instance to be passed as a single argument
         * For static member definitions it requires no argument
         *
         * @param inst an instance of this definition's owner class - required argument if this definition is for instance scope
         *
         * @return a function reference to the method that this definition describes
         */
        public function getMethod(inst:Object=null):Function{
            COMPILE::SWF{
                var methodName:Object = this.name;
                if (uri) methodName = new QName(uri, methodName);
            }
            COMPILE::JS{
                var methodName:String = this.name;
                var closureName:String = methodName;
                if (uri) {
                    closureName = uri+'::'+methodName; // same as QName instance toString()
                    methodName = QName.getAsObjectAccessFormat(uri, methodName); // same as QName instance.objectAccessFormat();
                }
            }
            const clazz:Class = getDefinitionByName(owner.qualifiedName);
            if (isStatic) {
                return clazz[methodName];
            } else {
                if (!inst || !(inst is clazz)) throw new Error('getMethod argument for instance MethodDefinition must be an instance of '+owner.qualifiedName);
                COMPILE::SWF{
                    return inst[methodName];
                }
                COMPILE::JS{
                    return Language.closure(inst[methodName], inst, closureName);
                }
            }
        }

        /**
         * A string representation of this method definition
         */
        public function toString():String{
            var retType:String=returnType.qualifiedName;
            if (retType=="") retType ="''";
            var uriNS:String = uri;
            if (uriNS) uriNS = ', uri=\''+ uriNS +'\'';
            var s:String="method: '"+name +"'" + uriNS + ", returnType:"+retType+" declaredBy:"+declaredBy.qualifiedName;
            var params:Array = parameters;
            var i:uint;
            var l:uint = params.length;
            if (!l) s+="\n\t{No parameters}";
            else
                for (i=0;i<l;i++) {
                    s+="\n\t"+params[i].toString();
                }
            var meta:Array = metadata;
            l = meta.length;
            if (l) {
                s += "\n\tmetadata:";
                for (i=0;i<l;i++) {
                    s += "\n\t\t" + meta[i].toString().split("\n").join("\n\t\t");
                }
            }
            return s;
        }
    }
}
