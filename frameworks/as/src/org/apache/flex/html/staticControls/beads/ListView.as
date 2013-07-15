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
package org.apache.flex.html.staticControls.beads
{	
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IItemRenderer;
	import org.apache.flex.core.IItemRendererParent;
	import org.apache.flex.core.ISelectionModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.events.Event;
	import org.apache.flex.html.staticControls.beads.controllers.VScrollBarMouseController;
	import org.apache.flex.html.staticControls.beads.layouts.VScrollBarLayout;
	import org.apache.flex.html.staticControls.beads.models.ScrollBarModel;
	import org.apache.flex.html.staticControls.beads.models.SingleLineBorderModel;
	import org.apache.flex.html.staticControls.supportClasses.Border;
	import org.apache.flex.html.staticControls.supportClasses.NonVirtualDataGroup;
	import org.apache.flex.html.staticControls.supportClasses.ScrollBar;

	public class ListView implements IBead, IStrand, IListView
	{
		public function ListView()
		{
		}
						
		private var listModel:ISelectionModel;
		
        private var _border:Border;
        
        public function get border():Border
        {
            return _border;
        }

        private var _dataGroup:IItemRendererParent;

		public function get dataGroup():IItemRendererParent
		{
			return _dataGroup;
		}
		
		private var _vScrollBar:ScrollBar;
		
		public function get vScrollBar():ScrollBar
		{
            if (!_vScrollBar)
                _vScrollBar = createScrollBar();
			return _vScrollBar;
		}

		private var _strand:IStrand;
		
		public function get strand():IStrand
		{
			return _strand;
		}
		public function set strand(value:IStrand):void
		{
			_strand = value;
            _border = new Border();
            border.addToParent(UIBase(_strand));
            _border.model = new SingleLineBorderModel();
            _border.addBead(new SingleLineBorderBead());
			_dataGroup = new NonVirtualDataGroup();
			UIBase(_dataGroup).addToParent(UIBase(_strand));
			listModel = value.getBeadByType(ISelectionModel) as ISelectionModel;
			listModel.addEventListener("selectedIndexChanged", selectionChangeHandler);
		}
		
		private var lastSelectedIndex:int = -1;
		
		private function selectionChangeHandler(event:Event):void
		{
			if (lastSelectedIndex != -1)
			{
				var ir:IItemRenderer = dataGroup.getItemRendererForIndex(lastSelectedIndex) as IItemRenderer;
                ir.selected = false;
			}
			if (listModel.selectedIndex != -1)
			{
	            ir = dataGroup.getItemRendererForIndex(listModel.selectedIndex);
	            ir.selected = true;
			}
            lastSelectedIndex = listModel.selectedIndex;
		}
			
		private function createScrollBar():ScrollBar
		{
			var vsb:ScrollBar;
			vsb = new ScrollBar();
			vsb.addToParent(UIBase(_strand));
			var vsbm:ScrollBarModel = new ScrollBarModel();
			vsbm.maximum = 100;
			vsbm.minimum = 0;
			vsbm.pageSize = 10;
			vsbm.pageStepSize = 10;
			vsbm.snapInterval = 1;
			vsbm.stepSize = 1;
			vsbm.value = 0;
			vsb.model = vsbm;
			vsb.width = 16;
			var vsbl:VScrollBarLayout = new VScrollBarLayout();
			//vsbb.addBead(vsbl);
			var vsbc:VScrollBarMouseController = new VScrollBarMouseController();
			vsb.addBead(vsbc);
			return vsb;
		}
				
		// beads declared in MXML are added to the strand.
		// from AS, just call addBead()
		public var beads:Array;
		
		private var _beads:Vector.<IBead>;
		public function addBead(bead:IBead):void
		{
			if (!_beads)
				_beads = new Vector.<IBead>;
			_beads.push(bead);
			bead.strand = this;
		}
		
		public function getBeadByType(classOrInterface:Class):IBead
		{
			for each (var bead:IBead in _beads)
			{
				if (bead is classOrInterface)
					return bead;
			}
			return null;
		}
		
		public function removeBead(value:IBead):IBead	
		{
			var n:int = _beads.length;
			for (var i:int = 0; i < n; i++)
			{
				var bead:IBead = _beads[i];
				if (bead == value)
				{
					_beads.splice(i, 1);
					return bead;
				}
			}
			return null;
		}
	}
}