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
	import org.apache.royale.core.IDataProviderModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.CollectionEvent;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.utils.sendBeadEvent;
	import org.apache.royale.core.Bead;


    /**
	 *  Handles the update of an itemRenderer in a List component once the corresponding
	 *  datum has been updated from the IDataProviderModel.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class CollectionChangeUpdateForArrayListData extends Bead
	{
		/**
		 *  Constructor
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function CollectionChangeUpdateForArrayListData()
		{
		}

		protected var labelField:String;

		/**
		 *  @copy org.apache.royale.core.IStrand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			listenOnStrand("initComplete", initComplete);
		}

		/**
		 *  finish setup
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 *  @royaleignorecoercion org.apache.royale.core.IDataProviderModel
		 */
		protected function initComplete(event:Event):void
		{
			IEventDispatcher(_strand).removeEventListener("initComplete", initComplete);

			_dataProviderModel = _strand.getBeadByType(IDataProviderModel) as IDataProviderModel;
			labelField = _dataProviderModel.labelField;

			dataProviderModel.addEventListener("dataProviderChanged", dataProviderChangeHandler);

			// invoke now in case "dataProviderChanged" has already been dispatched.
			dataProviderChangeHandler(null);
		}

		private var dp:IEventDispatcher;
		private var ignoreDPChange:Boolean;
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		protected function dataProviderChangeHandler(event:Event):void
		{
			if (ignoreDPChange) return;
			if(dp)
			{
				dp.removeEventListener(CollectionEvent.COLLECTION_CHANGED, handleCollectionChanged);
			}
			dp = dataProviderModel.dataProvider as IEventDispatcher;
			if (!dp)
				return;

			// listen for COLLECTION_CHANGED in the future.
			dp.addEventListener(CollectionEvent.COLLECTION_CHANGED, handleCollectionChanged);
		}

		/**
		 *  Handles the COLLECTION_CHANGED event by refreshing the full set of renderers.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
         *  @royaleignorecoercion org.apache.royale.core.ISelectionModel
		 */
		protected function handleCollectionChanged(event:CollectionEvent):void
		{
			ignoreDPChange = true;
			//simulate a dataProvider change (full renderer refresh)
			sendBeadEvent(_dataProviderModel,"dataProviderChanged");
			ignoreDPChange = false;
		}

		private var _dataProviderModel:IDataProviderModel;

		/**
		 *  The org.apache.royale.core.IDataProviderModel that contains the
		 *  data source.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.core.IDataProviderModel
		 */
		public function get dataProviderModel():IDataProviderModel
		{
			if (_dataProviderModel == null) {
				_dataProviderModel = _strand.getBeadByType(IDataProviderModel) as IDataProviderModel;
			}
			return _dataProviderModel;
		}
		
	}
}
