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
	import org.apache.royale.style.stylebeads.flexgrid.FlexGrow;
	import org.apache.royale.style.stylebeads.flexgrid.FlexShrink;
	import org.apache.royale.style.stylebeads.flexgrid.FlexBasis;
	import org.apache.royale.style.stylebeads.flexgrid.Order;

	public class FlexItemStyle extends CompositeStyle
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
			growFactor = value ? 1 : 0;
		}

		private var _growFactor:Number;
		public function get growFactor():Number
		{
			return _growFactor;
		}
		public function set growFactor(value:Number):void
		{
			_growFactor = value;
			if(!growStyle)
			{
				growStyle = new FlexGrow(value);
				return addStyleBead(growStyle);
			}
			growStyle.value = value;
		}
		private var growStyle:FlexGrow;


		private var _shrink:Boolean;

		public function get shrink():Boolean
		{
			return _shrinkFactor > 0;
		}

		public function set shrink(value:Boolean):void
		{
			shrinkFactor = value ? 1 : 0;
		}

		private var _shrinkFactor:Number;

		public function get shrinkFactor():Number
		{
			return _shrinkFactor;
		}

		public function set shrinkFactor(value:Number):void
		{
			_shrinkFactor = value;
			if(!shrinkStyle)
			{
				shrinkStyle = new FlexShrink(value);
				return addStyleBead(shrinkStyle);
			}
			shrinkStyle.value = value;
		}
		private var shrinkStyle:FlexShrink;
		private var _basis:String = "auto";

		public function get basis():String
		{
			return _basis;
		}

		public function set basis(value:String):void
		{
			_basis = value;
			if(!basisStyle)
			{
				basisStyle = new FlexBasis(value);
				return addStyleBead(basisStyle);
			}
			basisStyle.value = value;
		}
		private var basisStyle:FlexBasis;

		private var _order:Number;
		[Inspectable(category="General", defaultValue="NaN", minValue="-9999", maxValue="9999")]
		public function get order():Number
		{
			return _order;
		}

		public function set order(value:Number):void
		{
			_order = value;
			if(!orderStyle)
			{
				orderStyle = new Order(value);
				return addStyleBead(orderStyle);
			}
			orderStyle.value = value;
		}
		private var orderStyle:Order;
	}	
}