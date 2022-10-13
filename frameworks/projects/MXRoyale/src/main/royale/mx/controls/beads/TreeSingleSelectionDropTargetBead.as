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
	import mx.collections.IList;

	import org.apache.royale.core.DropType;
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IDataProviderModel;
	import org.apache.royale.core.IIndexedItemRenderer;
	import org.apache.royale.core.IItemRenderer;
	import org.apache.royale.core.IItemRendererOwnerView;
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.DragEvent;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.geom.Point;
	import org.apache.royale.html.beads.IDrawingLayerBead;
	import org.apache.royale.html.beads.SingleSelectionDropIndicatorBead;
	import org.apache.royale.html.beads.controllers.DropMouseController;
	import org.apache.royale.html.util.getModelByType;
	import org.apache.royale.utils.PointUtils;
	import org.apache.royale.utils.sendEvent;
	import org.apache.royale.utils.sendStrandEvent;
	import org.apache.royale.events.ValueEvent;
	import org.apache.royale.core.IChild;
	import mx.core.FlexGlobals;


	/**
	 * The enter event is dispatched when a DragEnter has been detected in the drop target
	 * strand. This event can be used to determine if the strand can and will accept the data
	 * being dragged onto it. If the data cannot be used by the drop target strand this event
	 * should be cancelled.
     *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	[Event(name="enter", type="org.apache.royale.events.Event")]

	/**
	 * The exit event is sent when the drag goes outside of the drop target space.
     *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
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
	 *  @productversion Royale 0.9
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
	 *  @productversion Royale 0.9
	 */
	[Event(name="drop", type="org.apache.royale.events.Event")]

	/**
	 * The complete event is dispatched when the drop operation has completed from the drop
	 * target's perspective.
     *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	[Event(name="complete", type="org.apache.royale.events.Event")]

	/**
	 *  The TreeSingleSelectionDropTargetBead enables items to be dropped onto single-selection Tree
	 *  components. This bead can be used with SingleSelectionDragSourceBead to enable the re-arrangement
	 *  of rows within the same tree.
     *
	 *  @see org.apache.royale.html.beads.SingleSelectionDropIndicatorBead
     *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.10
	 */
	public class TreeSingleSelectionDropTargetBead extends EventDispatcher implements IBead
	{
		/**
		 * Constructor
	     *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.10
		 */
		public function TreeSingleSelectionDropTargetBead()
		{
			super();
		}

		private var _dropController:DropMouseController;
		private var _itemRendererOwnerView:IItemRendererOwnerView;
		private var _dropIndicatorBead:SingleSelectionDropIndicatorBead;
		private var _dropIndicator:UIBase;
		private var lastItemVisited:Object;
		private var indicatorVisible:Boolean = false;

		private var _strand:IStrand;

		/**
		 * @private
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
		}

		private var _dropDirection: String = "horizontal";

		/**
		 * The direction the drop indicator should display. "horizontal" (default) or "vertical".
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
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
		 * @royaleignorecoercion org.apache.royale.html.beads.IDrawingLayerBead
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
		 * @royaleignorecoercion org.apache.royale.core.IItemRendererOwnerView
		 */
		private function get itemRendererOwnerView():IItemRendererOwnerView
		{
			if (!_itemRendererOwnerView)
				_itemRendererOwnerView = _strand.getBeadByType(IItemRendererOwnerView) as IItemRendererOwnerView;
			return _itemRendererOwnerView;
		}

		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.html.beads.SingleSelectionDropIndicatorBead
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
		 * @royaleignorecoercion org.apache.royale.core.IUIBase
		 * @royaleignorecoercion org.apache.royale.core.IItemRenderer
		 */
		private function handleDragEnter(event:DragEvent):void
		{
			//trace("TreeSingleSelectionDropTargetBead received DragEnter via: "+event.relatedObject.toString());
			var newEvent:Event = new Event("enter", false, true);
			dispatchEvent(newEvent);
			if (newEvent.defaultPrevented) return;

			var pt0:Point;
			var pt1:Point;
			var pt2:Point;

			_dropController.acceptDragDrop(event.relatedObject as IUIBase, DropType.COPY);

			var startHere:Object = event.relatedObject;
			while( !(startHere is IItemRenderer) && startHere != null) {
				startHere = startHere.parent;
			}

			if (startHere is IItemRenderer) {
				var ir:IItemRenderer = startHere as IItemRenderer;
				lastItemVisited = ir;
			} else if (itemRendererOwnerView && itemRendererOwnerView.numItemRenderers > 0)
			{
				// as long as we're assuming the last item is dropped into in case there's no item renderer under mouse
				// this is needed
				lastItemVisited = itemRendererOwnerView.getItemRendererAt(itemRendererOwnerView.numItemRenderers - 1);
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
		 */
		private function handleDragExit(event:DragEvent):void
		{
			//trace("TreeSingleSelectionDropTargetBead received DragExit via: "+event.relatedObject.toString());
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
		 * @royaleignorecoercion org.apache.royale.core.IUIBase
		 */
		private function handleDragOver(event:DragEvent):void
		{
			//trace("TreeSingleSelectionDropTargetBead received DragOver via: "+event.relatedObject.toString());
			var newEvent:Event = new Event("over", false, true);
			dispatchEvent(newEvent);
			if (event.defaultPrevented) {
				return;
			}

			var startHere:Object = event.relatedObject;
			while( !(startHere is IItemRenderer) && startHere != null) {
				startHere = startHere.parent;
			}

			if ((startHere is IItemRenderer) && _dropIndicator != null && indicatorParent) {
				displayDropIndicator(startHere as IUIBase);
				lastItemVisited = startHere;

			}
			else if (lastItemVisited && _dropIndicator != null && indicatorParent) {
				displayDropIndicator(lastItemVisited as IUIBase);
			}
		}

		/**
		 * @private
		 * @royaleignorecoercion mx.collections.IList
		 * @royaleignorecoercion org.apache.royale.core.IDataProviderModel
		 * @royaleignorecoercion org.apache.royale.core.IIndexedItemRenderer
		 * @royaleignorecoercion org.apache.royale.core.ISelectionModel
		 */
		private function handleDragDrop(event:DragEvent):void
		{
			//trace("TreeSingleSelectionDropTargetBead received DragDrop via: "+event.relatedObject.toString());

			handleDragExit(event);

			var newEvent:Event = new Event("drop", false, true);
			dispatchEvent(newEvent);
			if (newEvent.defaultPrevented) {
				return;
			}


			var startHere:Object = event.relatedObject;
			var child:IChild = startHere as IChild;
			while(child && child != _strand) {
				if (child is IIndexedItemRenderer)
				{
					startHere = child;
				}
				child = child.parent as IChild;
			}

			if (DragEvent.dragInitiator) {
				DragEvent.dragInitiator.acceptingDrop(_strand, "object");
			}

			var dragSource:Object = DragEvent.dragSource;
			sendStrandEvent(_strand, new ValueEvent( "handlingDragDrop", startHere));


			// Let the dragInitiator know the drop has been completed.
			if (DragEvent.dragInitiator) {
				DragEvent.dragInitiator.acceptedDrop(_strand, "object");
			}
			
			var dataProviderModel:IDataProviderModel = getModelByType(_strand,IDataProviderModel) as IDataProviderModel;
			if (dataProviderModel is ISelectionModel) {
				(dataProviderModel as ISelectionModel).selectedItem = dragSource;
			}

			// is this event necessary? isn't "complete" enough?
			sendStrandEvent(_strand,"dragDropAccepted");
			sendEvent(this,"complete");
		}

		COMPILE::SWF
		private function displayDropIndicator(item:IUIBase):void
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
		private function displayDropIndicator(item:IUIBase):void
		{
			var pt:Point = PointUtils.localToGlobal(new Point(0,0), item);
			pt = PointUtils.globalToLocal(pt,indicatorParent);
			if (dropDirection == "horizontal") {
				_dropIndicator.x = 0;
				_dropIndicator.y = pt.y;
			} else {
				_dropIndicator.x = pt.x;
				_dropIndicator.y = 0;
			}
		}
	}
}
