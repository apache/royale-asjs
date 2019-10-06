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
	import org.apache.royale.crux.Bean;
	import org.apache.royale.crux.metadata.PostConstructMetadataTag;
	import org.apache.royale.crux.reflection.IMetadataTag;

	/**
	 * PostConstruct Processor
	 */
	public class PostConstructProcessor extends BaseMetadataProcessor
	{
		// ========================================
		// protected static constants
		// ========================================

		protected static const POST_CONSTRUCT : String = "PostConstruct";

		// ========================================
		// public properties
		// ========================================

		/**
		 *
		 */
		override public function get priority() : int
		{
			return ProcessorPriority.POST_CONSTRUCT;
		}

		// ========================================
		// constructor
		// ========================================

		/**
		 * Constructor
		 */
		public function PostConstructProcessor(metadataNames : Array = null )
		{
			super( ( metadataNames == null ) ? [ POST_CONSTRUCT ] : metadataNames, PostConstructMetadataTag );
		}

		// ========================================
		// public methods
		// ========================================

		/**
		 * @inheritDoc
		 */
		override public function setUpMetadataTags( metadataTags : Array, bean : Bean ) : void
		{
			super.setUpMetadataTags( metadataTags, bean );

			metadataTags.sortOn( "order", Array.NUMERIC );

			for each ( var metadataTag : IMetadataTag in metadataTags )
			{
				var f : Function = bean.source[ metadataTag.host.name ];
				f.apply(bean.source);
			}
		}
	}
}
