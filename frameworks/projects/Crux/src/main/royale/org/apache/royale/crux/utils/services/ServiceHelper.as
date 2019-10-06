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
package org.apache.royale.crux.utils.services
{
	import mx.rpc.AsyncToken;

	import org.apache.royale.crux.ICrux;
	import org.apache.royale.crux.ICruxAware;

	public class ServiceHelper implements IServiceHelper, ICruxAware
	{
		protected var _crux:ICrux;

		public function set crux( crux:ICrux ):void
		{
			_crux = crux;
		}

		public function executeServiceCall( call:AsyncToken, resultHandler:Function, faultHandler:Function = null, handlerArgs:Array = null ):AsyncToken
		{
			// use default fault handler defined for crux instance if not provided
			// check if crux is set which is not the case if ServiceHelper is used in a testing environment
			if( faultHandler == null && _crux != null && _crux.config.defaultFaultHandler != null )
				faultHandler = _crux.config.defaultFaultHandler;

			call.addResponder( new CruxResponder(resultHandler, faultHandler, handlerArgs ) );
			
			return call;
		}
	}
}
