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
package mx.controls.listClasses
{
	import mx.collections.IList;
	
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IBeadModel;
	import org.apache.royale.core.IDataProviderItemRendererMapper;
	import org.apache.royale.core.IDataProviderModel;
	import org.apache.royale.core.IDataProviderVirtualItemRendererMapper;
	import org.apache.royale.core.IIndexedItemRenderer;
    import org.apache.royale.core.IIndexedItemRendererInitializer;
	import org.apache.royale.core.IItemRendererClassFactory;
	import org.apache.royale.core.IItemRendererOwnerView;
	import org.apache.royale.core.IListPresentationModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IStrandWithModelView;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.SimpleCSSStyles;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.CollectionEvent;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.ItemRendererEvent;
	import org.apache.royale.html.List;
	import org.apache.royale.html.beads.DataItemRendererFactoryForCollectionView;
	import org.apache.royale.html.beads.IListView;
	import org.apache.royale.html.supportClasses.DataItemRenderer;
	
	[Event(name="itemRendererCreated",type="org.apache.royale.events.ItemRendererEvent")]

    /**
     *  The DataItemRendererFactoryForHierarchicalData class reads a
     *  HierarchicalData object and creates an item renderer for every
     *  item in the array.  Other implementations of
     *  IDataProviderItemRendererMapper map different data
     *  structures or manage a virtual set of renderers.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class VirtualDataItemRendererFactoryForIListData extends DataItemRendererFactoryForIListData 
        implements IDataProviderVirtualItemRendererMapper
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function VirtualDataItemRendererFactoryForIListData()
		{
			super();
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
            var ir:IIndexedItemRenderer = rendererMap[index];
            var view:IListView = (_strand as IStrandWithModelView).view as IListView;
            var dataGroup:IItemRendererOwnerView = view.dataGroup;
            dataGroup.removeItemRenderer(ir);
            delete rendererMap[index];
        }
        
        private var rendererMap:Object = {};
                
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
        override protected function dataProviderChangeHandler(event:Event):void
        {
            // do not call super as it will be non-virtual and renderer every item in the dp
            
            var dp:IList = dataProviderModel.dataProvider as IList;
            if (!dp)
                return;
            
            var view:IListView = (_strand as IStrandWithModelView).view as IListView;
            var dataGroup:IItemRendererOwnerView = view.dataGroup;
            
            dataGroup.removeAllItemRenderers();
			IEventDispatcher(_strand).dispatchEvent(new Event("layoutNeeded"));
			
        }
        

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
        public function getItemRendererForIndex(index:int, elementIndex:int):IIndexedItemRenderer
        {
            var ir:IIndexedItemRenderer = rendererMap[index];
            if (ir) return ir;
            
            var dp:IList = dataProviderModel.dataProvider as IList;
            
            var view:IListView = (_strand as IStrandWithModelView).view as IListView;
            var dataGroup:IItemRendererOwnerView = view.dataGroup;
            ir = itemRendererFactory.createItemRenderer() as IIndexedItemRenderer;
            
            dataGroup.addItemRendererAt(ir, elementIndex);
            
            var data:Object = dp.getItemAt(index);
            (itemRendererInitializer as IIndexedItemRendererInitializer).initializeIndexedItemRenderer(ir, data, index);
            rendererMap[index] = ir;
			ir.data = data;
                        
            var newEvent:ItemRendererEvent = new ItemRendererEvent(ItemRendererEvent.CREATED);
            newEvent.itemRenderer = ir;
            dispatchEvent(newEvent);
            return ir;
        }
		
	}
}
