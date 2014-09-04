package org.apache.flex.core.graphics
{
	public class SolidColorStroke
	{
		
		//----------------------------------
		//  alpha
		//----------------------------------
		private var _alpha:Number = 1.0;
		
		//----------------------------------
		//  color
		//----------------------------------
		private var _color:uint = 0x000000;
		
		//----------------------------------
		//  weight
		//----------------------------------
		private var _weight:Number = 1;
		
		/**
		 *  The transparency of a color.
		 *  Possible values are 0.0 (invisible) through 1.0 (opaque). 
		 *  
		 *  @default 1.0
		 *  
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion FlexJS 0.3
		 */
		public function get alpha():Number
		{
			return _alpha;
		}
		
		public function set alpha(value:Number):void
		{
			var oldValue:Number = _alpha;
			if (value != oldValue)
			{
				_alpha = value;
			}
		}
		
		/**
		 *  A color value. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
	     *  @productversion FlexJS 0.3
		 */
		public function get color():uint
		{
			return _color;
		}
		
		public function set color(value:uint):void
		{
			var oldValue:uint = _color;
			if (value != oldValue)
			{
				_color = value;
			}
		}

		public function get weight():Number
		{
			return _weight;
		}

		/**
		 *  A color value. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion FlexJS 0.3
		 */
		public function set weight(value:Number):void
		{
			_weight = value;
		}

		
	}
}