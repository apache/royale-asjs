
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
package mx.controls.beads
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IChild;
	import org.apache.royale.core.IDataProviderModel;
	import org.apache.royale.core.IDragInitiator;
	import org.apache.royale.core.IIndexedItemRenderer;
	import org.apache.royale.core.IItemRenderer;
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.DragEvent;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.beads.controllers.DragMouseController;
	import org.apache.royale.utils.getParentOrSelfByType;
	import org.apache.royale.html.util.getModelByType;
	import mx.collections.IList;
	import org.apache.royale.utils.sendStrandEvent;
	import org.apache.royale.events.ValueEvent;

	/**
	 * The start event is dispatched when a DragStart event happens. The DragEvent.dragSource
	 * is set before this event is dispatched. A listener for this event can then decide if
	 * if the drag-drop action should continue or not. If not, the event should be cancelled.
     *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.10
	 */
	[Event(name="start", type="org.apache.royale.events.Event")]

	/**
	 * The accept event is dispatched when the drop happens but just before the data being
	 * dragged as been incorporated into the drop target's data source. Cancelling this event
	 * prevents that from happening.
     *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.10
	 */
	[Event(name="accept", type="org.apache.royale.events.Event")]

	/**
	 * The complete event is dispatched when the entire drag-and-drop operation has completed
	 * from the drag source's perspective.
     *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.10
	 */
	[Event(name="complete", type="org.apache.royale.events.Event")]

	/**
	 * The dragMove event is dispatched while the drag action moves.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.10
	 */
	[Event(name="dragMove", type="org.apache.royale.events.DragEvent")]

	/**
	 * The dragEnd event is dispatched while the drag action stops.
	 * This is dispatched even when the drag event is aborted.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.10
	 */
	[Event(name="dragEnd", type="org.apache.royale.events.DragEvent")]
	/**
	 *  The TreeSingleSelectionDragSourceBead brings drag capability to single-selection Tree components.
	 *  By adding this bead, a user can drag a row of the Tree to a new location within the tree. This bead
	 *  should be used in conjunction with TreeSingleSelectionDropTargetBead.
	 *
	 *  This bead adds a new event to the strand, "dragImageNeeded", which is dispatched on the strand
	 *  just prior to the dragImage's appearance. An event listener can create its own dragImage if the
	 *  default, taken from the data item, is not suitable.
	 *
	 *  @see org.apache.royale.html.beads.SingleSelectionDropTargetBead.
     *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.10
	 */
	public class TreeSingleSelectionDragSourceBead extends EventDispatcher implements IBead, IDragInitiator
	{
		/**
		 * Constructor
	     *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.10
		 */
		public function TreeSingleSelectionDragSourceBead()
		{
			super();
		}

		private var _strand:IStrand;
		private var _dragController:DragMouseController;
		private var continueDragOperation:Boolean = true;

		private var _dragType:String = "move";

		/**
		 * The type of drag and drop operation: move or copy.
	     *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.10
		 */
		public function get dragType():String
		{
			return _dragType;
		}
		public function set dragType(value:String):void
		{
			_dragType = value;
		}

		private var _approveDragStart:Function;
		/**
		 * Provides the ability to approve (or prevent) a mouseDown event being considered
		 * as the start of a drag sequence. This can be useful for renderers with some controls
		 * that must remain interactive, so that dragging is only supported by other parts of the renderer.
		 * The function should return true for the mouseDown event to be approved as the possible start
		 * of a drag sequence
		 *
		 * @param value a function that takes a MouseEvent as a parameter and returns a Boolean value that
		 * pre-approves a mouseDown event (or not)
		 */
		public function set approveDragStart(value:Function):void{
			if (_dragController) {
				_dragController.approveDragStart=value
			} else {
				_approveDragStart = value;
			}
		}
		public function get approveDragStart():Function{
			return _dragController? _dragController.approveDragStart :_approveDragStart;
		}

		private var _explicitTopmostDispatcher:IEventDispatcher;
		/**
		 * Provides the ability to specify a non-default topMostEventDispatcher.
		 * A Basic Royale application looks on the document.body tag for an associated Royale EventDispatcher instance,
		 * and the default behaviour is to consider that to be valid.
		 * Other Application types may not be associated with the body tag, so this provides a way to explicitly specify
		 * the top level instance.
		 *
		 */
		public function set explicitTopmostDispatcher(value:IEventDispatcher):void{
			if (_dragController) {
				_dragController.topMostDispatcher = value;
				_explicitTopmostDispatcher = null;
			}
			else _explicitTopmostDispatcher = value;
		}
		public function get explicitTopmostDispatcher():IEventDispatcher{
			return _dragController? _dragController.topMostDispatcher :_explicitTopmostDispatcher;
		}

		/**
		 * @private
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			_dragController = new DragMouseController();
			_dragController.topMostDispatcher = _explicitTopmostDispatcher;
			_dragController.approveDragStart = _approveDragStart;
			_strand.addBead(_dragController);

			_dragController.addEventListener(DragEvent.DRAG_START, handleDragStart);
			_dragController.addEventListener(DragEvent.DRAG_MOVE, handleDragMove);
			_dragController.addEventListener(DragEvent.DRAG_END, handleDragEnd);
		}


		/**
		 * @private
		 *  @royaleignorecoercion org.apache.royale.core.IChild
		 *  @royaleignorecoercion org.apache.royale.core.IIndexedItemRenderer
		 */
		private function handleDragStart(event:DragEvent):void
		{
			//trace("TreeSingleSelectionDragSourceBead received the DragStart");

			DragEvent.dragInitiator = this;
			DragMouseController.dragImageOffsetX = 0;
			DragMouseController.dragImageOffsetY = -30;

			var relatedObject:Object = event.relatedObject;
			var itemRenderer:IIndexedItemRenderer = getParentOrSelfByType(relatedObject as IChild, IItemRenderer) as IIndexedItemRenderer;

			if (itemRenderer) {
				DragEvent.dragSource = itemRenderer.data;
				sendStrandEvent(_strand, new ValueEvent("dragSourceSet", itemRenderer));
			}

			var newEvent:Event = new Event("start", false, true);
			continueDragOperation = true;
			dispatchEvent(newEvent);
			if (newEvent.defaultPrevented) {
				continueDragOperation = false;
			}
		}

		/**
		 * @private
		 */
		protected function handleDragMove(event:DragEvent):void
		{
			dispatchEvent(event);
		}

		/**
		 * @private
		 */
		protected function handleDragEnd(event:DragEvent):void
		{
			dispatchEvent(event);
		}

		/* IDragInitiator */

		/**
		 * Handles pre-drop actions.
	     *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.10
		 *  @royaleignorecoercion Array
		 *  @royaleignorecoercion org.apache.royale.core.ISelectionModel
		 *  @royaleignorecoercion org.apache.royale.core.IDataProviderModel
		 *  @royaleignorecoercion mx.collections.IList
		 */
		public function acceptingDrop(dropTarget:Object, type:String):void
		{
			if (!continueDragOperation) return;

			//trace("TreeSingleSelectionDragSourceBead accepting drop of type "+type);
			var newEvent:Event = new Event("accept", false, true);
			dispatchEvent(newEvent);
			if (newEvent.defaultPrevented) return;
			
			var dataProviderModel:IDataProviderModel = getModelByType(_strand,IDataProviderModel) as IDataProviderModel;
			if (dataProviderModel is ISelectionModel) {
				(dataProviderModel as ISelectionModel).selectedIndex = -1;
			}

			if (dragType == "copy") return;
			sendStrandEvent(_strand, new Event("acceptingMoveDrop"));
		}

		/**
		 * Handles post-drop actions.
	     *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.10
		 */
		public function acceptedDrop(dropTarget:Object, type:String):void
		{
			dispatchEvent(new Event("complete"));
		}

	}
}
