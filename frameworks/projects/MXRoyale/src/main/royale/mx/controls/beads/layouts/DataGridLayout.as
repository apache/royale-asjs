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
    import mx.controls.dataGridClasses.DataGridColumn;
    import mx.core.ScrollControlBase;
    import mx.core.ScrollPolicy;
    
    import org.apache.royale.core.IBorderPaddingMarginValuesImpl;
    import org.apache.royale.core.IUIBase;
    import org.apache.royale.core.ValuesManager;
    import org.apache.royale.core.layout.EdgeData;
    import org.apache.royale.html.beads.IDataGridView;
    import org.apache.royale.html.beads.layouts.DataGridLayout;
    import org.apache.royale.html.beads.models.ButtonBarModel;
	
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
            if (ww > view.listArea.width)
            {
                // fudge last column if offscreen so it scrolls horizontally properly if
                // vertical scrollbar is always on
                COMPILE::JS
                {
                    if (view.listArea.element.offsetWidth > view.listArea.element.clientWidth)
                    {
                        columnWidths[columnWidths.length - 1] += view.listArea.element.offsetWidth - 
                            view.listArea.element.clientWidth;
                    }
                }
            }
            
            super.setHeaderWidths(columnWidths);
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
            var view:DataGridView = (uiHost.view as DataGridView);
            // do the proportional sizing of columns
            var borderMetrics:EdgeData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getBorderMetrics(_strand as IUIBase);			
            var useWidth:Number = uiHost.width - (borderMetrics.left + borderMetrics.right);
            var useHeight:Number = uiHost.height - (borderMetrics.top + borderMetrics.bottom);
            
            var totalWidths:Number = 0;
            var unspecifiedWidths:int = 0;
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
                    if (totalWidths != useWidth)
                    {
                        var factor:Number = useWidth / totalWidths;
                        for(i=0; i < view.visibleColumns.length; i++) {
                            columnDef = view.visibleColumns[i] as DataGridColumn;
                            columnDef.columnWidth = columnDef.width * factor;
                        }                
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
                if (totalWidths < useWidth)
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
                }
            }
            
            return super.layout();
        }
	}
}
