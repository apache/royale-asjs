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
package org.apache.royale.jewel.beads.controllers
{
	import org.apache.royale.core.IBeadController;
	import org.apache.royale.core.IBeadView;
	import org.apache.royale.core.IIndexedItemRenderer;
	import org.apache.royale.core.IItemRendererOwnerView;
	import org.apache.royale.core.IRollOverModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.ITableModel;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.ItemAddedEvent;
	import org.apache.royale.events.ItemClickedEvent;
	import org.apache.royale.events.ItemRemovedEvent;
	import org.apache.royale.html.beads.ITableView;
	import org.apache.royale.html.supportClasses.StyledDataItemRenderer;
	import org.apache.royale.jewel.beads.models.IJewelSelectionModel;

    /**
     *  The TableCellSelectionMouseController class is a controller for
     *  org.apache.royale.jewel.Table.  Controllers
     *  watch for events from the interactive portions of a View and
     *  update the data model or dispatch a semantic event.
     *  This controller watches for events from the item renderers
     *  and updates an ITableModel (which only supports single
     *  selection).  Other controller/model pairs would support
     *  various kinds of multiple selection.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
     */
	public class TableCellSelectionMouseController implements IBeadController
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		public function TableCellSelectionMouseController()
		{
		}
		
        /**
         *  The model.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		protected var model:ITableModel;

        /**
         *  The view.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
        protected var view:ITableView;

        /**
         *  The parent of the item renderers.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
        protected var dataGroup:IItemRendererOwnerView;

		private var _strand:IStrand;
		
        /**
         *  @copy org.apache.royale.core.IBead#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         *  @royaleignorecoercion org.apache.royale.core.ISelectionModel
         *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
         *  @royaleignorecoercion org.apache.royale.core.IListView
         */
		public function set strand(value:IStrand):void
		{
			_strand = value;

			model = value.getBeadByType(ITableModel) as ITableModel;
			view = value.getBeadByType(IBeadView) as ITableView;
			IEventDispatcher(_strand).addEventListener("itemAdded", handleItemAdded);
			IEventDispatcher(_strand).addEventListener("itemRemoved", handleItemRemoved);

            //if the list is composed as part of another component, with a shared model (e.g. ComboBox) then it should not be the primary dispatcher
			if (model is IJewelSelectionModel && !(IJewelSelectionModel(model).hasDispatcher)) {
                 IJewelSelectionModel(model).dispatcher = IEventDispatcher(value);
			}
            else {
				IEventDispatcher(model).addEventListener('rollOverIndexChanged', modelChangeHandler);
				IEventDispatcher(model).addEventListener('selectionChanged', modelChangeHandler);
                IEventDispatcher(model).addEventListener('dataProviderChanged', modelChangeHandler);
            }
		}

        /**
         * 
         * @param event 
         */
        protected function modelChangeHandler(event:Event):void{
            IEventDispatcher(_strand).dispatchEvent(new Event(event.type));
        }
		
        /**
         * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
         */
		protected function handleItemAdded(event:ItemAddedEvent):void
		{
			IEventDispatcher(event.item).addEventListener("itemClicked", selectedHandler);
			IEventDispatcher(event.item).addEventListener("itemRollOver", rolloverHandler);
			IEventDispatcher(event.item).addEventListener("itemRollOut", rolloutHandler);
		}
		
        /**
         * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
         */
		protected function handleItemRemoved(event:ItemRemovedEvent):void
		{
            IEventDispatcher(event.item).removeEventListener("itemClicked", selectedHandler);
			IEventDispatcher(event.item).removeEventListener("itemRollOver", rolloverHandler);
			IEventDispatcher(event.item).removeEventListener("itemRollOut", rolloutHandler);
		}
		
		protected function selectedHandler(event:ItemClickedEvent):void
        {
            var renderer:StyledDataItemRenderer = event.currentTarget as StyledDataItemRenderer;
			
            model.labelField = renderer.labelField;
			model.selectedItem = event.data;
            model.selectedItemProperty = model.selectedItem[model.labelField];
            model.selectedIndex = model.getIndexForSelectedItemProperty();

            view.host.dispatchEvent(new Event(Event.CHANGE));
        }
		
		/**
		 * @royaleemitcoercion org.apache.royale.core.IIndexedItemRenderer
         * @royaleignorecoercion org.apache.royale.core.IRollOverModel
		 */
		protected function rolloverHandler(event:Event):void
		{
			var renderer:IIndexedItemRenderer = event.currentTarget as IIndexedItemRenderer;
			if (renderer) {
				IRollOverModel(model).rollOverIndex = renderer.index;
			}
		}
		
		/**
		 * @royaleemitcoercion org.apache.royale.core.IIndexedItemRenderer
         * @royaleignorecoercion org.apache.royale.core.IRollOverModel
		 */
		protected function rolloutHandler(event:Event):void
		{
			var renderer:IIndexedItemRenderer = event.currentTarget as IIndexedItemRenderer;
			if (renderer) {
				//renderer.hovered = false; who sets this to true?
				//renderer.down = false; who sets this to true?
				IRollOverModel(model).rollOverIndex = -1;
			}
		}
	
	}
}
