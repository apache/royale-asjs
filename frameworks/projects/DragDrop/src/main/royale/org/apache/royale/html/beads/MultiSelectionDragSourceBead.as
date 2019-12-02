
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
	import org.apache.royale.core.IMultiSelectionModel;
	import org.apache.royale.core.IDocument;
	import org.apache.royale.core.IDragInitiator;
	import org.apache.royale.core.IItemRenderer;
	import org.apache.royale.core.ILayoutHost;
	import org.apache.royale.core.IItemRendererParent;
	import org.apache.royale.core.IParent;
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.events.DragEvent;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.geom.Point;
	import org.apache.royale.geom.Rectangle;
	import org.apache.royale.html.Group;
	import org.apache.royale.html.Label;
	import org.apache.royale.html.beads.controllers.DragMouseController;
	import org.apache.royale.html.supportClasses.DataItemRenderer;
	import org.apache.royale.utils.PointUtils;
	import org.apache.royale.utils.UIUtils;
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
	 *  The MultiSelectionDragSourceBead brings drag capability to single-selection List components.
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
	 *  @productversion Royale 0.9.7
	 */
	public class MultiSelectionDragSourceBead extends EventDispatcher implements IBead, IDragInitiator
	{
		/**
		 * Constructor
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function MultiSelectionDragSourceBead()
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
		 *  @productversion Royale 0.9.7
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

			IEventDispatcher(_strand).addEventListener(DragEvent.DRAG_START, handleDragStart);
			IEventDispatcher(_strand).addEventListener(DragEvent.DRAG_MOVE, handleDragMove);
			IEventDispatcher(_strand).addEventListener(DragEvent.DRAG_END, handleDragEnd);
		}

		/**
		 * The index into the dataProvider of the strand's model where the dragSource
		 * can be found. If -1, the dragSource is not in the dataProvider.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function get dragSourceIndices():Array
		{
			var dataProviderModel:IMultiSelectionModel = _strand.getBeadByType(IMultiSelectionModel) as IMultiSelectionModel;
			return dataProviderModel.selectedIndices;
		}

		/**
		 * @private
		 */
		private function handleDragStart(event:DragEvent):void
		{
			//trace("MultiSelectionDragSourceBead received the DragStart");

			DragEvent.dragInitiator = this;
			DragMouseController.dragImageOffsetX = 0;
			DragMouseController.dragImageOffsetY = -30;

			var dataProviderModel:IMultiSelectionModel = _strand.getBeadByType(IMultiSelectionModel) as IMultiSelectionModel;
			DragEvent.dragSource = dataProviderModel.selectedItems;

			var newEvent:Event = new Event("start", false, true);
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
			// ignored for now
		}

		/**
		 * @private
		 */
		protected function handleDragEnd(event:DragEvent):void
		{
			// ignored for now
		}

		/* IDragInitiator */

		/**
		 * Handles pre-drop actions.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function acceptingDrop(dropTarget:Object, type:String):void
		{
			if (!continueDragOperation) return;

			//trace("MultiSelectionDragSourceBead accepting drop of type "+type);
			var newEvent:Event = new Event("accept", false, true);
			dispatchEvent(newEvent);
			if (newEvent.defaultPrevented) return;
			
			var dataProviderModel:IMultiSelectionModel = _strand.getBeadByType(IMultiSelectionModel) as IMultiSelectionModel;
			if (dataProviderModel is ISelectionModel) {
				(dataProviderModel as IMultiSelectionModel).selectedIndices = null;
			}

			if (dragType == "copy") return;
			var dragSource:Array = DragEvent.dragSource as Array;
			if (dataProviderModel.dataProvider is Array) {
				var dataArray:Array = dataProviderModel.dataProvider as Array;

				for (var i:int = 0; i < dragSource.length; i++)
				{
					dataArray.removeAt(dataArray.indexOf(dragSource[i]));
				}	

				// refresh the dataProvider model
				var newArray:Array = dataArray.slice()
				dataProviderModel.dataProvider = newArray;
			}
			else if (dataProviderModel.dataProvider is ArrayList) {
				var dataList:ArrayList = dataProviderModel.dataProvider as ArrayList;

				for (i = 0; i < dragSource.length; i++)
				{
					dataList.removeItem(dragSource[i]);
				}	
			}
		}

		/**
		 * Handles post-drop actions.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function acceptedDrop(dropTarget:Object, type:String):void
		{
			var dataProviderModel:IMultiSelectionModel = _strand.getBeadByType(IMultiSelectionModel) as IMultiSelectionModel;
			dataProviderModel.selectedIndices = null;
			dispatchEvent(new Event("complete"));
		}

	}
}
