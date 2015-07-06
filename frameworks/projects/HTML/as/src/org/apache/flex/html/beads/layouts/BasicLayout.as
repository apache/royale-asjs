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
	import org.apache.flex.core.ILayoutChild;
	import org.apache.flex.core.ILayoutParent;
	import org.apache.flex.core.IParentIUIBase;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.IViewport;
	import org.apache.flex.core.IViewportModel;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
    import org.apache.flex.utils.dbg.DOMPathUtil;

    /**
     *  The BasicLayout class is a simple layout
     *  bead.  It takes the set of children and lays them out
     *  as specified by CSS properties like left, right, top
     *  and bottom.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class BasicLayout implements IBeadLayout
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function BasicLayout()
		{
		}
		
        // the strand/host container is also an ILayoutChild because
        // can have its size dictated by the host's parent which is
        // important to know for layout optimization
        private var host:ILayoutChild;
        		
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
            host = value as ILayoutChild;
		}
		
		private var _viewportModel:IViewportModel;
		
		/**
		 *  The data that describes the viewport used by this layout.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get viewportModel():IViewportModel
		{
			return _viewportModel;
		}
		public function set viewportModel(value:IViewportModel):void
		{
			_viewportModel = value;
		}
	        
        /**
         * @copy org.apache.flex.core.IBeadLayout#layout
         */
		public function layout():Boolean
		{
            //trace(DOMPathUtil.getPath(host), event ? event.type : "fixed size");
			var layoutParent:ILayoutParent = host.getBeadByType(ILayoutParent) as ILayoutParent;
			var contentView:IParentIUIBase = layoutParent ? layoutParent.contentView : IParentIUIBase(host);
			
			// this layout will use and modify the IViewportMode
			var viewport:IViewport = host.getBeadByType(IViewport) as IViewport;
			viewportModel = viewport.model;
			
            var hostWidthSizedToContent:Boolean = host.isWidthSizedToContent();
            var hostHeightSizedToContent:Boolean = host.isHeightSizedToContent();
            var w:Number = hostWidthSizedToContent ? 0 : contentView.width;
            var h:Number = hostHeightSizedToContent ? 0 : contentView.height;
			var n:int = contentView.numElements;
            var maxWidth:Number = 0;
            var maxHeight:Number = 0;
            var childData:Array = [];
			for (var i:int = 0; i < n; i++)
			{
				var child:IUIBase = contentView.getElementAt(i) as IUIBase;
                var left:Number = ValuesManager.valuesImpl.getValue(child, "left");
                var right:Number = ValuesManager.valuesImpl.getValue(child, "right");
                var top:Number = ValuesManager.valuesImpl.getValue(child, "top");
                var bottom:Number = ValuesManager.valuesImpl.getValue(child, "bottom");
                var ww:Number = w;
                var hh:Number = h;
                
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
                    if (!hostWidthSizedToContent)
                    {
                        if (!isNaN(ilc.percentWidth))
                            ilc.setWidth((ww - (isNaN(right) ? 0 : right)) * ilc.percentWidth / 100, true);
                    }
                    else
                        childData[i] = { bottom: bottom, right: right, ww: ww, ilc: ilc, child: child };
                }
                if (!isNaN(right))
                {
                    if (!hostWidthSizedToContent)
                    {
                        if (!isNaN(left))
                        {
                            if (ilc)
                                ilc.setWidth(ww - right, true);
                            else
                                child.width = ww - right;
                        }
                        else
                            child.x = w - right - child.width;
                    }
                    else
                        childData[i] = { ww: ww, left: left, right: right, ilc: ilc, child: child };
                }
                if (ilc)
                {
                    if (!hostHeightSizedToContent)
                    {
                        if (!isNaN(ilc.percentHeight))
                            ilc.setHeight((hh - (isNaN(bottom) ? 0 : bottom)) * ilc.percentHeight / 100, true);
                    }
                    else
                    {
                        if (!childData[i])
                            childData[i] = { hh: hh, bottom: bottom, ilc: ilc, child: child };
                        else
                        {
                            childData[i].hh = hh;
                            childData[i].bottom = bottom;
                        }
                    }
                }
                if (!isNaN(bottom))
                {
                    if (!hostHeightSizedToContent)
                    {
                        if (!isNaN(top))
                        {
                            if (ilc)
                                ilc.setHeight(hh - bottom, true);
                            else
                                child.height = hh - bottom;
                        }
                        else
                            child.y = h - bottom - child.height;
                    }
                    else
                    {
                        if (!childData[i])
                            childData[i] = { top: top, bottom: bottom, hh:hh, ilc: ilc, child: child };
                        else
                        {
                            childData[i].top = top;
                            childData[i].bottom = bottom;
                            childData[i].hh = hh;
                        }
                    }
                }
                if (!childData[i])
                    child.dispatchEvent(new Event("sizeChanged"));
                maxWidth = Math.max(maxWidth, child.x + child.width);
                maxHeight = Math.max(maxHeight, child.y + child.height);
			}
            if (hostHeightSizedToContent || hostWidthSizedToContent)
            {
                for (i = 0; i < n; i++)
                {
                    var data:Object = childData[i];
                    if (data)
                    {
                        if (hostWidthSizedToContent)
                        {
                            if (data.ilc && !isNaN(data.ilc.percentWidth))
                                data.ilc.setWidth((data.ww - (isNaN(data.right) ? 0 : data.right)) * data.ilc.percentWidth / 100, true);
                            if (!isNaN(data.right))
                            {
                                if (!isNaN(data.left))
                                {
                                    if (data.ilc)
                                        data.ilc.setWidth(data.ww - data.right, true);
                                    else
                                        data.child.width = data.ww - data.right;
                                }
                                else
                                    data.child.x = maxWidth - data.right - data.child.width;
                            }
                        }
                        if (hostHeightSizedToContent)
                        {
                            if (data.ilc && !isNaN(data.ilc.percentHeight))
                                data.ilc.setHeight((data.hh - (isNaN(data.bottom) ? 0 : data.bottom)) * data.ilc.percentHeight / 100, true);
                            if (!isNaN(data.bottom))
                            {
                                if (!isNaN(data.top))
                                {
                                    if (data.ilc)
                                        data.ilc.setHeight(data.hh - data.bottom, true);
                                    else
                                        data.child.height = data.hh - data.bottom;
                                }
                                else
                                    data.child.y = maxHeight - data.bottom - data.child.height;
                            }
                        }
                        child.dispatchEvent(new Event("sizeChanged"));
                    }
                }
            }
			
			if (viewportModel != null) {
				viewportModel.contentWidth = maxWidth;
				viewportModel.contentHeight = maxHeight;
			}
			
            return true;
		}
	}
}
