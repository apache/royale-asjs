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
package org.apache.royale.style.stylebeads
{
	public class FlexContainerStyle extends StyleBeadBase
	{
		public function FlexContainerStyle()
		{
			super();
		}
		
		private var _flex:Boolean = true;
		/**
		 * Added a FlexContainerStyle is implicitly flex.
		 * This is only needed if you need to set flex to false.
		 * For example, if you have a container that is flex by default
		 * and you want to make it not flex,
		 * then you would add a FlexContainerStyle with flex set to false.
		 * 
		 */
		public function get flex():Boolean
		{
			return _flex;
		}
		public function set flex(value:Boolean):void
		{
			_flex = value;
		}

		private var _inline:Boolean;
		public function get inline():Boolean
		{
			return _inline;
		}

		public function set inline(value:Boolean):void
		{
			_inline = value;
		}

		private var _column:Boolean;
		/**
		 * Added a FlexContainerStyle is implicitly row.
		 * Set column to true to make it column.
		 */
		public function get column():Boolean
		{
			return _column;
		}
		public function set column(value:Boolean):void
		{
			_column = value;
		}

		private var _reverse:Boolean;
		public function get reverse():Boolean
		{
			return _reverse;
		}

		public function set reverse(value:Boolean):void
		{
			_reverse = value;
		}

		private var _wrap:*;
		/**
		 * Wrap by default inherits from parent, which is the same as nowrap.
		 * Set wrap to true to make it wrap, false to make it nowrap.
		 */
		public function get wrap():Boolean
		{
			return !!_wrap;
		}

		public function set wrap(value:Boolean):void
		{
			_wrap = value;
		}

		private var _value:String;
		
		private function stringify(sep:String):String
		{
			var wrapStr:String = wrap ? "wrap" : "nowrap";
			var direction:String = column ? "column" : "row";
			if(reverse){
				if(wrap)
					wrapStr += "-reverse";
				else
					direction += "-reverse";
			}
			if(_wrap == undefined)
				return direction;
			
			return direction + sep + wrapStr;
		}
		override public function get selectors():Array
		{
			return [".flex-flow" + stringify("-")];
		}
	
		override public function get rules():Array
		{
			return ["flex-flow:" + stringify(" ") + ";"];
		}

	}
}