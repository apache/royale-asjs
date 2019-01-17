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

//import mx.collections.errors.ChildItemPendingError;
//import mx.collections.errors.ItemPendingError;
import mx.core.mx_internal;
import mx.events.CollectionEvent;
import mx.events.CollectionEventKind;
import mx.events.FlexEvent;
import mx.utils.ObjectUtil;
import mx.utils.UIDUtil;

use namespace mx_internal;

/**
 *  The HierarchicalCollectionViewCursor class defines a 
 *  cursor for a hierarchical view of a standard collection. 
 *  The collection that this cursor walks across need not be hierarchical - it may be flat. 
 *  This class delegates to the IHierarchicalData for information regarding the tree 
 *  structure of the data it walks across. 
 *  
 *  @see HierarchicalCollectionView
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class HierarchicalCollectionViewCursor extends EventDispatcher
                                    implements IHierarchicalCollectionViewCursor
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
     *  @param collection The HierarchicalCollectionView instance referenced by this cursor.
     *
     *  @param model The source data collection.
     *
     *  @param hierarchicalData The data used to create the HierarchicalCollectionView instance.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function HierarchicalCollectionViewCursor(
                            collection:HierarchicalCollectionView,
                            model:ICollectionView,
                            hierarchicalData:IHierarchicalData)
    {
        super();
        
        //fields
        this.collection = collection;
        this.hierarchicalData = hierarchicalData;
        this.model = model;
        
        //events
        collection.addEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler, false/*, 0, true*/);

        //init
        modelCursor = model.createCursor();
        
        //check to see if the model has more than one top level items
        more = model.length > 1;
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
     *  The bookmark representing the position of the current node in its siblings collection
     */
    private var currentChildBookmark:CursorBookmark = CursorBookmark.FIRST;

    /**
     *  @private
     *  Its effective offset into the "array".
     */
    private var currentIndex:int = 0;
    
    /**
     *  @private
     *  The depth of the current node.
     */
    private var _currentDepth:int = 1; 
    
    /**
     *  @private
     *  The current set of childNodes we are walking.
     */
    private var childNodes:ICollectionView;
    
    /**
     *  @private
     *  The current set of parentNodes that we have walked from
     */
    private var parentNodes:Array = [];
    
    /**
     *  @private
     *  A stack of the currentChildBookmark in all parents of the currentNode.
     */
    private var parentBookmarkStack:Array = [];

    /**
     *  @private
     *  The collection that stores the user data
     */
    private var model:ICollectionView;
    
    /**
     *  @private
     *  The collection wrapper of the model
     */
    private var collection:HierarchicalCollectionView;
    
    /**
     *  @private
     *  Flag indicating model has more data
     */ 
    private var more:Boolean;
    
    /**
     *  @private
     *  Cursor from the model
     */ 
    private var modelCursor:IViewCursor;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    // index
    //----------------------------------
    /**
     * @private
     */
    public function get index():int
    {
        return currentIndex;
    }
    
    //----------------------------------
    //  bookmark
    //----------------------------------
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get bookmark():CursorBookmark
    {
        return new CursorBookmark(currentIndex.toString());
    }

    //---------------------------------- 
    //  current
    //----------------------------------
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get current():Object
    {
        if (parentBookmarkStack.length == 0)
        {
            return modelCursor.current;
        }
        else
        {
            var childCursor:IViewCursor = childNodes.createCursor();
            //try
            //{
                
                childCursor.seek(currentChildBookmark);
                return childCursor.current;
                /*
            }
            catch (e:ItemPendingError)
            {
                return null;
            }*/
        }
        
        return null;
    }


    //---------------------------------
    // currentDepth
    //---------------------------------
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get currentDepth():int
    {
        return _currentDepth;
    }


    //----------------------------------
    //  beforeFirst
    //----------------------------------
    /**
     *  @copy mx.collections.IViewCursor#beforeFirst
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get beforeFirst():Boolean
    {
        return currentIndex < 0 && current == null;
    }
    
    //----------------------------------
    //  afterLast
    //----------------------------------
    /**
     *  @copy mx.collections.IViewCursor#afterLast
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get afterLast():Boolean
    {
        return currentIndex >= collection.length && current == null;
    } 
    
    //----------------------------------
    //  view
    //----------------------------------
    /**
     *  @copy mx.collections.IViewCursor#view
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get view():ICollectionView
    {
        return model;
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  <p>Note that for this class, the view does not need to be sorted in order to
     *  call this method. Also, if the item cannot be found, the cursor location is
     *  left on the last queried object.</p>
     *
     *  @inheritDoc
     * 
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function findAny(valuesToMatch:Object):Boolean
    {
        seek(CursorBookmark.FIRST);
        
        do
        {
            if (ObjectUtil.valuesAreSubsetOfObject(valuesToMatch, hierarchicalData.getData(current)))
                return true;
        }
        while(moveNext());

        return false;
    }

    /**
     *  <p>Note that for this class, the view does not need to be sorted in order to
     *  call this method. Also, if the item cannot be found, the cursor location is
     *  left on the last queried object.</p>
     *
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function findFirst(values:Object):Boolean
    {
        return findAny(values);
    }

    /**
     *  <p>Note that for this class, the view does not need to be sorted in order to
     *  call this method. Also, if the item cannot be found, the cursor location is
     *  left on the last queried object.</p>
     *
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function findLast(valuesToMatch:Object):Boolean
    {
        seek(CursorBookmark.LAST);
        
        do
        {
            if (ObjectUtil.valuesAreSubsetOfObject(valuesToMatch, hierarchicalData.getData(current)))
                return true;
        }
        while(movePrevious());

        return false;
    }


    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function moveNext():Boolean 
    {
        var currentNode:Object = current;
        //if there is no currentNode then we can't move forward and must be off the ends
        if (currentNode == null) 
            return false; 
        
        var childCursor:IViewCursor;
        var uid:String = UIDUtil.getUID(currentNode);

        // If current node is a branch and is open, the first child is our next item so return it
        if (collection.openNodes[uid] &&
            hierarchicalData.canHaveChildren(currentNode) && 
            hierarchicalData.hasChildren(currentNode))
        {
                var previousChildNodes:ICollectionView = childNodes;
                childNodes = collection.getChildren(currentNode);
                if (childNodes.length > 0)
                {
                    parentBookmarkStack.push(currentChildBookmark);
                    parentNodes.push(currentNode);
                    currentChildBookmark = CursorBookmark.FIRST;
                    childCursor = childNodes.createCursor();
                    //try
                    //{
                        currentNode = childCursor.current;
                        // update parent map
                        updateParentMap(currentNode);
                    //}
                    //catch (e:ItemPendingError)
                    //{
                    //    currentNode = null;
                    //    throw new ChildItemPendingError(e.message);
                    //}
                    currentIndex++;
                    _currentDepth++;
                    return true;
                }
                else
                {
                    childNodes = previousChildNodes;
                }
        }

        // Otherwise until we find the next child (could be on any level)
        while (true)
        {
            // If we hit the end of this list, pop up a level.
            if(childNodes != null)
            {
                childCursor = childNodes.createCursor();
                //try
                //{
                    childCursor.seek(currentChildBookmark);
                    childCursor.moveNext();
                //}
                //catch(e:ItemPendingError)
                //{
                //    childCursor.seek(CursorBookmark.FIRST);
                //}
             }
             
             var grandParent:Object;
            
            if (childNodes != null && 
                childNodes.length > 0 && 
                (childCursor.bookmark == CursorBookmark.LAST || childCursor.afterLast))
            {
                //check for the end of the tree here.
                if (parentBookmarkStack.length < 1 && !more)  
                {
                    currentNode = null;
                    currentIndex++;
                    _currentDepth = 1;
                    return false;
                }
                else 
                {  
                    //pop up to parent
                    currentNode = parentNodes.pop(); 
                    //get parents siblings 
                    grandParent = parentNodes[parentNodes.length-1];
                    //we could probably assume that a non-null grandparent has descendants 
                    //but the analogy only goes so far... 
                    if (grandParent != null && 
                        hierarchicalData.canHaveChildren(grandParent) &&
                        hierarchicalData.hasChildren(grandParent))
                    {
                        childNodes = collection.getChildren(grandParent);
                    }
                    else
                    {
                        childNodes = null;
                    }
                    //get new current nodes index
                    currentChildBookmark = parentBookmarkStack.pop();
                    //pop the level up one
                    _currentDepth--;
                }
            }
            else
            {
                //if no childnodes then we're probably at the top level
                if (parentBookmarkStack.length == 0)
                {
                    //check for more top level siblings
                    //and if we're here the depth should be 1
                    _currentDepth = 1;
                    more = modelCursor.moveNext();
                    if (more) 
                    {
                        currentNode = modelCursor.current;
                        break;
                    } 
                    else 
                    {
                        //at the end of the tree
                        _currentDepth = 1;
                        currentIndex++;  //this should push us to afterLast
                        currentNode = null;
                        return false;
                    }
                }
                else 
                {
                    //get the next child node
                    //try
                    //{
                        childCursor = childNodes.createCursor();
                        childCursor.seek(currentChildBookmark);
                        
                        childCursor.moveNext();
                        currentChildBookmark = childCursor.bookmark;
                        
                        currentNode = childCursor.current;
                        break;
                    //}
                        /*
                    catch(e:ItemPendingError)
                    {
                        //pop up to parent
                        currentNode = parentNodes.pop(); 
                        //get parents siblings 
                        grandParent = parentNodes[parentNodes.length-1];
                        //we could probably assume that a non-null grandparent has descendants 
                        //but the analogy only goes so far... 
                        if (grandParent != null && 
                            hierarchicalData.canHaveChildren(grandParent) &&
                            hierarchicalData.hasChildren(grandParent))
                        {
                            childNodes = collection.getChildren(grandParent);
                        }
                        else
                        {
                            childNodes = null;
                        }
                        //get new current nodes index
                        currentChildBookmark = parentBookmarkStack.pop();
                        //pop the level up one
                        _currentDepth--;
                        
                        if (parentBookmarkStack.length == 0)
                        {
                            //check for more top level siblings
                            //and if we're here the depth should be 1
                            _currentDepth = 1;
                            more = modelCursor.moveNext();
                            if (more) 
                            {
                                currentNode = modelCursor.current;
                                throw new ChildItemPendingError(e.message);
                            } 
                            else 
                            {
                                //at the end of the tree
                                _currentDepth = 1;
                                currentIndex++;  //this should push us to afterLast
                                currentNode = null;
                                return false;
                            }
                        }
                        break;
                    }
                        */
                }
            } 
        }
        
        updateParentMap(currentNode);

        currentIndex++;
        return true;
    }
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function movePrevious():Boolean
    {
        var currentNode:Object = current;
        // If there are no items, there's no current node, so return false.
        if (currentNode == null)
            return false;
        
        var childCursor:IViewCursor;
        
        //if not at top level
        if (parentNodes && parentNodes.length > 0)
        {
            if (currentChildBookmark == CursorBookmark.FIRST)
            {
                //at the first node in this branch so move to parent
                currentNode = parentNodes.pop();
                currentChildBookmark = parentBookmarkStack.pop();
                var grandParent:Object = parentNodes[parentNodes.length-1];
                //we could probably assume that a non-null grandparent has descendants 
                //but the analogy only goes so far... 
                if (grandParent != null && 
                    hierarchicalData.canHaveChildren(grandParent) &&
                    hierarchicalData.hasChildren(grandParent))
                {
                    childNodes = collection.getChildren(grandParent);
                }
                else
                {
                    childNodes = null;  
                }
                _currentDepth--;
                currentIndex--;
                return true;
            }
            else 
            {
                // get previous child sibling
                //try 
                //{
                    childCursor = childNodes.createCursor();
                    
                    childCursor.seek(currentChildBookmark);
                    childCursor.movePrevious();
                    currentChildBookmark = childCursor.bookmark;
                    currentNode = childCursor.current;
                    
                    //try
                    //{
                        // this is needed because the cursor bookmark for
                        // the zero position and CursorBookmark.FIRST is not 
                        // same. this condition is encountered while doing
                        // a movePrevious()
                        childCursor.movePrevious();
                        if (childCursor.bookmark == CursorBookmark.FIRST)
                            currentChildBookmark = CursorBookmark.FIRST;
                        /*
                    }
                    catch (e:ItemPendingError)
                    {
                    }
                }
                catch(e:ItemPendingError)
                {
                    //lets try to recover
                    return false;
                }
                        */
            }   
        }
        //handle top level siblings
        else 
        {
            more = modelCursor.movePrevious();
            if (more)
            {
                //move back one node and then loop through children
                currentNode = modelCursor.current;
            }
            //if past the begining of the tree return false
            else 
            {
                //currentIndex--;  //should be before first
                currentIndex = -1;
                currentNode = null;
                return false;
            }
        }
        while (true)
        {
            // If there are children, walk backwards on the children
            // and consider youself after your children.
            if (collection.openNodes[UIDUtil.getUID(currentNode)] &&
                hierarchicalData.canHaveChildren(currentNode) &&
                hierarchicalData.hasChildren(currentNode))
            {
                var previousChildNodes:ICollectionView = childNodes;
                childNodes = collection.getChildren(currentNode);
                if (childNodes.length > 0)
                {
                    parentBookmarkStack.push(currentChildBookmark);
                    parentNodes.push(currentNode);
                    // if the child collection has only one item then set the
                    // bookmark to first
                    if (childNodes.length == 1)
                        currentChildBookmark = CursorBookmark.FIRST;
                    else
                        currentChildBookmark = CursorBookmark.LAST;
                    
                    childCursor = childNodes.createCursor();
                    //try
                    //{
                        childCursor.seek(currentChildBookmark);
                        currentNode = childCursor.current;
                    /*}
                    catch (e:ItemPendingError)
                    {
                        try
                        {
                            childCursor.seek(CursorBookmark.FIRST);
                            while (!childCursor.afterLast)
                            {
                                currentNode = childCursor.current;
                                childCursor.moveNext();
                            }
                        }
                        catch(e1:ItemPendingError)
                        {
                        }
                        
                        throw new ChildItemPendingError(e.message);
                    }*/
                    _currentDepth++;
                }
                else
                {
                    childNodes = previousChildNodes;
                    break;
                }
            }   
            else
            {
                //No more open branches so we'll bail
                break;
            }
        }

        updateParentMap(currentNode);

        currentIndex--;
        return true;
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function seek(bookmark:CursorBookmark, offset:int=0,
                         prefetch:int = 0):void
    {
        var value:int;
        
        if (bookmark == CursorBookmark.FIRST)
        {
            value = 0;
        }
        else if (bookmark == CursorBookmark.CURRENT)
        {
            value = currentIndex;
        }
        else if (bookmark == CursorBookmark.LAST)
        {
            value = collection.length - 1;
        }
        else
        {
            value = int(bookmark.value);
        }
        
        value = Math.max(Math.min(value + offset, collection.length), 0);
        var dc:int = Math.abs(currentIndex - value);
        var de:int = Math.abs(collection.length - value);
        var movedown:Boolean = true;
        // if we're closer to the current than the beginning
        if (dc < value)
        {
            // if we're closer to the end than the current position
            if (de < dc)
            {
                moveToLast();

                if (de == 0)
                {       
                    // if de = 0; we need to be "off the end"
                    moveNext();
                    value = 0;
                }
                else
                {
                    value = de - 1;
                }
                movedown = false;
            }
            else
            {
                movedown = currentIndex < value;
                value = dc;
                // if current is off the end, reset
                if (currentIndex == collection.length)
                {
                    value--;
                    moveToLast();
                }
            }
        }
        else // we're closer to the beginning than the current
        {
            // if we're closer to the end than the beginning
            if (de < value)
            {
                moveToLast();
                if (de == 0)
                {       
                    // if de = 0; we need to be "off the end"
                    moveNext();
                    value = 0;
                }
                else
                {
                    value = de - 1;
                }
                movedown = false;
            }
            else
            {
                moveToFirst();
            }
        }

        if (movedown)
        {
            while (value && value > 0) 
            {
                moveNext();
                value--;
            }
        }
        else
        {
            while (value && value > 0)  
            {
                movePrevious();
                value--;
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
    public function insert(item:Object):void
    {
        var parent:Object = collection.getParentItem(current);
        collection.addChildAt(parent, item, currentIndex);
    }
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function remove():Object
    {
        var obj:Object = current;
        var parent:Object = collection.getParentItem(current);
        collection.removeChild(parent, current);
        return obj;
    }
    
    /**
     *  @private
     *  Determines if a node is visible on the screen
     */
    private function isItemVisible(node:Object):Boolean
    { 
        var parentNode:Object = collection.getParentItem(node);
        while (parentNode != null)
        {
            if (collection.openNodes[UIDUtil.getUID(parentNode)] == null)
                return false;
            
            parentNode = collection.getParentItem(parentNode);
        }
        return true;
    }
    
    /**
     * @private
     * Update the parent map.
     */ 
    private function updateParentMap(currentNode:Object):void
    {
        if (currentNode != null)
        {
            var uid:String = UIDUtil.getUID(currentNode);
            collection.addParentMapping(uid, parentNodes[parentNodes.length - 1], false);
        }
    }

    /**
     *  @private
     *  Creates a stack of parent nodes by walking upwards
     */
    private function getParentStack(node:Object):Array
    {
        var nodeParents:Array = [];
        
        // Make a list of parents of the node.
        var obj:Object = collection.getParentItem(node);
        while (obj != null)
        {
            nodeParents.unshift(obj);
            obj = collection.getParentItem(obj);
        }
        return nodeParents;
    }

    /**
     *  @private
     *  When something happens to the tree, find out if it happened
     *  to children that occur before the current child in the tree walk.
     */
    private function isNodeBefore(node:Object, currentNode:Object):Boolean
    {
        if (currentNode == null)
            return false;

        var i:int;
        var tmpChildNodes:ICollectionView;
        var sameParent:Object;

        var nodeParents:Array = getParentStack(node);
        var curParents:Array = getParentStack(currentNode);
        
        var cursor:IViewCursor;
        var child:Object;

        // Starting from the root, compare parents
        // (assumes the root must be the same).
        while (nodeParents.length != 0 && curParents.length != 0)
        {
            var nodeParent:Object = nodeParents.shift();
            var curParent:Object = curParents.shift();
            
            // If not the same parentm then which ever one is first
            // in the child list is before the other.
            if (nodeParent != curParent)
            {
                // The last parent must be common.
                sameParent = collection.getParentItem(nodeParent);
                
                // Get the child list.
                if (sameParent != null && 
                    hierarchicalData.canHaveChildren(sameParent) &&
                    hierarchicalData.hasChildren(sameParent))
                {
                    tmpChildNodes = collection.getChildren(sameParent);
                }
                else
                {
                    tmpChildNodes = model; 
                }
                // Walk it until you hit one or the other.
                {
                    cursor = tmpChildNodes.createCursor();
                    //try
                    //{
                        cursor.seek(CursorBookmark.FIRST, i);
                        child = cursor.current;
                    //}
                    //catch (e:ItemPendingError)
                    //{
                        // item pending - this may never happen
                    //    return false;
                    //}
                    
                    if (child == curParent)
                        return false;

                    if (child == nodeParent)
                        return true;
                }
            }
        }

        if (nodeParents.length)
            node = nodeParents.shift();
        if (curParents.length)
            currentNode = curParents.shift();

        // If we get here, they have the same parentage or one or both
        // had a root parent. Who's first?
        tmpChildNodes = model; 
        cursor = tmpChildNodes.createCursor();
        while (!cursor.afterLast)
        {
            child = cursor.current;

            if (child == currentNode)
                return false;

            if (child == node)
                return true;
            
            //try
            //{
                cursor.moveNext();
            //}
            //catch (e:ItemPendingError)
            //{
                // item pending
            //    return false;
            //}
        }
        return false;
    }
    
    /**
     *  @private
     */
    private function moveToFirst():void
    {
        childNodes = null;
        
        //first move to the begining of the top level collection
        // let it throw an IPE, the classes using this cursor will handle it
        modelCursor.seek(CursorBookmark.FIRST, 0);
        
        more = model.length > 1;
        currentChildBookmark = CursorBookmark.FIRST;
        parentNodes = [];
        parentBookmarkStack = [];
        currentIndex = 0;
        _currentDepth = 1;
    }
    
    /**
     *  @private
     */
    public function moveToLast():void
    {
        childNodes = null;
        parentBookmarkStack = [];
        _currentDepth = 1;
        parentNodes = [];

        //first move to the end of the top level collection
        // let it throw an IPE, the classes using this cursor will handle it
        modelCursor.seek(CursorBookmark.LAST, 0);
        
        //if its a branch and open then get children for the last item
        var currentNode:Object = modelCursor.current;
        //if current node is open get its children
        while (collection.openNodes[UIDUtil.getUID(currentNode)] &&
               hierarchicalData.canHaveChildren(currentNode) &&
               hierarchicalData.hasChildren(currentNode))
        {
            var previousChildNodes:ICollectionView = childNodes;
            childNodes = collection.getChildren(currentNode);
            if (childNodes != null && childNodes.length > 0)
            {
                var childCursor:IViewCursor = childNodes.createCursor();
                //try
                //{
                    childCursor.seek(CursorBookmark.LAST);
                //}
                //catch (e:ItemPendingError)
                //{
                    // just break because if the last child item is pending
                    // return its parent
                //    break;
                //}
                parentNodes.push(currentNode);
                parentBookmarkStack.push(currentChildBookmark);                
                currentNode = childCursor.current;
                currentChildBookmark = CursorBookmark.LAST;
                //try
                //{
                    // this is needed because the cursor bookmark for
                    // the zero position and CursorBookmark.FIRST is not 
                    // same. this condition is encountered while doing
                    // a movePrevious()
                    childCursor.movePrevious();
                    if (childCursor.bookmark == CursorBookmark.FIRST)
                        currentChildBookmark = CursorBookmark.FIRST;
                //}
                //catch (e:ItemPendingError)
                //{
                //}
                _currentDepth++;
            }
            else 
            {
                childNodes = previousChildNodes;
                break;
            }
        }
        currentIndex = collection.length - 1;
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
        var changingNode:Object;
        var parentOfChangingNode:Object;
        var parentOfCurrentNode:Object;
        var parentStack:Array;
        var isBefore:Boolean = false;
        var parentOfChangingNodeIndex:int;
        var isChangingNodeParentAncestorOfSelectedNode:Boolean;
        var bookmarkInChangingCollection:CursorBookmark;
		var changingNodeCollectionBookmarkIndex:int;
        var changingNodeAndSiblings:ICollectionView;
        var changingCollectionCursor:IViewCursor;

        if (event.kind == CollectionEventKind.ADD)
        {
            n = event.items.length;
            if (event.location <= currentIndex)
            {
                currentIndex += n;
                isBefore = true;
            }

            parentStack = getParentStack(current);
            parentOfCurrentNode = parentStack[parentStack.length - 1];

            for (i = 0; i < n; i++)
            {
                changingNode = event.items[i];
                if (isBefore)
                {
                    // if the added node is before the current
                    // and they share parents then we have to
                    // adjust the currentChildIndex or
                    // the stack of child indexes.
                    parentOfChangingNode = collection.getParentItem(changingNode);
                    changingNodeAndSiblings = collection.getChildren(parentOfChangingNode); 

                    if (parentOfChangingNode == parentOfCurrentNode)
                    {
                        if (changingNodeAndSiblings != null)
                        {
                            changingCollectionCursor = changingNodeAndSiblings.createCursor();
                            //try
                            //{
                                changingCollectionCursor.seek(currentChildBookmark);
                                changingCollectionCursor.moveNext();
                                currentChildBookmark = changingCollectionCursor.bookmark;
                            //}
                            //catch (e:ItemPendingError)
                            //{
                            //}
                        }
                    }
                    else {
                        parentOfChangingNodeIndex = parentStack.indexOf(parentOfChangingNode);
                        isChangingNodeParentAncestorOfSelectedNode = parentOfChangingNodeIndex != -1;
                        if (isChangingNodeParentAncestorOfSelectedNode)
                        {
                            if (changingNodeAndSiblings != null)
                            {
                                changingNodeCollectionBookmarkIndex = parentOfChangingNodeIndex + 1;
                                changingCollectionCursor = changingNodeAndSiblings.createCursor();
                                bookmarkInChangingCollection = parentBookmarkStack[changingNodeCollectionBookmarkIndex];
                                //try
                                //{
                                    changingCollectionCursor.seek(bookmarkInChangingCollection);
                                    changingCollectionCursor.moveNext();
                                //}
                                //catch (e:ItemPendingError)
                                //{
                                //}
                                parentBookmarkStack[changingNodeCollectionBookmarkIndex] = changingCollectionCursor.bookmark;
                            }
                        }
                    }
                }
            }
            
        }
        else if (event.kind == CollectionEventKind.REMOVE)
        {
            n = event.items.length;
            if (event.location <= currentIndex)
            {
                var lastIndexAffectedByDeletion:int = event.location + n;
                var isCurrentIndexAmongRemovedNodes:Boolean = lastIndexAffectedByDeletion >= currentIndex;
                var currentItemNotFoundAmongItsSiblings:Boolean = isCurrentIndexAmongRemovedNodes ? false : (!afterLast && !beforeFirst && current == null);

                if (isCurrentIndexAmongRemovedNodes || currentItemNotFoundAmongItsSiblings)
                {
                    // the list classes expect that we
                    // leave the cursor on whatever falls
                    // into that slot
                    var indexToReturnTo:int = isCurrentIndexAmongRemovedNodes ? event.location : currentIndex - n;
                    moveToFirst();
                    seek(CursorBookmark.FIRST, indexToReturnTo);

                    return;
                }

                currentIndex -= n;
                isBefore = true;
            }

            parentStack = getParentStack(current);
            parentOfCurrentNode = parentStack[parentStack.length - 1];

            for (i = 0; i < n; i++)
            {
                changingNode = event.items[i];
                if (isBefore)
                {
                    // if the removed node is before the current
                    // and they share parents then we have to
                    // adjust the currentChildIndex or
                    // the stack of child indexes.
                    parentOfChangingNode = collection.getParentItem(changingNode);
                    changingNodeAndSiblings = collection.getChildren(parentOfChangingNode);

                    if (parentOfChangingNode == parentOfCurrentNode)
                    {
                        if(currentChildBookmark == CursorBookmark.LAST)
                            break;

                        if (changingNodeAndSiblings != null)
                        {
                            changingCollectionCursor = changingNodeAndSiblings.createCursor();
                            //try
                            //{
                                changingCollectionCursor.seek(currentChildBookmark);
                                changingCollectionCursor.movePrevious();
                                currentChildBookmark = changingCollectionCursor.bookmark;
                            //}
                            //catch (e:ItemPendingError)
                            //{
                            //}
                        }
                    }
                    else {
                        parentOfChangingNodeIndex = parentStack.indexOf(parentOfChangingNode);
                        isChangingNodeParentAncestorOfSelectedNode = parentOfChangingNodeIndex != -1;
                        if (isChangingNodeParentAncestorOfSelectedNode)
                        {
                            if (changingNodeAndSiblings != null)
                            {
                                changingNodeCollectionBookmarkIndex = parentOfChangingNodeIndex + 1;
                                changingCollectionCursor = changingNodeAndSiblings.createCursor();
                                bookmarkInChangingCollection = parentBookmarkStack[changingNodeCollectionBookmarkIndex];

                                if(bookmarkInChangingCollection == CursorBookmark.LAST)
                                    break;

                                //try
                                //{
                                    changingCollectionCursor.seek(bookmarkInChangingCollection);
                                    changingCollectionCursor.movePrevious();
                                //}
                                //catch (e:ItemPendingError)
                                //{
                                //}
                                parentBookmarkStack[changingNodeCollectionBookmarkIndex] = changingCollectionCursor.bookmark;
                            }
                        }
                    }
                }
            }
        }
        else if (event.kind == CollectionEventKind.RESET)
        {
            // update the source collection and the cursor
            model = collection.treeData;
            modelCursor = model.createCursor();
            // dispatch CURSOR_UPDATE event
            //collection.dispatchEvent(new FlexEvent(FlexEvent.CURSOR_UPDATE));
        }
        else if (event.kind == CollectionEventKind.REFRESH)
        {
            // find the correct index of the item
            if (!(beforeFirst || afterLast))
            {
                findFirst(current);
            }
        }
    }
}
}
