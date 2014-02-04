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
package org.apache.flex.html.staticControls.beads.controllers
{
	import flash.events.MouseEvent;
	
	import org.apache.flex.core.IBeadController;
	import org.apache.flex.core.IItemRenderer;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.events.Event;

	/**
	 *  The ItemRendererMouseController class bead handles mouse events in itemRenderers. This
	 *  includes roll-overs, mouse down, and mouse up. These platform-specific events are then
	 *  re-dispatched as FlexJS events.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
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
		
        private var renderer:IItemRenderer;
		private var _strand:IStrand;
		
		/**
		 * @private
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
            renderer = value as IItemRenderer;
            renderer.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
            renderer.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
            renderer.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		
		/**
		 * @private
		 */
		protected function rollOverHandler(event:MouseEvent):void
		{
			var target:IItemRenderer = event.target as IItemRenderer;
			if (target)
			{
                target.hovered = true;
				target.dispatchEvent(new Event("rollover",true));
			}
		}
		
		/**
		 * @private
		 */
		protected function rollOutHandler(event:MouseEvent):void
		{
			var target:IItemRenderer = event.target as IItemRenderer;
			if (target)
			{
                target.hovered = false;
                target.down = false;
			}
		}

		/**
		 * @private
		 */
		protected function mouseDownHandler(event:MouseEvent):void
		{
			var target:IItemRenderer = event.currentTarget as IItemRenderer;
			if (target)
			{
                target.down = true;
				target.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			}
		}
		
		/**
		 * @private
		 */
		protected function mouseUpHandler(event:MouseEvent):void
		{
			var target:IItemRenderer = event.currentTarget as IItemRenderer;
			if (target)
			{
                target.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);                
				target.selected = true;
				target.dispatchEvent(new Event("selected"));
			}			
		}
	
	}
}