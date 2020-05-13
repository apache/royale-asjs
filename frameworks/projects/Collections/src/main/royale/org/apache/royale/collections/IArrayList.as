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

    //--------------------------------------
	
	/**
	 *  Support for Arraylike access (typed index access via []) and also via iteration when used with for-each loops.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	[RoyaleArrayLike(getValue="getItemAt",setValue="setItemAt",setterArgSequence="value,index",length="length",lengthAccess="getter")]
	
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
	public interface IArrayList extends IEventDispatcher
	{
        /**
         *  The array of raw data needing conversion.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		function get source():Array;
		function set source(value:Array):void;

		/**
		 * Returns a copy of the source array.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
		 */
		function toArray():Array;

        /**
         *  Fetches an item from the collection
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        function getItemAt(index:int):Object;

		/**
		 *  Fetches an item from the collection given an index.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		function getItemIndex(item:Object):int;

		/**
		 *  Adds an item to the end of the array.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		function addItem(item:Object):void;

		/**
		 *  Inserts an item to a specific location within the array.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		function addItemAt(item:Object, index:int):void;

		/**
		 *  Replaces the item at the given index with a new item and
		 *  returns the old item.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		function setItemAt(item:Object, index:int):Object;

		/**
		 *  Removed an item from the array and returns it.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		function removeItem(item:Object):Boolean;

		/**
		 *  Removes an item from a specific location within the array and
		 *  returns it.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		function removeItemAt(index:int):Object;

		/**
		 *  Removes all of the items from the array.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		function removeAll():void;

		/**
		 *  Signals that an item in the array has been updated.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		function itemUpdated(item:Object):void;

		/**
		 *  Signals that an item in the array has been updated.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		function itemUpdatedAt(index:int):void;

        /**
         *  The number of items.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        function get length():int;

	}
}
