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
package models
{
	import org.apache.royale.core.IBeadModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.net.HTTPService;
	import org.apache.royale.collections.parsers.JSONInputParser;
	import org.apache.royale.collections.LazyCollection;
	import org.apache.royale.collections.ArrayList;

	import org.apache.royale.storage.PermanentStorage;
	import org.apache.royale.storage.events.FileEvent;
	import org.apache.royale.storage.events.FileErrorEvent;

	public class ProductsModel extends EventDispatcher implements IBeadModel
	{
		public function ProductsModel()
		{
			super();

			service = new HTTPService();
			collection = new LazyCollection;
			collection.inputParser = new JSONInputParser();
			collection.itemConverter = new StockDataJSONItemConverter();

			_watchList = new ArrayList();
			_assetList = new ArrayList();
		}

		public function loadDataFromStorage():void
		{
			var storage:PermanentStorage = new PermanentStorage();
			var useFile:String = "com.apache.royale.MobileStocks2";

			storage.addEventListener("READ", handleRead);
			storage.addEventListener("ERROR", handleReadError);
			storage.readTextFromDataFile(useFile);
		}

		private function handleRead(event:FileEvent):void
		{
		    trace(event.data);
		    var result:XML = new XML(event.data);
		    trace("XML parsing:");
		    trace(result);

		    var assetItems:XMLList = result..asset;
		    trace("Got "+assetItems.length()+" assets");
		    for each (var asset:XML in assetItems) {
		        trace("symbol = " + asset.@symbol + ", shares = " + asset.@shares);
		        addStockToAssetList(asset.@symbol, Number(asset.@shares));
		    }

		    var watchItems:XMLList = result..watch;
		    trace("Got "+watchItems.length()+" watches");
		    for each (var watch:XML in watchItems) {
		        trace("symbol = "+watch.@symbol);
		        addStockToWatchList(watch.@symbol);
		    }
		}

		private function handleReadError(event:FileErrorEvent):void
		{
			trace("Read error: "+event.errorMessage);
		}

		public function saveDataToStorage():void
		{
			var storage:PermanentStorage = new PermanentStorage();
			var useFile:String = "com.apache.royale.MobileStocks2";
			var assets:String = "";

			for (var i:int=0; i < _assetList.length; i++) {
				var stock:Stock = _assetList.getItemAt(i) as Stock;
				assets = assets + '<asset symbol="'+stock.symbol+'" shares="'+stock.shares+'" />';
			}

			var watches:String = "";
			for (i=0; i < _watchList.length; i++) {
			    stock = _watchList.getItemAt(i) as Stock;
			    watches = watches + '<watch symbol="'+stock.symbol+'" />';
			}

			var output:String = "<data><assets>"+assets+"</assets><watches>"+watches+"</watches></data>";

			trace("Writing: "+output);

			storage.addEventListener("WRITE", handleSave);
			storage.addEventListener("ERROR", handleSaveError);
			storage.writeTextToDataFile(useFile, output);
		}

		private function handleSave(event:FileEvent):void
		{
			trace("Save completed");
		}

		private function handleSaveError(event:FileErrorEvent):void
		{
			trace("Write error: "+event.errorMessage);
		}

		private var service:HTTPService;
		private var collection:LazyCollection;

		private var queryBegin:String = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22";
        private var queryEnd:String = "%22)%0A%09%09&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&format=json";

		private var _strand:IStrand;
		public function set strand(value:IStrand):void
		{
			_strand = value;

			service.addBead(collection);
			_strand.addBead(service);
		}

		private var _tabList:Array = ["Assets", "Watch", "Alerts"];
		public function get tabList():Array
		{
			return _tabList;
		}

		private var _labelFields:Array = [ "id", "title", "detail" ];
		public function get labelFields():Array
		{
			return _labelFields;
		}

		private var _watchList:ArrayList;

		public function get watchList():ArrayList
		{
			return _watchList;
		}

		private var _assetList:ArrayList;

		public function get assetList():ArrayList
		{
			return _assetList;
		}

		public function addStockToAssetList(symbol:String, shares:Number):Stock
		{
			for (var i:int=0; i < _assetList.length; i++)
			{
				var stock:Stock = _assetList.getItemAt(i) as Stock;
				if (stock.symbol == symbol) {
					stock.shares = shares;
					_assetList.itemUpdatedAt(i);
					return stock;
				}
			}

			stock = new Stock(symbol);
			stock.shares = shares;

			_assetList.addItem(stock);
			updateStockData(stock);

			return stock;
		}

		public function addStockToWatchList(symbol:String):Stock
		{
			for (var i:int=0; i < _watchList.length; i++)
			{
				var stock:Stock = _watchList.getItemAt(i) as Stock;
				if (stock.symbol == symbol) {
					_watchList.itemUpdatedAt(i);
					return stock;
				}
			}

			stock = new Stock(symbol);
			_watchList.addItem(stock);
			updateStockData(stock);
			return stock;
		}

		public function removeStockFromWatchList(stock:Stock):void
		{
			for (var i:int=0; i < _watchList.length; i++)
			{
				var s:Stock = _watchList.getItemAt(i) as Stock;
				if (stock.symbol == s.symbol) {
					_watchList.removeItemAt(i);
					break;
				}
			}

			dispatchEvent(new Event("update"));
		}

		public function removeStockFromAssetListAtIndex(index:int):void
		{
			if (index >= 0 && index < _assetList.length) {
				_assetList.removeItemAt(index);
				dispatchEvent(new Event("update"));
			}
		}

		// UPDATE STOCK INFORMATION FROM REMOTE SYSTEM

		public function updateStockData(value:Stock):void
		{
			var sym:String = value.symbol;
			service.url = queryBegin + sym + queryEnd;
			service.send();
			service.addEventListener("complete", completeHandler);
		}

		private function completeHandler(event:Event):void
		{
			var responseData:Object = collection.getItemAt(0);
			if ((responseData is String) && (responseData == "No Data")) return;
			var sym:String = responseData["Symbol"];

			var queueNext:Stock = null;

			for (var i:int=0; i < _watchList.length; i++)
			{
				var stock:Stock = _watchList.getItemAt(i) as Stock;
				if (stock.symbol == sym) {
					stock.updateFromData(responseData);
					_watchList.itemUpdatedAt(i);
				}
				else if (stock.last == 0) {
				    queueNext = stock;
				}
			}

			for (i=0; i < _assetList.length; i++)
			{
				stock = _assetList.getItemAt(i) as Stock;
				if (stock.symbol == sym) {
					stock.updateFromData(responseData);
					_assetList.itemUpdatedAt(i);
				}
				else if (stock.last == 0) {
					queueNext = stock;
				}
			}

			if (queueNext != null) {
				trace("--- queue: "+queueNext.symbol);
				updateStockData(queueNext);
			}

		}
	}
}
