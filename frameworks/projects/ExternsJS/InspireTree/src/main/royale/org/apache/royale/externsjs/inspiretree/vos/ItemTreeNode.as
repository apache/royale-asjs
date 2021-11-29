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
   


	/**
	 * text - Text used in display.
	 * id - Unique ID. If missing, one will be generated.
	 * children - An array of child nodes.
	 * itree - An object used to describe initial tree values:
	 *         a.attributes - Custom attributes for this node's a.
	 *         icon - Custom icon for the anchor.
	 *         li.attributes - Custom attributes for this node's root li.
	 *         state.checked - Set checked state.
	 *         state.collapsed - Set initial collapsed state.
	 *         state.draggable - Allows this node to be dragged, if supported*.
	 *         state.drop-target - Allows node to be a drop target, if supported*.
	 *         state.editable - Allow user editing of node text, if supported*.
	 *         state.focused - Node has focus, if supported*.
	 *         state.hidden - Set initial visibility.
	 *         state.indeterminate - Set indeterminate state. May be overridden if all or zero children checked.
	 *         state.loading - Dynamic load of children in progress.
	 *         state.matched - Node was matched by a search.
	 *         state.removed - Soft removed. Never shown until restored.
	 *         state.rendered - Whether node has been rendered, if supported*.
	 *         state.selectable - Allow selection.
	 *         state.selected - Set initial selection.
	 * 
	 * Value applies natively to InspireTreeDOM, and will require added support if you're using a custom DOM renderer.
	 * 
	 * Some internal-use-only states are not listed.
	 */
    public class ItemTreeNode
    {
        
		public function ItemTreeNode( treeNode:Object = null){
            if(treeNode == null)
            {
			    itree = getItreeDefault();
            }else{                
                this.text = treeNode.text;
                this.id = treeNode.id;
                this.children = treeNode.children;
                this.itree = treeNode.itree;
            }
		}
		/**
         * text - Text used in display.
		 */
		public var text:String = "";
		/**
         * id - Unique ID. If missing, one will be generated.
		 */
		public var id:String = "";
		
		/**
         * children - An array of child nodes.
		 */
		public var children:Array = new Array();
		
		/**
         * itree - An object used to describe initial tree values:
         *         a.attributes - Custom attributes for this node's a.
         *         icon - Custom icon for the anchor.
         *         li.attributes - Custom attributes for this node's root li.
		 * 
         *         state.checked - Set checked state.
         *         state.collapsed - Set initial collapsed state.
         *         state.draggable - Allows this node to be dragged, if supported*.
         *     --> state.drop-target - Allows node to be a drop target, if supported*.
         *         state.editable - Allow user editing of node text, if supported*.
         *         state.focused - Node has focus, if supported*.
         *         state.hidden - Set initial visibility.
         *         state.indeterminate - Set indeterminate state. May be overridden if all or zero children checked.
         *         state.loading - Dynamic load of children in progress.
         *         state.matched - Node was matched by a search.
         *         state.removed - Soft removed. Never shown until restored.
         *         state.rendered - Whether node has been rendered, if supported*.
         *         state.selectable - Allow selection.
         *         state.selected - Set initial selection.
		 */
		public var itree:Object;
		
        /**
         * Items states (in TreeNode.itree)
         * 
         * We cannot create a separate 'ItemStatesTree' class because the 'drop-target' attribute is not a valid property name in as3.
         * 
         * @return Default object Item
         */
        private function getItreeDefault():Object
        {
            var res:Object = new Object;		
			res.a = { attributes:{} };
			res.li = { attributes:{} };
			res.icon = null;

            var resstate:Object = {checked:false,
                            collapsed:true,
                            draggable:true,
                            editable:false,
                            //editing:false,
                            focused:false,
                            hidden:false,
                            indeterminate:false,
                            loading:false,
                            matched:false,
                            removed:false,
                            rendered:true,
                            selectable:true,
                            selected:false};        
            resstate['drop-target']=true;
			res.state = resstate;
			
            return res;
        }

        public function fillFromTreeNode(node:Object):ItemTreeNode
        {
            this.text = node.text;
            this.id = node.id;
            this.children = node.children;
            this.itree = node.itree;
            return this;
        }
    }

}