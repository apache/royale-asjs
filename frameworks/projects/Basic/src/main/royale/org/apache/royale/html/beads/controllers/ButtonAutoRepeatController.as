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
package org.apache.royale.html.beads.controllers
{
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IBeadController;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
    import org.apache.royale.events.MouseEvent;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.utils.sendStrandEvent;

    /**
     *  The ButtonAutoRepeatController class adds autorepeat
     *  functionality to a button.  This version is simply waits
     *  a specified amount of time (default is 250ms), then repeats the button
     *  event at a specified interval, which defaults to
     *  125 milliseconds.  Alternate implementations could
     *  have non-linear repeat timing, look for keyboard modifiers to choose
     *  different rates, etc.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public class ButtonAutoRepeatController implements IBead, IBeadController
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function ButtonAutoRepeatController()
		{
		}
		
        private var _strand:IStrand;
        
        /**
         *  @copy org.apache.royale.core.IBead#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function set strand(value:IStrand):void
        {
            _strand = value;
            IEventDispatcher(value).addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
        }
        
        /**
         *  The number of milliseconds to wait before repeating the event
         *  for the first time.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public var delay:int = 250;
        
        /**
         *  The number of milliseconds to wait before repeating the event
         *  after the first time.  This value is not checked for
         *  changes after the events start repeating.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public var interval:int = 100;
        
        private var timeout:uint;
        private var repeater:uint;
        
        private function mouseDownHandler(event:MouseEvent):void
        {
            event.target.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);   
            event.target.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
            timeout = setTimeout(sendFirstRepeat, delay); 
        }
        
        private function mouseOutHandler(event:MouseEvent):void
        {
            event.target.removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);   
            event.target.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler); 
            if (repeater > 0)
                clearInterval(repeater);
            repeater = 0;
            if (timeout > 0)
                clearTimeout(timeout);
            timeout = 0;
        }
        
        private function mouseUpHandler(event:MouseEvent):void
        {
            event.target.removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);   
            event.target.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);  
            if (repeater > 0)
                clearInterval(repeater);
            repeater = 0;
            if (timeout > 0)
                clearTimeout(timeout);
            timeout = 0;
        }
        
        private function sendFirstRepeat():void
        {
            clearTimeout(timeout);
            timeout = 0;
        	repeater = setInterval(sendRepeats, interval);
            sendStrandEvent(_strand,"buttonRepeat");
        }
        
        private function sendRepeats():void
        {
            sendStrandEvent(_strand,"buttonRepeat");
        }
	}
}
