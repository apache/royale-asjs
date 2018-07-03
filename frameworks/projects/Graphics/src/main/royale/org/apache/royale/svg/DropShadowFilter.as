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
package org.apache.royale.svg
{
	
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.ValuesManager;

	/**
	 *  DropShadowFilter is a bead that injects a series of beads in the correct 
	 *  order and initialized them.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.3
	 */
	public class DropShadowFilter implements IBead
	{
		private var _dx:Number;
		private var _dy:Number;
		private var _stdDeviation:Number;

		public function DropShadowFilter()
		{
		}
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */		
		public function set strand(value:IStrand):void
		{
			if (!value)
			{
				return;
			}
			loadBeadFromValuesManager(Filter, "filter", value);
			var offset:OffsetFilterElement = loadBeadFromValuesManager(OffsetFilterElement, "offsetFilterElement", value) as OffsetFilterElement;
			offset.dx = dx;
			offset.dy = dy;
			var blur:BlurFilterElement = loadBeadFromValuesManager(BlurFilterElement, "blurFilterElement", value) as BlurFilterElement;
			blur.stdDeviation = stdDeviation;
			blur.blurResult = "blurResult";
			var blend:BlendFilterElement = loadBeadFromValuesManager(BlendFilterElement, "blendFilterElement", value) as BlendFilterElement;
			blend.in2 = "blurResult";
			value.removeBead(this);
		}

		private function loadBeadFromValuesManager(classOrInterface:Class, classOrInterfaceName:String, strand:IStrand):IBead
		{
			var result:IBead;
			var c:Class = ValuesManager.valuesImpl.getValue(this, classOrInterfaceName) as Class;
			if (c)
			{
				COMPILE::JS
					{
						var f:Function = c as Function;
						result = new f() as IBead;
					}
					COMPILE::SWF
					{
						result = new c() as IBead;
					}
					if (result)
						strand.addBead(result);
			}
			return result;
		}

		/**
		 *  The drop shadow x offset
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function get dx():Number
		{
			return _dx;
		}
		
		public function set dx(value:Number):void
		{
			_dx = value;
		}
		
		/**
		 *  The drop shadow y offset
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function get dy():Number
		{
			return _dy;
		}
		
		public function set dy(value:Number):void
		{
			_dy = value;
		}

		/**
		 *  The Gaussian blur standard deviation for the drop shadow
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function get stdDeviation():Number
		{
			return _stdDeviation;
		}
		
		public function set stdDeviation(value:Number):void
		{
			_stdDeviation = value;
		}
	}
}

