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

	public class BlockToken implements IToken
	{
		public function BlockToken()
		{
			lineData = [-1,-1];
		}
		private var lineData:Array;

		public function get firstLine():int
		{
			return lineData[0] as int;
		}

		public function set firstLine(value:int):void
		{
			lineData[0] = value;
		}

		public function get lastLine():int
		{
			return lineData[1];
		}

		public function set lastLine(value:int):void
		{
			lineData[1] = value;
		}

		public var children:Array;

		private var _content:String;
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
		private var _type:String = "";
		/**
		 *  The token type
		 *  @langversion 3.0
		 *  @productversion Royale 0.9.9
		 */
		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}

		private var _level:int = 0;
		/**
		 *  The level of nesting of the token
		 *  @langversion 3.0
		 *  @productversion Royale 0.9.9
		 */
		public function get level():int
		{
			return _level;
		}

		public function set level(value:int):void
		{
			_level = value;
		}
	}
}