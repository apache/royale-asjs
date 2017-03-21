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
	import org.apache.flex.core.ILayoutObject;
    import org.apache.flex.core.ILayoutHost;
	import org.apache.flex.core.ILayoutParent;
	import org.apache.flex.core.IParentIUIBase;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.IViewport;
	import org.apache.flex.core.IViewportModel;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
    import org.apache.flex.geom.Rectangle;
    import org.apache.flex.html.supportClasses.Viewport;
    import org.apache.flex.utils.CSSContainerUtils;
	import org.apache.flex.utils.CSSUtils;

    /**
     *  The FlexibleFirstChildHorizontalLayout class is a simple layout
     *  bead.  It takes the set of children and lays them out
     *  horizontally in one row, separating them according to
     *  CSS layout rules for margin and padding styles. But it
     *  will size the first child to take up as much or little
     *  room as possible.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class FlexibleFirstChildHorizontalLayout implements IBeadLayout
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function FlexibleFirstChildHorizontalLayout()
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
		
        private var _maxWidth:Number;
        
        /**
         *  @copy org.apache.flex.core.IBead#maxWidth
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function get maxWidth():Number
        {
            return _maxWidth;
        }
        
        /**
         *  @private 
         */
        public function set maxWidth(value:Number):void
        {
            _maxWidth = value;
        }
        
        private var _maxHeight:Number;
        
        /**
         *  @copy org.apache.flex.core.IBead#maxHeight
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function get maxHeight():Number
        {
            return _maxHeight;
        }
        
        /**
         *  @private 
         */
        public function set maxHeight(value:Number):void
        {
            _maxHeight = value;
        }
        
        /**
         * @copy org.apache.flex.core.IBeadLayout#layout
         */
		COMPILE::SWF
		public function layout():Boolean
		{			
			var layoutHost:ILayoutHost = (host as ILayoutParent).getLayoutHost(); 
			var contentView:ILayoutObject = layoutHost.contentView;
			
			var n:Number = contentView.numElements;
			if (n == 0) return false;
			
			var maxWidth:Number = 0;
			var maxHeight:Number = 0;
			var hostSizedToContent:Boolean = host.isHeightSizedToContent();
			var hostWidth:Number = contentView.width;
			var hostHeight:Number = hostSizedToContent ? 0 : contentView.height;
			
			var ilc:ILayoutChild;
			var data:Object;
			var canAdjust:Boolean = false;
			var marginLeft:Object;
			var marginRight:Object;
			var marginTop:Object;
			var marginBottom:Object;
			var margin:Object;
			
			var paddingMetrics:Rectangle = CSSContainerUtils.getPaddingMetrics(host);
			var borderMetrics:Rectangle = CSSContainerUtils.getBorderMetrics(host);
			
			var xpos:Number = hostWidth - borderMetrics.right - paddingMetrics.right;
			var ypos:Number = borderMetrics.top + paddingMetrics.left;
			var adjustedWidth:Number = 0;
			
			for(var i:int=(n-1); i >= 0; i--)
			{
				var child:IUIBase = contentView.getElementAt(i) as IUIBase;
				if (child == null || !child.visible) continue;
				var top:Number = ValuesManager.valuesImpl.getValue(child, "top");
				var bottom:Number = ValuesManager.valuesImpl.getValue(child, "bottom");
				margin = ValuesManager.valuesImpl.getValue(child, "margin");
				marginLeft = ValuesManager.valuesImpl.getValue(child, "margin-left");
				marginTop = ValuesManager.valuesImpl.getValue(child, "margin-top");
				marginRight = ValuesManager.valuesImpl.getValue(child, "margin-right");
				marginBottom = ValuesManager.valuesImpl.getValue(child, "margin-bottom");
				var ml:Number = CSSUtils.getLeftValue(marginLeft, margin, hostWidth);
				var mr:Number = CSSUtils.getRightValue(marginRight, margin, hostWidth);
				var mt:Number = CSSUtils.getTopValue(marginTop, margin, hostHeight);
				var mb:Number = CSSUtils.getBottomValue(marginBottom, margin, hostHeight);
				if (marginLeft == "auto")
					ml = 0;
				if (marginRight == "auto")
					mr = 0;
				
				ilc = child as ILayoutChild;
								
				var childYpos:Number = ypos + mt; // default y position
				
				if (!hostSizedToContent) {
					var childHeight:Number = child.height;
					if (ilc != null && !isNaN(ilc.percentHeight)) {
						childHeight = (hostHeight-borderMetrics.top-borderMetrics.bottom-paddingMetrics.top-paddingMetrics.bottom) * ilc.percentHeight/100.0;
						ilc.setHeight(childHeight);
					}			
					// the following code middle-aligns the child
					childYpos = hostHeight/2 - (childHeight + mt + mb)/2;
				}
				
				if (ilc) {
					if (!isNaN(ilc.percentWidth)) {
						ilc.setWidth((contentView.width-borderMetrics.left-borderMetrics.right-paddingMetrics.left-paddingMetrics.right) * ilc.percentWidth / 100);
					}
				}
				
				if (i > 0) {
					xpos -= child.width + mr;
					adjustedWidth = child.width;
				} else {
					adjustedWidth = xpos - (borderMetrics.left + paddingMetrics.left + ml + mr);
					xpos = borderMetrics.left + paddingMetrics.left + ml;
				}
				
				if (ilc) {
					ilc.setX(xpos);
					ilc.setY(childYpos);
					ilc.setWidth(adjustedWidth);
					
				} else {
					child.x = xpos;
					child.y = childYpos;
					child.width = adjustedWidth;
				}
				
				xpos -= ml;
			}
			
			host.dispatchEvent( new Event("layoutComplete") );
			
			return true;
		}
		
		COMPILE::JS
		public function layout():Boolean
		{
			var viewBead:ILayoutHost = (host as ILayoutParent).getLayoutHost();
			var contentView:ILayoutObject = viewBead.contentView;
			
			// set the display on the contentView
			contentView.element.style["display"] = "flex";
			contentView.element.style["flex-flow"] = "row";
			contentView.element.style["align-items"] = "center";
			
			var n:int = contentView.numElements;
			if (n == 0) return false;
			
			for(var i:int=0; i < n; i++) {
				var child:UIBase = contentView.getElementAt(i) as UIBase;
				child.element.style["flex-grow"] = (i == 0) ? "1" : "0";
				child.element.style["flex-shrink"] = "0";
			}
			
			return true;
		}

    }
        
}
