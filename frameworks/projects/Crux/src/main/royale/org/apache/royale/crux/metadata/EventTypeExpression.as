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
	import org.apache.royale.crux.ICrux;
	import org.apache.royale.crux.reflection.ClassConstant;
	import org.apache.royale.crux.reflection.Constant;
	import org.apache.royale.crux.reflection.TypeCache;
	import org.apache.royale.crux.reflection.TypeDescriptor;

	public class EventTypeExpression
	{
		// ========================================
		// protected properties
		// ========================================

		/**
		 * Crux instance.
		 */
		protected var crux:ICrux;
		
		/**
		 * Event type expression.
		 */
		protected var expression:String;
		
		/**
		 * Backing variable for <code>eventClass</code> property.
		 */
		protected var _eventClass:Class;
		
		[ArrayElementType("String")]
		/**
		 * Backing variable for <code>eventTypes</code> property.
		 */
		protected var _eventTypes:Array;
		
		// ========================================
		// public properties
		// ========================================
		
		/**
		 * Event Class associated for this Event type expression (if applicable).
		 */
		public function get eventClass():Class
		{
			return _eventClass;
		}
		
		[ArrayElementType("String")]
		/**
		 * Event types for this Event type expression.
		 */
		public function get eventTypes():Array
		{
			return _eventTypes;
		}
		
		// ========================================
		// constructor
		// ========================================
		
		/**
		 * Constructor
		 */
		public function EventTypeExpression(expression:String, crux:ICrux )
		{
			this.crux = crux;
			this.expression = expression;
			
			parse();
		}
		
		// ========================================
		// protected methods
		// ========================================
		
		/**
		 * Parse event type expression.
		 *
		 * Processes an event type expression into an event class and type. Accepts a String specifying either the event type
		 * (ex. 'type') or a class constant reference (ex. 'SomeEvent.TYPE').  If a class constant reference is specified,
		 * it will be evaluated to obtain its String value.  If a ".*" wildcard is specified, all constants will evaluated.
		 *
		 * Class constant references are only supported in 'strict' mode.
		 */
		protected function parse():void
		{
			if( crux.config.strict && ClassConstant.isClassConstant( expression ) )
			{
				_eventClass = ClassConstant.getClass( expression, crux.config.eventPackages );
				
				if( expression.substr( -2 ) == ".*" )
				{
					var td:TypeDescriptor = TypeCache.getTypeDescriptor( _eventClass );
					_eventTypes = new Array();
					for each( var constant:Constant in td.constants )
						_eventTypes.push( constant.value );
				}
				else
				{
					_eventTypes = [ ClassConstant.getConstantValue( _eventClass, ClassConstant.getConstantName( expression ) ) ];
				}
			}
			else
			{
				_eventClass = null;
				_eventTypes = [ expression ];
			}
		}
	}
}
