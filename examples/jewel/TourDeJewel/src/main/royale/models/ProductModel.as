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
	import org.apache.royale.collections.ArrayList;
	import vos.Product;

	[Bindable]
	public class ProductModel
	{
		private var _fewProductList:ArrayList = new ArrayList([
            new Product("ps100", "Few", 44, 200,"assets/smallbluerect.jpg"),
            new Product("tx200", "Products", 5, 285,"assets/smallgreenrect.jpg"),
            new Product("rz300", "On List", 80, 105,"assets/smallyellowrect.jpg")
		]);

		public function get fewProductList():ArrayList
		{
			return _fewProductList;
		}
		public function set fewProductList(value:ArrayList):void
		{
			if(value != _fewProductList)
			{
				_fewProductList = value;
			}
		}

		private var _productList:ArrayList = new ArrayList([
            new Product("ps100","Widgets",44,200,"assets/smallbluerect.jpg"),
            new Product("tx200","Thingys",5,285,"assets/smallgreenrect.jpg"),
            new Product("rz300","Sprockets",80,105,"assets/smallyellowrect.jpg"),
            new Product("dh440","Doohickies",10,340,"assets/smallredrect.jpg"),
            new Product("ps220","Weejets",35,190,"assets/smallorangerect.jpg")
		]);

		public function get productList():ArrayList
		{
			return _productList;
		}
	}
}
