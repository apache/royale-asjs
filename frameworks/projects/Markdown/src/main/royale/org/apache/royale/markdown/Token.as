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
	public abstract class Token implements IToken
	{
		public function Token(type:String)
		{
			this.type = type;
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

		private var _data:String;

		public function get data():String
		{
			return _data;
		}

		public function set data(value:String):void
		{
			_data = value;
		}

		private var _title:String;

		public function get title():String
		{
			return _title;
		}

		public function set title(value:String):void
		{
			_title = value;
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

		private var _tight:Boolean = false;
		
		public function get tight():Boolean
		{
			return _tight;
		}

		public function set tight(value:Boolean):void
		{
			_tight = value;
		}

		private var _id:int;

		public function get id():int
		{
			return _id;
		}

		public function set id(value:int):void
		{
			_id = value;
		}

		private var _subId:int;

		public function get subId():int
		{
			return _subId;
		}

		public function set subId(value:int):void
		{
			_subId = value;
		}
		private var _numValue:Number;

		public function get numValue():Number
		{
			return _numValue;
		}

		public function set numValue(value:Number):void
		{
			_numValue = value;
		}
	}
}