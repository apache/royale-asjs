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
package org.apache.flex.html.staticControls.beads
{
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IItemRenderer;
	import org.apache.flex.core.IItemRendererClassFactory;
	import org.apache.flex.core.IItemRendererParent;
	import org.apache.flex.core.ISelectionModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	
	public class DataItemRendererFactoryForArrayData implements IBead, IDataProviderItemRendererMapper
	{
		public function DataItemRendererFactoryForArrayData()
		{
		}
		
		private var selectionModel:ISelectionModel;
		
		private var _strand:IStrand;
		
		public function set strand(value:IStrand):void
		{
			_strand = value;
			selectionModel = value.getBeadByType(ISelectionModel) as ISelectionModel;
			var listView:IListView = value.getBeadByType(IListView) as IListView;
			dataGroup = listView.dataGroup;
			selectionModel.addEventListener("dataProviderChanged", dataProviderChangeHandler);
			
			if (!itemRendererFactory)
			{
				_itemRendererFactory = new (ValuesManager.valuesImpl.getValue(_strand, "iItemRendererClassFactory")) as IItemRendererClassFactory;
				_strand.addBead(_itemRendererFactory);
			}
			
			dataProviderChangeHandler(null);
		}
		
		public var _itemRendererFactory:IItemRendererClassFactory;
		
		public function get itemRendererFactory():IItemRendererClassFactory
		{
			return _itemRendererFactory
		}
		
		public function set itemRendererFactory(value:IItemRendererClassFactory):void
		{
			_itemRendererFactory = value;
		}
		
		protected var dataGroup:IItemRendererParent;
		
		private function dataProviderChangeHandler(event:Event):void
		{
			var dp:Array = selectionModel.dataProvider as Array;
			if (!dp)
				return;
			
			dataGroup.removeAllElements();
			
			var n:int = dp.length; 
			for (var i:int = 0; i < n; i++)
			{
				var ir:IItemRenderer = itemRendererFactory.createItemRenderer(dataGroup) as IItemRenderer;
				ir.index = i;
				dataGroup.addElement(ir);
				ir.data = dp[i];
			}
			
			IEventDispatcher(_strand).dispatchEvent(new Event("itemsCreated"));
		}
	}
}