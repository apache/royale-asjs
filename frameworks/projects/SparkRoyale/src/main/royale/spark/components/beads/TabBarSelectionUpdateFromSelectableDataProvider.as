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
package spark.components.beads
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IDataProviderModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IViewport;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import mx.core.ISelectableList;
	import spark.components.TabBar;


    /**
	 *  Updates TabBar.selectedIndex when the selectable dataProvider (i.e. ViewStack)
	 *  has a selectedIndex change.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.8
	 */
	public class TabBarSelectionUpdateFromSelectableDataProvider implements IBead
	{
		/**
		 *  Constructor
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 */
		public function TabBarSelectionUpdateFromSelectableDataProvider()
		{
		}

		protected var _strand:IStrand;

		/**
		 *  @copy org.apache.royale.core.IStrand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			IEventDispatcher(value).addEventListener("initComplete", initComplete);
		}

		/**
		 *  finish setup
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 *  @royaleignorecoercion org.apache.royale.core.IDataProviderModel
		 */
		protected function initComplete(event:Event):void
		{
			IEventDispatcher(_strand).removeEventListener("initComplete", initComplete);

			var contentView:IStrand = (_strand.getBeadByType(IViewport) as IViewport).contentView as IStrand;
			_dataProviderModel = contentView.getBeadByType(IDataProviderModel) as IDataProviderModel;

			dataProviderModel.addEventListener("dataProviderChanged", dataProviderChangeHandler);

			// invoke now in case "dataProviderChanged" has already been dispatched.
			dataProviderChangeHandler(null);
		}

		private var dp:ISelectableList;

		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		protected function dataProviderChangeHandler(event:Event):void
		{
			if (dp)
			{
				dp.removeEventListener("change", handleIndexChange);
				dp.removeEventListener("valueCommit", handleIndexChange);
			}

			dp = dataProviderModel.dataProvider as ISelectableList;
			if (!dp) return;

			dp.addEventListener("change", handleIndexChange);
			dp.addEventListener("valueCommit", handleIndexChange);
			
			handleIndexChange(null);
		}

		/**
		 *  Handles the selectedIndex change event.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		protected function handleIndexChange(event:Event):void
		{
			var tb:TabBar = _strand as TabBar;
			var newSelectedIndex:int = dp.selectedIndex;
			if (tb.selectedIndex != newSelectedIndex)
			{
				tb.selectedIndex = newSelectedIndex;
			}
		}

		private var _dataProviderModel:IDataProviderModel;

		/**
		 *  The org.apache.royale.core.IDataProviderModel that contains the
		 *  data source.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 *  @royaleignorecoercion org.apache.royale.core.IDataProviderModel
		 */
		public function get dataProviderModel():IDataProviderModel
		{
			if (!_dataProviderModel)
			{
				var contentView:IStrand = (_strand.getBeadByType(IViewport) as IViewport).contentView as IStrand;
				_dataProviderModel = contentView.getBeadByType(IDataProviderModel) as IDataProviderModel;
			}
			return _dataProviderModel;
		}
		
	}
}
