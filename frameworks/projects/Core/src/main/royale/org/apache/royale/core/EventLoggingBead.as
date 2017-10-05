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
    import org.apache.royale.events.IEventDispatcher;
    
    /**
     *  The EventLogging bead logs dispatches
	 *  of certain events.  This can be useful
	 *  in debugging type coercion errors when
	 *  an event handler has the wrong type
	 *  in the function signature.
     *  
	 *  Place this bead in the application.
	 *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class EventLoggingBead implements IBead
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function EventLoggingBead()
		{
			super();
		}
        
        private var _strand:IStrand;
        
        /**
         *  @copy org.apache.royale.core.IBead#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
		 *
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
         */
        public function set strand(value:IStrand):void
        {
            _strand = value;
			
			COMPILE::SWF
			{
			if (eventNames)
			{
				// log each event.  Use capture phase to try to get it first.
				for each (var e:String in eventNames)
					(_strand as IEventDispatcher).addEventListener(e, eventHandler, true);
			}
			}
        }    

        private var _eventNames:Array;
        
        /**
         *  Array of event names to listen to.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get eventNames():Array
        {
			return _eventNames;
        }
        
		public function set eventNames(value:Array):void
		{
			_eventNames = value;
		}
		
		private var _log:Array = [];
		
		public function get log():Array
		{
			return _log;
		}
		
        COMPILE::SWF
        private function eventHandler(event:Event):void
        {
			_log.push(event);
			if (_log.length > 10)
				_log.shift();
			trace(event.type + " " + event.target);
        }
        
        
    }
}
