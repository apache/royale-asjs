0.////////////////////////////////////////////////////////////////////////////////
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
package bindables
{
	import org.apache.flex.events.Event;

				import org.apache.flex.utils.Timer;
			
	public class InstanceTimer
	{
			
			public function InstanceTimer(){
				initTimer(1500);
			}
			
			
			private static var _inst:InstanceTimer;
			
			public static function getInstance():InstanceTimer {
				return _inst || (_inst = new InstanceTimer());
			
			}
			
			
			
			
			private var timer:Timer;
						
			
			
			private function updateTimer(e:Event=null):void{
				timerCount++
			//	trace('updateTimer',timerCount);
	
			}
			
			private  function initTimer(val:uint):void{

				timer = new Timer(val);
				timer.addEventListener(Timer.TIMER,updateTimer);
				timer.start();
				trace('init InstanceTimer');

			}
			
			[Bindable]
			public var timerCount:uint = 0;
			
			[Bindable]
			public static var stimerCount:uint = 0;

	}
}
