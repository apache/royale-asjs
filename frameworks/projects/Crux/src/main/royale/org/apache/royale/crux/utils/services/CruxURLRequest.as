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
	import org.apache.royale.events.Event;
	import org.apache.royale.net.HTTPConstants;

	COMPILE::SWF{
		import flash.net.URLLoader;
		import flash.net.URLRequest;
		import flash.events.ProgressEvent
	}
	COMPILE::JS{
		import org.apache.royale.net.URLLoader;
		import org.apache.royale.net.URLRequest;
		import org.apache.royale.events.ProgressEvent
	}
	
	/**
	 *
	 * CruxURLRequest can be used to wrap URLLoader calls.
	 * The faultHandler function will be used for IOErrors and SecurityErrors
	 * so you should type the argument Event and check/cast the specific type
	 * in the method body.
	 *
	 * When used implicitly from Crux.executeUrlRequest or AbstractController.executeUrlRequest
	 * the generic fault handler will be applied if available. Otherwise in an error case
	 * the Crux internal generic fault shows up.
	 *
	 *   @royalesuppresspublicvarwarning
	 */
	public class CruxURLRequest
	{
		public var loader:URLLoader;
		
		/**
		 *
		 * @param request
		 * @param resultHandler The resultHandler function must expect the an event. event.currentTarget.data should contain the result. Signature can be extended with additional handlerArgs
		 * @param faultHandler The faultHandler function will be called for IOErrors and SecurityErrors with the specific error event.
		 * @param progressHandler
		 * @param httpStatusHandler
		 * @param handlerArgs The handlerArgs will be applied to the signature of the resultHandler function.
		 *
		 */
		public function CruxURLRequest(request:URLRequest, resultHandler:Function,
		                                    faultHandler:Function = null, progressHandler:Function = null,
		                                    httpStatusHandler:Function = null, handlerArgs:Array = null )
		{
			loader = new URLLoader();
			
			loader.addEventListener( HTTPConstants.COMPLETE, function( e:Event ):void
				{
					// we could apply the result directly but from the current knowledge applying the event itself
					// seems more flexible. This may change in the future if we don't see any necessity for this.
					
					if( handlerArgs == null )
					{
						resultHandler( e );
					}
					else
					{
						resultHandler.apply( null, [ e ].concat( handlerArgs ) );
					}
				} );
			
			if( faultHandler != null )
			{
				loader.addEventListener( HTTPConstants.IO_ERROR, function( e:Event ):void
					{
						if( handlerArgs == null )
						{
							faultHandler( e );
						}
						else
						{
							faultHandler.apply( null, [ e ].concat( handlerArgs ) );
						}
					} );
				
				loader.addEventListener( HTTPConstants.SECURITY_ERROR, function( e:Event ):void
					{
						if( handlerArgs == null )
						{
							faultHandler( e );
						}
						else
						{
							faultHandler.apply( null, [ e ].concat( handlerArgs ) );
						}
					} );
			}
			
			if( progressHandler != null )
			{
				loader.addEventListener( ProgressEvent.PROGRESS, function( e:ProgressEvent ):void
					{
						if( handlerArgs == null )
						{
							progressHandler( e );
						}
						else
						{
							progressHandler.apply( null, [ e ].concat( handlerArgs ) );
						}
					} );
			}
			
			if( httpStatusHandler != null )
			{
				loader.addEventListener( HTTPConstants.STATUS, function( e:Event ):void
					{
						if( handlerArgs == null )
						{
							httpStatusHandler( e );
						}
						else
						{
							httpStatusHandler.apply( null, [ e ].concat( handlerArgs ) );
						}
					} );
			}
			
			loader.load( request );
		}
	}
}
