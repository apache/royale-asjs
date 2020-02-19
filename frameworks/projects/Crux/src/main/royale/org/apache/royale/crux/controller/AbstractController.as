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
package org.apache.royale.crux.controller
{
	COMPILE::SWF{
		import flash.net.URLLoader;
		import flash.net.URLRequest;
	}
	COMPILE::JS{
		import org.apache.royale.net.URLLoader;
		import org.apache.royale.net.URLRequest;
	}	
	import mx.rpc.AsyncToken;

	import org.apache.royale.crux.ICrux;
	import org.apache.royale.crux.ICruxAware;
	import org.apache.royale.crux.IDispatcherAware;
	import org.apache.royale.crux.utils.chain.AsyncCommandChainStep;
	import org.apache.royale.crux.utils.chain.ChainType;
	import org.apache.royale.crux.utils.chain.CommandChain;
	import org.apache.royale.crux.utils.services.CruxResponder;
	import org.apache.royale.crux.utils.services.CruxURLRequest;
	import org.apache.royale.events.IEventDispatcher;
	
	/**
	 *
	 *   @royalesuppresspublicvarwarning
	 */
	public class AbstractController implements ICruxAware, IDispatcherAware
	{
		public var _crux:ICrux;
		private var _dispatcher:IEventDispatcher;
		
		public function AbstractController()
		{
		}
		
		public function set crux( crux :ICrux ):void
		{
			_crux = crux;
		}
		
		/** IDispatcherAware implementation */
		public function set dispatcher( dispatcher:IEventDispatcher ):void
		{
			_dispatcher = dispatcher;
		}
		
		public function get dispatcher():IEventDispatcher
		{
			return _dispatcher;
		}
		
		/** Delegates execute service call to Crux */
		protected function executeServiceCall( call:AsyncToken, resultHandler:Function,
											   faultHandler:Function = null, handlerArgs:Array = null ):AsyncToken
		{
			
			if( faultHandler == null && _crux.config.defaultFaultHandler != null )
				faultHandler = _crux.config.defaultFaultHandler;
			
			call.addResponder( new CruxResponder(resultHandler, faultHandler, handlerArgs ) );
			
			return call;
		}
		
		/** Delegates execute url request call to Crux */
		protected function executeURLRequest( request:URLRequest, resultHandler:Function, faultHandler:Function = null,
											  progressHandler:Function = null, httpStatusHandler:Function = null,
											  handlerArgs:Array = null ):URLLoader
		{
			
			if( faultHandler == null && _crux.config.defaultFaultHandler != null )
				faultHandler = _crux.config.defaultFaultHandler;
			
			return new CruxURLRequest(request, resultHandler, faultHandler, progressHandler, httpStatusHandler, handlerArgs ).loader;
		}
		
		/** Delegates create command to Crux */
		protected function createCommand( delayedCall:Function, args:Array, resultHandler:Function,
										  faultHandler:Function = null, handlerArgs:Array = null ):AsyncCommandChainStep
		{
			return new AsyncCommandChainStep( delayedCall, args, resultHandler, faultHandler, handlerArgs );
		}
		
		/** Constructs a dynamic command */
		public function createChain( mode:String = ChainType.SEQUENCE ):CommandChain
		{
			return new CommandChain( mode );
		}
	}
}
