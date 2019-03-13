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


/**
 *  Hierarchical data is data already in a structure of parent and child data items.
 *  The HierarchicalData class provides a default implementation for
 *  accessing and manipulating data for use in controls such as the AdvancedDataGrid control.
 *  To configure the AdvancedDataGrid control to display hierarchical data, 
 *  you pass to the <code>dataProvider</code> property an instance of the HierarchicalData class.
 *
 *  This implementation handles E4X, XML, and Object nodes in similar but different
 *  ways. See each method description for details on how the method
 *  accesses values in nodes of various types.
 *
 *  @see mx.controls.AdvancedDataGrid
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class HierarchicalData  extends EventDispatcher implements IHierarchicalData
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
     *  @param value The data used to populate the HierarchicalData instance.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function HierarchicalData(value:Object = null)
    {
        super();
        
        source = value;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //--------------------------------------------------------------------------
    // childrenField
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     *  The field name to be used to detect children field.
     */
    private var _childrenField:String = "children";
    
    /**
     *  Indicates the field name to be used to detect children objects in
     *  a data item. 
     *  By default, all subnodes are considered as children for 
     *  XML data, and the <code>children</code> property is used for the Object data type.
     *
     *  This is helpful in adapting to a data format that uses custom data fields
     *  to represent children.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get childrenField():String
    {
        return _childrenField;
    }
    
    /**
     *  @private
     */
    public function set childrenField(value:String):void
    {
        _childrenField = value;
    }
    
    //--------------------------------------------------------------------------
    // source
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     *  The source collection.
     */
    private var _source:Object;
    
    /**
     *  The source collection.
     *  The collection should implement the IList interface 
     *  to facilitate operation like the addition and removal of items.
     *
     *  @see mx.collections.IList
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get source():Object
    {
        return _source;
    }
    
    /**
     *  @private
     */
    public function set source(value:Object):void
    {
        _source = value;
        
        var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
        event.kind = CollectionEventKind.RESET;
        dispatchEvent(event);
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
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
    public function canHaveChildren(node:Object):Boolean
    {
        if (node == null)
            return false;
            
        var branch:Boolean = false;
            
        if (node is XML)
        {
            var childList:XMLList = childrenField == "children" ? node.children() : node.child(childrenField).children();
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
                if (node[childrenField] != undefined)
                {
                    branch = true;
                }
            }
            catch (e:Error)
            {
            }
        }
        return branch;
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getChildren(node:Object):Object
    {
        if (node == null)
            return null;
            
        var children:*;
        
        //first get the children based on the type of node. 
        if (node is XML)
        {
            children = childrenField == "children" ? (node as XML).* : (node.child(childrenField) as XML).*;
        }
        else if (node is Object)
        {
            //we'll try the default children property
            try
            {
                children = node[childrenField];
            }
            catch (e:Error)
            {
            }
        }
        
        //no children exist for this node 
        if(children === undefined)
            return null;
        
        return children;
    }
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function hasChildren(node:Object):Boolean
    {
        if (node == null) 
            return false;
            
        //This default impl can't optimize this call to getChildren
        //since we can't make any assumptions by type.  Custom impl's
        //can probably avoid this call and reduce the number of calls to 
        //getChildren if need be. 
        var children:Object = getChildren(node);
        try 
        {
            if(children is XMLList || children is XML)
            {
                if (children.length() > 0)
                    return true;
            }
            
            if (children.length > 0)
                return true;
        }
        catch (e:Error)
        {
        }
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
    public function getData(node:Object):Object
    {
        return Object(node);
    }
    
    /**
     * @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */ 
    public function getRoot():Object
    {
        return source;
    }

}

}
