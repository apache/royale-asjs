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
	import org.apache.royale.textLayout.factory.TLFFactory;
	import org.apache.royale.textLayout.elements.IFlowLeafElement;
	import org.apache.royale.textLayout.elements.IConfiguration;
	import org.apache.royale.textLayout.elements.IParagraphElement;
	import org.apache.royale.textLayout.elements.ISpanElement;
	import org.apache.royale.textLayout.elements.TextFlow;
	import org.apache.royale.textLayout.elements.ITextFlow;
	import org.apache.royale.textLayout.elements.ElementHelper;


	// import container.TextFrame;
	


	// [ExcludeClass]
	/** 
	 * @private
	 * PlainText import converter. Use this to import simple unformatted Unicode text.
	 * Newlines will be converted to paragraphs. Using the PlainTextImporter directly
	 * is equivalent to calling TextConverter.importToFlow(TextConverter.PLAIN_TEXT_FORMAT).
	 */
	public class PlainTextImporter extends ConverterBase implements ITextImporter
	{
		protected var _config:IConfiguration = null;
		
		/** Constructor */
		public function PlainTextImporter()
		{
		}
		
		/** @copy ITextImporter#importToFlow()
		 */
		public function importToFlow(source:Object):ITextFlow
		{
			if (source is String)
				return importFromString(String(source));
			return null;
		}
		
		/**
		 * The <code>configuration</code> property contains the IConfiguration instance that
		 * the importerd needs when creating new ITextFlow instances. This property
		 * is initially set to <code>null</code>.
		 * @see ITextFlow constructor
		 * @playerversion Flash 10.2
		 * @playerversion AIR 2.0
		 * @langversion 3.0
		 */
		public function get configuration():IConfiguration
		{
			return _config;
		}
		
		public function set configuration(value:IConfiguration):void
		{
			_config = value;
		}
		
		
		// LF or CR or CR+LF. Equivalently, LF or CR, the latter optionally followed by LF
		private static const _newLineRegex:RegExp = /\u000A|\u000D\u000A?/g;
		
		/** Import text content, from an external source, and convert it into a ITextFlow.
		 * @param source		source data to convert
		 * @return textFlows[]	an array of ITextFlow objects that were created from the source.
		 */
		protected function importFromString(source:String):ITextFlow
		{
			var paragraphStrings:Array = source.split(_newLineRegex);

			var textFlow:ITextFlow = new TextFlow(TLFFactory.defaultTLFFactory,_config);
			var paraText:String;
			for each (paraText in paragraphStrings)
			{
				var paragraph:IParagraphElement  = ElementHelper.getParagraph();	// No PMD
				var span:ISpanElement = ElementHelper.getSpan();	// No PMD
				span.replaceText(0, 0, paraText);
				paragraph.replaceChildren(0, 0, span);			
				textFlow.replaceChildren(textFlow.numChildren, textFlow.numChildren, paragraph);
			}

			// Mark partial last paragraph (string doesn't end in paragraph terminator)
			if (useClipboardAnnotations && 
				source.lastIndexOf('\u000A', source.length - 1) != source.length - 1)
			{
				var lastLeaf:IFlowLeafElement = textFlow.getLastLeaf();
				lastLeaf.setStyle(ConversionConstants.MERGE_TO_NEXT_ON_PASTE, "true");
				lastLeaf.parent.setStyle(ConversionConstants.MERGE_TO_NEXT_ON_PASTE, "true");
				textFlow.setStyle(ConversionConstants.MERGE_TO_NEXT_ON_PASTE, "true");
			}
			return textFlow;			
		}

	}
}
