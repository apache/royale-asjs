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
	 * Class to represent <code>[PostConstruct]</code> metadata tags.
	 */
	public class PostConstructMetadataTag extends BaseMetadataTag
	{
		// ========================================
		// protected properties
		// ========================================
		
		/**
		 * Backing variable for read-only <code>order</code> property.
		 */
		protected var _order:int = 1;
		
		// ========================================
		// public properties
		// ========================================
		
		/**
		 * Returns order attribute of [PostConstruct] tag.
		 * Refers to the order in which the decorated methods will be executed.
		 * Is the default attribute, meaning <code>[PostConstruct( 2 )]</code> is
		 * equivalent to <code>[PostConstruct( order="2" )]</code>.
		 */
		public function get order():int
		{
			return _order;
		}
		
		// ========================================
		// constructor
		// ========================================
		
		/**
		 * Constructor sets <code>defaultArgName</code>.
		 */
		public function PostConstructMetadataTag()
		{
			defaultArgName = "order";
		}
		
		// ========================================
		// public methods
		// ========================================
		
		override public function copyFrom( metadataTag:IMetadataTag ):void
		{
			super.copyFrom( metadataTag );
			
			if( hasArg( "order" ) )
				_order = int( getArg( "order" ).value );
		}
	}
}
