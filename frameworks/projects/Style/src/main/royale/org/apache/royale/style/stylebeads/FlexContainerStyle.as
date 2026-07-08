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
	import org.apache.royale.style.stylebeads.layout.Display;
	import org.apache.royale.style.stylebeads.flexgrid.FlexDirection;
	import org.apache.royale.style.stylebeads.flexgrid.FlexWrap;
	/**
	 * A FlexContainerStyle is always flex.
	 */
	public class FlexContainerStyle extends CompositeStyle
	{
		public function FlexContainerStyle()
		{
			super();
			displayStyle = new Display("flex");
			addStyleBead(displayStyle);
		}
		
		private var displayStyle:Display;

		private var _inline:Boolean;
		public function get inline():Boolean
		{
			return !!_inline;
		}

		public function set inline(value:Boolean):void
		{
			_inline = value;
			displayStyle.value = value ? "inline-flex" : "flex";
		}

		private var _column:Boolean;
		/**
		 * Added a FlexContainerStyle is implicitly row.
		 * Set column to true to make it column.
		 */
		public function get column():Boolean
		{
			return !!_column;
		}
		public function set column(value:Boolean):void
		{
			_column = value;
			setDirection();
		}
		private var directionStyle:FlexDirection;
		private function setDirection():void
		{
			var dir:String = _column ? "column" : "row";
			if(reverse)
				dir += "-reverse";
			if(!directionStyle)
			{
				directionStyle = new FlexDirection(dir);
				return addStyleBead(directionStyle);
			}
			directionStyle.value = dir;
		}
		private var _reverse:Boolean;
		public function get reverse():Boolean
		{
			return !!_reverse;
		}

		public function set reverse(value:Boolean):void
		{
			_reverse = value;
			if(directionStyle)
				setDirection();
			if(wrapStyle)
				setWrap();
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
		private var wrapStyle:FlexWrap;
		public function set wrap(value:Boolean):void
		{
			_wrap = value;
			setWrap();
		}
		private function setWrap():void
		{
			var w:String = _wrap ? "wrap" : "nowrap";
			if(_wrap && reverse)
					w += "-reverse";
			if(!wrapStyle)
			{
				wrapStyle = new FlexWrap(w);
				return addStyleBead(wrapStyle);
			}
			wrapStyle.value = w;
		}
	}
}