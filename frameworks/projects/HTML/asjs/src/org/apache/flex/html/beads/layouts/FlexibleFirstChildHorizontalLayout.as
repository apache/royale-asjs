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
    import org.apache.flex.core.ILayoutHost;
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
		public function layout():Boolean
		{
			var layoutParent:ILayoutHost = host.getBeadByType(ILayoutHost) as ILayoutHost;
			var contentView:IParentIUIBase = layoutParent.contentView as IParentIUIBase;
            var padding:Rectangle = CSSContainerUtils.getPaddingMetrics(host);
            var hostSizedToContent:Boolean = host.isHeightSizedToContent();
			
			var n:int = contentView.numElements;
			var marginLeft:Object;
			var marginRight:Object;
			var marginTop:Object;
			var marginBottom:Object;
			var margin:Object;
			maxHeight = 0;
			var verticalMargins:Array = [];
			
            var xx:Number = contentView.width;
            if (isNaN(xx) || xx <= 0)
                return true;
            xx -= padding.right + 1; // some browsers won't layout to the edge
            
            for (var i:int = n - 1; i >= 0; i--)
			{
				var child:IUIBase = contentView.getElementAt(i) as IUIBase;
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
				mt = Number(marginTop);
				if (isNaN(mt))
					mt = 0;
				mb = Number(marginBottom);
				if (isNaN(mb))
					mb = 0;
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
				child.y = mt + padding.top;
				if (i == 0)
                {
                    child.x = ml + padding.left;
                    child.width = xx - mr - child.x;
                }
				else
                    child.x = xx - child.width - mr;
                maxHeight = Math.max(maxHeight, mt + child.height + mb);
				xx -= child.width + mr + ml;
				lastmr = mr;
				var valign:Object = ValuesManager.valuesImpl.getValue(child, "vertical-align");
				verticalMargins.push({ marginTop: mt, marginBottom: mb, valign: valign });
			}
			for (i = 0; i < n; i++)
			{
				var obj:Object = verticalMargins[0]
				child = contentView.getElementAt(i) as IUIBase;
				if (obj.valign == "middle")
					child.y = (maxHeight - child.height) / 2;
				else if (valign == "bottom")
					child.y = maxHeight - child.height - obj.marginBottom;
				else
					child.y = obj.marginTop;
			}
            if (hostSizedToContent)
                ILayoutChild(contentView).setHeight(maxHeight + padding.top + padding.bottom, true);
			
            return true;
		}

    }
        
}
