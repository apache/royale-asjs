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
package org.apache.flex.core.xml
{
	public class JXONAttribute implements IJXON
	{
		public function JXONAttribute(name:String="",value:String="")
		{
			_name = name;
			_value = value;
		}
		
		private var _name:String;

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}
		
		private var _value:String;

		public function get value():String
		{
			return _value;
		}

		public function set value(value:String):void
		{
			_value = value;
		}


		public function isText():Boolean
		{
			return false;
		}
		
		public function toString():String
		{
			return null;
		}
		
		public function children():JXONList
		{
			return null;
		}
		
		public function attributes():JXONList
		{
			return null;
		}
		
		public function get nodeKind():String
		{
			return "attribute";
		}
	}
}