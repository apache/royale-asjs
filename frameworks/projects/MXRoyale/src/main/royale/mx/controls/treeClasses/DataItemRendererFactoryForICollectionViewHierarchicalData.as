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
            }

            dp = dataProviderModel.dataProvider as ICollectionView;
            super.dataProviderChangeHandler(event);

            if (dp)
            {
                dp.addEventListener(mx.events.CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler);
            }
        }

        protected function collectionChangeHandler(event:mx.events.CollectionEvent):void
        {
            if (event is mx.events.CollectionEvent)
            {
                if (event.kind == mx.events.CollectionEventKind.RESET)
                {
                    // RESET may be from XMLListCollection source = newxmlllist + refresh(), for example.
                    sendBeadEvent(dataProviderModel, "dataProviderChanged");
                }
                else if (event.kind == CollectionEventKind.ADD)
                {
                    // ADD may be from HierarchicalCollectionView.xmlNotification
                    var addEvent:org.apache.royale.events.CollectionEvent 
                        = new org.apache.royale.events.CollectionEvent(org.apache.royale.events.CollectionEvent.ITEM_ADDED);
                    addEvent.item = event.items[0];
                    addEvent.index = event.location;
                    itemAddedHandler(addEvent);
                }
                else if (event.kind == CollectionEventKind.REMOVE)
                {
                    // REMOVE may be from HierarchicalCollectionView.xmlNotification
                    var removeEvent:org.apache.royale.events.CollectionEvent 
                        = new org.apache.royale.events.CollectionEvent(org.apache.royale.events.CollectionEvent.ITEM_REMOVED);
                    removeEvent.item = event.items[0];
                    removeEvent.index = event.location;
                    itemRemovedHandler(removeEvent);
                }
                else if (event.kind == CollectionEventKind.UPDATE)
                {
                    var propertyChangeEvents:Array = event.items;
                    var index:int;
                    for each(var propertyChangeEvent:PropertyChangeEvent in propertyChangeEvents) {
                        var data:Object = propertyChangeEvent.source;
                        index = HierarchicalCollectionView(dp).getItemIndex(data);
                        var updateEvent:org.apache.royale.events.CollectionEvent = new org.apache.royale.events.CollectionEvent(org.apache.royale.events.CollectionEvent.ITEM_UPDATED);
                        updateEvent.item = data;
                        updateEvent.index = index;
                        this.itemUpdatedHandler(updateEvent);
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
		
	}
}
