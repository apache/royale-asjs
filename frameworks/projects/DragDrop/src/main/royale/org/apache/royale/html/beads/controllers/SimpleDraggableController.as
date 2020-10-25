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
//@todo refactor topMostDispatcher stuff similar to elsewhere

    COMPILE::SWF {
        import flash.display.InteractiveObject;
        import flash.display.DisplayObjectContainer;
	}

    COMPILE::JS
    {
        import org.apache.royale.events.utils.MouseEventConverter;
        import org.apache.royale.core.WrappedHTMLElement;
    }

	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.events.DragEvent;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.geom.Point;
	import org.apache.royale.utils.PointUtils;
	import org.apache.royale.utils.UIUtils;
    import org.apache.royale.utils.DisplayUtils;
    import org.apache.royale.geom.Rectangle;


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
	public class SimpleDraggableController extends EventDispatcher implements IBead
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
		public function SimpleDraggableController()
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

            instanceNumber += 100;
		}

		public function get strand():IStrand
		{
			return _strand;
		}

        private var _parentDraggable:IUIBase;

        private var mouseDownX:Number;
        private var mouseDownY:Number;
        private var lastPositionX:Number;
        private var lastPositionY:Number;

        private var _approveDragStart:Function;
        /**
         * Provides the ability to approve (or prevent) a mouseDown event being considered
         * as the start of a drag sequence.
         *
         * @param value a function that takes a MouseEvent as a parameter, its boolean return value pre-approves a mouseDown event (or not)
         */
        public function set approveDragStart(value:Function):void{
            _approveDragStart = value;
        }
        public function get approveDragStart():Function{
            return _approveDragStart;
        }


        private var _topMostDispatcher:IEventDispatcher;
        /**
         *  @royaleignorecoercion org.apache.royale.core.IUIBase
         */
        public function get topMostDispatcher():IEventDispatcher{
            if (_topMostDispatcher) return _topMostDispatcher;
            if (_strand) _topMostDispatcher = (_strand as IUIBase).topMostEventDispatcher;
            return _topMostDispatcher;
        }
        public function set topMostDispatcher(value:IEventDispatcher):void{
            _topMostDispatcher = value;
        }

        private var _listeningDispatcher:IEventDispatcher;

        /**
         *  @private
         *  @royaleignorecoercion org.apache.royale.core.IUIBase
         */
        private function dragMouseDownHandler(event:MouseEvent):void
        {
//            trace("DRAG-MOUSE: dragMouseDown");
            if (_approveDragStart && !_approveDragStart(event)) return;
            topMostDispatcher = (_strand as IUIBase).topMostEventDispatcher;
            if (!topMostDispatcher) {
                trace('there was a problem finding the topmost EventDispatcher');
                return;
            }

            topMostDispatcher.addEventListener(MouseEvent.MOUSE_MOVE, dragMouseMoveHandler);
            topMostDispatcher.addEventListener(MouseEvent.CLICK, dragMouseUpHandler);

            COMPILE::SWF
            {
                topMostDispatcher.addEventListener(MouseEvent.MOUSE_UP, dragMouseUpHandler);
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
            lastPositionX = event.clientX;
            lastPositionY = event.clientY;
            event.preventDefault();
        }

        /**
         * @royaleignorecoercion org.apache.royale.core.IUIBase
         * @royaleignorecoercion org.apache.royale.core.UIBase
         */
        private function dragMouseMoveHandler(event:MouseEvent):void
        {
            var dragEvent:DragEvent;
            event.preventDefault();
            var draggable:IUIBase;
            if (!dragging)
            {

                if (Math.abs(event.screenX - mouseDownX) > threshold ||
                    Math.abs(event.screenY - mouseDownY) > threshold)
                {
                    dragEvent = DragEvent.createDragEvent("dragStart", event);
					dragEvent.clientX = lastPositionX;
					dragEvent.clientY = lastPositionY;

//					trace("DRAG-MOUSE: sending dragStart via "+event.target.toString()+" == "+dragImageOffsetX);
					COMPILE::SWF {
						dragEvent.relatedObject = _strand as InteractiveObject;
					}
					COMPILE::JS {
						dragEvent.relatedObject = _strand;
					}
					DragEvent.dispatchDragEvent(dragEvent, event.target);
					dispatchEvent(dragEvent);

                    var avoid:Boolean;
                    COMPILE::SWF {
                        avoid = dragEvent.isDefaultPrevented();
                    }
                    COMPILE::JS {
                        avoid = dragEvent.defaultPrevented;
                    }

                    if (!avoid)
                    {
                        dragging = true;

                        var deltaX:Number = event.clientX -lastPositionX;
                        var deltaY:Number = event.clientY - lastPositionY;
                        lastPositionX = event.clientX;
                        lastPositionY = event.clientY;
                        draggable = parentDraggable;

                        draggable.x = draggable.x + deltaX ;
                        draggable.y = draggable.y + deltaY ;

						COMPILE::SWF {
							(draggable as InteractiveObject).mouseEnabled = false;
							(draggable as DisplayObjectContainer).mouseChildren = false;
						}
						COMPILE::JS {
                            draggable.element.style['cursor'] = 'move';
                            draggable.element.style['position'] = 'absolute';
						}
                    }
                }
            }
            else
            {
//                trace("DRAG-MOUSE: sending dragMove via " + event.target.toString()+" == "+dragImageOffsetX);
                dragEvent = DragEvent.createDragEvent("dragMove", event);
                draggable = parentDraggable;

                deltaX =  event.clientX - lastPositionX;
                deltaY = event.clientY - lastPositionY;
                lastPositionX = event.clientX;
                lastPositionY = event.clientY;

                //@todo support some constraint approach

                draggable.x = draggable.x + deltaX;
                draggable.y = draggable.y + deltaY;


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

       //     host = UIUtils.findPopUpHost(_strand as IUIBase);

            var draggable:IUIBase;
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

            topMostDispatcher.removeEventListener(MouseEvent.MOUSE_MOVE, dragMouseMoveHandler);
            topMostDispatcher.removeEventListener(MouseEvent.CLICK, dragMouseUpHandler);

            COMPILE::SWF
            {
                topMostDispatcher.removeEventListener(MouseEvent.MOUSE_UP, dragMouseUpHandler);
            }
            
            COMPILE::JS
            {
                window.removeEventListener(MouseEvent.MOUSE_UP, dragMouseUpHandler);
                parentDraggable.element.style['cursor'] = 'auto';
            }

        }

        /**
         * allows explicitly setting a parent that can be dragged by this bead being
         * active on one of its children (e.g. use case: panel draggable from its header)
         */
        public function get parentDraggable():IUIBase {
            return _parentDraggable || _strand as IUIBase;
        }

        public function set parentDraggable(value:IUIBase):void {
            _parentDraggable = value;
        }
    }
}
