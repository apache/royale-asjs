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
    
    /**
     *  The description of a method inside a class or interface
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    public class MethodDefinition extends DefinitionWithMetaData
	{
        public function MethodDefinition(name:String, rawData:Object)
        {
            super(name, rawData);
        }

        /**
         * The type that defined this method
         * This could be an ancestor class of the method's containing TypeDefinition
         */
        public function get declaredBy():TypeDefinition
        {
            COMPILE::SWF{
                var declareBy:String = _rawData.@declaredBy;
            }
            COMPILE::JS{
                var declareBy:String = _rawData.declaredBy;
            }
            return TypeDefinition.getDefinition(declareBy);
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
                    results.push(new ParameterDefinition(uint(item.@index),item));
                }
            }
            COMPILE::JS {
                if (rawData.parameters != null) {
                    var data:Array = rawData.parameters();
                    var n:int = data.length;
                    for (var i:int = 0; i < n; i++)
                    {
                        var item:Object = data[i];
                        results.push(new ParameterDefinition(uint(item.index),item));
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

            return TypeDefinition.getDefinition(returnType);
        }

        /**
         * A string representation of this method definition
         */
        public function toString():String{
            var retType:String=returnType.qualifiedName;
            if (retType=="") retType ="''";
            var s:String="method: '"+name +"', returnType:"+retType+" declaredBy:"+declaredBy.qualifiedName;
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
