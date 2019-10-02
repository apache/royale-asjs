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
package
{
	import isXMLName;
	
	COMPILE::JS
	public class Namespace
	{
		//force dependency
		private static const xmlNameCheck:Function = isXMLName;
		
		COMPILE::JS
		{
			import org.apache.royale.utils.Language;
		}
		
		COMPILE::JS
		/**
		 * @royaleignorecoercion Namespace
		 * @royaleignorecoercion String
		 * @royalenoimplicitstringconversion
		 */
    	public function Namespace(prefixValue:*=undefined,uriValue:*=undefined)
		{
			/*
				When the Namespace constructor is called with a no arguments, one argument uriValue or two arguments prefixValue and uriValue, the following steps are taken:
				1. Create a new Namespace object n
				2. If prefixValue is not specified and uriValue is not specified
				  a. Let n.prefix be the empty string
				  b. Let n.uri be the empty string
				3. Else if prefixValue is not specified
				  a. If Type(uriValue) is Object and uriValue.[[Class]] == "Namespace"
				    i. Let n.prefix = uriValue.prefix
				    ii. Let n.uri = uriValue.uri
				  b. Else if Type(uriValue) is Object and uriValue.[[Class]] == "QName" and uriValue.uri is not null
				    i. Let n.uri = uriValue.uri NOTE implementations that preserve prefixes in qualified names may also set n.prefix = uriValue.[[Prefix]]
				  c. Else
				    i. Let n.uri = ToString(uriValue)
				    ii. If (n.uri is the empty string), let n.prefix be the empty string
				    iii. Else n.prefix = undefined
				4. Else
				  a. If Type(uriValue) is Object and uriValue.[[Class]] == "QName" and uriValue.uri is not null
				    i. Let n.uri = uriValue.uri
				  b. Else
				    i. Let n.uri = ToString(uriValue)
				  c. If n.uri is the empty string
				    i. If prefixValue is undefined or ToString(prefixValue) is the empty string
				      1. Let n.prefix be the empty string
				    ii. Else throw a TypeError exception
				  d. Else if prefixValue is undefined, let n.prefix = undefined
				  e. Else if isXMLName(prefixValue) == false
				  	i. Let n.prefix = undefined
				  f. Else let n.prefix = ToString(prefixValue)
				5. Return n
			*/
			
			
			var isObj:Boolean;
			var argCount:uint = arguments.length;
			if (argCount)
			{
				if (argCount == 1)
				{
					//steps 3...
					uriValue = prefixValue; // <- normalise naming to match spec description
					isObj = uriValue && typeof uriValue == 'object';
					if (!isObj)
					{ //faster branch for string only arg (common)
						//3.c.i - 3.c.iii
						_uri = uriValue + ''; //3.c.i
						_prefix = _uri == '' ? '' : undefined;//3.c.ii, 3.c.iii
					} else
					{
						if (uriValue['className'] == 'Namespace')
						{
							_prefix = uriValue.prefix;
							_uri = uriValue.uri;
						} else if (uriValue['className'] == 'QName' && uriValue.uri != null)
						{
							_uri = uriValue.uri;
							trace('check');
						} else
						{
							//3.c.i - 3.c.iii
							_uri = uriValue.toString(); //3.c.i
							_prefix = _uri == '' ? '' : undefined;//3.c.ii, 3.c.iii
						}
					}
					
				} else
				{
					//steps from 4.0
					isObj = uriValue && typeof uriValue == 'object';
					if (isObj)
					{
						if (uriValue['className'] == 'QName'  && uriValue.uri != null)
						{
							_uri = uriValue.uri; //4.a
						} else _uri = uriValue.toString();//4.b for non-primitives
					} else
					{
						_uri = uriValue + ''; //4.b for primitives
					}
					if (_uri == '') { //4.c
						if (prefixValue === undefined || (prefixValue + '' == ''))
						{
							//4.c.i.1
							_prefix = '';
						} else {
							//4.c.ii
							throw new TypeError('Error #1098: Illegal prefix undefined for no namespace.');
						}
					} else if (prefixValue !== undefined)
					{
						var prfx:String = '' + prefixValue;
						if (prfx == '') _prefix = '';
						else if (isXMLName(prfx)) {
							//4.f
							_prefix = prfx
						} //else 4.e _prefix is undefined by default
					} //else  //4.d _prefix is undefined by default
				}
			} else {
				//Step 2: two undefined args
				_uri = '';
				_prefix = '';
			}
			
		}

		/*// Using this instead of simply using "is QName" because "is QName" causes a circular dependency.
		private function isQName(val:Object):Boolean
		{
			return val && typeof val == 'object' && val['className'] == 'QName';
			/!*if(val==null)
				return false;
			if(val.hasOwnProperty("uri") && val.hasOwnProperty("localName") && val.hasOwnProperty("prefix"))
				return true;
			return false;*!/
		}*/

		private var _uri:String = "";
		public function get uri():String
		{
			return _uri;
		}
		
		private var _prefix:* ;
		public function get prefix():*
		{
			return _prefix;
		}
		
		/**
		 * @private
		 * @royalesuppressexport
		 * intended for internal use only
		 */
		public function setPrefix(value:String):void
		{
			_prefix = value;
		}
		
		COMPILE::JS
		/**
		 * Non-spec (specifically: non swf spec, is however consistent with ECMA-357).
		 * Used for internal performance reasons only (faster than Language.is checks)
		 * @private
		 * @royalesuppressexport
		 */
		public function get className():String{
			return 'Namespace';
		}

		COMPILE::JS
		public function toString():String
		{
			return uri;
		}

		COMPILE::JS
		override public function valueOf():*
		{
			return this;
		}
        
        COMPILE::JS
        private static var forceLanguageDependency:Class = Language;
	}
}


