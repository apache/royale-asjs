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

	import views.LaunchView;

	public class LaunchViewController extends EventDispatcher implements IBeadController
	{
		public function LaunchViewController()
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

			var view:LaunchView = value as LaunchView;
			view.addEventListener("addSymbol", handleAddSymbol);
			view.addEventListener("removeSymbol", handleRemoveSymbol);
			view.addEventListener("symbolSelected", handleGridSelection);
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
			var view:LaunchView = _strand as LaunchView;
			var symbol:String = view.symbolInput.text.toUpperCase();
			var shares:Number = Number(view.sharesInput.text);
			if (isNaN(shares) || shares < 0) shares = 0;

			(model as ProductsModel).addStockToAssetList(symbol, shares);
			(model as ProductsModel).saveDataToStorage();

			subscribe();

			view.symbolInput.text = "";
			view.sharesInput.text = "";
			view.addButton.text = "Add";
		}

		private function handleGridSelection(event:Event):void
		{
			var view:LaunchView = _strand as LaunchView;
			var index:int = view.assetGrid.selectedIndex;
			var data:Object = (model as ProductsModel).assetList.getItemAt(index);
			view.symbolInput.text = data.symbol;
			view.sharesInput.text = String(data.shares);

			view.addButton.text = "Change";
		}

		public function handleRemoveSymbol(event:Event):void
		{
			var view:LaunchView = _strand as LaunchView;
			var index:int = view.assetGrid.selectedIndex;
			if (index < 0) return;

			(model as ProductsModel).removeStockFromAssetListAtIndex(index);

			view.symbolInput.text = "";
			view.sharesInput.text = "";

			view.addButton.text = "Add";
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
			var stockList:ArrayList = (model as ProductsModel).assetList;

			if (stockList.length == 0) return;

			if (index >= stockList.length) index = 0;

			(model as ProductsModel).updateStockData(stockList.getItemAt(index) as Stock);
			index++;

			var newEvent:Event = new Event("update");
			model.dispatchEvent(newEvent);
		}
	}
}
