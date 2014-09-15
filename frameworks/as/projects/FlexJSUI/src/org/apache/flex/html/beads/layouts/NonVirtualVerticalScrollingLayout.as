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
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	
	import org.apache.flex.core.IBeadLayout;
	import org.apache.flex.core.IBorderModel;
<<<<<<< HEAD
	import org.apache.flex.core.IContentView;
	import org.apache.flex.core.IItemRenderer;
	import org.apache.flex.core.IItemRendererClassFactory;
	import org.apache.flex.core.IItemRendererParent;
	import org.apache.flex.core.ILayoutParent;
||||||| merged common ancestors
	import org.apache.flex.core.ILayoutParent;
=======
	import org.apache.flex.core.IScrollingLayoutParent;
    import org.apache.flex.core.ILayoutParent;
>>>>>>> refactor ILayoutParent into IScrollingLayoutParent
	import org.apache.flex.core.IScrollBarModel;
	import org.apache.flex.core.ISelectionModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.List;
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
			IEventDispatcher(value).addEventListener("layoutNeeded", changeHandler);
		}
		
		private function changeHandler(event:Event):void
		{            
            var layoutParent:IScrollingLayoutParent = 
                _strand.getBeadByType(IScrollingLayoutParent) as IScrollingLayoutParent;
            var contentView:IContentView = layoutParent.contentView as IContentView;
			var border:Border = layoutParent.border;
			var borderModel:IBorderModel = border.model as IBorderModel;
			
			var ww:Number = DisplayObject(layoutParent.resizableView).width;
			var hh:Number = DisplayObject(layoutParent.resizableView).height;
			border.width = ww;
			border.height = hh;
			
			contentView.width = ww - borderModel.offsets.left - borderModel.offsets.right;
			contentView.height = hh - borderModel.offsets.top - borderModel.offsets.bottom;
			contentView.x = borderModel.offsets.left;
			contentView.y = borderModel.offsets.top;
			
			var selectionModel:ISelectionModel = _strand.getBeadByType(ISelectionModel) as ISelectionModel;
			var dp:Array = selectionModel.dataProvider as Array;
			if (!dp)
				return;
			
			var itemRendererFactory:IItemRendererClassFactory = _strand.getBeadByType(IItemRendererClassFactory) as IItemRendererClassFactory;
			
			var n:int = dp.length;
			var yy:Number = 0;
			
			for (var i:int = 0; i < n; i++)
			{
				var needsAdd:Boolean = false;
				var ir:IItemRenderer = IItemRendererParent(contentView).getItemRendererForIndex(i);
				if (ir == null) {
					ir = itemRendererFactory.createItemRenderer(contentView as IItemRendererParent) as IItemRenderer;
				}
				ir.index = i;
				ir.labelField = (_strand as List).labelField;
				ir.data = dp[i];
				UIBase(ir).y = yy;
				UIBase(ir).x = 0;
				UIBase(ir).width = contentView.width;
				yy += UIBase(ir).height;			
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
				DisplayObjectContainer(contentView).scrollRect = new Rectangle(0, vpos, contentView.width, vpos + contentView.height);
				vScrollBar.addEventListener("scroll", scrollHandler);
			}
			else if (vScrollBar)
			{
				DisplayObjectContainer(contentView).scrollRect = null;
				vScrollBar.visible = false;
			}
		}

        private function scrollHandler(event:Event):void
        {
			var layoutParent:ILayoutParent = _strand.getBeadByType(ILayoutParent) as ILayoutParent;
			var contentView:DisplayObjectContainer = layoutParent.contentView;
			
            var vpos:Number = IScrollBarModel(vScrollBar.model).value;
			contentView.scrollRect = new Rectangle(0, vpos, contentView.width, vpos + contentView.height);
        }
	}
}
