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

	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.WrappedHTMLElement;
	import org.apache.royale.html.supportClasses.CheckBoxIcon;
	import org.apache.royale.html.util.addElementToWrapper;
}
import org.apache.royale.core.ISelectable;
import org.apache.royale.core.IStrand;
import org.apache.royale.core.IToggleButtonModel;
import org.apache.royale.core.IUIBase;
import org.apache.royale.events.Event;
import org.apache.royale.events.MouseEvent;
COMPILE::SWF
{
	import flash.events.MouseEvent;
}

/*
import mx.core.FlexVersion;
import mx.core.IToggleButton;
import mx.core.mx_internal;
import mx.core.UITextField;
import flash.text.TextLineMetrics;
import flash.utils.getQualifiedClassName;

use namespace mx_internal;
*/

/**
 *  Dispatched when the user checks or un-checks the CheckBox.
 *
 *  @langversion 3.0
 *  @playerversion Flash 10.2
 *  @playerversion AIR 2.6
 *  @productversion Royale 0.0
 */
[Event(name="change", type="org.apache.royale.events.Event")]

/**
 *  The CheckBox control consists of an optional label and a small box
 *  that can contain a check mark or not.
 *  You can place the optional text label to the left, right, top, or bottom
 *  of the CheckBox.
 *  When a user clicks a CheckBox control or its associated text,
 *  the CheckBox control changes its state
 *  from checked to unchecked or from unchecked to checked.
 *  CheckBox controls gather a set of true or false values
 *  that are not mutually exclusive.
 *
 *  <p>The CheckBox control has the following default characteristics:</p>
 *     <table class="innertable">
 *        <tr>
 *           <th>Characteristic</th>
 *           <th>Description</th>
 *        </tr>
 *        <tr>
 *           <td>Default size</td>
 *           <td>A size large enough to hold the label</td>
 *        </tr>
 *        <tr>
 *           <td>Minimum size</td>
 *           <td>0 pixels</td>
 *        </tr>
 *        <tr>
 *           <td>Maximum size</td>
 *           <td>No limit</td>
 *        </tr>
 *     </table>
 *
 *  @mxml
 *
 *  <p>The <code>&lt;mx:CheckBox&gt;</code> tag inherits all of the tag
 *  attributes of its superclass and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;mx:CheckBox
 *    <strong>Styles</strong>
 *    disabledIconColor="0x999999"
 *    iconColor="0x2B333C"
 *  /&gt;
 *  </pre>
 *
 *  @includeExample examples/CheckBoxExample.mxml
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
COMPILE::SWF
public class CheckBox extends Button implements IStrand, ISelectable
{
    /**
	 *  Constructor.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public function CheckBox()
	{
		super();

		addEventListener(org.apache.royale.events.MouseEvent.CLICK, internalMouseHandler);
	}

	/**
	 *  The text label for the CheckBox.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	override public function get label():String
	{
		return IToggleButtonModel(model).text;
	}

	/**
	 *  @private
	 */
	override public function set label(value:String):void
	{
		IToggleButtonModel(model).text = value;
	}

	[Bindable("change")]
	/**
	 *  <code>true</code> if the check mark is displayed.
	 *
	 *  @default false
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	override public function get selected():Boolean
	{
		return IToggleButtonModel(model).selected;
	}

	/**
	 *  @private
	 */
	override public function set selected(value:Boolean):void
	{
		IToggleButtonModel(model).selected = value;
	}

	private function internalMouseHandler(event:org.apache.royale.events.MouseEvent) : void
	{
		selected = !selected;
		dispatchEvent(new Event("change"));
	}
}

COMPILE::JS
public class CheckBox extends Button implements IStrand, ISelectable
{
    private var _label:WrappedHTMLElement;
	private var _icon:CheckBoxIcon;

	private static var _checkNumber:Number = 0;

	/**
	 * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
	 */
	override protected function createElement():WrappedHTMLElement
	{
		addElementToWrapper(this,'label');
		_label = element;
		_icon = new CheckBoxIcon();
		element.appendChild(_icon.element);

		element.appendChild(document.createTextNode(''));
		//positioner.style.position = 'relative';
		_icon.element.royale_wrapper = this;

		typeNames = 'CheckBox CheckBoxIcon';

		return element;
	}

	override public function get label():String
	{
		return _label.childNodes.item(1).nodeValue;
	}

	override public function set label(value:String):void
	{
		_label.childNodes.item(1).nodeValue = value;
	}

	[Bindable("change")]
	override public function get selected():Boolean
	{
		return (_icon.element as HTMLInputElement).checked;
	}

	override public function set selected(value:Boolean):void
	{
	   (_icon.element as HTMLInputElement).checked = value;
	}
}

}
