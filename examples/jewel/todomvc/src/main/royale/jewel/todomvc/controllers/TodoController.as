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

	import org.apache.royale.core.IBeadController;
	import org.apache.royale.core.IBeadModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.IEventDispatcher;

	[Bindable]
    /**
     * The Todo Controller holds all the global actions. The views dispatch events that bubbles and
	 * this class register to these evens and updates the model, so views can update accordingly using
	 * binding most of the times.
     */
	public class TodoController implements IBeadController
	{
        /**
		 *  constructor.
		 */
        public function TodoController():void
		{
        }

        private var _strand:IStrand;
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function set strand(value:IStrand):void {
			_strand = value;
			IEventDispatcher(_strand).addEventListener(TodoEvent.ADD_TODO_ITEM, addTodoItem);            
			IEventDispatcher(_strand).addEventListener(TodoEvent.MARK_ALL_COMPLETE, markAllComplete);            
			IEventDispatcher(_strand).addEventListener(TodoEvent.REMOVE_COMPLETED, removeCompleted);            
			IEventDispatcher(_strand).addEventListener(TodoEvent.REFRESH_LIST, refreshList);            
			IEventDispatcher(_strand).addEventListener(TodoEvent.REFRESH_LIST_BY_USER, refreshListByUser);            
			IEventDispatcher(_strand).addEventListener(TodoEvent.ITEM_STATE_CHANGED, itemStateChangedHandler);            
			IEventDispatcher(_strand).addEventListener(TodoEvent.ITEM_LABEL_CHANGED, itemLabelChangedHandler);            
			IEventDispatcher(_strand).addEventListener(TodoEvent.ITEM_REMOVED, itemRemovedHandler);            
			
        	model = _strand.getBeadByType(IBeadModel) as TodoModel;
			model.listItems = model.allItems;
        }

		/**
		 *  Common todo model
		 */
		private var model:TodoModel;
		
        /**
         *  Add the todo item to the list and refresh the list state 
         */
        protected function addTodoItem(event:TodoEvent):void {
            model.allItems.addItem(event.todo);
            updateInterface();
        }
        
		/**
         *  Mark all todo items as completed and update items left and clear completed button visibility
         */
        protected function markAllComplete(event:TodoEvent):void {
            var len:int = model.allItems.length
			var item:TodoVO;
			for(var i:int = 0; i < len; i++) {
				item = TodoVO(model.allItems.getItemAt(i));
				item.done = true;
			}

			updateInterface();
        }

		/**
         *  Remove all completed todo items, update footer and toggle all button visibility
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

			model.footerVisibility = model.allItems.length != 0 ? true : false;
			model.toogleAllVisibility = model.allItems.length != 0 ? true : false;
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
         *  Refresh the todo list to the appropiate filter state (All, Active or Completed)
         */
        protected function refreshListByUser(event:TodoEvent):void
		{
			if(model.filterState != event.label) {
				model.filterState = event.label;
				
				model.router.routeState.title = "TodoMVC - " + model.filterState + " State";
				model.router.routeState.state = model.filterState;
				model.router.setState();

				setListState();
			}
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
				model.listItems = model.activeItems;
			}
			else if(model.filterState == TodoModel.COMPLETED_FILTER) {
				model.listItems = model.completedItems;
			}
		}

		/**
		 *  When some todo item change state (done/undone), we must update the interface accordingly
		 */
        public function itemStateChangedHandler(event:TodoEvent = null):void {
			event.todo.done = event.completion;
			updateInterface();
		}

		/**
		 *  Commit the label changes to the item
		 */
        public function itemLabelChangedHandler(event:TodoEvent = null):void {
			event.todo.label = event.label;
		}

		/**
		 *  When the user click in the renderer destroy button we must remove the item and update the interface
		 */
        public function itemRemovedHandler(event:TodoEvent):void {
			model.allItems.removeItem(event.todo);
            updateInterface();
		}

		/**
		 *  Update the interface accordingly
		 */
		public function updateInterface():void {
			setListState();

			model.itemsLeftLabel = model.activeItems.length + " item left";
            model.clearCompletedVisibility = model.completedItems.length != 0 ? true : false;
			model.footerVisibility = model.allItems.length != 0 ? true : false;
			model.toogleAllVisibility = model.allItems.length != 0 ? true : false;
        }
	}
}
