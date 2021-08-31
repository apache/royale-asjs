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
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.events.CollectionEvent;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
 
	
	/**
	 * This class is an extension of DataItemRendererFactoryForCollectionView for components using ISelectionModel
	 * that will need special handling of selected index for items added, removed or updated at runtime from the dataprovider.
	 */
	public class SelectionDataItemRendererFactoryForCollectionView extends DataItemRendererFactoryForCollectionView
	{
		public function SelectionDataItemRendererFactoryForCollectionView(target:Object = null)
		{
			super(target);
		}
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.core.ISelectionModel
		 */
		override protected function itemAddedHandler(event:CollectionEvent):void
		{
			super.itemAddedHandler(event);

			//adjust the model's selectedIndex, if applicable
			if(dataProviderModel is ISelectionModel) {
				if (event.index <= ISelectionModel(dataProviderModel).selectedIndex) {
					ISelectionModel(dataProviderModel).selectedIndex = ISelectionModel(dataProviderModel).selectedIndex + 1;
				}
			}
		}
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.core.ISelectionModel
		 */
		override protected function itemRemovedHandler(event:CollectionEvent):void
		{
			super.itemRemovedHandler(event);

			//adjust the model's selectedIndex, if applicable
			if(dataProviderModel is ISelectionModel) {
				if (event.index < ISelectionModel(dataProviderModel).selectedIndex)
				{
					ISelectionModel(dataProviderModel).selectedIndex = ISelectionModel(dataProviderModel).selectedIndex - 1;
				} 
				else if (event.index == ISelectionModel(dataProviderModel).selectedIndex)
				{
					ISelectionModel(dataProviderModel).selectedIndex = -1;
				}
			}
		}
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.core.ISelectionModel
		 */
		override protected function itemUpdatedHandler(event:CollectionEvent):void
		{
			super.itemUpdatedHandler(event);

			if(dataProviderModel is ISelectionModel) {
				if (event.index == ISelectionModel(dataProviderModel).selectedIndex) {
					//manually trigger a selection change, even if there was actually none.
					//This causes selection-based bindings to work
					IEventDispatcher(dataProviderModel).dispatchEvent(new Event('selectedIndexChanged'));
				}
			}
		}
	}
}