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
package vos {
	
	[Bindable]
	public class Product
	{
		private var _id:String;
		private var _title:String;
		private var _detail:Number;
		private var _image:String;
		private var _sales:Number;
		
		public function Product(id:String,title:String,detail:Number,sales:Number,image:String)
		{
			this._id = id;
			this._title = title;
			this._detail = detail;
			this._sales = sales;
			this._image = image;
		}
		
		public function get id():String
		{
			return _id;
		}
		public function set id(value:String):void
		{
			_id = value;
		}
		
		public function get title():String
		{
			return _title;
		}
		public function set title(value:String):void
		{
			_title = value;
		}
		
		public function get detail():Number
		{
			return _detail;
		}
		public function set detail(value:Number):void
		{
			_detail = value;
		}
		
		public function get image():String
		{
			return _image;
		}
		public function set image(value:String):void
		{
			_image = value;
		}
		
		public function get sales():Number
		{
			return _sales;
		}
		public function set sales(value:Number):void
		{
			_sales = value;
		}
		
		public function toString():String
		{
			return title;
		}
	}
}
