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
package org.apache.royale.crux.metadata
{
    import org.apache.royale.crux.reflection.BaseMetadataTag;
    import org.apache.royale.crux.reflection.IMetadataTag;

    /**
	 * Class to represent <code>[EventHandler]</code> (and deprecated [Mediate]) metadata tags.
	 */
	public class EventHandlerMetadataTag extends BaseMetadataTag
	{
		/**
		 * Backing variable for read-only <code>event</code> property.
		 */
		protected var _event:String;
		
		/**
		 * Backing variable for read-only <code>properties</code> property.
		 */
		protected var _properties:Array;
		
		/**
		 * Backing variable for read-only <code>scope</code> property.
		 */
		protected var _scope:String;
		
		/**
		 * Backing variable for read-only <code>priority</code> property.
		 */
		protected var _priority:int = 0;
		
		/**
		 * Backing variable for read-only <code>stopPropagation</code> property.
		 */
		protected var _stopPropagation:Boolean = false;
		
		/**
		 * Backing variable for read-only <code>stopImmediatePropagation</code> property.
		 */
		protected var _stopImmediatePropagation:Boolean = false;
		
		/**
		 * Backing variable for read-only <code>useCapture</code> property.
		 */
		protected var _useCapture:Boolean = false;
		
		/**
		 * Returns event attribute of [EventHandler] tag.
		 * Refers to the event type that will trigger the decorated method.
		 * Is the default attribute, meaning [EventHandler( "someEvent" )] is
		 * equivalent to [EventHandler( event="someEvent" )].
		 */
		public function get event():String
		{
			return _event;
		}
		
		/**
		 * Returns properties attribute of [EventHandler] tag as an <code>Array</code>.
		 * Lists properties that will be pulled off of the event object and passed
		 * to the decorated method.
		 */
		public function get properties():Array
		{
			return _properties;
		}
		
		/**
		 * Returns scope attribute of [EventHandler] tag as a <code>String</code>.
		 * Defines which dispatcher to attach this mediator to on the owning Crux instance.
		 * Acceptable values are local, global and [parent], defined as constants on CruxConfig
		 */
		public function get scope():String
		{
			return _scope;
		}
		
		/**
		 * Returns priority attribute of [EventHandler] tag.
		 * Synonymous to the priority argument of <code>org.apache.royale.events.IEventDispatcher.addEventListener()</code>.
		 */
		public function get priority():int
		{
			return _priority;
		}
		
		/**
		 * Returns stopPropagation attribute of [EventHandler] tag as a <code>Boolean</code>.
		 * Synonymous to the stopPropagation method of <code>flash.events.Event</code>.
		 *
		 * @default false
		 */
		public function get stopPropagation():Boolean
		{
			return _stopPropagation;
		}
		
		/**
		 * Returns stopImmediatePropagation attribute of [EventHandler] tag as a <code>Boolean</code>.
		 * Synonymous to the stopImmediatePropagation method of <code>flash.events.Event</code>.
		 *
		 * @default false
		 */
		public function get stopImmediatePropagation():Boolean
		{
			return _stopImmediatePropagation;
		}
		
		/**
		 * Returns useCapture attribute of [EventHandler] tag as a <code>Boolean</code>.
		 * Synonymous to the useCapture argument of <code>org.apache.royale.events.IEventDispatcher.addEventListener()</code>.
		 *
		 * @default false
		 */
		public function get useCapture():Boolean
		{
			return _useCapture;
		}
		
		/**
		 * Constructor sets <code>defaultArgName</code>.
		 */
		public function EventHandlerMetadataTag()
		{
			defaultArgName = "event";
		}
		
		/**
		 * Initialize properties based on values provided in [EventHandler] tag.
		 */
		override public function copyFrom(metadataTag:IMetadataTag):void
		{
			// super will set name, args and host for us
			super.copyFrom( metadataTag );
			
			// event is the default attribute
			// [EventHandler( "someEvent" )] == [EventHandler( event="someEvent" )]
			if( hasArg( "event" ) )
				_event = getArg( "event" ).value;
			
			if( hasArg( "properties" ) )
				_properties = getArg( "properties" ).value.replace( /\s/g, "" ).split( "," );
			
			if( hasArg( "scope" ) )
				_scope = getArg( "scope" ).value;
			
			if( hasArg( "priority" ) )
				_priority = int( getArg( "priority" ).value );
			
			if( hasArg( "stopPropagation" ) )
				_stopPropagation = getArg( "stopPropagation" ).value == "true";
			
			if( hasArg( "stopImmediatePropagation" ) )
				_stopImmediatePropagation = getArg( "stopImmediatePropagation" ).value == "true";
			
			if( hasArg( "useCapture" ) )
				_useCapture = getArg( "useCapture" ).value == "true";
		}
	}
}
