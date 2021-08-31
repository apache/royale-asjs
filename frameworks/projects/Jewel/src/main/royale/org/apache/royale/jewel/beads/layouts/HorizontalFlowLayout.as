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
package org.apache.royale.jewel.beads.layouts
{
	COMPILE::SWF {
	import org.apache.royale.core.IBorderPaddingMarginValuesImpl;
	import org.apache.royale.core.ILayoutChild;
	import org.apache.royale.core.ILayoutView;
	import org.apache.royale.core.layout.EdgeData;
	}
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.core.layout.ILayoutStyleProperties;
	import org.apache.royale.events.Event;

    /**
	 *  The HorizontalFlowLayout class is a simple layout
	 *  bead similar to HorizontalLayout, but it adds support for
	 *  padding and gap values.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
     */
	public class HorizontalFlowLayout extends SimpleHorizontalLayout implements ILayoutStyleProperties
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		public function HorizontalFlowLayout()
		{
			super();
		}

		/**
		 * @royalesuppresspublicvarwarning
		 */
		public static const LAYOUT_TYPE_NAMES:String = "layout horizontal flow";

		/**
		 *  Add class selectors when the component is addedToParent
		 *  Otherwise component will not get the class selectors when 
		 *  perform "removeElement" and then "addElement"
		 * 
 		 *  @langversion 3.0
 		 *  @playerversion Flash 10.2
 		 *  @playerversion AIR 2.6
 		 *  @productversion Royale 0.9.4
 		 */
		override public function beadsAddedHandler(event:Event = null):void
		{
			super.beadsAddedHandler();

			hostComponent.replaceClass("flow");
			
			applyStyleToLayout(hostComponent, "gap");
			
			COMPILE::JS
			{
			setGap(_gap);
			}
		}

		private var gapInitialized:Boolean;
		// private var _gap:Boolean;
		/**
		 *  Assigns variable gap to grid from 1 to 20
		 *  Activate "gap-Xdp" effect selector to set a numeric gap 
		 *  between grid cells
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		// public function get gap():Boolean
        // {
        //     return _gap;
        // }

		// /**
		//  *  @private
		//  */
		// public function set gap(value:Boolean):void
		// {
		// 	if (_gap != value)
        //     {
		// 		COMPILE::JS
		// 		{
		// 			if(hostComponent)
		// 				setGap(value);
					
		// 			_gap = value;
		// 			gapInitialized = true;
		// 		}
        //     }
		// }

		// COMPILE::JS
		// private function setGap(value:Boolean):void
		// {
		// 	if (value)
		// 		hostComponent.addClass("gap");
		// 	else
		// 		hostComponent.removeClass("gap");
		// }

		/**
		 *  Get the component layout style and apply to if exists
		 * 
		 *  @param component the IUIBase component that host this layout
		 *  @param cssProperty the style property in css set for the component to retrieve
		 * 
		 *  @see org.apache.royale.core.layout.ILayoutStyleProperties#applyStyleToLayout(component:IUIBase, cssProperty:String):void
		 * 
 		 *  @langversion 3.0
 		 *  @playerversion Flash 10.2
 		 *  @playerversion AIR 2.6
 		 *  @productversion Royale 0.9.4
 		 */
		override public function applyStyleToLayout(component:IUIBase, cssProperty:String):void
		{
			super.applyStyleToLayout(component, cssProperty);

			var cssValue:* = ValuesManager.valuesImpl.getValue(component, cssProperty);
			if (cssValue !== undefined)
			{
				switch(cssProperty)
				{
					case "gap":
						if(!gapInitialized)
							gap = Number(cssValue);
						break;
					default:
						break;
				}	
			}
		}

		protected var _gap:Number = 0;
		/**
		 *  Assigns variable gap in steps of GAP_STEP. You have available GAPS*GAP_STEP gap styles
		 *  Activate "gap-{X}x{GAP_STEP}px" effect selector to set a numeric gap between elements.
		 *  i.e: gap-2x3px will result in a gap of 6px
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get gap():Number
        {
            return _gap;
        }

		/**
		 *  @private
		 */
		public function set gap(value:Number):void
		{
			if (_gap != value)
            {
				COMPILE::JS
				{
					if(hostComponent)
						setGap(value);
					
					_gap = value;
					gapInitialized = true;
				}
            }
		}

		COMPILE::JS
		private function setGap(value:Number):void
		{
			if (value >= 0 && value <= GapConstants.GAPS)
			{
				if (hostComponent.containsClass("gap-" + _gap + "x" + GapConstants.GAP_STEP + "px"))
					hostComponent.removeClass("gap-" + _gap + "x" + GapConstants.GAP_STEP + "px");
				if(value != 0)
					hostComponent.addClass("gap-" + value + "x" + GapConstants.GAP_STEP + "px");
			} else
				throw new Error("Gap needs to be between 0 and " + GapConstants.GAPS);
		}
		
        /**
         * @copy org.apache.royale.core.IBeadLayout#layout
         * @royaleignorecoercion org.apache.royale.core.ILayoutHost
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         * @royaleignorecoercion org.apache.royale.core.IBorderPaddingMarginValuesImpl
         */
		override public function layout():Boolean
		{
            COMPILE::SWF
            {
				var contentView:ILayoutView = layoutView;

				var n:Number = contentView.numElements;
				if (n == 0) return false;

				var maxWidth:Number = 0;
				var maxHeight:Number = 0;
				var hostWidthSizedToContent:Boolean = host.isWidthSizedToContent();
				var hostHeightSizedToContent:Boolean = host.isHeightSizedToContent();
				var hostWidth:Number = hostWidthSizedToContent ? 0 : contentView.width;
				var hostHeight:Number = hostHeightSizedToContent ? 0 : contentView.height;

				var ilc:ILayoutChild;
				var data:Object;
				var canAdjust:Boolean = false;

				// var paddingMetrics:EdgeData = new EdgeData();
                // paddingMetrics.left = _paddingLeft;
                // paddingMetrics.top = _paddingTop;
                // paddingMetrics.right = _paddingRight;
                // paddingMetrics.bottom = _paddingBottom;
				// var borderMetrics:EdgeData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getBorderMetrics(host);
				
				// adjust the host's usable size by the metrics. If hostSizedToContent, then the
				// resulting adjusted value may be less than zero.
				hostWidth -= 0;//paddingMetrics.left + paddingMetrics.right + borderMetrics.left + borderMetrics.right;
				hostHeight -= 0;//paddingMetrics.top + paddingMetrics.bottom + borderMetrics.top + borderMetrics.bottom;

				var xpos:Number = 0;// borderMetrics.left + paddingMetrics.left;
				var ypos:Number = 0;//borderMetrics.top + paddingMetrics.top;

				// First pass determines the data about the child.
				for(var i:int=0; i < n; i++)
				{
					var child:IUIBase = contentView.getElementAt(i) as IUIBase;
					if (child == null || !child.visible) continue;
					var positions:Object = childPositions(child);

					ilc = child as ILayoutChild;

					var childYpos:Number = ypos; // default y position

					if (!hostHeightSizedToContent) {
						var childHeight:Number = child.height;
						if (ilc != null && !isNaN(ilc.percentHeight)) {
							childHeight = hostHeight * ilc.percentHeight/100.0;
							ilc.setHeight(childHeight);
						}
						// the following code middle-aligns the child, but since HTML does not
						// do this normally, this code is commented. (Use HorizontalFlexLayout for
						// vertically centered elements in a horizontal row).
						//						childYpos = hostHeight/2 - (childHeight + mt + mb)/2;
					}

					if (ilc) {
						ilc.setX(xpos);
						ilc.setY(childYpos);

						if (!hostWidthSizedToContent && !isNaN(ilc.percentWidth)) {
							var newWidth:Number = hostWidth * ilc.percentWidth / 100;
							ilc.setWidth(newWidth);
						}

					} else {
						child.x = xpos;
						child.y = childYpos;
					}

					xpos += child.width + _gap;
				}

				return true;

            }
            COMPILE::JS
            {
				super.layout();

                return true;
            }
		}
	}
}
