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
package org.apache.flex.textLayout.beads
{
	
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.events.KeyboardEvent;
	import org.apache.flex.events.utils.KeyboardEventConverter;
	import org.apache.flex.text.events.TextEvent;
	import org.apache.flex.textLayout.events.FocusEvent;

	COMPILE::JS
	{
		import org.apache.flex.core.IRenderedObject;
		import goog.events;
	}
	
	COMPILE::SWF
	{
		import flash.events.Event;
		import flash.events.KeyboardEvent;
	}
	
	/**
	 *  The DispatchKeyboardEventBead class dispatched INPUT_FINISHED on strand
	 *  when enter is pressed, or when foucus is out.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class DispatchTLFKeyboardEventBead implements IBead
	{
		/**
		 *  constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function DispatchTLFKeyboardEventBead()
		{
		}			
		
		private var _strand:IStrand;
		
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			COMPILE::SWF
			{
				if (!attachEventListeners())
				{
					(_strand as IEventDispatcher).addEventListener("viewChanged", viewChangedHandler);
				}
			}
			COMPILE::JS
			{
				(_strand as Object).element.addEventListener('keydown', keyEventHandler);
				(_strand as Object).element.addEventListener('keyup', keyEventHandler);
			}
		}
		
		
		/**
		 * @private
		 */
		COMPILE::SWF
		private function viewChangedHandler(e:org.apache.flex.events.Event):void
		{
			attachEventListeners();
		}
		
		/**
		 * @private
		 */
		COMPILE::SWF
		private function attachEventListeners():Boolean
		{
			var host:UIBase = _strand as UIBase;
			host.$displayObject.addEventListener(flash.events.KeyboardEvent.KEY_DOWN, keyEventHandler);
			host.$displayObject.addEventListener(flash.events.TextEvent.TEXT_INPUT, textEventHandler);
			host.$displayObject.addEventListener(flash.events.KeyboardEvent.KEY_UP, keyEventHandler);
			host.$displayObject.addEventListener(flash.events.Event.ACTIVATE, eventHandler);
			host.$displayObject.addEventListener(flash.events.Event.DEACTIVATE, eventHandler);
			host.$displayObject.addEventListener(flash.events.FocusEvent.FOCUS_IN, focusEventHandler);
			host.$displayObject.addEventListener(flash.events.FocusEvent.FOCUS_OUT, focusEventHandler);
			return true;
		}
		
		/**
		 * @private
		 */
		COMPILE::SWF
		protected function textEventHandler(event:flash.events.TextEvent):void
		{
			// this will otherwise bubble an event of flash.events.Event
			event.stopImmediatePropagation();
			var newEvent:org.apache.flex.text.events.TextEvent = new org.apache.flex.text.events.TextEvent(event.type);
			newEvent.text = event.text;
			(_strand as IEventDispatcher).dispatchEvent(newEvent);
			if(newEvent.defaultPrevented)
			{
				event.preventDefault();
			}
			
			
		}
				
		/**
		 * @private
		 */
		COMPILE::SWF
		protected function keyEventHandler(event:flash.events.KeyboardEvent):void
		{
			// this will otherwise bubble an event of flash.events.Event
			event.stopImmediatePropagation();
			var newEvent:org.apache.flex.events.KeyboardEvent = KeyboardEventConverter.convert(event);
			(_strand as IEventDispatcher).dispatchEvent(newEvent);
			if(newEvent.defaultPrevented)
			{
				event.preventDefault();
			}
			
			
		}
		
		/**
		 * @private
		 */
		COMPILE::SWF
		protected function eventHandler(event:flash.events.Event):void
		{
			if (event is org.apache.flex.events.Event) return;
			
			// this will otherwise dispatch an event of flash.events.Event
			event.stopImmediatePropagation();
			var newEvent:org.apache.flex.events.Event = new org.apache.flex.events.Event(event.type);
			(_strand as IEventDispatcher).dispatchEvent(newEvent);
			if(newEvent.defaultPrevented)
			{
				event.preventDefault();
			}
		}

		/**
		 * @private
		 */
		COMPILE::SWF
		protected function focusEventHandler(event:flash.events.FocusEvent):void
		{
			if (event is org.apache.flex.events.Event) return;
			
			trace(event.type, event.target, event.relatedObject);
			// this will otherwise dispatch an event of flash.events.FocusEvent
			event.stopImmediatePropagation();
			var newEvent:org.apache.flex.textLayout.events.FocusEvent = new org.apache.flex.textLayout.events.FocusEvent(event.type);
			(_strand as IEventDispatcher).dispatchEvent(newEvent);
			if(newEvent.defaultPrevented)
			{
				event.preventDefault();
			}
		}
		
		/**
		 * @private
		 */
		COMPILE::JS
		protected function keyEventHandler(event:KeyboardEvent):void
		{
			event.stopImmediatePropagation();
			var newEvent:org.apache.flex.events.KeyboardEvent = KeyboardEventConverter.convert(event);
			(_strand as IEventDispatcher).dispatchEvent(newEvent);
			if(newEvent.defaultPrevented)
			{
				event.preventDefault();
			}
		}
		
	}
}
