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

package mx.events
{
     import org.apache.royale.events.Event;
     import org.apache.royale.events.IRoyaleEvent;

    /**
     *  The TimeEvent class represents event objects specific to Timer
     *
     *  @see mx.utils.Timer
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     *  @productversion Royale 0.9.8
     */
    public class TimerEvent extends Event
    {
        //--------------------------------------------------------------------------
        //
        //  Class constants
        //
        //--------------------------------------------------------------------------
        /**
         *
         *  @eventType timerComplete
         *
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         *  @productversion Royale 0.9.8
         */
        public static const TIMER:String = "timer";

        /**
         *
         *  @eventType timerComplete
         *
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         *  @productversion Royale 0.9.8
         */
        public static const TIMER_COMPLETE:String = "timerComplete";

        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------

        /**
         *  Constructor.
         *
         *  @param type The event type; indicates the action that caused the event.
         *
         *  @param bubbles Specifies whether the event can bubble up the display list hierarchy.
         *
         *  @param cancelable Specifies whether the behavior associated with the event can be prevented.
         *
         *
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         *  @productversion Royale 0.9.8
         */
        public function TimerEvent(type:String, bubbles:Boolean = false,
                                   cancelable:Boolean = false)
        {
            super(type, bubbles, cancelable);
        }

        //--------------------------------------------------------------------------
        //
        //  Properties
        //
        //--------------------------------------------------------------------------

        //--------------------------------------------------------------------------
        //
        //  Overridden methods: Event
        //
        //--------------------------------------------------------------------------

        /**
         *  @private
         */
        override public function cloneEvent():IRoyaleEvent
        {
            return new TimerEvent(type, bubbles, cancelable);
        }
    }
}
