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
	import org.apache.royale.textLayout.elements.IFlowLeafElement;
	import org.apache.royale.textLayout.elements.IParagraphElement;
	import org.apache.royale.textLayout.elements.ITextFlow;

	

	
	/** 
	 * Export converter for plain text format. This class provides an alternative to
	 * the <code>TextConverter.export()</code> static method for exporting plain text.
	 *  The PlainTextExporter class's <code>export()</code> method results in the 
	 * same output string as the <code>TextConverter.export()</code> static method 
	 * if the two properties of the PlainTextExporter class, the <code>PARAGRAPH_SEPARATOR_PROPERTY</code>
	 * and the <code>STRIP_DISCRETIONARY_HYPHENS_PROPERTY</code> properties, contain their
	 * default values of <code>"\n"</code> and <code>true</code>, respectively.
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 */
	public class PlainTextExporter extends ConverterBase implements IPlainTextExporter	
	{
		private var _stripDiscretionaryHyphens:Boolean;
		private var _paragraphSeparator:String;
		
		static private var _discretionaryHyphen:String = String.fromCharCode(0x00AD);
		

		
		/**
		 * Constructor 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */

		public function PlainTextExporter()
		{
			_stripDiscretionaryHyphens = true;
			_paragraphSeparator = "\n";
		}
		 
		/** @copy IPlainTextExporter#stripDiscretionaryHyphens
  		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0-
		 */
		public function get stripDiscretionaryHyphens():Boolean
		{ return _stripDiscretionaryHyphens; }
		public function set stripDiscretionaryHyphens(value:Boolean):void
		{ _stripDiscretionaryHyphens = value; }

		/** @copy IPlainTextExporter#paragraphSeparator
 		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get paragraphSeparator():String
		{ return _paragraphSeparator; }
		public function set paragraphSeparator(value:String):void
		{ _paragraphSeparator = value; }

		/** @copy ITextExporter#export()
		 */
		public function export(source:ITextFlow, conversionType:String):Object
		{
			clear();
			if (conversionType == ConversionType.STRING_TYPE)
				return exportToString(source);
			return null;
		}
		
		/** Export text content as a string
		 * @param source	the text to export
		 * @return String	the exported content
		 * 
  		 * @private
		 */
		protected function exportToString(source:ITextFlow):String
		{
			var rslt:String = "";
			var leaf:IFlowLeafElement = source.getFirstLeaf(); 
			
			while (leaf)
			{
            	var p:IParagraphElement = leaf.getParagraph();
            	while (true)
            	{
            		var curString:String = leaf.text;
            		
            		//split out discretionary hyphen and put string back together
            		if (_stripDiscretionaryHyphens)
            		{
						var temparray:Array = curString.split(_discretionaryHyphen);
						curString = temparray.join("");
            		}
					
	               	rslt += curString;
					var nextLeaf:IFlowLeafElement = leaf.getNextLeaf(p);
					if (!nextLeaf)
						break; // end of para
					
					leaf = nextLeaf;
            	}
            	
            	leaf = leaf.getNextLeaf();
            	if (leaf) // not the last para
                   	rslt += _paragraphSeparator; 
   			}
			
			if (useClipboardAnnotations)
			{
				// Append a final paragraph separator if the last paragraph is not marked as a partial element
				var lastPara:IParagraphElement = source.getLastLeaf().getParagraph();
				if (lastPara.getStyle(ConversionConstants.MERGE_TO_NEXT_ON_PASTE) != "true")
					rslt += _paragraphSeparator;
				
			}
   			return rslt;
		}
	}
		
}
