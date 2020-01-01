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
package org.apache.royale.html.beads.controllers
{
	import org.apache.royale.core.IBeadController;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.ItemClickedEvent;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.html.supportClasses.AccordionItemRenderer;
	import org.apache.royale.utils.sendEvent;
	
	public class AccordionItemRendererMouseController implements IBeadController
	{
		private var _strand:IStrand;
		
		public function AccordionItemRendererMouseController()
		{
		}
		
		private function get accordionItemRenderer():AccordionItemRenderer
		{
			return _strand as AccordionItemRenderer;		
		}
		
		public function get strand():IStrand
		{
			return _strand;
		}

		public function set strand(value:IStrand):void
		{
			_strand = value;
			accordionItemRenderer.titleBar.addEventListener(MouseEvent.CLICK, titleBarClickHandler);
			accordionItemRenderer.titleBar.addEventListener(MouseEvent.ROLL_OVER, titleRollHandler);
			accordionItemRenderer.titleBar.addEventListener(MouseEvent.ROLL_OUT, titleRollHandler);
		}
		
		protected function titleRollHandler(event:MouseEvent):void
		{
			var type:String = event.type == MouseEvent.ROLL_OVER ? "itemRollOver" : "itemRollOut";
			sendEvent(accordionItemRenderer,type);
		}
		
		protected function titleBarClickHandler(event:MouseEvent):void
		{
			var newEvent:ItemClickedEvent = new ItemClickedEvent("itemClicked");
			newEvent.data = accordionItemRenderer.data;
			newEvent.index = accordionItemRenderer.index;
			sendEvent(accordionItemRenderer,newEvent);
		}
	}
}
