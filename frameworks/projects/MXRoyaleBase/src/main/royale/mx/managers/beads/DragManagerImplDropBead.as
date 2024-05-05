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
package mx.managers.beads
{
	// import org.apache.royale.collections.ArrayList;
	// import org.apache.royale.core.DropType;
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IItemRendererOwnerView;
	import org.apache.royale.reflection.getQualifiedClassName;

// import org.apache.royale.core.IChild;
	// import org.apache.royale.core.IDataProviderModel;
	// import org.apache.royale.core.IItemRenderer;
	// import org.apache.royale.core.ItemRendererOwnerViewBead;
	// import org.apache.royale.core.IParent;
	// import org.apache.royale.core.ILayoutHost;
	// import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.DragEvent;
	// import org.apache.royale.events.Event;
	// import org.apache.royale.events.EventDispatcher;
	// import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.geom.Point;
	// import org.apache.royale.geom.Rectangle;
	import org.apache.royale.html.beads.controllers.DropMouseController;
	import org.apache.royale.utils.PointUtils;
	// import org.apache.royale.core.IIndexedItemRenderer;
	import org.apache.royale.utils.sendStrandEvent;
	// import org.apache.royale.utils.sendEvent;
	// import org.apache.royale.html.util.getModelByType;
	// import mx.managers.DragManagerImpl;
	import mx.events.DragEvent;
	import mx.core.IUIComponent;
	import mx.core.DragSource;


	/**
	 * Bead to set up DragManagerImpl target events
     *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.10
	 */

	/**
	 *  The SingleSelectionDropTargetBead enables items to be dropped onto single-selection List
	 *  components. This bead can be used with SingleSelectionDragSourceBead to enable the re-arrangement
	 *  of rows within the same list.
     *
	 *  @see org.apache.royale.html.beads.SingleSelectionDropIndicatorBead
     *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	public class DragManagerImplDropBead implements IBead
	{

		private var _dropController:DropMouseController;
		private var _itemRendererOwnerView:IItemRendererOwnerView;
		// private var _dropIndicatorBead:SingleSelectionDropIndicatorBead;
		private var _dropIndicator:UIBase;
		private var lastItemVisited:Object;
		private var indicatorVisible:Boolean = false;
		private static var _dragInitiator:IUIComponent;
		public static function set dragInitiator(value:IUIComponent):void{
			dragTarget = null;
			_dragInitiator = value;
		}

		private var _handled:Boolean;
		private var _track:Boolean;
		public function handleCreationEvent(event:org.apache.royale.events.DragEvent):Boolean{
			_handled = false;
			_track = true;
			switch(event.type) {
				case org.apache.royale.events.DragEvent.DRAG_ENTER:
					handleDragEnter(event);
					break;
				case org.apache.royale.events.DragEvent.DRAG_EXIT:
					handleDragExit(event);
					break;
				case org.apache.royale.events.DragEvent.DRAG_OVER:
					handleDragOver(event);
					break;
				case org.apache.royale.events.DragEvent.DRAG_DROP:
					handleDragDrop(event);
					break;
				default:
					trace('unknown creation event ', event.type)
					break;

			}
			var ret:Boolean = _handled;
			_handled = false;
			_track = false;
			return ret;
		}


		private static var dragAcceptTarget:IUIComponent;
		public static function set dragTarget(value:IUIComponent):void{
			if (!_dragInitiator) value = null;
			/*if (dragAcceptTarget && value != dragAcceptTarget) {
				sendDragEvent(mx.events.DragEvent.DRAG_EXIT, dragAcceptTarget);
			}*/
			dragAcceptTarget = value;
		}

		private static function sendDragEvent(type:String, strand:IStrand, derivedFrom:org.apache.royale.events.DragEvent):void
		{
			//var dragEvent:mx.events.DragEvent = new mx.events.DragEvent(type, false, true, _dragInitiator, org.apache.royale.events.DragEvent.dragSource as DragSource);
			var dragEvent:mx.events.DragEvent = mx.events.DragEvent.createMxDragEventFromRoyaleDragEvent(type,derivedFrom,false, true, null);

			dragEvent.dragInitiator = _dragInitiator;


			sendStrandEvent(strand, dragEvent);
		}


		private var _strand:IStrand;

		/**
		 * Constructor
	     *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function DragManagerImplDropBead()
		{
			super();
		}
		/**
		 * @private
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;

			_dropController = new DropMouseController();
			_strand.addBead(_dropController);

			_dropController.addEventListener(org.apache.royale.events.DragEvent.DRAG_ENTER, handleDragEnter);
			_dropController.addEventListener(org.apache.royale.events.DragEvent.DRAG_EXIT, handleDragExit);
			_dropController.addEventListener(org.apache.royale.events.DragEvent.DRAG_OVER, handleDragOver);
			_dropController.addEventListener(org.apache.royale.events.DragEvent.DRAG_DROP, handleDragDrop);
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
		// protected function get indicatorParent():UIBase
		// {
		// 	if (_indicatorParent == null) {
		// 		var layerBead:IDrawingLayerBead = _strand.getBeadByType(IDrawingLayerBead) as IDrawingLayerBead;
		// 		if (layerBead != null) {
		// 			_indicatorParent = layerBead.layer;
		// 		}
		// 	}
		// 	return _indicatorParent;
		// }
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.core.IItemRendererOwnerView
		 */
		// private function get itemRendererOwnerView():IItemRendererOwnerView
		// {
		// 	if (!_itemRendererOwnerView)
		// 		_itemRendererOwnerView = _strand.getBeadByType(IItemRendererOwnerView) as IItemRendererOwnerView;
		// 	return _itemRendererOwnerView;
		// }

		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.html.beads.SingleSelectionDropIndicatorBead
		 */
		// protected function getDropIndicator(ir:Object, width:Number, height:Number):UIBase
		// {
			// if (_dropIndicatorBead == null) {
			// 	_dropIndicatorBead = _strand.getBeadByType(SingleSelectionDropIndicatorBead) as SingleSelectionDropIndicatorBead;
			// 	if (_dropIndicatorBead == null) return null;
			// }
			// _dropIndicator = _dropIndicatorBead.getDropIndicator(ir, width, height);
		// 	return _dropIndicator;
		// }

		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.core.IUIBase
		 * @royaleignorecoercion org.apache.royale.core.IItemRenderer
		 */
		private function handleDragEnter(event:org.apache.royale.events.DragEvent):void
		{
			trace(getQualifiedClassName(_strand),"received DragEnter via: "+getQualifiedClassName(event.relatedObject),'acceptTarget:'+(dragAcceptTarget ? getQualifiedClassName(dragAcceptTarget):dragAcceptTarget) );
			// //trace("SingleSelectionDropTargetBead received DragEnter via: "+event.relatedObject.toString());
			// var newEvent:Event = new Event("enter", false, true);
			// dispatchEvent(newEvent);
			// if (newEvent.defaultPrevented) return;

			// var pt0:Point;
			// var pt1:Point;
			// var pt2:Point;

			// _dropController.acceptDragDrop(event.relatedObject as IUIBase, DropType.COPY);

			// var startHere:Object = event.relatedObject;
			// while( !(startHere is IItemRenderer) && startHere != null) {
			// 	startHere = startHere.parent;
			// }

			// if (startHere is IItemRenderer) {
			// 	var ir:IItemRenderer = startHere as IItemRenderer;
			// 	lastItemVisited = ir;
			// } else if (itemRendererOwnerView && itemRendererOwnerView.numItemRenderers > 0)
			// {
			// 	// as long as we're assuming the last item is dropped into in case there's no item renderer under mouse
			// 	// this is needed
			// 	lastItemVisited = itemRendererOwnerView.getItemRendererAt(itemRendererOwnerView.numItemRenderers - 1);
			// }

			// if (lastItemVisited && !indicatorVisible && indicatorParent) {
			// 	var di:UIBase = getDropIndicator(lastItemVisited, (dropDirection == "horizontal") ? indicatorParent.width : 4,
			// 		                             (dropDirection == "horizontal") ? 4 : indicatorParent.height);
			// 	indicatorVisible = true;
			// 	displayDropIndicator(lastItemVisited as IUIBase);

			// 	if (indicatorParent != null) {
			// 		indicatorParent.addElement(di);
			// 	}
			// }
			var oldTarget:IUIComponent = dragAcceptTarget;
			if (event.relatedObject == _strand && _strand != oldTarget) {
				if (_track) {
					_handled = true;
				}
				sendDragEvent(mx.events.DragEvent.DRAG_ENTER, _strand, event);
			}


			if (dragAcceptTarget == _strand && oldTarget && oldTarget != _strand) {
				sendDragEvent(mx.events.DragEvent.DRAG_EXIT, oldTarget, event);
				if (dragAcceptTarget == oldTarget)
					dragAcceptTarget = null;
			}

		}

		/**
		 * @private
		 */
		private function handleDragExit(event:org.apache.royale.events.DragEvent):void
		{
		//	trace(_strand['id'],"received DragExit via: "+event.relatedObject['id'], 'acceptTarget:'+(dragAcceptTarget ? dragAcceptTarget['id']:dragAcceptTarget));
			// //trace("SingleSelectionDropTargetBead received DragExit via: "+event.relatedObject.toString());
			// var dragEvent:DragEvent = new DragEvent()
			// sendStrandEvent(_strand, new Dra

			// if (indicatorVisible) {
			// 	if (indicatorParent != null) {
			// 		indicatorParent.removeElement(_dropIndicator);
			// 	}
			// 	indicatorVisible = false;
			// }
			if (dragAcceptTarget == _strand) {
				if (_track) {
					_handled = true;
				}
				sendDragEvent(mx.events.DragEvent.DRAG_EXIT, _strand, event);
				if (dragAcceptTarget == _strand)
					dragAcceptTarget = null;
			}

		}

		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.core.IUIBase
		 */
		private function handleDragOver(event:org.apache.royale.events.DragEvent):void
		{
		//	trace(_strand['id'],"received DragOver via: "+event.relatedObject['id'], 'acceptTarget:'+(dragAcceptTarget ? dragAcceptTarget['id']:dragAcceptTarget));
			//trace("SingleSelectionDropTargetBead received DragOver via: "+event.relatedObject.toString());
			// var newEvent:Event = new Event("over", false, true);
			// dispatchEvent(newEvent);
			// if (event.defaultPrevented) {
			// 	return;
			// }

			// var startHere:Object = event.relatedObject;
			// while( !(startHere is IItemRenderer) && startHere != null) {
			// 	startHere = startHere.parent;
			// }

			// if ((startHere is IItemRenderer) && _dropIndicator != null && indicatorParent) {
			// 	displayDropIndicator(startHere as IUIBase);
			// 	lastItemVisited = startHere;

			// }
			// else if (lastItemVisited && _dropIndicator != null && indicatorParent) {
			// 	displayDropIndicator(lastItemVisited as IUIBase);
			// }
			if (dragAcceptTarget == _strand) {
				if (_track) {
					_handled = true;
				}
				sendDragEvent(mx.events.DragEvent.DRAG_OVER, _strand, event);
			}
			else {
				/*if ((_strand as IUIComponent).contains(dragAcceptTarget))*/
				if (!dragAcceptTarget || !(event.relatedObject == dragAcceptTarget || dragAcceptTarget/*(_strand as IUIComponent).contains(dragAcceptTarget)*/)) {
					var oldTarget:IUIComponent = dragAcceptTarget;

					if (_track) {
						_handled = true;
					}
					sendDragEvent(mx.events.DragEvent.DRAG_ENTER, _strand, event);

					if (dragAcceptTarget == _strand && oldTarget) {
						sendDragEvent(mx.events.DragEvent.DRAG_EXIT, oldTarget, event);
						if (dragAcceptTarget == oldTarget)
							dragAcceptTarget = null;
					}

				}
			}
		}

		/**
		 * @private
		 */
		private function handleDragDrop(event:org.apache.royale.events.DragEvent):void
		{
		//	trace(_strand['id'],"received DragDrop via: "+event.relatedObject['id'], 'acceptTarget:'+(dragAcceptTarget ? dragAcceptTarget['id']:dragAcceptTarget));

			// //trace("SingleSelectionDropTargetBead received DragDrop via: "+event.relatedObject.toString());

			// handleDragExit(event);

			// var newEvent:Event = new Event("drop", false, true);
			// dispatchEvent(newEvent);
			// if (newEvent.defaultPrevented) {
			// 	return;
			// }

			// var targetIndex:int = -1; // indicates drop beyond length of items
			// // var contentViewAsParent:IParent;

			// var startHere:Object = event.relatedObject;
			// while( !(startHere is IIndexedItemRenderer) && startHere != null) {
			// 	startHere = startHere.parent;
			// }

			// if (startHere) {
			// 	var ir:IIndexedItemRenderer = startHere as IIndexedItemRenderer;
			// 	targetIndex = ir.index;
			// }

			// var downPoint:Point = new Point(event.clientX, event.clientY);
			// //trace("Dropping at this point: "+downPoint.x+", "+downPoint.y);
			// //trace("-- find the itemRenderer this object is over");

			// // Let the dragInitiator know that the drop was accepted so it can do
			// // whatever it needs to do to prepare the data or structures.
			// if (DragEvent.dragInitiator) {
			// 	DragEvent.dragInitiator.acceptingDrop(_strand, "object");
			// }

			// var dragSource:Object = org.apache.royale.events.DragEvent.dragSource;
			// var sourceIndex:int = 0;

			// var dataProviderModel:IDataProviderModel = getModelByType(_strand,IDataProviderModel) as IDataProviderModel;
			// if (dataProviderModel.dataProvider is Array) {
			// 	var dataArray:Array = dataProviderModel.dataProvider as Array;

			// 	// insert the item being dropped
			// 	if (targetIndex == -1) {
			// 		// append to the end
			// 		dataArray.push(dragSource);
			// 	} else {
			// 		// insert before targetIndex
			// 		dataArray.splice(targetIndex, 0, dragSource);
			// 	}

			// 	var newArray:Array = dataArray.slice()
			// 	dataProviderModel.dataProvider = newArray;
			// }
			// else if (dataProviderModel.dataProvider is ArrayList) {
			// 	var dataList:ArrayList = dataProviderModel.dataProvider as ArrayList;

			// 	// insert the item being dropped
			// 	if (targetIndex == -1) {
			// 		// sppend to the end
			// 		dataList.addItem(dragSource);
			// 	} else {
			// 		// insert before target index
			// 		dataList.addItemAt(dragSource, targetIndex);
			// 	}
			// }

			// // Let the dragInitiator know the drop has been completed.
			// if (org.apache.royale.events.DragEvent.dragInitiator) {
			// 	org.apache.royale.events.DragEvent.dragInitiator.acceptedDrop(_strand, "object");
			// }
			
			// if (dataProviderModel is ISelectionModel) {
			// 	(dataProviderModel as ISelectionModel).selectedIndex = targetIndex;
			// }

			// // is this event necessary? isn't "complete" enough?
			// sendStrandEvent(_strand,"dragDropAccepted");
			// sendEvent(this,"complete");
			if (dragAcceptTarget == _strand) {
				if (_track) {
					_handled = true;
				}
				sendDragEvent(mx.events.DragEvent.DRAG_DROP, _strand, event);
			}

		}




		// COMPILE::SWF
		// private function displayDropIndicator(item:IUIBase):void
		// {
		// 	var pt0:Point;
		// 	var pt1:Point;
		// 	var pt2:Point;

		// 	if (dropDirection == "horizontal") {
		// 		pt0 = new Point(0, item.y+item.height);
		// 		pt1 = PointUtils.localToGlobal(pt0, item.parent);
		// 		pt2 = PointUtils.globalToLocal(pt1, indicatorParent);
		// 		_dropIndicator.x = 0;
		// 		_dropIndicator.y = pt2.y - 1;
		// 	}
		// 	else {
		// 		pt0 = new Point(item.x, 0);
		// 		pt1 = PointUtils.localToGlobal(pt0, item.parent);
		// 		pt2 = PointUtils.globalToLocal(pt1, indicatorParent);
		// 		_dropIndicator.x = pt2.x - 1;
		// 		_dropIndicator.y = 0;
		// 	}
		// }

		// COMPILE::JS
		// private function displayDropIndicator(item:IUIBase):void
		// {
		// 	var pt:Point = PointUtils.localToGlobal(new Point(0,0), item);
		// 	pt = PointUtils.globalToLocal(pt,indicatorParent);
		// 	if (dropDirection == "horizontal") {
		// 		_dropIndicator.x = 0;
		// 		_dropIndicator.y = pt.y;
		// 	} else {
		// 		_dropIndicator.x = pt.x;
		// 		_dropIndicator.y = 0;
		// 	}
		// }
	}
}
