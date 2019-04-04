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

/**
 *  Color of text in the component, including the component label.
 *
 *  @default 0x0B333C
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="color", type="uint", format="Color", inherit="yes")]

/**
 *  Color of text in the component if it is disabled.
 *
 *  @default 0xAAB3B3
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="disabledColor", type="uint", format="Color", inherit="yes")]

/**
 *  Sets the <code>antiAliasType</code> property of internal TextFields. The possible values are 
 *  <code>"normal"</code> (<code>flash.text.AntiAliasType.NORMAL</code>) 
 *  and <code>"advanced"</code> (<code>flash.text.AntiAliasType.ADVANCED</code>). 
 *  
 *  <p>The default value is <code>"advanced"</code>, which enables the FlashType renderer if you are using an 
 *  embedded FlashType font. Set to <code>"normal"</code> to disable the FlashType renderer.</p>
 *  
 *  <p>This style has no effect for system fonts.</p>
 *  
 *  <p>This style applies to all the text in a TextField subcontrol; 
 *  you can't apply it to some characters and not others.</p>

 *  @default "advanced"
 * 
 *  @see flash.text.TextField
 *  @see flash.text.AntiAliasType
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="fontAntiAliasType", type="String", enumeration="normal,advanced", inherit="yes")]

/**
 *  Name of the font to use.
 *  Unlike in a full CSS implementation,
 *  comma-separated lists are not supported.
 *  You can use any font family name.
 *  If you specify a generic font name,
 *  it is converted to an appropriate device font.
 * 
 *  @default "Verdana"
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="fontFamily", type="String", inherit="yes")]

/**
 *  Sets the <code>gridFitType</code> property of internal TextFields that represent text in Flex controls.
 *  The possible values are <code>"none"</code> (<code>flash.text.GridFitType.NONE</code>), 
 *  <code>"pixel"</code> (<code>flash.text.GridFitType.PIXEL</code>),
 *  and <code>"subpixel"</code> (<code>flash.text.GridFitType.SUBPIXEL</code>). 
 *  
 *  <p>This property only applies when you are using an embedded FlashType font 
 *  and the <code>fontAntiAliasType</code> property 
 *  is set to <code>"advanced"</code>.</p>
 *  
 *  <p>This style has no effect for system fonts.</p>
 * 
 *  <p>This style applies to all the text in a TextField subcontrol; 
 *  you can't apply it to some characters and not others.</p>
 * 
 *  @default "pixel"
 *  
 *  @see flash.text.TextField
 *  @see flash.text.GridFitType
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="fontGridFitType", type="String", enumeration="none,pixel,subpixel", inherit="yes")]

/**
 *  Sets the <code>sharpness</code> property of internal TextFields that represent text in Flex controls.
 *  This property specifies the sharpness of the glyph edges. The possible values are Numbers 
 *  from -400 through 400. 
 *  
 *  <p>This property only applies when you are using an embedded FlashType font 
 *  and the <code>fontAntiAliasType</code> property 
 *  is set to <code>"advanced"</code>.</p>
 *  
 *  <p>This style has no effect for system fonts.</p>
 * 
 *  <p>This style applies to all the text in a TextField subcontrol; 
 *  you can't apply it to some characters and not others.</p>
 *  
 *  @default 0
 *  
 *  @see flash.text.TextField
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="fontSharpness", type="Number", inherit="yes")]

/**
 *  Height of the text, in pixels.
 *
 *  The default value is 10 for all controls except the ColorPicker control. 
 *  For the ColorPicker control, the default value is 11. 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="fontSize", type="Number", format="Length", inherit="yes")]

/**
 *  Determines whether the text is italic font.
 *  Recognized values are <code>"normal"</code> and <code>"italic"</code>.
 * 
 *  @default "normal"
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="fontStyle", type="String", enumeration="normal,italic", inherit="yes")]

/**
 *  Sets the <code>thickness</code> property of internal TextFields that represent text in Flex controls.
 *  This property specifies the thickness of the glyph edges.
 *  The possible values are Numbers from -200 to 200. 
 *  
 *  <p>This property only applies when you are using an embedded FlashType font 
 *  and the <code>fontAntiAliasType</code> property 
 *  is set to <code>"advanced"</code>.</p>
 *  
 *  <p>This style has no effect on system fonts.</p>
 * 
 *  <p>This style applies to all the text in a TextField subcontrol; 
 *  you can't apply it to some characters and not others.</p>
 *  
 *  @default 0
 *  
 *  @see flash.text.TextField
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="fontThickness", type="Number", inherit="yes")]

/**
 *  Determines whether the text is boldface.
 *  Recognized values are <code>"normal"</code> and <code>"bold"</code>.
 *  For LegendItem, the default is <code>"bold"</code>.
 * 
 *  @default "normal"
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="fontWeight", type="String", enumeration="normal,bold", inherit="yes")]

/**
 *  A Boolean value that indicates whether kerning
 *  is enabled (<code>true</code>) or disabled (<code>false</code>).
 *  Kerning adjusts the gap between certain character pairs
 *  to improve readability, and should be used only when necessary,
 *  such as with headings in large fonts.
 *  Kerning is supported for embedded FlashType fonts only. 
 *  Certain fonts, such as Verdana, and monospaced fonts,
 *  such as Courier New, do not support kerning.
 *
 *  @default false
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="kerning", type="Boolean", inherit="yes")]

/**
 *  The number of additional pixels to appear between each character.
 *  A positive value increases the character spacing beyond the normal spacing,
 *  while a negative value decreases it.
 * 
 *  @default 0
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="letterSpacing", type="Number", inherit="yes")]

/**
 *  Alignment of text within a container.
 *  Possible values are <code>"left"</code>, <code>"right"</code>,
 *  or <code>"center"</code>.
 * 
 *  <p>The default value for most controls is <code>left</code>.
 *  For the Button, LinkButton, and AccordionHeader components,
 *  the default value is <code>"center"</code>.
 *  For these components, this property is only recognized when the
 *  <code>labelPlacement</code> property is set to <code>"left"</code> or
 *  <code>"right"</code>.
 *  If <code>labelPlacement</code> is set to <code>"top"</code> or
 *  <code>"bottom"</code>, the text and any icon are centered.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="textAlign", type="String", enumeration="left,center,right", inherit="yes")]

/**
 *  Determines whether the text is underlined.
 *  Possible values are <code>"none"</code> and <code>"underline"</code>.
 * 
 *  @default "none"
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="textDecoration", type="String", enumeration="none,underline", inherit="yes")]

/**
 *  Offset of first line of text from the left side of the container, in pixels.
 * 
 *  @default 0
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="textIndent", type="Number", format="Length", inherit="yes")]
