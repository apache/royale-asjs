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
	import org.apache.flex.core.LayoutBase;
	import org.apache.flex.core.IDocument;
	import org.apache.flex.core.ILayoutChild;
	import org.apache.flex.core.ILayoutHost;
	import org.apache.flex.core.ILayoutView;
	import org.apache.flex.core.ILayoutParent;
	import org.apache.flex.core.IParentIUIBase;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.events.Event;
	import org.apache.flex.geom.Rectangle;
	import org.apache.flex.utils.CSSContainerUtils;
	import org.apache.flex.utils.CSSUtils;

    /**
     *  The OneFlexibleChildHorizontalLayout class is a simple layout
     *  bead.  It takes the set of children and lays them out
     *  horizontally in one row, separating them according to
     *  CSS layout rules for margin and padding styles. But it
     *  will size the one child to take up as much or little
     *  room as possible.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class OneFlexibleChildHorizontalLayout extends LayoutBase implements IOneFlexibleChildLayout, IDocument
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function OneFlexibleChildHorizontalLayout()
		{
			super();
		}


        private var _flexibleChild:String;

        private var actualChild:ILayoutChild;

        /**
         *  @private
         *  The document.
         */
        private var document:Object;

		/**
		 *  The id of the flexible child
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get flexibleChild():String
		{
			return _flexibleChild;
		}

		/**
		 * @private
		 */
		public function set flexibleChild(value:String):void
		{
			_flexibleChild = value;
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
		COMPILE::JS
		override public function layout():Boolean
		{
			var contentView:ILayoutView = layoutView;

			actualChild = document[flexibleChild];

			// set the display on the contentView
			contentView.element.style["display"] = "flex";
			contentView.element.style["flex-flow"] = "row";
			contentView.element.style["align-items"] = "center";

			var n:int = contentView.numElements;
			if (n == 0) return false;

			for(var i:int=0; i < n; i++) {
				var child:UIBase = contentView.getElementAt(i) as UIBase;
				child.element.style["flex-grow"] = (child == actualChild) ? "1" : "0";
				child.element.style["flex-shrink"] = "0";
			}

			return true;
		}

		COMPILE::SWF
		override public function layout():Boolean
		{
			var contentView:ILayoutView = layoutView;
			var actualChild:IUIBase = document.hasOwnProperty(flexibleChild) ? document[flexibleChild] : null;

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
			var margins:Object;

			var paddingMetrics:Rectangle = CSSContainerUtils.getPaddingMetrics(host);
			var borderMetrics:Rectangle = CSSContainerUtils.getBorderMetrics(host);

			var xpos:Number = borderMetrics.left - paddingMetrics.left;
			var ypos:Number = borderMetrics.top + paddingMetrics.left;
			var child:IUIBase;
			var childHeight:Number;
			var i:int;
			var childYpos:Number;
			var adjustLeft:Number = 0;
			var adjustRight:Number = hostWidth - borderMetrics.right - paddingMetrics.right;

			// first work from left to right
			for(i=0; i < n; i++)
			{
				child = contentView.getElementAt(i) as IUIBase;
				if (child == null || !child.visible) continue;
				if (child == actualChild) break;

				margins = childMargins(child, hostWidth, hostHeight);
				ilc = child as ILayoutChild;

				xpos += margins.left;

				childYpos = ypos + margins.top; // default y position

				if (!hostSizedToContent) {
					childHeight = child.height;
					if (ilc != null && !isNaN(ilc.percentHeight)) {
						childHeight = (hostHeight-borderMetrics.top-borderMetrics.bottom-paddingMetrics.top-paddingMetrics.bottom) * ilc.percentHeight/100.0;
						ilc.setHeight(childHeight);
					}
					// the following code middle-aligns the child
					childYpos = hostHeight/2 - (childHeight + margins.top + margins.bottom)/2;
				}

				if (ilc) {
					ilc.setX(xpos);
					ilc.setY(childYpos);

					if (!isNaN(ilc.percentWidth)) {
						ilc.setWidth((contentView.width-borderMetrics.left-borderMetrics.right-paddingMetrics.left-paddingMetrics.right) * ilc.percentWidth / 100);
					}

				} else {
					child.x = xpos;
					child.y = childYpos;
				}

				xpos += child.width + margins.right;
				adjustLeft = xpos;
			}

			// then work from right to left
			xpos = hostWidth - borderMetrics.right - paddingMetrics.right;

			for(i=(n-1); actualChild != null && i >= 0; i--)
			{
				child = contentView.getElementAt(i) as IUIBase;
				if (child == null || !child.visible) continue;
				if (child == actualChild) break;

				margins = childMargins(child, hostWidth, hostHeight);
				ilc = child as ILayoutChild;

				childYpos = ypos + margins.top; // default y position

				if (!hostSizedToContent) {
					childHeight = child.height;
					if (ilc != null && !isNaN(ilc.percentHeight)) {
						childHeight = (hostHeight-borderMetrics.top-borderMetrics.bottom-paddingMetrics.top-paddingMetrics.bottom) * ilc.percentHeight/100.0;
						ilc.setHeight(childHeight);
					}
					// the following code middle-aligns the child
					childYpos = hostHeight/2 - (childHeight + margins.top + margins.bottom)/2;
				}

				if (ilc) {
					if (!isNaN(ilc.percentWidth)) {
						ilc.setWidth((contentView.width-borderMetrics.left-borderMetrics.right-paddingMetrics.left-paddingMetrics.right) * ilc.percentWidth / 100);
					}
				}

				xpos -= child.width + margins.right;

				if (ilc) {
					ilc.setX(xpos);
					ilc.setY(childYpos);
				} else {
					child.x = xpos;
					child.y = childYpos;
				}

				xpos -= margins.left;
				adjustRight = xpos;
			}

			// now adjust the actualChild to fill the space.
			if (actualChild != null) {
				margins = childMargins(actualChild, hostWidth, hostHeight);
				ilc = actualChild as ILayoutChild;
				if (!hostSizedToContent) {
					childHeight = actualChild.height;
					if (ilc != null && !isNaN(ilc.percentHeight)) {
						childHeight = (hostHeight-borderMetrics.top-borderMetrics.bottom-paddingMetrics.top-paddingMetrics.bottom) * ilc.percentHeight/100.0;
						ilc.setHeight(childHeight);
					}
				}
				actualChild.y = hostHeight/2 - (childHeight + margins.top + margins.bottom)/2;
				actualChild.x = adjustLeft + margins.left;
				if (ilc) {
					ilc.setWidth((adjustRight-margins.right) - (adjustLeft+margins.left));
				} else {
					actualChild.width = (adjustRight-margins.right) - (adjustLeft+margins.left);
				}
			}

            return true;
		}

        public function setDocument(document:Object, id:String = null):void
        {
            this.document = document;
        }
    }

}
