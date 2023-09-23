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
	COMPILE::SWF
	{
		import flash.events.Event;
		import org.apache.royale.core.UIBase;
	}

	import org.apache.royale.collections.ArrayList;
	import org.apache.royale.collections.ICollectionView;
	import org.apache.royale.core.Bead;
	import org.apache.royale.core.IHasDataProvider;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.debugging.assert;
	
	/**
	 * The SmoothDataLoader class is a bead that can be used with a
	 * List or DataGrid to load data in a smooth way.
	 * 
	 * It is useful when loading large amounts of data, and the UI
	 * needs to be responsive while the data is being loaded.
	 * 
	 * It can be used with any component that implements IHasDataProvider.
	 * 
	 * It requires that the dataProvider is an ICollectionView.
	 * If the strand does not have a dataProvider, it will create
	 * a new ArrayList and set it as the dataProvider.
	 * 
	 * The data is added to the dataProvider in batches, so that the
	 * UI is not blocked while the data is being loaded.
	 * 
	 * The component must have a strand which listens for changes to the dataProvider
	 * and a factory which works with collections.
	 * @see org.apache.royale.html.beads.DataItemRendererFactoryForCollectionView
	 * @see org.apache.royale.html.beads.DataItemRendererFactoryForArrayList
	 * @see org.apache.royale.html.beads.CollectionChangeUpdateForArrayListData
	 * @see org.apache.royale.html.beads.DynamicRemoveAllItemRendererForArrayListData
	 * 
	 * The number of items to be added in each frame can be adjusted
	 * with the batchLength property.
	 * 
	 * The data can be set with the setData() method, or appended
	 * with the appendData() method.
	 * 
	 * The number of items that are pending to be added to the dataProvider
	 * can be obtained with the itemsPending property.
	 * 
	 *  @langversion 3.0
	 *  @productversion Royale 0.9.10
	 * 
	 */
	public class SmoothDataLoader extends Bead
	{
		public function SmoothDataLoader()
		{
			super();
		}

		COMPILE::SWF
		private function getHost():UIBase
		{
			return _strand as UIBase;
		}

		private var _data:Array;

		private var _dataQueued:Boolean;

		private function queueData():void
		{
			if(_dataQueued)
				return;
			if(!_data || !_data.length)
				return;
			
			_dataQueued = true;
			COMPILE::JS
			{
				requestAnimationFrame(appendQueuedData);
			}

			COMPILE::SWF
			{
				getHost().stage.addEventListener(Event.ENTER_FRAME, appendQueuedData);
			}
		}
		override public function set strand(value:IStrand):void
		{
			assert(value is IHasDataProvider, "SmoothDataLoader requires a strand that implements IHasDataProvider");
			_strand = value;
		}

		/**
		 *  @royaleignorecoercion org.apache.royale.core.IHasDataProvider
		 *  @royaleignorecoercion org.apache.royale.collections.ICollectionView
		 */
		private function getProvider():ICollectionView
		{
			var host:IHasDataProvider = _strand as IHasDataProvider;
			var provider:Object = host.dataProvider;
			if(provider == null)
			{
				host.dataProvider = new ArrayList();
				provider = host.dataProvider;
			}
			assert(provider is ICollectionView, "SmoothDataLoader requires a dataProvider that is an ICollectionView");
			return provider as ICollectionView;
		}
		private function appendQueuedData():void
		{
			_dataQueued = false;
			COMPILE::SWF
			{
				getHost().stage.removeEventListener(Event.ENTER_FRAME, appendQueuedData);
			}

			var host:IHasDataProvider = _strand as IHasDataProvider;
			var provider:ICollectionView = getProvider();
			for(var i:int=0;i<_batchLength;i++)
			{
				if(!_data.length)
					break;

				// shift the first item and add it to the provider
				provider.addItem(_data.shift());
			}
			if(_data.length){

				COMPILE::SWF
				{
					getHost().stage.addEventListener(Event.ENTER_FRAME, appendQueuedData);
				}

				COMPILE::JS
				{
					requestAnimationFrame(appendQueuedData);
				}

			}

		}

		private var _batchLength:int = 20;

		/**
		 * The number of data items to be added in each frame.
		 * The default is 20.
		 * 
		 * Depending on the complexity of the item renderers,
		 * the number can be adjusted to optimize speed and responsiveness.
		 */
		public function get batchLength():int
		{
			return _batchLength;
		}

		public function set batchLength(value:int):void
		{
			if(value <= 0)
				return;
			_batchLength = value;
		}

		/**
		 * Sets the dataProvider to the data of specified array.
		 */
		public function setData(data:Array):void
		{
			var provider:ICollectionView = getProvider();
			provider.removeAll();
			_data = data;
			queueData();
		}

		/**
		 * Appends data to the end of the dataProvider.
		 */
		public function appendData(data:Array):void
		{
			if(!_data)
				_data = [];
			_data = _data.concat(data);
			queueData();
		}

		/**
		 * The number of items that are pending to be added to the dataProvider.
		 */
		public function get itemsPending():int
		{
			return _data ? _data.length : 0;
		}

	}
}