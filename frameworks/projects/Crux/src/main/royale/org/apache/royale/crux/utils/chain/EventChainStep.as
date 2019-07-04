/*
 * Copyright 2010 Swiz Framework Contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */
package org.apache.royale.crux.utils.chain
{
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	
	import org.apache.royale.crux.utils.async.IAsynchronousEvent;
	import org.apache.royale.crux.utils.async.IAsynchronousOperation;
	import org.apache.royale.crux.utils.services.CruxResponder;
	
	public class EventChainStep extends BaseChainStep implements IAutonomousChainStep, IAsyncChainStep
	{
		// ========================================
		// protected properties
		// ========================================
		
		/**
		 * Backing variable for <code>dispatcher</code> getter/setter.
		 */
		protected var _dispatcher:IEventDispatcher;
		
		/**
		 * Backing variable for <code>event</code> property.
		 */
		protected var _event:Event;
		
		/**
		 * Backing variable for <code>pendingCount</code> property.
		 */
		protected var _pendingCount:int = 0;
		
		// ========================================
		// public properties
		// ========================================
		
		/**
		 * Target Event dispatcher.
		 */
		public function get dispatcher():IEventDispatcher
		{
			return _dispatcher;
		}
		
		public function set dispatcher( value:IEventDispatcher ):void
		{
			_dispatcher = value;
		}
		
		/**
		 * Event dispatched for this EventChainStep.
		 */
		public function get event():Event
		{
			return _event;
		}
		
		/**
		 * Count of pending asynchronous operations for this step.
		 */
		public function get pendingCount():int
		{
			return _pendingCount;
		}
		
		// ========================================
		// constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function EventChainStep(event:Event, dispatcher:IEventDispatcher = null )
		{
			super();
			
			_dispatcher = dispatcher;
			_event = event;
			if ( _event is IAsynchronousEvent )
				IAsynchronousEvent( _event ).step = this;
		}
		
		// ========================================
		// public methods
		// ========================================
		
		/**
		 * @inheritDoc
		 */
		public function doProceed():void
		{
			_failed = false;
			_pendingCount = 0;
			
			dispatcher.dispatchEvent( event );
			
			if ( ( pendingCount == 0 ) && ( ! isComplete ) )
				complete();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function complete():void
		{
			_pendingCount = 0;
			
			super.complete();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function error():void
		{
			_failed = true;
			
			super.error();
		}

		/**
		 * @inheritDoc
		 */
		public function addAsynchronousOperation( operation:IAsynchronousOperation ):void
		{
			operation.addResponder( new CruxResponder(resultHandler, faultHandler ) );
			
			_pendingCount++;
		}
		
		// ========================================
		// public methods
		// ========================================
		
		/**
		 * Result handler for an associated pending asynchronous operation.
		 */
		protected function resultHandler( data:Object ):void
		{
			if ( _pendingCount > 0 )
				_pendingCount--;
		
			if ( !_failed )
			{
				if ( _pendingCount == 0 )
					complete();
			}
		}
		
		/**
		 * Fault handler for an associated pending asynchronous operation.
		 */
		protected function faultHandler( info:Object ):void
		{
			if ( _pendingCount > 0 )
				_pendingCount--;
			
			error();
		}	
	}
}
