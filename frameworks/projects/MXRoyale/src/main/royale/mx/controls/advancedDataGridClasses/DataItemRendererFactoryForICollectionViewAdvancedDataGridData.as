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
	import mx.collections.ICollectionView;
	import mx.collections.IViewCursor;

	import org.apache.royale.core.IItemRendererOwnerView;
	import org.apache.royale.core.IStrandWithModelView;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.beads.IListView;
	import org.apache.royale.html.beads.VirtualDataItemRendererFactoryBase;
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
            var dp:ICollectionView = dataProviderModel.dataProvider as ICollectionView;
            if (!dp)
                return;

            if (cursor) cursor.finalizeThis();
            cursor = dp.createCursor();
            currentIndex = (dp.length > 0) ? 0 : -1;
            
            // listen for individual items being added in the future.
            //var dped:IEventDispatcher = dp as IEventDispatcher;
            //dped.addEventListener(CollectionEvent.ITEM_ADDED, itemAddedHandler);
            //dped.addEventListener(CollectionEvent.ITEM_REMOVED, itemRemovedHandler);
            //dped.addEventListener(CollectionEvent.ITEM_UPDATED, itemUpdatedHandler);

			sendStrandEvent(_strand, "itemsCreated");
			super.dataProviderChangeHandler(event);
        }

        private var cursor:IViewCursor;
        private var currentIndex:int;
		
        
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
	}
}
