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
	import org.apache.flex.core.ILayoutHost;
	import org.apache.flex.core.ILayoutView;
	import org.apache.flex.core.ILayoutParent;
	import org.apache.flex.core.IParentIUIBase;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.geom.Rectangle;
	import org.apache.flex.utils.CSSContainerUtils;
	import org.apache.flex.utils.CSSUtils;
	COMPILE::SWF {
			import org.apache.flex.core.UIBase;
	}
    COMPILE::JS {
        import org.apache.flex.core.WrappedHTMLElement;
    }

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
         *  @flexjsignorecoercion HTMLElement
         *  @flexjsignorecoercion org.apache.flex.core.IUIBase
         */
		public function set strand(value:IStrand):void
		{
			host = value as ILayoutChild;
            COMPILE::JS
            {
				var base:IUIBase = value as IUIBase;
				if (base.element.style.display !== "none") {
					base.element.style.display = "block";
				}
            }
		}

        /**
         * @copy org.apache.flex.core.IBeadLayout#layout
         * @flexjsignorecoercion org.apache.flex.core.ILayoutHost
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         */
		public function layout():Boolean
		{
            COMPILE::SWF
            {
				var layoutHost:ILayoutHost = (host as ILayoutParent).getLayoutHost();
				var contentView:ILayoutView = layoutHost.contentView;

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

				var xpos:Number = borderMetrics.left + paddingMetrics.left;
				var ypos:Number = borderMetrics.top + paddingMetrics.left;

				// First pass determines the data about the child.
				for(var i:int=0; i < n; i++)
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

					xpos += ml;

					var childYpos:Number = ypos + mt; // default y position

					if (!hostSizedToContent) {
						var childHeight:Number = child.height;
						if (ilc != null && !isNaN(ilc.percentHeight)) {
							childHeight = (hostHeight-borderMetrics.top-borderMetrics.bottom-paddingMetrics.top-paddingMetrics.bottom) * ilc.percentHeight/100.0;
							ilc.setHeight(childHeight - mt - mb);
						}
						// the following code middle-aligns the child, but since HTML does not
						// do this normally, this code is commented. (Use HorizontalFlexLayout for
						// vertically centered elements in a horizontal row).
//						childYpos = hostHeight/2 - (childHeight + mt + mb)/2;
					}

					if (ilc) {
						ilc.setX(xpos);
						ilc.setY(childYpos);

						if (!isNaN(ilc.percentWidth)) {
							var newWidth:Number = (contentView.width-borderMetrics.left-borderMetrics.right-paddingMetrics.left-paddingMetrics.right) * ilc.percentWidth / 100;
							ilc.setWidth(newWidth - mr - ml);
						}

					} else {
						child.x = xpos;
						child.y = childYpos;
					}

					xpos += child.width + mr;
				}

				host.dispatchEvent( new Event("layoutComplete") );

				return true;

            }
            COMPILE::JS
            {
                var children:Array;
                var i:int;
                var n:int;

                var viewBead:ILayoutHost = (host as ILayoutParent).getLayoutHost();
                var contentView:IParentIUIBase = viewBead.contentView as IParentIUIBase;

				contentView.element.style["white-space"] = "nowrap";

                children = contentView.internalChildren();


                n = children.length;
                for (i = 0; i < n; i++)
                {
                    var child:WrappedHTMLElement = children[i] as WrappedHTMLElement;
					if (child == null) continue;
					child.flexjs_wrapper.setDisplayStyleForLayout('inline-block');
					if (child.style.display !== 'none')
					{
						child.style.display = 'inline-block';
					}
				}
				host.dispatchEvent( new Event("layoutComplete") );
                return true;
            }
		}
	}
}
