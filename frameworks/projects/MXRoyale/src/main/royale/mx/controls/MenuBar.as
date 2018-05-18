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
import org.apache.royale.events.Event;
import mx.collections.ArrayCollection;
import mx.collections.ICollectionView;
import mx.collections.IViewCursor;
import mx.collections.XMLListCollection;
import mx.core.ClassFactory;
import mx.core.EventPriority;
import mx.core.IFactory;
import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.events.FlexEvent;
import mx.styles.ISimpleStyleClient;
import mx.styles.StyleProxy;

/*
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.ui.Keyboard;
import flash.xml.XMLNode;

import mx.collections.ArrayCollection;
import mx.collections.ICollectionView;
import mx.collections.IViewCursor;
import mx.collections.XMLListCollection;
import mx.collections.errors.ItemPendingError;
import mx.containers.ApplicationControlBar;
import mx.controls.menuClasses.IMenuBarItemRenderer;
import mx.controls.menuClasses.IMenuDataDescriptor;
import mx.controls.menuClasses.MenuBarItem;
import mx.controls.treeClasses.DefaultDataDescriptor;
import mx.core.ClassFactory;
import mx.core.EventPriority;
import mx.core.IFactory;
import mx.core.IFlexDisplayObject;
import mx.core.IUIComponent;
import mx.core.LayoutDirection;
import mx.core.UIComponent;
import mx.core.UIComponentGlobals;
import mx.core.mx_internal;
import mx.events.CollectionEvent;
import mx.events.CollectionEventKind;
import mx.events.FlexEvent;
import mx.events.InterManagerRequest;
import mx.events.MenuEvent;
import mx.managers.IFocusManagerComponent;
import mx.managers.ISystemManager;
import mx.managers.PopUpManager;
import mx.styles.CSSStyleDeclaration;
import mx.styles.ISimpleStyleClient;
import mx.styles.StyleProxy;

use namespace mx_internal;
*/
//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched when selection changes as a result of user 
 *  interaction.  
 *  This event is also dispatched when the user changes 
 *  the current menu selection in a pop-up submenu. 
 *  When the event occurs on the menu bar, 
 *  the <code>menu</code> property of the MenuEvent object is <code>null</code>.
 *  When it occurs in a pop-up submenu, the <code>menu</code> property 
 *  contains a reference to the Menu object that represents the 
 *  the pop-up submenu.
 *
 *  @eventType mx.events.MenuEvent.CHANGE 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
//[Event(name="change", type="mx.events.MenuEvent")]

/**
 *  Dispatched when the user selects an item in a pop-up submenu.
 *
 *  @eventType mx.events.MenuEvent.ITEM_CLICK 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
[Event(name="itemClick", type="mx.events.MenuEvent")]

/**
 *  Dispatched when a pop-up submenu closes.
 *
 *  @eventType mx.events.MenuEvent.MENU_HIDE 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
//[Event(name="menuHide", type="mx.events.MenuEvent")]

/**
 *  Dispatched when a pop-up submenu opens, or the 
 *  user selects a menu bar item with no drop-down menu.
 *
 *  @eventType mx.events.MenuEvent.MENU_SHOW 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
[Event(name="menuShow", type="mx.events.MenuEvent")]

/**
 *  Dispatched when the mouse pointer rolls out of a menu item.
 *
 *  @eventType mx.events.MenuEvent.ITEM_ROLL_OUT
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
//[Event(name="itemRollOut", type="mx.events.MenuEvent")]

/**
 *  Dispatched when the mouse pointer rolls over a menu item.
 *
 *  @eventType mx.events.MenuEvent.ITEM_ROLL_OVER
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
//[Event(name="itemRollOver", type="mx.events.MenuEvent")]

//--------------------------------------
//  Styles
//--------------------------------------

//include "../styles/metadata/FocusStyles.as"
//include "../styles/metadata/LeadingStyle.as"
//include "../styles/metadata/SkinStyles.as"
//include "../styles/metadata/TextStyles.as"

/**
 *  The background skin of the MenuBar control. 
 *   
 *  <p>The default skin class is based on the theme. For example, with the Halo theme,
 *  the default skin class is <code>mx.skins.halo.MenuBarBackgroundSkin</code>. For the Spark theme, the default skin
 *  class is <code>mx.skins.spark.ButtonSkin</code>.</p>
 * 
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
//[Style(name="backgroundSkin", type="Class", inherit="no")]

/**
 *  The default skin for a MenuBar item.
 * 
 *  <p>The default skin class is based on the theme. For example, with the Halo theme,
 *  the default skin class is <code>mx.skins.halo.ActivatorSkin</code>. For the Spark theme, the default skin
 *  class is <code>mx.skins.spark.MenuItemSkin</code>.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
//[Style(name="itemSkin", type="Class", inherit="no", states="up, over, down")]

/**
 *  The skin when a MenuBar item is not selected.
 * 
 *  <p>The default skin class is based on the theme. For example, with the Halo theme,
 *  the default skin class is <code>mx.skins.halo.ActivatorSkin</code>. For the Spark theme, the default skin
 *  class is <code>mx.skins.spark.MenuItemSkin</code>.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
//[Style(name="itemUpSkin", type="Class", inherit="no")]

/**
 *  The skin when focus is over a MenuBar item. 
 * 
 *  <p>The default skin class is based on the theme. For example, with the Halo theme,
 *  the default skin class is <code>mx.skins.halo.ActivatorSkin</code>. For the Spark theme, the default skin
 *  class is <code>mx.skins.spark.MenuItemSkin</code>.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
//[Style(name="itemOverSkin", type="Class", inherit="no")]

/**
 *  The skin when a MenuBar item is selected. 
 * 
 *  <p>The default skin class is based on the theme. For example, with the Halo theme,
 *  the default skin class is <code>mx.skins.halo.ActivatorSkin</code>. For the Spark theme, the default skin
 *  class is <code>mx.skins.spark.MenuItemSkin</code>.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
//[Style(name="itemDownSkin", type="Class", inherit="no")]

/**
 *  Name of the CSSStyleDeclaration that specifies the styles for
 *  the Menu controls displayed by this MenuBar control. 
 *  By default, the Menu controls use the MenuBar control's
 *  inheritable styles. 
 *  
 *  <p>You can use this class selector to set the values of all the style properties 
 *  of the Menu class, including <code>backgroundAlpha</code> and <code>backgroundColor</code>.</p>
 * 
 *  @default undefined
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
//[Style(name="menuStyleName", type="String", inherit="no")]


/**
 *  @copy mx.controls.Menu#style:rollOverColor
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
//[Style(name="rollOverColor", type="uint", format="Color", inherit="yes")]

/**
 *  @copy mx.controls.Menu#style:selectionColor
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
//[Style(name="selectionColor", type="uint", format="Color", inherit="yes")]

/**
 *  Color of any symbol of a component. Examples include the check mark of a CheckBox or
 *  the arrow of a ScrollBar button.
 *   
 *  @default 0x000000
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.3
 */ 
//[Style(name="symbolColor", type="uint", format="Color", inherit="yes", theme="spark")]

//--------------------------------------
//  Other metadata
//--------------------------------------

//[AccessibilityClass(implementation="mx.accessibility.MenuBarAccImpl")]

[DefaultBindingProperty(destination="dataProvider")]

[DefaultProperty("dataProvider")]

//[DefaultTriggerEvent("change")]

//[IconFile("MenuBar.png")]

[RequiresDataBinding(true)]

/**
 *  A MenuBar control defines a horizontal, top-level menu bar that contains
 *  one or more menus. Clicking on a top-level menu item opens a pop-up submenu
 *  that is an instance of the Menu control.
 *
 *  <p>The top-level menu bar of the MenuBar control is generally always visible. 
 *  It is not intended for use as a pop-up menu. The individual submenus
 *  pop up as the user selects them with the mouse or keyboard. Open submenus 
 *  disappear when a menu item is selected, or if the menu is dismissed by the
 *  user clicking outside the menu.</p>
 *
 *  <p>For information and an example on the attributes that you can use 
 *  in the data provider for the MenuBar control, see the Menu control.</p>
 *
 *  <p>The MenuBar control has the following sizing characteristics:
 *  </p>
 *     <table class="innertable">
 *        <tr>
 *           <th>Characteristic</th>
 *           <th>Description</th>
 *        </tr>
 *        <tr>
 *           <td>Default size</td>
 *           <td>The width is determined from the menu text, with a 
 *               minimum value of 27 pixels for the width. The default 
 *               value for the height is 22 pixels.</td>
 *        </tr>
 *     </table>
 *
 *  @mxml
 *  <p>
 *  The <code>&lt;mx:MenuBar&gt</code> tag inherits all of the tag attributes of its superclass, and
 *  adds the following tag attributes:
 *  </p>
 *  
 *  <pre>
 *  &lt;mx:MenuBar
 *    <b>Properties</b>
 *    dataDescriptor="<i>mx.controls.treeClasses.DefaultDataDescriptor</i>"
 *    dataProvider="<i>undefined</i>"
 *    iconField="icon"
 *    labelField="label"
 *    labelFunction="<i>undefined</i>"
 *    menuBarItemRenderer="<i>mx.controls.menuClasses.MenuBarItem</i>"
 *    menuBarItems="[]"
 *    menus="[]"
 *    selectedIndex="-1"
 *    showRoot="true"
 *  
 *    <b>Styles</b>
 *    backgroundSkin="mx.skins.halo.MenuBarBackgroundSkin"
 *    borderColor="0xAAB3B3"
 *    color="0x0B333C"
 *    cornerRadius="0"
 *    disabledColor="0xAAB3B3"
 *    fillAlphas="[0.6,0.4]"
 *    fillColors="[0xFFFFFF, 0xCCCCCC]"
 *    focusAlpha="0.5"
 *    focusRoundedCorners="tl tr bl br"
 *    fontAntiAliasType="advanced|normal"
 *    fontFamily="Verdana"
 *    fontGridFitType="pixel|none|subpixel"
 *    fontSharpness="0"
 *    fontSize="10"
 *    fontStyle="normal|italic"
 *    fontThickness="0"
 *    fontWeight="normal|bold"
 *    highlightAlphas="[0.3,0.0]"
 *    itemDownSkin="mx.skins.halo.ActivatorSkin"
 *    itemOverSkin="mx.skins.halo.ActivatorSkin"
 *    itemUpSkin="mx.skins.halo.ActivatorSkin"
 *    leading="2"
 *    menuStyleName="<i>No default</i>"
 *    rollOverColor="0xB2E1FF"
 *    selectionColor="0x7FCEFF"
 *    textAlign="left"
 *    textDecoration="none"
 *    textIndent="0"
 *  
 *    <b>Events</b>
 *    itemClick="<i>No default"</i>
 *    itemRollOut="<i>No default"</i>
 *    itemRollOver="<i>No default"</i>
 *    menuHide="<i>No default"</i>
 *    menuShow="<i>No default"</i>
 *  /&gt;
 *  </pre>
 *  </p>
 *
 *  @see mx.controls.Menu
 *  @see mx.controls.PopUpMenuButton
 *  @see mx.controls.menuClasses.IMenuBarItemRenderer
 *  @see mx.controls.menuClasses.MenuBarItem
 *  @see mx.controls.menuClasses.IMenuDataDescriptor
 *  @see mx.controls.treeClasses.DefaultDataDescriptor
 *
 *  @includeExample examples/MenuBarExample.mxml
 *
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
public class MenuBar extends UIComponent 
	// implements IFocusManagerComponent
{
	//   include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    //private static const MARGIN_WIDTH:int = 10;

    //--------------------------------------------------------------------------
    //
    //  Class mixins
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Placeholder for mixin by MenuBarAccImpl.
     */
//    mx_internal static var createAccessibilityImplementation:Function;

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
     *  @productversion Royale 0.9.3
     */
    public function MenuBar()
    {
        super();
 //       menuBarItemRenderer = new ClassFactory(MenuBarItem);
//        tabChildren = false;
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Storage variable for the original dataProvider
     */
//    mx_internal var _rootModel:ICollectionView;

    /**
     *  @private
     */
    //private var isDown:Boolean;

    /**
     *  @private
     */
    //private var inKeyDown:Boolean = false;

    /**
     *  @private
     */
//    private var background:IFlexDisplayObject;

    /**
     *  @private
     *  This menu bar could be inside an ApplicationControlBar (ACB).
     */
    //private var isInsideACB:Boolean = false;

    /**
     *  @private
     */
    //private var supposedToLoseFocus:Boolean = false;

    /**
     *  @private
     */
    //private var dataProviderChanged:Boolean = false;
    
    /**
     *  @private
     */
    //private var iconFieldChanged:Boolean = false;
    
        /**
     *  @private
     */
    //private var menuBarItemRendererChanged:Boolean = false;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  dataProvider
    //----------------------------------

    [Bindable("collectionChange")]
    [Inspectable(category="Data")]

    /**
     *  The hierarchy of objects that are displayed as MenuBar items and menus. 
     *  The top-level children all become MenuBar items, and their children 
     *  become the items in the menus and submenus. 
     * 
     *  The MenuBar control handles the source data object as follows:
     *  <p>
     *  <ul>
     *  <li>A String containing valid XML text is converted to an XML object.</li>
     *  <li>An XMLNode is converted to an XML object.</li>
     *  <li>An XMLList is converted to an XMLListCollection.</li>
     *  <li>Any object that implements the ICollectionView interface is cast to
     *  an ICollectionView.</li>
     *  <li>An Array is converted to an ArrayCollection.</li>
     *  <li>Any other type object is wrapped in an Array with the object as its sole
     *  entry.</li>
     *  </ul>
     *  </p>
     * 
     *  @default "undefined"
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function get dataProvider():Object
    {
    //    if (_rootModel)
    //   {   
    //        return _rootModel;
    //    }
    //   else return null;
	return null;
    }

    /**
     *  @private
     */
    public function set dataProvider(value:Object):void
    {
    /*    if (_rootModel)
        {
            _rootModel.removeEventListener(CollectionEvent.COLLECTION_CHANGE, 
                                           collectionChangeHandler);
        }
                            
        // handle strings and xml
        if (typeof(value)=="string")
            value = new XML(value);
        else if (value is XMLNode)
            value = new XML(XMLNode(value).toString());
        else if (value is XMLList)
            value = new XMLListCollection(value as XMLList);
        
        if (value is XML)
        {
            _hasRoot = true;
            var xl:XMLList = new XMLList();
            xl += value;
            _rootModel = new XMLListCollection(xl);
        }
        //if already a collection dont make new one
        if (value is ICollectionView)
        {
            _rootModel = ICollectionView(value);
            if (_rootModel.length == 1)
                _hasRoot = true;
        }
        else if (value is Array)
        {
    /       _rootModel = new ArrayCollection(value as Array);
        }
        //all other types get wrapped in an ArrayCollection
        else if (value is Object)
        {
            _hasRoot = true;
            // convert to an array containing this one item
            var tmp:Array = [];
            tmp.push(value);
            _rootModel = new ArrayCollection(tmp);
        }
        else
        {
            _rootModel = new ArrayCollection();
        }
        //add listeners as weak references
        _rootModel.addEventListener(CollectionEvent.COLLECTION_CHANGE,
                                    collectionChangeHandler, false, 0, true);
        //flag for processing in commitProps
        dataProviderChanged = true;
        invalidateProperties();
        
        var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
        event.kind = CollectionEventKind.RESET;
        collectionChangeHandler(event);
        dispatchEvent(event);*/
    }

    //----------------------------------
    //  iconField
    //----------------------------------

    /**
     *  @private
     *  Storage for iconField property.
     */
    private var _iconField:String = "icon";

    //[Bindable("iconFieldChanged")]
    [Inspectable(category="Other", defaultValue="icon")]

    /**
     *  The name of the field in the data provider that determines the 
     *  icon to display for each menu item. By default, the MenuBar does not 
     *  try to display icons along with the text in a menu item. By specifying 
     *  an icon field, you can define a graphic that is created 
     *  and displayed as an icon for a menu item. 
     *
     *  <p>The MenuItemRenderer examines 
     *  the data provider for a property of the name defined 
     *  by the <code>iconField</code> property.  If the value of the property is a Class, it 
     *  instantiates that class and expects it to be an instance of 
     *  IFlexDisplayObject. If the value of the property is a String, it 
     *  looks to see if a Class exists with that name in the application, and if 
     *  it cannot find one, it looks for a property on the document 
     *  with that name and expects that property to map to a Class.</p>
     *
     *  @default "icon"
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function get iconField():String
    {
        return _iconField;
    }

    /**
     *  @private
     */
    public function set iconField(value:String):void
    {
        if (_iconField != value)
        {
            //iconFieldChanged = true;
            _iconField = value;
            invalidateProperties();
            //dispatchEvent(new Event("iconFieldChanged"));
        }
    }

    //----------------------------------
    //  labelField
    //----------------------------------

    /**
     *  @private
     */
    private var _labelField:String = "label";

    //[Bindable("labelFieldChanged")]
    [Inspectable(category="Data", defaultValue="label")]

    /**
     *  The name of the field in the data provider that determines the 
     *  text to display for each menu item. If the data provider is an Array of 
     *  Strings, Flex uses each string value as the label. If the data 
     *  provider is an E4X XML object, you must set this property explicitly. 
     *  For example, use @label to specify the label attribute in an E4X XML Object 
     *  as the text to display for each menu item. 
     * 
     *  Setting the <code>labelFunction</code> property overrides this property.
     *
     *  @default "label"
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function get labelField():String
    {
        return _labelField;
    }

    /**
     *  @private
     */
    public function set labelField(value:String):void
    {
        if (_labelField != value)
        {
            _labelField = value;
            //dispatchEvent(new Event("labelFieldChanged"));
        }
    }

}

}
