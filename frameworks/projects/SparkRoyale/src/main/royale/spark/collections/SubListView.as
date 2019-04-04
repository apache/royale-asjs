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

package spark.collections
{
/*
import flash.events.Event;
import flash.events.EventDispatcher;
*/
	
import org.apache.royale.events.Event;
import org.apache.royale.events.EventDispatcher;

import mx.collections.IList;
import mx.events.CollectionEvent;
import mx.events.CollectionEventKind;

[ExcludeClass]

/**
 *  A "view" of a contiguous IList interval that begins at startIndex and extends for count items.
 * 
 *  The list item index parameter for IList methods like getItemAt(index) are defined relative to 
 *  this SubListView.   For example the SubListView definition of getItemAt(0) is defined as 
 *  list.getItemAt(startIndex).  Similarly returned index values and the location CollectionEvent 
 *  property are defined relative to the SubListView.   In all other respects paraters, return values,
 *  and events, have the same semantics as defined for IList.
 *  
 *  This class is internal to the Grid implementation.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 11
 *  @playerversion AIR 3
 *  @productversion Flex 5.0* 
 */
public class SubListView extends EventDispatcher implements IList
{
    /**
     *  Construct a SubListView and optionally specify the target list and the item interval
     *  this SubListView spans.
     */
    public function SubListView(list:IList = null, startIndex:int = 0, count:int = -1)
    {
        super();
        this.list = list;
        this.startIndex = startIndex;
        this.count = count;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    private function dispatchChangeEvent(type:String):void
    {
        if (hasEventListener(type))
            dispatchEvent(new Event(type));
    }
    
    /**
     *  @private
     */
    private function dispatchCollectionResetEvent():void
    {
        if (hasEventListener(CollectionEvent.COLLECTION_CHANGE))
            dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.RESET));            
    }      
    
    //----------------------------------
    //  list
    //----------------------------------
    
    private var _list:IList;
    
    [Inspectable(category="General")]
    [Bindable("listChanged")]
    
    /**
     *  The IList to which all of IList methods are delegated.
     * 
     *  <p>If this property is null, the IList mutation methods, such as <code>setItemAt()</code>,
     *  are no-ops. The IList query methods, such <code>getItemAt()</code>, return null
     *  or zero (-1 for <code>getItemIndex()</code>), as appropriate.</p>
     * 
     *  @default null  
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
        
        if (_list)
            _list.removeEventListener(CollectionEvent.COLLECTION_CHANGE, handleCollectionChangeEvent);
        _list = value;
        if (_list)
            _list.addEventListener(CollectionEvent.COLLECTION_CHANGE, handleCollectionChangeEvent, false, 0); //, true);
        
        dispatchChangeEvent("listChanged");
        dispatchCollectionResetEvent();
    }
	
    //----------------------------------
    //  startIndex
    //----------------------------------
    
    private var _startIndex:int = 0;  // Typically this value is >= 0
    
    [Inspectable(category="General")]
    [Bindable("startIndexChanged")]
    
    /**
     *  The index of the first list item included by this SubListView.
     * 
     *  @default 0
     */
    public function get startIndex():int
    {
        return _startIndex;
    }
    
    /**
     *  @private
     */
    public function set startIndex(value:int):void
    {
        if (_startIndex == value)
            return;
        
        _startIndex = value;
        
        dispatchChangeEvent("startIndexChanged");
        dispatchCollectionResetEvent();
    }
    
    //----------------------------------
    //  count
    //----------------------------------
    
    private var _count:int = -1;  
    
    [Inspectable(category="General")]
    [Bindable("countChanged")]
    
    /**
     *  The number of items to be included in this SubListView or -1, which means
     *  that all items, beginning with the one at startIndex, are to be included.
     * 
     *  @default -1
     */
    public function get count():int
    {
        return _count;
    }
    
    /**
     *  @private
     */
    public function set count(value:int):void
    {
        if (_count == value)
            return;
        
        _count = value;
        
        dispatchChangeEvent("countChanged");
        dispatchCollectionResetEvent();
    }
    
    
    //--------------------------------------------------------------------------
    //
    //  CollectionEvent.COLLECTION_CHANGE Handlers
    //
    //-------------------------------------------------------------------------- 
    
    /**
     *  @private
     *  All "collectionChange" events are redispatched to the SubListView listeners.
     */
    private function handleCollectionChangeEvent(event:CollectionEvent):void
    {
        var viewEvent:CollectionEvent = null;
        var location:int = event.location;
        
        switch (event.kind)
        {
            case CollectionEventKind.ADD:
            case CollectionEventKind.REMOVE: 
            {
                viewEvent = handleModifyCollectionChangeEvent(event);
                break;
            }
                
            case CollectionEventKind.REPLACE:
            case CollectionEventKind.UPDATE:
            {
                viewEvent = handleUpdateCollectionChangeEvent(event);
                break;
            }                
                
            case CollectionEventKind.MOVE:
            {
                // TBD: may require synthesizing add and/or remove events
                break;
            }
                
            default:  // refresh, reset, null
            {
                viewEvent = event;
                break;
            }
        }		
        
        if (viewEvent)
            dispatchEvent(viewEvent);
    }
    
    /**
     *  @private
     */    
    private function createCollectionEvent(kind:String):CollectionEvent
    {
        return new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, kind);
    }  
    
    /**
     *  @private
     *  This method is called after (the underlying) list has been modified via add/remove.
     * 
     *  The incoming event.location is the list modification start point, event.items is the 
     *  array of items that were inserted/removed/replaced.
     * 
     *  Returned event (if any) is a refresh if the insert was "to the left of" this SubListView,
     *  or a potentially truncated version of the insert was within the SubListView.
     */
    private function handleModifyCollectionChangeEvent(event:CollectionEvent):CollectionEvent
    {
        const viewEnd:int = startIndex + length;
        
        //  is "to the right of" the SubListView
        
        if (event.location >= viewEnd) 
            return null;
        
        // Insert is "to the left of" the SubListView; entire SubListView shifts 
        
        if (event.location <= startIndex) 
            return createCollectionEvent(CollectionEventKind.REFRESH);
        
        // Insert is within the SubListView
        
        const viewEvent:CollectionEvent = createCollectionEvent(event.kind);
        viewEvent.location = event.location - startIndex;
        
        const items:Array = [];
        viewEvent.items = items;
        
        var location:int = event.location;
        for each (var item:Object in event.items)
        {
            items.push(item);
            if (location++ >= viewEnd)
                break;
        }        

        return viewEvent;
    } 
    
    /**
     *  @private
     *  This method is called after (the underlying) list has been modified via update/replace.
     *  This case is different than add/remove because the item locations do not change.
     * 
     *  The incoming event.location is the list modification start point, event.items is the 
     *  array of PropertyChangeEvents that characterize the old and new item values.
     * 
     */
    private function handleUpdateCollectionChangeEvent(event:CollectionEvent):CollectionEvent
    {
        const viewEnd:int = startIndex + length;
        
        // Update/replace doesn't overlap this SubListView
        
        if (((event.location + event.items.length) < startIndex) || (event.location >= viewEnd))
            return null;
        
        const viewEvent:CollectionEvent = createCollectionEvent(event.kind);
        var viewLocation:int = Math.max(startIndex, event.location);
        viewEvent.location = viewLocation - startIndex;
        
        const items:Array = [];
        viewEvent.items = items;
        
        for each (var item:Object in event.items)
        {
            items.push(item);
            if (viewLocation++ >= viewEnd)
                break;
        }        
        
        return viewEvent;
    } 
        
    //--------------------------------------------------------------------------
    //
    //  IList Implementation
    //
    //--------------------------------------------------------------------------
    
    [Bindable("collectionChange")]
    
    public function get length():int
    {
        if (count == -1)
            return (list) ? list.length - startIndex : 0; 
        
        return count;
    }
    
    public function addItem(item:Object):void
    {
        if (list)
            list.addItem(item);
    }
    
    public function addItemAt(item:Object, index:int):void
    {
        if (list)
            list.addItemAt(item, index + startIndex);
    }
    
    public function getItemAt(index:int, prefetch:int=0):Object
    {
        return (list) ? list.getItemAt(index + startIndex, prefetch) : null;
    }
    
    public function getItemIndex(item:Object):int
    {
        if (!list || (count == 0))
            return -1;
        
        const index:int = list.getItemIndex(item);
        return ((index < startIndex) || (index >= (startIndex + length))) ? -1 : index - startIndex;
    }
    
    public function itemUpdated(item:Object, property:Object=null, oldValue:Object=null, newValue:Object=null):void
    {
        if (list)
            list.itemUpdated(item, property, oldValue, newValue);        
    }
    
    public function removeAll():void
    {
        if (list)
            list.removeAll();
    }
    
	public function removeItem(item:Object):Boolean
	{
		return (list && "removeItem" in list) ? list["removeItem"]( item ) : false;
	}
	
    public function removeItemAt(index:int):Object
    {
        return (list) ? list.removeItemAt(startIndex + index) : null;
    }
    
    public function setItemAt(item:Object, index:int):Object
    {
        return (list) ? list.setItemAt(item, startIndex + index) : null;
    }
    
    public function toArray():Array
    {
        if (!list)
            return [];
        
        const a:Array = new Array(length);
		const aCount:int = Math.min(a.length, list.length - startIndex);
        for(var i:int = 0; i < aCount; i++)
            a[i] = list.getItemAt(i + startIndex);
        return a;
    }
    
}
}
