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
    COMPILE::SWF
    {
        import flash.events.Event;
    }
    
    import org.apache.royale.core.IBead;
    import org.apache.royale.core.IStrand;
    
    /**
     *  The CallLater bead implements ways for
     *  a method to be called after other code has
     *  finished running.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class CallLaterBead extends Bead
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function CallLaterBead()
		{
			super();
		}
        
        private var calls:Array;
        
        /**
         *  Calls a function after some amount of time.
         * 
         *  CallLater works a bit differently than in
         *  the Flex SDK.  The Flex SDK version was
         *  could use the Flash Player's RENDER event 
         *  to try to run code before the scren was
         *  updated.  Since there is no deferred rendering
         *  in HTML/JS/CSS, this version of callLater
         *  is almost always going to run after the
         *  screen is updated.
         *  
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function callLater(fn:Function, args:Array = null, thisArg:Object = null):void
        {
            COMPILE::SWF
            {
                (_strand as IRenderedObject).$displayObject.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
            }
            if (calls == null)
                calls = [ {thisArg: thisArg, fn: fn, args: args } ];
            else
                calls.push({thisArg: thisArg, fn: fn, args: args });
            
            COMPILE::JS
            {
                setTimeout(makeCalls, 0);
            }
        }
        
        COMPILE::SWF
        private function enterFrameHandler(event:Event):void
        {
            (_strand as IRenderedObject).$displayObject.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
            makeCalls();
        }
        
        private function makeCalls():void
        {
            var list:Array = calls;
            var n:int = list.length;
            for (var i:int = 0; i < n; i++)
            {
                var call:Object = list.shift();
                var fn:Function = call.fn;
                fn.apply(call.thisArg, call.args);
            }
            
        }
        
    }
}
