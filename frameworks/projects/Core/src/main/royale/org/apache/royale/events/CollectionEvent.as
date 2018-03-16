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
package org.apache.royale.events
{
	/**
	 * The CollectionEvent class is used for dispatching an collection events
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10.2
	 * @playerversion AIR 2.6
	 * @productversion Royale 0.9.0
     * 
     *  @royalesuppresspublicvarwarning
	 */
	public class CollectionEvent extends Event
	{
		public static const ITEM_ADDED:String = "itemAdded";
		public static const ITEM_REMOVED:String = "itemRemoved";
        public static const ALL_ITEMS_REMOVED:String = "allItemsRemoved";
		public static const ITEM_UPDATED:String = "itemUpdated";
		public static const COLLECTION_CHANGED:String = "collectionChanged";

		//--------------------------------------
		//   Constructor
		//--------------------------------------

		/**
		 * Constructor.
		 *
		 * @param type The name of the event.
		 * @param bubbles Whether the event bubbles.
		 * @param cancelable Whether the event can be canceled.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10.2
		 * @playerversion AIR 2.6
		 * @productversion Royale 0.9.0
		 */
		public function CollectionEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
            super(type, bubbles, cancelable);                    
		}
		
		/**
		 * The index of the item added, removed, or changed
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.9.0
		 */
		public var index:int;

        /**
         * The item being removed/added/updated
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.9.0
         */
        public var item:Object;

        /**
         * The items being removed
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.9.0
         */
		public var items:Array;

        override public function cloneEvent():IRoyaleEvent
        {
            var collectionEvent:CollectionEvent = new CollectionEvent(type, bubbles, cancelable);
			collectionEvent.item = item;
			collectionEvent.items = items;
			collectionEvent.index = index;

			return collectionEvent;
        }
    }
}
