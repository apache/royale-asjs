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
    import mx.controls.beads.DataGridView;
    import mx.controls.beads.models.DataGridPresentationModel;
    import mx.controls.dataGridClasses.DataGridColumn;
    import mx.core.ScrollControlBase;
    import mx.core.ScrollPolicy;
    
    import org.apache.royale.core.IBorderPaddingMarginValuesImpl;
    import org.apache.royale.core.IUIBase;
    import org.apache.royale.core.UIBase;
    import org.apache.royale.core.IDataGridModel;
    import org.apache.royale.core.ValuesManager;
    import org.apache.royale.core.layout.EdgeData;
    import org.apache.royale.html.beads.IDataGridView;
    import org.apache.royale.html.beads.layouts.DataGridLayout;
    import org.apache.royale.html.beads.models.ButtonBarModel;
    import org.apache.royale.html.IListPresentationModel;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.IStrandWithPresentationModel;
    import org.apache.royale.events.Event;
    /**
     *  The DataGridLayout class.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class DataGridLayout extends org.apache.royale.html.beads.layouts.DataGridLayout
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function DataGridLayout()
		{
        }

        COMPILE::JS
        protected var scrollListening:Boolean;

        COMPILE::JS
        protected var spacer:HTMLDivElement;



        public var firstVisibleIndex:int;

        public var lastVisibleIndex:int;

        public var maxVerticalScrollPosition:Number;

        public var actualRowHeight:Number;

        COMPILE::JS
        private var _deferred:Boolean;
        protected function scrollHandler(e:Event):void
        {
            COMPILE::JS{
                (uiHost.view as DataGridView).header.element.scrollLeft = (uiHost.view as DataGridView).listArea.element.scrollLeft;
                if (_deferred) return;
                //this seems necessary for some browsers:
                requestAnimationFrame(layout);
                _deferred = true;
            }
            COMPILE::SWF{
                layout();
            }

        }

        override protected function getColumnsForLayout():Array
        {
            var view:DataGridView = (uiHost.view as DataGridView);
            return view.visibleColumns;    
        }
        
        override protected function setHeaderWidths(columnWidths:Array):void
        {
            var ww:Number = 0;
            for (var i:int = 0; i < columnWidths.length; i++)
            {
                ww += columnWidths[i];
            }
            var view:DataGridView = (uiHost.view as DataGridView);
            if (ww < view.listArea.width)
            {
                // fudge last column if it has a gap for the vertical scrollbar
                // so it will appear flush with right border if
                // vertical scrollbar is showing
                COMPILE::JS
                {
                    if (view.listArea.element.offsetWidth > view.listArea.element.clientWidth)
                    {
                        columnWidths[columnWidths.length - 1] += view.listArea.element.offsetWidth - 
                            view.listArea.element.clientWidth;
                    }
                }
            } else {
                COMPILE::JS
                {
                    if ((uiHost as ScrollControlBase).horizontalScrollPolicy != mx.core.ScrollPolicy.OFF) {
                        columnWidths[columnWidths.length - 1] += view.listArea.element.offsetWidth -
                                view.listArea.element.clientWidth;
                    }

                }
            }
            
            super.setHeaderWidths(columnWidths);
        }


        protected function scrollPolicyChangedHandler(event:Event):void{
       /*
            //temp
            var policy:String = event.type.substr(0,event.type.indexOf('Changed'));
            trace(policy, uiHost[policy])*/

            if (event.type == 'verticalScrollPolicyChanged') {
                //if the recent change was to 'off' then reset the scroll position to top to match what Flex does
                if ((uiHost as ScrollControlBase).verticalScrollPolicy == ScrollPolicy.OFF) {
                    //reset the scroll top
                    var listArea:IUIBase = (uiHost.view as IDataGridView).listArea;
                    COMPILE::JS{
                        listArea.element.scrollTop = 0;
                    }
                }
            }
            layout();
            if (event.type == 'horizontalScrollPolicyChanged') {
                //request re-render of the vertical column lines for the listArea
                uiHost.dispatchEvent(new Event("renderColumnsNeeded"))
            }
        }

        /**
         * @copy org.apache.royale.core.IBeadLayout#layout
         * @royaleignorecoercion org.apache.royale.core.IBorderPaddingMarginValuesImpl
         * @royaleignorecoercion org.apache.royale.core.IDataGridModel
         * @royaleignorecoercion org.apache.royale.core.IUIBase
         * @royaleignorecoercion org.apache.royale.core.UIBase
         * @royaleignorecoercion org.apache.royale.html.beads.IDataGridView
         * @royaleignorecoercion org.apache.royale.html.beads.models.ButtonBarModel
         * @royaleignorecoercion org.apache.royale.html.supportClasses.IDataGridColumn
         */
        override public function layout():Boolean
        {
            COMPILE::JS
            {
                if (!scrollListening) {
                    (uiHost.view as IDataGridView).listArea.element.addEventListener("scroll", scrollHandler);
                    uiHost.addEventListener('horizontalScrollPolicyChanged', scrollPolicyChangedHandler);
                    uiHost.addEventListener('verticalScrollPolicyChanged', scrollPolicyChangedHandler);
                    scrollListening = true;
                }
                _deferred = false;

            }
            var presentationModel:DataGridPresentationModel = (uiHost as IStrandWithPresentationModel).presentationModel as DataGridPresentationModel;
            var view:DataGridView = (uiHost.view as DataGridView);
            // do the proportional sizing of columns
            var borderMetrics:EdgeData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getBorderMetrics(_strand as IUIBase);			
            var useWidth:Number = uiHost.width - (borderMetrics.left + borderMetrics.right);
            var useHeight:Number = uiHost.height - (borderMetrics.top + borderMetrics.bottom);
            
            var totalWidths:Number = 0;
            var unspecifiedWidths:int = 0;
            var vScrollbarWidth:Number = 0;
            COMPILE::JS{
                vScrollbarWidth = view.listArea.element.offsetWidth - view.listArea.element.clientWidth;
            }

            if (view.visibleColumns)
            {
                for(var i:int=0; i < view.visibleColumns.length; i++) {
                    var columnDef:DataGridColumn = view.visibleColumns[i] as DataGridColumn;
                    if (!isNaN(columnDef.width))
                        totalWidths += columnDef.width;
                    else
                        unspecifiedWidths++;
                }
            }
            else
            {
                return true;
            }
            
            if ((uiHost as ScrollControlBase).horizontalScrollPolicy == ScrollPolicy.OFF ||
                totalWidths < useWidth)
            {
                if (unspecifiedWidths > 0 && totalWidths > 0)
                {
                    // some widths are specified, others are not, so fit the unspecified
                    // in the remaining space
                    var remainingSpace:Number = useWidth - totalWidths;
                    var proportionateShare:Number = remainingSpace / unspecifiedWidths;
                    for(i=0; i < view.visibleColumns.length; i++) {
                        columnDef = view.visibleColumns[i] as DataGridColumn;
                        if (!isNaN(columnDef.width))
                            columnDef.columnWidth = columnDef.width;
                        else
                            columnDef.columnWidth = proportionateShare;
                    }                
                }
                else if (totalWidths > 0)
                {


                    var factor:Number = totalWidths != useWidth ? useWidth / totalWidths : 1;
                    for(i=0; i < view.visibleColumns.length; i++) {
                        columnDef = view.visibleColumns[i] as DataGridColumn;
                        columnDef.columnWidth = columnDef.width * factor;
                    }

                }
            }
            
            // not an else clause because we want to go into this if we can scroll
            // horizontally after the earlier clause scaled column widths to fit if
            // they were too small.
            if ((uiHost as ScrollControlBase).horizontalScrollPolicy != ScrollPolicy.OFF)
            {
                COMPILE::JS
                {
                   view.header.element.scrollLeft = view.listArea.element.scrollLeft;
                }
                if (totalWidths < useWidth - vScrollbarWidth)
                {
                    // this loop should prevent totalWidth < useWidth next time through
                    for(i=0; i < view.visibleColumns.length; i++) {
                        columnDef = view.visibleColumns[i] as DataGridColumn;
                        columnDef.width = columnDef.columnWidth;
                    }                
                }
                else
                {
                    // this loop should prevent totalWidth < useWidth next time through
                    for(i=0; i < view.visibleColumns.length; i++) {
                        columnDef = view.visibleColumns[i] as DataGridColumn;
                        columnDef.columnWidth = columnDef.width;
                    }
                    if (totalWidths == useWidth && vScrollbarWidth) {
                        //columnDef is the last column from the above loop:
                        columnDef.columnWidth -= vScrollbarWidth;
                    }
                }
            }

            var retval:Boolean = super.layout();

           /* COMPILE::JS
            {
                if (!uiHost.isHeightSizedToContent())
                {
                    if (uiHost.element.style["overflow-x"] == "hidden")
                        (uiHost.view as IDataGridView).listArea.element.style["overflow-x"] = "hidden";
                }
            }*/

            if (!uiHost.isHeightSizedToContent())
            {
                var header:IUIBase = (uiHost.view as IDataGridView).header;
        //        var bbmodel:ButtonBarModel = header.getBeadByType(ButtonBarModel) as ButtonBarModel;
                // do the proportional sizing of columns
                /*var borderMetrics:EdgeData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getBorderMetrics(_strand as IUIBase);
                var useWidth:Number = uiHost.width - (borderMetrics.left + borderMetrics.right);
                var useHeight:Number = uiHost.height - (borderMetrics.top + borderMetrics.bottom) - header.height - 1;
                */
                useHeight = useHeight - header.height - 1
                var displayedColumns:Array = (uiHost.view as IDataGridView).columnLists;
                if (!displayedColumns) return retval;
                var n:int = displayedColumns.length;
                var listArea:IUIBase = (uiHost.view as IDataGridView).listArea;
                actualRowHeight = presentationModel.rowHeight
                        + presentationModel.separatorThickness;
                COMPILE::JS
                {
                    firstVisibleIndex = Math.floor(listArea.element.scrollTop / actualRowHeight);
                    var scrollTop:Number = listArea.element.scrollTop;
                    var topSpacerHeight:Number = Math.floor(listArea.element.scrollTop / actualRowHeight)
                            * actualRowHeight;
                }
                var model:IDataGridModel = uiHost.model as IDataGridModel;
                if (model.dataProvider && model.dataProvider.length)
                {
                    var totalHeight:Number = model.dataProvider.length * actualRowHeight;
                    maxVerticalScrollPosition = totalHeight - useHeight;
                    COMPILE::JS
                    {
                        if (!spacer)
                        {
                            spacer = document.createElement("div") as HTMLDivElement;
                            listArea.element.appendChild(spacer);
                        }
                        // the lists are "absolute" so they float over the spacer
                        spacer.style.height = totalHeight.toString() + "px";
                        topSpacerHeight = Math.min(topSpacerHeight, totalHeight - useHeight);
                        // if we have enough to scroll, then make the columns a row taller because
                        // the virtual scrolling neds to shift the column lists
                        if (totalHeight > useHeight)
                        {
                            var numVisibleRows:int = Math.floor(useHeight / actualRowHeight);
                            lastVisibleIndex = firstVisibleIndex + numVisibleRows + 1;
                            useHeight = actualRowHeight * (numVisibleRows + 1);
                        }
                        else
                            lastVisibleIndex = model.dataProvider.length - 1;
                        /*if (uiHost.element.style["overflow-x"] == "hidden")
                            listArea.element.style["overflow-x"] = "hidden";*/
                    }
                }
                /*COMPILE::JS
                {
                    if (listArea.element.offsetHeight > listArea.element.clientHeight)
                    {
                        // horizontal scrollbar is always shown
                        useHeight -= listArea.element.offsetHeight - listArea.element.clientHeight;
                    }
                }*/
                for (i = 0; i < n; i++)
                {
                    var columnList:UIBase = displayedColumns[i] as UIBase;
                    if (presentationModel.virtualized) //set the columnList to a specific height if virtualized
                        columnList.height = useHeight;
                    COMPILE::JS
                    {
                        if (!presentationModel.virtualized) topSpacerHeight = 0; //we don't need a vertical offset if all renderers are present
                        columnList.element.style.position = "absolute";
                        columnList.element.style.top = (topSpacerHeight + 1).toString() + 'px';
                        // chrome has bug where moving things resets scrollTop
                        listArea.element.scrollTop = scrollTop;
                        columnList.dispatchEvent(new Event("layoutNeeded"));
                    }
                }
            }


            return retval;
        }


        public function isVisibleIndex(index:int):Boolean
        {
            return index >= firstVisibleIndex && index <= lastVisibleIndex;
        }
	}
}
