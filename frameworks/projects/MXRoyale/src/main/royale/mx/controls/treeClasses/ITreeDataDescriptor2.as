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
import mx.collections.IViewCursor;

/**
 *  The ITreeDataDescriptor2 Interface defines methods for parsing and adding nodes
 *  to a collection of data that is displayed by a Tree control.
 *
 *  @see mx.collections.ICollectionView
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public interface ITreeDataDescriptor2 extends ITreeDataDescriptor
{
    /**
     *  Returns an ICollectionView instance that makes the hierarchical data appear
     *  as if it was a linear ICollectionView instance.
     *
     *  @param hierarchicalData The hierarchical data.
     *
     *  @param uidFunction A function that takes an Object and returns the UID, as a String. 
     *  This parameter is usually the <code>Tree.itemToUID()</code> method.
     *
     *  @param openItems The items that have been opened or set opened.
     *
     *  @param model The collection to which this node belongs.
     * 
     *  @return An ICollectionView instance.
     *
     *  @see mx.controls.Tree
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function getHierarchicalCollectionAdaptor(hierarchicalData:ICollectionView, 
                                                uidFunction:Function, 
                                                openItems:Object,
                                                model:Object = null):ICollectionView;

    /**
     *  Returns the depth of the node, meaning the number of ancestors it has.
     *
     *  @param node The Object that defines the node.
     * 
     *  @param iterator An IViewCursor instance that could be used to do the calculation.
     *
     *  @param model The collection to which this node belongs.
     *  
     *  @return The depth of the node, where 0 corresponds to the top level, 
     *  and -1 if the depth cannot be calculated.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function getNodeDepth(node:Object, iterator:IViewCursor, model:Object = null):int;

    /**
     *  Returns the parent of the node
     *  The parent of a top-level node is <code>null</code>.
     *
     *  @param node The Object that defines the node.
     *
     *  @param collection An ICollectionView instance that could be used to do the calculation.
     *
     *  @param model The collection to which this node belongs.
     * 
     *  @return The parent node containing the node as child, 
     *  <code>null</code> for a top-level node,  
     *  and <code>undefined</code> if the parent cannot be determined.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function getParent(node:Object, collection:ICollectionView, model:Object = null):Object;
}

}
