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
	import org.apache.flex.core.DropType;
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IDataProviderModel;
	import org.apache.flex.core.IItemRenderer;
	import org.apache.flex.core.IItemRendererParent;
	import org.apache.flex.core.IParent;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.events.DragEvent;
	import org.apache.flex.events.EventDispatcher;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.geom.Point;
	import org.apache.flex.geom.Rectangle;
	import org.apache.flex.html.beads.controllers.DropMouseController;
	import org.apache.flex.html.supportClasses.DataItemRenderer;
	import org.apache.flex.utils.PointUtils;
	import org.apache.flex.utils.UIUtils;
	
    
	/**
	 *  The SingleSelectionDropTargetBead enables items to be dropped onto single-selection List
	 *  components. This bead can be used with SingleSelectionDragSourceBead to enable the re-arrangement
	 *  of rows within the same list.
     *  
	 *  @see org.apache.flex.html.beads.SingleSelectionDropIndicatorBead
     *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.8
	 */
	public class SingleSelectionDropTargetBead extends EventDispatcher implements IBead
	{
		/**
		 * Constructor
	     *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function SingleSelectionDropTargetBead()
		{
			super();
		}
		
		private var _strand:IStrand;
		private var _dropController:DropMouseController;
		private var _dropIndicator:UIBase;
		private var lastItemVisited:Object;
		private var indicatorVisible:Boolean = false;
		
		/**
		 * @private
		 */
		protected function getDropIndicator(ir:Object, width:Number, height:Number):UIBase
		{
			if (_dropIndicator == null) {
				var bead:SingleSelectionDropIndicatorBead = _strand.getBeadByType(SingleSelectionDropIndicatorBead) as SingleSelectionDropIndicatorBead;
				if (bead == null) return null;
				
				_dropIndicator = bead.getDropIndicator(ir, width, height);
			}
			return _dropIndicator;
		}
		
		/**
		 * @private
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			_dropController = new DropMouseController();
			_strand.addBead(_dropController);
			
			IEventDispatcher(_dropController).addEventListener(DragEvent.DRAG_ENTER, handleDragEnter);
			IEventDispatcher(_dropController).addEventListener(DragEvent.DRAG_EXIT, handleDragExit);
			IEventDispatcher(_dropController).addEventListener(DragEvent.DRAG_OVER, handleDragOver);
			IEventDispatcher(_dropController).addEventListener(DragEvent.DRAG_DROP, handleDragDrop);
		}
		
		/**
		 * @private
		 */
		private function handleDragEnter(event:DragEvent):void
		{
			trace("SingleSelectionDropTargetBead received DragEnter via: "+event.relatedObject.toString());
			
			_dropController.acceptDragDrop(event.target as IUIBase, DropType.COPY);
			
			var startHere:Object = event.relatedObject;
			while( !(startHere is DataItemRenderer) && startHere != null) {
				startHere = startHere.parent;
			}
			
			if (startHere is DataItemRenderer) {
				var ir:DataItemRenderer = startHere as DataItemRenderer;				
				lastItemVisited = ir;
			}
			
			if (lastItemVisited && !indicatorVisible) {
				var host:UIBase = UIUtils.findPopUpHost(_strand as UIBase) as UIBase;
				var orgPoint:Point = new Point((lastItemVisited as UIBase).x, (lastItemVisited as UIBase).y);
				var pt1:Point = PointUtils.localToGlobal(orgPoint, lastItemVisited.parent);
				var pt2:Point = PointUtils.globalToLocal(pt1, host);
				indicatorVisible = true;
				var di:UIBase = getDropIndicator(lastItemVisited, (_strand as UIBase).width, 4);
				di.x = pt2.x;
				di.y = pt2.y;
				
				trace("=== over item "+(lastItemVisited as DataItemRenderer).data.toString()+", at "+pt2.x+", "+pt2.y);
				
				if (_dropIndicator) host.addElement(di);
			}
			
		}
		
		/**
		 * @private
		 */
		private function handleDragExit(event:DragEvent):void
		{
			trace("SingleSelectionDropTargetBead received DragExit via: "+event.relatedObject.toString());
			
			if (indicatorVisible) {
				var host:UIBase = UIUtils.findPopUpHost(_strand as UIBase) as UIBase;
				if (_dropIndicator) host.removeElement(_dropIndicator);
				indicatorVisible = false;
			}
		}
		
		/**
		 * @private
		 */
		private function handleDragOver(event:DragEvent):void
		{
			trace("SingleSelectionDropTargetBead received DragOver via: "+event.relatedObject.toString());
			
			var startHere:Object = event.relatedObject;
			while( !(startHere is DataItemRenderer) && startHere != null) {
				startHere = startHere.parent;
			}
			if ((startHere is DataItemRenderer) && _dropIndicator != null) {
				var host:UIBase = UIUtils.findPopUpHost(_strand as UIBase) as UIBase;
				var orgPoint:Point = new Point((startHere as UIBase).x, (startHere as UIBase).y);
				var pt1:Point = PointUtils.localToGlobal(orgPoint, startHere.parent);
				var pt2:Point = PointUtils.globalToLocal(pt1, host);
				_dropIndicator.x = pt2.x;
				_dropIndicator.y = pt2.y - 1;
				
				lastItemVisited = startHere;
				
				trace("== over item "+(startHere as DataItemRenderer).data.toString()+", at "+pt2.x+", "+pt2.y);
			} else if (lastItemVisited && _dropIndicator != null) {
				trace("== beyond last item");
				
				var p:UIBase = (lastItemVisited as UIBase).parent as UIBase;
				if (p == null) return;
				
				var n:int = p.numElements;
				var lastItem:UIBase = p.getElementAt(n-1) as UIBase;
				
				host = UIUtils.findPopUpHost(_strand as UIBase) as UIBase;
				orgPoint = new Point(lastItem.x, lastItem.y);
				pt1 = PointUtils.localToGlobal(orgPoint, p);
				pt2 = PointUtils.globalToLocal(pt1, host);
				_dropIndicator.x = pt2.x;
				_dropIndicator.y = pt2.y + lastItem.height + 1;
			}
		}
		
		/**
		 * @private
		 */
		private function handleDragDrop(event:DragEvent):void
		{
			trace("SingleSelectionDropTargetBead received DragDrop via: "+event.relatedObject.toString());
			
			handleDragExit(event);
						
			var targetIndex:int = -1; // indicates drop beyond length of items
			
			var startHere:Object = event.relatedObject;
			while( !(startHere is IItemRenderer) && startHere != null) {
				startHere = startHere.parent;
			}
			
			if (startHere is IItemRenderer) {
				var ir:IItemRenderer = startHere as IItemRenderer;
				trace("-- dropping onto an existing object: "+ir.data.toString());
				
				var p:UIBase = (ir as UIBase).parent as UIBase;
				targetIndex = p.getElementIndex(ir);
			}
			else  {
				trace("-- dropping after the last item");
			}
			
			var downPoint:Point = new Point(event.clientX, event.clientY); 
			//trace("Dropping at this point: "+downPoint.x+", "+downPoint.y);
			//trace("-- find the itemRenderer this object is over");
						
			// Let the dragInitiator know that the drop was accepted so it can do
			// whatever it needs to do to prepare the data or structures.
			if (DragEvent.dragInitiator) {
				DragEvent.dragInitiator.acceptingDrop(_strand, "object");
			}
				
			var dragSource:Object = DragEvent.dragSource;
				
			var dataProviderModel:IDataProviderModel = _strand.getBeadByType(IDataProviderModel) as IDataProviderModel;
			if (dataProviderModel.dataProvider is Array) {
				var dataArray:Array = dataProviderModel.dataProvider as Array;

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
				
				// insert the item being dropped
				if (targetIndex == -1) {
					// sppend to the end
					dataList.addItem(dragSource);
				} else {
					// insert before target index
					dataList.addItemAt(dragSource, targetIndex);
				}
				
				var newList:ArrayList = new ArrayList(dataList.source);
				dataProviderModel.dataProvider = newList;
			}
				
			// Let the dragInitiator know the drop has been completed.
			if (DragEvent.dragInitiator) {
				DragEvent.dragInitiator.acceptedDrop(_strand, "object");
			}
		}
	}
}
