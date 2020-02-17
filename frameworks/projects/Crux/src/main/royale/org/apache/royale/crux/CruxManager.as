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
	COMPILE::SWF{
		import flash.utils.Dictionary;
	}
	import org.apache.royale.core.IFlexInfo;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.crux.processors.IMetadataProcessor;
	import org.apache.royale.crux.processors.IProcessor;
	import org.apache.royale.crux.utils.view.applicationContains;

    public class CruxManager
	{
		/**
		 * @royalesuppresspublicvarwarning
		 */
		public static var cruxes:Array = [];
		
		/**
		 * non-weak keys for consistency (differs from original)
		 */
		COMPILE::SWF
		public static var wiredViews:Dictionary = new Dictionary( );

		/**
		 * @royalesuppresspublicvarwarning
		 */
		COMPILE::JS
		public static var wiredViews:Map = new Map();
		
		/**
		 * @royalesuppresspublicvarwarning
		 */
		public static var metadataNames:Array = [];
		
		public static function addCrux(crux:ICrux):void
		{
			cruxes.push(crux);
			
			for each(var p:IProcessor in crux.processors)
			{
				if(p is IMetadataProcessor)
				{
					metadataNames = metadataNames.concat(IMetadataProcessor(p).metadataNames);
				}
			}
		}
		
		public static function removeCrux(crux:ICrux):void
		{
			cruxes.splice(cruxes.indexOf(crux), 1);
		}
		
		public static function setUp( view:UIBase ):void
		{
			//already wired
			COMPILE::SWF{
				if( wiredViews[ view ] != null )
					return;
			}
			COMPILE::JS{
				if( wiredViews.get(view) != null )
					return;
			}

			
			for( var i:int = cruxes.length - 1; i > -1; i-- )
			{
				var crux:ICrux = ICrux( cruxes[ i ] );

				if (applicationContains(IFlexInfo( crux.dispatcher ), view))
				{
					setUpView( view, crux );
					return;
				}
			}
			//@todo review...
			//pop ups not registered to a particular Crux instance must be handled by the root instance
			setUpView( view, ICrux( cruxes[ 0 ] ) );
		}
		
		private static function setUpView( viewToWire:UIBase, cruxInstance:ICrux ):void
		{
			COMPILE::SWF{
				wiredViews[ viewToWire ] = cruxInstance;
			}
			COMPILE::JS{
				wiredViews.set(viewToWire, cruxInstance);
			}

			cruxInstance.beanFactory.setUpBean( BeanFactory.constructBean( viewToWire, null) );
		}
		
		public static function tearDown( wiredView:UIBase ):void
		{
			//wasn't wired
			COMPILE::SWF{
				if( wiredViews[ wiredView ] == null )
					return;
			}
			COMPILE::JS{
				if( wiredViews.get(wiredView) == null )
					return;
			}
			
			for( var i:int = cruxes.length - 1; i > -1; i-- )
			{
				var crux:ICrux = ICrux( cruxes[ i ] );
				
				//if this is the dispatcher for a crux instance tear down crux
				if( crux.dispatcher == wiredView )
				{
					crux.tearDown();
					return;
				}
			}

			COMPILE::SWF{
				crux = wiredViews[ wiredView ]
			}
			COMPILE::JS{
				crux = wiredViews.get(wiredView);
			}
			// for tear down use the crux instance that was associated at set up time
			tearDownWiredView( wiredView, crux );
		}
		
		public static function tearDownWiredView( wiredView:UIBase, cruxInstance:ICrux ):void
		{

			COMPILE::SWF{
				delete wiredViews[ wiredView ];
			}
			COMPILE::JS{
				wiredViews.delete(wiredView);
			}
			//@todo testing:
			cruxInstance.beanFactory.tearDownBean( BeanFactory.constructBean( wiredView, null) );
		}
		
		public static function tearDownAllWiredViewsForCruxInstance( cruxInstance:ICrux ):void
		{
			COMPILE::SWF{
				for(var wiredView:* in wiredViews)
				{
					// this will also tear down the crux dispatcher itself
					if( wiredViews[wiredView] == cruxInstance)
					{
						tearDownWiredView(wiredView, cruxInstance);
					}
				}
			}
			COMPILE::JS{
				//Don't use an IteratorIterable approach to maintain compatibility with IE11
				//IE11
				//ref: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Map/forEach
				
				wiredViews.forEach(
					function(value:Object, wiredView:*):void {
						if (value == cruxInstance) {
							tearDownWiredView(wiredView, cruxInstance);
						}
					} //no second 'this' arg here - we are static
				)
				
				//otherwise (for other browsers) IteratorIterable might be faster (tbc):
				//both could be supported with 'if (wireViews.keys) or maybe 'if (Map.prototype.keys)' tests
				//as a feature check, but the above is common to all, and so deferring to IE's needs for now
				//leaving this below as possible future improvement:

				/*var iterator:IteratorIterable = wiredViews.keys();
				var result:* = iterator.next();
				while(!result.done)
				{
					var wiredView:* = result.value;
					// this will also tear down the crux dispatcher itself
					if( wiredViews.get(wiredView) == cruxInstance)
					{
						tearDownWiredView(wiredView, cruxInstance);
					}
					result = iterator.next();
				}*/
			}
		}
	}
}
