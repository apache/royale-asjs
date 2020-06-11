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
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.geom.Rectangle;
	import org.apache.royale.geom.Point;
	import org.apache.royale.core.IListPresentationModel;
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.core.IFactory;
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IBeadLayout;
	import org.apache.royale.core.ILayoutHost;
	import org.apache.royale.core.IMenu;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.IDataProviderItemRendererMapper;
	import org.apache.royale.core.IItemRendererClassFactory;
	import org.apache.royale.core.IItemRendererProvider;
	import org.apache.royale.html.beads.models.CascadingMenuModel;
	import org.apache.royale.html.beads.models.MenuModel;
	import org.apache.royale.utils.loadBeadFromValuesManager;
	
	import mx.core.UIComponent;
	import mx.events.MouseEvent;
	
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
	import flash.utils.clearInterval;
	import flash.utils.setTimeout;
	import flash.xml.XMLNode;
	*/
	
	import mx.collections.ArrayCollection;
	import mx.collections.CursorBookmark;
	import mx.collections.ICollectionView;
	import mx.collections.XMLListCollection;
	import mx.controls.listClasses.BaseListData;
	import mx.controls.listClasses.IListItemRenderer;
    import mx.controls.listClasses.ListItemRenderer;
	// import mx.controls.menuClasses.IMenuBarItemRenderer;
	// import mx.controls.menuClasses.IMenuDataDescriptor;
	// import mx.controls.menuClasses.IMenuItemRenderer;
	// import mx.controls.menuClasses.MenuItemRenderer;
	// import mx.controls.menuClasses.MenuListData;
	import mx.controls.treeClasses.DefaultDataDescriptor;
	import mx.core.ClassFactory;
	import mx.core.EdgeMetrics;
	import mx.core.EventPriority;
	import mx.core.FlexGlobals;
	import mx.core.IFlexDisplayObject;
	import mx.core.LayoutDirection;
	import mx.core.ScrollPolicy;
	import mx.core.UIComponent;
	import mx.core.UIComponentGlobals;
	import mx.core.mx_internal;
	import mx.effects.Tween;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.FlexEvent;
	// import mx.events.FlexMouseEvent;
	// import mx.events.InterManagerRequest;
	import mx.events.ListEvent;
	import mx.events.MenuEvent;
	import mx.events.SandboxMouseEvent;
	import mx.managers.IActiveWindowManager;
	import mx.managers.IFocusManagerContainer;
	import mx.managers.ISystemManager;
	import mx.managers.PopUpManager;
	
	use namespace mx_internal;
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 *  Dispatched when selection changes as a result
	 *  of user interaction. 
	 *
	 *  @eventType mx.events.MenuEvent.CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Event(name="change", type="mx.events.MenuEvent")]
	
	/**
	 *  Dispatched when a menu item is selected. 
	 *
	 *  @eventType mx.events.MenuEvent.ITEM_CLICK
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Event(name="itemClick", type="mx.events.MenuEvent")]
	
	/**
	 *  Dispatched when a menu or submenu is dismissed.
	 *
	 *  @eventType mx.events.MenuEvent.MENU_HIDE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Event(name="menuHide", type="mx.events.MenuEvent")]
	
	/**
	 *  Dispatched when a menu or submenu opens. 
	 *
	 *  @eventType mx.events.MenuEvent.MENU_SHOW
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Event(name="menuShow", type="mx.events.MenuEvent")]
	
	/**
	 *  Dispatched when a user rolls the mouse out of a menu item.
	 *
	 *  @eventType mx.events.MenuEvent.ITEM_ROLL_OUT
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Event(name="itemRollOut", type="mx.events.MenuEvent")]
	
	/**
	 *  Dispatched when a user rolls the mouse over a menu item.
	 *
	 *  @eventType mx.events.MenuEvent.ITEM_ROLL_OVER
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Event(name="itemRollOver", type="mx.events.MenuEvent")]
	
	//--------------------------------------
	//  Styles
	//--------------------------------------
	
	/**
	 *  The colors used for menu or submenu menu items in an alternating pattern. 
	 *  The value can be an Array of one or more colors.
	 *  This style is only used if <code>backgroundColor</code> is not specified. 
	 * 
	 *  @default "undefined"
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Style(name="alternatingItemColors", type="Array", arrayType="uint", format="Color", inherit="yes")]
	
	/**
	 *  Number of pixels between children (icons and label) in the horizontal direction.
	 * 
	 *  @default 6
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Style(name="horizontalGap", type="Number", format="Length", inherit="no")]
	
	/**
	 *  The gap to the left of the label in a menu item.  If the icons (custom 
	 *  icon and type icon) do not fit in this gap, the gap is expanded to 
	 *  fit them properly.
	 *  The default value is 18.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Style(name="leftIconGap", type="Number", format="Length", inherit="no")]
	
	/**
	 *  The gap to the right of the label in a menu item.  If the branch icon 
	 *  does not fit in this gap, the gap is expanded to fit it properly.
	 *  The default value is 15.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Style(name="rightIconGap", type="Number", format="Length", inherit="no")]
	
	/**
	 *  The duration of the menu or submenu opening transition, in milliseconds.
	 *  The value 0 specifies no transition.
	 *  
	 *  The default value for the Halo theme is 250.
	 *  The default value for the Spark theme is 0.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Style(name="openDuration", type="Number", format="Time", inherit="no")]
	
	/**
	 *  The color of the menu item background when a user rolls the mouse over it. 
	 *  
	 *  The default value for the Halo theme is <code>0xB2E1FF</code>.
	 *  The default value for the Spark theme is <code>0xCEDBEF</code>.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Style(name="rollOverColor", type="uint", format="Color", inherit="yes")]
	
	/**
	 *  The color of the menu item background when a menu item is selected.
	 *  
	 *  The default value for the Halo theme is <code>0x7FCEFF</code>.
	 *  The default value for the Spark theme is <code>0xA8C6EE</code>.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Style(name="selectionColor", type="uint", format="Color", inherit="yes")]
	
	/**
	 *  The reference to an <code>easingFunction</code> equation which is used to 
	 *  control programmatic tweening.
	 * 
	 *  @default "undefined"
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Style(name="selectionEasingFunction", type="Function", inherit="no")]
	
	/**
	 *  The offset of the first line of text from the left side of the menu or 
	 *  submenu menu item. 
	 * 
	 *  @default 0
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Style(name="textIndent", type="Number", format="Length", inherit="yes")]
	
	/**
	 *  The color of the menu item text when a user rolls the mouse over the 
	 *  menu item.
	 * 
	 *  The default value for the Halo theme is <code>0x2B333C</code>.
	 *  The default value for the Spark theme is <code>0x000000</code>.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Style(name="textRollOverColor", type="uint", format="Color", inherit="yes")]
	
	/**
	 *  The color of the menu item text when the menu item is selected.
	 * 
	 *  The default value for the Halo theme is <code>0x2B333C</code>.
	 *  The default value for the Spark theme is <code>0x000000</code>.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Style(name="textSelectedColor", type="uint", format="Color", inherit="yes")]
	
	/**
	 *  The icon for all enabled menu items that have submenus. 
	 * 
	 *  The default value for the Halo theme is the "MenuBranchEnabled" symbol
	 *  in the Assets.swf file.
	 *  The default value for the Spark theme is <code>mx.skins.spark.MenuArrow</code>.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Style(name="branchIcon", type="Class", inherit="no")]
	
	/**
	 *  The icon for all disabled menu items that have submenus. 
	 * 
	 *  The default value for the Halo theme is the "MenuBranchDisabled" symbol
	 *  in the Assets.swf file.
	 *  The default value for the Spark theme is <code>mx.skins.spark.MenuArrowDisabled</code>.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Style(name="branchDisabledIcon", type="Class", inherit="no")]
	
	/**
	 *  The icon for all enabled menu items whose type identifier is a check box. 
	 *  
	 *  The default value for the Halo theme is the "MenuCheckEnabled" symbol
	 *  in the Assets.swf file.
	 *  The default value for the Spark theme is <code>mx.skins.spark.MenuCheck</code>.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Style(name="checkIcon", type="Class", inherit="no")]
	
	/**
	 *  The icon for all dsiabled menu items whose type identifier is a check box. 
	 *  
	 *  The default value for the Halo theme is the "MenuCheckDisabled" symbol
	 *  in the Assets.swf file.
	 *  The default value for the Spark theme is <code>mx.skins.spark.MenuCheckDisabled</code>.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Style(name="checkDisabledIcon", type="Class", inherit="no")]
	
	/**
	 *  The icon for all enabled menu items whose type identifier is a radio 
	 *  button. 
	 *  
	 *  The default value for the Halo theme is the "MenuRadioEnabled" symbol
	 *  in the Assets.swf file.
	 *  The default value for the Spark theme is <code>mx.skins.spark.MenuRadio</code>.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Style(name="radioIcon", type="Class", inherit="no")]
	
	/**
	 *  The icon for all disabled menu items whose type identifier is a radio 
	 *  button. 
	 * 
	 *  The default value for the Halo theme is the "MenuRadioDisabled" symbol
	 *  in the Assets.swf file.
	 *  The default value for the Spark theme is <code>mx.skins.spark.MenuRadioDisabled</code>.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Style(name="radioDisabledIcon", type="Class", inherit="no")]
	
	/**
	 *  The skin for all menu items which are identified as separators. 
	 *  
	 *  The default value for the Halo theme is the "MenuSeparator" symbol
	 *  in the Assets.swf file.
	 *  The default value for the Spark theme is <code>mx.skins.spark.MenuSeparatorSkin</code>.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Style(name="separatorSkin", type="Class", inherit="no")]
	
	//--------------------------------------
	//  Excluded APIs
	//--------------------------------------
	
	[Exclude(name="allowMultipleSelection", kind="property")]
	[Exclude(name="horizontalScrollBarStyleName", kind="property")]
	[Exclude(name="horizontalScrollPolicy", kind="property")]
	[Exclude(name="horizontalScrollPosition", kind="property")]
	[Exclude(name="liveScrolling", kind="property")]
	[Exclude(name="maxHorizontalScrollPosition", kind="property")]
	[Exclude(name="maxVerticalScrollPosition", kind="property")]
	[Exclude(name="scrollTipFunction", kind="property")]
	[Exclude(name="showScrollTips", kind="property")]
	[Exclude(name="verticalScrollBarStyleName", kind="property")]
	[Exclude(name="verticalScrollPolicy", kind="property")]
	[Exclude(name="verticalScrollPosition", kind="property")]
	
	
	//--------------------------------------
	//  Other metadata
	//--------------------------------------
	
	[AccessibilityClass(implementation="mx.accessibility.MenuAccImpl")]
	
	[DefaultBindingProperty(destination="dataProvider")]
	
	[DefaultTriggerEvent("change")]
	
	// [IconFile("Menu.png")]
	
	[RequiresDataBinding(true)]
	
	/**
	 *  The Menu control creates a pop-up menu of individually selectable choices,
	 *  similar to the File or Edit menu found in most software applications. The 
	 *  popped up menu can have as many levels of submenus as needed. 
	 *  After a Menu control has opened, it remains visible until it is closed by 
	 *  any of the following actions:
	 * 
	 *  <ul>
	 *   <li>A call to the <code>Menu.hide()</code> method.</li>
	 *   <li>When a user selects an enabled menu item.</li>
	 *   <li>When a user clicks outside of the Menu control.</li>
	 *   <li>When a user selects another component in the application.</li>
	 *  </ul>
	 *
	 *  <p>The Menu class has no corresponding MXML tag. You must create it using ActionScript.</p>
	 *
	 *  <p>The Menu control has the following sizing characteristics:</p>
	 *     <table class="innertable">
	 *        <tr>
	 *           <th>Characteristic</th>
	 *           <th>Description</th>
	 *        </tr>
	 *        <tr>
	 *           <td>Default size</td>
	 *           <td>The width is determined from the Menu text. The 
	 *               default height is the number of menu rows multiplied 
	 *               by 19 pixels per row (the default row height).</td>
	 *        </tr>
	 *     </table>
	 *
	 *  <p>The data provider for Menu items can specify several attributes that determine how 
	 *  the item is displayed and behaves, as the following XML data provider shows:</p>
	 *  <pre>
	 *   &lt;mx:XML format=&quot;e4x&quot; id=&quot;myMenuData&quot;&gt;
	 *     &lt;root&gt;
	 *        &lt;menuitem label=&quot;MenuItem A&quot; icon=&quot;myTopIcon&quot;&gt;
	 *            &lt;menuitem label=&quot;SubMenuItem A-1&quot; enabled=&quot;False&quot;/&gt;
	 *            &lt;menuitem label=&quot;SubMenuItem A-2&quot;/&gt;
	 *        &lt;/menuitem&gt;
	 *        &lt;menuitem label=&quot;MenuItem B&quot; type=&quot;check&quot; toggled=&quot;true&quot;/&gt;
	 *        &lt;menuitem label=&quot;MenuItem C&quot; type=&quot;check&quot; toggled=&quot;false&quot; icon=&quot;myTopIcon&quot;/&gt;
	 *        &lt;menuitem type=&quot;separator&quot;/&gt; 
	 *        &lt;menuitem label=&quot;MenuItem D&quot; icon=&quot;myTopIcon&quot;&gt;
	 *            &lt;menuitem label=&quot;SubMenuItem D-1&quot; type=&quot;radio&quot; groupName=&quot;one&quot;/&gt;
	 *            &lt;menuitem label=&quot;SubMenuItem D-2&quot; type=&quot;radio&quot; groupName=&quot;one&quot; toggled=&quot;true&quot;/&gt;
	 *            &lt;menuitem label=&quot;SubMenuItem D-3&quot; type=&quot;radio&quot; groupName=&quot;one&quot;/&gt;
	 *        &lt;/menuitem&gt;
	 *    &lt;/root&gt;
	 * &lt;/mx:XML&gt;</pre>
	 * 
	 *  <p>The following table lists the attributes you can specify, 
	 *  their data types, their purposes, and how the data provider must represent 
	 *  them if the menu uses the DefaultDataDescriptor class to parse the data provider:</p>
	 * 
	 *  <table class="innertable">
	 *  <tr>
	 *    <th>Attribute</th>
	 *    <th>Type</th>
	 *    <th>Description</th>
	 *  </tr>
	 *  <tr>
	 *    <td><code>enabled</code></td>
	 *    <td>Boolean</td>
	 *    <td>Specifies whether the user can select the menu item (<code>true</code>), 
	 *      or not (<code>false</code>). If not specified, Flex treats the item as if 
	 *      the value were <code>true</code>.
	 *      If you use the default data descriptor, data providers must use an <code>enabled</code> 
	 *      XML attribute or object field to specify this characteristic.</td>
	 *  </tr>
	 *  <tr>
	 *    <td><code>groupName</code></td>
	 *    <td>String</td>
	 *    <td> (Required, and meaningful, for <code>radio</code> type only) The identifier that 
	 *      associates radio button items in a radio group. If you use the default data descriptor, 
	 *      data providers must use a <code>groupName</code> XML attribute or object field to 
	 *      specify this characteristic.</td>
	 *  </tr>
	 *  <tr>
	 *    <td><code>icon</code></td>
	 *    <td>Class</td>
	 *    <td>Specifies the class identifier of an image asset. This item is not used for 
	 *      the <code>check</code>, <code>radio</code>, or <code>separator</code> types. 
	 *      You can use the <code>checkIcon</code> and <code>radioIcon</code> styles to 
	 *      specify the icons used for radio and check box items that are selected.
	 *      The menu's <code>iconField</code> or <code>iconFunction</code> property determines 
	 *      the name of the field in the data that specifies the icon, or a function for determining the icons.</td>
	 *  </tr>
	 *  <tr>
	 *    <td><code>label</code></td>
	 *    <td>String</td>
	 *    <td>Specifies the text that appears in the control. This item is used for all 
	 *      menu item types except <code>separator</code>.
	 *      The menu's <code>labelField</code> or <code>labelFunction</code> property 
	 *      determines the name of the field in the data that specifies the label, 
	 *      or a function for determining the labels. (If the data provider is in E4X XML format, 
	 *      you must specify one of these properties to display a label.) 
	 *      If the data provider is an Array of Strings, Flex uses the String value as the label.</td>
	 *  </tr>
	 *  <tr>
	 *    <td><code>toggled</code></td>
	 *    <td>Boolean</td>
	 *    <td>Specifies whether a check or radio item is selected. 
	 *      If not specified, Flex treats the item as if the value were <code>false</code> 
	 *      and the item is not selected.
	 *      If you use the default data descriptor, data providers must use a toggled 
	 *      XML attribute or object field to specify this characteristic.</td>
	 *  </tr>
	 *  <tr>
	 *    <td><code>type</code></td>
	 *    <td>String</td>
	 *    <td>Specifies the type of menu item. Meaningful values are <code>separator</code>, 
	 *      <code>check</code>, or <code>radio</code>. Flex treats all other values, 
	 *      or nodes with no type entry, as normal menu entries.
	 *      If you use the default data descriptor, data providers must use a type 
	 *      XML attribute or object field to specify this characteristic.</td>
	 *  </tr>
	 * </table>
	 *
	 *
	 *  @includeExample examples/SimpleMenuExample.mxml
	 *
	 *  @see mx.controls.MenuBar
	 *  @see mx.controls.PopUpMenuButton
	 *  @see mx.controls.menuClasses.IMenuDataDescriptor
	 *  @see mx.controls.treeClasses.DefaultDataDescriptor
	 *  @see mx.effects.Tween
	 *  @see mx.managers.PopUpManager
	 *
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public class Menu extends UIComponent implements IFocusManagerContainer, IMenu, IItemRendererProvider
	{
		// include "../core/Version.as";
		
		//--------------------------------------------------------------------------
		//
		//  Class mixins
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  Placeholder for mixin by MenuAccImpl.
		 */
		mx_internal static var createAccessibilityImplementation:Function;
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Creates and returns an instance of the Menu class. The Menu control's 
		 *  content is determined by the method's <code>mdp</code> argument. The 
		 *  Menu control is placed in the parent container specified by the 
		 *  method's <code>parent</code> argument.
		 * 
		 *  This method does not show the Menu control. Instead, 
		 *  this method just creates the Menu control and allows for modifications
		 *  to be made to the Menu instance before the Menu is shown. To show the 
		 *  Menu, call the <code>Menu.show()</code> method.
		 *
		 *  @param parent A container that the PopUpManager uses to place the Menu 
		 *  control in. The Menu control may not actually be parented by this object.
		 * 
		 *  @param mdp The data provider for the Menu control. 
		 *  @see mx.controls.Menu@dataProvider 
		 * 
		 *  @param showRoot A Boolean flag that specifies whether to display the 
		 *  root node of the data provider.
		 *  @see mx.controls.Menu@showRoot 
		 * 
		 *  @return An instance of the Menu class. 
		 *
		 *  @see mx.controls.Menu#popUpMenu()
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function createMenu(parent:UIComponent, mdp:Object, showRoot:Boolean = true):Menu
		{
			var menu:Menu = new Menu();
			menu.tabEnabled = false;
			menu.tabFocusEnabled = false;
			// menu.owner = DisplayObjectContainer(FlexGlobals.topLevelApplication);
			menu.showRoot = showRoot;
			popUpMenu(menu, parent, mdp);
			return menu;
		}
		
		/**
		 *  Sets the dataProvider of an existing Menu control and places the Menu 
		 *  control in the specified parent container.
		 *  
		 *  This method does not show the Menu control; you must use the 
		 *  <code>Menu.show()</code> method to display the Menu control. 
		 * 
		 *  The <code>Menu.createMenu()</code> method uses this method.
		 *
		 *  @param menu Menu control to popup. 
		 * 
		 *  @param parent A container that the PopUpManager uses to place the Menu 
		 *  control in. The Menu control may not actually be parented by this object.
		 *  If you omit this property, the method sets the Menu control's parent to 
		 *  the application. 
		 * 
		 *  @param mdp dataProvider object set on the popped up Menu. If you omit this 
		 *  property, the method sets the Menu data provider to a new, empty XML object.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function popUpMenu(menu:Menu, parent:UIComponent, mdp:Object):void
		{
			menu.parentDisplayObject = parent ?
				parent :
				UIComponent(FlexGlobals.topLevelApplication);
			
			if (!mdp)
				mdp = new XML();
			
			menu.supposedToLoseFocus = true;
			//      menu.isPressed = true;
			menu.dataProvider = mdp;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 *
		 *  <p>Applications do not normally call the Menu constructor directly.
		 *  Instead, Applications will call the <code>Menu.createMenu()</code>
		 *  method.</p>
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function Menu()
		{
			super();
			
			/*itemRenderer = new ClassFactory(MenuItemRenderer);
			setRowHeight(19);
			iconField = "icon";*/
			typeNames = "Menu";
			
			visible = false;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  internal measuring stick
		 */
		private var hiddenItem:IListItemRenderer;
		
		/**
		 *  @private
		 *  The maximum width for icons.  Used so they 
		 *  can align properly across all MenuItemRenderers
		 */
		private var maxMeasuredIconWidth:Number = 0;
		
		/**
		 *  @private
		 *  The maximum width for type icons (checkbox, radiobox).
		 *  Used so they can align properly across all MenuItemRenderers
		 */
		private var maxMeasuredTypeIconWidth:Number = 0;
		
		/**
		 *  @private
		 *  The maximum width for branch icons.  Used so they 
		 *  can align properly across all MenuItemRenderers
		 */
		private var maxMeasuredBranchIconWidth:Number = 0;
		
		/**
		 *  @private
		 *  Whether the left icons should layout into two separate columns
		 *  (one for icons and one for type icons, like check and radio)
		 */
		private var useTwoColumns:Boolean = false;
		
		/**
		 *  @private
		 *  The menu bar that eventually spawned this menu
		 */
		mx_internal var sourceMenuBar:MenuBar;      // optional
		
		/**
		 *  @private
		 *  the IMenuBarItemRenderer instance in the menubar 
		 *  that spawned this menu
		 */
		// mx_internal var sourceMenuBarItem:IMenuBarItemRenderer;   // optional
		
		/**
		 *  @private
		 *  Where to add this menu on the display list.
		 */
		mx_internal var parentDisplayObject:UIComponent;
		
		/**
		 *  @private
		 *  Whether the menu was opened from the left or the right.
		 *  This really only applies to submenus and helps with cascading submenus.
		 */
		private var isDirectionLeft:Boolean = false;
		
		// the anchor is the row in the parent menu that opened to be this menu
		// or the row in this menu that opened to be a submenu
		private var anchorRow:IListItemRenderer;
		
		//private var _anchor:String; // reference to the ID of the last opened submenu within a menu level
		//private var _anchorIndex:int; // reference to the rowIndex of a menu's anchor in the parent menu
		
		private var subMenu:Menu;
		
		mx_internal var popupTween:Tween;
		
		mx_internal var supposedToLoseFocus:Boolean = false;
		
		/**
		 *  @private
		 *  When this timer fires, we'll open a submenu
		 */
		mx_internal var openSubMenuTimer:int = 0;
		
		/**
		 *  @private
		 *  When this timer fires, we'll hide this menu
		 */
		mx_internal var closeTimer:int = 0;
		
		/**
		 *  @private
		 *  Storage variable for the original dataProvider
		 */
		mx_internal var _rootModel:ICollectionView;
		
		/**
		 *  @private
		 *  Storage variable for dataProvider passed to parent
		 */
		mx_internal var _listDataProvider:ICollectionView;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//  parentMenu
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		mx_internal var _parentMenu:Menu;
		
		/**
		 *  The parent menu in a hierarchical chain of menus, where the current 
		 *  menu is a submenu of the parent.
		 * 
		 *  @return The parent Menu control. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get parentMenu():Menu
		{
			return _parentMenu;
		}
		
		/**
		 *  @private
		 */
		public function set parentMenu(value:Menu):void
		{
			_parentMenu = value;
			
			// setup weak references
			/*value.addEventListener(FlexEvent.HIDE, parentHideHandler, false, 0, true);
			value.addEventListener("rowHeightChanged", parentRowHeightHandler, false, 0, true);
			value.addEventListener("iconFieldChanged", parentIconFieldHandler, false, 0, true);
			value.addEventListener("iconFunctionChanged", parentIconFunctionHandler, false, 0, true);
			value.addEventListener("labelFieldChanged", parentLabelFieldHandler, false, 0, true);
			value.addEventListener("labelFunctionChanged", parentLabelFunctionHandler, false, 0, true);
			value.addEventListener("itemRendererChanged", parentItemRendererHandler, false, 0, true);*/
		}
		
		//--------------------------------------------------------------------------
		//  dataDescriptor
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		// mx_internal var _dataDescriptor:IMenuDataDescriptor = new DefaultDataDescriptor();
		
		/**
		 *  The object that accesses and manipulates data in the data provider. 
		 *  The Menu control delegates to the data descriptor for information 
		 *  about its data. This data is then used to parse and move about the 
		 *  data source. The data descriptor defined for the root menu is used 
		 *  for all submenus. 
		 * 
		 *  The default value is an internal instance of the
		 *  DefaultDataDescriptor class.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		/*public function get dataDescriptor():IMenuDataDescriptor
		{
			return IMenuDataDescriptor(_dataDescriptor);
		}*/
		
		/**
		 *  @private
		 */
		/*public function set dataDescriptor(value:IMenuDataDescriptor):void
		{
			_dataDescriptor = value;
		}*/
		
		//--------------------------------------------------------------------------
		//  dataProvider
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		mx_internal var dataProviderChanged:Boolean = false;
		
		/**
		 *  @private
		 *  Convert user data to collection.
		 *
		 *  @see mx.controls.listClasses.ListBase
		 *  @see mx.controls.List
		 *  @see mx.controls.Tree
		 */
		public function set dataProvider(value:Object):void
		{
			// handle strings and xml
			if (typeof(value)=="string")
				value = new XML(value);
			//else if (value is XMLNode)
			//	value = new XML(XMLNode(value).toString());
			else if (value is XMLList)
				value = new XMLListCollection(value as XMLList);
			
			if (value is XML)
			{
				_hasRoot = true;
				var xl:XMLList = new XMLList();
				xl += value;
				if (showRoot)
					_rootModel = new XMLListCollection(xl);
				else
					_rootModel = new XMLListCollection(xl.children());
			}
				//if already a collection dont make new one
			else if (value is ICollectionView)
			{
				_rootModel = ICollectionView(value);
				if (_rootModel.length == 1)
					_hasRoot = true;
			}
			else if (value is Array)
			{
				_rootModel = new ArrayCollection(value as Array);
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
			
			(model as ISelectionModel).dataProvider = _rootModel;
			//flag for processing in commitProps
			dataProviderChanged = true;
			invalidateProperties();
		}
		
		/**
		 *  @private
		 */
		public function get dataProvider():Object
		{
			return (model as ISelectionModel).dataProvider;
		}
		
		//--------------------------------------------------------------------------
		//  showRoot
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  Storage variable for showRoot flag.
		 */
		mx_internal var _showRoot:Boolean = true;
		
		/**
		 *  @private
		 *  Storage variable for changes to showRoot.
		 */ 
		mx_internal var showRootChanged:Boolean = false;
		
		/**
		 *  A Boolean flag that specifies whether to display the data provider's 
		 *  root node.
		 *
		 *  If the dataProvider object has a root node, and showRoot is set to 
		 *  <code>false</code>, the Menu control does not display the root node; 
		 *  only the descendants of the root node will be displayed.  
		 * 
		 *  This flag has no effect on data providers without root nodes, 
		 *  like Lists and Arrays. 
		 *
		 *  @default true
		 *  @see #hasRoot
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get showRoot():Boolean
		{
			return _showRoot;
		}
		
		/**
		 *  @private
		 */
		public function set showRoot(value:Boolean):void
		{
			if (_showRoot != value)
			{
				_showRoot = value;
				showRootChanged = true;
				invalidateProperties();
			}
		}
		
		//--------------------------------------------------------------------------
		//  hasRoot
		//--------------------------------------------------------------------------
		
		/** 
		 *  @private
		 *  Flag to indicate if the model has a root
		 */
		mx_internal var _hasRoot:Boolean = false;
		
		/**
		 *  A flag that indicates that the current data provider has a root node; for example, 
		 *  a single top node in a hierarchical structure. XML and Object 
		 *  are examples of types that have a root node, while Lists and Arrays do 
		 *  not.
		 * 
		 *  @default false
		 *  @see #showRoot
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get hasRoot():Boolean
		{
			return _hasRoot;
		}
		
		//--------------------------------------------------------------------------
		//  defaultButton
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		public function get defaultButton():IFlexDisplayObject
		{
			return null;
		}
		
		/**
		 *  @private
		 */
		public function set defaultButton(value:IFlexDisplayObject):void
		{
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		private function parentHideHandler(event:FlexEvent):void
		{
			visible = false;
		}
		
		/**
		 *  @private
		 */
		private function parentRowHeightHandler(event:Event):void
		{
			rowHeight = parentMenu.rowHeight;
		}
		
		/**
		 *  @private
		 */
		private function parentIconFieldHandler(event:Event):void
		{
			// iconField = parentMenu.iconField;
		}
		
		/**
		 *  @private
		 */
		private function parentIconFunctionHandler(event:Event):void
		{
			// iconFunction = parentMenu.iconFunction;
		}
		
		/**
		 *  @private
		 */
		private function parentLabelFieldHandler(event:Event):void
		{
			// labelField = parentMenu.labelField;
		}
		
		/**
		 *  @private
		 */
		private function parentLabelFunctionHandler(event:Event):void
		{
			// labelFunction = parentMenu.labelFunction;
		}
		
		/**
		 *  @private
		 */
		private function parentItemRendererHandler(event:Event):void
		{
			itemRenderer = parentMenu.itemRenderer;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  Called by the initialize() method of UIComponent
		 *  to hook in the accessibility code.
		 */
		/*override protected function initializeAccessibility():void
		{
			if (createAccessibilityImplementation != null)
				createAccessibilityImplementation(this);
		}*/
		
		/**
		 *  @private
		 */
		/*override protected function commitProperties():void 
		{
			if (showRootChanged)
			{
				if (!_hasRoot)
					showRootChanged = false;            
			}
			
			if (dataProviderChanged || showRootChanged)
			{
				var tmpCollection:ICollectionView;
				
				// Reset flags.
				dataProviderChanged = false;
				showRootChanged = false;
				
				// Are we swallowing the root?
				if (_rootModel && !_showRoot && _hasRoot)
				{
					var rootItem:* = _rootModel.createCursor().current;
					if (rootItem != null &&
						_dataDescriptor.isBranch(rootItem, _rootModel) &&
						_dataDescriptor.hasChildren(rootItem, _rootModel))
					{
						// then get rootItem children
						tmpCollection = _dataDescriptor.getChildren(rootItem, _rootModel);
					}
				}
				
				if (_listDataProvider)
				{
					_listDataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE,
						collectionChangeHandler, false);
				}
				
				// At this point _rootModel may be null so we dont need to continue.
				if (_rootModel)
				{
					if (!tmpCollection)
						tmpCollection = _rootModel;
					
					_listDataProvider = tmpCollection;
					super.dataProvider = tmpCollection;
					
					// not really a default handler, but we need to be later than the wrapper
					_listDataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE,
						collectionChangeHandler,
						false,
						EventPriority.DEFAULT_HANDLER, true);
				}
				else
				{
					_listDataProvider = null;
					vider = null;
				}
			}
			
			// Send it up the chain.
			super.commitProperties();
		}*/
		
		
		/**
		 *  Calculates the preferred width and height of the Menu based on the
		 *  widths and heights of its menu items. This method does not take into 
		 *  account the position and size of submenus. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		/*override protected function measure():void
		{
			super.measure();
			
			if (!dataProvider || dataProvider.length == 0)
			{
				// we show a collapsed menu if nothing in it so we can dispatch
				// a menuShow and give someone a chance to add things
				measuredWidth = 0;
				measuredHeight = 0;
			}
			else
			{       
				var vm:EdgeMetrics = viewMetrics;
				measuredMinWidth = measuredWidth = measureWidthOfItems(0, dataProvider.length);
				
				var requiredHeight:int;
				if (variableRowHeight)
					requiredHeight = measureHeightOfItems(0, dataProvider.length);
				else
					requiredHeight = dataProvider.length * rowHeight;
				
				measuredMinHeight = measuredHeight =
					requiredHeight + vm.top + vm.bottom;
			}
		}*/
		
		/**
		 *  @private
		 */
		/*override public function measureWidthOfItems(index:int = -1, count:int = 0):Number
		{
			var w:Number = 0;
			
			// reset max's so we can shrink if we should
			var minimumLeftMargin:Number = getStyle("leftIconGap");
			var minimumRightMargin:Number = getStyle("rightIconGap");
			maxMeasuredIconWidth = 0;
			maxMeasuredTypeIconWidth = 0;
			maxMeasuredBranchIconWidth = 0;
			useTwoColumns = false;
			
			if (collection && collection.length)
			{
				var placeHolder:CursorBookmark = iterator.bookmark;
				var previousCount:int = count;
				
				// we loop through up to 2 times because the first time, we may 
				// need to do a re-draw due to the margins changing from a 
				// larger icon width
				for (var i:int = 0; i < 2; i++)
				{
					iterator.seek(CursorBookmark.FIRST, index);
					count = previousCount;
					var valuesChanged:Boolean = false;
					
					while (count)
					{
						var data:Object = iterator.current;
						var menuListData:MenuListData;
						
						var item:IListItemRenderer = hiddenItem = getMeasuringRenderer(data);
						item.explicitWidth = NaN;
						
						setupRendererFromData(item, data);
						w = Math.max(item.getExplicitOrMeasuredWidth(), w);
						
						if (item is IMenuItemRenderer)
						{
							var menuItemRenderer:IMenuItemRenderer = IMenuItemRenderer(item);
							
							if (menuItemRenderer.measuredIconWidth > maxMeasuredIconWidth)
							{
								maxMeasuredIconWidth = menuItemRenderer.measuredIconWidth;
								valuesChanged = true;
							}
							
							if (menuItemRenderer.measuredTypeIconWidth > maxMeasuredTypeIconWidth)
							{
								maxMeasuredTypeIconWidth = menuItemRenderer.measuredTypeIconWidth;
								valuesChanged = true;
							}
							
							if (menuItemRenderer.measuredBranchIconWidth > maxMeasuredBranchIconWidth)
							{
								maxMeasuredBranchIconWidth = menuItemRenderer.measuredBranchIconWidth;
								valuesChanged = true;
							}
							
							// use two columns if the same MenuItemRenderer can have both a type icon and a 
							// regular icon
							if (menuItemRenderer.measuredIconWidth > 0 && menuItemRenderer.measuredTypeIconWidth)
							{
								useTwoColumns = true;
								valuesChanged = true;
							}
						}
						
						count--;
						if (!iterator.moveNext())
							break;
					}
					
					if (i == 0)
					{
						if (!(valuesChanged && 
							(maxMeasuredIconWidth + maxMeasuredTypeIconWidth > minimumLeftMargin ||
								maxMeasuredBranchIconWidth > minimumRightMargin)))
						{
							break;
						}
					}
				}
				
				iterator.seek(placeHolder, 0);
			}
			if (!w)
			{
				// If we couldn't calculate a width, use 200
				w = 200;
			}
			
			w += getStyle("paddingLeft") + getStyle("paddingRight");
			
			return w;
		}*/
		
		/**
		 *  @private
		 */
		/*override protected function updateDisplayList(unscaledWidth:Number,
													  unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if (border)
			{
				border.move(0, 0); 
				border.visible = (dataProvider != null && dataProvider.length > 0);
			}
			
			// there's sort of a bug in the player that if we don't give size to the
			// hiddenItem it gets set to width = 0 and then you can't measure text anymore.
			if (hiddenItem)
				hiddenItem.setActualSize(unscaledWidth, hiddenItem.getExplicitOrMeasuredHeight());
		}*/
		
		/**
		 *  @private
		 *  Relying on UIComponent description.
		 */
		override public function styleChanged(styleProp:String):void
		{
			super.styleChanged(styleProp);
			
			deleteDependentSubMenus();
		}
		
		/**
		 *  @private
		 */
		/*override protected function drawItem(item:IListItemRenderer,
											 selected:Boolean = false,
											 highlighted:Boolean = false,
											 caret:Boolean = false,
											 transition:Boolean = false):void
		{
			if (!getStyle("useRollOver"))
			{
				super.drawItem(item, selected, false, false, transition);
			}
			else
			{
				super.drawItem(item, selected, highlighted, caret, transition);
			}
		}*/
		
		/**
		 *  @private
		 */
		/*override protected function configureScrollBars():void
		{
		}*/
		
		/*override mx_internal function clearHighlight(item:IListItemRenderer):void
		{
			var uid:String = itemToUID(item.data);
			
			drawItem(visibleData[uid], isItemSelected(item.data),
				false, uid == caretUID);
			
			var pt:Point = itemRendererToIndices(item);
			if (pt)
			{
				var menuEvent:MenuEvent = new MenuEvent(MenuEvent.ITEM_ROLL_OUT);
				menuEvent.menu = this;
				menuEvent.index = getRowIndex(item);
				menuEvent.menuBar = sourceMenuBar;
				menuEvent.label = itemToLabel(item.data);
				menuEvent.item = item.data;
				menuEvent.itemRenderer = item;
				getRootMenu().dispatchEvent(menuEvent);
				
			}
		}*/
		
		/**
		 *  @private
		 *  Determines if the itemrenderer is a separator. If so, return null to prevent separators
		 *  from highlighting and emitting menu-level events. 
		 */
		/*override protected function mouseEventToItemRenderer(event:MouseEvent):IListItemRenderer
		{
			var row:IListItemRenderer = super.mouseEventToItemRenderer(event);
			
			if (row && row.data && _dataDescriptor.getType(row.data) == "separator")
				return null;
			else return row;
		}*/
		
		/**
		 *  @private
		 */
		override public function setFocus():void
		{
			super.setFocus();
		}
		
		/**
		 *  @private
		 */
		/*override protected function focusOutHandler(event:FocusEvent):void
		{
			super.focusOutHandler(event);
			if (!supposedToLoseFocus)
			{
				hideAllMenus();
			}
			supposedToLoseFocus = false;
		}*/
		
		/**
		 *  @private
		 */
		override public function dispatchEvent(event:Event):Boolean
		{  
			if (!(event is MenuEvent) && event is ListEvent && 
				(event.type == ListEvent.ITEM_ROLL_OUT ||
					event.type == ListEvent.ITEM_ROLL_OVER ||
					event.type == ListEvent.CHANGE))
			{
				// we don't want to dispatch ListEvent.ITEM_ROLL_OVER or
				// ListEvent.ITEM_ROLL_OUT or ListEvent.CHANGE events 
				// because Menu dispatches its own 
				event.stopImmediatePropagation();                
			}   
			
			// in case we encounter a ListEvent.ITEM_CLICK from 
			// a superclass that we did not account for, 
			// lets convert the ListEvent and pass it on up to 
			// avoid an RTE
			if (!(event is MenuEvent) && event is ListEvent && 
				(event.type == ListEvent.ITEM_CLICK))
			{
				var me:MenuEvent = new MenuEvent(event.type,
					event.bubbles,
					event.cancelable);
                me.index = ListEvent(event).rowIndex;
				me.item = ListEvent(event).itemRenderer.data;
				me.label = (ListEvent(event).itemRenderer as ListItemRenderer).text;
				return super.dispatchEvent(me);                     
			}
			
			// we'll let everything else go through
			return super.dispatchEvent(event);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Toggles the menu item. The menu item type identifier must be a
		 *  check box or radio button, otherwise this method has no effect.
		 *
		 *  @param item The menu item to toggle.
		 *  @param toggle Boolean value that indicates whether the item is 
		 *  toggled. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		protected function setMenuItemToggled(item:Object, toggle:Boolean):void
		{
			/*itemsSizeChanged = true;
			invalidateDisplayList();
			if (_dataDescriptor.getType(item) == "radio")
			{
				var groupName:String = _dataDescriptor.getGroupName(item);
				
				// Find other items with the same groupName and toggle them to the state opposite the item.
				// Toggle the item.
				for (var i:int = 0; i < listItems.length; i++)
				{
					var row:IListItemRenderer = listItems[i][0];
					var rowItem:Object = row.data;
					if (_dataDescriptor.getType(rowItem) == "radio" &&
						_dataDescriptor.getGroupName(rowItem) == groupName)
					{
						_dataDescriptor.setToggled(rowItem, (rowItem == item));
					}
				}
			}
			if (toggle != _dataDescriptor.isToggled(item))
			{
				_dataDescriptor.setToggled(item, toggle);
			}*/
		}
		
		/**
		 *  Creates a new MenuListData instance and populates the fields based on
		 *  the input data provider item. 
		 *  
		 *  @param data The data provider item used to populate the ListData.
		 *  @param uid The UID for the item.
		 *  @param rowNum The index of the item in the data provider.
		 *  
		 *  @return A newly constructed ListData object.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		/*override protected function makeListData(data:Object, uid:String, 
												 rowNum:int):BaseListData
		{
			var menuListData:MenuListData = new MenuListData(itemToLabel(data), itemToIcon(data),
				labelField, uid, this, rowNum);
			
			menuListData.maxMeasuredIconWidth = maxMeasuredIconWidth;
			menuListData.maxMeasuredTypeIconWidth = maxMeasuredTypeIconWidth; 
			menuListData.maxMeasuredBranchIconWidth = maxMeasuredBranchIconWidth;
			menuListData.useTwoColumns = useTwoColumns;
			
			return menuListData;  
		}*/
		
		/**
		 *  Shows the Menu control. If the Menu control is not visible, this method 
		 *  places the Menu in the upper-left corner of the parent application at 
		 *  the given coordinates, resizes the Menu control as needed, and makes 
		 *  the Menu control visible.
		 * 
		 *  The x and y arguments of the <code>show()</code> method specify the 
		 *  coordinates of the upper-left corner of the Menu control relative to the 
		 *  sandbox root, which is not necessarily the direct parent of the 
		 *  Menu control. 
		 * 
		 *  For example, if the Menu control is in an HBox container which is 
		 *  nested within a Panel container, the x and y coordinates are 
		 *  relative to the Application container, not to the HBox container.
		 *
		 *  @param x Horizontal location of the Menu control's upper-left 
		 *  corner (optional).
		 * 
		 *  @param y Vertical location of the Menu control's upper-left 
		 *  corner (optional).
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function show(parent:IUIBase, xShow:Number = 0, yShow:Number = 0):void
		{
			if (parent is UIComponent)
				parentDisplayObject = (parent as UIComponent);
				
			//this could be an empty menu so we'll return if it is
			//if (collection && collection.length == 0)
			//	return;
			
			// If parent is closed, then don't show this submenu
			if (parentMenu && !parentMenu.visible)
				return;
			
			// If I'm already visible, then do nothing
			if (visible)
				return;
			
			if (parentDisplayObject && (!parent /* || !parent.contains(parentDisplayObject)*/))
			{
				PopUpManager.addPopUp(this, parentDisplayObject, false);
				//addEventListener(MenuEvent.MENU_HIDE, menuHideHandler, false, EventPriority.DEFAULT_HANDLER);
				MenuModel.menuList.push(this);
			}
			/*
			// Fire an event
			var menuEvent:MenuEvent = new MenuEvent(MenuEvent.MENU_SHOW);
			menuEvent.menu = this;
			menuEvent.menuBar = sourceMenuBar;
			getRootMenu().dispatchEvent(menuEvent);
			
			// Activate the focus manager for that menu
			var awm:IActiveWindowManager = 
				IActiveWindowManager(systemManager.getImplementation("mx.managers::IActiveWindowManager"));
			awm.activate(this);
			
			*/
			// Position it
			if (/*xShow !== null && */!isNaN(Number(xShow)))
				x = Number(xShow);
			if (/*yShow !== null && */!isNaN(Number(yShow)))
				y = Number(yShow);
			/*
			// Adjust for menus that extend out of bounds
			var sm:ISystemManager = systemManager.topLevelSystemManager;
			var sbRoot:UIComponent = sm.getSandboxRoot();
			if (this != getRootMenu())
			{
				// do x
				var screen:Rectangle;
				var pt:Point = new Point(x, y);
				pt = sbRoot.localToGlobal(pt);
				
				screen = sm.getVisibleApplicationRect(null, true);
				
				var shift:Number = pt.x + width - screen.right;
				if (shift > 0)
					x = Math.max(x - shift, 0);
				
				// now do y
				shift = pt.y + height - screen.bottom;
				if (shift > 0)
					y = Math.max(y - shift, 0);
			}
			
			// Make sure the Menu's width and height has been determined
			// before we try to set the size for its mask
			UIComponentGlobals.layoutManager.validateClient(this, true);
			*/
			setActualSize(getExplicitOrMeasuredWidth(), getExplicitOrMeasuredHeight());
			/*
			cacheAsBitmap = true;
			
			var duration:Number = getStyle("openDuration");
			if (duration != 0)
			{
				scrollRect = new Rectangle(0, 0, unscaledWidth, 0);
				
				*/
				// Make it visible
				visible = true;
				/*
				UIComponentGlobals.layoutManager.validateNow();
				
				// Block all layout, responses from web service, and other background
				// processing until the tween finishes executing.
				UIComponent.suspendBackgroundProcessing();
				
				popupTween = new Tween(this, [0,0], [unscaledWidth,unscaledHeight], duration);
			}
			else 
			{
				// if duration is zero, this should allow alternate 
				// effects specified via showEffect to work
				UIComponentGlobals.layoutManager.validateNow();
				visible = true;
			}
			
			focusManager.setFocus(this);
			supposedToLoseFocus = true;
			
			// If the user clicks outside the menu, then hide the menu
			sbRoot.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownOutsideHandler, false, 0, true);
			addEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE, mouseDownOutsideHandler, false, 0, true);*/
		}
		
		/**
		 *  @private
		 */
		mx_internal function onTweenUpdate(value:Object):void
		{
			// Slide the mask down until it covers the Menu
			// scrollRect = new Rectangle(0, 0, value[0], value[1]);
		}
		
		/**
		 *  @private
		 */
		mx_internal function onTweenEnd(value:Object):void
		{/*
			UIComponent.resumeBackgroundProcessing();
			scrollRect = null;
			popupTween = null;*/
		}
		
		/**
		 *  Hides the Menu control and any of its submenus if the Menu control is
		 *  visible.  
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function hide():void
		{/*
			if (visible)
			{
				// Kill any tween that's currently running
				if (popupTween)
					popupTween.endTween();
				
				clearSelected();
				if (anchorRow)
				{
					drawItem(anchorRow, false, false);
					anchorRow = null;
				}
				
				visible = false;
				//          isPressed = false;
				
				// Now that the menu is no longer visible, it doesn't need
				// to listen to mouseDown events anymore.
				var sbRoot:UIComponent = systemManager.getSandboxRoot();
				sbRoot.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownOutsideHandler);
				removeEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE, mouseDownOutsideHandler);
				
				// Fire an event
				var menuEvent:MenuEvent = new MenuEvent(MenuEvent.MENU_HIDE);
				menuEvent.menu = this;
				menuEvent.menuBar = sourceMenuBar;
				getRootMenu().dispatchEvent(menuEvent);
			}*/
		}
		
		// -------------------------------------------------------------------------
		// Event Handlers
		// -------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		/*override protected function collectionChangeHandler(event:Event):void
		{
			//trace("[Menu] caught model changed:", CollectionEvent(event).kind);
			if (event is CollectionEvent)
			{
				var ce:CollectionEvent = CollectionEvent(event);
				if (ce.kind == CollectionEventKind.ADD)
				{
					super.collectionChangeHandler(event);
					dataProviderChanged = true;
					invalidateProperties();
					invalidateSize();
					UIComponentGlobals.layoutManager.validateClient(this);
					setActualSize(getExplicitOrMeasuredWidth(), getExplicitOrMeasuredHeight());
				}
				else if (ce.kind == CollectionEventKind.REMOVE)
				{
					super.collectionChangeHandler(event);
					dataProviderChanged = true;
					invalidateProperties();
					invalidateSize();
					UIComponentGlobals.layoutManager.validateClient(this);
					setActualSize(getExplicitOrMeasuredWidth(), getExplicitOrMeasuredHeight());
				}
				else if (ce.kind == CollectionEventKind.REFRESH)
				{
					dataProviderChanged = true;
					invalidateProperties();
					invalidateSize();
				}
				else if (ce.kind == CollectionEventKind.RESET)
				{
					dataProviderChanged = true;
					invalidateProperties();
					invalidateSize();
				}
			}
			itemsSizeChanged = true;
			invalidateDisplayList();
		}*/
		
		/**
		 *  @private
		 */
		private function mouseDownOutsideHandler(event:Event):void
		{/*
			if (event is MouseEvent)
			{
				var mouseEvent:MouseEvent = MouseEvent(event);
				if (!isMouseOverMenu(mouseEvent) && !isMouseOverMenuBarItem(mouseEvent))
					hideAllMenus();
			}
			else if (event is SandboxMouseEvent)
				hideAllMenus();*/
		}
		
		/**
		 *  @private
		 *  Removes the root menu from the display list.  This is called only for
		 *  menus created using "createMenu".
		 * 
		 *  MJM private static?
		 */
		private static function menuHideHandler(event:MenuEvent):void
		{/*
			var menu:Menu = Menu(event.target);
			if (!event.isDefaultPrevented() && event.menu == menu)
			{
				menu.supposedToLoseFocus = true;
				PopUpManager.removePopUp(menu);
				menu.removeEventListener(MenuEvent.MENU_HIDE, menuHideHandler);
			}*/
		}
		
		/**
		 *  @private
		 *  Handle mouse release on an item.
		 *
		 *  For separators or items with sub-menu, do nothing.
		 *  For check items, toggle state, then fire change event.
		 *  For radio items, toggle state if untoggled, then fire change event.
		 *  For normal items, fire change event.
		 */
		/*override protected function mouseUpHandler(event:MouseEvent):void
		{
			var menuEvent:MenuEvent;
			
			if (!enabled || !selectable || !visible)
				return;
			
			super.mouseUpHandler(event);
			
			var row:IListItemRenderer = mouseEventToItemRenderer(event);
			
			var item:Object;
			if (row && row.data)
				item = row.data;
			
			if (item != null && _dataDescriptor.isEnabled(item) && !_dataDescriptor.isBranch(item))
			{
				// Toggle the item if it is a check or it is previously untoggled radio item.
				// For previously toggled radio items, we will dispatch MenuEvent.ITEM_CLICK events but
				// won't toggle or dispatch MenuEvent.CHANGE events.
				// Custom item renderers can choose how to display this state
				var toggleItem:Boolean = _dataDescriptor.getType(item) != "radio" 
					|| !_dataDescriptor.isToggled(item);
				
				if (toggleItem)
					setMenuItemToggled(item, !_dataDescriptor.isToggled(item));
				
				menuEvent = new MenuEvent(MenuEvent.ITEM_CLICK);
				menuEvent.menu = this;
				menuEvent.index = this.selectedIndex;
				menuEvent.menuBar = sourceMenuBar;
				menuEvent.label = itemToLabel(item);
				menuEvent.item = item;
				menuEvent.itemRenderer = row;
				getRootMenu().dispatchEvent(menuEvent);
				
				if (toggleItem)
				{
					menuEvent = new MenuEvent(MenuEvent.CHANGE);
					menuEvent.menu = this;
					menuEvent.index = this.selectedIndex;
					menuEvent.menuBar = sourceMenuBar;
					menuEvent.label = itemToLabel(item);
					menuEvent.item = item;
					menuEvent.itemRenderer = row;
					getRootMenu().dispatchEvent(menuEvent);
				}
				
				hideAllMenus();
			}
		}*/
		
		/**
		 *  @private
		 *  Extend the behavior from ScrollSelectList to handle row presses over
		 *  separators, branch items, and disabled row items.
		 */
		/*override protected function mouseDownHandler(event:MouseEvent):void
		{
			var row:IListItemRenderer = mouseEventToItemRenderer(event);
			
			var item:Object;
			if (row && row.data)
				item = row.data;
			
			// only allow action on items that are enabled which are not branches
			if (item && _dataDescriptor.isEnabled(item) && !_dataDescriptor.isBranch(item))
				super.mouseDownHandler(event);
		}*/
		
		
		/**
		 *  @private
		 *  Notify listeners when the mouse leaves
		 */
		/*override protected function mouseOutHandler(event:MouseEvent):void
		{
			if (!enabled || !selectable || !visible) 
				return;
			
			systemManager.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, true);
			
			// Fire the appropriate rollout event
			var row:IListItemRenderer = mouseEventToItemRenderer(event);
			
			if (!row)
				return;
			
			var item:Object;
			if (row && row.data)
				item = row.data;
			
			// If a submenu was waiting to open, then clear the timeout
			// so it doesn't open
			if (openSubMenuTimer)
			{
				clearInterval(openSubMenuTimer);
				openSubMenuTimer = 0;
			}
			
			// either we're rolling onto different subpieces of ourself or our 
			// highlight indicator, or the clearing of the highlighted item has 
			// already happened care of the mouseMove handler
			if (itemRendererContains(row, event.relatedObject) ||
				itemRendererContains(row, UIComponent(event.target)) || 
				event.relatedObject == highlightIndicator || 
				event.relatedObject == listContent || 
				!highlightItemRenderer)
			{
				return;
			}
			
			if (getStyle("useRollOver") && item)
			{
				clearHighlight(row);
			}
		}*/
		
		/**
		 *  @private
		 *  Extend the behavior from ScrollSelectList to pop up submenus
		 */
		/*override protected function mouseOverHandler(event:MouseEvent):void
		{
			if (!enabled || !selectable || !visible) 
				return;
			
			systemManager.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, true, 0, true);
			
			var row:IListItemRenderer = mouseEventToItemRenderer(event);
			
			if (!row)
				return;
			
			var item:Object;
			if (row && row.data)
				item = row.data;
			
			isPressed = event.buttonDown;
			
			if (row && row != anchorRow)
			{
				if (anchorRow)
					// no longer on anchor so close its submenu
					drawItem(anchorRow, false, false);
				if (subMenu)
				{
					subMenu.supposedToLoseFocus = true;
					subMenu.closeTimer = setTimeout(closeSubMenu, 250, subMenu);
				}
				subMenu = null;
				anchorRow = null;
			}
			else if (subMenu && subMenu.subMenu)
			{
				// Close grandchild submenus - only children are allowed to be open
				subMenu.subMenu.hide();
			}
			
			// Update the view
			if (_dataDescriptor.isBranch(item) && _dataDescriptor.isEnabled(item))
			{
				anchorRow = row;
				
				// If there's a timer waiting to close this menu, cancel the
				// timer so that the menu doesn't close
				if (subMenu && subMenu.closeTimer)
				{
					clearInterval(subMenu.closeTimer);
					subMenu.closeTimer = 0;
				}
				
				// If the menu is not visible, pop it up after a short delay
				if (!subMenu || !subMenu.visible)
				{
					if (openSubMenuTimer)
						clearInterval(openSubMenuTimer);
					
					openSubMenuTimer = setTimeout(
						function(row:IListItemRenderer):void
						{
							openSubMenu(row);
						},
						250,
						row);
				}
			}
			
			// Send event and update view
			if (item && _dataDescriptor.isEnabled(item))
			{
				// we're rolling onto different subpieces of ourself or our highlight indicator
				if (event.relatedObject)
				{
					if (itemRendererContains(row, event.relatedObject) ||
						row == lastHighlightItemRenderer ||
						event.relatedObject == highlightIndicator)
						return;
				}
			}
			
			if (row)
			{
				drawItem(row, false, Boolean(item && _dataDescriptor.isEnabled(item)));
				
				if (isPressed)
				{
					if (item && _dataDescriptor.isEnabled(item))
					{
						if (!_dataDescriptor.isBranch(item))
							selectItem(row, event.shiftKey, event.ctrlKey);
						else
							clearSelected();
					}
				}
				
				if (item && _dataDescriptor.isEnabled(item))
				{
					// Fire the appropriate rollover event
					var menuEvent:MenuEvent = new MenuEvent(MenuEvent.ITEM_ROLL_OVER);
					menuEvent.menu = this;
					menuEvent.index = getRowIndex(row);
					menuEvent.menuBar = sourceMenuBar;
					menuEvent.label = itemToLabel(item);
					menuEvent.item = item;
					menuEvent.itemRenderer = row;
					getRootMenu().dispatchEvent(menuEvent);
				}
			}
		}*/
		
		/**
		 *  @private
		 *  ListBase uses the mouseClickHandler dispatch the ListEvent.ITEM_CLICK event.
		 *  In Menu we chose to do that in the mouseUpHandler so we will do nothing
		 *  in the mouseClickHandler. 
		 */
		/*override protected function mouseClickHandler(event:MouseEvent):void
		{
		}*/
		
		/**
		 *  @private
		 */
		/*override protected function keyDownHandler(event:KeyboardEvent):void
		{
			var row:IListItemRenderer = selectedIndex == -1 ? null : listItems[selectedIndex - verticalScrollPosition][0];
			var rowData:Object = row ? row.data : null;
			var menu:Menu = row ? IMenuItemRenderer(row).menu : null;
			var menuEvent:MenuEvent;
			
			// If rtl layout, need to swap LEFT and RIGHT so correct action
			// is done.
			var keyCode:uint = mapKeycodeForLayoutDirection(event);
			
			// Handle Key.UP Navigation
			if (keyCode == Keyboard.UP)
			{
				if (rowData && _dataDescriptor.isBranch(rowData) && menu && menu.visible)
				{
					supposedToLoseFocus = true;
					menu.setFocus();
					
					// start at end and move up 1
					menu.moveSelBy(menu.dataProvider.length, -1);
				}
				else
				{
					moveSelBy(selectedIndex, -1);
				}
				
				event.stopPropagation();
			}
				
				// Handle Key.DOWN Navigation
			else if (keyCode == Keyboard.DOWN)
			{
				if (rowData && _dataDescriptor.isBranch(rowData) && menu && menu.visible)
				{
					supposedToLoseFocus = true;
					menu.setFocus();
					
					// start at -1 and move down 1
					menu.moveSelBy(-1, 1);
				}
				else
				{
					moveSelBy(selectedIndex, 1);
				}
				
				event.stopPropagation();
			}
				
				// Handle Key.RIGHT Navigation
			else if (keyCode == Keyboard.RIGHT)
			{
				if (rowData && _dataDescriptor.isBranch(rowData))
				{
					openSubMenu(row);
					menu = IMenuItemRenderer(row).menu;
					
					supposedToLoseFocus = true;
					menu.setFocus();
					
					// start at -1 and move down 1
					menu.moveSelBy(-1, 1);
				}
				else
				{
					// jump to next sibling in the menubar
					if (sourceMenuBar)
					{
						supposedToLoseFocus = true;
						sourceMenuBar.setFocus();
						// Redispatch the event to the MenuBar
						// and let its keyDownHandler() handle it.
						sourceMenuBar.dispatchEvent(event);
					}
				}
				event.stopPropagation();
			}
				
				// Handle Key.LEFT Navigation
			else if (keyCode == Keyboard.LEFT)
			{
				if (_parentMenu)
				{
					supposedToLoseFocus = true;
					hide(); // hide this menu
					_parentMenu.setFocus();
				}
				else
				{
					// jump to previous sibling in the menubar
					if (sourceMenuBar)
					{
						supposedToLoseFocus = true;
						sourceMenuBar.setFocus();
						// Redispatch the event to the MenuBar
						// and let its keyDownHandler() handle it.
						sourceMenuBar.dispatchEvent(event);
					}
				}
				
				event.stopPropagation();
			}
				
				// Handle Key.ENTER Commands
			else if (keyCode == Keyboard.ENTER || keyCode == Keyboard.SPACE)
			{
				if (rowData && _dataDescriptor.isBranch(rowData))
				{
					openSubMenu(row);
					menu = IMenuItemRenderer(row).menu;
					
					supposedToLoseFocus = true;
					menu.setFocus();
					
					// start at -1 and move down 1
					menu.moveSelBy(-1, 1);
				}
				else if (rowData)
				{
					// Toggle the item regardless of whether it is a check or radio
					// Custom item renderers can choose how to display this state
					setMenuItemToggled(rowData, !_dataDescriptor.isToggled(rowData));
					
					menuEvent = new MenuEvent(MenuEvent.ITEM_CLICK);
					menuEvent.menu = this;
					menuEvent.index = this.selectedIndex;
					menuEvent.menuBar = sourceMenuBar;
					menuEvent.label = itemToLabel(rowData);
					menuEvent.item = rowData;
					menuEvent.itemRenderer = row;
					getRootMenu().dispatchEvent(menuEvent);
					
					menuEvent = new MenuEvent(MenuEvent.CHANGE);
					menuEvent.menu = this;
					menuEvent.index = this.selectedIndex;
					menuEvent.menuBar = sourceMenuBar;
					menuEvent.label = itemToLabel(rowData);
					menuEvent.item = rowData;
					menuEvent.itemRenderer = row;
					getRootMenu().dispatchEvent(menuEvent);
					
					hideAllMenus();
				}
				
				event.stopPropagation();
			}
				
				// Handle Key.ESCAPE commands
			else if (keyCode == Keyboard.TAB)
			{
				menuEvent = new MenuEvent(MenuEvent.MENU_HIDE);
				menuEvent.menu = getRootMenu();
				menuEvent.menuBar = sourceMenuBar;
				getRootMenu().dispatchEvent(menuEvent);
				
				hideAllMenus();
				
				event.stopPropagation();
			}
				
			else if (keyCode == Keyboard.ESCAPE)
			{
				if (_parentMenu)
				{
					supposedToLoseFocus = true;
					hide(); // hide this menu
					_parentMenu.setFocus();
				}
				else
				{
					menuEvent = new MenuEvent(MenuEvent.MENU_HIDE);
					menuEvent.menu = getRootMenu();
					menuEvent.menuBar = sourceMenuBar;
					getRootMenu().dispatchEvent(menuEvent);
					
					hideAllMenus();
					
					event.stopPropagation();
				}
			}
		}*/
		
		/**
		 *  @private
		 */
		private function moveSelBy(oldIndex:Number, incr:Number):void
		{/*
			var curIndex:Number = oldIndex;
			if (isNaN(curIndex))
				curIndex = -1;
			
			var limit:Number = Math.max(0, Math.min(rowCount, collection.length) - 1);
			
			var newIndex:Number = curIndex;
			var item:Object;
			var curItem:int = 0;
			
			do
			{ 
				newIndex = newIndex + incr;
				
				if (curItem > limit)
					return;
				else
					curItem++;
				
				if (newIndex > limit)
					newIndex = 0;
				else if (newIndex < 0)
					newIndex = limit;
				
				item = listItems[newIndex][0];
				
			}
			while (item.data && (_dataDescriptor.getType(item.data) == "separator" || !_dataDescriptor.isEnabled(item.data)));
			
			var menuEvent:MenuEvent;
			
			if (selectedIndex != -1)
			{
				var oldItem:Object = listItems[selectedIndex][0];
				
				menuEvent = new MenuEvent(MenuEvent.ITEM_ROLL_OUT);
				menuEvent.menu = this;
				menuEvent.index = this.selectedIndex;
				menuEvent.menuBar = sourceMenuBar;
				menuEvent.label = itemToLabel(oldItem.data);
				menuEvent.item = oldItem.data;
				menuEvent.itemRenderer = IListItemRenderer(oldItem);
				getRootMenu().dispatchEvent(menuEvent);
			}
			
			if (item.data)
			{
				selectItem(listItems[newIndex - verticalScrollPosition][0], false, false);
				
				menuEvent = new MenuEvent(MenuEvent.ITEM_ROLL_OVER);
				menuEvent.menu = this;
				menuEvent.index = this.selectedIndex;
				menuEvent.menuBar = sourceMenuBar;
				menuEvent.label = itemToLabel(item.data);
				menuEvent.item = item.data;
				menuEvent.itemRenderer = IListItemRenderer(item);
				getRootMenu().dispatchEvent(menuEvent);
			}*/
		}
		
		// -------------------------------------------------------------------------
		// Menu visibility management
		// -------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		mx_internal function openSubMenu(row:IListItemRenderer):void
		{
			supposedToLoseFocus = true;
			
			var r:Menu = getRootMenu();
			var menu:Menu;
			
			// check to see if the menu exists, if not create it
			/*if (!IMenuItemRenderer(row).menu)
			{
				menu = new Menu();
				menu.parentMenu = this;
				menu.owner = this;
				menu.showRoot = showRoot;
				menu.dataDescriptor = r.dataDescriptor;
				menu.styleName = r;
				menu.labelField = r.labelField;
				menu.labelFunction = r.labelFunction;
				menu.iconField = r.iconField;
				menu.iconFunction = r.iconFunction;
				menu.itemRenderer = r.itemRenderer;
				menu.rowHeight = r.rowHeight;
				menu.scaleY = r.scaleY;
				menu.scaleX = r.scaleX;
				
				// if there's data and it has children then add the items
				if (row.data && 
					_dataDescriptor.isBranch(row.data) &&
					_dataDescriptor.hasChildren(row.data))
				{
					menu.dataProvider = _dataDescriptor.getChildren(row.data);
				}
				menu.sourceMenuBar = sourceMenuBar;
				menu.sourceMenuBarItem = sourceMenuBarItem;
				
				IMenuItemRenderer(row).menu = menu;
				PopUpManager.addPopUp(menu, r, false);
			}
			else
			{
				menu = IMenuItemRenderer(row).menu;
			}
			
			var _do:UIComponent = UIComponent(row);
			var sandBoxRootPoint:Point = new Point(0,0);
			sandBoxRootPoint = _do.localToGlobal(sandBoxRootPoint);
			// when loadMovied, you may not be in global coordinates
			if (_do.root)   //verify this is sufficient
				sandBoxRootPoint = _do.root.globalToLocal(sandBoxRootPoint);
			
			// If the layout is mirrored, and isDirectionLeft then we add the
			// menu's width to find the origin of menu, rather than subtracting.
			// Similarly, if isDirectionLeft=false, we subtract the menu item's width.
			
			const isLayoutMirrored:Boolean = 
				(layoutDirection == LayoutDirection.RTL);
			const menuWidth:Number = menu.getExplicitOrMeasuredWidth();
			const menuItemWidth:Number = row.width;
			
			// showX, showY are in sandbox root coordinates
			var showY:Number = sandBoxRootPoint.y;
			var showX:Number;
			if (!isDirectionLeft)
				showX = sandBoxRootPoint.x + ((isLayoutMirrored) ? -menuItemWidth : +menuItemWidth);
			else
				showX = sandBoxRootPoint.x + ((isLayoutMirrored) ? +menuWidth : -menuWidth);
			
			// If the layout has been mirrored, then showX is currently menu's right
			// edge; compensate here.
			if (isLayoutMirrored)
				showX -= menuWidth;
			
			// convert to global coordinates to compare with getVisibleApplicationRect().
			// the screen is the visible coordinates of our sandbox (written in global coordinates)
			var screen:Rectangle = systemManager.getVisibleApplicationRect(null, true);
			var sbRoot:UIComponent = systemManager.getSandboxRoot();
			
			var screenPoint:Point = sbRoot.localToGlobal(new Point(showX, showY));
			
			// do x
			var shift:Number = screenPoint.x + menuWidth - screen.right;
			if (shift > 0 || screenPoint.x < screen.x)
			{
				// if we want to ensure our parent's visible, let's 
				// modify the shift so that we're not just on-screen
				// but we're also shifted away from our parent.
				var shiftForParent:Number = getExplicitOrMeasuredWidth() + menu.getExplicitOrMeasuredWidth();
				
				// if was going left, shift to right.  otherwise, shift to left
				if (isDirectionLeft)
					shiftForParent *= -1;
				
				showX = Math.max(showX - shiftForParent, 0);
				
				// now make sure we're still on-screen again
				screenPoint = new Point(showX, showY);
				screenPoint = sbRoot.localToGlobal(screenPoint);
				
				// only shift if greater our position + width > width of screen
				shift = Math.max(0, screenPoint.x + width - screen.right);
				
				showX = Math.max(showX - shift, 0);
			}
			
			menu.isDirectionLeft = (isLayoutMirrored) ? (this.x <= showX) : (this.x > showX);
			
			// now do y
			shift = screenPoint.y + menu.getExplicitOrMeasuredHeight() - screen.bottom;
			if (shift > 0 || screenPoint.y < screen.y)
				showY = Math.max(showY - shift, 0);
			
			menu.show(showX, showY);
			
			subMenu = menu;
			clearInterval(openSubMenuTimer);
			openSubMenuTimer = 0;*/
		}
		
		/**
		 *  @private
		 */
		private function closeSubMenu(menu:Menu):void
		{
			menu.hide();
			// clearInterval(menu.closeTimer);
			menu.closeTimer = 0;
		}
		
		mx_internal function deleteDependentSubMenus():void
		{/*
			var n:int = listItems.length;
			for (var i:int = 0; i < n; i++)
			{
				
				// Check to see if the listItems array has a renderer at this index.
				if (listItems[i][0])
				{
					var subMenu:Menu = IMenuItemRenderer(listItems[i][0]).menu;
					if (subMenu)
					{
						subMenu.deleteDependentSubMenus();
						PopUpManager.removePopUp(subMenu);
						IMenuItemRenderer(listItems[i][0]).menu = null;
					}
				}
			}*/
		}
		
		mx_internal function hideAllMenus():void
		{
			getRootMenu().hide();
			getRootMenu().deleteDependentSubMenus();
		}
		
		//--------------------------------------------------------------------------
		// Internal utilities
		//--------------------------------------------------------------------------
		
		private function isMouseOverMenu(event:MouseEvent):Boolean
		{
			var target:UIComponent = UIComponent(event.target);
			while (target)
			{
				if (target is Menu)
					return true;
				// target = target.parent;
			}
			
			return false;
		}
		
		private function isMouseOverMenuBarItem(event:MouseEvent):Boolean
		{
			/*if (!sourceMenuBarItem)
				return false;
			
			var target:UIComponent = UIComponent(event.target);
			while (target)
			{
				if (target == sourceMenuBarItem)
					return true;
				target = target.parent;
			}*/
			
			return false;
		}
		
		/**
		 * From any menu, walks up the parent menu chain and finds the root menu.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		mx_internal function getRootMenu():Menu
		{
			var target:Menu = this;
			
			while (target.parentMenu)
				target = target.parentMenu;
			
			return target;
		}
		
		/**
		 * Given a row, find the row's index in the Menu. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		private function getRowIndex(row:IListItemRenderer):int
		{
			/*for (var i:int = 0; i < listItems.length; i++)
			{
				var item:IListItemRenderer = listItems[i][0];
				if (item && item.data && !(_dataDescriptor.getType(item.data) == "separator"))
					if (item == row)
						return i;
			}*/
			return -1;
		}
		
		/**
		 *  For autotesting, get the current set of submenus
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		mx_internal function get subMenus():Array
		{
			var arr:Array = [];
			/*for (var i:int = 0; i < listItems.length; i++)
			{
				arr.push(listItems[i][0].menu);
			}*/
			return arr;
		}
		
        //--------------------------------------------------------------------------
        //
        //  Methods: Item fields
        //
        //--------------------------------------------------------------------------
        
        /**
         *  Returns the string the renderer would display for the given data object
         *  based on the labelField and labelFunction properties.
         *  If the method cannot convert the parameter to a string, it returns a
         *  single space.
         *
         *  @param data Object to be rendered.
         *
         *  @return The string to be displayed based on the data.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function itemToLabel(data:Object):String
        {
            if (data == null)
                return " ";
            
            /*
            if (labelFunction != null)
                return labelFunction(data);
            */
            
            if (data is XML)
            {
                try
                {
                    if ((data as XML)[labelField].length() != 0)
                        data = (data as XML)[labelField];
                    //by popular demand, this is a default XML labelField
                    //else if (data.@label.length() != 0)
                    //  data = data.@label;
                }
                catch(e:Error)
                {
                }
            }
            else if (data is Object)
            {
                try
                {
                    if (data[labelField] != null)
                        data = data[labelField];
                }
                catch(e:Error)
                {
                }
            }
            
            if (data is String)
                return String(data);
            
            try
            {
                return data.toString();
            }
            catch(e:Error)
            {
            }
            
            return " ";
        }

        /*
        * IItemRendererProvider
        */
        
        private var _itemRenderer:IFactory;
        
        /**
         *  The class or factory used to display each item.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get itemRenderer():IFactory
        {
            return _itemRenderer;
        }
        public function set itemRenderer(value:IFactory):void
        {
            _itemRenderer = value;
        }

        //----------------------------------
        //  labelField
        //----------------------------------
                
        [Bindable("labelFieldChanged")]
        [Inspectable(category="Data", defaultValue="label")]
        
        /**
         *  The name of the field in the data provider items to display as the label. 
         *  By default the list looks for a property named <code>label</code> 
         *  on each item and displays it.
         *  However, if the data objects do not contain a <code>label</code> 
         *  property, you can set the <code>labelField</code> property to
         *  use a different property in the data object. An example would be 
         *  "FullName" when viewing a set of people names fetched from a database.
         *
         *  @default "label"
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         *  @royaleignorecoercion org.apache.royale.core.ISelectionModel
         */
        public function get labelField():String
        {
            return (model as ISelectionModel).labelField;
        }
        
        /**
         *  @private
         *  @royaleignorecoercion org.apache.royale.core.ISelectionModel
         */
        public function set labelField(value:String):void
        {
            (model as ISelectionModel).labelField = value;
        }
        
		        //----------------------------------
        //  rowHeight
        //----------------------------------
        
        /**
         *  @private
         *  Storage for the rowHeight property.
         */
        private var _rowHeight:Number;
        
        /**
         *  @private
         */
        private var rowHeightChanged:Boolean = false;
        
        [Inspectable(category="General")]
        
        /**
         *  The height of the rows in pixels.
         *  Unless the <code>variableRowHeight</code> property is
         *  <code>true</code>, all rows are the same height.  
         *  If not specified, the row height is based on
         *  the font size and other properties of the renderer.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function get rowHeight():Number
        {
            return _rowHeight;
        }
        
        /**
         *  @private
         *  @royaleignorecoercion org.apache.royale.core.IListPresentationModel
         */
        public function set rowHeight(value:Number):void
        {
            //explicitRowHeight = value;
            
            if (_rowHeight != value)
            {
                _rowHeight = value;
                
                (presentationModel as IListPresentationModel).rowHeight = value;
                /*
                invalidateSize();
                itemsSizeChanged = true;
                invalidateDisplayList();
                
                dispatchEvent(new Event("rowHeightChanged"));
                */
            }
        }

        /**
         * @private
         */
        private var _presentationModel:IListPresentationModel;
        
        /**
         *  The DataGrid's presentation model
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
         *  @royaleignorecoercion org.apache.royale.core.IListPresentationModel
         *  @royaleignorecoercion org.apache.royale.core.IBead
         */
        public function get presentationModel():IBead
        {
            if (_presentationModel == null) {
                var bead:IBead = getBeadByType(IListPresentationModel);
                if (bead)
                    _presentationModel = bead as IListPresentationModel;
                else
                {
                    var c:Class = ValuesManager.valuesImpl.getValue(this, "iListPresentationModel");
                    if (c) {
                        _presentationModel = new c() as IListPresentationModel;
                        addBead(_presentationModel as IBead);
                    }
                }
            }
            
            return _presentationModel;
        }

		override public function addedToParent():void
		{
			super.addedToParent();		
			
            // Load the layout bead if it hasn't already been loaded.
            loadBeadFromValuesManager(IBeadLayout, "iBeadLayout", this);

            // Even though super.addedToParent dispatched "beadsAdded", DataContainer still needs its data mapper
            // and item factory beads. These beads are added after super.addedToParent is called in case substitutions
            // were made; these are just defaults extracted from CSS.
            loadBeadFromValuesManager(IDataProviderItemRendererMapper, "iDataProviderItemRendererMapper", this);
            loadBeadFromValuesManager(IItemRendererClassFactory, "iItemRendererClassFactory", this);
	        dispatchEvent(new Event("initComplete"));
		}
		
		/**
         * Returns the ILayoutHost which is its view. From ILayoutParent.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         *  @royaleignorecoercion org.apache.royale.core.ILayoutHost
         */
        public function getLayoutHost():ILayoutHost
        {
            return view as ILayoutHost;
        }

	    //----------------------------------
	    //  selectedIndex
	    //----------------------------------
	
	    [Bindable("change")]
	    [Bindable("valueCommit")]
	    [Inspectable(category="General", defaultValue="-1")]
	
	    /**
	     *  The index in the data provider of the selected item.
	     * 
	     *  <p>The default value is -1 (no selected item).</p>
	     *
	     *  
	     *  @langversion 3.0
	     *  @playerversion Flash 9
	     *  @playerversion AIR 1.1
	     *  @productversion Flex 3
	     *  @royaleignorecoercion org.apache.royale.core.ISelectionModel
	     */
	    public function get selectedIndex():int
	    {
	        return (model as ISelectionModel).selectedIndex;
	    }
	
	    /**
	     *  @private
	     *  @royaleignorecoercion org.apache.royale.core.ISelectionModel
	     */
	    public function set selectedIndex(value:int):void
	    {
	       // if (!collection || collection.length == 0)
	       // {
	        (model as ISelectionModel).selectedIndex = value;
	         //   bSelectionChanged = true;
	         //   bSelectedIndexChanged = true;
	          //  invalidateDisplayList();
	            return;
	       // }
	        //commitSelectedIndex(value);
	    }

	    //----------------------------------
	    //  selectedItem
	    //----------------------------------
	    
	    [Bindable("change")]
	    [Bindable("valueCommit")]
	    
	    /**
	     *  The selected item in the data provider.
	     *  
	     *  @langversion 3.0
	     *  @playerversion Flash 9
	     *  @playerversion AIR 1.1
	     *  @productversion Flex 3
	     */
	    public function get selectedItem():Object
	    {
	        return (model as ISelectionModel).selectedItem;
	    }
	    
	    /**
	     *  @private
	     */
	    public function set selectedItem(item:Object):void
	    {
	        (model as ISelectionModel).selectedItem = item;
	    }
	    
		private var _parentMenuBar:IEventDispatcher;
		
		/**
		 * @private
		 * 
		 * If this menu is used as part of a menu bar system, this property should reference
		 * that menu bar. If this property is set, the "change" event is dispatched against this
		 * object rather than the Menu itself.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function get parentMenuBar():IEventDispatcher
		{
			return _parentMenuBar;
		}
		public function set parentMenuBar(value:IEventDispatcher):void
		{
			_parentMenuBar = value;
		}
		
		/**
		 * The name of the field to use in the data that indicates a sub-menu. The
		 * default value is "menu".
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function get submenuField():String
		{
			return (model as CascadingMenuModel).submenuField;
		}
		
		public function set submenuField(value:String):void
		{
			(model as CascadingMenuModel).submenuField = value;
		}
		        
	}
	
}
