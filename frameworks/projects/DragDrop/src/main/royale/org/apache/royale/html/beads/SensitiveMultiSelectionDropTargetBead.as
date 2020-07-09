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
	import org.apache.royale.core.DropType;
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IMultiSelectionModel;
	import org.apache.royale.core.IItemRendererOwnerView;
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.DragEvent;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.geom.Point;
	import org.apache.royale.html.beads.controllers.DropMouseController;
	import org.apache.royale.utils.PointUtils;
	import org.apache.royale.utils.sendStrandEvent;


	/**
	 * The enter event is dispatched when a DragEnter has been detected in the drop target
	 * strand. This event can be used to determine if the strand can and will accept the data
	 * being dragged onto it. If the data cannot be used by the drop target strand this event
	 * should be cancelled.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.7
	 */
	[Event(name="enter", type="org.apache.royale.events.Event")]

	/**
	 * The exit event is sent when the drag goes outside of the drop target space.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.7
	 */
	[Event(name="exit", type="org.apache.royale.events.Event")]

	/**
	 * The over event is dispatched while the drag is happening over the drop target space. This
	 * event may be cancelled if that particular area of the drop target cannot accept the
	 * drag source data.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.7
	 */
	[Event(name="over", type="org.apache.royale.events.Event")]

	/**
	 * The drop event is dispatched just prior to incorporating the drag source data into the drop
	 * target's dataProvider. This event may be cancelled to prevent that from happening.
	 * Note that a "exit" event always precedes this event to allow any drag-drop graphics
	 * to be cleared.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.7
	 */
	[Event(name="drop", type="org.apache.royale.events.Event")]

	/**
	 * The complete event is dispatched when the drop operation has completed from the drop
	 * target's perspective.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.7
	 */
	[Event(name="complete", type="org.apache.royale.events.Event")]

	/**
	 *  The SensitiveMultiSelectionDropTargetBead enables items to be dropped onto multi-selection List
	 *  components. When the pointing device is in the first half of an item renderer it assumes the item is to be dropped on that item renderer.
	 *  If it is on the second half it assumes the drop target is the next item renderer.
	 *
	 *  @see org.apache.royale.html.beads.SingleSelectionDropTargetBead
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.7
	 */
	public class SensitiveMultiSelectionDropTargetBead extends EventDispatcher implements IBead
	{
		/**
		 * Constructor
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function SensitiveMultiSelectionDropTargetBead()
		{
			super();
		}

		private var _dropController:DropMouseController;
		private var _itemRendererOwnerView:IItemRendererOwnerView;
		private var _dropIndicatorBead:SingleSelectionDropIndicatorBead;
		private var _dropIndicator:UIBase;
		private var targetIndex:int = -1;
		private var indicatorVisible:Boolean = false;
		private var isEndOfList:Boolean = false;

		private var _strand:IStrand;

		/**
		 * @private
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;

			_dropController = new DropMouseController();
			_strand.addBead(_dropController);

			_dropController.addEventListener(DragEvent.DRAG_ENTER, handleDragEnter);
			_dropController.addEventListener(DragEvent.DRAG_EXIT, handleDragExit);
			_dropController.addEventListener(DragEvent.DRAG_OVER, handleDragOver);
			_dropController.addEventListener(DragEvent.DRAG_DROP, handleDragDrop);
			(_strand as IEventDispatcher).addEventListener(DragEvent.DRAG_MOVE, handleDragMove);
		}

		private var _dropDirection: String = "horizontal";

		/**
		 * The direction the drop indicator should display. "horizontal" (default) or "vertical".
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function get dropDirection():String
		{
			return _dropDirection;
		}
		public function set dropDirection(value:String):void
		{
			_dropDirection = value;
		}

		protected var _indicatorParent:UIBase;

		/**
		 * @private
		 *  @royaleignorecoercion org.apache.royale.html.beads.IDrawingLayerBead
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
		 *  @royaleignorecoercion org.apache.royale.core.IItemRendererOwnerView
		 */
		private function get itemRendererOwnerView():IItemRendererOwnerView
		{
			if (!_itemRendererOwnerView)
				_itemRendererOwnerView = _strand.getBeadByType(IItemRendererOwnerView) as IItemRendererOwnerView;
			return _itemRendererOwnerView;
		}

		/**
		 * @private
		 *  @royaleignorecoercion org.apache.royale.html.beads.SingleSelectionDropIndicatorBead
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

		/**
		 * @private
		 *  @royaleignorecoercion org.apache.royale.core.IUIBase
		 */
		private function handleDragEnter(event:DragEvent):void
		{
			var newEvent:Event = new Event("enter", false, true);
			dispatchEvent(newEvent);
			if (newEvent.defaultPrevented) return;


			var pt0:Point;
			var pt1:Point;
			var pt2:Point;

			_dropController.acceptDragDrop(event.relatedObject as IUIBase, DropType.COPY);
		}
		
		/**
		 *  @royaleignorecoercion org.apache.royale.core.IUIBase
		 */
		private function checkForNextItemRenderer(e:DragEvent):void
		{
			var changeMade:Boolean = true;
			var calculatedIndex:int = -1;
			for (var i:int = 0; i < itemRendererOwnerView.numItemRenderers; i++)
			{
				var ir:IUIBase = itemRendererOwnerView.getItemRendererAt(i) as IUIBase;
				var localY:Number = PointUtils.globalToLocal(new Point(e.clientX, e.clientY), ir).y;
				if (localY >= 0 && localY <= ir.height)
				{
					calculatedIndex = i;
					if (localY > ir.height / 2)
					{
						calculatedIndex++;
					}
					break;
				}
			}
			if (targetIndex != calculatedIndex && calculatedIndex != -1 && indicatorParent && (targetIndex != calculatedIndex || !indicatorVisible)) {
				targetIndex = calculatedIndex;
				// in case we're at the end of the list, we want to choose the last renderer
				// but we also want to drop the source after the least renderer, not before it
				isEndOfList = calculatedIndex == itemRendererOwnerView.numItemRenderers;
				// calculated index may have been increased beyond bounds
				var lastItemVisitedIndex:int = !isEndOfList ? calculatedIndex : calculatedIndex - 1;
				var lastItemVisited:IUIBase = itemRendererOwnerView.getItemRendererAt(lastItemVisitedIndex) as IUIBase;
				
				var di:UIBase = getDropIndicator(lastItemVisited, (dropDirection == "horizontal") ? indicatorParent.width : 4,
					(dropDirection == "horizontal") ? 4 : indicatorParent.height);
				if (indicatorParent != null) {
					indicatorParent.addElement(di);
				}
				displayDropIndicator(lastItemVisited, isEndOfList);
				indicatorVisible = true;
			}
		}
		
		/**
		 * @private
		 */
		private function handleDragExit(event:DragEvent):void
		{
			//trace("MultiSelectionDropTargetBead received DragExit via: "+event.relatedObject.toString());
			dispatchEvent(new Event("exit", false, true));

			if (indicatorVisible) {
				if (indicatorParent != null) {
					indicatorParent.removeElement(_dropIndicator);
				}
				indicatorVisible = false;
			}
		}

		/**
		 * @private
		 */
		private function handleDragOver(event:DragEvent):void
		{
			//trace("MultiSelectionDropTargetBead received DragOver via: "+event.relatedObject.toString());
			var newEvent:Event = new Event("over", false, true);
			dispatchEvent(newEvent);
			if (event.defaultPrevented) {
				return;
			}
		}

		/**
		 * @private
		 */
		private function handleDragMove(event:DragEvent):void
		{
			checkForNextItemRenderer(event);
		}

		/**
		 * @private
		 *  @royaleignorecoercion Array
		 *  @royaleignorecoercion org.apache.royale.collections.ArrayList
		 *  @royaleignorecoercion org.apache.royale.core.IMultiSelectionModel
		 *  @royaleignorecoercion org.apache.royale.core.ISelectionModel
		 */
		private function handleDragDrop(event:DragEvent):void
		{
			//trace("SingleSelectionDropTargetBead received DragDrop via: "+event.relatedObject.toString());

			handleDragExit(event);

			var newEvent:Event = new Event("drop", false, true);
			dispatchEvent(newEvent);
			if (newEvent.defaultPrevented) {
				return;
			}


			var dragSource:Array = DragEvent.dragSource as Array;
			var calculatedTargetIndex:int = targetIndex;

			// dragging somewhere higher on the list, fix items jumping down before it's dropped
			for (var i:int = 0; i < calculatedTargetIndex; i++)
			{
				if (itemRendererOwnerView.getItemRendererAt(i).data == dragSource[0])
				{
					calculatedTargetIndex--;
					break;
				}
			}
			
			if (DragEvent.dragInitiator) {
				DragEvent.dragInitiator.acceptingDrop(_strand, "object");
			}

			var dataProviderModel:IMultiSelectionModel = _strand.getBeadByType(IMultiSelectionModel) as IMultiSelectionModel;
			var myTargetIndex:int = calculatedTargetIndex > -1 ? calculatedTargetIndex : 0;
			if (dataProviderModel.dataProvider is Array) {
				var dataArray:Array = dataProviderModel.dataProvider as Array;
				for (i = 0; i < dragSource.length; i++)
				{
					dataArray.insertAt(myTargetIndex++, dragSource[i]);
				}
				var newArray:Array = dataArray.slice()
				dataProviderModel.dataProvider = newArray;
			} else if (dataProviderModel.dataProvider is ArrayList)
			{
				var dataList:ArrayList = dataProviderModel.dataProvider as ArrayList;
				for (i = 0; i < dragSource.length; i++)
				{
					dataList.addItemAt(dragSource[i], myTargetIndex++);
				}
			}

			// Let the dragInitiator know the drop has been completed.
			if (DragEvent.dragInitiator) {
				DragEvent.dragInitiator.acceptedDrop(_strand, "object");
			}
			
			if (dataProviderModel is ISelectionModel) {
				(dataProviderModel as ISelectionModel).selectedIndex = calculatedTargetIndex;
			}

			// is this event necessary? isn't "complete" enough?
			sendStrandEvent(_strand,"dragDropAccepted");

			dispatchEvent(new Event("complete"));
		}

		COMPILE::SWF
		private function displayDropIndicator(item:IUIBase, isEndOfList:Boolean=false):void
		{
			var pt0:Point;
			var pt1:Point;
			var pt2:Point;

			if (dropDirection == "horizontal") {
				pt0 = new Point(0, item.y+item.height);
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
		private function displayDropIndicator(item:IUIBase, isEndOfList:Boolean=false):void
		{
			var pt:Point = PointUtils.localToGlobal(new Point(0,0), item);
			pt = PointUtils.globalToLocal(pt,indicatorParent);
			if (dropDirection == "horizontal") {
				_dropIndicator.x = 0;
				_dropIndicator.y = pt.y + (isEndOfList ? item.height : 0);
			} else {
				_dropIndicator.x = pt.x + (isEndOfList ? item.width : 0);
				_dropIndicator.y = 0;
			}
		}
	}
}
