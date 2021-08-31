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
    import org.apache.royale.core.IChild;
    import org.apache.royale.core.IDataProviderItemRendererMapper;
    import org.apache.royale.core.IIndexedItemRendererInitializer;
    import org.apache.royale.core.IItemRendererOwnerView;
    import org.apache.royale.core.IParent;
    import org.apache.royale.core.IStrandWithModelView;
    import org.apache.royale.core.ITableModel;
    import org.apache.royale.events.Event;
    import org.apache.royale.html.beads.DataItemRendererFactoryBase;
    import org.apache.royale.html.beads.ITableView;
    import org.apache.royale.jewel.Label;
    import org.apache.royale.jewel.Table;
    import org.apache.royale.jewel.beads.controls.TextAlign;
    import org.apache.royale.jewel.itemRenderers.TableItemRenderer;
    import org.apache.royale.jewel.supportClasses.table.THead;
    import org.apache.royale.jewel.supportClasses.table.TableColumn;
    import org.apache.royale.jewel.supportClasses.table.TableHeaderCell;
    import org.apache.royale.jewel.supportClasses.table.TableRow;

    /**
	 * This class creates itemRenderer instances from the data contained within an ICollectionView
     * and generates the appropiate table structure with thead, tbody and table rows and cells
     * to hold the columns and data in cells.
	 */
	public class TableItemRendererFactoryForCollectionView extends DataItemRendererFactoryBase implements IDataProviderItemRendererMapper
	{
		public function TableItemRendererFactoryForCollectionView(target:Object = null)
		{
			super(target);
		}
		
		private var table:Table;
		private var view:ITableView;

		override protected function finishSetup(event:Event):void
		{
			super.finishSetup(event);
			table = _strand as Table;
		}

		override protected function get dataGroup():IItemRendererOwnerView {
			if(!view)
				view = (_strand as IStrandWithModelView).view as ITableView;
			return view.dataGroup;
		}
		
		protected function get model():ITableModel {
			return dataProviderModel as ITableModel;
		}

		/**
         *  Remove all itemrenderers
         * 
         *  @royaleignorecoercion org.apache.royale.core.IItemRendererOwnerView
         */
        override protected function removeAllItemRenderers(dataGroup:IItemRendererOwnerView):void
        {
			// TBodyContentArea - remove data items
            super.removeAllItemRenderers(dataGroup);

			// THEAD - remove header items
			removeElements(view.header);
        }

		/**
		 *  create all item renderers
		 *  
		 *  @royaleignorecoercion org.apache.royale.core.IIndexedItemRenderer
		 *  @royaleignorecoercion org.apache.royale.core.IIndexedItemRendererInitializer
		 */
		override protected function createAllItemRenderers(dataGroup:IItemRendererOwnerView):void
		{
			if(!model.columns)
				return;

			// -- add the header
            createHeader();
			
			// -- 2) CREATION PHASE
            var column:TableColumn;
            var ir:TableItemRenderer;

			var n:int = model.dataProvider.length;
			var index:int = 0;
			for (var i:int = 0; i < n; i++)
			{
			    for(var j:int = 0; j < model.columns.length; j++)
				{
			        column = model.columns[j] as TableColumn;
					
			        if(column.itemRenderer != null)
                    {
						ir = column.itemRenderer.newInstance() as TableItemRenderer;
                    } else
                    {
                        ir = itemRendererFactory.createItemRenderer() as TableItemRenderer;
                    }

					ir.dataField = column.dataField;
					ir.rowIndex = i;
					ir.columnIndex = j;
					if(column.align != "")
						ir.align = column.align;
					
					var data:Object = model.dataProvider.getItemAt(i);
					
					(itemRendererInitializer as IIndexedItemRendererInitializer).initializeIndexedItemRenderer(ir, data, index);
                    
					dataGroup.addItemRendererAt(ir, index);

					ir.labelField = column.dataField;
					ir.index = index;
					ir.data = data;

					index++;
                }
			}
		}

		/**
		 *  remove all elements in a container.
		 *  Needed to remove THEAD contents as part of cleaning
		 */
		protected function removeElements(container: IParent):void
		{
			if(container != null)
			{
				while (container.numElements > 0) {
					var child:IChild = container.getElementAt(0);
					container.removeElement(child);
				}
			}
		}

		/**
		 * Create the THEAD in the creation phase with the columns info
		 */
        protected function createHeader():void
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
				if(view.header == null)
                	view.header = new THead();
				var headerRow:TableRow = new TableRow();
				
				for(c=0; c < model.columns.length; c++)
				{
					test = model.columns[c] as TableColumn;
					var tableHeader:TableHeaderCell = new TableHeaderCell();
					
                    var label:Label = new Label();
					tableHeader.addElement(label);
					label.text = test.label == null ? "" : test.label;
					
					var columnLabelTextAlign:TextAlign = new TextAlign();
					columnLabelTextAlign.align = test.columnLabelAlign;
					label.addBead(columnLabelTextAlign);
					headerRow.addElement(tableHeader);
				}

				view.header.addElement(headerRow);
				table.addElementAt(view.header as THead, 0);
			}
        }
    }
}