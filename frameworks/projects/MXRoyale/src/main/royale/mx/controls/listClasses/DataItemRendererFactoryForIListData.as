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
    import mx.collections.ArrayList;
    import mx.collections.IList;
    
    import org.apache.royale.core.IBead;
    import org.apache.royale.core.IBeadModel;
    import org.apache.royale.core.IDataProviderItemRendererMapper;
    import org.apache.royale.core.IDataProviderModel;
    import org.apache.royale.core.IItemRendererClassFactory;
    import org.apache.royale.core.IItemRendererOwnerView;
    import org.apache.royale.core.IListPresentationModel;
    import org.apache.royale.core.IIndexedItemRenderer;
    import org.apache.royale.core.IStrand;
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
	public class DataItemRendererFactoryForIListData extends DataItemRendererFactoryForCollectionView
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function DataItemRendererFactoryForIListData()
		{
			super();
		}
        
        private var dp:IList;
        
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
            dp = dataProviderModel.dataProvider as IList;
            if (!dp)
            {
                // temporary until descriptor is used in MenuBarModel
                var obj:Object = dataProviderModel.dataProvider;
                if (obj is Array)
                {
                    dp = new ArrayList(obj as Array);
                }
                else
                    return;
            }
            
            // listen for individual items being added in the future.
            var dped:IEventDispatcher = dp as IEventDispatcher;
            dped.addEventListener(CollectionEvent.ITEM_ADDED, itemAddedHandler);
            dped.addEventListener(CollectionEvent.ITEM_REMOVED, itemRemovedHandler);
            dped.addEventListener(CollectionEvent.ITEM_UPDATED, itemUpdatedHandler);
            
            super.dataProviderChangeHandler(event);
            
        }
        
        override protected function get dataProviderLength():int
        {
            return dp.length;
        }
        
        override protected function getItemAt(index:int):Object
        {
            return dp.getItemAt(index);
        }
		
	}
}
