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
package org.apache.royale.style.stylebeads.typography
{
	import org.apache.royale.style.stylebeads.StyleBeadBase;
	import org.apache.royale.style.stylebeads.LeafStyleBase;
	import org.apache.royale.debugging.assert;

	public class LineClamp extends LeafStyleBase
	{
		public function LineClamp(value:* = null)
		{
			super("line-clamp", "", value);
		}
		override public function get styleType():String
		{
			return selectorBase;
		}
		override public function set value(value:*):void
		{
			_value = value;
			var overflow:String = "overflow: ";
			var hidden:String = "hidden;";
			var visible:String = "visible;";
			var display:String = "display: ";
			var webkitBox:String = "-webkit-box;";
			var block:String = "block;";
			var orient:String = "-webkit-box-orient: ";
			var vertical:String = "vertical;";
			var horizontal:String = "horizontal;";
			var clampPre:String = "-webkit-line-clamp: ";
			if(isNum(value) || isVar(value))
			{
				assert(isInt(value), "Line clamp value must be an integer.");
				calculatedRuleValue = overflow + hidden + display + webkitBox + orient + vertical + clampPre + value + ";";
			}
			else if(value == "none")
			{
				calculatedRuleValue = overflow + visible + display + block + orient + horizontal + clampPre + "unset;";
			}
			else
			{
				calculatedRuleValue = overflow + hidden + display + webkitBox + orient + vertical + clampPre + value + ";";
			}
			calculatedSelector = value;
		}
	}
}