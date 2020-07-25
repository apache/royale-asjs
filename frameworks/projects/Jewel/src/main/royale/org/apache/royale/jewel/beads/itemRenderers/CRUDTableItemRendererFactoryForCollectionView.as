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
    import org.apache.royale.core.IIndexedItemRendererInitializer;
    import org.apache.royale.core.IParent;
    import org.apache.royale.events.CollectionEvent;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.jewel.itemRenderers.TableItemRenderer;
    import org.apache.royale.jewel.supportClasses.table.TableCell;
    import org.apache.royale.jewel.supportClasses.table.TableColumn;
    import org.apache.royale.jewel.supportClasses.table.TableRow;

    /**
	 * This class creates itemRenderer instances from the data contained within an ICollectionView
     * and generates the appropiate table structure with thead, tbody and table rows and cells
     * to hold the columns and data in cells.
	 */
	public class CRUDTableItemRendererFactoryForCollectionView extends TableItemRendererFactoryForCollectionView
	{
		public function CRUDTableItemRendererFactoryForCollectionView(target:Object = null)
		{
			super(target);
		}

        /**
		 * the dataProvider as a dispatcher
		 */
		protected var dped:IEventDispatcher;

        /**
		 * @private
		 * @royaleignorecoercion org.apache.royale.collections.ICollectionView
		 * @royaleignorecoercion org.apache.royale.core.IListPresentationModel
		 * @royaleignorecoercion org.apache.royale.core.IIndexedItemRenderer
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		override protected function dataProviderChangeHandler(event:Event):void
		{
			super.dataProviderChangeHandler(event);
			
			if(dped)
			{
				dped.removeEventListener(CollectionEvent.ITEM_ADDED, itemAddedHandler);
				dped.removeEventListener(CollectionEvent.ITEM_REMOVED, itemRemovedHandler);
				dped.removeEventListener(CollectionEvent.ITEM_UPDATED, itemUpdatedHandler);
				dped = null;
			}
			
			if (!dataProviderModel.dataProvider)
				return;
			
			// listen for individual items being added in the future.
			dped = dataProviderModel.dataProvider as IEventDispatcher;
			dped.addEventListener(CollectionEvent.ITEM_ADDED, itemAddedHandler);
			dped.addEventListener(CollectionEvent.ITEM_REMOVED, itemRemovedHandler);
			dped.addEventListener(CollectionEvent.ITEM_UPDATED, itemUpdatedHandler);
		}

        /**
		 *  Handles the itemRemoved event by removing the item.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 * 
		 *  @private
		 *  
		 *  @royaleignorecoercion org.apache.royale.events.CollectionEvent
  		 *  @royaleignorecoercion org.apache.royale.jewel.supportClasses.table.TableColumn
		 *  @royaleignorecoercion org.apache.royale.jewel.itemRenderers.TableItemRenderer
		 *  @royaleignorecoercion org.apache.royale.core.IIndexedItemRendererInitializer
		 */
		protected function itemAddedHandler(event:CollectionEvent):void
		{
            var column:TableColumn;
			var ir:TableItemRenderer;

			var index:int = event.index * model.columns.length;
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
				ir.rowIndex = event.index;
				ir.columnIndex = j;
				if(column.align != "")
					ir.align = column.align;
                
				(itemRendererInitializer as IIndexedItemRendererInitializer).initializeIndexedItemRenderer(ir, event.item, index);
				
                dataGroup.addItemRendererAt(ir, index);

                ir.labelField = column.dataField;
                ir.index = index;
                ir.data = event.item;

				index++;
			}

			// update the index values in the itemRenderers to correspond to their shifted positions.
			// adjust the itemRenderers' index to adjust for the shift
			var len:int = dataGroup.numItemRenderers;
			for (var i:int = event.index; i < len; i++)
			{
				ir = dataGroup.getItemRendererAt(i) as TableItemRenderer;
				ir.index = i;
				ir.rowIndex = i;
			}
		}

		/**
		 *  Handles the itemRemoved event by removing the item.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  
		 *  @private
		 *  @royaleignorecoercion org.apache.royale.events.CollectionEvent
		 *  @royaleignorecoercion org.apache.royale.jewel.itemRenderers.TableItemRenderer
  		 *  @royaleignorecoercion org.apache.royale.jewel.supportClasses.table.TableCell
  		 *  @royaleignorecoercion org.apache.royale.jewel.supportClasses.table.TableRow
  		 *  @royaleignorecoercion org.apache.royale.core.IParent
		 */
		protected function itemRemovedHandler(event:CollectionEvent):void
		{
			var ir:TableItemRenderer;
			var cell:TableCell;
			var processedRow:TableRow = (dataGroup as IParent).getElementAt(event.index) as TableRow;
			
			while (processedRow.numElements > 0) {
				cell = processedRow.getElementAt(0) as TableCell;
				ir = cell.getElementAt(0) as TableItemRenderer;
				dataGroup.removeItemRenderer(ir);
				cell.removeElement(ir);
				processedRow.removeElement(cell);
			}
			(dataGroup as IParent).removeElement(processedRow);

			// adjust the itemRenderers' index to adjust for the shift
			var len:int = dataGroup.numItemRenderers;
			for (var i:int = event.index; i < len; i++)
			{
				ir = dataGroup.getItemRendererAt(i) as TableItemRenderer;
				ir.index = i;
				ir.rowIndex = i;
			}
		}

		/**
		 *  Handles the itemUpdated event by updating the item.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  
		 *  @private
		 * 
		 *  @royaleignorecoercion org.apache.royale.jewel.itemRenderers.TableItemRenderer
		 *  @royaleignorecoercion org.apache.royale.jewel.supportClasses.table.TableRow
		 *  @royaleignorecoercion org.apache.royale.core.IParent
		 *  @royaleignorecoercion org.apache.royale.jewel.supportClasses.table.TableCell
		 */
		protected function itemUpdatedHandler(event:CollectionEvent):void
		{
			var ir:TableItemRenderer;
			var processedRow:TableRow = (dataGroup as IParent).getElementAt(event.index) as TableRow;
			var cell:TableCell;
			var n:int = processedRow.numElements;
			for (var i:int = 0; i < n; i++)
			{
				cell = processedRow.getElementAt(i) as TableCell;
				ir = cell.getElementAt(0) as TableItemRenderer;
				ir.index = event.index;
                ir.data = event.item;
			}
		}
    }
}