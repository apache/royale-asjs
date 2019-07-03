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
/***
 * Based on the
 * Swiz Framework library by Chris Scott, Ben Clinkinbeard, Sönke Rohde, John Yanarella, Ryan Campbell, and others https://github.com/swiz/swiz-framework
 */
package org.apache.royale.crux.utils.services
{
	import mx.rpc.IResponder;
	
	public class CruxResponder implements IResponder
	{
		private var resultHandler:Function;
		private var faultHandler:Function;
		private var handlerArgs:Array;
		
		public function CruxResponder(resultHandler:Function, faultHandler:Function = null, handlerArgs:Array = null )
		{
			this.resultHandler = resultHandler;
			this.faultHandler = faultHandler;
			this.handlerArgs = handlerArgs;
		}
		
		public function result( data:Object ):void
		{
			if( handlerArgs == null )
			{
				resultHandler( data );
			}
			else
			{
				resultHandler.apply( null, [ data ].concat( handlerArgs ) );
			}
		}
		
		public function fault( info:Object ):void
		{
			if( faultHandler != null )
			{
				if( handlerArgs == null )
				{
					faultHandler( info );
				}
				else
				{
					try
					{
						faultHandler( info );
					}
					catch( e:Error )
					{
						faultHandler.apply( null, [ info ].concat( handlerArgs ) );
					}
				}
			}
			else
			{
				// todo: what if there is no fault handler applied to dynamic responder
				// legacy comment: 'fails silently, maybe logging is smarter...'
			}
		}
	}
}
