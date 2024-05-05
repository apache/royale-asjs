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
	COMPILE::SWF {
	import org.apache.royale.events.MouseEvent;
	}
	COMPILE::JS {
	import goog.events;
	import goog.events.Event;
	import goog.events.EventType;

	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.WrappedHTMLElement;
	import org.apache.royale.events.BrowserEvent;
	}
	import org.apache.royale.core.IBeadController;
	import org.apache.royale.core.IIndexedItemRenderer;
	import org.apache.royale.core.ISelectableItemRenderer;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.ItemClickedEvent;
	import org.apache.royale.events.Event;
	import org.apache.royale.utils.getSelectionRenderBead;
	import org.apache.royale.utils.sendEvent;

	/**
	 *  The ItemRendererMouseController class can mouse events in itemRenderers. This
	 *  includes roll-overs, mouse down, and mouse up. These platform-specific events are then
	 *  re-dispatched as Royale events.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 *  @royaleignoreimport goog.events.Event
	 */
	public class ItemRendererMouseController implements IBeadController
	{
		/**
		 *  constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function ItemRendererMouseController()
		{
		}
		
		private var renderer:IIndexedItemRenderer;
		private var _strand:IStrand;

		//default behavior, allow overrides
		protected function get setDownState():Boolean{
			return true;
		}


		//utility methods to avoid duplicated code:
		/**
		 * @royaleemitcoercion org.apache.royale.core.IIndexedItemRenderer
		 */
		COMPILE::JS
		protected function getTarget(event:org.apache.royale.events.Event):IIndexedItemRenderer{
			return event.currentTarget as IIndexedItemRenderer;
		}


		//utility methods to avoid duplicated code:
		/**
		 * @royaleemitcoercion org.apache.royale.core.IIndexedItemRenderer
		 */
		COMPILE::SWF
		protected function getTarget(event:org.apache.royale.events.MouseEvent):IIndexedItemRenderer{
			return event.currentTarget as IIndexedItemRenderer;
		}
		
		protected function sendICE(target:IIndexedItemRenderer, eventType:String, details:Boolean):void{
			var newEvent:ItemClickedEvent = new ItemClickedEvent(eventType);
			if (details) {
				newEvent.data = target.data;
				newEvent.index = target.index;
			}
			sendEvent(target,newEvent);
		}
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 *  @royaleignorecoercion org.apache.royale.core.IIndexedItemRenderer
		 *  @royaleignorecoercion org.apache.royale.core.UIBase
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			renderer = value as IIndexedItemRenderer;
			
			COMPILE::SWF {
				renderer.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
				renderer.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
				renderer.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				renderer.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			}
				
			COMPILE::JS {
				var positioner:WrappedHTMLElement = (_strand as UIBase).positioner;
				
				goog.events.listen(positioner, goog.events.EventType.MOUSEENTER, this.handleMouseOver);
				goog.events.listen(positioner, goog.events.EventType.MOUSELEAVE, this.handleMouseOut);
				goog.events.listen(positioner, goog.events.EventType.MOUSEDOWN, this.handleMouseDown);
				goog.events.listen(positioner, goog.events.EventType.CLICK, this.handleMouseClick);
				goog.events.listen(positioner, goog.events.EventType.MOUSEUP, this.handleMouseUp);
			}
		}
		
		/**
		 * @private
		 */
		COMPILE::SWF
		protected function rollOverHandler(event:MouseEvent):void
		{
			var target:IIndexedItemRenderer = getTarget(event);
			if (target)
			{
				sendEvent(target,new Event("itemRollOver",true));
			}
		}
		
		/**
		 * 
		 * @royaleignorecoercion org.apache.royale.events.Event
		 */
		COMPILE::JS
		protected function handleMouseOver(event:BrowserEvent):void
		{
			var target:IIndexedItemRenderer = getTarget(event as org.apache.royale.events.Event);
			if (target) {
				sendEvent(target,new org.apache.royale.events.Event("itemRollOver",true));
			}
		}
		
		/**
		 * @private
		 */
		COMPILE::SWF
		protected function rollOutHandler(event:MouseEvent):void
		{
			var target:IIndexedItemRenderer = getTarget(event);
			if (target)
			{
				sendEvent(target,new Event("itemRollOut",true));
			}
		}
		
		/**
		 * @royaleignorecoercion org.apache.royale.events.Event
		 */
		COMPILE::JS
		protected function handleMouseOut(event:BrowserEvent):void
		{
			var target:IIndexedItemRenderer = getTarget(event as org.apache.royale.events.Event);
			if (target)
			{
				sendEvent(target,new org.apache.royale.events.Event("itemRollOut",true));
			}
		}

		/**
		 * @private
		 */
		COMPILE::SWF
		protected function mouseDownHandler(event:MouseEvent):void
		{
			var target:IIndexedItemRenderer = getTarget(event);
			if (target)
			{
				if (setDownState) {
					var selectionBead:ISelectableItemRenderer = getSelectionRenderBead(renderer);
					if (selectionBead)
						selectionBead.down = true;
				}

				sendICE(target, "itemMouseDown", true);
				/*var newEvent:ItemClickedEvent = new ItemClickedEvent("itemMouseDown");
				newEvent.data = target.data;
				newEvent.index = target.index;
				sendEvent(target,newEvent);*/
				target.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			}
		}
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.events.Event
		 */
		COMPILE::JS
		protected function handleMouseDown(event:BrowserEvent):void
		{
			var target:IIndexedItemRenderer = getTarget(event as org.apache.royale.events.Event);
			if (target)
			{
				if (setDownState) {
					var selectionBead:ISelectableItemRenderer = getSelectionRenderBead(renderer);
					if (selectionBead)
					{
						selectionBead.down = true;
						//selectionBead.hovered = false;
					}
				}


				sendICE(target, "itemMouseDown", true);
				/*var newEvent:ItemClickedEvent = new ItemClickedEvent("itemMouseDown");
				newEvent.data = target.data;
				newEvent.index = target.index;
				sendEvent(target,newEvent);*/
			}
		}
		
		/**
		 * @private
		 */
		COMPILE::SWF
		protected function mouseUpHandler(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			var target:IIndexedItemRenderer = event.currentTarget as IIndexedItemRenderer;
			if (target)
			{				
				/*var newEvent:ItemClickedEvent = new ItemClickedEvent("itemClicked");
				newEvent.data = target.data;
				newEvent.index = target.index;*/
				
				target.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);

				sendICE(target, "itemClicked", true);
				
				//sendEvent(target,newEvent);
			}			
		}
		
		/**
		 * @private
		 * @royaleemitcoercion org.apache.royale.core.IIndexedItemRenderer
		 */
		COMPILE::JS
		protected function handleMouseClick(event:BrowserEvent):void
		{
			var target:IIndexedItemRenderer = event.currentTarget as IIndexedItemRenderer;
			if (target)
			{
				/*var newEvent:ItemClickedEvent = new ItemClickedEvent("itemClicked");
				newEvent.data = target.data;
				newEvent.index = target.index;

				sendEvent(target,newEvent);*/
				sendICE(target, "itemClicked", true);
			}
		}

		/**
		 * @private
		 * @royaleemitcoercion org.apache.royale.core.IIndexedItemRenderer
		 */
		COMPILE::JS
		protected function handleMouseUp(event:BrowserEvent):void
		{
			var target:IIndexedItemRenderer = event.currentTarget as IIndexedItemRenderer;
			if (target)
			{
				/*var newEvent:ItemClickedEvent = new ItemClickedEvent("itemMouseUp");
				newEvent.data = target.data;
				newEvent.index = target.index;

				sendEvent(target,newEvent);*/
				sendICE(target, "itemMouseUp", true);
			}
			
		}

	}
}
