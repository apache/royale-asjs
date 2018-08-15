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
package org.apache.royale.jewel.beads.itemRenderers
{
    import org.apache.royale.collections.ICollectionView;
    import org.apache.royale.core.IChild;
    import org.apache.royale.core.IParent;
	import org.apache.royale.core.IBeadModel;
	import org.apache.royale.core.IListPresentationModel;
	import org.apache.royale.core.SimpleCSSStyles;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.CollectionEvent;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.beads.IListView;
    import org.apache.royale.jewel.Label;
	import org.apache.royale.jewel.Table;
	import org.apache.royale.core.ISelectableItemRenderer;
	import org.apache.royale.jewel.beads.itemRenderers.ITextItemRenderer;
	import org.apache.royale.jewel.beads.models.TableModel;
	import org.apache.royale.jewel.beads.views.TableView;
	import org.apache.royale.jewel.supportClasses.table.TableCell;
	import org.apache.royale.jewel.supportClasses.table.TableHeaderCell;
	import org.apache.royale.jewel.supportClasses.table.TableRow;
	import org.apache.royale.jewel.supportClasses.table.THead;
	import org.apache.royale.jewel.supportClasses.table.TableColumn;
	import org.apache.royale.jewel.supportClasses.table.TBodyContentArea;
	import org.apache.royale.html.supportClasses.DataItemRenderer;

    /**
	 * This class creates itemRenderer instances from the data contained within an ICollectionView
     * and generates the appropiate table structure with thead, tbody and table rows and cells
     * to hold the columns and data in cells.
     * 
	 */
	public class TableItemRendererFactoryForCollectionView extends DataItemRendererFactoryForCollectionView
	{
		public function TableItemRendererFactoryForCollectionView(target:Object = null)
		{
			super(target);
		}

        protected var view:TableView;
        protected var model:TableModel;
        protected var table:Table;

		private var tbody:TBodyContentArea;

        /**
		 *  initialize bead
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 *  @royaleignorecoercion org.apache.royale.html.beads.IListView
		 */
		override protected function initComplete(event:Event):void
		{
            view = _strand.getBeadByType(IListView) as TableView;
            model = _strand.getBeadByType(IBeadModel) as TableModel;
            table = _strand as Table;

			super.initComplete(event);
		}

        /**
		 * @private
		 * @royaleignorecoercion org.apache.royale.collections.ICollectionView
		 * @royaleignorecoercion org.apache.royale.core.IListPresentationModel
		 * @royaleignorecoercion org.apache.royale.core.ISelectableItemRenderer
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		override protected function dataProviderChangeHandler(event:Event):void
		{
			// -- 1) CLEANING PHASE
            if (!dataProviderModel)
				return;
			var dp:ICollectionView = dataProviderModel.dataProvider as ICollectionView;
			if (!dp)
				return;
			
			// listen for individual items being added in the future.
			var dped:IEventDispatcher = dp as IEventDispatcher;
			dped.addEventListener(CollectionEvent.ITEM_ADDED, itemAddedHandler);
			dped.addEventListener(CollectionEvent.ITEM_REMOVED, itemRemovedHandler);
			dped.addEventListener(CollectionEvent.ITEM_UPDATED, itemUpdatedHandler);
			
            // THEAD - remove header items
			removeElements(view.thead);
			
            // TBodyContentArea - remove data items
			tbody = dataGroup as TBodyContentArea;
			//tbody.removeAllItemRenderers(); -- this doesn't work since we 're wrappint IR in other pieces
			removeElements(tbody);
			
			// -- 2) CREATION PHASE

            // -- add the header
            createHeader();
			
			var presentationModel:IListPresentationModel = _strand.getBeadByType(IListPresentationModel) as IListPresentationModel;
			//labelField = dataProviderModel.labelField;
			
            var row:TableRow;
            var column:TableColumn;
            var tableCell:TableCell;
            var ir:ITextItemRenderer;

			var n:int = dp.length;
			var index:int = 0;
			for (var i:int = 0; i < n; i++)
			{
                row = new TableRow();

                for(var j:int = 0; j < model.columns.length; j++)
				{
                    column = model.columns[j] as TableColumn;
					tableCell = new TableCell();

                    if(column.itemRenderer != null)
                    {
                        ir = column.itemRenderer.newInstance() as ITextItemRenderer;
                    } else
                    {
                        ir = itemRendererFactory.createItemRenderer(tbody) as ITextItemRenderer;
                    }

                    tableCell.addElement(ir);
                    row.addElement(tableCell);

					labelField =  column.dataField;
                    // ir.labelField = labelField;
                    var item:Object = dp.getItemAt(i);
                    fillRenderer(index++, item, (ir as ISelectableItemRenderer), presentationModel);

                    (ir as DataItemRenderer).dataField = labelField;
					(ir as DataItemRenderer).rowIndex = i;
					(ir as DataItemRenderer).columnIndex = j;
                    
                    if(column.align != "")
                    {
                        ir.align = column.align;
                    }

					tbody.dispatchItemAdded(ir);
                }
                tbody.addElement(row);
			}
			
			IEventDispatcher(_strand).dispatchEvent(new Event("itemsCreated"));
            table.dispatchEvent(new Event("layoutNeeded"));
        }

		public function removeElements(container: IParent):void
		{
			if(container != null)
			{
				trace(container);
				trace(" removing all");
				while (container.numElements > 0) {
					var child:IChild = container.getElementAt(0);
					container.removeElement(child);
				}
			}
		}

        /**
		 * @private
		 * @royaleignorecoercion org.apache.royale.core.UIBase
		 */
		override protected function fillRenderer(index:int,
										item:Object,
										itemRenderer:ISelectableItemRenderer,
										presentationModel:IListPresentationModel):void
		{
			// tbody.addItemRendererAt(itemRenderer, index);
			
			itemRenderer.labelField = labelField;
			
			if (presentationModel) {
				var style:SimpleCSSStyles = new SimpleCSSStyles();
				style.marginBottom = presentationModel.separatorThickness;
				UIBase(itemRenderer).style = style;
				UIBase(itemRenderer).height = presentationModel.rowHeight;
				UIBase(itemRenderer).percentWidth = 100;
			}
			
			setData(itemRenderer, item, index);
		}

        private function createHeader():void
		{
            var createHeaderRow:Boolean = false;
            var test:TableColumn;
            var c:int;

			for(c=0; c < model.columns.length; c++)
			{
				test = model.columns[c] as TableColumn;
				if (test.label != null) {
					createHeaderRow = true;
					break;
				}
			}

            if (createHeaderRow) 
            {
				if(view.thead == null)
                	view.thead = new THead();
				var thead:THead = view.thead;
				var headerRow:TableRow = new TableRow();
				
				for(c=0; c < model.columns.length; c++)
				{
					test = model.columns[c] as TableColumn;
					var tableHeader:TableHeaderCell = new TableHeaderCell();
					
                    var label:Label = new Label();
					tableHeader.addElement(label);
					label.text = test.label == null ? "" : test.label;
					headerRow.addElement(tableHeader);
				}

				thead.addElement(headerRow);
				table.addElement(thead);
			}
        }
    }
}