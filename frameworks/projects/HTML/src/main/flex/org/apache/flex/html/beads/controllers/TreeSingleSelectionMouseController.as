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
package org.apache.flex.html.beads.controllers
{
	import org.apache.flex.collections.FlattenedList;
	import org.apache.flex.html.Tree
	import org.apache.flex.events.ItemClickedEvent;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;

	/**
	 *  The TreeSingleSelectionMouseController class is a controller for 
	 *  org.apache.flex.html.Tree. This controller watches for selection
	 *  events on the tree item renderers and uses those events to open
	 *  or close nodes of the tree.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class TreeSingleSelectionMouseController extends ListSingleSelectionMouseController
	{
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function TreeSingleSelectionMouseController()
		{
			super();
		}

		private var _strand:IStrand;

		/**
		 * @private
		 */
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			super.strand = value;
		}

		/**
		 * @private
		 */
		override protected function selectedHandler(event:ItemClickedEvent):void
		{
			var tree:Tree = _strand as Tree;
			var flatList:FlattenedList = listModel.dataProvider as FlattenedList;
			var node:Object = event.data;
			
			if (flatList.isOpen(node)) {
				flatList.closeNode(node);
			} else {
				flatList.openNode(node);
			}
			
			listModel.selectedItem = node;
			listModel.dispatchEvent(new Event("dataProviderChanged"));
			
			IEventDispatcher(_strand).dispatchEvent(new Event("change"));
		}
	}
}
