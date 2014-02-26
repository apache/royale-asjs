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
package controller {

	import org.apache.flex.core.Application;
	import org.apache.flex.core.IDocument;
	import org.apache.flex.events.Event;
	
	import model.TodoListModel;
    	
	public class TodoListController implements IDocument {
		private var app:TodoListSampleApp;
		private var model:TodoListModel;
		
		public function TodoListController(app:Application = null) {
			if (app != null) {
				app = app as TodoListSampleApp;
			}
		}
		
		/**
		 * 
		 */
		public function setDocument(document:Object, id:String = null):void {
			this.app = document as TodoListSampleApp;
		}
		
	}
}