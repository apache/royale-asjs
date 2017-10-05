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
package org.apache.royale.textLayout.conversion
{
	/** This interface should be implemented by converters that export plain text. Clients that have explicitly
	 * created an exporter using TextConverter.getExporter may control the export process by calling into these methods on the 
	 * exporter.
	 * 
	 * @playerversion Flash 10.0
	 * @playerversion AIR 2.0
	 * @langversion 3.0
	 */
	public interface IPlainTextExporter extends ITextExporter
	{
		/** Specifies the character sequence used (in a text flow's plain-text equivalent) to separate paragraphs.
		 * The paragraph separator is not added after the last paragraph. 
		 * 
		 * <p>This property applies to the <code>PLAIN_TEXT_FORMAT</code> exporter.</p>
		 *
		 * <p>The default value is "\n".</p> 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		function get paragraphSeparator():String;
		function set paragraphSeparator(value:String):void;
		
		/** This property indicates whether discretionary hyphens in the text should be stripped during the export process.
		 * Discretionary hyphens, also known as "soft hyphens", indicate where to break a word in case the word must be
		 * split between two lines. The Unicode character for discretionary hyphens is <code>\u00AD</code>.
		 * <p>If this property is set to <code>true</code>, discretionary hyphens that are in the original text will not be in the exported text, 
		 * even if they are part of the original text. If <code>false</code>, discretionary hyphens will be in the exported text.</p>
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		function get stripDiscretionaryHyphens():Boolean;
		function set stripDiscretionaryHyphens(value:Boolean):void;		
	}
}
