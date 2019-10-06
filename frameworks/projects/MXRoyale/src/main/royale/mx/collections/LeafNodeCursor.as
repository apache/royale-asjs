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

import mx.events.CollectionEvent;
import mx.events.CollectionEventKind;
import mx.utils.UIDUtil;

import mx.core.mx_internal;

use namespace mx_internal;

/**
 *  @private
 *  This class provides a heirarchical view (a tree-like) view of a standard collection. 
 *  The collection that this Cursor walks across need not be heirarchical but may be flat. 
 *  This class delegates to the IHierarchicalData for information regarding the tree 
 *  structure of the data it walks across.
 *  This class assumes that all the nodes are open and then traverse through them.
 *  
 *  Only methods moveNext() and movePrevious() are implemented.
 *  
 *  @see HierarchicalCollectionView
 */
public class LeafNodeCursor extends EventDispatcher
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
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function LeafNodeCursor(
							collection:HierarchicalCollectionView,
							model:ICollectionView,
							hierarchicalData:IHierarchicalData)
    {
		super();
		
		//fields
        this.collection = collection;
        this.hierarchicalData = hierarchicalData;
		this.model = model;

		//init
		modelCursor = model.createCursor();
		
		//check to see if the model has more than one top level items
		if (model.length > 1)
			more = true;
		else 
			more = false;
			
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
 
    /**
     *  @private
     */
    private var hierarchicalData:IHierarchicalData;

    /**
     *  @private
	 *  Its effective offset into the "array".
     */
    private var currentIndex:int = 0;
    
    /**
     *  @private
	 *  The current index into the childNodes array
     */
    private var currentChildIndex:int = 0;
    
    /**
     *  @private
     *  The depth of the current node.
     */
    private var _currentDepth:int = 1; 
    
    /**
     *  @private
	 *  The current set of childNodes we are walking.
     */
	private var childNodes:Object = [];
	
	/**
	 *  @private
	 *  The current set of parentNodes that we have walked from
	 */
	private var parentNodes:Array = [];
    
    /**
     *  @private
	 *  A stack of the currentChildIndex in all parents of the currentNode.
     */
	private var childIndexStack:Array = [];

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
     *  @private
     */
    public function get bookmark():CursorBookmark
    {
        return null;
    }

    //---------------------------------- 
	//  current
    //----------------------------------
    
    /**
     *  @private
     */
    public function get current():Object
    {
        try 
        {
        	if (childIndexStack.length == 0)
        	{
        		if (hierarchicalData.canHaveChildren(modelCursor.current) ||
        			 modelCursor.current is SummaryObject)
				{
					moveNext();
				}
				else
				{
        			return modelCursor.current;
    			}
        	}
        	return childNodes[currentChildIndex];
 		}
        catch (e:RangeError)
		{
		}
		return null;
    }


	//---------------------------------
	// currentDepth
	//---------------------------------
	/**
	 *  @private
	 */
	public function get currentDepth():int
	{
		return _currentDepth;
	}


	//----------------------------------
	//  beforeFirst
	//----------------------------------
	/**
	 *  @private
	 */
    public function get beforeFirst():Boolean
    {
    	return currentIndex < 0 && current == null;
    }
    
	//----------------------------------
	//  afterLast
	//----------------------------------
	/**
	 *  @private
	 */
    public function get afterLast():Boolean
    {
        return currentIndex >= collection.length && current == null;
    } 
    
	//----------------------------------
	//  view
	//----------------------------------
	/**
	 *  @private
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
     *  @private
     */
    public function findAny(values:Object):Boolean
    {
        return false;
    }

    /**
     *  @private
     */
    public function findFirst(values:Object):Boolean
    {
        return false;
    }

    /**
     *  @private
     */
    public function findLast(values:Object):Boolean
    {
        return false;
    }

    /**
     *  @private
     *  Move one node forward from current.  
     *  This may include moving up or down one or more levels.
     */
    public function moveNext():Boolean 
    {
    	var currentNode:Object = childIndexStack.length == 0 ? modelCursor.current : current;
        //if there is no currentNode then we cant move forward and must be off the ends
    	if (currentNode == null) 
    		return false; 
    	
		var uid:String = UIDUtil.getUID(currentNode);
        collection.addParentMapping(uid, parentNodes[parentNodes.length - 1], false);

		var flag:Boolean = true;		
		// If current node is a branch and is open, the first child is our next item so return it
		if (hierarchicalData.canHaveChildren(currentNode) && 
			hierarchicalData.hasChildren(currentNode))
	    {
	        	var previousChildNodes:Object = childNodes;
	            childNodes = collection.getChildren(currentNode);
				if (childNodes.length > 0)
				{
					childIndexStack.push(currentChildIndex);
					parentNodes.push(currentNode);
					currentChildIndex = 0;
					currentNode = childNodes[0];					
					currentIndex++;
					_currentDepth++;
					
					// check for children and currentNode to be SummaryObject and find the next item if required.
					if (hierarchicalData.canHaveChildren(currentNode) ||
						currentNode is SummaryObject)
					{
						flag = moveNext();
					}
					return flag;
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
            if (childNodes != null && 
            	childNodes.length > 0 && 
            	currentChildIndex >= Math.max(childNodes.length - 1, 0))
            {
            	//check for the end of the tree here.
                if (childIndexStack.length < 1 && !more)  
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
               			childNodes = [];
               		}
                	//get new current nodes index
                	currentChildIndex = childIndexStack.pop();
                	//pop the level up one
                	_currentDepth--;
                }
            }
            else
            {
            	//if no childnodes then we're probably at the top level
            	if (childIndexStack.length == 0)
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
					try
					{
						currentNode = childNodes[++currentChildIndex];
						break;
					}
					catch (e:RangeError)
					{
						//lets try to recover
						return false;
					}
    			}
            } 
        }
        currentIndex++;
        
       // check for children and currentNode to be SummaryObject and find the next item if required.
        if (hierarchicalData.canHaveChildren(currentNode) ||
        	 currentNode is SummaryObject)
		{
			flag = moveNext();
		}
        return flag;
    }
    
    /**
     *  @private
	 *  Performs a backward tree walk.
     */
    public function movePrevious():Boolean
    {
    	var currentNode:Object = current;
    	// If there are no items, there's no current node, so return false.
        if (currentNode == null)
			return false;
    	
    	var flag:Boolean = true;
    	//if not at top level
		if (parentNodes && parentNodes.length > 0)
		{
			if (currentChildIndex == 0)
        	{
        		//at the first node in this branch so move to parent
        		currentNode = parentNodes.pop();
        		currentChildIndex = childIndexStack.pop();
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
                	//null is valid, but error prone so we'll make it empty
                	childNodes = [];  
                }
        		_currentDepth--;
        		currentIndex--;

				// check for children and currentNode to be SummaryObject and find the previous item if required.
				if (!beforeFirst && (hierarchicalData.canHaveChildren(currentNode) ||
					currentNode is SummaryObject))
				{
					flag = movePrevious();
				}
        		return flag;
        	}
        	else 
        	{
        		// get previous child sibling
        		try 
        		{
        			currentNode = childNodes[--currentChildIndex];
        		}
        		catch(e:RangeError)
        		{
        			//lets try to recover
					return false;
        		}
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
			if (hierarchicalData.canHaveChildren(currentNode) &&
			    hierarchicalData.hasChildren(currentNode))
            {
				var previousChildNodes:Object = childNodes;
            	childNodes = collection.getChildren(currentNode);
				if (childNodes.length > 0)
				{
            		childIndexStack.push(currentChildIndex);
            		parentNodes.push(currentNode);
            		currentChildIndex = childNodes.length - 1;
            		currentNode = childNodes[currentChildIndex];
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
        currentIndex--;

		// check for children and currentNode to be SummaryObject and find the previous item if required.
		if (hierarchicalData.canHaveChildren(currentNode) || 
			currentNode is SummaryObject)
		{
			flag = movePrevious();
		}
        return flag;
    }

    /**
     *  @private
     */
    public function seek(bookmark:CursorBookmark, offset:int=0,
						 prefetch:int = 0):void
    {
    	//No impl
    }
    
    /**
     *  @private
     */
    public function insert(item:Object):void
    {
        //No impl
    }
    
    /**
     *  @private
     */
    public function remove():Object
    {
        return null;
    }
}

}
