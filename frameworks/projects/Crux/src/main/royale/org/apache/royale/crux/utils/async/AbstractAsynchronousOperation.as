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
	import mx.rpc.IResponder;

	public class AbstractAsynchronousOperation
	{
		// ========================================
		// protected properties
		// ========================================
		
		/**
		 * Indicates whether this operation has concluded.
		 */
		protected var concluded:Boolean = false;
		
		[ArrayElementType("mx.rpc.IResponder")]
		/**
		 * Subscribed responders.
		 */
		protected var responders:Array = [];
		
		// ========================================
		// constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function AbstractAsynchronousOperation()
		{
			super();
		}
		
		// ========================================
		// public methods
		// ========================================
		
		/**
		 * @inheritDoc
		 */
		public function addResponder( responder:IResponder ):void
		{
			responders.push( responder );
		}
		
		/**
		 * @inheritDoc
		 */
		public function complete( data:Object ):void
		{
			if ( ! concluded )
			{
				for each ( var responder:IResponder in responders )
				{
					responder.result( data );
				}
				
				concluded = true;
			}
			else
			{
				// TODO: Issue warning.
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function fail( info:Object ):void
		{
			if ( ! concluded )
			{
				for each ( var responder:IResponder in responders )
				{
					responder.fault( info );
				}
				
				concluded = true;
			}
			else
			{
				// TODO: Issue warning.
			}
		}
	}
}
