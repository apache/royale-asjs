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

package mx.controls.treeClasses
{

import mx.collections.CursorBookmark;
import mx.collections.ICollectionView;
import mx.collections.ISort;
import mx.collections.IViewCursor;
import mx.collections.XMLListAdapter;
import mx.collections.XMLListCollection;
import mx.core.EventPriority;
import mx.core.mx_internal;
import mx.events.CollectionEvent;
import mx.events.CollectionEventKind;
import mx.events.PropertyChangeEvent;
import mx.utils.IXMLNotifiable;
import mx.utils.XMLNotifier;

import org.apache.royale.events.CollectionEvent;
import org.apache.royale.events.EventDispatcher;
import org.apache.royale.collections.ITreeData;

use namespace mx_internal;

[ExcludeClass]

/**
 *  @private
 *  This class provides a hierarchical view of a standard collection.
 *  It is used by Tree to parse user data.
 */
public class HierarchicalCollectionView extends EventDispatcher
										implements ICollectionView, IXMLNotifiable, ITreeData
{
//    include "../../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function HierarchicalCollectionView(
							model:ICollectionView,
							treeDataDescriptor:ITreeDataDescriptor,
							itemToUID:Function,
							argOpenNodes:Object = null)
	{
		super();

		parentMap = {};

		childrenMap = new ChildrenMap();

		treeData = model;

        /*
		// listen for add/remove events from developer as weak reference
		treeData.addEventListener(CollectionEvent.COLLECTION_CHANGE,
								  collectionChangeHandler,
								  false,
								  EventPriority.DEFAULT_HANDLER,
								  true);
								  
		addEventListener(CollectionEvent.COLLECTION_CHANGE, 
								  expandEventHandler, 
								  false, 
								  0, 
								  true);
        */
        treeData.addEventListener(mx.events.CollectionEvent.COLLECTION_CHANGE,
            collectionChangeHandler);
        
        addEventListener(mx.events.CollectionEvent.COLLECTION_CHANGE, 
            expandEventHandler);
				
		dataDescriptor = treeDataDescriptor;
		this.itemToUID = itemToUID;
		openNodes = argOpenNodes;
		//calc initial length
		currentLength = calculateLength();
	}

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	private var dataDescriptor:ITreeDataDescriptor;

	/**
	 *  @private
	 */
	private var treeData:ICollectionView;

	/**
	 *  @private
	 */
	private var cursor:HierarchicalViewCursor;

	/**
	 *  @private
	 *  The total number of nodes we know about.
	 */
	private var currentLength:int;

	/**
	 *  @private
     * 
     *  @royalesuppresspublicvarwarning
	 */
	public var openNodes:Object; // change to get/set if folks set it from MXML

	/**
	 *  @private
	 *  Mapping of UID to parents.  Must be maintained as things get removed/added
	 *  This map is created as objects are visited
     * 
     *  @royalesuppresspublicvarwarning
	 */
	public var parentMap:Object; // change to get/set if folks set it from MXML

	/**
	 *  @private
	 *  Top level XML node if there is one
	 */
	private var parentNode:XML;

	/**
	 *  @private
	 *  Mapping of nodes to children.  Used by getChildren.
	 */
	private var childrenMap:ChildrenMap;
	
	/**
	 *  @private
	 */
	private var itemToUID:Function;

    //----------------------------------
	//  filter
    //----------------------------------

    /**
     *  Not Supported in Tree.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get filterFunction():Function
    {
        return null;
    }

    /**
     *  Not Supported in Tree.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function set filterFunction(value:Function):void
    {
        //No Impl.
    }

    //----------------------------------
	//  length
    //----------------------------------

    /**
     *  The length of the currently parsed collection.  This
     *  length only includes nodes that we know about.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	public function get length():int
	{
		return currentLength;
	}

    //----------------------------------
	//  sort
    //----------------------------------
    /**
    *  @private
     *  Not Supported in Tree.
     */
    public function get sort():ISort
	{
	    return null;
	}

    /**
     *  @private
     *  Not Supported in Tree.
     */
    public function set sort(value:ISort):void
	{
	    //No Impl
	}

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

	/**
	 *  Returns the parent of a node.  Top level node's parent is null
	 *  If we don't know the parent we return undefined.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
    public function getParentItem(node:Object):*
    {
		var uid:String = itemToUID(node);
		if (parentMap.hasOwnProperty(uid))
			return parentMap[uid];

		return undefined;
	}
	
	/**
	 *  @private
	 *  Calculate the total length of the collection, but only count nodes
	 *  that we can reach.
	 */
	public function calculateLength(node:Object = null, parent:Object = null):int
	{
		var length:int = 0;
		var childNodes:ICollectionView;
		var firstNode:Boolean = true;

		if (node == null)
		{
			var modelOffset:int = 0;
			// special case counting the whole thing
			// watch for page faults
			var modelCursor:IViewCursor = treeData.createCursor();
			if (modelCursor.beforeFirst)
			{
				// indicates that an IPE occurred on the first item
				return treeData.length;
			}
			while (!modelCursor.afterLast)
			{
				node = modelCursor.current;
				if (node is XML)
				{
					if (firstNode)
					{	
						firstNode = false;
						var parNode:* = node.parent();
						if (parNode)
						{
							startTrackUpdates(parNode);
							childrenMap.put(parNode, treeData);
							parentNode = parNode;
						}
					}
					startTrackUpdates(node);
				}
				
				if (node === null)
					length += 1;
				else
					length += calculateLength(node, null) + 1;
				
				modelOffset++;
                /*
				try
				{*/
					modelCursor.moveNext();
                /*
				}
				catch(e:ItemPendingError)
				{
					// just stop where we are, no sense paging
					// the whole thing just to get length. make a rough
					// guess assuming that all un-paged nodes are closed
					length += treeData.length - modelOffset;
					return length;
				}
                */
			}
		}
		else
		{
			var uid:String = itemToUID(node);
			parentMap[uid] = parent;
			if (node != null &&
				openNodes[uid] &&
				dataDescriptor.isBranch(node, treeData))
			{
				childNodes = getChildren(node);
				if (childNodes != null)
				{
					var numChildren:int = childNodes.length;
					for (var i:int = 0; i < numChildren; i++)
					{
						if (node is XML)
							startTrackUpdates(childNodes[i]);
						length += calculateLength(childNodes[i], node) + 1;
					}
				}
			}
		}
		return length;
	}

	/**
	 *  @private
	 *  This method is merely for ICollectionView interface compliance.
	 */
	public function describeData():Object
	{
		return null;
	}

    /**
	 *  Returns a new instance of a view iterator over the items in this view
	 *
     *  @see mx.utils.IViewCursor
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function createCursor():IViewCursor
	{
		return new HierarchicalViewCursor(
			this, treeData, dataDescriptor, itemToUID, openNodes);
	}

    /**
     *  Checks the collection for item using standard equality test.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function contains(item:Object):Boolean
	{
		var cursor:IViewCursor = createCursor();
		var done:Boolean = false;
		while (!done)
		{
			if (cursor.current == item)
				return true;
			done = cursor.moveNext();
		}
		return false;
	}

    /**
     *  @private
     */
	public function disableAutoUpdate():void
	{
	    //no-op
    }

    /**
     *  @private
     */
    public function enableAutoUpdate():void
    {
        //no-op
    }

	/**
	 *  @private
	 */
	public function itemUpdated(item:Object, property:Object = null,
                                oldValue:Object = null,
                                newValue:Object = null):void
    {
	    var event:mx.events.CollectionEvent =
			new mx.events.CollectionEvent(mx.events.CollectionEvent.COLLECTION_CHANGE);
	    event.kind = mx.events.CollectionEventKind.UPDATE;

		var objEvent:PropertyChangeEvent =
			new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
	    objEvent.property = property;
	    objEvent.oldValue = oldValue;
	    objEvent.newValue = newValue;
	    event.items.push(objEvent);

		dispatchEvent(event);
    }

	/**
	 *  @private
	 */
	public function refresh():Boolean
	{
	    var event:mx.events.CollectionEvent =
			new mx.events.CollectionEvent(mx.events.CollectionEvent.COLLECTION_CHANGE);
	    event.kind = mx.events.CollectionEventKind.REFRESH;
	    dispatchEvent(event);

		return true;
    }
    
    /**
	 * @private
	 * delegate getChildren in order to add event listeners for nested collections
	 */
	private function getChildren(node:Object):ICollectionView
	{
		var children:ICollectionView = dataDescriptor.getChildren(node, treeData);
		var oldChildren:ICollectionView = childrenMap.fetch(node) as ICollectionView;
		if (oldChildren != children)
		{
		    if (oldChildren != null)
		    {
				oldChildren.removeEventListener(mx.events.CollectionEvent.COLLECTION_CHANGE,
									  nestedCollectionChangeHandler);
			}
			if (children)
			{
                /*
    			children.addEventListener(CollectionEvent.COLLECTION_CHANGE,
    										  nestedCollectionChangeHandler, false, 0, true);*/
                children.addEventListener(mx.events.CollectionEvent.COLLECTION_CHANGE,
                    nestedCollectionChangeHandler);
				childrenMap.put(node, children);
			}
			else
				childrenMap.remove(node);
		}
		return children;
	}
    
    /**
	 * @private
	 * Force a recalulation of length	
	 */
	 private function updateLength(node:Object = null, parent:Object = null):void
	 {
	 	currentLength = calculateLength();
	 }

	/**
	 * @private
	 *  Fill the node array with the node and all of its visible children
	 *  update the parentMap as you go.
	 */
	private function getVisibleNodes(node:Object, parent:Object, nodeArray:Array):void
	{
		var childNodes:ICollectionView;
		nodeArray.push(node);

		var uid:String = itemToUID(node);
		parentMap[uid] = parent;
		if (openNodes[uid] &&
			dataDescriptor.isBranch(node, treeData) &&
			dataDescriptor.hasChildren(node, treeData))
		{
			childNodes = getChildren(node);
			if (childNodes != null)
			{
				var numChildren:int = childNodes.length;
				for (var i:int = 0; i < numChildren; i++)
				{
					getVisibleNodes(childNodes[i], node, nodeArray);
				}
			}
		}
	}

	/**
	 *  @private
	 *  Factor in the open children before this location in the model
	 */
	private function getVisibleLocation(oldLocation:int):int
	{
		var newLocation:int = 0;
		var modelCursor:IViewCursor = treeData.createCursor();
		for (var i:int = 0; i < oldLocation && !modelCursor.afterLast; i++)
		{
			newLocation += calculateLength(modelCursor.current, null) + 1;
			modelCursor.moveNext();
		}
		return newLocation;
	}

	/**
	 * @private
	 * factor in the open children before this location in a sub collection
	 */
	private function getVisibleLocationInSubCollection(parent:Object, oldLocation:int):int
	{
		var newLocation:int = oldLocation;
		var target:Object = parent;
		parent = getParentItem(parent);
		var children:ICollectionView;
		var cursor:IViewCursor;
		while (parent != null)
		{
			children = childrenMap.fetch(parent) as ICollectionView;
			cursor = children.createCursor();
			while (!cursor.afterLast)
			{
				if (cursor.current == target)
				{
					newLocation++;
					break;
				}
				newLocation += calculateLength(cursor.current, parent) + 1;
				cursor.moveNext();
			}
			target = parent;
			parent = getParentItem(parent);
		}
		cursor = treeData.createCursor();
		while (!cursor.afterLast)
		{
			if (cursor.current == target)
			{
				newLocation++;
				break;
			}
			newLocation += calculateLength(cursor.current, parent) + 1;
			cursor.moveNext();
		}
		return newLocation;
	}

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	public function collectionChangeHandler(event:mx.events.CollectionEvent):void
	{
		var i:int;
		var n:int;
		var location:int;
		var uid:String;
		var parent:Object;
		var node:Object;
		var items:Array;

		var convertedEvent:mx.events.CollectionEvent;
		
		if (event is mx.events.CollectionEvent)
        {
            var ce:mx.events.CollectionEvent = mx.events.CollectionEvent(event);
            if (ce.kind == CollectionEventKind.RESET)
            {
            	updateLength();
            	dispatchEvent(event);
            }
            else if (ce.kind == mx.events.CollectionEventKind.ADD)
            {
				n = ce.items.length;
				convertedEvent = new mx.events.CollectionEvent(
                    mx.events.CollectionEvent.COLLECTION_CHANGE,
										false, 
										true,
										ce.kind);
				convertedEvent.location = getVisibleLocation(ce.location);
				for (i = 0; i < n; i++)
				{
					node = ce.items[i];
					if (node is XML)
						startTrackUpdates(node);
					getVisibleNodes(node, null, convertedEvent.items);
				}
				currentLength += convertedEvent.items.length;
            	dispatchEvent(convertedEvent);
            }
            else if (ce.kind == mx.events.CollectionEventKind.REMOVE)
            {
				n = ce.items.length;
				convertedEvent = new mx.events.CollectionEvent(
                    mx.events.CollectionEvent.COLLECTION_CHANGE,
										false, 
										true,
										ce.kind);
				convertedEvent.location = getVisibleLocation(ce.location);
				for (i = 0; i < n; i++)
				{
					node = ce.items[i];
					if (node is XML)
						stopTrackUpdates(node);
					getVisibleNodes(node, null, convertedEvent.items);
				}
				currentLength -= convertedEvent.items.length;
            	dispatchEvent(convertedEvent);
            }
            else if (ce.kind == mx.events.CollectionEventKind.UPDATE)
            {
				// so far, nobody cares about the details so just
				// send it
				//updateLength();
            	dispatchEvent(event);
            }
            else if (ce.kind == mx.events.CollectionEventKind.REPLACE)
            {
            	// someday handle case where node is marked as open
				// before it becomes the replacement.
				// for now, just pass on the data and remove
				// old visible rows
				n = ce.items.length;
				convertedEvent = new mx.events.CollectionEvent(
                    mx.events.CollectionEvent.COLLECTION_CHANGE,
										false, 
										true,
                                        mx.events.CollectionEventKind.REMOVE);

				for (i = 0; i < n; i++)
				{
					node = ce.items[i].oldValue;
					if (node is XML)
						stopTrackUpdates(node);
					getVisibleNodes(node, null, convertedEvent.items);
				}

				// prune the replacements from this list
				var j:int = 0;
				for (i = 0; i < n; i++)
				{
					node = ce.items[i].oldValue;
					while (convertedEvent.items[j] != node)
						j++;
					convertedEvent.items.splice(j, 1);
				}
				if (convertedEvent.items.length)
				{
					currentLength -= convertedEvent.items.length;
					// nobody cares about location yet.
            		dispatchEvent(convertedEvent);
				}
            	dispatchEvent(event);
            }
        }
	}

	/**
	 *  @private
	 */
	public function nestedCollectionChangeHandler(event:mx.events.CollectionEvent):void
	{
		var i:int;
		var n:int;
		var location:int;
		var uid:String;
		var parent:Object;
		var node:Object;
		var items:Array;
		var convertedEvent:mx.events.CollectionEvent;

		if (event is mx.events.CollectionEvent)
        {
            var ce:mx.events.CollectionEvent = mx.events.CollectionEvent(event);
            if (ce.kind == mx.events.CollectionEventKind.EXPAND)
            {
            	event.stopImmediatePropagation();
            }
            else if (ce.kind == mx.events.CollectionEventKind.ADD)
            {
				// optimize someday.  We do a full tree walk so we can
				// not only count how many but find the parents of the
				// new nodes.  A better scheme would be to just
				// increment by the number of visible nodes, but we
				// don't have a good way to get the parents.
            	updateLength();
				n = ce.items.length;
				convertedEvent = new mx.events.CollectionEvent(
                    mx.events.CollectionEvent.COLLECTION_CHANGE,
										false, 
										true,
										ce.kind);
				for (i = 0; i < n; i++)
				{
					node = ce.items[i];
					if (node is XML)
						startTrackUpdates(node);
					parent = getParentItem(node);
					if (parent != null)
						getVisibleNodes(node, parent, convertedEvent.items);
				}
				convertedEvent.location = getVisibleLocationInSubCollection(parent, ce.location);
            	dispatchEvent(convertedEvent);
            }
            else if (ce.kind == mx.events.CollectionEventKind.REMOVE)
            {
				n = ce.items.length;
				convertedEvent = new mx.events.CollectionEvent(
                    mx.events.CollectionEvent.COLLECTION_CHANGE,
										false, 
										true,
										ce.kind);
				for (i = 0; i < n; i++)
				{
					node = ce.items[i];
					if (node is XML)
						stopTrackUpdates(node);
					parent = getParentItem(node);
					if (parent != null)
						getVisibleNodes(node, parent, convertedEvent.items);
				}
				convertedEvent.location = getVisibleLocationInSubCollection(parent, ce.location);
				currentLength -= convertedEvent.items.length;
            	dispatchEvent(convertedEvent);
            }
            else if (ce.kind == mx.events.CollectionEventKind.UPDATE)
            {
				// so far, nobody cares about the details so just
				// send it
            	dispatchEvent(event);
            }
	        else if (ce.kind == mx.events.CollectionEventKind.REPLACE)
            {
            	// someday handle case where node is marked as open
				// before it becomes the replacement.
				// for now, just pass on the data and remove
				// old visible rows
				n = ce.items.length;
				convertedEvent = new mx.events.CollectionEvent(
                    mx.events.CollectionEvent.COLLECTION_CHANGE,
										false, 
										true,
                                        mx.events.CollectionEventKind.REMOVE);

				for (i = 0; i < n; i++)
				{
					node = ce.items[i].oldValue;
					parent = getParentItem(node);
					if (parent != null)
						getVisibleNodes(node, parent, convertedEvent.items);
				}

				// prune the replacements from this list
				var j:int = 0;
				for (i = 0; i < n; i++)
				{
					node = ce.items[i].oldValue;
					if (node is XML)
						stopTrackUpdates(node);
					while (convertedEvent.items[j] != node)
						j++;
					convertedEvent.items.splice(j, 1);
				}
				if (convertedEvent.items.length)
				{
					currentLength -= convertedEvent.items.length;
					// nobody cares about location yet.
            		dispatchEvent(convertedEvent);
				}
            	dispatchEvent(event);
            }
			else if (ce.kind == mx.events.CollectionEventKind.RESET)
			{
				// removeAll() sends a RESET.
				// when we get a reset we don't know what went away
				// and we don't know how many things went away, so
				// we just fake a refresh as if there was a filter
				// applied that filtered out whatever went away
            	updateLength();
				convertedEvent = new mx.events.CollectionEvent(
                    mx.events.CollectionEvent.COLLECTION_CHANGE,
										false, 
										true,
                                        mx.events.CollectionEventKind.REFRESH);
           		dispatchEvent(convertedEvent);
			}
        }
	}

    /**
     * Called whenever an XML object contained in our list is updated
     * in some way.  The initial implementation stab is very lenient,
     * any changeType will cause an update no matter how much further down
     * in a hierarchy.  
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function xmlNotification(currentTarget:Object, 
                                        type:String, 
                                        target:Object, 
                                        value:Object, 
                                        detail:Object):void
    {
        var prop:String;
        var oldValue:Object;
        var newValue:Object;
		var children:XMLListCollection;
		var location:int;
        var event:mx.events.CollectionEvent;
		var list:XMLListAdapter;
        
		// trace("currentTarget", currentTarget.toXMLString());
		// trace("target", target.toXMLString());
		// trace("value", value.toXMLString());
		// trace("type", type);

		if (currentTarget === target)
        {
			
	        switch(type)
	        {
	            case "nodeAdded":
	            {
                    var q:*;
                    
                    /*  Flash needs this because XML instances would not always
                        lookup correctly in a Dictionary.*/
                    COMPILE::SWF
                    {
    	            	for each (q in childrenMap.keys)
    					{
    						if (q === currentTarget)
    						{
    							list = childrenMap.fetch(q).list as XMLListAdapter;
    							break;
    						}
    					}
                    }
                    COMPILE::JS
                    {
                        q = currentTarget;
                        list = childrenMap.fetch(q).list as XMLListAdapter;                        
                    }
	            	if (!list && target is XML && XML(target).children().length() == 1)
	            	{
	            		// this is a special case (SDK-13807), when you add your first xml node
	            		// we need to add the listener, and getChildren() does it for us.
	            		list = (getChildren(target) as XMLListCollection).list as XMLListAdapter;
	            	}
	            	
					if (list && !list.busy())
					{
						if (childrenMap.fetch(q) === treeData)
						{
							children = treeData as XMLListCollection;
							if (parentNode)
							{
								children.dispatchResetEvent = false;
								children.source = parentNode.*;
							}
						}
						else
						{
							// this should refresh the collection
							children = getChildren(q) as XMLListCollection;
						}
						if (children)
						{
							// now we fake an event on behalf of the
							// child collection
							location = value.childIndex();
							event = new mx.events.CollectionEvent(mx.events.CollectionEvent.COLLECTION_CHANGE);
							event.kind = mx.events.CollectionEventKind.ADD;
							event.location = location;
							event.items = [ value ];
							children.dispatchEvent(event);
						}
					}

	                break;
	            }

				/* needed?
	            case "nodeChanged":
	            {
	                prop = value.localName();
	                oldValue = detail;
	                newValue = value;
	                break;
	            }
				*  
				*  @langversion 3.0
				*  @playerversion Flash 9
				*  @playerversion AIR 1.1
				*  @productversion Flex 3
				*/

	            case "nodeRemoved":
	            {
                    var p:*;
                    
                    children = null;
					// lookup doesn't work, must scan instead
                    COMPILE::SWF
                    {
					for (p in childrenMap.keys)
					{
						if (p === currentTarget)
						{
							children = childrenMap.fetch(p) as XMLListCollection;
                            break;
                        }
                    }
                    }
                    COMPILE::JS
                    {
                        p = currentTarget;
                        children = childrenMap.fetch(p) as XMLListCollection;
                    }
                    if (children != null)
                    {
						list = children.list as XMLListAdapter;
						if (list && !list.busy())
						{
							var xmllist:XMLList = children.source as XMLList;

							if (childrenMap.fetch(p) === treeData)
							{
								children = treeData as XMLListCollection;
								if (parentNode)
								{
									children.dispatchResetEvent = false;
									children.source = parentNode.*;
								}
							}
							else
							{
								var oldChildren:XMLListCollection = children;
								// this should refresh the collection
								children = getChildren(p) as XMLListCollection;
								if (!children)
								{
									// last item got removed so there's no child collection
									oldChildren.addEventListener(mx.events.CollectionEvent.COLLECTION_CHANGE,
																  nestedCollectionChangeHandler);
                                    //oldChildren.addEventListener(CollectionEvent.COLLECTION_CHANGE,
                                    //    nestedCollectionChangeHandler, false, 0, true);

									event = new mx.events.CollectionEvent(mx.events.CollectionEvent.COLLECTION_CHANGE);
									event.kind = mx.events.CollectionEventKind.REMOVE;
									event.location = 0;
									event.items = [ value ];
									oldChildren.dispatchEvent(event);
									oldChildren.removeEventListener(mx.events.CollectionEvent.COLLECTION_CHANGE,
																  nestedCollectionChangeHandler);

								}
							}
							if (children)
							{
								var n:int = xmllist.length();
								for (var i:int = 0; i < n; i++)
								{
									if (xmllist[i] === value)
									{
										event = new mx.events.CollectionEvent(mx.events.CollectionEvent.COLLECTION_CHANGE);
										event.kind = mx.events.CollectionEventKind.REMOVE;
										event.location = location;
										event.items = [ value ];
										children.dispatchEvent(event);
										break;
									}
								}
							}
						}
					}
	                break;
	            }

	            default:
				{
	                break;
				}
	        }
        }
    }

    /** 
     *  This is called by addItemAt and when the source is initially
     *  assigned.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private function startTrackUpdates(item:Object):void
    {
        XMLNotifier.getInstance().watchXML(item, this);
    }
    
    /** 
     *  This is called by removeItemAt, removeAll, and before a new
     *  source is assigned.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private function stopTrackUpdates(item:Object):void
    {
        XMLNotifier.getInstance().unwatchXML(item, this);
    }

	/**
	 *  @private
	 */
	public function expandEventHandler(event:mx.events.CollectionEvent):void
	{
		if (event is mx.events.CollectionEvent)
        {
            var ce:mx.events.CollectionEvent = mx.events.CollectionEvent(event);
            if (ce.kind == mx.events.CollectionEventKind.EXPAND)
            {
            	event.stopImmediatePropagation();
            	updateLength();  
            }
        }
	}
    
    private var iterator:IViewCursor;
    
    public function getDepth(node:Object):int
    {
        if (!iterator)
            iterator = createCursor();
        
        if (iterator.current == node)
            return getCurrentCursorDepth();
        
        var offset:int = getItemIndex(node);
        //otherwise seek to offset and get the depth
        var bookmark:CursorBookmark = iterator.bookmark;
        iterator.seek(CursorBookmark.FIRST, offset);
        var depth:int = getCurrentCursorDepth();
        //put the cursor back
        iterator.seek(bookmark, 0);
        return depth;
    }
    
    /**
     *  @private
     */
    public function getItemIndex(item:Object):int
    {
        if (!iterator)
            iterator = createCursor();
        
        iterator.seek(CursorBookmark.FIRST, 0);
        
        var i:int = 0;
        do
        {
            if (iterator.current === item)
                break;
            i++;
        }
        while (iterator.moveNext());
        return i;
    }

    /**
     *  @private
     *  Utility method to get the depth of the current item from the cursor.
     */
    private function getCurrentCursorDepth():int  //private
    {
        if (dataDescriptor is ITreeDataDescriptor2)
            return ITreeDataDescriptor2(dataDescriptor).getNodeDepth(iterator.current, iterator, treeData);
        
        return HierarchicalViewCursor(iterator).currentDepth;
    }

    public function isOpen(node:Object):Boolean
    {
        var uid:String = itemToUID(node);
        return (openNodes[uid] != null);
    }
    
    public function hasChildren(node:Object):Boolean
    {
        return dataDescriptor.hasChildren(node, treeData)
    }

    public function openNode(node:Object):void
    {
        var uid:String = itemToUID(node);
        openNodes[uid] = 1;
        var index:int = getItemIndex(node);
        dispatchAddEvents(node, index + 1, org.apache.royale.events.CollectionEvent.ITEM_ADDED);
		var collectionEvent:org.apache.royale.events.CollectionEvent;
        collectionEvent = new org.apache.royale.events.CollectionEvent(org.apache.royale.events.CollectionEvent.ITEM_UPDATED);
        collectionEvent.item = node;
        collectionEvent.index = index;
		dispatchEvent(collectionEvent);
    }
    
    private function dispatchAddEvents(node:Object, index:int, type:String):int
    {
        var children:ICollectionView = getChildren(node);
        var cursor:IViewCursor = children.createCursor();
		var item:Object;
		var collectionEvent:org.apache.royale.events.CollectionEvent;
        do
        {
            item = cursor.current;
            collectionEvent = new org.apache.royale.events.CollectionEvent(type);
            collectionEvent.item = item;
            collectionEvent.index = index;
            dispatchEvent(collectionEvent);
            currentLength++;
			index++;
            if (isOpen(item))
            {
                index = dispatchAddEvents(item, index, type);
            }
   
        } while (cursor.moveNext());
        return index;
    }
    
    public function closeNode(node:Object):void
    {
        var uid:String = itemToUID(node);
        delete openNodes[uid];        
        var index:int = getItemIndex(node);
        dispatchRemoveEvents(node, index + 1, org.apache.royale.events.CollectionEvent.ITEM_REMOVED);
		var collectionEvent:org.apache.royale.events.CollectionEvent;
        collectionEvent = new org.apache.royale.events.CollectionEvent(org.apache.royale.events.CollectionEvent.ITEM_UPDATED);
        collectionEvent.item = node;
        collectionEvent.index = index;
		dispatchEvent(collectionEvent);
    }

    private function dispatchRemoveEvents(node:Object, index:int, type:String, eventQueue:Array = null):int
    {
        var children:ICollectionView = getChildren(node);
        var cursor:IViewCursor = children.createCursor();
		var item:Object;
		var collectionEvent:org.apache.royale.events.CollectionEvent;
		var topLevel:Boolean = (eventQueue == null);
		if (!eventQueue) 
			eventQueue = [];
        do
        {
            item = cursor.current;
            collectionEvent = new org.apache.royale.events.CollectionEvent(type);
            collectionEvent.item = item;
            collectionEvent.index = index;
            eventQueue.push(collectionEvent);
			index++;
            if (isOpen(item))
            {
                index = dispatchRemoveEvents(item, index, type, eventQueue);
            }
   
        } while (cursor.moveNext());

		if (topLevel)
		{
			// dispatch events in reverse order
			while (eventQueue.length)
			{
				collectionEvent = eventQueue.pop() as org.apache.royale.events.CollectionEvent;
				dispatchEvent(collectionEvent);
                currentLength--;
			}
		}

        return index;
    }
    
}

}

COMPILE::SWF
{
    import flash.utils.Dictionary;
}

class ChildrenMap
{
    COMPILE::SWF
    private var cache:Dictionary = new Dictionary(true);
    
    // use Object.defineProperty some day to block iteration of this property?
    private var propName:String = "__ChildrenMap__";
    
    public function fetch(obj:Object):Object
    {
        COMPILE::SWF
        {
            return cache[obj];
        }
        COMPILE::JS
        {
            return obj[propName];
        }
    }
    
    public function put(obj:Object, value:Object):void
    {
        COMPILE::SWF
        {
            cache[obj] = value;
        }
        COMPILE::JS
        {
            obj[propName] = value;
        }
    }
    
    public function remove(obj:Object):void
    {
        COMPILE::SWF
        {
            delete cache[obj];
        }
        COMPILE::JS
        {
            delete obj[propName];
        }
    }
    
    public function get keys():Array
    {
        var output:Array = [];
        COMPILE::SWF
        {
            for (var p:* in cache.keys)
            {
                output.push(p);
            }
        }
        // for JS, assume we won't ever need to produce the keys since
        // the runtime shouldn't be messing with XML node instances
        return output;
    }
}
    