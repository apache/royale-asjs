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
package org.apache.flex.html.staticControls.supportClasses
{	
	import org.apache.flex.core.FilledRectangle;
	import org.apache.flex.core.IItemRenderer;
	import org.apache.flex.core.IItemRendererFactory;
	import org.apache.flex.html.staticControls.beads.IChartItemRenderer;
	import org.apache.flex.html.staticControls.supportClasses.UIItemRendererBase;
	
	public class BoxItemRenderer extends UIItemRendererBase implements IChartItemRenderer, IItemRendererFactory
	{
		public function BoxItemRenderer()
		{
			super();
		}
		
		override public function newInstance():IItemRenderer
		{
			return new BoxItemRenderer();
		}
		
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
		
		private var _yField:String = "y";
		public function get yField():String
		{
			return _yField;
		}
		public function set yField(value:String):void
		{
			_yField = value;
		}
		
		private var _xField:String = "x";
		public function get xField():String
		{
			return _xField;
		}
		public function set xField(value:String):void
		{
			_xField = value;
		}
		
		private var _fillColor:uint;
		public function get fillColor():uint
		{
			return _fillColor;
		}
		public function set fillColor(value:uint):void
		{
			_fillColor = value;
		}
		
		override public function addedToParent():void
		{
			super.addedToParent();
		}
				
		override public function set data(value:Object):void
		{
			super.data = value;		
			
			if (filledRect == null) {
				filledRect = new FilledRectangle();
				addElement(filledRect);
			}	
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
			drawBar();
		}
		
		override public function set height(value:Number):void
		{
			super.height = value;
			drawBar();
		}
		
		protected function drawBar():void
		{
			if (filledRect) {
				filledRect.fillColor = fillColor;
				filledRect.drawRect(0,0,this.width,this.height);
			}
		}
	}
}