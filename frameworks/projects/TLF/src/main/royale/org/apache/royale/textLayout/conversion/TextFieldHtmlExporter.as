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
	import org.apache.royale.textLayout.elements.ListElement;
	import org.apache.royale.textLayout.elements.IFlowGroupElement;
	import org.apache.royale.reflection.getQualifiedClassName;
	import org.apache.royale.text.engine.Kerning;
	import org.apache.royale.text.engine.TabAlignment;
	import org.apache.royale.textLayout.debug.assert;
	import org.apache.royale.textLayout.elements.BreakElement;
	import org.apache.royale.textLayout.elements.DivElement;
	import org.apache.royale.textLayout.elements.FlowGroupElement;
	import org.apache.royale.textLayout.elements.IFlowElement;
	import org.apache.royale.textLayout.elements.IFlowLeafElement;
	import org.apache.royale.textLayout.elements.IParagraphElement;
	import org.apache.royale.textLayout.elements.InlineGraphicElement;
	import org.apache.royale.textLayout.elements.LinkElement;
	import org.apache.royale.textLayout.elements.IListElement;
	import org.apache.royale.textLayout.elements.ListItemElement;
	import org.apache.royale.textLayout.elements.IParagraphElement;
	import org.apache.royale.textLayout.elements.SpanElement;
	import org.apache.royale.textLayout.elements.SubParagraphGroupElement;
	import org.apache.royale.textLayout.elements.SubParagraphGroupElementBase;
	import org.apache.royale.textLayout.elements.TCYElement;
	import org.apache.royale.textLayout.elements.TabElement;
	import org.apache.royale.textLayout.elements.ITextFlow;
	import org.apache.royale.textLayout.formats.Direction;
	import org.apache.royale.textLayout.formats.Float;
	import org.apache.royale.textLayout.formats.FormatValue;
	import org.apache.royale.textLayout.formats.ITextLayoutFormat;
	import org.apache.royale.textLayout.formats.LeadingModel;
	import org.apache.royale.textLayout.formats.TabStopFormat;
	import org.apache.royale.textLayout.formats.TextAlign;
	import org.apache.royale.textLayout.formats.TextLayoutFormat;

	// [ExcludeClass]
	/** 
	* @private
	* Export converter for HTML format. 
	*/
	public class TextFieldHtmlExporter extends ConverterBase implements ITextExporter	
	{
		/** @private */
		public static var _config:ImportExportConfiguration;
		
		public function TextFieldHtmlExporter()
		{
			if (!_config)
			{
				_config = new ImportExportConfiguration();
				_config.addIEInfo(null, DivElement, null, exportDiv);
				_config.addIEInfo(null, IParagraphElement, null, exportParagraph);
				_config.addIEInfo(null, LinkElement, null, exportLink);
				_config.addIEInfo(null, TCYElement, null, exportTCY);
				_config.addIEInfo(null, SubParagraphGroupElement, null, exportSPGE);
				_config.addIEInfo(null, SpanElement, null, exportSpan);
				_config.addIEInfo(null, InlineGraphicElement, null, exportImage);
				_config.addIEInfo(null, TabElement, null, exportTab);
				_config.addIEInfo(null, BreakElement, null, exportBreak);
				_config.addIEInfo(null, ListElement, null, exportList);
				_config.addIEInfo(null, ListItemElement, null, exportListItem);
			}
		}
		 
		/** @copy ITextExporter#export()
		 */
		public function export(source:ITextFlow, conversionType:String):Object
		{
			var result:XML = exportToXML(source);
			return conversionType == ConversionType.STRING_TYPE ? BaseTextLayoutExporter.convertXMLToString(result) : result;
		}
		
		/** Export text content of a TextFlow into HTML format.
		 * @param source	the text to export
		 * @return XML	the exported content
		 * @private
		 */
		public function exportToXML(textFlow:ITextFlow) : XML
		{
			var html:XML = <HTML/>;
			
			if (textFlow.numChildren != 0)
			{
				if (textFlow.getChildAt(0).typeName != "BODY")
				{
					var body:XML = <BODY/>;
					html.appendChild(body);
					exportChildren(textFlow,body);
				}
				else
					exportChildren(textFlow,html);
			}
			
			return html;
		}
		
		/** create the XMl tag for an element. @private */
		static public function makeTaggedTypeName(elem:IFlowElement,defaultTag:String):XML
		{
			if (elem.typeName == elem.defaultTypeName)
				return <{defaultTag}/>;
			return <{elem.typeName.toUpperCase()}/>;
		}
		
		/** export styleName and id @private */
		public static function exportStyling(elem:IFlowElement, xml:XML):void
		{
			if (elem.id != null)
				xml.@id = elem.id;
//TODO @
			// if (elem.styleName != null)
			// 	xml.@["class"] = elem.styleName;
		}
		
		/** export FlowGroupElement children into parentXML. @private */
		public function exportChildren(elem:IFlowGroupElement,parentXML:XML):void
		{
			for (var idx:int = 0; idx < elem.numChildren; idx++)
			{
				var child:IFlowElement = elem.getChildAt(idx);
				exportElement(child,parentXML);
			}
		}
		
		/** Export a List @private */
		public function exportList(list:IListElement, parentXML:XML):void
		{
			var xml:XML;
			if (list.isNumberedList())
				xml = <OL/>;
			else
				xml = <UL/>;
			exportStyling(list, xml);
			exportChildren(list, xml);
			
			if (list.typeName != list.defaultTypeName)
			{
				var typeNameXML:XML = <{list.typeName}/>;
				typeNameXML.appendChild(xml);
				parentXML.appendChild(typeNameXML);
			}
			else
				parentXML.appendChild(xml);
		}

		
		/** Export a ListItem @private */
		public function exportListItem(li:ListItemElement, parentXML:XML):void
		{
			// WARNING: no solution for a listitem with a custom typeName - loose the typeName
			var xml:XML = <LI/>;
			exportStyling(li, xml);
			exportChildren(li, xml);
			
			// if we've got exactly one P promote its child directly into the LI.  It causes TextField to add an extra paragraph.  Ugly.
			var children:XMLList = xml.children();
			if (children.length() == 1)
			{
				var child:XML = children[0];
				if (child.name().localName == "P")
				{
					var paraChildren:XMLList = child.children();
					if (paraChildren.length() == 1)
					{
						xml = <LI/>;
						xml.appendChild(paraChildren[0]);
					}
				}
			}
			parentXML.appendChild(xml);
		}
		
		/** Export a DIV element */
		public function exportDiv(div:DivElement, parentXML:XML):void
		{
			var xml:XML = makeTaggedTypeName(div,"DIV");			
			exportStyling(div, xml);
			exportChildren(div, xml);
			parentXML.appendChild(xml);			
		}
		
		/** Export a paragraph
		 * @private
		 */
		public function exportParagraph(para:IParagraphElement, parentXML:XML):void
		{
			// Exported as a <P/>
			// Some paragraph-level formats (such as textAlign) are exported as attributes of <P/>, 
			// Others (such as textIndent) are exported as attributes of the <TEXTFORMAT/> parent of <P/>
			// Some character-level formats (such as fontSize) are exported as attributes of the <FONT/> child of <P/>
			// Children of the IParagraphElement are nested inside the <FONT/>
			var xml:XML = makeTaggedTypeName(para,"P");
			exportStyling(para, xml);
			
			var fontXML:XML = exportFont(para.computedFormat);
			CONFIG::debug { assert(fontXML != null, "Expect exportFont to return non-null xml if second parameter (ifDifferentFromFormat) is null"); }
			exportSubParagraphChildren(para, fontXML);
			nest(xml, fontXML);
			
			parentXML.appendChild(exportParagraphFormat(xml, para));
		}
		
		/** Export a link
		 * @private
		 */
		public function exportLink(link:LinkElement, parentXML:XML):void
		{
			// Exported as an <A/> with HREF and TARGET attributes
			// Children of the LinkElement are nested inside the <A/>
			// If the computed values of certain character-level formats differ from the corresponding computed values for the
			// containing paragraph, these are exported as attributes of a <FONT/> which (in this case) parents the <A/>.
			var xml:XML = <A/>;

			if (link.href)
				xml.@HREF= link.href;
			if (link.target)
				xml.@TARGET = link.target;
			else
			{
				// TextField uses _self as the default target  
				// while TLF uses null (funcionally identical to _blank). Account for this difference.
				xml.@TARGET = "_blank";
			}
			exportSubParagraphElement(link, xml, parentXML);
		}
		
		/** Export a tcy element
		 * @private
		 */
		public function exportTCY(tcy:TCYElement, parentXML:XML):void
		{
			// make it a custom element - this will round trip it
			// note if the element has a custom typeName that typeName is going to be built as a parent
			var xml:XML = <TCY/>;
			exportSubParagraphElement(tcy, xml, parentXML);
		}
		
		
		/** Export a SubParagraphGroupElement
		 * @private
		 */
		public function exportSPGE(spge:SubParagraphGroupElement, parentXML:XML):void
		{
			var xml:XML = spge.typeName != spge.defaultTypeName ? <{spge.typeName}/> : <SPAN/>;
			exportSubParagraphElement(spge, xml, parentXML, false);
		}
		
		public function exportSubParagraphElement(elem:SubParagraphGroupElementBase, xml:XML, parentXML:XML, checkTypeName:Boolean=true):void
		{
			exportStyling(elem, xml);
			exportSubParagraphChildren(elem, xml);
			
			var format:ITextLayoutFormat = elem.computedFormat;
			var ifDifferentFromFormat:ITextLayoutFormat = elem.parent.computedFormat;
			
			var font:XML = exportFont(format, ifDifferentFromFormat);	
			var childXML:XML = font ? nest(font, xml) : xml;
			
			if (checkTypeName && elem.typeName != elem.defaultTypeName)
			{
				var typeNameXML:XML = <{elem.typeName}/>;
				typeNameXML.appendChild(childXML);
				parentXML.appendChild(typeNameXML);				
			}
			else
				parentXML.appendChild(childXML);
		}
		
		/** @private */
		static public const brRegEx:RegExp = /\u2028/;
		
		/** Gets the xml element used to represent a character in the export format
		 * @private
		 */
		static public function getSpanTextReplacementXML(ch:String):XML
		{
			CONFIG::debug {assert(ch == '\u2028', "Did not recognize character to be replaced with XML"); }
			return <BR/>;
		}
		
		/** Export a span
		 * @private
		 */
		public function exportSpan(span:SpanElement, parentXML:XML):void
		{
			// Span text is exported as a text node (or text nodes delimited by <BR/> elements for any occurences of U+2028)
			// These text nodes and <BR/> elements are optionally nested in formatting elements
			var xml:XML  = makeTaggedTypeName(span, "SPAN"); 
			exportStyling(span, xml);
			BaseTextLayoutExporter.exportSpanText(xml, span, brRegEx, getSpanTextReplacementXML);
			
			// for brevity, do not export attribute-less <span> tags; export just their children
			if (span.id == null && span.styleName == null && span.typeName == span.defaultTypeName)
			{
				var children:Object = xml.children();
					
				// Workaround for bug 1852072 : extraneous tags can appear around a string child added after an XML element 
				if (children.length() == 1 && children[0].nodeKind() == "text")
					children = xml.text()[0];
					
				parentXML.appendChild(exportSpanFormat(children, span));
			}
			else
				parentXML.appendChild(exportSpanFormat(xml, span));
		}
		
		/** Export an inline graphic
		 * @private
		 */
		public function exportImage(image:InlineGraphicElement, parentXML:XML):void
		{
			// Exported as an <IMG/> with SRC, WIDTH, HEIGHT and ALIGN attributes
			var xml:XML = <IMG/>;
			exportStyling(image, xml);
			if (image.source)
				xml.@SRC = image.source;
			if (image.width !== undefined && image.width != FormatValue.AUTO) 
				xml.@WIDTH = image.width;
			// xml.@WIDTH = image.actualWidth;
			if (image.height !== undefined && image.height != FormatValue.AUTO) 
				xml.@HEIGHT = image.height;
			// xml.@HEIGHT = image.actualHeight;	
			if (image.computedFloat != Float.NONE)
				xml.@ALIGN = image.float;
			
			if (image.typeName != image.defaultTypeName)
			{
				var typeNameXML:XML = <{image.typeName}/>;
				typeNameXML.appendChild(xml);
				parentXML.appendChild(typeNameXML);
			}
			else
				parentXML.appendChild(xml);
		}
	
		/** Export a break
		 * Is this ever called: BreakElements are either merged with adjacent spans or become spans? 
		 * @private
		 */		
		public function exportBreak(breakElement:BreakElement,parentXML:XML):void
		{
			parentXML.appendChild(<BR/>);
		}
		
		/** Export a tab
		 * Is this ever called: TabElements are either merged with adjacent spans or become spans? 
		 * @private
		 */	
		public function exportTab(tabElement:TabElement, parentXML:XML):void
		{
			// Export as a span
			exportSpan(tabElement, parentXML);
		}
		
		/** @private */
		public function exportTextFormatAttribute (textFormatXML:XML, attrName:String, attrVal:*):XML
		{
			if (!textFormatXML)
				textFormatXML = <TEXTFORMAT/>;

//TODO @
			// textFormatXML.@[attrName] = attrVal;
			
			return textFormatXML;	
		}
		
		/** Exports the paragraph-level format for a paragraph  
		 * @param xml xml to decorate with attributes or add nest in formatting elements
		 * @para the paragraph
		 * @return XML	the outermost XML element after exporting 
		 * @private
		 */	
		public function exportParagraphFormat(xml:XML, para:IParagraphElement):XML
		{	
			var paraFormat:ITextLayoutFormat = para.computedFormat;
			
			var textAlignment:String;
			switch(paraFormat.textAlign)
			{
				case TextAlign.START:
					textAlignment = (paraFormat.direction == Direction.LTR) ? TextAlign.LEFT : TextAlign.RIGHT;
					break;
				case TextAlign.END:
					textAlignment = (paraFormat.direction == Direction.LTR) ? TextAlign.RIGHT : TextAlign.LEFT;
					break;
				default:
					textAlignment = paraFormat.textAlign;
			}
			xml.@ALIGN = textAlignment;
					
			var textFormat:XML;
			
			if (paraFormat.paragraphStartIndent != 0)
				textFormat = exportTextFormatAttribute (textFormat, paraFormat.direction == Direction.LTR ? "LEFTMARGIN" : "RIGHTMARGIN", paraFormat.paragraphStartIndent);
			
			if (paraFormat.paragraphEndIndent != 0)
				 textFormat = exportTextFormatAttribute (textFormat, paraFormat.direction == Direction.LTR ? "RIGHTMARGIN" : "LEFTMARGIN", paraFormat.paragraphEndIndent);
			
			if (paraFormat.textIndent != 0)
				textFormat = exportTextFormatAttribute(textFormat, "INDENT", paraFormat.textIndent);
				
			if (paraFormat.leadingModel == LeadingModel.APPROXIMATE_TEXT_FIELD)
			{
				var firstLeaf:IFlowLeafElement = para.getFirstLeaf();
				if (firstLeaf)
				{
					var lineHeight:Number = TextLayoutFormat.lineHeightProperty.computeActualPropertyValue(firstLeaf.computedFormat.lineHeight,firstLeaf.getEffectiveFontSize());
					if (lineHeight != 0)
						textFormat = exportTextFormatAttribute(textFormat, "LEADING", lineHeight);
				}
			}
			
			var tabStops:Array = paraFormat.tabStops;
			if (tabStops)
			{
				var tabStopsString:String = "";
				for each (var tabStop:TabStopFormat in tabStops)
				{
					if (tabStop.alignment != TabAlignment.START)
						break;
					
					if (tabStopsString.length)
						tabStopsString += ", ";
					
					tabStopsString += tabStop.position;
				}
				
				if (tabStopsString.length)
					textFormat = exportTextFormatAttribute(textFormat, "TABSTOPS", tabStopsString);
			}
			
			return textFormat ? nest(textFormat, xml) : xml;
		}
		
		/** Exports the character-level format for a span  
		 * @param xml xml/xmlList to nest in formatting elements
		 * @span the span
		 * @return XML	the outermost XML element after exporting 
		 * @private
		 */	
		public function exportSpanFormat(xml:Object, span:SpanElement):Object
		{
			// These are optionally nested in a <FONT/> with appopriate attributes ,			 
			
			var format:ITextLayoutFormat = span.computedFormat;
			var outerElement:Object = xml;
			
			// Nest in <B/>, <I/>, or <U/> if applicable
			if (format.textDecoration.toString() == org.apache.royale.textLayout.formats.TextDecoration.UNDERLINE)
				outerElement = nest (<U/>, outerElement);
//TODO get HTML based on styles
//			if (format.fontStyle.toString() == org.apache.royale.text.engine.FontPosture.ITALIC)
//				outerElement = nest (<I/>, outerElement);
//			if (format.fontWeight.toString() == org.apache.royale.text.engine.FontWeight.BOLD)
//				outerElement = nest (<B/>, outerElement);
				
			// Nest in <FONT/> if the computed values of certain character-level formats 
			// differ from the corresponding computed values for the containing parent that's exported
			// A span can be contained in a TCY, link, or paragraph. Of these, TCY is not exported, so only
			// check link and paragraph.
			var exportedParent:IFlowElement = span.getParentByType("LinkElement");
			if (!exportedParent)
				exportedParent = span.getParagraph();
	
			var font:XML = exportFont(format, exportedParent.computedFormat);	
			if (font)
				outerElement = nest(font, outerElement);	

			return outerElement;			   	
		}	
		
		/** @private */
		public function exportFontAttribute (fontXML:XML, attrName:String, attrVal:*):XML
		{
			if (!fontXML)
				fontXML = <FONT/>;
				
//TODO @
			// fontXML.@[attrName] = attrVal;
			
			return fontXML;	
		}
		
		/**  
		 * Exports certain character level formats as a <FONT/> with appropriate attributes
		 * @param format format to export
		 * @param ifDifferentFromFormat if non-null, a value in format is exported only if it differs from the corresponding value in ifDifferentFromFormat
		 * @return XML	the populated XML element
		 * @private
		 */	
		public function exportFont(format:ITextLayoutFormat, ifDifferentFromFormat:ITextLayoutFormat=null):XML
		{
			var font:XML;
			if (!ifDifferentFromFormat || ifDifferentFromFormat.fontFamily != format.fontFamily)
				font = exportFontAttribute(font, "FACE", format.fontFamily);
			if (!ifDifferentFromFormat || ifDifferentFromFormat.fontSize != format.fontSize)
				font = exportFontAttribute(font, "SIZE", format.fontSize);
			if (!ifDifferentFromFormat || ifDifferentFromFormat.color != format.color)
			{
				var rgb:String = format.color.toString(16);
				while (rgb.length < 6) 
					rgb = "0" + rgb; // pad with leading zeros
				rgb = "#" + rgb;
				font = exportFontAttribute(font, "COLOR", rgb);
			}
			if (!ifDifferentFromFormat || ifDifferentFromFormat.trackingRight != format.trackingRight)
				font = exportFontAttribute(font, "LETTERSPACING", format.trackingRight); 
			if (!ifDifferentFromFormat || ifDifferentFromFormat.kerning != format.kerning)
				font = exportFontAttribute(font, "KERNING", format.kerning == Kerning.OFF ? "0" : "1");
						
			return font;				
		}
			
		/** Exports the flow element by finding the appropriate exporter
		 * @param flowElement	Element to export
		 * @return Object	XML/XMLList for the flowElement
		 * @private
		 */
		public function exportElement(flowElement:IFlowElement, parentXML:XML):void
		{
			var className:String = getQualifiedClassName(flowElement);
			var info:FlowElementInfo = _config.lookupByClass(className);
			if (info)
				info.exporter(flowElement, parentXML);
			else 
			{
				CONFIG::debug { assert(flowElement is FlowGroupElement,"Bad element in HtmlExport.exportElement"); }
				var xml:XML = <{flowElement.typeName.toUpperCase()}/>;
				exportChildren(flowElement as FlowGroupElement, xml);
				parentXML.appendChild(xml);
			}
		}
		
		/** Exports the children of a flow group element
		 * @param xml XML to append children to
		 * @param flowGroupElement	the flow group element
		 * @private
		 */
		public function exportSubParagraphChildren(flowGroupElement:IFlowGroupElement, parentXML:XML):void
		{
			for(var i:int=0; i < flowGroupElement.numChildren; ++i)
			{
				exportElement(flowGroupElement.getChildAt(i),parentXML);
			}
		}
		
		/** Helper to establish a parent-child relationship between two xml elements
		 * and return the parent
		 * @param parent the intended parent
		 * @param children the intended children (XML or XMLList)
		 * @return the parent
		 * @private
		 */
		static public function nest (parent:XML, children:Object):XML
		{
			parent.setChildren(children);
			return parent;
		}
		
 	}
}
