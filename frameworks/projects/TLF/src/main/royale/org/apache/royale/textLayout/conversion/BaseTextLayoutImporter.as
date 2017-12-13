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
	import org.apache.royale.textLayout.elements.ElementHelper;
	import org.apache.royale.textLayout.elements.FlowGroupElement;
	import org.apache.royale.textLayout.elements.GlobalSettings;
	import org.apache.royale.textLayout.elements.IConfiguration;
	import org.apache.royale.textLayout.elements.IContainerFormattedElement;
	import org.apache.royale.textLayout.elements.IFlowElement;
	import org.apache.royale.textLayout.elements.IFlowGroupElement;
	import org.apache.royale.textLayout.elements.IFlowLeafElement;
	import org.apache.royale.textLayout.elements.IListElement;
	import org.apache.royale.textLayout.elements.IListItemElement;
	import org.apache.royale.textLayout.elements.IParagraphElement;
	import org.apache.royale.textLayout.elements.IParagraphFormattedElement;
	import org.apache.royale.textLayout.elements.ISpanElement;
	import org.apache.royale.textLayout.elements.ITextFlow;
	import org.apache.royale.textLayout.elements.SpanElement;
	import org.apache.royale.textLayout.elements.TabElement;
	import org.apache.royale.textLayout.elements.TableCellElement;
	import org.apache.royale.textLayout.elements.TextFlow;
	import org.apache.royale.textLayout.property.Property;
	import org.apache.royale.textLayout.property.PropertyUtil;
	import org.apache.royale.textLayout.factory.TLFFactory;

	/**
	 * BaseTextLayoutImporter is a base class for handling the import/export of TextLayout text 
	 * in the native format.
	 */
	internal class BaseTextLayoutImporter extends ConverterBase implements ITextImporter
	{
		private var _ns:Namespace;		// namespace of expected in imported/exported content
		private var _textFlowNamespace:Namespace; // namespace of the TextFlow element against which the namespaces of the following elements are validated
		protected var _config:ImportExportConfiguration;
		protected var _textFlowConfiguration:IConfiguration = null;
		protected var _importVersion:uint;
		// static private const anyPrintChar:RegExp = /[^\s]/g;
		// Consider only tab, line feed, carriage return, and space as characters used for pretty-printing.
		// While debatable, this is consistent with what CSS does.
		static private const anyPrintChar:RegExp = /[^\u0009\u000a\u000d\u0020]/g;
		public function BaseTextLayoutImporter(nsValue:Namespace, config:ImportExportConfiguration)
		{
			_ns = nsValue;
			_config = config;
		}

		public override function clear():void
		{
			super.clear();
			_textFlowNamespace = null;
			_impliedPara = null;
		}

		/** @copy ITextImporter#importToFlow()
		 */
		public function importToFlow(source:Object):ITextFlow
		{
			clear();		// empty results of previous imports

			if (throwOnError)
				return importToFlowCanThrow(source);

			var rslt:TextFlow = null;
			var savedErrorHandler:Function = PropertyUtil.errorHandler;
			try
			{
				PropertyUtil.errorHandler = importPropertyErrorHandler;
				rslt = importToFlowCanThrow(source);
			}
			catch (e:Error)
			{
				reportError(e.toString());
			}
			PropertyUtil.errorHandler = savedErrorHandler;
			return rslt;
		}

		/** @copy ITextImporter#get configuration()
		 */
		public function get configuration():IConfiguration
		{
			return _textFlowConfiguration;
		}

		public function set configuration(value:IConfiguration):void
		{
			_textFlowConfiguration = value;
		}

		/** @private */
		protected function importPropertyErrorHandler(p:Property, value:Object):void
		{
			reportError(PropertyUtil.createErrorString(p, value));
		}

		private function importToFlowCanThrow(source:Object):TextFlow
		{
			if (source is String)
				return importFromString(String(source));
			else if (source is XML)
				return importFromXML(XML(source));
			return null;
		}

		/** Parse and convert input data.
		 * 
		 * @param source - a string which is in XFL format. String is applied to an XML object then passed
		 * to importFromXML to be processed.  The source must be capable of being cast as an XML
		 * object (E4X). 
		 */
		protected function importFromString(source:String):TextFlow
		{
			var originalSettings:Object = XML.settings();
			try
			{
				XML.ignoreProcessingInstructions = false;
				XML.ignoreWhitespace = false;
				var xmlTree:XML = new XML(source);
			}
			finally
			{
				XML.setSettings(originalSettings);
			}

			var textFlow:TextFlow = importFromXML(xmlTree);
			// TODO probably does not make sense for Royale
			// if (Configuration.playerEnablesArgoFeatures)
			// System["disposeXML"](xmlTree);
			return textFlow;
		}

		/** Parse and convert input data.
		 * 
		 * xflSource is a XFL formated object which must be capable of being cast as an XML
		 * object (E4X). 
		 */
		protected function importFromXML(xmlSource:XML):TextFlow
		// Parse an XFL hierarchy into a TextFlow, using the geometry supplied by a TextFrame
		// to host child containers (e.g. tables). This is the main entry point into this class.
		{
			return parseContent(xmlSource[0]);
		}

		// This routine imports a TextFlow
		protected function parseContent(rootStory:XML):TextFlow
		{
			// If the root element isn't a textFlow we know how to parse, keep descending the hierarchy.
			var child:XML = rootStory..*::TextFlow[0];
			if (child)
				return parseTextFlow(this, rootStory);
			return null;
		}

		/** Returns the namespace used in for writing XML/XFL
		 * 
		 * @return the Namespace being used.
		 */
		public function get ns():Namespace
		{
			return _ns;
		}

		// Remove double spaces, tabs, and newlines.
		// If I have a sequence of different sorts of spaces (e.g., en quad, hair space), would I want them converted down to one space? Probably not.
		// For now, u0020 is the only space character we consider for eliminating duplicates, though u00A0 (non-breaking space) is potentially eligible.
		static private const dblSpacePattern:RegExp = /[\u0020]{2,}/g;
		// Tab, line feed, and carriage return
		static private const tabNewLinePattern:RegExp = /[\u0009\u000a\u000d]/g;
		protected static function stripWhitespace(insertString:String):String
		{
			// Replace the newlines and tabs inside the element with spaces.
			return insertString.replace(tabNewLinePattern, " ");
		}

		/** Parse XML and convert to  TextFlow. 
		 * @param importer		parser object
		 * @param xmlToParse	content to parse
		 * @param parent always null - this parameter is only provided to match FlowElementInfo.importer signature
		 * @return TextFlow	the new TextFlow created as a result of the parse
		 */
		static public function parseTextFlow(importer:BaseTextLayoutImporter, xmlToParse:XML, parent:Object = null):TextFlow
		{
			return importer.createTextFlowFromXML(xmlToParse, null);
		}

		/** 
		 * Static method to parse the supplied XML into a paragrph. 
		 * Parse the <p ...> tag and it's children.
		 * 
		 * @param importer	parser object
		 * @param xmlToParse	content to parse
		 * @param parent 		the parent for the new content
		 */
		static public function parsePara(importer:BaseTextLayoutImporter, xmlToParse:XML, parent:FlowGroupElement):void
		{
			var paraElem:IParagraphElement = importer.createParagraphFromXML(xmlToParse);
			if (importer.addChild(parent, paraElem))
			{
				importer.parseFlowGroupElementChildren(xmlToParse, paraElem);
				// if parsing an empty paragraph, create a Span for it.
				if (paraElem.numChildren == 0)
					paraElem.addChild(new SpanElement());
			}
		}

		static protected function copyAllStyleProps(dst:IFlowLeafElement, src:IFlowLeafElement):void
		{
			dst.format = src.format;
			dst.typeName = src.typeName;
			dst.id = src.id;
		}

		/** 
		 * Static method for constructing a span from XML. Parse the <span> ... </span> tag. 
		 * Insert the span into its parent
		 * 
		 * @param importer	parser object
		 * @param xmlToParse	content to parse
		 * @param parent 		the parent for the new content
		 */
		static public function parseSpan(importer:BaseTextLayoutImporter, xmlToParse:XML, parent:IFlowGroupElement):void
		{
			var firstSpan:ISpanElement = importer.createSpanFromXML(xmlToParse);

			var elemList:XMLList = xmlToParse[0].children();
			if (elemList.length() == 0)
			{
				// Empty span, but may have formatting, so don't strip it out.
				// Note: the normalizer may yet strip it out if it is not the last child, but that's the normalizer's business.
				importer.addChild(parent, firstSpan);
				return;
			}

			for each (var child:XML in elemList)
			{
				var elemName:String = child.name() ? child.name().localName : null;

				if (elemName == null) // span text
				{
					if (firstSpan.parent == null)	// hasn't been used yet
					{
						firstSpan.text = child.toString();
						importer.addChild(parent, firstSpan);
					}
					else
					{
						var s:SpanElement = new SpanElement();	// No PMD
						copyAllStyleProps(s, firstSpan);
						s.text = child.toString();
						importer.addChild(parent, s);
					}
				}
				else if (elemName == "br")
				{
					var brElem:BreakElement = importer.createBreakFromXML(child);	// may be null
					if (brElem)
					{
						copyAllStyleProps(brElem, firstSpan);
						importer.addChild(parent, brElem);
					}
					else
						importer.reportError(GlobalSettings.resourceStringFunction("unexpectedXMLElementInSpan", [elemName]));
				}
				else if (elemName == "tab")
				{
					var tabElem:TabElement = importer.createTabFromXML(child);	// may be null
					if (tabElem)
					{
						copyAllStyleProps(tabElem, firstSpan);
						importer.addChild(parent, tabElem);
					}
					else
						importer.reportError(GlobalSettings.resourceStringFunction("unexpectedXMLElementInSpan", [elemName]));
				}
				else
					importer.reportError(GlobalSettings.resourceStringFunction("unexpectedXMLElementInSpan", [elemName]));
			}
		}

		/** 
		 * Static method for constructing a break element from XML. Validate the <br> ... </br> tag. 
		 * Use "\u2028" as the text; Insert the new element into its parent 
		 * 
		 * @param importer	parser object
		 * @param xmlToParse	content to parse
		 * @param parent 		the parent for the new content
		 */
		static public function parseBreak(importer:BaseTextLayoutImporter, xmlToParse:XML, parent:IFlowGroupElement):void
		{
			var breakElem:BreakElement = importer.createBreakFromXML(xmlToParse);
			importer.addChild(parent, breakElem);
		}

		/** 
		 * Static method for constructing a tab element from XML. Validate the <tab> ... </tab> tag. 
		 * Use "\t" as the text; Insert the new element into its parent 
		 * 
		 * @param importer	parser object
		 * @param xmlToParse	content to parse
		 * @param parent 		the parent for the new content
		 */
		static public function parseTab(importer:BaseTextLayoutImporter, xmlToParse:XML, parent:IFlowGroupElement):void
		{
			var tabElem:TabElement = importer.createTabFromXML(xmlToParse);	// may be null
			if (tabElem)
				importer.addChild(parent, tabElem);
		}

		/** 
		 * Static method for constructing a list element from XML. 
		 * 
		 * @param importer	parser object
		 * @param xmlToParse	content to parse
		 * @param parent 		the parent for the new content
		 */
		static public function parseList(importer:BaseTextLayoutImporter, xmlToParse:XML, parent:IFlowGroupElement):void
		{
			var listElem:IListElement = importer.createListFromXML(xmlToParse);
			if (importer.addChild(parent, listElem))
			{
				importer.parseFlowGroupElementChildren(xmlToParse, listElem);
			}
		}

		/** 
		 * Static method for constructing a list item from XML. 
		 * 
		 * @param importer	parser object
		 * @param xmlToParse	content to parse
		 * @param parent 		the parent for the new content
		 */
		static public function parseListItem(importer:BaseTextLayoutImporter, xmlToParse:XML, parent:IFlowGroupElement):void
		{
			var listItem:IListItemElement = importer.createListItemFromXML(xmlToParse);
			if (importer.addChild(parent, listItem))
			{
				importer.parseFlowGroupElementChildren(xmlToParse, listItem);
				// if parsing an empty list item, create a Paragraph for it.
				if (listItem.numChildren == 0)
					listItem.addChild(ElementHelper.getParagraph());
			}
		}

		protected function checkNamespace(xmlToParse:XML):Boolean
		{
			var elementNS:Namespace = xmlToParse.namespace();
			if (!_textFlowNamespace) // Not set yet; must be parsing the TextFlow element
			{
				// TextFlow element: allow only empty namespace and flow namespace
				if (elementNS != ns)
				{
					reportError(GlobalSettings.resourceStringFunction("unexpectedNamespace", [elementNS.toString()]));
					return false;
				}
				_textFlowNamespace = elementNS;
			}
			// Other elements: must match the namespace of the TextFlow element
			// Specifically, can't be empty unless the TextFlow element's namespace is also empty
			else if (elementNS != _textFlowNamespace)
			{
				reportError(GlobalSettings.resourceStringFunction("unexpectedNamespace", [elementNS.toString()]));
				return false;
			}

			return true;
		}

		public function parseAttributes(xmlToParse:XML, formatImporters:Array):void
		{
			var importer:IFormatImporter;
			// reset them all
			for each (importer in formatImporters)
				importer.reset();

			if (!xmlToParse)
				return;

			for each (var item:XML in xmlToParse.attributes())
			{
				var propertyName:String = item.name().localName;
				var propertyValue:String = item.toString();
				var imported:Boolean = false;

				// Strip out padding properties from XML coming in before TLF 2.0, since they were ignored but are no longer. This preserves the look of the text.
				if (xmlToParse.localName() == "TextFlow")
				{
					if (propertyName == "version")	// skip over the version attribute, we've already processed it
						continue;
				}
				else if (_importVersion < TextLayoutVersion.VERSION_2_0 && (propertyName == "paddingLeft" || propertyName == "paddingTop" || propertyName == "paddingRight" || propertyName == "paddingBottom"))
					continue;
				for each (importer in formatImporters)
				{
					if (importer.importOneFormat(propertyName, propertyValue))
					{
						imported = true;
						break;
					}
				}
				if (!imported)	// not a supported attribute
					handleUnknownAttribute(xmlToParse.name().localName, propertyName);
			}
		}

		static protected function extractAttributesHelper(curAttrs:Object, importer:TLFormatImporter):Object
		{
			if (curAttrs == null)
				return importer.result;

			if (importer.result == null)
				return curAttrs;

			var workAttrs:Object = new importer.classType(curAttrs);
			workAttrs.apply(importer.result);
			return workAttrs;
		}

		/** 
		 * Parse XML and convert to  TextFlow.
		 * 
		 * @param xmlToParse	content to parse
		 * @param textFlow 		TextFlow we're parsing. If null, create or find a new TextFlow based on XML content
		 * @return TextFlow	the new TextFlow created as a result of the parse
		 */
		public function createTextFlowFromXML(xmlToParse:XML, newFlow:TextFlow = null):TextFlow	// No PMD
		{
			CONFIG::debug
			{
				assert(false, "missing override for createTextFlowFromXML"); }
			return null;
		}

		public function createParagraphFromXML(xmlToParse:XML):IParagraphElement	// No PMD
		{
			CONFIG::debug
			{
				assert(false, "missing override for createParagraphFromXML"); }
			return null;
		}

		public function createSpanFromXML(xmlToParse:XML):ISpanElement	// No PMD
		{
			CONFIG::debug
			{
				assert(false, "missing override for createSpanFromXML"); }
			return null;
		}

		public function createBreakFromXML(xmlToParse:XML):BreakElement
		{
			parseAttributes(xmlToParse, null);	// no attributes allowed - reports errors
			return new BreakElement();
		}

		public function createListFromXML(xmlToParse:XML):IListElement	// No PMD
		{
			CONFIG::debug
			{
				assert(false, "missing override for createListFromXML"); }
			return null;
		}

		public function createListItemFromXML(xmlToParse:XML):IListItemElement	// No PMD
		{
			CONFIG::debug
			{
				assert(false, "missing override for createListItemFromXML"); }
			return null;
		}

		public function createTabFromXML(xmlToParse:XML):TabElement
		{
			parseAttributes(xmlToParse, null);	// reports errors
			return new TabElement();
		}

		/** 
		 * Parse XML, convert to FlowElements and add to the parent.
		 * 
		 * @param xmlToParse	content to parse
		 * @param parent 		the parent for the new content
		 */
		public function parseFlowChildren(xmlToParse:XML, parent:FlowGroupElement):void
		{
			parseFlowGroupElementChildren(xmlToParse, parent);
		}

		/** 
		 * Parse XML, convert to FlowElements and add to the parent.
		 * 
		 * @param xmlToParse	content to parse
		 * @param parent 		the parent for the new content
		 * @param chainedParent whether parent actually corresponds to xmlToParse or has been chained (such as when xmlToParse is a formatting element) 
		 */
		public function parseFlowGroupElementChildren(xmlToParse:XML, parent:IFlowGroupElement, exceptionElements:Object = null, chainedParent:Boolean = false):void
		{
			for each (var child:XML in xmlToParse.children())
			{
				if (child.nodeKind() == "element")
				{
					parseObject(child.name().localName, child, parent, exceptionElements);
				}
				// look for mixed content here
				else if (child.nodeKind() == "text")
				{
					var txt:String = child.toString();
					// Strip whitespace-only text appearing as a child of a container-formatted element
					var strip:Boolean = false;
					if (parent is IContainerFormattedElement)
					{
						strip = txt.search(anyPrintChar) == -1;
					}

					if (!strip)
						addChild(parent, createImpliedSpan(txt));
				}
			}

			// no implied paragraph should extend across container elements
			if (!chainedParent && parent is IContainerFormattedElement)
				resetImpliedPara();
		}

		/** 
		 * Parse XML, convert XML to FlowElements and TextFlow and add to the parent table cell
		 * 
		 * @param xmlToParse	content to parse
		 * @param parent 		the parent for the new content
		 * @param chainedParent whether parent actually corresponds to xmlToParse or has been chained (such as when xmlToParse is a formatting element) 
		 */
		public function parseTableCellElementChildren(xmlToParse:XML, parent:IFlowGroupElement, exceptionElements:Object = null, chainedParent:Boolean = false):void
		{
			var textFlow:TextFlow;

			for each (var child:XML in xmlToParse.children())
			{
				if (child.nodeKind() == "element")
				{
					if (child.name().localName == "p")
					{
						textFlow = new TextFlow(TLFFactory.defaultTLFFactory);
						parseObject(child.name().localName, child, textFlow, exceptionElements);
					}
					else if (child.name().localName == "TextFlow")
					{
						TableCellElement(parent).textFlow = createTextFlowFromXML(child);
					}
				}
				// look for mixed content here
				else if (child.nodeKind() == "text")
				{
					var txt:String = child.toString();
					// Strip whitespace-only text appearing as a child of a container-formatted element
					var strip:Boolean = false;
					if (parent is IContainerFormattedElement)
					{
						strip = txt.search(anyPrintChar) == -1;
					}

					if (!strip)
					{
						textFlow = new TextFlow(TLFFactory.defaultTLFFactory);
						parseObject(child.name().localName, child, textFlow, exceptionElements);
						// addChild(textFlow, createImpliedSpan(txt));
					}
				}

				if (textFlow)
				{
					TableCellElement(parent).textFlow = textFlow;
					textFlow = null;
				}
			}
		}

		/** create an implied span with specified text */
		public function createImpliedSpan(text:String):SpanElement
		{
			var span:SpanElement = new SpanElement();	// No PMD
			span.text = text;
			return span;
		}

		public function createParagraphFlowFromXML(xmlToParse:XML, newFlow:TextFlow = null):TextFlow	// No PMD
		{
			CONFIG::debug
			{
				assert(false, "missing override for createParagraphFlowFromXML"); }	// client must override
			return null;
		}

		public function parseObject(name:String, xmlToParse:XML, parent:IFlowGroupElement, exceptionElements:Object = null):void
		{
			if (!checkNamespace(xmlToParse))
				return;

			var info:FlowElementInfo = _config.lookup(name);
			if (!info)
			{
				if (exceptionElements == null || exceptionElements[name] === undefined)
					handleUnknownElement(name, xmlToParse, parent);
			}
			else
				info.parser(this, xmlToParse, parent);
		}

		protected function handleUnknownElement(name:String, xmlToParse:XML, parent:IFlowGroupElement):void
		{
			reportError(GlobalSettings.resourceStringFunction("unknownElement", [name]));
		}

		protected function handleUnknownAttribute(elementName:String, propertyName:String):void
		{
			reportError(GlobalSettings.resourceStringFunction("unknownAttribute", [propertyName, elementName]));
		}

		protected function getElementInfo(xmlToParse:XML):FlowElementInfo
		{
			return _config.lookup(xmlToParse.name().localName);
		}

		protected function GetClass(xmlToParse:XML):Class
		{
			var info:FlowElementInfo = _config.lookup(xmlToParse.name().localName);
			return info ? info.flowClass : null;
		}

		// In the text model, non-FlowParagraphElements (i.e. spans, images, links, TCY) cannot be children of a ContainerElement (TextFlow, Div etc.)
		// They can only be children of paragraphs or subparagraph blocks.
		// In XML, however, <p> elements can be implied (for example, a <span> may appear as a direct child of <flow>).
		// So, while parsing the XML, if we enounter a non-FlowParagraphElement child of a ContainerElement
		// 1. an explicitly created paragraph is used as the parent instead
		// 2. such explicitly created paragraphs are shared by adjacent flow elements provided there isn't an intervening FlowParagraphElement
		private var _impliedPara:IParagraphElement = null;

		/** @private */
		public function createImpliedParagraph():IParagraphElement
		{
			return createParagraphFromXML(<p/>);
		}

		/**
		 * @private
		 * Helper function for adding a child flow element that honors throwOnError setting and uses the parent override
		 * NOTE: You MUST NOT call addChild directly unless you are sure
		 * - There is not possibility of an implied paragraph, and
		 * - Parent is of type that can contain child
		 */
		public function addChild(parent:IFlowGroupElement, child:IFlowElement):Boolean
		{
			if (child is IParagraphFormattedElement)
			{
				// Reset due to possibly intervening FlowParagrahElement; See note 2. above
				resetImpliedPara();
			}
			else if (parent is IContainerFormattedElement)
			{
				// See note 1. above
				if (!_impliedPara)
				{
					// Derived classes may have special behavior for <p> tags. Implied paragraphs may need the same behavior.
					// So call createParagraphFromXML, don't just instantiate a ParagraphElement
					_impliedPara = createImpliedParagraph();
					parent.addChild(_impliedPara);
				}

				parent = _impliedPara;
			}

			if (throwOnError)
				parent.addChild(child);
			else
			{
				try
				{
					parent.addChild(child);
				}
				catch (e:*)
				{
					reportError(e);
					return false;
				}
			}

			return true;
		}

		public function resetImpliedPara():void
		{
			if (_impliedPara)
			{
				onResetImpliedPara(_impliedPara);
				_impliedPara = null;
			}
		}

		protected function onResetImpliedPara(para:IParagraphElement):void
		{
		}
	}
}
