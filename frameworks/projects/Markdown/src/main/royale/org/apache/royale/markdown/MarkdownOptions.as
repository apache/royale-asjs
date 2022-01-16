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
package org.apache.royale.markdown
{
	/**
	 * Holds optional customizations for rendering the markdown
	 */
	public class MarkdownOptions
	{
		public function MarkdownOptions()
		{
			
		}
		public var maxNesting:int = 20;
		public var typographer:Boolean = false;
		public var quotes:String = '“”‘’';
    public var html:Boolean = false; // Enable HTML tags in source
    public var xhtmlOut:Boolean = false; // Use '/' to close single tags (<br />)
    public var breaks:Boolean = false; // Convert '\n' in paragraphs into <br>
    public var langPrefix:String = 'language-'; // CSS language prefix for fenced blocks
    public var linkTarget:String = ''; // set target to open link in

	}
}