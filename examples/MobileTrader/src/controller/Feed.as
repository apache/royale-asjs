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
////////////////////////////////////////////////////////////////////////////////s
package controller
{
//	import flash.events.TimerEvent;
	
	import models.Stock;
	
	import org.apache.flex.core.IBeadModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.EventDispatcher;
	import org.apache.flex.utils.Timer;
	
	[Event("change",org.apache.flex.events.Event)]

	public class Feed extends EventDispatcher implements IBeadModel
	{
		protected var index:int = 0;
		
		protected var updateOrder:Array = [6,4,1,7,0,3,2,5]; // used to simulated randomness of updates
		
		protected var timer:Timer;
		
		protected var stockMap:Object;
		
		private var _stockList:Array;
		public function get stockList():Array
		{
			return _stockList;
		}
		public function set stockList(value:Array):void
		{
			_stockList = value;
		}
		
		public function set strand(value:IStrand):void
		{
			// not used
		}
		
		public function Feed()
		{
			stockMap = new Object();
			stockList = new Array();
			
			stockList.push(new Stock("XOM", 81.39));
			stockList.push(new Stock("WMT", 51.47));
			stockList.push(new Stock("CVX", 102.93));
			stockList.push(new Stock("AIG", 36.01));
			stockList.push(new Stock("IBM", 155.49));
			stockList.push(new Stock("SAP", 57.53));
			stockList.push(new Stock("MOT", 41.50));
			stockList.push(new Stock("MCD", 73));
			
			var stockCount:int = stockList.length;
			
			for (var k:int = 0; k < stockCount; k++)
			{
				var s:Stock = stockList[k] as Stock;
				s.open = s.last;
				s.high = s.last;
				s.low = s.last;
				s.change = 0;
				stockMap[s.symbol] = s;
			}
			
			// Simulate history for the last 2 minutes			
			for (var i:int=0; i < 120 ; i++)
			{
				for (var j:int=0 ; j<stockCount ; j++)
				{
					simulateChange(stockList[j] as Stock, false);
				}
			}		
			timer = new Timer(1000 / 4, 0);
			timer.addEventListener("timer", timerHandler);
		}
		
		public function subscribe():void
		{
			if (!timer.running) 
			{
				timer.start();
			}
		}
		
		public function unsubscribe():void
		{
			if (timer.running) 
			{
				timer.stop();
			}
		}

		protected function timerHandler(event:*):void
		{
			if (index >= stockList.length) index = 0;
			simulateChange(stockList[updateOrder[index]] as Stock, true);
			index++;
			
			var newEvent:Event = new Event("update");
			this.dispatchEvent(newEvent);
		}
		
		protected function simulateChange(stock:Stock, removeFirst:Boolean = true):void
		{
			var maxChange:Number = stock.open * 0.005;
			var change:Number = maxChange - Math.random() * maxChange * 2;
			
			change = change == 0 ? 0.01 : change;
			
			var newValue:Number = stock.last + change;
			
			if (newValue > stock.open * 1.15 || newValue < stock.open * 0.85)
			{
				change = -change;
				newValue = stock.last + change;
			}
			
			stock.change = change;
			stock.last = newValue;
			
			if (stock.last > stock.high)
			{
				stock.high = stock.last;
			}
			else if (stock.last < stock.low || stock.low == 0)
			{
				stock.low = stock.last;
			}
			
			if (!stock.history)
			{
				stock.history = new Array();
			}
			if (removeFirst)
			{
				stock.history.splice(1,0);
			}
			stock.history.push({high: stock.high, low: stock.low, open: stock.open, last: stock.last});

		}
		
	}
}