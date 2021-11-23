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
    
	import org.apache.royale.events.Event;

	/**
	 * @externs
	 */
	public class TreeEvent extends Event
    {
        public function TreeEvent(typeName:String, TREE:InspireTree, TREE_NODE:TreeNode)
        {
			super(type, true, true);
            
		}
        
    }
    //export interface TreeEvents<TREE extends InspireTree= InspireTree, TREE_NODE extends TreeNode = TreeNode> {
    /** @event changes.applied (InspireTree | TreeNode context) - Indicates batched changes are complete for the context. */
    //'changes.applied'?: (context: TREE | TREE_NODE) => void;

    /** @event children.loaded (TreeNode node) - Children were dynamically loaded for a node. */
    //children.loaded'?: (node: TREE_NODE) => void;

    /** @event data.loaded (Array nodes) - Data has been loaded successfully (only for data loaded via xhr/callbacks). */
    //data.loaded'?: (nodes: any[]) => void;

    /** @event data.loaderror (Error err) - Loading failed. */
    //data.loaderror'?: (err: Error) => void;

    /** @event model.loaded (Array nodes) - Data has been parsed into an internal model. */
    //model.loaded'?: (node: TREE_NODE) => void;

    /** @event node.added (TreeNode node) - Node added. */
    //node.added'?: (node: TREE_NODE) => void;

    /** @event node.click (TreeNode node) - Node os clicked. */
    //node.click'?: (node: TREE_NODE) => void;

    /** @event node.blurred (TreeNode node, bool isLoadEvent) - Node lost focus. */
    //node.blurred'?: (node: TREE_NODE, isLoadEvent: boolean) => void;

    /** @event node.checked (TreeNode node, bool isLoadEvent) - Node checked. */
    //node.checked'?: (node: TREE_NODE, isLoadEvent: boolean) => void;

    /** @event node.collapsed (TreeNode node) - Node collapsed. */
    //node.collapsed'?: (node: TREE_NODE) => void;

    /** @event node.deselected (TreeNode node) - Node deselected. */
    //node.deselected'?: (node: TREE_NODE) => void;

    /** @event node.edited (TreeNode node), (string oldValue), (string newValue) - Node text was altered via inline editing. */
    //node.edited'?: (node: TREE_NODE) => void;

    /** @event node.expanded (TreeNode node, bool isLoadEvent) - Node expanded. */
    //node.expanded'?: (node: TREE_NODE, isLoadEvent: boolean) => void;

    /** @event node.focused (TreeNode node, bool isLoadEvent) - Node focused. */
    //node.focused'?: (node: TREE_NODE, isLoadEvent: boolean) => void;

    /** @event node.hidden (TreeNode node, bool isLoadEvent) - Node hidden. */
    //node.hidden'?: (node: TREE_NODE, isLoadEvent: boolean) => void;

    /** @event node.moved (TreeNode node, TreeNodes source, int oldIndex, TreeNodes target, int newIndex) - Node moved. */
    //node.moved'?: (node: TREE_NODE) => void;

    /** @event node.paginated (TreeNode context), (Object pagination) (Event event) - Nodes were paginated. Context is undefined when for the root level. */
    //node.paginated'?: (node: TREE_NODE) => void;

    /** @event node.propertchanged - (TreeNode node), (String property), (Mixed oldValue), (Mixed) newValue) - A node's root property has changed. */
    //node.property.changed'?: (node: TREE_NODE) => void;

    /** @event node.removed (object node) - Node removed. */
    //node.removed'?: (node: TREE_NODE) => void;

    /** @event node.restored (TreeNode node) - Node restored. */
    //node.restored'?: (node: TREE_NODE) => void;

    /** @event node.selected (TreeNode node, bool isLoadEvent) - Node selected. */
    //node.selected'?: (node: TREE_NODE, isLoadEvent: boolean) => void;

    /** @event node.statchanged - (TreeNode node), (String property), (Mixed oldValue), (Mixed) newValue) - A node state boolean has changed. */
    //node.state.changed'?: (node: TREE_NODE) => void;

    /** @event node.shown (TreeNode node) - Node shown. */
    //node.shown'?: (node: TREE_NODE) => void;

    /** @event node.softremoved (TreeNode node, bool isLoadEvent) - Node soft removed. */
    //node.softremoved'?: (node: TREE_NODE, isLoadEvent: boolean) => void;

    /** @event node.unchecked (TreeNode node) - Node unchecked. */
    //node.unchecked'?: (node: TREE_NODE) => void;

}