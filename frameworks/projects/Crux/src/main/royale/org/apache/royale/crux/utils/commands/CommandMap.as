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
package org.apache.royale.crux.utils.commands
{
	import org.apache.royale.events.Event;

	import org.apache.royale.crux.Bean;
	import org.apache.royale.crux.ICrux;
	import org.apache.royale.crux.ICruxAware;
	import org.apache.royale.crux.Prototype;
	import org.apache.royale.crux.reflection.TypeCache;
	
	
	/**
	 * Class used to map events to the commands they should trigger.
	 */
	public class CommandMap implements ICruxAware
	{
		// ========================================
		// protected properties
		// ========================================
		
		/**
		 * Backing variable for crux setter.
		 */
		protected var _crux:ICrux;
		
		/**
		 * Object hash to hold mappings (only string keys needed).
		 */
		protected var map:Object = {};
		
		
		// ========================================
		// public properties
		// ========================================
		
		/**
		 * Setter to satisfy ICruxAware interface contract.
		 * 
		 * @see org.apache.royale.crux.core.ICruxAware
		 */
		public function set crux( crux:ICrux ):void
		{
			// if crux is null, we are being torn down
			if( crux )
			{
				_crux = crux;
				mapCommands();
			}
			else
			{
				unmapCommands();
				_crux = crux;
			}
		}
		
		// ========================================
		// protected methods
		// ========================================
		
		/**
		 * Handler method triggered when a mapped event is caught.
		 */
		protected function handleCommandEvent( event:Event ):void
		{
			// make sure we have a mapping
			if( map[ event.type ] != null )
			{
				var indexesToClear:Array = [];
				var mappings:Array = map[ event.type ] as Array;
				
				for( var i:int = 0; i < mappings.length; i++ ) 
				{
					// retrieve mapping
					var commandMapping:CommandMapping = CommandMapping( mappings[ i ] );
					
					// validate event class
					if( !( event is commandMapping.eventClass ) )
						continue;
					
					// get our command bean
					var commandPrototype:Bean = _crux.beanFactory.getBeanByType( commandMapping.commandClass );
					
					if( commandPrototype == null )
						throw new Error( "Command bean not found for mapped event type." );
					
					if( commandPrototype is Prototype )
					{
						// get a new instance of the command class
						var command:Object = Prototype( commandPrototype ).source;
						
						if( !( command is ICommand ) )
							throw new Error( "Commands must implement org.apache.royale.crux.utils.commands.ICommand." );
						
						// provide event reference if command is IEventAwareCommand
						if( command is IEventAwareCommand )
							IEventAwareCommand( command ).event = event;
						
						ICommand( command ).execute();
					}
					else
					{
						throw new Error( "Commands must be provided as Prototype beans." );
					}
					
					if( commandMapping.oneTime )
						indexesToClear.push( i );
				}
				
				if( indexesToClear.length > 0 )
				{
					for( var j:int = indexesToClear.length - 1; j > -1; j-- )
					{
						mappings.splice( indexesToClear[ j ], 1 );
					}
					
					// if no more commands are mapped to this event type, remove from map
					if( mappings.length == 0 )
						delete map[ event.type ];
				}
			}
		}
		
		/**
		 * Abstract method that sub classes should override and populate with calls to <code>mapCommand()</code>.
		 * Mapping commands here (and letting it be called for you) ensures all the necessary pieces have
		 * been provided before attempting to create any mappings.
		 */
		protected function mapCommands():void
		{
			// do nothing, subclasses must override
		}
		
		/**
		 * Method that performs actual event to command mapping.
		 */
		protected function mapCommand( eventType:String, commandClass:Class, eventClass:Class = null, oneTime:Boolean = false ):void
		{
			if( map[ eventType ] == null )
			{
				map[ eventType ] = [ new CommandMapping( eventType, commandClass, eventClass, oneTime ) ];
			}
			else
			{
				var mappings:Array = map[ eventType ] as Array;
				
				for each( var cm:CommandMapping in mappings )
				{
					if( cm.commandClass == commandClass )
						throw new Error( cm.commandClass + " already mapped to " + eventType );
				}
				
				mappings.push( new CommandMapping( eventType, commandClass, eventClass, oneTime ) );
			}
			
			// create Prototype bean for commandClass if it hasn't been created already
			if( _crux.beanFactory.getBeanByType( commandClass ) == null )
			{
				// create a Prototype for adding to the BeanFactory
				var commandPrototype:Prototype = new Prototype( commandClass );
				commandPrototype.typeDescriptor = TypeCache.getTypeDescriptor( commandClass/*, _crux.domain*/ );
				// add command bean for later instantiation
				_crux.beanFactory.addBean( commandPrototype, false );
			}
			
			// listen for event that will trigger this command
			_crux.dispatcher.addEventListener( eventType, handleCommandEvent );
		}
		
		protected function unmapCommands():void
		{
			for( var eventType:String in map )
			{
				_crux.dispatcher.removeEventListener( eventType, handleCommandEvent );
				
				delete map[ eventType ];
			}
			
			map = null;
		}
	}
}
import org.apache.royale.events.Event;

/**
 * Inner class used to hold the details of a mapping.
 */
class CommandMapping
{
	public var eventType:String;
	public var commandClass:Class;
	public var eventClass:Class;
	public var oneTime:Boolean;
	
	public function CommandMapping( eventType:String, commandClass:Class, eventClass:Class = null, oneTime:Boolean = false )
	{
		this.eventType = eventType;
		this.commandClass = commandClass;
		this.eventClass = eventClass || Event;
		this.oneTime = oneTime;
	}
}
