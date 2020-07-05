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
	import flash.display.InteractiveObject;
	import flash.display.DisplayObjectContainer;
	}

    COMPILE::JS
    {
        import org.apache.royale.events.utils.MouseEventConverter;
    }

	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IDragInitiator;
	import org.apache.royale.core.IPopUpHost;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.DragEvent;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.geom.Point;
	import org.apache.royale.utils.PointUtils;
	import org.apache.royale.utils.UIUtils;
	import org.apache.royale.css2.Cursors;

    /**
     *  Indicates that a drag/drop operation is starting.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     */
    [Event(name="dragStart", type="org.apache.royale.events.DragEvent")]

    /**
     *  Indicates that the mouse is moving during
     *  a drag/drop operation.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     */
    [Event(name="dragMove", type="org.apache.royale.events.DragEvent")]

    /**
     *  Indicates that a drag/drop operation is ending.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     */
    [Event(name="dragEnd", type="org.apache.royale.events.DragEvent")]

	/**
	 *  The DragMouseController bead handles mouse events on the
	 *  a component, looking for activity that constitutes the start
     *  of a drag drop operation.
	 *
     *  @royaleignoreimport org.apache.royale.core.IDragInitiator
     *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	public class DragMouseController extends EventDispatcher implements IBead
	{
        /**
         *  Whether there is a drag operation
         *  in progress.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         * 
         *  @royalesuppresspublicvarwarning
         */
        public static var dragging:Boolean = false;

        /**
         *  The drag image.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         * 
         *  @royalesuppresspublicvarwarning
         */
        public static var dragImage:IUIBase;

        /**
         *  The offset of the drag image.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         * 
         *  @royalesuppresspublicvarwarning
         */
        public static var dragImageOffsetX:Number = 0;

        /**
         *  The offset of the drag image.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         * 
         *  @royalesuppresspublicvarwarning
         */
        public static var dragImageOffsetY:Number = 0;

        /**
         *  The default movement in x and or y that
         *  means a drag should start
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         * 
         *  @royalesuppresspublicvarwarning
         */
        public static var defaultThreshold:int = 4;

		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function DragMouseController()
		{
            threshold = defaultThreshold;
		}

        private var _threshold:int = 4;
        
        /**
         *  The movement in x and or y that
         *  means a drag should start
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        public function get threshold():int
        {
            return _threshold;
        }
        public function set threshold(value:int):void
        {
            _threshold = value;
        }
        
		private var _strand:IStrand;

        /**
         *  @private
         * 
         *  @royalesuppresspublicvarwarning
         */
		public static var instanceNumber:int = 1;

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

            IEventDispatcher(_strand).addEventListener(MouseEvent.MOUSE_DOWN, dragMouseDownHandler);

            DragMouseController.instanceNumber += 100;
		}

		public function get strand():IStrand
		{
			return _strand;
		}

        private var mouseDownX:Number;
        private var mouseDownY:Number;

        private var host:IPopUpHost;

        /**
         *  @private
         *  @royaleignorecoercion org.apache.royale.core.IUIBase
         */
        private function dragMouseDownHandler(event:MouseEvent):void
        {
//            trace("DRAG-MOUSE: dragMouseDown");
            (_strand as IUIBase).topMostEventDispatcher.addEventListener(MouseEvent.MOUSE_MOVE, dragMouseMoveHandler);
            (_strand as IUIBase).topMostEventDispatcher.addEventListener(MouseEvent.CLICK, dragMouseUpHandler);
            COMPILE::SWF
            {
                (_strand as IUIBase).topMostEventDispatcher.addEventListener(MouseEvent.MOUSE_UP, dragMouseUpHandler);
            }
            /**
             * In browser, we need to listen to window to get mouseup events outside the window
             */
            COMPILE::JS
            {
                window.addEventListener(MouseEvent.MOUSE_UP, dragMouseUpHandler);
            }
            mouseDownX = event.screenX;
            mouseDownY = event.screenY;
            event.preventDefault();
        }

        /**
         * @royaleignorecoercion org.apache.royale.core.IUIBase
         * @royaleignorecoercion org.apache.royale.core.UIBase
         */
        private function dragMouseMoveHandler(event:MouseEvent):void
        {
            var pt:Point;
            var dragEvent:DragEvent;
//            trace("DRAG-MOUSE: dragMouseMove");

            event.preventDefault();

            if (!dragging)
            {
//                trace("DRAG-MOUSE: not dragging anything else");
                if (Math.abs(event.screenX - mouseDownX) > threshold ||
                    Math.abs(event.screenY - mouseDownY) > threshold)
                {
                    dragEvent = DragEvent.createDragEvent("dragStart", event);
					dragEvent.clientX = mouseDownX;
					dragEvent.clientY = mouseDownY;
//					trace("DRAG-MOUSE: sending dragStart via "+event.target.toString()+" == "+dragImageOffsetX);
					COMPILE::SWF {
						dragEvent.relatedObject = event.target as InteractiveObject;
					}
					COMPILE::JS {
						dragEvent.relatedObject = event.target;
					}
					DragEvent.dispatchDragEvent(dragEvent, event.target);
					dispatchEvent(dragEvent);

                    if (DragEvent.dragSource != null)
                    {
                        dragging = true;
                        host = UIUtils.findPopUpHost(_strand as IUIBase);
                        if (host == null) return;
                        host.popUpParent.addElement(dragImage);
                        pt = PointUtils.globalToLocal(new Point(event.clientX, event.clientY), host);
                        dragImage.x = pt.x + dragImageOffsetX;
                        dragImage.y = pt.y + dragImageOffsetY;
						(dragImage as UIBase).id = "drag_image";
						COMPILE::SWF {
							(dragImage as InteractiveObject).mouseEnabled = false;
							(dragImage as DisplayObjectContainer).mouseChildren = false;
						}
						COMPILE::JS {
							dragImage.element.style['pointer-events'] = 'none';
							dragImage.element.style['position'] = 'absolute';
						}
                    }
                }
            }
            else
            {
            	host = UIUtils.findPopUpHost(_strand as IUIBase);
                if (host == null) return;
//                trace("DRAG-MOUSE: sending dragMove via " + event.target.toString()+" == "+dragImageOffsetX);
                dragEvent = DragEvent.createDragEvent("dragMove", event);
                pt = PointUtils.globalToLocal(new Point(event.clientX, event.clientY), host);
                dragImage.x = pt.x + dragImageOffsetX;
                dragImage.y = pt.y + dragImageOffsetY;
				COMPILE::SWF {
					dragEvent.relatedObject = event.target as InteractiveObject;
				}
				COMPILE::JS {
					dragEvent.relatedObject = event.target;
				}
                DragEvent.dispatchDragEvent(dragEvent, event.target);
				dispatchEvent(dragEvent);
            }
        }

        /**
         * @royaleignorecoercion org.apache.royale.core.IUIBase
         */
        private function dragMouseUpHandler(event:MouseEvent):void
        {
            //trace("DRAG-MOUSE: dragMouseUp");
            var dragEvent:DragEvent;

            host = UIUtils.findPopUpHost(_strand as IUIBase);
            if (dragImage && host) {
            	host.popUpParent.removeElement(dragImage);
            }

            if (dragging && event.target)
            {
                //trace("DRAG-MOUSE: sending dragEnd via: "+event.target.toString());
                COMPILE::JS
                {
                    event = MouseEventConverter.convert(event);
                }
				var screenPoint:Point = new Point(event.screenX, event.screenY);
                // if dragged out of the browser window the target will be the document
                // and trying to get the local coordinates will casue a RTE.
                var royaleEvent:Boolean;
                var newPoint:Point;
                // these values are relative to the browser window and can be negative.
                if(event.target.constructor.name == "HTMLHtmlElement")
                {
                    royaleEvent = false;
                    newPoint = new Point(event.clientX,event.clientY);
                }
                else 
				{
                    royaleEvent = true;
                    newPoint = PointUtils.globalToLocal(screenPoint, event.target);
                }
				dragEvent = DragEvent.createDragEvent("dragEnd", event);
				dragEvent.clientX = newPoint.x;
				dragEvent.clientY = newPoint.y;
				COMPILE::SWF {
					dragEvent.relatedObject = event.target as InteractiveObject;
				}
				COMPILE::JS {
					dragEvent.relatedObject = event.target;
				}
                if(royaleEvent)
                {
                    DragEvent.dispatchDragEvent(dragEvent, event.target);
                }
				dispatchEvent(dragEvent);
                event.preventDefault();
            }

            dragging = false;
            DragEvent.dragSource = null;
            DragEvent.dragInitiator = null;
            dragImage = null;

            (_strand as IUIBase).topMostEventDispatcher.removeEventListener(MouseEvent.MOUSE_MOVE, dragMouseMoveHandler);
            (_strand as IUIBase).topMostEventDispatcher.removeEventListener(MouseEvent.CLICK, dragMouseUpHandler);

            COMPILE::SWF
            {
                (_strand as IUIBase).topMostEventDispatcher.removeEventListener(MouseEvent.MOUSE_UP, dragMouseUpHandler);
            }
            
            COMPILE::JS
            {
                window.removeEventListener(MouseEvent.MOUSE_UP, dragMouseUpHandler);
            }

        }

	}
}
