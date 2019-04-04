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
	import org.apache.royale.core.ISelectableItemRenderer;
	import org.apache.royale.core.IStrand;
COMPILE::SWF {
	import org.apache.royale.events.Event;
	import org.apache.royale.events.MouseEvent;
}
COMPILE::JS {
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.WrappedHTMLElement;
	import org.apache.royale.events.BrowserEvent;
	import goog.events.Event;
	import goog.events.EventType;
    import goog.events;
}
	import org.apache.royale.events.ItemClickedEvent;

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
		
        private var renderer:ISelectableItemRenderer;
		private var _strand:IStrand;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 *  @royaleignorecoercion org.apache.royale.core.ISelectableItemRenderer
		 *  @royaleignorecoercion org.apache.royale.core.UIBase
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
            renderer = value as ISelectableItemRenderer;
			
			COMPILE::SWF {
	            renderer.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
	            renderer.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
				renderer.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				renderer.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			}
				
			COMPILE::JS {
				var element:WrappedHTMLElement = (_strand as UIBase).element;
				
				goog.events.listen(element, goog.events.EventType.MOUSEOVER, this.handleMouseOver);
				goog.events.listen(element, goog.events.EventType.MOUSEOUT, this.handleMouseOut);
				goog.events.listen(element, goog.events.EventType.MOUSEDOWN, this.handleMouseDown);
				goog.events.listen(element, goog.events.EventType.CLICK, this.handleMouseClick);
                goog.events.listen(element, goog.events.EventType.MOUSEUP, this.handleMouseUp);
			}
		}
		
		/**
		 * @private
		 */
		COMPILE::SWF
		protected function rollOverHandler(event:MouseEvent):void
		{
			var target:ISelectableItemRenderer = event.currentTarget as ISelectableItemRenderer;
			if (target)
			{
				target.dispatchEvent(new Event("itemRollOver",true));
			}
		}
		
		/**
		 * @royaleemitcoercion org.apache.royale.core.ISelectableItemRenderer
		 */
		COMPILE::JS
		protected function handleMouseOver(event:BrowserEvent):void
		{
			var target:ISelectableItemRenderer = event.currentTarget as ISelectableItemRenderer;
			if (target) {
				target.dispatchEvent(new Event("itemRollOver",true));
			}
		}
		
		/**
		 * @private
		 */
		COMPILE::SWF
		protected function rollOutHandler(event:MouseEvent):void
		{
			var target:ISelectableItemRenderer = event.currentTarget as ISelectableItemRenderer;
			if (target)
			{
				target.dispatchEvent(new Event("itemRollOut",true));
			}
		}
		
		/**
		 * @royaleemitcoercion org.apache.royale.core.ISelectableItemRenderer
		 */
		COMPILE::JS
		protected function handleMouseOut(event:BrowserEvent):void
		{
			var target:ISelectableItemRenderer = event.currentTarget as ISelectableItemRenderer;
			if (target)
			{
				target.dispatchEvent(new Event("itemRollOut",true));
			}
		}

		/**
		 * @private
		 */
		COMPILE::SWF
		protected function mouseDownHandler(event:MouseEvent):void
		{
			var target:ISelectableItemRenderer = event.currentTarget as ISelectableItemRenderer;
			if (target)
			{
                target.down = true;
                
                var newEvent:ItemClickedEvent = new ItemClickedEvent("itemMouseDown");
                newEvent.data = target.data;
                newEvent.multipleSelection = event.shiftKey;
                newEvent.index = target.index;
                
                target.dispatchEvent(newEvent);
				target.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			}
		}
		
		/**
		 * @private
		 * @royaleemitcoercion org.apache.royale.core.ISelectableItemRenderer
		 */
		COMPILE::JS
		protected function handleMouseDown(event:BrowserEvent):void
		{
			var target:ISelectableItemRenderer = event.currentTarget as ISelectableItemRenderer;
			if (target)
			{
				target.down = true;
				target.hovered = false;

				var newEvent:ItemClickedEvent = new ItemClickedEvent("itemMouseDown");
				newEvent.data = target.data;
				newEvent.multipleSelection = event.shiftKey;
				newEvent.index = target.index;

				target.dispatchEvent(newEvent);
			}
		}
		
		/**
		 * @private
		 */
		COMPILE::SWF
		protected function mouseUpHandler(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			var target:ISelectableItemRenderer = event.currentTarget as ISelectableItemRenderer;
			if (target)
			{				
				var newEvent:ItemClickedEvent = new ItemClickedEvent("itemClicked");
				newEvent.data = target.data;
				newEvent.multipleSelection = event.shiftKey;
				newEvent.index = target.index;
				
                target.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);                
				target.dispatchEvent(newEvent);
			}			
		}
		
		/**
		 * @private
		 * @royaleemitcoercion org.apache.royale.core.ISelectableItemRenderer
		 */
		COMPILE::JS
		protected function handleMouseClick(event:BrowserEvent):void
		{
			var target:ISelectableItemRenderer = event.currentTarget as ISelectableItemRenderer;
			if (target)
			{
				var newEvent:ItemClickedEvent = new ItemClickedEvent("itemClicked");
				newEvent.data = target.data;
				newEvent.multipleSelection = event.shiftKey;
				newEvent.index = target.index;

				target.dispatchEvent(newEvent);
			}
		}

		/**
		 * @private
		 * @royaleemitcoercion org.apache.royale.core.ISelectableItemRenderer
		 */
		COMPILE::JS
		protected function handleMouseUp(event:BrowserEvent):void
		{
			var target:ISelectableItemRenderer = event.currentTarget as ISelectableItemRenderer;
			if (target)
			{
				var newEvent:ItemClickedEvent = new ItemClickedEvent("itemMouseUp");
				newEvent.data = target.data;
				newEvent.multipleSelection = event.shiftKey;
				newEvent.index = target.index;

				target.dispatchEvent(newEvent);
			}
		}

	}
}
