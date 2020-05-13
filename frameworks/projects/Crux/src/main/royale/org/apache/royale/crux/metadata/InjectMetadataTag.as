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
	 * Class to represent <code>[Inject]</code> metadata tags.
	 */
	public class InjectMetadataTag extends BaseMetadataTag
	{
		// ========================================
		// protected properties
		// ========================================
		
		// protected var logger:CruxLogger = CruxLogger.getLogger( this );
		
		/**
		 * Backing variable for read-only <code>source</code> property.
		 */
		protected var _source:String;
		
		/**
		 * Backing variable for read-only <code>destination</code> property.
		 */
		protected var _destination:String;
		
		/**
		 * Backing variable for read-only <code>twoWay</code> property.
		 */
		//protected var _twoWay:Boolean = false;
		
		/**
		 * Backing variable for read-only <code>bind</code> property.
		 */
		protected var _bind:Boolean = false;
		
		/**
		 * Backing variable for read-only <code>required</code> property.
		 */
		protected var _required:Boolean = true;
		
		// ========================================
		// public properties
		// ========================================
		
		/**
		 * Returns source attribute of [Inject] tag.
		 * Refers to the source to be used for injection.
		 * Is the default attribute, meaning <code>[Inject( "someModel" )]</code> is
		 * equivalent to <code>[Inject( source="someModel" )]</code>.
		 */
		public function get source():String
		{
			return _source;
		}
		
		public function set source( value:String ):void
		{
			_source = value;
		}
		
		/**
		 * Returns destination attribute of [Inject] tag.
		 * Refers to the injection target.
		 */
		public function get destination():String
		{
			return _destination;
		}
		
		/**
		 * Returns twoWay attribute of [Inject] tag as a <code>Boolean</code> value.
		 * If true will cause a two way binding to be established.
		 *
		 * @default false
		 */
		/*public function get twoWay():Boolean
		{
			return _twoWay;
		}*/
		
		/**
		 * Returns bind attribute of [Inject] tag as a <code>Boolean</code> value.
		 * If true will cause a binding to be established.
		 *
		 * @default false
		 */
		public function get bind():Boolean
		{
			return _bind;
		}
		
		/**
		 * Returns required attribute of [Inject] tag as a <code>Boolean</code> value.
		 * If true Crux will throw an error if it fails to fill this dependency.
		 *
		 * @default true
		 */
		public function get required():Boolean
		{
			return _required;
		}
		
		// ========================================
		// constructor
		// ========================================
		
		/**
		 * Constructor sets <code>defaultArgName</code>.
		 */
		public function InjectMetadataTag()
		{
			defaultArgName = "source";
		}
		
		// ========================================
		// public methods
		// ========================================
		
		override public function copyFrom( metadataTag:IMetadataTag ):void
		{
			super.copyFrom( metadataTag );
			
			//@todo consider removing the 'bean' arg support or putting it only in debug-only build
			if( hasArg( "bean" ) && hasArg( "source" ) )
				throw new Error( "Your metadata tag defines both a bean and source attribute. source has replaced bean, please update accordingly." );
			
			if( hasArg( "bean" ) )
			{
				// logger.warn( "The bean attribute has been deprecated in favor of the source attribute. Please update your code accordingly. Found in {0}", metadataTag.asTag );
				_source = getArg( "bean" ).value;
			}
			
			// source is the default attribute
			// [Inject( "someModel" )] == [Inject( source="someModel" )]
			if( hasArg( "source" ) )
				_source = getArg( "source" ).value;
			
			if( hasArg( "property" ) )
			{
				// logger.warn( "The property attribute has been deprecated. Please use dot notation in your source attribute instead. Found in {0}", metadataTag.asTag );
				_source += "." + getArg( "property" ).value;
			}
			
			if( hasArg( "destination" ) )
				_destination = getArg( "destination" ).value;
			
			/*if( hasArg( "twoWay" ) )
				_twoWay = getArg( "twoWay" ).value == "true";*/
			
			if( hasArg( "bind" ) )
				_bind = getArg( "bind" ).value == "true";
			
			if( hasArg( "required" ) )
				_required = getArg( "required" ).value == "true";
		}
	}
}
