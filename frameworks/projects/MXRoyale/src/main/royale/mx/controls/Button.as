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
import mx.controls.beads.ToolTipBead;
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

	override public function addedToParent():void{
		super.addedToParent();
		COMPILE::JS{
			if (_toggle) {
				applyToggle();
			}
		}
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

	/*public function get textDecoration():String
	{
		var val:String;
		COMPILE::SWF{
			val = 'none';
		}
		COMPILE::JS{
			val = this.element.style.textDecoration;
			val = (val == 'underline') ? val : 'none';
		}
		return val;
	}
	public function set textDecoration(value:String):void
	{
		COMPILE::JS{
			value = (value == 'underline') ? value : 'none';
			this.element.style.textDecoration = value;
		}
	}*/

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

	private var _fixedIconWidth:uint = 0;
	/**
	 * New to Royale
	 * Setting to constrain the icon width
	 * @param value 0 if natural size, otherwise positive integer
	 * to constrain
	 */
	public function set fixedIconWidth(value:uint):void{
		_fixedIconWidth = value;
		if (icon) {
			COMPILE::JS {
				configureBGSize();
			}
		}
	}

	public function get fixedIconWidth():uint{
		return _fixedIconWidth;
	}



	private var _fixedIconHeight:uint = 0;
	/**
	 * New to Royale
	 * Setting to constrain the icon height
	 * @param value 0 if natural size, otherwise positive integer
	 * to constrain
	 */
	public function set fixedIconHeight(value:uint):void{
		_fixedIconHeight = value;
		if (icon) {
			COMPILE::JS {
				configureBGSize();
			}
		}
	}

	public function get fixedIconHeight():uint{
		return _fixedIconHeight;
	}

	private var _hGap:Number;
	public function set horizontalGap(value:Number):void{
		_hGap = value;
	}

	public function get horizontalGap():Number{
		var value:Number = _hGap;
		if (isNaN(value)) {
			value = Number(getStyle('horizontalGap'));
		}
		return isNaN(value) ? 2 : value;
	}

	private var _vGap:Number;
	public function set verticalGap(value:Number):void{
		_vGap = value;
	}

	public function get verticalGap():Number{
		var value:Number = _vGap;
		if (isNaN(value)) {
			value = Number(getStyle('verticalGap'));
		}
		return isNaN(value) ? 2 : value;
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
	private var selectedSet:Boolean;




	public function get label():String
	{
		return ITextModel(model).text;
	}

	/**
	 *  @private
	 */
	public function set label(value:String):void
	{
		if (!_ttListening) {
			addEventListener(mx.events.MouseEvent.MOUSE_OVER,checkTooltipNeeded)
			_ttListening = true;
		}
		labelSet = true;
		ITextModel(model).text = value;
		COMPILE::JS {
			setInnerHTML();
		}
		invalidateSize();
		/*if (parent)
			(parent as IEventDispatcher).dispatchEvent(new Event("layoutNeeded"));*/

	}

	private var _ttListening:Boolean;
	protected function checkTooltipNeeded(event:mx.events.MouseEvent):void
	{
		if (toolTip)
		{
			return;
		}
		var needed:Boolean;
		COMPILE::JS {
			needed = ( element.offsetWidth < element.scrollWidth)
		}

		if (needed)
		{
			if (!_toolTipBead)
			{
				_toolTipBead = new ToolTipBead();
				addBead(_toolTipBead);
			}
			_toolTipBead.toolTip = label;
		} else {
			if (_toolTipBead) {
				_toolTipBead.toolTip = null;
			}
		}
	}

	//----------------------------------
	//  toolTip
	//----------------------------------

	/**
	 *  @private
	 */
	//private var _toolTipBead:ToolTipBead;

	/*[Inspectable(category="General", defaultValue="null")]

	/!**
	 *  @private
	 *!/
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
	}*/


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

        if (newSelected !== undefined && !selectedSet)
        {
            selected = newSelected as Boolean;
            selectedSet = false;
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
		selectedSet = true;
		if (_selected != value) {
			_selected = value;
			COMPILE::JS{
				if (parent) {
					applyToggle();
				}
			}
		}
		dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
	}


	//----------------------------------
	//  selectedField
	//----------------------------------


	private var _selectedField:String = null;

	/**
	 *  The name of the field in the <code>data</code> property which specifies
	 *  the value of the Button control's <code>selected</code> property.
	 *  You can set this property when you use the Button control in an item renderer.
	 *  The default value is null, which means that the Button control does
	 *  not set its selected state based on a property in the <code>data</code> property.
	 *
	 *  @default null
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 0.9.9
	 */
	public function get selectedField():String
	{
		return _selectedField;
	}
	public function set selectedField(value:String):void
	{
		_selectedField = value;
	}

	//----------------------------------
	//  labelPlacement
	//----------------------------------

	/**
	 *  @private
	 *  Storage for labelPlacement property.
	 */
	//private var _labelPlacement:String = "right";//ButtonLabelPlacement.RIGHT;
	private var _labelPlacement:String = ButtonLabelPlacement.RIGHT;


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
		invalidateSize();
       		invalidateDisplayList();
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
		if (_toggle != value) {
			_toggle = value; // TBD: store in model
			if (!value) {

				_selected = false;
				selectedSet = false;
			}
			COMPILE::JS{
				if (parent) {
					applyToggle();
				}
				if (value) {
					element.addEventListener('click',onToggle, true);
				} else {
					element.removeEventListener('click',onToggle, true);
				}
			}
			dispatchEvent(new Event("toggleChanged"));
		}
	}

	COMPILE::JS
	protected function onToggle(e:BrowserEvent):void{
		_selected = !_selected;
		applyToggle();
		dispatchEvent(new org.apache.royale.events.Event('change'));
		dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
	}
	//----------------------------------
	//  internal
	//----------------------------------

	/**
	 * @private
	 * @royalesuppressexport
	 */
	COMPILE::JS
	protected function applyToggle():void
	{
		//note : no support for IE:
		var classList:Object = this.element.classList;
		if (classList){
			if (_toggle) {
				classList.add('toggle');
				if (_selected)
					classList.add('selected');
				else classList.remove('selected');
			} else {
				classList.remove('toggle');
				classList.remove('selected');
			}
		}
	}

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

	COMPILE::JS
	private var _span:HTMLSpanElement;
	
	/**
	 * @royaleignorecoercion HTMLImageElement
	 * @royaleignorecoercion HTMLSpanElement
	 */
	COMPILE::JS
	protected function setInnerHTML():void
	{
		var label:String = ITextModel(model).text;
		if (label != null) {
			if (!_span) {
				_span =  document.createElement("span") as HTMLSpanElement;
				element.appendChild(_span);
			}
			_span.textContent = label;
		}
		var icon:String = ImageAndTextModel(model).image;
		if (icon != null) {
			//avoid doing this, because it interferes with usage of other things like native css :hov state for background-color, for example
			//element.style.background = "url('"+icon+"') no-repeat 2px center";
			//instead use this, more explicit approach:
			element.style.backgroundImage = "url('"+icon+"')";
			element.style.backgroundRepeat = "no-repeat";
			var paddingLeft:Number = Number(this.paddingLeft);
			//@todo add support for labelPlacement, for now only assuming 'RIGHT'  (no LEFT, TOP, BOTTOM)
			element.style.backgroundPosition = paddingLeft + "px center";

			element.style["text-indent"] = String(paddingLeft + _fixedIconWidth + horizontalGap)+"px";

			if (!_fixedIconWidth || !_fixedIconHeight) {
				// since the load of a CSS background-image cannot be detected, a standard technique
				// is to create a dummy <img> and load the same image and listen for that to
				// complete. This element is never added to the DOM.
				var dummyImage:HTMLImageElement = document.createElement('img') as HTMLImageElement;
				dummyImage.addEventListener("load", handleImageLoaded2);
				dummyImage.src = icon;
			}
		}
		
		measuredWidth = Number.NaN;
		measuredHeight = Number.NaN;
	}

	COMPILE::JS
	private function configureBGSize():void{
		element.style.backgroundSize = (_fixedIconWidth ? _fixedIconWidth+'px ' : 'auto ') + (_fixedIconHeight ? _fixedIconHeight+'px' :'auto');
	}

	/**
	 * 
	 * @royaleignorecoercion HTMLImageElement
	 */
	COMPILE::JS
	private function handleImageLoaded2(event:BrowserEvent):void
	{
		var img:HTMLImageElement = event.target as HTMLImageElement;
		//@todo add support for labelPlacement, for now only assuming 'RIGHT' (no LEFT, TOP, BOTTOM)
		var paddingLeft:Number = Number(this.paddingLeft);

		var hOffset:uint = _fixedIconWidth ? _fixedIconWidth : img.naturalWidth;
		configureBGSize();
		element.style["text-indent"] = String(paddingLeft + hOffset + horizontalGap)+"px";

		if (this.isHeightSizedToContent() ) {
			if (!_fixedIconHeight)
				this.setHeight( Math.max(img.naturalHeight, element.offsetHeight));
		}

		
		measuredWidth = Number.NaN;
		measuredHeight = Number.NaN;
		
		var newEvent:Event = new Event("layoutNeeded",true);
		dispatchEvent(newEvent);
	}

	//--------------------------------------------------------------------------
	//
	//  Royale-specific overrides
	//
	//--------------------------------------------------------------------------
	COMPILE::JS
	override public function get measuredWidth():Number{
		if (isNaN(_measuredWidth) || _measuredWidth </*=*/ 0) {
			var oldHeight:Object = this.positioner.style.height;
			if (this.isHeightSizedToContent()) {
				//do we need to respect newlines and set whitespace?
				if (oldHeight.length) this.positioner.style.height = '';
			}
			var oldPosition:String = this.positioner.style.position;
			this.positioner.style.position = 'fixed';
			var superWidth:Number = super.measuredWidth;
			this.positioner.style.position = oldPosition ? oldPosition : '';
			if (oldHeight.length) this.positioner.style.height = oldHeight;
			return superWidth ? superWidth + 1 : 0; //round up by 1 pixel
		}
		return _measuredWidth;
	}

	COMPILE::JS
	override public function get measuredHeight():Number{
		if (isNaN(_measuredHeight) || _measuredHeight </*=*/ 0) {
			var oldWidth:Object = this.positioner.style.width;
			if (this.isWidthSizedToContent()) {
				//do we need to respect newlines and set whitespace?
				if (oldWidth.length) this.positioner.style.width = '';
			}
			var oldPosition:String = this.positioner.style.position;
			this.positioner.style.position = 'fixed';
			var superHeight:Number = super.measuredHeight;
			this.positioner.style.position = oldPosition ? oldPosition : '';
			if (oldWidth.length) this.positioner.style.width = oldWidth;
			return superHeight ? superHeight + 1 : 0; //round up by 1 pixel
		}
		return _measuredHeight;
	}


	override protected function configureDisableBead(inst:DisableBead):void{
		//@todo, the following works for regular buttons, but we also need to somehow support the buttons with native background image....
		//inst.setComposedContent([element],[]);
	}
	
}

}
