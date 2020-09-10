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
    import org.apache.royale.collections.ArrayList;
    import org.apache.royale.collections.IArrayList;
    import org.apache.royale.events.CollectionEvent;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.EventDispatcher;

    /**
     *  Dispatched when the IArrayListView has been updated in some way.
     *
     *  @eventType org.apache.royale.events.CollectionEvent.COLLECTION_CHANGED
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.6
     */
    [Event(name="collectionChanged", type="org.apache.royale.events.CollectionEvent")]

    /**
     *  Dispatched when the collection has added an item.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.6
     */
    [Event(name="itemAdded", type="org.apache.royale.events.CollectionEvent")]

    /**
     *  Dispatched when the collection has removed an item.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.6
     */
    [Event(name="itemRemoved", type="org.apache.royale.events.CollectionEvent")]

    /**
     *  Dispatched when the collection has updated an item.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.6
     */
    [Event(name="allItemsRemoved", type="org.apache.royale.events.CollectionEvent")]

    /**
     *  Dispatched when the collection has updated an item.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.6
     */
    [Event(name="itemUpdated", type="org.apache.royale.events.CollectionEvent")]

    /**
     * The ArrayListView class adds the properties and methods of the
     * <code>IArrayListView</code> interface to an object that conforms to the
     * <code>IArrayList</code> interface. As a result, you can pass an object of this class
     * to anything that requires an <code>IArrayList</code> or <code>IArrayListView</code>.
     *
     * <p>This class also lets you use [ ] array notation
     * to access the <code>getItemAt()</code> and <code>setItemAt()</code> methods.
     * If you use code such as <code>myArrayListView[index]</code>
     * Flex calls the <code>myArrayListView</code> object's
     * <code>getItemAt()</code> or <code>setItemAt()</code> method.</p>
     *
     * @mxml
     *
     *  <p>The <code>&lt;mx:ArrayListView&gt;</code> has the following attributes,
     *  which all of its subclasses inherit:</p>
     *
     *  <pre>
     *  &lt;mx:ArrayListView
     *  <b>Properties</b>
     *  filterFunction="null"
     *  list="null"
     *  sort="null"
     *  <b>Events</b>
     *  collectionChanged="<i>No default</i>"
     *  /&gt;
     *  </pre>
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.6
     */
    public class ArrayListView extends EventDispatcher implements IArrayListView, IArrayList 
    {
        /**
         *  @private
         *  Used internally for managing disableAutoUpdate and enableAutoUpdate
         *  calls.  disableAutoUpdate increments the counter, enable decrements.
         *  When the counter reaches 0 handlePendingUpdates is called.
         */
        private var autoUpdateCounter:int;

        /**
         *  @private
         *  Any update events that occured while autoUpdateCounter > 0
         *  are stored here.
         *  This may be null when there are no updates.
         */
        private var pendingUpdates:Array;

        /**
         *  @private
         *  Flag that indicates whether a RESET type of collectionChange
         *  event should be emitted when reset() is called.
         */
        private var dispatchResetEvent:Boolean = true;


        //--------------------------------------------------------------------------
        //
        // Protected variables
        //
        //--------------------------------------------------------------------------

        /**
         *  When the view is sorted or filtered the <code>localIndex</code> property
         *  contains an array of items in the sorted or filtered (ordered, reduced)
         *  view, in the sorted order.
         *  The ArrayListView class uses this property to access the items in
         *  the view.
         *  The <code>localIndex</code> property should never contain anything
         *  that is not in the source, but may not have everything in the source.
         *  This property is <code>null</code> when there is no sort.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
        protected var localIndex:Array;

        //--------------------------------------------------------------------------
        //
        // Constructor
        //
        //--------------------------------------------------------------------------

        /**
         *  The ArrayListView constructor.
         *
         *  @param list the IArrayList this ArrayListView is meant to wrap.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
        public function ArrayListView(initialSource:ArrayList = null) {
            this.list = initialSource || new ArrayList();
            localIndex = null;
        }

        private var _id:String;

        /**
         *  @copy org.apache.royale.core.UIBase#id
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
        public function get id():String {
            return _id;
        }

        /**
         *  @private
         */
        public function set id(value:String):void {
            if (_id != value) {
                _id = value;
                dispatchEvent(new Event("idChanged"));
            }
        }
        
        /*   private var _strand:IStrand;
    
        /!**
            *  @copy org.apache.royale.core.UIBase#strand
            *
            *  @langversion 3.0
            *  @playerversion Flash 10.2
            *  @playerversion AIR 2.6
            *  @productversion Royale 0.9.6
            *!/
        public function set strand(value:IStrand):void {
            _strand = value;
        }*/

        //--------------------------------------------------------------------------
        //
        // Properties
        //
        //--------------------------------------------------------------------------

        //----------------------------------
        // length
        //----------------------------------

        [Bindable("lengthChanged")]

        /**
         *  The number of items currently in this view of the source ArrayList's data.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
        public function get length():int {

            if (localIndex) {
                return localIndex.length;
            }
            else if (list) {
                return list.length;
            }
            else {
                return 0;
            }
        }

        //----------------------------------
        //  list
        //----------------------------------

        /**
         *  @private
         *  Storage for the list property.
         */
        private var _list:ArrayList;

        [Inspectable(category="General")]
        [Bindable("listChanged")]

        /**
         *  The IArrayList that this collection view wraps.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
        public function get list():ArrayList {
            return _list;
        }

        /**
         *  @private
         */
        public function set list(value:ArrayList):void {
            if (_list != value) {
                var oldHasItems:Boolean;
                var newHasItems:Boolean;
                if (_list) {
                    toggleListListeners(_list, false);
                    oldHasItems = _list.length > 0;
                }

                _list = value;

                if (_list) {
                    toggleListListeners(_list, true);
                    newHasItems = _list.length > 0;
                }

                if (oldHasItems || newHasItems) reset();
                dispatchEvent(new Event("listChanged"));
            }
        }

        protected function toggleListListeners(list:ArrayList, toggleOn:Boolean):void{
            const listenerToggle:Function = toggleOn ? list.addEventListener : list.removeEventListener;

            listenerToggle(CollectionEvent.COLLECTION_CHANGED, listChangeHandler);
            listenerToggle(CollectionEvent.ITEM_ADDED, listChangeHandler);
            listenerToggle(CollectionEvent.ITEM_REMOVED, listChangeHandler);
            listenerToggle(CollectionEvent.ITEM_UPDATED, listChangeHandler);
            listenerToggle(CollectionEvent.ALL_ITEMS_REMOVED, listChangeHandler);
        }

        /**
         *  The array of raw data needing conversion.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
        public function get source():Array {

            return _list ? _list.source : null;
        }

        public function set source(value:Array):void {
            if (_list) {
                _list.source = value
            } else {
                list = new ArrayList(value)
            }
        }

        //----------------------------------
        //  filterFunction
        //----------------------------------

        /**
         *  @private
         *  Storage for the filterFunction property.
         */
        private var _filterFunction:Function;

        [Bindable("filterFunctionChanged")]
        [Inspectable(category="General")]

        /**
         *  @inheritDoc
         *
         *  @see #refresh()
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
        public function get filterFunction():Function {
            
            return _filterFunction;
        }

        /**
         *  @private
         */
        public function set filterFunction(f:Function):void {
            
            if (_filterFunction != f) {
                _filterFunction = f;
                _needsRefresh = true;
                dispatchEvent(new Event("filterFunctionChanged"));
            }
        }

        //----------------------------------
        //  sort
        //----------------------------------

        /**
         *  @private
         *  Storage for the sort property.
         */
        private var _sort:ISort;

        [Bindable("sortChanged")]
        [Inspectable(category="General")]

        /**
         *  @inheritDoc
         *
         *  @see #refresh()
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
        public function get sort():ISort {
            
            return _sort;
        }

        /**
         *  @private
         */
        public function set sort(value:ISort):void {

            if (_sort != value) {
                _sort = value;
                _needsRefresh = true;
                dispatchEvent(new Event("sortChanged"));
            }
        }

        //--------------------------------------------------------------------------
        //
        // IArrayListView Methods
        //
        //--------------------------------------------------------------------------

        /**
         * verify if the item is contained within this ArrayListView
         *
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
        public function contains(item:Object):Boolean {
            return getItemIndex(item) != -1;
        }

        /**
         *  stop processing update events from the source list.
         *
         *  @see mx.collections.IArrayListView#enableAutoUpdate()
         *  @see mx.events.CollectionEvent
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
        public function disableAutoUpdate():void {
            autoUpdateCounter++;
        }

        /**
         *  restore updates from the source list
         *
         *  @see mx.collections.IArrayListView#disableAutoUpdate()
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
        public function enableAutoUpdate():void {
            if (autoUpdateCounter > 0) {
                autoUpdateCounter--;
                if (autoUpdateCounter == 0) {
                    handlePendingUpdates();
                }
            }
        }

        /**
         *  trigger notification events that the item has been updated.
         *
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
        public function itemUpdated(item:Object):void {
            list.itemUpdated(item);
        }
        
        /**
         *  trigger notification events that the item has been updated.
         *
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
        public function itemUpdatedAt(index:int):void {
            if (index >= 0 && index < length) {
                var item:Object = getItemAt(index);
                list.itemUpdated(item);
            }
        }

        /**
         * Forces an update of this ArrayListView contents from the source ArrayList,
         * by applying the current filter function and Sort.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
        public function refresh():Boolean {
            var lengthChanged:Boolean = internalRefresh(true);

            if (lengthChanged) {
                dispatchEvent(new Event('lengthChanged'));
            }

            return lengthChanged;
        }

        //--------------------------------------------------------------------------
        //
        // IArrayList Methods
        //
        //--------------------------------------------------------------------------

        [Bindable("collectionChanged")]

        /**
         *  Fetches an item from the collection at a given index
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
        public function getItemAt(index:int):Object {

            if (index < 0 || index >= length) {
                throw new RangeError('ArrayListView getItemAt index out of bounds :' + index);
            }
            
            if (localIndex) {

                return localIndex[index];
            }
            else if (list) {

                return list.getItemAt(index);
            }

            return null;
        }

        /**
         *  Replaces the item at the given index with a new item and
         *  returns the old item, or adds an item to end of the source list if the
         *  index is the same as this ArrayListView's current length, returning null
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
        public function setItemAt(item:Object, index:int):Object {

            if (index < 0 || !list || index > length) {
                throw new RangeError(
                        'ArrayListView setItemAt index out of bounds :' + (!list ? '(list content is null)' : index)
                );
            }
            
            var listIndex:int = index;
            if (localIndex) {
                if (index > localIndex.length) {
                    listIndex = list.length;
                }
                else {
                    var oldItem:Object = localIndex[index];
                    // FIXME fails on duplicates
                    listIndex = list.getItemIndex(oldItem);
                }
            }
            return list.setItemAt(item, listIndex);
        }

        /**
         * @inheritDoc
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
        public function addItem(item:Object):void {
            if (localIndex)
                addItemAt(item, localIndex.length);
            else
                addItemAt(item, length);
        }

        /**
         * @inheritDoc
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
        public function addItemAt(item:Object, index:int):void {

            /*
            if (index < 0 || !list || index > length)
            {
                var message:String = resourceManager.getString(
                    "collections", "outOfBounds", [ index ]);
                throw new RangeError(message);
            }
            */

            var listIndex:int = index;

            // if we're sorted addItemAt is meaningless, just add to the end
            if (localIndex && sort) {
                listIndex = list.length;
            }
            else if (localIndex && filterFunction != null) {
                // if end of filtered list, put at end of source list
                if (listIndex == localIndex.length)
                    listIndex = list.length;
                // if somewhere in filtered list, find it and insert before it
                // or at beginning
                else
                    listIndex = list.getItemIndex(localIndex[index]);
            }
            // List is sorted or filtered but refresh has not been called
            // Just add to end of list
            else if (localIndex) {
                listIndex = list.length;
            }

            list.addItemAt(item, listIndex);
        }

        /**
         *  Adds a list of items to the current list, placing them at the end of
         *  the list in the order they are passed.
         *
         *  @param addList IArrayList The list of items to add to the current list
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
        public function addAll(addList:IArrayList):void {
            if (localIndex)
                addAllAt(addList, localIndex.length);
            else
                addAllAt(addList, length);
        }

        /**
         *  Adds a list of items to the current list, placing them at the position
         *  index passed in to the function.  The items are placed at the index location
         *  and placed in the order they are recieved.
         *
         *  @param addList IArrayList The list of items to add to the current list
         *  @param index The location of the current list to place the new items.
         *  @throws RangeError if index is less than 0 or greater than the length of the list.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
        public function addAllAt(addList:IArrayList, index:int):void {
            /*
            if (index < 0 || index > this.length)
            {
                var message:String = resourceManager.getString(
                    "collections", "outOfBounds", [ index ]);
                throw new RangeError(message);
            }
            */

            var length:int = addList.length;

            for (var i:int = 0; i < length; i++) {
                var insertIndex:int = i + index;

                // incremental index may be out of bounds because of filtering,
                // so add this item to the end.
                if (insertIndex > this.length)
                    insertIndex = this.length;

                this.addItemAt(addList.getItemAt(i), insertIndex);
            }
        }

        /**
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
        public function getItemIndex(item:Object):int {
            var i:int;

            if (localIndex && _filterFunction != null) {
                /*var len:int = localIndex.length;
                for (i = 0; i < len; i++) {
                    if (localIndex[i] == item) {

                        return i;
                    }

                }

                return -1;*/
                
                return localIndex.indexOf(item);
            }
            else if (localIndex && _sort) {
                var startIndex:int = findItem(item, Sort.FIRST_INDEX_MODE);
                if (startIndex == -1) {

                    return -1;
                }


                var endIndex:int = findItem(item, Sort.LAST_INDEX_MODE);
                for (i = startIndex; i <= endIndex; i++) {
                    if (localIndex[i] == item) {

                        return i;
                    }

                }

                return -1;
            }
            // List is sorted or filtered but refresh has not been called
            else if (localIndex) {
                /*len = localIndex.length;
                for (i = 0; i < len; i++) {
                    if (localIndex[i] == item) {

                        return i;
                    }

                }

                return -1;*/
                return localIndex.indexOf(item);
            }

            // fallback
            return list.getItemIndex(item);
        }

        /**
         * @inheritDoc
         */
        internal function getLocalItemIndex(item:Object):int {
            /*var i:int;

            var len:int = localIndex.length;
            for (i = 0; i < len; i++) {
                if (localIndex[i] == item) //not using strict equality (Array.indexOf does)
                    return i;
            }

            return -1;*/
            //note: using strict equality check:
            return localIndex.indexOf(item);
        }

        /**
         * @private
         */
        private function getFilteredItemIndex(item:Object):int {
            // loc is wrong
            // the intent of this function is to find where this new item
            // should be in the filtered list, by looking at the main list
            // for it's neighbor that is also in this filtered list
            // and trying to insert item after that neighbor in the local filtered list

            // 1st get the position in the original list
            var loc:int = list.getItemIndex(item);

            // something gone wrong and list is not filtered so just return loc to stop RTE
            if (_filterFunction == null)
                return loc;

            // if it's 0 then item must be also the first in the filtered list
            if (loc == 0)
                return 0;

            // scan backwards for an item that also in the filtered list
            for (var i:int = loc - 1; i >= 0; i--) {
                var prevItem:Object = list.getItemAt(i);
                if (filterFunction(prevItem)) {
                    /*var len:int = localIndex.length;
                    // get the index of the item in the filtered set
                    for (var j:int = 0; j < len; j++) {
                        if (localIndex[j] == prevItem)  //using non strict equality (Array.indexOf does)
                            return j + 1;
                    }*/
                    //note: using strict equality check:
                    var found:int = localIndex.indexOf(prevItem);
                    if (found != -1) return found + 1;
                }
            }

            // turns out that there are no neighbors of item in the filtered
            // list, so item is the 1st item
            return 0;
        }

        /**
         *  Removes the specified item from this list, should it exist.
         *  Relies on ArrayList implementation
         *
         *  @param  item Object reference to the item that should be removed.
         *  @return Boolean indicating if the item was removed.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Apache Flex 4.10
         */
        public function removeItem(item:Object):Boolean {
            return list.removeItem(item);
        }

        /**
         * @inheritDoc
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
        public function removeItemAt(index:int):Object {
            if (index < 0 || index >= length) {
                throw new RangeError(
                        'ArrayListView removeItemAt index out of bounds :' + index
                );
            }

            var listIndex:int = index;
            if (localIndex) {
                var oldItem:Object = localIndex[index];
                listIndex = list.getItemIndex(oldItem);
            }
            return list.removeItemAt(listIndex);
        }

        /**
         * Remove all items from the list.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
        public function removeAll():void {
            var len:int = length;
            if (len > 0) {
                if (localIndex && filterFunction != null) {
                    len = localIndex.length;
                    for (var i:int = len - 1; i >= 0; i--) {
                        removeItemAt(i);
                    }
                }
                else {
                    localIndex = null;
                    list.removeAll();
                }
            }
        }

        /**
         * @inheritDoc
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
        public function toArray():Array {
            var ret:Array;
            if (localIndex)
                ret = localIndex.concat();
            else
                ret = list.toArray();
            return ret;
        }

        /**
         *  Find the item specified using the Sort find mode constants.
         *  If there is no sort assigned throw an error.
         *
         *  @param values the values object that can be passed into Sort.findItem
         *  @param mode the mode to pass to Sort.findItem (see Sort)
         *  @param insertIndex true if it should find the insertion point
         *  @return the index where the item is located, -1 if not found or SortError
         *  caught
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
        internal function findItem(values:Object, mode:String, insertIndex:Boolean = false):int {

            if (!sort || !localIndex) {
                throw new Error('ArrayListView findItem requires a sort and subsequent refresh()');
            }

            if (localIndex.length == 0)
                return insertIndex ? 0 : -1;

            try {
                return sort.findItem(localIndex, values, mode, insertIndex);
            }
            catch (e:Error) {
                // usually because the find criteria is not compatible with the sort.
                trace('sorting error')
            }

            return -1;
        }

        /**
         * The view is a listener of CollectionEvents on its underlying IArrayList
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
        private function listChangeHandler(event:CollectionEvent):void {

            if (autoUpdateCounter > 0) {
                if (!pendingUpdates) {
                    pendingUpdates = [];
                }
                pendingUpdates.push(event);
            }
            else {
                switch (event.type) {
                    case CollectionEvent.ITEM_ADDED:
                        addItemsToView(event.items || [event], true);
                        break;
                    case CollectionEvent.ITEM_REMOVED:
                        removeItemsFromView(event.items || [event], true);
                        break;
                    case CollectionEvent.ALL_ITEMS_REMOVED:
                        handleAllItemsRemoved(event);
                        break;
                    case CollectionEvent.ITEM_UPDATED:
                        handleItemUpdatedEvents(event.items || [event]);
                        break;

                    default:
                        dispatchEvent(event);
                } // switch
            }
        }
        
        /**
         *
         * @royaleignorecoercion org.apache.royale.events.CollectionEvent
         */
        private function handleAllItemsRemoved(sourceEvent:CollectionEvent):void{
            var allItems:Array = localIndex ? localIndex : sourceEvent.items.concat();
            if (dispatchResetEvent) {
                reset()
            } else {
                internalRefresh(false, false);
                dispatchEvent(new Event('lengthChanged'));
            }
            var localEvent:CollectionEvent = sourceEvent.cloneEvent() as CollectionEvent;
            localEvent.items = allItems;
            dispatchEvent(localEvent);
        }
        
        private function addItemsToView(itemEvents:Array, withRefresh:Boolean):void{
            var lengthChanged:Boolean;
            var i:uint = 0;
            var l:uint = itemEvents.length;
            var addedItems:Array = [];
            const withFilter:Boolean = filterFunction != null;
            for (;i < l; i++) {
                var itemEvent:CollectionEvent = itemEvents[i];
                if (withFilter) {
                    //ignore this if it would be filtered out
                    if (!filterFunction(itemEvent.item)) continue;
                }
                addedItems.push(itemEvent);
            }
            l = addedItems.length;
            if (l) {
                if (withRefresh) {
                    internalRefresh(false, false);
                } else {
                    throw new Error('WIP , do to');
                }

                while (l--) {
                    var localEvent:CollectionEvent = addedItems[l].cloneEvent();
                    addedItems[l] = localEvent;
                    localEvent.index = getItemIndex(localEvent.item);
                }
                addedItems.sort(function(event1:CollectionEvent, event2:CollectionEvent):Boolean{return event1.index < event2.index ? -1 : 1});
                while (addedItems.length) {
                    localEvent = addedItems.shift();
                    dispatchEvent(localEvent);
                }
                lengthChanged = true
            }
            
            if (lengthChanged) {
                dispatchEvent(new Event('lengthChanged'));
            }
        }
        
        private function removeItemsFromView(itemEvents:Array, withRefresh:Boolean):void{
            var lengthChanged:Boolean;
            var i:uint = 0;
            var l:uint = itemEvents.length;
    
            var removedItems:Array = [];
            const withFilter:Boolean = filterFunction != null;
            for (;i < l; i++) {
                var itemEvent:CollectionEvent = itemEvents[i];
                if (withFilter) {
                    //ignore this if it was already filtered out
                    if (!filterFunction(itemEvent.item)) continue;
                }
                removedItems.push(itemEvent);
            }
            l = removedItems.length;
            if (l) {
                while (l--) {
                    var localEvent:CollectionEvent = removedItems[l].cloneEvent();
                    removedItems[l] = localEvent;
                    localEvent.index = getItemIndex(localEvent.item);
                }
                var localUpdate:Boolean;
                if (withRefresh || !localIndex) {
                    internalRefresh(false, false);
                } else {
                    localUpdate = true;
                }
                
                removedItems.sort(function(event1:CollectionEvent, event2:CollectionEvent):Boolean{return event1.index < event2.index ? 1 : -1});
                var offset:int = 0;
                while (removedItems.length) {
                    localEvent = removedItems.shift();
                    localEvent.index =- offset;
                    if (localUpdate) {
                        localIndex.splice(localEvent.index, 1);
                    }
                    dispatchEvent(localEvent);
                    offset++;
                }
                
                lengthChanged = true;
            }
            if (lengthChanged) {
                dispatchEvent(new Event('lengthChanged'));
            }
        }

        /**
         * Given a set of <code>CollectionEvent</code>s go through and update the view.
         * This is currently not optimized.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         *
         *  @royaleignorecoercion org.apache.royale.events.CollectionEvent
         */
        private function handleItemUpdatedEvents(events:Array):void {
        
            var event:CollectionEvent;
            var item:Object;
            var withFilter:Boolean = _filterFunction != null;
            var dispatchLengthChanged:Boolean;
            if (_needsRefresh) {
                //will dispatch collectionChanged (and lengthChanged)
                reset(true);
            } else {
                if (_sort || withFilter) {
                    var originals:Array = localIndex ? localIndex.concat() : source.concat();
                    var present:Boolean = true;
                    var check:Boolean = true;
                    var updateEvent:CollectionEvent;
            
                    if (events.length == 1) {
                        
                        //WIP - to be continued:
                        /*event = events[0];
                        item = event.item;
                        var knownIndex:int = originals.indexOf(item);
                        present = knownIndex != -1;
                        check = withFilter ?  _filterFunction(item) : true;
                
                        if (present != check) {
                            dispatchLengthChanged = true;
                            if (present) {
                                event = new CollectionEvent(CollectionEvent.ITEM_REMOVED);
                                event.index = knownIndex;
                                event.item = item;
                            } else {
                                event = new CollectionEvent(CollectionEvent.ITEM_ADDED);
                                if (_sort) {
                            
                                } else {
                                    event.index = getFilteredItemIndex(item);
                                }
                            }
                        } else {
                    
                        }*/
                        
                        dispatchLengthChanged = internalRefresh(false, false);
                        //for now simply dispatch Collection Change event
                        updateEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGED);
                        updateEvent.items = events;
                        dispatchEvent(updateEvent);
                
                    } else {
                        //WIP - to be continued:
        
                        dispatchLengthChanged = internalRefresh(false, false);
                        //for now simply dispatch Collection Change event
                        updateEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGED);
                        updateEvent.items = events;
                        dispatchEvent(updateEvent);
                
                    }
        
                } else {
                    var i:uint=0;
                    var l:uint = events.length;
                    //simply re-dispatch the item updated events locally
                    for (; i<l;i++) {
                        event = CollectionEvent(events[i]).cloneEvent() as CollectionEvent;
                        dispatchEvent(event);
                    }
                }
            }
            
            if (dispatchLengthChanged) {
                dispatchEvent(new Event('lengthChanged'));
            }
        }

        /**
         * When enableAutoUpdates pushes autoUpdateCounter back down to 0
         * this method will execute to consolidate the pending update
         * events or turn it into a massive refresh().
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
        private function handlePendingUpdates():void {

            if (pendingUpdates) {
                var pu:Array = pendingUpdates;
                pendingUpdates = null;

                // Could further optimize to consolidate various events
                // and make a decision if there are too many updates
                // and we should just refresh.
                var singleUpdateEvent:CollectionEvent;
                for (var i:int = 0; i < pu.length; i++) {
                    var event:CollectionEvent = pu[i];

                    if (!singleUpdateEvent) {
                        singleUpdateEvent = event;
                    }
                    else {
                        if (singleUpdateEvent.items) {
                            throw new Error('still in development');

                        }
                        singleUpdateEvent.items = [];
                        var currentItems:Array = event.items || [event.item];
                        for (var j:int = 0; j < currentItems.length; j++) {
                            singleUpdateEvent.items.push(currentItems[j]);
                        }
                    }
                }

                if (singleUpdateEvent) {
                    listChangeHandler(singleUpdateEvent);
                }
            }
        }

        private var _needsRefresh:Boolean;
        
        /**
         * @private
         * @param dispatch
         * @param autoDispatch
         * @return true if the length of this ArrayListView contents changed
         */
        private function internalRefresh(dispatch:Boolean, autoDispatch:Boolean = true):Boolean {
            var originalLen:uint = length;
            if (sort || filterFunction != null) {
                populateLocalIndex();
                if (filterFunction != null) {
                    var tmp:Array = [];
                    var len:int = localIndex.length;
                    for (var i:int = 0; i < len; i++) {
                        var item:Object = localIndex[i];
                        if (filterFunction(item)) {
                            tmp.push(item);
                        }
                    }
                    localIndex = tmp;
                    if (autoDispatch) dispatch = true;
                }

                if (sort) {
                    sort.sort(localIndex);
                    if (autoDispatch) dispatch = true;
                }
            }
            else if (localIndex) {
                localIndex = null;
            }
            _needsRefresh = false;
            pendingUpdates = null;
            if (dispatch) {
                var refreshEvent:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGED);
                dispatchEvent(refreshEvent);
            }
        
            return length != originalLen;
        }

        /**
         * Copy all of the data from the source list into the local index.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
        private function populateLocalIndex():void {

            if (list) {
                localIndex = list.toArray();
            }
            else {
                localIndex = [];
            }
        }

        /**
         *  @private
         *  When the source list is replaced, reset.
         */
        private function reset(forceDispatch:Boolean = false):void {
            var lengthChanged:Boolean = internalRefresh(false, false);
            if (forceDispatch || dispatchResetEvent) {
                var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGED);
                dispatchEvent(event);
            }
            
            if (lengthChanged) {
                dispatchEvent(new Event('lengthChanged'));
            }
        }
    }
}




