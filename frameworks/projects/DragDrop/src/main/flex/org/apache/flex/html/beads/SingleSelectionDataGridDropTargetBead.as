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
	 *  The SingleSelectionDataGridDropTargetBead enables items to be dropped onto single-selection DataGrid
	 *  components. This bead can be used with SingleSelectionDragSourceBead to enable the re-arrangement
	 *  of rows within the same list.
     *  
	 *  @see org.apache.flex.html.beads.SingleSelectionDropTargetBead
     *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.8
	 */
	public class SingleSelectionDataGridDropTargetBead extends SingleSelectionDropTargetBead
	{
		/**
		 * Constructor
	     *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function SingleSelectionDataGridDropTargetBead()
		{
			super();
		}
		
		private var _strand:IStrand;
		private var _dropIndicator:UIBase;
		
		/**
		 * @private
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			_strand = value;
		}
		
		/**
		 * @private
		 */
		override protected function getDropIndicator(ir:Object, width:Number, height:Number):UIBase
		{
			if (_dropIndicator == null) {
				var bead:SingleSelectionDropIndicatorBead = _strand.getBeadByType(SingleSelectionDropIndicatorBead) as SingleSelectionDropIndicatorBead;
				if (bead == null) return null;
				
				_dropIndicator = bead.getDropIndicator(ir, width, height);
			}
			if (indicatorParent == null) {
				indicatorParent = findListContainer(_strand as UIBase);
			}
			return _dropIndicator;
		}
		
		private function findListContainer(object:UIBase):UIBase
		{
			const cname:String = "opt_org-apache-flex-html-DataGrid_ListArea";
			
			if (object == null) return null;
			if (object.className == cname) return object;
			var n:Number = object.numElements;
			for (var i:int=0; i < n; i++) {
				var result:UIBase = findListContainer(object.getElementAt(i) as UIBase);
				if (result != null) return result;
			}
			return null;
		}
	}
}
