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
package org.apache.royale.html.beads
{
	
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.core.DispatcherBead;
	COMPILE::SWF {
		import flash.utils.clearTimeout;	
		import flash.utils.setTimeout;	
	}

	/**
     *  Dispatched when the event first fires
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9
     */
    [Event(name="startingThrottle", type="org.apache.royale.events.Event")]
    /**
     *  Dispatched after the timeout occurs
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9
     */

    [Event(name="finishedThrottle", type="org.apache.royale.events.Event")]
	/**
	 *  The ThrottleBead class allows you to listen to an event only after a timeout
	 *  has been reached. This can be useful in situations where events are thrown repeatedly
	 *  but the application is only interested in the last dispatching.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */

	public class ThrottleBead extends DispatcherBead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function ThrottleBead()
		{
		}
		
		private var _event:String;
		public function get event():String
		{
			return _event;
		}
		public function set event(value:String):void
		{
			_event = value;
		}

		private var _interval:Number = 500;
		public function get interval():Number
		{
			return _interval;
		}

		[Inspectable(category="General", defaultValue="500")]
		public function set interval(value:Number):void
		{
			_interval = value;
		}
		
		
		private var timeoutId:Number = NaN;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		override public function set strand(value:IStrand):void
		{	
			_strand = value;
			host.addEventListener(event, originalEventDispatched);
		}
		
		private function originalEventDispatched():void
		{
			if (isNaN(timeoutId))
			{
				timeoutId = setTimeout(throwEventWhenFinished, interval);
				dispatchEvent(new Event("startingThrottle"));
			} else
			{
				clearTimeout(timeoutId);
				timeoutId = setTimeout(throwEventWhenFinished, interval);
			}
		}

		/**
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		protected function get host():IEventDispatcher
		{
			return _strand as IEventDispatcher;
		}
		
		private function throwEventWhenFinished():void
		{
			clearTimeout(timeoutId);
			timeoutId = NaN;
			dispatchEvent(new Event("finishedThrottle"));
		}

		
	}
}
