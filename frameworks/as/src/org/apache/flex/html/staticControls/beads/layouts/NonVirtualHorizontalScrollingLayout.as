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
package org.apache.flex.html.staticControls.beads.layouts
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	
	import org.apache.flex.core.IBeadLayout;
	import org.apache.flex.core.IBorderModel;
	import org.apache.flex.core.ILayoutParent;
	import org.apache.flex.core.IScrollBarModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.staticControls.supportClasses.Border;
	import org.apache.flex.html.staticControls.supportClasses.ScrollBar;
	
	public class NonVirtualHorizontalScrollingLayout implements IBeadLayout
	{
		public function NonVirtualHorizontalScrollingLayout()
		{
		}
		
		private var hScrollBar:ScrollBar;
		
		private var _strand:IStrand;
		
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			IEventDispatcher(value).addEventListener("heightChanged", changeHandler);
			IEventDispatcher(value).addEventListener("widthChanged", changeHandler);
			IEventDispatcher(value).addEventListener("itemsCreated", changeHandler);
		}
		
		private function changeHandler(event:Event):void
		{            
			var layoutParent:ILayoutParent = _strand.getBeadByType(ILayoutParent) as ILayoutParent;
			var contentView:DisplayObjectContainer = layoutParent.contentView;
			var border:Border = layoutParent.border;
			var borderModel:IBorderModel = border.model as IBorderModel;
			
			var ww:Number = layoutParent.resizableView.width;
			var hh:Number = layoutParent.resizableView.height;
			border.width = ww;
			border.height = hh;
			
			contentView.width = ww - borderModel.offsets.left - borderModel.offsets.right;
			contentView.height = hh - borderModel.offsets.top - borderModel.offsets.bottom;
			contentView.x = borderModel.offsets.left;
			contentView.y = borderModel.offsets.top;
			
			var n:int = contentView.numChildren;
			var xx:Number = 0;
			for (var i:int = 0; i < n; i++)
			{
				var ir:DisplayObject = contentView.getChildAt(i);
				ir.x = xx;
				ir.height = contentView.height;
				xx += ir.width;			
			}
			/*
			if (xx > dataGroup.width)
			{
				hScrollBar = listView.hScrollBar;
				dataGroup.height -= hScrollBar.height;
				IScrollBarModel(hScrollBar.model).maximum = xx;
				IScrollBarModel(hScrollBar.model).pageSize = dataGroup.width;
				IScrollBarModel(hScrollBar.model).pageStepSize = dataGroup.width;
				hScrollBar.visible = true;
				hScrollBar.width = dataGroup.width;
				hScrollBar.x = dataGroup.x;
				hScrollBar.y = dataGroup.height;
				var xpos:Number = IScrollBarModel(hScrollBar.model).value;
				dataGroup.scrollRect = new Rectangle(xpos, 0, xpos + dataGroup.width, dataGroup.height);
				hScrollBar.addEventListener("scroll", scrollHandler);
			}
			else if (hScrollBar)
			{
				dataGroup.scrollRect = null;
				hScrollBar.visible = false;
			}
			*/
		}
		
		/*private function scrollHandler(event:Event):void
		{
			var xpos:Number = IScrollBarModel(hScrollBar.model).value;
			dataGroup.scrollRect = new Rectangle(xpos, 0, xpos + dataGroup.width, dataGroup.height);
		}*/
	}
}