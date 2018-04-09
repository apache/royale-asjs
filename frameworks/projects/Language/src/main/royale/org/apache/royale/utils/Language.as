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
package org.apache.royale.utils
{

	[ExcludeClass]
	COMPILE::SWF
	public class Language {}

    COMPILE::JS
    {
        import goog.bind;
        import goog.global;
    }
    
    /**
     * @royaleignoreimport goog.bind
     * @royaleignoreimport goog.global
     */
    COMPILE::JS
	public class Language
	{

		//--------------------------------------
		//   Static Property
		//--------------------------------------

		
		/**
		 * Helper var for sortOn
		 */
		static private var sortNames:Array;
		static private var sortNamesOne:Array = [];
		static private var muler:Number;
		static private var zeroStr:String = String.fromCharCode(0);
		
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
		 * string()
		 *
		 * @param value The value to be cast.
		 * @return {string}
		 */
		static public function string(value:*):String
		{
			return value == null ? null : value.toString();
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
            // A little faster to only call typeof once
			var theType:String = typeof leftOperand;
			//TODO This is actually incorrect for 'constructed' strings
			// The correct way is using Object.prototype.toString.call(leftOperand) == '[object String]'
			// But this is about 50 times slower than typeof
			// "is String" should probably be pulled out into a separate function
			// which is called directly by the compiler to deal with it in the most performant manner.
			// Another (possibly better) option would be to have the compiler throw an error
			// if new is used with String, Number or Boolean. If 'new' is not allowed, the typeof check is enough.
			if (theType === 'string')
				return rightOperand === String;

			if (theType === 'number')
				return rightOperand === Number;

            if (theType === 'boolean')
                return rightOperand === Boolean;
			//TODO add optimization to compiler to convert 'is Array' directly to Array.isArray
            if (rightOperand === Array)
                return Array.isArray(leftOperand);

			if (leftOperand.ROYALE_CLASS_INFO === undefined)
				return false; // could be a function but not an instance

			if (leftOperand.ROYALE_CLASS_INFO.interfaces)
			{
				if (checkInterfaces(leftOperand, rightOperand))
				{
					return true;
				}
			}

			superClass = leftOperand.constructor.superClass_;

			if (superClass)
			{
				while (superClass && superClass.ROYALE_CLASS_INFO)
				{
					if (superClass.ROYALE_CLASS_INFO.interfaces)
					{
						if (checkInterfaces(superClass, rightOperand))
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
         * Helper function for is()
         */
        private static function checkInterfaces(leftOperand:*, rightOperand:*):Boolean
        {
            var i:int, interfaces:Array;
            
            interfaces = leftOperand.ROYALE_CLASS_INFO.interfaces;
            for (i = interfaces.length - 1; i > -1; i--) {
                if (interfaces[i] === rightOperand) {
                    return true;
                }
                
                if (interfaces[i].prototype.ROYALE_CLASS_INFO.interfaces) {
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
        
		static public function trace(...rest):void
		{
			var theConsole:*;

			if (!goog.DEBUG) return;
			
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

		/**
		 * @param	arr
		 * @param	names
		 * @param	opt
		 */
		public static function sortOn(arr:Array,names:Object,opt:Object=0):void{
			if (names is Array){
				sortNames = names as Array;
			}else{
				sortNamesOne[0] = names;
				sortNames = sortNamesOne;
			}
			if (opt is Array){
				var opt2:int = 0;
				for each(var o:int in opt){
					opt2 = opt2 | o;
				}
			}else{
				opt2 = opt as int;
			}
			muler = (Array.DESCENDING & opt2) > 0?-1: 1;
			if(opt2&Array.NUMERIC){
				arr.sort(compareNumber);
			}else if (opt2&Array.CASEINSENSITIVE){
				arr.sort(compareStringCaseinsensitive);
			}else{
				arr.sort(compareString);
			}
		}
		
		private static function compareStringCaseinsensitive(a:Object, b:Object):int{
			for each(var n:String in sortNames){
				var v:int = (a[n]||zeroStr).toString().toLowerCase().localeCompare((b[n]||zeroStr).toString().toLowerCase());
				if (v != 0){
					return v*muler;
				}
			}
			return 0;
		}
		private static function compareString(a:Object, b:Object):int{
			for each(var n:String in sortNames){
				var v:int = (a[n]||zeroStr).toString().localeCompare((b[n]||zeroStr).toString());
				if (v != 0){
					return v*muler;
				}
			}
			return 0;
		}
		
		private static function compareNumber(a:Object, b:Object):int{
			for each(var n:String in sortNames){
				if (a[n]>b[n]){
					return muler;
				}else if (a[n]<b[n]){
					return -muler;
				}
			}
			return 0;
		}
		
		public static function Vector(size:int = 0, basetype:String = null):Array{
			var arr:Array = [];
			var defValue:Object = null;
			if (basetype == "int" || basetype == "uint" || basetype == "Number")
			{
				defValue = 0;
			}
			else if (basetype == "String")
			{
				defValue = "";
			}
			for (var i:int = 0; i < size; i++)
				arr.push(defValue);
			return arr;
		}
	}
}
