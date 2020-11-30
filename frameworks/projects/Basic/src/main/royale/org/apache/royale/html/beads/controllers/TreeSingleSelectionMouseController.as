////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//	  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
package org.apache.royale.html.beads.controllers
{
	import org.apache.royale.collections.ITreeData;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.ItemAddedEvent;
	import org.apache.royale.events.ItemClickedEvent;
	import org.apache.royale.events.ItemRemovedEvent;
	import org.apache.royale.utils.sendStrandEvent;

	/**
	 *  The TreeSingleSelectionMouseController class is a controller for 
	 *  org.apache.royale.html.Tree. This controller watches for selection
	 *  events on the tree item renderers and uses those events to open
	 *  or close nodes of the tree.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class TreeSingleSelectionMouseController extends ListSingleSelectionMouseController
	{
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function TreeSingleSelectionMouseController()
		{
			super();
		}

		/**
		 * @private
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
			/** what is this for? was in selectedHandler
			// reset the selection
			listModel.selectedItem = node;
			sendStrandEvent(_strand,"change");
			*/
		}
		
		/**
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		override protected function handleItemAdded(event:ItemAddedEvent):void
		{
			super.handleItemAdded(event);
			IEventDispatcher(event.item).addEventListener("itemExpanded", expandedHandler);
		}
		
		/**
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		override protected function handleItemRemoved(event:ItemRemovedEvent):void
		{
			super.handleItemRemoved(event);
			IEventDispatcher(event.item).removeEventListener("itemExpanded", expandedHandler);
		}
	}
}
