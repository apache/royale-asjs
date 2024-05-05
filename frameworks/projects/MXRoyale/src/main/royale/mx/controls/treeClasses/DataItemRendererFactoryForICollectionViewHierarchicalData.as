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
package mx.controls.treeClasses
{
	import mx.collections.ICollectionView;
    import mx.collections.IViewCursor;
    import mx.collections.ICollectionView;
    import mx.collections.ListCollectionView;
    import mx.events.CollectionEvent;
    import mx.events.CollectionEventKind;
    import mx.events.PropertyChangeEvent;
	
	import org.apache.royale.collections.FlattenedList;
	import org.apache.royale.collections.HierarchicalData;
	import org.apache.royale.collections.ITreeData;
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IBeadModel;
	import org.apache.royale.core.IDataProviderItemRendererMapper;
	import org.apache.royale.core.IDataProviderModel;
	import org.apache.royale.core.IItemRendererClassFactory;
	import org.apache.royale.core.IItemRendererOwnerView;
	import org.apache.royale.core.IListPresentationModel;
	import org.apache.royale.core.ISelectableItemRenderer;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.SimpleCSSStyles;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
    import org.apache.royale.events.CollectionEvent;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.ItemRendererEvent;
	import org.apache.royale.html.List;
    import org.apache.royale.html.beads.DataItemRendererFactoryForCollectionView;
    import org.apache.royale.utils.sendBeadEvent;

    import org.apache.royale.core.IIndexedItemRenderer;
    import org.apache.royale.core.IIndexedItemRendererInitializer;
    import org.apache.royale.core.IItemRendererOwnerView;
    import org.apache.royale.core.IStrandWithModelView;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.html.beads.IListView;
    import org.apache.royale.utils.sendStrandEvent;

    COMPILE::SWF{
        import flash.utils.setTimeout;
        import flash.utils.Dictionary;
    }
	
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
	public class DataItemRendererFactoryForICollectionViewHierarchicalData extends DataItemRendererFactoryForCollectionView
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function DataItemRendererFactoryForICollectionViewHierarchicalData()
		{
			super();
            resetOnRemove = true;
		}

		private var dp:ICollectionView;
		
        /**
         * @private
         * @royaleignorecoercion mx.collections.ICollectionView
         * @royaleignorecoercion org.apache.royale.core.IListPresentationModel
         * @royaleignorecoercion org.apache.royale.core.ISelectableItemRenderer
         * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
         */
        override protected function dataProviderChangeHandler(event:Event):void
        {
            if (!dataProviderModel)
                return;

            if (dp)
            {
                dp.removeEventListener(mx.events.CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler);
                dp.removeEventListener(HierarchicalCollectionView.ITEMS_ADDED, itemAddedHandler);
                dp.removeEventListener(HierarchicalCollectionView.ITEMS_REMOVED, itemRemovedHandler);
            }

            dp = dataProviderModel.dataProvider as ICollectionView;
            super.dataProviderChangeHandler(event);

            if (dp)
            {
                dp.addEventListener(mx.events.CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler);
                dp.addEventListener(HierarchicalCollectionView.ITEMS_ADDED, itemAddedHandler);
                dp.addEventListener(HierarchicalCollectionView.ITEMS_REMOVED, itemRemovedHandler);
            }
        }

        COMPILE::JS
        private var _rendererMap:Map = new Map();
        COMPILE::SWF
        private var _rendererMap:Dictionary = new Dictionary();


        override protected function setRendererData(ir:IIndexedItemRenderer, data:Object):void{
            var oldData:Object = ir.data;
            if (oldData != null ) {
                if (oldData != data) {
                    COMPILE::SWF{
                        delete _rendererMap[oldData];
                    }
                    COMPILE::JS{
                        _rendererMap.delete(oldData);
                    }
                }
            }
            if (data != null && oldData != data) {
                COMPILE::SWF{
                    _rendererMap[data] = ir;
                }
                COMPILE::JS{
                    _rendererMap.set(data, ir);
                }
            }
            //could call super, but repeating it here should be faster instead:
            ir.data = data;
        }

        private function getRendererForData(data:Object):IIndexedItemRenderer{
            var renderer:IIndexedItemRenderer;
            if (data != null) {
                COMPILE::SWF{
                    renderer = _rendererMap[data] as IIndexedItemRenderer;
                }
                COMPILE::JS{
                    renderer = _rendererMap.get(data) as IIndexedItemRenderer;
                }
            }
            return renderer;
        }

        override protected function createAllItemRenderers(dataGroup:IItemRendererOwnerView):void{
            COMPILE::SWF{
                _rendererMap = new Dictionary()
            }
            COMPILE::JS{
                _rendererMap.clear();
            }
            super.createAllItemRenderers(dataGroup);
            //clean up the cursor instance (strong listeners) (see: dataProviderLength/getItemAt)
            cursor.finalizeThis();
            cursor = null;
        }

        protected function collectionChangeHandler(event:mx.events.CollectionEvent):void
        {
            var item:Object;
            var hcv:HierarchicalCollectionView;
            var items:Array;
            var multi:Boolean;
            var i:uint, l:uint, idx:uint;
            var collated:org.apache.royale.events.CollectionEvent;
            var collation:Array;
            if (event is mx.events.CollectionEvent)
            {
                if (event.kind == mx.events.CollectionEventKind.RESET)
                {
                    // RESET may be from XMLListCollection source = newxmlllist + refresh(), for example.
                    sendBeadEvent(dataProviderModel, "dataProviderChanged");
                }
                else if (event.kind == CollectionEventKind.ADD)
                {
                    hcv = dp as HierarchicalCollectionView;
                    l = event.items.length;
                    multi = l > 1;
                   // item = event.items[0];
                    items = event.items;

                    if (items) {
                        if (multi) {
                            collated = new org.apache.royale.events.CollectionEvent(HierarchicalCollectionView.ITEMS_ADDED);
                            collation = [];
                            collated.item = collation;
                        }
                        idx = event.location; //use this as the base
                        for (i=0;i<l;i++ ) {
                            item = items[i];
                            if (hcv.amIVisible(item)) {
                                // REMOVE may be from HierarchicalCollectionView.xmlNotification
                                // ADD may be from HierarchicalCollectionView.xmlNotification
                                var addEvent:org.apache.royale.events.CollectionEvent
                                        = new org.apache.royale.events.CollectionEvent(org.apache.royale.events.CollectionEvent.ITEM_ADDED);
                                addEvent.item = item;
                                addEvent.index = idx;
                                if (collated) {
                                    collation.push(addEvent);
                                }
                                else itemAddedHandler(addEvent);

                            }
                            idx++; //@todo more thorough check if this approach is ok
                        }
                        if (collated) itemAddedHandler(collated);
                    }
                }
                else if (event.kind == CollectionEventKind.REMOVE)
                {
                    hcv = dp as HierarchicalCollectionView;
                    l = event.items.length;
                    multi = l > 1;
                    items = multi ? event.items.slice() : event.items;
                    if (items) {
                        if (multi) {
                            items.reverse();
                            collated = new org.apache.royale.events.CollectionEvent(HierarchicalCollectionView.ITEMS_REMOVED);
                            collation = [];
                            collated.item = collation;
                        }
                        idx = event.location + l-1; //use this as the base
                        for (i=0;i<l;i++ ) {
                            item = items[i];
                            if (getRendererForData(item)) {
                                // REMOVE may be from HierarchicalCollectionView.xmlNotification
                                var removeEvent:org.apache.royale.events.CollectionEvent
                                        = new org.apache.royale.events.CollectionEvent(org.apache.royale.events.CollectionEvent.ITEM_REMOVED);
                                removeEvent.item = item;
                                removeEvent.index = idx/*multi ? hcv.getItemIndex(item) : event.location*/;
                                if (collated) {
                                    collation.push(removeEvent);
                                }
                                else itemRemovedHandler(removeEvent);
                            }
                            idx--; //@todo more thorough check if this approach is ok
                        }
                        if (collated) itemRemovedHandler(collated);
                    }
                }
                else if (event.kind == CollectionEventKind.UPDATE)
                {
                    var propertyChangeEvents:Array = event.items;
                    var index:int;
                    hcv = dp as HierarchicalCollectionView;
                    for each(var propertyChangeEvent:PropertyChangeEvent in propertyChangeEvents) {
                        var data:Object = propertyChangeEvent.source;

                        if (getRendererForData(data)) {
                            index = hcv.getItemIndex(data);
                            var updateEvent:org.apache.royale.events.CollectionEvent = new org.apache.royale.events.CollectionEvent(org.apache.royale.events.CollectionEvent.ITEM_UPDATED);
                            updateEvent.item = data;
                            updateEvent.index = index;
                            this.itemUpdatedHandler(updateEvent);
                        }
                    }
                }
            }
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



        override protected function itemAddedHandler(event:org.apache.royale.events.CollectionEvent):void
        {
            if (event.type == HierarchicalCollectionView.ITEMS_ADDED) {
                var batch:Array = event.item as Array;
                var last:uint = batch.length-1;
                avoidLayout = true;
                for (var i:uint = 0;i<=last;i++) {
                    event = batch[i];
                    if (i == last) avoidLayout = false; //trigger layout on the last iteration
                    super.itemAddedHandler(event);
                }
            } else {
                super.itemAddedHandler(event)
            }

        }

        override protected function itemRemovedHandler(event:org.apache.royale.events.CollectionEvent):void
        {
            if (event.type == HierarchicalCollectionView.ITEMS_REMOVED) {
                var batch:Array = event.item as Array;
                var last:uint = batch.length-1;
                avoidLayout = true;
                for (var i:uint = 0;i<=last;i++) {
                    event = batch[i];
                    if (i == last) avoidLayout = false; //trigger layout on the last iteration
                    super.itemRemovedHandler(event);
                }
            } else {
                super.itemRemovedHandler(event)
            }
        }
		
	}
}
