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
package org.apache.flex.html.beads.layouts
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import org.apache.flex.core.IBeadLayout;
	import org.apache.flex.core.IBorderModel;
	import org.apache.flex.core.ILayoutParent;
	import org.apache.flex.core.IParentIUIBase;
	import org.apache.flex.core.IScrollBarModel;
	import org.apache.flex.core.IScrollingLayoutParent;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.supportClasses.Border;
	import org.apache.flex.html.supportClasses.ScrollBar;

    /**
     *  The NonVirtualVerticalScrollingLayout class is a layout
     *  bead that displays a set of children vertically in one row, 
     *  separating them according to CSS layout rules for margin and 
     *  vertical-align styles and lays out a vertical ScrollBar
     *  to the right of the children.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class NonVirtualVerticalScrollingLayout implements IBeadLayout
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function NonVirtualVerticalScrollingLayout()
		{
		}
        
        private var vScrollBar:ScrollBar;	

		private var _strand:IStrand;
		
        /**
         *  @copy org.apache.flex.core.IBead#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			IEventDispatcher(value).addEventListener("heightChanged", changeHandler);
			IEventDispatcher(value).addEventListener("widthChanged", changeHandler);
			IEventDispatcher(value).addEventListener("itemsCreated", changeHandler);
		}
		
		private function changeHandler(event:Event):void
		{            
            var layoutParent:IScrollingLayoutParent = 
                _strand.getBeadByType(IScrollingLayoutParent) as IScrollingLayoutParent;
            var contentView:IParentIUIBase = layoutParent.contentView as IParentIUIBase;
			var border:Border = layoutParent.border;
   			var borderModel:IBorderModel;
            if (border)
                borderModel = border.model as IBorderModel;
            var ww:Number = layoutParent.resizableView.width;
            var hh:Number = layoutParent.resizableView.height;
            if (border)
            {
                border.width = ww;
                border.height = hh;
            }
            
			contentView.width = ww - ((border) ? borderModel.offsets.left + borderModel.offsets.right : 0);
			contentView.height = hh - ((border) ? borderModel.offsets.top - borderModel.offsets.bottom : 0);
			contentView.x = (border) ? borderModel.offsets.left : 0;
			contentView.y = (border) ? borderModel.offsets.top : 0;
			
			var n:int = contentView.numElements;
			var yy:Number = 0;
			
			for (var i:int = 0; i < n; i++)
			{
				var ir:IUIBase = contentView.getElementAt(i) as IUIBase;
				ir.y = yy;
				ir.width = contentView.width;
				yy += ir.height;			
			}
			if (yy > contentView.height)
			{
				vScrollBar = layoutParent.vScrollBar;
				contentView.width -= vScrollBar.width;
				IScrollBarModel(vScrollBar.model).maximum = yy;
				IScrollBarModel(vScrollBar.model).pageSize = contentView.height;
				IScrollBarModel(vScrollBar.model).pageStepSize = contentView.height;
				vScrollBar.visible = true;
				vScrollBar.height = contentView.height;
				vScrollBar.y = contentView.y;
				vScrollBar.x = contentView.width;
                var vpos:Number = IScrollBarModel(vScrollBar.model).value;
                DisplayObject(contentView).scrollRect = new Rectangle(0, vpos, contentView.width, vpos + contentView.height);
                vScrollBar.addEventListener("scroll", scrollHandler);
			}
			else if (vScrollBar)
			{
                DisplayObject(contentView).scrollRect = null;
				vScrollBar.visible = false;
			}
			
			IEventDispatcher(_strand).dispatchEvent(new Event("layoutComplete"));
		}

        private function scrollHandler(event:Event):void
        {
			var layoutParent:ILayoutParent = _strand.getBeadByType(ILayoutParent) as ILayoutParent;
			var contentView:IParentIUIBase = layoutParent.contentView;
			
            var vpos:Number = IScrollBarModel(vScrollBar.model).value;
			DisplayObject(contentView).scrollRect = new Rectangle(0, vpos, contentView.width, vpos + contentView.height);
        }
	}
}
