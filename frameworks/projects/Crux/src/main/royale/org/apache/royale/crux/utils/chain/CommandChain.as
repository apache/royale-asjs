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
package org.apache.royale.crux.utils.chain
{
	public class CommandChain extends BaseCompositeChain
	{
		// ========================================
		// constructor
		// ========================================

		/**
		 * Constructor.
		 */
		public function CommandChain(mode:String = ChainType.SEQUENCE, stopOnError:Boolean = true )
		{
			super( mode, stopOnError );
		}
		
		// ========================================
		// public methods
		// ========================================
		
		/**
		 * Add an CommandChainStep to this EventChain.
		 */
		public function addCommand( command:CommandChainStep ):CommandChain
		{
			addStep( command );
			return this;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function doProceed():void
		{
			if( currentStep is CommandChainStep )
				CommandChainStep( currentStep ).doProceed();
			else
				super.doProceed();
		}
	}
}
