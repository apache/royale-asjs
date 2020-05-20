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
COMPILE::SWF
{
    import flash.display.InteractiveObject;    
}
/*
import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.TextEvent;
import mx.collections.ArrayCollection;
import mx.collections.CursorBookmark;
import mx.collections.ICollectionView;
import mx.collections.IList;
import mx.collections.IViewCursor;
import mx.collections.ListCollectionView;
import mx.collections.XMLListCollection;
import mx.core.EdgeMetrics;
import mx.core.FlexVersion;
import mx.core.IFlexDisplayObject;
import mx.core.IIMESupport;
import mx.core.IRectangularBorder;
import mx.core.IUITextField;
import mx.core.UITextField;
import mx.events.CollectionEvent;
import mx.events.CollectionEventKind;
import mx.events.FlexEvent;
import mx.managers.IFocusManager;
import mx.styles.ISimpleStyleClient;
import mx.styles.StyleProxy;
import mx.utils.UIDUtil;
*/
import mx.core.ITextInput;
import mx.core.UIComponent;
import mx.core.mx_internal;
use namespace mx_internal;

import mx.managers.IFocusManagerComponent;

import org.apache.royale.core.IComboBoxModel;
import org.apache.royale.html.TextInput;
import org.apache.royale.html.beads.IComboBoxView;
import org.apache.royale.core.IComboBoxModel;
import org.apache.royale.core.IUIBase;
import mx.events.FlexEvent;
import mx.collections.IList;
import mx.collections.XMLListCollection;
import mx.collections.ArrayCollection;
import mx.collections.ICollectionView;
import mx.collections.ListCollectionView;
import org.apache.royale.html.beads.DisableBead;
import org.apache.royale.events.Event;

/**
 *  The alpha of the content background for this component.
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[Style(name="contentBackgroundAlpha", type="Number", inherit="yes", theme="spark")]

/**
 *  Color of the content area of the component.
 *   
 *  @default 0xFFFFFF
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */ 
[Style(name="contentBackgroundColor", type="uint", format="Color", inherit="yes")]

/**
 *  Color of focus ring when the component is in focus
 *   
 *  @default 0x70B2EE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */ 
//[Style(name="focusColor", type="uint", format="Color", inherit="yes", theme="spark")]

/**
 *  Color of any symbol of a component. Examples include the check mark of a CheckBox or
 *  the arrow of a ScrollBar button.
 *   
 *  @default 0x000000
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */ 
//[Style(name="symbolColor", type="uint", format="Color", inherit="yes", theme="spark")]

/**
 *  Name of the class to use as the default skin for the background and border. 
 *  For the ComboBase class, there is no default value.
 *  For the ComboBox class, the default value is the ComboBoxArrowSkin class.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="skin", type="Class", inherit="no", states=" up, over, down, disabled,  editableUp, editableOver, editableDown, editableDisabled")]

/**
 *  Name of the class to use as the skin for the background and border
 *  when the mouse is not over the control.
 *  For the ComboBase class, there is no default value.
 *  For the ComboBox class, the default value is the ComboBoxArrowSkin class.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="upSkin", type="Class", inherit="no")]

/**
 *  Name of the class to use as the skin for the background and border
 *  when the mouse is over the control.
 *  For the ComboBase class, there is no default value.
 *  For the ComboBox class, the default value is the ComboBoxArrowSkin class.
 *  For the ColorPicker class, the default value is the ColorPickerSkin class.
 *  For the DateField class, the default value is the ScrollArrowDownSkin class.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="overSkin", type="Class", inherit="no")]

/**
 *  Name of the class to use as the skin for the background and border
 *  when the user holds down the mouse button.
 *  For the ComboBase class, there is no default value.
 *  For the ComboBox class, the default value is the ComboBoxArrowSkin class.
 *  For the ColorPicker class, the default value is the ColorPickerSkin class.
 *  For the DateField class, the default value is the ScrollArrowDownSkin class.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="downSkin", type="Class", inherit="no")]

/**
 *  Name of the class to use as the skin for the background and border
 *  when the control is disabled.
 *  For the ComboBase class, there is no default value.
 *  For the ComboBox class, the default value is the ComboBoxArrowSkin class.
 *  For the ColorPicker class, the default value is the ColorPickerSkin class.
 *  For the DateField class, the default value is the ScrollArrowDownSkin class.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="disabledSkin", type="Class", inherit="no")]

/**
 *  Name of the class to use as the skin for the background and border
 *  when the <code>editable</code>
 *  property is <code>true</code>. This skin is only used by the ComboBox class.
 *  For the ComboBase class, there is no default value.
 *  For the ComboBox class, the default value is the ComboBoxArrowSkin class.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="editableSkin", type="Class", inherit="no")]

/**
 *  Name of the class to use as the skin for the background and border
 *  when the mouse is not over the control, and the <code>editable</code>
 *  property is <code>true</code>. This skin is only used by the ComboBox class.
 *  For the ComboBase class, there is no default value.
 *  For the ComboBox class, the default value is the ComboBoxArrowSkin class.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="editableUpSkin", type="Class", inherit="no")]

/**
 *  Name of the class to use as the skin for the background and border
 *  when the mouse is over the control, and the <code>editable</code>
 *  property is <code>true</code>. This skin is only used by the ComboBox class.
 *  For the ComboBase class, there is no default value.
 *  For the ComboBox class, the default value is the ComboBoxArrowSkin class.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="editableOverSkin", type="Class", inherit="no")]

/**
 *  Name of the class to use as the skin for the background and border
 *  when the user holds down the mouse button, and the <code>editable</code>
 *  property is <code>true</code>. This skin is only used by the ComboBox class.
 *  For the ComboBase class, there is no default value.
 *  For the ComboBox class, the default value is the ComboBoxArrowSkin class.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="editableDownSkin", type="Class", inherit="no")]

/**
 *  Name of the class to use as the skin for the background and border
 *  when the control is disabled, and the <code>editable</code>
 *  property is <code>true</code>. This skin is only used by the ComboBox class.
 *  For the ComboBase class, there is no default value.
 *  For the ComboBox class, the default value is the ComboBoxArrowSkin class.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="editableDisabledSkin", type="Class", inherit="no")]

/**
 *  The class implementing ITextInput that is used by this component
 *  to input text.
 *
 *  <p>It can be set to either the mx.core.TextInput class
 *  (to use the classic Halo TextInput control)
 *  or the mx.controls.MXFTETextInput class
 *  (to use the Spark TextInput component based on the Text Layout Framework 
 *  to get improved text rendering, including bidirectional layout).</p>
 *
 *  @default mx.controls.TextInput
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[Style(name="textInputClass", type="Class", inherit="no")]

/**
 *  The style declaration for the internal TextInput subcomponent 
 *  that displays the current selection. 
 *  If no value is specified, then the TextInput subcomponent uses 
 *  the default text styles defined by the ComboBase class.
 *
 *  @default ""
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="textInputStyleName", type="String", inherit="no")]
//--------------------------------------
//  Other metadata
//--------------------------------------

[AccessibilityClass(implementation="mx.accessibility.ComboBaseAccImpl")]

/**
 *  The ComboBase class is the base class for controls that display text in a 
 *  text field and have a button that causes a drop-down list to appear where 
 *  the user can choose which text to display.
 *  The ComboBase class is not used directly as an MXML tag.
 *
 *  @mxml
 *
 *  <p>The <code>&lt;mx:ComboBase&gt;</code> tag inherits all the tag attributes
 *  of its superclass, and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;<i>mx:tagname</i>
 *    <b>Properties</b>
 *    dataProvider="null"
 *    editable="false|true"
 *    imeMode="null"
 *    restrict="null"
 *    selectedIndex="-1"
 *    selectedItem="null"
 *    text=""
 *    &nbsp;
 *    <b>Styles</b>
 *    disabledSkin="<i>Depends on class</i>"
 *    downSkin="<i>Depends on class</i>"
 *    editableDisabledSkin="<i>Depends on class</i>"
 *    editableDownSkin="<i>Depends on class</i>"
 *    editableOverSkin="<i>Depends on class</i>"
 *    editableUpSkin="<i>Depends on class</i>"
 *    overSkin="<i>Depends on class</i>"
 *    textInputStyleName="" 
 *    upSkin="<i>Depends on class</i>"
 *
 *  /&gt;
 *  </pre>
 *
 *  @see mx.controls.Button
 *  @see mx.controls.TextInput
 *  @see mx.collections.ICollectionView
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class ComboBase extends UIComponent implements /*IIMESupport,*/ IFocusManagerComponent
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
    public function ComboBase()
    {
        super();

        COMPILE::SWF
        {
        tabEnabled = true;
        tabFocusEnabled = true;
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------


    /**
     *  @private
     *  The internal Button property that causes the drop-down list to appear.
     *  @royalesuppresspublicvarwarning
     */
    mx_internal var downArrowButton:Button;

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
     *  Storage for enabled property.
     */
    private var _disableBead:DisableBead;
    private var _enabled:Boolean = false;
    
    private var _contentBackgroundColor:uint = 0xFFFFFF;

    /**
     *  @private
     */
    public function get contentBackgroundColor():uint{
	
        return _contentBackgroundColor;
    }
    
    public function set contentBackgroundColor(value:uint):void
    {
       _contentBackgroundColor = value;
    }
    
    /**
     *  @private
     */
    private var enabledChanged:Boolean = false;

    [Inspectable(category="General", enumeration="true,false", defaultValue="true")]

    /**
     *  @private
     */
    override public function get enabled():Boolean
    {
        return _enabled;
    }
    
    override public function set enabled(value:Boolean):void
    {
        _enabled = value;
	if (_disableBead == null) {
		_disableBead = new DisableBead();
		addBead(_disableBead);
	}

	_disableBead.disabled = !value;

	dispatchEvent(new org.apache.royale.events.Event("enabledChanged"));
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  value
    //----------------------------------
	
    public function get value():Object
	{
      return null;	
	}

    //----------------------------------
    //  dataProvider
    //----------------------------------

    [Bindable("collectionChange")]
    [Inspectable(category="Data")]

    /**
     *  The set of items this component displays. This property is of type
     *  Object because the derived classes can handle a variety of data
     *  types such as Arrays, XML, ICollectionViews, and other classes.  All
     *  are converted into an ICollectionView and that ICollectionView is
     *  returned if you get the value of this property; you will not get the
     *  value you set if it was not an ICollectionView.
     *
     *  <p>Setting this property will adjust the <code>selectedIndex</code>
     *  property (and therefore the <code>selectedItem</code> property) if 
     *  the <code>selectedIndex</code> property has not otherwise been set. 
     *  If there is no <code>prompt</code> property, the <code>selectedIndex</code>
     *  property will be set to 0; otherwise it will remain at -1,
     *  the index used for the prompt string.  
     *  If the <code>selectedIndex</code> property has been set and
     *  it is out of range of the new data provider, unexpected behavior is
     *  likely to occur.</p>
     * 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get dataProvider():Object
    {
        return IComboBoxModel(model).dataProvider;
    }

    /**
     *  @private
     */
    public function set dataProvider(value:Object):void
    {
        if (value is Array)
        {
            value = new ArrayCollection(value as Array);
        }
        else if (value is ICollectionView)
        {
            value = ICollectionView(value);
        }
        else if (value is IList)
        {
            value = new ListCollectionView(IList(value));
        }
        else if (value is XMLList)
        {
            value = new XMLListCollection(value as XMLList);
        }
        else if (value is XML)
        {
            var xl:XMLList = new XMLList();
            xl += value;
            value = new XMLListCollection(xl);
        }
        else
        {
            // convert it to an array containing this one item
            var tmp:Array = [];
            if (value != null)
                tmp.push(value);
            value = new ArrayCollection(tmp);
        }
        IComboBoxModel(model).dataProvider = value;
        if (value && IComboBoxModel(model).selectedIndex == -1)
            IComboBoxModel(model).selectedIndex = 0;
    }

    //----------------------------------
    //  editable
    //----------------------------------

    [Bindable("editableChanged")]
    [Inspectable(category="General", defaultValue="false")]

    /**
     *  A flag that indicates whether the control is editable, 
     *  which lets the user directly type entries that are not specified 
     *  in the dataProvider, or not editable, which requires the user select
     *  from the items in the dataProvider.
     *
     *  <p>If <code>true</code> keyboard input will be entered in the
     *  editable text field; otherwise it will be used as shortcuts to
     *  select items in the dataProvider.</p>
     *
     *  @default false.
     *  This property is ignored by the DateField control.
     *
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get editable():Boolean
    {
        trace("ComboBox.editable not implemented");
        return true;
    }

    /**
     *  @private
     */
    public function set editable(value:Boolean):void
    {
        trace("ComboBox.editable not implemented");
    }


    //----------------------------------
    //  imeMode
    //----------------------------------

    /**
     *  @copy mx.controls.TextInput#imeMode
     * 
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     **/
    public function get imeMode():String
    {
        trace("ComboBox.imeMode not implemented");
        return "";
    }

    /**
     *  @private
     */
    public function set imeMode(value:String):void
    {
        trace("ComboBox.imeMode not implemented");
    }

    //----------------------------------
    //  restrict
    //----------------------------------

    /**
     *  Set of characters that a user can or cannot enter into the text field.
     * 
     *  @default null
     *
     *  @see flash.text.TextField#restrict
     *
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get restrict():String
    {
        trace("ComboBox.restrict not implemented");
        return "";
    }

    /**
     *  @private
     */
    public function set restrict(value:String):void
    {
        trace("ComboBox.restrict not implemented");
    }

    //----------------------------------
    //  selectedIndex
    //----------------------------------

    [Bindable("change")]
    [Bindable("valueCommit")]
    [Inspectable(category="General", defaultValue="-1")]

    /**
     *  The index in the data provider of the selected item.
     *  If there is a <code>prompt</code> property, the <code>selectedIndex</code>
     *  value can be set to -1 to show the prompt.
     *  If there is no <code>prompt</code>, property then <code>selectedIndex</code>
     *  will be set to 0 once a <code>dataProvider</code> is set.
     *
     *  <p>If the ComboBox control is editable, the <code>selectedIndex</code>
     *  property is -1 if the user types any text
     *  into the text field.</p>
     *
     *  <p>Unlike many other Flex properties that are invalidating (setting
     *  them does not have an immediate effect), the <code>selectedIndex</code> and
     *  <code>selectedItem</code> properties are synchronous; setting one immediately 
     *  affects the other.</p>
     *
     *  @default -1
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get selectedIndex():int
    {
        return IComboBoxModel(model).selectedIndex;
    }

    /**
     *  @private
     */
    public function set selectedIndex(value:int):void
    {
        IComboBoxModel(model).selectedIndex = value;

    }


    //----------------------------------
    //  selectedItem
    //----------------------------------

    [Bindable("change")]
    [Bindable("valueCommit")]
    [Inspectable(category="General", defaultValue="null")]

    /**
     *  The item in the data provider at the selectedIndex.
     *
     *  <p>If the data is an object or class instance, modifying
     *  properties in the object or instance modifies the 
     *  <code>dataProvider</code> object but may not update the views  
     *  unless the instance is Bindable or implements IPropertyChangeNotifier
     *  or a call to dataProvider.itemUpdated() occurs.</p>
     *
     *  Setting the <code>selectedItem</code> property causes the
     *  ComboBox control to select that item (display it in the text field and
     *  set the <code>selectedIndex</code>) if it exists in the data provider.
     *  If the ComboBox control is editable, the <code>selectedItem</code>
     *  property is <code>null</code> if the user types any text
     *  into the text field.
     *
     *  <p>Unlike many other Flex properties that are invalidating (setting
     *  them does not have an immediate effect), <code>selectedIndex</code> and
     *  <code>selectedItem</code> are synchronous; setting one immediately 
     *  affects the other.</p>
     *
     *  @default null;
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get selectedItem():Object
    {
        return IComboBoxModel(model).selectedItem;
    }

    /**
     *  @private
     */
    public function set selectedItem(value:Object):void
    {
        IComboBoxModel(model).selectedItem = value;
    }

    //----------------------------------
    //  text
    //----------------------------------
    
    [Bindable("collectionChange")]
    [Bindable("valueCommit")]
    [Inspectable(category="General", defaultValue="")]
    [NonCommittingChangeEvent("change")]
    
    /**
     *  Contents of the text field.  If the control is non-editable
     *  setting this property has no effect. If the control is editable, 
     *  setting this property sets the contents of the text field.
     *
     *  @default ""
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get text():String
    {
        return ((view as IComboBoxView).textInputField as org.apache.royale.html.TextInput).text;
    }
    
    /**
     *  @private
     */
    public function set text(value:String):void
    {
        ((view as IComboBoxView).textInputField as org.apache.royale.html.TextInput).text = value;
    }
    
    //----------------------------------
    //  textInput
    //----------------------------------

    /**
     *  The internal TextInput subcomponent that displays
     *  the current selection.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function get textInput():Object
    {
        return (view as IComboBoxView).textInputField;
    }

    protected function set textInput(value:Object):void
    {
       
    }

    //----------------------------------
    //  textInputStyleFilters
    //----------------------------------

    /**
     *  The set of styles to pass from the ComboBase to the text input. 
     *  These styles are ignored if you set 
     *  the <code>textInputStyleName</code> style property.
     *  @see mx.styles.StyleProxy
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function get textInputStyleFilters():Object 
    {
        return _textInputStyleFilters;
    }
    
    override public function addedToParent():void
    {
        super.addedToParent();
        textInput.addEventListener(Event.CHANGE, textInput_changeHandler);
    }

    protected function textInput_changeHandler(event:Event):void
    {
        // override this
    }

    
    private static var _textInputStyleFilters:Object =
    {
        "backgroundAlpha" : "backgroundAlpha",
        "backgroundColor" : "backgroundColor",
        "backgroundImage" : "backgroundImage",
        "backgroundDisabledColor" : "backgroundDisabledColor",
        "backgroundSize" : "backgroundSize",
        "borderAlpha" : "borderAlpha", 
        "borderColor" : "borderColor",
        "borderSides" : "borderSides", 
        "borderStyle" : "borderStyle",
        "borderThickness" : "borderThickness",
        "dropShadowColor" : "dropShadowColor",
        "dropShadowEnabled" : "dropShadowEnabled",
        "embedFonts" : "embedFonts",
        "focusAlpha" : "focusAlpha",
        "focusBlendMode" : "focusBlendMode",
        "focusRoundedCorners" : "focusRoundedCorners", 
        "focusThickness" : "focusThickness",
        "leading" : "leading",
        "paddingLeft" : "paddingLeft", 
        "paddingRight" : "paddingRight",
        "shadowDirection" : "shadowDirection",
        "shadowDistance" : "shadowDistance",
        "textDecoration" : "textDecoration"
     };


    /**
     *  @private
     */
    override public function setFocus():void
    {
        if (textInput && editable)
        {
            COMPILE::SWF
            {
                stage.focus = textInput as InteractiveObject;
            }
            COMPILE::JS
            {
                (textInput as IUIBase).element.focus();
            }
        }
        else
            super.setFocus();
    }

}

}
