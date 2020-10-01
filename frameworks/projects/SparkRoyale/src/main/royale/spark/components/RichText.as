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

package spark.components
{
/*
import flash.display.DisplayObject;
import flash.text.TextFormat;

import flashx.textLayout.compose.ISWFContext;
import flashx.textLayout.conversion.ConversionType;
import flashx.textLayout.conversion.ITextExporter;
import flashx.textLayout.elements.Configuration;
import flashx.textLayout.elements.GlobalSettings;
*/
import mx.core.mx_internal;
import mx.styles.IStyleClient;

import spark.components.supportClasses.TextBase;
import spark.core.CSSTextLayoutFormat;

import org.apache.royale.text.engine.ITextLine;
import org.apache.royale.textLayout.conversion.ITextImporter;
import org.apache.royale.textLayout.conversion.TextConverter;
import org.apache.royale.textLayout.elements.ITextFlow;
import org.apache.royale.textLayout.elements.TextFlow;
import org.apache.royale.textLayout.events.DamageEvent;
import org.apache.royale.textLayout.factory.StringTextLineFactory;
import org.apache.royale.textLayout.factory.TLFFactory;
import org.apache.royale.textLayout.factory.StandardTLFFactory;
import org.apache.royale.textLayout.factory.TextFlowTextLineFactory;
import org.apache.royale.textLayout.factory.TextLineFactoryBase;
import org.apache.royale.textLayout.formats.ITextLayoutFormat;

use namespace mx_internal;

COMPILE::JS
{
    import org.apache.royale.html.util.addElementToWrapper;
    import org.apache.royale.core.WrappedHTMLElement;        
}
import org.apache.royale.events.Event;        

//--------------------------------------
//  Styles
//--------------------------------------
/*
include "../styles/metadata/BasicInheritingTextStyles.as"
include "../styles/metadata/BasicNonInheritingTextStyles.as"
include "../styles/metadata/AdvancedInheritingTextStyles.as"
include "../styles/metadata/AdvancedNonInheritingTextStyles.as"
*/
//--------------------------------------
//  Other metadata
//--------------------------------------

[DefaultProperty("content")]

//[IconFile("RichText.png")]

//[DiscouragedForProfile("mobileDevice")]

/**
 *  RichText is a low-level UIComponent that can display one or more lines
 *  of richly-formatted text and embedded images.
 *
 *  <p>For performance reasons, it does not support scrolling,
 *  selection, editing, clickable hyperlinks, or images loaded from URLs.
 *  If you need those capabilities, please see the RichEditableText
 *  class.</p>
 *
 *  <p>RichText uses the Text Layout Framework (TLF) library, which in turn builds on
 *  the Flash Text Engine (FTE) in Flash Player 10.
 *  In combination, they provide rich text layout using
 *  high-quality international typography.</p>
 *
 *  <p>The Spark architecture provides three text "primitives" -- 
 *  Label, RichText, and RichEditableText.
 *  Label is the fastest and most lightweight
 *  because it uses only FTE, not TLF,
 *  but it is limited in its capabilities: no rich text,
 *  no scrolling, no selection, and no editing.
 *  RichText adds the ability to display rich text
 *  with complex layout, but is still completely non-interactive.
 *  RichEditableText is the heaviest-weight,
 *  but offers most of what TLF can do.
 *  You should use the lightest-weight text primitive that meets your needs.</p>
 *
 *  <p>RichText is similar to the MX control mx.controls.Text.
 *  The Text control uses the older TextField class, instead of TLF,
 *  to display text.</p>
 *
 *  <p>The most important differences between RichText and Text are:
 *  <ul>
 *    <li>RichText offers better typography, better support
 *        for international languages, and better text layout than Text.</li>
 *    <li>RichText has an object-oriented model of what it displays,
 *        while Text does not.</li>
 *    <li>Text is selectable, while RichText does not support selection.</li>
 *  </ul></p>
 *
 *  <p>RichText uses TLF's object-oriented model of rich text,
 *  in which text layout elements such as divisions, paragraphs, spans,
 *  and images are represented at runtime by ActionScript objects
 *  which can be programmatically accessed and manipulated.
 *  The central object in TLF for representing rich text is a
 *  TextFlow, and you specify what RichText should display
 *  by setting its <code>textFlow</code> property to a TextFlow instance.
 *  (Please see the description of the <code>textFlow</code>
 *  property for information about how to create one.)
 *  You can also set the <code>text</code> property that
 *  is inherited from TextBase, but if you don't need
 *  the richness of a TextFlow, you should consider using
 *  Label instead.</p>
 *
 *  <p>At compile time, you can put TLF markup tags inside
 *  the RichText tag, as the following example shows:
 *  <pre>
 *  &lt;s:RichText&gt;Hello &lt;s:span fontWeight="bold"&gt;World!&lt;/s:span&gt;&lt;/s:RichText&gt;
 *  </pre>
 *  In this case, the MXML compiler sets the <code>content</code>
 *  property, causing a TextFlow to be automatically created
 *  from the FlowElements that you specify.</p>
 *
 *  <p>The default text formatting is determined by CSS styles
 *  such as <code>fontFamily</code>, <code>fontSize</code>.
 *  Any formatting information in the TextFlow overrides
 *  the default formatting provided by the CSS styles.</p>
 *
 *  <p>You can control the spacing between lines with the
 *  <code>lineHeight</code> style and the spacing between
 *  paragraphs with the <code>paragraphSpaceBefore</code>
 *  and <code>paragraphSpaceAfter</code> styles.
 *  You can align or justify the text using the <code>textAlign</code>
 *  and <code>textAlignLast</code> styles.
 *  You can inset the text from the component's edges using the
 *  <code>paddingLeft</code>, <code>paddingTop</code>, 
 *  <code>paddingRight</code>, and <code>paddingBottom</code> styles.</p>
 *
 *  <p>If you don't specify any kind of width for a RichText,
 *  then the longest line, as determined by these explicit line breaks,
 *  determines the width of the Label.</p>
 *
 *  <p>When you specify a width, the text wraps at the right
 *  edge of the component and the text is clipped when there is more
 *  text than fits.
 *  If you set the <code>lineBreak</code> style to <code>explicit</code>,
 *  new lines will start only at explicit lines breaks, such as
 *  if you use CR (<code>\r</code>), LF (<code>\n</code>),
 *  or CR+LF (<code>\r\n</code>) in <code>text</code>
 *  or if you use <code>&lt;p&gt;</code> and <code>&lt;br/&gt;</code>
 *  in TLF markup. In that case, lines that are wider than the control
 *  are clipped.</p>
 *
 *  <p>If you have more text than you have room to display it,
 *  RichText can truncate the text for you.
 *  Truncating text means replacing excess text
 *  with a truncation indicator such as "...".
 *  See the inherited properties <code>maxDisplayedLines</code>
 *  and <code>isTruncated</code>.</p>
 *
 *  <p>By default,RichText has no background,
 *  but you can draw one using the <code>backgroundColor</code>
 *  and <code>backgroundAlpha</code> styles.
 *  Borders are not supported.
 *  If you need a border, or a more complicated background, use a separate
 *  graphic element, such as a Rect, behind the RichText.</p>
 *
 *  <p>Because RichText uses TLF,
 *  it supports displaying left-to-right (LTR) text such as French,
 *  right-to-left (RTL) text such as Arabic, and bidirectional text
 *  such as a French phrase inside of an Arabic one.
 *  If the predominant text direction is right-to-left,
 *  set the <code>direction</code> style to <code>rtl</code>.
 *  The <code>textAlign</code> style defaults to <code>"start"</code>,
 *  which makes the text left-aligned when <code>direction</code>
 *  is <code>ltr</code> and right-aligned when <code>direction</code>
 *  is <code>rtl</code>.
 *  To get the opposite alignment,
 *  set <code>textAlign</code> to <code>end</code>.</p>
 *
 *  <p>RichText uses TLF's StringTextFlowFactory and TextFlowTextLineFactory
 *  classes to create one or more TextLine objects to statically display
 *  its text.
 *  For performance, its TextLines do not contain information
 *  about individual glyphs; for more info, see the TextLineValidity class.</p>
 *
 *  <p>To use this component in a list-based component, such as a List or DataGrid, 
 *  create an item renderer.
 *  For information about creating an item renderer, see 
 *  <a href="http://help.adobe.com/en_US/flex/using/WS4bebcd66a74275c3-fc6548e124e49b51c4-8000.html">
 *  Custom Spark item renderers</a>. </p>
 *  
 *  @mxml
 *
 *  <p>The <code>&lt;s:RichText&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;s:RichText
 *    <strong>Properties</strong>
 *    luminosityClip="false"
 *    luminosityInvert="false"
 *    maskType="MaskType.CLIP"
 *    textFlow="<i>TextFlow</i>"
 *  /&gt;
 *  </pre>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 *
 *  @see spark.components.RichEditableText
 *  @see spark.components.Label
 *  @see flash.text.engine.TextLineValidity
 *  
 *  @includeExample examples/RichTextExample.mxml
 */
public class RichText extends TextBase implements IStyleClient
{
//    include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private static var classInitialized:Boolean = false;
    
    /**
     *  @private
     *  This TLF object composes TextLines from a text String.
     *  We use it when the 'text' property is set to a String
     *  that doesn't contain linebreaks.
     */
    private static var staticStringFactory:StringTextLineFactory;
    
    /**
     *  @private
     *  This TLF object composes TextLines from a TextFlow.
     *  We use it when the 'textFlow' or 'content' property is set,
     *  and when the 'text' property is set to a String
     *  that contains linebreaks (and therefore is interpreted
     *  as multiple paragraphs).
     */
    private static var staticTextFlowFactory:TextFlowTextLineFactory;
    
    /**
     *  @private
     *  This TLF object is used to import a 'text' String
     *  containing linebreaks to create a multiparagraph TextFlow.
     */
    private static var staticPlainTextImporter:ITextImporter;
    
    /**
     *  @private
     *  This TLF object is used to export a TextFlow as plain 'text',
     *  by walking the leaf FlowElements in the TextFlow.
     */
    //private static var staticPlainTextExporter:ITextExporter;
    
    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     *  This method initializes the static vars of this class.
     *  Rather than calling it at static initialization time,
     *  we call it in the constructor to do the class initialization
     *  when the first instance is created.
     *  (It does an immediate return if it has already run.)
     *  By doing so, we avoid any static initialization issues
     *  related to whether this class or the TLF classes
     *  that it uses are initialized first.
     */
    private static function initClass():void
    {
        if (classInitialized)
            return;

        if (!TLFFactory.defaultTLFFactory)
            TLFFactory.defaultTLFFactory = new StandardTLFFactory();        

        // Set the TLF hook used for localizing runtime error messages.
        // TLF itself has English-only messages,
        // but higher layers like Flex can provide localized versions.
        //GlobalSettings.resourceStringFunction = TextUtil.getResourceString;

        // Set the TLF hook used to specify the callback used for changing 
        // the FontLookup based on SWFContext.  
        //GlobalSettings.resolveFontLookupFunction = TextUtil.resolveFontLookup;

        // Pre-FP10.1, set default tab stops in TLF.  Without this, if there
        // is a tab and TLF is measuring width, the tab will
        // measure as the rest of the remaining width up to 10000.
        //GlobalSettings.enableDefaultTabStops = !Configuration.playerEnablesArgoFeatures;
        
        staticStringFactory = new StringTextLineFactory();
        
        staticTextFlowFactory = new TextFlowTextLineFactory();
        
        staticPlainTextImporter =
            TextConverter.getImporter(TextConverter.PLAIN_TEXT_FORMAT);
        
        //staticPlainTextExporter =
        //    TextConverter.getExporter(TextConverter.PLAIN_TEXT_FORMAT);
            
        classInitialized = true;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function RichText()
    {
        super();
        
        initClass();
        
        text = "";
        
        addEventListener("sizeChanged", sizeChangedHandler);
    }
    
    private function sizeChangedHandler(event:Event):void
    {
        updateDisplayList(width, height);
    }
        
    COMPILE::JS
    override protected function createElement():WrappedHTMLElement
    {
        addElementToWrapper(this,'div');
                
        return element;
    }

    override public function addedToParent():void
    {
        super.addedToParent();
        commitProperties();
        if (isWidthSizedToContent() && isHeightSizedToContent())
            updateDisplayList(getExplicitOrMeasuredWidth(), getExplicitOrMeasuredHeight());
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     *  This object determines the default text formatting used
     *  by this component, based on its CSS styles.
     *  It is set to null by stylesInitialized() and styleChanged(),
     *  and recreated whenever necessary in commitProperties().
     */
    private var hostFormat:ITextLayoutFormat;

    /**
     *  @private
     *  Holds the last recorded value of the textFlow generation for _textFlow.  
     *  Used to determine whether to return immediately from damage event if 
     *  there have been no changes.
     */
    private var lastGeneration:uint = 0;    // 0 means not set
        
    /**
     *  @private
     *  Holds the last recorded value of the module factory
     *  used to create the font.
     */
    //mx_internal var embeddedFontContext:IFlexModuleFactory;
    
    /**
     *  @private
     *  Specifies whether the StringTextLineFactory
     *  or the TextFlowTextLineFactory is used to create the TextLines.
     *  A StringTextLineFactory is more efficient; it is used
     *  by default to render the default text ""
     *  and when 'text' is set to a string without linebreaks;
     *  otherwise, a TextFlowTextLineFactory is used.
     */
    private var factory:TextLineFactoryBase;

    /**
     *  @private
     *  If true, the damage handler will return immediately.
     */
    private var ignoreDamageEvent:Boolean;
    
    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  text
    //----------------------------------

    // Compiler will strip leading and trailing whitespace from text string.
    [CollapseWhiteSpace]
    
    // The _text storage var is mx_internal in TextBase.
    
    /**
     *  @private
     */
    private var textChanged:Boolean = false;
    
    /**
     *  @private
     *  Source of text: one of "text", "textFlow" or "content".* 
     */
    private var source:String = "";
    
    /**
     *  @private
     */
    override public function get text():String
    {
        // Extracting the plaintext from a TextFlow is somewhat expensive,
        // as it involves iterating over the leaf FlowElements in the TextFlow.
        // Therefore we do this extraction only when necessary, namely when
        // you first set the 'content' or the 'textFlow'
        // (or mutate the TextFlow), and then get the 'text'.
        /*
        if (_text == null)
        {
            // If 'content' was last set,
            // we have to first turn that into a TextFlow.
            if (contentChanged)
            {
                _textFlow = createTextFlowFromContent(_content);
                lastGeneration = _textFlow.generation;
            }
                    
            // Once we have a TextFlow, we can export its plain text.
            _text = staticPlainTextExporter.export(
                _textFlow, ConversionType.STRING_TYPE) as String;
        }
        */
        
        return _text;
    }

    /**
     *  @private
     *  This will create a TextFlow with a single paragraph with a single span 
     *  with exactly the text specified.  If there is whitespace and line 
     *  breaks in the text, they will remain, regardless of the settings of
     *  the lineBreak and whiteSpaceCollapse styles.
     */
    override public function set text(value:String):void
    {
        // Treat setting the 'text' to null
        // as if it were set to the empty String
        // (which is the default state).
        if (value == null)
            value = "";
        
        // If the most recent change to _text was caused by calling this method,
        // then it's safe to short-cicuit in the same way that TextBase does.
        if ((source == "text") && (value == _text))
            return;
        
        // Don't return early if value is the same as _text,
        // because _text might have been produced from setting
        // 'textFlow' or 'content'.
        // For example, if you set a TextFlow corresponding to
        // "Hello <span color="OxFF0000">World</span>"
        // and then get the 'text', it will be the String "Hello World"
        // But if you then set the 'text' to "Hello World"
        // this represents a change: the "World" should no longer be red.
        
        _text = value;
        textChanged = true;
        source = "text";
        
        // If more than one of 'text', 'textFlow', and 'content' is set,
        // the last one set wins.
        textFlowChanged = false;
        contentChanged = false;
        
        // If there was a textFlow remove its damage handler.
        removeDamageHandler();

        // The other two are now invalid and must be recalculated when needed.
        _textFlow = null;
        _content = null;
        
        factory = staticStringFactory;
        
        /*
        invalidateTextLines();
        invalidateProperties();
        invalidateSize();
        invalidateDisplayList();
        */
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  content
    //----------------------------------

    /**
     *  @private
     *  Storage for the content property.
     */
    protected var _content:Object;
    
    /**
     *  @private
     */
    private var contentChanged:Boolean = false;
    
    /**
     *  @private
     *  This metadata tells the MXML compiler to disable some of its default
     *  interpretation of the value specified for the 'content' property.
     *  Normally, for properties of type Object, it assumes that things
     *  looking like numbers are numbers and things looking like arrays
     *  are arrays. But <content>1</content> should generate code to set the
     *  content to  the String "1", not the int 1, and <content>[1]</content>
     *  should set it to the String "[1]", not the Array [ 1 ].
     *  However, {...} continues to be interpreted as a databinding
     *  expression, and @Resource(...), @Embed(...), etc.
     *  as compiler directives.
     *  Similar metadata on TLF classes causes the same rules to apply
     *  within <p>, <span>, etc.
     */
    [RichTextContent]
    
    /**
     *  This property is intended for use in MXML at compile time;
     *  to get or set rich text content at runtime,
     *  please use the <code>textFlow</code> property instead.
     *
     *  <p>The <code>content</code> property is the default property
     *  for RichText, so that you can write MXML such as
     *  <pre>
     *  &lt;s:RichText&gt;Hello &lt;s:span fontWeight="bold"/&gt;World&lt;/s:span&gt;&lt;/s:RichText&gt;
     *  </pre>
     *  and have the String and SpanElement that you specify
     *  as the content be used to create a TextFlow.</p>
     *
     *  <p>This property is typed as Object because you can set it to
     *  to a String, a FlowElement, or an Array of Strings and FlowElements.
     *  In the example above, you are specifying the content
     *  to be a 2-element Array whose first element is the String
     *  "Hello" and whose second element is a SpanElement with the text
     *  "World" in boldface.</p>
     * 
     *  <p>No matter how you specify the content, it gets converted
     *  into a TextFlow, and when you get this property, you will get
     *  the resulting TextFlow.</p>
     * 
     *  <p>Adobe recommends using <code>textFlow</code> property
     *  to get and set rich text content at runtime,
     *  because it is strongly typed as a TextFlow
     *  rather than as an Object.
     *  A TextFlow is the canonical representation
     *  for rich text content in the Text Layout Framework.</p>
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get content():Object
    {
        return textFlow;
    }
    
    /**
     *  @private
     */   
    public function set content(value:Object):void
    {
        // Treat setting the 'content' to null
        // as if 'text' were being set to the empty String
        // (which is the default state).
        if (value == null)
        {
            text = "";
            return;
        }
        
        if (value == _content)
            return;
        
        _content = value;
        contentChanged = true;
        source = "content";
        
        // If more than one of 'text', 'textFlow', and 'content' is set,
        // the last one set wins.
        textChanged = false;
        textFlowChanged = false;
        
        // If there was a textFlow remove its damage handler.
        removeDamageHandler();

        // The other two are now invalid and must be recalculated when needed.
        _text = null;
        _textFlow = null;
        
        factory = staticTextFlowFactory;
        
        /*
        invalidateTextLines();
        invalidateProperties();
        invalidateSize();
        invalidateDisplayList();
        */
    }
    
    //----------------------------------
    //  mask
    //----------------------------------
    
    /**
     *  @private
     */
    //private var maskChanged:Boolean;
       
    /**
     *  @private
    override public function set mask(value:DisplayObject):void
    {
        if (super.mask == value)
            return;
        
        var oldMask:UIComponent = super.mask as UIComponent;
        
        super.mask = value;      
                
        // If the old mask was attached by us, then we need to 
        // undo the attachment logic        
        if (oldMask && oldMask.$parent === this)
        {       
            if (oldMask.parent is UIComponent)
                UIComponent(oldMask.parent).childRemoved(oldMask);
            oldMask.$parent.removeChild(oldMask);
        }     
                
        maskChanged = true;
        maskTypeChanged = true;
                
        invalidateProperties();
        invalidateDisplayList();
    }
         */
    /**
     *  @private
    */
    public function set verticalAlign(value:String):void {}

    //----------------------------------
    //  maskType
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the maskType property.
     */
    //private var _maskType:String = MaskType.CLIP;
    
    /**
     *  @private
     */
    //private var maskTypeChanged:Boolean;
    
    [Inspectable(defaultValue="clip", enumeration="clip,alpha,luminosity")]

    /**
     *  <p>The maskType defines how the mask is applied to the component.</p> 
     * 
     *  <p>The possible values are <code>MaskType.CLIP</code>, <code>MaskType.ALPHA</code> and 
     *  <code>MaskType.LUMINOSITY</code>.</p>  
     * 
     *  <p><strong>Clip Masking</strong></p>
     * 
     *  <p>When masking in clip mode, a clipping masks is reduced to 1-bit.  This means that a mask will 
     *  not affect the opacity of a pixel in the source content; it either leaves the value unmodified, 
     *  if the corresponding pixel in the mask is has a non-zero alpha value, or makes it fully 
     *  transparent, if the mask pixel value has an alpha value of zero.</p>
     * 
     *  <p>When clip masking is used, only the actual path and shape vectors and fills defined by the
     *  mask are used to determine the effect on the source content.  strokes and bitmap filters 
     *  defined on the mask are ignored.  Any filled region in the mask is considered filled, and renders 
     *  the source content.  The type and parameters of the fill is irrelevant;  a solid color fill, 
     *  gradient fill, or bitmap fill in a mask will all render the underlying source content, regardless 
     *  of the alpha values of the mask fill.</p>
     *  
     *  <p>BitmapGraphics are treated as bitmap filled rectangles when used in a clipping mask.  As a 
     *  result, the alpha channel of the source bitmap is irrelevant when part of a mask -- the bitmap 
     *  affects the mask in the same manner as solid filled rectangle of equivalent dimensions.</p>
     * 
     *  <p><strong>Alpha Masking</strong></p>
     * 
     *  <p>In alpha mode, the opacity of each pixel in the source content is multiplied by the opacity 
     *  of the corresponding region of the mask.  i.e., a pixel in the source content with an opacity of 
     *  1 that is masked by a region of opacity of .5 will have a resulting opacity of .5.  A source pixel 
     *  with an opacity of .8 masked by a region with opacity of .5 will have a resulting opacity of .4.</p>
     * 
     *  <p>Conceptually, alpha masking is equivalent to rendering the transformed mask and source content 
     *  into separate RGBA surfaces, and multiplying the alpha channel of the mask content into the alpha 
     *  channel of the source content.  All of the mask content is rendered into its surface before 
     *  compositing into the source content's surface. As a result, all FXG features, such as strokes, 
     *  bitmap filters, and fill opacity will affect the final composited content.</p>
     * 
     *  <p>When in alpha mode, the alpha channel of any bitmap data is composited normally into the mask 
     *  alpha channel, and will affect the final rendered content. This holds true for both BitmapGraphics 
     *  and bitmap filled shapes and paths.</p>
     * 
     *  <p><strong>Luminosity Masking</strong></p>
     * 
     *  <p>A luminosity mask, sometimes called a 'soft mask', works very similarly to an alpha mask
     *  except that both the opacity and RGB color value of a pixel in the source content is multiplied
     *  by the opacity and RGB color value of the corresponding region in the mask.</p>
     * 
     *  <p>Conceptually, luminosity masking is equivalent to rendering the transformed mask and source content 
     *  into separate RGBA surfaces, and multiplying the alpha channel and the RGB color value of the mask 
     *  content into the alpha channel and RGB color value of the source content.  All of the mask content is 
     *  rendered into its surface before compositing into the source content's surface. As a result, all FXG 
     *  features, such as strokes, bitmap filters, and fill opacity will affect the final composited 
     *  content.</p>
     * 
     *  <p>Luminosity masking is not native to Flash but is common in Adobe Creative Suite tools like Adobe 
     *  Illustrator and Adobe Photoshop. In order to accomplish the visual effect of a luminosity mask in 
     *  Flash-rendered content, a graphic element specifying a luminosity mask actually instantiates a shader
     *  filter that mimics the visual look of a luminosity mask as rendered in Adobe Creative Suite tools.</p>
     * 
     *  <p>Objects being masked by luminosity masks can set properties to control the RGB color value and 
     *  clipping of the mask. See the luminosityInvert and luminosityClip attributes.</p>
     * 
     *  @see spark.core.MaskType
     * 
     *  @default MaskType.CLIP
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
    public function get maskType():String
    {
        return _maskType;
    }
         */

    /**
     *  @private
    public function set maskType(value:String):void
    {
        if (_maskType == value)
            return;
        
        _maskType = value;
        maskTypeChanged = true;
        invalidateProperties();
    }
     */
    
    //----------------------------------
    //  luminosityInvert
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the luminosityInvert property.
     */
    //private var _luminosityInvert:Boolean = false; 
    
    /**
     *  @private
     */
    //private var luminositySettingsChanged:Boolean;

    [Inspectable(defaultValue="false")]

    /**
     *  A property that controls the calculation of the RGB 
     *  color value of a graphic element being masked by 
     *  a luminosity mask. If true, the RGB color value of a  
     *  pixel in the source content is inverted and multipled  
     *  by the corresponding region in the mask. If false, 
     *  the source content's pixel's RGB color value is used 
     *  directly. 
     * 
     *  @default false 
     *  @see #maskType 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
    public function get luminosityInvert():Boolean
    {
        return _luminosityInvert;
    }
     */
    
    /**
     *  @private
    public function set luminosityInvert(value:Boolean):void
    {
        if (_luminosityInvert == value)
            return;
        
        _luminosityInvert = value;
        luminositySettingsChanged = true; 
    }
     */
    
    //----------------------------------
    //  luminosityClip
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the luminosityClip property.
     */
    //private var _luminosityClip:Boolean = false; 
        
    [Inspectable(defaultValue="false")]

    /**
     *  A property that controls whether the luminosity 
     *  mask clips the masked content. This property can 
     *  only have an effect if the graphic element has a 
     *  mask applied to it that is of type 
     *  <code>MaskType.LUMINOSITY</code>.  
     * 
     *  @default false 
     *  @see #maskType 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
    public function get luminosityClip():Boolean
    {
        return _luminosityClip;
    }
     */
    
    /**
     *  @private
    public function set luminosityClip(value:Boolean):void
    {
        if (_luminosityClip == value)
            return;
        
        _luminosityClip = value;
        luminositySettingsChanged = true; 
    }
     */
    
    //----------------------------------
    //  textFlow
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the textFlow property.
     */
    private var _textFlow:TextFlow;
    
    /**
     *  @private
     */
    private var textFlowChanged:Boolean = false;
    
    /**
     *  The TextFlow representing the rich text displayed by this component.
     * 
     *  <p>A TextFlow is the most important class
     *  in the Text Layout Framework (TLF).
     *  It is the root of a tree of FlowElements
     *  representing rich text content.</p>
     *
     *  <p>You normally create a TextFlow from TLF markup
     *  using the <code>TextFlowUtil.importFromString()</code>
     *  or <code>TextFlowUtil.importFromXML()</code> methods.
     *  Alternately, you can use TLF's TextConverter class
     *  (which can import a subset of HTML) or build a TextFlow
     *  using methods like <code>addChild()</code> on TextFlow.</p>
     * 
     *  <p>Setting this property affects the <code>text</code> property
     *  and vice versa.</p>
     *
     *  <p>If you set the <code>textFlow</code> and get the <code>text</code>,
     *  the text in each paragraph will be separated by a single
     *  LF (<code>\n</code>).</p>
     *
     *  <p>If you set the <code>text</code> to a String such as
     *  <code>"Hello World"</code> and get the <code>textFlow</code>,
     *  it will be a TextFlow containing a single ParagraphElement
     *  with a single SpanElement.</p>
     *
     *  <p>If the text contains explicit line breaks --
     *  CR (<code>\r</code>), LF (<code>\n</code>), or CR+LF (<code>\r\n</code>) --
     *  then the content will be set to a TextFlow
     *  which contains multiple paragraphs, each with one span.</p>
     *
     *  <p>To turn a TextFlow object into TLF markup,
     *  use the markup returned from the <code>TextFlowUtil.export()</code> method.</p>
     *
     *  @see spark.utils.TextFlowUtil#importFromString()
     *  @see spark.utils.TextFlowUtil#importFromXML()
     *  @see spark.components.RichEditableText#text
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function get textFlow():TextFlow
    {
        // We might not have a valid _textFlow for two reasons:
        // either because the 'text' was set (which is the state
        // after construction) or because the 'content' was set.
        /*
        if (!_textFlow)
        {
            if (_content != null)
                _textFlow = createTextFlowFromContent(_content);
            else
                _textFlow = staticPlainTextImporter.importToFlow(_text);
            
            lastGeneration = _textFlow ? _textFlow.generation : 0;
        }
        */
        /*
        _textFlow.addEventListener(DamageEvent.DAMAGE,
                                   textFlow_damageHandler);
              
        // Ensure our textFlow has the most appropriate
        // swf context associated with it.                           
        if (_textFlow.flowComposer)
        {
            _textFlow.flowComposer.swfContext = 
                ISWFContext(getEmbeddedFontContext());  
        }                    
        */
        return _textFlow;
    }
    
    /**
     *  @private
     */
    public function set textFlow(value:TextFlow):void
    {
        // Treat setting the 'textFlow' to null
        // as if 'text' were being set to the empty String
        // (which is the default state).
        if (value == null)
        {
            text = "";
            return;
        }
        
        if (value == _textFlow)
            return;
                    
        // If there was a textFlow remove its damage handler.
        removeDamageHandler();
        
        _textFlow = value;
        textFlowChanged = true;
        source = "textFlow";
        
        // If more than one of 'text', 'textFlow', and 'content' is set,
        // the last one set wins.
        textChanged = false;
        contentChanged = false;
        
        // The other two are now invalid and must be recalculated when needed.
        _text = null
        _content = null;
        
        /*
        factory = staticTextFlowFactory;

        invalidateTextLines();
        invalidateProperties();
        invalidateSize();
        invalidateDisplayList();
        */
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: UIComponent
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    override protected function commitProperties():void
    {
        /*
        super.commitProperties();
        */
        
        // Only one of textChanged, textFlowChanged, and contentChanged
        // will be true; the other two will be false because each setter
        // guarantees this.
        if (textChanged)
        {
            // If the text has linebreaks (CR, LF, or CF+LF)
            // create a multi-paragraph TextFlow from it
            // and use the TextFlowTextLineFactory to render it.
            // Otherwise the StringTextLineFactory will put
            // all of the lines into a single paragraph
            // and FTE performance will degrade on a large paragraph.
            if (_text.indexOf("\n") != -1 || _text.indexOf("\r") != -1)
            {
                _textFlow = staticPlainTextImporter.importToFlow(_text) as TextFlow;
                factory = staticTextFlowFactory;
            }
            textChanged = false;
        }
        else if (textFlowChanged)
        {
            // Nothing to do at commitProperties() time.
            textFlowChanged = false;
        }
        else if (contentChanged)
        {
            _textFlow = createTextFlowFromContent(_content);
            contentChanged = false;
        }
    
        lastGeneration = _textFlow ? _textFlow.generation : 0;
        
        // At this point we know which TextLineFactory we're going to use
        // and we know the _text or _textFlow that it will compose.
                    
        // If the styles have changed, hostFormat will have
        // been set to null to indicate that it is invalid.
        // In that case, create a new one.
        if (!hostFormat)
        {
            hostFormat = new CSSTextLayoutFormat(this);
            // Note: CSSTextLayoutFormat has special processing
            // for the fontLookup style. If it is "auto",
            // the fontLookup format is set to either
            // "device" or "embedded" depending on whether
            // embeddedFontContext is null or non-null.
        }
        
        if (_textFlow)
        {
            // We might have a new TextFlow, or a new hostFormat,
            // so attach the latter to the former.
            _textFlow.hostFormat = hostFormat;
    
            // Add a damage handler.
            _textFlow.addEventListener(DamageEvent.DAMAGE, 
                                       textFlow_damageHandler);
        }
        
        /*
        if (maskChanged)
        {
            if (mask && !mask.parent)
            {
                addChild(mask);
                MaskUtil.applyMask(mask, null);
            }
            maskChanged = false;            
        }        
        
        if (luminositySettingsChanged)
        {
            MaskUtil.applyLuminositySettings(
                mask, _maskType, _luminosityInvert, _luminosityClip);

            luminositySettingsChanged = false;             
        }

        if (maskTypeChanged)
        {
            MaskUtil.applyMaskType(
                mask, _maskType, _luminosityInvert, _luminosityClip, this);

            maskTypeChanged = false;
        }
        */
    }

    /**
     *  @private
    override public function stylesInitialized():void
    {
        super.stylesInitialized();

        // The old hostFormat is invalid
        // and a new one must be created.
        hostFormat = null;
    }
     */

    /**
     *  @private
    override public function styleChanged(styleProp:String):void
    {
        super.styleChanged(styleProp);

        // The old hostFormat is invalid
        // and a new one must be created.
        hostFormat = null;
        
        invalidateTextLines();
        invalidateProperties();
        invalidateSize();
        invalidateDisplayList();
    }
     */

    /**
     *  @private
     */
    override protected function updateDisplayList(unscaledWidth:Number, 
                                                  unscaledHeight:Number):void
    {
        /*
        // The factory will compose just enough lines to fill the 
        // compositionHeight.  If not all the text is composed, the reported
        // contentHeight will be an estimate of what the height will be when
        // it is all composed and there will not be textLines to back it up.
        // There is no easy way to tell if the contentHeight is the actual
        // value or an estimated value.
        if (!isNaN(_composeHeight) && unscaledHeight != _composeHeight)
        {
            invalidateTextLines();
        }

        super.updateDisplayList(unscaledWidth, unscaledHeight);
        */
        
        // Compose will add the new text lines to the display object container.
        // Otherwise, if the text is in a shared container, make sure the 
        // position of the lines has remained the same.
        TLFFactory.defaultTLFFactory.currentContainer = this;
        composeTextLines(unscaledWidth, unscaledHeight);

    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods: TextBase
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     *  Returns true to indicate all lines were composed.
     */
    override mx_internal function composeTextLines(width:Number = NaN,
                                                   height:Number = NaN):Boolean
    {   
        // If there is no explicit width but there is an explicit
        // maxWidth use that.
        if (isNaN(width) && !isNaN(explicitMaxWidth))
            width = explicitMaxWidth;
        
        super.composeTextLines(width, height);
        
        // Ignore damage events while we're re-composing the text lines.
        ignoreDamageEvent = true;

        // Set the composition bounds to be used by createTextLines().
        // If there is no explicit width, and there is no explicit maxWidth,
        // the width will be computed by this method.
        // If the height is NaN, it will be computed by this method
        // by the time it returns.
        // The bounds are then used by the addTextLines() method
        // to determine the isOverset flag.
        // The composition bounds are also reported by the measure() method.
        
        bounds.x = 0;
        bounds.y = 0;
        bounds.width = width;
        bounds.height = height;
        
        removeTextLines();
        releaseTextLines();
        
        createTextLines();
        
        // Truncation only done if not measuring width and line breaks are
        // toFit.  So if we are measuring, create the text lines to figure
        // out their size and then recreate them using this size so truncation 
        // will be done.
        if (maxDisplayedLines != 0 && /*!isTruncated &&*/
            getStyle("lineBreak") == "toFit")
        {
            var bp:String = getStyle("blockProgression");
            if ((isNaN(width) && bp == "tb") || (isNaN(height) && bp != "tb"))
            {
                textLines.length = 0;
                // bounds contains the measured size of the lines created above
                createTextLines();
            }
        }
        
        // Add the new text lines to the container.
        addTextLines();
        
        // Figure out if the text overruns the available space for composition.
        //isOverset = isTextOverset(width, height);
        
        // Just recomposed so reset.
        //invalidateCompose = false;
        
        // Listen for "damage" events in case the textFlow is 
        // modified programatically.
        ignoreDamageEvent = false;
        
        // Created all lines.
        return true;      
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private function createTextFlowFromContent(content:Object):TextFlow
    {
        var textFlow:TextFlow ;
        
        if (content is TextFlow)
        {
            textFlow = content as TextFlow;
        }
        else if (content is Array)
        {
            textFlow = new TextFlow(TLFFactory.defaultTLFFactory);
            textFlow.whiteSpaceCollapse = getStyle("whiteSpaceCollapse");
            textFlow.mxmlChildren = content as Array;
            textFlow.whiteSpaceCollapse = undefined;
        }
        else
        {
            textFlow = new TextFlow(TLFFactory.defaultTLFFactory);
            textFlow.whiteSpaceCollapse = getStyle("whiteSpaceCollapse");
            textFlow.mxmlChildren = [ content ];
            textFlow.whiteSpaceCollapse = undefined;
        }
        
        return textFlow;
    }
    
    /**
     *  @private
     *  Uses TextLineFactory to compose the textFlow
     *  into as many TextLines as fit into the bounds.
     */
    private function createTextLines():void
    {
        // Clear any previously generated TextLines from the textLines Array.
        textLines.length = 0;
        
        // Note: Even if we have nothing to compose, we nevertheless
        // use the StringTextLineFactory to compose an empty string.
        // Since it appends the paragraph terminator "\u2029",
        // it actually creates and measures one TextLine.
        // Its width is 0 but its height is equal to the font's
        // ascent plus descent.
        
        factory.compositionBounds = bounds;   
        
        // Set up the truncation options.
        /*
        var truncationOptions:TruncationOptions;
        if (maxDisplayedLines != 0)
        {
            truncationOptions = new TruncationOptions();
            truncationOptions.lineCountLimit = maxDisplayedLines;
            truncationOptions.truncationIndicator =
                TextBase.truncationIndicatorResource;
        }        
        factory.truncationOptions = truncationOptions;
        */
        
        // If the CSS styles for this component specify an embedded font,
        // embeddedFontContext will be set to the module factory that
        // should create TextLines (since they must be created in the
        // SWF where the embedded font is). Otherwise, this will be null.
        //embeddedFontContext = getEmbeddedFontContext();
       
        if (factory is StringTextLineFactory)
        {
            // We know text is non-null since it got this far.
            staticStringFactory.text = _text;
            staticStringFactory.textFlowFormat = hostFormat;
            //staticStringFactory.swfContext = ISWFContext(embeddedFontContext);
            staticStringFactory.createTextLines(addTextLine);
        }
        else if (factory is TextFlowTextLineFactory)
        {
            // if (_textFlow && _textFlow.flowComposer)
            // {
                //_textFlow.flowComposer.swfContext = 
                //    ISWFContext(embeddedFontContext);
            // }
            
            //staticTextFlowFactory.swfContext = ISWFContext(embeddedFontContext);
            staticTextFlowFactory.createTextLines(addTextLine, _textFlow);
        }
        
        bounds = factory.getContentBounds();
        //setIsTruncated(factory.isTruncated);
    }

    /**
     *  @private
     *  Uses StringTextLineFactory to compose an empty string so we can 
     *  determine the baseline from the text line.  The height is important
     *  if the text is vertically aligned.
    override mx_internal function createEmptyTextLine(height:Number=NaN):void

    {
        // Clear any previously generated TextLines from the textLines Array.
        textLines.length = 0;
        
        // Note: 
        // Use the StringTextLineFactory to compose an empty string.
        // Since it appends the paragraph terminator "\u2029",
        // it actually creates and measures one TextLine.
        // Its width is 0 but its height is equal to the font's
        // ascent plus descent.
        // Note:  Prior to TLF2, the factory would callback addTextLine 
        // when width=0 but that has been optimized out.  Now width to NaN.
        
        bounds.x = 0;
        bounds.y = 0;
        bounds.width = width ? width : NaN;
        bounds.height = height;
        
        staticStringFactory.compositionBounds = bounds;   
        
        // Set up the truncation options.
        staticStringFactory.truncationOptions = null;
        
        staticStringFactory.text = "";
        staticStringFactory.textFlowFormat = hostFormat;
        staticStringFactory.createTextLines(addTextLine);
    }
     */

    /**
     *  @private
     *  Callback passed to createTextLines().
     */
    private function addTextLine(textLine:ITextLine):void
    {
        textLines.push(textLine);
    }

    /**
     *  @private
     *  Make sure to remove the damage handler before resetting the text flow.
     */
    private function removeDamageHandler():void
    {
        // Could check factory is TextFlowTextLineFactory but be safe and 
        // try to remove whenever there is a text flow.
        if (_textFlow != null)
        {
            _textFlow.removeEventListener(DamageEvent.DAMAGE,
                textFlow_damageHandler);
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     *  Called when the TextFlow dispatches a 'damage' event
     *  to indicate it has been modified.  This could mean the styles changed
     *  or the content changed, or both changed.
     */
    private function textFlow_damageHandler(event:DamageEvent):void
    {
        // If there are no changes to the generation, don't recompose.  
        // The TextFlowFactory createTextLines dispatches damage events every 
        // time the textFlow is composed, even if there are no changes.
        if (ignoreDamageEvent || _textFlow.generation == lastGeneration)
            return;
        
        // Update the last know generation for _textFlow.
        lastGeneration = _textFlow.generation;

        // Invalidate _text and _content.
        _text = null;
        _content = null;
        
        // After the TextFlow has been mutated,
        // we must render it, not the 'text' String.
        factory = staticTextFlowFactory;
        
        // Force recompose since text and/or styles may have changed.
        //invalidateTextLines();
        
        // We don't need to call invalidateProperties()
        // because the hostFormat and the _textFlow are still valid.

        // This is smart enough not to remeasure if the explicit width/height
        // were specified.
        //invalidateSize();
        
        //invalidateDisplayList();  
    }    
}

}
