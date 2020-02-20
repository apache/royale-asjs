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
	import org.apache.royale.html.beads.controllers.ListSingleSelectionMouseController;
	import org.apache.royale.core.IItemRenderer;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.ItemAddedEvent;
	import org.apache.royale.events.ItemRemovedEvent;
	import org.apache.royale.events.ItemClickedEvent;
	import org.apache.royale.events.ItemRendererEvent;

	public class TodoListSingleSelectionMouseController extends ListSingleSelectionMouseController {
	
		/**
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		override protected function handleItemAdded(event:ItemAddedEvent):void
		{
			super.handleItemAdded(event);
			IEventDispatcher(event.item).addEventListener("checkChanged", propagateHandler);
			IEventDispatcher(event.item).addEventListener("removeRequest", propagateHandler);
		}
		
		/**
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		override protected function handleItemRemoved(event:ItemRemovedEvent):void
		{
			super.handleItemRemoved(event);
			IEventDispatcher(event.item).removeEventListener("checkChanged", propagateHandler);
			IEventDispatcher(event.item).removeEventListener("removeRequest", propagateHandler);
		}
		
		protected function propagateHandler(event:ItemClickedEvent):void
		{
			var e:ItemRendererEvent = new ItemRendererEvent(event.type);
			e.itemRenderer = event.target as IItemRenderer;
            listView.host.dispatchEvent(e);
		}
		
	}
}
