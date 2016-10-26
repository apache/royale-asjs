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
package org.apache.flex.events
{

	import org.apache.flex.events.CustomEvent;
	
	/**
	 * The ItemClickedEvent is a custom event issued by an itemRenderer to
	 * convey information about itself when it has determined that the
	 * event(s) happening to it constitute a 'click' on itself.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10.2
	 * @playerversion AIR 2.6
	 * @productversion FlexJS 0.0
	 */
	public class ItemClickedEvent extends CustomEvent
	{

		//--------------------------------------
		//   Constructor
		//--------------------------------------

		/**
		 * Constructor.
		 *
		 * @param type The name of the event.
		 * @param bubbles Whether the event bubbles.
		 * @param cancelable Whether the event can be canceled.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10.2
		 * @playerversion AIR 2.6
		 * @productversion FlexJS 0.0
		 */
		public function ItemClickedEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
            COMPILE::SWF
            {
                super(type, bubbles, cancelable);                    
            }
            COMPILE::JS
            {
                super(type);
            }
			
			index = -1;
			data = null;
			multipleSelection = false;
		}
		
		/**
		 * The index of the item beginning with zero.
		 *
		 * @export
		 * @langversion 3.0
		 * @playerversion Flash 10.2
		 * @playerversion AIR 2.6
		 * @productversion FlexJS 0.0
		 */
		public var index:Number;
		
		/**
		 * The data of the item.
		 *
		 * @export
		 * @langversion 3.0
		 * @playerversion Flash 10.2
		 * @playerversion AIR 2.6
		 * @productversion FlexJS 0.0
		 */
		public var data:Object;
		
		/**
		 * Whether or not this click is part of a multi-selection sequence.
		 *
		 * @export
		 * @langversion 3.0
		 * @playerversion Flash 10.2
		 * @playerversion AIR 2.6
		 * @productversion FlexJS 0.0
		 */
		public var multipleSelection:Boolean;
		
		/**
		 * @private
		 */
		override public function cloneEvent():org.apache.flex.events.Event
		{
			var newEvent:ItemClickedEvent = new ItemClickedEvent(type);
			newEvent.index = index;
			newEvent.data = data;
			newEvent.multipleSelection = multipleSelection;
			return newEvent;
		}
	}
}
