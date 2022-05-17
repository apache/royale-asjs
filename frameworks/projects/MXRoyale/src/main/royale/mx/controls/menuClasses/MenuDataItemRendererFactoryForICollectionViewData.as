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
package mx.controls.menuClasses
{
    import mx.collections.ArrayCollection;
    import mx.collections.ICollectionView;
    import mx.collections.IViewCursor;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;

	import mx.controls.beads.models.MenuBarModel;
    
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
	public class MenuDataItemRendererFactoryForICollectionViewData extends DataItemRendererFactoryBase
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function MenuDataItemRendererFactoryForICollectionViewData()
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
			var menuBarModel:MenuBarModel =MenuBarModel(dataProviderModel);
			if (dp) {
				//First remove if it's already added
				dp.removeEventListener(mx.events.CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler);
			}
            dp = menuBarModel.dataProvider as ICollectionView;

			if (dp) {
				if (menuBarModel.hasRoot && !menuBarModel.showRoot) {
					//this corresponds roughly to part of the code inside commitProperties in the original Flex MenuBar code:
					var rootItem:* = dp.createCursor().current;
					var tmpCollection:ICollectionView;
					if (rootItem != null &&
							menuBarModel.dataDescriptor.isBranch(rootItem, dp) &&
							menuBarModel.dataDescriptor.hasChildren(rootItem, dp))
					{
						// then get rootItem children
						tmpCollection =
								menuBarModel.dataDescriptor.getChildren(rootItem, dp);

						dp = tmpCollection;
					}
					//not part of the original Flex code, but should we not do this? (it is a root node with no children - i.e. should it not be an empty menubar? ) :
					/*else {
						dp = new ArrayCollection();
					}*/
				}

				dp.addEventListener(mx.events.CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler);
			}
            
            super.dataProviderChangeHandler(event);            
        }
		
        private var cursor:IViewCursor;
        
        
        // assumes will be called in a loop, not random access
        override protected function get dataProviderLength():int
        {
			if (!dp) return 0;
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
		protected function itemAddedHandler(event:CollectionEvent):void
		{
			if (!dataProviderModel)
				return;
			dp = dataProviderModel.dataProvider as ICollectionView;
			if (!dp)
				return;
			
            var view:IListView = (_strand as IStrandWithModelView).view as IListView;
            var dataGroup:IItemRendererOwnerView = view.dataGroup;
            
			var ir:IIndexedItemRenderer = itemRendererFactory.createItemRenderer() as IIndexedItemRenderer;
			dataGroup.addItemRendererAt(ir, event.location);

            var data:Object = event.items[0];//.pop();
            (itemRendererInitializer as IIndexedItemRendererInitializer).initializeIndexedItemRenderer(ir, data, event.location);
            ir.data = data;				
			
			// update the index values in the itemRenderers to correspond to their shifted positions.
			var n:int = dataGroup.numItemRenderers;
			for (var i:int = event.location; i < n; i++)
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
		
		protected function itemRemovedHandler(event:CollectionEvent):void
		{
			if (!dataProviderModel)
				return;
			dp = dataProviderModel.dataProvider as ICollectionView;
			if (!dp)
				return;
			
            var view:IListView = (_strand as IStrandWithModelView).view as IListView;
            var dataGroup:IItemRendererOwnerView = view.dataGroup;
            
			var ir:IIndexedItemRenderer = dataGroup.getItemRendererAt(event.location) as IIndexedItemRenderer;
			if (!ir) return; // may have already been cleaned up, possibly when a tree node closes
			dataGroup.removeItemRenderer(ir);
			
			// adjust the itemRenderers' index to adjust for the shift
			var n:int = dataGroup.numItemRenderers;
			for (var i:int = event.location; i < n; i++)
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
		protected function itemUpdatedHandler(event:CollectionEvent):void
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
			var ir:IIndexedItemRenderer = dataGroup.getItemRendererAt(event.location) as IIndexedItemRenderer;

            var data:Object = event.items[0];//.pop();
            (itemRendererInitializer as IIndexedItemRendererInitializer).initializeIndexedItemRenderer(ir, data, event.location);
            ir.data = data;				
		}
		
				/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.collections.ICollectionView
		 * @royaleignorecoercion org.apache.royale.core.IListPresentationModel
		 * @royaleignorecoercion org.apache.royale.core.IIndexedItemRenderer
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		protected function collectionChangeHandler(event:CollectionEvent):void
		{
			if (!dataProviderModel)
				return;
			dp = dataProviderModel.dataProvider as ICollectionView;
			if (!dp)
				return;
			
			if (event.kind == CollectionEventKind.RESET || event.kind == CollectionEventKind.REFRESH)
			{
				super.dataProviderChangeHandler(event);            
			}
			else if (event.kind == CollectionEventKind.REMOVE)
			{
				this.itemRemovedHandler(event);
			}
			else if (event.kind == CollectionEventKind.ADD)
			{
				this.itemAddedHandler(event);
			}
			else if (event.kind == CollectionEventKind.UPDATE)
			{
				this.itemUpdatedHandler(event);
			}
		}
	}
}
