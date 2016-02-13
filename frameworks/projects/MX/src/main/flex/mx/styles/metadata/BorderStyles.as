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
 *  Background color of the component when it is disabled.
 *  The global default value is <code>undefined</code>.
 *  The default value for List controls is <code>0xDDDDDD</code> (light gray).
 *  If a container is disabled, the background is dimmed, and the degree of
 *  dimming is controlled by the <code>disabledOverlayAlpha</code> style.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="backgroundDisabledColor", type="uint", format="Color", inherit="yes", theme="halo")]

/**
 *  Background image of a component.  This can be an absolute or relative
 *  URL or class.  You can set either the <code>backgroundColor</code> or the
 *  <code>backgroundImage</code>. The background image is displayed
 *  on top of the background color.
 *  The default value is <code>undefined</code>, meaning "not set".
 *  If this style and the <code>backgroundColor</code> style are undefined,
 *  the component has a transparent background.
 * 
 *  <p>The default skins of most Flex controls are partially transparent. As a result, the background image of 
 *  a container partially "bleeds through" to controls that are in that container. You can avoid this by setting the 
 *  alpha values of the control's <code>fillAlphas</code> property to 1, as the following example shows:
 *  <pre>
 *  &lt;mx:<i>Container</i> backgroundColor="0x66CC66"/&gt;
 *      &lt;mx:<i>ControlName</i> ... fillAlphas="[1,1]"/&gt;
 *  &lt;/mx:<i>Container</i>&gt;</pre>
 *  </p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="backgroundImage", type="Object", format="File", inherit="no", theme="halo")]

/**
 *  Scales the image specified by <code>backgroundImage</code>
 *  to different percentage sizes.
 *  A value of <code>"100%"</code> stretches the image
 *  to fit the entire component.
 *  To specify a percentage value, you must include the percent sign (%).
 *  The default for the Application container is <code>100%</code>.
 *  The default value for all other containers is <code>auto</code>, which maintains
 *  the original size of the image.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="backgroundSize", type="String", inherit="no", theme="halo")]

/**
 *  Alpha of the border.
 *  @default 1
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
[Style(name="borderAlpha", type="Number", inherit="no", theme="spark")]

/**
 *  Color of the border.
 *  The default value depends on the component class;
 *  if not overridden for the class, the default value is <code>0xB7BABC</code>
 *  for the Halo theme and <code>0x696969</code> for the Spark theme.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="borderColor", type="uint", format="Color", inherit="no", theme="halo, spark, mobile")]

/**
 *  Bounding box sides.
 *  A space-delimited String that specifies the sides of the border to show.
 *  The String can contain <code>"left"</code>, <code>"top"</code>,
 *  <code>"right"</code>, and <code>"bottom"</code> in any order.
 *  The default value is <code>"left top right bottom"</code>,
 *  which shows all four sides.
 *
 *  This style is only used when borderStyle is <code>"solid"</code>.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="borderSides", type="String", inherit="no", theme="halo")]

/**
 *  The border skin class of the component. 
 *  The default value in all components that do not explicitly
 *  set their own default for the Halo theme is <code>mx.skins.halo.HaloBorder</code>
 *  and for the Spark theme is <code>mx.skins.spark.BorderSkin</code>.
 *  The Panel container has a default value of <code>mx.skins.halo.PanelSkin</code>
 *  for the Halo theme and <code>mx.skins.spark.BorderSkin</code> for the Spark theme.
 *  To determine the default value for a component, see the default.css file.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="borderSkin", type="Class", inherit="no")]

/**
 *  Bounding box style.
 *  The possible values are <code>"none"</code>, <code>"solid"</code>,
 *  <code>"inset"</code>, and <code>"outset"</code>.
 *  The default value depends on the component class;
 *  if not overridden for the class, the default value is <code>"inset"</code>.
 *  The default value for most Containers is <code>"none"</code>.
 *  The <code>"inset"</code> and <code>"outset"</code> values are only
 *  valid with the halo theme.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="borderStyle", type="String", enumeration="inset,outset,solid,none", inherit="no")]

/**
 *  Bounding box thickness.
 *  Only used when <code>borderStyle</code> is set to <code>"solid"</code>.
 *
 *  @default 1
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="borderThickness", type="Number", format="Length", inherit="no", theme="halo")]

/**
 *  Visibility of the border.
 *
 *  @default true
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
[Style(name="borderVisible", type="Boolean", inherit="no", theme="spark")]

/**
 *  Boolean property that specifies whether the component has a visible
 *  drop shadow.
 *  This style is used with <code>borderStyle="solid"</code>.
 *  The default value is <code>false</code>.
 *
 *  <p><b>Note:</b> For drop shadows to appear on containers, set
 *  <code>backgroundColor</code> or <code>backgroundImage</code> properties.
 *  Otherwise, the shadow appears behind the container because
 *  the default background of a container is transparent.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="dropShadowEnabled", type="Boolean", inherit="no", theme="halo")]

/**
 *  Boolean property that specifies whether the component has a visible
 *  drop shadow.
 *  The default value is <code>false</code>.
 *
 *  <p><b>Note:</b> For drop shadows to appear on containers, set
 *  <code>contentBackgroundColor</code> property.
 *  Otherwise, the shadow appears behind the container because
 *  the default background of a container is transparent.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
[Style(name="dropShadowVisible", type="Boolean", inherit="no", theme="spark")]

/**
 *  Color of the drop shadow.
 *
 *  @default 0x000000
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="dropShadowColor", type="uint", format="Color", inherit="yes", theme="halo")]

/**
 *  Direction of the drop shadow.
 *  Possible values are <code>"left"</code>, <code>"center"</code>,
 *  and <code>"right"</code>.
 *
 *  @default "center"
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="shadowDirection", type="String", enumeration="left,center,right", inherit="no", theme="halo")]

/**
 *  Distance of the drop shadow.
 *  If the property is set to a negative value, the shadow appears above the component.
 *
 *  @default 2
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="shadowDistance", type="Number", format="Length", inherit="no", theme="halo")]



