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
package org.apache.royale.reflection {
    
    COMPILE::JS{
        import goog.DEBUG;
    }
	
	COMPILE::SWF{
		import flash.utils.getDefinitionByName;
	}
    
    /**
     *  The description of a Class or Interface accessor (get and/or set)
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public class AccessorDefinition extends VariableDefinition
    {
        public function AccessorDefinition(name:String, isStatic:Boolean, owner:TypeDefinition, rawData:Object = null)
        {
            super(name,isStatic, owner, rawData);
        }
        /**
         * The type that defined this accessor
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
            return TypeDefinition.internalGetDefinition(declareBy);
        }


        private var _access:String;
        /**
         * The type of access that this accessor has.
         * One of: 'readonly', 'writeonly', or 'readwrite'
         * Note, these values are all lower case (not camelCase).
         */
        public function get access():String
        {
            if (_access) return _access;

            COMPILE::SWF {
                _access=rawData.@access;
            }
            COMPILE::JS {
                _access = rawData.access;
            }

            return _access;
        }
        
        COMPILE::JS
        override public function get getValue():Function{
			if (_getter != null) return _getter;
            if (isStatic || goog.DEBUG) {
                var cl:Class = getDefinitionByName(owner.qualifiedName) as Class;
            }
            var fieldName:String = name;
            if (isStatic) {
                _getter = function():* {return cl[fieldName]}
            } else {
                _getter = function(instance:Object):* {
                    if (goog.DEBUG) {
                        if (arguments.length != 1 || (!(instance is cl))) throw 'invalid getValue parameters';
                    }
                    return instance[fieldName];
                }
            }
			return _getter;
		}
	
		COMPILE::JS
		override public function get setValue():Function{
			if (_setter != null) return _setter;
            if (isStatic || goog.DEBUG) {
                var cl:Class = getDefinitionByName(owner.qualifiedName) as Class;
            }
			var fieldName:String = name;
			if (isStatic) {
				_setter = function(value:*):* {
					cl[fieldName] = value
				}
			} else {
				_setter = function(instance:Object, value:*):* {
					if (goog.DEBUG) {
						if (arguments.length != 2 || (!(instance is cl))) throw 'invalid setValue parameters';
					}
					instance[fieldName] = value;
				}
			}
			return _setter;
		}
        

        /**
         * A string representation of this accessor definition
         */
        override public function toString():String{
            var s:String = "accessor: '"+name+"' access:"+access+", type:"+type.qualifiedName+", declaredBy:"+declaredBy.qualifiedName;
            var meta:Array = metadata;
            var i:uint;
            var l:uint = meta.length;
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
