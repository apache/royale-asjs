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
package products
{
	public class Product
	{
		public function Product(id:String,title:String,detail:Number,sales:Number,image:String)
		{
			this.id = id;
			this.title = title;
			this.detail = detail;
			this.sales = sales;
			this.image = image;
		}
		
		public var id:String;
		public var title:String;
		public var detail:Number;
		public var image:String;
		public var sales:Number;
		
		public function toString():String
		{
			return title;
		}
	}
}
