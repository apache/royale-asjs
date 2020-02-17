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
	import org.apache.royale.crux.events.ChainEvent;
	import org.apache.royale.crux.utils.chain.IChain;
	
	public class AsynchronousChainOperation extends AbstractAsynchronousOperation implements IAsynchronousOperation
	{
		// ========================================
		// constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function AsynchronousChainOperation(chain:IChain )
		{
			super();
			
			addEventListeners( chain );
		}
		
		// ========================================
		// protected methods
		// ========================================
		
		/**
		 * Add ChainEvent listeners to the specified chain.
		 */
		protected function addEventListeners( chain:IChain ):void
		{
			chain.addEventListener( ChainEvent.CHAIN_COMPLETE, chainCompleteHandler );
			chain.addEventListener( ChainEvent.CHAIN_FAIL, chainFailHandler );
		}
		
		/**
		 * Remove ChainEvent listeners from the specified chain.
		 */
		protected function removeEventListeners( chain:IChain ):void
		{
			chain.removeEventListener( ChainEvent.CHAIN_COMPLETE, chainCompleteHandler );
			chain.removeEventListener( ChainEvent.CHAIN_FAIL, chainFailHandler );			
		}
		
		/**
		 * Handle ChainEvent.CHAIN_COMPLETE.
		 */
		protected function chainCompleteHandler( event:ChainEvent ):void
		{
			var chain:IChain = event.target as IChain;
			
			removeEventListeners( chain );
			
			complete( chain );
		}
		
		/**
		 * Handle ChainEvent.CHAIN_FAIL.
		 */
		protected function chainFailHandler( event:ChainEvent ):void
		{
			var chain:IChain = event.target as IChain;
			
			removeEventListeners( chain );
			
			fail( chain );
		}
	}
}
