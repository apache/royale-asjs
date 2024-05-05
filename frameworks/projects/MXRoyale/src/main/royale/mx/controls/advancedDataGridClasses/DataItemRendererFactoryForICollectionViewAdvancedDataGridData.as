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
package mx.controls.advancedDataGridClasses
{
	import mx.collections.CursorBookmark;
    import mx.collections.HierarchicalCollectionView;
    import mx.collections.ICollectionView;
import mx.collections.IList;
import mx.collections.IViewCursor;
    import mx.events.CollectionEvent;
    import mx.events.CollectionEventKind;
    import mx.events.PropertyChangeEvent;

    import org.apache.royale.core.IIndexedItemRenderer;
	import org.apache.royale.core.IIndexedItemRendererInitializer;
	import org.apache.royale.core.IItemRendererOwnerView;
	import org.apache.royale.core.IStrandWithModelView;
	import org.apache.royale.events.Event;
    import org.apache.royale.events.CollectionEvent;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.beads.IListView;
	import org.apache.royale.html.beads.VirtualDataItemRendererFactoryBase;
    import org.apache.royale.utils.sendBeadEvent;
    import org.apache.royale.utils.sendStrandEvent;

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
	public class DataItemRendererFactoryForICollectionViewAdvancedDataGridData extends VirtualDataItemRendererFactoryBase
	{
		private var cursor:IViewCursor;
		private var currentIndex:int;

		/**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function DataItemRendererFactoryForICollectionViewAdvancedDataGridData()
		{
			super();
		}

        private var dp:ICollectionView;

        /**
         * @private
         * @royaleignorecoercion mx.collections.ICollectionView
         * @royaleignorecoercion org.apache.royale.core.IListPresentationModel
         * @royaleignorecoercion org.apache.royale.core.IIndexedItemRenderer
         * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
         */
        override protected function dataProviderChangeHandler(event:Event):void
        {
            if (!dataProviderModel)
                return;
            var newDP:ICollectionView = dataProviderModel.dataProvider as ICollectionView;;
            if (dp)
            {
                dp.removeEventListener(mx.events.CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler);

            }
            if (!newDP) {
                if (cursor)
                {
                    cursor.finalizeThis();
                    cursor = null;
                }
                return;
            }

            dp = newDP;
            resetCollectionCursor();
            currentIndex = (dp.length > 0) ? 0 : -1;

			super.dataProviderChangeHandler(event);
            if (dp)
            {
                dp.addEventListener(mx.events.CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler);
            }
        }

        /**
         *  Get a item for a given index.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.0
         *  @royaleignorecoercion org.apache.royale.core.IStrandWithModelView
         *  @royaleignorecoercion org.apache.royale.html.beads.IListView
         */
        override public function getItemAt(index:int):Object
        {
            var delta:int = index - currentIndex;

            if (currentIndex == -1)
            {
                cursor.seek(CursorBookmark.FIRST, index);                
            }
            else if (delta == -1)
            {
                cursor.movePrevious();
            }
            else if (delta == 1)
            {
                cursor.moveNext();
            }
            else if (delta != 0)
            {
                cursor.seek(CursorBookmark.CURRENT, delta);
            }
            currentIndex = index;
			return cursor.current;
        }

		private function resetCollectionCursor():void
		{
			if (cursor)
			{
				cursor.finalizeThis();
			}

			var dp:ICollectionView = dataProviderModel.dataProvider as ICollectionView;
			cursor = dp.createCursor();
		}


        protected function collectionChangeHandler(event:mx.events.CollectionEvent):void
        {

            trace('collections HCV collectionChangeHandler', event);

            var item:Object;
            var hcv:HierarchicalCollectionView;
            var list:IList;
            if (event is mx.events.CollectionEvent)
            {

                if (event.kind == CollectionEventKind.UPDATE)
                {
                    var propertyChangeEvents:Array = event.items;
                    var index:int;

                    list = dp as IList;
                    if (!list){
                        hcv = dp as HierarchicalCollectionView;
                       //if hcv is null, what other options are there?
                    }

                    for each(var propertyChangeEvent:PropertyChangeEvent in propertyChangeEvents) {
                        var data:Object = propertyChangeEvent.source;
                        if (list){
                            index = list.getItemIndex(data);
                        } else {
                            index = hcv.getItemIndex(data);
                        }
                        var updateEvent:org.apache.royale.events.CollectionEvent = new org.apache.royale.events.CollectionEvent(org.apache.royale.events.CollectionEvent.ITEM_UPDATED);
                        updateEvent.item = data;
                        updateEvent.index = index;
                        this.itemUpdatedHandler(updateEvent);
                    }
                }

                /*else if (event.kind == mx.events.CollectionEventKind.RESET)
                {
                    // RESET may be from XMLListCollection source = newxmlllist + refresh(), for example.
                    sendBeadEvent(dataProviderModel, "dataProviderChanged");
                }
                else if (event.kind == CollectionEventKind.ADD)
                {
                    item = event.items[0];
                    hcv = dp as HierarchicalCollectionView;
                    var addEvent:org.apache.royale.events.CollectionEvent
                            = new org.apache.royale.events.CollectionEvent(org.apache.royale.events.CollectionEvent.ITEM_ADDED);
                    addEvent.item = item;//event.items[0];
                    addEvent.index = event.location;
                    itemAddedHandler(addEvent);
                   /!* if (hcv.amIVisible(hcv.getParentItem(item))) {
                        // ADD may be from HierarchicalCollectionView.xmlNotification
                        var addEvent:org.apache.royale.events.CollectionEvent
                                = new org.apache.royale.events.CollectionEvent(org.apache.royale.events.CollectionEvent.ITEM_ADDED);
                        addEvent.item = event.items[0];
                        addEvent.index = event.location;
                        itemAddedHandler(addEvent);
                    }*!/
                }*/
                /*else if (event.kind == CollectionEventKind.REMOVE)
                {
                    item = event.items[0];
                    hcv = dp as HierarchicalCollectionView;
                    var removeEvent:org.apache.royale.events.CollectionEvent
                            = new org.apache.royale.events.CollectionEvent(org.apache.royale.events.CollectionEvent.ITEM_REMOVED);
                    removeEvent.item = item;//event.items[0];
                    removeEvent.index = event.location;
                    itemRemovedHandler(removeEvent);
                   /!* if (hcv.amIVisible(hcv.getParentItem(item))) {
                        // REMOVE may be from HierarchicalCollectionView.xmlNotification
                        var removeEvent:org.apache.royale.events.CollectionEvent
                                = new org.apache.royale.events.CollectionEvent(org.apache.royale.events.CollectionEvent.ITEM_REMOVED);
                        removeEvent.item = event.items[0];
                        removeEvent.index = event.location;
                        itemRemovedHandler(removeEvent);
                    }*!/

                }*/
                /*else if (event.kind == CollectionEventKind.UPDATE)
                {
                    var propertyChangeEvents:Array = event.items;
                    var index:int;
                    hcv = dp as HierarchicalCollectionView;
                    for each(var propertyChangeEvent:PropertyChangeEvent in propertyChangeEvents) {
                        var data:Object = propertyChangeEvent.source;
                        index = hcv.getItemIndex(data);
                        var updateEvent:org.apache.royale.events.CollectionEvent = new org.apache.royale.events.CollectionEvent(org.apache.royale.events.CollectionEvent.ITEM_UPDATED);
                        updateEvent.item = data;
                        updateEvent.index = index;
                        this.itemUpdatedHandler(updateEvent);
                        /!*if (hcv.amIVisible(data)) {
                            index = hcv.getItemIndex(data);
                            var updateEvent:org.apache.royale.events.CollectionEvent = new org.apache.royale.events.CollectionEvent(org.apache.royale.events.CollectionEvent.ITEM_UPDATED);
                            updateEvent.item = data;
                            updateEvent.index = index;
                            this.itemUpdatedHandler(updateEvent);
                        }*!/
                    }*/
                    /*for each(var propertyChangeEvent:PropertyChangeEvent in propertyChangeEvents) {
                        var data:Object = propertyChangeEvent.source;
                        if (hcv.amIVisible(data)) {
                            index = hcv.getItemIndex(data);
                            var updateEvent:org.apache.royale.events.CollectionEvent = new org.apache.royale.events.CollectionEvent(org.apache.royale.events.CollectionEvent.ITEM_UPDATED);
                            updateEvent.item = data;
                            updateEvent.index = index;
                            this.itemUpdatedHandler(updateEvent);
                        }
                    }
                }*/
            }
        }


        //(GD) tried the granular approaches with added/removed, but for now instead using the 'brute-force'
        // refresh approach from ADG level (see deferredViewUpdate)
        /**
         * @private
         * @royaleignorecoercion org.apache.royale.collections.ICollectionView
         * @royaleignorecoercion org.apache.royale.core.IListPresentationModel
         * @royaleignorecoercion org.apache.royale.core.IIndexedItemRenderer
         */
        /*protected function itemAddedHandler(event:org.apache.royale.events.CollectionEvent):void
        {
            /!*if(!dataProviderExist)
                return;*!/
            var view:IListView = (_strand as IStrandWithModelView).view as IListView;
            var dataGroup:IItemRendererOwnerView = view.dataGroup;

            var ir:IIndexedItemRenderer = itemRendererFactory.createItemRenderer() as IIndexedItemRenderer;

            var data:Object = event.item;
            dataGroup.addItemRendererAt(ir, event.index);
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

            sendStrandEvent(_strand,"itemsCreated");
            sendStrandEvent(_strand,"layoutNeeded");
        }*/

        /**
         * @private
         * @royaleignorecoercion org.apache.royale.collections.ICollectionView
         * @royaleignorecoercion org.apache.royale.core.IListPresentationModel
         * @royaleignorecoercion org.apache.royale.core.IIndexedItemRenderer
         */
        /*protected function itemRemovedHandler(event:org.apache.royale.events.CollectionEvent):void
        {
            /!*if(!dataProviderExist)
                return;*!/

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

            sendStrandEvent(_strand,"layoutNeeded");
        }*/

        /**
         * @private
         * @royaleignorecoercion org.apache.royale.collections.ICollectionView
         * @royaleignorecoercion org.apache.royale.core.IIndexedItemRenderer
         */
        protected function itemUpdatedHandler(event:org.apache.royale.events.CollectionEvent):void
        {
           /* if(!dataProviderExist)
                return;*/

            var view:IListView = (_strand as IStrandWithModelView).view as IListView;
            var dataGroup:IItemRendererOwnerView = view.dataGroup;

            // update the given renderer with (possibly) new information so it can change its
            // appearence or whatever.
            var ir:IIndexedItemRenderer = dataGroup.getItemRendererAt(event.index) as IIndexedItemRenderer;
            if (ir){
                var data:Object = event.item;
                (itemRendererInitializer as IIndexedItemRendererInitializer).initializeIndexedItemRenderer(ir, data, event.index);
                ir.data = data;
            }

        }
	}
}
