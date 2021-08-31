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
	import org.apache.royale.collections.TreeData;
	import org.apache.royale.events.DragEvent;
	import org.apache.royale.events.Event;

	/**
	 * The start event is dispatched when a DragStart event happens. The DragEvent.dragSource
	 * is set before this event is dispatched. A listener for this event can then decide if
	 * if the drag-drop action should continue or not. If not, the event should be cancelled.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	[Event(name="start", type="org.apache.royale.events.Event")]

	/**
	 * The accept event is dispatched when the drop happens but just before the data being
	 * dragged as been incorporated into the drop target's data source. Cancelling this event
	 * prevents that from happening.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	[Event(name="accept", type="org.apache.royale.events.Event")]

	/**
	 * The complete event is dispatched when the entire drag-and-drop operation has completed
	 * from the drag source's perspective.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	[Event(name="complete", type="org.apache.royale.events.Event")]

	/**
	 * The dragMove event is dispatched while the drag action moves.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.7
	 */
	[Event(name="dragMove", type="org.apache.royale.events.DragEvent")]

	/**
	 * The dragEnd event is dispatched while the drag action stops.
	 * This is dispatched even when the drag event is aborted.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.7
	 */
	[Event(name="dragEnd", type="org.apache.royale.events.DragEvent")]
	/**
	 *  The MultiSelectionTreeDragSourceBead brings drag capability to single-selection List components.
	 *  By adding this bead, a user can drag a row of the List to a new location within the list. This bead
	 *  should be used in conjunction with SingleSelectionDropTargetBead.
	 *
	 *  This bead adds a new event to the strand, "dragImageNeeded", which is dispatched on the strand
	 *  just prior to the dragImage's appearance. An event listener can create its own dragImage if the
	 *  default, taken from the data item, is not suitable.
	 *
	 *  @see org.apache.royale.html.beads.SingleSelectionDropTargetBead.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.7
	 */
	public class MultiSelectionTreeDragSourceBead extends MultiSelectionDragSourceBead
	{
		/**
		 * Constructor
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function MultiSelectionTreeDragSourceBead()
		{
			super();
		}

		/* IDragInitiator */

		/**
		 * Handles pre-drop actions.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 *  @royaleignorecoercion Array
		 *  @royaleignorecoercion org.apache.royale.collections.TreeData
		 */
		override public function acceptingDrop(dropTarget:Object, type:String):void
		{
			if (!continueDragOperation) return;

			//trace("MultiSelectionDragSourceBead accepting drop of type "+type);
			var newEvent:Event = new Event("accept", false, true);
			dispatchEvent(newEvent);
			if (newEvent.defaultPrevented) return;
			
			model.selectedIndices = null;

			if (dragType == "copy") return;
			var dragSource:Array = DragEvent.dragSource as Array;
			var dataList:TreeData = model.dataProvider as TreeData;

			for (var i:int = 0; i < dragSource.length; i++)
			{
				dataList.removeItem(dragSource[i]);
			}
		}
	}
}
