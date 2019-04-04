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

package spark.components.gridClasses
{

import mx.collections.ArrayCollection;

[ExcludeClass]

/**
 *  Open LinkedList implementation for representing row heights in a Grid
 *  where each GridRowNode represents a row in the Grid.
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.0
 *  @productversion Flex 4.5
 */
public class GridRowList
{
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    private var _head:GridRowNode;
    private var _tail:GridRowNode;
    private var _length:Number = 0;
    
    private var recentNode:GridRowNode;
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Constructor. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function GridRowList():void
    {
        super();
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  first
    //----------------------------------
    
    /**
     *  First node in list.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function get first():GridRowNode
    {
        return _head;
    }
    
    //----------------------------------
    //  last
    //----------------------------------
    
    /**
     *  Last node in list.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function get last():GridRowNode
    {
        return _tail;
    }
    
    //----------------------------------
    //  tail
    //----------------------------------
    
    /**
     *  Node representing tail of the list.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function get tail():GridRowNode
    {
        return _tail;
    }
    
    //----------------------------------
    //  head
    //----------------------------------
    
    /**
     *  Node representing head of the list.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function get head():GridRowNode
    {
        return _head;
    }
    
    //----------------------------------
    //  length
    //----------------------------------
    
    /**
     *  Returns length of list.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function get length():Number
    {
        return _length;
    }
    
    //----------------------------------
    //  numColumns
    //----------------------------------
    
    private var _numColumns:uint = 0;

    /**
     *  Returns number of columns per row.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function get numColumns():uint
    {
        return _numColumns;
    }
    
    /**
     *  @private
     */
    public function set numColumns(value:uint):void
    {
        if (_numColumns == value)
            return;
        
        _numColumns = value;
        
        var cur:GridRowNode = _head;
        while (cur)
        {
            cur.numColumns = value;
            cur = cur.next;
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Inserts new node at the specified row index. If a node with the
     *  index already exists, it will be returned.
     * 
     *  @param index The row index in which to create and insert the node.
     *  
     *  @return The newly created or existing node for the specified row index.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function insert(index:int):GridRowNode
    {
        // empty list
        if (_head == null)
        {
            _head = new GridRowNode(numColumns, index);
            _tail = _head;
            _length++;
            return _head;
        }
        
        // This part can be optimized by a better search mechanism
        // Bookmarks, LRU node...etc...
        var cur:GridRowNode = findNearestLTE(index);
        if (cur && cur.rowIndex == index)
            return cur;
        
        var newNode:GridRowNode = new GridRowNode(numColumns, index);
        
        // index is before head.
        if (!cur)
            insertBefore(_head, newNode);
        else // index is after cur.
            insertAfter(cur, newNode);
        
        recentNode = newNode;
        
        return newNode;
    }
    
    /**
     *  Inserts a new node after the specified node. Returns
     *  the new node.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function insertAfter(node:GridRowNode, newNode:GridRowNode):void
    {
        newNode.prev = node;
        newNode.next = node.next;
        if (node.next == null)
            _tail = newNode;
        else
            node.next.prev = newNode;
        node.next = newNode;
        
        _length++;
    }
    
    /**
     *  Inserts a new node after the specified node. Returns
     *  the new node.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function insertBefore(node:GridRowNode, newNode:GridRowNode):void
    {
        newNode.prev = node.prev;
        newNode.next = node;
        if (node.prev == null)
            _head = newNode;
        else
            node.prev.next = newNode;
        node.prev = newNode;
        
        _length++;
    }
    
    /**
     *  Searches through all nodes for the given row index.
     * 
     *  @param index The row index to find.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function find(index:int):GridRowNode
    {
        // use bookmarks? or maybe a least recently used one.
        if (!_head)
            return null;
        
        var indexToRecent:int;
        var temp:int;
        var lastToIndex:int = _tail.rowIndex - index;
        var result:GridRowNode = null;
        
        if (recentNode)
        {
            if (recentNode.rowIndex == index)
                return recentNode;
            
            indexToRecent = recentNode.rowIndex - index;
            temp = Math.abs(indexToRecent);
        }
        
        // Uses last searched node if its closest to the target.
        if (lastToIndex < 0)
        {
            return null;
        }
        else if (recentNode && temp < lastToIndex && temp < index)
        {
            if (indexToRecent > 0)
                result = findBefore(index, recentNode);
            else
                result = findAfter(index, recentNode);
        }
        else if (lastToIndex < index)
        {
            result = findBefore(index, _tail);
        }
        else
        {
            result = findAfter(index, _head);
        }
        
        if (result)
            recentNode = result;
        
        return result;
    }
    
    /**
     *  @private
     *  Searches for the given value after the specified node.
     */
    private function findAfter(index:int, node:GridRowNode):GridRowNode
    {
        var cur:GridRowNode = node;
        var result:GridRowNode = null;
        while (cur && cur.rowIndex <= index)
        {
            if (cur.rowIndex == index)
            {
                result = cur;
                break;
            }
            cur = cur.next;
        }
        return result;
    }
    
    /**
     *  @private
     *  Searches for the given value before the specified node.
     */
    private function findBefore(index:int, node:GridRowNode):GridRowNode
    {
        var cur:GridRowNode = node;
        var result:GridRowNode = null;
        while (cur && cur.rowIndex >= index)
        {
            if (cur.rowIndex == index)
            {
                result = cur;
                break;
            }
            cur = cur.prev;
        }
        return result;
    }
    
    /**
     *  Searches through all nodes for the one with a row index closest and
     *  less than equal to the specified index. If a node with the row index
     *  exists, it will just return the node at that index. Returns null if
     *  all nodes have a row index greater than the provided index.
     * 
     *  @param index The row index to find
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function findNearestLTE(index:int):GridRowNode
    {
        // use bookmarks? or maybe a least recently used one.
        if (!_head || index < 0)
            return null;
        
        var indexToRecent:int;
        var temp:int;
        var lastToIndex:int;
        var result:GridRowNode = null;
        
        if (recentNode)
        {
            if (recentNode.rowIndex == index)
                return recentNode;
            
            indexToRecent = recentNode.rowIndex - index;
            temp = Math.abs(indexToRecent);
        }
        
        lastToIndex = _tail.rowIndex - index;
        
        if (index < _head.rowIndex)
        {
            result = null;
        }
        // Uses last searched node if its closest to the target.
        else if (lastToIndex < 0)
        {
            result = _tail;
        }
        else if (recentNode && temp < lastToIndex && temp < index)
        {
            if (indexToRecent > 0)
                result = findNearestLTEBefore(index, recentNode);
            else
                result = findNearestLTEAfter(index, recentNode);
        }
        else if (lastToIndex < index)
        {
            result = findNearestLTEBefore(index, _tail);
        }
        else
        {
            result = findNearestLTEAfter(index, _head);
        }
        
        recentNode = result;
        
        return result;
    }
    
    /**
     *  @private
     *  Searches through all nodes for the one with a row index closest and
     *  less than equal to the specified index. Searches forwards from the specified node.
     */
    private function findNearestLTEAfter(index:int, node:GridRowNode):GridRowNode
    {
        var cur:GridRowNode = node;
        while (cur && cur.rowIndex < index)
        {
            if (cur.next == null)
                break;
            else if (cur.next.rowIndex > index)
                break;
            
            cur = cur.next;
        }
        return cur;
    }
    
    /**
     *  @private
     *  Searches through all nodes for the one with a row index closest and
     *  less than equal to the specified index. Searches backwards from the specified node.
     */
    private function findNearestLTEBefore(index:int, node:GridRowNode):GridRowNode
    {
        var cur:GridRowNode = node;
        while (cur && cur.rowIndex > index)
        {
            cur = cur.prev;
        }
        return cur;
    }
    
    /**
     *  Inserts the specified node at the end of the list.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function push(node:GridRowNode):void
    {
        if (_tail)
        {
            node.prev = _tail;
            node.next = null;
            _tail.next = node;
            _tail = node;
            _length++;
        }
        else
        {
            node.prev = null;
            node.next = null;
            _head = node;
            _tail = node;
            _length = 1;
        }
    }
    
    /**
     *  Searches through all nodes for the given row index and
     *  removes it from the list if found.
     * 
     *  @param index The row index to remove.
     *  
     *  @return The removed node, null otherwise.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function remove(index:int):GridRowNode
    {
        var node:GridRowNode = find(index);
        if (node)
            removeNode(node);
        return node;
    }
    
    /**
     *  Removes specified node from the list.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function removeNode(node:GridRowNode):void
    {
        if (node.prev == null)
            _head = node.next;
        else
            node.prev.next = node.next;
        
        if (node.next == null)
            _tail = node.prev;
        else
            node.next.prev = node.prev;
        
        node.next = null;
        node.prev = null;
        
        if (node == recentNode)
            recentNode = null;
        
        _length--;
    }
    
    /**
     *  Removes all nodes.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function removeAll():void
    {
        this._head = null;
        this._tail = null;
        this._length = 0;
        this.recentNode = null;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods for column changes
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Inserts count number of columns into each node and
     *  increases numColumns by count.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function insertColumns(startColumn:int, count:int):void
    {
        _numColumns += count;
        
        var node:GridRowNode = first;
        while (node)
        {   
            node.insertColumns(startColumn, count);
            node = node.next;
        }
    }
    
    /**
     *  Inserts count number of columns into each node and
     *  increases numColumns by count.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function removeColumns(startColumn:int, count:int):void
    {
        _numColumns -= count;
        
        var node:GridRowNode = first;
        while (node)
        {
            node.removeColumns(startColumn, count);
            node = node.next;
        }
    }
    
    /**
     *  Moves the specified columns in each node.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function moveColumns(fromCol:int, toCol:int, count:int):void
    {
        var node:GridRowNode = first;
        while (node)
        {
            node.moveColumns(fromCol, toCol, count);
            node = node.next;
        }
    }
    
    /**
     *  Clears the column values for count number of columns in each
     *  node.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function clearColumns(startColumn:int, count:int):void
    {
        var node:GridRowNode = first;
        while (node)
        {
            node.clearColumns(startColumn, count);
            node = node.next;
        }
    }
    
    /**
     *  @private
     *  for testing;
     */
    public function toString():String
    {
        var s:String = "[ ";
        var node:GridRowNode = this.first;
        
        while (node)
        {
//            s += "max = " + node.maxCellHeight + "; index = " + node.rowIndex + "; "
//                 node.cellHeights + "\n";
            s += "(" + node.rowIndex + "," + node.maxCellHeight + ") -> ";
            node = node.next;
        }
        s += "]";
        
        return s;
    }
    
    /**
     *  @private
     *  for testing;
     */
    public function toArray():ArrayCollection
    {
        var arr:ArrayCollection = new ArrayCollection();
        var node:GridRowNode = this.first;
        var index:int = 0;
        
        while (node)
        {
            arr.addItem(node);
            node = node.next;
        }
        return arr;
    }
}
}