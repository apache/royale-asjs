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
	import org.apache.royale.core.IBeadLayout;
	import org.apache.royale.core.IBeadModel;
    import org.apache.royale.core.IBorderPaddingMarginValuesImpl;
	import org.apache.royale.core.IDataProviderModel;
	import org.apache.royale.core.IDataProviderVirtualItemRendererMapper;
	import org.apache.royale.core.ILayoutChild;
	import org.apache.royale.core.ILayoutHost;
	import org.apache.royale.core.ILayoutParent;
	import org.apache.royale.core.ILayoutView;
	import org.apache.royale.core.IListPresentationModel;
	import org.apache.royale.core.IListWithPresentationModel;
	import org.apache.royale.core.IParentIUIBase;
    import org.apache.royale.core.IScrollingViewport;
	import org.apache.royale.core.ISelectableItemRenderer;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
    import org.apache.royale.core.layout.EdgeData;
	import org.apache.royale.core.LayoutBase;
	import org.apache.royale.core.ValuesManager;
	COMPILE::JS
	{
		import org.apache.royale.core.WrappedHTMLElement;
	}
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.geom.Rectangle;
    import org.apache.royale.html.beads.VirtualListView;
	import org.apache.royale.utils.CSSUtils;
    COMPILE::SWF {
        import org.apache.royale.geom.Size;
    }
        
	/**
	 *  The VerticalLayout class is a simple layout
	 *  bead.  It takes the set of children and lays them out
	 *  vertically in one column, separating them according to
	 *  CSS layout rules for margin and horizontal-align styles.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class VirtualListVerticalLayout extends LayoutBase implements IBeadLayout
	{
		/**
		 *  Constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
         *  @royaleignorecoercion HTMLDivElement
		 */
		public function VirtualListVerticalLayout()
		{
			super();
		}

        protected var dataProviderModel:IDataProviderModel;

        override public function set strand(value:IStrand):void
        {
            super.strand = value;
            dataProviderModel = host.getBeadByType(IDataProviderModel) as IDataProviderModel;
            COMPILE::JS
            {
                host.element.addEventListener("scroll", scrollHandler);
            }
        }
        
        COMPILE::JS
        private var topSpacer:HTMLDivElement;
        
        COMPILE::JS
        private var bottomSpacer:HTMLDivElement;
        
        private var visibleIndexes:Array = [];
        
        private function scrollHandler(e:Event):void
        {
            layout();
        }
        
        private var inLayout:Boolean;
        
		/**
		 *  Layout children vertically
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 *  @royaleignorecoercion org.apache.royale.core.ILayoutHost
		 *  @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 */
		override public function layout():Boolean
		{
            if (inLayout) return true;
            inLayout = true;
            
			COMPILE::SWF
			{
                // the strategy for virtualization in SWF is based on the
                // fact that we can completely control the scrolling metrics
                // instead of trying to rely on the browsers built-in scrolling.
                // This code puts enough renderers on the screen and then dictates
                // the scrolling metrics.
				var contentView:ILayoutView = layoutView;

				var maxWidth:Number = 0;
				var maxHeight:Number = 0;
                var dp:Array = dataProviderModel.dataProvider as Array;
                var presentationModel:IListPresentationModel = (host as IListWithPresentationModel).presentationModel;
				var hostWidthSizedToContent:Boolean = host.isWidthSizedToContent();
				var hostHeightSizedToContent:Boolean = host.isHeightSizedToContent();
				var hostWidth:Number = host.width;
				var hostHeight:Number = host.height;

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
                
                var viewport:IScrollingViewport = host.getBeadByType(IScrollingViewport) as IScrollingViewport;
                viewport.addEventListener("verticalScrollPositionChanged", scrollHandler);
                var viewportTop:Number = viewport.verticalScrollPosition;
                var viewportHeight:Number = hostHeight;
                var startIndex:int = Math.floor(viewportTop / presentationModel.rowHeight);
                var factory:IDataProviderVirtualItemRendererMapper = host.getBeadByType(IDataProviderVirtualItemRendererMapper) as IDataProviderVirtualItemRendererMapper;
                var endIndex:int = Math.ceil((viewportTop + viewportHeight) / presentationModel.rowHeight);
                var freeIndex:int;
                var firstIndex:int;
                var lastIndex:int;

                if (visibleIndexes.length)
                {
                    if (startIndex < visibleIndexes[0])
                    {
                        // see if we can re-use any renderers
                        freeIndex = visibleIndexes.pop();
                        while (freeIndex >= endIndex)
                        {
                            factory.freeItemRendererForIndex(freeIndex);
                            if (visibleIndexes.length == 0)
                                break;
                            freeIndex = visibleIndexes.pop();
                        }
                        if (visibleIndexes.length)
                            endIndex = visibleIndexes[visibleIndexes.length - 1];
                    }
                    else if (startIndex > visibleIndexes[0])
                    {
                        // see if we can re-use any renderers
                        freeIndex = visibleIndexes.shift();
                        while (freeIndex < startIndex)
                        {
                            factory.freeItemRendererForIndex(freeIndex);
                            if (visibleIndexes.length == 0)
                                break;
                            freeIndex = visibleIndexes.shift();
                        }
                    }
                    else
                    {
                        // see if rows got added or removed because height changed
                        lastIndex = visibleIndexes[visibleIndexes.length - 1];
                        if (lastIndex > endIndex)
                        {
                            // see if we can re-use any renderers
                            freeIndex = visibleIndexes.pop();
                            while (freeIndex > endIndex)
                            {
                                factory.freeItemRendererForIndex(freeIndex);
                                if (visibleIndexes.length == 0)
                                    break;
                                freeIndex = visibleIndexes.pop();
                            }
                            inLayout = false;
                            return true;  // we should be all done if we shrunk
                        }
                    }
                    firstIndex = visibleIndexes[0];
                    lastIndex = visibleIndexes[visibleIndexes.length - 1];
                }
                else
                {
                    firstIndex = dp.length;
                    lastIndex = 0;
                }
                for (var i:int = startIndex; i < endIndex; i++)
                {
                    var ir:ISelectableItemRenderer;
                    if (i < firstIndex)
                    {
                        ir  = factory.getItemRendererForIndex(i, i - startIndex);
                        sizeAndPositionRenderer(ir, xpos, ypos + (presentationModel.rowHeight * i), hostWidth, hostHeight);
                        visibleIndexes.push(i);
                    }
                    else if (i > lastIndex)
                    {
                        ir  = factory.getItemRendererForIndex(i, i - startIndex);
                        sizeAndPositionRenderer(ir, xpos, ypos + (presentationModel.rowHeight * i), hostWidth, hostHeight);
                        visibleIndexes.push(i);
                    }
                }
                visibleIndexes = visibleIndexes.sort(numberSort);

                var view:VirtualListView = host.getBeadByType(VirtualListView) as VirtualListView;
                view.lastContentSize = new Size(hostWidth, dp.length * presentationModel.rowHeight);

                inLayout = false;
				return true;
			}
			COMPILE::JS
			{
                // the strategy for virtualization in JS is to leverage the built-in scrollbars
                // by creating a topSpacer and bottomSpacer that take up the area that is offscreen
                // so the scrollbars have the right metrics, then create enough renderers to
                // show in the visible area.  This code does not recycle renderers, but the
                // factory can.  This code does try to keep renderers on the DOM that aren't
                // going off-screen
                var contentView:ILayoutView = layoutView;
                var dp:Array = dataProviderModel.dataProvider as Array;
                var presentationModel:IListPresentationModel = (host as IListWithPresentationModel).presentationModel;
                var totalHeight:Number = presentationModel.rowHeight * dp.length;
                var viewportTop:Number = Math.max(contentView.element.scrollTop, 0);
                var viewportHeight:Number = contentView.element.clientHeight;
                var startIndex:int = Math.floor(viewportTop / presentationModel.rowHeight);
                var factory:IDataProviderVirtualItemRendererMapper = host.getBeadByType(IDataProviderVirtualItemRendererMapper) as IDataProviderVirtualItemRendererMapper;
                var endIndex:int = Math.ceil((viewportTop + viewportHeight) / presentationModel.rowHeight);
                var freeIndex:int;
                var firstIndex:int;
                var lastIndex:int;
                if (!topSpacer)
                {
                    topSpacer = document.createElement("div") as HTMLDivElement;
                    contentView.element.appendChild(topSpacer);
                }
                topSpacer.style.height = (startIndex * presentationModel.rowHeight).toString() + "px";
                if (visibleIndexes.length)
                {
                    if (startIndex < visibleIndexes[0])
                    {
                        // see if we can re-use any renderers
                        freeIndex = visibleIndexes.pop();
                        while (freeIndex >= endIndex)
                        {
                            factory.freeItemRendererForIndex(freeIndex);
                            if (visibleIndexes.length == 0)
                                break;
                            freeIndex = visibleIndexes.pop();
                        }
                        if (visibleIndexes.length)
                            endIndex = visibleIndexes[visibleIndexes.length - 1];
                    }
                    else if (startIndex > visibleIndexes[0])
                    {
                        // see if we can re-use any renderers
                        freeIndex = visibleIndexes.shift();
                        while (freeIndex < startIndex)
                        {
                            factory.freeItemRendererForIndex(freeIndex);
                            if (visibleIndexes.length == 0)
                                break;
                            freeIndex = visibleIndexes.shift();
                        }
                    }
                    else
                    {
                        // see if rows got added or removed because height changed
                        lastIndex = visibleIndexes[visibleIndexes.length - 1];
                        if (lastIndex > endIndex)
                        {
                            // see if we can re-use any renderers
                            freeIndex = visibleIndexes.pop();
                            while (freeIndex > endIndex)
                            {
                                factory.freeItemRendererForIndex(freeIndex);
                                if (visibleIndexes.length == 0)
                                    break;
                                freeIndex = visibleIndexes.pop();
                            }
                            inLayout = false;
                            return true;  // we should be all done if we shrunk
                        }
                    }
                    firstIndex = visibleIndexes[0];
                    lastIndex = visibleIndexes[visibleIndexes.length - 1];
                }
                else
                {
                    firstIndex = dp.length;
                    lastIndex = 0;
                }
                for (var i:int = startIndex; i < endIndex; i++)
                {
                    var ir:ISelectableItemRenderer;
                    if (i < firstIndex)
                    {
                       ir  = factory.getItemRendererForIndex(i, i - startIndex + 1);
                       ir.element.style.display = "block";
                       visibleIndexes.push(i);
                    }
                    else if (i > lastIndex)
                    {
                        ir  = factory.getItemRendererForIndex(i, i - startIndex + 1);
                        ir.element.style.display = "block";
                        visibleIndexes.push(i);
                    }
                }
                visibleIndexes = visibleIndexes.sort(numberSort);
                if (!bottomSpacer)
                {
                    bottomSpacer = document.createElement("div") as HTMLDivElement;
                    contentView.element.appendChild(bottomSpacer);
                }
                bottomSpacer.style.height = ((dp.length - endIndex) * presentationModel.rowHeight).toString() + "px";  
                inLayout = false;
				return true;
			}
		}
        
        public function numberSort(a:int, b:int):int
        {
            return a - b;
        }

        COMPILE::SWF
        private function sizeAndPositionRenderer(ir:ISelectableItemRenderer, xpos:Number, ypos:Number, hostWidth:Number, hostHeight:Number):void
        {
            var ilc:ILayoutChild;
            var positions:Object = childPositions(ir);
            var margins:Object = childMargins(ir, hostWidth, hostHeight);
            
            ilc = ir as ILayoutChild;
            var child:IUIBase = ir as IUIBase;
            
            ypos += margins.top;
            
            var childXpos:Number = xpos + margins.left; // default x position
            
            var childWidth:Number = child.width;
            if (ilc != null && !isNaN(ilc.percentWidth)) {
                childWidth = hostWidth * ilc.percentWidth/100.0;
                ilc.setWidth(childWidth);
            }
            else if (ilc.isWidthSizedToContent() && !margins.auto)
            {
                childWidth = hostWidth;
                ilc.setWidth(childWidth);
            }
            if (margins.auto)
                childXpos = (hostWidth - childWidth) / 2;
            
            if (ilc) {
                ilc.setX(childXpos);
                ilc.setY(ypos);
                
                if (!isNaN(ilc.percentHeight)) {
                    var newHeight:Number = hostHeight * ilc.percentHeight / 100;
                    ilc.setHeight(newHeight);
                }
                
            } else {
                child.x = childXpos;
                child.y = ypos;
            }
            
            ypos += child.height + margins.bottom;
        }
	}
}
