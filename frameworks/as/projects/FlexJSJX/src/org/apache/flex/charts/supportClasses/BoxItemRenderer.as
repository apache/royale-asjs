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
package org.apache.flex.charts.supportClasses
{
	import org.apache.flex.core.FilledRectangle;
	import org.apache.flex.html.staticControls.supportClasses.UIItemRendererBase;
	import org.apache.flex.charts.core.IChartItemRenderer;
	
	/**
	 *  The BoxItemRenderer displays a colored rectangular area suitable for use as
	 *  an itemRenderer for a BarChartSeries. This class implements the IChartItemRenderer
	 *  interface. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class BoxItemRenderer extends UIItemRendererBase implements IChartItemRenderer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function BoxItemRenderer()
		{
			super();
		}
				
		/**
		 *  The parent component of the itemRenderer instance. This is the container that houses
		 *  all of the itemRenderers for the series.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		private var _itemRendererParent:Object;
		public function get itemRendererParent():Object
		{
			return _itemRendererParent;
		}
		public function set itemRendererParent(value:Object):void
		{
			_itemRendererParent = value;
		}
		
		private var filledRect:FilledRectangle;
		
		/**
		 *  The name of the field containing the value for the Y axis.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		private var _yField:String = "y";
		public function get yField():String
		{
			return _yField;
		}
		public function set yField(value:String):void
		{
			_yField = value;
		}
		
		/**
		 *  The name of the field containing the value for the X axis.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		private var _xField:String = "x";
		public function get xField():String
		{
			return _xField;
		}
		public function set xField(value:String):void
		{
			_xField = value;
		}
		
		/**
		 *  The color used to fill the interior of the box.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		private var _fillColor:uint;
		public function get fillColor():uint
		{
			return _fillColor;
		}
		public function set fillColor(value:uint):void
		{
			_fillColor = value;
		}
		
		/**
		 *  The data being represented.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		override public function set data(value:Object):void
		{
			super.data = value;		
			
			if (filledRect == null) {
				filledRect = new FilledRectangle();
				addElement(filledRect);
			}	
		}
		
		/**
		 *  @private
		 */
		override public function set width(value:Number):void
		{
			super.width = value;
			drawBar();
		}
		
		/**
		 *  @private
		 */
		override public function set height(value:Number):void
		{
			super.height = value;
			drawBar();
		}
		
		/**
		 *  @private
		 */
		protected function drawBar():void
		{
			if (filledRect) {
				filledRect.fillColor = fillColor;
				filledRect.drawRect(0,0,this.width,this.height);
			}
		}
	}
}