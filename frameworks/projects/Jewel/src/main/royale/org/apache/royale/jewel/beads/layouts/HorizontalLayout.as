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
	COMPILE::JS {
        import org.apache.royale.core.UIBase;
        import org.apache.royale.core.WrappedHTMLElement;
    }
	import org.apache.royale.core.IBorderPaddingMarginValuesImpl;
	import org.apache.royale.core.ILayoutChild;
	import org.apache.royale.core.ILayoutView;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.core.layout.EdgeData;
	import org.apache.royale.core.layout.ILayoutStyleProperties;
	import org.apache.royale.events.Event;

    /**
	 *  The HorizontalLayout class is a simple layout
	 *  bead similar to HorizontalLayout, but it adds support for
	 *  padding and gap values.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
     */
	public class HorizontalLayout extends SimpleHorizontalLayout implements ILayoutStyleProperties
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		public function HorizontalLayout()
		{
			super();
		}

		/**
		 * @royalesuppresspublicvarwarning
		 */
		public static const LAYOUT_TYPE_NAMES:String = "layout horizontal";

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

			COMPILE::JS
			{
				applyStyleToLayout(hostComponent, "gap");
				setGap(_gap);
			}
		}

		/**
		 *  @private
		 */
		private var _paddingTop:Number = 0;

		/**
		 *  The top padding value.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get paddingTop():Number
		{
			return _paddingTop;
		}

		/**
		 *  @private
		 */
		public function set paddingTop(value:Number):void
		{
			_paddingTop = value;
		}

		/**
		 *  @private
		 */
		private var _paddingRight:Number = 0;

		/**
		 *  The right padding value.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get paddingRight():Number
		{
			return _paddingRight;
		}

		/**
		 *  @private
		 */
		public function set paddingRight(value:Number):void
		{
			_paddingRight = value;
		}

		/**
		 *  @private
		 */
		private var _paddingBottom:Number = 0;

		/**
		 *  The top padding value.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get paddingBottom():Number
		{
			return _paddingBottom;
		}

		/**
		 *  @private
		 */
		public function set paddingBottom(value:Number):void
		{
			_paddingBottom = value;
		}

		/**
		 *  @private
		 */
		private var _paddingLeft:Number = 0;

		/**
		 *  The left padding value.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get paddingLeft():Number
		{
			return _paddingLeft;
		}

		/**
		 *  @private
		 */
		public function set paddingLeft(value:Number):void
		{
			_paddingLeft = value;
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
		// 		hostClassList.add("gap");
		// 	else
		// 		hostClassList.remove("gap");
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
		public function applyStyleToLayout(component:IUIBase, cssProperty:String):void
		{	
			var cssValue:* = ValuesManager.valuesImpl.getValue(component, cssProperty);
			if (cssValue !== undefined)
			{
				switch(cssProperty)
				{
					case "gap":
						if(!gapInitialized)
							gap = Number(cssValue);
						break;
					case "itemsVerticalAlign":
						if(!itemsVerticalAlignInitialized)
							itemsVerticalAlign = cssValue;
						break;
					case "itemsHorizontalAlign":
						if(!itemsHorizontalAlignInitialized)
							itemsHorizontalAlign = cssValue;
						break;
					default:
						break;
				}	
			}
		}

		// number of gap styles available in CSS @see $gaps variable in _layout.sass
		public static const GAPS:Number = 10;
		// gap step size in each gap style rule in CSS @see $gap-step variable in _layout.sass
		public static const GAP_STEP:Number = 3;

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
			if (value >= 0 && value <= GAPS*GAP_STEP)
			{
				if (hostClassList.contains("gap-" + _gap + "x" + GAP_STEP + "px"))
					hostClassList.remove("gap-" + _gap + "x" + GAP_STEP + "px");
				if(value != 0)
					hostClassList.add("gap-" + value + "x" + GAP_STEP + "px");
			} else
				throw new Error("Gap needs to be between 0 and " + GAPS*GAP_STEP);
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

				var paddingMetrics:EdgeData = new EdgeData();
                paddingMetrics.left = _paddingLeft;
                paddingMetrics.top = _paddingTop;
                paddingMetrics.right = _paddingRight;
                paddingMetrics.bottom = _paddingBottom;
				var borderMetrics:EdgeData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getBorderMetrics(host);
				
				// adjust the host's usable size by the metrics. If hostSizedToContent, then the
				// resulting adjusted value may be less than zero.
				hostWidth -= paddingMetrics.left + paddingMetrics.right + borderMetrics.left + borderMetrics.right;
				hostHeight -= paddingMetrics.top + paddingMetrics.bottom + borderMetrics.top + borderMetrics.bottom;

				var xpos:Number = borderMetrics.left + paddingMetrics.left;
				var ypos:Number = borderMetrics.top + paddingMetrics.top;

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
				//applyStyleToLayout(c, "gap");

				/*var children:Array = contentView.internalChildren();
				var i:int;
				var n:int = children.length;
				for (i = 0; i < n; i++)
                {
                    var child:WrappedHTMLElement = children[i] as WrappedHTMLElement;
					if (child == null) continue;
					child.style.marginTop = _paddingTop + 'px';
					if(i === (n - 1))
					{
						child.style.marginRight = _paddingRight + 'px';
					}
					else
					{
						child.style.marginRight = '0px';
					}
					child.style.marginBottom = _paddingBottom + 'px';
					if(i == 0)
					{
						child.style.marginLeft = _paddingLeft + 'px';
					}
					else
					{
						child.style.marginLeft = _gap + 'px';
					}					
				}*/

                return true;
            }
		}
	}
}
