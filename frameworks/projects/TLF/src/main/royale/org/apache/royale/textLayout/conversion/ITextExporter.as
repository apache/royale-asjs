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
	import org.apache.royale.textLayout.elements.ITextFlow;
	
	/** 
	 * Interface for exporting text content from a TextFlow instance to a given format, 
	 * which may for example be String or XML format, or a user-defined format. Exporters support the getting
	 * and setting of properties to control the export of data. These properties are implemented
	 * as public properties, but the direct access of these properties should be avoided, since
	 * a user might replace the converter class in the TextConverter registry, causing a downcast
	 * to fail.
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0 
	 */
	public interface ITextExporter
	{	
		/** 
		 * Export text content from a TextFlow instance in String, or XML, or a user defined format.
		 * <p>Set the <code>conversionType</code> parameter to either of the following values,
		 * or a user defined format in user-defined exporters.
		 * <ul>
		 *   <li><code>org.apache.royale.textLayout.conversion.ConversionType.STRING_TYPE</code>;</li>
		 *   <li><code>org.apache.royale.textLayout.conversion.ConversionType.XML_TYPE</code>.</li>
		 * </ul>
		 * </p>
		 * @param source	The TextFlow to export
		 * @param conversionType 	Return a String (STRING_TYPE) or XML (XML_TYPE), or any user defined format.
		 * @return Object	The exported content
		 * @see org.apache.royale.textLayout.conversion.ConversionType
	 	 * @playerversion Flash 10
	 	 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		function export(source:ITextFlow, conversionType:String):Object;
		
		/** 
		 * This property contains a vector of error messages as strings after a call
		 * to an exporter method is the <code>throwOnError</code> property is set to
		 * <code>false</code>, which is the default. If there were no errors, the
		 * property returns <code>null</code>. The property is reset on each method
		 * call.
		 * @playerversion Flash 10.2
		 * @playerversion AIR 2.0
		 * @langversion 3.0
		 */
		function get errors():Vector.<String>;
		
		/** 
		 * The throwOnError property controls how the exporter handles errors.
		 * If set to <code>true</code>, methods throw an Error instance on errors. 
		 * If set to <code>false</code>, which is the default, errors are collected
		 * into a vector of strings and stored in the <code>errors</code> property, 
		 * and the exporter does not throw.	
		 * @playerversion Flash 10.2
		 * @playerversion AIR 2.0
		 * @langversion 3.0
		 */
		function get throwOnError():Boolean;
		function set throwOnError(value:Boolean):void;

		/** 
		 * The <code>useClipboardAnnotations</code> property controls whether or not the 
		 * importer should handle the extra information necessary for the clipboard. 
		 * When data is in a TextFlow, paragraphs are always complete, and include a 
		 * terminator character. When a range of text is pasted to the clipboard, it
		 * will form paragraphs, but the range may not include in the final terminator.
		 * In this case, the paragraph needs to be marked as a partial paragraph if it
		 * is intended for the clipboard, so that if it is later pasted it will merge
		 * into the new text correctly. If the content is intended for the clipboard, 
		 * useClipboardAnnotations will be true.
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		function get useClipboardAnnotations():Boolean;
		function set useClipboardAnnotations(value:Boolean):void;
		
		/**
		 * Accesses the config options for the exporter. 
		 **/
		function get config():ImportExportConfiguration;
		function set config(value:ImportExportConfiguration):void;		
	}
}
