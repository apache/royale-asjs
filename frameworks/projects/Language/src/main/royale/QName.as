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
	public class QName
	{
		COMPILE::JS
		/**
		 * @private
		 * @royalesuppressexport
		 * @royalesuppresspublicvarwarning
		 * compiler-use-only to support new QName with alternate default namespace
		 */
		public static var defaultNS:String = '';
		
		COMPILE::JS
		/**
         * @private
		 * @royalesuppressexport
		 * compiler use only to support QName == QName
		 * this method can be dead-code eliminated in release build (by default) if never used
		 */
		public static function equality(lhs:QName, rhs:QName):Boolean{
			return lhs === rhs || (lhs && lhs.equals(rhs));
		}
		/**
		 * @private
		 * @royalesuppressexport
	 	 * compiler-use-only to support new QName with alternate default namespace
		 * this method can be dead-code eliminated in release build (by default) if never used
		 */
        public static function createWithDefaultNamespace(uri:*, arg1:*, arg2:*):QName{
			defaultNS = typeof uri == 'string' ? uri : uri.toString();
			var qName:QName = new QName(arg1, arg2);
			//always restore afterwards
			defaultNS = '';
			return qName;
		}
		
		/**
		 * @private
		 * @royalesuppressexport
		 * Intended primarily for reflection and other framework use, without the need to construct
		 * a QName instance
		 */
		public static function getAsObjectAccessFormat(uri:String, localName:String):String{
			var uriVal:String = uri;
			if (uriVal) {
				uriVal = uriVal.replace(/:/g, "_");
				uriVal = uriVal.replace(/\./g, "_");
				uriVal = uriVal.replace(/\//g, "$");
				return uriVal + "__" + localName;
			}
			return localName;
		}
		
		
		/**
		 * @royaleignorecoercion Namespace
		 * @royaleignorecoercion QName
		 */
		COMPILE::JS
		public function QName(qNameOrUri:*=undefined,localNameVal:*=undefined)
		{
			/*
				When the QName constructor is called with a one argument Name or two arguments Namespace and Name the following steps are taken:
				1. If (Type(Name) is Object and Name.[[Class]] == "QName")
				  a. If (Namespace is not specified), return a copy of Name
				  b. Else let Name = Name.localName
				2. If (Name is undefined or not specified)
				  a. Let Name = “”
				3. Else let Name = ToString(Name)
				4. If (Namespace is undefined or not specified)
				  a. If Name = "*"
				    i. Let Namespace = null
				  b. Else
				    i. Let Namespace = GetDefaultNamespace()
				5. Let q be a new QName with q.localName = Name
				6. If Namespace == null
				  a. Let q.uri = null NOTE implementations that preserve prefixes in qualified names may also set q.[[Prefix]] to undefined
				7. Else
				  a. Let Namespace be a new Namespace created as if by calling the constructor new Namespace(Namespace)
				  b. Let q.uri = Namespace.uri NOTE implementations that preserve prefixes in qualified names may also set q.[[Prefix]] to Namespace.prefix
				8. Return q
			*/
			//@todo log and categorise constructor argument types, optimise this code for most common constructor call signatures
			
			//firstClass is either nullish or the (expected string) value of the 'className' field on the qNameOrUri arg 
			const firstClass:* = qNameOrUri && (typeof qNameOrUri == 'object') && qNameOrUri['className'];
			//if firstClass == 'Namespace' then the first arg is a Namespace (avoids Language.is)
			const ns:Namespace = (firstClass == 'Namespace') ? Namespace(qNameOrUri) : null;
			//resolve qname depending on arg types
			const qname:QName = localNameVal && typeof localNameVal == 'object' && localNameVal['className'] == 'QName'
					? QName(localNameVal) : (!ns && firstClass == 'QName')
							? QName(qNameOrUri) : null;
			
			//possibilities:
			//qname, undefined
			//namespace, qname
			//qname1, qname2 <-- handle this one too. Checked in swf.
			//namespace, (undefined, null, string or toString)
			//(undefined, null , String or toString), (undefined, null, String or toString)
			
			if (qname) {
				_localName = qname._localName;
				if (!ns) {
					if (qname != qNameOrUri) {
						//qName is not the first arg, but the first arg is also not a Namespace instance
						//the 'name' was the second argument
						if (firstClass == 'QName') {
							//, but first was also a QName. Covering all variants...
							//in this case, swf treats the first QName arg as the namespace supplier for uri, second for local name.
							_uri = QName(qNameOrUri)._uri;
						} else {
							//we have a toString, null or undefined value for first arg.
							if (qNameOrUri === undefined) {
								//get uri from qname
								//we use the uri from our name - not part of spec, but observed behavior in swf
								_uri = qname._uri;
							} else {
								if (qNameOrUri !== null) {
									_uri = qNameOrUri.toString();
								} else {
									_uri = null;
								}
							}
						}
					} else _uri = qname._uri;
				} else {
					//both ns and qname args
					_uri = ns.uri;
				}
			} else {
				if (ns) {
					//namespace first arg, followed by non-QName localNameVal arg
					if (localNameVal == undefined) //step 2.
							_localName = localNameVal === undefined ? '' : 'null';
					else _localName = localNameVal.toString(); //step 3
					_uri = ns.uri;
				} else {
					//deal with string/toString variations
					if (localNameVal !== undefined) {
						_localName = localNameVal === null ? 'null' : localNameVal.toString();
						if (qNameOrUri !== undefined) {
							//'ns' is defined in some way, and can be explicitly null
							if (qNameOrUri !== null)  _uri = qNameOrUri.toString();
							//this can leave _uri in an internal undefined state, which covers one variation in matches
						} else {
							//ns is undefined. conform to step 4.
							if (_localName == '*') _uri = null;
							else _uri = defaultNS; // GetDefaultNamespace()
						}
					} else {
						if (qNameOrUri !== undefined) {
							//we only have one arg
							//this is the local name and ns is undefined
							_localName = qNameOrUri === null ? 'null' : qNameOrUri.toString();
							//ns is undefined. conform to step 4.
							if (_localName == '*') _uri = null;
							else _uri = defaultNS; // GetDefaultNamespace()
							
						} else {
							//both args are undefined
							_localName = '';
							_uri = defaultNS; // GetDefaultNamespace()
						}
					}
				}
			}
			
		}

		private var _uri:*;
		/**
		 * @royaleignorecoercion String
		 * @royalenoimplicitstringconversion
		 */
		public function get uri():String
		{
			//support 'undefined' internal state
			return _uri == null ? null : _uri as String;
		}

		
		private var _localName:String;
		public function get localName():String
		{
			return _localName;
		}


		private var _prefix:String;
		public function get prefix():String
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
		 * Non-spec. Used for internal performance reasons only (faster than Language.is checks)
		 * @private
		 * @royalesuppressexport
		 */
		public function get  className():String{
			return 'QName';
		}

		COMPILE::JS
		public function objectAccessFormat():String
		{
			/*var uriVal:String = _uri ? _uri : "*";
            uriVal = uriVal.replace(/:/g, "_");
            uriVal = uriVal.replace(/\./g, "_");
            uriVal = uriVal.replace(/\//g, "$");
			return uriVal + "__" + _localName;*/
			return getAsObjectAccessFormat(_uri, _localName);
		}

		COMPILE::JS
		public function equals(name:QName):Boolean
		{
			return name != null && (name === this || (this.uri == name.uri && this.localName == name.localName)); // this.prefix == name.prefix &&
		}
		
		COMPILE::JS
		public function matches(qname:QName):Boolean
		{
			if (qname && (isAttribute != qname.isAttribute)) return false;
			
			const anyName:Boolean = _localName == '*';
	
			if (anyName && (_uri === null || (qname && _uri === undefined))) return true; //variation
			
			if (!qname) return false; //different order to AVM code - hoisted by one
		
			if (!anyName && qname && (_localName != qname._localName)) return false;
		
			if (_uri == null) return true; //anyNamespace
		
			return _uri === qname._uri && _localName === qname._localName;
			
		}
		
		private var _isAttribute:Boolean = false;
		/**
		 * @royalesuppressexport
		 * This property is intended for internal use only in XML classes.
		 */
		public function get isAttribute():Boolean
		{
			return _isAttribute;
		}
		/**
		 * @private
		 * @royalesuppressexport
		 * intended for internal use only
		 */
		public function setIsAttribute(value:Boolean):void
		{
			_isAttribute = value;
		}
		/*public function set isAttribute(value:Boolean):void
		{
			_isAttribute = value;
		}*/

		COMPILE::JS
		public function getNamespace(namespaces:Array=null):Namespace
		{
			/*
				When the [[GetNamespace]] method of a QName q is called with no arguments or one argument InScopeNamespaces, the following steps are taken:
				1. If q.uri is null, throw a TypeError exception NOTE the exception above should never occur due to the way [[GetNamespace]] is called in this specification
				2. If InScopeNamespaces was not specified, let InScopeNamespaces = { }
				3. Find a Namespace ns in InScopeNamespaces, such that ns.uri == q.uri. If more than one such Namespace ns exists, the implementation may choose one of the matching Namespaces arbitrarily. NOTE implementations that preserve prefixes in qualified names may additionally constrain ns, such that ns.prefix == q.[[Prefix]]
				4. If no such namespace ns exists
				a. Let ns be a new namespace created as if by calling the constructor new Namespace(q.uri) NOTE implementations that preserve prefixes and qualified names may create the new namespaces as if by calling the constructor Namespace(q.[[Prefix]], q.uri)
				5. Return ns
			*/
			var i:int;
			var possibleMatch:Namespace;
			if(!namespaces)
				namespaces = [];
			for(i=0;i<namespaces.length;i++)
			{
				if(namespaces[i].uri == _uri)
				{
					if (!possibleMatch) //retain first possible match
						possibleMatch = namespaces[i];
					if(_prefix == null /*|| namespaces[i].prefix == _prefix*/)
						return namespaces[i];
				}
			}
			if(possibleMatch)
				return possibleMatch;
			if(!_prefix)
				return new Namespace(_uri);
			return new Namespace(_prefix,_uri);
		}

		COMPILE::JS
		public function toString():String
		{
			/*
			 	1. If Type(n) is not Object or n.[[Class]] is not equal to "QName", throw a TypeError exception
				2. Let s be the empty string
				3. If n.uri is not the empty string
					a. If n.uri == null, let s be the string "*::"
					b. Else let s be the result of concatenating n.uri and the string "::"
				4. Let s be the result of concatenating s and n.localName
				5. Return s
			 */
			// This should cover "*" as well
			if(_uri !== '') {
				//for '*' with null uri, it should return '*::*' as per 3.a and 4 above
				return (_uri ? _uri : '*') + "::" + _localName;
			}
			
			return _localName;
		}

	}
}
