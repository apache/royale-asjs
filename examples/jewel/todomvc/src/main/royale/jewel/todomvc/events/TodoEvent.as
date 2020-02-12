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
package jewel.todomvc.events
{
	import jewel.todomvc.vos.TodoVO;

	import org.apache.royale.events.Event;

	/**
	 * Todo Event
	 */
	public class TodoEvent extends Event
	{
		/**
		 * Actions
		 */
		public static const ADD_TODO_ITEM:String = "add_Todo_Item";
		public static const TOGGLE_ALL_COMPLETE:String = "toggle_all_complete";
		public static const REMOVE_COMPLETED:String = "remove_completed";
		public static const REFRESH_LIST:String = "refresh_list";
		public static const ITEM_STATE_CHANGED:String = "item_state_changed";
		public static const ITEM_LABEL_CHANGED:String = "item_label_changed";
		public static const ITEM_REMOVED:String = "item_removed";

		/**
		 * The todo to pass between layers
		 */
		public var todo:TodoVO;
		
		/**
		 * Use to send the filter state label or the changes in a todo item label
		 */
		public var label:String;
		
		/**
		 * To send the state of the item (done/undone)
		 */
		public var completion:Boolean;

        /**
         * constructor
		 * 
		 * event need to bubble up to be catched for the views
         */
		public function TodoEvent(type:String, todo:TodoVO = null, label:String = null, completion:Boolean = false) {
			super(type, true);

			this.todo = todo;
			this.label = label;
			this.completion = completion
		}
	}
}