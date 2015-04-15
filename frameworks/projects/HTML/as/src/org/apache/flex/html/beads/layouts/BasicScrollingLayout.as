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
	import org.apache.flex.core.ILayoutChild;
	import org.apache.flex.core.ILayoutParent;
	import org.apache.flex.core.IParentIUIBase;
    import org.apache.flex.core.IScrollBarModel;
    import org.apache.flex.core.IScrollingLayoutParent;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
    import org.apache.flex.html.supportClasses.Border;
    import org.apache.flex.html.supportClasses.ScrollBar;

    /**
     *  The NonVirtualBasicLayout class is a simple layout
     *  bead.  It takes the set of children and lays them out
     *  as specified by CSS properties like left, right, top
     *  and bottom, and puts up a scrollbar if needed.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class NonVirtualBasicScrollingLayout implements IBeadLayout
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function NonVirtualBasicScrollingLayout()
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
			IEventDispatcher(value).addEventListener("childrenAdded", changeHandler);
            IEventDispatcher(value).addEventListener("layoutNeeded", changeHandler);
			IEventDispatcher(value).addEventListener("itemsCreated", changeHandler);
			IEventDispatcher(value).addEventListener("beadsAdded", changeHandler);
		}
	
		private function changeHandler(event:Event):void
		{
			var layoutParent:IScrollingLayoutParent = _strand.getBeadByType(IScrollingLayoutParent) as IScrollingLayoutParent;
			var contentView:IParentIUIBase = layoutParent.contentView;
            if (!contentView)
                return;
            
            IEventDispatcher(contentView).addEventListener("childrenAdded", changeHandler);
            IEventDispatcher(contentView).addEventListener("layoutNeeded", changeHandler);
			
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
            
            var ilcv:ILayoutChild = contentView as ILayoutChild;
            if (ilcv)
            {
                ilcv.setWidth(ww - ((border) ? borderModel.offsets.left + borderModel.offsets.right : 0));
                ilcv.setHeight(hh - ((border) ? borderModel.offsets.top - borderModel.offsets.bottom : 0));                
            }
            else
            {
                contentView.width = ww - ((border) ? borderModel.offsets.left + borderModel.offsets.right : 0);
                contentView.height = hh - ((border) ? borderModel.offsets.top - borderModel.offsets.bottom : 0);                
            }
            contentView.x = (border) ? borderModel.offsets.left : 0;
            contentView.y = (border) ? borderModel.offsets.top : 0;
            
            var w:Number = contentView.width;
            var h:Number = contentView.height;
			var n:int = contentView.numElements;
            var yy:Number = 0;
			for (var i:int = 0; i < n; i++)
			{
				var child:IUIBase = contentView.getElementAt(i) as IUIBase;
                var left:Number = ValuesManager.valuesImpl.getValue(child, "left");
                var right:Number = ValuesManager.valuesImpl.getValue(child, "right");
                var top:Number = ValuesManager.valuesImpl.getValue(child, "top");
                var bottom:Number = ValuesManager.valuesImpl.getValue(child, "bottom");
                ww = w;
                hh = h;
                
                if (!isNaN(left))
                {
                    child.x = left;
                    ww -= left;
                }
                if (!isNaN(top))
                {
                    child.y = top;
                    hh -= top;
                }
                var ilc:ILayoutChild = child as ILayoutChild;
                if (ilc)
                {
                    ilc = child as ILayoutChild;
                    if (!isNaN(ilc.percentWidth))
                        ilc.setWidth((ww - (isNaN(right) ? 0 : right)) * ilc.percentWidth / 100);
                }
                if (!isNaN(right))
                {
                    if (!isNaN(left))
                    {
                        if (ilc)
                            ilc.setWidth(ww - right);
                        else
                            child.width = ww - right;
                    }
                    else
                        child.x = w - right - child.width;
                }
                if (child is ILayoutChild)
                {
                    ilc = child as ILayoutChild;
                    if (!isNaN(ilc.percentHeight))
                        ilc.setHeight((hh - (isNaN(bottom) ? 0 : bottom)) * ilc.percentHeight / 100);
                }
                if (!isNaN(bottom))
                {
                    if (!isNaN(top))
                    {
                        if (ilc)
                            ilc.setHeight(hh - bottom);
                        else
                            child.height = hh - bottom;
                    }
                    else
                        child.y = h - bottom - child.height;
                }
                yy = Math.max(yy, child.y + child.height);
			}
            if (yy > contentView.height)
            {
                vScrollBar = layoutParent.vScrollBar;
                if (ilcv)
                    ilcv.setWidth(contentView.width - vScrollBar.width);
                else
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
            var layoutParent:IScrollingLayoutParent = _strand.getBeadByType(IScrollingLayoutParent) as IScrollingLayoutParent;
            var contentView:IParentIUIBase = layoutParent.contentView;
            
            var vpos:Number = IScrollBarModel(vScrollBar.model).value;
            DisplayObject(contentView).scrollRect = new Rectangle(0, vpos, contentView.width, vpos + contentView.height);
        }
    }
}
