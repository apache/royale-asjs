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
package jewel.todomvc.controllers
{
	import jewel.todomvc.events.TodoEvent;
	import jewel.todomvc.models.TodoModel;
	import jewel.todomvc.vos.TodoVO;

	import org.apache.royale.collections.ArrayList;
	import org.apache.royale.collections.IArrayList;
	import org.apache.royale.core.Bead;
	import org.apache.royale.core.IBeadController;
	import org.apache.royale.core.IBeadModel;
	import org.apache.royale.core.IStrand;

	/**
     * The Todo Controller holds all the global actions. The views dispatch events that bubbles and
	 * this class register to these evens and updates the model, so views can update accordingly using
	 * binding most of the times.
     */
	public class TodoController extends Bead implements IBeadController
	{
        /**
		 *  constructor.
		 */
        public function TodoController():void
		{
        }

        /**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		override public function set strand(value:IStrand):void {
			super.strand = value;

			listenOnStrand(TodoEvent.ADD_TODO_ITEM, addTodoItem);            
			listenOnStrand(TodoEvent.TOGGLE_ALL_COMPLETE, toggleAllComplete);            
			listenOnStrand(TodoEvent.REMOVE_COMPLETED, removeCompleted);            
			listenOnStrand(TodoEvent.REFRESH_LIST, refreshList);            
			listenOnStrand(TodoEvent.ITEM_STATE_CHANGED, itemStateChangedHandler);            
			listenOnStrand(TodoEvent.ITEM_LABEL_CHANGED, itemLabelChangedHandler);            
			listenOnStrand(TodoEvent.ITEM_REMOVED, itemRemovedHandler);            
			
        	model = _strand.getBeadByType(IBeadModel) as TodoModel;
			
			// retrieve local items and use it if exists
			model.allItems = new ArrayList(model.getItemStore());
			
			model.setUpFilteredCollections();
			model.listItems = model.allItems;

			updateInterface();
        }

		/**
		 *  Common todo model
		 */
		private var model:TodoModel;

        /**
         *  Add the todo item to the list, save data and refresh the list state 
         */
        protected function addTodoItem(event:TodoEvent):void {
            model.allItems.addItem(event.todo);
			
			saveDataToLocal();
			updateInterface();
        }

		/**
         *  Mark all todo items as completed or uncompleted, save data and update the interface accordingly
         */
        protected function toggleAllComplete(event:TodoEvent):void {
			model.toggleAllToCompletedState = !model.toggleAllToCompletedState;

            var len:int = model.allItems.length;
			var item:TodoVO;
			for(var i:int = 0; i < len; i++) {
				item = TodoVO(model.allItems.getItemAt(i));
				item.done = model.toggleAllToCompletedState;
			}

			saveDataToLocal();
			updateInterface();
        }

		/**
         *  Remove all completed todo items, save data and update footer and toggle all button visibility
         */
        protected function removeCompleted(event:TodoEvent):void {
			var l:uint = model.allItems.length;
			var item:TodoVO;
			while(l--) {
				item = TodoVO(model.allItems.getItemAt(l));
				if(item.done){
					model.allItems.removeItem(item);
				}
			}

			saveDataToLocal();
			updateInterface();
		}

		/**
         *  Refresh the todo list to the appropiate filter state (All, Active or Completed)
         */
        protected function refreshList(event:TodoEvent):void
		{
			if(model.filterState != event.label) {
				model.filterState = event.label;

				setListState();
			}
		}

		/**
		 *  When some todo item change state (done/undone), we must save data and update the interface accordingly
		 */
        public function itemStateChangedHandler(event:TodoEvent = null):void {
			event.todo.done = event.completion;
			model.allItems.itemUpdated(event.todo);

			saveDataToLocal();
			updateInterface();
		}

		/**
		 *  Commit the label changes to the item and save data
		 *  if label is empty, remove todo item
		 */
        public function itemLabelChangedHandler(event:TodoEvent = null):void {
			if(event.label != ""){
				event.todo.label = event.label;
				model.allItems.itemUpdated(event.todo);
			}
			else {
				model.allItems.removeItem(event.todo);
			}

			saveDataToLocal();
			updateInterface();
		}

		/**
		 *  When the user click in the renderer destroy button we must remove the item, save data and update the interface
		 */
        public function itemRemovedHandler(event:TodoEvent):void {
			model.allItems.removeItem(event.todo);

			saveDataToLocal();
            updateInterface();
		}

		/**
         *  Saves the actual data to the local storage via Local SharedObject
         */
        protected function saveDataToLocal():void {
			try {
				model.setItemStore(model.allItems.source);
			} catch (error:Error) {
				trace("You need to be online to store locally");
			}
		}

		/**
		 *  Update the interface accordingly
		 */
		public function updateInterface():void {
			setListState();
			var item:String = model.activeItems.length == 1 ? " item " : " items ";
			model.itemsLeftLabel = model.activeItems.length + item + "left";
            model.clearCompletedVisibility = model.completedItems.length != 0;
			model.footerVisibility = model.allItems.length != 0;
			model.toogleAllVisibility = model.allItems.length != 0;
			model.toggleAllToCompletedState = model.activeItems.length == 0;
        }

		/**
		 *  Sets the new state filter and refresh list to match the filter
		 */
        protected function setListState():void {
			// setting to the same collection must cause refreshed too
			model.listItems = null;

			model.activeItems.refresh();
			model.completedItems.refresh();

			if(model.filterState == TodoModel.ALL_FILTER) {
				model.listItems = model.allItems;
			} 
			else if(model.filterState == TodoModel.ACTIVE_FILTER) {
				model.listItems = model.activeItems as IArrayList;
			}
			else if(model.filterState == TodoModel.COMPLETED_FILTER) {
				model.listItems = model.completedItems as IArrayList;
			}
		}
	}
}
