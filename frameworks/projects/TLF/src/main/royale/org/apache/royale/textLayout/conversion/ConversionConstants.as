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

	public class ConversionConstants
	{
		/** A converter that converts clipboard data into a TextFlow should use the MERGE_TO_NEXT_ON_PASTE property
		 * to control how the elements are treated when they are merged into an existing TextFlow on paste. This is useful
		 * if you want special handling for the case where only part of the element is copied. For instance, wheh a list
		 * is copied, if only part of the list is copied, and you paste it into another list, it merges into the list as
		 * additional items. If the entire list is copied, it appears as a nested list. When TLF creates a TextFlow for use
		 * on the clipboard, it decorates any partial elements with user properties that control whether the end of the element 
		 * should be merged with the one after it. This user property is never pasted into the final TextFlow, but it may go 
		 * on the elements in the TextScrap.textFlow. When copying text, the converter has the option to look for these properties 
		 * to propagate them into the format that is posted on the clipboard. For instance, the plain text exporter checks the 
		 * "mergeToNextOnPaste" property on paragraphs and supresses the paragraph terminator if it is found set to true. 
		 * Likewise on import if the incoming String has no terminator, and useClipboardAnnotations is true, then it calls 
		 * <code>setStyle(MERGE_TO_NEXT_ON_PASTE, "true")</code> on the corresponding paragraph so that when it is pasted 
		 * it will blend into the paragraph where its pasted. This property should only be set on elements in a TextScrap, and
		 * only on the last element in the scrap.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
 	 	 * @langversion 3.0
		 */
		static public const MERGE_TO_NEXT_ON_PASTE:String = "mergeToNextOnPaste";
	}
}
