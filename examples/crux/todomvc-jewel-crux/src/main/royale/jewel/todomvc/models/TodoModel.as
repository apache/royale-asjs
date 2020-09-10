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
package jewel.todomvc.models
{
	import jewel.todomvc.vos.TodoVO;

	import org.apache.royale.collections.ArrayList;
	import org.apache.royale.collections.ArrayListView;
	import org.apache.royale.collections.IArrayList;
	import org.apache.royale.collections.IArrayListView;
	import org.apache.royale.events.EventDispatcher;

    /**
     *  Todo Model stores global model variables that are updated by controller
     *  and used in views to update visuals for the user
     */
	[Bindable]
	public class TodoModel
	{
        /**
         * We have three todo list states: All, Active and Completed
         */
        public static const ALL_FILTER:String = "All";
        public static const ACTIVE_FILTER:String = "Active";
        public static const COMPLETED_FILTER:String = "Completed";

        /**
         * the list of items binded to the todo list component
         */
        public var listItems:IArrayList;
        
        /**
         * the real list with all items
         */
        public var allItems:ArrayList;

        /**
         * the filtered list with active items
         */
        public var activeItems:IArrayListView;
        
        /**
         * the filtered list with completed items
         */
        public var completedItems:IArrayListView;

        /**
         *  Set up the filtered collections for later use
         */
        public function setUpFilteredCollections():void {
            activeItems = filterItems(isActive);
            completedItems = filterItems(isCompleted);
        }
        /**
         *  Filter the items in the list creating an ArrayListView with the right filter function
         */
        public function filterItems(filterFunction:Function = null):ArrayListView {
            var alv:ArrayListView = new ArrayListView(allItems);
            alv.filterFunction = filterFunction;
            alv.refresh();
            return alv;
        }

        /**
         * filterFunction for the ArrayListView to get active items
         */
        public function isActive(item:TodoVO):Boolean {
            return item && item.done == false;
        }

        /**
         * filterFunction for the ArrayListView to get completed items
         */
        public function isCompleted(item:TodoVO):Boolean {
            return item && item.done == true;
        }

        /**
         * Stores the current filter for the list
         */
        public var filterState:String = TodoModel.ALL_FILTER;

        /**
         * true, toggle all todo items to completed state, false to all uncompleted
         */
        public var toggleAllToCompletedState:Boolean = false;
        
        /**
         * how many items left to do
         */
        public var itemsLeftLabel:String = "0 items left";
        
        /**
         * footer bar visibility
         */
        public var footerVisibility:Boolean = false;

        /**
         * toggle all button visibility
         */
        public var toogleAllVisibility:Boolean = false;

        /**
         * clear completed button visibility
         */
        public var clearCompletedVisibility:Boolean = false;
	}
}
