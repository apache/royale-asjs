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

	public interface IAsynchronousOperation
	{
		/**
		 * Add a responder to be notified of operation completion or failure.
		 */
		function addResponder( responder:IResponder ):void;
		
		/**
		 * Notify registered responders that this operation is complete.
		 */
		function complete( data:Object ):void;
		
		/**
		 * Notify registered responders that this operation has failed.
		 */
		function fail( info:Object ):void;
	}
}
