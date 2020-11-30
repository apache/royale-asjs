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
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IChild;
	import org.apache.royale.core.IDataProviderModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IItemRenderer;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.DragEvent;
	import org.apache.royale.html.DataGrid;
	import org.apache.royale.html.supportClasses.DataGridColumn;
	import org.apache.royale.html.beads.IDataGridView;
	import org.apache.royale.html.beads.SingleSelectionDragImageBead;
	import org.apache.royale.html.beads.SingleSelectionDragSourceBead;
	import org.apache.royale.html.beads.SingleSelectionDropTargetBead;
	import org.apache.royale.html.beads.SingleSelectionDropIndicatorBead;
	import org.apache.royale.html.beads.DataGridWithDrawingLayerLayout;
	import org.apache.royale.html.beads.DataGridDrawingLayerBead;

	/**
	 *  The DataGridDragDropBead bead should be added to the DataGrid when
	 *  drag and drop operations are required. Rather than using the drag and
	 *  drop beads individually, this bead will add them as needed and monitor
	 *  events to insure the drag and drop operations are handled property
	 *  for the DataGrid.
	 *
	 *  @viewbead
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	public class DataGridDragDropBead extends EventDispatcher implements IBead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function DataGridDragDropBead()
		{
			super();
		}

		private var _dragType:String = "move";

		/**
		 * The type of drag operation to perform: move or copy.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function get dragType():String
		{
			return _dragType;
		}
		public function set dragType(value:String):void
		{
			_dragType = value;
		}

		private var _allowDrag:Boolean = true;

		/**
		 * Sets whether or not to allow the DataGrid to be the source
		 * of a drag operation. The default is true.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function get allowDrag():Boolean
		{
			return _allowDrag;
		}
		public function set allowDrag(value:Boolean):void
		{
			_allowDrag = value;
		}

		private var _allowDrop:Boolean = true;

		/**
		 * Sets whether or not to allow the DataGrid to be the target
		 * of a drag/drop operation. The default is true.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function get allowDrop():Boolean
		{
			return _allowDrop;
		}
		public function set allowDrop(value:Boolean):void
		{
			_allowDrop = value;
		}


		private var _strand:IStrand;
		private var _listArea: UIBase;


		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;

			// need to add the layout bead early on to prevent the
			// default layout from being used.
			layoutBead = new DataGridWithDrawingLayerLayout();
			_strand.addBead(layoutBead);

			drawingLayerBead = new DataGridDrawingLayerBead();
			_strand.addBead(drawingLayerBead);

			IEventDispatcher(_strand).addEventListener("dataGridViewCreated", handleViewCreated);
		}

		private var dragSourceBead: SingleSelectionDragSourceBead;
		private var dropTargetBead: SingleSelectionDropTargetBead;
		private var dragImageBead:  SingleSelectionDragImageBead;
		private var dropIndicatorBead: SingleSelectionDropIndicatorBead;
		private var drawingLayerBead: DataGridDrawingLayerBead;
		private var layoutBead: DataGridWithDrawingLayerLayout;

		private var continueDragOperation: Boolean = true;

		/**
		 * @private
		 *  @royaleignorecoercion org.apache.royale.html.DataGrid
		 *  @royaleignorecoercion org.apache.royale.html.beads.IDataGridView
		 *  @royaleignorecoercion org.apache.royale.core.UIBase
		 */
		protected function handleViewCreated(event:Event):void
		{
			var host:DataGrid = _strand as DataGrid;
			var view:IDataGridView = host.view as IDataGridView;

			_listArea = view.listArea as UIBase;

			if (allowDrag) {
				dragSourceBead = new SingleSelectionDragSourceBead();
				dragSourceBead.dragType = dragType;
				dragSourceBead.addEventListener("start", handleDragStart);
				_strand.addBead(dragSourceBead);

				dragImageBead = new SingleSelectionDragImageBead();
				_strand.addBead(dragImageBead);
			}

			if (allowDrop) {
				dropTargetBead = new SingleSelectionDropTargetBead();
				dropTargetBead.addEventListener("enter", handleDragOver);
				dropTargetBead.addEventListener("exit", handleDragOver);
				dropTargetBead.addEventListener("over", handleDragOver);
				dropTargetBead.addEventListener("drop", handleDrop);
				_strand.addBead(dropTargetBead);

				dropIndicatorBead = new SingleSelectionDropIndicatorBead();
				_strand.addBead(dropIndicatorBead);
			}
		}

		/**
		 * @private
		 */
		private function handleDragStart(event:Event):void
		{
			var data:Object = DragEvent.dragSource;

			// In general, the DataGrid can accept anything because it does not
			// know about the structure of the data. Only when that data has been
			// dropped into it and it tries to incorporate it (or rather, its
			// itemRenderers try to display it) will it be discovered if the
			// data is compatible. However, some types of data are obvious that
			// they cannot be accepted.

			if (data is DataGridColumn) {
				continueDragOperation = false;
			} else if ((data is String) || (data is Number) || (data is Date)) {
				continueDragOperation = false;
			} else {
				continueDragOperation = true;
			}

			if (!continueDragOperation) {
				event.preventDefault();
			}
		}

		/**
		 * @private
		 */
		private function handleDragOver(event:Event):void
		{
			if (!continueDragOperation) {
				event.preventDefault();
			}
		}

		private function handleDrop(event:Event):void
		{
			if (!continueDragOperation) {
				event.preventDefault();
			}
		}
	}
}

