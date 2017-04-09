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
package org.apache.flex.html.beads
{
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IDataGridModel;
	import org.apache.flex.core.IDataProviderItemRendererMapper;
	import org.apache.flex.core.IItemRendererClassFactory;
	import org.apache.flex.core.IItemRendererParent;
	import org.apache.flex.core.IList;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.supportClasses.DataItemRenderer;
	
	/**
	 *  The DataItemRendererFactoryForColumnData class implents the 
	 *  org.apache.flex.core.IDataProviderItemRendererMapper interface and creates the itemRenderers 
	 *  for each cell in the org.apache.flex.html.DataGrid.  
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class DataItemRendererFactoryForColumnData implements IBead, IDataProviderItemRendererMapper
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function DataItemRendererFactoryForColumnData()
		{
		}
		
		private var selectionModel:IDataGridModel;
		
		private var _strand:IStrand;
		
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			IEventDispatcher(value).addEventListener("initComplete",finishSetup);
		}
		
		/**
		 * @private
		 */
		private function finishSetup(event:Event):void
		{			
			selectionModel = _strand.getBeadByType(IDataGridModel) as IDataGridModel;
			selectionModel.addEventListener("dataProviderChanged", dataProviderChangeHandler);
			
			// if the host component inherits from DataContainerBase, the itemRendererClassFactory will 
			// already have been loaded by DataContainerBase.addedToParent function.
			_itemRendererFactory = _strand.getBeadByType(IItemRendererClassFactory) as IItemRendererClassFactory;
			if (itemRendererFactory == null) {
				_itemRendererFactory = new (ValuesManager.valuesImpl.getValue(_strand, "iItemRendererClassFactory")) as IItemRendererClassFactory;
				_strand.addBead(_itemRendererFactory);
			}
			
			dataProviderChangeHandler(null);
		}
		
		private var _itemRendererFactory:IItemRendererClassFactory;
		
		/**
		 *  The factory used to create the itemRenderers.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get itemRendererFactory():IItemRendererClassFactory
		{
			return _itemRendererFactory
		}
		public function set itemRendererFactory(value:IItemRendererClassFactory):void
		{
			_itemRendererFactory = value;
		}
		
		/**
		 *  The dataGroup that is the pareent for the itemRenderers
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
//		protected var dataGroup:IItemRendererParent;
		
		/**
		 * @private
		 */
		private function dataProviderChangeHandler(event:Event):void
		{
			var dp:Array = selectionModel.dataProvider as Array;
			if (!dp)
				return;
			
			var list:IList = _strand as IList;
			var dataGroup:IItemRendererParent = list.dataGroup;
			
			dataGroup.removeAllItemRenderers();
						
			var view:DataGridColumnView = _strand.getBeadByType(IBeadView) as DataGridColumnView;
			if (view == null) return;
						
			var n:int = dp.length; 
			for (var i:int = 0; i < n; i++)
			{
				var tf:DataItemRenderer = itemRendererFactory.createItemRenderer(dataGroup) as DataItemRenderer;
				dataGroup.addItemRenderer(tf);
				tf.index = i;
				tf.labelField = view.column.dataField;
				tf.data = dp[i];
			}
			
			IEventDispatcher(_strand).dispatchEvent(new Event("itemsCreated"));
		}
	}
}
