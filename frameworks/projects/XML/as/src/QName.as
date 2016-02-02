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
COMPILE::JS
{
package
{
	public class QName
	{
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
			if(qNameOrUri is QName)
			{
				_uri = qNameOrUri.uri;
				_localName = qNameOrUri.localName;
			}
			else if(qNameOrUri is Namespace)
			{
				_uri = (qNameOrUri as Namespace).uri;
				_prefix = (qNameOrUri as Namespace).prefix;
				if(localNameVal)
					_localName = localNameVal.toString();
			}
			else if (qNameOrUri.toString())
			{
				_uri = qNameOrUri;
				if(localName)
					_localName = localName;
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

		public function toString():String
		{
			return _localName;
		}

		public function equals(name:QName):Boolean
		{
			return this.uri == name.uri && this.prefix == name.prefix && this.localName == name.localName;
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

	}
}
}

