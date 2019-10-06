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
	import org.apache.royale.textLayout.TextLayoutVersion;
	import org.apache.royale.textLayout.debug.assert;
	import org.apache.royale.textLayout.elements.BreakElement;
	import org.apache.royale.textLayout.elements.DivElement;
	import org.apache.royale.textLayout.elements.ElementHelper;
	import org.apache.royale.textLayout.elements.FlowGroupElement;
	import org.apache.royale.textLayout.elements.GlobalSettings;
	import org.apache.royale.textLayout.elements.IDivElement;
	import org.apache.royale.textLayout.elements.IFlowElement;
	import org.apache.royale.textLayout.elements.IListElement;
	import org.apache.royale.textLayout.elements.IListItemElement;
	import org.apache.royale.textLayout.elements.IParagraphElement;
	import org.apache.royale.textLayout.elements.ISpanElement;
	import org.apache.royale.textLayout.elements.ITableElement;
	import org.apache.royale.textLayout.elements.InlineGraphicElement;
	import org.apache.royale.textLayout.elements.LinkElement;
	import org.apache.royale.textLayout.elements.ListElement;
	import org.apache.royale.textLayout.elements.ListItemElement;
	import org.apache.royale.textLayout.elements.SpanElement;
	import org.apache.royale.textLayout.elements.SubParagraphGroupElement;
	import org.apache.royale.textLayout.elements.TCYElement;
	import org.apache.royale.textLayout.elements.TabElement;
	import org.apache.royale.textLayout.elements.TableCellElement;
	import org.apache.royale.textLayout.elements.TableElement;
	import org.apache.royale.textLayout.elements.TableRowElement;
	import org.apache.royale.textLayout.elements.TextFlow;
	import org.apache.royale.textLayout.formats.TextLayoutFormat;
	import org.apache.royale.textLayout.property.PropertyFactory;
	import org.apache.royale.utils.ObjectMap;
	import org.apache.royale.textLayout.conversion.TLFormatImporter;
	import org.apache.royale.textLayout.conversion.SingletonAttributeImporter;
	import org.apache.royale.textLayout.conversion.CustomFormatImporter;
	import org.apache.royale.textLayout.factory.TLFFactory;
	


	/** 
	 * @private
	 * TextLayoutImporter converts from XML to TextLayout data structures and back.
	 */ 	
	public class TextLayoutImporter extends BaseTextLayoutImporter implements ITextLayoutImporter
	{
		private static var _defaultConfiguration:ImportExportConfiguration;
		
		/** Default ImportExportConfiguration to use when none specified 
		* @playerversion Flash 10
		* @playerversion AIR 1.5
	 	* @langversion 3.0 
		*/
		public static function get defaultConfiguration():ImportExportConfiguration
		{
			// The first call will force the import/export to include the standard components
			if (!_defaultConfiguration)
			{
				_defaultConfiguration = new ImportExportConfiguration();
				// elements
	 			_defaultConfiguration.addIEInfo("TextFlow", TextFlow,        BaseTextLayoutImporter.parseTextFlow,	BaseTextLayoutExporter.exportTextFlow);
				_defaultConfiguration.addIEInfo("br", BreakElement,          BaseTextLayoutImporter.parseBreak,		BaseTextLayoutExporter.exportFlowElement);
				_defaultConfiguration.addIEInfo("p", IParagraphElement,       BaseTextLayoutImporter.parsePara,		BaseTextLayoutExporter.exportParagraphFormattedElement);
				_defaultConfiguration.addIEInfo("span", SpanElement,         BaseTextLayoutImporter.parseSpan,		BaseTextLayoutExporter.exportSpan);
				_defaultConfiguration.addIEInfo("tab", TabElement,           BaseTextLayoutImporter.parseTab,		BaseTextLayoutExporter.exportFlowElement);
				_defaultConfiguration.addIEInfo("list", ListElement,  		 BaseTextLayoutImporter.parseList,		BaseTextLayoutExporter.exportList);
				_defaultConfiguration.addIEInfo("li", ListItemElement,       BaseTextLayoutImporter.parseListItem,	BaseTextLayoutExporter.exportListItem);
				_defaultConfiguration.addIEInfo("g", SubParagraphGroupElement, TextLayoutImporter.parseSPGE, 		TextLayoutExporter.exportSPGE);
				_defaultConfiguration.addIEInfo("tcy", TCYElement,           TextLayoutImporter.parseTCY, 			TextLayoutExporter.exportTCY);
				_defaultConfiguration.addIEInfo("a", LinkElement,            TextLayoutImporter.parseLink, 			TextLayoutExporter.exportLink);
	 			_defaultConfiguration.addIEInfo("div", DivElement,           TextLayoutImporter.parseDivElement, 	TextLayoutExporter.exportDiv);
				_defaultConfiguration.addIEInfo("img", InlineGraphicElement, TextLayoutImporter.parseInlineGraphic, TextLayoutExporter.exportImage);	
				_defaultConfiguration.addIEInfo("table", TableElement, 		 TextLayoutImporter.parseTable,     	TextLayoutExporter.exportTable);	
				_defaultConfiguration.addIEInfo("tr", TableRowElement, 	     TextLayoutImporter.parseTableRow,	    TextLayoutExporter.exportTableRow);	
				_defaultConfiguration.addIEInfo("th", TableCellElement, 	 TextLayoutImporter.parseTableCell,  	TextLayoutExporter.exportTableCell);	
				_defaultConfiguration.addIEInfo("td", TableCellElement, 	 TextLayoutImporter.parseTableCell,  	TextLayoutExporter.exportTableCell);	
				
				// validate the defaultTypeName values.  They are to match the TLF format export xml names
				CONFIG::debug 
				{
					for (var name:String in _defaultConfiguration.flowElementInfoList)
					{
						var info:FlowElementInfo = _defaultConfiguration.flowElementInfoList[name];
						assert(name == (new info.flowClass).defaultTypeName,"Bad defaultTypeName in "+info.flowClass);
					}
				}
				// customized link formats
				_defaultConfiguration.addIEInfo("linkNormalFormat",null,TextLayoutImporter.parseLinkNormalFormat,null);
				_defaultConfiguration.addIEInfo("linkActiveFormat",null,TextLayoutImporter.parseLinkActiveFormat,null);
				_defaultConfiguration.addIEInfo("linkHoverFormat", null,TextLayoutImporter.parseLinkHoverFormat, null);
				// list marker format
				_defaultConfiguration.addIEInfo("ListMarkerFormat",null,TextLayoutImporter.parseListMarkerFormat,null);
			}
			
			return _defaultConfiguration;
		}
		
		/** Set the default configuration back to its original value 
		* @playerversion Flash 10
		* @playerversion AIR 1.5
	 	* @langversion 3.0
	 	*/
		public static function restoreDefaults():void
		{
			_defaultConfiguration = null;
		}
				
		static private var _formatImporter:TLFormatImporter;
		static private function get formatImporter():TLFormatImporter{
			if(_formatImporter == null)
				_formatImporter = new TLFormatImporter(TextLayoutFormat,TextLayoutFormat.description);
			
			return _formatImporter;
		}
		static private var _idImporter:SingletonAttributeImporter;
		static private function get idImporter():SingletonAttributeImporter
		{
			if(_idImporter == null)
				_idImporter = new SingletonAttributeImporter("id");
			
			return _idImporter;
		}
		static private var _typeNameImporter:SingletonAttributeImporter;
		static private function get typeNameImporter():SingletonAttributeImporter
		{
			if(_typeNameImporter == null)
				_typeNameImporter = new SingletonAttributeImporter("typeName");
			
			return _typeNameImporter;
		}
		static private var _customFormatImporter:CustomFormatImporter;
		static private function get customFormatImporter():CustomFormatImporter
		{
			if(_customFormatImporter == null)
				_customFormatImporter = new CustomFormatImporter();
			
			return _customFormatImporter;
		}
		
		static private var _flowElementFormatImporters:Array;
		static private function get flowElementFormatImporters():Array
		{
			if(_flowElementFormatImporters == null)
				_flowElementFormatImporters = [ formatImporter,idImporter,typeNameImporter,customFormatImporter ];
			
			return _flowElementFormatImporters;
		}
		
		private var _imageSourceResolveFunction:Function;

		/** Constructor */
		public function TextLayoutImporter()
		{
			super(new Namespace("flow", "http://ns.adobe.com/textLayout/2008"), defaultConfiguration);
		}
		
		/** @copy ITextLayoutImporter#imageSourceResolveFunction
		 * 
		 * @playerversion Flash 10.0
		 * @playerversion AIR 2.0
		 * @langversion 3.0
		 */
		public function get imageSourceResolveFunction():Function
		{ return _imageSourceResolveFunction; }
		public function set imageSourceResolveFunction(resolver:Function):void
		{ _imageSourceResolveFunction = resolver; }
		
		
		/**  @private */
		override protected function parseContent(rootStory:XML):TextFlow
		{
			// Capture all the top-level tags of interest that can be "bound"
			// We have to do this because the attributes are applied at the point
			// of calling something like:
			// span.charAttrs = characterAttrs;
			// At one time, we just set the variable to the parameter (in the setter),
			// but now we're copying the data into a new object. This change does
			// not allow for us to parse the bindings in any order. Hence, we
			// will process the potential bindings objects first, then the
			// TextFlow objects.
			//
			// Also note the use of "..*" below. We are using this to traverse the
			// XML structure looking for particular tags and at the same time allow for
			// any namespace. So, you might see something like <flow:TextContainer> or
			// <TextContainer> and this code will capture both cases.
			
			var rootName:String = rootStory.name().localName;
			var textFlowElement:XML = rootName == "TextFlow" ? rootStory : rootStory..*::TextFlow[0];
			if (!textFlowElement)
			{
				reportError(GlobalSettings.resourceStringFunction("missingTextFlow")); 
				return null;
			}
			if (!checkNamespace(textFlowElement))
				return null;
	
			return parseTextFlow(this, textFlowElement);
		}
		
		private function parseStandardFlowElementAttributes(flowElem:IFlowElement,xmlToParse:XML,importers:Array = null):void
		{
			if (importers == null)
				importers = _flowElementFormatImporters;
			// all the standard ones have to be in importers - some check needed
			parseAttributes(xmlToParse,importers);
			
			var textFormat:TextLayoutFormat = extractTextFormatAttributesHelper(flowElem.format,formatImporter) as TextLayoutFormat;
			if (textFormat)
			{
				CONFIG::debug { assert(textFormat.getStyles() != null,"Bad TextFormat in parseStandardFlowElementAttributes"); }
				flowElem.format = textFormat;
			}

			if (idImporter.result)
				flowElem.id = idImporter.result as String;
			if (typeNameImporter.result)
				flowElem.typeName = typeNameImporter.result as String;
			if (customFormatImporter.result)
			{
				for (var styleName:String in customFormatImporter.result)
					flowElem.setStyle(styleName,customFormatImporter.result[styleName]);
			}
		}
		

		override public function createTextFlowFromXML(xmlToParse:XML, textFlow:TextFlow = null):TextFlow
		{
			// allocate the TextFlow and set the TextContainer's rootElement to it.
			var newFlow:TextFlow = null;

			if (!checkNamespace(xmlToParse))
				return newFlow;

//TODO @
			if (xmlToParse.hasOwnProperty("@version"))
			{
				var version:String = xmlToParse.@version;
				if (version == "3.0.0")
					_importVersion = TextLayoutVersion.VERSION_3_0;
				else if (version == "2.0.0")
					_importVersion = TextLayoutVersion.VERSION_2_0;
				else if (version == "1.1.0" || version == "1.0.0")
					_importVersion = TextLayoutVersion.VERSION_1_0;
				else
				{
					reportError(GlobalSettings.resourceStringFunction("unsupportedVersion",[ xmlToParse.@version ]));
					_importVersion = TextLayoutVersion.CURRENT_VERSION;
				}
			}
			else		// we must be the first version
				_importVersion = TextLayoutVersion.VERSION_1_0;
				
			// allocate the TextFlow and initialize the container attributes
			if (!newFlow)
				newFlow = new TextFlow(TLFFactory.defaultTLFFactory);
	
			// parse formatting
			parseStandardFlowElementAttributes(newFlow,xmlToParse);
			
			// descend into children
			parseFlowGroupElementChildren(xmlToParse, newFlow);
			
			CONFIG::debug { newFlow.debugCheckNormalizeAll() ; }
			newFlow.normalize();
			
			newFlow.applyWhiteSpaceCollapse(null);
			
			return newFlow;
		}
		
		public function createDivFromXML(xmlToParse:XML):IDivElement
		{
			// add the div element to the parent
			var divElem:IDivElement = new DivElement();
			
			parseStandardFlowElementAttributes(divElem,xmlToParse);

			return divElem;
		}
		
		/**
		 * Create a table element from XML
		 **/
		public function createTableFromXML(xmlToParse:XML):ITableElement
		{
			// add the table element to the parent
			var tableElement:TableElement = new TableElement();
			
			parseStandardFlowElementAttributes(tableElement, xmlToParse);

			return tableElement;
		}
		
		/**
		 * Create a table row element from XML
		 **/
		public function createTableRowFromXML(xmlToParse:XML):TableRowElement
		{
			// add the table row element to the parent
			var tableRowElement:TableRowElement = new TableRowElement();
			
			parseStandardFlowElementAttributes(tableRowElement, xmlToParse);
			
			return tableRowElement;
		}
		
		/**
		 * Create a table cell element from XML
		 **/
		public function createTableCellFromXML(xmlToParse:XML):TableCellElement
		{
			// add the table cell element to the parent
			var tableCellElement:TableCellElement = new TableCellElement();
			
			parseStandardFlowElementAttributes(tableCellElement, xmlToParse);
			
			return tableCellElement;
		}
		
		/**
		 * Create a paragraph element from XML
		 **/
		public override function createParagraphFromXML(xmlToParse:XML):IParagraphElement
		{
			var paraElem:IParagraphElement = ElementHelper.getParagraph();
			parseStandardFlowElementAttributes(paraElem,xmlToParse);
			return paraElem;
		}
		
		/**
		 * Create a sub paragraph group element from XML
		 **/
		public function createSubParagraphGroupFromXML(xmlToParse:XML):SubParagraphGroupElement
		{
			var elem:SubParagraphGroupElement = new SubParagraphGroupElement();
			parseStandardFlowElementAttributes(elem,xmlToParse);
			return elem;
		}
		
		/**
		 * Create a tate chu yoko element from XML
		 **/
		public function createTCYFromXML(xmlToParse:XML):TCYElement
		{
			var tcyElem:TCYElement = new TCYElement();
			parseStandardFlowElementAttributes(tcyElem,xmlToParse);
			return tcyElem;
		}
		
		
		// static internal const _linkDescription:Object = {
		// 	"href" : PropertyFactory.string("href",null, false, null),
		// 	"target" : PropertyFactory.string("target",null, false, null)
		// };
		static private var _linkFormatImporter:TLFormatImporter;
		static private function get linkFormatImporter():TLFormatImporter
		{
			if(_linkFormatImporter == null)
			{
				_linkFormatImporter  = new TLFormatImporter(
					ObjectMap,
					{
						"href" : PropertyFactory.string("href",null, false, null),
						"target" : PropertyFactory.string("target",null, false, null)
					}
				);
			}

			return _linkFormatImporter;
		}
		static private var _linkElementFormatImporters:Array;
		static private function get linkElementFormatImporters():Array
		{
			if(_linkElementFormatImporters == null)
				_linkElementFormatImporters = [ linkFormatImporter, formatImporter,idImporter,typeNameImporter,customFormatImporter ];
			
			return _linkElementFormatImporters;
		}

		/** 
		 * Parse a LinkElement Block.
		 * 
		 * @param - importFilter:BaseTextLayoutImporter - parser object
		 * @param - xmlToParse:XML - the xml describing the Link
		 * @param - parent:FlowBlockElement - the parent of the new Link
		 * @return LinkElement - a new LinkElement and its children
		 */
		public function createLinkFromXML(xmlToParse:XML):LinkElement
		{
			var linkElem:LinkElement = new LinkElement();
			parseStandardFlowElementAttributes(linkElem,xmlToParse,linkElementFormatImporters);
			if (linkFormatImporter.result)
			{
				linkElem.href = linkFormatImporter.result["href"] as String;
				linkElem.target = linkFormatImporter.result["target"] as String;
			}

			return linkElem;
		}
		
		/**
		 * Create a span element from XML
		 **/
		public override function createSpanFromXML(xmlToParse:XML):ISpanElement
		{
			var spanElem:SpanElement = new SpanElement();
			
			parseStandardFlowElementAttributes(spanElem,xmlToParse);

			return spanElem;
		}
		
		static private var _ilgFormatImporter:TLFormatImporter;
		static private function get ilgFormatImporter():TLFormatImporter
		{
			if(_ilgFormatImporter == null)
				_ilgFormatImporter = new TLFormatImporter(
					ObjectMap,
					{
						"height":InlineGraphicElement.heightPropertyDefinition,
						"width":InlineGraphicElement.widthPropertyDefinition,
						"source": PropertyFactory.string("source", null, false, null),
						"float": PropertyFactory.string("float", null, false, null),
						"rotation": InlineGraphicElement.rotationPropertyDefinition
					}
				);
			return _ilgFormatImporter;
		}
		static private var _ilgElementFormatImporters:Array;
		static private function get ilgElementFormatImporters():Array
		{
			if(_ilgElementFormatImporters == null)
			{
				_ilgElementFormatImporters = [ ilgFormatImporter, formatImporter, idImporter, typeNameImporter, customFormatImporter ];
			}
			return _ilgElementFormatImporters;
		}

		/**
		 * Create an inline graphic from XML
		 **/
		public function createInlineGraphicFromXML(xmlToParse:XML):InlineGraphicElement
		{				
			var imgElem:InlineGraphicElement = new InlineGraphicElement();
			
			parseStandardFlowElementAttributes(imgElem,xmlToParse,ilgElementFormatImporters);
			
			if (ilgFormatImporter.result)
			{
				var source:String = ilgFormatImporter.result["source"];
				imgElem.source = _imageSourceResolveFunction != null ? _imageSourceResolveFunction(source) : source;
				
				// if not defined then let InlineGraphic set its own default
				imgElem.height = ilgFormatImporter.result["height"];
				imgElem.width  = ilgFormatImporter.result["width"];
				/*	We don't support rotation yet because of bugs in the player. */		
				// imgElem.rotation  = InlineGraphicElement.heightPropertyDefinition.setHelper(imgElem.rotation,ilgFormatImporter.result["rotation"]);
				imgElem.float = ilgFormatImporter.result["float"];
			}
			
			return imgElem;
		}
	
		/**
		 * Create a list element from XML
		 **/
		public override function createListFromXML(xmlToParse:XML):IListElement
		{
			var rslt:IListElement = ElementHelper.getList();
			parseStandardFlowElementAttributes(rslt,xmlToParse);
			return rslt;
		}

		/**
		 * Create a list item element from XML
		 **/
		public override function createListItemFromXML(xmlToParse:XML):IListItemElement
		{
			var rslt:IListItemElement = ElementHelper.getListItem();
			parseStandardFlowElementAttributes(rslt,xmlToParse);
			return rslt;
		}
		
		/**
		 * Extract text format attributes
		 **/
		public function extractTextFormatAttributesHelper(curAttrs:Object, importer:TLFormatImporter):Object
		{
			return extractAttributesHelper(curAttrs,importer);
		}
		
		/** 
		 * Parse an SPGE element
		 * 
		 * @param - importFilter:BaseTextLayoutImporter - parser object
		 * @param - xmlToParse:XML - the xml describing the TCY Block
		 * @param - parent:FlowBlockElement - the parent of the new TCY Block
		 * @return SubParagraphGroupElement - a new TCYBlockElement and its children
		 */
		static public function parseSPGE(importFilter:BaseTextLayoutImporter, xmlToParse:XML, parent:FlowGroupElement):void
		{
			var elem:SubParagraphGroupElement = TextLayoutImporter(importFilter).createSubParagraphGroupFromXML(xmlToParse);
			if (importFilter.addChild(parent, elem))
			{
				importFilter.parseFlowGroupElementChildren(xmlToParse, elem);
				//if parsing an empty tcy, create a Span for it.
				if (elem.numChildren == 0)
					elem.addChild(new SpanElement());
			}
		}

		/** 
		 * Parse a TCY Block.
		 * 
		 * @param - importFilter:BaseTextLayoutImporter - parser object
		 * @param - xmlToParse:XML - the xml describing the TCY Block
		 * @param - parent:FlowBlockElement - the parent of the new TCY Block
		 * @return TCYBlockElement - a new TCYBlockElement and its children
		 */
		static public function parseTCY(importFilter:BaseTextLayoutImporter, xmlToParse:XML, parent:FlowGroupElement):void
		{
			var tcyElem:TCYElement = TextLayoutImporter(importFilter).createTCYFromXML(xmlToParse);
			if (importFilter.addChild(parent, tcyElem))
			{
				importFilter.parseFlowGroupElementChildren(xmlToParse, tcyElem);
				//if parsing an empty tcy, create a Span for it.
				if (tcyElem.numChildren == 0)
					tcyElem.addChild(new SpanElement());
			}
		}
		
				
		/** 
		 * Parse a LinkElement Block.
		 * 
		 * @param - importFilter:BaseTextLayoutImporter - parser object
		 * @param - xmlToParse:XML - the xml describing the Link
		 * @param - parent:FlowBlockElement - the parent of the new Link
		 * @return LinkElement - a new LinkElement and its children
		 */
		static public function parseLink(importFilter:BaseTextLayoutImporter, xmlToParse:XML, parent:FlowGroupElement):void
		{
			var linkElem:LinkElement = TextLayoutImporter(importFilter).createLinkFromXML(xmlToParse);
			if (importFilter.addChild(parent, linkElem))
			{
				importFilter.parseFlowGroupElementChildren(xmlToParse, linkElem);
				//if parsing an empty link, create a Span for it.
				if (linkElem.numChildren == 0)
					linkElem.addChild(new SpanElement());
			}
		}
		
		public function createDictionaryFromXML(xmlToParse:XML):ObjectMap
		{
			var formatImporters:Array = [ customFormatImporter ];

			// parse the TextLayoutFormat child object		
			var formatList:XMLList = xmlToParse..*::TextLayoutFormat;
			if (formatList.length() != 1)
				reportError(GlobalSettings.resourceStringFunction("expectedExactlyOneTextLayoutFormat",[ xmlToParse.name() ]));
			
			var parseThis:XML = formatList.length() > 0 ? formatList[0] : xmlToParse;
			parseAttributes(parseThis,formatImporters);
			return customFormatImporter.result as ObjectMap;
		}

		static public function parseLinkNormalFormat(importFilter:BaseTextLayoutImporter, xmlToParse:XML, parent:FlowGroupElement):void
		{ parent.linkNormalFormat = TextLayoutImporter(importFilter).createDictionaryFromXML(xmlToParse); }
		static public function parseLinkActiveFormat(importFilter:BaseTextLayoutImporter, xmlToParse:XML, parent:FlowGroupElement):void
		{ parent.linkActiveFormat = TextLayoutImporter(importFilter).createDictionaryFromXML(xmlToParse); }
		static public function parseLinkHoverFormat(importFilter:BaseTextLayoutImporter, xmlToParse:XML, parent:FlowGroupElement):void
		{ parent.linkHoverFormat = TextLayoutImporter(importFilter).createDictionaryFromXML(xmlToParse); }
		
		public function createListMarkerFormatDictionaryFromXML(xmlToParse:XML):ObjectMap
		{
			var formatImporters:Array = [ customFormatImporter ];
			
			// parse the TextLayoutFormat child object		
			var formatList:XMLList = xmlToParse..*::ListMarkerFormat;
			if (formatList.length() != 1)
				reportError(GlobalSettings.resourceStringFunction("expectedExactlyOneListMarkerFormat",[ xmlToParse.name() ]));
			
			var parseThis:XML = formatList.length() > 0 ? formatList[0] : xmlToParse;
			parseAttributes(parseThis,formatImporters);
			return customFormatImporter.result as ObjectMap;
		}
		
		static public function parseListMarkerFormat(importFilter:BaseTextLayoutImporter, xmlToParse:XML, parent:FlowGroupElement):void
		{ parent.listMarkerFormat = TextLayoutImporter(importFilter).createListMarkerFormatDictionaryFromXML(xmlToParse); }

		/** 
		 * Parse the <div ...> tag and all its children
		 * 
		 * @param - importFilter:BaseTextLayoutImportFilter - parser object
		 * @param - xmlToParse:XML - the xml describing the Div
		 * @param - parent:FlowBlockElement - the parent of the new Div
		 */
		static public function parseDivElement(importFilter:BaseTextLayoutImporter, xmlToParse:XML, parent:FlowGroupElement):void
		{
			var divElem:IDivElement = TextLayoutImporter(importFilter).createDivFromXML(xmlToParse);
			if (importFilter.addChild(parent, divElem))
			{
				importFilter.parseFlowGroupElementChildren(xmlToParse, divElem);
				// we can't have a <div> tag w/no children... so, add an empty paragraph
				if (divElem.numChildren == 0)
					divElem.addChild(ElementHelper.getParagraph());
			}
		}

		/** 
		 * Parse a leaf element, the <img ...>  tag.
		 * 
		 * @param - importFilter:BaseTextLayoutImporter - parser object
		 * @param - xmlToParse:XML - the xml describing the InlineGraphic FlowElement
		 * @param - parent:FlowBlockElement - the parent of the new image FlowElement
		 */
		static public function parseInlineGraphic(importFilter:BaseTextLayoutImporter, xmlToParse:XML, parent:FlowGroupElement):void
		{
			var ilg:InlineGraphicElement = TextLayoutImporter(importFilter).createInlineGraphicFromXML(xmlToParse);
			importFilter.addChild(parent, ilg);
		}
		
		/** 
		 * Parse the <table ...> tag and all its children
		 * 
		 * @param - importFilter:BaseTextLayoutImportFilter - parser object
		 * @param - xmlToParse:XML - the xml describing the Table
		 * @param - parent:FlowBlockElement - the parent of the new Table
		 */
		static public function parseTable(importFilter:BaseTextLayoutImporter, xmlToParse:XML, parent:FlowGroupElement):void
		{
			var tableElement:ITableElement = TextLayoutImporter(importFilter).createTableFromXML(xmlToParse);
			
			if (importFilter.addChild(parent, tableElement)) 
			{
				importFilter.parseFlowGroupElementChildren(xmlToParse, tableElement);
				
			}
		}
		
		/** 
		 * Parse the <tr ...> tag (TableRowElement) and all its children
		 * 
		 * @param - importFilter:BaseTextLayoutImportFilter - parser object
		 * @param - xmlToParse:XML - the xml describing the Table
		 * @param - parent:FlowBlockElement - the parent of the new Table
		 */
		static public function parseTableRow(importFilter:BaseTextLayoutImporter, xmlToParse:XML, parent:FlowGroupElement):void
		{
			var tableRowElement:TableRowElement = TextLayoutImporter(importFilter).createTableRowFromXML(xmlToParse);
			var table:ITableElement;
			
			if (importFilter.addChild(parent, tableRowElement))
			{
				
				importFilter.parseFlowGroupElementChildren(xmlToParse, tableRowElement);
				
				table = tableRowElement.table;
				
				var columnCount:int = tableRowElement.getColumnCount();
				
				if (table.numColumns<columnCount) {
					table.numColumns = columnCount;
				}
				
				table.insertRow(tableRowElement, tableRowElement.mxmlChildren);
				
			}
		}
		
		/** 
		 * Parse the <td ...> or <th ...> tag (TableCellElement) and all its children
		 * 
		 * @param - importFilter:BaseTextLayoutImportFilter - parser object
		 * @param - xmlToParse:XML - the xml describing the Table
		 * @param - parent:FlowBlockElement - the parent of the new Table
		 */
		static public function parseTableCell(importFilter:BaseTextLayoutImporter, xmlToParse:XML, parent:FlowGroupElement):void
		{
			var tableCellElement:TableCellElement = TextLayoutImporter(importFilter).createTableCellFromXML(xmlToParse);
			
			if (importFilter.addChild(parent, tableCellElement))
			{
				importFilter.parseTableCellElementChildren(xmlToParse, tableCellElement);
			}
			
			//tableCellElement.textFlow = getTextFlowContent("test cell");
			
			TableRowElement(parent).addCell(tableCellElement);
			//TableRowElement(parent).getTable().addChild(tableCellElement);
			//importFilter.parseFlowGroupElementChildren(xmlToParse, tableCellElement);
			
			// we can't have a <td> tag w/no children... so, add an empty text flow
			//if (tableCellElement.numChildren == 0) {
			//	tableCellElement.addChild(new TextFlow());
			//}
				
		}
		
		/**
		 * Creates default text flow from the text value passed in. Used for table cell text flows. 
		 * Used for testing. May be removed in the future. 
		 **/
		static public function getTextFlowContent(text:String = null, selectable:Boolean = false, editable:Boolean = false):TextFlow {
			var textFlowContent:TextFlow = new TextFlow(TLFFactory.defaultTLFFactory);
			var paragraph:IParagraphElement = ElementHelper.getParagraph();
			var span:SpanElement = new SpanElement();
			
			if (text) {
				span.text = text;
			}
			else {
				span.text = "";
			}
			
			paragraph.backgroundAlpha = 0.2;
			paragraph.backgroundColor = 0xFF0000;
			paragraph.addChild(span);
			
            /*
			if (editable) {
				//textFlowContent.interactionManager = new EditManager(new UndoManager);
			}
			else if (selectable) {
				//textFlowContent.interactionManager = new SelectionManager();
			}
			*/
            
			textFlowContent.addChild(paragraph);
			
			return textFlowContent;
		}
	}
}

