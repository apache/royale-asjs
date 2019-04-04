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
package org.apache.royale.html.beads
{
	import org.apache.royale.collections.ICollectionView;
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IBeadModel;
	import org.apache.royale.core.IDataProviderItemRendererMapper;
	import org.apache.royale.core.IDataProviderModel;
	import org.apache.royale.core.IItemRendererClassFactory;
	import org.apache.royale.core.IItemRendererParent;
	import org.apache.royale.core.IListPresentationModel;
	import org.apache.royale.core.ISelectableItemRenderer;
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.SimpleCSSStyles;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.CollectionEvent;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.supportClasses.StringItemRenderer;
	import org.apache.royale.html.supportClasses.UIItemRendererBase;
	import org.apache.royale.utils.loadBeadFromValuesManager;
	import org.apache.royale.html.beads.IListView;

	
	/**
	 * This class creates itemRenderer instances from the data contained within an ICollectionView
	 */
	public class DataItemRendererFactoryForCollectionView extends EventDispatcher implements IBead, IDataProviderItemRendererMapper
	{
		public function DataItemRendererFactoryForCollectionView(target:Object = null)
		{
			super(target);
		}
		
		protected var _strand:IStrand;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			IEventDispatcher(value).addEventListener("initComplete", initComplete);
		}
		
		/**
		 *  finish setup
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 *  @royaleignorecoercion org.apache.royale.html.beads.IListView
		 */
		protected function initComplete(event:Event):void
		{
			IEventDispatcher(_strand).removeEventListener("initComplete", initComplete);
			
			var listView:IListView = _strand.getBeadByType(IListView) as IListView;
			dataGroup = listView.dataGroup;
			
			var model:IEventDispatcher = _strand.getBeadByType(IBeadModel) as IEventDispatcher;
			model.addEventListener("dataProviderChanged", dataProviderChangeHandler);
			
			dataProviderChangeHandler(null);
		}
		
		protected var _dataProviderModel:IDataProviderModel;
		
		/**
		 * The model holding the dataProvider.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 *  @royaleignorecoercion org.apache.royale.core.IDataProviderModel
		 */
		public function get dataProviderModel():IDataProviderModel
		{
			if (_dataProviderModel == null && _strand != null) {
				_dataProviderModel = _strand.getBeadByType(IBeadModel) as IDataProviderModel;
			}
			return _dataProviderModel;
		}
		
		protected var labelField:String;
		
		private var _itemRendererFactory:IItemRendererClassFactory;
		
		/**
		 *  The org.apache.royale.core.IItemRendererClassFactory used
		 *  to generate instances of item renderers.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 *  @royaleignorecoercion org.apache.royale.core.IItemRendererClassFactory
		 */
		public function get itemRendererFactory():IItemRendererClassFactory
		{
			if(!_itemRendererFactory)
				_itemRendererFactory = loadBeadFromValuesManager(IItemRendererClassFactory, "iItemRendererClassFactory", _strand) as IItemRendererClassFactory;
			
			return _itemRendererFactory;
		}
		
		/**
		 *  @private
		 */
		public function set itemRendererFactory(value:IItemRendererClassFactory):void
		{
			_itemRendererFactory = value;
		}
		
		/**
		 *  The org.apache.royale.core.IItemRendererParent that will
		 *  parent the item renderers.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		protected var dataGroup:IItemRendererParent;
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.collections.ICollectionView
		 * @royaleignorecoercion org.apache.royale.core.IListPresentationModel
		 * @royaleignorecoercion org.apache.royale.core.ISelectableItemRenderer
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		protected function dataProviderChangeHandler(event:Event):void
		{
			if (!dataProviderModel)
				return;
			var dp:ICollectionView = dataProviderModel.dataProvider as ICollectionView;
			if (!dp)
				return;
			
			// listen for individual items being added in the future.
			var dped:IEventDispatcher = dp as IEventDispatcher;
			dped.addEventListener(CollectionEvent.ITEM_ADDED, itemAddedHandler);
			dped.addEventListener(CollectionEvent.ITEM_REMOVED, itemRemovedHandler);
			dped.addEventListener(CollectionEvent.ITEM_UPDATED, itemUpdatedHandler);
			
			dataGroup.removeAllItemRenderers();
			
			var presentationModel:IListPresentationModel = _strand.getBeadByType(IListPresentationModel) as IListPresentationModel;
			labelField = dataProviderModel.labelField;
			
			var n:int = dp.length;
			for (var i:int = 0; i < n; i++)
			{
				var ir:ISelectableItemRenderer = itemRendererFactory.createItemRenderer(dataGroup) as ISelectableItemRenderer;
				var item:Object = dp.getItemAt(i);
				fillRenderer(i, item, ir, presentationModel);
			}
			
			IEventDispatcher(_strand).dispatchEvent(new Event("itemsCreated"));
		}
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.collections.ICollectionView
		 * @royaleignorecoercion org.apache.royale.core.IListPresentationModel
		 * @royaleignorecoercion org.apache.royale.core.ISelectableItemRenderer
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		protected function itemAddedHandler(event:CollectionEvent):void
		{
			if (!dataProviderModel)
				return;
			var dp:ICollectionView = dataProviderModel.dataProvider as ICollectionView;
			if (!dp)
				return;
			
			var presentationModel:IListPresentationModel = _strand.getBeadByType(IListPresentationModel) as IListPresentationModel;
			var ir:ISelectableItemRenderer = itemRendererFactory.createItemRenderer(dataGroup) as ISelectableItemRenderer;
			labelField = dataProviderModel.labelField;
			
			fillRenderer(event.index, event.item, ir, presentationModel);
			
			// update the index values in the itemRenderers to correspond to their shifted positions.
			var n:int = dataGroup.numItemRenderers;
			for (var i:int = event.index; i < n; i++)
			{
				ir = dataGroup.getItemRendererAt(i) as ISelectableItemRenderer;
				ir.index = i;
				
				// could let the IR know its index has been changed (eg, it might change its
				// UI based on the index). Instead (PAYG), allow another bead to detect
				// this event and do this as not every IR will need to be updated.
				//var ubase:UIItemRendererBase = ir as UIItemRendererBase;
				//if (ubase) ubase.updateRenderer()
			}
			
			(_strand as IEventDispatcher).dispatchEvent(new Event("itemsCreated"));
			(_strand as IEventDispatcher).dispatchEvent(new Event("layoutNeeded"));
		}
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.collections.ICollectionView
		 * @royaleignorecoercion org.apache.royale.core.IListPresentationModel
		 * @royaleignorecoercion org.apache.royale.core.ISelectableItemRenderer
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		protected function itemRemovedHandler(event:CollectionEvent):void
		{
			if (!dataProviderModel)
				return;
			var dp:ICollectionView = dataProviderModel.dataProvider as ICollectionView;
			if (!dp)
				return;
			
			var ir:ISelectableItemRenderer = dataGroup.getItemRendererAt(event.index) as ISelectableItemRenderer;
			dataGroup.removeItemRenderer(ir);
			
			// adjust the itemRenderers' index to adjust for the shift
			var n:int = dataGroup.numItemRenderers;
			for (var i:int = event.index; i < n; i++)
			{
				ir = dataGroup.getItemRendererAt(i) as ISelectableItemRenderer;
				ir.index = i;
				
				// could let the IR know its index has been changed (eg, it might change its
				// UI based on the index). Instead (PAYG), allow another bead to detect
				// this event and do this as not every IR will need to be updated.
				//var ubase:UIItemRendererBase = ir as UIItemRendererBase;
				//if (ubase) ubase.updateRenderer()
			}
			
			(_strand as IEventDispatcher).dispatchEvent(new Event("layoutNeeded"));
		}
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.collections.ICollectionView
		 * @royaleignorecoercion org.apache.royale.core.ISelectableItemRenderer
		 */
		protected function itemUpdatedHandler(event:CollectionEvent):void
		{
			if (!dataProviderModel)
				return;
			var dp:ICollectionView = dataProviderModel.dataProvider as ICollectionView;
			if (!dp)
				return;

			// update the given renderer with (possibly) new information so it can change its
			// appearence or whatever.
			var ir:ISelectableItemRenderer = dataGroup.getItemRendererAt(event.index) as ISelectableItemRenderer;
			setData(ir, event.item, event.index);
		}
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.core.UIBase
		 */
		protected function fillRenderer(index:int,
										item:Object,
										itemRenderer:ISelectableItemRenderer,
										presentationModel:IListPresentationModel):void
		{
			dataGroup.addItemRendererAt(itemRenderer, index);
			
			itemRenderer.labelField = labelField;
			
			if (presentationModel) {
				var style:SimpleCSSStyles = new SimpleCSSStyles();
				style.marginBottom = presentationModel.separatorThickness;
				UIBase(itemRenderer).style = style;
				UIBase(itemRenderer).height = presentationModel.rowHeight;
				UIBase(itemRenderer).percentWidth = 100;
			}
			
			setData(itemRenderer, item, index);
		}
		
		/**
		 * @private
		 */
		protected function setData(itemRenderer:ISelectableItemRenderer, data:Object, index:int):void
		{
			itemRenderer.index = index;
			itemRenderer.data = data;
		}
	}
}