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

/* import flash.accessibility.Accessibility;
import flash.accessibility.AccessibilityProperties;
import flash.display.DisplayObject;
import flash.display.InteractiveObject;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.MouseEvent;
import flash.events.SoftKeyboardEvent;
import flash.system.Capabilities;

import flashx.textLayout.elements.TextFlow;
import flashx.textLayout.events.SelectionEvent;

import mx.core.FlexGlobals;
import mx.core.IIMESupport;
import mx.core.IVisualElement;
import mx.core.InteractionMode;
import mx.events.FlexEvent;
import mx.events.SandboxMouseEvent;
import mx.events.TouchInteractionEvent;
import mx.utils.Platform;

import spark.components.Application;
import spark.components.TextSelectionHighlighting;
import spark.core.IDisplayText;
import spark.core.IProxiedStageTextWrapper;
import spark.core.ISoftKeyboardHintClient;
import spark.events.TextOperationEvent;
 */
import mx.core.mx_internal;
import mx.managers.IFocusManagerComponent;
import mx.utils.BitFlagUtil;

import spark.components.RichEditableText;
import spark.core.IEditableText;

import org.apache.royale.events.Event;
import org.apache.royale.events.MouseEvent;
import org.apache.royale.html.accessories.PasswordInputBead;
import org.apache.royale.textLayout.elements.TextFlow;

use namespace mx_internal;

//--------------------------------------
//  Styles
//--------------------------------------

/* include "../../styles/metadata/BasicNonInheritingTextStyles.as"
include "../../styles/metadata/BasicInheritingTextStyles.as"
include "../../styles/metadata/AdvancedInheritingTextStyles.as"
include "../../styles/metadata/SelectionFormatTextStyles.as" */

/**
 *  The alpha of the border for this component.
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
[Style(name="borderAlpha", type="Number", inherit="no", minValue="0.0", maxValue="1.0")]

/**
 *  The color of the border for this component.
 *  Supported in iOS7+ skins
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
[Style(name="borderColor", type="uint", format="Color", inherit="no", "mobile")]

/**
 *  Controls the visibility of the border for this component.
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[Style(name="borderVisible", type="Boolean", inherit="no", theme="spark, mobile")]

/**
 *  The alpha of the content background for this component.
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[Style(name="contentBackgroundAlpha", type="Number", inherit="yes", theme="spark, mobile", minValue="0.0", maxValue="1.0")]

/**
 *  @copy spark.components.supportClasses.GroupBase#style:contentBackgroundColor
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[Style(name="contentBackgroundColor", type="uint", format="Color", inherit="yes", theme="spark, mobile")]

/**
 *  The alpha of the focus ring for this component.
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[Style(name="focusAlpha", type="Number", inherit="no", theme="spark, mobile", minValue="0.0", maxValue="1.0")]

/**
 *  @copy spark.components.supportClasses.GroupBase#style:focusColor
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */ 
//[Style(name="focusColor", type="uint", format="Color", inherit="yes", theme="spark, mobile")]

/**
 *  Controls the visibility of prompt text for this component when it is empty
 *  and focused.
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10.2
 *  @playerversion AIR 2.5
 *  @productversion Royale 0.9.4.6
 */
//[Style(name="showPromptWhenFocused", type="Boolean", inherit="yes", theme="mobile")]

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispached after the <code>selectionAnchorPosition</code> and/or
 *  <code>selectionActivePosition</code> properties have changed
 *  for any reason.
 *
 *  <p><b>For the Mobile theme, this is not dispatched.</b></p>
 * 
 *  @eventType mx.events.FlexEvent.SELECTION_CHANGE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[Event(name="selectionChange", type="mx.events.FlexEvent")]

/**
 *  Dispatched before a user editing operation occurs.
 *  You can alter the operation, or cancel the event
 *  to prevent the operation from being processed.
 *
 *  <p><b>For the Mobile theme, this is not dispatched.</b></p>
 * 
 *  @eventType spark.events.TextOperationEvent.CHANGING
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[Event(name="changing", type="spark.events.TextOperationEvent")]

/**
 *  Dispatched after a user editing operation is complete.
 *
 *  @eventType spark.events.TextOperationEvent.CHANGE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
[Event(name="change", type="spark.events.TextOperationEvent")]

/**
 *  Dispatched when a keystroke is about to be input to
 *  the component.
 *
 *  <p><b>For the Mobile theme, this is not dispatched.</b></p>
 * 
 *  @eventType flash.events.TextEvent.TEXT_INPUT
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
// [Event(name="textInput", type="flash.events.TextEvent")]

//--------------------------------------
//  Skin states
//--------------------------------------

/**
 *  Normal state.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[SkinState("normal")]

/**
 *  Disabled state.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[SkinState("disabled")]

/**
 *  Normal state with prompt.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10.2
 *  @playerversion AIR 2.5
 *  @productversion Royale 0.9.4.5
 */
//[SkinState("normalWithPrompt")]

/**
 *  Disabled state with prompt.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10.2
 *  @playerversion AIR 2.5
 *  @productversion Royale 0.9.4.5
 */
//[SkinState("disabledWithPrompt")]

/**
 *  The base class for skinnable components, such as the Spark TextInput
 *  and TextArea, that include an instance of IEditableText in their skin
 *  to provide text display, scrolling, selection, and editing.
 *  By default, IEditableText is RichEditableText for the Spark theme and StyleableStageText
 *  for the Mobile theme. StyleableTextField is also available for the Mobile theme.
 *  
 *  @mxml
 *
 *  <p>The <code>&lt;s:SkinnableTextBase&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;s:SkinnableTextBase
 *    autoCapitalize="none"  <b>[Mobile theme only]</b>
 *    autoCorrect="true"  <b>[Mobile theme only]</b>
 *    displayAsPassword="false"
 *    editable="true"
 *    imeMode="null"  <b>[Spark theme only]</b>
 *    maxChars="0"
 *    prompt="null"
 *    restrict="null"
 *    returnLabelKey="default"  <b>[Mobile theme only]</b>
 *    selectable="true"
 *    selectionHighlighting="whenFocused"  <b>[Spark theme only]</b>
 *    softKeyBoardType="default"  <b>[Mobile theme only]</b>
 *    text=""
 *    typicalText="null"  <b>[Spark theme only]</b>
 *  
 *    <strong>Styles</strong>
 *    borderAlpha="1.0"
 *    borderColor="0x696969"
 *    borderVisible="true"
 *    contentBackgroundAlpha="1.0" 
 *    contentBackgroundColor="0xFFFFFF"
 *    focusAlpha="0.55"
 *    focusColor="0x70B2EE"
 *    showPromptWhenFocused="true"
 * 
 *    <strong>Events</strong>
 *    change="<i>No default</i>"
 *    changing="<i>No default</i>"  <b>[Spark theme only]</b>
 *    selectionChange="<i>No default</i>"  <b>[Spark theme only]</b>
 *    textInput="<i>No default</i>"  <b>[Spark theme only]</b>
 *  /&gt;
 *  </pre>
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
public class SkinnableTextBase extends SkinnableComponent 
    implements IFocusManagerComponent
{ //, IIMESupport, ISoftKeyboardHintClient
   // include "../../core/Version.as";
    
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    private static const CONTENT_PROPERTY_FLAG:uint = 1 << 0;

    /**
     *  @private
     */
   // private static const DISPLAY_AS_PASSWORD_PROPERTY_FLAG:uint = 1 << 1;
    
    /**
     *  @private
     */
   // private static const EDITABLE_PROPERTY_FLAG:uint = 1 << 2;
        
    /**
     *  @private
     */
 //   private static const HEIGHT_IN_LINES_PROPERTY_FLAG:uint = 1 << 3;
    
    /**
     *  @private
     */
 //   private static const IME_MODE_PROPERTY_FLAG:uint = 1 << 4;
    
    /**
     *  @private
     */
  //  private static const MAX_CHARS_PROPERTY_FLAG:uint = 1 << 5;
       
    /**
     *  @private
     */
  //  private static const MAX_WIDTH_PROPERTY_FLAG:uint = 1 << 7;
    
    /**
     *  @private
     */
   // private static const RESTRICT_PROPERTY_FLAG:uint = 1 << 8;

    /**
     *  @private
     */
  //  private static const SELECTABLE_PROPERTY_FLAG:uint = 1 << 9;

    /**
     *  @private
     */
  //  private static const SELECTION_HIGHLIGHTING_FLAG:uint = 1 << 10;

    /**
     *  @private
     */
  //  private static const TEXT_PROPERTY_FLAG:uint = 1 << 11;

    /**
     *  @private
     */
    private static const TEXT_FLOW_PROPERTY_FLAG:uint = 1 << 12;
    
    /**
     *  @private
     */
  //  private static const TYPICAL_TEXT_PROPERTY_FLAG:uint = 1 << 13;
    
    /**
     *  @private
     */
  //  private static const WIDTH_IN_CHARS_PROPERTY_FLAG:uint = 1 << 14;
    
    /**
     *  @private
     */
  //  private static const AUTO_CAPITALIZE_FLAG:uint = 1 << 15;
    
    /**
     *  @private
     */
  //  private static const AUTO_CORRECT_FLAG:uint = 1 << 16;
    
    /**
     *  @private
     */
  //  private static const RETURN_KEY_LABEL_FLAG:uint = 1 << 17;
    
    /**
     *  @private
     */
  //  private static const SOFT_KEYBOARD_TYPE_FLAG:uint = 1 << 18;

    /**
     *  @private
     */
  //  private static const PROMPT_TEXT_PROPERTY_FLAG:uint = 1;
    
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
     *  @productversion Royale 0.9.4
     */    
    public function SkinnableTextBase()
    {
        super();
    }
    
    private var _borderAlpha:Number;
    private var _borderColor:uint;
    
    public function get borderAlpha():Number
    {
        return _borderAlpha;
    } 
    
    /**
     *  @private
     */
    public function set borderAlpha(value:Number):void
    {
        _borderAlpha = value;
    } 
	
    public function get borderColor():uint
    {
        return _borderColor;
    } 
    /**
     *  @private
     */
    public function set borderColor(value:uint):void
    {
        _borderColor = value;
    } 
    
    
    public function get contentBackgroundColor():uint
    {
        return getStyle("backgroundColor");
    }
    
    public function set contentBackgroundColor(val:uint):void
    {
        setStyle("contentBackgroundColor", val);
    }
    
    public function get contentBackgroundAlpha():Number
    {
	return 0;
    }
    public function set contentBackgroundAlpha(val:Number):void
    {
    }
    
    public function get borderVisible():Boolean
    {
	return true;
    }
    public function set borderVisible(val:Boolean):void
    {
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
    
    public function get textAlignLast():String
    {
	return "";
    }
    public function set textAlignLast(val:String):void
    {
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //-------------------------------------------------------------------------- 

    /**
     *  @private
     */  
  //  private var touchHandlersAdded:Boolean = false;
    
    /**
     *  @private
     *  True if we received a mouseDown and we haven't receieved a mouseUp yet
     */
  //  private var isTouchMouseDown:Boolean = false;
    
    /**
     *  @private
     *  True if setFocus is called while isTouchMouseDown is true
     */
   // private var delaySetFocus:Boolean = false;
    
    /**
     *  @private
     *  The target from the current mouseDown event
     */
  //  private var touchMouseDownTarget:InteractiveObject;
    
    /**
     *  @private
     *  Variable that determines whether this application is running on iOS.
     */
  //  private static var isIOS:Boolean = Platform.isIOS;
    
    //--------------------------------------------------------------------------
    //
    //  Skin parts
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  promptDisplay
    //----------------------------------
    
   // [SkinPart(required="false")]
    
    /**
     *  The Label or other IDisplayText that might be present
     *  in any skin assigned to this component.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    //public var promptDisplay:IDisplayText;
    
    /**
     *  @private
     *  Properties are proxied to promptDisplay.  However, when 
     *  promptDisplay is not around, we need to store values set on 
     *  SkinnableTextBase.  This object stores those values.  If promptDisplay is 
     *  around, the values are  stored  on the promptDisplay directly.  However, 
     *  we need to know what values have been set by the developer on 
     *  TextInput/TextArea (versus set on the promptDisplay or defaults of the 
     *  promptDisplay) as those are values we want to carry around if the 
     *  promptDisplay changes (via a new skin). In order to store this info 
     *  efficiently, promptDisplayProperties becomes a uint to store a series of 
     *  BitFlags.  These bits represent whether a property has been explicitly 
     *  set on this SkinnableTextBase.  When the promptDisplay is not around, 
     *  promptDisplayProperties is a typeless object to store these proxied 
     *  properties.  When promptDisplay is around, promptDisplayProperties stores 
     *  booleans as to whether these properties have been explicitly set or not.
     */
    //private var promptDisplayProperties:Object = {};
    
    //----------------------------------
    //  textDisplay
    //----------------------------------

   // [Bindable]
   // [SkinPart(required="false")]

    /**
     *  The IEditableText that may be present
     *  in any skin assigned to this component.
     *  This is RichEditableText for the Spark theme
     *  and StyleableStageText/ScrollableStageText for the Mobile theme.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
  	public var textDisplay:IEditableText;

    /**
     *  @private
     *  Several properties are proxied to textDisplay.  However, when 
     *  textDisplay is not around, we need to store values set on 
     *  SkinnableTextBase.  This object stores those values.  If textDisplay is 
     *  around, the values are  stored  on the textDisplay directly.  However, 
     *  we need to know what values have been set by the developer on 
     *  TextInput/TextArea (versus set on the textDisplay or defaults of the 
     *  textDisplay) as those are values we want to carry around if the 
     *  textDisplay changes (via a new skin). In order to store this info 
     *  efficiently, textDisplayProperties becomes a uint to store a series of 
     *  BitFlags.  These bits represent whether a property has been explicitly 
     *  set on this SkinnableTextBase.  When the  textDisplay is not around, 
     *  textDisplayProperties is a typeless object to store these proxied 
     *  properties.  When textDisplay is around, textDisplayProperties stores 
     *  booleans as to whether these properties have been explicitly set or not.
     */
    private var textDisplayProperties:Object = {};
   
    //--------------------------------------------------------------------------
    //
    //  Overridden properties: UIComponent
    //
    //--------------------------------------------------------------------------
    
    /*
    
    Note:
    
    SkinnableTextBase does not have an accessibilityImplementation
    because, if it does, the Flash Player doesn't support text-selection
    accessibility. The selectionAnchorIndex and selectionActiveIndex
    getters of the acc impl don't get called, probably because Player 10.1
    doesn't like the fact that stage.focus is the texDisplay:RichEditableText
    part instead of the SinnableTextBase component (i.e., the TextInput
    or TextArea).
    
    Instead, we rely on the RichEditableTextAccImpl of the textDisplay
    to provide accessibility.
    
    However, developers expect to be able to control accessibility by setting
    accessibilityProperties, accessibilityName, accessibilityDescription,
    tabIndex, etc. on the component itself.
    
    In order to make these settings usable by RichEditableTextAccImpl,
    we push them down into the accessibilityProperties of the RichEditableText,
    using the invalidateProperties() / commitProperties() pattern.
    
    */

    //----------------------------------
    //  accessibilityEnabled
    //----------------------------------
    
    /**
     *  @private
     */
    /* override public function set accessibilityEnabled(value:Boolean):void
    {
        if (!Capabilities.hasAccessibility)
            return;
            
        if (!accessibilityProperties)
            accessibilityProperties = new AccessibilityProperties();
        
        accessibilityProperties.silent = !value;
        accessibilityPropertiesChanged = true;
        
        invalidateProperties();
    } */
    
    //----------------------------------
    //  accessibilityDescription
    //----------------------------------
    
    /**
     *  @private
     */
   /*  override public function set accessibilityDescription(value:String):void
    {
        if (!Capabilities.hasAccessibility)
            return;
        
        if (!accessibilityProperties)
            accessibilityProperties = new AccessibilityProperties();
        
        accessibilityProperties.description = value;
        accessibilityPropertiesChanged = true;
        
        invalidateProperties();
    } */
    
    //----------------------------------
    //  accessibilityName
    //----------------------------------
    
    /**
     *  @private
     */
    /* override public function set accessibilityName(value:String):void 
    {
        if (!Capabilities.hasAccessibility)
            return;
        
        if (!accessibilityProperties)
            accessibilityProperties = new AccessibilityProperties();
        
        accessibilityProperties.name = value;
        accessibilityPropertiesChanged = true;
        
        invalidateProperties();
    } */
    
    //----------------------------------
    //  accessibilityProperties
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the accessibilityProperties property.
     */
   // private var _accessibilityProperties:AccessibilityProperties = null;

    /**
     *  @private
     */
   // private var accessibilityPropertiesChanged:Boolean = false;
    
    /**
     *  @private
     */
    /* override public function get accessibilityProperties():AccessibilityProperties
    {
        return _accessibilityProperties;
    } */
    
    /**
     *  @private
     */
    /* override public function set accessibilityProperties(
                                    value:AccessibilityProperties):void
    {
        _accessibilityProperties = value;
        accessibilityPropertiesChanged = true;
        
        invalidateProperties();
    } */
    
    //----------------------------------
    //  accessibilityShortcut
    //----------------------------------
    
    /**
     *  @private
     */
    /* override public function set accessibilityShortcut(value:String):void
    {
        if (!Capabilities.hasAccessibility)
            return;     
        
        if (!accessibilityProperties)
            accessibilityProperties = new AccessibilityProperties();
        
        accessibilityProperties.shortcut = value;
        accessibilityPropertiesChanged = true;
        
        invalidateProperties();
    } */

    //----------------------------------
    //  baselinePosition
    //----------------------------------
    
    /**
     *  @private
     */
   /*  override public function get baselinePosition():Number
    {
        return getBaselinePositionForPart(textDisplay as IVisualElement);
    } */
    
    //----------------------------------
    //  enabled
    //----------------------------------
    
    /**
     *  @private
     */
    override public function set enabled(value:Boolean):void
    {
        if (textDisplay)
            textDisplay.enabled = value;
        
        if (value == super.enabled)
            return;
        
        super.enabled = value;
    }

    //----------------------------------
    //  maxWidth
    //----------------------------------

    /**
     *  @private
     */
    /* override public function get maxWidth():Number
    {
        var richEditableText:RichEditableText = textDisplay as RichEditableText;

        if (richEditableText)
            return richEditableText.maxWidth;
            
        // want the default to be default max width for UIComponent
        var v:* = textDisplay ? undefined : textDisplayProperties.maxWidth;
        return (v === undefined) ? super.maxWidth : v;        
    } */

    /**
     *  @private
     */
    /* override public function set maxWidth(value:Number):void
    {
        if (textDisplay)
        {
            var richEditableText:RichEditableText = textDisplay as RichEditableText;
            
            if (richEditableText)
                richEditableText.maxWidth = value;
            else
                super.maxWidth = value;
            textDisplayProperties = BitFlagUtil.update(
                uint(textDisplayProperties), MAX_WIDTH_PROPERTY_FLAG, true);
        }
        else
        {
            textDisplayProperties.maxWidth = value;
        }

        // Generate an UPDATE_COMPLETE event.
        invalidateProperties();                    
    } */

    //----------------------------------
    //  prompt
    //----------------------------------
    
   // [Inspectable(category="General", defaultValue="")]

    /**
     *  Text to be displayed if/when the actual text property is an empty string.
     * 
     *  <p>Prompt text appears when the text control is first created. 
     *  Prompt text disappears when the control gets focus or when the control’s 
     *  <code>text</code> property is a non-empty string. 
     *  Prompt text reappears when the control loses focus, but only if no text was entered 
     *  (if the value of the text field is the empty string).</p>
     *  
     *  <p>For text controls, if the user enters text, but later deletes it, the prompt text 
     *  reappears when the control loses focus. 
     *  You can also cause the prompt text to reappear programmatically by setting the 
     *  text control’s text property to the empty string.</p>
     *  
     *  <p>You can change the style of the prompt text with CSS. 
     *  If the control has prompt text and is not disabled, the style is defined by the 
     *  <code>normalWithPrompt</code> pseudo selector. 
     *  If the control is disabled, then the styles defined by the <code>disabledWithPrompt</code> 
     *  pseudo selector are used.</p>
     *  
     *  <p>The following example CSS changes the color of the prompt text in controls that 
     *  sub-class SkinnableTextBase (this includes the Spark TextInput and TextArea controls):
     *  <pre>
     *  &#64;namespace s "library://ns.adobe.com/flex/spark";
     *  s|SkinnableTextBase:normalWithPrompt {
     *      color: #CCCCFF;
     *  }
     *  </pre>
     *  </p>
     *
     *  @default null
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.0
     *  @productversion Royale 0.9.4.5
     */
    /* public function get prompt():String
    {
        return getPrompt();
    } */
    
    /**
     *  @private
     */
   /*  public function set prompt(value:String):void
    {
        setPrompt(value);
    } */
    
    //----------------------------------
    //  tabIndex
    //----------------------------------

    /**
     *  @private
     *  Storage for the tabIndex property.
     */
   // private var _tabIndex:int = -1;
    
    /**
     *  @private
     */
    /* override public function get tabIndex():int
    {
        return _tabIndex;
    } */
    
    /**
     *  @private
     */
    /* override public function set tabIndex(
                                    value:int):void
    {
        _tabIndex = value;
        accessibilityPropertiesChanged = true;
        
        invalidateProperties();
    } */
        
    //----------------------------------
    //  typicalText
    //----------------------------------
    
    //[Inspectable(category="General", defaultValue="null")]

    /**
     *  Text that is used to determine
     *  the default width and height of the control, 
     *  without actually being displayed.
     * 
     *  <p><b>For the Spark theme, see
     *  spark.components.RichEditableText.typicalText</b></p>
     *
     *  <p><b>For the Mobile theme, this is not supported.</b></p>
     * 
     *  @see spark.components.RichEditableText#typicalText
     * 
     *  @default null
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function get typicalText():String
    {
        return getTypicalText();
    } */
    
    /**
     *  @private
     */
    /* public function set typicalText(value:String):void
    {
        setTypicalText(value);
    } */
    
    //--------------------------------------------------------------------------
    //
    //  Properties proxied to textDisplay
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  displayAsPassword
    //----------------------------------
    /**
     *  @private
     *  Storage for the displayAsPassword property.
     */
    private var _displayAsPassword:Boolean = false;

    /**
     *  @private
     */
	private var _passwordBead:PasswordInputBead;
    private var displayAsPasswordChanged:Boolean = false;

    [Bindable("displayAsPasswordChanged")]
    [Inspectable(category="General", defaultValue="false")]

    /**
     *  Indicates whether this control is used for entering passwords.
     *  If <code>true</code>, the field does not display entered text,
     *  instead, each text character entered into the control
     *  appears as the  character "&#42;".
     *
     *  @default false
     *  @tiptext Specifies whether to display '*'
     *  instead of the actual characters
     *  @helpid 3197
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get displayAsPassword():Boolean
    {
        return _displayAsPassword;
    }

    /**
     *  @private
     */
    public function set displayAsPassword(value:Boolean):void
    {
        if (value == _displayAsPassword)
            return;

        _displayAsPassword = value;
//        displayAsPasswordChanged = true;
//
//        invalidateProperties();
//        invalidateSize();
//        invalidateDisplayList();;
		
		if (_displayAsPassword && _passwordBead == null) {
			_passwordBead = new PasswordInputBead();
			addBead(_passwordBead);
		}
		else if (!_displayAsPassword && _passwordBead != null) {
			removeBead(_passwordBead);
			_passwordBead = null;
		}

        dispatchEvent(new Event("displayAsPasswordChanged"));
    }
    

    //----------------------------------
    //  editable
    //----------------------------------

    [Inspectable(category="General", defaultValue="true")]

    /**
     *  Specifies whether the text is editable.
     * 
     *  <p><b>For the Spark theme, see
     *  spark.components.RichEditableText.editable</b></p>
     *
     *  <p><b>For the Mobile theme, see
     *  spark.components.supportClasses.StyleableStageText.editable</b></p>
     * 
     *  @default true
     * 
     *  @see spark.components.RichEditableText#editable
     *  @see spark.components.supportClasses.StyleableStageText#editable
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function get editable():Boolean
    {
       /*  if (textDisplay)
            return textDisplay.editable; 
            
        // want the default to be true
        var v:* = textDisplayProperties.editable;
        return (v === undefined) ? true : v;*/
		return true;
    }

    /**
     *  @private
     */
    public function set editable(value:Boolean):void
    {
        /* if (textDisplay)
        {
            textDisplay.editable = value;
            textDisplayProperties = BitFlagUtil.update(
                uint(textDisplayProperties), EDITABLE_PROPERTY_FLAG, true);
        }
        else
        {
            textDisplayProperties.editable = value;
        }

        // Generate an UPDATE_COMPLETE event.
        invalidateProperties();  */                   
    }

    //----------------------------------
    //  enableIME
    //----------------------------------

    /**
     *  A flag that indicates whether the IME should
     *  be enabled when the component receives focus.
     * 
     *  <p><b>For the Mobile theme, this is not supported.</b></p>
     * 
     *  @see spark.components.RichEditableText#enableIME
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function get enableIME():Boolean
    {
        var richEditableText:RichEditableText = textDisplay as RichEditableText;
        
        if (richEditableText)        
            return richEditableText.enableIME;
        
        return false;
    } */

    //----------------------------------
    //  imeMode
    //----------------------------------

    /**
     *  Specifies the IME (input method editor) mode.
     * 
     *  <p><b>For the Spark theme, see
     *  spark.components.RichEditableText.imeMode</b></p>
     *
     *  <p><b>For the Mobile theme, this is not supported.</b></p>
     * 
     *  @see spark.components.RichEditableText#imeMode
     * 
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function get imeMode():String
    {
        var richEditableText:RichEditableText = textDisplay as RichEditableText;
                
        if (richEditableText)        
            return richEditableText.imeMode;
            
        // want the default to be null
        var v:* = textDisplay ? undefined : textDisplayProperties.imeMode;
        return (v === undefined) ? null : v;
    } */

    /**
     *  @private
     */
   /*  public function set imeMode(value:String):void
    {
        var richEditableText:RichEditableText = textDisplay as RichEditableText;

        if (textDisplay)
        {
            if (richEditableText)
                richEditableText.imeMode = value;
            textDisplayProperties = BitFlagUtil.update(
                uint(textDisplayProperties), IME_MODE_PROPERTY_FLAG, true);
        }
        else
        {
            textDisplayProperties.imeMode = value;
        }

        // Generate an UPDATE_COMPLETE event.
        invalidateProperties();                    
    } */

    //----------------------------------
    //  maxChars
    //---------------------------------
    
    private var _maxChars:int = 0;
   // [Inspectable(category="General", defaultValue="0")]    

    /**
     *  @copy flash.text.TextField#maxChars
     * 
     *  @default 0
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
     public function get maxChars():int 
    {
        /* if (textDisplay)
            return textDisplay.maxChars;
            
        // want the default to be 0
        var v:* = textDisplayProperties.maxChars;
        return (v === undefined) ? 0 : v; */
	
        return _maxChars;

    }     
    /**
     *  @private
     */
    public function set maxChars(value:int):void
    {
       /*  if (textDisplay)
        {
            textDisplay.maxChars = value;
            textDisplayProperties = BitFlagUtil.update(
                uint(textDisplayProperties), MAX_CHARS_PROPERTY_FLAG, true);
        }
        else
        {
            textDisplayProperties.maxChars = value;
        }

        // Generate an UPDATE_COMPLETE event.
        invalidateProperties();   */
	
	if (value == _maxChars)
            return;
            
        _maxChars = value;
    } 

    //----------------------------------
    //  restrict
    //----------------------------------

    [Inspectable(category="General", defaultValue="null")]

    /**
     *  @copy flash.text.TextField#restrict
     * 
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function get restrict():String 
    {
        /* if (textDisplay)
            return textDisplay.restrict;
            
        // want the default to be null
        var v:* = textDisplayProperties.restrict;
        return (v === undefined) ? null : v; */
		return "";
    } 
    
    /**
     *  @private
     */
     public function set restrict(value:String):void
    {
       /*  if (textDisplay)
        {
            textDisplay.restrict = value;
            textDisplayProperties = BitFlagUtil.update(
                uint(textDisplayProperties), RESTRICT_PROPERTY_FLAG, true);
        }
        else
        {
            textDisplayProperties.restrict = value;
        }

        // Generate an UPDATE_COMPLETE event.
        invalidateProperties();  */                   
    } 

    //----------------------------------
    //  selectable
    //----------------------------------

    //[Inspectable(category="General", defaultValue="true")]

    /**
     *  A flag indicating whether the content is selectable.  On a Desktop, a user can 
     *  select content with the mouse or with the keyboard when the control has 
     *  keyboard focus.  On a touch interaction device, a user can select text with 
     *  their fingers once they've entered into selection mode for the text component.
     * 
     *  <p><b>For the Spark theme, see
     *  spark.components.RichEditableText.selectable</b></p>
     *
     *  <p><b>For the Mobile theme, see
     *  spark.components.supportClasses.StyleableStageText.selectable</b></p>
     * 
     *  @see spark.components.RichEditableText#selectable
     *  @see spark.components.supportClasses.StyleableStageText#selectable
     *  
     *  @default true
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function get selectable():Boolean
    {
        if (textDisplay)
            return textDisplay.selectable;
            
        // want the default to be true
        var v:* = textDisplayProperties.selectable;
        return (v === undefined) ? true : v;
    } */

    /**
     *  @private
     */
    /* public function set selectable(value:Boolean):void
    {
        if (textDisplay)
        {
            textDisplay.selectable = value;
            textDisplayProperties = BitFlagUtil.update(
                uint(textDisplayProperties), SELECTABLE_PROPERTY_FLAG, true);
        }
        else
        {
            textDisplayProperties.selectable = value;
        }
        
        // Generate an UPDATE_COMPLETE event.
        invalidateProperties();                    
    } */

    //----------------------------------
    //  selectionActivePosition
    //----------------------------------

    /**
     *  @private
     */
    //[Bindable("selectionChange")]
    
    /**
     *  A character position, relative to the beginning of the
     *  <code>text</code> String, specifying the end of the selection
     *  that moves when the selection is extended with the arrow keys.
     * 
     *  <p><b>For the Spark theme, see
     *  spark.components.RichEditableText.selectionActivePosition</b></p>
     *
     *  <p><b>For the Mobile theme, see
     *  spark.components.supportClasses.StyleableStageText.selectionActivePosition</b></p>
     * 
     *  @see spark.components.RichEditableText#selectionActivePosition
     *  @see spark.components.supportClasses.StyleableStageText#selectionActivePosition
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function get selectionActivePosition():int
    {
        return 0; //textDisplay ? textDisplay.selectionActivePosition : -1;
    }

    //----------------------------------
    //  selectionAnchorPosition
    //----------------------------------

    /**
     *  @private
     */
    //[Bindable("selectionChange")]
    
    /**
     *  A character position, relative to the beginning of the
     *  <code>text</code> String, specifying the end of the selection
     *  that stays fixed when the selection is extended with the arrow keys.
     * 
     *  <p><b>For the Spark theme, see
     *  spark.components.RichEditableText.selectionAnchorPosition</b></p>
     *
     *  <p><b>For the Mobile theme, see
     *  spark.components.supportClasses.StyleableStageText.selectionAnchorPosition</b></p>
     * 
     *  @see spark.components.RichEditableText#selectionAnchorPosition
     *  @see spark.components.supportClasses.StyleableStageText#selectionAnchorPosition
     *   
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function get selectionAnchorPosition():int
    {
        return textDisplay ? textDisplay.selectionAnchorPosition : -1;
    } */

    //----------------------------------
    //  selectionHighlighting
    //----------------------------------

    //[Inspectable(category="General", enumeration="always,whenActive,whenFocused", defaultValue="whenFocused")]
    
    /**
     *  Determines when the text selection is highlighted.
     * 
     *  <p><b>For the Spark theme, see
     *  spark.components.RichEditableText.selectionHighlighting</b></p>
     *
     *  <p><b>For the Mobile theme, this is not supported.</b></p>
     * 
     *  @see spark.components.RichEditableText#selectionHighlighting
     * 
     *  @default TextSelectionHighlighting.WHEN_FOCUSED
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
   /*  public function get selectionHighlighting():String 
    {
        var richEditableText:RichEditableText = textDisplay as RichEditableText;
        
        if (richEditableText)
            return richEditableText.selectionHighlighting;
            
        // want the default to be "when focused"
        var v:* = textDisplay ? undefined : textDisplayProperties.selectionHighlighting;
        return (v === undefined) ? TextSelectionHighlighting.WHEN_FOCUSED : v;
    } */
    
    /**
     *  @private
     */
    /* public function set selectionHighlighting(value:String):void
    {
        if (textDisplay)
        {
            var richEditableText:RichEditableText = textDisplay as RichEditableText;
            
            if (richEditableText)
                richEditableText.selectionHighlighting = value;
            textDisplayProperties = BitFlagUtil.update(
                                    uint(textDisplayProperties), 
                                    SELECTION_HIGHLIGHTING_FLAG, true);
        }
        else
        {
            textDisplayProperties.selectionHighlighting = value;
        }

        // Generate an UPDATE_COMPLETE event.
        invalidateProperties();                    
    } */

    //----------------------------------
    //  text
    //----------------------------------
    
    [Inspectable(category="General", defaultValue="")]
    
    /**
     *  The text displayed by this text component.
     * 
     *  <p><b>For the Spark theme, see
     *  spark.components.RichEditableText.text</b></p>
     *
     *  <p><b>For the Mobile theme, see
     *  spark.components.supportClasses.StyleableStageText#text</b></p>
     * 
     *  @see spark.components.RichEditableText#text
     *  @see spark.components.supportClasses.StyleableStageText#text
     * 
     *  @default ""
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function get text():String
    {
        /* if (textDisplay)
            return textDisplay.text;
            
        // If there is no textDisplay, it isn't possible to set one of
        // text, textFlow or content and then get it in another form.
                    
        // want the default to be the empty string
        var v:* = textDisplayProperties.text;
        return (v === undefined) ? "" : v; */
		return "";
    }

    /**
     *  @private
     */
    public function set text(value:String):void
    {
        // text should never be null.  Convert null to the empty string.
        
        /* if (textDisplay)
        {
            textDisplay.text = value;
            textDisplayProperties = BitFlagUtil.update(
                uint(textDisplayProperties), TEXT_PROPERTY_FLAG, true);
        }
        else
        {
            textDisplayProperties.text = value ? value : "";

            // Of 'text', 'textFlow', and 'content', the last one set wins.  So
            // if we're holding onto the properties until the skin is loaded
            // make sure only the last one set is defined.
            textDisplayProperties.content = undefined;
            textDisplayProperties.textFlow = undefined;
        }

        // Generate an UPDATE_COMPLETE event.
        invalidateProperties();
        invalidateSkinState(); */
     } 

    //----------------------------------
    //  Mobile soft-keyboard hints
    //----------------------------------
    
    //----------------------------------
    //  autoCapitalize
    //----------------------------------
    
    //[Inspectable(category="General",enumeration="none,word,sentence,all",defaultValue="none")]

    /**
     *  Hint indicating what captialization behavior soft keyboards should
     *  use. 
     *
     *  <p>Supported values are defined in flash.text.AutoCapitalize:</p>
     * 
     *  <ul>
     *      <li><code>"none"</code> - no automatic capitalization</li>
     *      <li><code>"word"</code> - capitalize the first letter following any 
     *          space or punctuation</li>
     *      <li><code>"sentence"</code> - captitalize the first letter following 
     *          any period</li>
     *      <li><code>"all"</code> - capitalize every letter</li>
     *  </ul>
     *
     *  <p><b>For the Spark theme, this is not supported.</b></p>
     * 
     *  @default "none"
     * 
     *  @see flash.text.AutoCapitalize
     * 
     *  @langversion 3.0
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function get autoCapitalize():String
    {
        var softKeyboardClient:ISoftKeyboardHintClient = textDisplay as ISoftKeyboardHintClient;
        
        if (softKeyboardClient)
            return softKeyboardClient.autoCapitalize; 
        
        var v:* = textDisplay ? undefined : textDisplayProperties.autoCapitalize;
        return (v === undefined) ? "none" : v;
    }
    
    public function set autoCapitalize(value:String):void
    {
        if (textDisplay)
        {
            var softKeyboardClient:ISoftKeyboardHintClient = textDisplay as ISoftKeyboardHintClient;
            
            if (softKeyboardClient)
                softKeyboardClient.autoCapitalize = value;
            textDisplayProperties = BitFlagUtil.update(
                uint(textDisplayProperties), 
                AUTO_CAPITALIZE_FLAG, true);
        }
        else
        {
            textDisplayProperties.autoCapitalize = value;
        }
        
        // Generate an UPDATE_COMPLETE event.
        invalidateProperties();                    
    } */
    
    //----------------------------------
    //  autoCorrect
    //----------------------------------
    
    //[Inspectable(category="General",defaultValue="true")]

    /**
     *  Hint indicating whether a soft keyboard should use its auto-correct
     *  behavior, if supported.
     *  <p><b>For the Spark theme, this is not supported.</b></p>
     * 
     *  @default true
     *  
     *  @langversion 3.0
     *  @playerversion AIR 3.0
     *  @productversion Royale 0.9.4.6
     */
    /* public function get autoCorrect():Boolean
    {
        var softKeyboardClient:ISoftKeyboardHintClient = textDisplay as ISoftKeyboardHintClient;
        
        if (softKeyboardClient)
            return softKeyboardClient.autoCorrect; 
        
        var v:* = textDisplay ? undefined : textDisplayProperties.autoCorrect;
        return (v === undefined) ? true : v;
    }
    
    public function set autoCorrect(value:Boolean):void
    {
        if (textDisplay)
        {
            var softKeyboardClient:ISoftKeyboardHintClient = textDisplay as ISoftKeyboardHintClient;
            
            if (softKeyboardClient)
                softKeyboardClient.autoCorrect = value;
            textDisplayProperties = BitFlagUtil.update(
                uint(textDisplayProperties), 
                AUTO_CORRECT_FLAG, true);
        }
        else
        {
            textDisplayProperties.autoCorrect = value;
        }
        
        // Generate an UPDATE_COMPLETE event.
        invalidateProperties();                    
    }
     */
    //----------------------------------
    //  returnKeyLabel
    //----------------------------------
    
    //[Inspectable(category="General",enumeration="default,done,go,next,search",defaultValue="default")]

    /**
     *  Hint indicating what label should be displayed for the return key on
     *  soft keyboards.
     *
     *  <p>Supported values are defined in flash.text.ReturnKeyLabel:</p>
     * 
     *  <ul>
     *      <li><code>"default"</code> - default icon or label text</li>
     *      <li><code>"done"</code> - icon or label text indicating completed 
     *          text entry</li>
     *      <li><code>"go"</code> - icon or label text indicating that an action
     *          should start</li>
     *      <li><code>"next"</code> - icon or label text indicating a move to 
     *          the next field</li>
     *      <li><code>"search"</code> - icon or label text indicating that the 
     *          entered text should be searched for</li>
     *  </ul>
     *
     *  <p><b>For the Spark theme, this is not supported.</b></p>
     * 
     *  @default "default"
     *  
     *  @see flash.text.ReturnKeyLabel
     * 
     *  @langversion 3.0
     *  @playerversion AIR 3.0
     *  @productversion Royale 0.9.4.6
     */
    /* public function get returnKeyLabel():String
    {
        var softKeyboardClient:ISoftKeyboardHintClient = textDisplay as ISoftKeyboardHintClient;
        
        if (softKeyboardClient)
            return softKeyboardClient.returnKeyLabel; 
        
        var v:* = textDisplay ? undefined : textDisplayProperties.returnKeyLabel;
        return (v === undefined) ? "default" : v;
    } */
    
    /* public function set returnKeyLabel(value:String):void
    {
        if (textDisplay)
        {
            var softKeyboardClient:ISoftKeyboardHintClient = textDisplay as ISoftKeyboardHintClient;
            
            if (softKeyboardClient)
                softKeyboardClient.returnKeyLabel = value;
            textDisplayProperties = BitFlagUtil.update(
                uint(textDisplayProperties), 
                RETURN_KEY_LABEL_FLAG, true);
        }
        else
        {
            textDisplayProperties.returnKeyLabel = value;
        }
        
        // Generate an UPDATE_COMPLETE event.
        invalidateProperties();                    
    } */
    
    //----------------------------------
    //  softKeyboardType
    //----------------------------------
    
    //[Inspectable(category="General",enumeration="default,punctuation,url,number,contact,email",defaultValue="default")]

    /**
     *  Hint indicating what kind of soft keyboard should be displayed for
     *  this component.
     *
     *  <p>Supported values are defined in flash.text.SoftKeyboardType:</p>
     * 
     *  <ul>
     *      <li><code>"default"</code> - the default keyboard</li>
     *      <li><code>"punctuation"</code> - puts the keyboard into 
     *          punctuation/symbol entry mode</li>
     *      <li><code>"url"</code> - present soft keys appropriate for URL 
     *          entry, such as a specialized key that inserts '.com'</li>
     *      <li><code>"number"</code> - puts the keyboard into numeric keypad
     *          mode</li>
     *      <li><code>"contact"</code> - puts the keyboard into a mode 
     *          appropriate for entering contact information</li>
     *      <li><code>"email"</code> - puts the keyboard into e-mail addres 
     *          entry mode, which may make it easier to enter the at sign or
     *          '.com'</li>
     *  </ul>
     *
     *  <p><b>For the Spark theme, this is not supported.</b></p>
     * 
     *  @default "default" 
     * 
     *  @see flash.text.SoftKeyboardType
     * 
     *  @langversion 3.0
     *  @playerversion AIR 3.0
     *  @productversion Royale 0.9.4.6
     */
	/* public function get softKeyboardType():String
    {
        var softKeyboardClient:ISoftKeyboardHintClient = textDisplay as ISoftKeyboardHintClient;
        
        if (softKeyboardClient)
            return softKeyboardClient.softKeyboardType; 
        
        var v:* = textDisplay ? undefined : textDisplayProperties.softKeyboardType;
        return (v === undefined) ? "default" : v;
    } */
    
    /* public function set softKeyboardType(value:String):void
    {
        if (textDisplay)
        {
            var softKeyboardClient:ISoftKeyboardHintClient = textDisplay as ISoftKeyboardHintClient;
            
            if (softKeyboardClient)
                softKeyboardClient.softKeyboardType = value;
            textDisplayProperties = BitFlagUtil.update(
                uint(textDisplayProperties), 
                SOFT_KEYBOARD_TYPE_FLAG, true);
        }
        else
        {
            textDisplayProperties.softKeyboardType = value;
        }
        
        // Generate an UPDATE_COMPLETE event.
        invalidateProperties();                    
    } */
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override protected function commitProperties():void
    {
        super.commitProperties();
        
        /* if (accessibilityPropertiesChanged)
        {
            if (textDisplay)
            {
                textDisplay.accessibilityProperties = _accessibilityProperties;
                textDisplay.tabIndex = _tabIndex;             
                
                // Note: Calling updateProperties() on players that don't
                // support accessibility will throw an RTE.
                if (Capabilities.hasAccessibility)
                    Accessibility.updateProperties();
            }
            
            accessibilityPropertiesChanged = false;
        } */
    }
    
    /**
     *  @private
     */
    /* override public function styleChanged(styleProp:String):void
    {
        super.styleChanged(styleProp);
        
        if (!styleProp ||
            styleProp == "styleName" || styleProp == "interactionMode")
        {
            if (getStyle("interactionMode") == InteractionMode.TOUCH && !touchHandlersAdded)
            {
                addEventListener(MouseEvent.MOUSE_DOWN, touchMouseDownHandler);
                addEventListener(TouchInteractionEvent.TOUCH_INTERACTION_STARTING,
                        touchInteractionStartingHandler);
                addEventListener(TouchInteractionEvent.TOUCH_INTERACTION_START,
                        touchInteractionStartHandler);
                touchHandlersAdded = true;
            }
            else if (getStyle("interactionMode") == InteractionMode.MOUSE && touchHandlersAdded)
            {
                removeEventListener(MouseEvent.MOUSE_DOWN, touchMouseDownHandler);
                removeEventListener(TouchInteractionEvent.TOUCH_INTERACTION_STARTING,
                        touchInteractionStartingHandler);
                removeEventListener(TouchInteractionEvent.TOUCH_INTERACTION_START,
                        touchInteractionStartHandler);
                touchHandlersAdded = false;
            }
        }
    } */

    /**
     *  @private
     */
    /* override protected function partAdded(partName:String, instance:Object):void
    {
        super.partAdded(partName, instance);

        if (instance == promptDisplay)
        {
            var newPromptDisplayProperties:uint = 0;
            if (promptDisplayProperties.prompt !== undefined)
            {
                promptDisplay.text = promptDisplayProperties.prompt;
                newPromptDisplayProperties = BitFlagUtil.update(
                    uint(newPromptDisplayProperties), PROMPT_TEXT_PROPERTY_FLAG, true);
            }
            promptDisplayProperties = newPromptDisplayProperties;
        }
        
        if (instance == textDisplay)
        {
            // Copy proxied values from textDisplayProperties (if set) to 
            //textDisplay.
            textDisplayAdded();            

            // Focus on this, rather than the inner RET component.
            textDisplay.focusEnabled = false;

            // Start listening for various events from the IEditableText.

            textDisplay.addEventListener(SelectionEvent.SELECTION_CHANGE,
                                         textDisplay_selectionChangeHandler);

            textDisplay.addEventListener(TextOperationEvent.CHANGING, 
                                         textDisplay_changingHandler);

            textDisplay.addEventListener(TextOperationEvent.CHANGE,
                                         textDisplay_changeHandler);

            textDisplay.addEventListener(FlexEvent.ENTER,
                                         textDisplay_enterHandler);

            textDisplay.addEventListener(FlexEvent.VALUE_COMMIT,
                                         textDisplay_valueCommitHandler);
        }
    } */

    /**
     *  @private
     */
    /* override protected function partRemoved(partName:String, 
                                            instance:Object):void
    {
        super.partRemoved(partName, instance);

        if (instance == textDisplay)
        {
            // Copy proxied values from textDisplay (if explicitly set) to 
            // textDisplayProperties.                        
            textDisplayRemoved();            
            
            // Stop listening for various events from the IEditableText.

            textDisplay.removeEventListener(SelectionEvent.SELECTION_CHANGE,
                                            textDisplay_selectionChangeHandler);

            textDisplay.removeEventListener(TextOperationEvent.CHANGING,
                                            textDisplay_changingHandler);

            textDisplay.removeEventListener(TextOperationEvent.CHANGE,
                                            textDisplay_changeHandler);

            textDisplay.removeEventListener(FlexEvent.ENTER,
                                            textDisplay_enterHandler);

            textDisplay.removeEventListener(FlexEvent.VALUE_COMMIT,
                                            textDisplay_valueCommitHandler);
        }
        
        if (instance == promptDisplay)
        {
            var newPromptDisplayProperties:Object = {};
            
            if (BitFlagUtil.isSet(uint(promptDisplayProperties), 
                PROMPT_TEXT_PROPERTY_FLAG))
            {
                newPromptDisplayProperties.prompt = 
                    promptDisplay.text;
            }
            promptDisplayProperties = newPromptDisplayProperties;
        }
    } */
    
    /**
     *  @private
     */
   /*  override protected function getCurrentSkinState():String
    {
        var showPromptWhenFocused:Boolean = getStyle("showPromptWhenFocused");
        
        if ((showPromptWhenFocused || 
            focusManager && focusManager.getFocus() != focusManager.findFocusManagerComponent(this)) && 
            prompt != null && prompt != "")
        {
            if (text.length == 0)
            {
                if (enabled && skin && skin.hasState("normalWithPrompt"))
                    return "normalWithPrompt";
                if (!enabled && skin && skin.hasState("disabledWithPrompt"))
                    return "disabledWithPrompt";
            }
        }
        return enabled ? "normal" : "disabled";
    } */

    /**
     *  @private
     *  Focus should always be on the internal textDisplay.
     */
    override public function setFocus():void
    {
        // If the mouse is down, then we don't want the TextField to open the soft keyboard until mouse up.
        // we also want to prevent the keyboard from hiding until the next mouse up focus, or touch scroll.
        // Otherwise, this was called programmatically and we want the soft keyboard to appear immediately.
        // Note that isTouchMouseDown can only be true when we are in InteractionMode == TOUCH.
        /* if (textDisplay)
        {
            if (isTouchMouseDown)
            {
                delaySetFocus = true;
                if (textDisplay is IProxiedStageTextWrapper)
                  IProxiedStageTextWrapper(textDisplay).keepSoftKeyboardActive();
            }
            else
            {
                //Force properties to validate before resetting focus.
                validateProperties();

                textDisplay.setFocus();
            }
        } */
    }

    /**
     *  @private
     */
    /* override protected function isOurFocus(target:DisplayObject):Boolean
    {
        return target == textDisplay || super.isOurFocus(target);
    } */
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @copy spark.core.IEditableText#insertText()
     *   
     *  @see spark.components.RichEditableText#insertText()
     *  @see spark.components.supportClasses.StyleableStageText#insertText()
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function insertText(text:String):void
    {
        if (!textDisplay)
            return;

        textDisplay.insertText(text);
        
        // This changes text so generate an UPDATE_COMPLETE event.
        invalidateProperties();
    } */

    /**
     *  @copy spark.core.IEditableText#appendText()
     *  
     *  @see spark.components.RichEditableText#appendText()
     *  @see spark.components.supportClasses.StyleableStageText#appendText()
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function appendText(text:String):void
    {/*
        if (!textDisplay)
            return;

        textDisplay.appendText(text);
        
        // This changes text so generate an UPDATE_COMPLETE event.
        invalidateProperties();*/
    } 
    
    /**
     *  @copy spark.core.IEditableText#selectRange()
     *  
     *  @see spark.components.RichEditableText#selectRange()
     *  @see spark.components.supportClasses.StyleableStageText#selectRange()
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function selectRange(anchorIndex:int, activeIndex:int):void
    {
        //if (!textDisplay)
        //    return;

        // textDisplay.selectRange(anchorIndex, activeIndex);

        // This changes the selection so generate an UPDATE_COMPLETE event.
        // invalidateProperties();
    }

    /**
     *  @copy spark.core.IEditableText#selectAll()
     * 
     *  @see spark.components.RichEditableText#selectAll()
     *  @see spark.components.supportClasses.StyleableStageText#selectAll()
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function selectAll():void
    {
        if (!textDisplay)
            return;

        textDisplay.selectAll();

        // This changes the selection so generate an UPDATE_COMPLETE event.
        invalidateProperties();
    } */

    /**
     *  @private
     */
    public /*mx_internal*/ function setContent(value:Object):void
    {        
        if (textDisplay)
        {
            var richEditableText:RichEditableText = textDisplay as RichEditableText;
            
            if (richEditableText)
            {
                richEditableText.content = value;
                textDisplayProperties = BitFlagUtil.update(
                    uint(textDisplayProperties), CONTENT_PROPERTY_FLAG, true);
            }
        }
        else
        {
            textDisplayProperties.content = value;
            
            // Of 'text', 'textFlow', and 'content', the last one set wins.  So
            // if we're holding onto the properties until the skin is loaded
            // make sure only the last one set is defined.
            textDisplayProperties.text = undefined;
            textDisplayProperties.textFlow = undefined;
        }

        // Generate an UPDATE_COMPLETE event.
        invalidateProperties();                    
     }

    /**
     *  @private
     */
    /* mx_internal function getHeightInLines():Number
    {
        var richEditableText:RichEditableText = textDisplay as RichEditableText;

        if (richEditableText)
            return richEditableText.heightInLines;
            
        // want the default to be NaN
        var v:* = textDisplay ? undefined : textDisplayProperties.heightInLines;        
        return (v === undefined) ? NaN : v;
    } */

    /**
     *  @private
     */
    /* mx_internal function setHeightInLines(value:Number):void
    {
        if (textDisplay)
        {
            var richEditableText:RichEditableText = textDisplay as RichEditableText;

            if (richEditableText)
                richEditableText.heightInLines = value;
            textDisplayProperties = BitFlagUtil.update(
                uint(textDisplayProperties), 
                HEIGHT_IN_LINES_PROPERTY_FLAG, true);
        }
        else
        {
            textDisplayProperties.heightInLines = value;
        }

        // Generate an UPDATE_COMPLETE event.
        invalidateProperties();                    
    } */

    /**
     *  @see #prompt
     *
     *  @private
     */
    /* mx_internal function getPrompt():String
    {
        if (promptDisplay)
        {
            if (BitFlagUtil.isSet(uint(promptDisplayProperties), 
                PROMPT_TEXT_PROPERTY_FLAG))
                return promptDisplay.text;
            return null;
        }
        
        // want the default to be null
        var v:* = promptDisplay ? undefined : promptDisplayProperties.prompt;
        return (v === undefined) ? null : v;
    } */
    
    /**
     *  @private
     */
    /* mx_internal function setPrompt(value:String):void
    {
        if (promptDisplay)
        {
            promptDisplay.text = value;
            promptDisplayProperties = BitFlagUtil.update(
                uint(promptDisplayProperties), 
                PROMPT_TEXT_PROPERTY_FLAG, true);
        }
        else
            promptDisplayProperties.prompt = value;
        
        // Generate an UPDATE_COMPLETE event.
        invalidateProperties();       
        invalidateSkinState();
    } */
    
    /**
     *  @private  
     */
    public /*mx_internal*/ function getTextFlow():TextFlow 
    {
        var richEditableText:RichEditableText = textDisplay as RichEditableText;
        
        if (richEditableText)
            return richEditableText.textFlow;
            
        // If there is no textDisplay, it isn't possible to set one of
        // text, textFlow or content and then get it in another form.

        // want the default to be null
        var v:* = textDisplay ? undefined : textDisplayProperties.textFlow;
        return (v === undefined) ? null : v;
    }
    
    /**
     *  @private
     */
    public /*mx_internal*/ function setTextFlow(value:TextFlow):void
    {
        if (textDisplay)
        {
            var richEditableText:RichEditableText = textDisplay as RichEditableText;
            
            if (richEditableText)
                richEditableText.textFlow = value;
            textDisplayProperties = BitFlagUtil.update(
                                    uint(textDisplayProperties), 
                                    TEXT_FLOW_PROPERTY_FLAG, true);
        }
        else
        {
            textDisplayProperties.textFlow = value;

            // Of 'text', 'textFlow', and 'content', the last one set wins.  So
            // if we're holding onto the properties until the skin is loaded
            // make sure only the last one set is defined.
            textDisplayProperties.text = undefined;
            textDisplayProperties.content = undefined;
        }

        // Generate an UPDATE_COMPLETE event.
        invalidateProperties();
        invalidateSkinState();
    }

    /**
     *  @see RichEditableText#typicalText
     *
     *  @private
     */
    /* mx_internal function getTypicalText():String
    {
        var richEditableText:RichEditableText = textDisplay as RichEditableText;
        
        if (richEditableText)
            return richEditableText.typicalText;
        
        // want the default to be null
        var v:* = textDisplay ? undefined : textDisplayProperties.typicalText;
        return (v === undefined) ? null : v;
    } */
    
    /**
     *  @private
     */
   /*  mx_internal function setTypicalText(value:String):void
    {
        if (textDisplay)
        {
            var richEditableText:RichEditableText = textDisplay as RichEditableText;
            
            if (richEditableText)
                richEditableText.typicalText = value;
            textDisplayProperties = BitFlagUtil.update(
                uint(textDisplayProperties), 
                TYPICAL_TEXT_PROPERTY_FLAG, true);
        }
        else
        {
            textDisplayProperties.typicalText = value;
        }
        
        // Generate an UPDATE_COMPLETE event.
        invalidateProperties();                    
    } */

    /**
     *  The default width for the Text components, measured in characters.
     *  The width of the "M" character is used for the calculation.
     *  So if you set this property to 5, it will be wide enough
     *  to let the user enter 5 ems.
     *
     *  @private
     */
    /* mx_internal function getWidthInChars():Number
    {
        var richEditableText:RichEditableText = textDisplay as RichEditableText;

        if (richEditableText)
            return richEditableText.widthInChars
            
        // want the default to be NaN
        var v:* = textDisplay ? undefined : textDisplayProperties.widthInChars;
        return (v === undefined) ? NaN : v;
    } */

    /**
     *  @private
     */
    /* mx_internal function setWidthInChars(value:Number):void
    {
        if (textDisplay)
        {
            var richEditableText:RichEditableText = textDisplay as RichEditableText;

            if (richEditableText)
                richEditableText.widthInChars = value;
            textDisplayProperties = BitFlagUtil.update(
                uint(textDisplayProperties), 
                WIDTH_IN_CHARS_PROPERTY_FLAG, true);
        }
        else
        {
            textDisplayProperties.widthInChars = value;
        }

        // Generate an UPDATE_COMPLETE event.
        invalidateProperties();                    
    } */
    
    /**
     *  @private
     *  Copy values stored locally into textDisplay now that textDisplay 
     *  has been added.
     */
    /* private function textDisplayAdded():void
    {        
        var newTextDisplayProperties:uint = 0;
        var richEditableText:RichEditableText = textDisplay as RichEditableText;
        
        if (textDisplayProperties.content !== undefined && richEditableText)
        {
            richEditableText.content = textDisplayProperties.content;
            newTextDisplayProperties = BitFlagUtil.update(
                uint(newTextDisplayProperties), CONTENT_PROPERTY_FLAG, true);
        }
 
        if (textDisplayProperties.displayAsPassword !== undefined)
        {
            textDisplay.displayAsPassword = 
                textDisplayProperties.displayAsPassword
            newTextDisplayProperties = BitFlagUtil.update(
                uint(newTextDisplayProperties), 
                DISPLAY_AS_PASSWORD_PROPERTY_FLAG, true);
        }

        if (textDisplayProperties.editable !== undefined)
        {
            textDisplay.editable = textDisplayProperties.editable;
            newTextDisplayProperties = BitFlagUtil.update(
                uint(newTextDisplayProperties), EDITABLE_PROPERTY_FLAG, true);
        }

        if (textDisplayProperties.heightInLines !== undefined && richEditableText)
        {
            richEditableText.heightInLines = textDisplayProperties.heightInLines;
            newTextDisplayProperties = BitFlagUtil.update(
                uint(newTextDisplayProperties), 
                HEIGHT_IN_LINES_PROPERTY_FLAG, true);
        }

        if (textDisplayProperties.imeMode !== undefined && richEditableText)
        {
            richEditableText.imeMode = textDisplayProperties.imeMode;
            newTextDisplayProperties = BitFlagUtil.update(
                uint(newTextDisplayProperties), IME_MODE_PROPERTY_FLAG, true);
        }

        if (textDisplayProperties.maxChars !== undefined)
        {
            textDisplay.maxChars = textDisplayProperties.maxChars;
            newTextDisplayProperties = BitFlagUtil.update(
                uint(newTextDisplayProperties), MAX_CHARS_PROPERTY_FLAG, true);
        }
        
        if (textDisplayProperties.maxWidth !== undefined)
        {
            if (richEditableText)
                richEditableText.maxWidth = textDisplayProperties.maxWidth;
            else
                super.maxWidth = textDisplayProperties.maxWidth;
            newTextDisplayProperties = BitFlagUtil.update(
                uint(newTextDisplayProperties), MAX_WIDTH_PROPERTY_FLAG, true);
        }

        if (textDisplayProperties.restrict !== undefined)
        {
            textDisplay.restrict = textDisplayProperties.restrict;
            newTextDisplayProperties = BitFlagUtil.update(
                uint(newTextDisplayProperties), RESTRICT_PROPERTY_FLAG, true);
        }

        if (textDisplayProperties.selectable !== undefined)
        {
            textDisplay.selectable = textDisplayProperties.selectable;
            newTextDisplayProperties = BitFlagUtil.update(
                uint(newTextDisplayProperties), SELECTABLE_PROPERTY_FLAG, true);
        }

        if (textDisplayProperties.selectionHighlighting !== undefined && richEditableText)
        {
            richEditableText.selectionHighlighting = 
                textDisplayProperties.selectionHighlighting;
            newTextDisplayProperties = BitFlagUtil.update(
                uint(newTextDisplayProperties), 
                SELECTION_HIGHLIGHTING_FLAG, true);
        }
            
        if (textDisplayProperties.text != null)
        {
            textDisplay.text = textDisplayProperties.text;
            newTextDisplayProperties = BitFlagUtil.update(
                uint(newTextDisplayProperties), TEXT_PROPERTY_FLAG, true);
        }

        if (textDisplayProperties.textFlow !== undefined && richEditableText)
        {
            richEditableText.textFlow = textDisplayProperties.textFlow;
            newTextDisplayProperties = BitFlagUtil.update(
                uint(newTextDisplayProperties), TEXT_FLOW_PROPERTY_FLAG, true);
        }

        if (textDisplayProperties.typicalText !== undefined && richEditableText)
        {
            richEditableText.typicalText = textDisplayProperties.typicalText;
            newTextDisplayProperties = BitFlagUtil.update(
                uint(newTextDisplayProperties), 
                TYPICAL_TEXT_PROPERTY_FLAG, true);
        }
        
        if (textDisplayProperties.widthInChars !== undefined && richEditableText)
        {
            richEditableText.widthInChars = textDisplayProperties.widthInChars;
            newTextDisplayProperties = BitFlagUtil.update(
                uint(newTextDisplayProperties), 
                WIDTH_IN_CHARS_PROPERTY_FLAG, true);
        }
        
        var softKeyboardClient:ISoftKeyboardHintClient = textDisplay as ISoftKeyboardHintClient;
        
        if (textDisplayProperties.autoCapitalize !== undefined && softKeyboardClient)
        {
            softKeyboardClient.autoCapitalize = textDisplayProperties.autoCapitalize;
            newTextDisplayProperties = BitFlagUtil.update(
                uint(newTextDisplayProperties),
                AUTO_CAPITALIZE_FLAG, true);
        }
        
        if (textDisplayProperties.autoCorrect !== undefined && softKeyboardClient)
        {
            softKeyboardClient.autoCorrect = textDisplayProperties.autoCorrect;
            newTextDisplayProperties = BitFlagUtil.update(
                uint(newTextDisplayProperties),
                AUTO_CORRECT_FLAG, true);
        }
        
        if (textDisplayProperties.returnKeyLabel !== undefined && softKeyboardClient)
        {
            softKeyboardClient.returnKeyLabel = textDisplayProperties.returnKeyLabel;
            newTextDisplayProperties = BitFlagUtil.update(
                uint(newTextDisplayProperties),
                RETURN_KEY_LABEL_FLAG, true);
        }
        
        if (textDisplayProperties.softKeyboardType !== undefined && softKeyboardClient)
        {
            softKeyboardClient.softKeyboardType = textDisplayProperties.softKeyboardType;
            newTextDisplayProperties = BitFlagUtil.update(
                uint(newTextDisplayProperties),
                SOFT_KEYBOARD_TYPE_FLAG, true);
        }
            
        // Switch from storing properties to bit mask of stored properties.
        textDisplayProperties = newTextDisplayProperties;    
    } */
    
    /**
     *  @private
     *  Copy values stored in textDisplay back to local storage since 
     *  textDisplay is about to be removed.
     */
    /* private function textDisplayRemoved():void
    {        
        var newTextDisplayProperties:Object = {};
        var richEditableText:RichEditableText = textDisplay as RichEditableText;
        
        if (BitFlagUtil.isSet(uint(textDisplayProperties), 
                              DISPLAY_AS_PASSWORD_PROPERTY_FLAG))
        {
            newTextDisplayProperties.displayAsPassword = 
                textDisplay.displayAsPassword;
        }

        if (BitFlagUtil.isSet(uint(textDisplayProperties), 
                              EDITABLE_PROPERTY_FLAG))
        {
            newTextDisplayProperties.editable = textDisplay.editable;
        }
        
        if (BitFlagUtil.isSet(uint(textDisplayProperties), 
                              HEIGHT_IN_LINES_PROPERTY_FLAG) && richEditableText)
        {
            newTextDisplayProperties.heightInLines = richEditableText.heightInLines;
        }

        if (BitFlagUtil.isSet(uint(textDisplayProperties), 
                              IME_MODE_PROPERTY_FLAG) && richEditableText)
        {
            newTextDisplayProperties.imeMode = richEditableText.imeMode;
        }
        
        if (BitFlagUtil.isSet(uint(textDisplayProperties), 
                              MAX_CHARS_PROPERTY_FLAG))
        {
            newTextDisplayProperties.maxChars = textDisplay.maxChars;
        }

        if (BitFlagUtil.isSet(uint(textDisplayProperties), 
                              MAX_WIDTH_PROPERTY_FLAG))
        {
            newTextDisplayProperties.maxWidth = richEditableText ? 
                richEditableText.maxWidth : super.maxWidth;
        }

        if (BitFlagUtil.isSet(uint(textDisplayProperties), 
                              RESTRICT_PROPERTY_FLAG))
        {
            newTextDisplayProperties.restrict = textDisplay.restrict;
        }
        
        if (BitFlagUtil.isSet(uint(textDisplayProperties), 
                              SELECTABLE_PROPERTY_FLAG))
        {
            newTextDisplayProperties.selectable = textDisplay.selectable;
        }

        if (BitFlagUtil.isSet(uint(textDisplayProperties), 
                              SELECTION_HIGHLIGHTING_FLAG) && richEditableText)
        {
            newTextDisplayProperties.selectionHighlighting = 
                richEditableText.selectionHighlighting;
        }
            
        // Text is special.            
        if (BitFlagUtil.isSet(uint(textDisplayProperties), TEXT_PROPERTY_FLAG))
            newTextDisplayProperties.text = textDisplay.text;

        // Content is just a setter.  So if it was set, get the textFlow
        // instead.        
        if (BitFlagUtil.isSet(uint(textDisplayProperties), 
                TEXT_FLOW_PROPERTY_FLAG) || 
            BitFlagUtil.isSet(uint(textDisplayProperties), 
                CONTENT_PROPERTY_FLAG) && richEditableText)
        {
            newTextDisplayProperties.textFlow = richEditableText.textFlow;
        }

        if (BitFlagUtil.isSet(uint(textDisplayProperties), 
                              TYPICAL_TEXT_PROPERTY_FLAG) && richEditableText)
        {
            newTextDisplayProperties.typicalText = richEditableText.typicalText;
        }
            
        if (BitFlagUtil.isSet(uint(textDisplayProperties), 
            WIDTH_IN_CHARS_PROPERTY_FLAG) && richEditableText)
        {
            newTextDisplayProperties.widthInChars = richEditableText.widthInChars;
        }
        
        var softKeyboardClient:ISoftKeyboardHintClient = textDisplay as ISoftKeyboardHintClient;
        
        if (BitFlagUtil.isSet(uint(textDisplayProperties),
            AUTO_CAPITALIZE_FLAG) && softKeyboardClient)
        {
            newTextDisplayProperties.autoCapitalize = softKeyboardClient.autoCapitalize;
        }
        
        if (BitFlagUtil.isSet(uint(textDisplayProperties),
            AUTO_CORRECT_FLAG) && softKeyboardClient)
        {
            newTextDisplayProperties.autoCorrect = softKeyboardClient.autoCorrect;
        }
        
        if (BitFlagUtil.isSet(uint(textDisplayProperties),
            RETURN_KEY_LABEL_FLAG) && softKeyboardClient)
        {
            newTextDisplayProperties.returnKeyLabel = softKeyboardClient.returnKeyLabel;
        }
        
        if (BitFlagUtil.isSet(uint(textDisplayProperties),
            SOFT_KEYBOARD_TYPE_FLAG) && softKeyboardClient)
        {
            newTextDisplayProperties.softKeyboardType = softKeyboardClient.softKeyboardType;
        }
        
        // Switch from storing bit mask to storing properties.
        textDisplayProperties = newTextDisplayProperties;
    } */
    
    //--------------------------------------------------------------------------
    //
    //  Overridden event handlers
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    /* override protected function focusInHandler(event:FocusEvent):void
    {
        if (event.target == this)
        {
            // call setFocus on ourselves to pass focus to the
            // textDisplay.  This situation occurs when the
            // player occasionally takes over the first TAB
            // on a newly activated Window with nothing currently
            // in focus
            setFocus();
            return;
        }

        // On mobile, 2 problems interfere with FocusManager's
        // normal resetting of the focus indicator. First, the
        // mouse down and focus in events on mobile happen out of
        // order, so the normal resetting of showFocusIndicator
        // in the mouse down capture handler doesn't happen until
        // after the focus event. Second, StageText doesn't send
        // mouse events at all. So, to make the focus indicator
        // more robust, we store the flag's old value, set it, let
        // the superclass draw the focus indicator, then restore
        // the flag's old value.
        var oldShowFocusIndicator:Boolean;
        
        // Only editable text should have a focus ring.
        if (enabled && editable && focusManager)
        {
            oldShowFocusIndicator = focusManager.showFocusIndicator;
            focusManager.showFocusIndicator = true;
        }

        invalidateSkinState();
        
        super.focusInHandler(event);
        
        if (enabled && editable && focusManager)
            focusManager.showFocusIndicator = oldShowFocusIndicator;
    } */
 
    /**
     *  @private
     */
    /* override protected function focusOutHandler(event:FocusEvent):void
    {
        if (event.target == this)
            return;
        
        invalidateSkinState();
        
        super.focusOutHandler(event);
    } */

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------


    /**
     * @private
     * Called if we are in touch interaction mode and we receive a mouseDown
     */  
    /* private function touchMouseDownHandler(event:MouseEvent):void
    {
        isTouchMouseDown = true;
        touchMouseDownTarget = event.target as InteractiveObject;
        
        // If we already have focus, make sure to open soft keyboard
        // on mouse up
        if (focusManager && focusManager.getFocus() == this)
            delaySetFocus = true;
        
        // Wait for a mouseUp somewhere
        systemManager.getSandboxRoot().addEventListener(
            MouseEvent.MOUSE_UP, touchMouseUpHandler, false, 0, true);
        systemManager.getSandboxRoot().addEventListener(
            SandboxMouseEvent.MOUSE_UP_SOMEWHERE, touchMouseUpHandler, false, 0, true);
    } */
    
    /**
     * @private
     * Called if we are in touch interaction mode and a mouseUp occurs on the stage while isTouchMouseDown is true
     */ 
    //private function touchMouseUpHandler(event:Event):void
   // {        
        /*
         We set the focus on the component on mouseUp to activate the softKeyboard
         We only set focus if the following conditions are met:
         1. mouseUp occurs on this component
         2. mouseDown occured on any subcomponent besides the textDisplay OR
         mouseDown occurred on textDisplay and mouseUp did not occur on textDisplay

         The mouseDown and mouseUp on textDisplay case is handled by the Player
        */
        /* if ((event.target is DisplayObject && contains(DisplayObject(event.target)))
            && (delaySetFocus ||
             (touchMouseDownTarget == textDisplay && event.target != textDisplay)))
        {
            if (textDisplay)
                textDisplay.setFocus();
        }

        clearTouchMouseDownState();
    } */

    /**
     * @private
     * Called if we are inside of a Scroller and the user is about to  start a scroll gesture.
     * ask displayDisplay to show its proxy
     */
    /* private function touchInteractionStartingHandler(event: TouchInteractionEvent): void
    {
           if (textDisplay && textDisplay is IProxiedStageTextWrapper){
               IProxiedStageTextWrapper(textDisplay).prepareForTouchScroll();
           }
    } */

    /**
     * @private
     * Called if we are inside of a Scroller and the user has started a scroll gesture
     */
   /*  private function touchInteractionStartHandler(event:TouchInteractionEvent):void
    {
        // if in iOS and keyboard is up and scrolling is occurring, drop the keyboard
        var topLevelApp:Application = FlexGlobals.topLevelApplication as Application;
        if (isIOS && topLevelApp && topLevelApp.isSoftKeyboardActive && editable)
        {
            // set focus
            stage.focus = null;
        }

        // Clear out the state because starting a scroll gesture should never
        // open the soft keyboard
        clearTouchMouseDownState();
    } */

    /**
     * @private
     * Helper function to clear the state if the mouse is up or we started as scroll gesture
     */
    /* private function clearTouchMouseDownState():void
    {
        if (isTouchMouseDown)
        {
            systemManager.getSandboxRoot().removeEventListener(
                MouseEvent.MOUSE_UP, touchMouseUpHandler, false);
            systemManager.getSandboxRoot().removeEventListener(
                SandboxMouseEvent.MOUSE_UP_SOMEWHERE, touchMouseUpHandler, false);
            isTouchMouseDown = false;
            delaySetFocus = false;
            touchMouseDownTarget = null;
        }
    } */
    

    /**
     *  @private
     *  Called when the RichEditableText dispatches a 'selectionChange' event.
     */
   /*  private function textDisplay_selectionChangeHandler(event:Event):void
    {
        // Redispatch the event that came from the RichEditableText.
        dispatchEvent(event);
    } */

    /**
     *  Called when the RichEditableText dispatches a 'change' event
     *  after an editing operation.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
   /*  private function textDisplay_changeHandler(event:Event):void
    {        
        // The text component has changed.  Generate an UPDATE_COMPLETE event.
        invalidateDisplayList();


        // We may have gone from empty to non-empty or vice-versa. This should
        // cause the prompt to show or hide.
        if (prompt != null && prompt != "" && skin && skin.currentState)
        {
            //Checks when to invalidate skin. However when component is focused (and not prompt with focus) it will not have "WithPrompt".  Broken out for clarity.
            if (skin.currentState.indexOf("WithPrompt") != -1 && text.length != 0 ||
                skin.currentState.indexOf("WithPrompt") == -1 && text.length == 0)
            {
                invalidateSkinState();
            }
        }


        // Redispatch the event that came from the RichEditableText.
        dispatchEvent(event);
    } */

    /**
     *  @private
     *  Called when the RichEditableText dispatches a 'changing' event
     *  before an editing operation.
     */
   /*  private function textDisplay_changingHandler(event:TextOperationEvent):void
    {
        // Redispatch the event that came from the RichEditableText.
        var newEvent:Event = event.clone();
        dispatchEvent(newEvent);
        
        // If the event dispatched from this component is canceled,
        // cancel the one from the RichEditableText, which will prevent
        // the editing operation from being processed.
        if (newEvent.isDefaultPrevented())
            event.preventDefault();
    } */

    /**
     *  @private
     *  Called when the RichEditableText dispatches an 'enter' event
     *  in response to the Enter key.
     */
    /* private function textDisplay_enterHandler(event:Event):void
    {
        // Redispatch the event that came from the RichEditableText.
        dispatchEvent(event);
    } */

    /**
     *  @private
     *  Called when the RichEditableText dispatches an 'valueCommit' event
     *  when values are changed programmatically or by user interaction.
     *  Before the textDisplay part is loaded, any properties set are held
     *  in textDisplayProperties.  We don't want to dispatch 'valueCommit' when 
     *  there isn't a textDisplay since since the event will be dispatched by 
     *  RET when the textDisplay part is added.
     */
   /*  private function textDisplay_valueCommitHandler(event:Event):void
    {
        // Redispatch the event that came from the RichEditableText.
        dispatchEvent(event);
    } */
    
    override public function setStyle(styleName:String, value:*):void
    {
        if (styleName == "contentBackgroundColor")
        {
            styleName = "backgroundColor";
            if (value is String && value.charAt(0) != '#')
            {
                var c:uint = parseInt(value as String);
                value = '#' + c.toString(16);
            }
        }
        super.setStyle(styleName, value);
    }
}

}
