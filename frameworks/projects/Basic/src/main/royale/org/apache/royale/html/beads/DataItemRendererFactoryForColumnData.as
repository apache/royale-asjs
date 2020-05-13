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
	import org.apache.royale.core.IItemRendererOwnerView;
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
	public class DataItemRendererFactoryForColumnData extends DataItemRendererFactoryBase
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
		 * @private
         * @royaleignorecoercion org.apache.royale.html.beads.DataGridColumnView
         * @royaleignorecoercion org.apache.royale.html.supportClasses.DataItemRenderer
		 */
		override protected function dataProviderChangeHandler(event:Event):void
		{
			var dp:Array = selectionModel.dataProvider as Array;
			if (!dp)
				return;
			
			var view:DataGridColumnView = _strand.getBeadByType(IBeadView) as DataGridColumnView;
			if (view == null) return;

            super.dataProviderChangeHandler(event);
		}
	}
}
