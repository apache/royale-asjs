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
    import org.apache.royale.core.IBead;
    import org.apache.royale.core.IBeadModel;
    import org.apache.royale.core.IChild;
    import org.apache.royale.core.IDataProviderItemRendererMapper;
    import org.apache.royale.core.IItemRendererClassFactory;
    import org.apache.royale.core.IParent;
    import org.apache.royale.core.ISelectableItemRenderer;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.SimpleCSSStyles;
    import org.apache.royale.core.UIBase;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.EventDispatcher;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.html.beads.IListView;
    import org.apache.royale.html.supportClasses.DataItemRenderer;
    import org.apache.royale.jewel.Label;
    import org.apache.royale.jewel.Table;
    import org.apache.royale.jewel.beads.controls.TextAlign;
    import org.apache.royale.jewel.beads.models.TableModel;
    import org.apache.royale.jewel.beads.views.TableView;
    import org.apache.royale.jewel.itemRenderers.TableItemRenderer;
    import org.apache.royale.jewel.supportClasses.list.IListPresentationModel;
    import org.apache.royale.jewel.supportClasses.table.TBodyContentArea;
    import org.apache.royale.jewel.supportClasses.table.THead;
    import org.apache.royale.jewel.supportClasses.table.TableColumn;
    import org.apache.royale.jewel.supportClasses.table.TableHeaderCell;
    import org.apache.royale.jewel.supportClasses.table.TableRow;
    import org.apache.royale.utils.loadBeadFromValuesManager;

    /**
	 * This class creates itemRenderer instances from the data contained within an ICollectionView
     * and generates the appropiate table structure with thead, tbody and table rows and cells
     * to hold the columns and data in cells.
	 */
	public class TableItemRendererFactoryForCollectionView extends EventDispatcher implements IBead, IDataProviderItemRendererMapper
	{
		public function TableItemRendererFactoryForCollectionView(target:Object = null)
		{
			super(target);
		}

		protected var _strand:IStrand;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			IEventDispatcher(value).addEventListener("initComplete", initComplete);
		}

		/**
		 *  finish setup
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 *  @royaleignorecoercion org.apache.royale.html.beads.IListView
		 */
		protected function initComplete(event:Event):void
		{
			IEventDispatcher(_strand).removeEventListener("initComplete", initComplete);

			view = _strand.getBeadByType(IListView) as TableView;
			tbody = view.dataGroup as TBodyContentArea;

            model = _strand.getBeadByType(IBeadModel) as TableModel;
			model.addEventListener("dataProviderChanged", dataProviderChangeHandler);

            table = _strand as Table;
			
			dataProviderChangeHandler(null);
		}
		
		protected var labelField:String;
		
		private var _itemRendererFactory:IItemRendererClassFactory;
		
		/**
		 *  The org.apache.royale.core.IItemRendererClassFactory used
		 *  to generate instances of item renderers.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.core.IItemRendererClassFactory
		 */
		public function get itemRendererFactory():IItemRendererClassFactory
		{
			if(!_itemRendererFactory)
				_itemRendererFactory = loadBeadFromValuesManager(IItemRendererClassFactory, "iItemRendererClassFactory", _strand) as IItemRendererClassFactory;
			
			return _itemRendererFactory;
		}
		
		/**
		 *  @private
		 */
		public function set itemRendererFactory(value:IItemRendererClassFactory):void
		{
			_itemRendererFactory = value;
		}

        protected var view:TableView;
        protected var model:TableModel;
        protected var table:Table;

		private var tbody:TBodyContentArea;

        /**
		 * @private
		 * @royaleignorecoercion org.apache.royale.collections.ICollectionView
		 * @royaleignorecoercion org.apache.royale.jewel.supportClasses.list.IListPresentationModel
		 * @royaleignorecoercion org.apache.royale.core.ISelectableItemRenderer
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		protected function dataProviderChangeHandler(event:Event):void
		{
			// -- 1) CLEANING PHASE
            if (!model)
				return;
			var dp:ICollectionView = model.dataProvider as ICollectionView;
			if (!dp)
			{
				model.selectedIndex = -1;
				model.selectedItem = null;
				model.selectedItemProperty = null;

				// TBodyContentArea - remove data items
				tbody.removeAllItemRenderers();
				return;
			}
			// remove this and better add beads when needed
			// listen for individual items being added in the future.
			// var dped:IEventDispatcher = dp as IEventDispatcher;
			// dped.addEventListener(CollectionEvent.ITEM_ADDED, itemAddedHandler);
			// dped.addEventListener(CollectionEvent.ITEM_REMOVED, itemRemovedHandler);
			// dped.addEventListener(CollectionEvent.ITEM_UPDATED, itemUpdatedHandler);
			
            // TBodyContentArea - remove data items
			tbody.removeAllItemRenderers();
			
            // THEAD - remove header items
			removeElements(view.thead);
            // -- add the header
            createHeader();
			
			
			// -- 2) CREATION PHASE
			var presentationModel:IListPresentationModel = _strand.getBeadByType(IListPresentationModel) as IListPresentationModel;
			labelField = model.labelField;
			
            var column:TableColumn;
            var ir:TableItemRenderer;

			var n:int = dp.length;
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
                        ir = itemRendererFactory.createItemRenderer(tbody) as TableItemRenderer;
                    }

					labelField =  column.dataField;
                    var item:Object = dp.getItemAt(i);

                    (ir as DataItemRenderer).dataField = labelField;
					(ir as DataItemRenderer).rowIndex = i;
					(ir as DataItemRenderer).columnIndex = j;
                    fillRenderer(index++, item, (ir as ISelectableItemRenderer), presentationModel);
			        
                    if(column.align != "")
                    {
                        ir.align = column.align;
                    }
                }
			}
			
			IEventDispatcher(_strand).dispatchEvent(new Event("itemsCreated"));
            table.dispatchEvent(new Event("layoutNeeded"));
        }

		public function removeElements(container: IParent):void
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
		 * @private
		 * @royaleignorecoercion org.apache.royale.core.UIBase
		 */
		protected function fillRenderer(index:int,
										item:Object,
										itemRenderer:ISelectableItemRenderer,
										presentationModel:IListPresentationModel):void
		{
			tbody.addItemRendererAt(itemRenderer, index);
			itemRenderer.labelField = labelField;
			
			if (presentationModel) {
				UIBase(itemRenderer).height = presentationModel.rowHeight;
			}
			
			setData(itemRenderer, item, index);
		}

		/**
		 * @private
		 */
		protected function setData(itemRenderer:ISelectableItemRenderer, data:Object, index:int):void
		{
			itemRenderer.index = index;
			itemRenderer.data = data;
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
					
					var columnLabelTextAlign:TextAlign = new TextAlign();
					columnLabelTextAlign.align = test.columnLabelAlign;
					label.addBead(columnLabelTextAlign);
					headerRow.addElement(tableHeader);
				}

				thead.addElement(headerRow);
				table.addElement(thead);
			}
        }

		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.collections.ICollectionView
		 * @royaleignorecoercion org.apache.royale.jewel.supportClasses.list.IListPresentationModel
		 * @royaleignorecoercion org.apache.royale.core.ISelectableItemRenderer
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		// protected function itemAddedHandler(event:CollectionEvent):void
		// {
		// }

		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.collections.ICollectionView
		 * @royaleignorecoercion org.apache.royale.jewel.supportClasses.list.IListPresentationModel
		 * @royaleignorecoercion org.apache.royale.core.ISelectableItemRenderer
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		// protected function itemRemovedHandler(event:CollectionEvent):void
		// {
		// }

		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.collections.ICollectionView
		 * @royaleignorecoercion org.apache.royale.core.ISelectableItemRenderer
		 */
		// protected function itemUpdatedHandler(event:CollectionEvent):void
		// {
		// }
    }
}