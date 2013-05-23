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
package org.apache.flex.html.staticControls.beads
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.staticControls.Container;
	import org.apache.flex.html.staticControls.ControlBar;
	import org.apache.flex.html.staticControls.TitleBar;
	
	public class PanelBead implements IBead, IContainerBead
	{
		public function PanelBead()
		{
			_titleBar = new TitleBar();
			_titleBar.initModel();
			_titleBar.initSkin();
		}
		
		private var _titleBar:TitleBar;
		public function get titleBar():TitleBar
		{
			return _titleBar;
		}
		
		private var _strand:IStrand;
		
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			Container(_strand).addChild(titleBar);

			var borderStyle:String;
			var borderStyles:Object = ValuesManager.valuesImpl.getValue(value, "border");
			if (borderStyles is Array)
			{
				borderStyle = borderStyles[1];
			}
			if (borderStyle == null)
			{
				borderStyle = ValuesManager.valuesImpl.getValue(value, "border-style") as String;
			}
			if (borderStyle != null && borderStyle != "none")
			{
				if (value.getBeadByType(IBorderBead) == null)
					value.addBead(new (ValuesManager.valuesImpl.getValue(value, "iBorderBead")) as IBead);	
			}
			var backgroundColor:Object = ValuesManager.valuesImpl.getValue(value, "background-color");
			var backgroundImage:Object = ValuesManager.valuesImpl.getValue(value, "background-image");
			if (backgroundColor != null || backgroundImage != null)
			{
				if (value.getBeadByType(IBackgroundBead) == null)
					value.addBead(new (ValuesManager.valuesImpl.getValue(value, "iBackgroundBead")) as IBead);					
			}
			
			var paddingLeft:Object;
			var paddingTop:Object;
			var padding:Object = ValuesManager.valuesImpl.getValue(value, "padding");
			if (padding is Array)
			{
				if (padding.length == 1)
					paddingLeft = paddingTop = padding[0];
				else if (padding.length <= 3)
				{
					paddingLeft = padding[1];
					paddingTop = padding[0];
				}
				else if (padding.length == 4)
				{
					paddingLeft = padding[3];
					paddingTop = padding[0];					
				}
			}
			else if (padding == null)
			{
				paddingLeft = ValuesManager.valuesImpl.getValue(value, "padding-left");
				paddingTop = ValuesManager.valuesImpl.getValue(value, "padding-top");
			}
			else
			{
				paddingLeft = paddingTop = padding;
			}
			var pl:Number = Number(paddingLeft);
			var pt:Number = Number(paddingTop);
			
			if( isNaN(pl) ) pl = 0;
			if( isNaN(pt) ) pt = 0;
			
			var actualParent:Sprite = new Sprite();
			DisplayObjectContainer(value).addChild(actualParent);
			Container(value).setActualParent(actualParent);
			actualParent.x = pl;
			actualParent.y = pt;
			
			contentArea = actualParent;
			
			IEventDispatcher(_strand).addEventListener("childrenAdded", changeHandler);
		}
		
		private var contentArea:DisplayObjectContainer;
		private var controlBarArea:ControlBar;
		private var controlBarBackground:Shape;
		
		private function changeHandler(event:Event):void
		{
			layoutTitleArea();
			
			contentArea.x = 0;
			contentArea.y = titleBar.height;
			contentArea.width = Container(_strand).width;
			
			IEventDispatcher(_strand).dispatchEvent(new Event('widthChanged'));
			IEventDispatcher(_strand).dispatchEvent(new Event('heightChanged'));
		}
		
		protected function layoutTitleArea() : void
		{
			titleBar.x = 0;
			titleBar.y = 0;
			titleBar.width = Container(_strand).width;
		}
	}
}