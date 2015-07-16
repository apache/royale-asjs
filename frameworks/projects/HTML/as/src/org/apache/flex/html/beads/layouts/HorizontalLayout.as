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
	import org.apache.flex.core.IBeadModel;
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
     *  The HorizontalLayout class is a simple layout
     *  bead.  It takes the set of children and lays them out
     *  horizontally in one row, separating them according to
     *  CSS layout rules for margin and vertical-align styles.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class HorizontalLayout implements IBeadLayout
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function HorizontalLayout()
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
			var contentView:IParentIUIBase = layoutParent.contentView;
			
			// this layout will use and modify the IViewportMode
			var viewport:IViewport = host.getBeadByType(IViewport) as IViewport;
			if (viewport) viewportModel = viewport.model;
			
			var n:int = contentView.numElements;
            var hostSizedToContent:Boolean = host.isHeightSizedToContent();
            var ilc:ILayoutChild;
			var marginLeft:Object;
			var marginRight:Object;
			var marginTop:Object;
			var marginBottom:Object;
			var margin:Object;
			var maxHeight:Number = 0;
            // asking for contentView.width can result in infinite loop if host isn't sized already
            var h:Number = hostSizedToContent ? 0 : contentView.height;
			var verticalMargins:Array = [];
            var hasVerticalAlign:Boolean;
			
			for (var i:int = 0; i < n; i++)
			{
				var child:IUIBase = contentView.getElementAt(i) as IUIBase;
				if (child == null || !child.visible) continue;
                var top:Number = ValuesManager.valuesImpl.getValue(child, "top");
                var bottom:Number = ValuesManager.valuesImpl.getValue(child, "bottom");
                ilc = child as ILayoutChild;
				margin = ValuesManager.valuesImpl.getValue(child, "margin");
				if (margin is Array)
				{
					if (margin.length == 1)
						marginLeft = marginTop = marginRight = marginBottom = margin[0];
					else if (margin.length <= 3)
					{
						marginLeft = marginRight = margin[1];
						marginTop = marginBottom = margin[0];
					}
					else if (margin.length == 4)
					{
						marginLeft = margin[3];
						marginBottom = margin[2];
						marginRight = margin[1];
						marginTop = margin[0];					
					}
				}
				else if (margin == null)
				{
					marginLeft = ValuesManager.valuesImpl.getValue(child, "margin-left");
					marginTop = ValuesManager.valuesImpl.getValue(child, "margin-top");
					marginRight = ValuesManager.valuesImpl.getValue(child, "margin-right");
					marginBottom = ValuesManager.valuesImpl.getValue(child, "margin-bottom");
				}
				else
				{
					marginLeft = marginTop = marginBottom = marginRight = margin;
				}
				var ml:Number;
				var mr:Number;
				var mt:Number;
				var mb:Number;
				var lastmr:Number;
				if (marginLeft == "auto")
					ml = 0;
				else
				{
					ml = Number(marginLeft);
					if (isNaN(ml))
						ml = 0;
				}
				if (marginRight == "auto")
					mr = 0;
				else
				{
					mr = Number(marginRight);
					if (isNaN(mr))
						mr = 0;
				}
				mt = Number(marginTop);
				if (isNaN(mt))
					mt = 0;
				mb = Number(marginBottom);
				if (isNaN(mb))
					mb = 0;
                var xx:Number;
                if (i == 0)
                    child.x = ml;
                else
                    child.x = xx + ml + lastmr;
                if (ilc)
                {
                    if (!isNaN(ilc.percentWidth))
                        ilc.setWidth(contentView.width * ilc.percentWidth / 100, !isNaN(ilc.percentHeight));
                }
                lastmr = mr;
                var marginObject:Object = {};
                verticalMargins[i] = marginObject;
                if (!hostSizedToContent)
                {
                    // if host is sized by parent,
                    // we can position and size children horizontally now
                    setPositionAndHeight(child, top, mt, bottom, mb, h);
                }
                else
                {
                    if (!isNaN(top))
                    {
                        mt = top;
                        marginObject.top = mt;
                    }
                    if (!isNaN(bottom))
                    {
                        mb = bottom;
                        marginObject.bottom = mb;
                    }
                    maxHeight = Math.max(maxHeight, mt + child.height + mb);
                }
				xx = child.x + child.width;
				var valign:* = ValuesManager.valuesImpl.getValue(child, "vertical-align");
				marginObject.valign = valign;
                if (valign !== undefined)
                    hasVerticalAlign = true;
			}
            if (hostSizedToContent)
            {
                ILayoutChild(contentView).setHeight(maxHeight, true);
                if (host.isWidthSizedToContent())
                    ILayoutChild(contentView).setWidth(xx, true);
                for (i = 0; i < n; i++)
                {
                    child = contentView.getElementAt(i) as IUIBase;
                    if (child == null || !child.visible) continue;
                    var obj:Object = verticalMargins[i];
                    setPositionAndHeight(child, obj.top, obj.marginTop,
                        obj.bottom, obj.marginBottom, maxHeight);
                }
            }
            if (hasVerticalAlign)
            {
    			for (i = 0; i < n; i++)
    			{
    				child = contentView.getElementAt(i) as IUIBase;
    				if (child == null || !child.visible) continue;
                    obj = verticalMargins[i];
                    if (child is ILayoutChild)
                    {
                        ilc = child as ILayoutChild;
                        if (!isNaN(ilc.percentHeight))
                            ilc.setHeight(contentView.height * ilc.percentHeight / 100, !isNaN(ilc.percentHeight));
                    }
    				if (obj.valign == "middle")
    					child.y = (maxHeight - child.height) / 2;
    				else if (valign == "bottom")
    					child.y = maxHeight - child.height - obj.marginBottom;
    				else
    					child.y = obj.marginTop;
    			}
            }
			
			// Only return true if the contentView needs to be larger; that new
			// size is stored in the model.
			var sizeChanged:Boolean = false;
			if (viewportModel != null) {
				if (viewportModel.contentHeight != maxHeight) {
					viewportModel.contentHeight = maxHeight;
					sizeChanged = true;
				}
				if (viewportModel.contentWidth != xx) {
					viewportModel.contentWidth = xx;
					sizeChanged = true;
				}
			}
			
			host.dispatchEvent( new Event("layoutComplete") );
			
			return sizeChanged;
		}
        
        private function setPositionAndHeight(child:IUIBase, top:Number, mt:Number,
                                             bottom:Number, mb:Number, h:Number):void
        {
            var heightSet:Boolean = false;
            
            var hh:Number = h;
            var ilc:ILayoutChild = child as ILayoutChild;
            if (!isNaN(top))
            {
                child.y = top + mt;
                hh -= top + mt;
            }
            else 
            {
                child.y = mt;
                hh -= mt;
            }
            if (!isNaN(bottom))
            {
                if (!isNaN(top))
                {
                    if (ilc)
                        ilc.setHeight(hh - bottom - mb, true);
                    else 
                    {
                        child.height = hh - bottom - mb;
                        heightSet = true;
                    }
                }
                else
                    child.y = h - bottom - mb - child.height;
            }
            if (ilc)
            {
                if (!isNaN(ilc.percentHeight))
                    ilc.setHeight(h * ilc.percentHeight / 100, true);
            }
            if (!heightSet)
                child.dispatchEvent(new Event("sizeChanged"));
        }
	}
}
