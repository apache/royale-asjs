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
	import org.apache.royale.collections.ArrayList;
	import org.apache.royale.core.DropType;
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.DragEvent;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.beads.controllers.OutOfApplicationDropMouseController;


	/**
	 * The enter event is dispatched when a DragEnter has been detected in the drop target
	 * strand. This event can be used to determine if the strand can and will accept the data
	 * being dragged onto it. If the data cannot be used by the drop target strand this event
	 * should be cancelled.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.7
	 */
	[Event(name="enter", type="org.apache.royale.events.Event")]

	/**
	 * The exit event is sent when the drag goes outside of the drop target space.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.7
	 */
	[Event(name="exit", type="org.apache.royale.events.Event")]

	/**
	 * The complete event is dispatched when the drop operation has completed from the drop
	 * target's perspective.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.7
	 */

	[Event(name="drop", type="org.apache.royale.events.Event")]
	/**
	 * The drop event is dispatched when the drop operation is about to be completed. DragEvent.dragSource is still available
	 *  and default can still be prevented.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.7
	 */

	[Event(name="complete", type="org.apache.royale.events.Event")]
	/**
	 *  The OutOfApplicationDropTargetBead enables items to be dropped outside of the application
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.7
	 */

	public class OutOfApplicationDropTargetBead extends EventDispatcher implements IBead
	{
		/**
		 * Constructor
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function OutOfApplicationDropTargetBead()
		{
			super();
		}

		private var _dropController:OutOfApplicationDropMouseController;
		private var _strand:IStrand;

		/**
		 * @private
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;

			_dropController = new OutOfApplicationDropMouseController();
			_strand.addBead(_dropController);

			_dropController.addEventListener(DragEvent.DRAG_ENTER, handleDragEnter);
			_dropController.addEventListener(DragEvent.DRAG_EXIT, handleDragExit);
			_dropController.addEventListener(DragEvent.DRAG_DROP, handleDragDrop);
		}

		/**
		 * @private
		 *  @royaleignorecoercion org.apache.royale.core.IUIBase
		 */
		private function handleDragEnter(event:DragEvent):void
		{
			var newEvent:Event = new Event("enter", false, true);
			dispatchEvent(newEvent);
			if (newEvent.defaultPrevented) return;

			_dropController.acceptDragDrop(event.relatedObject as IUIBase, DropType.COPY);
		}

		/**
		 * @private
		 */
		private function handleDragDrop(event:DragEvent):void
		{
			handleDragExit(event);

			var newEvent:Event = new Event("drop", false, true);
			dispatchEvent(newEvent);
			if (newEvent.defaultPrevented) {
				return;
			}

			// Let the dragInitiator know the drop has been completed.
			if (DragEvent.dragInitiator) {
				DragEvent.dragInitiator.acceptedDrop(_strand, "object");
			}

			// is this event necessary? isn't "complete" enough?
			IEventDispatcher(_strand).dispatchEvent(new Event("dragDropAccepted"));

			dispatchEvent(new Event("complete"));
		}

		/*
		 * @private
		 */
		private function handleDragExit(event:DragEvent):void
		{
			dispatchEvent(new Event("exit", false, true));
		}
	}
}
