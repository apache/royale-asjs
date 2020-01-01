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
	import org.apache.royale.core.IBeadView;
	import org.apache.royale.core.IDataGridModel;
	import org.apache.royale.core.IDataProviderItemRendererMapper;
	import org.apache.royale.core.IItemRendererClassFactory;
	import org.apache.royale.core.IItemRendererParent;
	import org.apache.royale.core.IList;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.supportClasses.DataItemRenderer;
	import org.apache.royale.utils.loadBeadFromValuesManager;
	import org.apache.royale.core.Bead;
	import org.apache.royale.utils.sendStrandEvent;
	
	/**
	 *  The DataItemRendererFactoryForColumnData class implents the 
	 *  org.apache.royale.core.IDataProviderItemRendererMapper interface and creates the itemRenderers 
	 *  for each cell in the org.apache.royale.html.DataGrid.  
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class DataItemRendererFactoryForColumnData extends Bead implements IDataProviderItemRendererMapper
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function DataItemRendererFactoryForColumnData()
		{
		}
		
		private var selectionModel:IDataGridModel;
				
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			listenOnStrand("initComplete",finishSetup);
		}
		
		/**
		 * @private
     * @royaleignorecoercion org.apache.royale.core.IItemRendererClassFactory
		 */
		private function finishSetup(event:Event):void
		{			
			selectionModel = _strand.getBeadByType(IDataGridModel) as IDataGridModel;
			selectionModel.addEventListener("dataProviderChanged", dataProviderChangeHandler);
			
			// if the host component inherits from DataContainerBase, the itemRendererClassFactory will 
			// already have been loaded by DataContainerBase.addedToParent function.
			if(!_itemRendererFactory)
    			_itemRendererFactory = loadBeadFromValuesManager(IItemRendererClassFactory, "iItemRendererClassFactory", _strand) as IItemRendererClassFactory;
			
			dataProviderChangeHandler(null);
		}
		
		private var _itemRendererFactory:IItemRendererClassFactory;
		
		/**
		 *  The factory used to create the itemRenderers.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
     * @royaleignorecoercion org.apache.royale.core.IItemRendererClassFactory
		 */
		public function get itemRendererFactory():IItemRendererClassFactory
		{
			if(!_itemRendererFactory)
    			_itemRendererFactory = loadBeadFromValuesManager(IItemRendererClassFactory, "iItemRendererClassFactory", _strand) as IItemRendererClassFactory;
			
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
		 *  @productversion Royale 0.0
		 */
//		protected var dataGroup:IItemRendererParent;
		
		/**
		 * @private
         * @royaleignorecoercion org.apache.royale.html.beads.DataGridColumnView
         * @royaleignorecoercion org.apache.royale.html.supportClasses.DataItemRenderer
		 */
		private function dataProviderChangeHandler(event:Event):void
		{
			var dp:Array = selectionModel.dataProvider as Array;
			if (!dp)
				return;
			
			var view:DataGridColumnView = _strand.getBeadByType(IBeadView) as DataGridColumnView;
			if (view == null) return;

			var dataGroup:IItemRendererParent = view.dataGroup;
			dataGroup.removeAllItemRenderers();

			var n:int = dp.length; 
			for (var i:int = 0; i < n; i++)
			{
				var tf:DataItemRenderer = itemRendererFactory.createItemRenderer(dataGroup) as DataItemRenderer;
				dataGroup.addItemRenderer(tf, false);
				tf.index = i;
				tf.labelField = view.column.dataField;
				tf.data = dp[i];
			}
			
			sendStrandEvent(_strand,"itemsCreated");
		}
	}
}
