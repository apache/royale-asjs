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
    import org.apache.royale.core.IFactory;
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
    import org.apache.royale.html.beads.ItemRendererFunctionBead;
    import org.apache.royale.core.IIndexedItemRendererInitializer;
	
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
            resetOnRemove = true;
		}
        
        /**
         * @private
         */
        override protected function dataProviderChangeHandler(event:Event):void
        {
            if (!dataProviderModel)
                return;
            var dpTest:IList = dataProviderModel.dataProvider as IList;
            if (!dpTest)
            {
                // temporary until descriptor is used in MenuBarModel
                var obj:Object = dataProviderModel.dataProvider;
                if (obj is Array)
                {
                    dataProviderModel.dataProvider = new ArrayList(obj as Array);
                }
                else
                    return;
            }

            super.dataProviderChangeHandler(event);
        }
        
	override protected function createAllItemRenderers(dataGroup:IItemRendererOwnerView):void
	{
		var functionBead:ItemRendererFunctionBead = _strand.getBeadByType(ItemRendererFunctionBead) as ItemRendererFunctionBead;
		var rendererFunction:Function = functionBead ? functionBead.itemRendererFunction : null;
		var n:int = dataProviderLength; 
		for (var i:int = 0; i < n; i++)
		{				
			var data:Object = getItemAt(i);
			var ir:IIndexedItemRenderer = rendererFunction ? (rendererFunction(data) as IFactory).newInstance() as IIndexedItemRenderer :
				itemRendererFactory.createItemRenderer() as IIndexedItemRenderer;

			dataGroup.addItemRenderer(ir, false);
			(itemRendererInitializer as IIndexedItemRendererInitializer).initializeIndexedItemRenderer(ir, data, i);
			ir.data = data;				
		}
	}
		
	}
}
