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
	import org.apache.royale.crux.CruxConfig;
	import org.apache.royale.crux.reflection.IMetadataTag;
	import org.apache.royale.crux.reflection.MetadataArg;
	import org.apache.royale.crux.reflection.MetadataHostProperty;
	import org.apache.royale.events.IEventDispatcher;
	
	/**
	 * Dispatcher Processor
	 */
	public class DispatcherProcessor extends BaseMetadataProcessor
	{
		// ========================================
		// protected static constants
		// ========================================
		
		protected static const DISPATCHER:String = "Dispatcher";
		
		// ========================================
		// public properties
		// ========================================
		
		/**
		 *
		 */
		override public function get priority():int
		{
			return ProcessorPriority.DISPATCHER;
		}
		
		// ========================================
		// constructor
		// ========================================
		
		/**
		 * Constructor
		 */
		public function DispatcherProcessor(metadataNames:Array = null )
		{
			super( ( metadataNames == null ) ? [ DISPATCHER ] : metadataNames );
		}
		
		// ========================================
		// public methods
		// ========================================
		
		/**
		 * @inheritDoc
		 */
		override public function setUpMetadataTag( metadataTag:IMetadataTag, bean:Bean ):void
		{
			var scope:String;
			
			if( metadataTag.hasArg( "scope" ) )
				scope = metadataTag.getArg( "scope" ).value;
			else if( metadataTag.args.length > 0 && MetadataArg(metadataTag.args[0]).key == "" )
				scope = MetadataArg(metadataTag.args[0]).value;
			
			var dispatcher:IEventDispatcher = null;
			
			// if the mediate tag defines a scope, set proper dispatcher, else use defaults
			if( scope == CruxConfig.GLOBAL_DISPATCHER )
				dispatcher = crux.globalDispatcher;
			else if( scope == CruxConfig.LOCAL_DISPATCHER )
				dispatcher = crux.dispatcher;
			else
				dispatcher = crux.config.defaultDispatcher == CruxConfig.LOCAL_DISPATCHER ? crux.dispatcher : crux.globalDispatcher;
			
			var property:MetadataHostProperty = metadataTag.host as MetadataHostProperty;
			if (property) {
				property.sourceDefinition.setValue(bean.source, dispatcher);
			} else {
				trace('unexpected branch in \'DispatcherProcessor\'');
				bean.source[ metadataTag.host.name ] = dispatcher;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function tearDownMetadataTag( metadataTag:IMetadataTag, bean:Bean ):void
		{
			var property:MetadataHostProperty = metadataTag.host as MetadataHostProperty;
			if (property) {
				property.sourceDefinition.setValue(bean.source, null);
			} else {
				trace('unexpected branch in \'DispatcherProcessor\'');
				bean.source[ metadataTag.host.name ] = null;
			}
		}
	}
}
