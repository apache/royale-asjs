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

package mx.collections
{
import org.apache.royale.events.Event;
import org.apache.royale.events.EventDispatcher;
import org.apache.royale.reflection.getQualifiedClassName;

import mx.collections.errors.ItemPendingError;
import mx.core.mx_internal;
import mx.events.CollectionEvent;
import mx.events.CollectionEventKind;
import mx.events.PropertyChangeEvent;
import mx.events.PropertyChangeEventKind;

use namespace mx_internal;  // for mx_internal functions pendingItemSucceeded,Failed()

/**
 *  Dispatched when the list's length has changed or when a list
 *  element is replaced.
 *
 *  @eventType mx.events.CollectionEvent.COLLECTION_CHANGE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="collectionChange", type="mx.events.CollectionEvent")]

/**
 *  The AsyncListView class is an implementation of the IList interface 
 *  that handles ItemPendingErrors errors 
 *  thrown by the <code>getItemAt()</code>, <code>removeItemAt()</code>, 
 *  and <code>toArray()</code> methods.
 * 
 *  <p>The <code>getItemAt()</code> method handles ItemPendingErrors by returning a provisional 
 *  "pending" item until the underlying request succeeds or fails.  The provisional
 *  item is produced by calling the function specified by the <code>createPendingItemFunction</code>
 *  property. .  If the request
 *  succeeds, the actual item replaces the provisional one.
 *  If it fails,  the provisional item is replaced with the item returned by calling
 *  the function specified by the <code>createFailedItemFunction</code> property.</p>
 * 
 *  <p>This class delegates the IList methods and properties to its <code>list</code>.
 *  If a list isn't specified, methods that mutate the collection are no-ops, 
 *  and methods that query the collection return an empty value, such as null or zero
 *  as appropriate.</p>
 * 
 *  <p>This class is intended to be used with Spark components based on DataGroup,
 *  such as List and ComboBox. The Spark classes do not provide intrinsic support for 
 *  ItemPendingError handling.</p>
 * 
 *  <p>AsyncListView does not support re-insertion of pending or failed items.  Once 
 *  a failed or pending item is removed, its connection to a pending request for data 
 *  is lost.  Using drag and drop to move a pending item in an ASyncListView, or sorting 
 *  an ASyncListView that contains pending or failed items, is not supported because 
 *  these operations remove and then re-insert list items.</p>
 * 
 *  @mxml
 *
 *  <p>The <code>&lt;mx:AsyncListView&gt;</code> tag inherits all the attributes of its
 *  superclass, and adds the following attributes:</p>
 *
 *  <pre>
 *  &lt;mx:AsyncListView
 *  <b>Properties</b>
 *    createFailedItemFunction="null"
 *    createPendingItemFunction="null"
 *    list="null"
 *  /&gt;
 *  </pre>
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public class AsyncListView extends EventDispatcher implements IList
{
    /**
     *  Constructor.
     *
     *  @param list Initial value of the list property, the IList we're delegating to.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function AsyncListView(list:IList = null)
    {
        super();
        this.list = list;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  list
    //----------------------------------
    
    private var _list:IList;
    
    [Inspectable(category="General")]
    [Bindable("listChanged")]
    
    /**
     *  The IList object that this collection wraps. That means the object to which all of 
     *  the IList methods are delegated.
     * 
     *  <p>If this property is null, the IList mutation methods, such as <code>setItemAt()</code>,
     *  are no-ops. The IList query methods, such <code>getItemAt()</code>, return null
     *  or zero (-1 for <code>getItemIndex()</code>), as appropriate.</p>
     * 
     *  @default null  
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get list():IList
    {
        return _list;
    }
    
    /**
     *  @private
     */
    public function set list(value:IList):void
    {
        if (_list == value)
            return;

        deleteAllPendingResponders();
        oldLength = -1;
        if (_list)
            _list.removeEventListener(CollectionEvent.COLLECTION_CHANGE, handleCollectionChangeEvent);
        _list = value;
        if (_list)
        {
            _list.addEventListener(CollectionEvent.COLLECTION_CHANGE, handleCollectionChangeEvent);
            oldLength = _list.length;
        }

        dispatchEvent(new Event("listChanged"));
        dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.RESET));
    }

    /**
     *  @private
     */
    private function deleteAllPendingResponders():void
    {
        for each (var responder:ListItemResponder in pendingResponders)
        {
            if (responder)
                responder.index = -1;
        }
        pendingResponders.length = 0;
        failedItems.length = 0;
    }
    
    /**
     *  The previous known length of the list before handling a CollectionEvent.
     *  oldLength is updated by the list setter and isValidCollectionEvent().
     */
    private var oldLength:int = -1;
    
    /**
     *  This method checks the validity of incoming CollectionEvents. 
     *  In some cases, a CollectionEvent from the underlying list may have already
     *  been received once, or have been erroneously dispatched (See SDK-30594).
     *  Thus, we check the incoming event's location against the last known length'
     *  of the list (oldLength).
     * 
     *  <p>Returns false if the index is less than 0 or greater than the previous
     *  length of the list.
     *  This only applies to ADD, REMOVE, REPLACE, and MOVE CollectionEvents.
     *  It also updates oldLength to be the current length of the list, so it
     *  should not be called twice.</p>
     */
    private function isValidCollectionEvent(ce:CollectionEvent):Boolean
    {
        if (oldLength < 0)
            return true;
        
        const location:int = ce.location;
        
        switch (ce.kind)
        {
            case CollectionEventKind.ADD:
            {
                if (location < 0 || location > oldLength)
                    return false;
                break;
            }
                
            case CollectionEventKind.REMOVE:
            case CollectionEventKind.REPLACE:
            case CollectionEventKind.MOVE:
            {
                if (location < 0 || location >= oldLength)
                    return false;
                break;
            }
        }
        
        oldLength = length;
        return true;
    }

    /**
     *  @private
     *  Fixup the pendingResponders and failedItems arrays after a change to the list.  
     *  Generally speaking, if a list[index] item changes, the pending responder for 
     *  that index is no longer needed.
     *  
     *  All "collectionChange" events are redispatched to the AsyncListView listeners.
     */
    private function handleCollectionChangeEvent(ce:CollectionEvent):void
    {
        if (!isValidCollectionEvent(ce))
            return;
        
        switch (ce.kind)
        {
            case CollectionEventKind.REPLACE:
            case CollectionEventKind.UPDATE:
                deletePendingResponders(ce);
                break;
                
            case CollectionEventKind.MOVE:
                movePendingResponders(ce);
                break;
                
            case CollectionEventKind.ADD:
                shiftPendingRespondersRight(ce);
                break;

            case CollectionEventKind.REMOVE:
                shiftPendingRespondersLeft(ce);
                break;
                
            case CollectionEventKind.RESET:
            case CollectionEventKind.REFRESH:
                deleteAllPendingResponders();
                break;
        }

        dispatchEvent(ce);  // redispatch to CollectionEvent listeners on this
    }
    
    /**
     *  @private
     *  Delete the ListItemResponder at the specified index, if any.
     *  If a pending responder exists, return its item.
     *   
     *  This method assumes that the responder hasn't run yet, it sets
     *  the ListItemResponder index to -1 to prevent it from updating
     *  this AsyncListView later.
     */
    private function deletePendingResponder(index:int):Object
    {
        if ((index < 0) || (index >= pendingResponders.length))
            return null;

        const pendingResponder:ListItemResponder = pendingResponders[index];
        if (pendingResponder)
        {
            delete pendingResponders[index];
            ListItemResponder(pendingResponder).index = -1; 
            return pendingResponder.item;
        }
        
        return null;
    }

    /**
     *  @private
     *  Handler for a CollectionEventKind.UPDATE or REPLACE event. In either
     *  case a contiguous block of items (ce.items) beginning with index=ce.location
     *  has been changed.  If there are any pending requests for these indices, we
     *  assume they're no longer valid, i.e. we assume that getItemAt() should no longer
     *  return the pending item.  Likewise for failed items.
     */
    private function deletePendingResponders(ce:CollectionEvent):void
    {
        var index:int = ce.location;
        for each (var item:Object in ce.items)
        {
            deletePendingResponder(index);
            delete failedItems[index];
            index += 1;
        }
    }

    /**
     *  @private
     *  Handler for a CollectionEventKind.MOVE event.  The event indicates that a 
     *  contiguous block of items (ce.items), beginning with index=ce.oldLocation,
     *  has been moved to ce.location.  If pendingRequests already exist at ce.location,
     *  they're deleted first.
     */
    private function movePendingResponders(ce:CollectionEvent):void
    {
        var fromIndex:int = ce.oldLocation;
        var toIndex:int = ce.location;
        for each (var item:Object in ce.items)
        {
            var pendingResponder:ListItemResponder = pendingResponders[fromIndex];
            if (pendingResponder)
            {
                delete pendingResponders[fromIndex];
                ListItemResponder(pendingResponder).index = toIndex; 
                deletePendingResponder(toIndex); // in case we're copying over a pending request
                pendingResponders[toIndex] = pendingResponder;
            }
            
            var failedItem:* = failedItems[fromIndex];
            if (failedItem !== undefined)
            {
                delete failedItems[fromIndex];
                failedItems[toIndex] = failedItem;
            }
            
            fromIndex += 1;
            toIndex += 1;
        }
    }

    /**
     *  @private
     *  Handler for a CollectionEventKind.ADD.  The event indicates 
     *  that a block of ce.items.length items starting at ce.location was inserted,
     *  which implies that all of the pendingResponders whose index is greater than or
     *  equal to ce.location, must be shifted right by ce.items.length.  The failedItems
     *  array is handled similarly.
     */
    private function shiftPendingRespondersRight(ce:CollectionEvent):void
    {
        const delta:int = ce.items.length;
        const startIndex:int = ce.location;

        const pendingRespondersCopy:Array = sparseCopy(pendingResponders);
        pendingResponders.length = 0;
        for each (var responder:ListItemResponder in pendingRespondersCopy)
        {
            if (responder.index >= startIndex)
                responder.index += delta;
            pendingResponders[responder.index] = responder;
        }
        
        for (var index:int = failedItems.length - 1; index >= startIndex; index--)
        {
            var failedItem:* = failedItems[index];
            if (failedItem !== undefined)
            {
                delete failedItems[index];
                failedItems[index + delta] = failedItem;
            }
        }
    }

    /**
     *  @private
     *  Handler for a CollectionEventKind.REMOVE.  The event indicates 
     *  that a block of ce.items.length items starting at ce.location was removed,
     *  which implies that all of the pendingResponders whose index is greater than or
     *  equal to ce.location, must be shifted left by ce.items.length.  The failedItems
     *  array is handled similarly.
     */
    private function shiftPendingRespondersLeft(ce:CollectionEvent):void
    {
        const delta:int = ce.items.length;
        const startIndex:int = ce.location + delta;
        
        const pendingRespondersCopy:Array = sparseCopy(pendingResponders);
        pendingResponders.length = 0;
        for each (var responder:ListItemResponder in pendingRespondersCopy)
        {
            if (responder.index >= startIndex)
                responder.index -= delta;
            pendingResponders[responder.index] = responder;
        }
        
        const failedItemsLength:int = failedItems.length;
        for (var index:int = startIndex; index < failedItemsLength; index++)
        {
            var failedItem:* = failedItems[index];
            if (failedItem !== undefined)
            {
                delete failedItems[index];
                failedItems[index - delta] = failedItem;
            }
        }        
    }
    
    /**
     *  Applying concat() to a sparse array produces a new array that's
     *  not sparse, nulls replace items that were undefined.  Although the 
     *  result of this method is not sparse, it only includes items that 
     *  were in the original array.
     */
    private function sparseCopy(a:Array):Array
    {
        const r:Array = [];
        var index:int = 0;
        for each (var item:* in a)
        {
            if (item !== undefined)
                r[index++] = item;
        }
        return r;
    }
    
    //----------------------------------
    //  createPendingItemFunction
    //----------------------------------
    
    private var _createPendingItemFunction:Function = defaultCreatePendingItemFunction;
    
    /**
     *  @private
     */
    private function defaultCreatePendingItemFunction(index:int, ipe:ItemPendingError):Object
    {
        return null;        
    }
    
    /**
     *  A callback function used to create a provisional item when
     *  the initial request causes an <code>ItemPendingError</code> to be thrown.
     *  If the request eventually succeeds, the provisional item is automatically
     *  replaced by the actual item.  If the request fails, then the item is replaced
     *  with one created with the callback function specified by the 
     *  <code>createFailedItemFunction</code> property.
     *  
     *  <p>The value of this property must be a function with two parameters: the index
     *  of the requested data provider item, and the ItemPendingError itself. In most
     *  cases, the second parameter can be ignored.
     *  The following example shows an implementation of the callback function:
     *
     *   <pre>
     * function createPendingItem(index:int, ipe:ItemPendingError):Object
     * {
     *     return "[" + index + "request is pending...]";        
     * }
     *   </pre>
     *   </p>
     * 
     *  <p>Setting this property does not affect provisional pending items that were already
     *  created.  Setting this property to null prevents provisional pending items 
     *  from being created.</p>
     * 
     *  @default A function that unconditionally returns null. 
     *  @see #getItemAt()
     *  @see #createFailedItemFunction
     *  @see mx.collections.errors.ItemPendingError
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get createPendingItemFunction():Function
    {
        return _createPendingItemFunction;
    }
    
    /**
     *  @private
     */
    public function set createPendingItemFunction(value:Function):void
    {
        _createPendingItemFunction = value;
    }
    
    
    //----------------------------------
    //  createFailedItemFunction
    //----------------------------------
    
    private var _createFailedItemFunction:Function = defaultCreateFailedItemFunction;
    
    /**
     *  @private
     */
    private function defaultCreateFailedItemFunction(index:int, info:Object):Object
    {
        return null;        
    }
    
    /**
     *  A callback function used to create a substitute item when
     *  a request which had caused an <code>ItemPendingError</code> to be thrown, 
     *  subsequently fails.  The existing item, typically a pending item created
     *  by the callback function specified by the <code>createPendingItemFunction()</code> property, 
     *  is replaced with the failed item.
     *  
     *  <p>The value of this property must be a function with two parameters: the index
     *  of the requested item, and the failure "info" object, which is
     *  passed along from the IResponder <code>fault()</code> method.  
     *  In most cases you can ignore the second parameter.
     *  Shown below is an example implementation of the callback function:</p> 
     * 
     *  <pre>
     * function createFailedItem(index:int, info:Object):Object
     * {
     *     return "[" + index + "request failed]";        
     * }
     *   </pre>
     *  
     * 
     *  <p>Setting this property does not affect failed items that were already
     *  created.  Setting this property to null prevents failed items from being created.
     *  </p>
     * 
     *  @default A function that unconditionally returns null. 
     *  @see #getItemAt()
     *  @see #createPendingItemFunction
     *  @see mx.rpc.IResponder#fault
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get createFailedItemFunction():Function
    {
        return _createFailedItemFunction;
    }
    
    /**
     *  @private
     */
    public function set createFailedItemFunction(value:Function):void
    {
        _createFailedItemFunction = value;
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    private const pendingResponders:Array = [];
    private const failedItems:Array = [];
    
    /**
     *  @private
     *  Called by the ListItemProvider/result() method when a pending request
     *  completes successfully.
     * 
     *  @param index The item's index.
     *  @param info The informational object passed to IResponder/result().
     *  @see mx.rpc.IResponder#result
     */
    mx_internal function pendingRequestSucceeded(index:int, info:Object):void
    {
        delete pendingResponders[index];
    }

    /**
     *  @private
     *  Called by the ListItemProvider/fault() method when a pending request
     *  fails.
     * 
     *  @param index The item's index.
     *  @param info The informational object passed to IResponder/fault().
     *  @see mx.rpc.IResponder#fault
     */
    mx_internal function pendingRequestFailed(index:int, info:Object):void
    {
        delete pendingResponders[index];

        if (createFailedItemFunction === null)
            return;
        
        const item:Object = createFailedItemFunction(index, info);
        failedItems[index] = item;
            
        // dispatch collection and property change events
        
        const hasCollectionListener:Boolean = hasEventListener(CollectionEvent.COLLECTION_CHANGE);
        const hasPropertyListener:Boolean = hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE);
        var pce:PropertyChangeEvent; 
                
        if (hasCollectionListener || hasPropertyListener)
        {
            pce = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
            pce.kind = PropertyChangeEventKind.UPDATE;
            pce.oldValue = null;
            pce.newValue = item;
            pce.property = index;
        }
                
        if (hasCollectionListener)
        {
            var ce:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            ce.kind = CollectionEventKind.REPLACE;
            ce.location = index;
            ce.items.push(pce);
            dispatchEvent(ce);
        }
                
        if (hasPropertyListener)
            dispatchEvent(pce);
    }
            
    
    //--------------------------------------------------------------------------
    //
    //  IList Implementation
    //
    //--------------------------------------------------------------------------

    [Bindable("collectionChange")]
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get length():int
    {
        try
        {
            return (list) ? list.length : 0;
        }
        catch (ignore:ItemPendingError)
        {
            // The mx.data DataList class can throw an IPE here. We ignore it because
            // when the length is determined, a CollectionChanged event will be
            // be dispatched.  See handleCollectionChangeEvent().
        }
        
        return 0;
    }
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function addItem(item:Object):void
    {
        if (list)
        {
            try
            {
                list.addItem(item);
            }
            catch (ignore:ItemPendingError)
            {
                // The mx.data DataList class can throw an IPE here. We ignore it because
                // when the item is actually added, a CollectionChanged event will be
                // be dispatched.  See handleCollectionChangeEvent().
            }            
        }
    }
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function addItemAt(item:Object, index:int):void
    {
        if (list)
        {
            try
            {
                list.addItemAt(item, index);
            }
            catch (ignore:ItemPendingError)
            {
                // The mx.data DataList class can throw an IPE here. We ignore it because
                // when the item is actually added, a CollectionChanged event will be
                // be dispatched.  See handleCollectionChangeEvent().
            }            
        }
    }
    
    /**
     *  Returns the value of <code>list.getItemAt(index)</code>.
     * 
     *  <p>This method catches ItemPendingErrors (IPEs) generated as a consequence of 
     *  calling <code>getItemAt()</code>.  If an IPE is thrown, an <code>IResponder</code> is added to
     *  the IPE and a provisional "pending" item, created with the 
     *  <code>createPendingItemFunction</code> is returned.   If the underlying request
     *  eventually succeeds, the pending item is replaced with the real item.  If it fails,
     *  the pending item is replaced with a value produced by calling
     *  <code>createFailedItemFunction</code>.</p>
     * 
     *  @param index The list index from which to retrieve the item.
     *
     *  @param prefetch An <code>int</code> indicating both the direction
     *    and number of items to fetch during the request if the item is not local.
     * 
     *  @throws RangeError if <code>index &lt; 0</code> or <code>index >= length</code>.
     * 
     *  @return The list item at the specified index.
     * 
     *  @see #createPendingItemFunction
     *  @see #createFailedItemFunction
     *  @see mx.collections.errors.ItemPendingError
     *  @see mx.rpc.IResponder 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function getItemAt(index:int, prefetch:int=0):Object
    {
        if (!list)
            return null;
        
        const failedItem:* = failedItems[index];
        if (failedItem !== undefined)
            return failedItem;

        const pendingResponder:ListItemResponder = pendingResponders[index];
        if (pendingResponder)
            return pendingResponder.item;

        var item:Object = null;
        try
        {
            return list.getItemAt(index, prefetch);
        }
        catch (ipe:ItemPendingError)
        {
            const createPendingItem:Function = createPendingItemFunction;
            if (createPendingItem !== null)
                item = createPendingItem(index, ipe);
            var responder:ListItemResponder = new ListItemResponder(this, index, item);
            pendingResponders[index] = responder;
            ipe.addResponder(responder);
        }
        return item;
    }  
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function getItemIndex(item:Object):int
    {
        const failedItemIndex:int = failedItems.indexOf(item);
        if (failedItemIndex != -1)
            return failedItemIndex;
        
        for each (var responder:ListItemResponder in pendingResponders)
            if (responder && responder.item === item)
                return responder.index;
        return (list) ? list.getItemIndex(item) : -1;
    }
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function itemUpdated(item:Object, property:Object=null, oldValue:Object=null, newValue:Object=null):void
    {
        if (list)
            list.itemUpdated(item, property, oldValue, newValue);
    }
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function removeAll():void
    {
        if (list)
            list.removeAll();
    }
	
	/**
	 *  Removes the specified item from this list, should it exist.
	 *  Relies on ArrayList implementation
	 *
	 *  @param  item Object reference to the item that should be removed.
	 *  @return Boolean indicating if the item was removed.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Apache Flex 4.10
	 */
	public function removeItem(item:Object):Boolean
	{
		var _item:Object = removeItemAt(getItemIndex(item));
		return _item != null;
	}
    
    /**
     *  Removes the actual or pending item at the specified index and returns it.
     *  All items whose index is greater than the specified index  
     *  have their index reduced by 1.
     * 
     *  <p>If there is no actual or pending item at the specified index, for
     *  example because a call to <code>getItemAt(index)</code> hasn't caused the data to be 
     *  paged in, then the underlying <code>list</code> may throw an ItemPendingError.  
     *  The  implementation ignores the ItemPendingError and returns null.</p>
     *
     *  @param index The list index from which to retrieve the item.
     *
     *  @throws RangeError if <code>index &lt; 0</code> or <code>index >= length</code>.
     *
     *  @return The item that was removed or null.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function removeItemAt(index:int):Object
    {
        if (!list)
            return null;
        
        const failedItem:* = failedItems[index];
        delete failedItems[index];
        const pendingItem:Object = deletePendingResponder(index);
        try
        {
            const actualItem:Object = list.removeItemAt(index);
            if (failedItem !== undefined)
                return failedItem;
            return (pendingItem) ? pendingItem : actualItem;
            
        }
        catch (ipe:ItemPendingError)
        {
            // If list[index] doesn't exist yet, an IPE will be thrown.  There's nothing 
            // we can do about that, so ignore it.
        }
        return (failedItem !== undefined) ? failedItem : pendingItem; 
    }
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function setItemAt(item:Object, index:int):Object
    {
        if (!list)
            return null;
        
        const failedItem:* = failedItems[index];
        const pendingResponder:ListItemResponder = pendingResponders[index];

        var setItemValue:Object = null;  // return null if IPE
        try
        {
            setItemValue = list.setItemAt(item, index);
        }
        catch (ignore:ItemPendingError)
        {
            // The mx.data DataList class can throw an IPE here. We ignore it because
            // when the item is actually changed, a CollectionChanged event will be
            // be dispatched.  See handleCollectionChangeEvent().
        }            
        
        if (failedItem !== undefined)
            return failedItem;
        else
            return (pendingResponder) ? pendingResponder.item : setItemValue;
    }
    
    /**
     *  Returns an array with the same elements as this AsyncListView.  The array is initialized
     *  by retrieving each item with <code>getItemAt()</code>, so pending items are substituted where actual
     *  values aren't available yet.   The array will not be updated when the AsyncListView replaces
     *  the pending items with actual (or failed) values.
     *  
     *  @return an array with the same elements as this AsyncListView.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function toArray():Array
    {
        if (!list)
            return [];
        
        const a:Array = new Array(list.length);
        for(var i:int = 0; i < a.length; i++)
            a[i] = getItemAt(i);
        return a;
    }
    
 
    /**
     *  Returns a string that contains the list's length and the number of pending item requests.  
     *  It does not trigger pending requests.
     * 
     *  @return A brief description of the list.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function toString():String
    {
        var s:String = getQualifiedClassName(this);

        if (list)
        {
            var nRequests:int = 0;
            for each (var responder:ListItemResponder in pendingResponders)
            {
                if (responder)
                    nRequests += 1;
            }
            s += " length=" + length + ", " + nRequests + " pending requests";
        }
        else
            s += " no list";

        return s;
    }

}
}

import mx.rpc.IResponder;
import mx.collections.AsyncListView;
import mx.core.mx_internal;

use namespace mx_internal;  // for mx_internal functions pendingItemSucceeded,Failed()

class ListItemResponder implements IResponder
{
    private var asyncListView:AsyncListView;
    public var index:int = -1;
    public var item:Object = null;
    
    public function ListItemResponder(asyncListView:AsyncListView, index:int, item:Object)
    {
        super();
        this.asyncListView = asyncListView;
        this.index = index;
        this.item = item;
    }
    
    public function result(info:Object):void
    {
        if (index != -1)
            asyncListView.pendingRequestSucceeded(index, info);
    }
    
    public function fault(info:Object):void
    {
        if (index != -1)
            asyncListView.pendingRequestFailed(index, info);
    }
}
