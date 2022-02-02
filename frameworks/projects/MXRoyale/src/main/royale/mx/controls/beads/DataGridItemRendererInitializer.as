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
	import mx.controls.beads.models.DataGridColumnICollectionViewModel;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.controls.dataGridClasses.DataGridColumnList;
	import mx.controls.dataGridClasses.DataGridListData;
	import mx.controls.listClasses.BaseListData;
	import mx.core.UIComponent;

	import org.apache.royale.core.IIndexedItemRenderer;
    
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
		 *
		 *
		 *  @royaleignorecoercion mx.controls.dataGridClasses.DataGridColumn
		 *  @royaleignorecoercion mx.controls.dataGridClasses.DataGridColumnList
		 *  @royaleignorecoercion mx.controls.beads.models.DataGridColumnICollectionViewModel
		 *
		 */
		override protected function makeListData(data:Object, uid:String,
												 rowNum:int):BaseListData
		{	var dgColumnList:DataGridColumnList = _strand as DataGridColumnList;
			var dg:DataGrid = (dgColumnList.grid as DataGrid);
			if (data == null || !dgColumnList.grid) return null;

			var dgColumnListModel:DataGridColumnICollectionViewModel = dgColumnList.model as DataGridColumnICollectionViewModel;


			var dgColumn:DataGridColumn = dg.columns[dgColumnListModel.columnIndex] as DataGridColumn;
			var text:String = "";

			/*try {
				text = dgColumn.labelFunction !=null ? dgColumn.labelFunction(data, dgColumn) : data[dgColumn.dataField];
			} catch (e:Error)
			{
			}*/
			text = dgColumn.itemToLabel(data);

			return new DataGridListData(text, dgColumn.dataField, dgColumnListModel.columnIndex, "", dg, rowNum);
		}

        /*override protected function setupVisualsForItemRenderer(ir:IIndexedItemRenderer):void
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
		}*/
		        
	}
}
