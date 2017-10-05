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
package org.apache.royale.textLayout.edit
{
	import org.apache.royale.textLayout.conversion.ConversionConstants;
	import org.apache.royale.textLayout.conversion.ConversionType;
	import org.apache.royale.textLayout.conversion.FormatDescriptor;
	import org.apache.royale.textLayout.conversion.ITextExporter;
	import org.apache.royale.textLayout.conversion.ITextImporter;
	import org.apache.royale.textLayout.conversion.TextConverter;
	import org.apache.royale.textLayout.elements.FlowGroupElement;
	import org.apache.royale.textLayout.elements.IFlowElement;
	import org.apache.royale.textLayout.elements.ITextFlow;

	COMPILE::JS
	{
		import org.apache.royale.textLayout.conversion.PlainTextImporter;
	}


	/**
	 * The TextClipboard class copies and pastes TextScrap objects to and from the system clipboard.
	 * 
	 * <p>When you copy a TextScrap to the TextClipboard, the information is copied to the
	 * system clipboard in two clipboard formats. One format is an XML string expressing the copied 
	 * TextScrap object in Text Layout Markup syntax. This clipboard object uses the format name: 
	 * "TEXT_LAYOUT_MARKUP". The second format is a plain-text string, which uses the standard 
	 * Clipboard.TEXT_FORMAT name.</p>
	 * 
	 * <p>The methods of the TextClipboard class are static functions, you do not need to
	 * create an instance of TextClipboard.</p>  
	 * 
	 * @see flash.desktop.Clipboard
	 * 
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
 	 * @langversion 3.0
	*/
	public class TextClipboard
	{	
		/** @private */
		static public const TEXT_LAYOUT_MARKUP:String = "TEXT_LAYOUT_MARKUP";
		
		/**
		 * Gets any text on the system clipboard as a TextScrap object.
		 *  
		 * <p>If the "TEXT_LAYOUT_MARKUP" format is available, this method converts the formatted
		 * string into a TextScrap and returns it. Otherwise, if the Clipboard.TEXT_Format is available,
		 * this method converts the plain-text string into a TextScrap. If neither clipboard format
		 * is available, this method returns <code>null</code>.</p>
		 * 
		 * <p>Flash Player requires that the <code>getContents()</code> method be called in a paste event handler. In AIR, 
		 * this restriction only applies to content outside of the application security sandbox.</p>
		 * 
		 * @see org.apache.royale.events.Event#PASTE
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
		 */										
		public static function getContents():TextScrap
		{
			var systemClipboard:Clipboard = Clipboard.generalClipboard;
			COMPILE::SWF
			{
				return importScrap(getFromClipboard);
			}

			COMPILE::JS
			{
				systemClipboard.preventDefault();
				if(systemClipboard.hasFormat(TextConverter.TEXT_LAYOUT_FORMAT))
					return systemClipboard.getData(TextConverter.TEXT_LAYOUT_FORMAT) as TextScrap;
				else
				{
					var importer:PlainTextImporter = new PlainTextImporter();
					var flow:ITextFlow = importer.importToFlow(systemClipboard.getData("text/plain"));
					var textScrap:TextScrap = new TextScrap(flow);
					textScrap.setPlainText(true);
					return textScrap;
				}
			}


			return importScrap(getFromClipboard);

			function getFromClipboard(clipboardFormat:String):String
			{
				return (systemClipboard.hasFormat(clipboardFormat)) ? String(systemClipboard.getData(clipboardFormat)) : null;
			}
			
		}
				
		/** @private 
		 * Internal function to import a scrap to available clipboard formats. It abstracts 
		 * out the actual clipboard access so it can be called from testing code.
		 **/
		public static function importScrap(importFunctor:Function):TextScrap
		{
			var textScrap:TextScrap;
			var textOnClipboard:String;

			var numFormats:int = TextConverter.numFormats;
			for (var i:int = 0; i < numFormats && !textScrap; ++i)
			{
				var descriptor:FormatDescriptor = TextConverter.getFormatDescriptorAt(i);
				textOnClipboard = importFunctor(descriptor.clipboardFormat);
				if (textOnClipboard && (textOnClipboard != ""))
				{
					textOnClipboard = textOnClipboard.replace(/\u000B/g,"\u2028");
					textScrap = importToScrap(textOnClipboard, descriptor.format);
				}
			}
			return textScrap;
		}

		/**
		 * Puts a TextScrap onto the system clipboard.  
		 * 
		 * <p>The TextScrap is placed onto the system clipboard as both a Text Layout Markup
		 * representation and a plain text representation.</p>
		 * 
		 * <p>Flash Player requires a user event (such as a key press or mouse click) before 
		 * calling <code>setContents()</code>. In AIR, this restriction only applies to content outside of 
		 * the application security sandbox. </p>
		 * 
		 * @param scrap The TextScrap to paste into the clipboard.
		 * 
		 * @see org.apache.royale.events.Event#COPY
		 * @see org.apache.royale.events.Event#CUT
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
 		 */										
		public static function setContents(textScrap:TextScrap):void
		{ 
			if (!textScrap) 
				return;

			var systemClipboard:Clipboard = Clipboard.generalClipboard;
			systemClipboard.clear();
			
			COMPILE::SWF
			{
				exportScrap(textScrap, addToClipboard);
			}

			COMPILE::JS
			{
				systemClipboard.setData(TextConverter.TEXT_LAYOUT_FORMAT, textScrap);
				systemClipboard.setData("text/plain", textScrap.textFlow.getText());
				systemClipboard.preventDefault();
			}

			function addToClipboard(clipboardFormat:String, clipboardData:String):void 
			{ 						
				systemClipboard.setData(clipboardFormat, clipboardData); 
			}
		}
		
		/** @private 
		 * Internal function to export a scrap to available clipboard formats. It abstracts 
		 * out the actual clipboard access so it can be called from testing code.
		 **/
		public static function exportScrap(scrap:TextScrap, exportFunctor:Function):void
		{
			var formatsPosted:Array = [];	// one clipboardFormat may have multiple formats, but we only post one result per clipboardFormat
			
			var numFormats:int = TextConverter.numFormats;
			for (var i:int = 0; i < numFormats; i++)
			{
				var descriptor:FormatDescriptor = TextConverter.getFormatDescriptorAt(i);
				if (descriptor.clipboardFormat && formatsPosted.indexOf(descriptor.clipboardFormat) < 0)
				{
					var exportString:String = exportForClipboard(scrap, descriptor.format);
					if (exportString)
					{
						exportFunctor(descriptor.clipboardFormat, exportString);
						formatsPosted.push(descriptor.clipboardFormat);
					}
				}
			}
		}
		
		/** @private */
		public static function importToScrap(textOnClipboard:String, format:String):TextScrap
		{
			var textScrap:TextScrap;
			var importer:ITextImporter = TextConverter.getImporter(format);
			if (importer)
			{
				importer.useClipboardAnnotations = true;
				var textFlow:ITextFlow = importer.importToFlow(textOnClipboard);
				if (textFlow) {
					textScrap = new TextScrap(textFlow);
					
					/** Hint to the scrap about whether text is plain or formatted. If not set, scrap will inspect text for attributes. */
					if (format == TextConverter.PLAIN_TEXT_FORMAT)
						textScrap.setPlainText(true);
					else if (format == TextConverter.TEXT_LAYOUT_FORMAT)
						textScrap.setPlainText(false);
				}
				
				// Backwards compatibility: check for older scrap format
				if (!textScrap && format == TextConverter.TEXT_LAYOUT_FORMAT)
					textScrap = importOldTextLayoutFormatToScrap(textOnClipboard);
			}
			
			return textScrap;
		}
		
		/** @private */
		public static function importOldTextLayoutFormatToScrap(textOnClipboard:String):TextScrap
		{
			var textScrap:TextScrap;
			
			// The clipboard format for TLF 1.0 and 1.1 had a root "TextScrap" object with a TextFlow child and
			// encodings for the begin partial elements and the end partial elements. Convert the string to an XML object, 
			// and then translate the children.
			var originalSettings:Object = XML.settings();
			try {
				XML.ignoreProcessingInstructions = false;
				XML.ignoreWhitespace = false;
				var xmlTree:XML = new XML(textOnClipboard);
				if (xmlTree.localName() == "TextScrap")
				{		// read the old clipboard format
					var beginArrayChild:XML = xmlTree..*::BeginMissingElements[0];
					var endArrayChild:XML = xmlTree..*::EndMissingElements[0];
					var textLayoutMarkup:XML = xmlTree..*::TextFlow[0];
					var textFlow:ITextFlow = TextConverter.importToFlow(textLayoutMarkup, TextConverter.TEXT_LAYOUT_FORMAT);
					if (textFlow)
					{
						textScrap = new TextScrap(textFlow);
						var element:IFlowElement;
						var endMissingArray:Array = getEndArray(endArrayChild, textFlow);
						for each (element in endMissingArray)
							element.setStyle(ConversionConstants.MERGE_TO_NEXT_ON_PASTE, "true");
					}
				}
//TODO probably does not make sense for Royale
//				if (Configuration.playerEnablesArgoFeatures)
//					System["disposeXML"](xmlTree);

			}
			finally
			{
				XML.setSettings(originalSettings);
			}		
			return textScrap;
		}
		
		/** @private */
		public static function exportForClipboard(scrap:TextScrap, format:String):String
		{
			var exporter:ITextExporter = TextConverter.getExporter(format);
			if (exporter)
			{
				exporter.useClipboardAnnotations = true;
				return exporter.export(scrap.textFlow, ConversionType.STRING_TYPE) as String;
			}
			return null;
		}
		
		private static function getBeginArray(beginArrayChild:XML, textFlow:ITextFlow):Array
		{
			var beginArray:Array = new Array();
			var curFlElement:IFlowElement = textFlow;
			if (beginArrayChild != null)
			{
				var value:String = (beginArrayChild.@value != undefined) ? String(beginArrayChild.@value) : "";
				beginArray.push(textFlow);
				var posOfComma:int = value.indexOf(",");
				var startPos:int;
				var endPos:int;
				var curStr:String;
				var indexIntoFlowElement:int;
				while (posOfComma >= 0)
				{
					startPos = posOfComma + 1;
					posOfComma = value.indexOf(",", startPos);
					if (posOfComma >= 0)
					{
						endPos = posOfComma;
					} else {
						endPos = value.length;
					}
					curStr = value.substring(startPos, endPos);
					if (curStr.length > 0)
					{
						indexIntoFlowElement = parseInt(curStr);
						if (curFlElement is FlowGroupElement)
						{
							curFlElement = (curFlElement as FlowGroupElement).getChildAt(indexIntoFlowElement);
							beginArray.push(curFlElement);
						}
					}
				}				
			}
			return beginArray.reverse();
		}
		
		private static function getEndArray(endArrayChild:XML, textFlow:ITextFlow):Array
		{
			var endArray:Array = new Array();
			var curFlElement:IFlowElement = textFlow;
			if (endArrayChild != null)
			{
				var value:String = (endArrayChild.@value != undefined) ? String(endArrayChild.@value) : "";
				endArray.push(textFlow);
				var posOfComma:int = value.indexOf(",");
				var startPos:int;
				var endPos:int;
				var curStr:String;
				var indexIntoFlowElement:int;
				while (posOfComma >= 0)
				{
					startPos = posOfComma + 1;
					posOfComma = value.indexOf(",", startPos);
					if (posOfComma >= 0)
					{
						endPos = posOfComma;
					} else {
						endPos = value.length;
					}
					curStr = value.substring(startPos, endPos);
					if (curStr.length > 0)
					{
						indexIntoFlowElement = parseInt(curStr);
						if (curFlElement is FlowGroupElement)
						{
							curFlElement = (curFlElement as FlowGroupElement).getChildAt(indexIntoFlowElement);
							endArray.push(curFlElement);
						}
					}
				}				
			}
			return endArray.reverse();
		}

		
	} // end TextClipboard class
}

class TextClipboardSingletonEnforcer {}
