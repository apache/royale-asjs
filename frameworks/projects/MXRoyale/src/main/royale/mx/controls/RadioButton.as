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
COMPILE::JS {
	import goog.DEBUG;
}
COMPILE::SWF
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import org.apache.royale.core.UIButtonBase;
}

COMPILE::JS
{
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.WrappedHTMLElement;
	import org.apache.royale.html.supportClasses.RadioButtonIcon;
	import org.apache.royale.html.util.addElementToWrapper;
}

import org.apache.royale.core.IStrand;
import org.apache.royale.core.IUIBase;
import org.apache.royale.core.IValueToggleButtonModel;
import org.apache.royale.events.Event;
import org.apache.royale.events.MouseEvent;
import org.apache.royale.core.ISelectable;
/*
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.ui.Keyboard;
import mx.core.IFlexDisplayObject;
import mx.core.IFlexModuleFactory;
import mx.core.mx_internal;
import mx.events.FlexEvent;
import mx.core.FlexVersion;
import mx.core.IToggleButton;
import mx.events.ItemClickEvent;
import mx.managers.IFocusManager;
import mx.managers.IFocusManagerGroup;
import mx.core.UITextField;
import mx.styles.CSSStyleDeclaration;
import mx.styles.StyleManager;
import flash.text.TextLineMetrics;
import flash.utils.getQualifiedClassName;

use namespace mx_internal;
*/


/**
 *  The RadioButton control lets the user make a single choice
 *  within a set of mutually exclusive choices.
 *  A RadioButton group is composed of two or more RadioButton controls
 *  with the same <code>groupName</code> property. While grouping RadioButton instances
 *  in a RadioButtonGroup is optional, a group lets you do things
 *  like set a single event handler on a group of buttons, rather than
 *  on each individual button. The RadioButton group can refer to a group created by the
 *  <code>&lt;mx:RadioButtonGroup&gt;</code> tag.
 *  The user selects only one member of the group at a time.
 *  Selecting an unselected group member deselects the currently selected
 *  RadioButton control within that group.
 *
 *  <p>The RadioButton control has the following default characteristics:</p>
 *     <table class="innertable">
 *        <tr>
 *           <th>Characteristic</th>
 *           <th>Description</th>
 *        </tr>
 *        <tr>
 *           <td>Default size</td>
 *           <td>Wide enough to display the text label of the control</td>
 *        </tr>
 *        <tr>
 *           <td>Minimum size</td>
 *           <td>0 pixels</td>
 *        </tr>
 *        <tr>
 *           <td>Maximum size</td>
 *           <td>Undefined</td>
 *        </tr>
 *     </table>
 *
 *  @mxml
 *
 *  <p>The <code>&lt;mx:RadioButton&gt;</code> tag inherits all of the tag
 *  attributes of its superclass, and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;mx:RadioButton
 *    <strong>Properties</strong>
 *    groupName=""
 *    labelPlacement="right|left|top|bottom"
 *
 *    <strong>Styles</strong>
 *    disabledIconColor="0x999999"
 *    iconColor="0x2B333C"
 *  /&gt;
 *  </pre>
 *
 *  @includeExample examples/RadioButtonExample.mxml
 *
 *  @see mx.controls.RadioButtonGroup
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
COMPILE::SWF
public class RadioButton extends Button
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
    public function RadioButton()
    {
        super();

		addEventListener(org.apache.royale.events.MouseEvent.CLICK, internalMouseHandler);
    }



	protected static var dict:Dictionary = new Dictionary(true);

	private var _groupName:String;

	/**
	 *  The name of the group. Only one RadioButton in a group is selected.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public function get groupName() : String
	{
		return IValueToggleButtonModel(model).groupName;
	}
	public function set groupName(value:String) : void
	{
		IValueToggleButtonModel(model).groupName = value;
	}


    /**
     *  @private
     *  Storage for the group property.
     */
    private var _group:RadioButtonGroup;

    /**
     *  The RadioButtonGroup object to which this RadioButton belongs.
     *
     *  @default "undefined"
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get group():RadioButtonGroup
    {
    	if (goog.DEBUG)
    		trace("RadioButtonGroup not implemented for RadioButton");
    	return _group;
    }

    public function set group(value:RadioButtonGroup):void
    {
    	_group = value;
    }

	/**
	 *  The string used as a label for the RadioButton.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public function get text():String
	{
		return IValueToggleButtonModel(model).text;
	}
	public function set text(value:String):void
	{
		IValueToggleButtonModel(model).text = value;
	}

	/**
	 *  Whether or not the RadioButton instance is selected. Setting this property
	 *  causes the currently selected RadioButton in the same group to lose the
	 *  selection.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public function get selected():Boolean
	{
		return IValueToggleButtonModel(model).selected;
	}
	public function set selected(selValue:Boolean):void
	{
		IValueToggleButtonModel(model).selected = selValue;

		// if this button is being selected, its value should become
		// its group's selectedValue
		if( selValue ) {
			for each(var rb:RadioButton in dict)
			{
				if( rb.groupName == groupName )
				{
					rb.selectedValue = value;
				}
			}
		}
	}

	/**
	 *  The value associated with the RadioButton. For example, RadioButtons with labels,
	 *  "Red", "Green", and "Blue" might have the values 0, 1, and 2 respectively.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public function get value():Object
	{
		return IValueToggleButtonModel(model).value;
	}
	public function set value(newValue:Object):void
	{
		IValueToggleButtonModel(model).value = newValue;
	}

	/**
	 *  The group's currently selected value.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public function get selectedValue():Object
	{
		return IValueToggleButtonModel(model).selectedValue;
	}
	public function set selectedValue(newValue:Object):void
	{
		// a radio button is really selected when its value matches that of the group's value
		IValueToggleButtonModel(model).selected = (newValue == value);
		IValueToggleButtonModel(model).selectedValue = newValue;
	}

	/**
	 * @private
	 */
	override public function addedToParent():void
	{
		super.addedToParent();

		// if this instance is selected, set the local selectedValue to
		// this instance's value
		if( selected ) selectedValue = value;

		else {

			// make sure this button's selectedValue is set from its group's selectedValue
			// to keep it in sync with the rest of the buttons in its group.
			for each(var rb:RadioButton in dict)
			{
				if( rb.groupName == groupName )
				{
					selectedValue = rb.selectedValue;
					break;
				}
			}
		}

		dict[this] = this;
	}

	/**
	 * @private
	 */
	private function internalMouseHandler(event:org.apache.royale.events.MouseEvent) : void
	{
		// prevent radiobutton from being turned off by a click
		if( !selected ) {
			selected = !selected;
			dispatchEvent(new Event("change"));
		}
	}
}


COMPILE::JS
public class RadioButton extends Button
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
    public function RadioButton()
    {
        super();
    }

    /**
	 * @private
	 *
	 *  @royalesuppresspublicvarwarning
	 */
	public static var radioCounter:int = 0;

	private var labelFor:HTMLLabelElement;
	private var textNode:Text;
	private var icon:RadioButtonIcon;

	/**
	 * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
	 * @royaleignorecoercion HTMLInputElement
	 * @royaleignorecoercion HTMLLabelElement
	 * @royaleignorecoercion Text
	 */
	override protected function createElement():WrappedHTMLElement
	{
		icon = new RadioButtonIcon()
		icon.id = '_radio_' + RadioButton.radioCounter++;

		textNode = document.createTextNode('') as Text;

		labelFor = addElementToWrapper(this,'label') as HTMLLabelElement;
		labelFor.appendChild(icon.element);
		labelFor.appendChild(textNode);

	   (textNode as WrappedHTMLElement).royale_wrapper = this;
		(icon.element as WrappedHTMLElement).royale_wrapper = this;

		typeNames = 'RadioButton';

		return element;
	}

	override public function set id(value:String):void
	{
		super.id = value;
		labelFor.id = value;
		icon.element.id = value;
	}

	/**
	 * @royaleignorecoercion HTMLInputElement
	 */
	public function get groupName():String
	{
		return (icon.element as HTMLInputElement).name as String;
	}
	/**
	 * @royaleignorecoercion HTMLInputElement
	 */
	public function set groupName(value:String):void
	{
		(icon.element as HTMLInputElement).name = value;
	}

    /**
     *  @private
     *  Storage for the group property.
     */
    private var _group:RadioButtonGroup;

    /**
     *  The RadioButtonGroup object to which this RadioButton belongs.
     *
     *  @default "undefined"
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get group():RadioButtonGroup
    {
    	if (goog.DEBUG)
    		trace("RadioButtonGroup not implemented for RadioButton");
    	return _group;
    }

    public function set group(value:RadioButtonGroup):void
    {
    	_group = value;
    }

	public function get text():String
	{
		return textNode.nodeValue as String;
	}
	public function set text(value:String):void
	{
		textNode.nodeValue = value;
	}

	/**
	 * @royaleignorecoercion HTMLInputElement
	 * @export
	 */
	public function get selected():Boolean
	{
		return (icon.element as HTMLInputElement).checked;
	}
	/**
	 * @royaleignorecoercion HTMLInputElement
	 */
	public function set selected(value:Boolean):void
	{
		(icon.element as HTMLInputElement).checked = value;
	}

	/**
	 * @royaleignorecoercion HTMLInputElement
	 */
	public function get value():String
	{
		return (icon.element as HTMLInputElement).value;
	}
	/**
	 * @royaleignorecoercion HTMLInputElement
	 */
	public function set value(v:String):void
	{
		(icon.element as HTMLInputElement).value = "" + v;
	}

	/**
	 * @royaleignorecoercion HTMLInputElement
	 */
	public function get selectedValue():Object
	{
		var buttons:NodeList;
		var groupName:String;
		var i:int;
		var n:int;

		groupName = (icon.element as HTMLInputElement).name;
		buttons = document.getElementsByName(groupName);
		n = buttons.length;

		for (i = 0; i < n; i++) {
			if (buttons[i].checked) {
				return buttons[i].value;
			}
		}
		return null;
	}

	/**
	 * @royaleignorecoercion Array
	 * @royaleignorecoercion HTMLInputElement
	 */
	public function set selectedValue(value:Object):void
	{
		var buttons:NodeList;
		var groupName:String;
		var i:int;
		var n:int;

		groupName = (icon.element as HTMLInputElement).name;
		buttons = document.getElementsByName(groupName);
		n = buttons.length;
		for (i = 0; i < n; i++) {
			if (buttons[i].value === value) {
				buttons[i].checked = true;
				break;
			}
		}
	}
}

}
