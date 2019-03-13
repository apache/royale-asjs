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

import org.apache.royale.events.EventDispatcher;
//import flash.utils.Dictionary;
//import flash.xml.XMLNode;

//import mx.collections.errors.ItemPendingError;
//import mx.core.EventPriority;
import mx.core.mx_internal;
import mx.events.CollectionEvent;
import mx.events.CollectionEventKind;
import mx.events.PropertyChangeEvent;
import mx.utils.IXMLNotifiable;
import mx.utils.UIDUtil;
import mx.utils.XMLNotifier;

use namespace mx_internal;

/**
 *  The HierarchicalCollectionView class provides a hierarchical view of a standard collection.
 *
 *  @mxml
 *
 *  The <code>&lt;mx.HierarchicalCollectionView&gt;</code> inherits all the tag attributes of its superclass, 
 *  and defines the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;mx:HierarchicalCollectionView
 *  <b>Properties </b>
 *    showRoot="true|false"
 *    source="<i>No default</i>"
 *  /&gt;
 *  </pre> 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class HierarchicalCollectionView extends EventDispatcher
                                        implements IHierarchicalCollectionView, IXMLNotifiable
{
//    include "../core/Version.as";
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  @param hierarchicalData The data structure containing the hierarchical data.
     *
     *  @param argOpenNodes The Object that defines a node to appear as open.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function HierarchicalCollectionView(
                            hierarchicalData:IHierarchicalData = null,
                            argOpenNodes:Object = null)
    {
        super();
        
        if (hierarchicalData)
            initializeCollection(hierarchicalData.getRoot(), hierarchicalData, argOpenNodes);
    }
    
    //--------------------------------------------------------------------------
    //
    // Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    private var hierarchicalData:IHierarchicalData;

    /**
     *  @private
     *  The total number of nodes we know about.
     */
    private var currentLength:int;
    
    /**
     *  @private
     *  Top level XML node if there is one
     */
    private var parentNode:XML;

    /**
     *  @private
     *  Mapping of nodes to children.  Used by getChildren.
     */
    private var childrenMap:Object; //Dictionary;
    
    /**
     *  @private
     */
    private var childrenMapCache:Object = {}; // Dictionary = new Dictionary(true);
    
    /**
     *  @private
     */
    mx_internal var treeData:ICollectionView;
    
    /**
     *  @private
     *  Mapping of UID to parents.  Must be maintained as things get removed/added
     *  This map is created as objects are visited
     */
    private var parentMap:Object;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  hasRoot
    //----------------------------------
    
    private var _hasRoot:Boolean;
    
    /** 
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get hasRoot():Boolean
    {
        return _hasRoot;
    }
    
    //----------------------------------
    //  openNodes
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the openNodes property.
     */
    private var _openNodes:Object;
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get openNodes():Object
    {
        return _openNodes;  
    }
    
    /**
     *  @private
     */
    public function set openNodes(value:Object):void
    {
        // openNodes cant be null
        if (value)
        {
            _openNodes = {};
            for each (var item:* in value)
            {
                _openNodes[UIDUtil.getUID(item)] = item;
            }
        }
        else
            _openNodes = {};
        
        if (hierarchicalData)
        {
            //calc initial length
            currentLength = calculateLength();
            
            // need to refresh the collection after setting openNodes
            var event:CollectionEvent =
                new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            event.kind = CollectionEventKind.REFRESH;
            dispatchEvent(event);
        }
    }
    
    //----------------------------------
    //  showRoot
    //----------------------------------
    
    private var _showRoot:Boolean = true;
    
    [Bindable]
    [Inspectable(category="Data", enumeration="true,false", defaultValue="true")]
    
    /**
     *  @inheritDoc
     *
     *  @default true
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get showRoot():Boolean
    {
        return _showRoot;
    }

    /**
     *  @private
     */
    public function set showRoot(value:Boolean):void
    {
        if (_showRoot != value)
        {
            _showRoot = value;
            if (hierarchicalData)
            {
                initializeCollection(hierarchicalData.getRoot(), hierarchicalData, openNodes);
                
                //setting showRoot resets the collection
                var event:CollectionEvent =
                    new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
                event.kind = CollectionEventKind.RESET;
                dispatchEvent(event);
            }
        }
    }
    
    //----------------------------------
    //  source
    //----------------------------------
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get source():IHierarchicalData
    {
        return hierarchicalData;
    }

    /**
     *  @private
     */
    public function set source(value:IHierarchicalData):void
    {
        initializeCollection(value.getRoot(), value, openNodes);
    }
    
    //----------------------------------
    //  filter
    //----------------------------------

    /**
     *  @private
     *  Storage for the filterFunction property.
     */
    private var _filterFunction:Function;

    [Bindable("filterFunctionChanged")]
    [Inspectable(category="General")]
    
    /**
     *  @private
     */
    public function get filterFunction():Function
    {
        return _filterFunction;
    }

    /**
     *  @private
     */
    public function set filterFunction(value:Function):void
    {
        _filterFunction = value;
    }

    //----------------------------------
    //  length
    //----------------------------------

    /**
     *  The length of the currently parsed collection (i.e. the number
     *  of nodes that can be accessed by navigating the collection via
     *  HierarchicalCollectionViewCursor)
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
     *  Storage for the sort property.
     */
    private var _sort:ISort;

    [Bindable("sortChanged")]
    [Inspectable(category="General")]
    
    /**
     *  @private
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
        _sort = value;
    }
    
    //--------------------------------------------------------------------------
    //
    // ICollectionView Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Returns a new instance of a view iterator over the items in this view.
     *
     *  @return IViewCursor instance.
     *
     *  @see mx.collections.IViewCursor
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function createCursor():IViewCursor
    {
        return new HierarchicalCollectionViewCursor(
            this, treeData, hierarchicalData);
    }

    /**
     *  Checks the collection for the data item using standard equality test.
     *
     *  @param item The Object that defines the node to look for.
     *
     *  @return <code>true</code> if the data item is in the collection,
     *  and <code>false</code> if not.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function contains(item:Object):Boolean
    {
        var cursor:IViewCursor = createCursor();
        while (!cursor.afterLast)
        {
            if (cursor.current == item)
                return true;
                
            //try
            //{
                cursor.moveNext();
                /*
            }
            catch (e:ItemPendingError)
            {
                // item is pending.
                // we are not sure if the item is present or not, 
                // so return false
                return false;
            }
                */
        }
        return false;
    }

    /**
     *  @private
     */
    public function disableAutoUpdate():void
    {
        // propogate to all the child collections
        treeData.disableAutoUpdate();
        for (var p:Object in childrenMap)
            ICollectionView(childrenMap[p]).disableAutoUpdate();
    }

    /**
     *  @private
     */
    public function enableAutoUpdate():void
    {
        // propogate to all the child collections
        treeData.enableAutoUpdate();
        for (var p:Object in childrenMap)
            ICollectionView(childrenMap[p]).enableAutoUpdate();
    }

    /**
     *  @private
     */
    public function itemUpdated(item:Object, property:Object = null,
                                oldValue:Object = null,
                                newValue:Object = null):void
    {
        var event:CollectionEvent =
            new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
        event.kind = CollectionEventKind.UPDATE;

        var objEvent:PropertyChangeEvent =
            new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
        objEvent.source = item;
        objEvent.property = property;
        objEvent.oldValue = oldValue;
        objEvent.newValue = newValue;
        event.items.push(objEvent);

        dispatchEvent(event);
    }
    
    /**
     *  @inheritDoc 
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
    // IHierarchicalCollectionView Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */ 
    public function getNodeDepth(node:Object):int
    {
        var depth:int = 1;
        var parent:Object = getParentItem(node);
        
        while(parent != null)
        {
            parent = getParentItem(parent);
            depth++;
        }
        depth = (hasRoot && !showRoot) ? (depth - 1) : depth;
        
        // depth cant be less then 1
        return (depth < 1) ? 1 : depth;
    }
    
    /**
     *  Returns the parent of a node.  
     *  The parent of a top-level node is <code>null</code>.
     *
     *  @param node The Object that defines the node.
     *
     *  @return The parent node containing the node, 
     *  <code>null</code> for a top-level node,  
     *  and <code>undefined</code> if the parent cannot be determined.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getParentItem(node:Object):*
    {
        var uid:String = UIDUtil.getUID(node);
        if (parentMap.hasOwnProperty(uid))
            return parentMap[uid];

        return undefined;
    }

    public function deleteParentMapping(uid:String):void
    {
        delete parentMap[uid];
    }

    public function addParentMapping(uid:String, parent:Object, replaceExisting:Boolean = true):void
    {
        if(replaceExisting || !parentMap.hasOwnProperty(uid))
            parentMap[uid] = parent;
    }
    
    /**
     *  @inheritDoc 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getChildren(node:Object):ICollectionView
    {
        // Using uid because XML cant be referenced correctly using Dictionary
        var uid:String = UIDUtil.getUID(node);
        var children:* = hierarchicalData.getChildren(node);
        
        var childrenCollection:ICollectionView = childrenMapCache[uid];
        
        if (children is XMLList && childrenCollection)
        {       
            //We don't want to send a RESET type of collectionChange event in this case. 
            XMLListCollection(childrenCollection).mx_internal::dispatchResetEvent = false; 
            XMLListCollection(childrenCollection).source = children;
            
            // refresh the collection to apply the sort/filter
            childrenCollection.refresh();
        }
        
        // check the cache and return from it.
        // useful in sorting/filtering.
        if(childrenCollection)
        {
            // node might have changed, so update the childrenMap
            childrenMap[UIDUtil.getUID(node)] = childrenCollection;
            return childrenCollection;
        }
        
        // if there is no children, return null
        if (!children)
            return null;
        
        //then wrap children in ICollectionView if necessary
        if (children is ICollectionView)
        {
            childrenCollection = ICollectionView(children);
        }
        else if (children is Array)
        {
            childrenCollection = new ArrayCollection(children);
        }
        else if (children is XMLList)
        {
            childrenCollection =  new XMLListCollection(children);
        }
        else
        {
            var childArray:Array = new Array(children);
            if (childArray != null)
            {
                childrenCollection =  new ArrayCollection(childArray);
            }
        }
        
        childrenMapCache[uid] = childrenCollection;
        
        
        var oldChildren:ICollectionView = childrenMap[UIDUtil.getUID(node)];
        if (oldChildren != childrenCollection)
        {
            if (oldChildren != null)
            {
                oldChildren.removeEventListener(CollectionEvent.COLLECTION_CHANGE,
                                      nestedCollectionChangeHandler);
            }
            childrenCollection.addEventListener(CollectionEvent.COLLECTION_CHANGE,
                                          nestedCollectionChangeHandler, false/*, 0, true*/);
            childrenMap[UIDUtil.getUID(node)] = childrenCollection;
        }
        
        return childrenCollection;
    }
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function openNode(node:Object):void
    {
        var uid:String = UIDUtil.getUID(node);
        
        // check if the node is already opened
        if (_openNodes[uid] != null)
            return;

        // check if the node is accessible, abort if not
        var parent:* = getParentItem(node);
        while(parent)
        {
            parent = getParentItem(parent);
        }

        //undefined means an ancestor is not open, which means the node is inaccessible
        if(parent === undefined)
            return;

        // add the node to the openNodes object and update the length
        _openNodes[uid] = node;
        
        // apply the sort/filter to the child collection of the opened node.
        var childrenCollection:ICollectionView = getChildren(node);
        
        // return if there are no children
        if (!childrenCollection)
            return;
        
        if (sortCanBeApplied(childrenCollection) && !(childrenCollection.sort == null && sort == null))
        {
            childrenCollection.sort = this.sort;
        }
        if (!(childrenCollection.filterFunction == null && filterFunction == null))
        {
            childrenCollection.filterFunction = this.filterFunction;
        }
        childrenCollection.refresh();

        updateParentMapAndLength(childrenCollection, node);
    }
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function closeNode(node:Object):void
    {
        var childrenCollection:ICollectionView = childrenMap[UIDUtil.getUID(node)];

        // removes the node from the openNodes object and update the length
        delete _openNodes[UIDUtil.getUID(node)];

        if (childrenCollection)
        {
            var cursor:IViewCursor = childrenCollection.createCursor();
            while (!cursor.afterLast)
            {
                var uid:String = UIDUtil.getUID(cursor.current);
                deleteParentMapping(uid);

                //try
                //{
                    cursor.moveNext();
                //}
                    /*
                catch (e:ItemPendingError)
                {
                    break;
                }
                    */
        
            }
        }
        
        // update the length
        updateLength();
    }
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function addChild(parent:Object, newChild:Object):Boolean
    {
        if (parent == null)
            return addChildAt(parent, newChild, treeData.length);
        else
            return addChildAt(parent, newChild, getChildren(parent).length);
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function removeChild(parent:Object, child:Object):Boolean
    {
        var cursor:IViewCursor;
        if (parent == null)
        {
            cursor = treeData.createCursor();
        }
        else
        {
             var children:ICollectionView = getChildren(parent);
             cursor = children.createCursor();
        }
        while (!cursor.afterLast)
        {
            if (cursor.current == child)
            {
                cursor.remove();
                return true;
            }
                
            //try
            //{
                cursor.moveNext();
                /*
            }
            catch (e:ItemPendingError)
            {
                // Items are pending - so return false
                return false;
            }*/
        }
        
        return false;
    }
    
    /**
     *  Add a child node to a node at the specified index. 
     *  This implementation does the following:
     * 
     *  <ul>
     *      <li>If the <code>parent</code> is null or undefined,
     *          inserts the <code>child</code> at the 
     *          specified <code>index</code> in the collection specified 
     *          by <code>source</code>.
     *      </li>
     *      <li>If the <code>parent</code> has a <code>children</code>
     *          field or property, the method adds the <code>child</code> 
     *          to it at the <code>index</code> location.
     *          In this case, the <code>source</code> is not required.
     *     </li>
     *     <li>If the <code>parent</code> does not have a <code>children</code>
     *          field or property, the method adds the <code>children</code> 
     *          to the <code>parent</code>. The method then adds the 
     *          <code>child</code> to the parent at the 
     *          <code>index</code> location. 
     *          In this case, the <code>source</code> is not required.
     *     </li>
     *     <li>If the <code>index</code> value is greater than the collection 
     *         length or number of children in the parent, adds the object as
     *         the last child.
     *     </li>
     * </ul>
     *
     *  @param parent The Object that defines the parent node.
     * 
     *  @param newChild The Object that defines the child node.
     * 
     *  @param index The 0-based index of where to insert the child node.
     *
     *  @return <code>true</code> if the child is added successfully.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function addChildAt(parent:Object, newChild:Object, index:int):Boolean
    {   
        var cursor:IViewCursor;
        if (!parent)
        {
            cursor = treeData.createCursor();
        }
        else
        {
            if (!hierarchicalData.canHaveChildren(parent))
                return false;
            
            var children:ICollectionView = getChildren(parent);
            
            cursor = children.createCursor();
        }
        
        //try
        //{
            cursor.seek(CursorBookmark.FIRST, index);
            /*
        }
        catch (e:ItemPendingError)
        {
            // Item Pending
            return false;
        }*/
        
        cursor.insert(newChild);
        
        return true;
    }

    /**
     *  Removes the child node from a node at the specified index.
     *
     *  @param parent The Object that defines the parent node.
     * 
     *  @param index The 0-based index of  the child node to remove relative to the parent.
     * 
     *  @return <code>true</code> if the child is removed successfully.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function removeChildAt(parent:Object, index:int):Boolean
    {
        var cursor:IViewCursor;
        if (!parent)
        {
            cursor = treeData.createCursor();
        }
        else
        {
            var children:ICollectionView = getChildren(parent);
            cursor = children.createCursor();
        }
        
        //try
        //{
            cursor.seek(CursorBookmark.FIRST, index);
            /*
        }
        catch (e:ItemPendingError)
        {
            // Item Pending
            return false;
        }*/
        
        if (cursor.beforeFirst || cursor.afterLast)
            return false;
        
        cursor.remove();
        return true;
    }
    
    //--------------------------------------------------------------------------
    //
    // Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     * 
     * returns the collection view of the given object
     */ 
    private function getCollection(value:Object):ICollectionView
    {
        // handle strings and xml
        if (typeof(value)=="string")
            value = new XML(value);
        /*
        else if (value is XMLNode)
            value = new XML(XMLNode(value).toString());
        */
        else if (value is XMLList)
            value = new XMLListCollection(value as XMLList);
        
        if (value is XML)
        {
            var xl:XMLList = new XMLList();
            xl += value;
            return new XMLListCollection(xl);
        }
        //if already a collection dont make new one
        else if (value is ICollectionView)
        {
            return ICollectionView(value);
        }
        else if (value is Array)
        {
            return new ArrayCollection(value as Array);
        }
        //all other types get wrapped in an ArrayCollection
        else if (value is Object)
        {         
            // convert to an array containing this one item
            var tmp:Array = [];
            tmp.push(value);
            return new ArrayCollection(tmp);
        }
        else
        {
            return new ArrayCollection();
        }
    }
    
    /**
     *  @private
     *  
     *  Initialize the collection. set its various properties and
     *  update its length.
     */
    private function initializeCollection(model:Object,
                            hierarchicalData:IHierarchicalData,
                            argOpenNodes:Object = null):void
    {
        parentMap = {};

        childrenMap = {}; // new Dictionary(true);
        childrenMapCache = {}; // new Dictionary(true);
        
        if (treeData)
            treeData.removeEventListener(CollectionEvent.COLLECTION_CHANGE,
                                         collectionChangeHandler,
                                         false);
        
        if (this.hierarchicalData)
            this.hierarchicalData.removeEventListener(CollectionEvent.COLLECTION_CHANGE,
                                         collectionChangeHandler,
                                         false);
        
        treeData = getCollection(model);
        
        if (treeData)
            _hasRoot = treeData.length == 1;
        
        var tmpCollection:Object = model;
        // are we swallowing the root?
        if (hierarchicalData && !showRoot && hasRoot)
        {
            var obj:Object = treeData.createCursor().current;
            if (hierarchicalData.hasChildren(obj))
            {
                // then get rootItem children
                tmpCollection = hierarchicalData.getChildren(obj);
                treeData = getCollection(tmpCollection);
            }
        }

        // listen for add/remove events from developer as weak reference
        treeData.addEventListener(CollectionEvent.COLLECTION_CHANGE,
                                  collectionChangeHandler,
                                  false/*,
                                  EventPriority.DEFAULT_HANDLER,
                                  true*/);
                                  
        this.hierarchicalData = hierarchicalData;
        
        // listen for reset/refresh events
        this.hierarchicalData.addEventListener(
                                    CollectionEvent.COLLECTION_CHANGE,
                                    collectionChangeHandler,
                                    false/*,
                                    EventPriority.DEFAULT_HANDLER,
                                    true*/);
        
        // openNodes cant be null
        if (argOpenNodes)
            _openNodes = argOpenNodes;
        else
            _openNodes = {};
        
        //calc initial length
        currentLength = calculateLength();
    }
    
    /**
     *  @private
     *  
     *  Update the parent map and adjust the length.
     */ 
    private function updateParentMapAndLength(collection:ICollectionView, node:Object):void
    {
        var cursor:IViewCursor = collection.createCursor();
        currentLength += collection.length;
        
        while (!cursor.afterLast)
        {
            var item:Object = cursor.current;
            var uid:String = UIDUtil.getUID(item);
            addParentMapping(uid, node);
            
            // check that the node is opened or not.
            // If it is open, then update the length with the node's children.
            if (_openNodes[uid] != null)
            {
                var childrenCollection:ICollectionView = getChildren(item);
                if (childrenCollection)
                    updateParentMapAndLength(childrenCollection, item);
            }
            
            //try
            //{
                cursor.moveNext();
                /*
            }
            catch (e:ItemPendingError)
            {
                break;
            }
                */
        }
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
        var modelOffset:int = 0;
        var firstNode:Boolean = true;

        if (node == null)
        {
            // special case counting the whole thing
            // watch for page faults
            var modelCursor:IViewCursor = treeData.createCursor();
            if (modelCursor.beforeFirst)
            {
                // indicates that an IPE occured on the first item
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
                        if (parNode != null)
                        {
                            startTrackUpdates(parNode);
                            childrenMap[UIDUtil.getUID(parNode)] = treeData;
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
                //try
                //{
                    modelCursor.moveNext();
                    /*
                }
                catch (e:ItemPendingError)
                {
                    // just stop where we are, no sense paging
                    // the whole thing just to get length. make a rough
                    // guess assuming that all un-paged nodes are closed
                    length += treeData.length - modelOffset;
                    return length;
                }*/
            }
        }
        else
        {
            var uid:String = UIDUtil.getUID(node);
            addParentMapping(uid, parent);
            if (node != null &&
                openNodes[uid] &&
                hierarchicalData.canHaveChildren(node) &&
                hierarchicalData.hasChildren(node))
            {
                childNodes = getChildren(node);
                if (childNodes != null)
                {
                    var childCursor:IViewCursor = childNodes.createCursor();
                    //try
                    //{
                        childCursor.seek(CursorBookmark.FIRST);
                        while (!childCursor.afterLast)
                        {
                            if (node is XML)
                                startTrackUpdates(childCursor.current);
                            length += calculateLength(childCursor.current, node) + 1;
                            modelOffset++;
                            
                            //try
                            //{
                                childCursor.moveNext();
                                /*
                            }
                            catch (e:ItemPendingError)
                            {
                                // just stop where we are, no sense paging
                                // the whole thing just to get length. make a rough
                                // guess assuming that all un-paged nodes are closed
                                length += childNodes.length - modelOffset;
                                return length;
                            }
                                */
                        }
                        /*
                    }
                    catch (e:ItemPendingError)
                    {
                        // assume that the child collection has one item
                        length += 1;
                    }
                                */
                }
            }
        }
        return length;
    }
    
    /**
     *  @private
     */
    private function internalRefresh(dispatch:Boolean):Boolean
    {
        var obj:Object;
        var coll:ICollectionView;
        var needUpdate:Boolean = false;
        
        // apply filter function to all the collections including the child collections
        if (!(treeData.filterFunction == null && filterFunction == null))
        {
            treeData.filterFunction = filterFunction;
            treeData.refresh();
            needUpdate = true;
        }
        
        for each(obj in openNodes)
        {
            coll = getChildren(obj);
            if (coll && !(coll.filterFunction == null && filterFunction == null))
            {
                coll.filterFunction = filterFunction;
                coll.refresh();
                needUpdate = true
            }
        }
        
        // if filter is applied to any collection, only then update the length
        if (needUpdate)
            updateLength();  // length will change after filtering, so update it.
        
        
        // apply sort to all the collections including the child collections
        if (sortCanBeApplied(treeData) && !(treeData.sort == null && sort == null))
        {
            treeData.sort = sort;
            treeData.refresh();
            dispatch = true;
        }
        
        // recursive sort for every field
        for each(obj in openNodes)
        {
            
            coll = getChildren(obj);
            
            if (coll && sortCanBeApplied(coll) && !(coll.sort == null && sort == null))
            {
                coll.sort = sort;
                coll.refresh();
                dispatch = true;
            }
        }
        
        // No concept of a sort level, so commenting the code
        /* for(var i:int = 0;i<sort.fields.length;i++)
        {
            if(sort.fields[i].hasOwnProperty("sortLevel"))
                sortLevel = sort.fields[i].sortLevel;
            //else
                //sortLevel = 1;
            
            
            if(sortLevel == 1)
            {
                var srt:ISort = new Sort();
                        
                if(sort.usingCustomCompareFunction)
                {
                    srt.compareFunction = sort.compareFunction;
                }
                
                srt.unique = sort.unique;
                        
                srt.fields = [sort.fields[i]];
                treeData.sort = srt;
                treeData.refresh();
            }
            else
            {
                for each(var obj:Object in openNodes)
                {
                    
                    var depth:int = 2;
                    var o:Object = obj;
                    while(getParentItem(o) != null)
                    {
                        depth++;
                        o = getParentItem(o);
                    }
                    
                    if(depth == sortLevel)
                    {
                        var coll:ICollectionView = getChildren(obj);
                        
                        var srt:ISort = new Sort();
                        
                        if(sort.usingCustomCompareFunction)
                            srt.compareFunction = sort.compareFunction;
                        
                        srt.unique = sort.unique;
                        
                        srt.fields = [sort.fields[i]];
                        
                        coll.sort = srt;
                        coll.refresh();
                    }
                }
            }
        } */
            
        if (dispatch)
        {
            var refreshEvent:CollectionEvent =
                new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            refreshEvent.kind = CollectionEventKind.REFRESH;
            dispatchEvent(refreshEvent);
        }
        return true;
    }
    
    /**
     * @private
     * Check if a collection has the properties on which the sort is applied.   
     */
    private function sortCanBeApplied(coll:ICollectionView):Boolean
    {
        if (sort == null)
            return true;
        
        // get the current item
        var obj:Object = coll.createCursor().current;
        
        if (!obj || !sort.fields)
            return false;
        
        // check for the properties (sort fields) in the current object
        for (var i:int = 0; i < sort.fields.length; i++)
        {
            var sf:SortField = sort.fields[i];
            if (!obj.hasOwnProperty(sf.name))
                return false;
        }
        return true;
    }
    
    /**
     * @private
     * Force a recalculation of length
     */
     private function updateLength():void
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

        var uid:String = UIDUtil.getUID(node);
        addParentMapping(uid, parent);
        if (openNodes[uid] != null &&
            hierarchicalData.canHaveChildren(node) &&
            hierarchicalData.hasChildren(node))
        {
            childNodes = getChildren(node);
            if (childNodes != null)
            {
                var cursor:IViewCursor = childNodes.createCursor();
                while (!cursor.afterLast)
                {
                    getVisibleNodes(cursor.current, node, nodeArray);
                    //try
                    //{
                        cursor.moveNext();
                        /*
                    }
                    catch (e:ItemPendingError)
                    {
                        // Items are pending - so return
                        return;
                    }*/
                }
            }
        }
    }

    /**
     *  @private
     *  Factor in the available open children before this location in the model
     */
    private function getVisibleLocation(oldLocation:int):int
    {
        var newLocation:int = 0;
        var modelCursor:IViewCursor = treeData.createCursor();
        for (var i:int = 0; i < oldLocation && !modelCursor.afterLast; i++)
        {
            newLocation += calculateLength(modelCursor.current, null) + 1;
            //try
            //{
                modelCursor.moveNext();
                /*
            }
            catch (e:ItemPendingError)
            {
                // just return the location as the items are pending
                return newLocation;
            }*/
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
            children = childrenMap[UIDUtil.getUID(parent)];
            cursor = children.createCursor();
            while (!cursor.afterLast)
            {
                if (cursor.current == target)
                {
                    newLocation++;
                    break;
                }
                newLocation += calculateLength(cursor.current, parent) + 1;
                //try
                //{
                    cursor.moveNext();
                    /*
                }
                catch (e:ItemPendingError)
                {
                    break;
                }*/
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
            //try
            //{
                cursor.moveNext();
                /*
            }
            catch (e:ItemPendingError)
            {
                break;
            }
                */
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
    public function collectionChangeHandler(event:CollectionEvent):void
    {
        var i:int;
        var n:int;
        var node:Object;

        var convertedEvent:CollectionEvent;
        
        if (event is CollectionEvent)
        {
            var ce:CollectionEvent = CollectionEvent(event);
            if (ce.kind == CollectionEventKind.REFRESH)
            {
                // collection refreshed, update length
                updateLength();
            }
            else if (ce.kind == CollectionEventKind.RESET)
            {
                // initialize the collection again - its source is modified
                if (hierarchicalData)
                    initializeCollection(hierarchicalData.getRoot(), hierarchicalData, openNodes);
                updateLength();
                internalRefresh(false);
                dispatchEvent(event);
            }
            else if (ce.kind == CollectionEventKind.ADD)
            {
                n = ce.items.length;
                convertedEvent = new CollectionEvent(
                                        CollectionEvent.COLLECTION_CHANGE,
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
            else if (ce.kind == CollectionEventKind.REMOVE)
            {
                n = ce.items.length;
                convertedEvent = new CollectionEvent(
                                        CollectionEvent.COLLECTION_CHANGE,
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

                n = convertedEvent.items.length;
                for (i = 0; i < n; i++)
                {
                    deleteParentMapping(UIDUtil.getUID(convertedEvent.items[i]));
                }
            }
            else if (ce.kind == CollectionEventKind.UPDATE)
            {
                // so far, nobody cares about the details so just
                // send it
                dispatchEvent(event);
            }
            else if (ce.kind == CollectionEventKind.REPLACE)
            {
                // someday handle case where node is marked as open
                // before it becomes the replacement.
                // for now, just pass on the data and remove
                // old visible rows
                n = ce.items.length;
                convertedEvent = new CollectionEvent(
                                        CollectionEvent.COLLECTION_CHANGE,
                                        false, 
                                        true,
                                        CollectionEventKind.REMOVE);

                for (i = 0; i < n; i++)
                {
                    node = ce.items[i].oldValue;
                    if (node is XML)
                        stopTrackUpdates(node);
                    getVisibleNodes(node, null, convertedEvent.items);
                }

                // prune the replacements from this list
                for (i = 0; i < n; i++)
                {
                    node = ce.items[i].oldValue;
                    var replacedNodePosition:int = convertedEvent.items.indexOf(node);
                    if(replacedNodePosition != -1)
                        convertedEvent.items.splice(replacedNodePosition, 1);
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
    public function nestedCollectionChangeHandler(event:CollectionEvent):void
    {
        var i:int;
        var n:int;
        var parentOfChangingNode:Object;
        var changingNode:Object;
        var convertedEvent:CollectionEvent;

        if (event is CollectionEvent)
        {
            var ce:CollectionEvent = CollectionEvent(event);
            if (ce.kind == CollectionEventKind.EXPAND)
            {
                event.stopImmediatePropagation();
            }
            else if (ce.kind == CollectionEventKind.ADD)
            {
                // optimize someday.  We do a full tree walk so we can
                // not only count how many but find the parents of the
                // new nodes.  A better scheme would be to just
                // increment by the number of visible nodes, but we
                // don't have a good way to get the parents.
                updateLength();
                n = ce.items.length;
                convertedEvent = new CollectionEvent(
                                        CollectionEvent.COLLECTION_CHANGE,
                                        false, 
                                        true,
                                        ce.kind);
                for (i = 0; i < n; i++)
                {
                    changingNode = ce.items[i];
                    if (changingNode is XML)
                        startTrackUpdates(changingNode);
                    parentOfChangingNode = getParentItem(changingNode);
                    if (parentOfChangingNode != null)
                        getVisibleNodes(changingNode, parentOfChangingNode, convertedEvent.items);
                }
                convertedEvent.location = getVisibleLocationInSubCollection(parentOfChangingNode, ce.location);
                dispatchEvent(convertedEvent);
            }
            else if (ce.kind == CollectionEventKind.REMOVE)
            {
                n = ce.items.length;
                convertedEvent = new CollectionEvent(
                                        CollectionEvent.COLLECTION_CHANGE,
                                        false, 
                                        true,
                                        ce.kind);
                for (i = 0; i < n; i++)
                {
                    changingNode = ce.items[i];
                    if (changingNode is XML)
                        stopTrackUpdates(changingNode);
                    parentOfChangingNode = getParentItem(changingNode);
                    if (parentOfChangingNode != null)
                        getVisibleNodes(changingNode, parentOfChangingNode, convertedEvent.items);
                }
                convertedEvent.location = getVisibleLocationInSubCollection(parentOfChangingNode, ce.location);
                currentLength -= convertedEvent.items.length;
                dispatchEvent(convertedEvent);
            }
            else if (ce.kind == CollectionEventKind.UPDATE)
            {
                // so far, nobody cares about the details so just
                // send it
                dispatchEvent(event);
            }
            else if (ce.kind == CollectionEventKind.REPLACE)
            {
                // someday handle case where node is marked as open
                // before it becomes the replacement.
                // for now, just pass on the data and remove
                // old visible rows
                n = ce.items.length;
                convertedEvent = new CollectionEvent(
                                        CollectionEvent.COLLECTION_CHANGE,
                                        false, 
                                        true,
                                        CollectionEventKind.REMOVE);

                for (i = 0; i < n; i++)
                {
                    changingNode = ce.items[i].oldValue;
                    parentOfChangingNode = getParentItem(changingNode);
                    
                    if (parentOfChangingNode != null)
                    {
                        getVisibleNodes(changingNode, parentOfChangingNode, convertedEvent.items);
                        // update the parent of the new item only 
                        // if the parent node is opened
                        if (_openNodes[UIDUtil.getUID(parentOfChangingNode)] != null)
                        {
                            addParentMapping(UIDUtil.getUID(ce.items[i].newValue), parentOfChangingNode);
                        }
                    }
                }

                // prune the replacements from this list
                for (i = 0; i < n; i++)
                {
                    changingNode = ce.items[i].oldValue;
                    if (changingNode is XML)
                        stopTrackUpdates(changingNode);

                    var replacedNodePosition:int = convertedEvent.items.indexOf(changingNode);
                    if(replacedNodePosition != -1)
                        convertedEvent.items.splice(replacedNodePosition, 1);
                }
                if (convertedEvent.items.length)
                {
                    currentLength -= convertedEvent.items.length;
                    // nobody cares about location yet.
                    dispatchEvent(convertedEvent);
                }
                dispatchEvent(event);

                for (i = 0; i < n; i++)
                {
                    changingNode = ce.items[i].oldValue;
                    parentOfChangingNode = getParentItem(changingNode);

                    if (parentOfChangingNode != null && _openNodes[UIDUtil.getUID(parentOfChangingNode)] != null)
                        deleteParentMapping(UIDUtil.getUID(changingNode));
                }
            }
            else if (ce.kind == CollectionEventKind.RESET)
            {
                // removeAll() sends a RESET.
                // when we get a reset we don't know what went away
                // and we don't know how many things went away, so
                // we just fake a refresh as if there was a filter
                // applied that filtered out whatever went away
                updateLength();
                convertedEvent = new CollectionEvent(
                                        CollectionEvent.COLLECTION_CHANGE,
                                        false, 
                                        true,
                                        CollectionEventKind.REFRESH);
                dispatchEvent(convertedEvent);
            }
        }
    }
    
    /**
     *  @private
     *  Called whenever an XML object contained in a list is updated
     *  in some way.  The initial implementation stab is very lenient,
     *  any changeType will cause an update no matter how much further down
     *  in a hierarchy.  
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
        var children:XMLListCollection;
        var location:int;
        var event:CollectionEvent;
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
                    for (var q:* in childrenMap)
                    {
                        if (q === currentTarget)
                        {
                            list = childrenMap[q].list as XMLListAdapter;
                            if (list && !list.busy())
                            {
                                if (childrenMap[q] === treeData)
                                {
                                    children = treeData as XMLListCollection;
                                    if (parentNode != null)
                                    {
                                        children.mx_internal::dispatchResetEvent = false;
                                        children.source = parentNode.*;
                                        children.refresh();
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
                                    event = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
                                    event.kind = CollectionEventKind.ADD;
                                    event.location = location;
                                    event.items = [ value ];
                                    children.dispatchEvent(event);
                                }
                            }
                            break;
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
                */

                case "nodeRemoved":
                {
                    // lookup doesn't work, must scan instead
                    for (var p:* in childrenMap)
                    {
                        if (p === currentTarget)
                        {
                            children = childrenMap[p];
                            list = children.list as XMLListAdapter;
                            if (list && !list.busy())
                            {
                                var xmllist:XMLList = children.source as XMLList;

                                if (childrenMap[p] === treeData)
                                {
                                    children = treeData as XMLListCollection;
                                    if (parentNode)
                                    {
                                        children.mx_internal::dispatchResetEvent = false;
                                        children.source = parentNode.*;
                                        children.refresh();
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
                                        oldChildren.addEventListener(CollectionEvent.COLLECTION_CHANGE,
                                                                      nestedCollectionChangeHandler, false/*, 0, true*/);

                                        event = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
                                        event.kind = CollectionEventKind.REMOVE;
                                        event.location = 0;
                                        event.items = [ value ];
                                        oldChildren.dispatchEvent(event);
                                        oldChildren.removeEventListener(CollectionEvent.COLLECTION_CHANGE,
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
                                            event = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
                                            event.kind = CollectionEventKind.REMOVE;
                                            event.location = location;
                                            event.items = [ value ];
                                            children.dispatchEvent(event);
                                            break;
                                        }
                                    }
                                }
                            }
                            break;
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
}

}
