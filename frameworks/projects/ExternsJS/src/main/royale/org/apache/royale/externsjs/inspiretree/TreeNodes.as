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
package org.apache.royale.externsjs.inspiretree
{
	COMPILE::JS
    {
        import org.apache.royale.externsjs.inspiretree.TreeNode;
        import org.apache.royale.externsjs.inspiretree.InspireTree;
    }

	/**
	 * @externs
	 */
	COMPILE::JS
	public class TreeNodes
    {
        /**
         * An Array-like collection of TreeNodes.
         *
         * Note: Due to issue in many javascript environments,
         * native objects are problematic to extend correctly
         * so we mimic it, not actually extend it.
         *
         * @param {InspireTree} tree Context tree.
         * @param {array} array Array of TreeNode objects.
         * @param {object} opts Configuration object.
         * @return {TreeNodes} Collection of TreeNode
        */
        public function TreeNodes(tree:InspireTree, array:Array, opts:Object){
		}
        
        /**
         * Adds a new node. If a sort method is configured,
         * the node will be added in the appropriate order.
         *
         * @param {object} object Node
         * @return {TreeNode} Node object.
         */
        public function addNode(object:Object):TreeNode { return null; }

        /**
         * Query for all available nodes.
         *
         * @param {boolean} full Retain full hiearchy.
         * @return {TreeNodes} Array of node objects.
         */
        public function available(full:Boolean):TreeNodes { return null; }
	
        /**
         * Blur nodes.
         *
         * @return {TreeNodes} Array of node objects.
         */
        public function blur():TreeNodes { return null; }

        /**
         * Blur (deeply) all nodes.
         *
         * @return {TreeNodes} Array of node objects.
         */
        public function blurDeep():TreeNodes { return null; }

        /**
         * Query for all checked nodes.
         *
         * @param {boolean} full Retain full hiearchy.
         * @return {TreeNodes} Array of node objects.
         */
        public function checked(full:Boolean):TreeNodes { return null; }

        /**
         * Clean nodes.
         *
         * @return {TreeNodes} Array of node objects.
         */
        public function clean():TreeNodes { return null; }

        /**
         * Clones (deeply) the array of nodes.
         *
         * Note: Cloning will *not* clone the context pointer.
         *
         * @return {TreeNodes} Array of cloned nodes.
         */
        public function clone():TreeNodes { return null; }

        /**
         * Collapse nodes.
         *
         * @return {TreeNodes} Array of node objects.
         */
        public function collapse():TreeNodes  { return null; }

        /**
         * Query for all collapsed nodes.
         *
         * @param {boolean} full Retain full hiearchy.
         * @return {TreeNodes} Array of node objects.
         */
        public function collapsed(full:Boolean):TreeNodes  { return null; }

        /**
         * Collapse (deeply) all children.
         *
         * @return {TreeNodes} Array of node objects.
         */
        public function collapseDeep():TreeNodes  { return null; }

        /**
         * Concat multiple TreeNodes arrays.
         *
         * @param {TreeNodes} nodes Array of nodes.
         * @return {TreeNodes} Resulting node array.
         */
        public function concat(nodes:Array):TreeNodes { return null; }
        
        /**
         * Get the context of this collection. If a collection
         * of children, context is the parent node. Otherwise
         * the context is the tree itself.
         *
         * @return {TreeNode|object} Node object or tree instance.
         */
        public function context():Object { return null; }
        
        /**
         * Copy nodes to another tree instance.
         *
         * @param {object} dest Destination Inspire Tree.
         * @param {boolean} hierarchy Include necessary ancestors to match hierarchy.
         * @param {boolean} includeState Include itree.state object.
         * @return {object} Methods to perform action on copied nodes.
         */
        public function copy(dest:Object, hierarchy:Boolean, includeState:Boolean):Object { return null; }
        
        /**
         * Return deepest nodes.
         *
         * @return {TreeNodes} Array of node objects.
         */
        public function deepest():TreeNodes { return null; }
        
        /**
         * Deselect nodes.
         *
         * @return {TreeNodes} Array of node objects.
         */
        public function deselect():TreeNodes { return null; }
        
        /**
         * Deselect (deeply) all nodes.
         *
         * @return {TreeNodes} Array of node objects.
         */
        public function deselectDeep():TreeNodes { return null; }
        
        /**
         * Iterate each TreeNode.
         *
         * @param {function} iteratee Iteratee invoke for each node.
         * @return {TreeNodes} Array of node objects.
         */
        public function each(iteratee:Function):TreeNodes { return null; }
        
        /**
         * Query for all editable nodes.
         *
         * @param {boolean} full Retain full hiearchy.
         * @return {TreeNodes} Array of node objects.
         */
        public function editable(full:Boolean):TreeNodes { return null; }
        
        /**
         * Query for all nodes in editing mode.
         *
         * @param {boolean} full Retain full hiearchy.
         * @return {TreeNodes} Array of node objects.
         */
        public function editing(full:Boolean):TreeNodes { return null; }
        
        /**
         * Expand nodes.
         *
         * @return {TreeNodes} Array of node objects.
         */
        public function expand():TreeNodes { return null; }
        
        /**
         * Query for all expanded nodes.
         *
         * @param {boolean} full Retain full hiearchy.
         * @return {TreeNodes} Array of node objects.
         */
        public function expanded(full:Boolean):TreeNodes { return null; }
        
        /**
         * Expand (deeply) all nodes.
         *
         * @return {Promise<TreeNodes>} Promise resolved when all children have loaded and expanded.
         */
        public function expandDeep():Promise.<TreeNodes> { return null; }
        
        /**
         * Expand parents.
         *
         * @return {TreeNodes} Array of node objects.
         */
        public function expandParents():TreeNodes { return null; }
        
        /**
         * Clone a hierarchy of all nodes matching a predicate.
         *
         * Because it filters deeply, we must clone all nodes so that we
         * don't affect the actual node array.
         *
         * @param {string|function} predicate State flag or custom function. ¿?
         * @return {TreeNodes} Array of node objects.
         */
        public function extract(predicate:Function):TreeNodes { return null; }
        
        /**
         * Filter all nodes matching the given predicate.
         *
         * @param {string|function} predicate State flag or custom function.
         * @return {TreeNodes} Array of node objects.
         */
        public function filterBy(predicate:Function):TreeNodes { return null; }
        
        /**
         * Returns the first node matching predicate.
         *
         * @param {function} predicate Predicate function, accepts a single node and returns a boolean.
         * @return {TreeNode} First matching TreeNode, or undefined.
         */
        public function find(predicate:Function):TreeNode { return null; }
        
        /**
         * Returns the first shallow node matching predicate.
         *
         * @param {function} predicate Predicate function, accepts a single node and returns a boolean.
         * @return {TreeNode} First matching TreeNode, or undefined.
         */
        public function first(predicate:Function):TreeNode { return null; }
        
        /**
         * Flatten and get only node(s) matching the expected state or predicate function.
         *
         * @param {string|function} predicate State property or custom function.¿?
         * @return {TreeNodes} Flat array of matching nodes.
         */
        public function flatten(predicate:Function):TreeNodes { return null; }
        
        /**
         * Query for all focused nodes.
         *
         * @param {boolean} full Retain full hiearchy.
         * @return {TreeNodes} Array of node objects.
         */
        public function focused(full:Boolean):TreeNodes { return null; }
        
        /**
         * Iterate each TreeNode.
         *
         * @param {function} iteratee Iteratee invoke for each node.
         * @return {TreeNodes} Array of node objects.
         */
        public function forEach(iteratee:Function):TreeNodes { return null; }
        
        /**
         * Get a specific node by its index, or undefined if it doesn't exist.
         *
         * @param {int} index Numeric index of requested node.
         * @return {TreeNode} Node object. Undefined if invalid index.
         */
        public function get(index:int):TreeNode { return null; }
        
        /**
         * Query for all hidden nodes.
         *
         * @param {boolean} full Retain full hiearchy.
         * @return {TreeNodes} Array of node objects.
         */
        public function hidden(full:Boolean):TreeNodes { return null; }
        
        /**
         * Hide nodes.
         *
         * @return {TreeNodes} Array of node objects.
         */
        public function hide():TreeNodes { return null; }
        
        /**
         * Hide (deeply) all nodes.
         *
         * @return {TreeNodes} Array of node objects.
         */
        public function hideDeep():TreeNodes { return null; }
        
        /**
         * Query for all indeterminate nodes.
         *
         * @param {boolean} full Retain full hiearchy.
         * @return {TreeNodes} Array of node objects.
         */
        public function indeterminate(full:Boolean):TreeNodes { return null; }
        
        /**
         * Insert a new node at a given position.
         *
         * @param {integer} index Index at which to insert the node.
         * @param {object} object Raw node object or TreeNode.
         * @return {TreeNode} Node object.
         */
        public function insertAt(index:int, object:Object):TreeNode { return null; }
        
        /**
         * Invoke method(s) on each node.
         *
         * @param {string|array} methods Method name(s).
         * @param {array|Arguments} args Array of arguments to proxy.
         * @return {TreeNodes} Array of node objects.
         */
        public function invoke(methods:Array, args:Array):TreeNodes { return null; }
        
        /**
         * Invoke method(s) deeply.
         *
         * @param {string|array} methods Method name(s).
         * @param {array|Arguments} args Array of arguments to proxy.
         * @return {TreeNodes} Array of node objects.
         */
        public function invokeDeep(methods:Array, args:Array):TreeNodes { return null; }
        
        /**
         * Returns the last shallow node matching predicate.
         *
         * @param {function} predicate Predicate function, accepts a single node and returns a boolean.
         * @return {TreeNode} Last matching shallow TreeNode, or undefined.
         */
        public function last(predicate:Function):TreeNode { return null; }
        
        /**
         * Query for all nodes currently loading children.
         *
         * @param {boolean} full Retain full hiearchy.
         * @return {TreeNodes} Array of node objects.
         */
        public function loading(full:Boolean):TreeNodes { return null; }
        
        /**
         * Loads additional nodes for this context.
         *
         * @param {Event} event Click or scroll event if DOM interaction triggered this call.
         * @return {Promise<TreeNodes>} Resolves with request results.
         */
        public function loadMore(event:Event):Promise.<TreeNodes> { return null; }
        /**
         * Query for all nodes matched in the last search.
         *
         * @param {boolean} full Retain full hiearchy.
         * @return {TreeNodes} Array of node objects.
         */
        public function matched(full:Boolean):TreeNodes { return null; }
        
        /**
         * Move node at a given index to a new index.
         *
         * @param {int} index Current index.
         * @param {int} newIndex New index.
         * @param {TreeNodes} target Target TreeNodes array. Defaults to this.
         * @return {TreeNode} Node object.
         */
        public function move(index:int, newIndex:int, target:TreeNodes):TreeNode { return null; }
        
        /**
         * Get a node.
         *
         * @param {string|number} id ID of node.
         * @return {TreeNode} Node object.
         */
        public function node(id:String):TreeNode { return null; }
        
        /**
         * Get all nodes in a tree, or nodes for an array of IDs.
         *
         * @param {array} refs Array of ID references.
         * @return {TreeNodes} Array of node objects.
         * @example
         *
         * const all = tree.nodes()
         * const some = tree.nodes([1, 2, 3])
         */
        public function nodes(refs:Array):TreeNodes { return null; }
        
        /**
         * Get the pagination.
         *
         * @return {object} Pagination configuration object.
         */
        public function pagination():Object { return null; }
        
        /**
         * Removes the last node.
         *
         * @return {TreeNode} Last tree node.
         */
        public function pop():TreeNode { return null; }
        
        /**
         * Push a new TreeNode onto the collection.
         *
         * @param {TreeNode} node Node objext.
         * @returns {number} The new length.
         */
        public function push(node:TreeNode):Number { return null; }

        /**
         * Iterate down all nodes and any children.
         *
         * Return false to stop execution.
         *
         * @param {function} iteratee Iteratee function.
         * @return {TreeNodes} Resulting nodes.
         */
        public function recurseDown(iteratee:Function):TreeNodes { return null; }
        
        /**
         * Remove a node.
         *
         * @param {TreeNode} node Node object.
         * @return {TreeNodes} Resulting nodes.
         */
        public function remove(node:TreeNode):TreeNodes { return null; }
        
        /**
         * Query for all soft-removed nodes.
         *
         * @param {boolean} full Retain full hiearchy.
         * @return {TreeNodes} Array of node objects.
         */
        public function removed(full:Boolean):TreeNodes { return null; }
        
        /**
         * Restore nodes.
         *
         * @return {TreeNodes} Array of node objects.
         */
        public function restore():TreeNodes { return null; }
        
        /**
         * Restore (deeply) all nodes.
         *
         * @return {TreeNodes} Array of node objects.
         */
        public function restoreDeep():TreeNodes { return null; }
        
        /**
         * Select nodes.
         *
         * @return {TreeNodes} Array of node objects.
         */
        public function select():TreeNodes { return null; }
        
        /**
         * Query for all selectable nodes.
         *
         * @param {boolean} full Retain full hiearchy.
         * @return {TreeNodes} Array of node objects.
         */
        public function selectable(full:Boolean):TreeNodes { return null; }
        
        /**
         * Select (deeply) all nodes.
         *
         * @return {TreeNodes} Array of node objects.
         */
        public function selectDeep():TreeNodes { return null; }
        
        /**
         * Query for all selected nodes.
         *
         * @param {boolean} full Retain full hiearchy.
         * @return {TreeNodes} Array of node objects.
         */
        public function selected(full:Boolean):TreeNodes { return null; }
        
        /**
         * Removes the first node.
         *
         * @param {TreeNode} node Node object.
         * @return {TreeNode} Node object.
         */
        public function shift(node:TreeNode):TreeNode { return null; }
        
        /**
         * Show nodes.
         *
         * @return {TreeNodes} Array of node objects.
         */
        public function show():TreeNodes { return null; }
        
        /**
         * Show (deeply) all nodes.
         *
         * @return {TreeNodes} Array of node objects.
         */
        public function showDeep():TreeNodes { return null; }
        
        /**
         * Soft-remove nodes.
         *
         * @return {TreeNodes} Array of node objects.
         */
        public function softRemove():TreeNodes { return null; }
        
        /**
         * Sorts all TreeNode objects in this collection.
         *
         * If no custom sorter given, the configured "sort" value will be used.
         *
         * @param {string|function} sorter Sort function or property name. ¿?
         * @return {TreeNodes} Array of node objects.
         */
        public function sortBy(sorter:Function):TreeNodes { return null; }
        
        /**
         * Sorts (deeply) all nodes in this collection.
         *
         * @param {function} comparator [description]
         * @return {TreeNodes} Array of node objects.
         */
        public function sortDeep(comparator:Function):TreeNodes { return null; }
        
        /**
         * Changes array contents by removing existing nodes and/or adding new nodes.
         *
         * @param {number} start Start index.
         * @param {number} deleteCount Number of nodes to delete.
         * @param {TreeNode} ...nodes One or more nodes.
         * @return {array} Array of deleted elements.
         */
        public function splice():Array { return null; }
        
        /**
         * Set nodes' state values.
         *
         * @param {string} name Property name.
         * @param {boolean} newVal New value, if setting.
         * @return {TreeNodes} Array of node objects.
         */
        public function state():TreeNodes { return null; }
        
        /**
         * Set (deeply) nodes' state values.
         *
         * @param {string} name Property name.
         * @param {boolean} newVal New value, if setting.
         * @return {TreeNodes} Array of node objects.
         */
        public function stateDeep():TreeNodes { return null; }
        
        /**
         * Swaps two node positions.
         *
         * @param {TreeNode} node1 Node 1.
         * @param {TreeNode} node2 Node 2.
         * @return {TreeNodes} Array of node objects.
         */
        public function swap(node1:TreeNode, node2:TreeNode):TreeNodes { return null; }
        
        /**
         * Get the tree instance.
         *
         * @return {InspireTree} Tree instance.
         */
        public function tree():InspireTree { return null; }
        
        /**
         * Get a native node Array.
         *
         * @return {array} Array of node objects.
         */
        public function toArray():Array { return null; }
        
        /**
         * Adds a node to beginning of the collection.
         *
         * @param {TreeNode} node Node object.
         * @return {number} New length of collection.
         */
        public function unshift(node:TreeNode):Number { return null; }
        
        /**
         * Query for all visible nodes.
         *
         * @param {boolean} full Retain full hiearchy.
         * @return {TreeNodes} Array of node objects.
         */
        public function visible(full:Boolean):TreeNodes { return null; }
	
        
	}
	
}