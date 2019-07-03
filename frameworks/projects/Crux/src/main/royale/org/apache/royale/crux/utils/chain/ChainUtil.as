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
package org.apache.royale.crux.utils.chain
{
	import org.apache.royale.events.IEventDispatcher;
	
	import org.apache.royale.crux.IDispatcherAware;
	
	public class ChainUtil implements IDispatcherAware
	{
		private var _dispatcher:IEventDispatcher;
		
		public function ChainUtil()
		{
		}
		
		/** IDispatcherAware implementation */
		public function set dispatcher( dispatcher:IEventDispatcher ):void
		{
			_dispatcher = dispatcher;
		}
		
		/** Constructs a dynamic command */
		public function createCommand( delayedCall:Function, args:Array, resultHandler:Function,
									   faultHandler:Function = null, resultHandlerArgs:Array = null ):AsyncCommandChainStep
		{
			return new AsyncCommandChainStep( delayedCall, args, resultHandler, faultHandler, resultHandlerArgs );
		}
		
		/** Constructs a dynamic command */
		public function createChain( mode:String = ChainType.SEQUENCE ):CommandChain
		{
			return new CommandChain( mode );
		}
	}
}
