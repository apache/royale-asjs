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
	COMPILE::SWF 
	{
		import org.apache.royale.core.IRenderedObject;
		import flash.filters.DropShadowFilter;
	}

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
		private var _red:Number = 0;
		private var _green:Number = 0;
		private var _blue:Number = 0;
		private var _opacity:Number = 1;
		private var _spread:Number = 1;
		private var _inset:Boolean;

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
			COMPILE::JS 
			{
				if (!value)
				{
					return;
				}
				loadBeadFromValuesManager(Filter, "filter", value);
				if (inset)
				{
					loadBeadFromValuesManager(InvertFilterElement, "invertFilterElement", value);
				}
				if (!isNaN(dx) && !isNaN(dy) && (dx !=0 || dy !=0))
				{
					var offset:OffsetFilterElement = loadBeadFromValuesManager(OffsetFilterElement, "offsetFilterElement", value) as OffsetFilterElement;
					offset.dx = dx;
					offset.dy = dy;
				}
				var blur:BlurFilterElement = loadBeadFromValuesManager(BlurFilterElement, "blurFilterElement", value) as BlurFilterElement;
				blur.stdDeviation = stdDeviation;
				var colorMatrix:ColorMatrixFilterElement = loadBeadFromValuesManager(ColorMatrixFilterElement, "colorMatrixFilterElement", value) as ColorMatrixFilterElement;
				colorMatrix.red = red;
				colorMatrix.green = green;
				colorMatrix.blue = blue;
				colorMatrix.opacity = opacity;
				var spreadElement:SpreadFilterElement = loadBeadFromValuesManager(SpreadFilterElement, "spreadFilterElement", value) as SpreadFilterElement;
				if (!inset)
				{
					spreadElement.result = "spreadResult";
				}
				spreadElement.spread = spread;
				if (inset)
				{
					var composite:CompositeFilterElement = loadBeadFromValuesManager(CompositeFilterElement, "compositeFilterElement", value) as CompositeFilterElement;
					composite.in2 = "SourceAlpha";
					composite.operator = "in";
					composite.result = "compositeResult";
				}
				var blend:BlendFilterElement = loadBeadFromValuesManager(BlendFilterElement, "blendFilterElement", value) as BlendFilterElement;
				blend.in = inset ? "compositeResult" : "SourceGraphic";
				blend.in2 = inset ? "SourceGraphic" : "spreadResult";
				value.removeBead(this);
			}
			COMPILE::SWF 
			{
				var distance:Number = Math.sqrt( (dx * dx) + (dy * dy) );
				var radians:Number = Math.atan2(dy, dx);
				var angle:Number =  (180/Math.PI) * radians;
				var color:uint = red|green|blue;
				var filter:flash.filters.DropShadowFilter = new flash.filters.DropShadowFilter(distance, angle, color, opacity, stdDeviation, stdDeviation, spread + 1, 1, inset);
				(value as IRenderedObject).$displayObject.filters = [filter];
			}
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

		/**
		 *  The red component of the drop shadow
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function get red():Number
		{
			return _red;
		}
		
		public function set red(value:Number):void
		{
			_red = value;
		}

		/**
		 *  The green component of the drop shadow
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function get green():Number
		{
			return _green;
		}
		
		public function set green(value:Number):void
		{
			_green = value;
		}

		/**
		 *  The blue component of the drop shadow
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function get blue():Number
		{
			return _blue;
		}
		
		public function set blue(value:Number):void
		{
			_blue = value;
		}

		/**
		 *  The opacity component of the drop shadow
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function get opacity():Number
		{
			return _opacity;
		}
		
		public function set opacity(value:Number):void
		{
			_opacity = value;
		}

		/**
		 *  The spread component of the drop shadow. This can be a number between 0 and 255.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function get spread():Number
		{
			return _spread;
		}
		
		public function set spread(value:Number):void
		{
			_spread = value;
		}

		/**
		 *  Whether or not the drop shadow is inset.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function get inset():Boolean 
		{
			return _inset;
		}
		
		public function set inset(value:Boolean):void 
		{
			_inset = value;
		}
	}
}

