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
package org.apache.royale.crux.reflection
{
    /**
	 * The IMetadataHost interface is a representation of a public property, method
	 * or class that is decorated with metadata.
	 */
	public interface IMetadataHost
	{
		/**
		 * Name of the property/method/class.
		 */
		function get name():*;
		function set name( value:* ):void;
		
		/**
		 * Type of the property/method/class.
		 */
		function get type():Class;
		function set type( value:Class ):void;
		
		[ArrayElementType( "org.apache.royale.crux.reflection.IMetadataTag" )]
		/**
		 * Array of metadata tags that decorate the property/method/class.
		 */
		function get metadataTags():Array;
		function set metadataTags( value:Array ):void;
		
		/**
		 * Get metadata tag by name
		 */
		function getMetadataTagByName( name:String ):IMetadataTag;
		  
		/**
		 * Has metadata tag by name
		 */
		function hasMetadataTagByName( name:String ):Boolean;
	}
}
