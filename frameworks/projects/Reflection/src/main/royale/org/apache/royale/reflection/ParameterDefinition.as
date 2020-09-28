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
    
    /**
     *  The description of a Function parameter
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2S
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public class ParameterDefinition extends DefinitionBase
	{

        public function ParameterDefinition( index:uint, rawData:Object, owner:MethodDefinition)
        {
            super("parameter "+index, rawData);
			_owner = owner;
        }


		private var _owner:MethodDefinition;
		/**
		 * reference to the MethodDefinition owner of this ParameterDefinition
		 */
		public function get owner():MethodDefinition{
			return _owner;
		}

		/**
		 * The type of this parameter
		 */
		public function get type():TypeDefinition{
			COMPILE::SWF {
				return TypeDefinition.internalGetDefinition(_rawData.@type);
			}

			COMPILE::JS {
				return TypeDefinition.internalGetDefinition(_rawData.type);
			}

		}
		/**
		 * Whether this parameter is optional (has a default value) or not
		 */
		public function get optional():Boolean {
			COMPILE::SWF {
				return _rawData.@optional == "true";
			}

			COMPILE::JS {
				return _rawData.optional;
			}

		}
		/**
		 * The 1-based index of this parameter in its owner function/method
		 */
		public function get index():uint{
			COMPILE::SWF {
				return uint(_rawData.@index);
			}

			COMPILE::JS {
				return _rawData.index;
			}

		}
        /**
         * A string representation of this parameter definition
         */
		public function toString():String{
			return _name+", optional:"+optional+", type:"+type.qualifiedName;
		}
    }
}
