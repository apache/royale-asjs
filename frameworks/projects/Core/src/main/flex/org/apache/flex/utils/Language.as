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
package org.apache.flex.utils
{

	[ExcludeClass]
	COMPILE::AS3
	public class Language {}

    COMPILE::JS
    {
        import goog.bind;
        import goog.global;
    }
    
    /**
     * @flexjsignoreimport goog.bind
     * @flexjsignoreimport goog.global
     */
    COMPILE::JS
	public class Language
	{

		//--------------------------------------
		//   Static Property
		//--------------------------------------

		//--------------------------------------
		//   Static Function
		//--------------------------------------

		/**
		 * as()
		 *
		 * @param leftOperand The lefthand operand of the
		 * binary as operator in AS3.
		 * @param rightOperand The righthand operand of the
		 * binary operator in AS3.
		 * @param coercion The cast is a coercion,
		 * throw exception if it fails.
		 * @return Returns the lefthand operand if it is of the
		 * type of the righthand operand, otherwise null.
		 */
		static public function as(leftOperand:Object, rightOperand:Object, coercion:* = null):Object
		{
			var error:Error, itIs:Boolean, message:String;

			coercion = (coercion !== undefined) ? coercion : false;

			itIs = Language.is(leftOperand, rightOperand);

			if (!itIs && coercion)
			{
				message = 'Type Coercion failed';

				if (TypeError)
				{
					error = new TypeError(message);
				}
				else
				{
					error = new Error(message);
				}
				throw error;
			}

			return (itIs) ? leftOperand : null;
		}


		/**
		 * int()
		 *
		 * @param value The value to be cast.
		 * @return {number}
		 */
		static public function _int(value:Number):Number
		{
			return value >> 0;
		}

		/**
		 * is()
		 *
		 * @param leftOperand The lefthand operand of the
		 * binary as operator in AS3.
		 * @param rightOperand The righthand operand of the
		 * binary operator in AS3.
		 * @return {boolean}
		 */
		static public function is(leftOperand:Object, rightOperand:Object):Boolean
		{
			var superClass:Object;

			if (leftOperand == null || rightOperand == null)
				return false;

            if (leftOperand instanceof rightOperand)
                return true;
            if (rightOperand === Object)
                return true; // every value is an Object in ActionScript except null and undefined (caught above)
            
			if (typeof leftOperand === 'string')
				return rightOperand === String;

			if (typeof leftOperand === 'number')
				return rightOperand === Number;

            if (typeof leftOperand === 'boolean')
                return rightOperand === Boolean;
            if (rightOperand === Array)
                return Array.isArray(leftOperand);

			if (leftOperand.FLEXJS_CLASS_INFO === undefined)
				return false; // could be a function but not an instance

			if (leftOperand.FLEXJS_CLASS_INFO.interfaces)
			{
				if (checkInterfaces(leftOperand, rightOperand))
				{
					return true;
				}
			}

			superClass = leftOperand.constructor;
            superClass = superClass.superClass_;

			if (superClass)
			{
				while (superClass && superClass.FLEXJS_CLASS_INFO)
				{
					if (superClass.FLEXJS_CLASS_INFO.interfaces)
					{
						if (checkInterfaces(superClass, rightOperand))
						{
							return true;
						}
					}
					superClass = superClass.constructor;
                    superClass = superClass.superClass_;
				}
			}

			return false;
		}

        /**
         * Helper function for is()
         */
        private static function checkInterfaces(leftOperand:*, rightOperand:*):Boolean
        {
            var i:int, interfaces:Array;
            
            interfaces = leftOperand.FLEXJS_CLASS_INFO.interfaces;
            for (i = interfaces.length - 1; i > -1; i--) {
                if (interfaces[i] === rightOperand) {
                    return true;
                }
                
                if (interfaces[i].prototype.FLEXJS_CLASS_INFO.interfaces) {
                    var isit:Boolean = checkInterfaces(interfaces[i].prototype, rightOperand);
                    if (isit) return true;
                }
            }
            
            return false;
        }
        
        /**
         * Implementation of "classDef is Class"
         */
        public function isClass(classDef:*):Boolean
        {
            return typeof classDef === 'function'
                   && classDef.prototype
                   && classDef.prototype.constructor === classDef;
        }
            
        /**
         * Implementation of "classDef as Class"
         */
        public function asClass(classDef:*):Class
        {
            return isClass(classDef) ? classDef : null;
        }
        
		/**
		 * postdecrement handles foo--
		 *
		 * @param obj The object with the getter/setter.
		 * @param prop The name of a property.
		 * @return {number}
		 */
		static public function postdecrement(obj:Object, prop:String):int
		{
			var value:int = obj[prop];
			obj[prop] = value - 1;
			return value;
		}

		/**
		 * postincrement handles foo++
		 *
		 * @param obj The object with the getter/setter.
		 * @param prop The name of a property.
		 * @return {number}
		 */
		static public function postincrement(obj:Object, prop:String):int
		{
			var value:int = obj[prop];
			obj[prop] = value + 1;
			return value;
		}

		/**
		 * predecrement handles --foo
		 *
		 * @param obj The object with the getter/setter.
		 * @param prop The name of a property.
		 * @return {number}
		 */
		static public function predecrement(obj:Object, prop:String):int
		{
			var value:int = obj[prop] - 1;
			obj[prop] = value;
			return value;
		}

		/**
		 * preincrement handles ++foo
		 *
		 * @param obj The object with the getter/setter.
		 * @param prop The name of a property.
		 * @return {number}
		 */
		static public function preincrement(obj:Object, prop:String):int
		{
			var value:int = obj[prop] + 1;
			obj[prop] = value;
			return value;
		}

		/**
		 * superGetter calls the getter on the given class' superclass.
		 *
		 * @param clazz The class.
		 * @param pthis The this pointer.
		 * @param prop The name of the getter.
		 * @return {Object}
		 */
		static public function superGetter(clazz:Object, pthis:Object, prop:String):Object
		{
			var superClass:Object = clazz.superClass_;
			var superdesc:Object = Object.getOwnPropertyDescriptor(superClass, prop);

			while (superdesc == null)
			{
				superClass = superClass.constructor;
                superClass = superClass.superClass_;
				superdesc = Object.getOwnPropertyDescriptor(superClass, prop);
			}
			return superdesc.get.call(pthis);
		}

		/**
		 * superSetter calls the setter on the given class' superclass.
		 *
		 * @param clazz The class.
		 * @param pthis The this pointer.
		 * @param prop The name of the getter.
		 * @param value The value.
		 */
		static public function superSetter(clazz:Object, pthis:Object, prop:String, value:Object):void
		{
			var superClass:Object = clazz.superClass_;
			var superdesc:Object = Object.getOwnPropertyDescriptor(superClass, prop);

			while (superdesc == null)
			{
				superClass = superClass.constructor;
                superClass = superClass.superClass_;
				superdesc = Object.getOwnPropertyDescriptor(superClass, prop);
			}
			superdesc.set.apply(pthis, [value]);
		}

		static public function trace(...rest):void
		{
			var theConsole:*;

			theConsole = goog.global.console;

			if (theConsole === undefined)
			{
				if(typeof window !== "undefined")
				{
					theConsole = window.console;
				}
				else if(typeof console !== "undefined")
				{
					theConsole = console;
				}
			}

			try
			{
				if (theConsole && theConsole.log)
				{
					theConsole.log.apply(theConsole, rest);
				}
			}
			catch (e:Error)
			{
				// ignore; at least we tried ;-)
			}
		}

		/**
		 * uint()
		 *
		 * @param value The value to be cast.
		 * @return {number}
		 */
		static public function uint(value:Number):Number
		{
			return value >>> 0;
		}
        
        /**
         * caches closures and returns the one closure
         *
         * @param fn The method on the instance.
         * @param object The instance.
         * @param boundMethodName The name to use to cache the closure.
         * @return The closure.
         */
        static public function closure(fn:Function, object:Object, boundMethodName:String):Function {
            if (object.hasOwnProperty(boundMethodName)) {
                return object[boundMethodName];
            }
            var boundMethod:Function = goog.bind(fn, object);
            Object.defineProperty(object, boundMethodName, {
                value: boundMethod
            });
            return boundMethod;
        };

	}
}
