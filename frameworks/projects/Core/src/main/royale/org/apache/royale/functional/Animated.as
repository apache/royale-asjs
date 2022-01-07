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
package org.apache.royale.functional
{

	COMPILE::SWF
	{
		import flash.utils.setTimeout;
		import flash.utils.clearTimeout;
		import flash.utils.Timer;
		import flash.events.TimerEvent;
	}

	public class Animated
	{

		public static const STOPPED:String = "stopped";
		public static const RUNNING:String = "running";
		public static const FINISHED:String = "finished";

		public function Animated(toAnimate:Function,fps:Number=60,reusable:Boolean=false)
		{
			_reusable = reusable;
			this.fps = fps;
			animateFunction = toAnimate;

			lastTimeStamp = 0;
			invocations = [];

		}
		private var animateFunction:Function;
		private var limit:Number;
		private var lastTimeStamp:Number;
		private var invocations:Array;

		private var state:String = STOPPED;

		private var _reusable:Boolean;

		/**
		 * Whether the animation can be run again. (restart)
		 * 
		 * @langversion 3.0
		 * @productversion Royale 0.9.9
		 */
		public function get reusable():Boolean
		{
			return _reusable;
		}

		private var _fps:Number;

		/**
		 * frames per second to run the animation.
		 * 
		 * @langversion 3.0
		 * @productversion Royale 0.9.9
		 */
		public function get fps():Number
		{
			return _fps;
		}

		public function set fps(value:Number):void
		{
			_fps = value;
			limit = 1000/value;
		}

		COMPILE::SWF
		private var timer:Timer;
		COMPILE::SWF
		public function start():void
		{
			
			if(!invocations.length)
			{
				killTimer(FINISHED);
				return;
			}
			if(timer)
				return;

			var currentTime:Number = new Date().getTime();
			var previousState:String = state;
			state = RUNNING;
			createTimer();
			swfCallback(null);			
		}

		COMPILE::SWF
		private function swfCallback(ev:TimerEvent):void
		{
			if(state == STOPPED)
			{
				killTimer(state)
				return;
			}
			
			if(invocations.length == 0)
			{
				killTimer(FINISHED);
				return;
			}	

			if(invocations.length)
			{
				var currentArgs:Array = shiftInvocation();
				animateFunction.apply(null,currentArgs);
			}
			else
			{
				killTimer(FINISHED);
			}
		}
		private var usedInvocations:Array;
		private function shiftInvocation():Array
		{
			var invoc:Array = invocations.shift();
			if(_reusable)
			{
				if(!usedInvocations)
					usedInvocations = [];

				usedInvocations.push(invoc);
			}
			return invoc;
		}
		COMPILE::SWF
		private function createTimer():void
		{
			killTimer(state);
			timer = new Timer(limit);
			timer.addEventListener(TimerEvent.TIMER,swfCallback);
			timer.start();
		}
		COMPILE::SWF
		private function killTimer(state:String):void
		{
			this.state = state;
			if(timer){
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER,swfCallback);
			}
		}
		/**
		 * starts the animation
		 * 
		 * @langversion 3.0
		 * @productversion Royale 0.9.9
		 */

		COMPILE::JS
		public function start():void
		{
			if(state == RUNNING)
				return;

			if(invocations.length)
			{
				state = RUNNING;
				requestAnimationFrame(jsCallback);
			}
			else
				state = FINISHED;
		}

		COMPILE::JS
		private function jsCallback(timeStamp:Number):void
		{
			if(state == STOPPED)
				return;
			
			if(invocations.length == 0)
			{
				state = FINISHED;
				return;
			}	

			// we can't rely on getting time stamps ourselves,
			// so hopefully this is not slower than our target rate...
			if ( (timeStamp - lastTimeStamp) >= limit)
			{
				if(lastTimeStamp == 0)
					lastTimeStamp = timeStamp;
				else
					lastTimeStamp += limit; // make sure we stick to the desired rate
				var args:Array = shiftInvocation();
				animateFunction.apply(null,args);
			}
			// if there's no more operations, we'll catch it on the next animation frame and set the state to finished.
			// It's possible to push another call before the next animation frame.
			requestAnimationFrame(jsCallback);
		}


		/**
		 * stops an animation. If there are pending operations, they can be run by calling start.
		 * 
		 * @langversion 3.0
		 * @productversion Royale 0.9.9
		 */
		public function stop():void
		{
			state = STOPPED;
		}
		/**
		 * Reruns all the functions from the beginning. Only works if the Animated is reusable.
		 * Returns true if there was something to rerun, otherwise returns false.
		 * Either way, restart will function as start.
		 * 
		 * @langversion 3.0
		 * @productversion Royale 0.9.9
		 */
		public function restart():Boolean
		{
			var restarted:Boolean = false;
			if(usedInvocations && usedInvocations.length)
			{
				lastTimeStamp = 0;
				restarted = true;
				invocations = usedInvocations.concat(invocations);
			}
			start();
			return restarted;
		}

		/**
		 * returns true if the animation is currently running
		 * 
		 * @langversion 3.0
		 * @productversion Royale 0.9.9
		 */
		public function isRunning():Boolean
		{
			return state == RUNNING;
		}

		/**
		 * returns true if the animation has more operations to call
		 * 
		 * @langversion 3.0
		 * @productversion Royale 0.9.9
		 */
		public function isPending():Boolean
		{
			return invocations.length > 0;
		}

		/**
		 * returns true if the animation finished running
		 * 
		 * @langversion 3.0
		 * @productversion Royale 0.9.9
		 */
		public function isFinished():Boolean
		{
			return state == FINISHED;
		}

		/**
		 * adds an invocation to the animation
		 * 
		 * @langversion 3.0
		 * @productversion Royale 0.9.9
		 */
		public function push(args:Array):void
		{
			trace(args);
			invocations.push(args);
		}
		/**
		 * Removes all operations from the animation
		 * 
		 * @langversion 3.0
		 * @productversion Royale 0.9.9
		 */
		public function clear():void
		{
			invocations = [];
			usedInvocations = null;
		}

	}
}