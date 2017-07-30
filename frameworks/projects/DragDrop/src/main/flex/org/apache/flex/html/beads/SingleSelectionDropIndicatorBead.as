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
	import org.apache.flex.utils.PointUtils;
	import org.apache.flex.svg.Rect;
	import org.apache.flex.graphics.SolidColor;
	
    
	/**
	 *  The SingleSelectionDropIndicatorBead provides a graphic used to help the user
	 *  place the item being dropped.
	 * 
	 *  @see org.apache.flex.html.beads.SingleSelectionDropTargetBead.
     *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.8
	 */
	public class SingleSelectionDropIndicatorBead extends EventDispatcher implements IBead
	{
		/**
		 * Constructor
	     *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function SingleSelectionDropIndicatorBead()
		{
			super();
		}
		
		private var _strand:IStrand;
		
		/**
		 * @private
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
		}
		
		private var _dropIndicator:Rect;
		
		/**
		 * This function returns a UIBase component that is used to indicate where a drop action will occur or
		 * be accepted. This function is called once by the SingleSelectionDropTargetBead (or its derivatives) 
		 * when the drop target is entered. After that only its (x,y) coordinates will be changed.
		 * 
		 * @param ir Object The object that will be dragged. You can use this to help customize the drop indicator.
		 * @param width Number The preferred width of the drop indicator.
		 * @param height Number The preferred height of the drop indicator.
		 * @return UIBase A component that will show where the drop can be accepted.
	     *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function getDropIndicator(ir:Object, width:Number, height:Number):UIBase
		{
			if (_dropIndicator == null) {
				_dropIndicator = new Rect();
				_dropIndicator.fill = new SolidColor(0x000000);
			}
			
			_dropIndicator.width = width;
			_dropIndicator.height = height;
			
			return _dropIndicator;
		}
	}
}
