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
package org.apache.royale.textLayout.conversion {
	import org.apache.royale.reflection.getQualifiedClassName;
	
	// [ExcludeClass]
	/**
	 * @private  
	 * Contains configuration data about FlowElement types. 
	 */
	internal class FlowElementInfo
	{
		/** Class used for the FlowElement sub-type */
		private var _flowClass:Class;
		/** Fully qualified class name */
		private var _flowClassName:String;
		/** Parsing function used for reading in data on a FlowElement instance */
		private var _parser:Function;
		/** Class for the object's XFL import/export interface */
		private var _exporter:Function;
		
		/** Construct a FlowElementInfo
		 * @param	flowClass	Class used to represent the FlowElement
		 * @param 	parser		Function used for parsing XML description of a FlowElement
		 * @param 	exporter	Class used to represent the FlowElement's exporter
		 * @param	isParagraphFormattedElement Boolean indicating if this class is a subclass of ParagraphFormattedElement
		 */
		public function FlowElementInfo(flowClass:Class, parser:Function, exporter:Function)
		{
			this._flowClass = flowClass;
			this._parser = parser;
			this._exporter = exporter;
			this._flowClassName = getQualifiedClassName(flowClass);
		}
		
		/** Class used for the FlowElement sub-type */
		public function get flowClass():Class
		{ return _flowClass; }
		/** Fully qualified class name */
		public function get flowClassName():String
		{ return _flowClassName; }
		/** Parsing function used for reading in data on a FlowElement instance */
		public function get parser():Function
		{ return _parser; }
		/** Class for the object's XFL import/export interface */
		public function get exporter():Function
		{ return _exporter; }
		/** Boolean indicating if flowClass is a subclass of ParagraphFormattedElement */
	}
}
