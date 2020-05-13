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
package org.apache.royale.utils
{
COMPILE::SWF
{
    import flash.events.TimerEvent;
    import flash.utils.Timer;
}

import org.apache.royale.events.Event;

COMPILE::JS
{
    import org.apache.royale.events.EventDispatcher;
}

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched as requested via the delay and
 *  repeat count parameters in the constructor.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10.2
 *  @playerversion AIR 2.6
 *  @productversion Royale 0.0
 */
[Event(name="timer", type="org.apache.royale.events.Event")]

/**
 *  The Timer class dispatches events based on a delay
 *  and repeat count.  
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10.2
 *  @playerversion AIR 2.6
 *  @productversion Royale 0.0
 */
COMPILE::SWF
public class Timer extends flash.utils.Timer
{
    /**
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public static const TIMER:String = "timer";
    /**
     *  Constructor.
     * 
     *  @param delay The number of milliseconds 
     *  to wait before dispatching the event.
     *  @param repeatCount The number of times to dispatch
     *  the event.  If 0, keep dispatching forever.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function Timer(delay:Number, repeatCount:int = 0)
    {
        super(delay, repeatCount);
		addEventListener("timer", interceptor, false, 9999);
    }

	private function interceptor(event:flash.events.Event):void
	{
		if (event is TimerEvent)
		{
			event.stopImmediatePropagation();
			dispatchEvent(new Event("timer"));
		}
	}
}

/**
 *  The Timer class dispatches events based on a delay
 *  and repeat count.  
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10.2
 *  @playerversion AIR 2.6
 *  @productversion Royale 0.0
 * 
 *  @royalesuppresspublicvarwarning
 */
COMPILE::JS
public class Timer extends EventDispatcher
{
    
    /**
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public static const TIMER:String = "timer";
    /**
     *  Constructor.
     * 
     *  @param delay The number of milliseconds 
     *  to wait before dispatching the event.
     *  @param repeatCount The number of times to dispatch
     *  the event.  If 0, keep dispatching forever.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function Timer(delay:Number, repeatCount:int = 0)
    {
        this.delay = delay;
        this.repeatCount = repeatCount;
    }
    
    public var delay:Number;
    public var repeatCount:int;
    
	public function get running():Boolean
	{
		return timerInterval != -1;
	}
	
    private var _currentCount:int = 0;
	
	public function get currentCount():int
	{
		return _currentCount;
	}
    
    private var timerInterval:int = -1;
    
    public function reset():void
    {
        stop();
        _currentCount = 0;
    }
    
    public function stop():void
    {
        if (timerInterval != -1){
            clearInterval(timerInterval);
            timerInterval = -1;
        }
    }
    
    public function start():void
    {
		// ignore if already running.  
		if (timerInterval == -1) {
            timerInterval = setInterval(timerHandler, delay);
        }
    }
    
    private function timerHandler():void
    {
		// sometimes an interval gets called after you clear it
		if (timerInterval == -1)
		    return;
			
        _currentCount++;
        if (repeatCount > 0 && currentCount >= repeatCount) {
            stop();
        }
        
        dispatchEvent(new Event('timer'));
    }
}

}
