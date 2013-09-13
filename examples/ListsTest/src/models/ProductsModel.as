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

		private var _products:Array = [
			{id:"ps100", title:"Widgets", detail:"44", image:"smallbluerect.jpg"},
			{id:"tx200", title:"Thingys", detail:"out of stock", image:"smallgreenrect.jpg"},
			{id:"rz300", title:"Sprockets", detail:"8,000", image:"smallyellowrect.jpg"},
			{id:"dh440", title:"DooHickies", detail:"out of stock", image:"smallredrect.jpg"},
			{id:"ps220", title:"Weejets", detail:"235", image:"smallorangerect.jpg"}
			];
		public function get products():Array
		{
			return _products;
		}

	}
}