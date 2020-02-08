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
	import org.apache.royale.core.IDataProviderItemRendererMapper;
	import org.apache.royale.core.IDataProviderModel;
	import org.apache.royale.core.IIndexedItemRenderer;
	import org.apache.royale.core.IIndexedItemRendererInitializer;
	import org.apache.royale.core.IItemRenderer;
	import org.apache.royale.core.IItemRendererClassFactory;
	import org.apache.royale.core.IItemRendererInitializer;
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
	import org.apache.royale.html.List;
	import org.apache.royale.html.beads.IListView;
	import org.apache.royale.html.supportClasses.DataItemRenderer;
	import org.apache.royale.utils.loadBeadFromValuesManager;
	import org.apache.royale.utils.sendEvent;
	import org.apache.royale.utils.sendStrandEvent;

    /**
     *  The DataItemRendererFactoryBase class is a base class
     *  for IDataProviderItemRendererMapper implementations.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     */
	public class DataItemRendererFactoryBase extends ItemRendererFactoryBase implements IDataProviderItemRendererMapper
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
		public function DataItemRendererFactoryBase(target:Object=null)
		{
			super(target);
		}
		                
        /**
         *  This Factory deletes all renderers, and generates a renderer
         *  for every data provider item.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
		 *  @royaleignorecoercion Array
         *  @royaleignorecoercion org.apache.royale.core.IStrandWithModelView
         *  @royaleignorecoercion org.apache.royale.html.beads.IListView
		 *  @royaleignorecoercion org.apache.royale.core.IListPresentationModel
		 *  @royaleignorecoercion org.apache.royale.core.UIBase
		 *  @royaleignorecoercion org.apache.royale.core.IItemRenderer
		 *  @royaleignorecoercion org.apache.royale.core.IIndexedItemRenderer
		 *  @royaleignorecoercion org.apache.royale.core.IIndexedItemRendererInitializer
		 *  @royaleignorecoercion org.apache.royale.html.supportClasses.DataItemRenderer
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
         */		
		override protected function dataProviderChangeHandler(event:Event):void
		{
			var dp:Object = dataProviderModel.dataProvider;
			if (!dp)
				return;
			            
            var view:IListView = (_strand as IStrandWithModelView).view as IListView;
			var dataGroup:IItemRendererOwnerView = view.dataGroup;
			
            removeAllItemRenderers(dataGroup);
            
			var n:int = dataProviderLength; 
			for (var i:int = 0; i < n; i++)
			{				
				var ir:IItemRenderer = itemRendererFactory.createItemRenderer() as IItemRenderer;
                //var dataItemRenderer:DataItemRenderer = ir as DataItemRenderer;

				dataGroup.addItemRenderer(ir, false);
                var data:Object = getItemAt(i);
                (itemRendererInitializer as IIndexedItemRendererInitializer).initializeIndexedItemRenderer(ir as IIndexedItemRenderer, data, i);
				ir.data = data;				
			}
			
			sendStrandEvent(_strand,"itemsCreated");
		}
        
	}
}
