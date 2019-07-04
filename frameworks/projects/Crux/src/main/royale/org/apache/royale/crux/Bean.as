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
    import org.apache.royale.crux.reflection.TypeDescriptor;

    [DefaultProperty("source")]

	/**
	 * Bean
	 */
    public class Bean
	{
		/**
		 * Constructor
		 */
		public function Bean(source:* = null, name:String = null, typeDescriptor:TypeDescriptor = null)
		{
			this.source = source;
			this.name = name;
			this.typeDescriptor = typeDescriptor;
		}

        protected var _source:*;
        public function get source():*
		{
			return _source;
		}
		public function set source(value:*):void
		{
			_source = value;
		}

        /**
		 * Name
		 * @royalesuppresspublicvarwarning
		 */
		public var name:String;
		
		/**
		 * Type Descriptor
		 * @royalesuppresspublicvarwarning
		 */
		public var typeDescriptor:TypeDescriptor;
		
		/**
		 * BeanFactory
		 * @royalesuppresspublicvarwarning
		 */
		public var beanFactory:IBeanFactory;
		
		/**
		 * Initialzed
		 * @royalesuppresspublicvarwarning
		 */
		public var initialized:Boolean = false;
		
		public function get type():*
		{
			return source;
		}

		public function toString():String
		{
			return "Bean{ source: " + source + ", name: " + name + " }";
		}
    }
}
