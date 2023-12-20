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
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.collections.parsers.IInputParser;
	import org.apache.royale.collections.converters.IItemConverter;
	
	
	/**
	 *  The FlattenedList class takes a HierarchicalData object and "flattens" it
	 *  using all of the open members.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 * 
	 *  @royalesuppresspublicvarwarning
	 */
	public class FlattenedList extends ArrayList
	{
		public var hdata:IHierarchicalData;
		public var openNodes:Array;
		
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function FlattenedList(hdata:IHierarchicalData)
		{
			super();
			this.hdata = hdata;
			this.openNodes = [];
			reset();
		}
		
		/**
		 * Resets the list so that only the top root node is open.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function reset():void
		{
			var arr:Array = [];
			addChildren(hdata.getRoot(), arr);
			source = arr;
		}
		
		/**
		 * @private
		 */
		protected function addChildren(node:Object, arr:Array):void
		{
			var children:Array = hdata.getChildren(node) as Array;
			var n:int = children.length;
			
			for (var i:int=0; i < n; i++) {
				arr.push(children[i]);
				if (isOpen(children[i])) {
					addChildren(children[i], arr);
				}
			}
		}
		
		/**
		 * Returns true if the node has children nodes.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function hasChildren(node:Object):Boolean
		{
			return hdata.hasChildren(node);
		}
		
		/**
		 * Returns true if the node is currently open.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function isOpen(node:Object):Boolean
		{
			return openNodes.indexOf(node) != -1;
		}
		
		/**
		 * Opens the given node. The array data now contains more elements.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function openNode(node:Object):void
		{
			if (hdata.hasChildren(node)) {
				openNodes.push(node);
				var arr:Array = [];
				addChildren(node, arr);
				var i:int = getItemIndex(node);
				while (arr.length) {
					super.addItemAt(arr.shift(), ++i);
				}
			}
			updateNode(node);
		}
		
		/**
		 * Closes the given node. The array data now contains fewer elements.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
		 */
		public function closeNode(node:Object):void
		{
			var hasChildren:Boolean = hdata.hasChildren(node);
			var i:int = openNodes.indexOf(node);
			if (i != -1) {
				
				if (hasChildren) {
					var children:Array = hdata.getChildren(node) as Array;
					var n:int = children.length;
					for (var j:int=0; j < n; j++) {
						closeNode(children[j]);
					}
				}
				
				openNodes.splice(i, 1);
				var arr:Array = [];
				addChildren(node, arr);
				// removing them backwards should improve performance in most cases
				i = getItemIndex(node) + arr.length;
				var len:int = arr.length;
				for(var idx:int = 0; idx < len; idx++)
				{
					super.removeItemAt(i--);
				}
			}
			if(hasChildren)
				updateNode(node);
		}
		
		/**
		 * Singles to the node that its state has changed and it should
		 * update itself
		 */
		public function updateNode(node:Object):void
		{
			this.itemUpdated(node);
		}
		
		/**
		 * Returns the depth of the node with the root being zero.
		 * 
		 * Returning the depth from the HierachicalData allows for optimization in client code.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function getDepth(node:Object):int
		{
			return hdata.getDepth(node);
		}

		/**
		 * When adding items from outside FlattenedList, it needs to be added to the data structure as well.
		 * @royaleignorecoercion Array
		 */
		override public function addItemAt(item:Object, index:int):void{
			super.addItemAt(item,index);
			var topLevel:Array = hdata.getChildren(hdata.getRoot()) as Array;
			var len:int = topLevel.length;
			if (index < len && index > 0)
				topLevel.splice(index, 0, item);

			else if (index == len)
				topLevel.push(item);

			else if (index == 0)
				topLevel.unshift(item);
		}

		/**
		 * When removing items from outside FlattenedList, it needs to be added to the data structure as well.
		 * @royaleignorecoercion Array
		 */
		override public function removeItemAt(index:int):Object{
			var topLevel:Array = hdata.getChildren(hdata.getRoot()) as Array;
			var upperIdx:int = topLevel.length - 1;
			if (index > 0 && index < upperIdx)
				topLevel.splice(index, 1);

			else if (index == upperIdx)
				topLevel.pop();

			else if (index == 0)
				topLevel.shift();
			
			return super.removeItemAt(index);
		}

	}
}
