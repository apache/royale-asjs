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
		import goog.DEBUG;
		import org.apache.royale.utils.Language;
	}
	
	COMPILE::SWF{
		import flash.utils.getDefinitionByName;
	}
    /**
     *  The description of a Class or Interface variable
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public class VariableDefinition extends MemberDefinitionBase
	{
        public function VariableDefinition(name:String, isStatic:Boolean, owner:TypeDefinition, rawData:Object = null)
        {
            super(name,isStatic, owner, rawData);
        }

        /**
         * A TypeDefinition representing the type of the variable that
         * this VariableDefinition represents
         */
        public function get type():TypeDefinition {
            COMPILE::SWF {
                return TypeDefinition.internalGetDefinition(_rawData.@type);
            }

            COMPILE::JS {
                return TypeDefinition.internalGetDefinition(_rawData.type);
            }
        }
        
        protected var _getter:Function;
		/**
         * provides a function that supports reading the value described by this definition
         * For instance member definitions it requires the instance to be passed as a single argument
         * For static member definitions it requires no arguments
		 */
		public function get getValue():Function{
            if (_getter != null) return _getter;
            COMPILE::SWF{
				var fieldName:Object = this.name;
				var uri:String = this.uri;
				if (uri) fieldName = new QName(uri,fieldName);
				var cl:Class = flash.utils.getDefinitionByName(owner.qualifiedName) as Class;
                if (isStatic) {
					_getter = function():* {return cl[fieldName]}
                } else {
					_getter = function(instance:Object):* {
						if (arguments.length != 1 || (!(instance is cl))) throw 'invalid getValue parameters';
                        return instance[fieldName];
					}
                }
            }
			COMPILE::JS {
                var f:Function = _rawData.get_set;
                var canBeUndefined:Boolean = type.qualifiedName == '*';
                if (isStatic) {
					_getter = function():* {return canBeUndefined ? f(f) : f()}
                } else {
					_getter = function(instance:Object):* {
						if (goog.DEBUG) {
							if (arguments.length != 1 || !instance) throw 'invalid getValue parameters';
						}
                        return canBeUndefined ? f(instance, f) : f(instance)
                    }
                }
            }
			return _getter;
        }
		
		
		protected var _setter:Function;
		/**
		 * provides a function that supports setting the value described by this definition
         * For static member definitions it requires only the value argument
		 * For instance member definitions it requires the instance to be passed as a first argument, followed by the value
		 */
		public function get setValue():Function{
			if (_setter != null) return _setter;
			COMPILE::SWF{
				var fieldName:Object = this.name;
				var uri:String = this.uri;
				if (uri) fieldName = new QName(uri,fieldName);
				var cl:Class = flash.utils.getDefinitionByName(owner.qualifiedName) as Class;
				if (isStatic) {
					_setter = function(value:*):* {
                        cl[fieldName] = value
                    }
				} else {
					_setter = function(instance:Object, value:*):* {
						if (!(instance is cl)) throw 'invalid setValue parameters';
						instance[fieldName] = value;
					}
				}
			}
   
			COMPILE::JS {
				var f:Function = _rawData.get_set;
				var valueClass:Class;
				var type:String = _rawData.type;
				if (type && type != '*') {
					valueClass = getDefinitionByName(type);
				}
				if (isStatic) {
					_setter = function(value:*):* {
                        if (goog.DEBUG) {
                            if (arguments.length != 1) throw 'invalid setValue parameters';
							//todo: more robust runtime checking of value here for debug mode
                        }
						//coerce
						if (valueClass) value = Language.as(value, valueClass, true);
                        f(value);
                    }
				} else {
					_setter = function(instance:Object, value:*):* {
						if (goog.DEBUG) {
							if (arguments.length != 2 || !instance) throw 'invalid setValue parameters';
							//todo: more robust runtime checking of value here for debug mode
						}
						//coerce
						if (valueClass) value = Language.as(value, valueClass, true);
						f(instance, value);
					}
				}
			}
            return _setter;
		}
        
        
        /**
         * A string representation of this variable definition
         */
        public function toString():String {
			var uriNS:String = uri;
			if (uriNS) uriNS = ', uri=\''+ uriNS +'\'';
            var s:String = "variable: '"+name+"'" + uriNS + ", type:"+type.qualifiedName;
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
