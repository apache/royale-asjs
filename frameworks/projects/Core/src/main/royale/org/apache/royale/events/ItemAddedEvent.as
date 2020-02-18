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
	import org.apache.royale.events.CustomEvent;
	
	/**
	 * The ItemAddedEvent is dispatched by IItemRendererOwnerView objects whenenver an
	 * itemRenderer is added.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10.2
	 * @playerversion AIR 2.6
	 * @productversion Royale 0.0
     * 
     *  @royalesuppresspublicvarwarning
	 */
	public class ItemAddedEvent extends CustomEvent
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
		 * @productversion Royale 0.0
		 */
		public function ItemAddedEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
            COMPILE::SWF
            {
                super(type, bubbles, cancelable);                    
            }
            COMPILE::JS
            {
                super(type);
            }
			
			item = null;
		}
		
		/**
		 * The item being added.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10.2
		 * @playerversion AIR 2.6
		 * @productversion Royale 0.0
		 */
		public var item:Object;
		
		/**
		 * @private
		 */
		override public function cloneEvent():IRoyaleEvent
		{
			var newEvent:ItemAddedEvent = new ItemAddedEvent(type);
			newEvent.item = item;
			return newEvent;
		}
	}
}
