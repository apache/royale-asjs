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
package bindables
{
	import org.apache.royale.events.Event;

				import org.apache.royale.utils.Timer;
	public class StaticTimer
	{
	
			public static const EXTERNAL_STATIC_CONST:String = "EXTERNAL_STATIC_CONST_VAL";

			public function StaticTimer() {
			//trace("STATICTIMER");
			}
			
			private static var timer:Timer;
						
			private static var _inited:Boolean;
			
			private static function updateTimer(e:Event=null):void{
				var val:uint = uint(static_timerText);
				val++;
				static_timerText = val.toString();
			//	trace('updateTimer',val, static_timerText);
	
			}
			
			public static function initStaticTimer():void{
			if (!_inited) {
				timer = new Timer(1000);
				timer.addEventListener(Timer.TIMER,updateTimer);
				timer.start();
				_inited = true;
				trace('initStaticTimer');
			}
			}
			//[Bindable]
			public var instBindable:String;
			
			[Bindable]
			public static var static_timerText:String="1";

	}
}
