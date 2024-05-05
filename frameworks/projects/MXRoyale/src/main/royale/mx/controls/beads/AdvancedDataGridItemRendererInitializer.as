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

	import mx.controls.AdvancedDataGrid;
import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
import mx.controls.beads.controllers.ADGItemRendererMouseController;
	import mx.controls.listClasses.BaseListData;

	import org.apache.royale.collections.TreeData;
    import org.apache.royale.core.Bead;
	import org.apache.royale.core.IBeadController;
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
    import mx.controls.advancedDataGridClasses.AdvancedDataGridListData;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumnList;
    import mx.controls.beads.models.DataGridColumnICollectionViewModel;
	import mx.core.UIComponent;
    
	/**
	 *  The AdvancedDataGridItemRendererInitializer class initializes item renderers
     *  in tree classes.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class AdvancedDataGridItemRendererInitializer extends ListItemRendererInitializer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function AdvancedDataGridItemRendererInitializer()
		{
		}

		override protected function getDefaultController():IBeadController{
			return new ADGItemRendererMouseController();
		}
				
		/**
		 *  @private
		 *  @royaleignorecoercion org.apache.royale.core.HTMLElementWrapper
		 */
		override public function initializeIndexedItemRenderer(ir:IIndexedItemRenderer, data:Object, index:int):void
		{
            if (!dataProviderModel)
                return;
			_tempIR = ir;
            super.initializeIndexedItemRenderer(ir, data, index);
			_tempIR = null;

        }


		private var _tempIR:IIndexedItemRenderer;
		/**
		 *
		 *
		 *  @royaleignorecoercion mx.controls.advancedDataGridClasses.AdvancedDataGridColumnList
		 *  @royaleignorecoercion mx.controls.AdvancedDataGrid
		 *  @royaleignorecoercion mx.controls.beads.models.DataGridColumnICollectionViewModel
		 *  @royaleignorecoercion XML
		 *
		 */
		override protected function makeListData(data:Object, uid:String,
												 rowNum:int):BaseListData
		{
			var adgColumnList:AdvancedDataGridColumnList = _strand as AdvancedDataGridColumnList;

			if (!adgColumnList.grid) return null;

			var adgColumnListModel:DataGridColumnICollectionViewModel = adgColumnList.model as DataGridColumnICollectionViewModel;
			var adg:AdvancedDataGrid = (adgColumnList.grid as AdvancedDataGrid);
			var depth:int = adg.getDepth(data);
			var isOpen:Boolean = adg.isItemOpen(data);
			var hasChildren:Boolean = adg.hasChildren(data);
			var firstColumn:Boolean =  adgColumnListModel.columnIndex == 0;
			var activeColumn:AdvancedDataGridColumn = adg.columns[adgColumnListModel.columnIndex];
			var useLabelFunc:Boolean = activeColumn.labelFunction != null;
			var dataField:String = !useLabelFunc && firstColumn && adg.groupLabelField ? adg.groupLabelField : activeColumn.dataField;
			var text:String = "";
			try {
				if (useLabelFunc) {
					text = activeColumn.labelFunction(data, activeColumn)
				} else {
					if (data is XML)
						text = ((data as XML)[dataField]).toString();
					else
						text = data[dataField];
				}

			} catch (e:Error)
			{
			}
			// Set the listData with the depth of this item
			var treeListData:AdvancedDataGridListData = new AdvancedDataGridListData(text, dataField, adgColumnListModel.columnIndex, uid, (adgColumnList.grid as AdvancedDataGrid), rowNum);
			treeListData.depth = depth;
			treeListData.open = isOpen;
			treeListData.hasChildren = hasChildren;
			//item member is a reference to the data:
			treeListData.item = data;

			if (firstColumn && adg.groupLabelField) {
				(_tempIR as ILabelFieldItemRenderer).labelField = adg.groupLabelField;
			}


			return treeListData;
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
