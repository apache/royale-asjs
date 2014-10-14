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
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IDragInitiator;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.events.DragEvent;
    import org.apache.flex.events.EventDispatcher;
	import org.apache.flex.events.IEventDispatcher;
	
    /**
     *  Indicates that a drag/drop operation is starting.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    [Event(name="dragStart", type="org.apache.flex.events.DragEvent")]
    
    /**
     *  Indicates that the mouse is moving during
     *  a drag/drop operation.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    [Event(name="dragMove", type="org.apache.flex.events.DragEvent")]
    
    /**
     *  Indicates that a drag/drop operation is ending.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    [Event(name="dragEnd", type="org.apache.flex.events.DragEvent")]
    
	/**
	 *  The DragMouseController bead handles mouse events on the 
	 *  a component, looking for activity that constitutes the start
     *  of a drag drop operation.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class DragMouseController extends EventDispatcher implements IBead
	{
        /**
         *  The data being dragged. Or an instance
         *  of an object describing the data.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public static var dragSource:Object;
        
        /**
         *  The object that wants to know if a
         *  drop is accepted.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public static var dragInitiator:IDragInitiator;
        
        /**
         *  Whether there is a drag operation
         *  in progress.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public static var dragging:Boolean;
        
        /**
         *  The default movement in x and or y that
         *  means a drag should start
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public static var defaultThreshold:int = 4;
        
		/**
		 *  constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function DragMouseController()
		{
            threshold = defaultThreshold;
		}
		
        /**
         *  The movement in x and or y that
         *  means a drag should start
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public var threshold:int = 4;
        
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
			
            IEventDispatcher(_strand).addEventListener(MouseEvent.MOUSE_DOWN, dragMouseDownHandler);
		}
		
		public function get strand():IStrand
		{
			return _strand;
		}
        
        private var mouseDownX:Number;
        private var mouseDownY:Number;
        
        /**
         *  @private
         */
        private function dragMouseDownHandler(event:MouseEvent):void
        {
            DisplayObject(_strand).stage.addEventListener(MouseEvent.MOUSE_MOVE, dragMouseMoveHandler);
            DisplayObject(_strand).stage.addEventListener(MouseEvent.MOUSE_UP, dragMouseUpHandler);
            mouseDownX = event.stageX;
            mouseDownY = event.stageY;
        }
        
        private function dragMouseMoveHandler(event:MouseEvent):void
        {
            var dragEvent:DragEvent;
            
            if (!dragging)
            {
                if (Math.abs(event.stageX - mouseDownX) > threshold ||
                    Math.abs(event.stageY - mouseDownY) > threshold)
                {
                    dragEvent = new DragEvent("dragStart", true, true);
                    dragEvent.copyMouseEventProperties(event);
                    IEventDispatcher(strand).dispatchEvent(dragEvent);
                    if (dragSource != null)
                    {
                        dragging = true;
                    }
                }
            }
            else
            {
                dragEvent = new DragEvent("dragMove", true, true);
                event.stopImmediatePropagation();
                dragEvent.copyMouseEventProperties(event);
                dragEvent.dragSource = dragSource;
                dragEvent.dragInitiator = dragInitiator;
                IEventDispatcher(strand).dispatchEvent(dragEvent);
            }
        }
        
        private function dragMouseUpHandler(event:MouseEvent):void
        {
            var dragEvent:DragEvent;
            
            if (dragging)
            {
                dragEvent = new DragEvent("dragEnd", true, true);
                dragEvent.copyMouseEventProperties(event);
                event.stopImmediatePropagation();
                dragEvent.dragSource = dragSource;
                dragEvent.dragInitiator = dragInitiator;
                IEventDispatcher(strand).dispatchEvent(dragEvent);
            }
            dragging = false;
            dragSource = null;
            dragInitiator = null;
            DisplayObject(_strand).stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragMouseMoveHandler);
            DisplayObject(_strand).stage.removeEventListener(MouseEvent.MOUSE_UP, dragMouseUpHandler);			
        }
		
	}
}
