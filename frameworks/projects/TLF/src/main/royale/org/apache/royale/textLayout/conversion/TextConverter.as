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
	import org.apache.royale.textLayout.elements.IConfiguration;
	import org.apache.royale.textLayout.elements.ITextFlow;
	import org.apache.royale.textLayout.elements.TextFlow;

	

	
	/** 
	 * This is the gateway class for handling import and export. It serves as a unified access point to the 
	 * conversion functionality in the Text Layout Framework. It contains a registry for predefined as well
	 * as user defined input and/or output converters, plus a set of conversion methods.
	 * <p>
	 * The format of the converted data is not predefined; user written converters are free to accept and return
	 * any format of their choice. Common formats are strings, XML, and ByteArray instances. Converter authors 
	 * should document which formats are supported.
	 * </p>
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 */
	public class TextConverter
	{
		/** 
		 * HTML format.
		 * Use this for importing from, or exporting to, a TextFlow using the HTML fomat.
		 * The Text Layout Framework HTML supports a subset of the tags and attributes supported by
		 * the TextField class in the <code>flash.text</code> package.
		 * <p>The following table lists the HTML tags and attributes supported for the import
		 * and export process (tags and attributes supported by TextField, but not supported by 
		 * the Text Layout Framework are specifically described as not supported):</p>
		 * 
		 * 
		 * <table class="innertable" width="640">
		 * 
		 * <tr>
		 * 
		 * <th>
		 * Tag
		 * </th>
		 * 
		 * <th>
		 * Description
		 * </th>
		 * 
		 * </tr>
		 * 
		 * <tr>
		 * 
		 * <td>
		 * Anchor tag
		 * </td>
		 * 
		 * <td>
		 * The <code>&lt;a&gt;</code> tag creates a hypertext link and supports the following attributes:
		 * <ul>
		 * 
		 * <li>
		 * <code>target</code>: Specifies the name of the target window where you load the page. 
		 * Options include <code>_self</code>, <code>_blank</code>, <code>_parent</code>, and 
		 * <code>_top</code>. The <code>_self</code> option specifies the current frame in the current window, 
		 * <code>_blank</code> specifies a new window, <code>_parent</code> specifies the parent of the 
		 * current frame, and <code>_top</code> specifies the top-level frame in the current window. 
		 * </li>
		 *
		 * <li>
		 * <code>href</code>: Specifies a URL. The URL can 
		 * be either absolute or relative to the location of the SWF file that 
		 * is loading the page. An example of an absolute reference to a URL is 
		 * <code>http://www.adobe.com</code>; an example of a relative reference is 
		 * <code>/index.html</code>. Absolute URLs must be prefixed with 
		 * http://; otherwise, Flash treats them as relative URLs. 
		 * <strong>Note: Unlike the TextField class, </strong>ActionScript <code>link</code> events 
		 * are not supported. Neither are
		 * <code>a:link</code>, <code>a:hover</code>, and <code>a:active</code> styles.
		 * </li>
		 * 
		 * </ul>
		 * 
		 * </td>
		 * </tr>
		 * 
		 * <tr>
		 * 
		 * <td>
		 * Bold tag
		 * </td>
		 * 
		 * <td>
		 * The <code>&lt;b&gt;</code> tag renders text as bold. A bold typeface must be available for the font used.
		 * </td>
		 * </tr>
		 * 
		 * <tr>
		 * 
		 * <td>
		 * Break tag
		 * </td>
		 * <td>
		 * The <code>&lt;br&gt;</code> tag creates a line break in the text.
		 * </td>
		 * </tr>
		 * 
		 * <tr>
		 * 
		 * <td>
		 * Font tag
		 * </td>
		 * 
		 * <td>
		 * The <code>&lt;font&gt;</code> tag specifies a font or list of fonts to display the text.The font tag 
		 * supports the following attributes:
		 * <ul>
		 * 
		 * <li>
		 * <code>color</code>: Only hexadecimal color (<code>#FFFFFF</code>) values are supported. 
		 * </li>
		 * 
		 * <li>
		 * <code>face</code>: Specifies the name of the font to use. As shown in the following example, 
		 * you can specify a list of comma-delimited font names, in which case Flash Player selects the first available 
		 * font. If the specified font is not installed on the local computer system or isn't embedded in the SWF file, 
		 * Flash Player selects a substitute font. 
		 * </li>
		 * 
		 * <li>
		 * <code>size</code>: Specifies the size of the font. You can use absolute pixel sizes, such as 16 or 18 
		 * or relative point sizes, such as +2 or -4. 
		 * </li>
		 * 
		 * <li>
		 * <code>letterspacing</code>: Specifies the tracking (manual kerning) in pixels to be applied to the right of each character. 
		 * </li>
		 * 
		 * <li>
		 * <code>kerning</code>: Specifies whether kerning is enabled or disabled. A non-zero value enables kerning, while zero disables it.  
		 * </li>
		 * 
		 * </ul>
		 * 
		 * </td>
		 * </tr>
		 * 
		 * <tr>
		 * 
		 * <td>
		 * Image tag
		 * </td>
		 * 
		 * <td>
		 * The <code>&lt;img&gt;</code> tag lets you embed external image files (JPEG, GIF, PNG), SWF files, and 
		 * movie clips inside text.  
		 * 
		 *  <p>The <code>&lt;img&gt;</code> tag supports the following attributes: </p>
		 * 
		 * <ul >
		 * 
		 * <li>
		 * <code>src</code>: Specifies the URL to an image or SWF file, or the linkage identifier for a movie clip 
		 * symbol in the library. This attribute is required; all other attributes are optional. External files (JPEG, GIF, PNG, 
		 * and SWF files) do not show until they are downloaded completely. 
		 * </li>
		 * 
		 * <li>
		 * <code>width</code>: The width of the image, SWF file, or movie clip being inserted, in pixels. 
		 * </li>
		 * 
		 * <li>
		 * <code>height</code>: The height of the image, SWF file, or movie clip being inserted, in pixels. 
		 * </li>
		 * </ul>
		 * <p><strong>Note: </strong> Unlike the TextField class, the following attributes are not supported:
		 * <code>align</code>, <code>hspace</code>, <code>vspace</code>,  <code>id</code>, and <code>checkPolicyFile</code>.</p>
		 *
		 * </td>
		 * </tr>
		 * 
		 * <tr>
		 * 
		 * <td>
		 * Italic tag
		 * </td>
		 * 
		 * <td>
		 * The <code>&lt;i&gt;</code> tag displays the tagged text in italics. An italic typeface must be available 
		 * for the font used.
		 * </td>
		 * </tr>
		 * 
		 * <tr>
		 * 
		 * <td>
		 * <em>List item tag</em>
		 * </td>
		 * 
		 * <td>
		 * <strong>Note: </strong> Unlike the TextField class, the List item tag is not supported.
		 * </td>
		 * </tr>
		 * 
		 * <tr>
		 * 
		 * <td>
		 * Paragraph tag
		 * </td>
		 * 
		 * <td>
		 * The <code>&lt;p&gt;</code> tag creates a new paragraph. 
		 * 
		 * The <code>&lt;p&gt;</code> tag supports the following attributes:
		 * <ul >
		 * 
		 * <li>
		 * align: Specifies alignment of text within the paragraph; valid values are <code>left</code>, <code>right</code>, <code>justify</code>, and <code>center</code>. 
		 * </li>
		 * 
		 * <li>
		 * class: Specifies a class name that can be used for styling 
		 * </li>
		 * 
		 * </ul>
		 * 
		 * </td>
		 * </tr>
		 * 
		 * <tr>
		 * 
		 * <td>
		 * Span tag
		 * </td>
		 * 
		 * <td>
		 * 
		 * The <code>&lt;span&gt;</code> tag supports the following attributes:
		 * 
		 * <ul>
		 * 
		 * <li>
		 * class: Specifies a class name that can be used for styling. While span tags are often used to set a style defined in a style sheet,
		 * TLFTextField instances do not support style sheets. The span tag is available for TLFTextField instances to refer to a class with 
		 * style properties.</li>
		 * <li> You can also put properties directly in the span tag: 
		 * <code>&lt;span fontFamily="Arial"&gt;Hi there&lt;/span&gt;</code>. However, nested span tags are not supported.
		 * </li>
		 * 
		 * </ul>
		 * 
		 * </td>
		 * </tr>
		 * 
		 * <tr>
		 * 
		 * <td>
		 * Text format tag
		 * </td>
		 * 
		 * <td>
		 *  <p>The <code>&lt;textformat&gt;</code> tag lets you use a subset of paragraph formatting 
		 * properties of the TextFormat class within text fields, including line leading, indentation, 
		 * margins, and tab stops. You can combine <code>&lt;textformat&gt;</code> tags with the 
		 * built-in HTML tags. </p>
		 * 
		 *  <p>The <code>&lt;textformat&gt;</code> tag has the following attributes: </p>
		 * <ul >
		 * 
		 * 
		 * <li>
		 * <code>indent</code>: Specifies the indentation from the left margin to the first character 
		 * in the paragraph; corresponds to <code>TextFormat.indent</code>. Both positive and negative 
		 * numbers are acceptable. 
		 * </li>
		 * 
		 * <li>
		 * <code>blockindent</code>: Specifies the indentation applied to all lines of the paragraph.
		 * </li>
		 * 
		 * <li>
		 * <code>leftmargin</code>: Specifies the left margin of the paragraph, in points; corresponds 
		 * to <code>TextFormat.leftMargin</code>. 
		 * </li>
		 * 
		 * <li>
		 * <code>rightmargin</code>: Specifies the right margin of the paragraph, in points; corresponds 
		 * to <code>TextFormat.rightMargin</code>. 
		 * </li>
		 * 
		 * 	<li>
		 * <code>leading</code>: Specifies the leading (line height) measured in pixels between a line's ascent and the previous line's descent
		 * </li>
		 * 
		 * 	<li>
		 * <code>tabstops</code>: Specifies a comma-separated list of tab stop positions for the paragraph. 
		 * </li>
		 * </ul>
		 * 
		 * </td>
		 * </tr>
		 * 
		 * <tr>
		 * 
		 * <td>
		 * Underline tag
		 * </td>
		 * 
		 * <td>
		 * The <code>&lt;u&gt;</code> tag underlines the tagged text.
		 * </td>
		 * </tr>
		 * 
		 * </table>
		 * 
		 * <p>When an unknown tag is imported the <code>textFieldHTMLFormat</code> importer will either set a single FlowElement's typeName property to that tag name
		 * or create a DivElement or a SubParagraphGroupElement with its typeName property set to the tag name.</p>
		 * <p>The <code>textFieldHTMLFormat</code> exporter will export <code>typeName</code> as the XML tag when it is different from the default.</p>
		 * 
		 * @see org.apache.royale.textLayout.elements.FlowElement#typeName
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		 */
		public static const TEXT_FIELD_HTML_FORMAT:String = "textFieldHTMLFormat";

		/** 
		 * Plain text format.
		 * Use this for creating a TextFlow from a simple, unformatted String, 
		 * or for creating a simple, unformatted String from a TextFlow.
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		 */
		public static const PLAIN_TEXT_FORMAT:String = "plainTextFormat";

		/** 
		 * TextLayout Format.
		 * Use this for importing from, or exporting to, a TextFlow using the TextLayout markup format.
		 * Text Layout format will detect the following errors:
		 * <ul>
		 * <li>Unexpected namespace</li>
		 * <li>Unknown element</li>
		 * <li>Unknown attribute</li>
		 * </ul>
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		 */
		public static const TEXT_LAYOUT_FORMAT:String = "textLayoutFormat";
		
		// Descriptors - ordered list of all FormatDescriptors
		/** @private */
		static private var _descs:Array = [];

		// register standard importers and exporters
		setFormatsToDefault();
		
		/** @private */
		static public function setFormatsToDefault():void	// No PMD
		{
			_descs = [];
			addFormat(TEXT_LAYOUT_FORMAT, TextLayoutImporter, TextLayoutExporter, TEXT_LAYOUT_FORMAT, _descs);
			addFormat(TEXT_FIELD_HTML_FORMAT, TextFieldHtmlImporter,  TextFieldHtmlExporter, null, _descs);
			addFormat(PLAIN_TEXT_FORMAT, PlainTextImporter, PlainTextExporter, "air:text", _descs);
		}
		
		static public function get descArray():Array
		{
			if(_descs.length == 0) {
				setFormatsToDefault();
			}
			return _descs;
		}
		
		/** 
		 * Creates a TextFlow from source content in a specified format.
		 * <p>Use one of the static constants supplied with this class, a MIME type,
		 * to specify the <code>format</code> parameter, or use a user defined
		 * value for user-registered importers:
		 * <ul>
		 * <li>TextConverter.TEXT_FIELD_HTML_FORMAT</li>
		 * <li>TextConverter.PLAIN_TEXT_FORMAT</li>
		 * <li>TextConverter.TEXT_LAYOUT_FORMAT</li>
		 * </ul>
		 * </p>
		 * @param source	Source content
		 * @param format	Format of source content
		 * @param config    IConfiguration to use when creating new TextFlows
		 * @return TextFlow that was created from the source, or null on errors.
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 * @see #TEXT_FIELD_HTML_FORMAT
		 * @see #PLAIN_TEXT_FORMAT
		 * @see #TEXT_LAYOUT_FORMAT
		 */
		public static function importToFlow(source:Object, format:String, config:IConfiguration = null):ITextFlow
		{
			var parser:ITextImporter = getImporter(format, config);
			if (!parser)
				return null;
			parser.throwOnError = false;
			return parser.importToFlow(source);
		}
		
		/** 
		 * Exports a TextFlow to a specified format. 
		 * <p>Use one of the static constants supplied with this class, a MIME type,
		 * or a user defined format for user defined exporters to specify 
		 * the <code>format</code> parameter:
		 * <ul>
		 * <li>TextConverter.TEXT_FIELD_HTML_FORMAT</li>
		 * <li>TextConverter.PLAIN_TEXT_FORMAT</li>
		 * <li>TextConverter.TEXT_LAYOUT_FORMAT</li>
		 * </ul>
		 * </p>
		 * <p>Specify the type of the exported data in the <code>conversionType</code> parameter 
		 * with one of the static constants supplied by the ConversionType class, or a user defined
		 * data type for user defined exporters:
		 * <ul>
		 * <li>ConversionType.STRING_TYPE</li>
		 * <li>ConversionType.XML_TYPE</li>
		 * </ul>
		 * </p>
		 * 
		 * Returns a representation of the TextFlow in the specified format, or null on errors.
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		 * @param source	Source content
		 * @param format	Output format
		 * @param conversionType	Type of exported data
		 * @return Object	Exported form of the TextFlow, or null on errors
		 * @see #TEXT_FIELD_HTML_FORMAT
		 * @see #PLAIN_TEXT_FORMAT
		 * @see #TEXT_LAYOUT_FORMAT
		 * @see org.apache.royale.textLayout.conversion.ConversionType
		 */
		public static function export(source:TextFlow, format:String, conversionType:String) : Object
		{
			var exporter:ITextExporter = getExporter(format);
			if (!exporter)
				return null;
			exporter.throwOnError = false;
			return exporter.export(source, conversionType);
		}
		
		/** 
		 * Creates and returns an import converter, which you can then use to import from a 
		 * source string, an XML object, or any user defined data formats to a TextFlow. 
		 * Use this method if you have many separate imports to perform, or if you want to 
		 * handle errors during import. It is equivalent to calling 
		 * <code>org.apache.royale.textLayout.conversion.TextConverter.importToFlow()</code>.
		 * <p>Use one of the static constants supplied with this class
		 * to specify the <code>format</code> parameter, a MIME type, or a user defined
		 * data format.
		 * <ul>
		 * <li>TextConverter.TEXT_FIELD_HTML_FORMAT</li>
		 * <li>TextConverter.PLAIN_TEXT_FORMAT</li>
		 * <li>TextConverter.TEXT_LAYOUT_FORMAT</li>
		 * </ul>
		 * </p>
		 * <p>If the format has been added multiple times, the first one found will be used.</p>
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		 * @param format	Format of source content. Use constants from 
		 * 					org.apache.royale.textLayout.conversion.TextConverter.TEXT_LAYOUT_FORMAT, PLAIN_TEXT_FORMAT, TEXT_FIELD_HTML_FORMAT etc,
		 * 					a MIME type, or a user defined format.
		 * @param config    configuration to use during this import. null means take the current default.
		 * 					You can also set the configuration via the <code>ITextImporter.configuration</code>
		 * 					property.
		 * @return ITextImporter	Text importer that can import the source data
		 * @see #TEXT_FIELD_HTML_FORMAT
		 * @see #PLAIN_TEXT_FORMAT
		 * @see #TEXT_LAYOUT_FORMAT
		 */
		public static function getImporter(format:String,config:IConfiguration =  null): ITextImporter
		{
			var importer:ITextImporter = null;
			var i:int = findFormatIndex(format);
			if (i >= 0)
			{
				var descriptor:FormatDescriptor = descArray[i];
				if (descriptor && descriptor.importerClass)
				{
					importer = new descriptor.importerClass();
					importer.configuration = config;
				}
			}
			return importer;
		}

		/** 
		 * Creates and returns an export converter, which you can then use to export from 
		 * a TextFlow to a source string or XML object. Use this function if 
		 * you have many separate exports to perform. It is equivalent to calling 
		 * <code>org.apache.royale.textLayout.conversion.TextConverter.export()</code>.
		 * <p>Use one of the static constants supplied with this class
		 * to specify the <code>format</code> parameter:
		 * <ul>
		 * <li>TextConverter.TEXT_FIELD_HTML_FORMAT</li>
		 * <li>TextConverter.PLAIN_TEXT_FORMAT</li>
		 * <li>TextConverter.TEXT_LAYOUT_FORMAT</li>
		 * </ul>
		 * </p>
		 * <p>If the format has been added multiple times, the first one found will be used.</p>
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		 * @param format	Target format for exported data
		 * @return ITextExporter	Text exporter that can export in the specified format
		 * @see #TEXT_FIELD_HTML_FORMAT
		 * @see #PLAIN_TEXT_FORMAT
		 * @see #TEXT_LAYOUT_FORMAT
		 */
		public static function getExporter(format:String) : ITextExporter
		{
			var exporter:ITextExporter = null;
			var i:int = findFormatIndex(format);
			if (i >= 0)
			{
				var descriptor:FormatDescriptor = descArray[i];
				if (descriptor && descriptor.exporterClass)
					exporter = new descriptor.exporterClass();
			}
			return exporter;
		}

		/**
		 * Register a new format for import/export, at the specified location.
		 * Location can be significant for clients that have multiple 
		 * choices for which format to use, such as when importing from the external clipboard. 
		 * Lower numbers indicate higher priority; these converters will be tried first.
		 * The new format may support importing and/or exporting.
		 * If the format has already been added, then it will be present in multiple locations. The 
		 * first one found will be used.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 * @param importClass    The import converter class to register or null
		 * @param exportClass    The export converter class to register or null
		 * @param format         The format string tagging the converter classes
		 * @param clipboardFormat	The string used as the clipboard format when converting to/from the clipboard. Make this null if the format doesn't support clipboard access.
		 */
		public static function addFormatAt(index:int, format:String, importerClass:Class, exporterClass:Class = null, clipboardFormat:String = null, arr:Array = null):void
		{
			var descriptor:FormatDescriptor = new FormatDescriptor(format, importerClass, exporterClass, clipboardFormat);
			
			if(arr != null) {
				arr.splice(index, 0, descriptor);
			} else {
				descArray.splice(index, 0, descriptor);
			}
			//descArray.splice(index, 0, descriptor);
		}
		
		/**
		 * Register a new format for import/export. The new format will be added at the end,
		 * as the lowest priority. Location can be significant for clients that have multiple 
		 * choices for which format to use, such as when importing from the external clipboard. 
		 * The new format may support importing and/or exporting.
		 * If the format has already been added, then it will be present in multiple locations. The 
		 * first one found will be used.
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 * @param importClass    The import converter class to register or null
		 * @param exportClass    The export converter class to register or null
		 * @param format         The format string tagging the converter classes. Formats can be any name, but must be unique. 
		 * @param clipboardFormat	The string used as the clipboard format when converting to/from the clipboard. Make this null if the format doesn't support clipboard access.
		 */
		public static function addFormat(format:String, importerClass:Class, exporterClass:Class, clipboardFormat:String, arr:Array = null):void
		{
			if(arr != null) {
				addFormatAt(arr.length, format, importerClass, exporterClass, clipboardFormat, arr);
			} else {
				addFormatAt(descArray.length, format, importerClass, exporterClass, clipboardFormat);
			}
			// addFormatAt(arr.length, format, importerClass, exporterClass, clipboardFormat);
		}
		
		/**
		 * Remove the format at the index location. 
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 * @param index     The format to remove
		 */
		public static function removeFormatAt(index:int):void
		{
			if (index >= 0 && index < descArray.length)
				descArray.splice(index, 1);
		}

		private static function findFormatIndex(format:String):int
		{
			for (var i:int = 0; i < numFormats; i++)
			{
				if (descArray[i].format == format)
					return i;
			}
			return -1;
		}
		/**
		 * Remove the format. 
		 * If a format was added multiple times, only the first one found is removed.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 * @param format     The converter format string to remove
		 */
		public static function removeFormat(format:String):void
		{
			removeFormatAt(findFormatIndex(format));
		}
		
		/** Returns the format name for the index'th format.
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
	     */
		public static function getFormatAt(index:int):String
		{
			return descArray[index].format;
		}

		/** Returns the FormatDescriptor for the index'th format. 
		* @playerversion Flash 10
		* @playerversion AIR 1.5
		* @langversion 3.0 
		*/
		public static function getFormatDescriptorAt(index:int):FormatDescriptor
		{
			return descArray[index];
		}
	
		/** Number of formats.
		* @playerversion Flash 10
		* @playerversion AIR 1.5
		* @langversion 3.0 
		*/
		public static function get numFormats():int
		{
			return descArray.length;
		}
	}
}
