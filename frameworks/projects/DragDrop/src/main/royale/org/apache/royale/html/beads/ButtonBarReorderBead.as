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
	import org.apache.royale.core.IDataProviderModel;
	import org.apache.royale.core.IDocument;
	import org.apache.royale.core.IDragInitiator;
	import org.apache.royale.core.IItemRenderer;
	import org.apache.royale.core.IItemRendererOwnerView;
    import org.apache.royale.core.ItemRendererOwnerViewBead;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.IParent;
	import org.apache.royale.core.ILayoutHost;
	import org.apache.royale.core.IChild;
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
	import org.apache.royale.html.beads.controllers.DropMouseController;
	import org.apache.royale.html.supportClasses.DataItemRenderer;
	import org.apache.royale.utils.PointUtils;
	import org.apache.royale.utils.UIUtils;


	/**
	 *  The ButtonBarReorderBead bead can be added to a ButtonBar to re-order the buttons
	 *  using drag-and-drop. This bead will add additional beads as necessary.
	 *
	 *  @see org.apache.royale.html.beads.SingleSelectionDropTargetBead.
     *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	public class ButtonBarReorderBead extends EventDispatcher implements IBead
	{
		/**
		 * Constructor
	     *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function ButtonBarReorderBead()
		{
			super();
		}

		private var _strand:IStrand;
		private var _dragController:DragMouseController;
		private var _dropController:DropMouseController;
		private var _dropIndicatorBead:SingleSelectionDropIndicatorBead;
		private var _dropIndicator:UIBase;
		private var lastItemVisited:Object;
		private var indicatorVisible:Boolean = false;
		private var dropDirection:String;

		/**
		 * @private
		 * @royaleignoretypecoercion org.apache.royale.events.IEventDispatcher
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;

			dropDirection = "vertical";

			_dragController = new DragMouseController();
			_strand.addBead(_dragController);
			var host:IEventDispatcher = _strand as IEventDispatcher;
			host.removeEventListener(DragEvent.DRAG_START, handleDragStart);
			host.removeEventListener(DragEvent.DRAG_MOVE, handleDragMove);
			host.removeEventListener(DragEvent.DRAG_END, handleDragEnd);

			host.addEventListener(DragEvent.DRAG_START, handleDragStart);
			host.addEventListener(DragEvent.DRAG_MOVE, handleDragMove);
			host.addEventListener(DragEvent.DRAG_END, handleDragEnd);

			_dropController = new DropMouseController();
			_strand.addBead(_dropController);

			_dropController.addEventListener(DragEvent.DRAG_ENTER, handleDragEnter);
			_dropController.addEventListener(DragEvent.DRAG_EXIT, handleDragExit);
			_dropController.addEventListener(DragEvent.DRAG_OVER, handleDragOver);
			_dropController.addEventListener(DragEvent.DRAG_DROP, handleDragDrop);
		}

		/**
		 * @private
		 * The index of the item being moved
		 */
		private var sourceIndex:int = -1;

		/**
		 * @private
		 * The index of where the item is being moved before or if -1,
		 * the item is being put at the end.
		 */
		private var targetIndex:int = -1;

		/**
		 * @private
		 *  @royaleignorecoercion org.apache.royale.core.ILayoutHost
		 *  @royaleignorecoercion org.apache.royale.core.IParent
		 *  @royaleignorecoercion org.apache.royale.core.IChild
		 *  @royaleignorecoercion org.apache.royale.core.IItemRenderer
		 */
		private function handleDragStart(event:DragEvent):void
		{
			trace("ButtonBarReorderBead received the DragStart");

			DragMouseController.dragImageOffsetX = 0;
			DragMouseController.dragImageOffsetY = -30;
			//TODO The itemRenderers should be IIndexedItemRenderers, so there shouldn't be a need for itemRendererOwnerView
			var startHere:Object = event.relatedObject;
			while (!(startHere is IItemRenderer) && startHere != null) {
				startHere = startHere.itemRendererOwnerView;
			}
			if (startHere is IItemRenderer) {
				var p:IParent = (startHere.itemRendererOwnerView as ILayoutHost).contentView as IParent;
				sourceIndex = p.getElementIndex(startHere as IChild);
				DragEvent.dragSource = (startHere as IItemRenderer).data;
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

		/**
		 * @private
		 *  @royaleignorecoercion org.apache.royale.core.IItemRenderer
		 *  @royaleignorecoercion org.apache.royale.core.IUIBase
		 */
		private function handleDragEnter(event:DragEvent):void
		{
			trace("ButtonBarReorderBead received DragEnter via: "+event.relatedObject.toString());
			var pt0:Point;
			var pt1:Point;
			var pt2:Point;

			var startHere:Object = event.relatedObject;
			while( !(startHere is IItemRenderer) && startHere != null) {
				startHere = startHere.parent;
			}

			if (startHere is IItemRenderer) {
				var ir:IItemRenderer = startHere as IItemRenderer;
				lastItemVisited = ir;
			}

			if (lastItemVisited && !indicatorVisible && indicatorParent) {
				var di:UIBase = getDropIndicator(lastItemVisited, (dropDirection == "horizontal") ? indicatorParent.width : 4,
					                             (dropDirection == "horizontal") ? 4 : indicatorParent.height);
				indicatorVisible = true;
				displayDropIndicator(lastItemVisited as IUIBase);

				if (indicatorParent != null) {
					indicatorParent.addElement(di);
				}
			}

		}

		/**
		 * @private
		 *  @royaleignorecoercion org.apache.royale.core.IUIBase
		 *  @royaleignorecoercion org.apache.royale.core.UIBase
		 */
		private function handleDragOver(event:DragEvent):void
		{
			trace("ButtonBarReorderBead received DragOver via: "+event.relatedObject.toString());
			var pt0:Point;
			var pt1:Point;
			var pt2:Point;

			var startHere:Object = event.relatedObject;
			while( !(startHere is IItemRenderer) && startHere != null) {
				startHere = startHere.parent;
			}

			if ((startHere is IItemRenderer) && _dropIndicator != null && indicatorParent) {
				displayDropIndicator(startHere as IUIBase);
				lastItemVisited = startHere;

			}
			else if (lastItemVisited && _dropIndicator != null && indicatorParent) {
				var lastItem:UIBase = lastItemVisited as UIBase;
				displayDropIndicator(lastItemVisited as IUIBase);
			}
		}

		/**
		 * @private
		 */
		private function handleDragExit(event:DragEvent):void
		{
			trace("ButtonBarReorderBead received DragExit via: "+event.relatedObject.toString());

			if (indicatorVisible) {
				if (indicatorParent != null) {
					indicatorParent.removeElement(_dropIndicator);
				}
				indicatorVisible = false;
			}
		}

		/**
		 * @private
		 *  @royaleignorecoercion Array
		 *  @royaleignorecoercion org.apache.royale.collections.ArrayList
		 *  @royaleignorecoercion org.apache.royale.core.IItemRenderer
		 *  @royaleignorecoercion org.apache.royale.core.ILayoutHost
		 *  @royaleignorecoercion org.apache.royale.core.IParent
		 *  @royaleignorecoercion org.apache.royale.core.IDataProviderModel
		 *  @royaleignorecoercion org.apache.royale.core.ItemRendererOwnerViewBead
		 */
		private function handleDragDrop(event:DragEvent):void
		{
			trace("ButtonBarReorderBead received DragDrop via: "+event.relatedObject.toString());

			handleDragExit(event);

			targetIndex = -1; // assume after the end unless proven otherwise.

			var itemRendererOwnerView:IParent;

			var startHere:Object = event.relatedObject;
			while( !(startHere is IItemRenderer) && startHere != null) {
				startHere = startHere.parent;
			}

			if (startHere is IItemRenderer) {
				var ir:IItemRenderer = startHere as IItemRenderer;
				trace("-- dropping onto an existing object: "+ir.data.toString());
				
				var ownerViewBead:ItemRendererOwnerViewBead = ir.getBeadByType(ItemRendererOwnerViewBead) as ItemRendererOwnerViewBead;
				itemRendererOwnerView = (ownerViewBead.ownerView as ILayoutHost).contentView as IParent;
				targetIndex = itemRendererOwnerView.getElementIndex(ir);
			}
			else  {
				trace("-- dropping after the last item");
			}

			var dataProviderModel:IDataProviderModel = _strand.getBeadByType(IDataProviderModel) as IDataProviderModel;

			var dragSource:Object;

			if (dataProviderModel.dataProvider is Array) {
				var dataArray:Array = dataProviderModel.dataProvider as Array;

				dragSource = dataArray[sourceIndex];

 				// remove the item from its original position
 				dataArray.splice(sourceIndex,1)

				// insert the item being dropped
				if (targetIndex == -1) {
					// append to the end
					dataArray.push(dragSource);
				} else {
					// insert before targetIndex
					dataArray.splice(targetIndex, 0, dragSource);
				}

				var newArray:Array = dataArray.slice()
				dataProviderModel.dataProvider = newArray;
			}
			else if (dataProviderModel.dataProvider is ArrayList) {
				var dataList:ArrayList = dataProviderModel.dataProvider as ArrayList;

				dragSource = dataList.getItemAt(sourceIndex);

 				// remove the item from its original position
 				dataList.removeItemAt(sourceIndex);

				// insert the item being dropped
				if (targetIndex == -1) {
					// sppend to the end
					dataList.addItem(dragSource);
				} else {
					// insert before target index
					dataList.addItemAt(dragSource, targetIndex);
				}
			}
		}

		protected var _indicatorParent:UIBase;
		/**
		 *  @royaleignorecoercion org.apache.royale.htmls.beads.IDrawingLayerBead
		 */
		protected function get indicatorParent():UIBase
		{
			if (_indicatorParent == null) {
				var layerBead:IDrawingLayerBead = _strand.getBeadByType(IDrawingLayerBead) as IDrawingLayerBead;
				if (layerBead != null) {
					_indicatorParent = layerBead.layer;
				}
			}
			return _indicatorParent;
		}

		/**
		 * @private
		 *  @royaleignorecoercion org.apache.royale.htmls.beads.SingleSelectionDropIndicatorBead
		 */
		protected function getDropIndicator(ir:Object, width:Number, height:Number):UIBase
		{
			if (_dropIndicatorBead == null) {
				_dropIndicatorBead = _strand.getBeadByType(SingleSelectionDropIndicatorBead) as SingleSelectionDropIndicatorBead;
				if (_dropIndicatorBead == null) return null;
			}
			_dropIndicator = _dropIndicatorBead.getDropIndicator(ir, width, height);
			return _dropIndicator;
		}

		COMPILE::SWF
		private function displayDropIndicator(item:IUIBase):void
		{
			var pt0:Point;
			var pt1:Point;
			var pt2:Point;

			if (dropDirection == "horizontal") {
				pt0 = new Point(0, item.y);
				pt1 = PointUtils.localToGlobal(pt0, item.parent);
				pt2 = PointUtils.globalToLocal(pt1, indicatorParent);
				_dropIndicator.x = 0;
				_dropIndicator.y = pt2.y - 1;
			}
			else {
				pt0 = new Point(item.x, 0);
				pt1 = PointUtils.localToGlobal(pt0, item.parent);
				pt2 = PointUtils.globalToLocal(pt1, indicatorParent);
				_dropIndicator.x = pt2.x - 1;
				_dropIndicator.y = 0;
			}
		}

		COMPILE::JS
		private function displayDropIndicator(item:IUIBase):void
		{
			if (dropDirection == "horizontal") {
				_dropIndicator.x = 0;
				_dropIndicator.y = item.y;
			} else {
				_dropIndicator.x = item.x;
				_dropIndicator.y = 0;
			}
		}

	}
}
