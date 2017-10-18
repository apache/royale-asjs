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
package controller
{
	import models.ProductsModel;
	import models.Stock;

	import org.apache.royale.core.IBeadController;
	import org.apache.royale.core.IBeadModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.utils.Timer;
	import org.apache.royale.collections.ArrayList;

	import views.StockView;
	import views.WatchListView;

	public class WatchListController extends EventDispatcher implements IBeadController
	{
		public function WatchListController()
		{
			super();

			timer = new Timer(updateInterval, 0);
			timer.addEventListener("timer", timerHandler);
		}

		public var updateInterval:Number = 5000;

		protected var timer:Timer;

		private var index:Number = 0;
		private var selectedStock:Stock;
		private var _strand:IStrand;

		public function set strand(value:IStrand):void
		{
			_strand = value;

			var view:WatchListView = value as WatchListView;
			view.addEventListener("addSymbol", handleAddSymbol);
			view.addEventListener("stockSelected", handleGridSelection);
		}

		private var _model:IBeadModel;
		public function set model(value:IBeadModel):void
		{
			_model = value;
		}
		public function get model():IBeadModel
		{
			return _model;
		}

		private function handleAddSymbol(event:Event):void
		{
			var view:WatchListView = _strand as WatchListView;
			var symbol:String = view.symbolName.text.toUpperCase();

			view.symbolName.text = "";

			(model as ProductsModel).addStockToWatchList(symbol);
			(model as ProductsModel).saveDataToStorage();

			subscribe();
		}

		private function handleGridSelection(event:Event):void
		{
			var view:WatchListView = _strand as WatchListView;
			selectedStock = (model as ProductsModel).watchList.getItemAt(view.selectedStockIndex) as Stock;
			trace("Selected stock "+selectedStock.symbol);

			var stockView:StockView = view.showStockDetails(selectedStock);
			stockView.addEventListener("removeFromList", handleRemoveFromList);
		}

		public function handleRemoveFromList(event:Event):void
		{
			(model as ProductsModel).removeStockFromWatchList(selectedStock);

			var view:WatchListView = _strand as WatchListView;
			view.popView();
		}

		public function subscribe():void
		{
			if (!timer.running)
			{
				timer.start();
			}
		}

		public function unsubscribe():void
		{
			if (timer.running)
			{
				timer.stop();
			}
		}

		/**
		 * Each time the handler goes off a different stock in the list
		 * is updated. This keeps the app from sending too many requests
		 * all at once.
		 */
		protected function timerHandler(event:*):void
		{
			var stockList:ArrayList = (model as ProductsModel).watchList;

			if (stockList.length == 0) return;

			if (index >= stockList.length) index = 0;

			(model as ProductsModel).updateStockData(stockList.getItemAt(index) as Stock);
			index++;

			var newEvent:Event = new Event("update");
			model.dispatchEvent(newEvent);
		}
	}
}
