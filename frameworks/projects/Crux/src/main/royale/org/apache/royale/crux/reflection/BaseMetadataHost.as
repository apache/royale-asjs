////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
/***
 * Based on the
 * Swiz Framework library by Chris Scott, Ben Clinkinbeard, Sönke Rohde, John Yanarella, Ryan Campbell, and others https://github.com/swiz/swiz-framework
 */
package org.apache.royale.crux.reflection
{
    /**
	 * Base implementation of the IMetadataHost interface.
	 * Implements getters and setters and initializes <code>metadataTags</code> Array.
	 *
	 * @see org.apache.royale.crux.reflection.IMetadataHost
	 * @see org.apache.royale.crux.reflection.MetadataHostClass
	 * @see org.apache.royale.crux.reflection.MetadataHostMethod
	 * @see org.apache.royale.crux.reflection.MetadataHostProperty
	 */
	public class BaseMetadataHost implements IMetadataHost
	{
        /**
		 * Constructor initializes <code>metadataTags</code> Array.
		 */
		public function BaseMetadataHost()
		{
			metadataTags = [];
		}
        
		/**
		 * Backing variable for <code>name</code> getter/setter.
		 */
		protected var _name:*;
		
		/**
		 * Backing variable for <code>type</code> getter/setter.
		 */
		protected var _type:Class;
		
		/**
		 * Backing variable for <code>metadataTags</code> getter/setter.
		 */
		protected var _metadataTags:Array;
		
		public function get name():*
		{
			return _name;
		}
		public function set name( value:* ):void
		{
			_name = value;
		}
		
		public function get type():Class
		{
			return _type;
		}
		public function set type( value:Class ):void
		{
			_type = value;
		}
		
		[ArrayElementType( "org.apache.royale.crux.reflection.IMetadataTag" )]
		public function get metadataTags():Array
		{
			return _metadataTags;
		}
		public function set metadataTags( value:Array ):void
		{
			_metadataTags = value;
		}
		
		public function getMetadataTagByName( name:String ):IMetadataTag
		{
			for each ( var metadataTag:IMetadataTag in metadataTags )
			{
				if ( metadataTag.name == name )
					{
						return metadataTag;
					}
				}
			return null;
		}
		
		public function hasMetadataTagByName( name:String ):Boolean
		{
			return getMetadataTagByName( name ) != null;
		}
	}
}
