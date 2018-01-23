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
	import org.apache.royale.textLayout.elements.IFlowElement;
//	import org.apache.royale.events.ErrorEvent;
	
	/** 
	 * A TextFlow instance dispatches this event when the status of a FlowElement changes. 
	 * This event can be used to detect when an inline graphic element has
	 * completed loading. You can use your event handler to recompose the text flow
	 * based on the presence of the newly loaded inline graphic element.
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0 
	 */
	public class StatusChangeEvent extends Event
	{
	    /** 
	     * Defines the value of the <code>type</code> property of a <code>inlineGraphicStatusChanged</code> event object.
	     * @playerversion Flash 10
	     * @playerversion AIR 1.5
	     * @langversion 3.0 
	     */
	    public static const INLINE_GRAPHIC_STATUS_CHANGE:String = "inlineGraphicStatusChange";
	    
	    private var _element:IFlowElement;
	    private var _status:String;
//	    private var _errorEvent:ErrorEvent;

		/** Creates an event object that contains information about a status change.
		 * @param type		The type of the event. Event listeners can access this information through the
		 * inherited <code>type</code> property. There is only one type of StatusChangeEvent: 
		 * <code>StatusChangeEvent.INLINE_GRAPHIC_STATUS_CHANGE</code>; 
		 * @param bubbles 	Indicates whether an event is a bubbling event.This event does not bubble.
		 * @param cancelable 	Indicates whether the behavior associated with the event can be prevented.
		 * This event cannot be cancelled.
		 * @param element The FlowElement instance that has experienced a change in status.
		 * @param newStatus The FlowElement instance's new status.
		 * @param e The ErrorEvent object, if any, associated with the status.
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 **/
		public function StatusChangeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, element:IFlowElement = null,status:String = null)//,errorEvent:ErrorEvent = null
		{
			_element = element;
			_status = status;
//			_errorEvent = errorEvent;
			super(type, bubbles, cancelable);
		}
		
      	/** @private */
		override public function cloneEvent():IRoyaleEvent
		{
			return new StatusChangeEvent(type,bubbles,cancelable,_element,_status);//,_errorEvent
		}
		
		/** 
		 * The FlowElement instance that has experienced a change in status. 
		 * @see org.apache.royale.textLayout.elements.FlowElement
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public function get element():IFlowElement
		{ return _element; }		
		public function set element(value:IFlowElement):void
		{ _element = value; }		
		
		/**
		 * The FlowElement's new status. The possible values of this property are
		 * defined by the InlineGraphicElementStatus class. There are five static constants
		 * available in the InlineGraphicElementStatus class:
		 * <ul>
		 *   <li>ERROR : String = "error". An error occurred during loading of a referenced graphic.</li>
		 *   <li>LOADING : String = "loading". Load has been initiated (but not completed) on a graphic element that is a URL.</li>
		 *   <li>LOAD_PENDING : String = "loadPending". Graphic element is an URL that has not been loaded.</li>
		 *   <li>READY : String = "ready". Graphic is completely loaded and properly sized.</li>
		 *   <li>SIZE_PENDING : String = "sizePending". Graphic element with auto or percentage width/height has completed loading but has not been recomposed.</li>
		 * </ul>
		 *
		 * @see org.apache.royale.textLayout.elements.InlineGraphicElementStatus
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public function get status():String
		{ return _status; }
		public function set status(value:String):void
		{ _status = value; }
		
		/** 
		 * The ErrorEvent object that was dispatched as a result of the status change. 
		 * @see org.apache.royale.events.ErrorEvent
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
//		public function get errorEvent():ErrorEvent
//		{ return _errorEvent; }
//		public function set errorEvent(value:ErrorEvent):void
//		{ _errorEvent = value; }
	}
}
