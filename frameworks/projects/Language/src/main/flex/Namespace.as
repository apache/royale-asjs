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
	public class Namespace
	{
		COMPILE::JS
		{
			import org.apache.flex.utils.Language;
		}
		COMPILE::JS
    	public function Namespace(prefixOrUri:Object=null,uriValue:Object=null)
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
			if(!uriValue && prefixOrUri) //we don't have a prefix defined
			{
				var uriVal:Object = uriValue ? uriValue : prefixOrUri;
				if(uriVal is Namespace)
				{
					_prefix = (uriVal as Namespace).prefix;
					_uri = (uriVal as Namespace).uri;
				}
				else if(isQName(uriVal ))
				{
					_uri = uriVal.uri ? uriVal.uri : _uri;
				}
				else {
					_uri = uriVal.toString();
					if(_uri == "")
						_prefix = "";
				}
			}
			else if(uriValue)
			{
				// something is specified as the URI otherwise fall through and leave both the prefix and uri blank
				if(isQName(uriValue ))
				{
					if(uriValue.uri)
						_uri = uriValue.uri;
				}
				else {
					_uri = uriValue.toString();
				}

				if(!_uri)
				{
					if(!prefixOrUri)
						_prefix = "";
					else
						throw new TypeError("invalid prefix");
				}
				else
					_prefix = prefixOrUri.toString();

			}
		}

		// Using this instead of simply using "is QName" because "is QName" causes a circular dependency.
		private function isQName(val:Object):Boolean
		{
			if(val==null)
				return false;
			if(val.hasOwnProperty("uri") && val.hasOwnProperty("localName") && val.hasOwnProperty("prefix"))
				return true;
			return false;
		}

		private var _uri:String = "";
		public function get uri():String
		{
			return _uri;
		}
		public function set uri(value:String):void
		{
			_uri = value;
		}
		
		private var _prefix:String = null;
		public function get prefix():String
		{
			return _prefix;
		}
		public function set prefix(value:String):void
		{
			_prefix = value;
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
	}
}


