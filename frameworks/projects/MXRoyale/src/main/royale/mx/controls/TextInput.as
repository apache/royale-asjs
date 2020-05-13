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

package mx.controls
{
COMPILE::JS
{
	import goog.events;
	import org.apache.royale.core.WrappedHTMLElement;
	import org.apache.royale.html.util.addElementToWrapper;
}
import mx.controls.listClasses.BaseListData;
import mx.core.EdgeMetrics;
import mx.core.ITextInput;
import mx.core.UIComponent;
import mx.core.UITextField;
import mx.events.FlexEvent;
import mx.events.KeyboardEvent;
import mx.events.TextEvent;

import org.apache.royale.core.ITextModel;
import org.apache.royale.core.TextLineMetrics;
import org.apache.royale.events.Event;
import org.apache.royale.html.accessories.PasswordInputBead;
import org.apache.royale.html.accessories.RestrictTextInputBead;
import org.apache.royale.html.beads.DisableBead;

COMPILE::SWF {
	import org.apache.royale.html.beads.TextInputView;
}
import mx.core.mx_internal;

use namespace mx_internal;

/*
import mx.managers.IFocusManager;
import mx.managers.IFocusManagerComponent;
import mx.managers.ISystemManager;
import mx.managers.SystemManager;
import mx.styles.ISimpleStyleClient;

use namespace mx_internal;
*/

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched when text in the TextInput control changes
 *  through user input.
 *  This event does not occur if you use data binding or
 *  ActionScript code to change the text.
 *
 *  <p>Even though the default value of the <code>Event.bubbles</code> property
 *  is <code>true</code>, this control dispatches the event with
 *  the <code>Event.bubbles</code> property set to <code>false</code>.</p>
 *
 *  @eventType flash.events.Event.CHANGE
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="change", type="org.apache.royale.events.Event")]

/**
 *  Dispatched when the <code>data</code> property changes.
 *
 *  <p>When you use a component as an item renderer,
 *  the <code>data</code> property contains the data to display.
 *  You can listen for this event and update the component
 *  when the <code>data</code> property changes.</p>
 *
 *  @eventType mx.events.FlexEvent.DATA_CHANGE
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="dataChange", type="mx.events.FlexEvent")]

/**
 *  Dispatched when the user presses the Enter key.
 *
 *  @eventType mx.events.FlexEvent.ENTER
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="enter", type="mx.events.FlexEvent")]

/**
 *  Dispatched when the user types, deletes, or pastes text into the control.
 *  No event is dispatched when the user presses the Delete key, or Backspace key.
 *
 *  <p>Even though the default value of the <code>TextEvent.bubbles</code> property
 *  is <code>true</code>, this control dispatches the event with
 *  the <code>TextEvent.bubbles</code> property set to <code>false</code>.</p>
 *
 *  @eventType flash.events.TextEvent.TEXT_INPUT
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="textInput", type="mx.events.TextEvent")]


//--------------------------------------
//  Other metadata
//--------------------------------------

[DefaultBindingProperty(source="text", destination="text")]

[DefaultTriggerEvent("change")]


/**
 *  The TextInput control is a single-line text field
 *  that is optionally editable.
 *  All text in this control must use the same styling
 *  unless it is HTML text.
 *  The TextInput control supports the HTML rendering
 *  capabilities of Flash Player and AIR.
 *
 *  <p>TextInput controls do not include a label, although you
 *  can add one by using a Label control or by nesting the
 *  TextInput control in a FormItem control in a Form container.
 *  When used in a FormItem control, a TextInput control
 *  indicates whether a value is required.
 *  TextInput controls have a number of states, including filled,
 *  selected, disabled, and error.
 *  TextInput controls support formatting, validation, and keyboard
 *  equivalents; they also dispatch change and enter events.</p>
 *
 *  <p>If you disable a TextInput control, it displays its contents
 *  in the color specified by the <code>disabledColor</code>
 *  style.
 *  To disallow editing the text, you set the <code>editable</code>
 *  property to <code>false</code>.
 *  To conceal the input text by displaying asterisks instead of the
 *  characters entered, you set the <code>displayAsPassword</code> property
 *  to <code>true</code>.</p>
 *
 *  <p>The TextInput control is used as a subcomponent in several other controls,
 *  such as the RichTextEditor, NumericStepper, and ComboBox controls. As a result,
 *  if you assign style properties to a TextInput control by using a CSS type selector,
 *  Flex applies those styles to the TextInput when it appears in the other controls
 *  unless you explicitly override them.</p>
 *
 *  <p>The TextInput control has the following default sizing characteristics:</p>
 *     <table class="innertable">
 *        <tr>
 *           <th>Characteristic</th>
 *           <th>Description</th>
 *        </tr>
 *        <tr>
 *           <td>Default size</td>
 *           <td>The size of the text with a default minimum size of 22 pixels high and 160 pixels wide</td>
 *        </tr>
 *        <tr>
 *           <td>Minimum size</td>
 *           <td>0 pixels</td>
 *        </tr>
 *        <tr>
 *           <td>Maximum size</td>
 *           <td>10000 by 10000 pixels</td>
 *        </tr>
 *     </table>
 *
 *  @mxml
 *
 *  <p>The <code>&lt;mx:TextInput&gt;</code> tag inherits the attributes
 *  of its superclass and adds the following attributes:</p>
 *
 *  <pre>
 *  &lt;mx:TextInput
 *    <b>Properties</b>
 *    condenseWhite="false|true"
 *    data="undefined"
 *    displayAsPassword="false|true"
 *    editable="true|false"
 *    horizontalScrollPosition="0"
 *    htmlText=""
 *    imeMode="null"
 *    length="0"
 *    listData="null"
 *    maxChars="0"
 *    parentDrawsFocus="false"
 *    restrict="null"
 *    selectionBeginIndex="0"
 *    selectionEndIndex="0"
 *    text=""
 *    textHeight="0"
 *    textWidth="0"
 *    &nbsp;
 *    <b>Styles</b>
 *    backgroundAlpha="1.0"
 *    backgroundColor="undefined"
 *    backgroundImage="undefined"
 *    backgroundSize="auto"
 *    borderColor="0xAAB3B3"
 *    borderSides="left top right bottom"
 *    borderSkin="mx.skins.halo.HaloBorder"
 *    borderStyle="inset"
 *    borderThickness="1"
 *    color="0x0B333C"
 *    cornerRadius="0"
 *    disabledColor="0xAAB3B3"
 *    dropShadowColor="0x000000"
 *    dropShadowEnabled="false"
 *    focusAlpha="0.5"
 *    focusRoundedCorners"tl tr bl br"
 *    fontAntiAliasType="advanced|normal"
 *    fontFamily="Verdana"
 *    fontGridFitType="pixel|none|subpixel"
 *    fontSharpness="0"
 *    fontSize="10"
 *    fontStyle="normal|italic"
 *    fontThickness="0"
 *    fontWeight="normal|bold"
 *    paddingLeft="0"
 *    paddingRight="0"
 *    shadowDirection="center"
 *    shadowDistance="2"
 *    textAlign="left|right|center"
 *    textDecoration="none|underline"
 *    textIndent="0"
 *    &nbsp;
 *    <b>Events</b>
 *    change="<i>No default</i>"
 *    dataChange="<i>No default</i>"
 *    enter="<i>No default</i>"
 *    textInput="<i>No default</i>"
 *  /&gt;
 *  </pre>
 *
 *  @includeExample examples/TextInputExample.mxml
 *
 *  @see mx.controls.Label
 *  @see mx.controls.Text
 *  @see mx.controls.TextArea
 *  @see mx.controls.RichTextEditor
 *  @see mx.controls.textClasses.TextRange
 *
 *  @helpid 3188
 *  @tiptext TextInput is a single-line, editable text field.
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class TextInput extends UIComponent implements ITextInput
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function TextInput()
    {
        super();
        typeNames = "TextInput";
		
		COMPILE::SWF
		{
			model.addEventListener("textChange", textChangeHandler);
		}
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Flag that will block default data/listData behavior.
     */
    private var textSet:Boolean;

    /**
     *  @private
     */
    private var selectionChanged:Boolean = false;

    /**
     *  @private
     */
    private var errorCaught:Boolean = false;

    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------


    //----------------------------------
    //  enabled
    //----------------------------------

    /**
     *  @private
     */
    private var enabledChanged:Boolean = false;
	
	private var _disableBead:DisableBead;

    [Inspectable(category="General", enumeration="true,false", defaultValue="true")]

    /**
     *  @private
     *  Disable TextField when we're disabled.
     */
    override public function set enabled(value:Boolean):void
    {
        if (value == enabled)
            return;

        super.enabled = value;
//        enabledChanged = true;
//
//        invalidateProperties();
//
//         if (border && border is IInvalidating)
//             IInvalidating(border).invalidateDisplayList();
		
		if (_disableBead == null) {
			_disableBead = new DisableBead();
			addBead(_disableBead);
		}
		
		_disableBead.disabled = !value;
        
        COMPILE::JS {
            if (value)
            {
                element.removeEventListener("keypress", blockInput);
                element.removeEventListener("keydown", blockEdit);
            }
            else 
            {
                element.addEventListener("keypress", blockInput);
                element.addEventListener("keydown", blockEdit);
            }
        }
		
		COMPILE::SWF {
			var textView:TextInputView = view as TextInputView;
			textView.textField.mouseEnabled = super.enabled;
		}
    }
    
    COMPILE::JS
    private function blockInput(event:Event):void
    {
        event["returnValue"] = false;
        if (event.preventDefault) event.preventDefault();        
    }
    
    COMPILE::JS
    private function blockEdit(event:Event):void
    {
        if (event["key"] == "Delete" || event["key"] == "Backspace")
        {
            event["returnValue"] = false;
            if (event.preventDefault) event.preventDefault();   
        }
    }

    //----------------------------------
    //  tabIndex
    //----------------------------------

    /**
     *  @private
     *  Storage for the tabIndex property.
     */
    private var _tabIndex:int = -1;

    /**
     *  @private
     */
    private var tabIndexChanged:Boolean = false;

    /**
     *  @private
     *  Tab order in which the control receives the focus when navigating
     *  with the Tab key.
     *
     *  @default -1
     *  @tiptext tabIndex of the component
     *  @helpid 3198
     */
//     override public function get tabIndex():int
//     {
//         return _tabIndex;
//     }

    /**
     *  @private
     */
//     override public function set tabIndex(value:int):void
//     {
//         if (value == _tabIndex)
//             return;
//
//         _tabIndex = value;
//         tabIndexChanged = true;
//
//         invalidateProperties();
//     }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  contentBackgroundColor
    //----------------------------------
	
    public function get contentBackgroundColor():uint
    {
        return 0xFFFFFF;
    }
	
    public function set contentBackgroundColor(value:uint) :void
    {
    }
	
    //----------------------------------
    //  borderVisible
    //----------------------------------
	
    public function get borderVisible():Boolean
    {
        return true;
    }
	
    public function set borderVisible(value:Boolean) :void
    {
        
    }
    
    //----------------------------------
    //  data
    //----------------------------------

    /**
     *  @private
     *  Storage for the data property.
     */
    private var _data:Object;

    [Bindable("dataChange")]
    [Inspectable(environment="none")]

    /**
     *  Lets you pass a value to the component
     *  when you use it in an item renderer or item editor.
     *  You typically use data binding to bind a field of the <code>data</code>
     *  property to a property of this component.
     *
     *  <p>When you use the control as a drop-in item renderer or drop-in
     *  item editor, Flex automatically writes the current value of the item
     *  to the <code>text</code> property of this control.</p>
     *
     *  <p>You do not set this property in MXML.</p>
     *
     *  @default null
     *  @see mx.core.IDataRenderer
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get data():Object
    {
        return _data;
    }

    /**
     *  @private
     */
    public function set data(value:Object):void
    {
        var newText:*;

        _data = value;

        if (_listData)
        {
            newText = _listData.label;
        }
        else if (_data != null)
        {
            if (_data is String)
                newText = String(_data);
            else
                newText = _data.toString();
        }

        if (newText !== undefined && !textSet)
        {
            text = newText;
            textSet = false;
            // changing text should trigger the TextInput's view bead to change the display.
            //textField.setSelection(0, 0);
        }

        dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
    }

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

    /**
     *  @private
     *  Storage for the editable property.
     */
    private var _editable:Boolean = true;

    /**
     *  @private
     */
    private var editableChanged:Boolean = false;

    [Bindable("editableChanged")]
    [Inspectable(category="General", defaultValue="true")]

    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get editable():Boolean
    {
        return _editable;
    }

    /**
     *  @private
     */
    public function set editable(value:Boolean):void
    {
        _editable = value;
	COMPILE::JS
	{
		if(value == false) {
			(element as HTMLInputElement).readOnly = true;
		}
		else {
			 (element as HTMLInputElement).readOnly = value;
		}
	}
	
     /*   if (value == _editable)
            return;

        _editable = value;
        editableChanged = true;

        invalidateProperties();

        dispatchEvent(new Event("editableChanged")); */
    }

    //----------------------------------
    //  horizontalScrollPosition
    //----------------------------------

    /**
     *  @private
     *  Used to store the init time value if any.
     */
    private var _horizontalScrollPosition:Number = 0;

    /**
     *  @private
     */
    private var horizontalScrollPositionChanged:Boolean = false;

    [Bindable("horizontalScrollPositionChanged")]
    [Inspectable(defaultValue="0")]


    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get horizontalScrollPosition():Number
    {
        return _horizontalScrollPosition;
    }

    /**
     *  @private
     */
    public function set horizontalScrollPosition(value:Number):void
    {
        if (value == _horizontalScrollPosition)
            return;

        _horizontalScrollPosition = value;
        horizontalScrollPositionChanged = true;

        invalidateProperties();

        dispatchEvent(new Event("horizontalScrollPositionChanged"));
    }

    //----------------------------------
    //  htmlText
    //----------------------------------

    /**
     *  @private
     *  Storage for the htmlText property.
     *  In addition to being set in the htmlText setter,
     *  it is automatically updated at two other times.
     *  1. When the 'text' or 'htmlText' is pushed down into
     *  the textField in commitProperties(), this causes
     *  the textField to update its own 'htmlText'.
     *  Therefore in commitProperties() we reset this storage var
     *  to be in sync with the textField.
     *  2. When the TextFormat of the textField changes
     *  because a CSS style has changed (see validateNow()
     *  in UITextField), the textField also updates its own 'htmlText'.
     *  Therefore in textField_textFieldStyleChangeHandler()
     */
    private var _htmlText:String = "";

    /**
     *  @private
     */
    private var htmlTextChanged:Boolean = false;

    /**
     *  @private
     *  The last value of htmlText that was set.
     *  We have to keep track of this because when you set the htmlText
     *  of a TextField and read it back, you don't get what you set.
     *  In general it will have additional HTML markup corresponding
     *  to the defaultTextFormat set from the CSS styles.
     *  If this var is null, it means that 'text' rather than 'htmlText'
     *  was last set.
     */
    private var explicitHTMLText:String = null;

    [Bindable("htmlTextChanged")]
    [CollapseWhiteSpace]
    [Inspectable(category="General", defaultValue="")]
    [NonCommittingChangeEvent("change")]

   /**
     *  Specifies the text displayed by the TextInput control, including HTML markup that
     *  expresses the styles of that text.
     *  When you specify HTML text in this property, you can use the subset of HTML
     *  tags that is supported by the Flash TextField control.
     *
     *  <p> When you set this property, the HTML markup is applied
     *  after the CSS styles for the TextInput instance are applied.
     *  When you get this property, the HTML markup includes
     *  the CSS styles.</p>
     *
     *  <p>For example, if you set this to be a string such as,
     *  <code>"This is an example of &lt;b&gt;bold&lt;/b&gt; markup"</code>,
     *  the text "This is an example of <b>bold</b> markup" appears
     *  in the TextInput with whatever CSS styles normally apply.
     *  Also, the word "bold" appears in boldface font because of the
     *  <code>&lt;b&gt;</code> markup.</p>
     *
     *  <p>HTML markup uses characters such as &lt; and &gt;,
     *  which have special meaning in XML (and therefore in MXML). So,
     *  code such as the following does not compile:</p>
     *
     *  <pre>
     *  &lt;mx:TextInput htmlText="This is an example of &lt;b&gt;bold&lt;/b&gt; markup"/&gt;
     *  </pre>
     *
     *  <p>There are three ways around this problem.</p>
     *
     *  <ul>
     *
     *  <li>
     *
     *  <p>Set the <code>htmlText</code> property in an ActionScript method called as
     *  an <code>initialize</code> handler:</p>
     *
     *  <pre>
     *  &lt;mx:TextInput id="myTextInput" initialize="myTextInput_initialize()"/&gt;
     *  </pre>
     *
     *  <p>where the <code>myTextInput_initialize</code> method is in a script CDATA section:</p>
     *
     *  <pre>
     *  &lt;fx:Script&gt;
     *  &lt;![CDATA[
     *  private function myTextInput_initialize():void {
     *      myTextInput.htmlText = "This is an example of &lt;b&gt;bold&lt;/b&gt; markup";
     *  }
     *  ]]&gt;
     *  &lt;/fx:Script&gt;
     *
     *  </pre>
     *
     *  <p>This is the simplest approach because the HTML markup
     *  remains easily readable.
     *  Notice that you must assign an <code>id</code> to the TextInput
     *  so you can refer to it in the <code>initialize</code>
     *  handler.</p>
     *
     *  </li>
     *
     *  <li>
     *
     *  <p>Specify the <code>htmlText</code> property by using a child tag
     *  with a CDATA section. A CDATA section in XML contains character data
     *  where characters like &lt; and &gt; aren't given a special meaning.</p>
     *
     *  <pre>
     *  &lt;mx:TextInput&gt;
     *      &lt;mx:htmlText&gt;&lt;![CDATA[This is an example of &lt;b&gt;bold&lt;/b&gt; markup]]&gt;&lt;/mx:htmlText&gt;
     *  &lt;mx:TextInput/&gt;
     *  </pre>
     *
     *  <p>You must write the <code>htmlText</code> property as a child tag
     *  rather than as an attribute on the <code>&lt;mx:TextInput&gt;</code> tag
     *  because XML doesn't allow CDATA for the value of an attribute.
     *  Notice that the markup is readable, but the CDATA section makes
     *  this approach more complicated.</p>
     *
     *  </li>
     *
     *  <li>
     *
     *  <p>Use an <code>hmtlText</code> attribute where any occurences
     *  of the HTML markup characters &lt; and &gt; in the attribute value
     *  are written instead as the XML "entities" <code>&amp;lt;</code>
     *  and <code>&amp;gt;</code>:</p>
     *
     *  <pre>
     *  &lt;mx:TextInput htmlText="This is an example of &amp;lt;b&amp;gt;bold&amp;lt;/b&amp;gt; markup"/&amp;gt;
     *  </pre>
     *
     *  Adobe does not recommend this approach because the HTML markup becomes
     *  nearly impossible to read.
     *
     *  </li>
     *
     *  </ul>
     *
     *  <p>If the <code>condenseWhite</code> property is <code>true</code>
     *  when you set the <code>htmlText</code> property, multiple
     *  white-space characters are condensed, as in HTML-based browsers;
     *  for example, three consecutive spaces are displayed
     *  as a single space.
     *  The default value for <code>condenseWhite</code> is
     *  <code>false</code>, so you must set <code>condenseWhite</code>
     *  to <code>true</code> to collapse the white space.</p>
     *
     *  <p>If you read back the <code>htmlText</code> property quickly
     *  after setting it, you get the same string that you set.
     *  However, after the LayoutManager runs, the value changes
     *  to include additional markup that includes the CSS styles.</p>
     *
     *  <p>Setting the <code>htmlText</code> property affects the <code>text</code>
     *  property in several ways.
     *  If you read the <code>text</code> property quickly after setting
     *  the <code>htmlText</code> property, you get <code>null</code>,
     *  which indicates that the <code>text</code> corresponding to the new
     *  <code>htmlText</code> has not yet been determined.
     *  However, after the LayoutManager runs, the <code>text</code> property
     *  value changes to the <code>htmlText</code> string with all the
     *  HTML markup removed; that is,
     *  the value is the characters that the TextInput actually displays.</p>
     *
     *  <p>Conversely, if you set the <code>text</code> property,
     *  any previously set <code>htmlText</code> is irrelevant.
     *  If you read the <code>htmlText</code> property quickly after setting
     *  the <code>text</code> property, you get <code>null</code>,
     *  which indicates that the <code>htmlText</code> that corresponds to the new
     *  <code>text</code> has not yet been determined.
     *  However, after the LayoutManager runs, the <code>htmlText</code> property
     *  value changes to the new text plus the HTML markup for the CSS styles.</p>
     *
     *  <p>To make the LayoutManager run immediately, you can call the
     *  <code>validateNow()</code> method on the TextInput.
     *  For example, you could set some <code>htmlText</code>,
     *  call the <code>validateNow()</code> method, and immediately
     *  obtain the corresponding <code>text</code> that doesn't have
     *  the HTML markup.</p>
     *
     *  <p>If you set both <code>text</code> and <code>htmlText</code> properties
     *  in ActionScript, whichever is set last takes effect.
     *  Do not set both in MXML, because MXML does not guarantee that
     *  the properties of an instance get set in any particular order.</p>
     *
     *  <p>Setting either <code>text</code> or <code>htmlText</code> property
     *  inside a loop is a fast operation, because the underlying TextField
     *  that actually renders the text is not updated until
     *  the LayoutManager runs.</p>
     *
     *  <p>If you try to set this property to <code>null</code>,
     *  it is set, instead, to the empty string.
     *  If the property temporarily has the value <code>null</code>,
     *  it indicates that the <code>text</code> has been recently set
     *  and the corresponding <code>htmlText</code>
     *  has not yet been determined.</p>
     *
     *  @default ""
     *
     *  @see flash.text.TextField#htmlText
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get htmlText():String
    {
		COMPILE::SWF
		{
			return ITextModel(model).html;
		}
		COMPILE::JS
		{
			return (element as HTMLInputElement).value;
		}
    }

    /**
     *  @private
     */
    public function set htmlText(value:String):void
    {
		COMPILE::SWF
		{
			ITextModel(model).html = value;
		}
		COMPILE::JS
		{
			(element as HTMLInputElement).value = value;
			dispatchEvent(new Event('textChange'));
		}
    }

    //----------------------------------
    //  isHTML
    //----------------------------------

    /**
     *  @private
     */
    private function get isHTML():Boolean
    {
        return explicitHTMLText != null;
    }

    //----------------------------------
    //  length
    //----------------------------------

    /**
     *  The number of characters of text displayed in the TextArea.
     *
     *  @default 0
     *  @tiptext The number of characters in the TextInput.
     *  @helpid 3192
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get length():int
    {
        return text != null ? text.length : -1;
    }

    //----------------------------------
    //  listData
    //----------------------------------

    private var _listData:Object;

    [Bindable("dataChange")]
    [Inspectable(environment="none")]

    /**
     *  When a component is used as a drop-in item renderer or drop-in
     *  item editor, Flex initializes the <code>listData</code> property
     *  of the component with the appropriate data from the list control.
     *  The component can then use the <code>listData</code> property
     *  to initialize the <code>data</code> property of the drop-in
     *  item renderer or drop-in item editor.
     *
     *  <p>You do not set this property in MXML or ActionScript;
     *  Flex sets it when the component is used as a drop-in item renderer
     *  or drop-in item editor.</p>
     *
     *  @default null
     *  @see mx.controls.listClasses.IDropInListItemRenderer
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get listData():Object
    {
        return _listData;
    }

    /**
     *  @private
     */
    public function set listData(value:Object):void
    {
        _listData = value;
    }

    //----------------------------------
    //  maxChars
    //----------------------------------

    /**
     *  @private
     *  Storage for the maxChars property.
     */
    private var _maxChars:int = 0;

    /**
     *  @private
     */
    private var maxCharsChanged:Boolean = false;

    [Bindable("maxCharsChanged")]
    [Inspectable(category="General", defaultValue="0")]

    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get maxChars():int
    {
        return _maxChars;
    }

    /**
     *  @private
     */
    public function set maxChars(value:int):void
    {
        if (value == _maxChars)
            return;

        _maxChars = value;
        COMPILE::JS
        {
            (element as HTMLInputElement).maxLength = value;
        }  
    }

    //----------------------------------
    //  maxHorizontalScrollPosition
    //----------------------------------

    /**
     *  @private
     *  Maximum value of <code>horizontalScrollPosition</code>.
     *
     *  <p>The default value is 0, which means that horizontal scrolling is not
     *  required.</p>
     *
     *  <p>The value of the <code>maxHorizontalScrollPosition</code> property is
     *  computed from the data and size of component, and must not be set by
     *  the application code.</p>
     */
    public function get maxHorizontalScrollPosition():Number
    {
        return 0;//textField ? textField.maxScrollH : 0;
    }

    //----------------------------------
    //  parentDrawsFocus
    //----------------------------------

    /**
     *  @private
     *  Storage for the parentDrawsFocus property.
     */
    private var _parentDrawsFocus:Boolean = false;

    [Inspectable(category="General", enumeration="true,false", defaultValue="false")]

    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get parentDrawsFocus():Boolean
    {
        return _parentDrawsFocus;
    }

    /**
     *  @private
     */
    public function set parentDrawsFocus(value:Boolean):void
    {
        _parentDrawsFocus = value;
    }

    //----------------------------------
    //  restrict
    //----------------------------------

    private var restrictBead:RestrictTextInputBead;
    
    public function get restrict():String 
    {
        if (!restrictBead) return null;
        return restrictBead.restrict;
    }
    
    public function set restrict(value:String):void
    {
        if (!restrictBead)
        {
            restrictBead = new RestrictTextInputBead();
            addBead(restrictBead);
        }
        restrictBead.restrict = value;
    }

    //----------------------------------
    //  selectable
    //----------------------------------

    /**
     *  @private
     *  Used to make TextInput function correctly in the components that use it
     *  as a subcomponent. ComboBox, at this point.
     */
    private var _selectable:Boolean = true;

    /**
     *  @private
     */
    private var selectableChanged:Boolean = false;

    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get selectable():Boolean
    {
        return _selectable;
    }

    /**
     *  @private
     */
    public function set selectable(value:Boolean):void
    {
        if (_selectable == value)
            return;
        _selectable = value;
        selectableChanged = true;
        invalidateProperties();
    }
    //----------------------------------
    //  selectionBeginIndex
    //----------------------------------

    /**
     *  @private
     *  Storage for the selectionBeginIndex property.
     */
    private var _selectionBeginIndex:int = 0;

    [Inspectable(defaultValue="0")]

    /**
     *  The zero-based character index value of the first character
     *  in the current selection.
     *  For example, the first character is 0, the second character is 1,
     *  and so on.
     *  When the control gets the focus, the selection is visible if the
     *  <code>selectionBeginIndex</code> and <code>selectionEndIndex</code>
     *  properties are both set.
     *
     *  @default 0
     *
     *  @tiptext The zero-based index value of the first character
     *  in the selection.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get selectionBeginIndex():int
    {
        COMPILE::JS
        {
            _selectionBeginIndex = (element as HTMLInputElement).selectionStart;        
        }
        return _selectionBeginIndex;
    }

    /**
     *  @private
     */
    public function set selectionBeginIndex(value:int):void
    {
        _selectionBeginIndex = value;
        COMPILE::JS
        {
            (element as HTMLInputElement).selectionStart = value;        
        }
    }

    //----------------------------------
    //  selectionEndIndex
    //----------------------------------

    /**
     *  @private
     *  Storage for the selectionEndIndex property.
     */
    private var _selectionEndIndex:int = 0;

    [Inspectable(defaultValue="0")]

    /**
     *  The zero-based index of the position <i>after</i> the last character
     *  in the current selection (equivalent to the one-based index of the last
     *  character).
     *  If the last character in the selection, for example, is the fifth
     *  character, this property has the value 5.
     *  When the control gets the focus, the selection is visible if the
     *  <code>selectionBeginIndex</code> and <code>selectionEndIndex</code>
     *  properties are both set.
     *
     *  @default 0
     *
     *  @tiptext The zero-based index value of the last character
     *  in the selection.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get selectionEndIndex():int
    {
        COMPILE::JS
        {
            _selectionEndIndex = (element as HTMLInputElement).selectionEnd;        
        }
        return _selectionEndIndex;
    }

    /**
     *  @private
     */
    public function set selectionEndIndex(value:int):void
    {
        _selectionEndIndex = value;
        selectionChanged = true;

        invalidateProperties();
        COMPILE::JS
        {
            (element as HTMLInputElement).selectionEnd = value;        
        }
    }

    //----------------------------------
    //  text
    //----------------------------------


    /**
     *  @private
     */
    private var textChanged:Boolean = false;

    //[Bindable("textChanged")]
    [Bindable("change")]
    [CollapseWhiteSpace]
    [Inspectable(category="General", defaultValue="")]
    //[NonCommittingChangeEvent("change")]  Not sure what this did
    // since TextField sends change on every keystroke and other
    // code looked like it would dispatch a textChanged

    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     *  @royaleignorecoercion HTMLInputElement
     */
    public function get text():String
    {
		COMPILE::SWF
		{
			return ITextModel(model).text;
		}
		COMPILE::JS
		{
			return (element as HTMLInputElement).value;
		}
    }

    /**
     *  @private
     */
    public function set text(value:String):void
    {
		COMPILE::SWF
		{
			inSetter = true;
			ITextModel(model).text = value;
			inSetter = false;
		}
		
		COMPILE::JS
		{
            // Flash does not reset selection when setting text
            // but browser does
            _selectionBeginIndex = (element as HTMLInputElement).selectionStart;
            _selectionEndIndex = (element as HTMLInputElement).selectionEnd;
			(element as HTMLInputElement).value = value;
            (element as HTMLInputElement).selectionStart = _selectionBeginIndex;
            (element as HTMLInputElement).selectionEnd = _selectionEndIndex;
		}

        dispatchEvent(new Event('textChanged'));
        dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Create child objects.
     */
    override protected function createChildren():void
    {
        super.createChildren();
    }

    /**
     *  @private
     */
    override protected function commitProperties():void
    {
        super.commitProperties();


//         if (hasFontContextChanged() && textField != null)
//         {
//             var childIndex:int = getChildIndex(DisplayObject(textField));
//             removeTextField();
//             createTextField(childIndex);
//
//             accessibilityPropertiesChanged = true;
//             condenseWhiteChanged = true;
//             displayAsPasswordChanged = true;
//             enabledChanged = true;
//             maxCharsChanged = true;
//             restrictChanged = true;
//             tabIndexChanged = true;
//             textChanged = true;
//             selectionChanged = true;
//             horizontalScrollPositionChanged = true;
//         }
//
//         if (accessibilityPropertiesChanged)
//         {
//             textField.accessibilityProperties = _accessibilityProperties;
//
//             accessibilityPropertiesChanged = false;
//         }
//
//         if (condenseWhiteChanged)
//         {
//             textField.condenseWhite = _condenseWhite;
//
//             condenseWhiteChanged = false;
//         }
//
//         if (displayAsPasswordChanged)
//         {
//             textField.displayAsPassword = _displayAsPassword;
//
//             displayAsPasswordChanged = false;
//         }
//
//         if (enabledChanged || editableChanged)
//         {
//             textField.type = enabled && _editable ?
//                              TextFieldType.INPUT :
//                              TextFieldType.DYNAMIC;
//
//             if (enabledChanged)
//             {
//                 if (textField.enabled != enabled)
//                     textField.enabled = enabled;
//
//                 enabledChanged = false;
//             }
//             selectableChanged = true;
//             editableChanged = false;
//         }
//
//         if (selectableChanged)
//         {
//             if (_editable)
//                 textField.selectable = enabled;
//             else
//                 textField.selectable = enabled && _selectable;
//             selectableChanged = false;
//         }
//
//         if (maxCharsChanged)
//         {
//             textField.maxChars = _maxChars;
//
//             maxCharsChanged = false;
//         }
//
//         if (restrictChanged)
//         {
//             textField.restrict = _restrict;
//
//             restrictChanged = false;
//         }
//
//         if (tabIndexChanged)
//         {
//             textField.tabIndex = _tabIndex;
//
//             tabIndexChanged = false;
//         }
//
//         if (textChanged || htmlTextChanged)
//         {
//             // If the 'text' and 'htmlText' properties have both changed,
//             // the last one set wins.
//             if (isHTML)
//                 textField.htmlText = explicitHTMLText;
//             else
//                 textField.text = _text;
//
//             textFieldChanged(false, true);
//
//             textChanged = false;
//             htmlTextChanged = false;
//         }
//
//         if (selectionChanged)
//         {
//             textField.setSelection(_selectionBeginIndex, _selectionEndIndex);
//
//             selectionChanged = false;
//         }
//
//         if (horizontalScrollPositionChanged)
//         {
//             textField.scrollH = _horizontalScrollPosition;
//
//             horizontalScrollPositionChanged = false;
//         }
    }
    
    override public function getExplicitOrMeasuredWidth():Number
    {
        if (!isNaN(explicitWidth))
            return explicitWidth;
        measure()
        return measuredWidth;
    }

    override public function getExplicitOrMeasuredHeight():Number
    {
        if (!isNaN(explicitHeight))
            return explicitHeight;
        measure()
        return measuredHeight;
    }

    /**
     *  @private
     */
    override protected function measure():void
    {
        super.measure();

        var bm:EdgeMetrics = /*border && border is IRectangularBorder ?
                             IRectangularBorder(border).borderMetrics :*/
                             EdgeMetrics.EMPTY;

        var w:Number;
        var h:Number;
        
        // Start with a width of 160. This may change.
        measuredWidth = DEFAULT_MEASURED_WIDTH;

        if (maxChars)
        {
            // Use the width of "W" and multiply by the maxChars
            measuredWidth = Math.min(measuredWidth,
                measureText("W").width * maxChars + bm.left + bm.right + 8);
        }

        if (!text || text == "")
        {
            w = DEFAULT_MEASURED_MIN_WIDTH;
            h = measureText(" ").height +
                bm.top + bm.bottom + UITextField.TEXT_HEIGHT_PADDING;
            h += getStyle("paddingTop") + getStyle("paddingBottom");
        }
        else
        {
            var lineMetrics:TextLineMetrics;
            lineMetrics = measureText(text);

            w = lineMetrics.width + bm.left + bm.right + 8;
            h = lineMetrics.height + bm.top + bm.bottom + UITextField.TEXT_HEIGHT_PADDING;

            w += getStyle("paddingLeft") + getStyle("paddingRight");
            h += getStyle("paddingTop") + getStyle("paddingBottom");
        }

        measuredWidth = Math.max(w, measuredWidth);
        measuredHeight = Math.max(h, DEFAULT_MEASURED_HEIGHT);

        measuredMinWidth = DEFAULT_MEASURED_MIN_WIDTH;
        measuredMinHeight = DEFAULT_MEASURED_MIN_HEIGHT;
    }

    /**
     *  @private
     *  Stretch the border and fit the TextField inside it.
     */
    override protected function updateDisplayList(unscaledWidth:Number,
                                                  unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth, unscaledHeight);

        trace("TextInput.updateDisplayList not implemented");
//         var bm:EdgeMetrics;
//
//         if (border)
//         {
//             border.setActualSize(unscaledWidth, unscaledHeight);
//             bm = border is IRectangularBorder ?
//                     IRectangularBorder(border).borderMetrics : EdgeMetrics.EMPTY;
//         }
//         else
//         {
//             bm = EdgeMetrics.EMPTY;
//         }
//
//         var paddingLeft:Number = getStyle("paddingLeft");
//         var paddingRight:Number = getStyle("paddingRight");
//         var paddingTop:Number = getStyle("paddingTop");
//         var paddingBottom:Number = getStyle("paddingBottom");
//         var widthPad:Number = bm.left + bm.right;
//         var heightPad:Number = bm.top + bm.bottom + 1;
//
//         textField.x = bm.left;
//         textField.y = bm.top;
//
//         textField.x += paddingLeft;
//         textField.y += paddingTop;
//         widthPad += paddingLeft + paddingRight;
//         heightPad += paddingTop + paddingBottom;
//
//         textField.width = Math.max(0, unscaledWidth - widthPad);
//         textField.height = Math.max(0, unscaledHeight - heightPad);
    }

    /**
     *  @private
     *  Focus should always be on the internal TextField.
     */
    COMPILE::SWF
    override public function setFocus():void
    {
        var textView:TextInputView = view as TextInputView;
        textView.textField.stage.focus = textView.textField
    }

    /**
     *  @private
     */
    override public function styleChanged(styleProp:String):void
    {
    	trace("TextInput.styleChanged not implemented");
//         var allStyles:Boolean = (styleProp == null || styleProp == "styleName");
//
//         super.styleChanged(styleProp);
//
//         // Replace the borderSkin
//         if (allStyles || styleProp == "borderSkin")
//         {
//             if (border)
//             {
//                 removeChild(DisplayObject(border));
//                 border = null;
//                 createBorder();
//             }
//         }
    }
	
	//--------------------------------------------------------------------------
	//
	//  createElement
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
	 */
	COMPILE::JS
	override protected function createElement():WrappedHTMLElement
	{
		addElementToWrapper(this,'input');
		element.setAttribute('type', 'text');
		
		//attach input handler to dispatch royale change event when user write in textinput
		//goog.events.listen(element, 'change', killChangeHandler);
		goog.events.listen(element, 'input', textChangeHandler);
        goog.events.listen(element, 'keypress', enterEventHandler);
		return element;
	}
	
	private var inSetter:Boolean;

	/**
	 *  dispatch change event in response to a textChange event
	 *
	 *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
	 */
	public function textChangeHandler(event:Event):void
	{
        if (!inSetter)
        {
            dispatchEvent(new Event(Event.CHANGE));
            dispatchEvent(new Event(FlexEvent.VALUE_COMMIT));
        }
	}

    /**
     *  dispatch change event in response to a textChange event
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    COMPILE::JS
    public function enterEventHandler(event:Event):void
    {
        if (event['key'] === 'Enter') {
            // Cancel the default action, if needed
            event.preventDefault();
            dispatchEvent(new Event(FlexEvent.ENTER));
        }
        else
        {
            var textEvent:TextEvent = new TextEvent(TextEvent.TEXT_INPUT, false, true);
            textEvent.text = event['key'];
            if (!dispatchEvent(textEvent))
                event.preventDefault();
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------


    /**
     *  Creates the border for this component.
     *  Normally the border is determined by the
     *  <code>borderStyle</code> and <code>borderSkin</code> styles.
     *  It must set the border property to the instance
     *  of the border.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function createBorder():void
    {
    	trace("TextInput.createBorder not implemented");
//         if (!border)
//         {
//             var borderClass:Class = getStyle("borderSkin");
//
//             if (borderClass != null)
//             {
//                 border = new borderClass();
//
//                 if (border is ISimpleStyleClient)
//                     ISimpleStyleClient(border).styleName = this;
//
//                 // Add the border behind all the children.
//                 addChildAt(DisplayObject(border), 0);
//
//                 invalidateDisplayList();
//             }
//         }
    }

    /**
     *  Selects the text in the range specified by the parameters.
     *  If the control is not in focus, the selection highlight will not show
     *  until the control gains focus. Also, if the focus is gained by clicking
     *  on the control, any previous selection would be lost.
     *  If the two parameter values are the same,
     *  the new selection is an insertion point.
     *
     *  @param beginIndex The zero-based index of the first character in the
     *  selection; that is, the first character is 0, the second character
     *  is 1, and so on.
     *
     *  @param endIndex The zero-based index of the position <i>after</i>
     *  the last character in the selection (equivalent to the one-based
     *  index of the last character).
     *  If the parameter is 5, the last character in the selection, for
     *  example, is the fifth character.
     *  When the TextInput control gets the focus, the selection is visible
     *  if the <code>selectionBeginIndex</code> and <code>selectionEndIndex</code>
     *  properties are both set.
     *
     *  @tiptext Sets a new text selection.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     *  @royaleignorecoercion HTMLInputElement
     */
    public function setSelection(beginIndex:int, endIndex:int):void
    {
        _selectionBeginIndex = beginIndex;
        _selectionEndIndex = endIndex;
        selectionChanged = true;

        invalidateProperties();
        
        COMPILE::JS
        {
            (element as HTMLInputElement).setSelectionRange(beginIndex, endIndex);        
        }
          
    }

    /**
     *  @private
     *  Setting the 'htmlText' of textField changes its 'text',
     *  and vice versa, so afterwards doing so we call this method
     *  to update the storage vars for various properties.
     *  Afterwards, the TextInput's 'text', 'htmlText', 'textWidth',
     *  and 'textHeight' are all in sync with each other
     *  and are identical to the TextField's.
     */
    private function textFieldChanged(styleChangeOnly:Boolean,
                                      dispatchValueCommitEvent:Boolean):void
    {
    	trace("TextInput.textFieldChanged not implemented");
//         var changed1:Boolean;
//         var changed2:Boolean;
//
//         if (!styleChangeOnly)
//         {
//             changed1 = _text != textField.text;
//             _text = textField.text;
//         }
//
//         changed2 = _htmlText != textField.htmlText;
//         _htmlText = textField.htmlText;
//
//         // If the 'text' property changes, trigger bindings to it
//         // and conditionally dispatch a 'valueCommit' event.
//         if (changed1)
//         {
//             dispatchEvent(new Event("textChanged"));
//
//             if (dispatchValueCommitEvent)
//                 dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
//         }
//         // If the 'htmlText' property changes, trigger bindings to it.
//         if (changed2)
//             dispatchEvent(new Event("htmlTextChanged"));
//
//         _textWidth = textField.textWidth;
//         _textHeight = textField.textHeight;
    }

    //--------------------------------------------------------------------------
    //
    //  ITextInput Interface
    //
    //--------------------------------------------------------------------------

    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get selectionActivePosition():int
    {
        return selectionEndIndex;
    }


    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get selectionAnchorPosition():int
    {
        return selectionBeginIndex;
    }

    /**
     *  Selects the text in the range specified by the parameters.  Unlike
     *  <code>setSelection</code> this is done immediately.
     *
     *  @param anchorIndex The zero-based character index specifying the beginning
     *  of the selection that stays fixed when the selection is extended.
     *
     *  @param activeIndex The zero-based character index specifying
     *  the end of the selection that moves when the selection is extended.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function selectRange(anchorIndex:int, activeIndex:int):void
    {
    	trace("TextInput.selectRange not implemented");
        // Do it immediately.
//         textField.setSelection(anchorIndex, activeIndex);
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden event handlers: UIComponent
    //
    //--------------------------------------------------------------------------

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

}

}
