////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//	  http://www.apache.org/licenses/LICENSE-2.0
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
    import org.apache.royale.net.URLBinaryLoader;

	/**
	 *  Provides binary data loading functionality with CORS credentials support
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.12
	 *
	 *  @royalesuppresspublicvarwarning
	 */
	public class URLBinaryLoaderWithCorsCredentials extends URLBinaryLoader 
	{
		/**
		 * constructor
		 */
		public function URLBinaryLoaderWithCorsCredentials()
		{
			super();
		}
		
		override protected function createStream():void
		{
			this.stream = new URLStreamWithCorsCredentials();
		}
	}
}