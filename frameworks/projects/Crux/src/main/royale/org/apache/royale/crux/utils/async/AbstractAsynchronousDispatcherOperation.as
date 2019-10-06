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
package org.apache.royale.crux.utils.async
{
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;

	public class AbstractAsynchronousDispatcherOperation extends AbstractAsynchronousOperation implements IAsynchronousOperation
	{
		// ========================================
		// constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function AbstractAsynchronousDispatcherOperation(dispatcher:IEventDispatcher )
		{
			super();

			addEventListeners( dispatcher );
		}
		
		// ========================================
		// protected methods
		// ========================================

		/**
		 * Add Event listeners to the specified dispatcher.
		 */
		protected function addEventListeners( dispatcher:IEventDispatcher ):void
		{
			// Subclasses should override this method and add listeners for relevant Event(s).
		}
		
		/**
		 * Remove Event listeners from the specified dispatcher.
		 */
		protected function removeEventListeners( dispatcher:IEventDispatcher ):void
		{
			// Subclasses should override this method and remove any Event listeners added in addEventListener().
		}
		
		/**
		 * Handle an Event that results in completion.
		 */
		protected function completeHandler( event:Event ):void
		{
			removeEventListeners( event.target as IEventDispatcher );
			
			complete( event );
		}
		
		/**
		 * Handle an Event that results in failure.
		 */
		protected function failHandler( event:Event ):void
		{
			removeEventListeners( event.target as IEventDispatcher );
			
			fail( event );
		}	
	}
}
