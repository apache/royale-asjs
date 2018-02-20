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
package org.apache.royale.events
{
    
    /**
     *  The ValueChangeEvent class replaces the PropertyChangeEvent as
     *  the default event for property changes used in the databinding
     *  subsystem.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     * 
     *  @royalesuppresspublicvarwarning
     */
	public class ValueChangeEvent extends Event
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function ValueChangeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, 
										 oldValue:Object = null, newValue:Object = null)
		{
    		super(type, bubbles, cancelable);
			this.oldValue = oldValue;
			this.newValue = newValue;
		}
		
        /**
         *  The value of the property before it was changed.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public var oldValue:Object;

        /**
         *  The value of the property after it was changed.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public var newValue:Object;

        /**
         *  The name of the property.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public var propertyName:String;

        /**
         *  The object that owns the property.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public var source:Object;
		
        /**
         *  The default event type.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public static const VALUE_CHANGE:String = "valueChange";
        
        /**
         *  A convenience method to create an instance of the ValueChangeEvent.
         * 
         *  @param source The source of the object.
         *  @param name The name of the event.
         *  @param oldValue The value before it was changed.
         *  @param newValue The value after it was changed.
         *  @return An instance of the ValueChangeEvent.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public static function createUpdateEvent(source:Object, name:String, oldValue:Object, newValue:Object):ValueChangeEvent
        {
            var event:ValueChangeEvent = new ValueChangeEvent(VALUE_CHANGE, false, false, oldValue, newValue);
            event.propertyName = name;
            event.source = source;
            return event;
        }

        /**
         * Create a copy/clone of the ValueChangeEvent object.
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.0
         */
        override public function cloneEvent():IRoyaleEvent
        {
            return new ValueChangeEvent(type, bubbles, cancelable, oldValue, newValue);
        }
	}
}
