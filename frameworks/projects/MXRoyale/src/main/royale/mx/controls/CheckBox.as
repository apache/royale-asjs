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
import mx.controls.beads.DisableBead;
import mx.events.MouseEvent;
import mx.events.utils.MouseEventConverter;



COMPILE::JS
{

	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.WrappedHTMLElement;
	import org.apache.royale.html.supportClasses.CheckBoxIcon;
	import org.apache.royale.html.util.addElementToWrapper;
	import org.apache.royale.events.utils.EventUtils;
	import org.apache.royale.events.BrowserEvent;

	import goog.events;
	import goog.events.EventType;
}
import org.apache.royale.core.ISelectable;
import org.apache.royale.core.IStrand;
import org.apache.royale.core.IToggleButtonModel;
import org.apache.royale.core.IUIBase;
import org.apache.royale.events.Event;
import org.apache.royale.events.MouseEvent;
import mx.events.FlexEvent;
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
 
[Style(name="disabledIconColor", type="uint", format="Color", inherit="yes", theme="halo,mx")]

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

		addEventListener(org.apache.royale.events.MouseEvent.CLICK, clickHandler);
	}

	/**
	 *  The text label for the CheckBox.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 *
	 *  @royaleignorecoercion org.apache.royale.core.IToggleButtonModel
	 */
	override public function get label():String
	{
		return IToggleButtonModel(model).text;
	}

	/**
	 *  @private
	 *  @royaleignorecoercion org.apache.royale.core.IToggleButtonModel
	 */
	override public function set label(value:String):void
	{
		var oldLabel:String = IToggleButtonModel(model).text
		IToggleButtonModel(model).text = value;
		if (oldLabel != value) {
			invalidateSize();
		}
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
		//this is strange, but the base class needs to have its private flag set also
		IToggleButtonModel(model).selected = super.selected = value;
	}

	protected function clickHandler(event:org.apache.royale.events.MouseEvent) : void
	{
		selected = !selected;
		dispatchEvent(new Event("change"));
	}
	
	//----------------------------------
	//  disabledIconColor
	//----------------------------------
	private var _disabledIconColor:uint = 0x999999;

	public function get disabledIconColor():uint
	{
	  return _disabledIconColor;
	}
	public function set disabledIconColor(value:uint):void
	{
		_disabledIconColor = value;
	}


	override public function get toggle():Boolean
	{
		return true; // TBD: retrieve from model
	}
}

COMPILE::JS
public class CheckBox extends Button implements IStrand, ISelectable
{
    private var _label:WrappedHTMLElement;
	private var _icon:CheckBoxIcon;
	private var _span:HTMLSpanElement;
	private var _textNode:Node;

	private static var _checkNumber:Number = 0;


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
		typeNames = 'CheckBox'; //@todo consider prefixing everything with 'mx '
	}

	/**
	 * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
	 * @royaleignorecoercion HTMLSpanElement
	 */
	override protected function createElement():WrappedHTMLElement
	{
		addElementToWrapper(this,'label');
		_label = element;
		_icon = new CheckBoxIcon();
		element.appendChild(_icon.element);
		_span = document.createElement('span') as HTMLSpanElement;
		_textNode = document.createTextNode('') /*as Node*/;
		_span.appendChild(_textNode);
		element.appendChild(_span);
		(_span as WrappedHTMLElement).royale_wrapper = this;
		//positioner.style.position = 'relative';
		_icon.element.royale_wrapper = this;
		_icon.element.addEventListener('change',internalChangeHandler)
		//_icon.element.addEventListener('click', clickHandler)
		goog.events.listen(_icon.element, goog.events.EventType.CLICK, this._internalClickHandler);
		return element;
	}

	/**
	 * emulation level API for subclass overrides
	 * @param param1
	 */
	protected function clickHandler(event:mx.events.MouseEvent) : void{

	}


	/**
	 *
	 * @private
	 * @royaleignorecoercion  mx.events.MouseEvent
	 * @royaleignorecoercion  org.apache.royale.events.BrowserEvent
	 */
	protected function _internalClickHandler(e:Object):void{
		//because we are doing something different internally with the click handling (to avoid the native bubbling between 'label' and 'input')
		//we will convert this manually:
		var mxEvent:mx.events.MouseEvent = e as mx.events.MouseEvent;
		//a click event can be sent as a PointerEvent. This currently is not captured in MouseEventConvertor, which assumes "MouseEvent" constructor
		if (!mxEvent){ //PointerEvent click is not automatically converted to mx event... at the moment (it may be in the future, hence the above), so lets do that manually:
			if (e is org.apache.royale.events.BrowserEvent) {
				mxEvent = MouseEventConverter.convert((e as org.apache.royale.events.BrowserEvent).nativeEvent);
				EventUtils.tagNativeEvent((e as org.apache.royale.events.BrowserEvent).nativeEvent,mxEvent);
			}
		}
		if (mxEvent)
			clickHandler(mxEvent);
	}

	/**
	 * @private
	 */
	protected function internalChangeHandler(e:Event):void{
		e.stopPropagation(); //stop the propagation because the bubbling change events can affect parent hierarchy change listeners
		dispatchEvent(new org.apache.royale.events.Event("change"));
		//don't use change event for binding, use click (and valueCommit), same as flex
		dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
	}

	override public function get label():String
	{
		return /*_label.childNodes.item(1)*/_textNode.nodeValue;
	}

	override public function set label(value:String):void
	{
		var oldLabel:String = /*_label.childNodes.item(1)*/_textNode.nodeValue
		/*_label.childNodes.item(1)*/_textNode.nodeValue = value;
		if (oldLabel != value) {
			invalidateSize();
		}
	}


	/**
	 * @royaleignorecoercion HTMLInputElement
	 */
	[Bindable("click")]
	[Bindable("valueCommit")]
	override public function get selected():Boolean
	{
		return (_icon.element as HTMLInputElement).checked;
	}

	protected var changeOnSelected:Boolean;
	/**
	 * @royaleignorecoercion HTMLInputElement
	 */
	override public function set selected(value:Boolean):void
	{
		if (value != (_icon.element as HTMLInputElement).checked) {
			//this is unusual, but the base class needs to have its private flag set also, and cannot (currently) do that inline (below) because of a transpiler issue.
			//GD - the above described issue is resolved now I think, could perhaps restore the following lines to inline assignments:
			super.selected = value;
			(_icon.element as HTMLInputElement).checked = /*doing this inline failed to work (transpiler issues) : super.selected =*/ value;
			if (changeOnSelected) {
				//convenience flag in overridden classes
				dispatchEvent(new Event(Event.CHANGE));
				changeOnSelected = false;
			}
			dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
		}
	}
	
	//----------------------------------
	//  disabledIconColor
	//----------------------------------
	private var _disabledIconColor:uint = 0x999999;

	public function get disabledIconColor():uint
	{
	  return _disabledIconColor;
	}
	public function set disabledIconColor(value:uint):void
	{
		_disabledIconColor = value;
	}



	override protected function configureDisableBead(inst:DisableBead):void{
		COMPILE::JS{
			inst.setComposedContent([_icon.element],[_span]);
		}
	}

	/**
	 * For internal use only in subclasses
	 */
	protected function get checkBoxIcon():CheckBoxIcon{
		return _icon;
	}


	override public function get toggle():Boolean
	{
		return true; // TBD: retrieve from model
	}

	override public function addEventListener(type:String, handler:Function, opt_capture:Boolean = false, opt_handlerScope:Object=null):void{
		if (type == 'click') {
			goog.events.listen(_icon.element, goog.events.EventType.CLICK, handler,opt_capture,opt_handlerScope);
		} else {
			super.addEventListener(type,handler,opt_capture,opt_handlerScope);
		}
	}

	override public function removeEventListener(type:String, handler:Function, opt_capture:Boolean = false, opt_handlerScope:Object=null):void{
		if (type == 'click') {
			goog.events.unlisten(_icon.element, goog.events.EventType.CLICK, handler,opt_capture,opt_handlerScope);
		} else {
			super.removeEventListener(type,handler,opt_capture,opt_handlerScope);
		}
	}

	/*protected var _classNamed:String = 'CheckBox';
	override public function dispatchEvent(event:Object):Boolean{
		var ret:Boolean;
		console.log(_classNamed+' dispatching ', event.type, this.selected);
		ret = super.dispatchEvent(event);
		console.log(_classNamed+' dispatched ', event.type, this.selected);
		return ret;
	}*/

}

}
