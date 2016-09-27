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
     *  The description of a Class or Interface variable
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    public class VariableDefinition extends DefinitionWithMetaData
	{
        public function VariableDefinition(name:String, rawData:Object)
        {
            super(name, rawData);
        }

        /**
         * A TypeDefinition representing the type of the variable that
         * this VariableDefinition represents
         */
        public function get type():TypeDefinition {
            COMPILE::SWF {
                return TypeDefinition.getDefinition(_rawData.@type);
            }

            COMPILE::JS {
                return TypeDefinition.getDefinition(_rawData.type);
            }
        }
        /**
         * A string representation of this variable definition
         */
        public function toString():String {
            var s:String = "variable: '"+name+"', type:"+type.qualifiedName;
            var meta:Array = metadata;
            var i:uint;
            var l:uint = meta.length;
            if (l) {
                s+="\n\tmetadata:";
                for (i=0;i<l;i++) {
                    s += "\n\t\t" + meta[i].toString().split("\n").join("\n\t\t");
                }
            }
            return s;
        }
        
    }
}
