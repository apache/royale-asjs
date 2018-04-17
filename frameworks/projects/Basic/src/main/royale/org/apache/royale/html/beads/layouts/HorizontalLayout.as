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
     *  The HorizontalLayout class is a simple layout
     *  bead.  It takes the set of children and lays them out
     *  horizontally in one row, separating them according to
     *  CSS layout rules for margin and vertical-align styles.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9
     */
	public class HorizontalLayout extends LayoutBase implements IBeadLayout
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
         */
		public function HorizontalLayout()
		{
			super();
		}

        /**
         *  @copy org.apache.royale.core.IBead#strand
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
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
		 * @royaleignorecoercion org.apache.royale.core.IParentIUIBase
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
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

				var xpos:Number = borderMetrics.left + paddingMetrics.left;
				var ypos:Number = borderMetrics.top + paddingMetrics.top;

				// First pass determines the data about the child.
				for(var i:int=0; i < n; i++)
				{
					var child:IUIBase = contentView.getElementAt(i) as IUIBase;
					if (child == null || !child.visible) continue;
					var positions:Object = childPositions(child);
					var margins:Object = childMargins(child, hostWidth, hostHeight);

					ilc = child as ILayoutChild;

					xpos += margins.left;

					var childYpos:Number = ypos + margins.top; // default y position

					var childHeight:Number = child.height;
					if (ilc != null && !isNaN(ilc.percentHeight)) {
						childHeight = hostHeight * ilc.percentHeight/100.0;
						ilc.setHeight(childHeight);
					}
					var valign:Object = ValuesManager.valuesImpl.getValue(child, "vertical-align");
					if (valign == "middle")
					{
						childYpos = hostHeight/2 - (childHeight + margins.top + margins.bottom)/2;
					}
	
					if (ilc) {
						ilc.setX(xpos);
						ilc.setY(childYpos);

						if (!isNaN(ilc.percentWidth)) {
							var newWidth:Number = hostWidth * ilc.percentWidth / 100;
							ilc.setWidth(newWidth);
						}

					} else {
						child.x = xpos;
						child.y = childYpos;
					}

					xpos += child.width + margins.right;
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
