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
    import org.apache.royale.utils.Proxy;
    
    COMPILE::SWF
    {
    import flash.utils.flash_proxy;
    }

    //import mx.binding.utils.ChangeWatcher;
    //import mx.collections.errors.CollectionViewError;
    //import mx.collections.errors.ItemPendingError;
    import mx.collections.errors.SortError;
    //import mx.core.IMXMLObject;
    import mx.core.mx_internal;
    import mx.events.CollectionEvent;
    import mx.events.CollectionEventKind;
    import mx.events.PropertyChangeEvent;
    //import mx.resources.IResourceManager;
    //import mx.resources.ResourceManager;
    //import mx.utils.ObjectUtil;

    use namespace mx_internal;

/**
 *  Dispatched when the ICollectionView has been updated in some way.
 *
 *  @eventType mx.events.CollectionEvent.COLLECTION_CHANGE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="collectionChange", type="mx.events.CollectionEvent")]

//[ResourceBundle("collections")]
    
/**
 * The ListCollectionView class adds the properties and methods of the
 * <code>ICollectionView</code> interface to an object that conforms to the
 * <code>IList</code> interface. As a result, you can pass an object of this class
 * to anything that requires an <code>IList</code> or <code>ICollectionView</code>.
 *
 * <p>This class also lets you use [ ] array notation
 * to access the <code>getItemAt()</code> and <code>setItemAt()</code> methods.
 * If you use code such as <code>myListCollectionView[index]</code>
 * Flex calls the <code>myListCollectionView</code> object's
 * <code>getItemAt()</code> or <code>setItemAt()</code> method.</p>
 * 
 * @mxml
 *
 *  <p>The <code>&lt;mx:ListCollectionView&gt;</code> has the following attributes,
 *  which all of its subclasses inherit:</p>
 *
 *  <pre>
 *  &lt;mx:ListCollectionView
 *  <b>Properties</b>
 *  filterFunction="null"
 *  list="null"
 *  sort="null"
 *  <b>Events</b>
 *  collectionChange="<i>No default</i>"
 *  /&gt;
 *  </pre>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class ListCollectionView extends Proxy implements ICollectionView, IList //, IMXMLObject
{
//    include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    // Private variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Change watcher for complex sort fields.
     */
    //private var _complexFieldWatcher:ComplexFieldChangeWatcher;

    /**
     *  @private
     *  Internal event dispatcher.
     */
    private var eventDispatcher:EventDispatcher;
    
    /**
     *  @private
     *  Revisions are used for bookmark maintenace,
     *  see getBookmark() and getBookmarkIndex() along with reset().
     */
    private var revision:int;

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
    mx_internal var dispatchResetEvent:Boolean = true;

    /**
     *  @private
     *  Used for accessing localized Error messages.
     */
    //private var resourceManager:IResourceManager =
    //                                ResourceManager.getInstance();

    //--------------------------------------------------------------------------
    //
    // Protected variables
    //
    //--------------------------------------------------------------------------

    /**
     *  When the view is sorted or filtered the <code>localIndex</code> property
     *  contains an array of items in the sorted or filtered (ordered, reduced)
     *  view, in the sorted order.
     *  The ListCollectionView class uses this property to access the items in 
     *  the view.
     *  The <code>localIndex</code> property should never contain anything
     *  that is not in the source, but may not have everything in the source.  
     *  This property is <code>null</code> when there is no sort.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected var localIndex:Array;

    //--------------------------------------------------------------------------
    //
    // Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  The ListCollectionView constructor.
     *
     *  @param list the IList this ListCollectionView is meant to wrap.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function ListCollectionView(list:IList = null)
    {
        super();

        eventDispatcher = new EventDispatcher(this);
        this.list = list;
    }

     /**
      *  Called automatically by the MXML compiler when the ListCollectionView
      *  is created using an MXML tag.  
      *  If you create the ListCollectionView through ActionScript, you 
      *  must call this method passing in the MXML document and 
      *  <code>null</code> for the <code>id</code>.
      *
      *  @param document The MXML document containing this ListCollectionView.
      *
      *  @param id Ignored.
      *  
      *  @langversion 3.0
      *  @playerversion Flash 9
      *  @playerversion AIR 1.1
      *  @productversion Flex 3
      */
    public function initialized(document:Object, id:String):void
    {
        refresh();
    }

    //--------------------------------------------------------------------------
    //
    // Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    // length
    //----------------------------------

    [Bindable("collectionChange")]
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get length():int
    {
        if (localIndex)
        {
            return localIndex.length;
        }
        else if (list)
        {
            return list.length;
        }
        else
        {
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
    private var _list:IList;

    [Inspectable(category="General")]
    [Bindable("listChanged")]
    
    /**
     *  The IList that this collection view wraps.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
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
        if (_list != value)
        {
            var oldHasItems:Boolean;
            var newHasItems:Boolean;
            if (_list)
            {
                _list.removeEventListener(CollectionEvent.COLLECTION_CHANGE, listChangeHandler);
                oldHasItems = _list.length > 0;
            }

            _list = value;

            if (_list)
            {
                // weak listeners to collections and dataproviders
                //_list.addEventListener(CollectionEvent.COLLECTION_CHANGE, listChangeHandler, false, 0, true);
                _list.addEventListener(CollectionEvent.COLLECTION_CHANGE, listChangeHandler, false);
                newHasItems = _list.length > 0;
            }

            if (oldHasItems || newHasItems)
                reset();
            dispatchEvent(new Event("listChanged"));
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
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get filterFunction():Function
    {
        return _filterFunction;
    }

    /**
     *  @private
     */
    public function set filterFunction(f:Function):void
    {
        _filterFunction = f;
        dispatchEvent(new Event("filterFunctionChanged"));
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
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get sort():ISort
    {
        return _sort;
    }

    /**
     *  @private
     */
    public function set sort(value:ISort):void
    {
        if(_sort != value)
        {
            //stopWatchingForComplexFieldsChanges();

            _sort = value;

            //startWatchingForComplexFieldsChanges();

            dispatchEvent(new Event("sortChanged"));
        }
    }



    //--------------------------------------------------------------------------
    //
    // ICollectionView Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @inheritDoc
     *
     *  @see #enableAutoUpdate()
     *  @see mx.events.CollectionEvent
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function contains(item:Object):Boolean
    {
        return getItemIndex(item) != -1;
    }

    /**
     *  @inheritDoc
     * 
     *  @see mx.collections.ICollectionView#enableAutoUpdate()
     *  @see mx.events.CollectionEvent
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function disableAutoUpdate():void
    {
        autoUpdateCounter++;
    }

    /**
     *  @inheritDoc
     * 
     *  @see mx.collections.ICollectionView#disableAutoUpdate()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function enableAutoUpdate():void
    {
        if (autoUpdateCounter > 0)
        {
            autoUpdateCounter--;
            if (autoUpdateCounter == 0)
            {
                handlePendingUpdates();
            }
        }
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function createCursor():IViewCursor
    {
        return new ListCollectionViewCursor(this);
    }

    /**
     *  @inheritDoc
     *
     *  @see mx.events.CollectionEvent
     *  @see mx.core.IPropertyChangeNotifier
     *  @see mx.events.PropertyChangeEvent
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function itemUpdated(item:Object, property:Object = null,
                                oldValue:Object = null,
                                newValue:Object = null):void
    {
        list.itemUpdated(item, property, oldValue, newValue);
    }

    /**
     * @inheritDoc 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function refresh():Boolean
    {
        return internalRefresh(true);
    }

    //--------------------------------------------------------------------------
    //
    // IList Methods
    //
    //--------------------------------------------------------------------------

    [Bindable("collectionChange")]
    
    /**
     * @inheritDoc 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getItemAt(index:int, prefetch:int = 0):Object
    {
        /*
        if (index < 0 || index >= length)
        {
            var message:String = resourceManager.getString(
                "collections", "outOfBounds", [ index ]);
            throw new RangeError(message);
        }
        */

        if (localIndex)
        {
            return localIndex[index];
        }
        else if (list)
        {
            return list.getItemAt(index, prefetch);
        }

        return null;
    }

    /**
     * @inheritDoc 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function setItemAt(item:Object, index:int):Object
    {
        /*
        if (index < 0 || !list || index >= length)
         {
            var message:String = resourceManager.getString(
                "collections", "outOfBounds", [ index ]);
            throw new RangeError(message);
        }
        */

        var listIndex:int = index;
        if (localIndex)
        {
            if (index > localIndex.length)
            {
                listIndex = list.length;
            }
            else
            {
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
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function addItem(item:Object):void
    {
		if (localIndex)
        	addItemAt(item, localIndex.length);
		else
			addItemAt(item, length);
    }

    /**
     * @inheritDoc 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function addItemAt(item:Object, index:int):void
    {
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
		if (localIndex && sort)
        {
            listIndex = list.length;
        }
		else if (localIndex && filterFunction != null)
		{
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
		else if (localIndex)
		{
			listIndex = list.length;
		}
		
        list.addItemAt(item, listIndex);
    }
    
    /**
     *  Adds a list of items to the current list, placing them at the end of
     *  the list in the order they are passed.
     * 
     *  @param addList IList The list of items to add to the current list
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function addAll(addList:IList):void
    {
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
     *  @param addList IList The list of items to add to the current list
     *  @param index The location of the current list to place the new items.
     *  @throws RangeError if index is less than 0 or greater than the length of the list. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function addAllAt(addList:IList, index:int):void
    {	
        /*
        if (index < 0 || index > this.length)
        {
            var message:String = resourceManager.getString(
                "collections", "outOfBounds", [ index ]);
            throw new RangeError(message);
        }
        */
        
        var length:int = addList.length;

        for (var i:int=0; i < length; i++)
        {
            var insertIndex:int = i + index;
			
			// incremental index may be out of bounds because of filtering,
			// so add this item to the end.
			if (insertIndex > this.length)
				insertIndex = this.length;
			
            this.addItemAt(addList.getItemAt(i), insertIndex);
        }
    }

    /**
     * @inheritDoc 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getItemIndex(item:Object):int
    {
        var i:int;
        
        if (localIndex && filterFunction != null)
        {
            var len:int = localIndex.length;
            for (i = 0; i < len; i++)
            {
                if (localIndex[i] == item)
                    return i;
            }

            return -1;
        }
		else if (localIndex && sort)
		{
			var startIndex:int = findItem(item, Sort.FIRST_INDEX_MODE);
			if (startIndex == -1)
				return -1;
			
			var endIndex:int = findItem(item, Sort.LAST_INDEX_MODE);
			for (i = startIndex; i <= endIndex; i++)
			{
				if (localIndex[i] == item)
					return i;
			}
			
			return -1;
		}
		// List is sorted or filtered but refresh has not been called
		else if (localIndex)
		{
			len = localIndex.length;
			for (i = 0; i < len; i++)
			{
				if (localIndex[i] == item)
					return i;
			}
			
			return -1;
		}

        // fallback
        return list.getItemIndex(item);
    }

    /**
     * @inheritDoc 
     */
    mx_internal function getLocalItemIndex(item:Object):int
    {
        var i:int;
        
        var len:int = localIndex.length;
        for (i = 0; i < len; i++)
        {
            if (localIndex[i] == item)
                return i;
        }

        return -1;
    }

    /**
     * @private
     */
    private function getFilteredItemIndex(item:Object):int
    { 
        // loc is wrong 
        // the intent of this function is to find where this new item 
        // should be in the filtered list, by looking at the main list 
        // for it's neighbor that is also in this filtered list 
        // and trying to insert item after that neighbor in the insert locao filtered list 
    
        // 1st get the position in the original list 
        var loc:int = list.getItemIndex(item); 
		
		// something gone wrong and list is not filtered so just return loc to stop RTE
		if (filterFunction == null)
			return loc;
    
        // if it's 0 then item must be also the first in the filtered list 
        if (loc == 0) 
            return 0; 
    
        // scan backwards for an item that also in the filtered list 
        for (var i:int = loc - 1; i >= 0; i--) 
        { 
            var prevItem:Object = list.getItemAt(i); 
            if (filterFunction(prevItem)) 
            { 
                var len:int = localIndex.length; 
                // get the index of the item in the filtered set 
                // for (var j:int = 0; j < len; j++) 
                for (var j:int = 0; j < len; j++) 
                { 
                    if (localIndex[j] == prevItem) 
                        return j + 1; 
                }
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
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Apache Flex 4.10
	 */
	public function removeItem(item:Object):Boolean
	{
        if ("removeItem" in list)
    		return list["removeItem"](item);
        return false;
	}

    /**
     * @inheritDoc 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function removeItemAt(index:int):Object
    {
        /*
        if (index < 0 || index >= length)
        {
            var message:String = resourceManager.getString(
                "collections", "outOfBounds", [ index ]);
            throw new RangeError(message);
        }
        */

        var listIndex:int = index;
        if (localIndex)
        {
            var oldItem:Object = localIndex[index];
            listIndex = list.getItemIndex(oldItem);
        }
        return list.removeItemAt(listIndex);
    }

    /**
     * Remove all items from the list.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function removeAll():void
    {
        var len:int = length;
        if (len > 0)
        {
            if (localIndex && filterFunction != null)
            {
				len = localIndex.length;
                for (var i:int = len - 1; i >= 0; i--)
                {
                    removeItemAt(i);
                }
            }
            else
            {
				localIndex = null;
                list.removeAll();
            }
        }
    }

    /**
     * @inheritDoc 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function toArray():Array
    {
        var ret:Array;
        if (localIndex)
            ret = localIndex.concat();
        else
            ret = list.toArray();
        return ret;
    }

    /**
     *  Prints the contents of this view to a string and returns it.
     * 
     *  @return The contents of this view, in string form.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function toString():String
    {
        if (localIndex)
        {
            //return ObjectUtil.toString(localIndex);
            return localIndex.toString();
        }
        else
        {
            if (list && Object(list).toString)
                return Object(list).toString();
            else
                return getQualifiedClassName(this);
        }
    }
    
    //--------------------------------------------------------------------------
    //
    // Proxy methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Attempts to call getItemAt(), converting the property name into an int.
     */
    COMPILE::SWF
    override flash_proxy function getProperty(name:*):*
    {
        if (name is QName)
            name = name.localName;
        
        return proxy_getProperty(name as String);
    }
    COMPILE::JS
    override public function getProperty(name:String):*
    {
        return proxy_getProperty(name);
    }
    
    private function proxy_getProperty(name:String):*
    {
        try
        {
            var n:Number = parseInt(String(name));
		}
		catch(e:Error) // localName was not a number
		{
		}
		
        /*
        if (isNaN(n))
		{
			var message:String = resourceManager.getString(
				"collections", "unknownProperty", [ name ]);
			throw new Error(message);
		}
        else
        {
        */
			// If caller passed in a number such as 5.5, it will be floored.
            return getItemAt(int(n));
        //}
    }
    
    /**
     *  @private
     *  Attempts to call setItemAt(), converting the property name into an int.
     */
    COMPILE::SWF
    override flash_proxy function setProperty(name:*, value:*):void
    {
        if (name is QName)
            name = name.localName;
        proxy_setProperty(name as String, value);
    }
    COMPILE::JS
    override public function setProperty(name:String, value:*):void
    {
        proxy_setProperty(name as String, value);
    }
    
    private function proxy_setProperty(name:String, value:*):void
    {
		
		try
		{
			var n:Number = parseInt(String(name));
		}
		catch(e:Error) // localName was not a number
		{
		}
		
        /*
		if (isNaN(n))
		{
			var message:String = resourceManager.getString(
				"collections", "unknownProperty", [ name ]);
			throw new Error(message);
		}
		else
		{
        */
			// If caller passed in a number such as 5.5, it will be floored.
			setItemAt(value, int(n));
		//}
    }
    
    /**
     *  @private
     *  This is an internal function.
     *  The VM will call this method for code like <code>"foo" in bar</code>
     *  
     *  @param name The property name that should be tested for existence.
     */
    COMPILE::SWF
    override flash_proxy function hasProperty(name:*):Boolean
    {
        if (name is QName)
            name = name.localName;
        
        return proxy_hasProperty(name as String);
    }
    COMPILE::JS
    override public function hasProperty(name:String):Boolean
    {
        return proxy_hasProperty(name as String);
    }
    
    private function proxy_hasProperty(name:String):Boolean
    {
        var index:int = -1;
        try
        {
            // If caller passed in a number such as 5.5, it will be floored.
            var n:Number = parseInt(String(name));
            if (!isNaN(n))
                index = int(n);
        }
        catch(e:Error) // localName was not a number
        {
        }

        if (index == -1)
            return false;

        return index >= 0 && index < length;
    }

    /**
     *  @private
     */
    COMPILE::SWF
    override flash_proxy function nextNameIndex(index:int):int
    {
        return index < length ? index + 1 : 0;
    }
    
    /**
     *  @private
     */
    COMPILE::SWF
    override flash_proxy function nextName(index:int):String
    {
        return (index - 1).toString();
    }
    
    /**
     *  @private
     */
    COMPILE::SWF
    override flash_proxy function nextValue(index:int):*
    {
        return getItemAt(index - 1);
    }    

    /**
     *  @private
     *  Any methods that can't be found on this class shouldn't be called,
     *  so return null
     */
    COMPILE::SWF
    override flash_proxy function callProperty(name:*, ... rest):*
    {
        return null;
    }

    COMPILE::JS
    override public function propertyNames():Array
    {
        var nextNameArray:Array = [];
        for (var i:int = 0; i < length; i++)
        {
            nextNameArray.push(i.toString());    
        }
        return nextNameArray;
    }
    
    //--------------------------------------------------------------------------
    //
    // EventDispatcher methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    COMPILE::SWF
    public function addEventListener(eventType:String,
                                     listener:Function,
                                     useCapture:Boolean = false,
                                     priority:int = 0,
                                     useWeakReference:Boolean = false):void
    {
        eventDispatcher.addEventListener(eventType, listener, useCapture,
                                         priority, useWeakReference);
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    COMPILE::SWF
    public function removeEventListener(eventType:String,
                                        listener:Function,
                                        useCapture:Boolean = false):void
    {
        eventDispatcher.removeEventListener(eventType, listener, useCapture);
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    [SWFOverride(params="flash.events.Event", altparams="org.apache.royale.events.Event"))]
    COMPILE::SWF
    public function dispatchEvent(event:Event):Boolean
    {
        return eventDispatcher.dispatchEvent(event);
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    COMPILE::SWF
    public function hasEventListener(eventType:String):Boolean
    {
        return eventDispatcher.hasEventListener(eventType);
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    COMPILE::SWF
    public function willTrigger(eventType:String):Boolean
    {
        return eventDispatcher.willTrigger(eventType);
    }

    //--------------------------------------------------------------------------
    //
    // Internal methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Take the item and insert it into the view.  If we don't have a sort
     *  use the sourceLocation.  Dispatch the CollectionEvent with kind ADD
     *  if dispatch is true.
     *
     *  @param items the items to add into the view
     *  @param sourceLocation the location within the list where the items were added
     *  @param dispatch true if the view should dispatch a corresponding
     *                 CollectionEvent with kind ADD (default is true)
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private function addItemsToView(items:Array, sourceLocation:int,
                                      dispatch:Boolean = true):int
    {
        var addedItems:Array = localIndex ? [] : items;
        var addLocation:int = sourceLocation;
        var firstOne:Boolean = true;

        if (localIndex)
        {
            var loc:int = sourceLocation;
			var length:int = items.length;
			
            for (var i:int = 0; i < length; i++)
            {
                var item:Object = items[i];
				
				if (filterFunction != null)
				{
					if (filterFunction(item))
					{
						if (sort)
							loc = findItem(item, Sort.ANY_INDEX_MODE, true);
						else 
							loc = getFilteredItemIndex(item);
						
						if (firstOne)
						{
							addLocation = loc;
							firstOne = false;
						}
					}
					else
					{
						loc = -1;
						addLocation = -1;
					}
				}
				else if (sort)
                {
                    loc = findItem(item, Sort.ANY_INDEX_MODE, true);
                    if (firstOne)
                    {
                        addLocation = loc;
                        firstOne = false;
                    }
                }
				else
				// List is sorted or filtered but refresh has not been called
				// Just add to end of list
				{
					loc = localIndex.length;	
					addLocation = loc;
				}
					
				if (loc != -1)
				{
                    localIndex.splice(loc++, 0, item);
                    addedItems.push(item);
				}
             }
        }
	
        /*
		if (sort && sort.unique && sort.compareFunction(item, localIndex[loc]) == 0)
		{
			// We cause all adds to fail here, not just the one.
			var message:String = resourceManager.getString(
				"collections", "incorrectAddition");
			throw new CollectionViewError(message);
		}
        */

        if (localIndex && addedItems.length > 1)
        {
            addLocation = -1;
        }

        if (dispatch && addedItems.length > 0)
        {
            var event:CollectionEvent =
                new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            event.kind = CollectionEventKind.ADD;
            event.location = addLocation;
            event.items = addedItems;
            dispatchEvent(event);
        }

        return addLocation;
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
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    mx_internal function findItem(values:Object, mode:String, insertIndex:Boolean = false):int
    {
        /*
        if (!sort || !localIndex)
        {
            var message:String = resourceManager.getString(
                "collections", "itemNotFound");
            throw new CollectionViewError(message);
        }
        */
        
        if (localIndex.length == 0)
            return insertIndex ? 0 : -1;
        
        try
        {
            return sort.findItem(localIndex, values, mode, insertIndex);
        }
        catch (e:SortError)
        {
            // usually because the find criteria is not compatible with the sort.
        }
        
        return -1;
    }

    /**
     *  Create a bookmark for this view.  This method is called by
     *  ListCollectionViewCursor.
     *
     *  @param index the index to bookmark
     *  @return a new bookmark instance
     *  @throws a CollectionViewError if the index is out of bounds
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    mx_internal function getBookmark(index:int):ListCollectionViewBookmark
    {
        /*
        if (index < 0 || index > length)
        {
            var message:String = resourceManager.getString(
                "collections", "invalidIndex", [ index ]);
            throw new CollectionViewError(message);
        }
        */

        var value:Object;
		try
        {
            value = getItemAt(index);
        }
        catch(e:Error)
        {
        }
        return new ListCollectionViewBookmark(value,
                                              this,
                                              revision,
                                              index);

    }

    /**
     *  Given a bookmark find the location for the value.  If the
     *  view has been modified since the bookmark was created attempt
     *  to relocate the item.  If the bookmark represents an item
     *  that is no longer in the view (removed or filtered out) return
     *  -1.
     *
     *  @param bookmark the bookmark to locate
     *  @return the new location of the bookmark, -1 if not in the view anymore
     *  @throws CollectionViewError if the bookmark is invalid
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    mx_internal function getBookmarkIndex(bookmark:CursorBookmark):int
    {
        /*
        if (!(bookmark is ListCollectionViewBookmark)
            || ListCollectionViewBookmark(bookmark).view != this)
        {
            var message:String = resourceManager.getString(
                "collections", "bookmarkNotFound");
            throw new CollectionViewError(message);
        }
        */

        var bm:ListCollectionViewBookmark = ListCollectionViewBookmark(bookmark);

        if (bm.viewRevision != revision)
        {
            // getItemAt has a side-effect of throwing an exception if the index is out-
            // of-range, here we are checking to see if the index falls with-in the range
            // and only then calling getItemAt.
            if (bm.index < 0 || bm.index >= length || getItemAt(bm.index) != bm.value)
            {
                try
                {
                    bm.index = getItemIndex(bm.value);
                }
                catch (e:SortError)
                {
                    bm.index = getLocalItemIndex(bm.value);
                }
            }

            bm.viewRevision = revision;
        }
        return bm.index;
    }

    /**
     * The view is a listener of CollectionEvents on its underlying IList
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private function listChangeHandler(event:CollectionEvent):void
    {
        if (autoUpdateCounter > 0)
        {
            if (!pendingUpdates)
            {
                pendingUpdates = [];
            }
            pendingUpdates.push(event);
        }
        else
        {
            switch (event.kind)
            {
                case CollectionEventKind.ADD:
                    addItemsToView(event.items, event.location);
                break;

                case CollectionEventKind.MOVE:
                    var n:int = event.items.length;
                    for (var i:int = 0; i < n; i++)
                        moveItemInView(event.items[i]);                        
                break;
                
                case CollectionEventKind.RESET:
                    reset();
                break;

                case CollectionEventKind.REMOVE:
                    removeItemsFromView(event.items, event.location);
                break;

                case CollectionEventKind.REPLACE:
                     replaceItemsInView(event.items, event.location);
                break;

                case CollectionEventKind.UPDATE:
                     handlePropertyChangeEvents(event.items);
                break;

                default:
                    dispatchEvent(event);
            } // switch
        }
    }

    /**
     * Given a set of <code>PropertyChangeEvent</code>s go through and update the view.
     * This is currently not optimized.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private function handlePropertyChangeEvents(events:Array):void
    {
        var eventItems:Array = events;
        if (sort || filterFunction != null)
        {
            //go through the events and find all the individual objects
            //that have been updated
            //then for each one determine whether we should move it or
            //just fire an update event
            var updatedItems:Array = [];
            var updateEntry:Object;
            var i:int;
            for (i = 0; i < events.length; i++)
            {
                var updateInfo:PropertyChangeEvent = events[i];
                var item:Object;
                var defaultMove:Boolean;
                if (updateInfo.target)
                {
                    item = updateInfo.target;
                    //if the target != source that means the update
                    //happened to some sub-property of the item in the collection.
                    //if we have a custom comparator this will affect
                    //the sort so for now say we should move but
                    //maybe we could optimize further
                    defaultMove = updateInfo.target != updateInfo.source;
                }
                else
                {
                    item = updateInfo.source;
                    defaultMove = false;
                }

                //see if the item is already in the list
                var j:int = 0;
                for (; j < updatedItems.length; j++)
                {
					if (updatedItems[j].item == item)
					{
						// even if it is, if a different property changed, track that too.
						var evts:Array = updatedItems[j].events as Array;
						var l:int = evts.length;
						for (var k:int = 0; k < l; k++)
						{
							if (evts[k].property != updateInfo.property)
							{
								evts.push(updateInfo);
								break;
							}
							// we could also merge events for changes to the same
							// property but that's hopefully low probability
							// and leads to questions of event order.
						}
                        break;
					}
                }

                if (j < updatedItems.length)
                {
                    updateEntry = updatedItems[j];
                }
                else
                {
                    var oldOrNewValueSpecified:Boolean = updateInfo.oldValue != null || updateInfo.newValue != null;
                    var objectReplacedInCollection:Boolean = updateInfo.property == null && oldOrNewValueSpecified;
                    var somethingUnknownAboutTheObjectChanged:Boolean = updateInfo.property == null && !oldOrNewValueSpecified;
                    updateEntry = {item: item, move: defaultMove, events: [updateInfo],
                        undefinedChange:somethingUnknownAboutTheObjectChanged,
                        objectReplacedWithAnother: objectReplacedInCollection, oldItem: updateInfo.oldValue};
                    updatedItems.push(updateEntry);
                }

                //if we've already set move don't unset it
                //if there's a filterFunction need to go through move
                //if the property affects the sort, we'll need to move
                updateEntry.move = updateEntry.move
                    || filterFunction != null
                    || updateEntry.objectReplacedWithAnother
                    || updateEntry.undefinedChange
                    || (sort && sort.propertyAffectsSort(String(updateInfo.property)));
            }

			// go through the items and move and send move events for ones that moved
			// and build the list of remaining items we need to send UPDATE events for
            eventItems = [];
            for (i = 0; i < updatedItems.length; i++)
            {
                updateEntry = updatedItems[i];
                if (updateEntry.move)
                {
                    if(updateEntry.objectReplacedWithAnother)
                    {
                        removeItemsFromView([updateEntry.oldItem], -1, true);
                    }
                    moveItemInView(updateEntry.item, updateEntry.item != null, eventItems);
                }
                else
                {
                    eventItems.push(updateEntry.item);
                }
            }

			// now go through the updated items and add all events for all 
			// properties that changed in that item (except for those items
			// we moved)
            var temp:Array = [];
            for (var ctr:int = 0; ctr < eventItems.length; ctr++)
                for (var ctr1:int = 0; ctr1 < updatedItems.length; ctr1++)
                    if (eventItems[ctr] == updatedItems[ctr1].item)
					{
                        temp = temp.concat(updatedItems[ctr1].events);
					}
            eventItems = temp;
        }

        if (eventItems.length > 0)
        {
            var updateEvent:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            updateEvent.kind = CollectionEventKind.UPDATE;
            updateEvent.items = eventItems;
            dispatchEvent(updateEvent);
        }
    }

    /**
     * When enableAutoUpdates pushes autoUpdateCounter back down to 0
     * this method will execute to consolidate the pending update
     * events or turn it into a massive refresh().
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private function handlePendingUpdates():void
    {
        if (pendingUpdates)
        {
            var pu:Array = pendingUpdates;
            pendingUpdates = null;

            // Could further optimize to consolidate various events
            // and make a decision if there are too many updates
            // and we should just refresh.
            var singleUpdateEvent:CollectionEvent;
            for (var i:int = 0; i < pu.length; i++)
            {
                var event:CollectionEvent = pu[i];
                if (event.kind == CollectionEventKind.UPDATE)
                {
                    if (!singleUpdateEvent)
                    {
                        singleUpdateEvent = event;
                    }
                    else
                    {
                        for (var j:int = 0; j < event.items.length; j++)
                        {
                            singleUpdateEvent.items.push(event.items[j]);
                        }
                    }
                }
                else
                {
                    listChangeHandler(event);
                }
            }

            if (singleUpdateEvent)
            {
                listChangeHandler(singleUpdateEvent);
            }
        }
    }

    private function internalRefresh(dispatch:Boolean):Boolean
    {
        if (sort || filterFunction != null)
        {
            /*
            try
            {
            */
                populateLocalIndex();
            /*
            }
            catch(pending:ItemPendingError)
            {
                pending.addResponder(new ItemResponder(
                    function(data:Object, token:Object = null):void
                    {
                        internalRefresh(dispatch);
                    },
                    function(info:Object, token:Object = null):void
                    {
                        //no-op
                    }));
                return false;
            }
            */

            if (filterFunction != null)
            {
                var tmp:Array = [];
                var len:int = localIndex.length;
                for (var i:int = 0; i < len; i++)
                {
                    var item:Object = localIndex[i];
                    if (filterFunction(item))
                    {
                        tmp.push(item);
                    }
                }
                localIndex = tmp;
            }
			
            if (sort)
            {
                sort.sort(localIndex);
                dispatch = true;
            }
        }
        else if (localIndex)
        {
            localIndex = null;
        }

        revision++;
        pendingUpdates = null;
        if (dispatch)
        {
            var refreshEvent:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            refreshEvent.kind = CollectionEventKind.REFRESH;
            dispatchEvent(refreshEvent);
        }
        return true;
    }

    /**
     * Remove the old value from the view and replace it with the value
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private function moveItemInView(item:Object, dispatch:Boolean = true, updateEventItems:Array = null):void
    {
        if (localIndex)
        {
            //we're guaranteed that removeItemsFromView isn't going
            //to work here because the item has probably
            //already been updated so getItemIndex is going to fail
            //so we'll just do a linear search and find it if it's here
            var removeLocation:int = -1;
            for (var i:int = 0; i < localIndex.length; i++)
            {
                if (localIndex[i] == item)
                {
                    removeLocation = i;
                    break;
                }
            }
            if (removeLocation > -1)
            {
                localIndex.splice(removeLocation, 1);
            }

            var addLocation:int = addItemsToView([item], removeLocation, false);

            if (dispatch)
            {
                var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
                event.items.push(item);
                if (updateEventItems && addLocation == removeLocation && addLocation > -1)
                {
                    updateEventItems.push(item);
                    return;
                }
                if (addLocation > -1 && removeLocation > -1)
                {
                    event.kind = CollectionEventKind.MOVE;
                    event.location = addLocation;
                    event.oldLocation = removeLocation;
                }
                else if (addLocation > -1)
                {
                    event.kind = CollectionEventKind.ADD;
                    event.location = addLocation;
                }
                else if (removeLocation > -1)
                {
                    event.kind = CollectionEventKind.REMOVE;
                    event.location = removeLocation;
                }
                else
                {
                    dispatch = false;
                }

                if (dispatch)
                {
                    dispatchEvent(event);
                }
            }
        }
    }

    /**
     * Copy all of the data from the source list into the local index.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private function populateLocalIndex():void
    {
        if (list)
        {
            localIndex = list.toArray();
        }
        else
        {
            localIndex = [];
        }
    }

    /**
     *  Take the item and remove it from the view.  If we don't have a sort
     *  use the sourceLocation.  Dispatch the CollectionEvent with kind REMOVE
     *  if dispatch is true.
     *
     *  @param items the items to remove from the view
     *  @param sourceLocation the location within the list where the item was removed
     *  @param dispatch true if the view should dispatch a corresponding
     *                 CollectionEvent with kind REMOVE (default is true)
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private function removeItemsFromView(items:Array, sourceLocation:int, dispatch:Boolean = true):void
    {
        var removedItems:Array = localIndex ? [] : items;
        var removeLocation:int = sourceLocation;
        if (localIndex)
        {
            for (var i:int = 0; i < items.length; i++)
            {
                var item:Object = items[i];
                var loc:int = getItemIndex(item);
                if (loc > -1)
                {
                    localIndex.splice(loc, 1);
                    removedItems.push(item);
                    removeLocation = loc;
                }
            }
        }
        if (dispatch && removedItems.length > 0)
        {
            var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            event.kind = CollectionEventKind.REMOVE;
            event.location = (!localIndex || removedItems.length == 1)
                ? removeLocation
                : -1;
            event.items = removedItems;
            dispatchEvent(event);
        }
    }

    /**
     * Items is an array of PropertyChangeEvents so replace the oldValues with the new
     * newValues.  Start at the location specified and move forward, it's unlikely
     * that the length of items is > 1.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private function replaceItemsInView(changeEvents:Array,
                                          location:int,
                                          dispatch:Boolean = true):void
    {
        if (localIndex)
        {
            var len:int = changeEvents.length;
            var oldItems:Array = [];
            var newItems:Array = [];
            for (var i:int = 0; i < len; i++)
            {
                var propertyEvent:PropertyChangeEvent = changeEvents[i];
                oldItems.push(propertyEvent.oldValue);
                newItems.push(propertyEvent.newValue);
            }
            removeItemsFromView(oldItems, location, dispatch);
            addItemsToView(newItems, location, dispatch);
        }
        else
        {
            var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            event.kind = CollectionEventKind.REPLACE;
            event.location = location;
            event.items = changeEvents;
            dispatchEvent(event);
        }
    }

    /**
     *  @private
     *  When the source list is replaced, reset.
     */
    mx_internal function reset():void
    {
        internalRefresh(false);
        if (dispatchResetEvent)
        {
            var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            event.kind = CollectionEventKind.RESET;
            dispatchEvent(event);
        }
    }

    /*
    public function get complexFieldWatcher():ComplexFieldChangeWatcher
    {
        return _complexFieldWatcher;
    }

    public function set complexFieldWatcher(value:ComplexFieldChangeWatcher):void
    {
        if(_complexFieldWatcher != value)
        {
            stopWatchingForComplexFieldsChanges();

            _complexFieldWatcher = value;
            if(_complexFieldWatcher)
                _complexFieldWatcher.mx_internal::list = this;

            startWatchingForComplexFieldsChanges();
        }
    }

    private function startWatchingForComplexFieldsChanges():void
    {
        if(complexFieldWatcher && sort && sort.fields)
        {
            _complexFieldWatcher.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onComplexFieldValueChanged, false, 0, true);
            _complexFieldWatcher.startWatchingForComplexFieldChanges();
        }
    }

    private function stopWatchingForComplexFieldsChanges():void
    {
        if(complexFieldWatcher)
        {
            _complexFieldWatcher.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onComplexFieldValueChanged);
            _complexFieldWatcher.stopWatchingForComplexFieldChanges();
        }
    }

    private function onComplexFieldValueChanged(changeEvent:PropertyChangeEvent):void
    {
        if(sort)
        {
            moveItemInView(changeEvent.source);
        }
    }
    */
}

}

import org.apache.royale.events.EventDispatcher;

import mx.collections.*;
import mx.collections.errors.*;
import mx.core.mx_internal;
import mx.events.*;
//import mx.resources.IResourceManager;
//import mx.resources.ResourceManager;

use namespace mx_internal;

/**
 *  Dispatched whenever the cursor position is updated.
 *
 *  @eventType mx.events.FlexEvent.CURSOR_UPDATE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="cursorUpdate", type="mx.events.FlexEvent")]

//[ResourceBundle("collections")]

/**
 *  @private
 *  The internal implementation of cursor for the ListCollectionView.
 */
class ListCollectionViewCursor extends EventDispatcher implements IViewCursor
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private static const BEFORE_FIRST_INDEX:int = -1;

    /**
     *  @private
     */
    private static const AFTER_LAST_INDEX:int = -2;

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  <p>Creates the cursor for the view.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function ListCollectionViewCursor(view:ListCollectionView)
    {
        super();

        _view = view;
        _view.addEventListener(CollectionEvent.COLLECTION_CHANGE, collectionEventHandler);
        //_view.addEventListener(CollectionEvent.COLLECTION_CHANGE, collectionEventHandler, false, 0, true);
        currentIndex = view.length > 0 ? 0 : AFTER_LAST_INDEX;
        if (currentIndex == 0)
        {
            /*
            try
            {
            */
                setCurrent(view.getItemAt(0), false);
            /*
            }
            catch(e:ItemPendingError)
            {
                currentIndex = BEFORE_FIRST_INDEX;
                setCurrent(null, false);
            }
            */
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private var _view:ListCollectionView;

    /**
     *  @private
     */
    private var currentIndex:int;

    /**
     *  @private
     */
    private var currentValue:Object;

    /**
     *  @private
     */
    private var invalid:Boolean;

    /**
     *  @private
     *  Used for accessing localized Error messages.
     */
    //private var resourceManager:IResourceManager =
    //                                ResourceManager.getInstance();

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    /**
     *  Get a reference to the view that this cursor is associated with.
     *  @return the associated <code>ICollectionView</code>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get view():ICollectionView
    {
        checkValid();
        return _view;
    }

    [Bindable("cursorUpdate")]
    /**
     *  Provides access the object at the current location referenced by
     *  this cursor within the source collection.
     *  If the cursor is beyond the ends of the collection (beforeFirst,
     *  afterLast) this will return <code>null</code>.
     *
     *  @see mx.collections.IViewCursor#moveNext
     *  @see mx.collections.IViewCursor#movePrevious
     *  @see mx.collections.IViewCursor#seek
     *  @see mx.collections.IViewCursor#beforeFirst
     *  @see mx.collections.IViewCursor#afterLast
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get current():Object
    {
        checkValid();

        return currentValue;
    }

    [Bindable("cursorUpdate")]
    
    /**
     *  Provides access to the bookmark of the item returned by the
     *  <code>current</code> property.
     *  The bookmark can be used to move the cursor to a previously visited
     *  item, or one relative to it (see the <code>seek()</code> method for
     *  more information).
     *
     *  @see mx.collections.IViewCursor#current
     *  @see mx.collections.IViewCursor#seek
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get bookmark():CursorBookmark
    {
        checkValid();
        if (view.length == 0 || beforeFirst) return CursorBookmark.FIRST;
        else if (afterLast) return CursorBookmark.LAST;
        //if currentIndex > view.length this is a bug in cursor and i want the
        //exception thrown to track it down
        else return ListCollectionView(view).getBookmark(currentIndex);
    }


    [Bindable("cursorUpdate")]
    /**
     * true if the current is sitting before the first item in the view.
     * If the ICollectionView is empty (length == 0) this will always
     * be true.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get beforeFirst():Boolean
    {
        checkValid();
        return currentIndex == BEFORE_FIRST_INDEX || view.length == 0;
    }


    [Bindable("cursorUpdate")]
    /**
     * true if the cursor is sitting after the last item in the view.
     * If the ICollectionView is empty (length == 0) this will always
     * be true.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get afterLast():Boolean
    {
        checkValid();
        return currentIndex == AFTER_LAST_INDEX || view.length == 0;
    }

    /**
     *  Finds the item with the specified properties within the
     *  collection and positions the cursor on that item.
     *  If the item can not be found no change to the current location will be
     *  made.
     *  <code>findAny()</code> can only be called on sorted views, if the view
     *  isn't sorted, or items in the view do not contain properties used
     *  to compute the sort order, a <code>CursorError</code> will be thrown.
     *  <p>
     *  If the associated collection is remote, and not all of the items have
     *  been cached locally this method will begin an asynchronous fetch from the
     *  remote collection, or if one is already in progress wait for it to
     *  complete before making another fetch request.
     *  If multiple items can match the search criteria then the item found is
     *  non-deterministic.
     *  If it is important to find the first or last occurrence of an item in a
     *  non-unique index use the <code>findFirst()</code> or
     *  <code>findLast()</code>.
     *  The values specified must be configured as name-value pairs, as in an
     *  associative array (or the actual object to search for).
     *  The values of the names specified must match those properties specified in
     *  the sort. for example
     *  If properties "x", "y", and "z" are the in the current index, the values
     *  specified should be {x:x-value, y:y-value,z:z-value}.
     *  When all of the data is local this method will return <code>true</code> if
     *  the item can be found and false otherwise.
     *  If the data is not local and an asynchronous operation must be performed,
     *  an <code>ItemPendingError</code> will be thrown.
     *
     *  @see mx.collections.IViewCursor#findFirst
     *  @see mx.collections.IViewCursor#findLast
     *  @see mx.collections.errors.ItemPendingError
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function findAny(values:Object):Boolean
    {
        checkValid();
        var lcView:ListCollectionView = ListCollectionView(view);
        var index:int;
        try
        {
            index = lcView.findItem(values, Sort.ANY_INDEX_MODE);
        }
        catch(e:SortError)
        {
            //this is because the find critieria is not compatible with the
            //sort
            throw new CursorError(e.message);
        }
        if (index > -1)
        {
            currentIndex = index;
            setCurrent(lcView.getItemAt(currentIndex));
        }
        return index > -1;
    }

    /**
     *  Finds the first item with the specified properties
     *  within the collection and positions the cursor on that item.
     *  If the item can not be found no change to the current location will be
     *  made.
     *  <code>findFirst()</code> can only be called on sorted views, if the view
     *  isn't sorted, or items in the view do not contain properties used
     *  to compute the sort order, a <code>CursorError</code> will be thrown.
     *  <p>
     *  If the associated collection is remote, and not all of the items have been
     *  cached locally this method will begin an asynchronous fetch from the
     *  remote collection, or if one is already in progress wait for it to
     *  complete before making another fetch request.
     *  If it is not important to find the first occurrence of an item in a
     *  non-unique index use <code>findAny()</code> as it may be a little faster.
     *  The values specified must be configured as name-value pairs, as in an
     *  associative array (or the actual object to search for).
     *  The values of the names specified must match those properties specified in
     *  the sort. for example If properties "x", "y", and "z" are the in the current
     *  index, the values specified should be {x:x-value, y:y-value,z:z-value}.
     *  When all of the data is local this method will
     *  return <code>true</code> if the item can be found and false otherwise.
     *  If the data is not local and an asynchronous operation must be performed,
     *  an <code>ItemPendingError</code> will be thrown.
     *
     *  @see mx.collections.IViewCursor#findAny
     *  @see mx.collections.IViewCursor#findLast
     *  @see mx.collections.errors.ItemPendingError
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function findFirst(values:Object):Boolean
    {
        checkValid();
        var lcView:ListCollectionView = ListCollectionView(view);
        var index:int;
        try
        {
            index = lcView.findItem(values, Sort.FIRST_INDEX_MODE);
        }
        catch(sortError:SortError)
        {
            //this is because the find critieria is not compatible with the
            //sort
            throw new CursorError(sortError.message);
        }
        if (index > -1)
        {
            currentIndex = index;
            setCurrent(lcView.getItemAt(currentIndex));
        }
        return index > -1;
    }


    /**
     *  Finds the last item with the specified properties
     *  within the collection and positions the cursor on that item.
     *  If the item can not be found no change to the current location will be
     *  made.
     *  <code>findLast()</code> can only be called on sorted views, if the view
     *  isn't sorted, or items in the view do not contain properties used
     *  to compute the sort order, a <code>CursorError</code> will be thrown.
     *  <p>
     *  If the associated collection is remote, and not all of the items have been
     *  cached locally this method will begin an asynchronous fetch from the
     *  remote collection, or if one is already in progress wait for it to
     *  complete before making another fetch request.
     *  If it is not important to find the last occurrence of an item in a
     *  non-unique index use <code>findAny()</code> as it may be a little faster.
     *  The values specified must be configured as  name-value pairs, as in an
     *  associative array (or the actual object to search for).
     *  The values of the names specified must match those properties specified in
     *  the sort. for example If properties "x", "y", and "z" are the in the current
     *  index, the values specified should be {x:x-value, y:y-value,z:z-value}.
     *  When all of the data is local this method will
     *  return <code>true</code> if the item can be found and false otherwise.
     *  If the data is not local and an asynchronous operation must be performed,
     *  an <code>ItemPendingError</code> will be thrown.
     *
     *  @see mx.collections.IViewCursor#findAny
     *  @see mx.collections.IViewCursor#findFirst
     *  @see mx.collections.errors.ItemPendingError
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function findLast(values:Object):Boolean
    {
        checkValid();
        var lcView:ListCollectionView = ListCollectionView(view);
        var index:int;
        try
        {
            index = lcView.findItem(values, Sort.LAST_INDEX_MODE);
        }
        catch(sortError:SortError)
        {
            //this is because the find critieria is not compatible with the
            //sort
            throw new CursorError(sortError.message);
        }
        if (index > -1)
        {
            currentIndex = index;
            setCurrent(lcView.getItemAt(currentIndex));
        }
        return index > -1;
    }

    /**
     * Insert the specified item before the cursor's current position.
     * If the cursor is <code>afterLast</code> the insertion
     * will happen at the end of the View.  If the cursor is
     * <code>beforeFirst</code> on a non-empty view an error will be thrown.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function insert(item:Object):void
    {
        var insertIndex:int;
        if (afterLast)
        {
            insertIndex = view.length;
        }
        else if (beforeFirst)
        {
            if (view.length > 0)
            {
                var message:String = /*resourceManager.getString(
                    "collections", */"invalidInsert"/*)*/;
                throw new CursorError(message);
            }
            else
            {
                insertIndex = 0;
            }
        }
        else
        {
            insertIndex = currentIndex;
        }
        ListCollectionView(view).addItemAt(item, insertIndex);
    }

    /**
     *  Moves the cursor to the next item within the collection. On success
     *  the <code>current</code> property will be updated to reference the object at this
     *  new location.  Returns true if current is valid, false if not (afterLast).
     *  If the data is not local and an asynchronous operation must be performed, an
     *  <code>ItemPendingError</code> will be thrown. See the ItemPendingError docs
     *  as well as the collections documentation for more information on using the
     *  ItemPendingError.
     *
     *  @return true if still in the list, false if current is now afterLast
     *
     *  @see mx.collections.IViewCursor#current
     *  @see mx.collections.IViewCursor#movePrevious
     *  @see mx.collections.errors.ItemPendingError
     *  @example
     *  <pre>
     *    var myArrayCollection:ICollectionView = new ArrayCollection(["Bobby", "Mark", "Trevor", "Jacey", "Tyler"]);
     *    var cursor:IViewCursor = myArrayCollection.createCursor();
     *    while (!cursor.afterLast)
     *    {
     *       trace(cursor.current);
     *       cursor.moveNext();
     *     }
     *  </pre>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function moveNext():Boolean
    {
        //the afterLast getter checks validity and also checks length > 0
        if (afterLast)
        {
            return false;
        }
        // we can't set the index until we know that we can move there first.
        var tempIndex:int = beforeFirst ? 0 : currentIndex + 1;
        if (tempIndex >= view.length)
        {
            tempIndex = AFTER_LAST_INDEX;
            setCurrent(null);
        }
        else
        {
            setCurrent(ListCollectionView(view).getItemAt(tempIndex));
        }
        currentIndex = tempIndex;
        return !afterLast;
    }

    /**
     *  Moves the cursor to the previous item within the collection. On success
     *  the <code>current</code> property will be updated to reference the object at this
     *  new location.  Returns true if current is valid, false if not (beforeFirst).
     *  If the data is not local and an asynchronous operation must be performed, an
     *  <code>ItemPendingError</code> will be thrown. See the ItemPendingError docs
     * as well as the collections documentation for more information on using the
     * ItemPendingError.
     *
     *  @return true if still in the list, false if current is now beforeFirst
     *
     *  @see mx.collections.IViewCursor#current
     *  @see mx.collections.IViewCursor#moveNext
     *  @see mx.collections.errors.ItemPendingError
     *  @example
     *  <pre>
     *     var myArrayCollection:ICollectionView = new ArrayCollection(["Bobby", "Mark", "Trevor", "Jacey", "Tyler"]);
     *     var cursor:ICursor = myArrayCollection.createCursor();
     *     cursor.seek(CursorBookmark.last);
     *     while (!cursor.beforeFirst)
     *     {
     *        trace(current);
     *        cursor.movePrevious();
     *      }
     *  </pre>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */

    public function movePrevious():Boolean
    {
        //the afterLast getter checks validity and also checks length > 0
        if (beforeFirst)
        {
            return false;
        }
        // we can't set the index until we know that we can move there first
        var tempIndex:int = afterLast ? view.length - 1 : currentIndex - 1;
        if (tempIndex == -1)
        {
            tempIndex = BEFORE_FIRST_INDEX;
            setCurrent(null);
        }
        else
        {
            setCurrent(ListCollectionView(view).getItemAt(tempIndex));
        }
        currentIndex = tempIndex;
        return !beforeFirst;
    }

    /**
     * Remove the current item and return it.  If the cursor is
     * <code>beforeFirst</code> or <code>afterLast</code> throw a
     * CursorError.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function remove():Object
    {
        /*
        if (beforeFirst || afterLast)
        {
            var message:String = resourceManager.getString(
                "collections", "invalidRemove");
            throw new CursorError(message);
        }
        */
        var oldIndex:int = currentIndex;
        currentIndex++;
        if (currentIndex >= view.length)
        {
            currentIndex = AFTER_LAST_INDEX;
            setCurrent(null);
        }
        else
        {
            /*
            try
            {
            */
                setCurrent(ListCollectionView(view).getItemAt(currentIndex));
            /*
            }
            catch(e:ItemPendingError)
            {
                setCurrent(null, false);
                ListCollectionView(view).removeItemAt(oldIndex);
                throw e;
            }
            */
        }
        var removed:Object = ListCollectionView(view).removeItemAt(oldIndex);
        return removed;
    }

    /**
     *  Moves the cursor to a location at an offset from the specified
     *  bookmark.
     *  The offset can be negative in which case the cursor is positioned an
     *  offset number of items prior to the specified bookmark.
     *  If the associated collection is remote, and not all of the items have been
     *  cached locally this method will begin an asynchronous fetch from the
     *  remote collection.
     *
     *  If the data is not local and an asynchronous operation must be performed, an
     *  <code>ItemPendingError</code> will be thrown. See the ItemPendingError docs
     *  as well as the collections documentation for more information on using the
     *  ItemPendingError.
     *
     *
     *  @param bookmark <code>CursorBookmark</code> reference to marker information that
     *                 allows repositioning to a specific location.
     *           In addition to supplying a value returned from the <code>bookmark</code>
     *           property, there are three constant bookmark values that can be
     *           specified:
     *            <ul>
     *                <li><code>CursorBookmark.FIRST</code> - seek from
     *                the start (first element) of the collection</li>
     *                <li><code>CursorBookmark.CURRENT</code> - seek from
     *                the current position in the collection</li>
     *                <li><code>CursorBookmark.LAST</code> - seek from the
     *                end (last element) of the collection</li>
     *            </ul>
     *  @param offset indicates how far from the specified bookmark to seek.
     *           If the specified number is negative the cursor will attempt to
     *           move prior to the specified bookmark, if the offset specified is
     *           beyond the end points of the collection the cursor will be
     *           positioned off the end (beforeFirst or afterLast).
     *  @param prefetch indicates the intent to iterate in a specific direction once the
     *           seek operation completes, this reduces the number of required
     *           network round trips during a seek.
     *           If the iteration direction is known at the time of the request
     *           the appropriate amount of data can be returned ahead of the
     *           request to iterate it.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function seek(bookmark:CursorBookmark, offset:int = 0, prefetch:int = 0):void
    {
        checkValid();
        if (view.length == 0)
        {
            currentIndex = AFTER_LAST_INDEX;
            setCurrent(null, false);
            return;
        }

        var newIndex:int = currentIndex;
        if (bookmark == CursorBookmark.FIRST)
        {
            newIndex = 0;
        }
        else if (bookmark == CursorBookmark.LAST)
        {
            newIndex = view.length - 1;
        }
        else if (bookmark != CursorBookmark.CURRENT)
        {
            var message:String;
            //try
            //{
                newIndex = ListCollectionView(view).getBookmarkIndex(bookmark);
                if (newIndex < 0)
                {
                    setCurrent(null);
                    
                    /*
                    message = resourceManager.getString(
                        "collections", "bookmarkInvalid");
                    throw new CursorError(message);
                    */
                }
            /*
            }
            catch(bmError:CollectionViewError)
            {
                message = resourceManager.getString(
                    "collections", "bookmarkInvalid");
                throw new CursorError(message);
            }
            */
        }

        newIndex += offset;

        var newCurrent:Object = null;
        if (newIndex >= view.length)
        {
            currentIndex = AFTER_LAST_INDEX;
        }
        else if (newIndex < 0)
        {
            currentIndex = BEFORE_FIRST_INDEX;
        }
        else
        {
            newCurrent = ListCollectionView(view).getItemAt(newIndex, prefetch);
            currentIndex = newIndex;
        }
        setCurrent(newCurrent);
    }

    //--------------------------------------------------------------------------
    //
    // Internal methods
    //
    //--------------------------------------------------------------------------

    private function checkValid():void
    {
        /*
        if (invalid)
        {
            var message:String = resourceManager.getString(
                "collections", "invalidCursor");
            throw new CursorError(message);
        }
        */
    }

    private function collectionEventHandler(event:CollectionEvent):void
    {
        switch (event.kind)
        {
            case CollectionEventKind.ADD:
                if (event.location <= currentIndex)
                {
                    currentIndex += event.items.length;
                }
            break;

            case CollectionEventKind.REMOVE:
                if (event.location < currentIndex)
                {
                    currentIndex -= event.items.length;
                }
                else if (event.location == currentIndex)
                {
                    if (currentIndex < view.length)
                    {
                        /*
                        try
                        {
                        */
                            setCurrent(ListCollectionView(view).getItemAt(currentIndex));
                        /*
                        }
                        catch(error:ItemPendingError)
                        {
                            setCurrent(null, false);    
                        }
                        */
                    }
                    else // currentIndex == view.length
                    {
                        //we were removed!  is this an error?
                        //should cursor move to now last item, view.length - 1?? 
                        currentIndex = AFTER_LAST_INDEX;
                        setCurrent(null); //dispatch the updated at least
                    }
                }
            break;

            case CollectionEventKind.MOVE:
                if (event.oldLocation == currentIndex)
                {
                    currentIndex = event.location;
                }
                else
                {
                    if (event.oldLocation < currentIndex)
                    {
                        currentIndex -= event.items.length;
                    }
                    if (event.location <= currentIndex)
                    {
                        currentIndex += event.items.length;
                    }
                }
            break;

            case CollectionEventKind.REFRESH:
                if (!(beforeFirst || afterLast))
                {
                    try 
                    {
                        currentIndex = ListCollectionView(view).getItemIndex(currentValue);
                    }
                    catch (e:SortError)
                    {
                        if (ListCollectionView(view).sort)
                        {
                            currentIndex = ListCollectionView(view).getLocalItemIndex(currentValue);
                        }
                    }
                    if (currentIndex == -1)
                    {
                        setCurrent(null);
                    }
                }
            break;

            case CollectionEventKind.REPLACE:
                if (event.location == currentIndex)
                {
                    /*
                    try
                    {
                    */
                        setCurrent(ListCollectionView(view).getItemAt(currentIndex));
                    /*
                    }
                    catch(error:ItemPendingError)
                    {
                        setCurrent(null, false);    
                    }
                    */
                }
            break;

            case CollectionEventKind.RESET:
                //just move to the beginning
                currentIndex = BEFORE_FIRST_INDEX;
                setCurrent(null);
                break;
        }
    }

    /**
     *  @private
     */
    private function setCurrent(value:Object, dispatch:Boolean = true):void
    {
        currentValue = value;

        //if (dispatch)
        //    dispatchEvent(new FlexEvent(FlexEvent.CURSOR_UPDATE));
    }
}

/**
 *  @private
 *  Encapsulates the positional aspects of a cursor within an ListCollectionView.
 *  Only the ListCollectionView should construct this.
 */
class ListCollectionViewBookmark extends CursorBookmark
{
    mx_internal var index:int;
    mx_internal var view:ListCollectionView;
    mx_internal var viewRevision:int;

    /**
     *  @private
     */
    public function ListCollectionViewBookmark(value:Object,
                                               view:ListCollectionView,
                                               viewRevision:int,
                                               index:int)
    {
        super(value);
        this.view = view;
        this.viewRevision = viewRevision;
        this.index = index;
    }

    /**
     *  Gets the approximate index of the item represented by this bookmark
     *  in its view. If the item has been paged out, this method could throw an
     *  ItemPendingError.
     *
     *  @return The index of the item. If the item is not in the current view,
     *  this method returns -1. This method also returns -1 if index-based location
     *  retrieval is not possible.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function getViewIndex():int
    {
        return view.getBookmarkIndex(this);
    }
}