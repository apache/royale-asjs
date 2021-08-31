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

package spark.components.supportClasses
{
COMPILE::JS
{
    import goog.DEBUG;
    import org.apache.royale.core.WrappedHTMLElement;
    import org.apache.royale.html.util.addElementToWrapper;
}

/*
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.ui.Keyboard;
import flash.utils.Timer;

import mx.core.IVisualElement;
import mx.core.InteractionMode;
import mx.core.mx_internal;
import mx.events.FlexEvent;
import mx.events.SandboxMouseEvent;
import mx.events.TouchInteractionEvent;

import spark.core.IDisplayText;
import spark.primitives.BitmapImage;

use namespace mx_internal;
*/
import spark.components.Label;
import org.apache.royale.core.ITextModel;
import org.apache.royale.events.Event;
import org.apache.royale.events.IEventDispatcher;
import mx.managers.IFocusManagerComponent;

//--------------------------------------
//  Styles
//--------------------------------------

//include "../../styles/metadata/BasicInheritingTextStyles.as"

/**
 *  The radius of the corners of this component.
 *
 *  @default 4
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[Style(name="cornerRadius", type="Number", format="Length", inherit="no", theme="spark", minValue="0.0")]

/**
 *  The alpha of the focus ring for this component.
 *
 *  @default 0.5
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[Style(name="focusAlpha", type="Number", inherit="no", theme="spark, mobile", minValue="0.0", maxValue="1.0")]

/**
 *  @copy spark.components.supportClasses.GroupBase#style:focusColor
 *   
 *  @default 0x70B2EE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */ 
//[Style(name="focusColor", type="uint", format="Color", inherit="yes", theme="spark, mobile")]

/**
 *  Class or instance to use as the default icon.
 *  The icon can render from various graphical sources, including the following:  
 *  <ul>
 *   <li>A Bitmap or BitmapData instance.</li>
 *   <li>A class representing a subclass of DisplayObject. The BitmapFill 
 *       instantiates the class and creates a bitmap rendering of it.</li>
 *   <li>An instance of a DisplayObject. The BitmapFill copies it into a 
 *       Bitmap for filling.</li>
 *   <li>The name of an external image file. </li>
 *  </ul>
 * 
 *  @default null 
 * 
 *  @see spark.primitives.BitmapImage.source
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5
 */
//[Style(name="icon", type="Object", inherit="no")]

/**
 *  Orientation of the icon in relation to the label.
 *  Valid MXML values are <code>right</code>, <code>left</code>,
 *  <code>bottom</code>, and <code>top</code>.
 *
 *  <p>In ActionScript, you can use the following constants
 *  to set this property:
 *  <code>IconPlacement.RIGHT</code>,
 *  <code>IconPlacement.LEFT</code>,
 *  <code>IconPlacement.BOTTOM</code>, and
 *  <code>IconPlacement.TOP</code>.</p>
 *
 *  @default IconPlacement.LEFT
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[Style(name="iconPlacement", type="String", enumeration="top,bottom,right,left", inherit="no", theme="spark, mobile")]

/**
 *  Number of milliseconds to wait after the first <code>buttonDown</code>
 *  event before repeating <code>buttonDown</code> events at each 
 *  <code>repeatInterval</code>.
 * 
 *  @default 500
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[Style(name="repeatDelay", type="Number", format="Time", inherit="no", minValue="0.0")]

/**
 *  Number of milliseconds between <code>buttonDown</code> events
 *  if the user presses and holds the mouse on a button.
 *  
 *  @default 35
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[Style(name="repeatInterval", type="Number", format="Time", inherit="no", minValueExclusive="0.0")]

/**
 *  When in touch interaction mode, the number of milliseconds to wait after the user 
 *  interaction has occured before showing the component in a visually down state.
 * 
 *  <p>The reason for this delay is because when a user initiates a scroll gesture, we don't want 
 *  components to flicker as they touch the screen.  By having a reasonable delay, we make 
 *  sure that the user still gets feedback when they press down on a component, but that the 
 *  feedback doesn't come too quickly that it gets displayed during a scroll gesture 
 *  operation.</p>
 *  
 *  <p>If the mobile theme is applied, the default value for this style is 100 ms for 
 *  components inside of a Scroller and 0 ms for components outside of a Scroller.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10.1
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5
 */
//[Style(name="touchDelay", type="Number", format="Time", inherit="yes", minValue="0.0")]

//[Style(name="direction", type="String", inherit="yes")]
//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched when the user presses the ButtonBase control.
 *  If the <code>autoRepeat</code> property is <code>true</code>,
 *  this event is dispatched repeatedly as long as the button stays down.
 *
 *  @eventType mx.events.FlexEvent.BUTTON_DOWN
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[Event(name="buttonDown", type="mx.events.FlexEvent")]

//--------------------------------------
//  Skin states
//--------------------------------------

/**
 *  Up State of the Button
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[SkinState("up")]

/**
 *  Over State of the Button
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[SkinState("over")]

/**
 *  Down State of the Button
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[SkinState("down")]

/**
 *  Disabled State of the Button
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[SkinState("disabled")]
 
//--------------------------------------
//  Other metadata
//--------------------------------------

//[AccessibilityClass(implementation="spark.accessibility.ButtonBaseAccImpl")]

[DefaultTriggerEvent("click")]

[DefaultProperty("label")]

/**
 *  The ButtonBase class is the base class for the all Spark button components.
 *  The Button and ToggleButtonBase classes are subclasses of ButtonBase.
 *  ToggleButton. 
 *  The CheckBox and RadioButton classes are subclasses of ToggleButtonBase.
 * 
 *  @mxml
 *
 *  <p>The <code>&lt;s:ButtonBase&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;s:ButtonBase
 *    <strong>Properties</strong>
 *    autoRepeat="false"
 *    content="null"
 *    label=""
 *    stickyHighlighting="false"
 *  
 *    <strong>Events</strong>
 *    buttonDown="<i>No default</i>"
 *
 *    <strong>Styles</strong>
 *    alignmentBaseline="USE_DOMINANT_BASELINE"
 *    cffHinting="HORIZONTAL_STEM"
 *    color="0"
 *    cornerRadius="4"
 *    digitCase="DEFAULT"
 *    digitWidth="DEFAULT"
 *    direction="LTR"
 *    dominantBaseline="AUTO"
 *    focusAlpha="0.5"
 *    focusColor="0x70B2EE"
 *    fontFamily="Arial"
 *    fontLookup="DEVICE"
 *    fontSize="12"
 *    fontStyle="NORMAL"
 *    fontWeight="NORMAL"
 *    justificationRule="AUTO"
 *    justificationStyle="AUTO"
 *    kerning="AUTO"
 *    ligatureLevel="COMMON"
 *    lineHeight="120%"
 *    lineThrough="false"
 *    locale="en"
 *    renderingMode="CFF"
 *    repeatDelay="500"
 *    repeatInterval="35"
 *    textAlign="START"
 *    textAlignLast="START"
 *    textAlpha="1"
 *    textDecoration="NONE"
 *    textJustify="INTER_WORD"
 *    trackingLeft="0"
 *    trackingRight="0"
 *    typographicCase="DEFAULT"
 *    wordSpacing="100%"
 *  /&gt;
 *  </pre>
 *
 *  @see spark.components.Button
 *  @see spark.components.supportClasses.ToggleButtonBase
 *  @see spark.components.ToggleButton
 *  @see spark.components.CheckBox
 *  @see spark.components.RadioButton
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public class ButtonBase extends SkinnableComponent implements IFocusManagerComponent
{
//    include "../../core/Version.as";
    
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
    public function ButtonBase()
    {
        super();

        // DisplayObjectContainer properties.
        // Setting mouseChildren to false ensures that mouse events
        // are dispatched from the Button itself,
        // not from its skins, icons, or TextField.
        // One reason for doing this is that if you press the mouse button
        // while over the TextField and release the mouse button while over
        // a skin or icon, we want the player to dispatch a "click" event.
        // Another is that if mouseChildren were true and someone uses
        // Sprites rather than Shapes for the skins or icons,
        // then we we wouldn't get a click because the current skin or icon
        // changes between the mouseDown and the mouseUp.
        // (This doesn't happen even when mouseChildren is true if the skins
        // and icons are Shapes, because Shapes never dispatch mouse events;
        // they are dispatched from the Button in this case.)
        COMPILE::SWF
        {
            mouseChildren = false;                
        }
    }   
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  label
    //----------------------------------

    [Bindable("contentChange")]
    [Inspectable(category="General", defaultValue="")]

    /**
     *  Text to appear on the ButtonBase control.
     * 
     *  <p>If the label is wider than the ButtonBase control,
     *  the label is truncated and terminated by an ellipsis (...).
     *  The full label displays as a tooltip
     *  when the user moves the mouse over the control.
     *  If you have also set a tooltip by using the <code>tooltip</code>
     *  property, the tooltip is displayed rather than the label text.</p>
     *
     *  <p>This is the default ButtonBase property.</p>
     *
     *  <p>This property is a <code>String</code> typed facade to the
     *  <code>content</code> property.  This property is bindable and it shares
     *  dispatching the "contentChange" event with the <code>content</code>
     *  property.</p> 
     *  
     *  @default ""
     *  @see #content
     *  @eventType contentChange
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function set label(value:String):void
    {
        ITextModel(model).text = value;
        COMPILE::JS {
            setInnerHTML();
        }
		if (parent)
			(parent as IEventDispatcher).dispatchEvent(new Event("layoutNeeded"));			
    }

    /**
     *  @private
     */
    public function get label():String          
    {
        return ITextModel(model).text;
    }

    private var _labelDisplay:Label;
    
    // not implemeted
    public function get labelDisplay():Label
    {
	if (!_labelDisplay)
	{
		_labelDisplay = new Label();
	}
	return _labelDisplay;
    }	
	
    /**
     * @royaleignorecoercion HTMLImageElement
     */
    COMPILE::JS
    protected function setInnerHTML():void
    {
        if (label != null) {
            element.innerHTML = label;
        }
                
        measuredWidth = Number.NaN;
        measuredHeight = Number.NaN;
    };
    
    /**
     * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
     */
    COMPILE::JS
    override protected function createElement():WrappedHTMLElement
    {
        addElementToWrapper(this,'button');
        element.setAttribute('type', 'button');
        
        return element;
    }

    public function get lineThrough():Boolean
    {
	return true;
    }
    public function set lineThrough(val:Boolean):void
    {
    }
    
    public function get textDecoration():String
    {
	return null;
    }
    public function set textDecoration(val:String):void
    {
    }
    
   private var _direction:String = "LTR";

    /**
     *  @private
     */
    public function get direction():String{
	
        return _direction;
    }
    
    public function set direction(value:String):void
    {
       _direction = value;
    }


}

}
