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
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IDragInitiator;
	import org.apache.flex.core.IStrand;
    import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.events.DragEvent;
	import org.apache.flex.events.EventDispatcher;
	import org.apache.flex.events.IEventDispatcher;
    import org.apache.flex.events.MouseEvent;

    /**
     *  Indicates that the mouse has entered the component during
     *  a drag operatino.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    [Event(name="dragEnter", type="org.apache.flex.events.DragEvent")]
    
    /**
     *  Indicates that the mouse is moving over a component during
     *  a drag/drop operation.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    [Event(name="dragOver", type="org.apache.flex.events.DragEvent")]
    
    /**
     *  Indicates that a drop operation should be executed.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    [Event(name="dragDrop", type="org.apache.flex.events.DragEvent")]
    
	/**
	 *  The DropMouseController bead handles mouse events on the 
	 *  a component, looking for events from a drag/drop operation.
	 *  
     *  @flexjsignoreimport org.apache.flex.core.IDragInitiator
     * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class DropMouseController extends EventDispatcher implements IBead
	{
		/**
		 *  constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function DropMouseController()
		{
		}
		        
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
         */
        private function dragMoveHandler(event:DragEvent):void
        {
            trace("dragMove");
            var dragEvent:DragEvent;
            if (!inside)
            {
                dragEvent = new DragEvent("dragEnter", true, true);
                dragEvent.copyMouseEventProperties(event);
                dragSource = dragEvent.dragSource = event.dragSource;
                dragInitiator = dragEvent.dragInitiator = event.dragInitiator;
                dispatchEvent(dragEvent);
                inside = true;
                IUIBase(_strand).topMostEventDispatcher.addEventListener(DragEvent.DRAG_END, dragEndHandler);
                IUIBase(_strand).addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
            }
            else
            {
                dragEvent = new DragEvent("dragOver", true, true);
                dragEvent.copyMouseEventProperties(event);
                dragEvent.dragSource = event.dragSource;
                dragEvent.dragInitiator = event.dragInitiator;
                IEventDispatcher(_strand).dispatchEvent(dragEvent);
            }
        }
        
        private function rollOutHandler(event:MouseEvent):void
        {
            var dragEvent:DragEvent;
            
            if (inside)
            {
                dragEvent = new DragEvent("dragExit", true, true);
                dragEvent.copyMouseEventProperties(event);
                dragEvent.dragSource = dragSource;
                dragEvent.dragInitiator = dragInitiator;
                dragSource = null;
                dragInitiator = null;
                event.stopImmediatePropagation();
                dispatchEvent(dragEvent);
                inside = false;
            }
            IUIBase(_strand).topMostEventDispatcher.removeEventListener(DragEvent.DRAG_END, dragEndHandler);
            IUIBase(_strand).removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);			
        }
        
        private function dragEndHandler(event:DragEvent):void
        {
            trace("dragEnd");
            var dragEvent:DragEvent;
            
            dragEvent = new DragEvent("dragDrop", true, true);
            dragEvent.copyMouseEventProperties(event);
            dragEvent.dragSource = event.dragSource;
            dragEvent.dragInitiator = event.dragInitiator;
            dragSource = null;
            dragInitiator = null;
            event.stopImmediatePropagation();
            dispatchEvent(dragEvent);
            
            inside = false;
            IUIBase(_strand).topMostEventDispatcher.removeEventListener(DragEvent.DRAG_END, dragEndHandler);
            IUIBase(_strand).removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);			
        }
		
	}
}
