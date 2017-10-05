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
	import org.apache.royale.text.engine.Kerning;
	import org.apache.royale.textLayout.conversion.importers.CaseInsensitiveTLFFormatImporter;
	import org.apache.royale.textLayout.conversion.importers.FontImporter;
	import org.apache.royale.textLayout.conversion.importers.HtmlCustomParaFormatImporter;
	import org.apache.royale.textLayout.conversion.importers.TextFormatImporter;
	import org.apache.royale.textLayout.debug.assert;
	import org.apache.royale.textLayout.elements.BreakElement;
	import org.apache.royale.textLayout.elements.DivElement;
	import org.apache.royale.textLayout.elements.ElementHelper;
	import org.apache.royale.textLayout.elements.GlobalSettings;
	import org.apache.royale.textLayout.elements.IFlowElement;
	import org.apache.royale.textLayout.elements.IFlowGroupElement;
	import org.apache.royale.textLayout.elements.IFlowLeafElement;
	import org.apache.royale.textLayout.elements.IListElement;
	import org.apache.royale.textLayout.elements.IListItemElement;
	import org.apache.royale.textLayout.elements.IParagraphElement;
	import org.apache.royale.textLayout.elements.InlineGraphicElement;
	import org.apache.royale.textLayout.elements.LinkElement;
	import org.apache.royale.textLayout.elements.SpanElement;
	import org.apache.royale.textLayout.elements.SubParagraphGroupElement;
	import org.apache.royale.textLayout.elements.SubParagraphGroupElementBase;
	import org.apache.royale.textLayout.elements.TabElement;
	import org.apache.royale.textLayout.elements.TextFlow;
	import org.apache.royale.textLayout.factory.TLFFactory;
	import org.apache.royale.textLayout.formats.Float;
	import org.apache.royale.textLayout.formats.ITextLayoutFormat;
	import org.apache.royale.textLayout.formats.LeadingModel;
	import org.apache.royale.textLayout.formats.ListMarkerFormat;
	import org.apache.royale.textLayout.formats.ListStyleType;
	import org.apache.royale.textLayout.formats.TextLayoutFormat;
	import org.apache.royale.textLayout.property.PropertyFactory;
	import org.apache.royale.textLayout.property.PropertyUtil;
	import org.apache.royale.utils.ObjectMap;

	// [ExcludeClass]
	/** 
	 * @private
	 * TextFieldHtmlImporter converts from HTML to TextLayout data structures
	 */
	public class TextFieldHtmlImporter extends BaseTextLayoutImporter implements IHTMLImporter {
		// TLF formats to which <font/> attributes map directly
		/** @private */
		static private var _fontDescription_:Object;
		static private function get _fontDescription():Object
		{
			if(_fontDescription_ == null)
			{
				_fontDescription_ = {"color":TextLayoutFormat.colorProperty, "trackingRight":TextLayoutFormat.trackingRightProperty, "fontFamily":TextLayoutFormat.fontFamilyProperty};
			}
			return _fontDescription_;
		}
		// <font/> attributes that require custom logic for mapping to TLF formats
		/** @private */
		static private var _fontMiscDescription_:Object;
		static private function get _fontMiscDescription():Object
		{
			if(_fontMiscDescription_ == null)
			{
				_fontMiscDescription_ = {"size":PropertyFactory.string("size", null, false, null), "kerning":PropertyFactory.string("kerning", null, false, null)};
			}
			return _fontMiscDescription_;
		}
		// TLF formats to which <textformat/> attributes map directly
		/** @private */
		static private var _textFormatDescription_:Object;
		static private function get _textFormatDescription():Object
		{
			if(_textFormatDescription_ == null)
			{
				_textFormatDescription_ = {"paragraphStartIndent":TextLayoutFormat.paragraphStartIndentProperty, "paragraphEndIndent":TextLayoutFormat.paragraphEndIndentProperty, "textIndent":TextLayoutFormat.textIndentProperty, "lineHeight":TextLayoutFormat.lineHeightProperty, "tabStops":TextLayoutFormat.tabStopsProperty};
			}
			return _textFormatDescription_;
		}
		// <textformat/> attributes that require custom logic for mapping to TLF formats
		/** @private */
		static private var _textFormatMiscDescription_:Object;
		static private function get _textFormatMiscDescription():Object
		{
			if(_textFormatMiscDescription_ == null)
			{
				_textFormatMiscDescription_ = {"blockIndent":PropertyFactory.string("blockIndent", null, false, null)};
			}
			return _textFormatMiscDescription_;
		}
		/** @private */
		static private var _paragraphFormatDescription_:Object;
		static private function get _paragraphFormatDescription():Object
		{
			if(_paragraphFormatDescription_ == null)
			{
				_paragraphFormatDescription_ = {"textAlign":TextLayoutFormat.textAlignProperty};
			}
			return _paragraphFormatDescription_;
		}
		/** @private */
		static private var _linkHrefDescription_:Object;
		static private function get _linkHrefDescription():Object
		{
			if(_linkHrefDescription_ == null)
			{
				_linkHrefDescription_ = {"href":PropertyFactory.string("href", null, false, null)};
			}
			return _linkHrefDescription_;
		}
		/** @private */
		static private var _linkTargetDescription_:Object;
		static private function get _linkTargetDescription():Object
		{
			if(_linkTargetDescription_ == null)
			{
				_linkTargetDescription_ = {"target":PropertyFactory.string("target", null, false, null)};
			}
			return _linkTargetDescription_;
		}
		/** @private */
		static private var _imageDescription_:Object;
		static private function get _imageDescription():Object
		{
			if(_imageDescription_ == null)
			{
				_imageDescription_ = {"height":InlineGraphicElement.heightPropertyDefinition, "width":InlineGraphicElement.widthPropertyDefinition};
			}
			return _imageDescription_;
		}
		// Separate description because id value is case-sensitive unlike others
		/** @private */
		static private var _imageMiscDescription_:Object;
		static private function get _imageMiscDescription():Object
		{
			if(_imageMiscDescription_ == null)
			{
				_imageMiscDescription_ = {"src":PropertyFactory.string("src", null, false, null), "align":PropertyFactory.string("align", null, false, null)};
			}
			return _imageMiscDescription_;
		}
		/** @private Finish defining at run time because it has a member variable "CLASS" which is a reserved keyword. */
		static private var _classAndIdDescription_:Object;
		static private function get _classAndIdDescription():Object
		{
			if(_classAndIdDescription_ == null)
			{
				_classAndIdDescription_ = {"id":PropertyFactory.string("ID", null, false, null)};
			}
			return _classAndIdDescription_;
		}
		// For some reason, the following can't be initialized here
		/** @private */
		static public var _fontImporter:FontImporter;
		/** @private */
		static public var _fontMiscImporter:CaseInsensitiveTLFFormatImporter;
		/** @private */
		static public var _textFormatImporter:TextFormatImporter;
		/** @private */
		static public var _textFormatMiscImporter:CaseInsensitiveTLFFormatImporter;
		/** @private */
		static public var _paragraphFormatImporter:HtmlCustomParaFormatImporter;
		/** @private */
		static public var _linkHrefImporter:CaseInsensitiveTLFFormatImporter;
		/** @private */
		static public var _linkTargetImporter:CaseInsensitiveTLFFormatImporter;
		/** @private */
		static public var _ilgFormatImporter:CaseInsensitiveTLFFormatImporter;
		/** @private */
		static public var _ilgMiscFormatImporter:CaseInsensitiveTLFFormatImporter;
		/** @private */
		static public var _classAndIdImporter:CaseInsensitiveTLFFormatImporter;
		// Formats specified by formatting elements in the ancestry of the element being parsed currently
		/** @private */
		static private var _activeFormat_:TextLayoutFormat; // to be applied to all flow elements
		static private function get _activeFormat():TextLayoutFormat
		{
			if(_activeFormat_ == null)
			{
				_activeFormat_ = new TextLayoutFormat();
			}
			return _activeFormat_;
		}
		/** @private */
		static private var _activeParaFormat_:TextLayoutFormat; // to be applied to paras only
		static private function get _activeParaFormat():TextLayoutFormat
		{
			if(_activeParaFormat_ == null)
			{
				_activeParaFormat_ = new TextLayoutFormat();
			}
			return _activeParaFormat_;
		}
		/** @private */
		static public var _activeImpliedParaFormat:TextLayoutFormat = null;
		// The basis for relative font size calculation
		/** @private */
		public var _baseFontSize:Number;
		/** @private */
		public static var _htmlImporterConfig:ImportExportConfiguration;
		private var _imageSourceResolveFunction:Function;
		private var _preserveBodyElement:Boolean = false;
		private var _importHtmlElement:Boolean = false;

		/** Constructor */
		public function TextFieldHtmlImporter() {
			createConfig();
			super(null, _htmlImporterConfig);
		}

		/** @private */
		public static function createConfig():void {
			if (!_htmlImporterConfig) {
				_htmlImporterConfig = new ImportExportConfiguration();

				_htmlImporterConfig.addIEInfo("BR", BreakElement, BaseTextLayoutImporter.parseBreak, null);
				_htmlImporterConfig.addIEInfo("P", IParagraphElement, TextFieldHtmlImporter.parsePara, null);
				_htmlImporterConfig.addIEInfo("SPAN", SpanElement, TextFieldHtmlImporter.parseSpan, null);
				_htmlImporterConfig.addIEInfo("A", LinkElement, TextFieldHtmlImporter.parseLink, null);
				_htmlImporterConfig.addIEInfo("IMG", InlineGraphicElement, TextFieldHtmlImporter.parseInlineGraphic, null);
				_htmlImporterConfig.addIEInfo("DIV", DivElement, TextFieldHtmlImporter.parseDiv, null);
				_htmlImporterConfig.addIEInfo("HTML", null, TextFieldHtmlImporter.parseHtmlElement, null);
				_htmlImporterConfig.addIEInfo("BODY", null, TextFieldHtmlImporter.parseBody, null);

				// formatting elements
				_htmlImporterConfig.addIEInfo("FONT", null, TextFieldHtmlImporter.parseFont, null);
				_htmlImporterConfig.addIEInfo("TEXTFORMAT", null, TextFieldHtmlImporter.parseTextFormat, null);
				_htmlImporterConfig.addIEInfo("U", null, TextFieldHtmlImporter.parseUnderline, null);
				_htmlImporterConfig.addIEInfo("I", null, TextFieldHtmlImporter.parseItalic, null);
				_htmlImporterConfig.addIEInfo("B", null, TextFieldHtmlImporter.parseBold, null);
				_htmlImporterConfig.addIEInfo("S", null, TextFieldHtmlImporter.parseStrikeThrough, null);

				// list stuff
				_htmlImporterConfig.addIEInfo("UL", null, BaseTextLayoutImporter.parseList, null);
				_htmlImporterConfig.addIEInfo("OL", null, BaseTextLayoutImporter.parseList, null);
				_htmlImporterConfig.addIEInfo("LI", null, TextFieldHtmlImporter.parseListItem, null);
			}

			// create these here - can't be done above
			if (_classAndIdDescription["CLASS"] === undefined) {
				_classAndIdDescription["CLASS"] = PropertyFactory.string("CLASS", null, false, null);
				_paragraphFormatImporter = new HtmlCustomParaFormatImporter(TextLayoutFormat, _paragraphFormatDescription);
				_textFormatImporter = new TextFormatImporter(TextLayoutFormat, _textFormatDescription);
				_fontImporter = new FontImporter(TextLayoutFormat, _fontDescription);
				_fontMiscImporter = new CaseInsensitiveTLFFormatImporter(ObjectMap, _fontMiscDescription);
				_textFormatMiscImporter = new CaseInsensitiveTLFFormatImporter(ObjectMap, _textFormatMiscDescription);
				_linkHrefImporter = new CaseInsensitiveTLFFormatImporter(ObjectMap, _linkHrefDescription, false);
				_linkTargetImporter = new CaseInsensitiveTLFFormatImporter(ObjectMap, _linkTargetDescription);
				_ilgFormatImporter = new CaseInsensitiveTLFFormatImporter(ObjectMap, _imageDescription);
				_ilgMiscFormatImporter = new CaseInsensitiveTLFFormatImporter(ObjectMap, _imageMiscDescription, false);
				_classAndIdImporter = new CaseInsensitiveTLFFormatImporter(ObjectMap, _classAndIdDescription);
			}
		}

		/** @copy IHTMLExporter#imageSourceResolveFunction
		 * 
		 * @playerversion Flash 10.0
		 * @playerversion AIR 2.0
		 * @langversion 3.0
		 */
		public function get imageSourceResolveFunction():Function {
			return _imageSourceResolveFunction;
		}

		public function set imageSourceResolveFunction(resolver:Function):void {
			_imageSourceResolveFunction = resolver;
		}

		/** @copy IHTMLExporter#preserveBodyElement
		 * 
		 * @playerversion Flash 10.0
		 * @playerversion AIR 2.0
		 * @langversion 3.0
		 */
		public function get preserveBodyElement():Boolean {
			return _preserveBodyElement;
		}

		public function set preserveBodyElement(value:Boolean):void {
			_preserveBodyElement = value;
		}

		/** @copy IHTMLExporter#preserveHTMLElement
		 *
		 * @playerversion Flash 10.0
		 * @playerversion AIR 2.0
		 * @langversion 3.0
		 */
		public function get preserveHTMLElement():Boolean {
			return _importHtmlElement;
		}

		public function set preserveHTMLElement(value:Boolean):void {
			_importHtmlElement = value;
		}

		/** Parse and convert input data
		 * 
		 * @param source - the HTML string
		 */
		protected override function importFromString(source:String):TextFlow {
			var textFlow:TextFlow;

			// Use toXML rather than the XML constructor because the latter expects
			// well-formed XML, which source may not be
			var xml:XML = toXML(source);
			if (xml) {
				textFlow = importFromXML(xml);
				// TODO probably does not make sense to Royale 
				// if (Configuration.playerEnablesArgoFeatures)
				// System["disposeXML"](xml);
			}
			return textFlow;
		}

		/** Parse and convert input XML data
		 */
		protected override function importFromXML(xmlSource:XML):TextFlow {
			var textFlow:TextFlow = new TextFlow(TLFFactory.defaultTLFFactory, _textFlowConfiguration);
			// always set html typeName - the convertfromstring to xml code wraps the content in an HTML element.  this makes it all match
			if (this.preserveHTMLElement)
				textFlow.typeName = "html";

			// Use font size specified in _textFlowConfiguration.textFlowInitialFormat as the base font size
			// If not specified, use 12
			_baseFontSize = textFlow.fontSize === undefined ? 12 : textFlow.fontSize;

			// Unlike other markup formats, the HTML format for TLF does not have a fixed root XML element.
			// <html> and <body> are optional, and flow elements may or may not be encapsulated in formatting
			// elements like <i> or <textformat>. Use parseObject to handle any (expected) root element.
			CONFIG::debug {
				assert(xmlSource.name() != null, "Bad XML source"); }
			parseObject(xmlSource.name().localName, xmlSource, textFlow);

			// If the last para is implied, there is nothing following it that'll trigger a reset.
			// For most importers, this is fine (clear will eventually reset it), but the HTML importer has
			// some special behavior associated with the reset (replacing BreakElements with para splits).
			// Explicitly do so now (must happen before normalization)
			resetImpliedPara();

			CONFIG::debug {
				textFlow.debugCheckNormalizeAll() ; }
			textFlow.normalize();
			textFlow.applyWhiteSpaceCollapse(null);

			return textFlow;
		}

		/** @copy ConverterBase#clear()
		 * @private
		 */
		public override function clear():void {
			// Reset active formats and base font size
			_activeParaFormat.clearStyles();
			_activeFormat.clearStyles();
			super.clear();
		}

		/** @private */
		public override function createImpliedParagraph():IParagraphElement {
			var rslt:IParagraphElement;
			var savedActiveFormat:TextLayoutFormat = _activeFormat;
			if (_activeImpliedParaFormat)
				_activeFormat_ = _activeImpliedParaFormat;
			try {
				rslt = super.createImpliedParagraph();
			} finally {
				_activeFormat_ = savedActiveFormat;
			}
			return rslt;
		}

		/** @private */
		public override function createParagraphFromXML(xmlToParse:XML):IParagraphElement {
			var paraElem:IParagraphElement = ElementHelper.getParagraph();

			// Parse xml attributes for paragraph format
			var formatImporters:Array = [_paragraphFormatImporter, _classAndIdImporter];
			parseAttributes(xmlToParse, formatImporters);
			var paragraphFormat:TextLayoutFormat = new TextLayoutFormat(_paragraphFormatImporter.result as ITextLayoutFormat);

			// Apply paragraph format inherited from formatting elements
			if (_activeParaFormat)
				paragraphFormat.apply(_activeParaFormat);
			if (_activeFormat)
				paragraphFormat.apply(_activeFormat);

			// A <FONT/> that is the only child of a <P/> specifies formats that apply to the paragraph itself
			// Otherwise (i.e., if it has siblings), the formats apply to the elements nested within the <FONT/>
			// Check for the former case here
			var fontFormattingElement:XML = getSingleFontChild(xmlToParse);
			if (fontFormattingElement)
				paragraphFormat.apply(parseFontAttributes(fontFormattingElement));

			if (paragraphFormat.lineHeight !== undefined)
				paragraphFormat.leadingModel = LeadingModel.APPROXIMATE_TEXT_FIELD;

			paraElem.format = paragraphFormat;

			// Use the value of the 'class' attribute (if present) as styleName
			paraElem.styleName = _classAndIdImporter.getFormatValue("CLASS");
			paraElem.id = _classAndIdImporter.getFormatValue("ID");

			return paraElem;
		}

		/** @private */
		static public function parseListItem(importer:TextFieldHtmlImporter, xmlToParse:XML, parent:IFlowGroupElement):void {
			if (!(parent is IListElement)) {
				var list:IListElement = importer.createListFromXML(null);
				importer.addChild(parent, list);
				CONFIG::debug {
					assert(list.parent == parent, "TextFieldHtmlImporter.parseListeItem: Bad call to addChild"); }
				parent = list;
			}

			var listItem:IListItemElement = importer.createListItemFromXML(xmlToParse);
			if (importer.addChild(parent, listItem)) {
				importer.parseFlowGroupElementChildren(xmlToParse, listItem);
				// if parsing an empty list item, create a Paragraph for it.
				if (listItem.numChildren == 0)
					listItem.addChild(ElementHelper.getParagraph());
			}
		}

		/** @private */
		public override function createListFromXML(xmlToParse:XML):IListElement	// No PMD
		{
			parseAttributes(xmlToParse, [_classAndIdImporter]);

			// try and make lists look something like TextField but with a bit more - do ordered lists as well not just bullets
			// textField indents lists on the left by 36 pixels.

			var list:IListElement = ElementHelper.getList();
			list.paddingLeft = 36;
			var name:String = xmlToParse ? xmlToParse.name().localName : null;
			list.listStyleType = name == "OL" ? ListStyleType.DECIMAL : ListStyleType.DISC;

			// TextField does equivalent of a 18 pixel start indent but that doesnt look nice with numbered lists.
			// default bullet is around 4 pixels. so place the marker 14 pixels from the right side
			var lmf:ListMarkerFormat = new ListMarkerFormat();
			lmf.paragraphEndIndent = 14;
			list.listMarkerFormat = lmf;

			list.styleName = _classAndIdImporter.getFormatValue("CLASS");
			list.id = _classAndIdImporter.getFormatValue("ID");

			return list;
		}

		/** @private */
		public override function createListItemFromXML(xmlToParse:XML):IListItemElement	// No PMD
		{
			parseAttributes(xmlToParse, [_classAndIdImporter]);

			var listItem:IListItemElement = ElementHelper.getListItem();
			listItem.styleName = _classAndIdImporter.getFormatValue("CLASS");
			listItem.id = _classAndIdImporter.getFormatValue("ID");

			return listItem;
		}

		/** Parse the supplied XML into a paragraph. Parse the <p/> element and its children.
		 * @private
		 * @param importer	parser object
		 * @param xmlToParse	content to parse
		 * @param parent 		the parent for the new content
		 */
		static public function parsePara(importer:TextFieldHtmlImporter, xmlToParse:XML, parent:IFlowGroupElement):void {
			var paraElem:IParagraphElement = importer.createParagraphFromXML(xmlToParse);

			if (importer.addChild(parent, paraElem)) {
				// Parse children, but if there is only one child, a <FONT/>, skip to *its* children.
				// That's because the single <FONT/> chuld has already been parsed in createParagraphFromXML.
				var fontFormattingElement:XML = getSingleFontChild(xmlToParse);
				parseChildrenUnderNewActiveFormat(importer, fontFormattingElement ? fontFormattingElement : xmlToParse, paraElem, _activeFormat, null);

				// if parsing an empty paragraph, create a Span for it.
				if (paraElem.numChildren == 0)
					paraElem.addChild(importer.createImpliedSpan(""));
			}

			// Replace break elements with paragraph splits
			// This must happen before normalization else BreakElements may merge or become spans
			replaceBreakElementsWithParaSplits(paraElem);
		}

		/** Parse the supplied XML into a DivElement. Parse the <p/> element and its children.
		 * @private
		 * @param importer	parser object
		 * @param xmlToParse	content to parse
		 * @param parent 		the parent for the new content
		 */
		static public function parseDiv(importer:TextFieldHtmlImporter, xmlToParse:XML, parent:IFlowGroupElement):void {
			var elem:IFlowGroupElement;
			if (parent.canOwnFlowElement(new DivElement()))
				elem = importer.createDivFromXML(xmlToParse);
			else {
				elem = importer.createSPGEFromXML(xmlToParse);
				elem.typeName = "div";
			}

			importer.addChild(parent, elem);
			importer.parseFlowGroupElementChildren(xmlToParse, elem);
		}

		static public function parseHtmlElement(importer:TextFieldHtmlImporter, xmlToParse:XML, parent:IFlowGroupElement):void {
			// skip the element and descent to the children
			if (importer.preserveHTMLElement) {
				if (!(parent is TextFlow)) {
					var newParent:IFlowGroupElement = ((parent is IParagraphElement) || (parent is SubParagraphGroupElementBase)) ? new SubParagraphGroupElement() : new DivElement;
					parent.addChild(newParent);
					parent = newParent;
				}
				importer.parseAttributes(xmlToParse, [_classAndIdImporter]);
				parent.typeName = "html";
				parent.styleName = _classAndIdImporter.getFormatValue("CLASS");
				parent.id = _classAndIdImporter.getFormatValue("ID");
			}
			importer.parseFlowGroupElementChildren(xmlToParse, parent, null, true);
		}

		static public function parseBody(importer:TextFieldHtmlImporter, xmlToParse:XML, parent:IFlowGroupElement):void {
			// skip the element and descent to the children
			if (importer.preserveBodyElement) {
				var newParent:IFlowGroupElement = ((parent is IParagraphElement) || (parent is SubParagraphGroupElementBase)) ? new SubParagraphGroupElement() : new DivElement;
				parent.addChild(newParent);
				parent = newParent;

				importer.parseAttributes(xmlToParse, [_classAndIdImporter]);
				parent.typeName = "body";
				parent.styleName = _classAndIdImporter.getFormatValue("CLASS");
				parent.id = _classAndIdImporter.getFormatValue("ID");
			}
			importer.parseFlowGroupElementChildren(xmlToParse, parent, null, true);
		}

		public function createDivFromXML(xmlToParse:XML):DivElement {
			parseAttributes(xmlToParse, [_classAndIdImporter]);

			var divElement:DivElement = new DivElement();
			divElement.styleName = _classAndIdImporter.getFormatValue("CLASS");
			divElement.id = _classAndIdImporter.getFormatValue("ID");

			return divElement;
		}

		public function createSPGEFromXML(xmlToParse:XML):SubParagraphGroupElement {
			parseAttributes(xmlToParse, [_classAndIdImporter]);

			var spge:SubParagraphGroupElement = new SubParagraphGroupElement();
			spge.styleName = _classAndIdImporter.getFormatValue("CLASS");
			spge.id = _classAndIdImporter.getFormatValue("ID");

			return spge;
		}

		/** @private */
		protected override function onResetImpliedPara(para:IParagraphElement):void {
			// Replacing break elements with paragraph splits, even for implied paras
			replaceBreakElementsWithParaSplits(para);
		}

		/** If the provided xml has a single child <FONT.../>, get it
		 * @private
		 */
		static private function getSingleFontChild(xmlToParse:XML):XML {
			var children:XMLList = xmlToParse.children();
			if (children.length() == 1) {
				var child:XML = children[0];
				if (child.name() && child.name().localName.toUpperCase() == "FONT")
					return child;
			}

			return null;
		}

		private function createLinkFromXML(xmlToParse:XML):LinkElement {
			var linkElem:LinkElement = new LinkElement();

			var formatImporters:Array = [_linkHrefImporter, _linkTargetImporter, _classAndIdImporter];
			parseAttributes(xmlToParse, formatImporters);

			linkElem.href = _linkHrefImporter.getFormatValue("HREF");
			linkElem.target = _linkTargetImporter.getFormatValue("TARGET");

			// Handle difference in defaults between TextField and TLF
			// target "_self" vs. null (equivalent to "_blank")
			if (!linkElem.target)
				linkElem.target = "_self";

			// Apply active format
			linkElem.format = _activeFormat;

			linkElem.styleName = _classAndIdImporter.getFormatValue("CLASS");
			linkElem.id = _classAndIdImporter.getFormatValue("ID");

			return linkElem;
		}

		/** Parse the supplied XML into a LinkElement. Parse the <a/> element and its children.
		 * @private
		 * @param importer	parser object
		 * @param xmlToParse	content to parse
		 * @param parent 		the parent for the new content
		 */
		static public function parseLink(importer:TextFieldHtmlImporter, xmlToParse:XML, parent:IFlowGroupElement):void {
			var linkElem:LinkElement = importer.createLinkFromXML(xmlToParse);

			if (importer.addChild(parent, linkElem)) {
				parseChildrenUnderNewActiveFormat(importer, xmlToParse, linkElem, _activeFormat, null);
			}
		}

		/** @private returns a string if its a simple span otherwise null */
		public static function extractSimpleSpanText(xmlToParse:XML):String {
			var elemList:XMLList = xmlToParse[0].children();
			if (elemList.length() == 0)
				return "";
			if (elemList.length() != 1)
				return null;
			// sniff the first child and test if its a textelement
			for each (var child:XML in elemList)
				break;
			var elemName:String = child.name() ? child.name().localName : null;
			if (elemName != null)
				return null;

			var rslt:String = child.toString();
			return rslt ? rslt : "";
		}

		/** Static method for constructing a span from XML. Parse the <span> ... </span> tag. 
		 * Insert the new content into its parent
		 * Note: Differs from BaseTextLayoutImporter.parseSpan in that it allows nested <span/> elements. 
		 * @private
		 * @param importer	parser object
		 * @param xmlToParse	content to parse
		 * @param parent 		the parent for the new content
		 */
		static public function parseSpan(importer:TextFieldHtmlImporter, xmlToParse:XML, parent:IFlowGroupElement):void {
			// Use the value of the 'class' attribute (if present) as styleName
			importer.parseAttributes(xmlToParse, [_classAndIdImporter]);

			// if either class or id is set and its not a "simple" span then we need to create an SPGE and descend
			var classFormatValue:* = _classAndIdImporter.getFormatValue("CLASS");
			var idFormatValue:* = _classAndIdImporter.getFormatValue("ID");

			var simpleSpanText:String = extractSimpleSpanText(xmlToParse);

			if (simpleSpanText == null) {
				// if its an interesting span make an SPGE otherwise just parse the children
				if (classFormatValue !== undefined || idFormatValue !== undefined || !TextLayoutFormat.isEqual(_activeFormat, TextLayoutFormat.emptyTextLayoutFormat)) {
					var spge:SubParagraphGroupElement = new SubParagraphGroupElement();
					spge.format = _activeFormat;
					spge.styleName = classFormatValue;
					spge.id = idFormatValue;
					spge.typeName = "span";
					importer.addChild(parent, spge);
					parent = spge;
				}
				parseChildrenUnderNewActiveFormat(importer, xmlToParse, parent, _activeFormat, null);
				return;
			}

			var span:SpanElement = new SpanElement();
			span.format = _activeFormat;
			span.styleName = classFormatValue;
			span.id = idFormatValue;
			span.text = simpleSpanText;

			importer.addChild(parent, span);
		}

		/** create an implied span with specified text */
		public override function createImpliedSpan(text:String):SpanElement {
			var span:SpanElement = super.createImpliedSpan(text);
			span.format = _activeFormat;
			return span;
		}

		/** @private */
		protected function createInlineGraphicFromXML(xmlToParse:XML):InlineGraphicElement {
			var imgElem:InlineGraphicElement = new InlineGraphicElement();

			var formatImporters:Array = [_ilgFormatImporter, _ilgMiscFormatImporter, _classAndIdImporter];
			parseAttributes(xmlToParse, formatImporters);

			var source:String = _ilgMiscFormatImporter.getFormatValue("SRC");
			imgElem.source = _imageSourceResolveFunction != null ? _imageSourceResolveFunction(source) : source;

			// if not defined then let InlineGraphic set its own default
			imgElem.height = InlineGraphicElement.heightPropertyDefinition.setHelper(imgElem.height, _ilgFormatImporter.getFormatValue("HEIGHT"));
			imgElem.width = InlineGraphicElement.heightPropertyDefinition.setHelper(imgElem.width, _ilgFormatImporter.getFormatValue("WIDTH"));

			var floatVal:String = _ilgMiscFormatImporter.getFormatValue("ALIGN");
			// Handle difference in defaults between TextField and TLF
			// float "left" vs. "none"
			if (floatVal == Float.LEFT || floatVal == Float.RIGHT)
				imgElem.float = floatVal;

			// Apply active format
			imgElem.format = _activeFormat;
			imgElem.id = _classAndIdImporter.getFormatValue("ID");
			imgElem.styleName = _classAndIdImporter.getFormatValue("CLASS");

			return imgElem;
		}

		/** Parse the supplied XML into an InlineGraphicElement. Parse the <img/> element.
		 * @private
		 * @param importer	parser object
		 * @param xmlToParse	content to parse
		 * @param parent 		the parent for the new content
		 */
		static public function parseInlineGraphic(importer:TextFieldHtmlImporter, xmlToParse:XML, parent:IFlowGroupElement):void {
			var ilg:InlineGraphicElement = importer.createInlineGraphicFromXML(xmlToParse);
			importer.addChild(parent, ilg);
		}

		/** @private */
		public override function createTabFromXML(xmlToParse:XML):TabElement {
			return null; // no tabs in HTML
		}

		/** Parse the attributes of the <Font/> formatting element and returns the corresponding TLF format
		 * @private
		 */
		protected function parseFontAttributes(xmlToParse:XML):ITextLayoutFormat {
			var formatImporters:Array = [_fontImporter, _fontMiscImporter];
			parseAttributes(xmlToParse, formatImporters);

			var newFormat:TextLayoutFormat = new TextLayoutFormat(_fontImporter.result as ITextLayoutFormat);

			var kerning:String = _fontMiscImporter.getFormatValue("KERNING");
			if (kerning) {
				var kerningVal:Number = Number(kerning);
				newFormat.kerning = kerningVal == 0 ? Kerning.OFF : Kerning.AUTO;
			}

			var size:String = _fontMiscImporter.getFormatValue("SIZE");
			if (size) {
				var sizeVal:Number = TextLayoutFormat.fontSizeProperty.setHelper(NaN, size);
				if (!isNaN(sizeVal)) {
					if (size.search(/\s*(-|\+)/) != -1) // leading whitespace followed by + or -
						sizeVal += _baseFontSize;		// implies relative font sizes
					newFormat.fontSize = sizeVal;
				}
			}

			return newFormat;
		}

		/** Parse the <Font/> formatting element
		 * Calculates the new format to apply to _activeFormat and continues parsing down the hierarchy
		 * @private
		 */
		static public function parseFont(importer:TextFieldHtmlImporter, xmlToParse:XML, parent:IFlowGroupElement):void {
			var newFormat:ITextLayoutFormat = importer.parseFontAttributes(xmlToParse);
			parseChildrenUnderNewActiveFormatWithImpliedParaFormat(importer, xmlToParse, parent, newFormat);
		}

		/** Parse the <TextFormat> formatting element
		 * Calculates the new format to apply to _activeParaFormat and continues parsing down the hierarchy
		 * @private
		 */
		static public function parseTextFormat(importer:TextFieldHtmlImporter, xmlToParse:XML, parent:IFlowGroupElement):void {
			var formatImporters:Array = [_textFormatImporter, _textFormatMiscImporter];
			importer.parseAttributes(xmlToParse, formatImporters);

			var newFormat:TextLayoutFormat = new TextLayoutFormat(_textFormatImporter.result as ITextLayoutFormat);

			var blockIndent:* = _textFormatMiscImporter.getFormatValue("BLOCKINDENT");
			if (blockIndent !== undefined) {
				// TODO: Nested <TextFormat/>?
				blockIndent = TextLayoutFormat.paragraphStartIndentProperty.setHelper(undefined, blockIndent);
				if (blockIndent !== undefined) {
					var blockIndentVal:Number = Number(blockIndent);
					newFormat.paragraphStartIndent = newFormat.paragraphStartIndent === undefined ? blockIndentVal : newFormat.paragraphStartIndent + blockIndentVal;
				}
			}

			// lineHeight is the only textformat property that must be copied down into subparagraph elements
			var saveLineHeight:* = _activeFormat.lineHeight;
			if (parent is IParagraphElement) {
				if (parent.numChildren == 0) {
					// if <textFormat> is the first child then promote all the settings to the Paragraph
					var format:TextLayoutFormat = new TextLayoutFormat(parent.format);
					format.apply(newFormat);
					// same as createParagraphFromXML
					if (format.lineHeight !== undefined)
						format.leadingModel = LeadingModel.APPROXIMATE_TEXT_FIELD;
					parent.format = format;
					newFormat.clearStyles();
				} else if (newFormat.lineHeight !== undefined)
					_activeFormat.lineHeight = newFormat.lineHeight;
			}

			parseChildrenUnderNewActiveFormat(importer, xmlToParse, parent, _activeParaFormat, newFormat, true);

			_activeFormat.lineHeight = saveLineHeight;
		}

		/** Parse the <b> formatting element
		 * Calculates the new format to apply to _activeFormat and continues parsing down the hierarchy
		 * @private
		 */
		static public function parseBold(importer:TextFieldHtmlImporter, xmlToParse:XML, parent:IFlowGroupElement):void {
			var newFormat:TextLayoutFormat = new TextLayoutFormat();
			newFormat.fontWeight = org.apache.royale.text.engine.FontWeight.BOLD;

			parseChildrenUnderNewActiveFormatWithImpliedParaFormat(importer, xmlToParse, parent, newFormat);
		}

		/** Parse the <i> formatting element
		 * Calculates the new format to apply to _activeFormat and continues parsing down the hierarchy
		 * @private
		 */
		static public function parseItalic(importer:TextFieldHtmlImporter, xmlToParse:XML, parent:IFlowGroupElement):void {
			var newFormat:TextLayoutFormat = new TextLayoutFormat();
			newFormat.fontStyle = org.apache.royale.text.engine.FontPosture.ITALIC;
			parseChildrenUnderNewActiveFormatWithImpliedParaFormat(importer, xmlToParse, parent, newFormat);
		}

		/** Parse the <s> formatting element
		 * Calculates the new format to apply to _activeFormat and continues parsing down the hierarchy
		 * @private
		 */
		static public function parseStrikeThrough(importer:TextFieldHtmlImporter, xmlToParse:XML, parent:IFlowGroupElement):void {
			var newFormat:TextLayoutFormat = new TextLayoutFormat();
			newFormat.lineThrough = true;
			parseChildrenUnderNewActiveFormatWithImpliedParaFormat(importer, xmlToParse, parent, newFormat);
		}

		/** Parse the <u> formatting element
		 * Calculates the new format to apply to _activeFormat and continues parsing down the hierarchy
		 * @private
		 */
		static public function parseUnderline(importer:TextFieldHtmlImporter, xmlToParse:XML, parent:IFlowGroupElement):void {
			var newFormat:TextLayoutFormat = new TextLayoutFormat();
			newFormat.textDecoration = org.apache.royale.textLayout.formats.TextDecoration.UNDERLINE;
			parseChildrenUnderNewActiveFormatWithImpliedParaFormat(importer, xmlToParse, parent, newFormat);
		}

		/** @private */
		static protected function parseChildrenUnderNewActiveFormatWithImpliedParaFormat(importer:TextFieldHtmlImporter, xmlToParse:XML, parent:IFlowGroupElement, newFormat:ITextLayoutFormat):void {
			var oldActiveImpliedParaFormat:TextLayoutFormat = _activeImpliedParaFormat;
			if (_activeImpliedParaFormat == null)
				_activeImpliedParaFormat = new TextLayoutFormat(_activeFormat);
			try {
				parseChildrenUnderNewActiveFormat(importer, xmlToParse, parent, _activeFormat, newFormat, true);
			} finally {
				_activeImpliedParaFormat = oldActiveImpliedParaFormat;
			}
		}

		/** Updates the current active format and base font size as specified, parses children, and restores the active format and base font size
		 * There are two different use cases for this method:
		 * - Parsing children of a formatting XML element like <Font/> or <TextFormat/>. In this case, the TLF format corresponding to the formatting element
		 * (newFormat) is applied to the currently active format (_activeFormat in the case of <Font/> and _activeParaFormat in the case of <TextFormat/>). 
		 * Children of the formatting element are parsed under this new active format.
		 * - Parsing children of a flow XML element like <P/> or <A/>. In this case, newFormat is null and the currently active format (_activeFormat) is reset.
		 * Children of the flow element are parsed under this newly reset format. This is to avoid redundancy (the format is already applied to the flow element). 
		 * 
		 * @param importer	parser object
		 * @param xmlToParse	content to parse
		 * @param parent 		the parent for the parsed children
		 * @param currFormat	the active format (_activeFormat or _activeParaFormat)
		 * @param newFormat		the format to apply to currFormat while the children are being parsed. If null, currFormat is to be reset.
		 * @param chainedParent whether parent actually corresponds to xmlToParse or has been chained (such as when xmlToParse is a formatting element). See BaseTextLayoutImporter.parseFlowGroupElementChildren
		 * @private
		 */
		static protected function parseChildrenUnderNewActiveFormat(importer:TextFieldHtmlImporter, xmlToParse:XML, parent:IFlowGroupElement, currFormat:TextLayoutFormat, newFormat:ITextLayoutFormat, chainedParent:Boolean = false):void {
			// Remember the current state
			var restoreBaseFontSize:Number = importer._baseFontSize;
			var restoreStyles:Object = PropertyUtil.shallowCopy(currFormat.getStyles());

			if (newFormat) {
				// Update base font size based on the new format
				if (newFormat.fontSize !== undefined)
					importer._baseFontSize = newFormat.fontSize;

				// Apply the new format
				currFormat.apply(newFormat);
			} else {
				// Base font size remains unchanged

				// Reset the new format
				currFormat.clearStyles();
			}

			try {
				var beforeCount:int = parent.numChildren;
				importer.parseFlowGroupElementChildren(xmlToParse, parent, null, chainedParent);
				// if nothing was added create something - otherwise this construct fails <p><b/></p>
				if (beforeCount == parent.numChildren) {
					var span:SpanElement = importer.createImpliedSpan("");
					importer.addChild(parent, span);
				}
			} finally {
				// Restore
				currFormat.setStyles(restoreStyles, false);
				importer._baseFontSize = restoreBaseFontSize;
			}
		}

		/** @private */
		protected override function handleUnknownAttribute(elementName:String, propertyName:String):void {
			// A toss-up: report error or ignore? Ignore for now
			// If we do end up reporting error, we should add exceptions for documented attributes that we don't handle
			// like align on <img/>
		}

		/** @private */
		protected override function handleUnknownElement(name:String, xmlToParse:XML, parent:IFlowGroupElement):void {
			var newParent:IFlowGroupElement;	// scratch
			// Not an error (it may be a styling element like <h1/>); continue parsing children

			// a couple of cases
			// 1) must make a div/spge - if activeFormat or id or stylename is set OR parent is a IListElement (otherwise we wind up trying to put ListItems in a Div which is not supported)
			// 2) may make a div/spge - if more than one child is added to parent OR the added child has an id/stylename/typename
			// 3) otherwise just set the typeName of the single added child

			// Use the value of the 'class' attribute (if present) as styleName
			parseAttributes(xmlToParse, [_classAndIdImporter]);

			// if either class or id is set and its not a "simple" span then we need to create an SPGE and descend
			var classFormatValue:* = _classAndIdImporter.getFormatValue("CLASS");
			var idFormatValue:* = _classAndIdImporter.getFormatValue("ID");

			if (classFormatValue !== undefined || idFormatValue !== undefined || !TextLayoutFormat.isEqual(_activeFormat, TextLayoutFormat.emptyTextLayoutFormat) || (parent is IListElement)) {
				newParent = ((parent is IParagraphElement) || (parent is SubParagraphGroupElementBase)) ? new SubParagraphGroupElement() : new DivElement;
				addChild(parent, newParent);

				newParent.format = _activeFormat;
				newParent.typeName = name.toLowerCase();
				newParent.styleName = classFormatValue;
				newParent.id = idFormatValue;
				parseChildrenUnderNewActiveFormat(this, xmlToParse, newParent, _activeFormat, null);
				return;
			}

			var befNumChildren:int = parent.numChildren;
			parseFlowGroupElementChildren(xmlToParse, parent, null, true);

			// nothing got added - the custom element will be normalized away so just ignore it
			if (befNumChildren == parent.numChildren)
				return;

			if (befNumChildren + 1 == parent.numChildren) {
				// exactly one child was added - just tag it with the typeName if possible
				var addedChild:IFlowElement = parent.getChildAt(befNumChildren);
				if (addedChild.id == null && addedChild.styleName == null && addedChild.typeName == addedChild.defaultTypeName) {
					addedChild.typeName = name.toLowerCase();
					return;
				}
			}

			// have to make one - case 1)
			newParent = ((parent is IParagraphElement) || (parent is SubParagraphGroupElementBase)) ? new SubParagraphGroupElement() : new DivElement;
			newParent.typeName = name.toLowerCase();
			newParent.replaceChildren(0, 0, parent.mxmlChildren.slice(befNumChildren));
			addChild(parent, newParent);
		}

		public override function  parseObject(name:String, xmlToParse:XML, parent:IFlowGroupElement, exceptionElements:Object = null):void {
			// override to allow upper case tag names
			super.parseObject(name.toUpperCase(), xmlToParse, parent, exceptionElements);
		}

		/** @private */
		protected override function checkNamespace(xmlToParse:XML):Boolean {
			/* Ignore namespace */
			return true;
		}

		/** Splits the paragraph wherever a break element occurs and removes the latter
		 * This is to replicate TextField handling of <br/>: splits the containing paragraph (implied or otherwise)
		 * The <br/> itself doesn't survive.
		 * @private
		 */
		static protected function replaceBreakElementsWithParaSplits(para:IParagraphElement):void {
			// performance: when splitting the paragraph into multiple paragraphs take it out of the TextFlow
			var paraArray:Array;
			var paraIndex:int;
			var paraParent:IFlowGroupElement;

			// Find each BreakElement and split into a new paragraph
			var elem:IFlowLeafElement = para.getFirstLeaf();
			while (elem) {
				if (!(elem is BreakElement)) {
					elem = elem.getNextLeaf(para);
					continue;
				}
				if (!paraArray) {
					paraArray = [para];
					paraParent = para.parent;
					paraIndex = paraParent.getChildIndex(para);
					paraParent.removeChildAt(paraIndex);
				}

				// Split the para right after the BreakElement
				// CONFIG::debug { assert(elem.textLength == 1,"Bad TextLength in BreakElement"); }
				CONFIG::debug {
					assert(para.getAbsoluteStart() == 0, "Bad paragraph in replaceBreakElementsWithParaSplits"); }
				para = para.splitAtPosition(elem.getAbsoluteStart() + elem.textLength) as IParagraphElement;
				paraArray.push(para);

				// Remove the BreakElement
				elem.parent.removeChild(elem);

				// point elem to the first leaf of the new paragraph
				elem = para.getFirstLeaf();
			}

			if (paraArray)
				paraParent.replaceChildren(paraIndex, paraIndex, paraArray);
		}

		/** HTML parsing code
		 *  Uses regular expressions for recognizing constructs like comments, tags etc.
		 *  and a hand-coded parser to recognize the document structure and covert to well-formed xml
		 *  TODO-1/16/2009:List caveats
		 */
		/* Regex for stuff to be stripped: a comment, processing instruction, or a declaration
		 *
		 * <!--.*?--> - comment
		 *   <!-- - start comment
		 *   .*? - anything (including newline character, thanks to the s flag); the ? prevents a greedy match (which could match a --> later in the string) 
		 *  --> - end comment
		 *  
		 * <\?(".*?"|'.*?'|[^>]+)*> - processing instruction
		 *   <\? - start processing instruction
		 *   (".*?"|'.*?'|[^>]+)* - 0 or more of the following (interleaved in any order)
		 *     ".*?" - anything (including >) so long as it is within double quotes; the ? prevents a greedy match (which could match everything until a later " in the string) 
		 *     '.*?' - anything (including >) so long as it is within single quotes; the ? prevents a greedy match (which could match everything until a later ' in the string)
		 *     [^>"']+ - one or more characters other than > (because > ends the processing instruction), " (handled above), ' (handled above) 
		 *   > - end processing instruction
		 *
		 * <!(".*?"|'.*?'|[^>"']+)*> - declaration; 
		 * TODO-1/15/2009:not sure if a declaration can contain > within quotes. Assuming it can, the regex is  
		 *  is exactly like processing instruction above except it uses a ! instead of a ?
		 * @private
		 */
		/** @private */
		// Multiline in Javascript can not be done using "s". Using "[^]" instead.
		public static const stripRegex:RegExp = /<!--[^]*?-->|<\?("[^]*?"|'[^]*?'|[^>"']+)*>|<!("[^]*?"|'[^]*?'|[^>"']+)*>/g;
		/* Regular expression for an HTML tag
		 * < - open
		 *
		 * (\/?) - start modifier; 0 or 1 occurance of one of /
		 *
		 * (\w+) - tag name; 1 or more name characters
		 *
		 * ((?:\s+\w+(?:\s*=\s*(?:".*?"|'.*?'|[\w\.]+))?)*) - attributes; 0 or more of the following
		 *   (?:\s+\w+(?:\s*=\s*(?:".*?"|'.*?'|[\w\.]+))?) - attribute; 1 or more space, followed by 1 or more name characters optionally followed by
		 *      \s*=\s*(?:".*?"|'.*?'|[\w\.]+) - attribute value assignment; optional space followed by = followed by more optional space followed by one of
		 *         ".*?" - quoted attribute value (using double quotes); the ? prevents a greedy match (which could match everything until a later " in the string)
		 *         '.*?' - quoted attribute value (using single quotes); the ? prevents a greedy match ((which could match everything until a later ' in the string)
		 *         [\w\.]+ - unquoted attribute value; can only contain name characters or a period
		 *  Note: ?: specifies a non-capturing group (i.e., match won't be recorded or used as a numbered back-reference)
		 *
		 * \s* - optional space
		 *
		 * (\/?) - end modifer (0 or 1 occurance of /)
		 *
		 * > - close
		 * @private
		 */
		/** @private */
		// Multiline in Javascript can not be done using "s". Using "[^]" instead.
		public static const tagRegex:RegExp = /<(\/?)(\w+)((?:\s+\w+(?:\s*=\s*(?:"[^]*?"|'[^]*?'|[\w\.]+))?)*)\s*(\/?)>/g;
		/** Regular expression for an attribute. Except for grouping differences, this regex is the same as the one that appears in tagRegex
		 * @private
		 */
		// Multiline in Javascript can not be done using "s". Using "[^]" instead.
		public static const attrRegex:RegExp = /\s+(\w+)(?:\s*=\s*("[^]*?"|'[^]*?'|[\w\.]+))?/g;
		/** Wrapper for core HTML parsing code that manages XML settings during the process
		 * @private
		 */
		protected function toXML(source:String):XML {
			var xml:XML;

			var originalSettings:Object = XML.settings();
			try {
				XML.ignoreProcessingInstructions = false;
				XML.ignoreWhitespace = false;

				xml = toXMLInternal(source);
			} finally {
				XML.setSettings(originalSettings);
			}

			return xml;
		}

		/** Convert HTML string to well-formed xml, accounting for the following HTML oddities
		 * 
		 * 1) Start tags are optional for some elements.
		 * Optional start tag not specified&lt;/html&gt;
		 * TextField dialect: This is true for all elements. 
		 * 
		 * 2) End tags are optional for some elements. Elements with missing end tags may be implicitly closed by
		 *    a) start-tag for a peer element
		 *    &lt;p&gt;p element without end tag; closed by next p start tag
		 *    &lt;p&gt;closes previous p element with missing end tag&lt;/p&gt;
		 * 
		 *    b) end-tag for an ancestor element 
		 * 	  &lt;html&gt;&lt;p&gt;p element without end tag; closed by next end tag of an ancestor&lt;/html&gt;
		 *     TextField dialect: This is true for all elements. 
		 * 
		 * 3) End tags are forbidden for some elements
		 * &lt;br&gt; and &lt;br/&gt; are valid, but &lt;br&gt;&lt;/br&gt; is not
		 * TextField dialect: Does not apply. 
		 * 
		 * 4) Element and attribute names may use any case
		 * &lt;P ALign="left"&gt;&lt;/p&gt;
		 * 
		 * 5) Attribute values may be unquoted
		 * &lt;p align=left/&gt;
		 * 
		 * 6) Boolean attributed may assume a minimized form
		 * &lt;p selected/&gt; is equivalent to &lt;p selected="selected"/&gt;
		 * @private
		 */
		protected function toXMLInternal(source:String):XML {
			// Strip out comments, processing instructions and declaratins
			source = source.replace(stripRegex, "");

			// Parse the source, looking for tags and interleaved text content, creating an XML hierarchy in the process.
			// At any given time, there is a chain of 'open' elements corresponding to unclosed tags, the innermost of which is
			// tracked by the currElem. Content (element or text) parsed next is added as a child of currElem.

			// Root of the XML hierarchy (set to <html/> because the html start tag is optional)
			// Note that source may contain an html start tag, in which case we'll end up with two such elements
			// This is not quite correct, but handled by the importer
			var root:XML = <HTML/>;
			var currElem:XML = root;

			var lastIndex:int = tagRegex.lastIndex = 0;
			var openElemName:String;

			do {
				var result:Object = tagRegex.exec(source);
				if (!result) {
					// No more tags: add text (starting at search index) as a child of the innermost open element and break out
					appendTextChild(currElem, source.substring(lastIndex));
					break;
				}

				if (result.index != lastIndex) {
					// Add text between tags as a child of the innermost open element
					appendTextChild(currElem, source.substring(lastIndex, result.index));
				}

				var tag:String = result[0]; // entire tag
				var hasStartModifier:Boolean = (result[1] == "\/"); // modifier after < (/ for end tag)
				var name:String = result[2].toUpperCase();  // name; use lower case
				var attrs:String = result[3];  // attributes; including whitespace
				var hasEndModifier:Boolean = (result[4] == "\/"); // modifier before > (/ for composite start and end tag)

				if (!hasStartModifier) // start tag
				{
					// Special case for implicit closing of <p>
					// TODO-12/23/2008: this will need to be handled more generically
					if (name == "P" && currElem.name().localName == "P")
						currElem = currElem.parent();

					// Create an XML element by constructing a tag that can be fed to the XML constructor. Specifically, ensure
					// - it is a composite tag (start and end tag together) using the terminating slash shorthand
					// - element and attribute names are lower case (this is not required, but doesn't hurt)
					// - attribute values are quoted
					// - boolean attributes are fully specified (e.g., selected="selected" rather than selected)
					tag = "<" + name;
					do {
						var innerResult:Object = attrRegex.exec(attrs);
						if (!innerResult)
							break;

						var attrName:String = innerResult[1].toUpperCase();
						tag += " " + attrName + "=";
						var val:String = innerResult[2] ? innerResult[2] : attrName; /* boolean attribute with implied value equal to attribute name */
						var startChar:String = val.charAt(0);
						tag += ((startChar == "'" || startChar == "\"") ? val : ("\"" + val + "\""));
					} while (true);
					tag += "\/>";

					// Add the corresponding element as a child of the innermost open element
					currElem.appendChild(new XML(tag));

					// The new element becomes the innermost open element unless it is already closed because
					// - this is a composite start and end tag (i.e., has an end modifier)
					// - the start tag itself implies closure
					if (!hasEndModifier && !doesStartTagCloseElement(name))
						currElem = currElem.children()[currElem.children().length() - 1];
				} else // end tag
				{
					if (hasEndModifier || attrs.length) {
						reportError(GlobalSettings.resourceStringFunction("malformedTag", [tag]));
					} else {
						/*
						// Does not apply to TextField dialect
						if (isEndTagForbidden(name))
						{
						xxxreportError("End tag is not allowed for element " + name); NOTE : MAKE A LOCALIZABLE ERROR IF THIS COMES BACK
						return null;
						}*/

						// Move up the chain of open elements looking for a matching name
						// The matching element is closed and its parent becomes the innermost open element
						// Report error if matching element is not found and it requires a start tag
						// All intermediate open elements are also closed provided they don't require end tags
						// Report error if an intermediate element requires end tags
						var openElem:XML = currElem;
						do {
							openElemName = openElem.name().localName;
							openElem = openElem.parent();

							if (openElemName == name) {
								currElem = openElem;
								break;
							}
							/*
							// Does not apply to TextField dialect
							else if (isEndTagRequired(openElemName))
							{
							xxxreportError("Missing end tag for element " + openElemName);
							return null;
							}*/

							if (!openElem) {
								// Does not apply to TextField dialect
								/*if (isStartTagRequired(name))
								{
								xxxreportError("Unexpected end tag " + name);
								return null;
								}*/
								break;
							}
						} while (true);
					}
				}

				lastIndex = tagRegex.lastIndex;
				if (lastIndex == source.length)
					break; // string completely parsed
			} while (currElem); // null currElem means <html/> has been closed, so ignore everything else

			// No more string to parse, specifically, no more end tags.
			// Validate that remaining open elements do not require end tags.
			// Does not apply to TextField dialect
			/* while (currElem)
			{
			openElemName = currElem.name().localName; 
			if (isEndTagRequired(openElemName))
			{
			xxxreportError("Missing end tag for element " + openElemName);
			return null;
			}
			currElem = currElem.parent();
			}*/

			return root;
		}

		/** @private */
		protected function doesStartTagCloseElement(tagName:String):Boolean {
			switch (tagName) {
				case "BR":
				case "IMG":
					return true;
				default:
					return false;
			}
		}

		/** @private */
		public static const anyPrintChar:RegExp = /[^\u0009\u000a\u000d\u0020]/g;
		/** Adds text as a descendant of the specified XML element. Adds an intermediate <span> element is created if parent is not a <span>
		 *  No action is taken for whitespace-only text
		 * @private
		 */
		protected function appendTextChild(parent:XML, text:String):void {
			// No whitespace collapse
			// if (text.match(anyPrintChar).length != 0)
			{
				var parentIsSpan:Boolean = (parent.localName() == "SPAN");
				var elemName:String = parentIsSpan ? "DUMMY" : "SPAN";

				// var xml:XML = <{elemName}/>;
				// xml.appendChild(text);
				// The commented-out code above doesn't handle character entities like &lt;
				// The following lets the XML constructor handle them
				var xmlText:String = "<" + elemName + ">" + text + "<\/" + elemName + ">";
				try {
					var xml:XML = new XML(xmlText);
					parent.appendChild(parentIsSpan ? xml.children()[0] : xml);
				} catch (e:*) {
					// Report malformed content like "<" instead of "&lt;"
					reportError(GlobalSettings.resourceStringFunction("malformedMarkup", [text]));
				}
					
			}
		}
	}
}
