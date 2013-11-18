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
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import org.apache.flex.core.IBeadLayout;
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IItemRenderer;
	import org.apache.flex.core.IItemRendererParent;
	import org.apache.flex.core.ILayoutParent;
	import org.apache.flex.core.IParent;
	import org.apache.flex.core.IRollOverModel;
	import org.apache.flex.core.ISelectionModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.Strand;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.html.staticControls.beads.models.ScrollBarModel;
	import org.apache.flex.html.staticControls.beads.models.SingleLineBorderModel;
	import org.apache.flex.html.staticControls.supportClasses.Border;
	import org.apache.flex.html.staticControls.supportClasses.NonVirtualDataGroup;
	import org.apache.flex.html.staticControls.supportClasses.ScrollBar;

	public class ListView extends Strand implements IBeadView, IStrand, IListView, ILayoutParent
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
		
		public function get hScrollBar():ScrollBar
		{
			return null;
		}
		
		public function get contentView():DisplayObjectContainer
		{
			return _dataGroup as DisplayObjectContainer;
		}
		
		public function get resizableView():DisplayObject
		{
			return _strand as DisplayObject;
		}

		private var _strand:IStrand;
		
		public function get strand():IStrand
		{
			return _strand;
		}
		public function set strand(value:IStrand):void
		{
			_strand = value;
            
            listModel = value.getBeadByType(ISelectionModel) as ISelectionModel;
            listModel.addEventListener("selectedIndexChanged", selectionChangeHandler);
            listModel.addEventListener("rollOverIndexChanged", rollOverIndexChangeHandler);

            _border = new Border();
            _border.model = new SingleLineBorderModel();
            _border.addBead(new SingleLineBorderBead());
            IParent(_strand).addElement(_border);
            
			_dataGroup = new NonVirtualDataGroup();
			IParent(_strand).addElement(_dataGroup);
            
            if (getBeadByType(IBeadLayout) == null)
            {
                var mapper:IBeadLayout = new (ValuesManager.valuesImpl.getValue(_strand, "iBeadLayout")) as IBeadLayout;
				strand.addBead(mapper);
            }            
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
		
		private var lastRollOverIndex:int = -1;
		
		private function rollOverIndexChangeHandler(event:Event):void
		{
			if (lastRollOverIndex != -1)
			{
				var ir:IItemRenderer = dataGroup.getItemRendererForIndex(lastRollOverIndex) as IItemRenderer;
                ir.hovered = false;
			}
			if (IRollOverModel(listModel).rollOverIndex != -1)
			{
	            ir = dataGroup.getItemRendererForIndex(IRollOverModel(listModel).rollOverIndex);
	            ir.hovered = true;
			}
			lastRollOverIndex = IRollOverModel(listModel).rollOverIndex;
		}
			
		private function createScrollBar():ScrollBar
		{
			var vsb:ScrollBar;
			vsb = new ScrollBar();
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
            IParent(_strand).addElement(vsb);
			return vsb;
		}
				
	}
}