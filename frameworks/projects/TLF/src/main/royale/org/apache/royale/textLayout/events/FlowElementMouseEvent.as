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
package org.apache.royale.textLayout.events
{
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IRoyaleEvent;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.textLayout.elements.IFlowElement;
			
	/** A link element dispatches this event when it detects mouse activity.
	 * The Text Layout Framework includes this special version of mouse events
	 * because mouse events are generally unwanted when a flow element is
	 * embedded in an editable text flow, and because link elements are not in
	 * the display list (they are not DisplayObjects).
	 * <p>You can add an event listener to a link element to listen for this
	 * type of event. If you choose to cancel the event by calling
	 * <code>Event.preventDefault()</code>, the default behavior associated
	 * with the event will not occur.
	 * </p>
	 * <p>If you choose not to add an event listener to the link element, or
	 * your event listener function does not cancel the behavior, the 
	 * event is again dispatched, but this time by the link element's
	 * associated TextFlow instance rather than by the link element itself. 
	 * This provides a second opportunity to listen for this event with
	 * an event listener attached to the TextFlow. 
	 * </p>
	 * <p>FlowElementMouseEvents are
	 * dispatched only when the text cannot be edited or when the control key 
	 * is pressed concurrently with the mouse activity.</p>
	 * <p>
	 * The following six event types are dispatched only when the text
	 * cannot be edited or when the control key is pressed:
	 * <ul>
	 *   <li><code>FlowElementMouseEvent.CLICK</code></li>
	 *   <li><code>FlowElementMouseEvent.MOUSE_DOWN</code></li>
	 *   <li><code>FlowElementMouseEvent.MOUSE_UP</code></li>
	 *   <li><code>FlowElementMouseEvent.MOUSE_MOVE</code></li>
	 *   <li><code>FlowElementMouseEvent.ROLL_OVER</code></li>
	 *   <li><code>FlowElementMouseEvent.ROLL_OUT</code></li>
	 * </ul>
	 * </p>
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0 
	 * @see org.apache.royale.textLayout.elements.LinkElement
     * @see org.apache.royale.events.MouseEvent
	 */
	public class FlowElementMouseEvent extends Event
	{
		/**
		 * Defines the value of the <code>type</code> property of a <code>mouseDown</code> event object. 
		 * 
		 * @see org.apache.royale.events.MouseEvent#MOUSE_DOWN
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public static const MOUSE_DOWN:String = "mouseDown";
		/**
		 * Defines the value of the <code>type</code> property of a <code>mouseUp</code> event object. 
		 * 
		 * @see org.apache.royale.events.MouseEvent#MOUSE_UP
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public static const MOUSE_UP:String = "mouseUp";	
		/**
		 * Defines the value of the <code>type</code> property of a <code>mouseMove</code> event object. 
		 * 
		 * @see org.apache.royale.events.MouseEvent#MOUSE_MOVE
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public static const MOUSE_MOVE:String = "mouseMove";
		/**
		 * Defines the value of the <code>type</code> property of a <code>rollOver</code> event object. 
		 * 
		 * @see org.apache.royale.events.MouseEvent#ROLL_OVER
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public static const ROLL_OVER:String = "rollOver";
		/**
		 * Defines the value of the <code>type</code> property of a <code>rollOut</code> event object. 
		 * 
		 * @see org.apache.royale.events.MouseEvent#ROLL_OUT
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public static const ROLL_OUT:String = "rollOut";	
		/**
		 * Defines the value of the <code>type</code> property of a <code>click</code> event object. 
		 * 
		 * @see org.apache.royale.events.MouseEvent#CLICK
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public static const CLICK:String = "click";

		private var _flowElement:IFlowElement;
		private var _originalEvent:MouseEvent;
		
		/** 
		 * The FlowElement that dispatched the event.
		 *
		 * @see org.apache.royale.textLayout.elements.FlowElement
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public function get flowElement():IFlowElement
		{ return _flowElement; }		
		public function set flowElement(value:IFlowElement):void
		{ _flowElement = value; }
		
		/** 
		 * The original mouse event generated by the mouse activity. 
		 * This property can contain any of the following values:
		 * <ul>
		 *   <li><code>MouseEvent.CLICK</code></li>
		 *   <li><code>MouseEvent.MOUSE_DOWN</code></li>
		 *   <li><code>MouseEvent.MOUSE_UP</code></li>
		 *   <li><code>MouseEvent.MOUSE_MOVE</code></li>
		 *   <li><code>MouseEvent.MOUSE_OVER</code></li>
		 *   <li><code>MouseEvent.MOUSE_OUT</code></li>
		 * </ul>
		 * <p>
		 * In most cases the original event matches the event that the
		 * link element dispatches. The events match for the <code>click</code>,
		 * <code>mouseDown</code>, <code>mouseOut</code>, and <code>mouseOver</code>
		 * events. There are two cases, however, in which the original event
		 * is converted by the link element to a related event. 
		 * If a link element detects a <code>mouseOver</code> event, it dispatches
		 * a <code>rollOver</code> event. Likewise, if a link element detects
		 * a <code>mouseOut</code> event, it dispatches a <code>rollOut</code> event.
		 * Usually, the event target and the mouse coordinates are related to
		 * the TextLine instance containing the link element.
		 * </p>
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 * @see org.apache.royale.events.MouseEvent
		 */
		public function get originalEvent():MouseEvent
		{ return _originalEvent; }		
		public function set originalEvent(value:MouseEvent):void
		{ _originalEvent = value; }
				
		/** 
		 * Creates an event object that contains information about mouse activity.
		 * Event objects are passed as parameters to event listeners. Use the
		 * constructor if you plan to manually dispatch an event. You do not need
		 * to use the constructor to listen for FlowElementMouseEvent objects
		 * generated by a FlowElement.
		 * @param type  The type of the event. Event listeners can access this information through the
		 * inherited <code>type</code> property. There are six types:
		 * <code>FlowElementMouseEvent.CLICK</code>; <code>FlowElementMouseEvent.MOUSE_DOWN</code>; <code>FlowElementMouseEvent.MOUSE_MOVE</code>;
		 * <code>FlowElementMouseEvent.MOUSE_UP</code>; <code>FlowElementMouseEvent.ROLL_OVER</code>; and <code>FlowElementMouseEvent.ROLL_OUT</code>.
		 * @param bubbles Determines whether the Event object participates in the bubbling phase of the
		 * event flow. FlowElementMouseEvent objects do not bubble.
		 * @param cancelable Determines whether the Event object can be canceled. Event listeners can
		 * access this information through the inherited <code>cancelable</code> property. FlowElementMouseEvent
		 * objects can be cancelled. You can cancel the default behavior associated with this event
		 * by calling the <code>preventDefault()</code> method in your event listener.
		 * @param flowElement The instance of FlowElement, currently a LinkElement, associated with this
		 * event. Event listeners can access this information through the <code>flowElement</code> property.
		 * @param originalEvent The original mouse event that occurred on the flowElement. Event listeners can 
		 * access this information through the <code>originalEvent</code> property.

		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public function FlowElementMouseEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = true, flowElement:IFlowElement = null, originalEvent:MouseEvent = null)
		{
			super(type, bubbles, cancelable);
			_flowElement = flowElement;
			_originalEvent = originalEvent;
        }
        
        /** @private */
        override public function cloneEvent():IRoyaleEvent
        {
        	return new FlowElementMouseEvent(type, bubbles, cancelable, flowElement, originalEvent);
        }
        
	}
}
