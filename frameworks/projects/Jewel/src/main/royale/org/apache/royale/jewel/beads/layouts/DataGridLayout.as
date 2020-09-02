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
package org.apache.royale.jewel.beads.layouts
{	
    import org.apache.royale.collections.ArrayList;
    import org.apache.royale.core.IBeadLayout;
    import org.apache.royale.core.IDataGridModel;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.IUIBase;
    import org.apache.royale.core.UIBase;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.html.beads.IDataGridView;
    import org.apache.royale.html.beads.models.ButtonBarModel;
    import org.apache.royale.jewel.supportClasses.datagrid.DataGridColumnWidth;
    import org.apache.royale.jewel.supportClasses.datagrid.DataGridWidthDenominator;
    import org.apache.royale.jewel.supportClasses.datagrid.IDataGridColumn;
    import org.apache.royale.jewel.supportClasses.datagrid.IDataGridPresentationModel;
	
	/**
	 * DataGridLayout is a class that handles the size and positioning of the
	 * elements of a DataGrid. This includes the ButtonBar used for the column
	 * headers and the Lists that are the columns.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.7
	 */
	public class DataGridLayout implements IBeadLayout
	{
		/**
		 *  constructor
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function DataGridLayout()
		{
		}
		
		protected var _strand:IStrand;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			(_strand as IEventDispatcher).addEventListener("layoutNeeded", handleLayoutNeeded);
			(_strand as IEventDispatcher).addEventListener("sizeChanged", sizeChangedNeeded);
			(_strand as IEventDispatcher).addEventListener("widthChanged", sizeChangedNeeded);
		}
		
		/**
		 * @royaleignorecoercion org.apache.royale.core.UIBase
		 */
		protected function get datagrid():UIBase
		{
			return _strand as UIBase;
		}
		
		/**
		 *  sizeChangedNeeded
		 * 
		 *  @param event
		 *
		 * @royaleignorecoercion org.apache.royale.core.IUIBase
		 * @royaleignorecoercion org.apache.royale.html.beads.IDataGridView
		 * @royaleignorecoercion org.apache.royale.html.beads.models.ButtonBarModel
		 */
		private function sizeChangedNeeded(event:Event):void
		{

			var view:IDataGridView = datagrid.view as IDataGridView
			var header:IUIBase = view.header;
			var bbmodel:ButtonBarModel = header.getBeadByType(ButtonBarModel) as ButtonBarModel;
			bbmodel.buttonWidths = null;
			header.dispatchEvent(new Event('headerLayoutReset'));
			layout();
		}

		/**
		 *  handleLayoutNeeded
		 * 
		 *  @param event 
		 */
		private function handleLayoutNeeded(event:Event):void
		{
			layout();
		}

		/**
		 *  Used at begining of layout for % height
		 */
		private var initLayout:Boolean = true;
		
		/**
		 * @copy org.apache.royale.core.IBeadLayout#layout
         * @royaleignorecoercion org.apache.royale.core.IBorderPaddingMarginValuesImpl
         * @royaleignorecoercion org.apache.royale.core.IDataGridModel
         * @royaleignorecoercion org.apache.royale.core.IUIBase
		 * @royaleignorecoercion org.apache.royale.core.UIBase
		 * @royaleignorecoercion org.apache.royale.html.beads.IDataGridView
		 * @royaleignorecoercion org.apache.royale.html.beads.models.ButtonBarModel
		 * @royaleignorecoercion org.apache.royale.jewel.supportClasses.datagrid.IDataGridColumn
		 */
		public function layout():Boolean
		{
			var model:IDataGridModel = datagrid.model as IDataGridModel;

			// required when using percentage height (%) since at this point still don't have component measure
			// so we call requestAnimationFrame until get right values
			COMPILE::JS
			{
				if(initLayout && model.dataProvider){
					if(datagrid.height == 0 && !isNaN(datagrid.percentHeight)) {
						requestAnimationFrame(layout);
						return true;
					} else
						initLayout = false;
				}
			}

			var view:IDataGridView = datagrid.view as IDataGridView
			var presentationModel:IDataGridPresentationModel = datagrid.getBeadByType(IDataGridPresentationModel) as IDataGridPresentationModel;
			var header:IUIBase = view.header;
            // fancier DG's will filter invisible columns and only put visible columns
            // in the bbmodel, so do all layout based on the bbmodel, not the set
            // of columns that may contain invisible columns
            var bbmodel:ButtonBarModel = header.getBeadByType(ButtonBarModel) as ButtonBarModel;
			bbmodel.dataProvider.source = model.columns;
            var bblayout:DataGridColumnLayout = header.getBeadByType(DataGridColumnLayout) as DataGridColumnLayout;
			var listArea:IUIBase = view.listArea;
			
			var displayedColumns:Array = view.columnLists;
			
			// Width
			//var defaultColumnWidth:Number = 0;
			var defaultColumnWidth:DataGridColumnWidth = null;

			var l:uint = bbmodel.dataProvider.length;
			var i:int;
			var columnDef:IDataGridColumn;
			var isDGWidthSizedToContent:Boolean = datagrid.isWidthSizedToContent();
			var denominatorInst:DataGridWidthDenominator = new DataGridWidthDenominator();

			denominatorInst.value = l;
			var explicitWidths:Number = 0;
			var explicitPercents:uint = 0;
			for(i=0; i < l; i++) {
				columnDef = (bbmodel.dataProvider as ArrayList).getItemAt(i) as IDataGridColumn;
				if (!isNaN(columnDef.explicitColumnWidth)) {
					denominatorInst.value--;
					explicitWidths += columnDef.explicitColumnWidth;
				} else if(!isNaN(columnDef.percentColumnWidth)) {
					explicitPercents += columnDef.percentColumnWidth;
				}
			}

			// When still don't have header buttonWidths, we need a defaultColumnWidth
			if(!bbmodel.buttonWidths)
			{
				if (denominatorInst.value) {
					defaultColumnWidth = new DataGridColumnWidth();
					defaultColumnWidth.setDefault();
					defaultColumnWidth.widthType = DataGridColumnWidth.PERCENT;
					defaultColumnWidth.denominator = denominatorInst;
					bblayout.defaultWidth = defaultColumnWidth;
					//not sure about the logic behind these default assessments:
					if (datagrid.percentWidth) {
						defaultColumnWidth.value = ((100 - explicitPercents) * .01 * datagrid.percentWidth) / denominatorInst.value ;
						//if (defaultColumnWidth.value) defaultColumnWidth.widthType = DataGridColumnWidth.PERCENT;
					} else if (datagrid.explicitWidth){
						defaultColumnWidth.value = ((100 - explicitPercents)/100 * datagrid.width - explicitWidths) / denominatorInst.value;
						//if (defaultColumnWidth.value) defaultColumnWidth.widthType = DataGridColumnWidth.DEFAULT;
					}
					// special case when no width is set at all, defaultColumnWidth will be 0
					if (defaultColumnWidth.value == 0){
						if (isDGWidthSizedToContent || (100 - explicitPercents <= 0)) {
							defaultColumnWidth.value = 80;
							defaultColumnWidth.widthType = DataGridColumnWidth.PIXELS;
						} else {
							defaultColumnWidth.value = (100 - explicitPercents) / denominatorInst.value;
							//defaultColumnWidth.widthType = DataGridColumnWidth.EXPLICIT_PERCENT;
						}
					}
				}
			}
			
			var columnWidths:Array = [];

			var existing:Boolean = bbmodel.buttonWidths != null;
			for(i=0; i < l; i++)
			{
				columnDef = (bbmodel.dataProvider as ArrayList).getItemAt(i) as IDataGridColumn;
				var columnList:UIBase = displayedColumns[i] as UIBase;

				var columnWidth:DataGridColumnWidth = existing ? bbmodel.buttonWidths[i] || new DataGridColumnWidth() : new DataGridColumnWidth() ;
				columnWidth.denominator = denominatorInst;

				if (!isNaN(columnDef.explicitColumnWidth)) {
					columnWidth.widthType = DataGridColumnWidth.PIXELS;
					columnWidth.value = columnDef.columnWidth;
					columnWidth.column = columnDef;
				} else {
					if (!isNaN(columnDef.percentColumnWidth)) {
						columnWidth.widthType = DataGridColumnWidth.PERCENT;
						columnWidth.value = columnDef.percentColumnWidth;
						columnWidth.column = columnDef;
					} else {
						columnWidth.setFrom(defaultColumnWidth);
					}

				}
				columnWidth.configureWidth(columnList);

				columnWidths.push(columnWidth);
				
				// Column's Height - remove columns height if rows not surround datagrid height (and this one is set to pixels)
				/*if(model.dataProvider && (model.dataProvider.length * presentationModel.rowHeight) > (datagrid.height - header.height))
					columnList.height = NaN;
				else 
					columnList.percentHeight = 100;*/
			}

			bbmodel.buttonWidths = columnWidths;

			
			header.dispatchEvent(new Event("layoutNeeded"));
			listArea.dispatchEvent(new Event("layoutNeeded"));

			return true;
		}
	}
}