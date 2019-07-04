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
	import org.apache.royale.events.EventDispatcher;
	
	import org.apache.royale.crux.events.ChainEvent;
	
	[Event( name="chainStart",			type="org.apache.royale.crux.events.ChainEvent" )]
	[Event( name="chainStepComplete",	type="org.apache.royale.crux.events.ChainEvent" )]
	[Event( name="chainStepError",		type="org.apache.royale.crux.events.ChainEvent" )]
	[Event( name="chainComplete",		type="org.apache.royale.crux.events.ChainEvent" )]
	[Event( name="chainFail",			type="org.apache.royale.crux.events.ChainEvent" )]
	/**
	 *
	 *   @royalesuppresspublicvarwarning
	 */
	public class AbstractChain extends EventDispatcher implements IChainStep
	{
		public var mode:String = ChainType.SEQUENCE;
		
		public var steps:Array = [];
		
		public function get currentStep():IChainStep
		{
			return IChainStep( steps[ position ] );
		}
		
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
		
		protected var _isComplete:Boolean = true;
		protected var _isError:Boolean = false;
		
		public function get isComplete():Boolean
		{
			return _isComplete;
		}
		
		public function get isError():Boolean
		{
			return _isError;
		}
		
		/**
		 * Backing variable for <code>position</code> getter/setter.
		 */
		protected var _position:int = -1;
		
		/**
		 *
		 */
		public function get position():int
		{
			return _position;
		}
		
		public function set position( value:int ):void
		{
			_position = value;
		}
		
		/**
		 * Backing variable for <code>stopOnError</code> getter/setter.
		 */
		protected var _stopOnError:Boolean;
		
		/**
		 *
		 */
		public function get stopOnError():Boolean
		{
			return _stopOnError;
		}
		
		public function set stopOnError( value:Boolean ):void
		{
			_stopOnError = value;
		}
		
		public function AbstractChain(mode:String = ChainType.SEQUENCE, stopOnError:Boolean = true )
		{
			this.mode = mode;
			this.stopOnError = stopOnError;
		}
		
		/**
		 *
		 */
		public function addStep( step:IChainStep ):IChain
		{
			step.chain = IChain( this );
			steps.push( step );
			return IChain( this );
		}
		
		/**
		 *
		 */
		public function hasNext():Boolean
		{
			return position + 1 < steps.length;
		}
		
		/**
		 *
		 */
		public function start():void
		{
			if( _isComplete )
			{
				_isComplete = false;
				_isError = false;
				position = -1;
				proceed();
			}
		}
		
		public function stepComplete():void
		{
			dispatchEvent( new ChainEvent( ChainEvent.CHAIN_STEP_COMPLETE ) );
			if( mode == ChainType.SEQUENCE )
			{
				proceed();
			}
			else
			{
				for( var i:int = 0; i < steps.length; i++ )
				{
					if( !IChainStep( steps[ i ] ).isComplete )
						return;
				}
				complete();
			}
		}
		
		/**
		 *
		 */
		public function proceed():void
		{
			if( position == -1 )
				dispatchEvent( new ChainEvent( ChainEvent.CHAIN_START ) );
			
			if( !_isError )
			{
				if( mode == ChainType.SEQUENCE )
				{
					if( hasNext() )
					{
						position++;
						IChain( this ).doProceed();
					}
					else
					{
						complete();
					}
				}
				else
				{
					for( var i:int = 0; i < steps.length; i++ )
					{
						position = i;
						IChain( this ).doProceed();
					}
				}
			}
		}
		
		/**
		 *
		 */
		public function stepError():void
		{
			dispatchEvent( new ChainEvent( ChainEvent.CHAIN_STEP_ERROR ) );
			
			if( !stopOnError )
				proceed();
			else
				fail();
		}
		
		/**
		 *
		 */
		public function complete():void
		{
			dispatchEvent( new ChainEvent( ChainEvent.CHAIN_COMPLETE ) );
			
			_isComplete = true;
			
			if( chain != null )
				chain.stepComplete();
		}
		
		/**
		 *
		 */
		public function error():void
		{
			fail();
		}
		
		/**
		 *
		 */
		protected function fail():void
		{
			dispatchEvent( new ChainEvent( ChainEvent.CHAIN_FAIL ) );
			
			_isError = true;
			_isComplete = true;
			
			if( chain != null )
				chain.stepError();
		}
	}
}
