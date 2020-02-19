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
	
	public class AsynchronousIOOperation extends AbstractAsynchronousDispatcherOperation implements IAsynchronousOperation
	{
		// ========================================
		// constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function AsynchronousIOOperation(dispatcher:IEventDispatcher ):void
		{
			super( dispatcher );
		}
		
		// ========================================
		// protected methods
		// ========================================
		
		/**
		 * Add Event listeners to the specified dispatcher.
		 */
		override protected function addEventListeners( dispatcher:IEventDispatcher ):void
		{
			dispatcher.addEventListener(/*Event.CANCEL*/ 'cancel', failHandler);
			dispatcher.addEventListener(Event.COMPLETE, completeHandler);

			dispatcher.addEventListener(/*IOErrorEvent.IO_ERROR*/"ioError", failHandler);
			dispatcher.addEventListener(/*SecurityErrorEvent.SECURITY_ERROR*/"securityError", failHandler);
		}
		
		/**
		 * Remove Event listeners from the specified dispatcher.
		 */
		override protected function removeEventListeners( dispatcher:IEventDispatcher ):void
		{
			dispatcher.removeEventListener(/*Event.CANCEL*/ 'cancel', failHandler);
			dispatcher.removeEventListener(Event.COMPLETE, completeHandler);

			dispatcher.removeEventListener(/*IOErrorEvent.IO_ERROR*/"ioError", failHandler);
			dispatcher.removeEventListener(/*SecurityErrorEvent.SECURITY_ERROR*/"securityError", failHandler);

		}
	}
}
