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
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.html.beads.models.DividedContainerModel;
	import org.apache.royale.html.supportClasses.DividedContainerDivider;
	import org.apache.royale.core.Bead;

	/**
	 * This is the mouse controller for the VDividedContainer. This bead class tracks
	 * the mouse over a VDividedContainerDivider (its strand) causing the rows above
	 * and below it to grow and shrink.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	public class VDividedContainerMouseController extends Bead implements IBeadController
	{
		/**
		 * Constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function VDividedContainerMouseController()
		{
		}


		override public function set strand(value:IStrand):void
		{
			_strand = value;
			listenOnStrand(MouseEvent.MOUSE_DOWN, handleMouseDown);
		}

		private var deltaMove:Number = 0;
		private var lastPosition:Number = 0;

		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.core.IUIBase
		 */
		private function handleMouseDown(event:MouseEvent):void
		{
			COMPILE::JS {
				// this stops the cursor from changing into an I-Beam
				event.preventDefault();
			}
			lastPosition = event.screenY;
			deltaMove = 0;
			//trace("* VDividedContainerMouseController: anchor at "+lastPosition);

			(_strand as IUIBase).topMostEventDispatcher.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			(_strand as IUIBase).topMostEventDispatcher.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
		}

		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.html.supportClasses.DividedContainerDivider
		 * @royaleignorecoercion org.apache.royale.html.beads.models.DividedContainerModel
		 */
		private function handleMouseMove(event:MouseEvent):void
		{
			//trace("--- mouse moving by "+(event.screenY - lastPosition));
			deltaMove = event.screenY - lastPosition;
			var divider:DividedContainerDivider = _strand as DividedContainerDivider;
			var model:DividedContainerModel = divider.model as DividedContainerModel;
			var pairIndex:int = divider.pairIndex;

			model.addPairAdjustment(deltaMove, pairIndex);

			lastPosition = event.screenY;
		}

		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.core.IUIBase
		 * @royaleignorecoercion org.apache.royale.html.supportClasses.DividedContainerDivider
		 * @royaleignorecoercion org.apache.royale.html.beads.models.DividedContainerModel
		 */
		private function handleMouseUp(event:MouseEvent):void
		{
			deltaMove = event.screenY - lastPosition;
			//trace("* VDividedContainerMouseController: up at "+event.screenY+" delta of "+deltaMove);

			(_strand as IUIBase).topMostEventDispatcher.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			(_strand as IUIBase).topMostEventDispatcher.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
			var divider:DividedContainerDivider = _strand as DividedContainerDivider;
			var model:DividedContainerModel = divider.model as DividedContainerModel;
			var pairIndex:int = divider.pairIndex;

			model.addPairAdjustment(deltaMove, pairIndex);
		}
	}
}
