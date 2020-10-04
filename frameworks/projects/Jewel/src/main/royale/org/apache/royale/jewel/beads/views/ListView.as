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
package org.apache.royale.jewel.beads.views
{
	COMPILE::SWF
	{
	import org.apache.royale.core.IStrand;
	}
	COMPILE::JS
    {
	import org.apache.royale.core.IStyledUIBase;
	}
	import org.apache.royale.core.IItemRenderer;
	import org.apache.royale.core.IItemRendererOwnerView;
	import org.apache.royale.core.ILayoutView;
	import org.apache.royale.core.IRollOverModel;
	import org.apache.royale.core.ISelectableItemRenderer;
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.events.Event;
	import org.apache.royale.html.beads.DataContainerView;
	import org.apache.royale.jewel.beads.models.ListPresentationModel;
	import org.apache.royale.jewel.supportClasses.list.IListPresentationModel;
	import org.apache.royale.utils.getSelectionRenderBead;
	// import org.apache.royale.core.IFocusable;

	/**
	 *  The ListView class creates the visual elements of the org.apache.royale.jewel.List
	 *  component. A List consists of the area to display the data (in the dataGroup), any
	 *  scrollbars, and so forth.
	 *
	 *  @viewbead
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	COMPILE::JS
	public class ListView extends DataContainerView implements IScrollToIndexView
	{
		public function ListView()
		{
			super();
		}
		
		private var _dataGroup:IItemRendererOwnerView;
		/**
		 * @royaleignorecoercion org.apache.royale.core.IItemRendererOwnerView
		 */
		override public function get dataGroup():IItemRendererOwnerView
		{
			if(!_dataGroup)
			{
				var c:ILayoutView = contentView;
				if(c && c is IItemRendererOwnerView)
					_dataGroup = c as IItemRendererOwnerView;
				else
					_dataGroup = super.dataGroup;
			}
			return _dataGroup;
		}


		protected var listModel:ISelectionModel;

		protected var lastSelectedIndex:int = -1;

		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.core.ISelectionModel
		 */
		override protected function handleInitComplete(event:Event):void
		{
			listModel = _strand.getBeadByType(ISelectionModel) as ISelectionModel;
			listModel.addEventListener("selectionChanged", selectionChangeHandler);
			listModel.addEventListener("rollOverIndexChanged", rollOverIndexChangeHandler);
			
			super.handleInitComplete(event);
		}

		/**
		 * @private
		 * Ensure the list selects the selectedItem if some is set by the user at creation time
		 */
		override protected function itemsCreatedHandler(event:Event):void
		{
			super.itemsCreatedHandler(event);
			
			if(listModel.selectedIndex != -1)
				selectionChangeHandler(null);
		}
		
		/**
		 * @royaleignorecoercion org.apache.royale.core.IItemRenderer
		 * @royaleignorecoercion org.apache.royale.core.ISelectableItemRenderer
		 */
		protected function selectionChangeHandler(event:Event):void
		{
			var selectionBead:ISelectableItemRenderer;
			var ir:IItemRenderer = dataGroup.getItemRendererForIndex(lastSelectedIndex) as IItemRenderer;
			if (ir) 
			{
				selectionBead = getSelectionRenderBead(ir);
				if (selectionBead)
					selectionBead.selected = false;
			}
			ir = dataGroup.getItemRendererForIndex(listModel.selectedIndex) as IItemRenderer;
			if (ir) {
				selectionBead = getSelectionRenderBead(ir);
				if (selectionBead)
					selectionBead.selected = true;
			}
			
			lastSelectedIndex = listModel.selectedIndex;
		}

		protected var lastRollOverIndex:int = -1;

		/**
		 * @royaleignorecoercion org.apache.royale.core.IItemRenderer
		 * @royaleignorecoercion org.apache.royale.core.IRollOverModel
		 */
		protected function rollOverIndexChangeHandler(event:Event):void
		{
			var selectionBead:ISelectableItemRenderer;
			var ir:IItemRenderer = dataGroup.getItemRendererForIndex(lastRollOverIndex) as IItemRenderer;
			if (ir) 
			{
				selectionBead = getSelectionRenderBead(ir);
				if (selectionBead)
					selectionBead.hovered = false;
			}
			ir = dataGroup.getItemRendererForIndex((listModel as IRollOverModel).rollOverIndex) as IItemRenderer;
			if (ir) {
				selectionBead = getSelectionRenderBead(ir);
				if (selectionBead)
					selectionBead.hovered = true;
			}
			lastRollOverIndex = (listModel as IRollOverModel).rollOverIndex;
		}

		/**
		 *  Ensures that the data provider item at the given index is visible.
		 *  
		 *  If the item is visible, the <code>verticalScrollPosition</code>
		 *  property is left unchanged even if the item is not the first visible
		 *  item. If the item is not currently visible, the 
		 *  <code>verticalScrollPosition</code>
		 *  property is changed make the item the first visible item, unless there
		 *  aren't enough rows to do so because the 
		 *  <code>verticalScrollPosition</code> value is limited by the 
		 *  <code>maxVerticalScrollPosition</code> property.
		 *
		 *  @param index The index of the item in the data provider.
		 *
		 *  @return <code>true</code> if <code>verticalScrollPosition</code> changed.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.9.7
		 */
		public function scrollToIndex(index:int):Boolean
		{
			var scrollArea:HTMLElement = (_strand as IStyledUIBase).element;
			var oldScroll:Number = scrollArea.scrollTop;

			var totalHeight:Number = 0;
			var pm:IListPresentationModel = _strand.getBeadByType(IListPresentationModel) as IListPresentationModel;
			
			if(pm.variableRowHeight)
			{
				//each item render can have its own height
				var n:int = listModel.dataProvider.length;
				var irHeights:Array = [];
				for (var i:int = 0; i <= index; i++)
				{
					var ir:IItemRenderer = dataGroup.getItemRendererForIndex(i) as IItemRenderer;
					totalHeight += ir.element.clientHeight;
					irHeights.push(totalHeight + ir.element.clientHeight - scrollArea.clientHeight);
				}

				scrollArea.scrollTop = Math.min(irHeights[index], totalHeight);

			} else 
			{
				var rowHeight:Number;
				// all items renderers with same height
				rowHeight = isNaN(pm.rowHeight) ? ListPresentationModel.DEFAULT_ROW_HEIGHT : pm.rowHeight;
				totalHeight = listModel.dataProvider.length * rowHeight - scrollArea.clientHeight;
				
				scrollArea.scrollTop = Math.min(index * rowHeight, totalHeight);
			}

			return oldScroll != scrollArea.scrollTop;
		}

		/**
		 * 
		 * @param index 
		 */
		// public function setFocusOnItem(index:int):void
		// {
		// 	var ir:IFocusable = dataGroup.getItemRendererForIndex(index) as IFocusable;
		// 	ir.setFocus();
		// }
	}

	COMPILE::SWF
	public class ListView extends DataContainerView implements IScrollToIndexView
	{
		public function ListView()
		{
			super();
		}

		protected var listModel:ISelectionModel;

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			super.strand = value;
		}
		private var _dataGroup:IItemRendererOwnerView;
		override public function get dataGroup():IItemRendererOwnerView
		{
			if(!_dataGroup)
			{
				var c:ILayoutView = contentView;
				if(c && c is IItemRendererOwnerView)
					_dataGroup = c as IItemRendererOwnerView;
				else
					_dataGroup = super.dataGroup;
			}
			return _dataGroup;
		}

		/**
		 * @private
		 */
		override protected function handleInitComplete(event:Event):void
		{
			super.handleInitComplete(event);

			listModel = _strand.getBeadByType(ISelectionModel) as ISelectionModel;
			listModel.addEventListener("selectionChanged", selectionChangeHandler);
			listModel.addEventListener("rollOverIndexChanged", rollOverIndexChangeHandler);
		}

		protected var lastSelectedIndex:int = -1;

		/**
		 * @private
		 */
		protected function selectionChangeHandler(event:Event):void
		{
			var selectionBead:ISelectableItemRenderer;
			var ir:IItemRenderer = dataGroup.getItemRendererForIndex(lastSelectedIndex) as IItemRenderer;
			if (ir) 
			{
				selectionBead = getSelectionRenderBead(ir);
				if (selectionBead)
					selectionBead.selected = false;
			}
			ir = dataGroup.getItemRendererForIndex(listModel.selectedIndex) as IItemRenderer;
			if (ir) {
				selectionBead = getSelectionRenderBead(ir);
				if (selectionBead)
					selectionBead.selected = true;
			}
			lastSelectedIndex = listModel.selectedIndex;
		}

		protected var lastRollOverIndex:int = -1;

		/**
		 * @private
		 */
		protected function rollOverIndexChangeHandler(event:Event):void
		{
			var selectionBead:ISelectableItemRenderer;
			var ir:IItemRenderer = dataGroup.getItemRendererForIndex(lastRollOverIndex) as IItemRenderer;
			if (ir) 
			{
				selectionBead = getSelectionRenderBead(ir);
				if (selectionBead)
					selectionBead.hovered = false;
			}
			ir = dataGroup.getItemRendererForIndex((listModel as IRollOverModel).rollOverIndex) as IItemRenderer;
			if (ir) {
				selectionBead = getSelectionRenderBead(ir);
				if (selectionBead)
					selectionBead.hovered = true;
			}
			lastRollOverIndex = IRollOverModel(listModel).rollOverIndex;
		}

		/**
		 *  Ensures that the data provider item at the given index is visible.
		 *  
		 *  If the item is visible, the <code>verticalScrollPosition</code>
		 *  property is left unchanged even if the item is not the first visible
		 *  item. If the item is not currently visible, the 
		 *  <code>verticalScrollPosition</code>
		 *  property is changed make the item the first visible item, unless there
		 *  aren't enough rows to do so because the 
		 *  <code>verticalScrollPosition</code> value is limited by the 
		 *  <code>maxVerticalScrollPosition</code> property.
		 *
		 *  @param index The index of the item in the data provider.
		 *
		 *  @return <code>true</code> if <code>verticalScrollPosition</code> changed.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.9.7
		 */
		public function scrollToIndex(index:int):Boolean
		{
			return false;
		}
	}
}
