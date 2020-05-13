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

	import org.apache.royale.utils.OSUtils;
	COMPILE::JS
	{
		import org.apache.royale.events.BrowserEvent;
	}

	/**
	 * The MultiSelectionItemClickedEvent is a custom event issued by a multi selection itemRenderer to
	 * convey information about itself when it has determined that the
	 * event(s) happening to it constitute a 'click' on itself.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10.2
	 * @playerversion AIR 2.6
	 * @productversion Royale 0.0
	 * 
	 *  @royalesuppresspublicvarwarning
	 */
	public class MultiSelectionItemClickedEvent extends ItemClickedEvent
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
		 * @productversion Royale 0.9.7
		 */
		public function MultiSelectionItemClickedEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			COMPILE::SWF
			{
				super(type, bubbles, cancelable);                    
			}
			COMPILE::JS
			{
				super(type);
			}
		}


		/**
		 * Whether or not this click was done while holding the shift key
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10.2
		 * @playerversion AIR 2.6
		 * @productversion Royale 0.9.7
		 */

		public var shiftKey:Boolean;
		/**
		 * Whether or not this click was done while holding the control key
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10.2
		 * @playerversion AIR 2.6
		 * @productversion Royale 0.9.7
		 */
		public var ctrlKey:Boolean;


		override public function cloneEvent():IRoyaleEvent
		{
			var newEvent:MultiSelectionItemClickedEvent = new MultiSelectionItemClickedEvent(type);
			newEvent.index = index;
			newEvent.data = data;
			newEvent.shiftKey = shiftKey;
			newEvent.ctrlKey = ctrlKey;
			return newEvent;
		}

		/**
		 *  Factory for MultiSelectionItemClickedEvents.
		 *  
		 *  @param type The name of the event.
		 *  @param event The MouseEvent properties to copy into the MultiSelectionItemClickedEvent.
		 *  @return The new MultiSelectionItemClickedEvent.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 *  @royaleignorecoercion org.apache.royale.events.MultiSelectionItemClickedEvent
		 *  @royaleignorecoercion window.Event
		 *  @royaleignorecoercion Event
		 */
		COMPILE::JS
		public static function createMultiSelectionItemClickedEvent(type:String, event:BrowserEvent):MultiSelectionItemClickedEvent
		{
			var msice:MultiSelectionItemClickedEvent = new MultiSelectionItemClickedEvent(type, true, true);
			var ctrlKey:Boolean = OSUtils.getOS() == OSUtils.MAC_OS || OSUtils.getOS() == OSUtils.IOS_OS ? event.nativeEvent["metaKey"] : event.nativeEvent["ctrlKey"];
			msice.ctrlKey = ctrlKey;
			msice.shiftKey = event.nativeEvent["shiftKey"];
			return msice;
		}
	}
}
