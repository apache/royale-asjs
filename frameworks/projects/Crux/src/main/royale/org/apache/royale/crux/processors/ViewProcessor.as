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
	COMPILE::SWF{
	import flash.utils.Dictionary;
	}
	import org.apache.royale.crux.Bean;
	import org.apache.royale.crux.reflection.IMetadataTag;
	import org.apache.royale.crux.reflection.MetadataHostMethod;
	import org.apache.royale.crux.reflection.MethodParameter;

	public class ViewProcessor extends BaseMetadataProcessor implements IBeanProcessor
	{
		// ========================================
		// protected static constants
		// ========================================

		protected static const VIEW_ADDED:String = "ViewAdded";
		protected static const VIEW_REMOVED:String = "ViewRemoved";
		protected static const VIEW_NAVIGATOR:String = "ViewNavigator";
		
		// ========================================
		// protected properties
		// ========================================
		COMPILE::SWF
		protected var views:Dictionary = new Dictionary();

		COMPILE::JS
		protected var views:Map = new Map();

		// ========================================
		// public properties
		// ========================================

		/**
		 *
		 */
		override public function get priority():int
		{
			return 100;
		}

		// ========================================
		// constructor
		// ========================================

		/**
		 * Constructor
		 */
		public function ViewProcessor(metadataNames:Array = null )
		{
			super( ( metadataNames == null ) ? [ VIEW_ADDED, VIEW_REMOVED, VIEW_NAVIGATOR ] : metadataNames );
		}

		// ========================================
		// public methods
		// ========================================
		
		/**
		 * This method is called whenever a bean is added that contains [ViewAdded], 
		 * [ViewRemoved] and/or [ViewNavigator] tags. These will/should be regular beans defined
		 * in a BeanProvider that want to be notified when a particular type of view
		 * is set up or torn down, respectively.
		 */
		override public function setUpMetadataTags( metadataTags:Array, bean:Bean ):void
		{
			// parse any [ViewAdded], [ViewRemoved] or [ViewNavigator] tags found
			for each ( var tag:IMetadataTag in metadataTags )
			{
				var viewType:Class;
				
				// get the view type by examining the metadata host on which the tag was declared
				if( tag.host is MetadataHostMethod )
					viewType = MethodParameter( MetadataHostMethod( tag.host ).parameters[ 0 ] ).type;
				else
					viewType = tag.host.type;
				
				// make sure there is an array for this view type
				COMPILE::SWF{
					views[ viewType ] ||= [];
					var arr:Array = views[ viewType ] as Array;
				}
				COMPILE::JS{
					var arr:Array = views.get(viewType);
					if (!arr) {
						arr = [];
						views.set(viewType, arr);
					}
				}
				// store a ref
				arr.push( new ViewRef( tag, bean.source ) );
			}
		}
		
		/**
		 * This method is called whenever a bean that contains [ViewAdded], 
		 * [ViewRemoved] and/or [ViewNavigator] tags is torn down. This would likely only
		 * happen if the bean (mediator) was part of a module that was torn down.
		 */
		override public function tearDownMetadataTags( metadataTags:Array, bean:Bean ):void
		{
			// parse any [ViewAdded], [ViewRemoved] or [ViewNavigator] tags found
			for each ( var tag:IMetadataTag in metadataTags )
			{
				var viewType:Class;
				
				// get the view type by examining the metadata host on which the tag was declared
				if( tag.host is MetadataHostMethod )
					viewType = MethodParameter( MetadataHostMethod( tag.host ).parameters[ 0 ] ).type;
				else
					viewType = tag.host.type;
				
				var arr:Array;
				COMPILE::SWF{
					arr = views[ viewType ] as Array;
				}
				COMPILE::JS{
					arr = views.get(viewType) as Array;
				}
				
				for( var i:int = arr.length - 1; i > -1; i-- )
				{
					var ref:ViewRef = arr[ i ];
					
					if( ref.mediator === bean.source )
						arr.splice( i, 1 );
				}
			}
		}
		
		/**
		 * Called when a view is added to stage.
		 */
		public function setUpBean( bean:Bean ):void
		{
			processViewBean( bean, VIEW_ADDED );
		}
		
		/**
		 * Called when a view is removed from stage.
		 */
		public function tearDownBean( bean:Bean ):void
		{
			processViewBean( bean, VIEW_REMOVED );
		}
		
		/**
		 * Examine stored refs to see if any mediators have registered to
		 * be notified when a view of this type has been added or removed.
		 */
		COMPILE::SWF
		protected function processViewBean( bean:Bean, tagName:String ):void
		{
			// iterate over the keys of our Dictionary
			// the keys are the types we've found in [ViewAdded] and [ViewRemoved] declarations

			for( var type:* in views )
			{
				// check to see if the view that was added/removed is a compatible type
				// using "is" lets us match subclasses and interface implementations
				if( bean.source is type )
				{
					// get refs to all the metadata tag instances
					var refs:Array = views[ type ] as Array;
					
					// iterate over all the metadata tag instances
					for each( var ref:ViewRef in refs )
					{
						// if view was added, only process [ViewAdded] tags
						// if view was removed, only process [ViewRemoved] tags
						if( ref.tag.name != tagName && ref.tag.name != VIEW_NAVIGATOR )
							continue;
						
						// if tag was declared on a method pass the view in as the only argument
						if( ref.tag.host is MetadataHostMethod )
						{
							var f:Function = ref.mediator[ ref.tag.host.name ] as Function;
							f.apply( null, [ bean.source ] );
						}
						else // if tag was declared on a property do a simple assignment
						{
							ref.mediator[ ref.tag.host.name ] = bean.source;
						}
					}
				}
			}
		}


		/**
		 * Examine stored refs to see if any mediators have registered to
		 * be notified when a view of this type has been added or removed.
		 * @royaleignorecoercion Array
		 *
		 */
		COMPILE::JS
		protected function processViewBean( bean:Bean, tagName:String ):void
		{
			// iterate over the keys of our Dictionary
			// the keys are the types we've found in [ViewAdded] and [ViewRemoved] declarations
			
			//Don't use an IteratorIterable approach to maintain compatibility with IE11
			//IE11
			//ref: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Map/forEach
			
			
			
			/*if (views.keys != null) {
				var iterator:IteratorIterable = views.keys();
				var result:* = iterator.next();
				while ( !result.done )
				{
					var type:* = result.value;
					// check to see if the view that was added/removed is a compatible type
					// using "is" lets us match subclasses and interface implementations
					if( bean.source is type )
					{
						// get refs to all the metadata tag instances
						var refs:Array = views.get(type) as Array;
						
						// iterate over all the metadata tag instances
						for each( var ref:ViewRef in refs )
						{
							// if view was added, only process [ViewAdded] tags
							// if view was removed, only process [ViewRemoved] tags
							if( ref.tag.name != tagName && ref.tag.name != VIEW_NAVIGATOR )
								continue;
							
							// if tag was declared on a method pass the view in as the only argument
							if( ref.tag.host is MetadataHostMethod )
							{
								var f:Function = ref.mediator[ ref.tag.host.name ] as Function;
								f.apply( null, [ bean.source ] );
							}
							else // if tag was declared on a property do a simple assignment
							{
								ref.mediator[ ref.tag.host.name ] = bean.source;
							}
						}
					}
				}
			} else {*/
				//IE11
				views.forEach(
						function(value:Object, key:Object):void{
							var type:* = key;
							// check to see if the view that was added/removed is a compatible type
							// using "is" lets us match subclasses and interface implementations
							if( bean.source is type )
							{
								// get refs to all the metadata tag instances
								var refs:Array = value/*views.get(type)*/ as Array;
								
								// iterate over all the metadata tag instances
								for each( var ref:ViewRef in refs )
								{
									// if view was added, only process [ViewAdded] tags
									// if view was removed, only process [ViewRemoved] tags
									if( ref.tag.name != tagName && ref.tag.name != VIEW_NAVIGATOR )
										continue;
									
									// if tag was declared on a method pass the view in as the only argument
									if( ref.tag.host is MetadataHostMethod )
									{
										var f:Function = ref.mediator[ ref.tag.host.name ] as Function;
										f.apply( null, [ bean.source ] );
									}
									else // if tag was declared on a property do a simple assignment
									{
										ref.mediator[ ref.tag.host.name ] = bean.source;
									}
								}
							}
						} //no need for second 'this' argument
				)
				
			//}

		}
	}
}

import org.apache.royale.crux.reflection.IMetadataTag;

class ViewRef
{
	public var tag:IMetadataTag;
	public var mediator:*;
	
	public function ViewRef( tag:IMetadataTag, mediator:* )
	{
		this.tag = tag;
		this.mediator = mediator;
	}
}
