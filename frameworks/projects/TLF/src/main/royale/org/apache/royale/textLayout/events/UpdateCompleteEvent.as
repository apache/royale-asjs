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
package org.apache.royale.textLayout.events
{
	import org.apache.royale.events.IRoyaleEvent;
	import org.apache.royale.events.Event;
	
	import org.apache.royale.textLayout.container.IContainerController;
	import org.apache.royale.textLayout.elements.ITextFlow;

	/** 
	 * A TextFlow instance dispatches this event after any of its containers completes 
	 * an update. Each text container has two states: composition and display. This 
	 * event notifies you when the display phase has ended. This provides an 
	 * opportunity to make any necessary changes to the container when it is ready to
	 * be displayed, but hasn't yet been painted to the screen.
	 * 
	 * @internal Note: the DamageEvent_example class contains a good example of 
	 * using the UpdateCompleteEvent, so I have included it as the class example
	 * instead of creating a new example. I've updated the description of the
	 * DamageEvent_example file to include prominent mention of the UpdateCompleteEvent.
	 *
	 * @see org.apache.royale.textLayout.elements.TextFlow 
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0 
	 */
	public class UpdateCompleteEvent extends Event
	{
	    /** 
	     * Defines the value of the <code>type</code> property of an <code>UpdateCompleteEvent</code> object 
	     * @playerversion Flash 10
	     * @playerversion AIR 1.5
	     * @langversion 3.0 
	     */
	    public static const UPDATE_COMPLETE:String = "updateComplete";
	    
	    /** @private */
	    private var _controller:IContainerController;
	    /** @private */
		private var _textFlow:ITextFlow;
		
		/** Constructor
		 * @param type event type - use the static property UPDATE_COMPLETE.
		 * @param bubbles Indicates whether an event is a bubbling event. This event does not bubble.
		 * @param cancelable Indicates whether the behavior associated with the event can be prevented.
		 * This event cannot be cancelled.
		 * @param controller The ContainerController whose container was updated
		 * @param textFlow The TextFlow which was updated
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 **/
		public function UpdateCompleteEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, textFlow:ITextFlow =  null, controller:IContainerController=null)
		{
			super(type, bubbles, cancelable);
			this.controller = controller;
			_textFlow = textFlow;
		}

      	/** @private */
		override public function cloneEvent():IRoyaleEvent
		{
			return new UpdateCompleteEvent(type, bubbles, cancelable, _textFlow, _controller);
		}

		/** 
		 * The controller of the container being updated
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 		 
		 */
		public function get controller():IContainerController
		{ return _controller; }
		public function set controller(c:IContainerController):void
		{ _controller = c; }
		
		
		/**
		 * TextFlow which has been updated. 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public  function get textFlow():ITextFlow
		{ return _textFlow; }
		public  function set textFlow(value:ITextFlow):void
		{ _textFlow = value; }
	}
}
