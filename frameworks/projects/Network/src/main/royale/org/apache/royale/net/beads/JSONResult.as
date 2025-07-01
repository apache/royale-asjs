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
package org.apache.royale.net.beads
{
    COMPILE::SWF
    {
        import flash.events.Event;            
    }
	
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
    import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
    import org.apache.royale.events.IEventDispatcher;
    
    //--------------------------------------
    //  Events
    //--------------------------------------
    
    /**
     *  Dispatched when the collection has processed a complete event.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    [Event(name="complete", type="org.apache.royale.events.Event")]

	/**
     *  Dispatched when the data could not be parsed due to an error.
     *
     *  @langversion 3.0
     *  @playerversion Flash 0.0
     *  @playerversion AIR 0.0
     *  @productversion Royale 0.0
     */
    [Event(name="error", type="org.apache.royale.events.Event")]
    
    /**
     *  Add as a bead to HTTPService to parse the service's response text as
     *  JSON.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class JSONResult extends EventDispatcher implements IBead
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function JSONResult()
		{
			super();
		}

        private var _id:String;
        
        /**
         *  @copy org.apache.royale.core.UIBase#id
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function get id():String
		{
			return _id;
		}

        /**
         *  @private
         */
		public function set id(value:String):void
		{
			if (_id != value)
			{
				_id = value;
				dispatchEvent(new org.apache.royale.events.Event("idChanged"));
			}
		}
		
        private var _strand:IStrand;
        
        /**
         *  @copy org.apache.royale.core.UIBase#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
         */
        public function set strand(value:IStrand):void
        {
            _strand = value;
            COMPILE::SWF
            {
                IEventDispatcher(_strand).addEventListener(flash.events.Event.COMPLETE, completeHandler);                    
            }
            COMPILE::JS
            {
                IEventDispatcher(_strand).addEventListener("complete", completeHandler);                    
            }
        }

        private var _data:Object;

        [Bindable("complete")]
        /**
         *  The parsed JSON object.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get data():Object
        {
            return _data;
        }
        
        COMPILE::SWF
        private function completeHandler(event:flash.events.Event):void
        {
            try
            {
                _data = JSON.parse(_strand["data"]);
                dispatchEvent(event);
            }
            catch (error:Error)
            {
                dispatchEvent(new org.apache.royale.events.Event("error"));
            }
        }
        COMPILE::JS
        private function completeHandler(event:org.apache.royale.events.Event):void
        {
            try
            {
                _data = JSON.parse(_strand["data"]);
                dispatchEvent(event);
            }
            catch (error:Error)
            {
                dispatchEvent(new org.apache.royale.events.Event("error"));
            }
        }

	}
}
