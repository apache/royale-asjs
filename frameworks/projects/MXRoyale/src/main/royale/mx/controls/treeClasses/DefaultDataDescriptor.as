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

import mx.collections.ArrayCollection;
import mx.collections.CursorBookmark;
import mx.collections.ICollectionView;
import mx.collections.IList;
import mx.collections.IViewCursor;
import mx.collections.XMLListCollection;
import mx.core.mx_internal;
import mx.controls.menuClasses.IMenuDataDescriptor;

import org.apache.royale.utils.UIDUtil;

use namespace mx_internal;

/**
 *  The DefaultDataDescriptor class provides a default implementation for
 *  accessing and manipulating data for use in controls such as Tree and Menu.
 *
 *  This implementation handles e4x XML and object nodes in similar but different
 *  ways. See each method description for details on how the method
 *  accesses values in nodes of various types.
 *
 *  This class is the default value of the Tree, Menu, MenuBar, and
 *  PopUpMenuButton control <code>dataDescriptor</code> properties.
 *
 *  @see mx.controls.treeClasses.ITreeDataDescriptor
 *  @see mx.controls.menuClasses.IMenuDataDescriptor
 *  @see mx.controls.Menu
 *  @see mx.controls.MenuBar
 *  @see mx.controls.PopUpMenuButton
 *  @see mx.controls.Tree
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class DefaultDataDescriptor implements ITreeDataDescriptor2 , IMenuDataDescriptor
{
//    include "../../core/Version.as";

    /**
     *  Constructor.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function DefaultDataDescriptor()
    {
        super();
    }

    /**
     *  @private
     */
    private var ChildCollectionCache:CollectionCache = new CollectionCache();

    /**
     *  Provides access to a node's children. Returns a collection
     *  of children if they exist. If the node is an Object, the method
     *  returns the contents of the object's <code>children</code> field as
     *  an ArrayCollection.
     *  If the node is XML, the method returns an XMLListCollection containing
     *  the child elements.
     *
     *  @param node The node object currently being evaluated.
     *  @param model The collection that contains the node; ignored by this class.
     *  @return An object containing the children nodes.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getChildren(node:Object, model:Object = null):ICollectionView
    {
        if (node == null)
            return null;
            
        var children:*;
        var childrenCollection:ICollectionView;
        
        //first get the children based on the type of node. 
        if (node is XML)
        {
            var xmlNode:XML = node as XML;
            //trace("getChildren", node.toXMLString());
            children = xmlNode.*;
        }
        else if (node is Object)
        {
            //we'll try the default children property
            try
            {
                children = node.children;
            }
            catch(e:Error)
            {
            }
        }
        
        //no children exist for this node 
        if (children == undefined && !(children is XMLList))
            return null;
        
        //then wrap children in ICollectionView if necessary
        if (children is ICollectionView)
        {
            childrenCollection = ICollectionView(children);
        }
        else if (children is Array)
        {
            var oldArrayCollection:ArrayCollection = ChildCollectionCache.fetch(node) as ArrayCollection;
            if (!oldArrayCollection)
            {
                childrenCollection = new ArrayCollection(children);
                ChildCollectionCache.put(node, childrenCollection);
            }
            else
            {
                childrenCollection = oldArrayCollection;
                ArrayCollection(childrenCollection).dispatchResetEvent = false;
                ArrayCollection(childrenCollection).source = children;
            }
            
        }
        else if (children is XMLList)
        {
            var oldXMLCollection:XMLListCollection = ChildCollectionCache.fetch(node) as XMLListCollection;
            if (!oldXMLCollection)
            {
                // double check since XML as dictionary keys is inconsistent
                for each (var p:* in ChildCollectionCache.keys)
                {
                    if (p === node)
                    {
                        oldXMLCollection = ChildCollectionCache.fetch(p) as XMLListCollection;
                        break;
                    }
                }
            }

            if (!oldXMLCollection)
            {
                childrenCollection =  new XMLListCollection(children);
                ChildCollectionCache.put(node, childrenCollection);
            }
            else
            {
                childrenCollection = oldXMLCollection;
                
                //We don't want to send a RESET type of collectionChange event in this case. 
                XMLListCollection(childrenCollection).dispatchResetEvent = false; 
                XMLListCollection(childrenCollection).source = children;
            }
        }
        else
        {
            var childArray:Array = new Array(children);
            if (childArray != null)
            {
                childrenCollection =  new ArrayCollection(childArray);
            }
        }
        return childrenCollection;
    }
    
    /**
     *  Determines if the node actually has children. 
     * 
     *  @param node The node object currently being evaluated.
     *  @param model The collection that contains the node; ignored by this class.
     *  
     *  @return <code>true</code> if this node currently has children.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function hasChildren(node:Object, model:Object = null):Boolean
    {
        if (node == null) 
            return false;
            
        //This default impl can't optimize this call to getChildren
        //since we can't make any assumptions by type.  Custom impl's
        //can probably avoid this call and reduce the number of calls to 
        //getChildren if need be. 
        var children:ICollectionView = getChildren(node, model);
        try 
        {
            if (children.length > 0)
                return true;
        }
        catch(e:Error)
        {
        }
        return false;
    }

    /**
     *  Tests a node for termination.
     *  Branches are non-terminating but are not required to have any leaf nodes.
     *  If the node is XML, returns <code>true</code> if the node has children
     *  or a <code>true isBranch</code> attribute.
     *  If the node is an object, returns <code>true</code> if the node has a
     *  (possibly empty) <code>children</code> field.
     *
     *  @param node The node object currently being evaluated.
     *  @param model The collection that contains the node; ignored by this class.
     *  
     *  @return <code>true</code> if this node is non-terminating.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function isBranch(node:Object, model:Object = null):Boolean
    {
        if (node == null)
            return false;
            
        var branch:Boolean = false;
            
        if (node is XML)
        {
            var childList:XMLList = node.children();
            //accessing non-required e4x attributes is quirky
            //but we know we'll at least get an XMLList
            var branchFlag:XMLList = node.@isBranch;
            //check to see if a flag has been set
            if (branchFlag.length() == 1)
            {
                //check flag and return (this flag overrides termination status)
                if (branchFlag[0] == "true")
                    branch = true;
            }
            //since no flags, we'll check to see if there are children
            else if (childList.length() != 0)
            {
                branch = true;
            }
        }
        else if (node is Object)
        {
            try
            {
                if (node.children != undefined)
                {
                    branch = true;
                }
            }
            catch(e:Error)
            {
            }
        }
        return branch;
    }

    /**
     *  Returns a node's data.
     *  Currently returns the entire node.
     *
     *  @param node The node object currently being evaluated.
     *  @param model The collection that contains the node; ignored by this class.
     *  @return The node.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getData(node:Object, model:Object = null):Object
    {
        return Object(node);
    }

    /**
     *  Add a child node to a node at the specified index. 
     *  This implementation does the following:
     * 
     *  <ul>
     *      <li>If the <code>parent</code> parameter is null or undefined,
     *          inserts the <code>child</code> parameter at the 
     *          specified index in the collection specified by <code>model</code>
     *          parameter.
     *      </li>
     *      <li>If the <code>parent</code> parameter has a <code>children</code>
     *          field or property, the method adds the <code>child</code> parameter
     *          to it at the <code>index</code> parameter location.
     *          In this case, the <code>model</code> parameter is not required.
     *     </li>
     *     <li>If the <code>parent</code> parameter does not have a <code>children</code>
     *          field or property, the method adds the <code>children</code> 
     *          property to the <code>parent</code>. The method then adds the 
     *          <code>child</code> parameter to the parent at the 
     *          <code>index</code> parameter location. 
     *          In this case, the <code>model</code> parameter is not required.
     *     </li>
     *     <li>If the <code>index</code> value is greater than the collection 
     *         length or number of children in the parent, adds the object as
     *         the last child.
     *     </li>
     * </ul>
     *
     *  @param parent The node object that will parent the child.
     *  @param newChild The node object that will be parented by the node.
     *  @param index The 0-based index of where to put the child node relative to the parent.
     *  @param model The entire collection that this node is a part of.
     *  
     *  @return <code>true</code> if successful.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function addChildAt(parent:Object, newChild:Object, index:int, model:Object = null):Boolean
    {
        if (!parent)
        {
            try
            {
                if (index > model.length)
                    index = model.length;
                if (model is IList)
                    IList(model).addItemAt(newChild, index);
                else
                {
                    var cursor:IViewCursor = model.createCursor();
                    cursor.seek(CursorBookmark.FIRST, index);
                    cursor.insert(newChild);
                }

                return true;
            }
            catch(e:Error)
            {
            }
        }
        else 
        {
            var children:ICollectionView = ICollectionView(getChildren(parent, model));
            if (!children)
            {
                if (parent is XML)
                {
                    var temp:XMLList = new XMLList();
                    XML(parent).appendChild(temp);
                    children = new XMLListCollection(parent.children());
                }
                else if (parent is Object)
                {
                    parent.children = new ArrayCollection();
                    children = parent.children;
                }
            }
            try
            {
                if (index > children.length)
                    index = children.length;
                if (children is IList)
                    IList(children).addItemAt(newChild, index);
                else
                {
                    cursor = children.createCursor();
                    cursor.seek(CursorBookmark.FIRST, index);
                    cursor.insert(newChild);
                }
                return true;
            }
            catch(e:Error)
            {
            }
        }
        return false;
    }

    /**
     *  Removes the child node from a node at the specified index.
     *  If the <code>parent</code> parameter is null 
     *  or undefined, the method uses the <code>model</code> parameter to 
     *  access the child; otherwise, it uses the <code>parent</code> parameter
     *  and ignores the <code>model</code> parameter.
    *
     *  @param parent The node object that currently parents the child node.
     *  @param child The node that is being removed.
     *  @param index The 0-based index of  the child node to remove relative to the parent.
     *  @param model The entire collection that this node is a part of.
     *  
     *  @return <code>true</code> if successful.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function removeChildAt(parent:Object, child:Object, index:int, model:Object = null):Boolean
    {
        //handle top level where there is no parent
        if (!parent)
        {
            try
            {
                if (index > model.length)
                    index = model.length;
                if (model is IList)
                    model.removeItemAt(index);
                else
                {
                    var cursor:IViewCursor = model.createCursor();
                    cursor.seek(CursorBookmark.FIRST, index);
                    cursor.remove();
                }

                return true;
            }
            catch(e:Error)
            {
            }
        }
        else
        {
            var children:ICollectionView = ICollectionView(getChildren(parent, model));
            try
            {
                if (index > children.length)
                    index = children.length;
                if (children is IList)
                    IList(children).removeItemAt(index);
                else
                {
                    cursor = children.createCursor();
                    cursor.seek(CursorBookmark.FIRST, index);
                    cursor.remove();
                }

                return true;
            }
            catch(e:Error)
            {
            }
        }
        return false;
    }

    /**
     *  Returns the type identifier of a node.
     *  This method is used by menu-based controls to determine if the
     *  node represents a separator, radio button,
     *  a check box, or normal item.
     *
     *  @param node The node object for which to get the type.
     *  
     *  @return  The value of the <code>type</code> attribute or field,
     *  or the empty string if there is no such field.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getType(node:Object):String
    {
        if (node is XML)
        {
            return String(node.@type);
        }
        else if (node is Object)
        {
            try
            {
                return String(node.type);
            }
            catch(e:Error)
            {
            }
        }
        return "";
    }

    /**
     *  Returns whether the node is enabled.
     *  This method is used by menu-based controls.
     *
     *  @param node The node for which to get the status.
     *  
     *  @return The value of the node's <code>enabled</code>
     *  attribute or field, or <code>true</code> if there is no such
     *  entry or the value is not <code>false</code>.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function isEnabled(node:Object):Boolean
    {
        var enabled:*;
        if (node is XML)
        {
            enabled = node.@enabled;
            if (String(enabled[0]) == "false")
                return false;
        }
        else if (node is Object)
        {
            try
            {
                return !("false" == String(node.enabled))
            }
            catch(e:Error)
            {
            }
        }
        return true;
    }

    /**
     *  Sets the value of the field or attribute in the data provider
     *  that identifies whether the node is enabled.
     *  This method sets the value of the node's <code>enabled</code>
     *  attribute or field.
     *  This method is used by menu-based controls.
     *
     *  @param node The node for which to set the status.
     *  @param value Whether the node is enabled.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function setEnabled(node:Object, value:Boolean):void
    {
        if (node is XML)
        {
            node.@enabled = value;
        }
        else if (node is Object)
        {
            try
            {
                node.enabled = value;
            }
            catch(e:Error)
            {
            }
        }
    }

    /**
     *  Returns whether the node is toggled.
     *  This method is used by menu-based controls.
     *
     *  @param node The node for which to get the status.
     *  
     *  @return The value of the node's <code>toggled</code>
     *  attribute or field, or <code>false</code> if there is no such
     *  entry.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function isToggled(node:Object):Boolean
    {
        if (node is XML)
        {
            var toggled:* = node.@toggled;
            if (toggled[0] == true)
                return true;
        }
        else if (node is Object)
        {
            try
            {
                return Boolean(node.toggled);
            }
            catch(e:Error)
            {
            }
        }
        return false;
    }

    /**
     *  Sets the value of the field or attribute in the data provider
     *  that identifies whether the node is toggled.
     *  This method sets the value of the node's <code>toggled</code>
     *  attribute or field.
     *  This method is used by menu-based controls.
     *
     *  @param node The node for which to set the status.
     *  @param value Whether the node is toggled.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function setToggled(node:Object, value:Boolean):void
    {
        if (node is XML)
        {
            node.@toggled = value;
        }
        else if (node is Object)
        {
            try
            {
                node.toggled = value;
            }
            catch(e:Error)
            {
            }
        }
    }

    /**
     *  Returns the name of the radio button group to which
     *  the node belongs, if any.
     *  This method is used by menu-based controls.
     *
     *  @param node The node for which to get the group name.
     *  @return The value of the node's <code>groupName</code>
     *  attribute or field, or an empty string if there is no such
     *  entry.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getGroupName(node:Object):String
    {
        if (node is XML)
        {
            return node.@groupName;
        }
        else if (node is Object)
        {
            try
            {
                return node.groupName;
            }
            catch(e:Error)
            {
            }
        }
        return "";
    }
    
    //--------------------------------------------------------------------------
	//  dataDescriptor
	//--------------------------------------------------------------------------
	
	/**
	 *  @private
	 */
	private var _dataDescriptor:IMenuDataDescriptor;
	
	/**
	 *  The object that accesses and manipulates data in the data provider. 
	 *  The Menu control delegates to the data descriptor for information 
	 *  about its data. This data is then used to parse and move about the 
	 *  data source. The data descriptor defined for the root menu is used 
	 *  for all submenus. 
	 * 
	 *  The default value is an internal instance of the
	 *  DefaultDataDescriptor class.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get dataDescriptor():IMenuDataDescriptor
	{
		return _dataDescriptor || IMenuDataDescriptor(_dataDescriptor = new DefaultDataDescriptor());
	}
	
	/**
	 *  @private
	 */
	public function set dataDescriptor(value:IMenuDataDescriptor):void
	{
		_dataDescriptor = value;
	}

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getHierarchicalCollectionAdaptor(hierarchicalData:ICollectionView, 
                                                uidFunction:Function, 
                                                openItems:Object,
                                                model:Object = null):ICollectionView
    {
        return new HierarchicalCollectionView(hierarchicalData,
                                                this,
                                                uidFunction,
                                                openItems);
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getNodeDepth(node:Object, iterator:IViewCursor, model:Object = null):int
    {
        if (node == iterator.current)
            return HierarchicalViewCursor(iterator).currentDepth;
        return -1;
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getParent(node:Object, collection:ICollectionView, model:Object = null):Object
    {
        return HierarchicalCollectionView(collection).getParentItem(node);
    }
}

}

COMPILE::SWF
{
import flash.utils.Dictionary;
}

class CollectionCache
{
    COMPILE::SWF
    private var cache:Dictionary = new Dictionary(true);
    
    // use Object.defineProperty some day to block iteration of this property?
    private var propName:String = "__CollectionCache__";
    
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

    public function get keys():Array
    {
        var output:Array = [];
        COMPILE::SWF
        {
            for (var p:* in cache)
            {
                output.push(p);
            }
        }
        // for JS, assume we won't ever need to produce the keys since
        // the runtime shouldn't be messing with XML node instances
        return output;
    }
}
