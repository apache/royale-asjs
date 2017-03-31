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
	import org.apache.flex.core.IStyleableObject;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.events.Event;
	import org.apache.flex.geom.Rectangle;
	import org.apache.flex.utils.CSSContainerUtils;
	import org.apache.flex.utils.CSSUtils;

    /**
     *  The OneFlexibleChildVerticalLayout class is a simple layout
     *  bead.  It takes the set of children and lays them out
     *  vertically in one column, separating them according to
     *  CSS layout rules for margin and padding styles. But it
     *  will size the one child to take up as much or little
     *  room as possible.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class OneFlexibleChildVerticalLayout extends LayoutBase implements IOneFlexibleChildLayout, IDocument
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function OneFlexibleChildVerticalLayout()
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
			contentView.element.style["flex-flow"] = "column";
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
			var childWidth:Number;
			var i:int;
			var childXpos:Number;
			var adjustTop:Number = 0;
			var adjustBottom:Number = hostHeight - borderMetrics.top - paddingMetrics.bottom;

			// first work from top to bottom
			for(i=0; i < n; i++)
			{
				child = contentView.getElementAt(i) as IUIBase;
				if (child == null || !child.visible) continue;
				if (child == actualChild) break;

				margins = childMargins(child, hostWidth, hostHeight);
				ilc = child as ILayoutChild;

				ypos += margins.top;

				childXpos = xpos + margins.left; // default y position

				if (!hostSizedToContent) {
					childWidth = child.width;
					if (ilc != null && !isNaN(ilc.percentWidth)) {
						childWidth = (hostWidth-borderMetrics.left-borderMetrics.right-paddingMetrics.left-paddingMetrics.right) * ilc.percentWidth/100.0;
						ilc.setWidth(childWidth);
					}
					// the following code middle-aligns the child
					childXpos = hostWidth/2 - (childWidth + margins.left + margins.right)/2;
				}

				if (ilc) {
					ilc.setX(childXpos);
					ilc.setY(ypos);

					if (!isNaN(ilc.percentHeight)) {
						ilc.setHeight((contentView.height-borderMetrics.top-borderMetrics.bottom-paddingMetrics.top-paddingMetrics.bottom) * ilc.percentHeight / 100);
					}

				} else {
					child.x = childXpos;
					child.y = ypos;
				}

				ypos += child.height + margins.bottom;
				adjustTop = ypos;
			}

			// then work from bottom to top
			ypos = hostHeight - borderMetrics.bottom - paddingMetrics.bottom;

			for(i=(n-1); actualChild != null && i >= 0; i--)
			{
				child = contentView.getElementAt(i) as IUIBase;
				if (child == null || !child.visible) continue;
				if (child == actualChild) break;

				margins = childMargins(child, hostWidth, hostHeight);
				ilc = child as ILayoutChild;

				childXpos = xpos + margins.left; // default y position

				if (!hostSizedToContent) {
					childWidth = child.width;
					if (ilc != null && !isNaN(ilc.percentWidth)) {
						childWidth = (hostWidth-borderMetrics.left-borderMetrics.right-paddingMetrics.left-paddingMetrics.right) * ilc.percentWidth/100.0;
						ilc.setWidth(childWidth);
					}
					// the following code middle-aligns the child
					childXpos = hostWidth/2 - (childWidth + margins.left + margins.right)/2;
				}

				if (ilc) {
					if (!isNaN(ilc.percentHeight)) {
						ilc.setHeight((contentView.height-borderMetrics.top-borderMetrics.bottom-paddingMetrics.top-paddingMetrics.bottom) * ilc.percentHeight / 100);
					}
				}

				ypos -= child.height + margins.bottom;

				if (ilc) {
					ilc.setX(childXpos);
					ilc.setY(ypos);
				} else {
					child.x = childXpos;
					child.y = ypos;
				}

				ypos -= margins.top;
				adjustBottom = ypos;
			}

			// now adjust the actualChild to fill the space.
			if (actualChild != null) {
				margins = childMargins(actualChild, hostWidth, hostHeight);
				ilc = actualChild as ILayoutChild;
				if (!hostSizedToContent) {
					childWidth = actualChild.width;
					if (ilc != null && !isNaN(ilc.percentWidth)) {
						childWidth = (hostWidth-borderMetrics.left-borderMetrics.right-paddingMetrics.left-paddingMetrics.right) * ilc.percentWidth/100.0;
						ilc.width = childWidth;
					}
				}
				actualChild.x = hostWidth/2 - (childWidth + margins.left + margins.right)/2;
				actualChild.y = adjustTop + margins.top;
				if (ilc) {
					ilc.setHeight((adjustBottom-margins.bottom) - (adjustTop+margins.top));
				} else {
					actualChild.height = (adjustBottom-margins.bottom) - (adjustTop+margins.top);
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
