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
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IChild;
	import org.apache.royale.core.IDataProviderModel;
	import org.apache.royale.core.IDataProviderVirtualItemRendererMapper;
	import org.apache.royale.core.IItemRendererClassFactory;
	import org.apache.royale.core.IItemRendererOwnerView;
	import org.apache.royale.core.ILayoutHost;
	import org.apache.royale.core.IListPresentationModel;
	import org.apache.royale.core.IParentIUIBase;
	import org.apache.royale.core.ISelectableItemRenderer;
	import org.apache.royale.core.IStrand;
    import org.apache.royale.core.IStrandWithModelView;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.SimpleCSSStyles;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.ItemRendererEvent;
	import org.apache.royale.html.List;
    import org.apache.royale.html.beads.IListView;
	import org.apache.royale.html.supportClasses.DataItemRenderer;
	import org.apache.royale.utils.loadBeadFromValuesManager;

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
     *  @productversion Royale 0.0
     */
	public class VirtualDataItemRendererFactoryForArrayData extends EventDispatcher implements IBead, IDataProviderVirtualItemRendererMapper
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function VirtualDataItemRendererFactoryForArrayData(target:Object=null)
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
         *  @productversion Royale 0.0
         */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			IEventDispatcher(value).addEventListener("initComplete",finishSetup);
		}
		
		/**
		 * @private
		 */
		private function finishSetup(event:Event):void
		{			
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
         *  @productversion Royale 0.0
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
         *  The org.apache.royale.core.IItemRendererOwnerView that will
         *  parent the item renderers.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         *  @royaleignorecoercion org.apache.royale.core.IStrandWithModelView
         *  @royaleignorecoercion org.apache.royale.html.beads.IListView
         */		
		protected function dataProviderChangeHandler(event:Event):void
		{
			var dp:Array = dataProviderModel.dataProvider as Array;
			if (!dp)
				return;
			
            var view:IListView = (_strand as IStrandWithModelView).view as IListView;
			var dataGroup:IItemRendererOwnerView = view.dataGroup;
			
			dataGroup.removeAllItemRenderers();
        }
        
        /**
         *  Free an item renderer for a given index.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.0
         *  @royaleignorecoercion org.apache.royale.core.IStrandWithModelView
         *  @royaleignorecoercion org.apache.royale.html.beads.IListView
         */
        public function freeItemRendererForIndex(index:int):void
        {
            var ir:ISelectableItemRenderer = rendererMap[index];
            var view:IListView = (_strand as IStrandWithModelView).view as IListView;
            var dataGroup:IItemRendererOwnerView = view.dataGroup;
            dataGroup.removeItemRenderer(ir);
            delete rendererMap[index];
        }
        
        protected var rendererMap:Object = {};
        
        /**
         *  Get an item renderer for a given index.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.0
         *  @royaleignorecoercion org.apache.royale.core.IStrandWithModelView
         *  @royaleignorecoercion org.apache.royale.html.beads.IListView
         */
        public function getItemRendererForIndex(index:int, elementIndex:int):ISelectableItemRenderer
        {
            var ir:ISelectableItemRenderer = rendererMap[index];
            if (ir) return ir;
            
            var dp:Array = dataProviderModel.dataProvider as Array;
            
			ir = itemRendererFactory.createItemRenderer(dataGroup) as ISelectableItemRenderer;
            var dataItemRenderer:DataItemRenderer = ir as DataItemRenderer;

            var view:IListView = (_strand as IStrandWithModelView).view as IListView;
            var dataGroup:IItemRendererOwnerView = view.dataGroup;
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
				var style:SimpleCSSStyles = new SimpleCSSStyles();
				style.marginBottom = presentationModel.separatorThickness;
				UIBase(ir).style = style;
				UIBase(ir).height = presentationModel.rowHeight;
				UIBase(ir).percentWidth = 100;
			}
			ir.data = dp[index];
				
			var newEvent:ItemRendererEvent = new ItemRendererEvent(ItemRendererEvent.CREATED);
			newEvent.itemRenderer = ir;
			dispatchEvent(newEvent);
            return ir;
		}
	}
}
