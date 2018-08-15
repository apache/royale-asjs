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
package org.apache.royale.collections
{
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.events.CollectionEvent;

	/**
	 * TreeData is used with tree or structured data classes. This class incorporates
	 * a HierarchicalData structure as its primary source, but then internally flattens
	 * it for presentation.
	 */
	public class TreeData extends EventDispatcher implements ICollectionView, ITreeData
	{
		public function TreeData(source:HierarchicalData)
		{
			_hierarchicalData = source;
			_flatList = new FlattenedList(source);
			
			_flatList.addEventListener(CollectionEvent.ITEM_ADDED, handleCollectionEvent);
			_flatList.addEventListener(CollectionEvent.ITEM_REMOVED, handleCollectionEvent);
			_flatList.addEventListener(CollectionEvent.ITEM_UPDATED, handleCollectionEvent);
		}
		
		/**
		 * Forwards CollectionEvents from the internal FlattenedList as if they came
		 * from this TreeData, further mimicking an ICollectionView.
		 * 
		 * @private
		 */
		private function handleCollectionEvent(event:CollectionEvent):void
		{
			var newEvent:CollectionEvent = new CollectionEvent(event.type);
			newEvent.item = event.item;
			newEvent.index = event.index;
			dispatchEvent(newEvent);
		}
		
		private var _hierarchicalData:HierarchicalData;
		private var _flatList:FlattenedList;
		
		// Working with Trees
		
		public function hasChildren(node:Object):Boolean
		{
			return _flatList.hasChildren(node);
		}
		
		public function isOpen(node:Object):Boolean
		{
			return _flatList.isOpen(node);
		}
		
		public function openNode(node:Object):void
		{
			_flatList.openNode(node);
		}
		
		public function closeNode(node:Object):void
		{
			_flatList.closeNode(node);
		}
		
		public function getDepth(node:Object):int
		{
			return _flatList.getDepth(node);
		}
		
		// ICollectionData
		
		public function get length():int
		{
			return _flatList.length;
		}
		public function getItemAt(index:int):Object
		{
			return _flatList.getItemAt(index);
		}
		public function getItemIndex(item:Object):int
		{
			return _flatList.getItemIndex(item);
		}
		public function addItem(item:Object):void
		{
			_flatList.addItem(item);
		}
		public function addItemAt(item:Object, index:int):void
		{
			_flatList.addItemAt(item, index);
		}
		public function setItemAt(item:Object, index:int):Object
		{
			return _flatList.setItemAt(item, index);
		}
		public function removeItem(item:Object):Boolean
		{
			return _flatList.removeItem(item);
		}
		public function removeItemAt(index:int):Object
		{
			return _flatList.removeItemAt(index);
		}
		public function removeAll():void
		{
			_flatList.removeAll();
		}
		public function itemUpdated(item:Object):void
		{
			_flatList.itemUpdated(item);
		}
		public function itemUpdatedAt(index:int):void
		{
			_flatList.itemUpdatedAt(index);
		}
	}
}