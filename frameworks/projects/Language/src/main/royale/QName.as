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
		/**
		 * @royaleignorecoercion Namespace
		 */
		COMPILE::JS
		public function QName(qNameOrUri:*=null,localNameVal:*=null)
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
			if(qNameOrUri != null)
			{
				if(qNameOrUri is QName)
				{
					_uri = qNameOrUri.uri;
					_localName = qNameOrUri.localName;
					_prefix = qNameOrUri.prefix;
				}
				else if(qNameOrUri is Namespace)
				{
					_uri = (qNameOrUri as Namespace).uri;
					_prefix = (qNameOrUri as Namespace).prefix;
					if(localNameVal)
						_localName = localNameVal.toString();
				}
				else if(localNameVal)
				{
					_localName = localNameVal;
					_uri = qNameOrUri;
				}
				else if (qNameOrUri && qNameOrUri.toString())
				{
					_localName = qNameOrUri.toString();
				}
			}
		}

		private var _uri:String;
		public function get uri():String
		{
			return _uri;
		}
		public function set uri(value:String):void
		{
			_uri = value;
		}
		
		private var _localName:String;
		public function get localName():String
		{
			return _localName;
		}
		public function set localName(value:String):void
		{
			_localName = value;
		}

		private var _prefix:String;
		public function get prefix():String
		{
			return _prefix;
		}
		public function set prefix(value:String):void
		{
			_prefix = value;
		}

		COMPILE::JS
		public function objectAccessFormat():String
		{
			var uriVal:String = _uri ? _uri : "*";
            uriVal = uriVal.replace(/:/g, "_");
            uriVal = uriVal.replace(/\./g, "_");
            uriVal = uriVal.replace(/\//g, "$");
			return uriVal + "__" + _localName;
		}

		COMPILE::JS
		public function equals(name:QName):Boolean
		{
			return name != null && this.uri == name.uri && this.localName == name.localName; // this.prefix == name.prefix &&
		}
		
    COMPILE::JS
		public function matches(name:QName):Boolean
		{
			if (name == null) return this.localName == "*";
			if(this.uri == "*" || name.uri == "*")
				return this.localName == "*" || name.localName == "*" || this.localName == name.localName;

			if(this.localName == "*" || name.localName == "*")
				return this.uri == name.uri;

			return this.uri == name.uri && this.localName == name.localName;
		}
		private var _isAttribute:Boolean;
		public function get isAttribute():Boolean
		{
			return _isAttribute;
		}
		public function set isAttribute(value:Boolean):void
		{
			_isAttribute = value;
		}

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
					possibleMatch = namespaces[i];
					if(namespaces[i].prefix == _prefix)
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
			// This should cover "*" as well
			if(_uri)
				return _uri + "::" + _localName;

			return _localName;
		}

	}
}
