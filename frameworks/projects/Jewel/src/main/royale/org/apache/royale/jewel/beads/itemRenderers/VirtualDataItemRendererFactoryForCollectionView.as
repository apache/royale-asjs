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
package org.apache.royale.jewel.beads.itemRenderers
{
	import org.apache.royale.collections.ArrayList;
	import org.apache.royale.core.IIndexedItemRenderer;
	import org.apache.royale.core.ISelectableItemRenderer;
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.events.Event;
	import org.apache.royale.html.beads.VirtualDataItemRendererFactoryBase;
	import org.apache.royale.utils.getSelectionRenderBead;
	import org.apache.royale.utils.sendStrandEvent;

	[Event(name="itemRendererCreated",type="org.apache.royale.events.ItemRendererEvent")]
	
	/**
	 *  The VirtualDataItemRendererFactoryForCollectionView class reads an
	 *  array of data and creates an item renderer for every
	 *  item in the array.  Other implementations of
	 *  IDataProviderItemRendererMapper map different data 
	 *  structures or manage a virtual set of renderers.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.7
	 */
	public class VirtualDataItemRendererFactoryForCollectionView extends VirtualDataItemRendererFactoryBase
	{
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function VirtualDataItemRendererFactoryForCollectionView(target:Object=null)
		{
			super(target);
		}

		private var dp:ArrayList;
		
		/**
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 *  @royaleignorecoercion org.apache.royale.core.IStrandWithModelView
		 *  @royaleignorecoercion org.apache.royale.html.beads.IListView
		 */		
		override protected function dataProviderChangeHandler(event:Event):void
		{
			if (!dataProviderModel)
				return;
			dp = dataProviderModel.dataProvider as ArrayList;
			if (!dp)
				return;
			
			super.dataProviderChangeHandler(event);

			sendStrandEvent(_strand, "layoutNeeded");
		}
		
		/**
		 *  Get an item renderer for a given index.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 *  @royaleignorecoercion org.apache.royale.core.IStrandWithModelView
		 *  @royaleignorecoercion org.apache.royale.html.beads.IListView
		 */
		override public function getItemRendererForIndex(index:int, elementIndex:int):IIndexedItemRenderer
		{
			var ir:IIndexedItemRenderer = rendererMap[index];
			if (ir) return ir;
			
			ir = super.getItemRendererForIndex(index, elementIndex);
						
			// if the item was already selected make the item show it
			if(index == (dataProviderModel as ISelectionModel).selectedIndex)
			{
				var selectionBead:ISelectableItemRenderer;
				selectionBead = getSelectionRenderBead(ir);
				if (selectionBead)
					selectionBead.selected = false;
			}
				
			return ir;
		}
		
		override public function getItemAt(index:int):Object
		{
			return dp.getItemAt(index);
		}

	}
}
