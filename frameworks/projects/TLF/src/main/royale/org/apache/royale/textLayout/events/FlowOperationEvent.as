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
	import org.apache.royale.events.IRoyaleEvent;
	import org.apache.royale.events.Event;
	
	import org.apache.royale.textLayout.operations.FlowOperation; 
	
	/** A TextFlow instance dispatches this event just before an operation commences
	 * and again just after an operation completes. Although the event object
	 * dispatched in both cases is an instance of FlowOperationEvent, the events
	 * dispatched before and after an operation differ in significant ways.
	 *
	 * <p>Before any operation is carried out, a TextFlow object dispatches a FlowOperationEvent
	 * with its <code>type</code> property set to <code>FlowOperationEvent.FLOW_OPERATION_BEGIN.</code>
	 * You can determine what type of operation is about to commence by checking
	 * the <code>operation</code> property. Events of type FLOW_OPERATION_BEGIN are
	 * cancellable, which means that if you decide that the operation should not proceed,
	 * you can call <code>Event.PreventDefault()</code> to cancel the operation.
	 * If you cancel the operation, the operation is not performed and the 
	 * FLOW_OPERATION_END event is not dispatched. You may also choose to call back into the
	 * EditManager to do another operation before the operation that triggered the event is done. If you do
	 * this, the operations you initiate in your event handler will be undone as a single
	 * operation with the operation that triggered the event.</p>
	 *
	 * <p>If you allow the operation to proceed, TextFlow will dispatch a FlowOperationEvent
	 * upon completion of the operation with its <code>type</code> property set to
	 * <code>FlowOperationEvent.FLOW_OPERATION_END</code>. This event is dispatched
	 * before Flash Player throws any errors that may have occurred as a result of the
	 * operation. This gives you an opportunity to process the error before Flash Player
	 * throws the error. You can access the error through the event's <code>error</code>
	 * property. If you choose to handle the error in your event handler, you can prevent
	 * Flash Player from throwing the error by cancelling the FLOW_OPERATION_END event
	 * by calling <code>Event.preventDefault()</code>. You may also choose to call back into the
	 * EditManager to do some additional operations. If you do this, the operations that result
	 * will be undone as a unit with the operation that triggered the event.
	 * </p> 
	 *
	 * @see org.apache.royale.textLayout.operations.FlowOperation
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0 
	 */
	public class FlowOperationEvent extends Event
	{
		/** 
		 * Defines the value of the <code>type</code> property of a <code>flowOperationBegin</code> event object.
		 * Dispatched before an operation is executed.   Cancelling this event blocks the operation. 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		
		public static const FLOW_OPERATION_BEGIN:String = "flowOperationBegin";
		
		/**  
		 * Defines the value of the <code>type</code> property of a <code>flowOperationEnd</code> event object.
		 * Dispatched after an operation completes. Any errors are stored in <code>OperationEvent.error</code>.
	 	 * If there is an error, cancelling this event blocks the rethrow of the error.
	 	 * Generally speaking all errors are likely to be fatal.
	 	 * <p>Changing an operation at this time (after it has been executed) may fail.</p> 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
	 	 */
	 	
		public static const FLOW_OPERATION_END:String = "flowOperationEnd";

		/**  
		 * Defines the value of the <code>type</code> property of a <code>flowOperationComplete</code> event object.
		 * Dispatched after all operations including pending and composite operations are completed, composition is finished and the display is scrolled.
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		
		public static const FLOW_OPERATION_COMPLETE:String = "flowOperationComplete";
				
		private var _op:FlowOperation;
		private var _e:Error;
		private var _level:int;

		/** 
		 * The operation that is about to begin or has just ended.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
	         * @see org.apache.royale.textLayout.operations.FlowOperation
		 */		
		public function get operation():FlowOperation
		{ return _op; }	
		public function set operation(value:FlowOperation):void
		{ _op = value; }	

		/** 
		 * The error thrown, if any, during an operation.  
		 * If an error occurs during an operation, a reference to the error object is attached to the 
		 * FLOW_OPERATION_END event. This give you the opportunity to deal with the error
		 * before Flash Player throws the error. If you cancel the event, Flash Player will not throw the error.
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public function get error():Error
		{ return _e; }
		public function set error(value:Error):void
		{ _e = value; }
		
		/** 
		 * Operations may be merged into composite operations through nesting.  This flag describes the nesting level of the operation.
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public function get level():int
		{ return _level; }
		public function set level(value:int):void
		{ _level = value; }		
		
		/** Creates an event object that contains information about a flow operation.
		 * @param type			The type of the event. Event listeners can access this information through the
		 * inherited <code>type</code> property. There are two types: 
		 * <code>FlowOperationEvent.FLOW_OPERATION_BEGIN</code>; 
		 * <code>FlowOperationEvent.FLOW_OPERATION_END</code>.
		 * @param bubbles 		Indicates whether an event is a bubbling event.This event does not bubble.
		 * @param cancelable 	Indicates whether the behavior associated with the event can be prevented.
		 * This event can be cancelled by calling the <code>Event.preventDefault()</code> method in
		 * your event handler function.
		 * @param operation		The FlowOperation that is about to commence or that has just ended.
		 * @param error			Any Error generating during the operation.
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public function FlowOperationEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, operation:FlowOperation = null, level:int = 0, error:Error = null)
		{
			_op = operation;
			_e  = error;
			_level = level;
			super(type, bubbles, cancelable);
		}
		
       	/** @private */
		override public function cloneEvent():IRoyaleEvent
		{
			return new FlowOperationEvent(type, bubbles, cancelable, _op, _level, _e);
		}
		
	}
}
