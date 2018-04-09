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
	import org.apache.royale.core.IBeadModel;
    import org.apache.royale.core.IBorderPaddingMarginValuesImpl;
	import org.apache.royale.core.ILayoutChild;
	import org.apache.royale.core.ILayoutHost;
	import org.apache.royale.core.ILayoutView;
	import org.apache.royale.core.ILayoutParent;
	import org.apache.royale.core.IParentIUIBase;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
    import org.apache.royale.core.layout.EdgeData;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.geom.Rectangle;
	import org.apache.royale.utils.CSSUtils;
	COMPILE::SWF {
			import org.apache.royale.core.UIBase;
	}
    COMPILE::JS {
        import org.apache.royale.core.WrappedHTMLElement;
    }

    /**
	 *  The HorizontalLayoutWithPaddingAndGap class is a simple layout
	 *  bead similar to HorizontalLayout, but it adds support for
	 *  padding and gap values.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class HorizontalLayoutWithPaddingAndGap extends LayoutBase implements IBeadLayout
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function HorizontalLayoutWithPaddingAndGap()
		{
			super();
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
		 *  @productversion Royale 0.0
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
		 *  @productversion Royale 0.0
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
		 *  @productversion Royale 0.0
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
		 *  @productversion Royale 0.0
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

		/**
		 *  @private
		 */
		private var _gap:Number = 0;

		/**
		 *  The gap between items.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
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
			_gap = value;
		}

        /**
         *  @copy org.apache.royale.core.IBead#strand
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         *  @royaleignorecoercion HTMLElement
         *  @royaleignorecoercion org.apache.royale.core.IUIBase
         */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			
            COMPILE::JS
            {
				var base:IUIBase = value as IUIBase;
				if (base.element.style.display !== "none") {
					base.element.style.display = "block";
				}
            }
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
                var children:Array;
                var i:int;
                var n:int;
				var contentView:IParentIUIBase = layoutView as IParentIUIBase;

				contentView.element.style["white-space"] = "nowrap";

                children = contentView.internalChildren();


                n = children.length;
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
					child.royale_wrapper.setDisplayStyleForLayout('inline-block');
					if (child.style.display !== 'none')
					{
						child.style.display = 'inline-block';
					}
				}

                return true;
            }
		}
	}
}
