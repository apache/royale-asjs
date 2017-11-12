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
	
	
	/**
	 *  Represents events that are dispatched when the TextFlow does automatic scrolling.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 1.0.0
	 */
	public class ScrollEvent extends TextLayoutEvent
	{
		//--------------------------------------------------------------------------
		//
		// Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * 
		 *  Scroll events are dispatched when a container has scrolled. 
		 *
		 *  @param type The event type; indicates the action that caused the event.
		 *
		 *  @param bubbles Specifies whether the event can bubble
		 *  up the display list hierarchy.
		 *
		 *  @param cancelable Specifies whether the behavior associated with the event
		 *  can be prevented.
		 *
		 *
		 *  @param delta The change in scroll position, expressed in pixels.
		 *  
		 */
		public function ScrollEvent(type:String, bubbles:Boolean = false,
									cancelable:Boolean = false,
									direction:String = null, delta:Number = NaN)
		{
			super(type, bubbles, cancelable);
			
			this.direction = direction;
			this.delta = delta;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  delta
		//----------------------------------
		
		/**
		 *  The change in the scroll position value that resulted from 
		 *  the scroll. The value is expressed in pixels. A positive value indicates the 
		 *  scroll was down or to the right. A negative value indicates the scroll  
		 * 	was up or to the left.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 */
		public var delta:Number;
		
		//----------------------------------
		//  direction
		//----------------------------------
		
		/**
		 *  The direction of motion.
		 *  The possible values are <code>ScrollEventDirection.VERTICAL</code>
		 *  or <code>ScrollEventDirection.HORIZONTAL</code>.
		 *
		 *  @see org.apache.royale.textLayout.events.ScrollEventDirection
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 */
		public var direction:String;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods: Event
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		override public function cloneEvent():IRoyaleEvent
		{
			return new ScrollEvent(type, bubbles, cancelable, direction, delta);
		}
	}
	
}
