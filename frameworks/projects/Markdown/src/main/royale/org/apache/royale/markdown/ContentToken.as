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
package org.apache.royale.markdown
{
	/**
	 * ContentToken represent plain text. It is usually used for the content of inline
	 * structures. Most of them will be generated automatically by the inline
	 * parser. They are also sometimes generated explicitly by the
	 * inline parsing rules.
	 * 
	 * A text token has a `content` property containing the text it represents.
	 *  @langversion 3.0
	 *  @productversion Royale 0.9.9
	 */
	public class ContentToken extends Token
	{
		public function ContentToken(type:String,content:String,level:int=0)
		{
			super(type);
			_content = content;
			this.level = level;
		}

		private var _content:String = "";
		/**
		 * The raw text content
		 *  @langversion 3.0
		 *  @productversion Royale 0.9.9
		 */
		public function get content():String
		{
			return _content;
		}

		public function set content(value:String):void
		{
			_content = value;
		}

	}
}