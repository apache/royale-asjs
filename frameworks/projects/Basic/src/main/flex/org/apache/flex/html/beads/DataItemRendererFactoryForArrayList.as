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
	import org.apache.flex.collections.IArrayList;
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IDataProviderItemRendererMapper;
	import org.apache.flex.core.IItemRendererClassFactory;
	import org.apache.flex.core.IItemRendererParent;
	import org.apache.flex.core.IListPresentationModel;
	import org.apache.flex.core.ISelectableItemRenderer;
	import org.apache.flex.core.ISelectionModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.SimpleCSSStyles;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.events.EventDispatcher;
	import org.apache.flex.events.ItemRendererEvent;
	import org.apache.flex.html.List;
	
	[Event(name="itemRendererCreated",type="org.apache.flex.events.ItemRendererEvent")]
	
    /**
     *  The DataItemRendererFactoryForArrayList class uses an ArrayList
	 *  and creates an item renderer for every
     *  item in the collection.  Other implementations of
     *  IDataProviderItemRendererMapper map different data 
     *  structures or manage a virtual set of renderers.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class DataItemRendererFactoryForArrayList extends EventDispatcher implements IBead, IDataProviderItemRendererMapper
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function DataItemRendererFactoryForArrayList(target:Object=null)
		{
			super(target);
		}
		
		protected var selectionModel:ISelectionModel;
		
		protected var labelField:String;
		
		private var _strand:IStrand;
		
        /**
         *  @copy org.apache.flex.core.IBead#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			IEventDispatcher(_strand).addEventListener("beadsAdded", finishSetup);
			IEventDispatcher(_strand).addEventListener("initComplete", finishSetup);
		}
		
		private function finishSetup(event:Event):void
		{
			selectionModel = _strand.getBeadByType(ISelectionModel) as ISelectionModel;
			var listView:IListView = _strand.getBeadByType(IListView) as IListView;
			dataGroup = listView.dataGroup;
			selectionModel.addEventListener("dataProviderChanged", dataProviderChangeHandler);
			
			labelField = (listView.host as List).labelField;
			
			if (!itemRendererFactory)
			{
				_itemRendererFactory = _strand.getBeadByType(IItemRendererClassFactory) as IItemRendererClassFactory;
				if (_itemRendererFactory == null) {
					_itemRendererFactory = new (ValuesManager.valuesImpl.getValue(_strand, "iItemRendererClassFactory")) as IItemRendererClassFactory;
					_strand.addBead(_itemRendererFactory);
				}
			}
			
			dataProviderChangeHandler(null);
		}
		
		private var _itemRendererFactory:IItemRendererClassFactory;
		
        /**
         *  The org.apache.flex.core.IItemRendererClassFactory used 
         *  to generate instances of item renderers.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function get itemRendererFactory():IItemRendererClassFactory
		{
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
         *  The org.apache.flex.core.IItemRendererParent that will
         *  parent the item renderers.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		protected var dataGroup:IItemRendererParent;
		
		/**
		 * @private
		 */
		protected function setData(ir:ISelectableItemRenderer, data:Object, index:int):void
		{
			ir.index = index;
			ir.labelField = labelField;
			ir.data = data;
		}
		
		/**
		 * @private
		 */
		protected function dataProviderChangeHandler(event:Event):void
		{
			var dp:IArrayList = selectionModel.dataProvider as IArrayList;
			if (!dp)
				return;
			
			dataGroup.removeAllElements();
			
			var listView:IListView = _strand.getBeadByType(IListView) as IListView;
			var presentationModel:IListPresentationModel = _strand.getBeadByType(IListPresentationModel) as IListPresentationModel;
			
			var n:int = dp.length; 
			for (var i:int = 0; i < n; i++)
			{				
				var ir:ISelectableItemRenderer = itemRendererFactory.createItemRenderer(dataGroup) as ISelectableItemRenderer;
				if (presentationModel) {
					UIBase(ir).height = presentationModel.rowHeight;
					
					// ensure that the IR spans the width of its column
					var style:SimpleCSSStyles = new SimpleCSSStyles();
					style.right = 0;
					style.left = 0;
					UIBase(ir).style = style;
				}
				dataGroup.addElement(ir);
				setData(ir, dp.getItemAt(i), i);
				
				var newEvent:ItemRendererEvent = new ItemRendererEvent(ItemRendererEvent.CREATED);
				newEvent.itemRenderer = ir;
				dispatchEvent(newEvent);
			}
			
			IEventDispatcher(_strand).dispatchEvent(new Event("itemsCreated"));
		}
	}
}
