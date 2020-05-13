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
package org.apache.royale.crux.utils.event
{
	COMPILE::SWF{
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	}
	COMPILE::JS{
	import org.apache.royale.events.Event;
	}
	import mx.rpc.AsyncToken;

	import org.apache.royale.crux.metadata.EventHandlerMetadataTag;
	import org.apache.royale.crux.reflection.MetadataHostMethod;
	import org.apache.royale.crux.reflection.MethodParameter;
	import org.apache.royale.crux.reflection.TypeCache;
	import org.apache.royale.crux.reflection.TypeDescriptor;
	import org.apache.royale.crux.utils.async.AsyncTokenOperation;
	import org.apache.royale.crux.utils.async.IAsynchronousEvent;
	import org.apache.royale.crux.utils.async.IAsynchronousOperation;
	import org.apache.royale.reflection.TypeDefinition;
	import org.apache.royale.reflection.VariableDefinition;
	import org.apache.royale.reflection.getQualifiedClassName;
	import org.apache.royale.reflection.utils.getMembersWithNameMatch;
	
	/**
	 * Represents a deferred request for mediation.
	 */
	public class EventHandler
	{
		// ========================================
		// protected properties
		// ========================================
		
		/**
		 * Backing variable for <code>metadata</code> property.
		 */
		protected var _metadataTag:EventHandlerMetadataTag;
		
		/**
		 * Backing variable for <code>method</code> property.
		 */
		protected var _method:Function;
		
		/**
		 * Backing variable for <code>eventClass</code> property.
		 */
		protected var _eventClass:Class;
		
		protected var _eventClassName:String;
		
		/**
		 * Backing variable for <code>domain</code> property.
		 */
		COMPILE::SWF
		protected var _domain:ApplicationDomain;
		COMPILE::JS
		protected var _domain:Object;
		
		/**
		 * Strongly typed reference to metadataTag.host
		 */
		protected var hostMethod:MetadataHostMethod;
		
		// ========================================
		// public properties
		// ========================================
		
		/**
		 * The corresponding [EventHandler] tag.
		 */
		public function get metadataTag():EventHandlerMetadataTag
		{
			return _metadataTag;
		}
		
		/**
		 * The function decorated with the [EventHandler] tag.
		 */
		public function get method():Function
		{
			return _method;
		}
		
		/**
		 * The Event class associated with the [EventHandler] tag's event type expression (if applicable).
		 */
		public function get eventClass():Class
		{
			return _eventClass;
		}
		
		/**
		 * The ApplicationDomain in which to operate.
		 */
		public function get domain():Object
		{
			return _domain;
		}
		
		// ========================================
		// constructor
		// ========================================
		
		/**
		 * Constructor
		 */
		public function EventHandler(metadataTag:EventHandlerMetadataTag, method:Function, eventClass:Class/*, domain:ApplicationDomain*/ )
		{
			_metadataTag = metadataTag;
			_method = method;
			_eventClass = eventClass;
			
			verifyTag();
		}
		
		// ========================================
		// public methods
		// ========================================
		
		/**
		 * HandleEvent
		 *
		 * @param event The Event to handle.
		 */
		public function handleEvent( event:Event ):void
		{
			// ignore if the event types do not match
			if( ( eventClass != null ) && !( event is eventClass ) )
				return;
			
			var result:* = null;
			
			if( metadataTag.properties != null )
			{
				if( validateEvent( event, metadataTag ) )
					result = method.apply( null, getEventArgs( event, metadataTag.properties ) );
			}
			else if( hostMethod.requiredParameterCount <= 1 )
			{
				if( hostMethod.parameterCount > 0 && event is getParameterType( 0 ) )
					result = method.apply( null, [ event ] );
				else
					result = method.call(null);
			}
			
			if( event is IAsynchronousEvent && IAsynchronousEvent( event ).step != null )
			{
				if( result is IAsynchronousOperation )
					IAsynchronousEvent( event ).step.addAsynchronousOperation( result as IAsynchronousOperation );
				else if( result is AsyncToken )
					IAsynchronousEvent( event ).step.addAsynchronousOperation( new AsyncTokenOperation( result as AsyncToken ) );
			}
			
			if( metadataTag.stopPropagation )
				event.stopPropagation();
			
			if( metadataTag.stopImmediatePropagation )
				event.stopImmediatePropagation();
		}
		
		// ========================================
		// protected methods
		// ========================================
		
		protected function verifyTag():void
		{
			hostMethod = MetadataHostMethod( metadataTag.host );
			
			if( metadataTag.properties == null && hostMethod.requiredParameterCount > 0 )
			{
				var eventClassDescriptor:TypeDescriptor = TypeCache.getTypeDescriptor( eventClass );
				var parameterTypeName:String = getQualifiedClassName( getParameterType( 0 ) );
				
				if( eventClassDescriptor.satisfiesType( parameterTypeName ) == false )
					throw new Error( metadataTag.asTag + " is invalid. If you do not specify a properties attribute your method must either accept no arguments or an object compatible with the type specified in the tag." );
			}
			
			if( metadataTag.properties != null && ( metadataTag.properties.length < hostMethod.requiredParameterCount || metadataTag.properties.length > hostMethod.parameterCount ) )
				throw new Error( "The properties attribute of " + metadataTag.asTag + " is not compatible with the method signature of " + hostMethod.name + "()." );
		}
		
		
		protected var accessChains:Object ;
		
		/**
		 * Validate Event
		 *
		 * Evalutes an Event to ensure it has all of the required properties specified in the [EventHandler] tag, if applicable.
		 *
		 * @param event The Event to validate.
		 * @param properties The required properties specified in the [EventHandler] tag.
		 * @returns A Boolean value indicating whether the event has all of the required properties specified in the [EventHandler] tag.
		 */
		protected function validateEvent( event:Event, metadataTag:EventHandlerMetadataTag ):Boolean
		{
			
			if (!accessChains) {
				//set up access chains
				accessChains = {};
				var eventClassDescriptor:TypeDescriptor = TypeCache.getTypeDescriptor( eventClass );
				var eventDefinition:TypeDefinition = eventClassDescriptor.typeDefinition;
				_eventClassName = eventDefinition.qualifiedName;
				for each( var property:String in metadataTag.properties )
				{
					var chain:Array = property.split( "." );
					var accessChain:Array = [];
					var definition:TypeDefinition = eventDefinition;
					while (chain.length) {
						var prop:String = chain.shift();
						var search:Array = getMembersWithNameMatch(definition.variables,prop);
						if (search.length==0) getMembersWithNameMatch(definition.accessors,prop, search);
						if (search.length != 1) {
							throw new Error( "Unable to handle event: " + property + " does not exist as a property of " + eventClassDescriptor.className + "." );
						}
						var varDef:VariableDefinition = search[0];
						accessChain.push(varDef);
						if (chain.length) {
							//continue with next definition
							definition = varDef.type;
						}
					}
					accessChains[property] = accessChain;
				}
			}
			//now validate it
			for each( property in metadataTag.properties )
			{
				accessChain = accessChains[property];
				var o:Object = event;
				if (accessChain.length > 1) {
					var index:int = 0;
					var l:int = accessChain.length-1;
					while (index<l) {
						if (o == null) {
							throw new Error( "Unable to handle event: " + varDef.name + " is null as a property of " + _eventClassName + " as defined in " + metadataTag.asTag + "." );
						}
						varDef = accessChain[index];
						o = varDef.getValue(o)
					}
				}
				
			}
			
			return true;
		}
		
		/**
		 * Get Event Arguments
		 *
		 * @param event
		 * @param properties
		 */
		protected function getEventArgs( event:Event, properties:Array ):Array
		{
			var args:Array = [];
			
			for each( var property:String in properties )
			{
				
				var varDef:VariableDefinition;
				var chain:Array = accessChains[property];
				var l:uint = chain.length;
				if (l == 1) {
					varDef = chain[0];
					args[ args.length ] = VariableDefinition(chain[0]).getValue(event);
				} else {
					var o:Object = event;
					for (var i:int=0; i<l;i++) {
						o = VariableDefinition(chain[i]).getValue(o);
					}
					args[ args.length ] = o
				}
				
			}
			return args;
		}
		
		/**
		 * Get Parameter Type
		 *
		 * @param parameterIndex The index of parameter of the event handler method.
		 * @returns The type for the specified parameter.
		 */
		protected function getParameterType( parameterIndex:int ):Class
		{
			var parameters:Array = hostMethod.parameters;
			
			if( parameterIndex < parameters.length )
				return ( parameters[ parameterIndex ] as MethodParameter ).type;
			
			return null;
		}
	}
}
