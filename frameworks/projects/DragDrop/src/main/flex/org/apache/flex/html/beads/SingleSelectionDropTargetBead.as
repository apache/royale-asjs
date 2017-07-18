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
	
    
	/**
	 *  The SingleSelectionDropTargetBead enables items to be dropped onto single-selection List
	 *  components. This bead can be used with SingleSelectionDragSourceBead to enable the re-arrangement
	 *  of rows within the same list.
     *  
	 *  @see org.apache.flex.html.beads.SingleSelectionDropTargetBead
     *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class SingleSelectionDropTargetBead extends EventDispatcher implements IBead
	{
		public function SingleSelectionDropTargetBead()
		{
			super();
		}
		
		private var _strand:IStrand;
		private var _dropController:DropMouseController;
		
		private var _itemRendererParent:IParent;
		public function get itemRendererParent():IParent
		{
			if (_itemRendererParent == null) {
				_itemRendererParent = _strand.getBeadByType(IItemRendererParent) as IParent;
			}
			return _itemRendererParent;
		}
		
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
		
		public function get strand():IStrand
		{
			return _strand;
		}
		
		private function handleDragEnter(event:DragEvent):void
		{
			trace("SingleSelectionDropTargetBead received DragEnter via: "+event.target.toString());
			
			_dropController.acceptDragDrop(event.target as IUIBase, DropType.COPY);
		}
		
		private function handleDragExit(event:DragEvent):void
		{
			trace("SingleSelectionDropTargetBead received DragExit via: "+event.target.toString());
		}
		
		private function handleDragOver(event:DragEvent):void
		{
			trace("SingleSelectionDropTargetBead received DragOver via: "+event.target.toString());
		}
		
		private function handleDragDrop(event:DragEvent):void
		{
			trace("SingleSelectionDropTargetBead received DragDrop via: "+event.relatedObject.toString());
						
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
