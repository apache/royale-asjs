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
	public class JXONNamespace
	{
		
		/**
		 * Constructor
		 * 
		 * @param prefix
		 * @param uri
		 * 
		 *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.5.0
		 * 
		 */
		public function JXONNamespace(prefix:String,uri:String)
		{
			_prefix = prefix;
			_uri = uri;
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
		
		private var _uri:String;

		public function get uri():String
		{
			return _uri;
		}

		public function set uri(value:String):void
		{
			_uri = value;
		}

	}
}