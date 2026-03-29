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
package org.apache.royale.style
{

	import org.apache.royale.core.IChild;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.Event;

	public class Accordion extends Group
	{
		public function Accordion()
		{
			super();
		}

		private var _allowMultiple:Boolean;
		/**
		 * Whether or not multiple items can be open at once.
		 */
		public function get allowMultiple():Boolean
		{
			return _allowMultiple;
		}
		public function set allowMultiple(value:Boolean):void
		{
			_allowMultiple = value;
		}

		/**
		 * @royaleemitcoercion org.apache.royale.style.AccordionSection
		 */
		override public function addElement(c:IChild, dispatchEvent:Boolean = true):void
		{
			super.addElement(c,dispatchEvent);
			attachListeners(c);
		}
		/**
		 * @royaleemitcoercion org.apache.royale.style.AccordionSection
		 */
		override public function addElementAt(c:IChild, index:int, dispatchEvent:Boolean = true):void
		{
			super.addElementAt(c,index,dispatchEvent);
			attachListeners(c);
		}
		/**
		 * @royaleemitcoercion org.apache.royale.style.AccordionSection
		 */
		private function attachListeners(c:IChild):void
		{
			if(c is AccordionSection){
				(c as IEventDispatcher).addEventListener("openChanged",sectionChangeHandler);
			}
		}
		override public function removeElement(c:IChild, dispatchEvent:Boolean = true):void
		{
			super.removeElement(c,dispatchEvent);
			if(c is AccordionSection){
				(c as IEventDispatcher).removeEventListener("openChanged",sectionChangeHandler);
			}
		}

		private function sectionChangeHandler(ev:Event):void{
			var section:AccordionSection = ev.target as AccordionSection;
			if(allowMultiple || !section.open)
				return;

			for(var i:int=0;i<numElements;i++){
				var child:AccordionSection = getElementAt(i) as AccordionSection;
				if(child != section){
					child.open = false;
				}
			}
		}

	}
}
/**
              <div class="overflow-hidden rounded-xl border border-slate-300 dark:border-slate-700">
                <details class="group border-b border-slate-300 bg-slate-50 px-4 last:border-b-0 dark:border-slate-700 dark:bg-slate-800" name="my-accordion-join-1" open>
                  <summary class="flex cursor-pointer list-none items-center justify-between py-3 text-sm font-semibold">How do I create an account?<div class="h-4 w-4 text-slate-500 transition-transform duration-200 group-open:rotate-90"><svg viewBox="0 0 20 20" fill="none" stroke="currentColor" stroke-width="2"><path d="M7 5l5 5-5 5" stroke-linecap="round" stroke-linejoin="round"/></svg></div></summary>
                  <div class="pb-3 text-sm text-slate-600 dark:text-slate-300">Click the "Sign Up" button in the top right corner and follow the registration process.</div>
                </details>
              </div>

 */