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
	import org.apache.royale.collections.ICollectionView;
	import org.apache.royale.core.ISelectableItemRenderer;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.jewel.beads.models.IDropDownListModel;
	import org.apache.royale.jewel.itemRenderers.DropDownListItemRenderer;
	import org.apache.royale.jewel.supportClasses.IListPresentationModel;

	/**
	 * This class creates itemRenderer instances from the data contained within an ICollectionView
	 */
	public class DropDownListItemRendererFactoryForCollectionView extends DataItemRendererFactoryForCollectionView
	{
		public function DropDownListItemRendererFactoryForCollectionView(target:Object = null)
		{
			super(target);
		}
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.collections.ICollectionView
		 * @royaleignorecoercion org.apache.royale.jewel.supportClasses.IListPresentationModel
		 * @royaleignorecoercion org.apache.royale.core.ISelectableItemRenderer
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		override protected function dataProviderChangeHandler(event:Event):void
		{
			if (!dataProviderModel)
				return;
			var dp:ICollectionView = dataProviderModel.dataProvider as ICollectionView;
			if (!dp)
				return;
			
			dataGroup.removeAllItemRenderers();
			
			var presentationModel:IListPresentationModel = _strand.getBeadByType(IListPresentationModel) as IListPresentationModel;
			labelField = dataProviderModel.labelField;
			
			var ir:ISelectableItemRenderer;
			var item:Object;
			
			var model:IDropDownListModel = _strand.getBeadByType(IDropDownListModel) as IDropDownListModel;
			var offset:int = model.offset;

			if(offset == 1)
			{
				ir = itemRendererFactory.createItemRenderer(dataGroup) as ISelectableItemRenderer;
				item = DropDownListItemRenderer.OPTION_DISABLED;
				fillRenderer(0, item, ir, presentationModel);
			}

			var n:int = dp.length;
			for (var i:int = 0; i < n; i++)
			{
				ir = itemRendererFactory.createItemRenderer(dataGroup) as ISelectableItemRenderer;
				item = dp.getItemAt(i);
				fillRenderer(i + offset, item, ir, presentationModel);
			}
			
			IEventDispatcher(_strand).dispatchEvent(new Event("itemsCreated"));
		}
	}
}