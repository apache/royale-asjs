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

package mx.styles
{

import org.apache.royale.events.IEventDispatcher;

/**
 *  The IStyleManager class manages the following:
 *  <ul>
 *    <li>Which CSS style properties the class inherits</li>
 *    <li>Which style properties are colors, and therefore get special handling</li>
 *    <li>A list of strings that are aliases for color values</li>
 *  </ul>
 *
 *  This interface was used by Flex 2.0.1.
 *  Flex 3 now uses IStyleManager2 instead.
 *
 *  @see mx.styles.CSSStyleDeclaration
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 2.0.1
 *  
 */
public interface IStyleManager
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
	//  inheritingStyles
    //----------------------------------

    /**
     *  @private
     *  Set of inheriting non-color styles.
     *  This is not the complete set from CSS.
     *  Some of the omitted we don't support at all,
     *  others may be added later as needed.
     *  The method registerInheritingStyle() adds to this set
     *  and isInheritingStyle() queries this set.
	function get inheritingStyles():Object;
     */

    /**
     *  @private
	function set inheritingStyles(value:Object):void;
     */

    //----------------------------------
	//  stylesRoot
    //----------------------------------

    /**
     *  @private
     *  The root of all proto chains used for looking up styles.
     *  This object is initialized once by initProtoChainRoots() and
     *  then updated by calls to setStyle() on the global CSSStyleDeclaration.
     *  It is accessed by code that needs to construct proto chains,
     *  such as the initProtoChain() method of UIComponent.
	function get stylesRoot():Object;
     */

    /**
     *  @private
    function set stylesRoot(value:Object):void;
     */

    //----------------------------------
	//  typeSelectorCache
    //----------------------------------

    /**
     *  @private
	function get typeSelectorCache():Object;
     */

    /**
     *  @private
    function set typeSelectorCache(value:Object):void;
     */

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Gets the CSSStyleDeclaration object that stores the rules
     *  for the specified CSS selector.
     *
     *  <p>If the <code>selector</code> parameter starts with a period (.),
     *  the returned CSSStyleDeclaration is a class selector and applies only to those instances
     *  whose <code>styleName</code> property specifies that selector
     *  (not including the period).
     *  For example, the class selector <code>".bigMargins"</code>
     *  applies to any UIComponent whose <code>styleName</code>
     *  is <code>"bigMargins"</code>.</p>
     *
     *  <p>If the <code>selector</code> parameter does not start with a period,
     *  the returned CSSStyleDeclaration is a type selector and applies to all instances
     *  of that type.
     *  For example, the type selector <code>"Button"</code>
     *  applies to all instances of Button and its subclasses.</p>
     *
     *  <p>The <code>global</code> selector is similar to a type selector
     *  and does not start with a period.</p>
     *
     *  @param selector The name of the CSS selector.
     *
     *  @return The style declaration whose name matches the <code>selector</code> property.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	function getStyleDeclaration(selector:String):CSSStyleDeclaration;
	
    /**
     *  Sets the CSSStyleDeclaration object that stores the rules
     *  for the specified CSS selector.
     *
     *  <p>If the <code>selector</code> parameter starts with a period (.),
     *  the specified selector is a "class selector" and applies only to those instances
     *  whose <code>styleName</code> property specifies that selector
     *  (not including the period).
     *  For example, the class selector <code>".bigMargins"</code>
     *  applies to any UIComponent whose <code>styleName</code>
     *  is <code>"bigMargins"</code>.</p>
     *
     *  <p>If the <code>selector</code> parameter does not start with a period,
     *  the specified selector is a "type selector" and applies to all instances
     *  of that type.
     *  For example, the type selector <code>"Button"</code>
     *  applies to all instances of Button and its subclasses.</p>
     *
     *  <p>The <code>global</code> selector is similar to a type selector
     *  and does not start with a period.</p>
     *
     *  @param selector The name of the CSS selector.
     *  @param styleDeclaration The new style declaration.
     *  @param update Set to <code>true</code> to force an immediate update of the styles; internally, Flex
     *  calls the <code>styleChanged()</code> method of UIComponent.
     *  Set to <code>false</code> to avoid an immediate update of the styles in the application.
     * 
     *  <p>The styles will be updated the next time one of the following methods is called with
     *  the <code>update</code> property set to <code>true</code>:
     *  <ul>
     *   <li><code>clearStyleDeclaration()</code></li>
     *   <li><code>loadStyleDeclarations()</code></li>
     *   <li><code>setStyleDeclaration()</code></li>
     *   <li><code>unloadStyleDeclarations()</code></li>
     *  </ul>
     *  </p>
     * 
     *  <p>Typically, if you call the one of these methods multiple times, 
     *  you set this property to <code>true</code> only on the last call,
     *  so that Flex does not call the <code>styleChanged()</code> method multiple times.</p>
     * 
     *  <p>If you call the <code>getStyle()</code> method, Flex returns the style value 
     *  that was last applied to the UIComponent through a call to the <code>styleChanged()</code> method. 
     *  The component's appearance might not reflect the value returned by the <code>getStyle()</code> method. This occurs
     *  because one of these style declaration methods might not yet have been called with the 
     *  <code>update</code> property set to <code>true</code>.</p>
     *  
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	function setStyleDeclaration(selector:String,
								styleDeclaration:CSSStyleDeclaration,
								update:Boolean):void;
	
    /**
     *  Clears the CSSStyleDeclaration object that stores the rules
     *  for the specified CSS selector.
     *
     *  <p>If the specified selector is a class selector (for example, ".bigMargins" or ".myStyle"),
     *  you must be sure to start the
     *  <code>selector</code> property with a period (.).</p>
     *
     *  <p>If the specified selector is a type selector (for example, "Button"), do not start the
     *  <code>selector</code> property with a period.</p>
     *
     *  <p>The <code>global</code> selector is similar to a type selector
     *  and does not start with a period.</p>
     *
     *  @param selector The name of the CSS selector to clear.
     *  @param update Set to <code>true</code> to force an immediate update of the styles.
     *  Set to <code>false</code> to avoid an immediate update of the styles in the application.
     *  For more information about this method, see the description in the <code>setStyleDeclaration()</code>
     *  method.
     *  
     *  @see #setStyleDeclaration()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
	function clearStyleDeclaration(selector:String, update:Boolean):void;
     */
	
    /**
     *  Adds to the list of styles that can inherit values
     *  from their parents.
     *
     *  <p><b>Note:</b> Ensure that you avoid using duplicate style names, as name
     *  collisions can result in decreased performance if a style that is
     *  already used becomes inheriting.</p>
     *
     *  @param styleName The name of the style that is added to the list of styles that can inherit values.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
	function registerInheritingStyle(styleName:String):void;
     */
	
    /**
     *  Tests to see if a style is inheriting.
     *
     *  @param styleName The name of the style that you test to see if it is inheriting.
     *
     *  @return Returns <code>true</code> if the specified style is inheriting.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
	function isInheritingStyle(styleName:String):Boolean;
     */
	
    /**
     *  Test to see if a TextFormat style is inheriting.
     *
     *  @param styleName The name of the style that you test to see if it is inheriting.
     *
     *  @return Returns <code>true</code> if the specified TextFormat style
     *  is inheriting.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
	function isInheritingTextFormatStyle(styleName:String):Boolean;
     */
	
    /**
     *  Adds to the list of styles which may affect the measured size
     *  of the component.
     *  When one of these styles is set with <code>setStyle()</code>,
     *  the <code>invalidateSize()</code> method is automatically called on the component
     *  to make its measured size get recalculated later.
     *
     *  @param styleName The name of the style that you add to the list.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
	function registerSizeInvalidatingStyle(styleName:String):void;
     */
	
    /**
     *  Tests to see if a style changes the size of a component.
     *
     *  <p>When one of these styles is set with the <code>setStyle()</code> method,
     *  the <code>invalidateSize()</code> method is automatically called on the component
     *  to make its measured size get recalculated later.</p>
     *
     *  @param styleName The name of the style to test.
     *
     *  @return Returns <code>true</code> if the specified style is one
     *  which may affect the measured size of the component.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
	function isSizeInvalidatingStyle(styleName:String):Boolean;
     */
	
    /**
     *  Adds to the list of styles which may affect the measured size
     *  of the component's parent container.
     *  <p>When one of these styles is set with <code>setStyle()</code>,
     *  the <code>invalidateSize()</code> method is automatically called on the component's
     *  parent container to make its measured size get recalculated
     *  later.</p>
     *
     *  @param styleName The name of the style to register.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
	function registerParentSizeInvalidatingStyle(styleName:String):void;
     */
	
    /**
     *  Tests to see if the style changes the size of the component's parent container.
     *
     *  <p>When one of these styles is set with <code>setStyle()</code>,
     *  the <code>invalidateSize()</code> method is automatically called on the component's
     *  parent container to make its measured size get recalculated
     *  later.</p>
     *
     *  @param styleName The name of the style to test.
     *
     *  @return Returns <code>true</code> if the specified style is one
     *  which may affect the measured size of the component's
     *  parent container.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
	function isParentSizeInvalidatingStyle(styleName:String):Boolean;
     */
	
    /**
     *  Adds to the list of styles which may affect the appearance
     *  or layout of the component's parent container.
     *  When one of these styles is set with <code>setStyle()</code>,
     *  the <code>invalidateDisplayList()</code> method is auomatically called on the component's
     *  parent container to make it redraw and/or relayout its children.
     *
     *  @param styleName The name of the style to register.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
	function registerParentDisplayListInvalidatingStyle(styleName:String):void;
     */
	
    /**
     *  Tests to see if this style affects the component's parent container in
     *  such a way as to require that the parent container redraws itself when this style changes.
     *
     *  <p>When one of these styles is set with <code>setStyle()</code>,
     *  the <code>invalidateDisplayList()</code> method is auomatically called on the component's
     *  parent container to make it redraw and/or relayout its children.</p>
     *
     *  @param styleName The name of the style to test.
     *
     *  @return Returns <code>true</code> if the specified style is one
     *  which may affect the appearance or layout of the component's
     *  parent container.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
	function isParentDisplayListInvalidatingStyle(styleName:String):Boolean;
     */
	
    /**
     *  Adds a color name to the list of aliases for colors.
     *
     *  @param colorName The name of the color to add to the list; for example, "blue".
     *  If you later access this color name, the value is not case-sensitive.
     *
     *  @param colorValue Color value, for example, 0x0000FF.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
	function registerColorName(colorName:String, colorValue:uint):void;
     */
	
    /**
     *  Tests to see if the given String is an alias for a color value. For example,
     *  by default, the String "blue" is an alias for 0x0000FF.
     *
     *  @param colorName The color name to test. This parameter is not case-sensitive.
     *
     *  @return Returns <code>true</code> if <code>colorName</code> is an alias
     *  for a color.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
	function isColorName(colorName:String):Boolean;
     */
	
    /**
     *  Returns the numeric RGB color value that corresponds to the
     *  specified color string.
     *  The color string can be either a case-insensitive color name
     *  such as <code>"red"</code>, <code>"Blue"</code>, or
     *  <code>"haloGreen"</code>, a hexadecimal value such as 0xFF0000, or a #-hexadecimal String
     *  such as <code>"#FF0000"</code>.
     *
     *  <p>This method returns a uint, such as 4521830, that represents a color. You can convert
     *  this uint to a hexadecimal value by passing the numeric base (in this case, 16), to
     *  the uint class's <code>toString()</code> method, as the following example shows:</p>
     *  <pre>
     *  import mx.styles.StyleManager;
     *  private function getNewColorName():void {
     *      StyleManager.registerColorName("soylentGreen",0x44FF66);
     *      trace(StyleManager.getColorName("soylentGreen").toString(16));
     *  }
     *  </pre>
     *
     *  @param colorName The color name.
     *
     *  @return Returns a uint that represents the color value or <code>NOT_A_COLOR</code>
     *  if the value of the <code>colorName</code> property is not an alias for a color.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
	function getColorName(colorName:Object):uint;
     */
	
    /**
     *  Converts each element of the colors Array from a color name
     *  to a numeric RGB color value.
     *  Each color String can be either a case-insensitive color name
     *  such as <code>"red"</code>, <code>"Blue"</code>, or
     *  <code>"haloGreen"</code>, a hexadecimal value such as 0xFF0000, or a #-hexadecimal String
     *  such as <code>"#FF0000"</code>..
     *
     *  @param colors An Array of color names.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	//function getColorNames(colors:Array /* of Number or String */):void;
	
    /**
     *  Determines if a specified parameter is a valid style property. For example:
     *
     *  <pre>
     *  trace(StyleManager.isValidStyleValue(myButton.getStyle("color")).toString());
     *  </pre>
     *
     *  <p>This can be useful because some styles can be set to values
     *  such as 0, <code>NaN</code>,
     *  the empty String (<code>""</code>), or <code>null</code>, which can
     *  cause an <code>if (value)</code> test to fail.</p>
     *
     *  @param value The style property to test.
     *
     *  @return If you pass the value returned by a <code>getStyle()</code> method call
     *  to this method, it returns <code>true</code> if the style
     *  was set and <code>false</code> if it was not set.
     *
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	function isValidStyleValue(value:*):Boolean;
    
    /**
     *  Loads a style SWF.
     *
     *  @param url Location of the style SWF.
     *
     *  @param update Set to <code>true</code> to force
     *  an immediate update of the styles.
     *  Set to <code>false</code> to avoid an immediate update
     *  of the styles in the application.
     *  This parameter is optional and defaults to <code>true</code>
     *  For more information about this parameter, see the description
     *  in the <code>setStyleDeclaration()</code> method.
     *
     *  @param trustContent Obsolete, no longer used.
     *  This parameter is optional and defaults to <code>false</code>.
     *
     *  @param applicationDomain The ApplicationDomain passed to the
     *  <code>load()</code> method of the IModuleInfo that loads the style SWF.
     *  This parameter is optional and defaults to <code>null</code>.
     *
     *  @param securityDomain The SecurityDomain passed to the
     *  <code>load()</code> method of the IModuleInfo that loads the style SWF.
     *  This parameter is optional and defaults to <code>null</code>.
     * 
     *  @return An IEventDispatcher implementation that supports
     *          StyleEvent.PROGRESS, StyleEvent.COMPLETE, and
     *          StyleEvent.ERROR.
     *
     *  @see #setStyleDeclaration()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 4
    function loadStyleDeclarations(
                    url:String, update:Boolean = true,
                    trustContent:Boolean = false,
                    applicationDomain:ApplicationDomain = null,
                    securityDomain:SecurityDomain = null):IEventDispatcher;
     */

    /**
     *  Unloads a style SWF.
     *
     *  @param url Location of the style SWF.
     *  @param update Set to <code>true</code> to force an immediate update of the styles.
     *  Set to <code>false</code> to avoid an immediate update of the styles in the application.
     *  For more information about this method, see the description in the <code>setStyleDeclaration()</code>
     *  method.
     *  
     *  @see #setStyleDeclaration()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
	function unloadStyleDeclarations(
					url:String, update:Boolean = true):void;
     */

    /**
     *  @private
     *  This method is called by code autogenerated by the MXML compiler,
     *  after StyleManager.styles is popuplated with CSSStyleDeclarations.
	function initProtoChainRoots():void;
     */
	
    /**
     *  @private
     *  After an entire selector is added, replaced, or removed,
     *  this method updates all the DisplayList trees.
	function styleDeclarationsChanged():void;
     */
}

}
