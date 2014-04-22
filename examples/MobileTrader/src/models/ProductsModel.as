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
	import org.apache.flex.events.EventDispatcher;
		
	public class ProductsModel extends EventDispatcher
	{
		public function ProductsModel()
		{
		}

		private var _tabList:Array = ["Assets", "Watch", "Alerts"];
		public function get tabList():Array
		{
			return _tabList;
		}
		
		private var _stockData:Array = [
			{stock:"XOM",  open:81.39,   last:86.22,  high:88.40,  low:81.30,  image:""},
			{stock:"WMT",  open:51.47,   last:52.00,  high:52.50,  low:51.04,  image:""},
			{stock:"CVX",  open:102.93,  last:104.13, high:104.41, low:101.15, image:""}
		];
		public function get stockData():Array
		{
			return _stockData;
		}

		private var _labelFields:Array = [ "id", "title", "detail" ];
		public function get labelFields():Array
		{
			return _labelFields;
		}
	}
}