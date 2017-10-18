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
	import products.Product;
	
	public class ProductsModel
	{
		public function ProductsModel()
		{
			generateWaves(20);
		}

		private var _productList:Array = [
			new Product("tx200","Thingys",    5, 285,314,"smallgreenrect.jpg"),
			new Product("dh440","Doohickies", 10,340,125,"smallredrect.jpg"),
			new Product("ps220","Weejets",    35,190,240,"smallorangerect.jpg"),
			new Product("ps100","Widgets",    44,200,82,"smallbluerect.jpg"),
			new Product("rz300","Sprockets",  80,105,271,"smallyellowrect.jpg")
			];
		public function get productList():Array
		{
			return _productList;
		}

		private var _labelFields:Array = [ "id", "title", "sales2013", "sales2014", "detail" ];
		public function get labelFields():Array
		{
			return _labelFields;
		}
		
		private var _wave:Array;
		
		public function generateWaves(numPoints:int):void
		{
			_wave = [];
			
			var angleIncr:Number = 360/numPoints;
			var angle:Number = 0;
			
			for (var i:int=0; i < numPoints; i++)
			{
				var p:Object = {x:i, 
					sin:Math.sin(Math.PI/180*angle),
						cos:Math.cos(Math.PI/180*angle)};
				angle += angleIncr;
				_wave.push(p);
			}
		}
		
		public function get wave1():Array
		{
			return _wave;
		}
		
		public function get wave2():Array
		{
			return _wave;
		}
	}
}
