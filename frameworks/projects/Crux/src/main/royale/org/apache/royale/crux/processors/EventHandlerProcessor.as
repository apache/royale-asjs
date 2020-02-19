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
package org.apache.royale.crux.processors
{
	COMPILE::SWF{
		import flash.utils.Dictionary;
	}
	
	COMPILE::JS {
		import org.apache.royale.utils.Language;
	}
	import org.apache.royale.crux.Bean;
	import org.apache.royale.crux.CruxConfig;
	import org.apache.royale.crux.metadata.EventHandlerMetadataTag;
	import org.apache.royale.crux.metadata.EventTypeExpression;
	import org.apache.royale.crux.reflection.ClassConstant;
	import org.apache.royale.crux.reflection.IMetadataTag;
	import org.apache.royale.crux.reflection.TypeCache;
	import org.apache.royale.crux.reflection.TypeDescriptor;
	import org.apache.royale.crux.utils.event.EventHandler;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.reflection.getQualifiedClassName;
	import org.apache.royale.reflection.utils.getMembersWithNameMatch;
//	import org.apache.royale.crux.utils.logging.CruxLogger;
	
	/**
	 * EventHandler Processor
	 */
	public class EventHandlerProcessor extends BaseMetadataProcessor
	{
		// ========================================
		// protected static constants
		// ========================================
		
		protected static const EVENT_HANDLER:String = "EventHandler";
		protected static const MEDIATE:String = "Mediate";
		
		// ========================================
		// protected properties
		// ========================================
		
	//	protected var logger:CruxLogger = CruxLogger.getLogger( this );
		COMPILE::SWF
		protected var eventHandlersByEventType:Dictionary = new Dictionary();
		COMPILE::JS
		protected var eventHandlersByEventType:Map = new Map();

		protected var eventHandlerClass:Class = EventHandler;
		
		// ========================================
		// public properties
		// ========================================
		
		/**
		 *
		 */
		override public function get priority():int
		{
			return ProcessorPriority.EVENT_HANDLER;
		}
		
		// ========================================
		// constructor
		// ========================================
		
		/**
		 * Constructor
		 */
		public function EventHandlerProcessor(metadataNames:Array = null )
		{
			super( ( metadataNames == null ) ? [ EVENT_HANDLER, MEDIATE ] : metadataNames, EventHandlerMetadataTag );
		}
		
		// ========================================
		// public methods
		// ========================================
		
		/**
		 * @inheritDoc
		 */
		override public function setUpMetadataTag( metadataTag:IMetadataTag, bean:Bean ):void
		{
			var eventHandlerTag:EventHandlerMetadataTag = metadataTag as EventHandlerMetadataTag;
			
			if( validateEventHandlerMetadataTag( eventHandlerTag ) )
			{
				var expression:EventTypeExpression = new EventTypeExpression( eventHandlerTag.event, crux );
				for each( var eventType:String in expression.eventTypes )
				{
					var method:Function = bean.source[ eventHandlerTag.host.name ] as Function;
					COMPILE::JS {
						method = Language.closure(method, bean.source, eventHandlerTag.host.name);
					}
					
					addEventHandlerByEventType( eventHandlerTag, method, expression.eventClass, eventType );
				}
			}
			
		}
		
		/**
		 * @inheritDoc
		 */
		override public function tearDownMetadataTag( metadataTag:IMetadataTag, bean:Bean ):void
		{
			var eventHandlerTag:EventHandlerMetadataTag = metadataTag as EventHandlerMetadataTag;
			
			var expression:EventTypeExpression = new EventTypeExpression( eventHandlerTag.event, crux );
			for each( var eventType:String in expression.eventTypes )
			{
				var method:Function = bean.source[ eventHandlerTag.host.name ] as Function;
				COMPILE::JS {
					method = Language.closure(method, bean.source, eventHandlerTag.host.name);
				}
				
				removeEventHandlerByEventType( eventHandlerTag, method, expression.eventClass, eventType );
			}
			
		}
		
		// ========================================
		// protected methods
		// ========================================
		
		/**
		 * Add Mediator By Event Type
		 */
		protected function addEventHandlerByEventType( eventHandlerTag:EventHandlerMetadataTag, method:Function, eventClass:Class, eventType:String ):void
		{
			var eventHandler:EventHandler = new eventHandlerClass( eventHandlerTag, method, eventClass);

			COMPILE::SWF{
				eventHandlersByEventType[ eventType ] ||= [];
				eventHandlersByEventType[ eventType ].push( eventHandler );
			}
			COMPILE::JS{
				var eventTypeHandlers:Array = eventHandlersByEventType.get(eventType);
				if (!eventTypeHandlers) {
					eventTypeHandlers = [];
					eventHandlersByEventType.set(eventType, eventTypeHandlers);
				}
				eventTypeHandlers.push( eventHandler );
			}
			
			var dispatcher:IEventDispatcher = null;
			
			// if the eventHandler tag defines a scope, set proper dispatcher, else use defaults
			if( eventHandlerTag.scope == CruxConfig.GLOBAL_DISPATCHER )
				dispatcher = crux.globalDispatcher;
			else if( eventHandlerTag.scope == CruxConfig.LOCAL_DISPATCHER )
				dispatcher = crux.dispatcher;
			else
				dispatcher = crux.config.defaultDispatcher == CruxConfig.LOCAL_DISPATCHER ? crux.dispatcher : crux.globalDispatcher;
			//type:String,handler:Function,opt_capture:Boolean = false
			dispatcher.addEventListener( eventType, eventHandler.handleEvent, eventHandlerTag.useCapture/*, eventHandlerTag.priority, true*/ );
		}
		
		/**
		 * Remove Mediator By Event Type
		 */
		protected function removeEventHandlerByEventType( eventHandlerTag:EventHandlerMetadataTag, method:Function, eventClass:Class, eventType:String ):void
		{	
			var dispatcher:IEventDispatcher = null;
			
			// if the eventHandler tag defines a scope, set proper dispatcher, else use defaults
			if( eventHandlerTag.scope == CruxConfig.GLOBAL_DISPATCHER )
				dispatcher = crux.globalDispatcher;
			else if( eventHandlerTag.scope == CruxConfig.LOCAL_DISPATCHER )
				dispatcher = crux.dispatcher;
			else
				dispatcher = crux.config.defaultDispatcher == CruxConfig.LOCAL_DISPATCHER ? crux.dispatcher : crux.globalDispatcher;


			COMPILE::SWF{
				var eventTypeHandlers :Array = eventHandlersByEventType[eventType];
			}
			COMPILE::JS{
				var eventTypeHandlers :Array = eventHandlersByEventType.get(eventType);
			}


			if( eventTypeHandlers )
			{
				var eventHandlerIndex:int = 0;
				for each( var eventHandler:EventHandler in eventTypeHandlers )
				{
					if( ( eventHandler.method == method ) && ( eventHandler.eventClass == eventClass ) )
					{
						dispatcher.removeEventListener( eventType, eventHandler.handleEvent, eventHandlerTag.useCapture );

						eventTypeHandlers.splice( eventHandlerIndex, 1 );
						break;
					}
					
					eventHandlerIndex++;
				}
				
				if( eventTypeHandlers.length == 0 ){
					COMPILE::SWF{
						delete eventHandlersByEventType[ eventType ];
					}
					COMPILE::JS{
						eventHandlersByEventType.delete( eventType );
					}
				}

			}
		}
		
		/**
		 * Parse Event Type Expression
		 *
		 * Processes an event type expression into an event type. Accepts a String specifying either the event type
		 * (ex. 'type') or a class constant reference (ex. 'SomeEvent.TYPE').  If a class constant reference is specified,
		 * it will be evaluated to obtain its String value.
		 *
		 * Class constant references are only supported in 'strict' mode.
		 *
		 * @param value A String that defines an Event type expression.
		 * @returns The event type.
		 */
		protected function parseEventTypeExpression( value:String ):String
		{
			if( crux.config.strict && ClassConstant.isClassConstant( value ) )
			{
				return ClassConstant.getConstantValue( ClassConstant.getClass(value, crux.config.eventPackages ), ClassConstant.getConstantName( value ) );
			}
			else
			{
				return value;
			}
		}
		
		/**
		 * Validate EventHandler Metadata Tag
		 *
		 * @param mediator The EventHandlerMetadataTag
		 */
		protected function validateEventHandlerMetadataTag( eventHandlerTag:EventHandlerMetadataTag ):Boolean
		{
			if( eventHandlerTag.event == null || eventHandlerTag.event.length == 0 )
			{
				throw new Error( "Missing \"event\" property in [EventHandler] tag: " + eventHandlerTag.asTag );
			}
			
			if( ClassConstant.isClassConstant( eventHandlerTag.event ) )
			{
				var eventClass:Class = ClassConstant.getClass( eventHandlerTag.event, crux.config.eventPackages );
				
				if( eventClass == null )
					throw new Error( "Could not get a reference to class for " + eventHandlerTag.event + ". Did you specify its package in cruxConfig::eventPackages?" );
				
				var descriptor:TypeDescriptor = TypeCache.getTypeDescriptor( eventClass);
				
				
				for each( var property:String in eventHandlerTag.properties )
				{
					var checkList:Array = [];
					getMembersWithNameMatch(descriptor.typeDefinition.variables, property, checkList);
					if (checkList.length == 0) {
						getMembersWithNameMatch(descriptor.typeDefinition.accessors, property, checkList);
					}
					
					if(checkList.length == 0 )
					{
						throw new Error( "Unable to handle event: " + property + " does not exist as a property of " + getQualifiedClassName( eventClass ) + "." );
					}
				}
	
			}
			
			return true;
		}
	
	}
}
