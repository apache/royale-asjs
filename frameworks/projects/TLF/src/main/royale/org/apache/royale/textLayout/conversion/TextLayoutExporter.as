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
	import org.apache.royale.textLayout.debug.assert;
	import org.apache.royale.textLayout.elements.IDivElement;
	import org.apache.royale.textLayout.elements.IFlowElement;
	import org.apache.royale.textLayout.elements.InlineGraphicElement;
	import org.apache.royale.textLayout.elements.LinkElement;
	import org.apache.royale.textLayout.elements.ListElement;
	import org.apache.royale.textLayout.elements.SubParagraphGroupElement;
	import org.apache.royale.textLayout.elements.TCYElement;
	import org.apache.royale.textLayout.elements.TableCellElement;
	import org.apache.royale.textLayout.elements.TableElement;
	import org.apache.royale.textLayout.elements.TableRowElement;
	import org.apache.royale.textLayout.formats.FormatValue;
	import org.apache.royale.textLayout.formats.ListMarkerFormat;
	import org.apache.royale.textLayout.formats.TextLayoutFormat;
	import org.apache.royale.textLayout.property.Property;
	

	
	/** 
	 * Export filter for TextLayout format. 
	 */
	internal class TextLayoutExporter extends BaseTextLayoutExporter
	{	
		static private var _formatDescription_:Object;
		static private function get _formatDescription():Object
		{
			if(_formatDescription_ == null)
			{
				_formatDescription_ = TextLayoutFormat.description;
			}
			return _formatDescription_;
		}

		public function TextLayoutExporter()
		{
			super(new Namespace("http://ns.adobe.com/textLayout/2008"), null, TextLayoutImporter.defaultConfiguration);
		}
		
		static private const brTabRegEx:RegExp = new RegExp("[" + "\u2028" + "\t" + "]"); // Doesn't /\u2028\t/ work?
		
		/** Gets the regex that specifies characters to be replaced with XML elements
		 *  Note: Each match is a single character 
		 */
		protected override function get spanTextReplacementRegex():RegExp
		{
			return brTabRegEx;
		}
		
		/** Gets the xml element used to represent a character in the export format
		 */
		protected override function getSpanTextReplacementXML(ch:String):XML
		{
			var replacementXML:XML;
			if (ch == '\u2028')
				replacementXML = <br/>;
			else if (ch == '\t')
				replacementXML = <tab/>;
			else
			{
				CONFIG::debug {assert(false, "Did not recognize character to be replaced with XML"); }
				return null;			
			}
		
			replacementXML.setNamespace(flowNS);
			return replacementXML;	
		}
		
		/** 
		 * Helper function to export styles (core or user) in the form of xml attributes or xml children
		 * 
		 */
		public function createStylesFromDescription(styles:Object, description:Object, includeUserStyles:Boolean, exclusions:Array):Array
		{
			var sortableStyles:Array = [];
			for (var key:String in styles)
			{
				var val:Object = styles[key];
				if (exclusions && exclusions.indexOf(val) != -1)
					continue;
				
				var prop:Property = description[key];
				if (!prop)
				{
					if (includeUserStyles)
					{
						// User style
						if ((val is String) || val.hasOwnProperty("toString"))
						{
							// Is or can be converted to a String which will be used as an XML attribute value
							sortableStyles.push({xmlName:key, xmlVal:val});
						}						
					}
				}
				else if (val is TextLayoutFormat)
				{
					// A style dictionary; Will be converted to an XMLList containing elements to be added as children 
					var customDictProp:XMLList = exportObjectAsTextLayoutFormat(key,(val as TextLayoutFormat).getStyles());
					if (customDictProp)
						sortableStyles.push({xmlName:key, xmlVal:customDictProp});
				}
				else
					sortableStyles.push({xmlName:key, xmlVal:prop.toXMLString(val)});		
			}
			return sortableStyles;  
		}
		
		public function exportObjectAsTextLayoutFormat(key:String,styleDict:Object):XMLList
		{
			// link attributes and ListMarkerFormat
			var elementName:String;
			var description:Object;
			if (key == "linkNormalFormat" || key == "linkActiveFormat" || key == "linkHoverFormat")
			{
				elementName = "TextLayoutFormat";
				description = TextLayoutFormat.description;
			}
			else if (key == "ListMarkerFormat")
			{
				elementName = "ListMarkerFormat";
				description = ListMarkerFormat.description;
			}
			
			if (elementName == null)
				return null;
				
			// create the  element
			var formatXML:XML = <{elementName}/>;
			formatXML.setNamespace(flowNS);
			var sortableStyles:Array = createStylesFromDescription(styleDict, description, true, null);
			exportStyles(XMLList(formatXML), sortableStyles);
			
			// create the link format element
			var propertyXML:XMLList = XMLList(<{key}/>);
			propertyXML.appendChild(formatXML);
			return propertyXML;
		}
			
		protected override function exportFlowElement(flowElement:IFlowElement):XMLList
		{
			var rslt:XMLList = super.exportFlowElement(flowElement);
			
			var allStyles:Object = flowElement.styles;
			if (allStyles)
			{
				// WhiteSpaceCollapse attribute should never be exported (except on TextFlow -- handled separately)
				delete allStyles[TextLayoutFormat.whiteSpaceCollapseProperty.name];
				// To prevent "inherit" from getting exported for the root node, comment in the following line, and remove the one after that (only need one call to exportStyles
				var sortableStyles:Array = createStylesFromDescription(allStyles,formatDescription,true,flowElement.parent ? null : [FormatValue.INHERIT]);
				exportStyles(rslt, sortableStyles );
			}
			
			// export id and typeName
			if (flowElement.id != null)
				rslt.@id = flowElement.id;
			if (flowElement.typeName != flowElement.defaultTypeName)
				rslt.@typeName = flowElement.typeName;
				
			return rslt;
		}

		/** 
		 * Base functionality for exporting an Image. Exports as a FlowElement,
		 * and exports image properties.
		 * 
		 * @param exporter	Root object for the export
		 * @param image	Element to export
		 * @return XMLList	XML for the element
		 */
		static public function exportImage(exporter:BaseTextLayoutExporter, image:InlineGraphicElement):XMLList
		{
			var output:XMLList = exportFlowElement(exporter, image);
			
			// output the img specific values
			if (image.height !== undefined)
				output.@height = image.height;
			if (image.width !== undefined)
				output.@width = image.width;
		//	output.@rotation = image.rotation;  don't support rotation yet
			if (image.source != null)
				output.@source = image.source;
			if (image.float != undefined)
				output.@float = image.float;
						
			return output;
		}

		/** 
		 * Base functionality for exporting a LinkElement. Exports as a FlowGroupElement,
		 * and exports link properties.
		 * 
		 * @param exporter	Root object for the export
		 * @param link	Element to export
		 * @return XMLList	XML for the element
		 */
		static public function exportLink(exporter:BaseTextLayoutExporter, link:LinkElement):XMLList
		{
			var output:XMLList = exportFlowGroupElement(exporter, link);

			if (link.href)
				output.@href= link.href;
				
			if (link.target)
				output.@target = link.target;
				
			return output;
		}
		
		/** 
		 * Base functionality for exporting a IDivElement. Exports as a FlowContainerFormattedElement
		 * 
		 * @param exporter	Root object for the export
		 * @param div	Element to export
		 * @return XMLList	XML for the element
		 */
		static public function exportDiv(exporter:BaseTextLayoutExporter, div:IDivElement):XMLList
		{
			return exportContainerFormattedElement(exporter, div);
		}
		
		/** 
		 * Base functionality for exporting a SubParagraphGroupElement. Exports as a FlowGroupElement
		 * 
		 * @param exporter	Root object for the export
		 * @param elem	Element to export
		 * @return XMLList	XML for the element
		 */
		static public function exportSPGE(exporter:BaseTextLayoutExporter, elem:SubParagraphGroupElement):XMLList
		{
			return exportFlowGroupElement(exporter, elem);
		}
		/** 
		 * Base functionality for exporting a TCYElement. Exports as a FlowGroupElement
		 * 
		 * @param exporter	Root object for the export
		 * @param tcy	Element to export
		 * @return XMLList	XML for the element
		 */
		static public function exportTCY(exporter:BaseTextLayoutExporter, tcy:TCYElement):XMLList
		{
			return exportFlowGroupElement(exporter, tcy);
		}
		
		/** 
		 * Base functionality for exporting a TableElement. 
		 * 
		 * @param exporter	Root object for the export
		 * @param table	Element to export
		 * @return XMLList	XML for the element
		 */
		static public function exportTable(exporter:BaseTextLayoutExporter, table:TableElement):XMLList
		{
			return exportTableElement(exporter, table);
		}
		
		/** 
		 * Base functionality for exporting a TableRowElement. 
		 * 
		 * @param exporter	Root object for the export
		 * @param table	Element to export
		 * @return XMLList	XML for the element
		 */
		static public function exportTableRow(exporter:BaseTextLayoutExporter, tableRow:TableRowElement):XMLList
		{
			return exportTableRowElement(exporter, tableRow);
		}
		
		/** 
		 * Base functionality for exporting a TableCellElement. 
		 * 
		 * @param exporter	Root object for the export
		 * @param table	Element to export
		 * @return XMLList	XML for the element
		 */
		static public function exportTableCell(exporter:BaseTextLayoutExporter, tableCell:TableCellElement):XMLList
		{
			return exportTableCellElement(exporter, tableCell);
		}
		
		override protected function get formatDescription():Object
		{
			return _formatDescription;
		}		

	}
}
