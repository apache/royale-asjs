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
	import org.apache.royale.core.IDragInitiator;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.events.DragEvent;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.geom.Point;
	import org.apache.royale.utils.PointUtils;
	import org.apache.royale.css2.Cursors;

	COMPILE::SWF {
		import flash.display.InteractiveObject;
	}

    /**
     *  Indicates that the mouse has entered the component during
     *  a drag operatino.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     */
    [Event(name="dragEnter", type="org.apache.royale.events.DragEvent")]

    /**
     *  Indicates that the mouse is moving over a component during
     *  a drag/drop operation.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     */
    [Event(name="dragOver", type="org.apache.royale.events.DragEvent")]

    /**
     *  Indicates that the mouse is moving out of a component during
     *  a drag/drop operation.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     */
    [Event(name="dragExit", type="org.apache.royale.events.DragEvent")]

    /**
     *  Indicates that a drop operation should be executed.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     */
    [Event(name="dragDrop", type="org.apache.royale.events.DragEvent")]

	/**
	 *  The DropMouseController bead handles mouse events on the
	 *  a component, looking for events from a drag/drop operation.
	 *
     *  @royaleignoreimport org.apache.royale.core.IDragInitiator
     *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	public class DropMouseController extends EventDispatcher implements IBead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function DropMouseController()
		{
		}

		private var _strand:IStrand;

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
         *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;

            COMPILE::SWF
            {
                // consider using [Mixin] and requiring MixinManager
                DragEvent.init();
            }
            IEventDispatcher(_strand).addEventListener(DragEvent.DRAG_MOVE, dragMoveHandler);
		}

		public function get strand():IStrand
		{
			return _strand;
		}

        private var inside:Boolean;

        private var dragSource:Object;
        private var dragInitiator:IDragInitiator;

        public function acceptDragDrop(target:IUIBase, type:String):void
        {
            // TODO: aharui: switch icons
        }

        /**
         *  @private
		 * @royaleignorecoercion org.apache.royale.events.MouseEvent
         * @royaleignorecoercion org.apache.royale.core.IUIBase
         */
        private function dragMoveHandler(event:DragEvent):void
        {
//            trace("DROP-MOUSE: dragMove" + event.target.toString());
            var dragEvent:DragEvent;
            var host:IUIBase = _strand as IUIBase;
            if (!inside)
            {
                dragEvent = DragEvent.createDragEvent("dragEnter", event as MouseEvent);
				dragEvent.relatedObject = event.relatedObject;
				dispatchEvent(dragEvent);
                inside = true;
                host.addEventListener(DragEvent.DRAG_END, dragEndHandler);
                host.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);

				Cursors.setCursor(host, Cursors.MOVE);
            }
            else
            {
                dragEvent = DragEvent.createDragEvent("dragOver", event as MouseEvent);
				dragEvent.relatedObject = event.relatedObject;
				dispatchEvent(dragEvent);
            }
        }

        /**
         * @royaleignorecoercion org.apache.royale.core.IUIBase
         */
        private function rollOutHandler(event:MouseEvent):void
        {
            var dragEvent:DragEvent;
            var host:IUIBase = _strand as IUIBase;
            if (inside)
            {
                dragEvent = DragEvent.createDragEvent("dragExit", event);
				dispatchEvent(dragEvent);
                inside = false;

				Cursors.setCursor(host, Cursors.AUTO);
            }
            host.removeEventListener(DragEvent.DRAG_END, dragEndHandler);
            host.removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
        }

		/**
		 * @royaleignorecoercion org.apache.royale.events.MouseEvent
         * @royaleignorecoercion org.apache.royale.core.IUIBase
		 */
        private function dragEndHandler(event:DragEvent):void
        {
//            trace("DROP-MOUSE: dragEnd received for event via: "+event.target.toString());
            var dragEvent:DragEvent;

			var screenPoint:Point = new Point(event.screenX, event.screenY);
			var newPoint:Point = PointUtils.globalToLocal(screenPoint, _strand);
            dragEvent = DragEvent.createDragEvent("dragDrop", event as MouseEvent);
			dragEvent.clientX = newPoint.x;
			dragEvent.clientY = newPoint.y;
			COMPILE::SWF {
				dragEvent.relatedObject = event.target as InteractiveObject;
			}
			COMPILE::JS {
				dragEvent.relatedObject = event.relatedObject;
			}

			dispatchEvent(dragEvent);
            var host:IUIBase = _strand as IUIBase;
            inside = false;
            host.removeEventListener(DragEvent.DRAG_END, dragEndHandler);
            host.removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);

			Cursors.setCursor(host, Cursors.AUTO);
        }

	}
}
