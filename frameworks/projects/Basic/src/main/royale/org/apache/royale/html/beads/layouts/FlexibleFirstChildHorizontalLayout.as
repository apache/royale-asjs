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
package org.apache.royale.html.beads.layouts
{
	import org.apache.royale.core.LayoutBase;
	import org.apache.royale.core.IBeadLayout;
    import org.apache.royale.core.IBorderPaddingMarginValuesImpl;
	import org.apache.royale.core.ILayoutChild;
	import org.apache.royale.core.ILayoutView;
    import org.apache.royale.core.ILayoutHost;
	import org.apache.royale.core.ILayoutParent;
	import org.apache.royale.core.IParentIUIBase;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.IViewport;
	import org.apache.royale.core.IViewportModel;
    import org.apache.royale.core.layout.EdgeData;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.geom.Rectangle;
    import org.apache.royale.html.supportClasses.Viewport;
	import org.apache.royale.utils.CSSUtils;

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
     *  @productversion Royale 0.9
     */
	public class FlexibleFirstChildHorizontalLayout extends HorizontalLayout
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
         */
		public function FlexibleFirstChildHorizontalLayout()
		{
			super();
		}

        private var _maxWidth:Number;

        /**
         *  @copy org.apache.royale.core.IBead#maxWidth
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
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
         *  @copy org.apache.royale.core.IBead#maxHeight
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
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
         * @copy org.apache.royale.core.IBeadLayout#layout
         * @royaleignorecoercion org.apache.royale.core.IBorderPaddingMarginValuesImpl
		 * @royaleignorecoercion org.apache.royale.core.UIBase
         */
		COMPILE::SWF
		override public function layout():Boolean
		{
			var contentView:ILayoutView = layoutView;

			var n:Number = contentView.numElements;
			if (n == 0) return false;
			
			// if the layoutView has no width yet, this layout cannot
			// be run successfully, so default to HorizontalLayout.
			if (host.isWidthSizedToContent()) {
				return super.layout();
			}

			var maxWidth:Number = 0;
			var maxHeight:Number = 0;
			var hostSizedToContent:Boolean = host.isHeightSizedToContent();
			var hostWidth:Number = host.width;
			var hostHeight:Number = host.height;

			var ilc:ILayoutChild;
			var data:Object;
			var canAdjust:Boolean = false;

			var paddingMetrics:EdgeData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getPaddingMetrics(host);
			var borderMetrics:EdgeData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getBorderMetrics(host);
			
			// adjust the host's usable size by the metrics. If hostSizedToContent, then the
			// resulting adjusted value may be less than zero.
			hostWidth -= paddingMetrics.left + paddingMetrics.right + borderMetrics.left + borderMetrics.right;
			hostHeight -= paddingMetrics.top + paddingMetrics.bottom + borderMetrics.top + borderMetrics.bottom;

			var xpos:Number = hostWidth + borderMetrics.left + paddingMetrics.left;
			var ypos:Number = borderMetrics.top + paddingMetrics.top;
			var adjustedWidth:Number = 0;

			for(var i:int=(n-1); i >= 0; i--)
			{
				var child:IUIBase = contentView.getElementAt(i) as IUIBase;
				if (child == null || !child.visible) continue;
				var positions:Object = childPositions(child);
				var margins:Object = childMargins(child, hostWidth, hostHeight);

				ilc = child as ILayoutChild;

				var childYpos:Number = ypos + margins.top; // default y position

				var childHeight:Number = child.height;
				if (ilc != null && !isNaN(ilc.percentHeight)) {
					childHeight = hostHeight * ilc.percentHeight/100.0;
					ilc.setHeight(childHeight);
				}
				// the following code middle-aligns the child
				childYpos = hostHeight/2 - childHeight/2;

				if (ilc) {
					if (!isNaN(ilc.percentWidth)) {
						ilc.setWidth(hostWidth * ilc.percentWidth / 100);
					}
				}

				if (i > 0) {
					xpos -= child.width + margins.right;
					adjustedWidth = child.width;
				} else {
					adjustedWidth = xpos - (borderMetrics.left + paddingMetrics.left + margins.left + margins.right);
					xpos = borderMetrics.left + paddingMetrics.left + margins.left;
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

				xpos -= margins.left;
			}

			return true;
		}

		/**
		 * @royaleignorecoercion org.apache.royale.core.UIBase
		 */
		COMPILE::JS
		override public function layout():Boolean
		{
			var contentView:ILayoutView = layoutView;

			// set the display on the contentView
			contentView.element.style["display"] = "flex";
			contentView.element.style["flex-flow"] = "row";
			if (!contentView.element.style["align-items"])
				contentView.element.style["align-items"] = "center";

			var n:int = contentView.numElements;
			if (n == 0) return false;

			for(var i:int=0; i < n; i++) {
				var child:UIBase = contentView.getElementAt(i) as UIBase;
				child.element.style["flex-grow"] = (i == 0) ? "1" : "0";
				child.element.style["flex-shrink"] = "0";
				if (!isNaN(child.percentWidth))
				    child.element.style["flex-basis"] = child.percentWidth.toString() + "%";
			}

			return true;
		}

    }

}
