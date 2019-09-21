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
package org.apache.royale.net
{
	
	import org.apache.royale.net.utils.encodeAsQueryString;
	import org.apache.royale.net.utils.decodeQueryString;
	

	COMPILE::JS
	public dynamic class URLVariables
	{
		public function URLVariables(source:String = null)
		{
			if (source) decode(source);
		}
		
		public function decode(source:String):void
		{
			if (source) {
				if (!decodeQueryString(source, this)) {
					throw new Error('Error #2101: The String passed to URLVariables.decode() must be a URL-encoded query string containing name/value pairs.')
				}
			}
		}
		
		public function toString():String
		{
			return encodeAsQueryString(this);
		}
	}
	
	COMPILE::SWF {
		import flash.net.URLVariables;

		public dynamic class URLVariables extends flash.net.URLVariables
		{
			public function URLVariables(source:String = null)
			{
				super(source);
			}
			/*
			public function decode(source:String):void
			{
				//if (source) decodeQueryString(source, this);
			}
			
			public function toString():String
			{
				return null;//encodeAsQueryString(this);
			}*/
		}
	}
}

