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
    public class Prototype extends Bean
	{
		/**
		 * @royalesuppresspublicvarwarning
		 */
		public var constructorArguments:*;
		
		/**
		 * @royalesuppresspublicvarwarning
		 */
		public var singleton:Boolean = false;
		
		/**
		 *
		 */
		protected var _type:Class;
		
		override public function get type():*
		{
			return _type;
		}
		public function set type( clazz:Class ):void
		{
			_type = clazz;
		}
		
		override public function get source():*
		{
			return getObject();
		}
		
		public function Prototype(type:Class = null)
		{
			super();
			
			this.type = type;
		}
		
		protected function getObject():*
		{
			var instance:* = _source;
			
			if(instance == null)
			{
				// if source is null, create and initialize it (runs all processors)
				_source = instance = createInstance();
				beanFactory.setUpBean(new Bean(_source, name, typeDescriptor));
				
				// if this prototype is not a singleton, remove the source
				if(!singleton)
					_source = null;
				else
					initialized = true;
			}
			
			return instance;
		}
		
		protected function createInstance():Object
		{
			if( type == null )
				throw new Error( "Bean Creation exception! You must supply type to Prototype!" );
			
			var instance:*;
			
			if( constructorArguments != null )
			{
				var args:Array = constructorArguments is Array ? constructorArguments : [constructorArguments ];
				
				switch( args.length )
				{
					case 1:
						instance = new type( args[ 0 ] );
						break;
					case 2:
						instance = new type( args[ 0 ], args[ 1 ] );
						break;
					case 3:
						instance = new type( args[ 0 ], args[ 1 ], args[ 2 ] );
						break;
					case 4:
						instance = new type( args[ 0 ], args[ 1 ], args[ 2 ], args[ 3 ] );
						break;
					case 5:
						instance = new type( args[ 0 ], args[ 1 ], args[ 2 ], args[ 3 ], args[ 4 ] );
						break;
					case 6:
						instance = new type( args[ 0 ], args[ 1 ], args[ 2 ], args[ 3 ], args[ 4 ], args[ 5 ] );
						break;
					case 7:
						instance = new type( args[ 0 ], args[ 1 ], args[ 2 ], args[ 3 ], args[ 4 ], args[ 5 ], args[ 6 ] );
						break;
					case 8:
						instance = new type( args[ 0 ], args[ 1 ], args[ 2 ], args[ 3 ], args[ 4 ], args[ 5 ], args[ 6 ], args[ 7 ] );
						break;
					default:
						throw new Error( "No more than 8 constructor arguments are support by Prototype." );
				}
			}
			else
			{
				instance = new type();
			}
			
			return instance;
		}
		
		override public function toString():String
		{
			return "Prototype{ type: " + type + ", name: " + name + " }";
		}
	}
}
