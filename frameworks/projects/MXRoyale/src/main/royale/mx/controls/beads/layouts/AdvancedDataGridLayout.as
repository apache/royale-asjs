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
    import mx.controls.dataGridClasses.DataGridColumn;
    
    import org.apache.royale.core.IBorderPaddingMarginValuesImpl;
    import org.apache.royale.core.IDataGridModel;
    import org.apache.royale.core.IDataProviderModel;
    import org.apache.royale.core.IListPresentationModel;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.IStrandWithPresentationModel;
    import org.apache.royale.core.IUIBase;
    import org.apache.royale.core.UIBase;
    import org.apache.royale.core.ValuesManager;
    import org.apache.royale.core.layout.EdgeData;
    import org.apache.royale.events.Event;
    import org.apache.royale.html.beads.IDataGridView;
    import org.apache.royale.html.beads.models.ButtonBarModel;

	
    /**
     *  The DataGridLayout class.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class AdvancedDataGridLayout extends DataGridLayout
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function AdvancedDataGridLayout()
		{
        }
        
        protected function scrollHandler(e:Event):void
        {
            layout();
        }
        
        COMPILE::JS
        protected var spacer:HTMLDivElement;
        
        COMPILE::JS
        private var listening:Boolean;
        
        public var firstVisibleIndex:int;
        
        public var lastVisibleIndex:int;      
        
        public var maxVerticalScrollPosition:Number;
        
        public var actualRowHeight:Number;
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
            var presentationModel:IListPresentationModel = (uiHost as IStrandWithPresentationModel).presentationModel as IListPresentationModel;
            var retval:Boolean = super.layout();
            COMPILE::JS
            {
                if (!listening)
                    (uiHost.view as IDataGridView).listArea.element.addEventListener("scroll", scrollHandler);
                listening = true;
            }
            if (!uiHost.isHeightSizedToContent())
            {
                var header:IUIBase = (uiHost.view as IDataGridView).header;
                var bbmodel:ButtonBarModel = header.getBeadByType(ButtonBarModel) as ButtonBarModel;
                // do the proportional sizing of columns
                var borderMetrics:EdgeData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getBorderMetrics(_strand as IUIBase);			
                var useWidth:Number = uiHost.width - (borderMetrics.left + borderMetrics.right);
                var useHeight:Number = uiHost.height - (borderMetrics.top + borderMetrics.bottom) - header.height - 1;
                var displayedColumns:Array = (uiHost.view as IDataGridView).columnLists;
                if (!displayedColumns) return retval;
                var n:int = displayedColumns.length;
                var listArea:IUIBase = (uiHost.view as IDataGridView).listArea;
                actualRowHeight = presentationModel.rowHeight 
                    + presentationModel.separatorThickness;
                COMPILE::JS
                {
                firstVisibleIndex = Math.floor(listArea.element.scrollTop / actualRowHeight);
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
                        if (uiHost.element.style["overflow-x"] == "hidden")
                            listArea.element.style["overflow-x"] = "hidden";
                    }
                }
                for (var i:int = 0; i < n; i++)
                {
                    var columnList:UIBase = displayedColumns[i] as UIBase;
                    columnList.height = useHeight;
                    COMPILE::JS
                    {
                        columnList.element.style.position = "absolute";
                        columnList.element.style.top = (topSpacerHeight + 1).toString() + 'px';
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
