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
    import mx.controls.advancedDataGridClasses.AdvancedDataGridColumnGroup;
    import mx.controls.dataGridClasses.DataGridColumn;
    
    import org.apache.royale.core.IBorderPaddingMarginValuesImpl;
    import org.apache.royale.core.IDataGridModel;
    import org.apache.royale.core.IDataProviderModel;
    import org.apache.royale.html.IListPresentationModel;
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
        
       /* override protected function scrollHandler(e:Event):void
        {
            layout();
        }*/


        override protected function setHeaderWidths(columnWidths:Array):void
        {
            var header:IUIBase = (uiHost.view as IDataGridView).header;
            // fancier DG's will filter invisible columns and only put visible columns
            // in the bbmodel, so do all layout based on the bbmodel, not the set
            // of columns that may contain invisible columns
            var bbmodel:ButtonBarModel = header.getBeadByType(ButtonBarModel) as ButtonBarModel;
            if (bbmodel.dataProvider && (bbmodel.dataProvider.length != columnWidths.length))
            {
                // probably some grouped columns so recompute widths;
                var newColumnWidths:Array = [];
                for (var i:int = 0; i < bbmodel.dataProvider.length; i++)
                {
                    newColumnWidths.push(getHeaderColumnWidth(bbmodel.dataProvider[i] as DataGridColumn));
                }
                columnWidths = newColumnWidths;
            }
            super.setHeaderWidths(columnWidths);
        }
        
        private function getHeaderColumnWidth(column:DataGridColumn):Number
        {
            if (column is AdvancedDataGridColumnGroup)
            {
                var adgcg:AdvancedDataGridColumnGroup = column as AdvancedDataGridColumnGroup;
                var w:Number = 0;
                for (var i:int = 0; i < adgcg.children.length; i++)
                {
                    w += getHeaderColumnWidth(adgcg.children[i] as DataGridColumn);
                }
                return w;
            }
            return column.columnWidth;
        }

	}
}
