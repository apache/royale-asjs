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
	public class Language
	{

		//--------------------------------------
		//   Static Property
		//--------------------------------------

		//--------------------------------------
		//   Static Function
		//--------------------------------------

		/**
		 * _as()
		 *
		 * @export
		 * @param {?} leftOperand The lefthand operand of the
		 * binary as operator in AS3.
		 * @param {?} rightOperand The righthand operand of the
		 * binary operator in AS3.
		 * @param {?=} coercion The cast is a coercion,
		 * throw expception if it fails.
		 * @return {?} Returns the lefthand operand if it is of the
		 * type of the righthand operand, otherwise null.
		 */
		static public function _as(leftOperand:Object, rightOperand:Object, coercion:* = null):Object
		{
			var error:Error, itIs:Boolean, message:String;

			coercion = (coercion !== undefined) ? coercion : false;

			itIs = _is(leftOperand, rightOperand);

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
		 * @export
		 * @param {?} value The value to be cast.
		 * @return {number}
		 */
		static public function _int(value:Number):Number
		{
			return value >> 0;
		}

		/**
		 * _is()
		 *
		 * @export
		 * @param {?} leftOperand The lefthand operand of the
		 * binary as operator in AS3.
		 * @param {?} rightOperand The righthand operand of the
		 * binary operator in AS3.
		 * @return {boolean}
		 */
		static public function _is(leftOperand:Object, rightOperand:Object):Boolean
		{
			var checkInterfaces:Function, superClass:Object;

			if (!leftOperand)
				return false;

			if (leftOperand && !rightOperand)
			{
				return false;
			}

			checkInterfaces = function(left:Object):Boolean {
				var i:uint, interfaces:Array;

				interfaces = left.FLEXJS_CLASS_INFO.interfaces;
				for (i = interfaces.length - 1; i > -1; i--) {
					if (interfaces[i] === rightOperand) {
						return true;
					}

					if (interfaces[i].prototype.FLEXJS_CLASS_INFO.interfaces) {
						var isit:Boolean = checkInterfaces(new interfaces[i]());
						if (isit) return true;
					}
				}

				return false;
			};

			if ((rightOperand === String && typeof leftOperand === 'string') ||
				(leftOperand instanceof /** @type {Object} */(rightOperand)))
			{
				return true;
			}

			if (typeof leftOperand === 'string')
				return false; // right was not String otherwise exit above

			if (typeof leftOperand === 'number')
				return rightOperand === Number;

			if (rightOperand === Array && Array.isArray(leftOperand))
				return true;

			if (leftOperand.FLEXJS_CLASS_INFO === undefined)
				return false; // could be a function but not an instance

			if (leftOperand.FLEXJS_CLASS_INFO.interfaces)
			{
				if (checkInterfaces(leftOperand))
				{
					return true;
				}
			}

			superClass = leftOperand.constructor.superClass_;

			if (superClass)
			{
				while (superClass && superClass.FLEXJS_CLASS_INFO)
				{
					if (superClass.FLEXJS_CLASS_INFO.interfaces)
					{
						if (checkInterfaces(superClass))
						{
							return true;
						}
					}
					superClass = superClass.constructor.superClass_;
				}
			}

			return false;
		}

		/**
		 * postdecrement handles foo++
		 *
		 * @export
		 * @param {Object} obj The object with the getter/setter.
		 * @param {string} prop The name of a property.
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
		 * @export
		 * @param {Object} obj The object with the getter/setter.
		 * @param {string} prop The name of a property.
		 * @return {number}
		 */
		static public function postincrement(obj:Object, prop:String):int
		{
			var value:int = obj[prop];
			obj[prop] = value + 1;
			return value;
		}

		/**
		 * predecrement handles ++foo
		 *
		 * @export
		 * @param {Object} obj The object with the getter/setter.
		 * @param {string} prop The name of a property.
		 * @return {number}
		 */
		static public function predecrement(obj:Object, prop:String):int
		{
			var value:int = obj[prop] - 1;
			obj[prop] = value;
			return value;
		}

		/**
		 * preincrement handles --foo
		 *
		 * @export
		 * @param {Object} obj The object with the getter/setter.
		 * @param {string} prop The name of a property.
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
		 * @export
		 * @param {Object} clazz The class.
		 * @param {Object} pthis The this pointer.
		 * @param {string} prop The name of the getter.
		 * @return {Object}
		 */
		static public function superGetter(clazz:Object, pthis:Object, prop:String):Object
		{
			var superClass:Object = clazz.superClass_;
			var superdesc:Object = Object.getOwnPropertyDescriptor(superClass, prop);

			while (superdesc == null)
			{
				superClass = superClass.constructor.superClass_;
				superdesc = Object.getOwnPropertyDescriptor(superClass, prop);
			}
			return superdesc.get.call(pthis);
		}

		/**
		 * superSetter calls the setter on the given class' superclass.
		 *
		 * @export
		 * @param {Object} clazz The class.
		 * @param {Object} pthis The this pointer.
		 * @param {string} prop The name of the getter.
		 * @param {Object} value The value.
		 */
		static public function superSetter(clazz:Object, pthis:Object, prop:String, value:Object):void
		{
			var superClass:Object = clazz.superClass_;
			var superdesc:Object = Object.getOwnPropertyDescriptor(superClass, prop);

			while (superdesc == null)
			{
				superClass = superClass.constructor.superClass_;
				superdesc = Object.getOwnPropertyDescriptor(superClass, prop);
			}
			superdesc.set.apply(pthis, [value]);
		}

		static public function trace(...rest):void
		{
			var theConsole:*;

			var msg:String = '';

			for (var i:uint = 0; i < rest.length; i++)
			{
				if (i > 0)
					msg += ' ';
				msg += rest[i];
			}

			theConsole = ["goog"]["global"]["console"];

			if (theConsole === undefined && window.console !== undefined)
				theConsole = window.console;

			try
			{
				if (theConsole && theConsole.log)
				{
					theConsole.log(msg);
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
		 * @export
		 * @param {?} value The value to be cast.
		 * @return {number}
		 */
		static public function uint(value:Number):Number
		{
			return value >>> 0;
		}
	}
}
