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
package org.apache.royale.html.beads
{
	import org.apache.royale.collections.ArrayList;
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
	import org.apache.royale.html.beads.controllers.DragMouseController;
	import org.apache.royale.utils.getParentOrSelfByType;

	/**
	 * The start event is dispatched when a DragStart event happens. The DragEvent.dragSource
	 * is set before this event is dispatched. A listener for this event can then decide if
	 * if the drag-drop action should continue or not. If not, the event should be cancelled.
     *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
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
	 *  @productversion Royale 0.9
	 */
	[Event(name="accept", type="org.apache.royale.events.Event")]

	/**
	 * The complete event is dispatched when the entire drag-and-drop operation has completed
	 * from the drag source's perspective.
     *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	[Event(name="complete", type="org.apache.royale.events.Event")]

	/**
	 * The dragMove event is dispatched while the drag action moves.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.7
	 */
	[Event(name="dragMove", type="org.apache.royale.events.DragEvent")]

	/**
	 * The dragEnd event is dispatched while the drag action stops.
	 * This is dispatched even when the drag event is aborted.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.7
	 */
	[Event(name="dragEnd", type="org.apache.royale.events.DragEvent")]
	/**
	 *  The SingleSelectionDragSourceBead brings drag capability to single-selection List components.
	 *  By adding this bead, a user can drag a row of the List to a new location within the list. This bead
	 *  should be used in conjunction with SingleSelectionDropTargetBead.
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
	 *  @productversion Royale 0.8
	 */
	public class SingleSelectionDragSourceBead extends EventDispatcher implements IBead, IDragInitiator
	{
		/**
		 * Constructor
	     *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function SingleSelectionDragSourceBead()
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
		 *  @productversion Royale 0.8
		 */
		public function get dragType():String
		{
			return _dragType;
		}
		public function set dragType(value:String):void
		{
			_dragType = value;
		}

		/**
		 * @private
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;

			_dragController = new DragMouseController();
			_strand.addBead(_dragController);

			_dragController.addEventListener(DragEvent.DRAG_START, handleDragStart);
			_dragController.addEventListener(DragEvent.DRAG_MOVE, handleDragMove);
			_dragController.addEventListener(DragEvent.DRAG_END, handleDragEnd);
		}

		private var _dragSourceIndex:int = -1;

		/**
		 * The index into the dataProvider of the strand's model where the dragSource
		 * can be found. If -1, the dragSource is not in the dataProvider.
	     *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function get dragSourceIndex():int
		{
			return _dragSourceIndex;
		}

		/**
		 * @private
		 *  @royaleignorecoercion org.apache.royale.core.IChild
		 *  @royaleignorecoercion org.apache.royale.core.IIndexedItemRenderer
		 */
		private function handleDragStart(event:DragEvent):void
		{
			//trace("SingleSelectionDragSourceBead received the DragStart");

			DragEvent.dragInitiator = this;
			DragMouseController.dragImageOffsetX = 0;
			DragMouseController.dragImageOffsetY = -30;

			var relatedObject:Object = event.relatedObject;
			var itemRenderer:IIndexedItemRenderer = getParentOrSelfByType(relatedObject as IChild, IItemRenderer) as IIndexedItemRenderer;

			if (itemRenderer) {
				_dragSourceIndex = itemRenderer.index;
				DragEvent.dragSource = itemRenderer.data;
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
		 *  @productversion Royale 0.8
		 *  @royaleignorecoercion Array
		 *  @royaleignorecoercion org.apache.royale.collections.ArrayList
		 *  @royaleignorecoercion org.apache.royale.core.ISelectionModel
		 *  @royaleignorecoercion org.apache.royale.core.IDataProviderModel
		 */
		public function acceptingDrop(dropTarget:Object, type:String):void
		{
			if (!continueDragOperation) return;

			//trace("SingleSelectionDragSourceBead accepting drop of type "+type);
			var newEvent:Event = new Event("accept", false, true);
			dispatchEvent(newEvent);
			if (newEvent.defaultPrevented) return;
			
			var dataProviderModel:IDataProviderModel = _strand.getBeadByType(IDataProviderModel) as IDataProviderModel;
			if (dataProviderModel is ISelectionModel) {
				(dataProviderModel as ISelectionModel).selectedIndex = -1;
			}

			if (dragType == "copy") return;
			if (dataProviderModel.dataProvider is Array) {
				var dataArray:Array = dataProviderModel.dataProvider as Array;

				// remove the item being selected
				DragEvent.dragSource = dataArray.splice(_dragSourceIndex,1)[0];

				// refresh the dataProvider model
				var newArray:Array = dataArray.slice()
				dataProviderModel.dataProvider = newArray;
			}
			else if (dataProviderModel.dataProvider is ArrayList) {
				var dataList:ArrayList = dataProviderModel.dataProvider as ArrayList;

				// remove the item being selected
				DragEvent.dragSource = dataList.removeItemAt(_dragSourceIndex);
			}
		}

		/**
		 * Handles post-drop actions.
	     *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function acceptedDrop(dropTarget:Object, type:String):void
		{
			//trace("SingleSelectionDragSourceBead accepted drop of type "+type);
			var value:Object = DragEvent.dragSource;

			_dragSourceIndex = -1;

			dispatchEvent(new Event("complete"));
		}

	}
}
