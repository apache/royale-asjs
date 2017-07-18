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
	import org.apache.flex.core.IDataProviderModel;
	import org.apache.flex.core.IDocument;
	import org.apache.flex.core.IDragInitiator;
	import org.apache.flex.core.IItemRenderer;
	import org.apache.flex.core.IItemRendererParent;
	import org.apache.flex.core.IParent;
	import org.apache.flex.core.IStrand;
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
	
    
	/**
	 *  The SingleSelectionDragImageBead produces a UIBase component that represents
	 *  the item being dragged. It does this by taking the data associcated with the
	 *  index of the item selected and running the toString() function on it, placing
	 *  it inside of a Label that is inside of Group (which is given the className of
	 *  "DragImage").
	 * 
	 *  The createDragImage() function can be overridden and a different component returned.
	 * 
	 *  @see org.apache.flex.html.beads.SingleSelectionDropTargetBead.
     *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class SingleSelectionDragImageBead extends EventDispatcher implements IBead
	{
		public function SingleSelectionDragImageBead()
		{
			super();
		}
		
		private var _strand:IStrand;
		
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			IEventDispatcher(_strand).addEventListener(DragEvent.DRAG_START, handleDragStart);
		}
		
		public function get strand():IStrand
		{
			return _strand;
		}
		
		/**
		 * Creates an example/temporary component to be dragged and returns it.
		 * 
		 * @param ir DataItemRenderer The itemRenderer to be used as a template.
		 * @return UIBase The "dragImage" to use.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		protected function createDragImage(ir:DataItemRenderer):UIBase
		{
			var dragImage:UIBase = new Group();
			dragImage.className = "DragImage";
			dragImage.width = (ir as UIBase).width;
			dragImage.height = (ir as UIBase).height;
			var label:Label = new Label();
			if (ir.dataField != null) {
				label.text = ir.data[ir.dataField].toString();
			} else {
				label.text = ir.data.toString();
			}
			
			COMPILE::JS {
				dragImage.element.style.position = 'absolute';
				dragImage.element.style.cursor = 'pointer';
			}
				
			dragImage.addElement(label);
			
			return dragImage;
		}
		
		/**
		 * @private
		 */
		private function handleDragStart(event:DragEvent):void
		{
			trace("SingleSelectionDragImageBead received the DragStart via: "+event.target.toString());

			var startHere:Object = event.target;
			
			if (startHere is DataItemRenderer) {
				var ir:DataItemRenderer = startHere as DataItemRenderer;
				DragEvent.dragSource = ir.data;
				DragMouseController.dragImage = createDragImage(ir);
			}
		}
	}
}
