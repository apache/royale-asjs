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
	import org.apache.royale.style.util.ThemeManager;
	import org.apache.royale.style.util.CSSUnit;

	abstract public class SpacingBase extends StyleBeadBase
	{
		public function SpacingBase()
		{
			super();

		}

		private var _unit:String;

		public function get unit():String
		{
			return _unit || CSSUnit.PX;
		}

		public function set unit(value:String):void
		{
			_unit = value;
		}

		private var _spacing:Number;

		[[Inspectable(category="General", defaultValue="0")]]
		public function get spacing():Number
		{
			return isNaN(_spacing) ? ThemeManager.instance.activeTheme.spacing : _spacing;
		}

		public function set spacing(value:Number):void
		{
			_spacing = value;
		}

		private var _leftValue:Number;
		public function get leftValue():Number
		{
			return _leftValue;
		}
		public function set leftValue(value:Number):void
		{
			_leftValue = value;
		}
		
		private var _rightValue:Number;
		public function get rightValue():Number
		{
			return _rightValue;
		}
		public function set rightValue(value:Number):void
		{
			_rightValue = value;
		}
		
		private var _topValue:Number;
		public function get topValue():Number
		{
			return _topValue;
		}
		public function set topValue(value:Number):void
		{
			_topValue = value;
		}

		private var _bottomValue:Number;
		public function get bottomValue():Number
		{
			return _bottomValue;
		}
		public function set bottomValue(value:Number):void
		{
			_bottomValue = value;
		}

		private var _leftStep:Number;
		public function get leftStep():Number
		{
			return _leftStep;
		}
		public function set leftStep(value:Number):void
		{
			_leftStep = value;
		}

		private var _rightStep:Number;
		public function get rightStep():Number
		{
			return _rightStep;
		}
		public function set rightStep(value:Number):void
		{
			_rightStep = value;
		}
		
		private var _topStep:Number;
		public function get topStep():Number
		{
			return _topStep;
		}
		public function set topStep(value:Number):void
		{
			_topStep = value;
		}
		private var _bottomStep:Number;

		public function get bottomStep():Number
		{
			return _bottomStep;
		}

		public function set bottomStep(value:Number):void
		{
			_bottomStep = value;
		}

		private var _left:String;

		public function get left():String
		{
			return _left;
		}

		public function set left(value:String):void
		{
			_left = value;
		}
		private var _right:String;

		public function get right():String
		{
			return _right;
		}

		public function set right(value:String):void
		{
			_right = value;
		}
		private var _top:String;

		public function get top():String
		{
			return _top;
		}

		public function set top(value:String):void
		{
			_top = value;
		}
		private var _bottom:String;

		public function get bottom():String
		{
			return _bottom;
		}

		public function set bottom(value:String):void
		{
			_bottom = value;
		}

		public var auto:Boolean;

		private function computeVal(str:String, value:Number, step:Number):String
		{
			if (str)
				return str;
			if (!isNaN(value))
				return value + unit;
			
			if (!isNaN(step))
			{
				var s:Number = unit == CSSUnit.REM ? spacing / 16 : spacing;
				return (step * s) + unit;
			}
			return "";
		}

		protected function stringify():Array
		{
			if(auto)
				return ["auto"];
			
			var left:String = computeVal(_left, _leftValue, _leftStep);
			var right:String = computeVal(_right, _rightValue, _rightStep);
			var top:String = computeVal(_top, _topValue, _topStep);
			var bottom:String = computeVal(_bottom, _bottomValue, _bottomStep);
			if(left == right && right == top && top == bottom)
				return [left];
			
			return [top, right, bottom, left];
		}

	}
}