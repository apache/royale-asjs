package org.apache.flex.core.graphics
{
	
	import org.apache.flex.core.UIBase;
	
	public class GraphicShape extends UIBase
	{
		private var _fill:SolidColor;
		private var _stroke:SolidColorStroke;
		
		public function get stroke():SolidColorStroke
		{
			return _stroke;
		}
		
		/**
		 *  A solid color fill. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion FlexJS 0.0
		 */
		public function set stroke(value:SolidColorStroke):void
		{
			_stroke = value;
		}
		
		public function get fill():SolidColor
		{
			return _fill;
		}
		/**
		 *  A solid color fill. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion FlexJS 0.0
		 */
		public function set fill(value:SolidColor):void
		{
			_fill = value;
		}
		
	}
}