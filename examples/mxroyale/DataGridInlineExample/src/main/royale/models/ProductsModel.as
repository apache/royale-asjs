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
	import mx.collections.ArrayCollection;
	import products.Product;

	public class ProductsModel
	{
		private var _productList:ArrayCollection = new ArrayCollection([
            new Product("ps100","Widgets",44,200,"assets/smallbluerect.jpg"),
            new Product("tx200","Thingys",5,285,"assets/smallgreenrect.jpg"),
            new Product("rz300","Sprockets",80,105,"assets/smallyellowrect.jpg"),
            new Product("dh440","Doohickies",10,340,"assets/smallredrect.jpg"),
            new Product("ps220","Weejets",35,190,"assets/smallorangerect.jpg"),
			new Product("ga443","Gadgets",5,99,"assets/smallgreenrect.jpg"),
			new Product("dd123","Doodads",55,8077,"assets/smallyellowrect.jpg"),
			new Product("gr234","Gronkles",12,27,"assets/smallredrect.jpg"),
			new Product("wb754","Whizbangs",67,390,"assets/smallorangerect.jpg")
		]);

		[Bindable("__NoChangeEvent__")]
		public function get productList():ArrayCollection
		{
			return _productList;
		}
		
		private var _productArray:ArrayCollection = new ArrayCollection([
			new Product("ps100","Blueberries",44,200,"assets/smallbluerect.jpg"),
			new Product("tx200","Kiwis",5,285,"assets/smallgreenrect.jpg"),
			new Product("rz300","Bananas",80,105,"assets/smallyellowrect.jpg"),
			new Product("dh440","Strawberries",10,340,"assets/smallredrect.jpg"),
			new Product("ps220","Oranges",35,190,"assets/smallorangerect.jpg"),
			new Product("ps111","Mandarins",414,202,"assets/smallorangerect.jpg"),
			new Product("tx220","Loquats",51,185,"assets/smallyellowrect.jpg"),
			new Product("rz303","Guavas",810,1205,"assets/smallredrect.jpg"),
			new Product("dh490","Pears",120,3420,"assets/smallgreenrect.jpg"),
			new Product("ps222","Apples",315,1190,"assets/smallredrect.jpg")
		]);
		
		public function get alternateProductList():ArrayCollection
		{
			return _productArray;
		}
	}
}
