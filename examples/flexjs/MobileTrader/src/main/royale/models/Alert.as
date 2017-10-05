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
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;

	public class Alert extends EventDispatcher
	{
		public function Alert()
		{
			super();
			message = "";
		}
		
		private var _symbol:String;
		private var _value:Number;
		private var _greaterThan:Boolean;
		private var _message:String;
		private var _stock:Stock;
		
		[Binding("symbolChanged")]
		public function get symbol():String
		{
			return _symbol;
		}
		public function set symbol(value:String):void
		{
			_symbol = value;
			dispatchEvent(new Event("symbolChanged"));
		}
		
		[Binding("messageChanged")]
		public function get message():String
		{
			return _message;
		}
		public function set message(value:String):void
		{
			_message = value;
			dispatchEvent(new Event("messageChanged"));
		}
		
		[Binding("valueChanged")]
		public function get value():Number
		{
			return _value;
		}
		public function set value(newValue:Number):void
		{
			_value = newValue;
			dispatchEvent(new Event("valueChanged"));
		}
		
		[Binding("greaterThanChanged")]
		public function get greaterThan():Boolean
		{
			return _greaterThan;
		}
		public function set greaterThan(value:Boolean):void
		{
			_greaterThan = value;
			dispatchEvent(new Event("greaterThanChanged"));
		}
		
		[Binding("stockChanged")]
		public function get stock():Stock
		{
			return _stock;
		}
		public function set stock(value:Stock):void
		{
			_stock = value;
			dispatchEvent(new Event("stockChanged"));
		}
		
	}
}
