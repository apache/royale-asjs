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
package org.apache.flex.html.beads
{
	import org.apache.flex.collections.ArrayList;
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IChild;
	import org.apache.flex.core.IDataProviderModel;
	import org.apache.flex.core.IDocument;
	import org.apache.flex.core.IDragInitiator;
	import org.apache.flex.core.IItemRenderer;
	import org.apache.flex.core.IItemRendererParent;
	import org.apache.flex.core.IParent;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.events.DragEvent;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.EventDispatcher;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.geom.Point;
	import org.apache.flex.geom.Rectangle;
	import org.apache.flex.html.Group;
	import org.apache.flex.html.Label;
	import org.apache.flex.html.beads.controllers.DragMouseController;
	import org.apache.flex.html.supportClasses.DataItemRenderer;
	import org.apache.flex.utils.PointUtils;
	import org.apache.flex.utils.UIUtils;
	import org.apache.flex.utils.getParentOrSelfByType;


	/**
	 *  The SingleSelectionDragSourceBead brings drag capability to single-selection List components.
	 *  By adding this bead, a user can drag a row of the List to a new location within the list. This bead
	 *  should be used in conjunction with SingleSelectionDropTargetBead.
	 *
	 *  This bead adds a new event to the strand, "dragImageNeeded", which is dispatched on the strand
	 *  just prior to the dragImage's appearance. An event listener can create its own dragImage if the
	 *  default, taken from the data item, is not suitable.
	 *
	 *  @see org.apache.flex.html.beads.SingleSelectionDropTargetBead.
     *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.8
	 */
	public class SingleSelectionDragSourceBead extends EventDispatcher implements IBead, IDragInitiator
	{
		/**
		 * Constructor
	     *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function SingleSelectionDragSourceBead()
		{
			super();
		}

		private var _strand:IStrand;
		private var _dragController:DragMouseController;

		private var _dragType:String = "move";

		/**
		 * The type of drag and drop operation: move or copy.
	     *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
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

		private var indexOfDragSource:int = -1;

		/**
		 * @private
		 */
		private function handleDragStart(event:DragEvent):void
		{
			trace("SingleSelectionDragSourceBead received the DragStart");

			DragEvent.dragInitiator = this;
			DragMouseController.dragImageOffsetX = 0;
			DragMouseController.dragImageOffsetY = -30;

			var itemRenderer:IItemRenderer = getParentOrSelfByType(event.target as IChild, IItemRenderer) as IItemRenderer;

			if (itemRenderer) {
				var p:UIBase = itemRenderer.itemRendererParent as UIBase;
				indexOfDragSource = p.getElementIndex(itemRenderer as IChild);
				DragEvent.dragSource = (itemRenderer as IItemRenderer).data;
			}
		}

		/**
		 * @private
		 */
		protected function handleDragMove(event:DragEvent):void
		{
		}

		/**
		 * @private
		 */
		protected function handleDragEnd(event:DragEvent):void
		{
		}

		/* IDragInitiator */

		/**
		 * Handles pre-drop actions.
	     *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function acceptingDrop(dropTarget:Object, type:String):void
		{
			trace("SingleSelectionDragSourceBead accepting drop of type "+type);
			if (dragType == "copy") return;

			var dataProviderModel:IDataProviderModel = _strand.getBeadByType(IDataProviderModel) as IDataProviderModel;
			if (dataProviderModel.dataProvider is Array) {
				var dataArray:Array = dataProviderModel.dataProvider as Array;

				// remove the item being selected
				DragEvent.dragSource = dataArray.splice(indexOfDragSource,1)[0];

				// refresh the dataProvider model
				var newArray:Array = dataArray.slice()
				dataProviderModel.dataProvider = newArray;
			}
			else if (dataProviderModel.dataProvider is ArrayList) {
				var dataList:ArrayList = dataProviderModel.dataProvider as ArrayList;

				// remove the item being selected
				DragEvent.dragSource = dataList.removeItemAt(indexOfDragSource);

				// refresh the dataProvider model
				var newList:ArrayList = new ArrayList(dataList.source);
				dataProviderModel.dataProvider = newList;
			}
		}

		/**
		 * Handles post-drop actions.
	     *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function acceptedDrop(dropTarget:Object, type:String):void
		{
			trace("SingleSelectionDragSourceBead accepted drop of type "+type);
			var value:Object = DragEvent.dragSource;
			trace(" -- index: "+indexOfDragSource+" of data: "+value.toString());

			indexOfDragSource = -1;
		}

	}
}
