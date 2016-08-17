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
package sample.todo.controllers {
	import org.apache.flex.core.Application;
	import org.apache.flex.core.IDocument;
	import org.apache.flex.events.Event;

	import sample.todo.events.TodoListEvent;
	import sample.todo.models.TodoListModel;

	public class TodoListController implements IDocument {
		private var app:Application;

		public function TodoListController(app:Application = null) {
			if (app != null) {
				this.app = app;
			}
		}

		/**
		 *
		 */
		public function setDocument(document:Object, id:String = null):void {
			app = document as Application;
			app.addEventListener("viewChanged", viewChangeHandler);
		}

		/**
		 *
		 * @param event
		 */
		private function viewChangeHandler(event:Event):void {
			app.initialView.addEventListener(TodoListEvent.LOG_TODO, logTodo);
			app.initialView.addEventListener(TodoListEvent.ITEM_CHECKED,handleItemChecked);
			app.initialView.addEventListener(TodoListEvent.ITEM_REMOVE_REQUEST, handleItemRemove);
		}

		/**
		 * log todo
		 * @param event
		 */
		public function logTodo(evt:TodoListEvent):void {
			// still need to change model a view get the changes
			var todoModel:TodoListModel = app.model as TodoListModel;
			//todoModel.todos.push({title: evt.todo, selected: false});
			todoModel.addTodo(evt.todo);
		}

		public function handleItemChecked(event:TodoListEvent):void {
			var model: TodoListModel = app.model as TodoListModel;
			model.toggleItemCheck(event.item);
		}

		public function handleItemRemove(event:TodoListEvent):void {
			var model: TodoListModel = app.model as TodoListModel;
			model.removeItem(event.item);
		}
	}
}
