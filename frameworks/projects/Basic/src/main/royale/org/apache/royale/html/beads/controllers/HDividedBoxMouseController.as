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
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IBeadController;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.html.beads.models.DividedBoxModel;
	import org.apache.royale.html.supportClasses.DividedBoxDivider;
	
	/**
	 * This is the mouse controller for the HDividedBox. This bead class tracks the
	 * mouse over a HDividedBoxDivider (its strand) causing the columns on either side
	 * of the divider to grow and shrink.
	 */
	public class HDividedBoxMouseController implements IBead, IBeadController
	{
		/**
		 * Constructor
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function HDividedBoxMouseController()
		{
		}
		
		private var _strand:IStrand;
		
		/**
		 * @copy org.apache.royale.core.IStrand#strand
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			(_strand as IEventDispatcher).addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
		}
		
		private var deltaMove:Number = 0;
		private var lastPosition:Number = 0;
		
		/**
		 * @private
		 */
		private function handleMouseDown(event:MouseEvent):void
		{
			COMPILE::JS {
				// this stops the cursor from changing into an I-Beam
				event.preventDefault();
			}
			lastPosition = event.screenX;
			deltaMove = 0;
			//trace("* HDividedBoxMouseController: anchor at "+lastPosition);
			
			IUIBase(_strand).topMostEventDispatcher.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			IUIBase(_strand).topMostEventDispatcher.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
			
		}
		
		/**
		 * @private
		 */
		private function handleMouseMove(event:MouseEvent):void
		{
			//trace("--- mouse moving by "+(event.screenX - lastPosition));
			deltaMove = event.screenX - lastPosition;
			
			var model:DividedBoxModel = (_strand as UIBase).model as DividedBoxModel;
			var pairIndex:int = (_strand as DividedBoxDivider).pairIndex;
			
			model.addPairAdjustment(deltaMove, pairIndex);
			
			lastPosition = event.screenX;
		}
		
		/**
		 * @private
		 */
		private function handleMouseUp(event:MouseEvent):void
		{
			deltaMove = event.screenX - lastPosition;
			//trace("* HDividedBoxMouseController: up at "+event.screenX+" delta of "+deltaMove);
			
			IUIBase(_strand).topMostEventDispatcher.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			IUIBase(_strand).topMostEventDispatcher.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
			
			var model:DividedBoxModel = (_strand as UIBase).model as DividedBoxModel;
			var pairIndex:int = (_strand as DividedBoxDivider).pairIndex;
			
			model.addPairAdjustment(deltaMove, pairIndex);
		}
	}
}