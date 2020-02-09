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
package org.apache.royale.jewel.beads.itemRenderers
{
	import org.apache.royale.collections.ArrayList;
	import org.apache.royale.collections.ICollectionView;
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IDataProviderModel;
	import org.apache.royale.core.IDataProviderVirtualItemRendererMapper;
	import org.apache.royale.core.IItemRendererClassFactory;
	import org.apache.royale.core.IItemRendererParent;
	import org.apache.royale.core.ISelectableItemRenderer;
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IStrandWithModelView;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.ItemRendererEvent;
	import org.apache.royale.html.beads.IListView;
	import org.apache.royale.html.supportClasses.DataItemRenderer;
	import org.apache.royale.jewel.supportClasses.list.IListPresentationModel;
	import org.apache.royale.utils.loadBeadFromValuesManager;
	import org.apache.royale.utils.sendStrandEvent;

    [Event(name="itemRendererCreated",type="org.apache.royale.events.ItemRendererEvent")]
	
    /**
     *  The DataItemRendererFactoryForArrayData class reads an
     *  array of data and creates an item renderer for every
     *  item in the array.  Other implementations of
     *  IDataProviderItemRendererMapper map different data 
     *  structures or manage a virtual set of renderers.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.7
     */
	public class VirtualDataItemRendererFactoryForCollectionView extends EventDispatcher implements IBead, IDataProviderVirtualItemRendererMapper
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
		public function VirtualDataItemRendererFactoryForCollectionView(target:Object=null)
		{
			super(target);
		}

		protected var dataProviderModel:IDataProviderModel;
		protected var dataFieldProvider:DataFieldProviderBead;
		
		protected var labelField:String;
        protected var dataField:String;

		private var _strand:IStrand;
        /**
         *  @copy org.apache.royale.core.IBead#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			IEventDispatcher(value).addEventListener("initComplete", initComplete);
		}
		
		/**
		 * @private
		 */
		private function initComplete(event:Event):void
		{
            IEventDispatcher(_strand).removeEventListener("initComplete", initComplete);

            var view:IListView = (_strand as IStrandWithModelView).view as IListView;
			dataGroup = view.dataGroup;

			dataProviderModel = _strand.getBeadByType(IDataProviderModel) as IDataProviderModel;
			dataProviderModel.addEventListener("dataProviderChanged", dataProviderChangeHandler);
			labelField = dataProviderModel.labelField;

            dataFieldProvider = _strand.getBeadByType(DataFieldProviderBead) as DataFieldProviderBead;
			if (dataFieldProvider)
            {
                dataField = dataFieldProvider.dataField;
            }

			// if the host component inherits from DataContainerBase, the itemRendererClassFactory will 
			// already have been loaded by DataContainerBase.addedToParent function.
			if(!_itemRendererFactory)
    			_itemRendererFactory = loadBeadFromValuesManager(IItemRendererClassFactory, "iItemRendererClassFactory", _strand) as IItemRendererClassFactory;				
			
			dataProviderChangeHandler(null);
		}
		
		private var _itemRendererFactory:IItemRendererClassFactory;
		
        /**
         *  The org.apache.royale.core.IItemRendererClassFactory used 
         *  to generate instances of item renderers.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
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
		 *  @productversion Royale 0.9.7
		 */
		protected var dataGroup:IItemRendererParent;
		
        /**
         *  The org.apache.royale.core.IItemRendererParent that will
         *  parent the item renderers.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         *  @royaleignorecoercion org.apache.royale.core.IStrandWithModelView
         *  @royaleignorecoercion org.apache.royale.html.beads.IListView
         */		
		protected function dataProviderChangeHandler(event:Event):void
		{
            if (!dataProviderModel)
				return;
			var dp:ICollectionView = dataProviderModel.dataProvider as ICollectionView;
			if (!dp)
				return;
			
			dataGroup.removeAllItemRenderers();

            sendStrandEvent(_strand, "layoutNeeded");
        }
        
        /**
         *  Free an item renderer for a given index.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         *  @royaleignorecoercion org.apache.royale.core.IStrandWithModelView
         *  @royaleignorecoercion org.apache.royale.html.beads.IListView
         */
        public function freeItemRendererForIndex(index:int):void
        {
            dataGroup.removeItemRenderer(rendererMap[index]);
            delete rendererMap[index];
        }
        
        protected var rendererMap:Object = {};
        
        /**
         *  Get an item renderer for a given index.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         *  @royaleignorecoercion org.apache.royale.core.IStrandWithModelView
         *  @royaleignorecoercion org.apache.royale.html.beads.IListView
         */
        public function getItemRendererForIndex(index:int, elementIndex:int):ISelectableItemRenderer
        {
            var ir:ISelectableItemRenderer = rendererMap[index];
            if (ir) return ir;
            
            var dp:ArrayList = dataProviderModel.dataProvider as ArrayList;
            
			ir = itemRendererFactory.createItemRenderer(dataGroup) as ISelectableItemRenderer;
            var dataItemRenderer:DataItemRenderer = ir as DataItemRenderer;

            dataGroup.addItemRendererAt(ir, elementIndex);
			ir.index = index;
			ir.labelField = labelField;
            if (dataItemRenderer)
            {
                dataItemRenderer.dataField = dataField;
            }
            rendererMap[index] = ir;
            
            var presentationModel:IListPresentationModel = _strand.getBeadByType(IListPresentationModel) as IListPresentationModel;
			if (presentationModel) {
				UIBase(ir).height = presentationModel.rowHeight;
				
				if(ir is IAlignItemRenderer)
				{
					(ir as IAlignItemRenderer).align = presentationModel.align;
				}
			}
			ir.data = dp.getItemAt(index);
            
            // if the item was already selected make the item show it
            if(index == (dataProviderModel as ISelectionModel).selectedIndex)
            {
                ir.selected = true;
            }
				
			var itemCreatedEvent:ItemRendererEvent = new ItemRendererEvent(ItemRendererEvent.CREATED);
			itemCreatedEvent.itemRenderer = ir;
			sendStrandEvent(_strand, itemCreatedEvent);
            return ir;
		}
	}
}
