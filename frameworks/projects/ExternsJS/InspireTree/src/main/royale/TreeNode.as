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
        import TreeNodes;
    }

	/**
	 * @externs
	 */
	COMPILE::JS
	public class TreeNode
    {
        public function TreeNode(source:Object){
		}

        public var children:Array; //of TreeNodes
        public var id:String;
        public var itree:Object;
        public var text:String;
            
        /**
         * Add a child to this node.
         *
         * @param {object} child Node object.
         * @return {TreeNode} Node object.
         */
        public function addChild(children:Object):TreeNode { return null; }

        /**
         * Add multiple children to this node.
         *
         * @param {object} children Array of nodes.
         * @return {TreeNodes} Array of node objects.
         */
        public function addChildren(children:Object):TreeNodes { return null; }

        /**
         * Assign source object(s) to this node.
         *
         * @param {object} source Source object(s)
         * @return {TreeNode} Node object.
         */
        public function assign(source:Object):TreeNode { return null; }

        /**
         * Check if node available.
         *
         * @return {boolean} True if available.
         */
        public function available():Boolean { return null; }

        /**
         * Blur focus from this node.
         *
         * @return {TreeNode} Node object.
         */
        public function blur():TreeNode { return null; }
        
        /**
         * Mark node as checked.
         *
         * @param {boolean} shallow Skip auto-checking children.
         * @return {TreeNode} Node object.
         */
        public function check(shallow:Boolean):TreeNode { return null; }
        
        /**
         * Get whether this node is checked.
         *
         * @return {boolean} True if node checked.
         */
        public function checked():Boolean  { return null; }
        
        /**
         * Hide parents without any visible children.
         *
         * @return {TreeNode} Node object.
         */
        public function clean():TreeNode  { return null; }
        
        /**
         * Clone this node.
         *
         * @param {array} excludeKeys Keys to exclude from the clone.
         * @return {TreeNode} New node object.
         */
        public function clone(excludeKeys:Array):TreeNode { return null; }

        /**
         * Collapse this node.
         *
         * @return {TreeNode} Node object.
         */
        public function collapse():TreeNode  { return null; }

        /**
         * Get whether this node is collapsed.
         *
         * @return {boolean} True if node collapsed.
         */
        public function collapsed():Boolean  { return null; }

        /**
         * Get the containing context. If no parent present, the root context is returned.
         *
         * @return {TreeNodes} Node array object.
         */
        public function context():TreeNodes { return null; }

        /**
         * Copy node to another tree instance.
         *
         * @param {object} dest Destination Inspire Tree.
         * @param {boolean} hierarchy Include necessary ancestors to match hierarchy.
         * @param {boolean} includeState Include itree.state object.
         * @return {object} Property "to" for defining destination.
         */
        public function copy(dest:InspireTree, hierarchy:Boolean, includeState:Boolean):Object { return null; }

        /**
         * Copy all parents of a node.
         *
         * @param {boolean} excludeNode Exclude given node from hierarchy.
         * @param {boolean} includeState Include itree.state object.
         * @return {TreeNode} Root node object with hierarchy.
         */
        public function copyHierarchy(excludeNode:Boolean, includeState:Boolean):TreeNode { return null; }

        /**
         * Deselect this node.
         *
         * If selection.require is true and this is the last selected
         * node, the node will remain in a selected state.
         *
         * @param {boolean} shallow Skip auto-deselecting children.
         * @return {TreeNode} Node object.
         */
        public function deselect(shallow:Boolean):TreeNode { return null; }
            
        /**
         * Get whether node editable. Required editing.edit to be enable via config.
         *
         * @return {boolean} True if node editable.
         */
        public function editable():Boolean { return null; }

        /**
         * Get whether node is currently in edit mode.
         *
         * @return {boolean} True if node in edit mode.
         */
        public function editing():Boolean { return null; }

        /**
         * Expand this node.
         *
         * @return {Promise<TreeNode>} Promise resolved on successful load and expand of children.
         */
        public function expand():Promise.<TreeNode> { return null; }

        /**
         * Get whether node expanded.
         *
         * @return {boolean} True if expanded.
         */
        public function expanded():Boolean { return null; }
        
        /**
         * Expand parent nodes.
         *
         * @return {TreeNode} Node object.
         */
        public function expandParents():TreeNode { return null; }

        /**
         * Focus a node without changing its selection.
         *
         * @return {TreeNode} Node object.
         */
        public function focus():TreeNode { return null; }

        /**
         * Get whether this node is focused.
         *
         * @return {boolean} True if node focused.
         */
        public function focused():Boolean { return null; }

        /**
         * Get children for this node. If no children exist, an empty TreeNodes
         * collection is returned for safe chaining.
         *
         * @return {TreeNodes} Array of node objects.
         */
        public function getChildren():TreeNodes { return null; }

        /**
         * Get the immediate parent, if any.
         *
         * @return {TreeNode} Node object.
         */
        public function getParent():TreeNode { return null; }

        /**
         * Get parent nodes. Excludes any siblings.
         *
         * @return {TreeNodes} Node objects.
         */
        public function getParents():TreeNode { return null; }
        
        /**
         * Get a textual hierarchy for a given node. An array
         * of text from this node's root ancestor to the given node.
         *
         * @return {array} Array of node texts.
         */
        public function getTextualHierarchy():Array { return null; }

        /**
         * Get whether the given node is an ancestor of this node.
         *
         * @param {TreeNode} node Node object.
         * @return {boolean} True if node is an ancestor or the given node
         */
        public function hasAncestor(node:TreeNode):Boolean { return null; }

        /**
         * Get whether node has any children.
         *
         * @return {boolean} True if has loaded children.
         */
        public function hasChildren():Boolean { return null; }

        /**
         * Get whether children have been loaded. Will always be true for non-dynamic nodes.
         *
         * @return {boolean} True if we've attempted to load children.
         */
        public function hasLoadedChildren():Boolean { return null; }

        /**
         * Get whether node has any children, or allows dynamic loading.
         *
         * @return {boolean} True if node has, or will have children.
         */
        public function hasOrWillHaveChildren():Boolean { return null; }

        /**
         * Get whether node has a parent.
         *
         * @return {boolean} True if has a parent.
         */
        public function hasParent():Boolean { return null; }

        /**
         * Get whether node has any visible children.
         *
         * @return {boolean} True if children are visible.
         */
        public function hasVisibleChildren():Boolean { return null; }

        /**
         * Hide this node.
         *
         * @return {TreeNode} Node object.
         */
        public function hide():TreeNode { return null; }
        
        /**
         * Get whether this node is hidden.
         *
         * @return {boolean} True if node hidden.
         */
        public function hidden():Boolean { return null; }

        /**
         * Get a "path" of indices, values which map this node's location within all parent contexts.
         *
         * @return {string} Index path
         */
        public function indexPath():String { return null; }

        /**
         * Get whether this node is indeterminate.
         *
         * @return {boolean} True if node indeterminate.
         */
        public function indeterminate():Boolean { return null; }

        /**
         * Get whether this node is the first renderable in its context.
         *
         * @return {boolean} True if node is first renderable
         */
        public function isFirstRenderable():Boolean { return null; }

        /**
         * Get whether this node is the last renderable in its context.
         *
         * @return {boolean} True if node is last renderable
         */
        public function isLastRenderable():Boolean { return null; }

        /**
         * Get whether this node is the only renderable in its context.
         *
         * @return {boolean} True if node is only renderable
         */
        public function isOnlyRenderable():Boolean { return null; }

        /**
         * Find the last + deepest visible child of the previous sibling.
         *
         * @return {TreeNode} Node object.
         */
        public function lastDeepestVisibleChild():TreeNode { return null; }
        
        /**
         * Initiate a dynamic load of children for a given node.
         *
         * This requires `tree.config.data` to be a function which accepts
         * three arguments: node, resolve, reject.
         *
         * Use the `node` to filter results.
         *
         * On load success, pass the result array to `resolve`.
         * On error, pass the Error to `reject`.
         *
         * @return {Promise<TreeNodes>} Promise resolving children nodes.
         */
        public function loadChildren():Promise.<TreeNodes> { return null; }

        /**
         * Get whether this node is loading child data.
         *
         * @return {boolean} True if node's children are loading.
         */
        public function loading():Boolean { return null; }

        /**
         * Load additional children.
         *
         * @param {Event} event Click or scroll event if DOM interaction triggered this call.
         * @return {Promise<TreeNodes>} Resolves with request results.
         */
        public function loadMore():Promise.<TreeNodes> { return null; }

        /**
         * Mark node as dirty. For some systems this assists with rendering tracking.
         *
         * @return {TreeNode} Node object.
         */
        public function markDirty():TreeNode { return null; }
        
        /**
         * Get whether this node was matched during the last search.
         *
         * @return {boolean} True if node matched.
         */
        public function matched():Boolean { return null; }

        /**
         * Find the next visible sibling of our ancestor. Continues
         * seeking up the tree until a valid node is found or we
         * reach the root node.
         *
         * @return {TreeNode} Node object.
         */
        public function nextVisibleAncestralSiblingNode():TreeNode { return null; }
        
        /**
         * Find next visible child node.
         *
         * @return {TreeNode} Node object, if any.
         */
        public function nextVisibleChildNode():TreeNode { return null; }
        
        /**
         * Get the next visible node.
         *
         * @return {TreeNode} Node object if any.
         */
        public function nextVisibleNode():TreeNode { return null; }
        
        /**
         * Find the next visible sibling node.
         *
         * @return {TreeNode} Node object, if any.
         */
        public function nextVisibleSiblingNode():TreeNode { return null; }
        
        /**
         * Get pagination object for this tree node.
         *
         * @return {object} Pagination configuration object.
         */
        public function pagination():Object { return null; }
        /**
         * Find the previous visible node.
         *
         * @return {TreeNode} Node object, if any.
         */
        public function previousVisibleNode():TreeNode { return null; }
        
        /**
         * Find the previous visible sibling node.
         *
         * @return {TreeNode} Node object, if any.
         */
        public function previousVisibleSiblingNode():TreeNode { return null; }
        
        /**
         * Iterate down node and any children.
         *
         * @param {function} iteratee Iteratee function.
         * @return {TreeNode} Node object.
         */
        public function recurseDown(iteratee:Function):TreeNode { return null; }
        
        /**
         * Iterate up a node and its parents.
         *
         * @param {function} iteratee Iteratee function.
         * @return {TreeNode} Node object.
         */
        public function recurseUp(iteratee:Function):TreeNode { return null; }
        
        /**
         * Update the indeterminate state of this node by scanning states of children.
         *
         * True if some, but not all children are checked.
         * False if no children are checked.
         *
         * @return {TreeNode} Node object.
         */
        public function refreshIndeterminateState():TreeNode { return null; }
        
        /**
         * Remove all current children and re-execute a loadChildren call.
         *
         * @return {Promise<TreeNodes>} Promise resolved on load.
         */
        public function reload():Promise.<TreeNodes> { return null; }

        /**
         * Remove a node from the tree.
         *
         * @param {boolean} includeState Include itree.state object.
         * @return {object} Removed tree node object.
         */
        public function remove(includeState:Boolean = false):Object { return null; }

        /**
         * Get whether this node is soft-removed.
         *
         * @return {boolean} True if node soft-removed.
         */
        public function removed():Boolean { return null; }

        /**
         * Get whether this node can be "rendered" when the context is.
         * Hidden and removed nodes may still be included in the DOM,
         * but not "rendered" in a sense they'll be visible.
         *
         * @return {boolean} If not hidden or removed
         */
        public function renderable():Boolean { return null; }

        /**
         * Get whether this node has been rendered.
         *
         * Will be false if deferred rendering is enable and the node has
         * not yet been loaded, or if a custom DOM renderer is used.
         *
         * @return {boolean} True if node rendered.
         */
        public function rendered():Boolean { return null; }

        /**
         * Restore state if soft-removed.
         *
         * @return {TreeNode} Node object.
         */
        public function restore():TreeNode { return null; }
        
        /**
         * Select this node.
         *
         * @param {boolean} shallow Skip auto-selecting children.
         * @return {TreeNode} Node object.
         */
        public function select(shallow:Boolean):TreeNode { return null; }
        
        /**
         * Get whether node selectable.
         *
         * @return {boolean} True if node selectable.
         */
        public function selectable():Boolean { return null; }

        /**
         * Get whether this node is selected.
         *
         * @return {boolean} True if node selected.
         */
        public function selected():Boolean { return null; }

        /**
         * Set a root property on this node.
         *
         * @param {string|number} property Property name.
         * @param {*} value New value.
         * @return {TreeNode} Node object.
         */
        public function set(property:String, value:*):TreeNode { return null; }
        
        /**
         * Show this node.
         *
         * @return {TreeNode} Node object.
         */
        public function show():TreeNode { return null; }
        
        /**
         * Mark this node as "removed" without actually removing it.
         *
         * Expand/show methods will never reveal this node until restored.
         *
         * @return {TreeNode} Node object.
         */
        public function softRemove():TreeNode { return null; }
        
        /**
         * Get or set a state value.
         *
         * This is a base method and will not invoke related changes, for example
         * setting selected=false will not trigger any deselection logic.
         *
         * @param {string|object} obj Property name or Key/Value state object.
         * @param {boolean} val New value, if setting.
         * @return {boolean|object} Old state object, or old value if property name used.
         */
        public function state(obj:Object, val:Boolean):Object { return null; }

        /**
         * Get or set multiple state values to a single value.
         *
         * @param {Array} names Property names.
         * @param {boolean} newVal New value, if setting.
         * @return {Array} Array of state booleans
         */
        public function states(names:Array, newVal:Boolean):Array { return null; }

        /**
         * Swap position with the given node.
         *
         * @param {TreeNode} node Node.
         * @return {TreeNode} Node objects.
         */
        public function swap(node:TreeNode):TreeNode { return null; }
        
        /**
         * Toggle checked state.
         *
         * @return {TreeNode} Node object.
         */
        public function toggleCheck():TreeNode { return null; }
        
        /**
         * Toggle collapsed state.
         *
         * @return {TreeNode} Node object.
         */
        public function toggleCollapse():TreeNode { return null; }
        
        /**
         * Toggle editing state.
         *
         * @return {TreeNode} Node object.
         */
        public function toggleEditing():TreeNode { return null; }
        
        /**
         * Toggle selected state.
         *
         * @return {TreeNode} Node object.
         */
        public function toggleSelect():TreeNode { return null; }
        
        /**
         * Export this node as a native Object.
         *
         * @param {boolean} excludeChildren Exclude children.
         * @param {boolean} includeState Include itree.state object.
         * @return {object} Node object.
         */
        public function toObject(excludeChildren:Boolean = false, includeState:Boolean = false):Object { return null; }

        /**
         * Get the text content of this tree node.
         *
         * @return {string} Text content.
         */
        public function toString():String { return null; }

        /**
         * Get the tree this node ultimately belongs to.
         *
         * @return {InspireTree} Tree instance.
         */
        public function tree():InspireTree { return null; }

        /**
         * Uncheck this node.
         *
         * @param {boolean} shallow Skip auto-unchecking children.
         * @return {TreeNode} Node object.
         */
        public function uncheck(shallow:Boolean):TreeNode { return null; }
        
        /**
         * Get whether node is visible to a user. Returns false
         * if it's hidden, or if any ancestor is hidden or collapsed.
         *
         * @return {boolean} Whether visible.
         */
        public function visible():Boolean { return null; }

	}
	
}