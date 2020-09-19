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
	COMPILE::JS{
		import org.apache.royale.utils.net.IDataInput;
		import org.apache.royale.utils.net.IDataOutput;
	}
	COMPILE::SWF{
		import flash.utils.IDataInput;
		import flash.utils.IDataOutput;
	}
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.CollectionEvent;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.utils.net.IExternalizable;

    //--------------------------------------
    //  Events
    //--------------------------------------

	/**
	 *  Dispatched when the collection's underlying source array
	 *  is changed.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	[Event(name="collectionChanged", type="org.apache.royale.events.CollectionEvent")]

	/**
	 *  Dispatched when the collection has added an item.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	[Event(name="itemAdded", type="org.apache.royale.events.CollectionEvent")]

	/**
	 *  Dispatched when the collection has removed an item.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	[Event(name="itemRemoved", type="org.apache.royale.events.CollectionEvent")]

    /**
     *  Dispatched when the collection has updated an item.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    [Event(name="allItemsRemoved", type="org.apache.royale.events.CollectionEvent")]

	/**
	 *  Dispatched when the collection has updated an item.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	[Event(name="itemUpdated", type="org.apache.royale.events.CollectionEvent")]


	[DefaultProperty("source")]
    /**
     *  The ArrayList class provides an event-driven wrapper for the
	 *  standard Array. Events are dispatched when items are added, removed,
	 *  or changed.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class ArrayList extends EventDispatcher implements IBead, ICollectionView, IArrayList, IExternalizable
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function ArrayList(initialSource:Array=null)
		{
			super();
			if (initialSource) _source = initialSource;
			else _source = [];
		}

        private var _id:String;

        /**
         *  @copy org.apache.royale.core.UIBase#id
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function get id():String
		{
			return _id;
		}

        /**
         *  @private
         */
		public function set id(value:String):void
		{
			if (_id != value)
			{
				_id = value;
				dispatchEvent(new Event("idChanged"));
			}
		}

        private var _strand:IStrand;

        /**
         *  @copy org.apache.royale.core.UIBase#strand
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function set strand(value:IStrand):void
        {
            _strand = value;
			_source = new Array();
        }

		private var _source:Array;

        /**
         *  The array of raw data needing conversion.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function get source():Array
		{
			return _source;
		}

		public function set source(value:Array):void
		{
			if (_source != value) {
				if (value == null)
				{
					_source = [];
                }
				else
				{
					_source = value;
                }

				dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGED));
			}
		}

		/**
		 * Returns a copy of the source array.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
		 */
		public function toArray():Array
		{
			return _source.concat();
		}

        /**
         *  Fetches an item from the collection
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function getItemAt(index:int):Object
        {
            return _source[index];
        }

		/**
		 *  Fetches an item from the collection given an index.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function getItemIndex(item:Object):int
		{
			return _source.indexOf(item);
		}

		/**
		 *  Adds an item to the end of the array.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function addItem(item:Object):void
		{
			addItemAt(item, length);
		}

		/**
		 *  Inserts an item to a specific location within the array.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function addItemAt(item:Object, index:int):void
		{
			const spliceUpperBound:int = length;

			if (index < spliceUpperBound && index > 0)
			{
				source.splice(index, 0, item);
			}
			else if (index == spliceUpperBound)
			{
				source.push(item);
			}
			else if (index == 0)
			{
				source.unshift(item);
			}
			else
			{
				// error
				return;
			}

			var collectionEvent:CollectionEvent = new CollectionEvent(CollectionEvent.ITEM_ADDED);
			collectionEvent.item = item;
			collectionEvent.index = index;
			dispatchEvent(collectionEvent);

			dispatchEvent(new Event("lengthChanged"));
		}

		/**
		 *  Replaces the item at the given index with a new item and
		 *  returns the old item.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function setItemAt(item:Object, index:int):Object
		{
			const spliceUpperBound:int = length;
			var oldItem:Object;

			if (index >= 0 && index < spliceUpperBound) {
				oldItem = source[index];
				source[index] = item;

                var collectionEvent:CollectionEvent = new CollectionEvent(CollectionEvent.ITEM_UPDATED);
                collectionEvent.item = item;
				collectionEvent.index = index;
				dispatchEvent(collectionEvent);
			}
			else {
				// error
			}

			return oldItem;
		}

		/**
		 *  Removed an item from the array and returns it.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function removeItem(item:Object):Boolean
		{
			var index:int = getItemIndex(item);
			var result:Boolean = index >= 0;
			if (result) {
				removeItemAt(index);
			}
			return result;
		}

		/**
		 *  Removes an item from a specific location within the array and
		 *  returns it.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function removeItemAt(index:int):Object
		{
			const spliceUpperBound:int = length - 1;
			var removed:Object;

			if (index > 0 && index < spliceUpperBound)
			{
				removed = source.splice(index, 1)[0];
			}
			else if (index == spliceUpperBound)
			{
				removed = source.pop();
			}
			else if (index == 0)
			{
				removed = source.shift();
			}
			else {
				// error
				return null;
			}

            var collectionEvent:CollectionEvent = new CollectionEvent(CollectionEvent.ITEM_REMOVED);
            collectionEvent.item = removed;
			collectionEvent.index = index;
            dispatchEvent(collectionEvent);

			dispatchEvent(new Event("lengthChanged"));

			return removed;
		}

		/**
		 *  Removes all of the items from the array.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function removeAll():void
		{
			if (length > 0)
			{
                var collectionEvent:CollectionEvent = new CollectionEvent(CollectionEvent.ALL_ITEMS_REMOVED);
                collectionEvent.items = source.splice(0, length);
				collectionEvent.index = -1;
                dispatchEvent(collectionEvent);
			}
		}

		/**
		 *  Signals that an item in the array has been updated.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function itemUpdated(item:Object):void
		{
			var index:int = getItemIndex(item);
			if (index >= 0)
			{
                var collectionEvent:CollectionEvent = new CollectionEvent(CollectionEvent.ITEM_UPDATED);
                collectionEvent.item = item;
				collectionEvent.index = index;
                dispatchEvent(collectionEvent);
			}
		}

		/**
		 *  Signals that an item in the array has been updated.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function itemUpdatedAt(index:int):void
		{
			var collectionEvent:CollectionEvent = new CollectionEvent(CollectionEvent.ITEM_UPDATED);
			collectionEvent.item = getItemAt(index);
			collectionEvent.index = index;
			dispatchEvent(collectionEvent);
		}

		/**
		 *  The number of items.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		[Bindable("lengthChanged")]
		public function get length():int
		{
			return _source ? _source.length : 0;
		}
		
		
		/**
		 *  @private
		 *  Ensures that only the source property is serialized.
		 *  @royaleignorecoercion Array
		 */
		public function readExternal(input:IDataInput):void
		{
			source = input.readObject() as Array;
		}
		
		/**
		 *  @private
		 *  Ensures that only the source property is serialized.
		 */
		public function writeExternal(output:IDataOutput):void
		{
			output.writeObject(source);
		}

	}
}
