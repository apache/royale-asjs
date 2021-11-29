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
package org.apache.royale.externsjs.inspiretree.vos
{
   
    public class OptionsTree
    {
        public function OptionsTree(){}

        /**
         * Array of state-change events to fire for pre-set states.
         */
        public var allowLoadEvents:Array = [];
        /**
         * 
         * { autoCheckChildren: boolean }  Automatically check/uncheck children when parent toggled.
         */
        public var checkbox:Object = {autoCheckChildren: true};
        /**
         * public var contextMenu:Boolean = false;
         */
        
        /**
         * An array, promise, or callback function.
         */
        public var data:Object;
        /**
         * Enable deferred loading. 
         */
        public var deferredLoading:Boolean = false;
        /**
         * Allow inline editing (requires inspire-tree-dom).
         */
        public var editable:Boolean = false;
        /**
         * editing (defaults to true if editable is true)
         *      {add: booblean, edit:boolean, remove:boolean}
         *      add - Allow user to add nodes.
         *      edit - Allow user to edit existing nodes.
         *      remove - Allow user to remove nodes.
         */
        public var editing:Object = { add: false, edit: false, remove: false};
        /**
         * 
         * {resetStateOnRestore: boolean} Reset node state to defaults when restored.
         */
        public var nodes:Object = {resetStateOnRestore: true};
        /**
         * {limit: integer [, total:0]}
         *  limit - How many nodes are rendered/loaded at once. 
         *          Used with deferrals. Defaults to nodes which fit in the container.
         */
        public var pagination:Object = {limit: -1};
        /**
         * {matcher: boolean, matchProcessor: boolean}
         *  matcher - Custom search executor (for custom/external handling of entire search). 
         *            Must be a function which accepts a query and resolve/reject arguments.
         *  matchProcessor - Custom handler for search matches. 
         *            Must be a function which accepts a TreeNodes argument.
         */
        public var search:Object = { matcher: false, matchProcessor: false };
        /**
         * allow - Dynamically determine selectable boolean for a node.
         * autoDeselect - Prevent automatic deselection.
         * autoSelectChildren - Auto-select children when a parent node is selected, regardless of their visibility.
         * disableDirectDeselection - Disallow deselecting a node by clicking on it while selected.
         * mode - default or checkbox. Checkbox mode auto-selects children, doesn't auto deselect.
         *        mode ['default' | 'tree' | 'checkbox'] 
         * multiple - Allow multiple nodes to be selected at a time.
         * require - Require at least one selected node.
         *      
         *  unlinkCheckSelect: CUSTOM PROPERTY Hiedra (in checkbox mode checked <> selected)
         */
        public var selection:Object = { mode: 'tree', autoDeselect: true, autoSelectChildren: true, disableDirectDeselection: true,  multiple: false, require: false };
        /**
         * public var showCheckboxes:Boolean = false;
         */        
        //public var showCheckboxes:Boolean;
        /**
         * sort - Property to sort by, or a custom sort function.
         */
        public var sort:Object;
    }

}