////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
/***
 * Based on the
 * Swiz Framework library by Chris Scott, Ben Clinkinbeard, Sönke Rohde, John Yanarella, Ryan Campbell, and others https://github.com/swiz/swiz-framework
 */
package org.apache.royale.crux.reflection
{
	import org.apache.royale.reflection.VariableDefinition;

	/**
	 * Representation of a property that has been decorated with metadata.
	 */
	public class MetadataHostProperty extends BindableMetadataHost
	{
        /**
		 * Constructor
		 */
		public function MetadataHostProperty()
		{
			super();
		}


		protected var _sourceDefinition:VariableDefinition;
		/**
		 * The reflection definition ( could be accessor or variable) that informed this MetadataHostMethod
		 */
		public function get sourceDefinition():VariableDefinition
		{
			return _sourceDefinition;
		}

		public function set sourceDefinition( value:VariableDefinition ):void
		{
			_sourceDefinition = value;
		}
	}
}
