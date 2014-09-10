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
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import org.apache.flex.core.BeadViewBase;
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IBeadLayout;
	import org.apache.flex.core.IBeadModel;
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.ISelectableItemRenderer;
	import org.apache.flex.core.IItemRendererParent;
	import org.apache.flex.core.ILayoutParent;
	import org.apache.flex.core.IParent;
	import org.apache.flex.core.IRollOverModel;
	import org.apache.flex.core.ISelectionModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.Strand;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.beads.models.ArraySelectionModel;
	import org.apache.flex.html.beads.models.ScrollBarModel;
	import org.apache.flex.html.beads.models.SingleLineBorderModel;
	import org.apache.flex.html.supportClasses.Border;
	import org.apache.flex.html.supportClasses.NonVirtualDataGroup;
	import org.apache.flex.html.supportClasses.ScrollBar;

	/**
	 *  The List class creates the visual elements of the org.apache.flex.html.List 
	 *  component. A List consists of the area to display the data (in the dataGroup), any 
	 *  scrollbars, and so forth.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class ListView extends Strand implements IBeadView, IStrand, IListView, ILayoutParent
	{
		public function ListView()
		{
		}
						
		private var listModel:ISelectionModel;
		
		private var _border:Border;
		
		/**
		 *  The border surrounding the org.apache.flex.html.List.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
        public function get border():Border
        {
            return _border;
        }
		
		private var _dataGroup:IItemRendererParent;
		
		/**
		 *  The area holding the itemRenderers.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get dataGroup():IItemRendererParent
		{
			return _dataGroup;
		}
		public function set dataGroup(value:IItemRendererParent):void
		{
			_dataGroup = value;
		}
		
		private var _vScrollBar:ScrollBar;
		
		/**
		 *  The vertical org.apache.flex.html.ScrollBar, if needed.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get vScrollBar():ScrollBar
		{
            if (!_vScrollBar)
                _vScrollBar = createScrollBar();
			return _vScrollBar;
		}
		
		/**
		 *  The horizontal org.apache.flex.html.ScrollBar, currently null.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get hScrollBar():ScrollBar
		{
			return null;
		}
		
		/**
		 *  The contentArea includes the dataGroup and scrollBars.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get contentView():DisplayObjectContainer
		{
			return _dataGroup as DisplayObjectContainer;
		}
		
		/**
		 * @private
		 */
		public function get resizableView():DisplayObject
		{
			return _strand as DisplayObject;
		}
		
		private var _strand:IStrand;
		
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get strand():IStrand
		{
			return _strand;
		}
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			IEventDispatcher(_strand).addEventListener("widthChanged", handleSizeChange);
			IEventDispatcher(_strand).addEventListener("heightChanged",handleSizeChange);
            
            listModel = value.getBeadByType(ISelectionModel) as ISelectionModel;
            listModel.addEventListener("selectedIndexChanged", selectionChangeHandler);
            listModel.addEventListener("rollOverIndexChanged", rollOverIndexChangeHandler);
			listModel.addEventListener("dataProviderChanged", dataProviderChangeHandler);

            _border = new Border();
            _border.model = new (ValuesManager.valuesImpl.getValue(value, "iBorderModel")) as IBeadModel;
            _border.addBead(new (ValuesManager.valuesImpl.getValue(value, "iBorderBead")) as IBead);
            IParent(_strand).addElement(_border);
            
			if (_dataGroup == null) {
				_dataGroup = new (ValuesManager.valuesImpl.getValue(value, "iDataGroup")) as IItemRendererParent;
			}
			IParent(_strand).addElement(_dataGroup);
            
            if (_strand.getBeadByType(IBeadLayout) == null)
            {
                var mapper:IBeadLayout = new (ValuesManager.valuesImpl.getValue(_strand, "iBeadLayout")) as IBeadLayout;
				strand.addBead(mapper);
            }  
			
			handleSizeChange(null);
		}
		
		private var lastSelectedIndex:int = -1;
		
		/**
		 * @private
		 */
		protected function dataProviderChangeHandler(event:Event):void
		{
			// override if needed
		}
		
		/**
		 * @private
		 */
		private function selectionChangeHandler(event:Event):void
		{
			if (lastSelectedIndex != -1)
			{
				var ir:ISelectableItemRenderer = dataGroup.getItemRendererForIndex(lastSelectedIndex) as ISelectableItemRenderer;
                ir.selected = false;
			}
			if (listModel.selectedIndex != -1)
			{
	            ir = dataGroup.getItemRendererForIndex(listModel.selectedIndex) as ISelectableItemRenderer;
	            ir.selected = true;
			}
            lastSelectedIndex = listModel.selectedIndex;
		}
		
		private var lastRollOverIndex:int = -1;
		
		/**
		 * @private
		 */
		private function rollOverIndexChangeHandler(event:Event):void
		{
			if (lastRollOverIndex != -1)
			{
				var ir:ISelectableItemRenderer = dataGroup.getItemRendererForIndex(lastRollOverIndex) as ISelectableItemRenderer;
                ir.hovered = false;
			}
			if (IRollOverModel(listModel).rollOverIndex != -1)
			{
	            ir = dataGroup.getItemRendererForIndex(IRollOverModel(listModel).rollOverIndex) as ISelectableItemRenderer;
	            ir.hovered = true;
			}
			lastRollOverIndex = IRollOverModel(listModel).rollOverIndex;
		}
			
		/**
		 * @private
		 */
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
		
		/**
		 * @private
		 */
		private function handleSizeChange(event:Event):void
		{
			UIBase(_dataGroup).x = 0;
			UIBase(_dataGroup).y = 0;
			UIBase(_dataGroup).width = UIBase(_strand).width;
			UIBase(_dataGroup).height = UIBase(_strand).height;
		}
				
        /**
         *  @copy org.apache.flex.core.IBeadView#viewHeight
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function get viewHeight():Number
        {
            // don't want to put $height in an interface
            return _strand["$height"];
        }
        
        /**
         *  @copy org.apache.flex.core.IBeadView#viewWidth
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function get viewWidth():Number
        {
            // don't want to put $width in an interface
            return _strand["$width"];
        }
	}
}
