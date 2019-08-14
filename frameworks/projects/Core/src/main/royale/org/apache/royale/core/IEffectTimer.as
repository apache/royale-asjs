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
package org.apache.royale.core
{
	import org.apache.royale.events.IEventDispatcher;

    /**
     *  The IEffectTimer interface is the basic interface for the
	 *  class that updates effects like tweens.  Different
	 *  IEffectTimer implementations are tuned for various
	 *  runtime environments like mobile, Flash, desktop,
	 *  or even automated testing where the currentTime is
	 *  controlled so the animation updates its target at
	 *  predictable positions on the screen.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public interface IEffectTimer extends IEventDispatcher
	{
        /**
         *  Start getting update events.
		 * 
		 *  @return The current time.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		function start():Number;
		
        /**
         *  Stop getting update events.  Current time
		 *  should theoretically keep advancing, but events
		 *  are not dispatched so most implementations
		 *  stop the platform timer (which can save battery
		 *  on mobile devices) because they know that
		 *  when start() is called they have a way of
		 *  getting the updated current time.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		function stop():void;
		
	}
}
