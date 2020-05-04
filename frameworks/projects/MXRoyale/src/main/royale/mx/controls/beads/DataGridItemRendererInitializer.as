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
package mx.controls.beads
{


	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridListArea;

    import org.apache.royale.core.Bead;
    import org.apache.royale.core.IDataProviderModel;
    import org.apache.royale.core.IIndexedItemRenderer;
    import org.apache.royale.core.IIndexedItemRendererInitializer;
    import org.apache.royale.core.IItemRenderer;
    import org.apache.royale.core.IListDataItemRenderer;
    import org.apache.royale.core.ILabelFieldItemRenderer;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.IUIBase;
    import org.apache.royale.core.SimpleCSSStyles;
    import org.apache.royale.core.UIBase;
    import mx.controls.dataGridClasses.DataGridListData;
	import mx.controls.dataGridClasses.DataGridColumnList;
    import mx.controls.beads.models.DataGridColumnICollectionViewModel;
	import mx.core.UIComponent;
    
	/**
	 *  The DataGridItemRendererInitializer class initializes item renderers
     *  in mx DataGrid classes.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class DataGridItemRendererInitializer extends ListItemRendererInitializer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function DataGridItemRendererInitializer()
		{
		}
				
		/**
		 *  @private
		 *  @royaleignorecoercion org.apache.royale.core.HTMLElementWrapper
		 */
		override public function initializeIndexedItemRenderer(ir:IIndexedItemRenderer, data:Object, index:int):void
		{
            if (!dataProviderModel)
                return;
            
            super.initializeIndexedItemRenderer(ir, data, index);

            var dgColumnList:DataGridColumnList = _strand as DataGridColumnList;

            if (!dgColumnList.grid) return;

            var dgColumnListModel:DataGridColumnICollectionViewModel = dgColumnList.getBeadByType(DataGridColumnICollectionViewModel) as DataGridColumnICollectionViewModel;
			var dg:DataGrid = (dgColumnList.grid as DataGrid);

			var dataField:String = dg.columns[dgColumnListModel.columnIndex].dataField;
			var text:String = "";
			try {
				text = data[dataField];
			} catch (e:Error)
			{
			}
			// Set the listData with the depth of this item
			var listData:DataGridListData = new DataGridListData(text, dataField, dgColumnListModel.columnIndex, "", (dgColumnList.grid as DataGrid), index);

			(ir as IListDataItemRenderer).listData = listData;
        }

        override protected function setupVisualsForItemRenderer(ir:IIndexedItemRenderer):void
        {
			super.setupVisualsForItemRenderer(ir);
			COMPILE::JS
			{
				if (ir is UIComponent)
				{
					(ir as UIComponent).isAbsolute = false;
					(ir as UIComponent).element.style.position = 'relative';
				}
			}
		}
		        
	}
}
