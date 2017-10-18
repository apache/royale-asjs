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
     *  Instances of the StyleChangeEvent class are dispatched by the StyleChangeNotifier
	 *  when it detects changes to a component's style.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class StyleChangeEvent extends ValueChangeEvent
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function StyleChangeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, 
										 oldValue:Object = null, newValue:Object = null)
		{
    		super(type, bubbles, cancelable, oldValue, newValue);
		}
		
        /**
         *  The default event type.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public static const STYLE_CHANGE:String = "styleChange";
        
        /**
         *  A convenience method to create an instance of the StyleChangeEvent.
         * 
         *  @param source The source of the object.
         *  @param name The name of the style being changed.
         *  @param oldValue The value before it was changed.
         *  @param newValue The value after it was changed.
         *  @return An instance of the StyleChangeEvent.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public static function createChangeEvent(source:Object, name:String, oldValue:Object, newValue:Object):StyleChangeEvent
        {
            var event:StyleChangeEvent = new StyleChangeEvent(STYLE_CHANGE, false, false, oldValue, newValue);
            event.propertyName = name;
            event.source = source;
            return event;
        }
	}
}
