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
	 * Simple key/value representation of a metadata tag argument.
	 */
	public class MetadataArg
	{
        /**
		 * Constructor sets initial values of required parameters.
		 *
		 * @param key
		 * @param value
		 */
		public function MetadataArg( key:String, value:String )
		{
			this.key = key;
			this.value = value;
		}

        /**
		 * Name of metadata tag argument, e.g. "source" for [Inject( source="someModel" )]
		 * @royalesuppresspublicvarwarning
		 */
		public var key:String;
		
		/**
		 * Value of metadata tag argument, e.g. "someModel" for [Inject( source="someModel" )]
		 * @royalesuppresspublicvarwarning
		 */
		public var value:String;

        /**
		 * @return String representation of this metadata tag argument.
		 */
		public function toString():String
		{
			var str:String = "MetadataArg: ";
			
			str += key + " = " + value + "\n";
			
			return str;
		}
    }
}
