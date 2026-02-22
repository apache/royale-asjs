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
	public class FlexItemStyle extends StyleBeadBase
	{
		public static const ORDER_FIRST:Number = -9999;
		public static const ORDER_LAST:Number = 9999;
		public function FlexItemStyle()
		{
			super();
		}

		public function get grow():Boolean
		{
			return _growFactor > 0;
		}

		public function set grow(value:Boolean):void
		{
			_growFactor = value ? 1 : 0;
		}

		private var _growFactor:Number;
		public function get growFactor():Number
		{
			return _growFactor;
		}
		public function set growFactor(value:Number):void
		{
			_growFactor = value;
		}


		private var _shrink:Boolean;

		public function get shrink():Boolean
		{
			return _shrinkFactor > 0;
		}

		public function set shrink(value:Boolean):void
		{
			_shrinkFactor = value ? 1 : 0;
		}

		private var _shrinkFactor:Number;

		public function get shrinkFactor():Number
		{
			return _shrinkFactor;
		}

		public function set shrinkFactor(value:Number):void
		{
			_shrinkFactor = value;
		}
		private var _basis:String = "auto";

		public function get basis():String
		{
			return _basis;
		}

		public function set basis(value:String):void
		{
			_basis = value;
		}

		private var _order:Number;
		[Inspectable(category="General", defaultValue="NaN", minValue="-9999", maxValue="9999")]
		public function get order():Number
		{
			return _order;
		}

		public function set order(value:Number):void
		{
			_order = value;
		}
		
		private function computeShrink():String
		{
			if (isNaN(_shrinkFactor))
				return "1";
			return "" + _shrinkFactor;
		}

		private function computeGrow():String
		{
			if (isNaN(_growFactor))
				return "1";
			return "" + _growFactor;
		}
		private function computeBasis():String
		{
			return basis || "auto";
		}

		private function stringify(sep:String):String
		{
			var grow:String = computeGrow();
			var shrink:String = computeShrink();
			var basis:String = computeBasis();
			if(grow == "0" && shrink == "0")
				return "none";
			return grow + sep + shrink + sep + basis;
		}

		override public function get selectors():Array
		{
			var retVal:Array = [
				".flex-" + stringify("-")
			];
			if(!isNaN(order))
				retVal.push(".order-" + order);
			return retVal;
		}
	
		override public function get rules():Array
		{
			var retVal:Array = ["flex:" + stringify(" ") + ";"];
			if(!isNaN(order))
				retVal.push("order:" + order + ";");
			return retVal;
		}
	}	
}