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
    import mx.collections.ArrayCollection;
    import mx.collections.ICollectionView;
    import mx.collections.IViewCursor;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
    
    import org.apache.royale.core.IBead;
    import org.apache.royale.core.IBeadModel;
    import org.apache.royale.core.IDataProviderItemRendererMapper;
    import org.apache.royale.core.IDataProviderModel;
    import org.apache.royale.core.IItemRendererClassFactory;
    import org.apache.royale.core.IItemRendererOwnerView;
    import org.apache.royale.core.IListPresentationModel;
    import org.apache.royale.core.IIndexedItemRenderer;
    import org.apache.royale.core.IIndexedItemRendererInitializer;
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
    import org.apache.royale.html.beads.IListView;
    import org.apache.royale.html.beads.DataItemRendererFactoryBase;
    import org.apache.royale.html.supportClasses.TreeListData;
	
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
	public class DataItemRendererFactoryForICollectionViewData extends DataItemRendererFactoryBase
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function DataItemRendererFactoryForICollectionViewData()
		{
			super();
		}
        
        private var dp:ICollectionView;
        
        /**
         * @private
         * @royaleignorecoercion org.apache.royale.core.IListPresentationModel
         * @royaleignorecoercion org.apache.royale.core.ISelectableItemRenderer
         * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
         */
        override protected function dataProviderChangeHandler(event:Event):void
        {
            if (!dataProviderModel)
                return;
            dp = dataProviderModel.dataProvider as ICollectionView;
            if (!dp)
            {
                // temporary until descriptor is used in MenuBarModel
                var obj:Object = dataProviderModel.dataProvider;
                if (obj is Array)
                {
                    dp = new ArrayCollection(obj as Array);
                }
                else
                    return;
            }
            
            // listen for individual items being added in the future.
            var dped:IEventDispatcher = dp as IEventDispatcher;
            dped.addEventListener(org.apache.royale.events.CollectionEvent.ITEM_ADDED, itemAddedHandler);
            dped.addEventListener(org.apache.royale.events.CollectionEvent.ITEM_REMOVED, itemRemovedHandler);
            dped.addEventListener(org.apache.royale.events.CollectionEvent.ITEM_UPDATED, itemUpdatedHandler);
            dped.addEventListener(mx.events.CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler);
            
            super.dataProviderChangeHandler(event);            
        }
		
        private var cursor:IViewCursor;
        
        
        // assumes will be called in a loop, not random access
        override protected function get dataProviderLength():int
        {
            cursor = dp.createCursor();
            return dp.length;
        }
        
        // assumes will be called in a loop, not random access
        override protected function getItemAt(index:int):Object
        {
            var obj:Object = cursor.current;
            cursor.moveNext();
            return obj;
        }

		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.collections.ICollectionView
		 * @royaleignorecoercion org.apache.royale.core.IListPresentationModel
		 * @royaleignorecoercion org.apache.royale.core.IIndexedItemRenderer
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		protected function itemAddedHandler(event:org.apache.royale.events.CollectionEvent):void
		{
			if (!dataProviderModel)
				return;
			dp = dataProviderModel.dataProvider as ICollectionView;
			if (!dp)
				return;
			
            var view:IListView = (_strand as IStrandWithModelView).view as IListView;
            var dataGroup:IItemRendererOwnerView = view.dataGroup;
            
			var ir:IIndexedItemRenderer = itemRendererFactory.createItemRenderer() as IIndexedItemRenderer;
			dataGroup.addItemRendererAt(ir, event.index);

            var data:Object = event.item;
            (itemRendererInitializer as IIndexedItemRendererInitializer).initializeIndexedItemRenderer(ir, data, event.index);
            ir.data = data;				
			
			// update the index values in the itemRenderers to correspond to their shifted positions.
			var n:int = dataGroup.numItemRenderers;
			for (var i:int = event.index; i < n; i++)
			{
				ir = dataGroup.getItemRendererAt(i) as IIndexedItemRenderer;
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
		
		protected function itemRemovedHandler(event:org.apache.royale.events.CollectionEvent):void
		{
			if (!dataProviderModel)
				return;
			dp = dataProviderModel.dataProvider as ICollectionView;
			if (!dp)
				return;
			
            var view:IListView = (_strand as IStrandWithModelView).view as IListView;
            var dataGroup:IItemRendererOwnerView = view.dataGroup;
            
			var ir:IIndexedItemRenderer = dataGroup.getItemRendererAt(event.index) as IIndexedItemRenderer;
			if (!ir) return; // may have already been cleaned up, possibly when a tree node closes
			dataGroup.removeItemRenderer(ir);
			
			// adjust the itemRenderers' index to adjust for the shift
			var n:int = dataGroup.numItemRenderers;
			for (var i:int = event.index; i < n; i++)
			{
				ir = dataGroup.getItemRendererAt(i) as IIndexedItemRenderer;
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
		 * @royaleignorecoercion org.apache.royale.core.IIndexedItemRenderer
		 */
		protected function itemUpdatedHandler(event:org.apache.royale.events.CollectionEvent):void
		{
			if (!dataProviderModel)
				return;
			dp = dataProviderModel.dataProvider as ICollectionView;
			if (!dp)
				return;

            var view:IListView = (_strand as IStrandWithModelView).view as IListView;
            var dataGroup:IItemRendererOwnerView = view.dataGroup;
            
			// update the given renderer with (possibly) new information so it can change its
			// appearence or whatever.
			var ir:IIndexedItemRenderer = dataGroup.getItemRendererAt(event.index) as IIndexedItemRenderer;

            var data:Object = event.item;
            (itemRendererInitializer as IIndexedItemRendererInitializer).initializeIndexedItemRenderer(ir, data, event.index);
            ir.data = data;				
		}
		
				/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.collections.ICollectionView
		 * @royaleignorecoercion org.apache.royale.core.IListPresentationModel
		 * @royaleignorecoercion org.apache.royale.core.IIndexedItemRenderer
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		protected function collectionChangeHandler(event:mx.events.CollectionEvent):void
		{
			if (!dataProviderModel)
				return;
			dp = dataProviderModel.dataProvider as ICollectionView;
			if (!dp)
				return;
			
			if (event.kind == CollectionEventKind.RESET)
			{
	            super.dataProviderChangeHandler(event);            
			}
		}
		
		
		
	}
}
