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

package mx.core
{

import org.apache.royale.core.TextLineMetrics;

COMPILE::SWF
{
import flash.text.TextFormat;
}
COMPILE::JS
{
import mx.text.TextFormat;
}

import mx.managers.ISystemManager;
import mx.managers.SystemManager;

/**
 *  The UITextFormat class represents character formatting information
 *  for the UITextField class.
 *  The UITextField class defines the component used by many Flex composite
 *  components to display text.
 *
 *  <p>The UITextFormat class extends the flash.text.TextFormat class
 *  to add the text measurement methods <code>measureText()</code>
 *  and <code>measureHTMLText()</code> and to add properties for
 *  controlling the advanced anti-aliasing of fonts.</p>
 *
 *  @see mx.core.UITextField
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 * 
 *  @royalesuppresspublicvarwarning
 */
public class UITextFormat extends TextFormat
{
//    include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  textFieldFactory
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the textFieldFactory property.
     *  This gets initialized on first access,
     *  not at static initialization time, in order to ensure
     *  that the Singleton registry has already been initialized.
     */
    private static var _textFieldFactory:ITextFieldFactory;
    
    /**
     *  @private
     *  Factory for text fields used to measure text.
     *  Created in the context of module factories
     *  so the text field has access to an embedded font, if needed.
     */
    private static function get textFieldFactory():ITextFieldFactory
    {
        if (!_textFieldFactory)
        {
            _textFieldFactory = ITextFieldFactory(
                Singleton.getInstance("mx.core::ITextFieldFactory"));
        }
        
        return _textFieldFactory;
    }
    

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  @param systemManager A SystemManager object.
     *  The SystemManager keeps track of which fonts are embedded.
     *  Typically this is the SystemManager obtained from the
     *  <code>systemManager</code> property of UIComponent.
     *
     *  @param font A String specifying the name of a font,
     *  or <code>null</code> to indicate that this UITextFormat
     *  doesn't specify this property.
     *  This parameter is optional, with a default value of <code>null</code>.
     *
     *  @param size A Number specifying a font size in pixels,
     *  or <code>null</code> to indicate that this UITextFormat
     *  doesn't specify this property.
     *  This parameter is optional, with a default value of <code>null</code>.
     *
     *  @param color An unsigned integer specifying the RGB color of the text,
     *  such as 0xFF0000 for red, or <code>null</code> to indicate
     *  that is UITextFormat doesn't specify this property.
     *  This parameter is optional, with a default value of <code>null</code>.
     *
     *  @param bold A Boolean flag specifying whether the text is bold,
     *  or <code>null</code> to indicate that this UITextFormat
     *  doesn't specify this property.
     *  This parameter is optional, with a default value of <code>null</code>.
     *
     *  @param italic A Boolean flag specifying whether the text is italic,
     *  or <code>null</code> to indicate that this UITextFormat
     *  doesn't specify this property.
     *  This parameter is optional, with a default value of <code>null</code>.
     *
     *  @param italic A Boolean flag specifying whether the text is underlined,
     *  or <code>null</code> to indicate that this UITextFormat
     *  doesn't specify this property.
     *  This parameter is optional, with a default value of <code>null</code>.
     *
     *  @param urlString A String specifying the URL to which the text is
     *  hyperlinked, or <code>null</code> to indicate that this UITextFormat
     *  doesn't specify this property.
     *  This parameter is optional, with a default value of <code>null</code>.
     *
     *  @param target A String specifying the target window
     *  where the hyperlinked URL is displayed. 
     *  If the target window is <code>null</code> or an empty string,
     *  the hyperlinked page is displayed in the same browser window.
     *  If the <code>urlString</code> parameter is <code>null</code>
     *  or an empty string, this property has no effect.
     *  This parameter is optional, with a default value of <code>null</code>.
     *
     *  @param align A String specifying the alignment of the paragraph,
     *  as a flash.text.TextFormatAlign value, or <code>null</code> to indicate
     *  that this UITextFormat doesn't specify this property.
     *  This parameter is optional, with a default value of <code>null</code>.
     *
     *  @param leftMargin A Number specifying the left margin of the paragraph,
     *  in pixels, or <code>null</code> to indicate that this UITextFormat
     *  doesn't specify this property.
     *  This parameter is optional, with a default value of <code>null</code>.
     *
     *  @param rightMargin A Number specifying the right margin of the paragraph,
     *  in pixels, or <code>null</code> to indicate that this UITextFormat
     *  doesn't specify this property.
     *  This parameter is optional, with a default value of <code>null</code>.
     *
     *  @param indent A Number specifying the indentation from the left
     *  margin to the first character in the paragraph, in pixels,
     *  or <code>null</code> to indicate that this UITextFormat
     *  doesn't specify this property.
     *  This parameter is optional, with a default value of <code>null</code>.
     *
     *  @param leading A Number specifying the amount of additional vertical
     *  space between lines, or <code>null</code> to indicate
     *  that this UITextFormat doesn't specify this property.
     *  This parameter is optional, with a default value of <code>null</code>.
     *
     *  @see flash.text.TextFormatAlign
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function UITextFormat(systemManager:ISystemManager,
                                 font:String = null,
                                 size:Object = null,
                                 color:Object = null,
                                 bold:Object = null,
                                 italic:Object = null,
                                 underline:Object = null,
                                 align:String = null,
                                 leftMargin:Object = null,
                                 rightMargin:Object = null)
    {
        this.systemManager = systemManager;

        super(font, size, color, bold, italic, underline,
              align, leftMargin, rightMargin);
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private var systemManager:ISystemManager;
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  antiAliasType
    //----------------------------------

    /**
     *  Defines the anti-aliasing setting for the UITextField class.
     *  The possible values are <code>"normal"</code> 
     *  (<code>flash.text.AntiAliasType.NORMAL</code>) 
     *  and <code>"advanced"</code> 
     *  (<code>flash.text.AntiAliasType.ADVANCED</code>). 
     *  
     *  <p>The default value is <code>"advanced"</code>, 
     *  which enables advanced anti-aliasing 
     *  for the embedded font. 
     *  Set this property to <code>"normal"</code>
     *  to disable the advanced anti-aliasing.</p>
     *  
     *  <p>This property has no effect for system fonts.</p>
     *  
     *  <p>This property applies to all the text in a UITextField object; 
     *  you cannot apply it to some characters and not others.</p>
     * 
     *  @default "advanced"
     *
     *  @see flash.text.AntiAliasType
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var antiAliasType:String;
    
    //----------------------------------
    //  direction
    //----------------------------------

    /**
     *  The directionality of the text.
     *
     *  <p>The allowed values are <code>"ltr"</code> for left-to-right text,
     *  as in Latin-style scripts,
     *  and <code>"rtl"</code> for right-to-left text,
     *  as in Arabic and Hebrew.</p>
     *
     *  <p>FTE and TLF use this value in their bidirectional text layout algorithm,
     *  which maps Unicode character order to glyph order.</p>
     * 
     *  <p>Note: This style only applies when this UITextFormat
     *  is used with a UIFTETextField rather than a UITextField.</p>
     *
     *  @default null
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public var direction:String;
    
    //----------------------------------
    //  gridFitType
    //----------------------------------

    /**
     *  Defines the grid-fitting setting for the UITextField class.
     *  The possible values are <code>"none"</code> 
     *  (<code>flash.text.GridFitType.NONE</code>), 
     *  <code>"pixel"</code> 
     *  (<code>flash.text.GridFitType.PIXEL</code>),
     *  and <code>"subpixel"</code> 
     *  (<code>flash.text.GridFitType.SUBPIXEL</code>). 
     *  
     *  <p>This property only applies when you are using an
     *  embedded font and the <code>fontAntiAliasType</code>
     *  property is set to <code>"advanced"</code>.</p>
     *  
     *  <p>This property has no effect for system fonts.</p>
     * 
     *  <p>This property applies to all the text in a UITextField object; 
     *  you cannot apply it to some characters and not others.</p>
     * 
     *  @default "pixel"
     *
     *  @see flash.text.GridFitType
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var gridFitType:String;
    
    //----------------------------------
    //  locale
    //----------------------------------

    /**
     *  The locale of the text.
     * 
     *  <p>FTE and TLF use this locale to map Unicode characters
     *  to font glyphs and to find fallback fonts.</p>
     *
     *  <p>Note: This style only applies when this UITextFormat
     *  is used with a UIFTETextField rather than a UITextField.</p>
     *
     *  @default null
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public var locale:String;
    
    
    //----------------------------------
    //  sharpness
    //----------------------------------

    /**
     *  Defines the sharpness setting for the UITextField class.
     *  This property specifies the sharpness of the glyph edges. 
     *  The possible values are Numbers from -400 through 400. 
     *  
     *  <p>This property only applies when you are using an 
     *  embedded font and the <code>fontAntiAliasType</code>
     *  property is set to <code>"advanced"</code>.</p>
     *  
     *  <p>This property has no effect for system fonts.</p>
     * 
     *  <p>This property applies to all the text in a UITextField object; 
     *  you cannot apply it to some characters and not others.</p>
     *  
     *  @default 0
     *  @see flash.text.TextField
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var sharpness:Number;
    
    //----------------------------------
    //  thickness
    //----------------------------------

    /**
     *  Defines the thickness setting for the UITextField class.
     *  This property specifies the thickness of the glyph edges.
     *  The possible values are Numbers from -200 to 200. 
     *  
     *  <p>This property only applies when you are using an 
     *  embedded font and the <code>fontAntiAliasType</code>
     *  property is set to <code>"advanced"</code>.</p>
     *  
     *  <p>This property has no effect for system fonts.</p>
     * 
     *  <p>This property applies to all the text in a UITextField object; 
     *  you cannot apply it to some characters and not others.</p>
     *  
     *  @default 0
     *  @see flash.text.TextField
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var thickness:Number;
    
    //----------------------------------
    //  useFTE
    //----------------------------------
    
    /**
     *  Determines how the <code>measureText()</code>
     *  and <code>measureHTMLText()</code> methods do text measurement.
     * 
     *  <p>If <code>true</code>, they use an offscreen instance
     *  of the FTETextField class in the Text Layout Framework.
     *  If <code>false</code>, they use an offscreen instance
     *  of the TextField class in the Flash Player.</p>
     * 
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var useFTE:Boolean = false;

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Returns measurement information for the specified text, 
     *  assuming that it is displayed in a single-line UITextField component, 
     *  and using this UITextFormat object to define the text format. 
     *
     *  @param text A String specifying the text to measure.
     *  
     *  @param roundUp A Boolean flag specifying whether to round up the
     *  the measured width and height to the nearest integer.
     *  Rounding up is appropriate in most circumstances.
     *  
     *  @return A TextLineMetrics object containing the text measurements.
     *
     *  @see flash.text.TextLineMetrics
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function measureText(text:String, roundUp:Boolean = true):TextLineMetrics
    {
        return measure(text, false, roundUp);
    }

    /**
     *  Returns measurement information for the specified HTML text, 
     *  which may contain HTML tags such as <code>&lt;font&gt;</code>
     *  and <code>&lt;b&gt;</code>, assuming that it is displayed
     *  in a single-line UITextField, and using this UITextFormat object
     *  to define the text format.
     *
     *  @param text A String specifying the HTML text to measure.
     *  
     *  @param roundUp A Boolean flag specifying whether to round up the
     *  the measured width and height to the nearest integer.
     *  Rounding up is appropriate in most circumstances.
     * 
     *  @return A TextLineMetrics object containing the text measurements.
     *
     *  @see flash.text.TextLineMetrics
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function measureHTMLText(htmlText:String, roundUp:Boolean = true):TextLineMetrics
    {
        return measure(htmlText, true, roundUp);
    }

    /**
     *  @private
     */
    COMPILE::SWF
    private function measure(s:String, html:Boolean, roundUp:Boolean):TextLineMetrics
    {
        // The text of a TextField can't be set to null.
        if (!s)
            s = "";
        
        /*
        // Create a persistent, off-display-list TextField
        // to be used for text measurement. The text field factory keeps
        // the text fields to one per moduleFactory.
        var embeddedFont:Boolean = false;
        var fontModuleFactory:IFlexModuleFactory = (noEmbeddedFonts || !embeddedFontRegistry) ? 
            null : 
            embeddedFontRegistry.getAssociatedModuleFactory(
                font, bold, italic, this, moduleFactory, systemManager, useFTE);

        embeddedFont = (fontModuleFactory != null);
        if (fontModuleFactory == null)
        {
            // try to use the systemManager as a backup for the case
            // where embedded fonts have no info().
            fontModuleFactory = systemManager;
        }
        */
        var measurementTextField:Object /* either TextField or FTETextField */ =
            useFTE ?
            textFieldFactory.createFTETextField(/*fontModuleFactory*/null) :
            textFieldFactory.createTextField(/*fontModuleFactory*/null);
        
        // Clear any old text from the TextField.
        // Otherwise, new text will get the old TextFormat. 
        if (html)
            measurementTextField.htmlText = "";
        else
            measurementTextField.text = "";

        // Make the measurement TextField use this TextFormat.
        measurementTextField.defaultTextFormat = this;
        //measurementTextField.embedFonts = embeddedFont;
        
        // Set other properties based on CSS styles.
        if (!useFTE)
        {
            // These properties do not have meaning in FTETextField,
            // and have been implemented to return either null or NaN,
            // so don't try to set them on a FTETextField.
            measurementTextField.antiAliasType = antiAliasType;
            measurementTextField.gridFitType = gridFitType;
            measurementTextField.sharpness = sharpness;
            measurementTextField.thickness = thickness;
        }
        else
        {
            // The properties have meaning only on a FTETextField.
            measurementTextField.direction = direction;
            measurementTextField.locale = locale;
        }
        
        // Set the text to be measured into the TextField.
        if (html)
            measurementTextField.htmlText = s;
        else
            measurementTextField.text = s;
        
        // Measure it.
        var lineMetrics:TextLineMetrics =
            measurementTextField.getLineMetrics(0);

        // Account for any indenting of the text.
        if (indent != null)
            lineMetrics.width += indent;
 
        if (roundUp)
        {                               
            // Round up because embedded fonts can produce fractional values;
            // if a parent container rounds a component's actual width or height
            // down, the component may not be wide enough to display the text.
            lineMetrics.width = Math.ceil(lineMetrics.width);
            lineMetrics.height = Math.ceil(lineMetrics.height);
        }
        
        return lineMetrics;
    }

    COMPILE::JS
    private static var measuringElementRef:HTMLSpanElement

    /**
     * @royaleignorecoercion mx.managers.SystemManager;
     * @royaleignorecoercion HTMLSpanElement; 
     */
    COMPILE::JS
    private function measure(s:String, html:Boolean, roundUp:Boolean):TextLineMetrics
    {
        //sometimes this can be requested in some code that does not pass a reference to systemManager, so use
        //a cached reference to the measuringElement - needs review
        var measuringElement:HTMLSpanElement = measuringElementRef;

        if (!measuringElement) {
            measuringElementRef = (systemManager as SystemManager).measuringElement;
            measuringElement = measuringElementRef;
            if (!measuringElement) {
                var sm:SystemManager = systemManager as SystemManager;
                if (sm.measuringElement == null)
                {
                    measuringElement = document.createElement("span") as HTMLSpanElement;
                    //everything else is absolute position so should be above this element
                    //sm.measuringElement.style.position = "float"; // to try to keep it from affecting position of other elements
                    // offsetWidth/Height not computed for display: none
                    //sm.measuringElement.style.display = "none"; // to try to keep it hidden
                    measuringElement.style.opacity = 0;
                    measuringElement.style["pointer-events"] = "none";
                    sm.element.appendChild(measuringElement);
                    sm.measuringElement = measuringElement;
                }
            }
        }

        if (s.indexOf("&nbsp;") >= 0)
            measuringElement.innerHTML = s;
        else
            measuringElement.textContent = s;
        var tlm:TextLineMetrics = new TextLineMetrics();
        tlm.width = measuringElement.offsetWidth;
        tlm.height = measuringElement.offsetHeight;
        return tlm;
    }
    
    /**
     *  @private
     */
    mx_internal function copyFrom(source:TextFormat):void
    {
        font = source.font;
        size = source.size;
        color = source.color;
        bold = source.bold;
        italic = source.italic;
        underline = source.underline;
        //url = source.url;
        //target = source.target;
        align = source.align;
        leftMargin = source.leftMargin;
        rightMargin = source.rightMargin;
        //indent = source.indent;
        leading = source.leading;
        //letterSpacing = source.letterSpacing;
        //blockIndent = source.blockIndent;
        //bullet = source.bullet;
        //display = source.display;
        //indent = source.indent;
        //kerning = source.kerning;
        //tabStops = source.tabStops;
    }
}

}
