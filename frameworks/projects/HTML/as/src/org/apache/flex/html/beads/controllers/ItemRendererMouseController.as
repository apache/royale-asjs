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
package org.apache.flex.html.beads.controllers
{
	import org.apache.flex.core.IBeadController;
	import org.apache.flex.core.ISelectableItemRenderer;
	import org.apache.flex.core.IStrand;
COMPILE::AS3 {
	import org.apache.flex.events.Event;
	import org.apache.flex.events.MouseEvent;
}
COMPILE::JS {
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.WrappedHTMLElement;
	import org.apache.flex.events.BrowserEvent;
	import goog.events.Event;
	import goog.events.EventType;
    import goog.events;
}
	import org.apache.flex.events.ItemClickedEvent;

	/**
	 *  The ItemRendererMouseController class can mouse events in itemRenderers. This
	 *  includes roll-overs, mouse down, and mouse up. These platform-specific events are then
	 *  re-dispatched as FlexJS events.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 *  @flexjsignoreimport goog.events.Event
	 */
	public class ItemRendererMouseController implements IBeadController
	{
		/**
		 *  constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function ItemRendererMouseController()
		{
		}
		
        private var renderer:ISelectableItemRenderer;
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
            renderer = value as ISelectableItemRenderer;
			
			COMPILE::AS3 {
	            renderer.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
	            renderer.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
	            renderer.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			}
				
			COMPILE::JS {
				var element:WrappedHTMLElement = (_strand as UIBase).element;
				
				goog.events.listen(element, goog.events.EventType.MOUSEOVER, this.handleMouseOver);
				goog.events.listen(element, goog.events.EventType.MOUSEOUT, this.handleMouseOut);
				goog.events.listen(element, goog.events.EventType.MOUSEDOWN, this.handleMouseDown);
				goog.events.listen(element, goog.events.EventType.MOUSEUP, this.handleMouseUp);
			}
		}
		
		/**
		 * @private
		 */
		COMPILE::AS3
		protected function rollOverHandler(event:MouseEvent):void
		{
			var target:ISelectableItemRenderer = event.target as ISelectableItemRenderer;
			if (target)
			{
				target.dispatchEvent(new Event("itemRollOver",true));
			}
		}
		
		COMPILE::JS
		protected function handleMouseOver(event:BrowserEvent):void
		{
			var target:ISelectableItemRenderer = event.target as ISelectableItemRenderer;
			if (target) {
				target.dispatchEvent(new Event("itemRollOver",true));
			}
		}
		
		/**
		 * @private
		 */
		COMPILE::AS3
		protected function rollOutHandler(event:MouseEvent):void
		{
			var target:ISelectableItemRenderer = event.target as ISelectableItemRenderer;
			if (target)
			{
				target.dispatchEvent(new Event("itemRollOut",true));
			}
		}
		
		COMPILE::JS
		protected function handleMouseOut(event:BrowserEvent):void
		{
			var target:ISelectableItemRenderer = event.target as ISelectableItemRenderer;
			if (target)
			{
				target.dispatchEvent(new Event("itemRollOut",true));
			}
		}

		/**
		 * @private
		 */
		COMPILE::AS3
		protected function mouseDownHandler(event:MouseEvent):void
		{
			var target:ISelectableItemRenderer = event.currentTarget as ISelectableItemRenderer;
			if (target)
			{
                target.down = true;
				target.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			}
		}
		
		/**
		 * @private
		 */
		COMPILE::JS
		protected function handleMouseDown(event:BrowserEvent):void
		{
			var target:ISelectableItemRenderer = event.currentTarget as ISelectableItemRenderer;
			if (target)
			{
				target.down = true;
				target.hovered = false;
			}
		}
		
		/**
		 * @private
		 */
		COMPILE::AS3
		protected function mouseUpHandler(event:MouseEvent):void
		{
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
		 */
		COMPILE::JS
		protected function handleMouseUp(event:BrowserEvent):void
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
	
	}
}
