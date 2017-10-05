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
	
	import products.Product;
	
	public class ProductsModel extends EventDispatcher
	{
		public function ProductsModel()
		{
		}

		private var _productList:Array = [
			new Product("ps100", "Widgets", "44", 100, "smallbluerect.jpg"),
			new Product("tx200", "Thingys", "out of stock", 10000, "smallgreenrect.jpg"),
			new Product("rz300", "Sprockets", "8,000", 10, "smallyellowrect.jpg"),
			new Product("dh440", "DooHickies", "out of stock", 20000, "smallredrect.jpg"),
			new Product("ps220", "Weejets", "235", 300, "smallorangerect.jpg")
			];
		public function get productList():Array
		{
			return _productList;
		}

	}
}
