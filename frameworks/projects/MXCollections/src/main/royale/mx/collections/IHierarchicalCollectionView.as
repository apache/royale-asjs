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

/**
 *  The IHierarchicalCollectionView interface defines an interface 
 *  for hierarchical or grouped data.
 *  Typically, you use this data with the AdvancedDataGrid control. 
 *
 *  @see mx.controls.AdvancedDataGrid
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public interface IHierarchicalCollectionView extends ICollectionView
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  openNodes
    //----------------------------------

    /**
     *  An Array of Objects containing the data provider element 
     *  for all the open branch nodes of the data.
     *  
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get openNodes():Object;
    
    /**
     *  @private
     */
    function set openNodes(value:Object):void
    
    //----------------------------------
    //  hasRoot
    //----------------------------------
    
    /** 
     *  A flag that, if <code>true</code>, indicates that the current data provider has a root node; 
     *  for example, a single top-level node in a hierarchical structure. 
     *  XML and Object are examples of data types that have a root node, 
     *  while Lists and Arrays do not.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get hasRoot():Boolean;
    
    //----------------------------------
    //  showRoot
    //----------------------------------
    
    /**
     *  A Boolean flag that specifies whether to display the data provider's root node.
     *  If the source data has a root node, and this property is set to 
     *  <code>false</code>, the collection will not include the root item. 
     *  Only the descendants of the root item will be included in the collection.  
     * 
     *  <p>This property has no effect on a source with no root node, 
     *  such as List and Array objects.</p> 
     *
     *  @default true
     *  @see #hasRoot
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get showRoot():Boolean;
    
    /**
     *  @private
     */
    function set showRoot(value:Boolean):void;
    
    //----------------------------------
    //  source
    //----------------------------------
    
    /**
     *  The source data of the IHierarchicalCollectionView.
     * 
     *  @return the IHierarchicalData instance representing the source
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get source():IHierarchicalData;

    /**
     *  @private
     */
    function set source(value:IHierarchicalData):void;
    
    //--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
    /**
     *  Opens a node to display its children.
     *
     *  @param node The Object that defines the node.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function openNode(node:Object):void
    
    /**
     *  Closes a node to hide its children.
     *
     *  @param node The Object that defines the node.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function closeNode(node:Object):void
    
    /**
     *  Returns a collection of children, if they exist. 
     *
     *  @param node The Object that defines the node. 
     *  If <code>null</code>, return a collection of top level nodes.
     *
     *  @return ICollectionView instance containing the child nodes.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function getChildren(node:Object):ICollectionView;
    
    /**
     *  Adds a child node to a node of the data.
     *
     *  @param node The Object that defines the parent node.
     *
     *  @param child The Object that defines the new node.
     *
     *  @return <code>true</code> if the node is added successfully.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function addChild(parent:Object, newChild:Object):Boolean;

    /**
     *  Removes the child node from the parent node.
     *
     *  @param node The Object that defines the parent node,  
     *   and <code>null</code> for top-level nodes.
     *
     *  @param child The Object that defines the child node to be removed.
     *
     *  @return <code>true</code> if the node is removed successfully.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function removeChild(parent:Object, child:Object):Boolean;

    /**
     *  Adds a child node to a node of the data at a specific index in the data.
     *
     *  @param node The Object that defines the parent node.
     *
     *  @param child The Object that defines the new node.
     *
     *  @param index The zero-based index of where to insert the child node.
     *
     *  @return <code>true</code> if the node is added successfully.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function addChildAt(parent:Object, newChild:Object,
                        index:int):Boolean;
                        
    /**
     *  Removes the child node from a node at the specified index.
     *
     *  @param parent The node object that currently parents the child node.
     *  Set <code>parent</code> to <code>null</code> for top-level nodes.
     *
     *  @param index The zero-based index of the child node to remove relative to the parent.
     *
     *  @return <code>true</code> if successful, and <code>false</code> if not.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function removeChildAt(parent:Object, index:int):Boolean;
    
    /**
     *  Returns the depth of the node in the collection.
     *
     *  @param node The Object that defines the node.
     * 
     *  @return The depth of the node.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */ 
    function getNodeDepth(node:Object):int;
    
    /**
     *  Returns the parent of a node.  
     *  The parent of a top-level node is <code>null</code>.
     *
     *  @param node The Object that defines the node.
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
    function getParentItem(node:Object):*;
}

}
