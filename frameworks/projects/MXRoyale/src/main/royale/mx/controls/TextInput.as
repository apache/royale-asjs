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
    import goog.DEBUG;
	import goog.events;
	import org.apache.royale.core.WrappedHTMLElement;
	import org.apache.royale.html.util.addElementToWrapper;
}
import org.apache.royale.core.ITextModel;
import org.apache.royale.core.UIBase;
import org.apache.royale.events.Event;
/*
import flash.accessibility.AccessibilityProperties;
import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.TextEvent;
import flash.system.IME;
import flash.system.IMEConversionMode;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.text.TextLineMetrics;
import flash.ui.Keyboard;

import mx.controls.listClasses.BaseListData;
import mx.controls.listClasses.IDropInListItemRenderer;
import mx.controls.listClasses.IListItemRenderer;
import mx.core.EdgeMetrics;
import mx.core.IDataRenderer;
import mx.core.IFlexDisplayObject;
import mx.core.IFlexModuleFactory;
import mx.core.IFontContextComponent;
import mx.core.IIMESupport;
import mx.core.IInvalidating;
import mx.core.IRectangularBorder;
import mx.core.IUITextField;
import mx.core.ITextInput;
import mx.core.UIComponent;
import mx.core.UITextField;
import mx.core.mx_internal;
import mx.events.FlexEvent;
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
[Event(name="change", type="flash.events.Event")]

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
[Event(name="textInput", type="flash.events.TextEvent")]

//--------------------------------------
//  Styles
//--------------------------------------



//--------------------------------------
//  Other metadata
//--------------------------------------

[DataBindingInfo("editEvents", "&quot;focusIn;focusOut&quot;")]

[DefaultBindingProperty(source="text", destination="text")]

[DefaultTriggerEvent("change")]


[Alternative(replacement="spark.components.TextInput", since="4.0")]

//--------------------------------------
//  Excluded APIs
//--------------------------------------


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
public class TextInput extends UIComponent
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

    //--------------------------------------------------------------------------
    //
    //  Overridden properties
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
		typeNames = 'TextInput';

		//attach input handler to dispatch royale change event when user write in textinput
		//goog.events.listen(element, 'change', killChangeHandler);
		goog.events.listen(element, 'input', textChangeHandler);
		return element;
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
    override public function get tabIndex():int
    {
        return _tabIndex;
    }

    /**
     *  @private
     */
    override public function set tabIndex(value:int):void
    {
        if (value == _tabIndex)
            return;

        _tabIndex = value;
        tabIndexChanged = true;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------





    //----------------------------------
    //  editable
    //----------------------------------


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
        return true;
    }

    /**
     *  @private
     */
    public function set editable(value:Boolean):void
    {
        if (goog.DEBUG)
        	trace("setting editable is not yet implemented")
    }

    //----------------------------------
    //  text and htmlText
    //----------------------------------

	/**
	 *  @copy org.apache.royale.html.Label#text
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 *  @royaleignorecoercion HTMLInputElement
	 */
	[Bindable(event="change")]
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
	 *  @royaleignorecoercion HTMLInputElement
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
			(element as HTMLInputElement).value = value;
			dispatchEvent(new Event('textChange'));
		}
	}

	/**
	 *  @copy org.apache.royale.html.Label#html
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 *  @royaleignorecoercion HTMLInputElement
	 */
	[Bindable(event="change")]
	public function get html():String
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
	 *  @royaleignorecoercion HTMLInputElement
	 */
	public function set html(value:String):void
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
			dispatchEvent(new Event(Event.CHANGE));
	}

    //----------------------------------
    //  Methods
    //----------------------------------


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
     */
    public function setSelection(beginIndex:int, endIndex:int):void
    {
        if (goog.DEBUG)
        	trace("setSelection is not implemented");
    }
}

}
