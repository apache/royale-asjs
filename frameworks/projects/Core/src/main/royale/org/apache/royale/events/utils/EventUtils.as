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
package org.apache.royale.events.utils
{
COMPILE::JS
{
    import org.apache.royale.conversions.createEventInit;
    import goog.events.Event;
    import org.apache.royale.events.getTargetWrapper;
    import window.Event;
}

    /**
	 *  Provides static methods for creating custom events in JS
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     *
     *  @royalesupressexport
	 */
    COMPILE::JS
	public class EventUtils
	{
       public static function createEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false):Object
       {
           var customEvent:Object = null;

           try
           {
               customEvent = new window.Event(type, createEventInit(bubbles, cancelable));
               return customEvent;
           }
           catch (e:Error)
           {

           }

           if (!customEvent)
           {
               customEvent = document.createEvent("Event");
               customEvent.initEvent(type, bubbles, cancelable);
           }

           return customEvent;
       }

        /**
         * A way to let a Royale Event 'hitch a ride' on a native browser event.
         *  Encapsulates the tagging/untagging support in this Utils class
         * @param nativeEvent the native event to tag with the Royale Event
         * @param royaleEvent the Royale Event to accompany the native event (expected as a org.apache.royale.events.Event here)
         * @return the native event passed it
         */
       public static function tagNativeEvent(nativeEvent:Object, royaleEvent:Object):Object{
           nativeEvent['_RYL_ORIG'] = royaleEvent;
           return nativeEvent;
       }

        /**
         * A way to retrieve a RoyaleEvent from a native browser event,
         * if present. Encapsulates the tagging/untagging support in this Utils class
         * @param nativeEvent
         * @return the resolved event instance
         *
         * @royaleignorecoercion goog.events.Event
         */
        public static function retrieveEvent(nativeEvent:Object):Object{
            if (nativeEvent['_RYL_ORIG']) {
                var rlyEvt:goog.events.Event = nativeEvent['_RYL_ORIG'] as goog.events.Event;
                //retrieve it with the currentTarget updated
                rlyEvt.currentTarget = getTargetWrapper(nativeEvent.currentTarget)
                return rlyEvt;
            }
            return nativeEvent;
        }

    }
}
