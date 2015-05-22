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
	import org.apache.flex.core.IBeadLayout;
	import org.apache.flex.core.IBorderModel;
    import org.apache.flex.core.IParentIUIBase;
	import org.apache.flex.core.IScrollingLayoutParent;
    import org.apache.flex.core.IStrand;
    import org.apache.flex.core.IUIBase;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.supportClasses.Border;
	import org.apache.flex.html.supportClasses.ScrollBar;
	
    /**
     *  The HorizontalScrollingLayout class is a layout
     *  bead that displays a set of children horizontally in one row, 
     *  separating them according to CSS layout rules for margin and 
     *  vertical-align styles and lays out a horizontal ScrollBar
     *  below the children.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class HorizontalScrollingLayout implements IBeadLayout
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function HorizontalScrollingLayout()
		{
		}
		
		private var hScrollBar:ScrollBar;
		
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
		}
		
        /**
         *  @copy org.apache.flex.core.IBeadLayout#layout
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function layout():Boolean
		{            
			var layoutParent:IScrollingLayoutParent = 
                        _strand.getBeadByType(IScrollingLayoutParent) as IScrollingLayoutParent;
			var contentView:IParentIUIBase = layoutParent.contentView;
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
			
			var n:int = contentView.numElements;
			var xx:Number = 0;
			for (var i:int = 0; i < n; i++)
			{
				var ir:IUIBase = contentView.getElementAt(i) as IUIBase;
				if (ir == null || !ir.visible) continue;
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
            return true;
		}
		
		/*private function scrollHandler(event:Event):void
		{
			var xpos:Number = IScrollBarModel(hScrollBar.model).value;
			dataGroup.scrollRect = new Rectangle(xpos, 0, xpos + dataGroup.width, dataGroup.height);
		}*/
	}
}
