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
package sample.todo.models {
    import org.apache.royale.events.Event;
    import org.apache.royale.events.EventDispatcher;
    import sample.todo.vo.ToDoVO;

    public class TodoListModel extends EventDispatcher {
        public function TodoListModel() {
            super();
			_filterFunction();
        }

        private var _todos:Array = [new ToDoVO("Get something", true),
			new ToDoVO("Do this", true),
			new ToDoVO("Do that", false)];
		
		private var _filteredList:Array = [];
		private var _filterFunction:Function = showAllTodos;

        [Bindable("todoListChanged")]
        public function get todos():Array {
			return _filteredList;
        }

        public function set todos(value:Array):void {
            _todos = value;
			_filterFunction();
			dispatchEvent(new Event("todoListChanged"));
        }

        public function addTodo(value:String):Object
        {
			var item:Object = {title:value, selected:false};
			_todos.push(item);
			
			_filterFunction();
			
			return item;
        }
		
		public function showAllTodos() : void {
			_filteredList = _todos.slice();
			dispatchEvent(new Event("todoListChanged"));
			_filterFunction = showAllTodos;
		}
		
		public function showActiveTodos() : void {
			_filteredList = [];
			for (var i:int=0; i < _todos.length; i++) {
				if (!_todos[i].selected) {
					_filteredList.push(_todos[i]);
				}
			}
			dispatchEvent(new Event("todoListChanged"));
			_filterFunction = showActiveTodos;
		}
		
		public function showCompletedTodos() : void {
			_filteredList = [];
			for (var i:int=0; i < _todos.length; i++) {
				if (_todos[i].selected) {
					_filteredList.push(_todos[i]);
				}
			}
			dispatchEvent(new Event("todoListChanged"));
			_filterFunction = showCompletedTodos;
		}
		
		public function toggleItemCheck(item:Object) : void {
			item.selected = !item.selected;
			_filterFunction();
			dispatchEvent(new Event("todoListChanged"));
		}
		
		public function removeItem(item:Object) : void {
			var index:int = _todos.indexOf(item);
			if (index >= 0) {
				_todos.splice(index,1);
			}
			_filterFunction();
		}
    }
}
