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
package org.apache.royale.crux
{
    public class CruxConfig implements ICruxConfig
	{
        /**
		 * Constructor
		 */
		public function CruxConfig()
		{
			super();
		}
        
		public static const GLOBAL_DISPATCHER:String = "global";
		public static const LOCAL_DISPATCHER:String = "local";
		
		/**
		 * Regular expression to evaluate a 'wildcard' (ex. 'org.apache.royale.crux.*') package description.
		 *
		 * Matches: package.* or package.
		 * Captures: package as group 1and '.*' or '.' as group 2
		 */
		protected static const WILDCARD_PACKAGE:RegExp = /^((?:(?:[a-zA-Z]+(?:\.[a-zA-Z]+)*)\.)?(?:[a-zA-Z]*))(\.|\.\*)$/;
		
		/**
		 * Backing variable for the <code>strict</code> property.
		 */
		protected var _strict:Boolean = true;
		
		/**
		 * Backing variable for the <code>setUpEvent</code> property.
		 */
		protected var _setUpEventType:String = "addedToStage";
		
		/**
		 * Backing variable for the <code>setUpEventPriority</code> property.
		 */
		protected var _setUpEventPriority:int = 50;
		
		/**
		 * Backing variable for the <code>setUpEventPhase</code> property.
		 */
		protected var _setUpEventPhase:uint = 1;//EventPhase.CAPTURING_PHASE;
		
		/**
		 * Backing variable for the <code>tearDownEvent</code> property.
		 */
		protected var _tearDownEventType:String = "removedFromStage";
		
		/**
		 * Backing variable for the <code>tearDownEventPriority</code> property.
		 */
		protected var _tearDownEventPriority:int = 50;
		
		/**
		 * Backing variable for the <code>tearDownEventPhase</code> property.
		 */
		protected var _tearDownEventPhase:uint = 1;
		
		/**
		 * Backing variable for the <code>eventPackages</code> property.
		 */
		protected var _eventPackages:Array = [];
		
		/**
		 * Backing variable for the <code>viewPackages</code> property.
		 */
		protected var _viewPackages:Array = [];
		
		/**
		 * Backing variable for the <code>defaultFaultHandler</code> property.
		 */
		protected var _defaultFaultHandler:Function;
		
		/**
		 * Backing variable for the <code>defaultDispatcher</code> property.
		 */
		protected var _defaultDispatcher:String = GLOBAL_DISPATCHER;
		
		
        public function get strict():Boolean
		{
			return _strict;
		}
		public function set strict( value:Boolean ):void
		{
			_strict = value;
		}
		
		public function get setUpEventType():String
		{
			return _setUpEventType;
		}
		public function set setUpEventType( value:String ):void
		{
			_setUpEventType = value;
		}
		
		public function get setUpEventPriority():int
		{
			return _setUpEventPriority;
		}
		public function set setUpEventPriority( value:int ):void
		{
			_setUpEventPriority = value;
		}
		
		public function get setUpEventPhase():uint
		{
			return _setUpEventPhase;
		}
		public function set setUpEventPhase( value:uint ):void
		{
			_setUpEventPhase = value;
		}
		
		public function get tearDownEventType():String
		{
			return _tearDownEventType;
		}
		public function set tearDownEventType( value:String ):void
		{
			_tearDownEventType = value;
		}
		
		public function get tearDownEventPriority():int
		{
			return _tearDownEventPriority;
		}
		public function set tearDownEventPriority( value:int ):void
		{
			_tearDownEventPriority = value;
		}
		
		public function get tearDownEventPhase():uint
		{
			return _tearDownEventPhase;
		}
		public function set tearDownEventPhase( value:uint ):void
		{
			_tearDownEventPhase = value;
		}
		
		public function get eventPackages():Array
		{
			return _eventPackages;
		}
		public function set eventPackages( value:* ):void
		{
			setEventPackages( value );
		}
		
		public function get viewPackages():Array
		{
			return _viewPackages;
		}
		public function set viewPackages( value:* ):void
		{
			setViewPackages( value );
		}
		
		public function get defaultFaultHandler():Function
		{
			return _defaultFaultHandler;
		}
		public function set defaultFaultHandler( faultHandler:Function ):void
		{
			_defaultFaultHandler = faultHandler;
		}
		
		public function get defaultDispatcher():String
		{
			return _defaultDispatcher;
		}
		public function set defaultDispatcher( dispatcher:String ):void
		{
			_defaultDispatcher = dispatcher;
		}
		
		/**
		 * Internal setter for <code>eventPackages</code> property.
		 *
		 * @param value An Array of Strings or a single String that will be split on ","
		 */
		protected function setEventPackages( value:* ):void
		{
			_eventPackages = parsePackageValue( value );
		}
		
		/**
		 * Internal setter for <code>viewPackages</code> property.
		 *
		 * @param value An Array of Strings or a single String that will be split on ","
		 */
		protected function setViewPackages( value:* ):void
		{
			_viewPackages = parsePackageValue( value );
		}
		
		/**
		 * Parses a wildcard type package property value into an Array of parsed package names.
		 *
		 * @param value An Array of Strings or a single String that will be split on ","
		 * @return An Array of package name strings in a common format.
		 */
		protected function parsePackageValue( value:* ):Array
		{
			if( value == null )
			{
				return [];
			}
			else if( value is Array )
			{
				return parsePackageNames( value as Array );
			}
			else if( value is String )
			{
				return parsePackageNames( value.replace( /\s/g, "" ).split( "," ) );
			}
			else
			{
				throw new Error("Package specified using unknown type. Supported types are Array or String.");
			}
		}
		
		/**
		 * Parses an array of package names.
		 * Processes the package names to a common format - removing trailing '.*' wildcard notation.
		 *
		 * @param packageNames The package names to parse.
		 * @return An Array of the parsed package names.
		 */
		protected function parsePackageNames( packageNames:Array ):Array
		{
			var parsedPackageNames:Array = [];
			
			for each(var packageName:String in packageNames)
			{
				parsedPackageNames.push(parsePackageName(packageName));
			}
			
			return parsedPackageNames;
		}
		
		/**
		 * Parse Package Name
		 * Processes the package name to a common format - removing trailing '.*' wildcard notation.
		 *
		 * @param packageName The package name to parse.
		 * @return The package name with the wildcard notation stripped.
		 */
		protected function parsePackageName(packageName:String):String
		{
			var match:Object = WILDCARD_PACKAGE.exec(packageName);
			if(match)
				return match[1];
			
			return packageName;
		}
	}
}
