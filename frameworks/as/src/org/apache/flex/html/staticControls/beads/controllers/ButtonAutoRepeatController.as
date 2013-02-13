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
package org.apache.flex.html.staticControls.beads.controllers
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IStrand;

    public class ButtonAutoRepeatController implements IBead
	{
		public function ButtonAutoRepeatController()
		{
		}
		
        private var _strand:IStrand;
        
        public function get strand():IStrand
        {
            return _strand;
        }
        
        public function set strand(value:IStrand):void
        {
            _strand = value;
            IEventDispatcher(value).addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
        }
        
        public var delay:int = 250;
        public var interval:int = 100;
        
        private var timeout:uint;
        private var repeater:uint;
		private var stop:Boolean = false;
        
        private function mouseDownHandler(event:MouseEvent):void
        {
            event.target.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);   
            event.target.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			stop = false;
            setTimeout(sendFirstRepeat, delay); 
        }
        
        private function mouseOutHandler(event:MouseEvent):void
        {
            event.target.removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);   
            event.target.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler); 
			stop = true;
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
			stop = true;
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
			if (!stop) {
            	repeater = setInterval(sendRepeats, interval);
            	IEventDispatcher(_strand).dispatchEvent(new Event("buttonRepeat"));
			}
        }
        
        private function sendRepeats():void
        {
			if( stop ) {
				if (repeater > 0 ) 
					clearInterval(repeater);
				repeater = 0;
			}
			else {
        	    IEventDispatcher(_strand).dispatchEvent(new Event("buttonRepeat"));
			}
        }
	}
}