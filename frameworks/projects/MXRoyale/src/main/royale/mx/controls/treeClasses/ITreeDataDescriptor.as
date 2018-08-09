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

import mx.collections.ICollectionView;

/**
 *  Interface providing methods for parsing and adding nodes
 *  to a collection of data that is displayed by a Tree control.
 *
 *  @see mx.collections.ICollectionView
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
public interface ITreeDataDescriptor
{
    /**
     *  Provides access to a node's children, returning a collection
     *  view of children if they exist.
     *  A node can return any object in the collection as its children;
     *  children need not be nested.
     *  It is best-practice to return the same collection view for a
     *  given node.
     *
     *  @param node The node object currently being evaluated.
     *
     *  @param model The entire collection that this node is a part of.
     *
     *  @return An collection view containing the child nodes.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion  Royale 0.9.3
     */
    function getChildren(node:Object, model:Object = null):ICollectionView;

    /**
     *  Tests for the existence of children in a non-terminating node.
     *  
     *  @param node The current node.
     *  
     *  @param model The entire collection that this node is a part of.
     *  
     *  @return <code>true</code> if the node has at least one child.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    function hasChildren(node:Object, model:Object = null):Boolean;
    
    /**
     *  Tests a node for termination.
     *  Branches are non-terminating but are not required
     *  to have any leaf nodes.
     *
     *  @param node The node object currently being evaluated.
     *
     *  @param model The entire collection that this node is a part of.
     *
     *  @return A Boolean indicating if this node is non-terminating.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function isBranch(node:Object, model:Object = null):Boolean;
    
    /**
     *  Gets the data from a node.
     *
     *  @param node The node object from which to get the data.
     *
     *  @param model The collection that contains the node.
     *
     *  @return The requested data.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function getData(node:Object, model:Object = null):Object;
    
    /**
     *  Adds a child node to a node at the specified index.
     *
     *  @param node The node object that will parent the child.
     *
     *  @param child The node object that will be parented by the node.
     *
     *  @param index The 0-based index of where to put the child node.
     *
     *  @param model The entire collection that this node is a part of.
     *  
     *  @return <code>true</code> if successful.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function addChildAt(parent:Object, newChild:Object,
                        index:int, model:Object = null):Boolean;
    
    /**
     *  Removes a child node to a node at the specified index.
     *
     *  @param node The node object that is the parent of the child.
     *
     *  @param child The node object that will be removed.
     *
     *  @param index The 0-based index of the soon to be deleted node.
     *
     *  @param model The entire collection that this node is a part of.
     *  
     *  @return <code>true</code> if successful.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function removeChildAt(parent:Object, child:Object,
                           index:int, model:Object = null):Boolean;
}

}
