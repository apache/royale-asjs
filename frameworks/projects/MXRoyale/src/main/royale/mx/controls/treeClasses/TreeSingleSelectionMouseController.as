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
package mx.controls.treeClasses
{
	import mx.controls.Tree;
	import mx.events.ItemClickEvent;
	import mx.events.TreeEvent;
	
	import org.apache.royale.collections.ITreeData;
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.ItemClickedEvent;
	import org.apache.royale.html.beads.controllers.TreeSingleSelectionMouseController;
	import org.apache.royale.utils.sendEvent;

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
	public class TreeSingleSelectionMouseController extends org.apache.royale.html.beads.controllers.TreeSingleSelectionMouseController
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
		override protected function selectedHandler(event:ItemClickedEvent):void
		{
			listModel.selectedIndex = event.index;
			listModel.selectedItem = event.data;
			sendEvent(listView.host,"change");

		    var newEvent:ItemClickEvent = new ItemClickEvent(ItemClickEvent.ITEM_CLICK);
            	newEvent.index = event.index;
            IEventDispatcher(_strand).dispatchEvent(newEvent);
		}	    

		/**
		 * @private
		 */
		override public function set strand(value:IStrand):void
		{
			if (listModel)
			{
				listModel.removeEventListener("dataProviderChanged", handleDataProviderChanged);
			}
			super.strand = value;
			listModel.addEventListener("dataProviderChanged", handleDataProviderChanged);
			handleDataProviderChanged(null);
		}

		private var modelDP:IEventDispatcher;

		protected function handleDataProviderChanged(event:Event):void
		{
			if (modelDP)
			{
				modelDP.removeEventListener(TreeEvent.ITEM_OPEN, handleItemOpen);
			}
			modelDP = listModel.dataProvider as IEventDispatcher;
			if (!modelDP)
				return;
			modelDP.addEventListener(TreeEvent.ITEM_OPEN, handleItemOpen);
		}

		protected function handleItemOpen(event:TreeEvent):void
		{
			IEventDispatcher(_strand).dispatchEvent(event);
		}

		override protected function expandedHandler(event:ItemClickedEvent):void
		{
			var treeData:org.apache.royale.collections.ITreeData = listModel.dataProvider as org.apache.royale.collections.ITreeData;
			if (treeData == null) return;
			
			var node:Object = event.data;
			var isBranch : Boolean = (_strand as Tree).dataDescriptor.isBranch(node);
			
			if (isBranch || treeData.hasChildren(node))
			{
				if (treeData.isOpen(node)) {
					treeData.closeNode(node);
				} else {
					treeData.openNode(node);
				}
			}
		}
	}
}
