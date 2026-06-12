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
package org.apache.royale.style.beads
{
	import org.apache.royale.collections.ITreeData;
	import org.apache.royale.events.ItemClickedEvent;
	import org.apache.royale.utils.sendEvent;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.ItemAddedEvent;
	import org.apache.royale.events.ItemRemovedEvent;

	/**
	 * Controller for tree item selection and node expansion.
	 *
	 * @langversion 3.0
	 * @productversion Royale 1.0.0
	 */
	public class TreeController extends ListController
	{
		/**
		 * Creates a TreeController bead.
		 */
		public function TreeController()
		{
			super();
		}

		/**
		 * Toggles a tree node when an item renderer dispatches an itemExpanded event.
		 *
		 * @langversion 3.0
		 * @productversion Royale 1.0.0
		 */
		protected function expandedHandler(event:ItemClickedEvent):void
		{
			var treeData:ITreeData = listModel.dataProvider as ITreeData;
			if (treeData == null) return;
			
			var node:Object = event.data;
			
			if (treeData.hasChildren(node))
			{
				if (treeData.isOpen(node)) {
					treeData.closeNode(node);
				} else {
					treeData.openNode(node);
				}
			}
		}

		/**
		 * Updates selection and dispatches an itemExpanded event from the item renderer.
		 *
		 * @langversion 3.0
		 * @productversion Royale 1.0.0
		 *
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		override protected function selectedHandler(event:ItemClickedEvent):void
		{
			super.selectedHandler(event);

			var itemExpandedEvent:ItemClickedEvent = new ItemClickedEvent("itemExpanded");
				itemExpandedEvent.index = event.index;
				itemExpandedEvent.data = event.data;

			sendEvent(event.target as IEventDispatcher, itemExpandedEvent);
		}

		/**
		 * Adds tree expansion handling to an item renderer.
		 *
		 * @langversion 3.0
		 * @productversion Royale 1.0.0
		 *
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		override protected function handleItemAdded(event:ItemAddedEvent):void
		{
			super.handleItemAdded(event);
			IEventDispatcher(event.item).addEventListener("itemExpanded", expandedHandler);
		}
		
		/**
		 * Removes tree expansion handling from an item renderer.
		 *
		 * @langversion 3.0
		 * @productversion Royale 1.0.0
		 *
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		override protected function handleItemRemoved(event:ItemRemovedEvent):void
		{
			super.handleItemRemoved(event);
			IEventDispatcher(event.item).removeEventListener("itemExpanded", expandedHandler);
		}
	}
}