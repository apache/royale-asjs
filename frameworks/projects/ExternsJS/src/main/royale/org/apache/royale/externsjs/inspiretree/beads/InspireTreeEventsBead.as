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
package org.apache.royale.externsjs.inspiretree.beads
{	
	
	/**  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.8
	 */
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.Strand;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.externsjs.inspiretree.vos.ItemTreeNode;
    import org.apache.royale.externsjs.inspiretree.IInspireTree;
       
    COMPILE::JS
	public class InspireTreeEventsBead  extends Strand implements IBead
	{
		/**
		 *  constructor
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */

		public function InspireTreeEventsBead()
		{
			super();
		}
        private var _strand:IStrand;

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
        public function get strand():IStrand
        {
            return _strand;
        }

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */

		public function set strand(value:IStrand):void
		{
            _strand = value;
			(_strand as IEventDispatcher).addEventListener("onCreationComplete", createListeners)
		} 

		private function createListeners():void
		{
			//We do not delete the listener because the jsTree can be recreated and the callBacks must be recreated.
			//(_strand as IEventDispatcher).removeEventListener("onCreationComplete", createListeners);
			
			if(_nodeClick)
				(_strand as IInspireTree).jsTree.on('node.click', onClickHandler);
			if(_nodeDblClick)
				(_strand as IInspireTree).jsTree.on('node.dblclick', onDblClickHandler);
			if(_nodeContextmenu)
				(_strand as IInspireTree).jsTree.on('node.contextmenu', onNodeContextmenuHandler);
		}
		
        private var _nodeClick:Function;
        public function get nodeClick():Function { return _nodeClick; }
		/**
		 * function onClick(event:Event, node:ItemTreeNode):void{}
		 * @param value Callback function User clicked node.
		 */
        public function set nodeClick(value:Function):void { _nodeClick = value; }
		public function onClickHandler(evt:*, treeNode:Object, handler:Function):void
		{
			//-----
			// test - Override our default DOM event handlers
			// .
			//evt.treeDefaultPrevented = true; // Cancels default listener
			//-----

			//3 arguments: PointerEvent/Event, TreeNode, f()
			//args[0] = PointerEvent
			//args[0].currentTarget = "a.title.icon" | 
			//args[0].path[] : 	[0] a.title.icon
			//						<a class="title icon" data-uid="e5cfe258-c8e9-4285-89bb-0121ade5ee37" tabindex="1" unselectable="on">1 - Document Setup</a>
			//					[1] div.title-wrap
			//						<div class="title-wrap"><a class="toggle icon icon-expand"></a><input type="checkbox"><a class="title icon" data-uid="e5cfe258-c8e9-4285-89bb-0121ade5ee37" tabindex="1" unselectable="on">1 - Document Setup</a></div>
			//					[2] li.collapsed.draggable.focused.indeterminate.rendered.selectable.drop-target.folder
			//						<li class="collapsed draggable focused indeterminate rendered selectable drop-target folder" data-uid="e5cfe258-c8e9-4285-89bb-0121ade5ee37"><div class="title-wrap"><a class="toggle icon icon-expand"></a><input type="checkbox"><a class="title icon" data-uid="e5cfe258-c8e9-4285-89bb-0121ade5ee37" tabindex="1" unselectable="on">1 - Document Setup</a></div><div class="wholerow"> <img style="padding-left:25px" class="Treeparentimg" src="assets/inspiretree/personal_24.png"> <span width="20" height="20" style="float:right; cursor: pointer;"> <img class="revImage" src="assets/inspiretree/repeater24.png"> </span></div><ol><li class="checked collapsed draggable rendered selectable drop-target leaf" data-uid="bfc8c3a6-2e59-4c8a-9a96-a8799348d067"><div class="title-wrap"><input type="checkbox"><a class="title icon" data-uid="bfc8c3a6-2e59-4c8a-9a96-a8799348d067" tabindex="1" unselectable="on">View</a></div><div class="wholerow"></div></li><li class="checked collapsed draggable rendered selectable drop-target leaf" data-uid="eac25b56-f493-4d01-b7fe-01da31d7f815"><div class="title-wrap"><input type="checkbox"><a class="title icon" data-uid="eac25b56-f493-4d01-b7fe-01da31d7f815" tabindex="1" unselectable="on">Modify</a></div><div class="wholerow"></div></li><li class="checked collapsed draggable rendered selectable drop-target leaf" data-uid="be964bba-2e7a-4c82-9d8c-482e60c25a0e"><div class="title-wrap"><input type="checkbox"><a class="title icon" data-uid="be964bba-2e7a-4c82-9d8c-482e60c25a0e" tabindex="1" unselectable="on">Add</a></div><div class="wholerow"></div></li><li class="checked collapsed draggable rendered selectable drop-target leaf" data-uid="fcf73db2-f85c-415a-b065-171bcbd5eb2d"><div class="title-wrap"><input type="checkbox"><a class="title icon" data-uid="fcf73db2-f85c-415a-b065-171bcbd5eb2d" tabindex="1" unselectable="on">Delete</a></div><div class="wholerow"></div></li><li class="collapsed draggable rendered selectable drop-target leaf" data-uid="dfaa2d65-b709-468e-b87e-d893cd927d87"><div class="title-wrap"><input type="checkbox"><a class="title icon" data-uid="dfaa2d65-b709-468e-b87e-d893cd927d87" tabindex="1" unselectable="on">Save Image</a></div><div class="wholerow"></div></li></ol></li>
			//					[3] ol
			//					[4] div.inspire-tree
			// 					...
			//					[14] Windows
			//args[0] = Event
			//args[0].currentTarget = "input" | 
			//args[0].path[0-14] : 	[0] input
			//						<input type="checkbox">
			//					[1] div.title-wrap
			//						<div class="title-wrap"><a class="toggle icon icon-collapse"></a><input type="checkbox"><a class="title icon" data-uid="1ba59604-2ffe-4a0c-a80b-0df34c425027" tabindex="1" unselectable="on">1 - Document Setup</a></div>
			// 					...
			//					[14] Windows
			_nodeClick( evt, new ItemTreeNode(treeNode));
			
			//-----
			// test - Override our default DOM event handlers
			// As the original controller is passed as an argument, it allows us to run it when we are ready.
			// Only DOM-based events support this: node.click, node.dblclick, node.contextmenu
			// .
			//handler(); // call the original tree logic
			//-----
		}

        private var _nodeDblClick:Function;
        public function get nodeDblClick():Function { return _nodeDblClick; }
		/**
		 * function onDblClick(event:Event, node:ItemTreeNode):void{}
		 * @param value Callback function User double-clicked node.
		 */
        public function set nodeDblClick(value:Function):void {	_nodeDblClick = value; }
		public function onDblClickHandler():void
		{
			_nodeDblClick( arguments[0], new ItemTreeNode(arguments[1]));
		}

        private var _nodeContextmenu:Function;
        public function get nodeContextmenu():Function { return _nodeContextmenu; }
		/**
		 * function onNodeContextmenu(event:PointerEvent, node:ItemTreeNode):void{}
		 * @param value Callback function User right-clicked node.
		 */
        public function set nodeContextmenu (value:Function):void {	_nodeContextmenu = value; }
		public function onNodeContextmenuHandler():void
		{
			_nodeContextmenu(arguments[0], new ItemTreeNode(arguments[1]));
		}


		/*
		Event List - Inspire-tree-dom
		-------------------------------------------------------------------------------------------------------------
		node.click - (MouseEvent event, TreeNode node) - User clicked node.
		node.contextmenu - (MouseEvent event, TreeNode node) - User right-clicked node.
		node.dblclick - (MouseEvent event, TreeNode node) - User double-clicked node.
		node.dragend - (DragEvent event) - Drag end.
		node.dragenter - (DragEvent event) - Drag enter.
		node.dragleave - (DragEvent event) - Drag leave.
		node.dragover - (DragEvent event, int dir) - Node drag over. dir will be -1 for "above", 0 for "into", 1 for "below".
		node.dragstart - (DragEvent event) - Drag start.
		node.drop - (DragEvent event, TreeNode source, TreeNode target, int index) - Node was dropped. 
					If target null, node was dropped into the root context.
		node.edited - (TreeNode node), (string oldValue), (string newValue) - Node text was altered via inline editing.

		Event List - Inspire-tree (Exhibits Inspire.tree.dom events)
		-------------------------------------------------------------------------------------------------------------
		changes.applied - (InspireTree | TreeNode context) - Indicates batched changes are complete for the context.
		children.loaded - (TreeNode node) - Children were dynamically loaded for a node.
		data.loaded - (Array nodes) - Data has been loaded successfully (only for data loaded via xhr/callbacks).
		data.loaderror - (Error err) - Loading failed.
		model.loaded - (Array nodes) - Data has been parsed into an internal model.
		node.added - (TreeNode node) - Node added.
		node.blurred - (TreeNode node, bool isLoadEvent) - Node lost focus.
		node.checked - (TreeNode node, bool isLoadEvent) - Node checked.
		node.collapsed - (TreeNode node) - Node collapsed.
		node.deselected - (TreeNode node) - Node deselected.
		node.edited - (TreeNode node), (string oldValue), (string newValue) - Node text was altered via inline editing.
		node.expanded - (TreeNode node, bool isLoadEvent) - Node expanded.
		node.focused - (TreeNode node, bool isLoadEvent) - Node focused.
		node.hidden - (TreeNode node, bool isLoadEvent) - Node hidden.
		node.moved - (TreeNode node, TreeNodes source, int oldIndex, TreeNodes target, int newIndex) - Node moved.
		node.paginated - (TreeNode context), (Object pagination) (Event event) - Nodes were paginated. Context is undefined when for the root level.
		node.property.changed - (TreeNode node), (String property), (Mixed oldValue), (Mixed) newValue) - A node's root property has changed.
		node.removed - (object node) - Node removed.
		node.restored - (TreeNode node) - Node restored.
		node.selected - (TreeNode node, bool isLoadEvent) - Node selected.
		node.state.changed - (TreeNode node), (String property), (Mixed oldValue), (Mixed) newValue) - A node state boolean has changed.
		node.shown - (TreeNode node) - Node shown.
		node.softremoved - (TreeNode node, bool isLoadEvent) - Node soft removed.
		node.unchecked - (TreeNode node) - Node unchecked.
		*/
	}

    COMPILE::SWF
	public class InspireTreeEventsBead
	{
    }
}
