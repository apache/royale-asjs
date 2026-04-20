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
 
	COMPILE::JS
	{
		import org.apache.royale.core.WrappedHTMLElement;
	}
		import org.apache.royale.core.IChild;
		import org.apache.royale.events.Event;
		import org.apache.royale.events.MouseEvent;
		import org.apache.royale.style.elements.Summary;
		import org.apache.royale.style.skins.IAccordionSectionSkin;
		import org.apache.royale.debugging.assert;
		import org.apache.royale.style.skins.AccordionSectionSkin;

	[Event(name="openChanged", type="org.apache.royale.events.Event")]

	public class AccordionSection extends Group
	{
		public function AccordionSection()
		{
			super();
		}

		private var _headerText:String;

		public function get headerText():String
		{
			return headerElem.text;
		}

		public function set headerText(value:String):void
		{
			headerElem.text = value;
		}
		private var _disabled:Boolean = false;

		public function get disabled():Boolean
		{
			return _disabled;
		}

		public function set disabled(value:Boolean):void
		{
			if(value != _disabled){
				_disabled = value;

			toggleAttribute("data-disabled", value);
			headerElem.toggleAttribute("data-disabled", value);
			}
		}
		private var _open:Boolean = false;

		public function get open():Boolean
		{
			return _open;
		}

		public function set open(value:Boolean):void
		{
			if(value != _open){
				_open = value;
				toggleAttribute("open", value);
				if(headerIcon){
					headerIcon.toggleAttribute("data-open", value);
				}
				dispatchEvent(new Event("openChanged"));
			}
		}
		private function toggleSection(ev:MouseEvent):void{
			if(!disabled){
				ev.stopPropagation();
				ev.preventDefault();
				open = !open;
			}
		}
		/**
		 * modify the following methods to ignore the header element
		 */
		override public function get numElements():int{
			return super.numElements -1;
		}
		override public function addElementAt(c:IChild, index:int, dispatchEvent:Boolean = true):void{
			super.addElementAt(c,index+1,dispatchEvent);
		}
		override public function getElementAt(index:int):IChild{
			return super.getElementAt(index+1);
		}
		override public function getElementIndex(c:IChild):int{
			return super.getElementIndex(c) + 1;
		}

		protected var headerElem:Summary;
		
		protected var headerIcon:IStyleUIBase;
		/**
		 * @royaleignorecoercion org.apache.royale.style.skins.IAccordionSectionSkin
		 */
		override protected function applySkin():void
		{
			super.applySkin();
			assert(skin, "AccordionSection requires a skin that implements IAccordionSectionSkin");
			headerElem.setStyles((skin as IAccordionSectionSkin).headerStyles);
			var icon:IStyleUIBase = (skin as IAccordionSectionSkin).getIcon();
			if(icon){
				headerIcon = icon;
				headerElem.addElement(headerIcon);
				if(open)
					headerIcon.toggleAttribute("data-open", true);
			}
		}

		override protected function getTag():String
		{
			return "details";
		}

		COMPILE::JS
		override protected function createElement():WrappedHTMLElement{
			super.createElement();
			headerElem = new Summary();
			headerElem.text = '';
			headerElem.addEventListener("click",toggleSection);
			addElement(headerElem);

			return element;
		}

	}
}
/**
                <details class="group border-b border-slate-300 bg-slate-50 px-4 last:border-b-0 dark:border-slate-700 dark:bg-slate-800" name="my-accordion-join-1" open>
                  <summary class="flex cursor-pointer list-none items-center justify-between py-3 text-sm font-semibold">How do I create an account?<div class="h-4 w-4 text-slate-500 transition-transform duration-200 group-open:rotate-90"><svg viewBox="0 0 20 20" fill="none" stroke="currentColor" stroke-width="2"><path d="M7 5l5 5-5 5" stroke-linecap="round" stroke-linejoin="round"/></svg></div></summary>
                  <div class="pb-3 text-sm text-slate-600 dark:text-slate-300">Click the "Sign Up" button in the top right corner and follow the registration process.</div>
                </details>

 */