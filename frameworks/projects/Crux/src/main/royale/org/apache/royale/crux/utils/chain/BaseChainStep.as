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
	public class BaseChainStep implements IChainStep
	{
		/**
		 * Backing variable for <code>chain</code> getter/setter.
		 */
		protected var _chain:IChain;
		
		/**
		 *
		 */
		public function get chain():IChain
		{
			return _chain;
		}
		
		public function set chain( value:IChain ):void
		{
			_chain = value;
		}
		
		/**
		 * Backing variable for <code>failed</code> property.
		 */
		protected var _failed:Boolean = false;
		
		/**
		 * Indicates whether this step failed.
		 */
		public function get failed():Boolean
		{
			return _failed;
		}
		
		/**
		 * Backing variable for <code>isComplete</code> property.
		 */
		protected var _isComplete:Boolean = false;
		
		public function get isComplete():Boolean
		{
			return _isComplete;
		}
		
		public function BaseChainStep()
		{
		
		}
		
		/**
		 *
		 */
		public function complete():void
		{
			// before calling complete(), check if the chain step has been marked as error
			if( !_failed)
			{
				_isComplete = true;
				
				if( chain != null )
					chain.stepComplete();
			}
		}
		
		/**
		 *
		 */
		public function error():void
		{
			_failed = true;
			_isComplete = true;
			
			if( chain != null )
				chain.stepError();
		}
	}
}
