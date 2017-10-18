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
			_alerts = new ArrayList();
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
		
		private var _alerts:ArrayList;
		
		public function get alerts():ArrayList
		{
			return _alerts;
		}
		
		public function addAlert(value:Alert):void
		{
			for (var i:int =0; i < _alerts.length; i++)
			{
				var alert:Alert = _alerts.getItemAt(i) as Alert;
				if (alert.symbol == value.symbol) {
				    _alerts.setItemAt(value, i);
					return;
				}
			}
			
			_alerts.addItem(value);
			dispatchEvent(new Event("alertsUpdate"));
		}
		
		public function addStock(symbol:String):Stock
		{
			for (var i:int=0; i < _watchList.length; i++)
			{
				var stock:Stock = _watchList.getItemAt(i) as Stock;
				if (stock.symbol == symbol) return stock;
			}
			
			stock = new Stock(symbol);
			
			_watchList.addItem(stock);
	//		dispatchEvent(new Event("update"));
			
			updateStockData(stock);
			return stock;
		}
		
		public function updateStockData(value:Stock):void
		{
			var sym:String = value.symbol;
			service.url = queryBegin + sym + queryEnd;
			service.send();
			service.addEventListener("complete", completeHandler);
		}
		
		public function removeStock(stock:Stock):void
		{
			for (var i:int=0; i < alerts.length; i++)
			{
				var alert:Alert = alerts.getItemAt(i) as Alert;
				if (stock.symbol == alert.symbol) {
					alerts.removeItemAt(i);
					break;
				}
			}
			
			for (i=0; i < _watchList.length; i++)
			{
				var s:Stock = _watchList.getItemAt(i) as Stock;
				if (stock.symbol == s.symbol) {
					_watchList.removeItemAt(i);
					break;
				}
			}
			
			dispatchEvent(new Event("alertsUpdate"));
			dispatchEvent(new Event("update"));
		}
		
		private function completeHandler(event:Event):void
		{
			var responseData:Object = collection.getItemAt(0);
			
			var sym:String = responseData["Symbol"];
			for (var i:int=0; i < _watchList.length; i++)
			{
				var stock:Stock = _watchList.getItemAt(i) as Stock;
				if (stock.symbol == sym) {
					stock.updateFromData(responseData);
					_watchList.itemUpdatedAt(i);
					break;
				}
			}
		}
	}
}
