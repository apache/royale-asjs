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
package org.apache.flex.html.beads
{
	
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.events.KeyboardEvent;
	import org.apache.flex.events.utils.KeyboardEventConverter;
	
	COMPILE::JS
	{
		import org.apache.flex.core.IRenderedObject;
		import goog.events;
	}
	
	COMPILE::SWF
	{
		import flash.events.KeyboardEvent;
		import org.apache.flex.html.beads.ITextFieldView;
	}
	
	/**
	 *  The DispatchKeyboardEventBead class dispatches a KeyboardEvent from a text input.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class DispatchKeyboardEventBead implements IBead
	{
		/**
		 *  constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function DispatchKeyboardEventBead()
		{
		}			
		
		private var _strand:IStrand;
		
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
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
		private function viewChangedHandler(e:Event):void
		{
			attachEventListeners();
		}
		
		/**
		 * @private
		 */
		COMPILE::SWF
		private function attachEventListeners():Boolean
		{
			var viewBead:ITextFieldView = _strand.getBeadByType(ITextFieldView) as ITextFieldView;
			if (!viewBead) return false;
			viewBead.textField.addEventListener(flash.events.KeyboardEvent.KEY_DOWN, keyEventHandler);
			viewBead.textField.addEventListener(flash.events.KeyboardEvent.KEY_UP, keyEventHandler);
			return true;
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
