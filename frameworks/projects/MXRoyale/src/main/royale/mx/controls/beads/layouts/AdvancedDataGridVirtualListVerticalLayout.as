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
package mx.controls.beads.layouts
{
    import org.apache.royale.core.IBorderPaddingMarginValuesImpl;
    import org.apache.royale.core.IDataProviderModel;
    import org.apache.royale.core.IDataProviderVirtualItemRendererMapper;
    import org.apache.royale.core.ILayoutView;
    import org.apache.royale.html.IListPresentationModel;
    import org.apache.royale.core.IScrollingViewport;
    import org.apache.royale.core.IIndexedItemRenderer;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.IStrandWithPresentationModel;
    import org.apache.royale.core.IUIBase;
    import org.apache.royale.core.ValuesManager;
    import org.apache.royale.core.layout.EdgeData;
    import org.apache.royale.events.Event;
    import org.apache.royale.html.beads.IDataGridView;
    import org.apache.royale.html.beads.layouts.VirtualListVerticalLayout;
    import org.apache.royale.html.beads.models.ButtonBarModel;
    import org.apache.royale.html.beads.VirtualDataContainerView;

    import mx.controls.beads.models.DataGridPresentationModel;

    COMPILE::SWF {
        import org.apache.royale.geom.Size;
    }
        
    /**
     *  The AdvancedDataGridVirtualListVerticalLayout class.  It works a bit differently
     *  from other VirtualLayouts for JS because the div padding is applied to the container
     *  of these column lists.  The lists don't scroll, they only update the renderers
     *  for the viewport.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class AdvancedDataGridVirtualListVerticalLayout extends org.apache.royale.html.beads.layouts.VirtualListVerticalLayout
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function AdvancedDataGridVirtualListVerticalLayout()
		{
        }

        override public function set strand(value:IStrand):void
        {
            super.strand = value;
            (IStrandWithPresentationModel(value).presentationModel as DataGridPresentationModel).virtualized = true;
            dataProviderModel.addEventListener("dataProviderChanged", dataProviderChangeHandler);
        }
        
        private function dataProviderChangeHandler(event:Event):void
        {
            var factory:IDataProviderVirtualItemRendererMapper = host.getBeadByType(IDataProviderVirtualItemRendererMapper) as IDataProviderVirtualItemRendererMapper;
            while (visibleIndexes.length)
            {
                var index:int = visibleIndexes.pop();
                factory.freeItemRendererForIndex(index);
            }
        }
        
        private var inLayout:Boolean;
        
        /**
         *  Layout children vertically
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         *  @royaleignorecoercion Array
         *  @royaleignorecoercion org.apache.royale.core.ILayoutHost
         *  @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         *  @royaleignorecoercion org.apache.royale.core.IListPresentationModel
         *  @royaleignorecoercion org.apache.royale.core.IStrandWithPresentationModel
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
                    if (!dp) 
                    {
                        inLayout = false;
                        return true;
                    }
                    var presentationModel:IListPresentationModel = (host as IStrandWithPresentationModel).presentationModel as IListPresentationModel;
                    var widthSizedToContent:Boolean = host.isWidthSizedToContent();
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
                    var viewportTop:Number = getVerticalScrollPosition();
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
                        if (i >= dp.length) continue; // no more renderers needed
                        
                        var ir:IIndexedItemRenderer;
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
                    
                    var view:VirtualDataContainerView = host.getBeadByType(VirtualDataContainerView) as VirtualDataContainerView;
                    view.lastContentSize = new Size(hostWidth, dp.length * presentationModel.rowHeight);
                    
                    inLayout = false;
                    return true;
                }
                COMPILE::JS
                {
                    var hostWidth:Number = host.width;
                    // the strategy for virtualization in JS is to leverage the built-in scrollbars
                    // by creating a topSpacer and bottomSpacer that take up the area that is offscreen
                    // so the scrollbars have the right metrics, then create enough renderers to
                    // show in the visible area.  This code does not recycle renderers, but the
                    // factory can.  This code does try to keep renderers on the DOM that aren't
                    // going off-screen
                    var contentView:ILayoutView = layoutView;
                    var dp:Array = dataProviderModel.dataProvider as Array;
                    if (!dp) 
                    {
                        inLayout = false;
                        return true;
                    }
                    var presentationModel:IListPresentationModel = (host as IStrandWithPresentationModel).presentationModel as IListPresentationModel;
                    var actualRowHeight:Number = presentationModel.rowHeight + presentationModel.separatorThickness;
                    var totalHeight:Number = actualRowHeight * dp.length;
                    var viewportTop:Number = getVerticalScrollPosition();
                    // correct overscroll on Safari?
                    var top:String = host.element.style.top;
                    var c:int = top.indexOf("px");
                    if (c > 0)
                    {
                        var topValue:Number = parseFloat(top.substring(0, c));
                        if (topValue < 0)
                        {
                            trace(host.element.style.top);
                            host.element.style.top = "1px";                            
                        }
                    }
                    // end correct overscroll on Safari
                    var viewportHeight:Number = contentView.element.clientHeight;
                    var startIndex:int = Math.floor(viewportTop / actualRowHeight);
                    var factory:IDataProviderVirtualItemRendererMapper = host.getBeadByType(IDataProviderVirtualItemRendererMapper) as IDataProviderVirtualItemRendererMapper;
                    var endIndex:int = Math.ceil((viewportTop + viewportHeight) / actualRowHeight);
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
                        if (i >= dp.length) continue; // no more renderers needed
                        
                        var ir:IIndexedItemRenderer;
                        if (i < firstIndex)
                        {
                            // the base class adds 1 because the div/scroll padding is in the
                            // same list/datagroup, but for ADG, the padding is outside of the lists
                            ir  = factory.getItemRendererForIndex(i, i - startIndex);
                            ir.element.style.display = "block";
							(ir as IUIBase).width = hostWidth;
                            visibleIndexes.push(i);
                        }
                        else if (i > lastIndex)
                        {
                            ir  = factory.getItemRendererForIndex(i, i - startIndex);
                            ir.element.style.display = "block";
							(ir as IUIBase).width = hostWidth;
                            visibleIndexes.push(i);
                        }
                    }
                    visibleIndexes = visibleIndexes.sort(numberSort);
                    inLayout = false;
                    return true;
                }
        }

        /**
         * @royaleignorecoercion HTMLDivElement
         */
        private function getVerticalScrollPosition():Number
        {
            COMPILE::SWF
            {
                return 0; // to do        
            }
            COMPILE::JS
            {
                return Math.max((host.element.parentNode as HTMLDivElement).scrollTop, 0);
            }
        }
        
        override protected function scrollHandler(e:Event):void
        {
            // don't scroll.  The container of these column lists does the scrolling
        }
        
	}
}
