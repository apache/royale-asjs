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
	import org.apache.royale.core.IItemRenderer;
	import org.apache.royale.events.CustomEvent;
	
	/**
	 * The ItemRendererEvent is dispatched by DataItemRendererFactory classes under
	 * various conditions.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10.2
	 * @playerversion AIR 2.6
	 * @productversion Royale 0.0
     * 
     *  @royalesuppresspublicvarwarning
	 */
	public class ItemRendererEvent extends CustomEvent
	{
		// dispatched when a new itemRenderer has been created and added to the IItemRendererOwnerView.
		static public const CREATED:String = "itemRendererCreated";
		
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
		public function ItemRendererEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
            COMPILE::SWF
            {
                super(type, bubbles, cancelable);                    
            }
            COMPILE::JS
            {
                super(type);
            }
			
			itemRenderer = null;
		}
		
		/**
		 * The itemRenderer that has been created.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10.2
		 * @playerversion AIR 2.6
		 * @productversion Royale 0.0
		 */
		public var itemRenderer:IItemRenderer;
		
		/**
		 * @private
		 */
		override public function cloneEvent():IRoyaleEvent
		{
			var newEvent:ItemRendererEvent = new ItemRendererEvent(type);
			newEvent.itemRenderer = itemRenderer;
			return newEvent;
		}
	}
}