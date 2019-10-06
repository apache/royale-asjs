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
	 * Representation of a method parameter.
	 */
	public class MethodParameter
	{
        /**
		 * Constructor sets initial values of required parameters.
		 *
		 * @param index
		 * @param type
		 * @param optional
		 */
		public function MethodParameter( index:int, type:Class, optional:Boolean )
		{
			this.index = index;
			this.type = type;
			this.optional = optional;
		}

		/**
		 * Index of this parameter in method signature.
		 * @royalesuppresspublicvarwarning
		 */
		public var index:int;
		
		/**
		 * Type of this parameter. Null if typed as <code>* </code>.
		 * @royalesuppresspublicvarwarning
		 */
		public var type:Class;
		
		/**
		 * Flag indicating whether or not this parameter is optional.
		 * @royalesuppresspublicvarwarning
		 */
		public var optional:Boolean;
	}
}
