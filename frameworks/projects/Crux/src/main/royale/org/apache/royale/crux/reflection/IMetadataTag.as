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
	 * The IMetadataTag interface is a representation of a metadata tag
	 * that has been defined in source code.
	 */
	public interface IMetadataTag
	{
		/**
		 * Name of the tag, e.g. "Bindable" from [Bindable].
		 */
		function get name():String;
		function set name( value:String ):void;
		
		[ArrayElementType( "org.apache.royale.crux.reflection.MetadataArg" )]
		/**
		 * Array of arguments defined in the tag.
		 *
		 * @see org.apache.royale.crux.reflection.MetadataArg
		 */
		function get args():Array;
		function set args( value:Array ):void;
		
		/**
		 * Element (class, method or property) on which the metadata tag is defined.
		 */
		function get host():IMetadataHost;
		function set host( value:IMetadataHost ):void;
		
		/**
		 * String showing what this tag looks like in code. Useful for debugging and log messages.
		 */
		function get asTag():String;
		
		/**
		 * @param argName Name of argument whose existence on this tag will be checked.
		 * @return Flag indicating whether or not this tag contains an argument for the given name.
		 */
		function hasArg( argName:String ):Boolean;
		
		/**
		 * @param argName Name of argument to retrieve.
		 * @return Argument for the given name.
		 */
		function getArg( argName:String ):MetadataArg;
		
		function copyFrom( metadataTag:IMetadataTag ):void;
		
		function toString():String;
	}
}
