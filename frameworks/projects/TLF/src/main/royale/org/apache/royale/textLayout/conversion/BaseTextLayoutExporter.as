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
	import org.apache.royale.reflection.getQualifiedClassName;
	import org.apache.royale.textLayout.TextLayoutVersion;
	import org.apache.royale.textLayout.debug.assert;
	import org.apache.royale.textLayout.elements.FlowGroupElement;
	import org.apache.royale.textLayout.elements.IContainerFormattedElement;
	import org.apache.royale.textLayout.elements.IFlowElement;
	import org.apache.royale.textLayout.elements.IParagraphFormattedElement;
	import org.apache.royale.textLayout.elements.SpanElement;
	import org.apache.royale.textLayout.elements.TableCellElement;
	import org.apache.royale.textLayout.elements.TableElement;
	import org.apache.royale.textLayout.elements.TableRowElement;
	import org.apache.royale.textLayout.elements.ITextFlow;
	
	/** 
	 * Base export converter for TextLayout format. 
	 */
	public class BaseTextLayoutExporter extends ConverterBase implements ITextExporter
	{
		private var _rootTag:XML;
		private var _ns:Namespace;
		
		public function BaseTextLayoutExporter(ns:Namespace, rootTag:XML, configuration:ImportExportConfiguration)
		{
			config = configuration;
			_ns = ns;
			_rootTag = rootTag;
		}
		
		/** 
		 * @copy ITextExporter#export()
		 */
		public function export(source:ITextFlow, conversionType:String):Object
		{
			clear();
			
			var result:XML = exportToXML(source);
			return conversionType == ConversionType.STRING_TYPE ? convertXMLToString(result) : result;
		}
		
		/** 
		 * Export text content of a TextFlow into XFL format.
		 * 
		 * @param source	the text to export
		 * @return XML	the exported content
		 */
		protected function exportToXML(textFlow:ITextFlow) : XML
		{
			var result:XML;
			if (_rootTag)
			{
				result = new XML(_rootTag);
				result.addNamespace(_ns);
				result.appendChild(exportChild(textFlow));
			}
			else
			{
				result = XML(exportTextFlow(this, textFlow));
				result.addNamespace(_ns);
			}
			return result;
		}
		
		/** 
		 * Export text content as a string
		 * 
		 * @param xml	the XML to convert
		 * @return String	the exported content
		 * @private
		 */
		static public function convertXMLToString(xml:XML):String
		{
			var result:String;
			// Adjust settings so that leading and trailing spaces in the XML don't get dropped when it is converted to a string
			var originalSettings:Object = XML.settings();
			try
			{
				XML.ignoreProcessingInstructions = false;		
				XML.ignoreWhitespace = false;
				XML.prettyPrinting = false;
				result = xml.toXMLString();
//TODO probably does not make sense for Royale
//				if (Configuration.playerEnablesArgoFeatures)
//					System["disposeXML"](xml);
				XML.setSettings(originalSettings);
			}
			catch(e:Error)
			{
				XML.setSettings(originalSettings);
				throw(e);
			}		
			return result;
		}

	
		/** 
		 * Base functionality for exporting a FlowElement.
		 *  
		 * @param exporter	Root object for the export
		 * @param flowElement	Element to export
		 * @return XMLList	XML for the element
		 */
		static public function exportFlowElement(exporter:BaseTextLayoutExporter, flowElement:IFlowElement):XMLList
		{
			return exporter.exportFlowElement(flowElement);
		}
		
		/** 
		 * Overridable worker method for exporting a FlowElement. Creates the XMLList.
		 * 
		 * @param flowElement	Element to export
		 * @return XMLList	XML for the element
		 */
		protected function exportFlowElement (flowElement:IFlowElement):XMLList
		{
			var className:String = getQualifiedClassName(flowElement);
			var elementName:String = config.lookupName(className);	// NO PMD
			var output:XML = <{elementName}/>;
			output.setNamespace(_ns);
			return XMLList(output);
		}
		
		static public function exportSpanText(destination:XML, span:SpanElement, replacementRegex:RegExp, replacementXMLCallback:Function):void
		{
			//get the text for this span
			var spanText:String = span.text;

			// Check to see if it has text that needs to be converted			
			var matchLocation:Array = spanText.match(replacementRegex);
			
			if(matchLocation)	
			{
				var dummy:XML;
				
				// We have text that has characters to be converted. Break it up into runs of text interspersed with elements corresponding to match these characters
				while(matchLocation != null)
				{
					var ix:int = matchLocation.index;
					var tempStr:String = spanText.substr(0, ix);
					
					//if we have some text which does not need to be replaced, then write it now
					if(tempStr.length > 0)
					{
						// output[0].appendChild(tempStr); // extraneous tags can appear around a string child added after an XML element: see bug 1852072  
						
						// workaround for above-mentioned bug
						dummy = <dummy/>;
						dummy.appendChild(tempStr); // no extraneous tags here since there is no preceding XML element sibling
						destination.appendChild(dummy.text()[0]);
					}
					
					var replacementXML:XML = replacementXMLCallback(spanText.charAt(ix));
					CONFIG::debug{ assert(replacementXML != null, "Specified match regex, but provided null replacement XML"); }
					destination.appendChild(replacementXML);
					
					//remove the text up to this point
					spanText = spanText.slice(ix + 1, spanText.length);
					
					//look for another character to be replaced
					matchLocation = spanText.match(replacementRegex);
					
					//if we don't have any more matches, but there is still text, write that out as the last span
					if(!matchLocation && spanText.length > 0)
					{
						// output[0].appendChild(spanText); // extraneous tags can appear around a string child added after an XML element: see bug 1852072  
						
						// workaround for above-mentioned bug
						dummy = <dummy/>;
						dummy.appendChild(spanText); // no extraneous tags here since there is no preceding XML element sibling
						destination.appendChild(dummy.text()[0]);
					}
				}
			}
			else
			{
				//this is the simple case where we don't have a character to replace
				destination.appendChild(spanText);
			}		
		}  
		
		/** 
		 * Base functionality for exporting a Span. Exports as a FlowElement,
		 * and exports the text of the span.
		 * 
		 * @param exporter	Root object for the export
		 * @param span	Element to export
		 * @return XMLList	XML for the element
		 */
		static public function exportSpan(exporter:BaseTextLayoutExporter, span:SpanElement):XMLList
		{
			var output:XMLList = exportFlowElement(exporter, span);	
			exportSpanText(output[0], span, exporter.spanTextReplacementRegex, exporter.getSpanTextReplacementXML);
			return output;
		}
		
		static private const brRegEx:RegExp = /\u2028/;
		
		/** 
		 * Gets the regex that specifies characters in span text to be replaced with XML elements.
		 *  Note: Each match is a single character 
		 */
		protected function get spanTextReplacementRegex():RegExp
		{
			return brRegEx;
		}

		/** 
		 * Gets the xml element used to represent a character in the export format
		 */
		protected function getSpanTextReplacementXML(ch:String):XML
		{
			CONFIG::debug {assert(ch == '\u2028', "Did not recognize character to be replaced with XML"); }
			var breakXML:XML = <br/>;
			breakXML.setNamespace(flowNS);
			return breakXML;
		}
		
		/** 
		 * Base functionality for exporting a FlowGroupElement. Exports as a FlowElement,
		 * and exports the children of a element.
		 * 
		 * @param exporter	Root object for the export
		 * @param flowBlockElement	Element to export
		 * @return XMLList	XML for the element
		 */
		static public function exportFlowGroupElement(exporter:BaseTextLayoutExporter, flowBlockElement:FlowGroupElement):XMLList
		{
			var output:XMLList = exportFlowElement(exporter, flowBlockElement);
			var count:int = flowBlockElement.numChildren;
			
			// output each child
			for(var index:int; index < count; ++index)
			{
				var flowChild:IFlowElement = flowBlockElement.getChildAt(index);
				var childXML:XMLList = exporter.exportChild(flowChild);
				
				if (childXML) {
					output.appendChild(childXML);
				}
			}
			
			return output;
		}

		/** 
		 * Base functionality for exporting a IParagraphFormattedElement. Exports as a FlowGroupElement,
		 * and exports paragraph attributes.
		 * 
		 * @param exporter	Root object for the export
		 * @param flowParagraph	Element to export
		 * @return XMLList	XML for the element
		 */
		static public function exportParagraphFormattedElement(exporter:BaseTextLayoutExporter, flowParagraph:IParagraphFormattedElement):XMLList
		{
			return exporter.exportParagraphFormattedElement(flowParagraph);
		}
		
		static public function exportList(exporter:BaseTextLayoutExporter, flowParagraph:IParagraphFormattedElement):XMLList
		{
			return exporter.exportList(flowParagraph);
		}
		
		protected function exportList(flowElement:IFlowElement):XMLList
		{
			var result:XMLList = exportFlowElement(flowElement);
			var count:int = FlowGroupElement(flowElement).numChildren;
			
			// output each child
			for(var index:int; index < count; ++index)
			{
				var flowChild:IFlowElement = FlowGroupElement(flowElement).getChildAt(index);
				result.appendChild(exportChild(flowChild));
			}
			
			return result;
		}
		
		static public function exportListItem(exporter:BaseTextLayoutExporter, flowParagraph:IParagraphFormattedElement):XMLList
		{
			return exporter.exportListItem(flowParagraph);
		}
		
		protected function exportListItem(flowElement:IFlowElement):XMLList
		{
			var result:XMLList = exportFlowElement(flowElement);
			var count:int = FlowGroupElement(flowElement).numChildren;
			
			// output each child
			for(var index:int; index < count; ++index)
			{
				var flowChild:IFlowElement = FlowGroupElement(flowElement).getChildAt(index);
				result.appendChild(exportChild(flowChild));
			}
			
			return result;
		}
		
		/** 
		 * Base functionality for exporting a IContainerFormattedElement. Exports as a IParagraphFormattedElement,
		 * and exports container attributes.
		 * 
		 * @param exporter	Root object for the export
		 * @param container	Element to export
		 * @return XMLList	XML for the element
		 */
		static public function exportContainerFormattedElement(exporter:BaseTextLayoutExporter, container:IContainerFormattedElement):XMLList
		{
			return exporter.exportContainerFormattedElement(container);
		}
		
		/** 
		 * Overridable worker method for exporting a IParagraphFormattedElement. Creates the XMLList.
		 * 
		 * @param flowElement	Element to export
		 * @return XMLList	XML for the element
		 */
		protected function exportContainerFormattedElement(flowElement:IFlowElement):XMLList
		{
			return exportParagraphFormattedElement(flowElement);
		}
		
		/** 
		 * Base functionality for exporting a TableElement. Exports as a TableElement,
		 * and exports table attributes.
		 * 
		 * @param exporter	Root object for the export
		 * @param container	Element to export
		 * @return XMLList	XML for the element
		 */
		static public function exportTableElement(exporter:BaseTextLayoutExporter, table:TableElement):XMLList
		{
			return exporter.exportTableElement(table);
		}
		
		/** 
		 * Overridable worker method for exporting a TableElement. Creates the XMLList.
		 * 
		 * @param flowElement	Element to export
		 * @return XMLList	XML for the element
		 */
		protected function exportTableElement(tableElement:TableElement):XMLList
		{
			var result:XMLList = exportFlowElement(tableElement);
			var count:int = tableElement.numRows;
			
			// output each child
			for(var index:int = 0; index < count; ++index)
			{
				var flowChild:IFlowElement = tableElement.getRowAt(index);
				result.appendChild(exportChild(flowChild));
			}
			
			return result;
		}
		
		/** 
		 * Base functionality for exporting a TableRowElement. Exports as a TableRowElement,
		 * and exports table row attributes.
		 * 
		 * @param exporter	Root object for the export
		 * @param container	Element to export
		 * @return XMLList	XML for the element
		 */
		static public function exportTableRowElement(exporter:BaseTextLayoutExporter, tableRow:TableRowElement):XMLList
		{
			return exporter.exportTableRowElement(tableRow);
		}
		
		/** 
		 * Overridable worker method for exporting a TableRowElement. Creates the XMLList.
		 * 
		 * @param flowElement	Element to export
		 * @return XMLList	XML for the element
		 */
		protected function exportTableRowElement(tableRowElement:TableRowElement):XMLList
		{
			var result:XMLList = exportFlowElement(tableRowElement);
			var count:int = tableRowElement.numCells;
			
			// output each child
			for(var index:int; index < count; ++index)
			{
				var flowChild:IFlowElement = tableRowElement.getCellAt(index);
				result.appendChild(exportChild(flowChild));
			}
			
			return result;
		}
		
		/** 
		 * Base functionality for exporting a TableCellElement. Exports as a TableCellElement,
		 * and exports table cell attributes.
		 * 
		 * @param exporter	Root object for the export
		 * @param container	Element to export
		 * @return XMLList	XML for the element
		 */
		static public function exportTableCellElement(exporter:BaseTextLayoutExporter, tableCell:TableCellElement):XMLList
		{
			return exporter.exportTableCellElement(tableCell);
		}
		
		/** 
		 * Overridable worker method for exporting a TableCellElement. Creates the XMLList.
		 * 
		 * @param flowElement	Element to export
		 * @return XMLList	XML for the element
		 */
		protected function exportTableCellElement(tableCellElement:TableCellElement):XMLList
		{
			var result:XMLList = exportFlowElement(tableCellElement);
			
			return result;
		}
		
		/** 
		 * Overridable worker method for exporting a IParagraphFormattedElement. Creates the XMLList.
		 * 
		 * @param flowElement	Element to export
		 * @return XMLList	XML for the element
		 */
		protected function exportParagraphFormattedElement(flowElement:IFlowElement):XMLList
		{
			var result:XMLList = exportFlowElement(flowElement);
			var count:int = IParagraphFormattedElement(flowElement).numChildren;
			
			// output each child
			for(var index:int; index < count; ++index)
			{
				var flowChild:IFlowElement = IParagraphFormattedElement(flowElement).getChildAt(index);
				result.appendChild(exportChild(flowChild));
			}
			
			return result;
		}
		
		/** 
		 * Base functionality for exporting a TextFlow. Exports as a ContainerElement,
		 * and exports container attributes.
		 * 
		 * @param exporter	Root object for the export
		 * @param textFlow	Element to export
		 * @return XMLList	XML for the element
		 */
		static public function exportTextFlow(exporter:BaseTextLayoutExporter, textFlow:ITextFlow):XMLList
		{
			var output:XMLList = exportContainerFormattedElement(exporter, textFlow);
			
            /*
			if (exporter.config.whiteSpaceCollapse) {
				// TextLayout will use PRESERVE on output
//TODO @
				// output.@[TextLayoutFormat.whiteSpaceCollapseProperty.name] = exporter.config.whiteSpaceCollapse;
			}
			*/
            
			// TextLayout adds version information
			output.@version = TextLayoutVersion.getVersionString(TextLayoutVersion.CURRENT_VERSION);
						
			return output;
		}


		/** 
		 * Exports the object. It will find the appropriate exporter and use it to 
		 * export the object.
		 * 
		 * @param exporter	Root object for the export
		 * @param flowElement	Element to export
		 * @return XMLList	XML for the flowElement
		 */
		public function exportChild(flowElement:IFlowElement):XMLList
		{
			var className:String = getQualifiedClassName(flowElement);
			var info:FlowElementInfo = config.lookupByClass(className);
			if (info != null)
				return info.exporter(this, flowElement);
			return null;
		}
					
		/** 
		 * Helper function to export styles (core or user) in the form of xml attributes or xml children.
		 * 
		 * @param xml object to which attributes/children are added 
		 * @param sortableStyles an array of objects (xmlName,xmlVal) members that is sorted and exported.
		 */
		protected function exportStyles(xml:XMLList, sortableStyles:Array):void
		{
			// Sort the styles based on name for predictable export order
			sortableStyles.sortOn("xmlName");
			
			for each(var exportInfo:Object in sortableStyles)
            {
            	var xmlVal:Object = exportInfo.xmlVal;
				CONFIG::debug{ assert(useClipboardAnnotations || exportInfo.xmlName != ConversionConstants.MERGE_TO_NEXT_ON_PASTE, "Found paste merge attribute in exported TextFlow"); }
				/* Filter out paste attributes */
				if (!useClipboardAnnotations && exportInfo.xmlName == ConversionConstants.MERGE_TO_NEXT_ON_PASTE)
					continue;
//TODO @
            	// if (xmlVal is String)
				// 	xml.@[exportInfo.xmlName] = xmlVal; // as an attribute
				// else if (xmlVal is XMLList)
					xml.appendChild(xmlVal);			// as a child 
            }  
		}

		internal function get flowNS():Namespace
		{
			return _ns;
		}

		protected function get formatDescription():Object
		{
			return null;
		}
	}
}
