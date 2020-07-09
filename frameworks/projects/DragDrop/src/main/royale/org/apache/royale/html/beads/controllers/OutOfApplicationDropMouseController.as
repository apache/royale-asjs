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
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IDragInitiator;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.events.DragEvent;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.css2.Cursors;
	import org.apache.royale.core.IRenderedObject;

	COMPILE::JS {
		import org.apache.royale.events.BrowserEvent;
		import org.apache.royale.utils.sendStrandEvent;
	}

    /**
     *  Indicates that the mouse has gone outside the app during
     *  a drag operation. Note that we are entering the drop target
     *  when exiting the application, hence the event name.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.7
     */
    [Event(name="dragEnter", type="org.apache.royale.events.DragEvent")]

    /**
     *  Indicates that the mouse is moving out of a component during
     *  a drag/drop operation.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.7
     */
    [Event(name="dragExit", type="org.apache.royale.events.DragEvent")]

    /**
     *  Indicates that a drop operation should be executed.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.7
     */
    [Event(name="dragDrop", type="org.apache.royale.events.DragEvent")]

	/**
	 *  The OutOfApplicationDropMouseController bead handles mouse events outside of the application
	 *  looking for events from a drag/drop operation.
	 *
	 *  @royaleignoreimport org.apache.royale.core.IDragInitiator
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.7
	 */
	public class OutOfApplicationDropMouseController extends EventDispatcher implements IBead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function OutOfApplicationDropMouseController()
		{
		}

		private var _strand:IStrand;

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;

			COMPILE::SWF
			{
				DragEvent.init();
			}
			(_strand as IEventDispatcher).addEventListener(DragEvent.DRAG_MOVE, dragMoveHandler);
		}

		public function get strand():IStrand
		{
			return _strand;
		}

		private var listenersInitialized:Boolean;
		private var draggingOutOfApp:Boolean;

		public function acceptDragDrop(target:IUIBase, type:String):void
		{
			// TODO
		}

		/**
		 *  @private
		 *  @royaleignorecoercion org.apache.royale.core.IRenderedObject
		 */ 
		private function dragMoveHandler(event:DragEvent):void
		{
			if (!listenersInitialized)
			{
				COMPILE::JS
				{
					(_strand as IRenderedObject).element.addEventListener("mouseleave", mouseLeaveHandler);
				}
				COMPILE::SWF
				{
					// TODO
				}
				listenersInitialized = true;
			} else if (draggingOutOfApp)
			{
				draggingOutOfApp = false;
				var dragEvent:DragEvent = new DragEvent("dragExit");
				dispatchEvent(dragEvent);
				Cursors.setCursor(_strand as IRenderedObject, Cursors.AUTO);
			}

		}

		/**
		 *  @royaleignorecoercion org.apache.royale.core.IRenderedObject
		 */
		COMPILE::JS
		private function mouseLeaveHandler(event:BrowserEvent):void
		{
			var dragEvent:DragEvent = new DragEvent("dragEnter");
			dispatchEvent(dragEvent);
			window.addEventListener("mouseup" , dragEndHandler);
			Cursors.setCursor(_strand as IRenderedObject, Cursors.MOVE);
			draggingOutOfApp = true;
		}

		/**
		 *  @royaleignorecoercion org.apache.royale.core.IRenderedObject
		 */
		COMPILE::JS
		private function dragEndHandler(event:BrowserEvent):void
		{
			var dragEvent:DragEvent = new DragEvent("dragDrop");
			dispatchEvent(dragEvent);
			(_strand as IRenderedObject).element.removeEventListener("mouseleave", mouseLeaveHandler);
			listenersInitialized = false;
			draggingOutOfApp = false;
			Cursors.setCursor(_strand as IRenderedObject, Cursors.AUTO);
			// clean up drag image, etc.
			var mouseEvent:MouseEvent = new MouseEvent(MouseEvent.MOUSE_UP);
			sendStrandEvent(_strand,mouseEvent);
		}

	}
}
