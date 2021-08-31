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
	import jewel.todomvc.services.ILocalStorageDelegate;
	import jewel.todomvc.vos.TodoVO;

	import org.apache.royale.collections.ArrayList;
	import org.apache.royale.collections.IArrayList;

	/**
     * The Todo Controller holds all the global actions. The views dispatch events that bubbles and
	 * this class register to these evens and updates the model, so views can update accordingly using
	 * binding most of the times.
     */
	public class TodoController
	{
        /**
		 *  Common todo model
		 */
		//example of injection where name of source is different to local name
		[Inject(source = "todoModel")]
		public var model:TodoModel;

		/**
		 * the service delegate to store data in the browser
		 */
		[Inject(source = "localStorageDelegate")]
		public var delegate:ILocalStorageDelegate;

		/**
		 *  [PostConstruct] methods are invoked after all dependencies are injected.
		 *  In this example, we set up a default user after the bean is created.
		 */
		[PostConstruct]
		public function setUp():void {
			// retrieve local items and use it if exists
			model.allItems = new ArrayList(delegate.getItemStore());
			
			model.setUpFilteredCollections();
			model.listItems = model.allItems;

			updateInterface();
        }
		
        /**
         *  Add the todo item to the list, save data and refresh the list state 
         */
		[EventHandler(event="TodoEvent.ADD_TODO_ITEM", properties="todo")]
        public function addTodoItem(todo:TodoVO):void {
            model.allItems.addItem(todo);
			
			saveDataToLocal();
			updateInterface();
        }
        
		/**
         *  Mark all todo items as completed or uncompleted, save data and update the interface accordingly
         */
		[EventHandler(event="TodoEvent.TOGGLE_ALL_COMPLETE")]
        public function toggleAllComplete(event:TodoEvent):void {
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
		[EventHandler(event="TodoEvent.REMOVE_COMPLETED")]
        public function removeCompleted(event:TodoEvent):void {
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
		[EventHandler(event="TodoEvent.REFRESH_LIST", properties="label")]
        public function refreshList(label:String):void
		{
			if(model.filterState != label) {
				model.filterState = label;

				setListState();
			}
		}

		/**
		 *  When some todo item change state (done/undone), we must save data and update the interface accordingly
		 */
		[EventHandler(event="TodoEvent.ITEM_STATE_CHANGED", properties="todo, completion")]
        public function itemStateChangedHandler(todo:TodoVO, completion:String):void {
			todo.done = completion;
			model.allItems.itemUpdated(todo);

			saveDataToLocal();
			updateInterface();
		}

		/**
		 *  Commit the label changes to the item and save data
		 *  if label is empty, remove todo item
		 */
		[EventHandler(event="TodoEvent.ITEM_LABEL_CHANGED", properties="todo, label")]
        public function itemLabelChangedHandler(todo:TodoVO, label:String):void {
			if(label != ""){
				todo.label = label;
				model.allItems.itemUpdated(todo);
			}
			else {
				model.allItems.removeItem(todo);
			}

			saveDataToLocal();
			updateInterface();
		}

		/**
		 *  When the user click in the renderer destroy button we must remove the item, save data and update the interface
		 */
		[EventHandler(event="TodoEvent.ITEM_REMOVED", properties="todo")]
        public function itemRemovedHandler(todo:TodoVO):void {
			model.allItems.removeItem(todo);

			saveDataToLocal();
            updateInterface();
		}

		/**
         *  Saves the actual data to the local storage via Local SharedObject
         */
        protected function saveDataToLocal():void {
			try {
				delegate.setItemStore(model.allItems.source);
			} catch (error:Error) {
				trace("You need to be online to store locally");
			}
		}

		/**
		 *  Update the interface accordingly
		 */
		protected function updateInterface():void {
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
