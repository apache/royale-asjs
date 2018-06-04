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
	COMPILE::JS {
		import goog.DEBUG;
	}
	import org.apache.royale.events.Event;
    import org.apache.royale.events.EventDispatcher
	/*
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.utils.Proxy;
    import flash.utils.flash_proxy;
    import flash.utils.getQualifiedClassName;

    import mx.binding.utils.BindingUtils;
    import mx.binding.utils.ChangeWatcher;
    import mx.collections.errors.CollectionViewError;
    import mx.collections.errors.ItemPendingError;
    import mx.collections.errors.SortError;
    import mx.core.IMXMLObject;
    import mx.core.mx_internal;
    import mx.events.CollectionEvent;
    import mx.events.CollectionEventKind;
    import mx.events.PropertyChangeEvent;
    import mx.resources.IResourceManager;
    import mx.resources.ResourceManager;
    import mx.utils.ObjectUtil;

    use namespace mx_internal;
	*/

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

[ResourceBundle("collections")]
    
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
public class ListCollectionView //extends Proxy implements ICollectionView, IList, IMXMLObject
{
    //include "../core/Version.as";

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
    
    //mx_internal var dispatchResetEvent:Boolean = true;

    /**
     *  @private
     *  Used for accessing localized Error messages.
     */
	 /*
    private var resourceManager:IResourceManager =
                                    ResourceManager.getInstance();
	*/
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

        //eventDispatcher = new EventDispatcher(this);
        //this.list = list;
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
		*/
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
    public function addAllAt(addList:Object, index:int):void
	//(addList:IList, index:int):void
    {	
        /*if (index < 0 || index > this.length)
        {
            var message:String = resourceManager.getString(
                "collections", "outOfBounds", [ index ]);
            throw new RangeError(message);
        }
        
        var length:int = addList.length;

        for (var i:int=0; i < length; i++)
        {
            var insertIndex:int = i + index;
			
			// incremental index may be out of bounds because of filtering,
			// so add this item to the end.
			if (insertIndex > this.length)
				insertIndex = this.length;
			
            this.addItemAt(addList.getItemAt(i), insertIndex);
        }*/
    }

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

        if (localIndex)
        {
            return localIndex[index];
        }
        else if (list)
        {
            return list.getItemAt(index, prefetch);
        }
		*/
        return null;
    }

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
        /*else if (list)
        {
            return list.length;
        }*/
        else
        {
            return 0;
        }
    }

    //----------------------------------
    //  list
    //----------------------------------
    
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
        return true; //internalRefresh(true);
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
		/*
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
		*/
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

        var listIndex:int = index;
        if (localIndex)
        {
            var oldItem:Object = localIndex[index];
            listIndex = list.getItemIndex(oldItem);
        }
        return list.removeItemAt(listIndex);
		*/
		return null;
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

            //dispatchEvent(new Event("sortChanged"));
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
		/*
        else
            ret = list.toArray();
		*/
        return ret;
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function createCursor():void
	//IViewCursor
    {
        //return new ListCollectionViewCursor(this);
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
		/*
        _filterFunction = f;
        dispatchEvent(new Event("filterFunctionChanged"));
		*/
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
        /*
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
		*/
		return i;
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
        //list.itemUpdated(item, property, oldValue, newValue);
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
		*/
		return null;
    }

	}
}