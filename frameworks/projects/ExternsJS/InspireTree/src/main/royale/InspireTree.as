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
package 
{
	COMPILE::JS
    {
        import TreeNode;
        import TreeNodes;
        import org.apache.royale.externsjs.inspiretree.vos.OptionsTree;
        import org.apache.royale.externsjs.inspiretree.vos.ConfigTree;
    }

	/**
	 * @externs
	 */
	COMPILE::JS
	public class InspireTree
	{
		/**
		 * <inject_script>
		 * 
		 * var script = document.createElement("script");
		 * script.setAttribute("src", "externsjs/inspiretree/inspire-tree-royale.js");
		 * document.head.appendChild(script);
         * 
		 * </inject_script>
		*/
        public function InspireTree(opts:OptionsTree){ }
		
        public var config:ConfigTree;
        public var opts:OptionsTree;
        public var model:TreeNodes; //Array
        
        public function on(type:String, listener:Function):void {};
        public function off(type:String, listener:Function):void {};

        /**
         * Adds a new node. If a sort method is configured,
         * the node will be added in the appropriate order.
         *
         * @param {object} node Node
         * @return {TreeNode} Node object.
         */
        public function addNode(node:Object):TreeNode { return null; }

        /**
         * Add nodes.
         *
         * @param {array} nodes Array of node objects.
         * @return {TreeNodes} Added node objects.
         */
        public function addNodes(nodes:Array):TreeNodes { return null; }
        
        /**
         * Release pending data changes to any listeners.
         *
         * Will skip rendering as long as any calls
         * to `batch` have yet to be resolved,
         *
         * @private
         * @return {void}
         */
        public function applyChanges():void { }
            
        /**
         * Query for all available nodes.
         *
         * @param {boolean} full Retain full hiearchy.
         * @return {TreeNodes} Array of node objects.
         */
        public function available(full:Boolean):TreeNodes { return null; }
    
        /**
         * Batch multiple changes for listeners (i.e. DOM)
         *
         * @private
         * @return {void}
         */
        public function batch():void { }
        
        /**
         * Blur children in this collection.
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
         * Compares any number of TreeNode objects and returns
         * the minimum and maximum (starting/ending) nodes.
         *
         * @return {array} Array with two TreeNode objects.
         */
        public function boundingNodes():Array { return null; }
    
        /**
         * Check if the tree will auto-deselect currently selected nodes
         * when a new selection is made.
         *
         * @return {boolean} If tree will auto-deselect nodes.
         */
        public function canAutoDeselect():Boolean { return null; }
    
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
         * Clear nodes matched by previous search, restore all nodes and collapse parents.
         *
         * @return {Tree} Tree instance.
         */
        public function clearSearch():InspireTree { return null; }

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
        public function collapse():TreeNodes { return null; }

        /**
         * Query for all collapsed nodes.
         *
         * @param {boolean} full Retain full hiearchy.
         * @return {TreeNodes} Array of node objects.
         */
        public function collapsed(full:Boolean):TreeNodes { return null; }

        /**
         * Collapse (deeply) all children.
         *
         * @return {TreeNodes} Array of node objects.
         */
        public function collapseDeep():TreeNodes { return null; }

        /**
         * Concat multiple TreeNodes arrays.
         *
         * @param {TreeNodes} nodes Array of nodes.
         * @return {TreeNodes} Resulting node array.
         */
        public function concat(nodes:TreeNodes):TreeNodes { return null; }

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
         * Creates a TreeNode without adding it. If the obj is already a TreeNode it's returned without modification.
         *
         * @param {object} obj Source node object.
         * @return {TreeNode} Node object.
         */
        public function createNode(obj:Object):TreeNode { return null; }

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
         * Disable auto-deselection of currently selected nodes.
         *
         * @return {Tree} Tree instance.
         */
        public function disableDeselection():InspireTree { return null; }

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
         * Enable auto-deselection of currently selected nodes.
         *
         * @return {Tree} Tree instance.
         */
        public function enableDeselection():InspireTree { return null; }
        
        /**
         * Release the current batch.
         *
         * @private
         * @return {void}
         */
        public function end():void { }
        
        /**
         * Check if every node passes the given test.
         *
         * @param {function} tester Test each node in this collection,
         * @return {boolean} True if every node passes the test.
         */
        public function every(tester:Function):Boolean { return null; }
    
        /**
         * Expand children.
         *
         * @return {TreeNodes} Array of node objects.
         */
        public function expand():TreeNodes { return null; }

        /**
         * Expand (deeply) all nodes.
         *
         * @return {Promise<TreeNodes>} Promise resolved when all children have loaded and expanded.
         */
        public function expandDeep():Promise.<TreeNodes> { return null; }

        /**
         * Query for all expanded nodes.
         *
         * @return {TreeNodes} Array of node objects.
         */
        public function expanded():TreeNodes { return null; }

        /**
         * Clone a hierarchy of all nodes matching a predicate.
         *
         * Because it filters deeply, we must clone all nodes so that we
         * don't affect the actual node array.
         *
         * @param {string|function} predicate State flag or custom function. ¿?
         * @return {TreeNodes} Array of node objects.
         */
        public function extract(predicate:Object):TreeNodes { return null; }

        /**
         * Filter all nodes matching the given predicate.
         *
         * @param {function} predicate Test function.
         * @return {TreeNodes} Array of node objects.
         */
        public function filter(predicate:Function):TreeNodes { return null; }

        /**
         * Filter all nodes matching the given predicate.
         *
         * @param {string|function} predicate State flag or custom function. ¿?
         * @return {TreeNodes} Array of node objects.
         */
        public function filterBy(predicate:Object):TreeNodes { return null; }

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
        public function flatten(predicate:Object):TreeNodes { return null; }

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
         * Get the index of the given node.
         *
         * @param {TreeNode} node Root tree node.
         * @return {int} Index of the node.
         */
        public function indexOf(node:TreeNode):int { return null; }

        /**
         * Insert a new node at the given position.
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
         * @return {TreeNodes} Array of node objects.
         */
        public function invoke(methods:Array):TreeNodes { return null; }

        /**
         * Invoke method(s) deeply.
         *
         * @param {string|array} methods Method name(s).
         * @return {TreeNodes} Array of node objects.
         */
        public function invokeDeep(methods:Array):TreeNodes { return null; }

        /**
         * Check if an event is currently muted.
         *
         * @param {string} eventName Event name.
         * @return {boolean} If event is muted.
         */
        public function isEventMuted(eventName:String):Boolean { return null; }
    
        /**
         * Check if an object is a Tree.
         *
         * @param {object} object Object
         * @return {boolean} If object is a Tree.
         */
        public function isTree(object:Object):Boolean { return null; }
    
        /**
         * Check if an object is a TreeNode.
         *
         * @param {object} obj Object
         * @return {boolean} If object is a TreeNode.
         */
        public static function isTreeNode(obj:Object):Boolean { return null; }
    
        /**
         * Check if an object is a TreeNodes array.
         *
         * @param {object} obj Object
         * @return {boolean} If object is a TreeNodes array.
         */
        public static function isTreeNodes(obj:Object):Boolean { return null; }

        /**
         * Join nodes into a resulting string.
         *
         * @param {string} separator Separator, defaults to a comma
         * @return {string} Strings from root node objects.
         */
        public function join(separator:String):String { return null; }

        /**
         * Returns the last shallow node matching predicate.
         *
         * @param {function} predicate Predicate function, accepts a single node and returns a boolean.
         * @return {TreeNode} Last matching shallow TreeNode, or undefined.
         */
        public function last(predicate:Function):TreeNode { return null; }

        /**
         * Get the most recently selected node, if any.
         *
         * @return {TreeNode} Last selected node, or undefined.
         */
        public function lastSelectedNode():TreeNode { return null; }

        /**
         * Load data. Accepts an array, function, or promise.
         *
         * @param {array|function|Promise} loader Array of nodes, function, or promise resolving an array of nodes.
         * @return {Promise<TreeNodes>} Promise resolved upon successful load, rejected on error.
         * @example
         *
         * tree.load($.getJSON('nodes.json'));
         */
        public function load(loader:Object):Promise.<TreeNodes> { return null; }

        /**
         * Query for all nodes currently loading children.
         *
         * @param {boolean} full Retain full hiearchy.
         * @return {TreeNodes} Array of node objects.
         */
        public function loading(full:Boolean):TreeNodes { return null; }

        /**
         * Load additional nodes for the root context.
         *
         * @param {Event} event Click or scroll event if DOM interaction triggered this call.
         * @return {Promise<TreeNodes>} Resolves with request results.
         */
        public function loadMore(event:Event):Promise.<TreeNodes> { return null; }

        /**
         * Create a new collection after passing every node through iteratee.
         *
         * @param {function} iteratee Node iteratee.
         * @return {TreeNodes} New array of node objects.
         */
        public function map(iteratee:Function):TreeNodes { return null; }

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
         * Pause events.
         *
         * @param {array} events Event names to mute.
         * @return {Tree} Tree instance.
         */
        public function mute(events:Array):InspireTree { return null; }

        /**
         * Get current mute settings.
         *
         * @return {boolean|array} Muted events. If all, true.
         */
        public function muted():Object { return null; }

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
        public function nodes(refs:Array = null):TreeNodes { return null; }

        /**
         * Get the root TreeNodes pagination.
         *
         * @return {object} Pagination configuration object.
         */
        public function pagination():Object { return null; }

        /**
         * Pop node in the final index position.
         *
         * @return {TreeNode} Node object.
         */
        public function pop():TreeNode { return null; }

        /**
         * Add a TreeNode to the end of the root collection.
         *
         * @param {TreeNode} node Node object.
         * @return {int} The new length
         */
        public function push(node:TreeNode):int { return null; }

        /**
         * Iterate down all nodes and any children.
         *
         * Return false to stop execution.
         *
         * @private
         * @param {function} iteratee Iteratee function
         * @return {TreeNodes} Resulting nodes.
         */
        public function recurseDown():void { }

        /**
         * Reduce nodes.
         *
         * @param {function} iteratee Iteratee function
         * @return {any} Resulting data.
         */
        public function reduce(iteratee:Function):* { return null; }

        /**
         * Right-reduce root nodes.
         *
         * @param {function} iteratee Iteratee function
         * @return {any} Resulting data.
         */
        public function reduceRight(iteratee:Function):* { return null; }

        /**
         * Reload/re-execute the original data loader.
         *
         * @return {Promise<TreeNodes>} Load method promise.
         */
        public function reload():Promise.<TreeNodes> { return null; }

        /**
         * Remove a node.
         *
         * @param {TreeNode} node Node object.
         * @return {TreeNodes} Array of node objects.
         */
        public function remove(node:TreeNode):TreeNodes { return null; }

        /**
         * Remove all nodes.
         *
         * @return {Tree} Tree instance.
         */
        public function removeAll():InspireTree { return null; }

        /**
         * Query for all soft-removed nodes.
         *
         * @param {boolean} full Retain full hiearchy.
         * @return {TreeNodes} Array of node objects.
         */
        public function removed(full:Boolean):TreeNodes { return null; }

        /**
         * Resets the root model and associated information like pagination.
         *
         * Note: This method does *not* apply changes because it assumes
         * futher changes will occur to the model.
         *
         * @private
         * @return {Tree} Tree instance.
         */
        public function reset():void { }

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
         * Reverse node order.
         *
         * @return {TreeNodes} Reversed array of node objects.
         */
        public function reverse():TreeNodes { return null; }

        /**
         * Search nodes, showing only those that match and the necessary hierarchy.
         *
         * @param {*} query Search string, RegExp, or function.
         * @return {Promise<TreeNodes>} Promise resolved with an array of matching node objects.
         */
        public function search(query:*):Promise.<TreeNodes> { return null; }

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
         * Select all nodes between a start and end node.
         * Starting node must have a higher index path so we can work down to endNode.
         *
         * @param {TreeNode} startNode Starting node
         * @param {TreeNode} endNode Ending node
         * @return {Tree} Tree instance.
         */
        public function selectBetween(startNode:TreeNode, endNode:TreeNode):InspireTree { return null; }

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
         * Select the first available node.
         *
         * @return {TreeNode} Selected node object.
         */
        public function selectFirstAvailableNode():TreeNode { return null; }
        /**
         * Shift node in the first index position.
         *
         * @return {TreeNode} Node object.
         */
        public function shift():TreeNode { return null; }

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
         * Get a shallow copy of a portion of nodes.
         *
         * @param {int} begin Starting index.
         * @param {int} end End index.
         * @return {Array} Array of selected subset.
         */
        public function slice(begin:int, end:int):Array { return null; }
    
        /**
         * Soft-remove nodes.
         *
         * @return {TreeNodes} Array of node objects.
         */
        public function softRemove():TreeNodes { return null; }

        /**
         * Check if at least one node passes the given test.
         *
         * @param {function} tester Test each node in this collection,
         * @return {boolean} True if at least one node passes the test.
         */
        public function some(tester:Function):Boolean { return null; }

        /**
         * Sort nodes using a function.
         *
         * @param {function} compareFn Comparison function.
         * @return {TreeNodes} Root array of node objects.
         */
        public function sort(compareFn:Function):TreeNodes { return null; }

        /**
         * Sort nodes using a function or key name.
         *
         * If no custom sorter given, the configured "sort" value will be used.
         *
         * @param {string|function} sorter Sort function or property name.¿?
         * @return {TreeNodes} Array of node obejcts.
         */
        public function sortBy(sorter:Object):TreeNodes { return null; }

        /**
         * Deeply sort nodes.
         *
         * @param {function} compareFn Comparison function.
         * @return {TreeNodes} Root array of node objects.
         */
        public function sortDeep(compareFn:Function):TreeNodes { return null; }

        /**
         * Remove and/or add new TreeNodes into the root collection.
         *
         * @param {int} start Starting index.
         * @param {int} deleteCount Count of nodes to delete.
         * @param {TreeNode} node Node(s) to insert.
         * @return {Array} Array of selected subset.
         */
        public function splice(start:int, deleteCount:int, node:TreeNode):Array { return null; }
    
        /**
         * Set nodes' state values.
         *
         * @param {string} name Property name.
         * @param {boolean} newVal New value, if setting.
         * @return {TreeNodes} Array of node objects.
         */
        public function state(name:String, newVal:Boolean):TreeNodes { return null; }

        /**
         * Set (deeply) nodes' state values.
         *
         * @param {string} name Property name.
         * @param {boolean} newVal New value, if setting.
         * @return {TreeNodes} Array of node objects.
         */
        public function stateDeep(name:String, newVal:Boolean):TreeNodes { return null; }

        /**
         * Swap two node positions.
         *
         * @param {TreeNode} node1 Node 1.
         * @param {TreeNode} node2 Node 2.
         * @return {TreeNodes} Array of node objects.
         */
        public function swap(node1:TreeNode, node2:TreeNode):TreeNodes { return null; }

        /**
         * Get a native node Array.
         *
         * @return {array} Array of node objects.
         */
        public function toArray():Array { return null; }
    
        /**
         * Get a string representation of node objects.
         *
         * @return {string} Strings from root node objects.
         */
        public function toString():String { return null; }
        
        /**
         * Resume events.
         *
         * @param {array} events Events to unmute.
         * @return {Tree} Tree instance.
         */
        public function unmute(events:Array):InspireTree { return null; }

        /**
         * Add a TreeNode in the first index position.
         *
         * @return {number} The new length
         */
        public function unshift():Number { return null; }

        /**
         * Query for all visible nodes.
         *
         * @param {boolean} full Retain full hiearchy.
         * @return {TreeNodes} Array of node objects.
         */
        public function visible(full:Boolean):TreeNodes { return null; }


	}
	
}