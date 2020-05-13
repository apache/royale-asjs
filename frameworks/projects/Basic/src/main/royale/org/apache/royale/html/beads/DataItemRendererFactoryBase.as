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
	import org.apache.royale.core.IDataProviderItemRendererMapper;
	import org.apache.royale.core.IIndexedItemRenderer;
	import org.apache.royale.core.IIndexedItemRendererInitializer;
	import org.apache.royale.core.IItemRendererOwnerView;
	import org.apache.royale.core.IStrandWithModelView;
	import org.apache.royale.events.Event;
	import org.apache.royale.html.beads.IListView;
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
		 * the dataProvider
		 */
		protected var dp:Object;
						
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
		 *  @royaleignorecoercion org.apache.royale.core.IIndexedItemRenderer
		 *  @royaleignorecoercion org.apache.royale.core.IIndexedItemRendererInitializer
		 */		
		override protected function dataProviderChangeHandler(event:Event):void
		{			
			var view:IListView = (_strand as IStrandWithModelView).view as IListView;
			var dataGroup:IItemRendererOwnerView = view.dataGroup;
			
			removeAllItemRenderers(dataGroup);
			
			dp = dataProviderModel.dataProvider;
			if (!dp)
				return;
			
			var n:int = dataProviderLength; 
			for (var i:int = 0; i < n; i++)
			{				
				var ir:IIndexedItemRenderer = itemRendererFactory.createItemRenderer() as IIndexedItemRenderer;

				dataGroup.addItemRenderer(ir, false);
				var data:Object = getItemAt(i);
				(itemRendererInitializer as IIndexedItemRendererInitializer).initializeIndexedItemRenderer(ir, data, i);
				ir.data = data;				
			}
			
			dispatchItemCreatedEvent();
		}

		protected function dispatchItemCreatedEvent():void
		{
			sendStrandEvent(_strand,"itemsCreated");
		}

	}
}
