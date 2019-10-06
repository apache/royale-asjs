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
	COMPILE::SWF{
		import flash.net.URLLoader;
		import flash.net.URLRequest;
	}
	COMPILE::JS{
		import org.apache.royale.net.URLLoader;
		import org.apache.royale.net.URLRequest;
	}

	import org.apache.royale.crux.ICrux;
	import org.apache.royale.crux.ICruxAware;
	
	public class URLRequestHelper implements IURLRequestHelper, ICruxAware
	{
		protected var _crux:ICrux;
		
		public function set crux( crux:ICrux ):void
		{
			_crux = crux;
		}
		
		/** Delegates execute url request call to Crux */
		public function executeURLRequest( request:URLRequest, resultHandler:Function, faultHandler:Function = null,
										   progressHandler:Function = null, httpStatusHandler:Function = null,
										   handlerArgs:Array = null ):URLLoader
		{
			// use default fault handler defined for crux instance if not provided
			if( faultHandler == null && _crux.config.defaultFaultHandler != null )
				faultHandler = _crux.config.defaultFaultHandler;
			
			return new CruxURLRequest(request, resultHandler, faultHandler, progressHandler, httpStatusHandler, handlerArgs ).loader;
		}
	}
}
