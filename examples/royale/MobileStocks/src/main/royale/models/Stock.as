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
	
	public class Stock extends EventDispatcher
	{	    		
		public var history:Array;
		
		public function Stock(symbol:String=null, last:Number=0)
		{
			this.symbol = symbol;
			this.last = last;
			this.low = last;
			this.high = last;
			this.open = last;
			this.change = 0;
			this.name = "";
			this.shares = 0;
		}
		
		public function updateFromData(obj:Object):void
		{
			name = obj["Name"];
			low = obj["DaysLow"];
			high = obj["DaysHigh"];
			open = obj["Open"];
			change = obj["Change"];
			symbol = obj["Symbol"];
			last = obj["LastTradePriceOnly"];
			// shares do not change this way
		}
		
		private var _symbol:String;
		private var _name:String;
		private var _low:Number;
		private var _high:Number;
		private var _open:Number;
		private var _last:Number;
		private var _change:Number;
		private var _date:Date;
		
		private var _shares:Number;
		
		[Bindable("symbolChanged")]
		public function get symbol():String
		{
			return _symbol;
		}
		public function set symbol(value:String):void
		{
			_symbol = value;
			dispatchEvent(new Event("symbolChanged"));
		}
		
		[Bindable("nameChanged")]
		public function get name():String
		{
			return _name;
		}
		public function set name(value:String):void
		{
			_name = value;
			dispatchEvent(new Event("nameChanged"));
		}
		
		[Bindable("lowChanged")]
		public function get low():Number
		{
			return _low;
		}
		public function set low(value:Number):void
		{
			_low = value;
			dispatchEvent(new Event("lowChanged"));
		}
		
		[Bindable("highChanged")]
		public function get high():Number
		{
			return _high;
		}
		public function set high(value:Number):void
		{
			_high = value;
			dispatchEvent(new Event("highChanged"));
		}
		
		[Bindable("openChanged")]
		public function get open():Number
		{
			return _open;
		}
		public function set open(value:Number):void
		{
			_open = value;
			dispatchEvent(new Event("openChanged"));
		}
		
		[Bindable("lastChanged")]
		public function get last():Number
		{
			return _last;
		}
		public function set last(value:Number):void
		{
			_last = value;
			dispatchEvent(new Event("lastChanged"));
		}
		
		[Bindable("changeChanged")]
		public function get change():Number
		{
			return _change;
		}
		public function set change(value:Number):void
		{
			_change = value;
			dispatchEvent(new Event("changeChanged"));
		}
		
		[Bindable("dateChanged")]
		public function get date():Date
		{
			return _date;
		}
		public function set date(value:Date):void
		{
			_date = value;
			dispatchEvent(new Event("dateChanged"));
		}
		
		[Bindable("sharedChanged")]
		public function get shares():Number
		{
			return _shares;
		}
		public function set shares(value:Number):void
		{
			_shares = value;
			dispatchEvent(new Event("sharesChanged"));
		}
		
		public function get total():Number
		{
			return _shares * _last;
		}
	}
	
}
