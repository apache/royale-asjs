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
	import org.apache.royale.core.WrappedHTMLElement;
	import org.apache.royale.events.BrowserEvent;
	import org.apache.royale.html.util.addElementToWrapper;
}
import mx.controls.dataGridClasses.DataGridListData;
import mx.controls.listClasses.BaseListData;
import mx.controls.listClasses.IDropInListItemRenderer;
import mx.controls.listClasses.IListItemRenderer;
import mx.core.IDataRenderer;
import mx.core.UIComponent;
import mx.events.FlexEvent;

import org.apache.royale.binding.ItemRendererDataBinding;
import org.apache.royale.binding.DataBindingBase;
import org.apache.royale.core.ITextModel;
import org.apache.royale.events.Event;
import org.apache.royale.events.IEventDispatcher;
import org.apache.royale.html.accessories.ToolTipBead;
import org.apache.royale.html.beads.models.ImageAndTextModel;

/*
import mx.events.MoveEvent;
import mx.events.SandboxMouseEvent;
import mx.managers.IFocusManagerComponent;
import mx.styles.ISimpleStyleClient;


use namespace mx_internal;
*/

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched when the user clicks on a button.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10.2
 *  @playerversion AIR 2.6
 *  @productversion Royale 0.0
 */
[Event(name="click", type="mx.events.MouseEvent")]

/**
 *  Dispatched when the user presses the Button control.
 *  If the <code>autoRepeat</code> property is <code>true</code>,
 *  this event is dispatched repeatedly as long as the button stays down.
 *
 *  @eventType mx.events.FlexEvent.BUTTON_DOWN
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="buttonDown", type="mx.events.FlexEvent")]

/**
 *  Dispatched when the <code>selected</code> property
 *  changes for a toggle Button control. A toggle Button control means that the
 *  <code>toggle</code> property is set to <code>true</code>.
 *
 *  For the RadioButton controls, this event is dispatched when the <code>selected</code>
 *  property changes.
 *
 *  For the CheckBox controls, this event is dispatched only when the
 *  user interacts with the control by using the mouse.
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
 *  The Button control is a commonly used rectangular button.
 *  Button controls look like they can be pressed.
 *  They can have a text label, an icon, or both on their face.
 *
 *  <p>Buttons typically use event listeners to perform an action
 *  when the user selects the control. When a user clicks the mouse
 *  on a Button control, and the Button control is enabled,
 *  it dispatches a <code>click</code> event and a <code>buttonDown</code> event.
 *  A button always dispatches events such as the <code>mouseMove</code>,
 *  <code>mouseOver</code>, <code>mouseOut</code>, <code>rollOver</code>,
 *  <code>rollOut</code>, <code>mouseDown</code>, and
 *  <code>mouseUp</code> events whether enabled or disabled.</p>
 *
 *  <p>You can customize the look of a Button control
 *  and change its functionality from a push button to a toggle button.
 *  You can change the button appearance by using a skin
 *  for each of the button's states.</p>
 *
 *  <p>The label of a Button control uses a bold typeface. If you embed
 *  a font that you want to use for the label of the Button control, you must
 *  embed the bold typeface; for example:</p>
 *
 *  <pre>
 *  &lt;fx:style&gt;
 *    &#64;font-face {
 *      src:url("../MyFont-Bold.ttf");
 *      fontFamily: myFont;
 *      fontWeight: bold;
 *    }
 *   .myBoldStyle {
 *      fontFamily: myFont;
 *      fontWeight: bold;
 *    }
 *  &lt;/fx:style&gt;
 *  ...
 *  &lt;mx:Button ... styleName="myBoldStyle"/&gt;
 *  </pre>
 *
 *  <p>The Button control has the following default characteristics:</p>
 *  <table class="innertable">
 *     <tr><th>Characteristic</th><th>Description</th></tr>
 *     <tr><td>Default size</td><td>A size large enough to hold the label text, and any icon</td></tr>
 *     <tr><td>Minimum size</td><td>0 pixels</td></tr>
 *     <tr><td>Maximum size</td><td>No limit</td></tr>
 *  </table>
 *
 *  @mxml
 *
 *  <p>The <code>&lt;mx:Button&gt;</code> tag inherits all the tag attributes
 *  of its superclass, and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;mx:Button
 *    <b>Properties</b>
 *    autoRepeat="false|true"
 *    emphasized="false|true"
 *    fontContext="<i>IFontModuleFactory</i>"
 *    label=""
 *    labelPlacement="right|left|bottom|top"
 *    selected="false|true"
 *    selectedField="null"
 *    stickyHighlighting="false|true"
 *    toggle="false|true"
 *
 *    <b>Styles</b>
 *    borderColor="0xAAB3B3"
 *    color="0x0B333C"
 *    cornerRadius="4"
 *    disabledColor="0xAAB3B3"
 *    disabledIcon="null"
 *    disabledSkin="mx.skins.halo.ButtonSkin"
 *    downIcon="null"
 *    downSkin="mx.skins.halo.ButtonSkin"
 *    fillAlphas="[0.6, 0.4]"
 *    fillColors="[0xE6EEEE, 0xFFFFFF]"
 *    focusAlpha="0.5"
 *    focusRoundedCorners"tl tr bl br"
 *    fontAntiAliasType="advanced"
 *    fontFamily="Verdana"
 *    fontGridFitType="pixel"
 *    fontSharpness="0"
 *    fontSize="10"
 *    fontStyle="normal|italic"
 *    fontThickness="0"
 *    fontWeight="bold|normal"
 *    highlightAlphas="[0.3, 0.0]"
 *    horizontalGap="2"
 *    icon="null"
 *    kerning="false|true"
 *    leading="2"
 *    letterSpacing="0"
 *    overIcon="null"
 *    overSkin="mx.skins.halo.ButtonSkin"
 *    paddingBottom="2"
 *    paddingLeft="0"
 *    paddingRight="0"
 *    paddingTop="2"
 *    repeatDelay="500"
 *    repeatInterval="35"
 *    selectedDisabledIcon="null"
 *    selectedDisabledSkin="mx.skins.halo.ButtonSkin"
 *    selectedDownIcon="null"
 *    selectedDownSkin="mx.skins.halo.ButtonSkin"
 *    selectedOverIcon="null"
 *    selectedOverSkin="mx.skins.halo.ButtonSkin"
 *    selectedUpIcon="null"
 *    selectedUpSkin="mx.skins.halo.ButtonSkin"
 *    skin="mx.skins.halo.ButtonSkin"
 *    textAlign="center|left|right"
 *    textDecoration="none|underline"
 *    textIndent="0"
 *    textRollOverColor="0x2B333C"
 *    textSelectedColor="0x000000"
 *    upIcon="null"
 *    upSkin="mx.skins.halo.ButtonSkin"
 *    verticalGap="2"
 *
 *    <b>Events</b>
 *    buttonDown="<i>No default</i>"
 *    change="<i>No default</i>"
 *    dataChange="<i>No default</i>"
 *  /&gt;
 *  </pre>
 *
 *  @includeExample examples/ButtonExample.mxml
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class Button extends UIComponent implements IDataRenderer, IListItemRenderer, IDropInListItemRenderer
{
	
	public function Button()
	{
		super();
		typeNames = "Button";
	}
	
	// ------------------------------------------------
	//  locale
	// ------------------------------------------------
	
	public function get locale():String
	{
		return "en";
	}
	public function set locale(value:String):void
	{
	}
	
	// ------------------------------------------------
	//  textDecoration
	// ------------------------------------------------
	
	public function get textDecoration():String
	{
		return "none";
	}
	public function set textDecoration(value:String):void
	{
	}
	
	// ------------------------------------------------
	//  icon
	// ------------------------------------------------
	
	/**
	 *  The URL of an icon to use in the button
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public function get icon():String
	{
		return ImageAndTextModel(model).image;
	}
	
	/**
	 *  @private
	 */
	public function set icon(value:String):void
	{
		ImageAndTextModel(model).image = value;
		COMPILE::JS {
			setInnerHTML();
		}
	}
	
	// ------------------------------------------------
	//  disabledIcon
	// ------------------------------------------------
	
	/**
	 *  The URL of an disabledIcon to use in the button
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public function get disabledIcon():String
	{
		return null;
	}
	
	/**
	 *  @private
	 */
	public function set disabledIcon(value:String):void
	{
		
	}
	
	
	
	
	//----------------------------------
	//  label
	//----------------------------------
	
    private var labelSet:Boolean;
	public function get label():String
	{
		return ITextModel(model).text;
	}
	
	/**
	 *  @private
	 */
	public function set label(value:String):void
	{
		labelSet = true;
		ITextModel(model).text = value;
		COMPILE::JS {
			setInnerHTML();
		}
		if (parent)
			(parent as IEventDispatcher).dispatchEvent(new Event("layoutNeeded"));
	}


	
	//----------------------------------
	//  toolTip
	//----------------------------------
	
	/**
	 *  @private
	 */	
	private var _toolTipBead:ToolTipBead;
	
	[Inspectable(category="General", defaultValue="null")]
	
	/**
	 *  @private
	 */
	override public function set toolTip(value:String):void
	{
		super.toolTip = value;
		
		_toolTipBead = getBeadByType(ToolTipBead) as ToolTipBead;
		if (_toolTipBead == null) {
			_toolTipBead = new ToolTipBead();
			addBead(_toolTipBead);
		}
		_toolTipBead.toolTip = value;
	}
	
	override public function get toolTip():String
	{
		if (_toolTipBead) {
			return _toolTipBead.toolTip;
		}
		return null;
	}
	
	
	//----------------------------------
	//  data
	//----------------------------------
	
	/**
	 *  @private
	 *  Storage for the data property;
	 */
	private var _data:Object;
	
	[Bindable("dataChange")]
	[Inspectable(environment="none")]
	
	/**
	 *  The <code>data</code> property lets you pass a value
	 *  to the component when you use it as an item renderer or item editor.
	 *  You typically use data binding to bind a field of the <code>data</code>
	 *  property to a property of this component.
	 *
	 *  <p>When you use the control as a drop-in item renderer or drop-in
	 *  item editor, Flex automatically writes the current value of the item
	 *  to the <code>selected</code> property of this control.</p>
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
	
	private var bindingAdded:Boolean;

	/**
	 * By default, ItemRendererDataBinding is added on-demand if an instance is used as a Drop-In Renderer
	 * But Button subclasses need to be able to add whatever binding support makes sense, and avoid the possibility
	 * of conflicting databinding support. Using this method in subclasses is one way to achieve that.

	 * @param bindingImplClass a class that is a subclass of DataBindingBase
	 * @param init true if the bindings should be initialized immediately
	 */
	protected function addBindingSupport(bindingImplClass:Class, init:Boolean):void{
		if (!bindingAdded) {
			if (!getBeadByType(DataBindingBase)) {
				var bindingImpl:DataBindingBase = new bindingImplClass()
				addBead(bindingImpl);
				if (init) bindingImpl.initializeNow(); //no need to use an event in this case
			}
			bindingAdded = true;
		}
	}
	
	
	/**
	 *  @private
	 */
	public function set data(value:Object):void
	{
        var newSelected:*;
        var newLabel:*;

		if (!bindingAdded)
		{
			addBindingSupport(ItemRendererDataBinding, true);
		}
		
        _data = value;

        if (_listData && _listData is DataGridListData && 
            DataGridListData(_listData).dataField !=null)
        {
            newSelected = _data[DataGridListData(_listData).dataField];

            newLabel = "";
        }
        else if (_listData)
        {
            if (selectedField)
                newSelected = _data[selectedField];

            newLabel = _listData.label;
        }
        else
        {
            newSelected = _data;
        }

        if (newSelected !== undefined/* && !selectedSet*/)
        {
            selected = newSelected as Boolean;
            //selectedSet = false;
        }
        if (newLabel !== undefined && !labelSet)
        {
            label = newLabel;
            labelSet = false;
        }

        dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
	}
	
	//-----------------------------------
	//  listData
	//-----------------------------------
	
	/**
	 *  @private
	 *  Storage for the listData property.
	 */
	private var _listData:Object;
	
	[Bindable("dataChange")]
	[Inspectable(environment="none")]
	
	/**
	 *  When a component is used as a drop-in item renderer or drop-in
	 *  item editor, Flex initializes the <code>listData</code> property
	 *  of the component with the appropriate data from the list control.
	 *  The component can then use the <code>listData</code> property
	 *  to initialize the <code>data</code> property
	 *  of the drop-in item renderer or drop-in item editor.
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
	//  selected
	//----------------------------------
	
	private var _selected:Boolean = false;
	
	public function get selected():Boolean
	{
		return _selected;
	}
	
	/**
	 *  @private
	 */
	public function set selected(value:Boolean):void
	{
		_selected = value;
	}
	
	//----------------------------------
	//  labelPlacement
	//----------------------------------
	
	/**
	 *  @private
	 *  Storage for labelPlacement property.
	 */
	private var _labelPlacement:String = "right";//ButtonLabelPlacement.RIGHT;
	
	[Bindable("labelPlacementChanged")]
	[Inspectable(category="General", enumeration="left,right,top,bottom", defaultValue="right")]
	
	/**
	 *  Orientation of the label in relation to a specified icon.
	 *  Valid MXML values are <code>right</code>, <code>left</code>,
	 *  <code>bottom</code>, and <code>top</code>.
	 *
	 *  <p>In ActionScript, you can use the following constants
	 *  to set this property:
	 *  <code>ButtonLabelPlacement.RIGHT</code>,
	 *  <code>ButtonLabelPlacement.LEFT</code>,
	 *  <code>ButtonLabelPlacement.BOTTOM</code>, and
	 *  <code>ButtonLabelPlacement.TOP</code>.</p>
	 *
	 *  @default ButtonLabelPlacement.RIGHT
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get labelPlacement():String
	{
		return _labelPlacement;
	}
	
	/**
	 *  @private
	 */
	public function set labelPlacement(value:String):void
	{
		_labelPlacement = value;
		dispatchEvent(new Event("labelPlacementChanged"));
	}
	
	
	//----------------------------------
	//  toggle
	//----------------------------------
	
	/**
	 *  @private
	 *  Storage for toggle property.
	 */
	private var _toggle:Boolean = false; // TBD: store in model
	
	/**
	 *  @private
	 */	
	[Bindable("toggleChanged")]
	[Inspectable(category="General", defaultValue="false")]
	
	/**
	 *  Controls whether a Button is in a toggle state or not.
	 *
	 *  If <code>true</code>, clicking the button toggles it
	 *  between a selected and an unselected state.
	 *  You can get or set this state programmatically
	 *  by using the <code>selected</code> property.
	 *
	 *  If <code>false</code>, the button does not stay pressed
	 *  after the user releases it.
	 *  In this case, its <code>selected</code> property
	 *  is always <code>false</code>.
	 *  Buttons like this are used for performing actions.
	 *
	 *  When <code>toggle</code> is set to <code>false</code>,
	 *  <code>selected</code> is forced to <code>false</code>
	 *  because only toggle buttons can be selected.
	 *
	 *  @default false
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get toggle():Boolean
	{
		return _toggle; // TBD: retrieve from model
	}
	
	/**
	 *  @private
	 */
	public function set toggle(value:Boolean):void
	{
		_toggle = value; // TBD: store in model
		dispatchEvent(new Event("toggleChanged"));
	}
	
	//----------------------------------
	//  internal
	//----------------------------------
	
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
	
	/**
	 * @royaleignorecoercion HTMLImageElement
	 */
	COMPILE::JS
	protected function setInnerHTML():void
	{
		var label:String = ITextModel(model).text;
		if (label != null) {
			element.innerHTML = label;
		}
		var icon:String = ImageAndTextModel(model).image;
		if (icon != null) {
			element.style.background = "url('"+icon+"') no-repeat 2px center";
			
			// since the load of a CSS background-image cannot be detected, a standard technique
			// is to create a dummy <img> and load the same image and listen for that to
			// complete. This element is never added to the DOM.
			var dummyImage:HTMLImageElement = document.createElement('img') as HTMLImageElement;
			dummyImage.addEventListener("load", handleImageLoaded2);
			dummyImage.src = icon;
		}
		
		measuredWidth = Number.NaN;
		measuredHeight = Number.NaN;
	}
	
	/**
	 * 
	 * @royaleignorecoercion HTMLImageElement
	 */
	COMPILE::JS
	private function handleImageLoaded2(event:BrowserEvent):void
	{
		var img:HTMLImageElement = event.target as HTMLImageElement;
		element.style["text-indent"] = String(img.naturalWidth+4)+"px";
		
		this.height = Math.max(img.naturalHeight, element.offsetHeight);
		
		measuredWidth = Number.NaN;
		measuredHeight = Number.NaN;
		
		var newEvent:Event = new Event("layoutNeeded",true);
		dispatchEvent(newEvent);
	}
	
}

}
