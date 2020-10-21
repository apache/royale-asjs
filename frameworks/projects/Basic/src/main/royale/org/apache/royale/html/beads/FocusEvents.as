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
package org.apache.royale.html.beads
{

	import org.apache.royale.core.DispatcherBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.FocusEvent;

	[Event(name='focusIn', type='org.apache.royale.events.FocusEvent')]
	[Event(name='focusOut', type='org.apache.royale.events.FocusEvent')]
	
	/**
	 *  The FocusEvents class is a specialty bead that can be used with
	 *  any focus enabled control. The bead places permits using
	 *  "focusIn" and "focusOut" in mxml documents
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class FocusEvents extends DispatcherBead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function FocusEvents()
		{
		}


		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion HTMLInputElement
		 *  @royaleignorecoercion org.apache.royale.core.UIBase;
		 */
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			COMPILE::JS
			{
			listenOnStrand("beadsAdded", beadsAddedHandler);
			}
			COMPILE::SWF
			{
				//@todo

			}
		}
		/**
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 *  @royaleignorecoercion org.apache.royale.core.IUIBase
		 */
		COMPILE::JS
		private function beadsAddedHandler(event:Event):void
		{
			IEventDispatcher(_strand).removeEventListener("beadsAdded", beadsAddedHandler);
			IUIBase(_strand).element.addEventListener('blur', onFocusEvent);
			IUIBase(_strand).element.addEventListener('focus', onFocusEvent);
		}

		/**
         *  Dispatch a normalized royale FocusEvent
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
		COMPILE::JS
		protected function onFocusEvent(event:FocusEvent):void
		{
			event.stopImmediatePropagation();
			var FE:org.apache.royale.events.FocusEvent
			if (event.type == 'blur') {
				FE = new org.apache.royale.events.FocusEvent('focusOut', false, false, _strand);
			} else {
				FE = new org.apache.royale.events.FocusEvent('focusIn', false, false, _strand);
			}
			dispatchEvent(FE);
			if(FE.defaultPrevented)
			{
				event.preventDefault();
			}
		}

	}
}