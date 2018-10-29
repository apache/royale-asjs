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

package mx.controls.menuClasses
{
	// import flash.display.DisplayObject;
	// import flash.text.TextLineMetrics;
	
	import org.apache.royale.core.TextLineMetrics;
	
	import mx.controls.MenuBar;
	import mx.core.IFlexDisplayObject; 
	import mx.core.IFlexModuleFactory;
	import mx.core.IFontContextComponent;
	import mx.core.IProgrammaticSkin;
	import mx.core.IStateClient;
	import mx.core.IUITextField;
	import mx.core.UIComponent;
	import mx.core.UITextField;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.ISimpleStyleClient;
	
	use namespace mx_internal;
	
	// include "../../styles/metadata/LeadingStyle.as"
	// include "../../styles/metadata/TextStyles.as"
	
	/**
	 *  The MenuBarItem class defines the default item 
	 *  renderer for the top-level menu bar of a MenuBar control. 
	 *  By default, the item renderer draws the text associated
	 *  with each item in the top-level menu bar, and an optional icon. 
	 *
	 *  <p>A MenuBarItem
	 *  instance passes mouse and keyboard interactions to the MenuBar so 
	 *  that the MenuBar can correctly show and hide menus. </p>
	 *
	 *  <p>You can override the default MenuBar item renderer
	 *  by creating a custom item renderer that implements the 
	 *  IMenuBarItemRenderer interface.</p>
	 * 
	 *  <p>You can also define an item renderer for the pop-up submenus 
	 *  of the MenuBar control. 
	 *  Because each pop-up submenu is an instance of the Menu control, 
	 *  you use the class MenuItemRenderer to define an item renderer 
	 *  for the pop-up submenus.</p>
	 *
	 *  @see mx.controls.MenuBar
	 *  @see mx.controls.Menu
	 *  @see mx.controls.menuClasses.IMenuBarItemRenderer
	 *  @see mx.controls.menuClasses.MenuItemRenderer
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	
	public class MenuBarItem extends UIComponent implements IMenuBarItemRenderer, IFontContextComponent
	{
		
		//include "../../core/Version.as";
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		private var leftMargin:int = 20;
		
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
		public function MenuBarItem()
		{
			super();
			mouseChildren = false;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  currentSkin
		//----------------------------------
		
		/**
		 *  The skin defining the border and background for this MenuBarItem.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		mx_internal var currentSkin:IFlexDisplayObject;
		
		//----------------------------------
		//  icon
		//----------------------------------
		
		/**
		 *  The IFlexDisplayObject that displays the icon in this MenuBarItem.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		protected var icon:IFlexDisplayObject;
		
		//----------------------------------
		//  label
		//----------------------------------
		
		/**
		 *  The UITextField that displays the text in this MenuBarItem.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		protected var label:IUITextField;
		
		/**
		 *  The default skin's style name
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		mx_internal var skinName:String = "itemSkin";
		
		/**
		 *  Flags used to save information about the skin and icon styles
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		private var defaultSkinUsesStates:Boolean = false;
		private var checkedDefaultSkin:Boolean = false;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden properties: UIComponent
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  The baselinePosition of a MenuBarItem is calculated
		 *  for its label.
		 */
		override public function get baselinePosition():Number
		{
			if (!validateBaselinePosition())
				return NaN;
			
			return label.y + label.baselinePosition;
		}
		
		//----------------------------------
		//  enabled
		//----------------------------------
		
		/**
		 *  @private
		 */
		private var enabledChanged:Boolean = false;
		
		/**
		 *  @private
		 */
		override public function set enabled(value:Boolean):void
		{
			if (super.enabled == value)
				return;
			
			super.enabled = value;
			enabledChanged = true;
			
			invalidateProperties();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  data
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the data property.
		 */
		private var _data:Object;
		
		[Bindable("dataChange")]
		
		/**
		 *  The implementation of the <code>data</code> property
		 *  as defined by the IDataRenderer interface.
		 *  All item renderers must implement the IDataRenderer interface.
		 *
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
			_data = value;
			invalidateProperties();
			
			dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
		}
		
		//----------------------------------
		//  fontContext
		//----------------------------------
		
		/**
		 *  @private
		 */
		public function get fontContext():IFlexModuleFactory
		{
			return moduleFactory;
		}
		
		/**
		 *  @private
		 */
		public function set fontContext(moduleFactory:IFlexModuleFactory):void
		{
			this.moduleFactory = moduleFactory;
		}
		
		//----------------------------------
		//  menuBar
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the menuBar property. 
		 */
		private var _menuBar:MenuBar;
		
		/**
		 *  The implementation of the <code>menuBar</code> property
		 *  as defined by the IMenuBarItemRenderer interface. 
		 *  
		 *  @copy mx.controls.menuClasses.IMenuBarItemRenderer#menuBar 
		 * 
		 *  @see mx.controls.menuClasses.IMenuBarItemRenderer#menuBar
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get menuBar():MenuBar
		{
			return _menuBar;
		}
		
		/**
		 *  @private
		 */
		public function set menuBar(value:MenuBar):void
		{
			_menuBar = value;
		}   
		
		//----------------------------------
		//  menuBarItemIndex
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the menuBarItemIndex property. 
		 */
		private var _menuBarItemIndex:int = -1;
		
		/**
		 *  The implementation of the <code>menuBarItemIndex</code> property
		 *  as defined by the IMenuBarItemRenderer interface.  
		 *  
		 *  @copy mx.controls.menuClasses.IMenuBarItemRenderer#menuBarItemIndex 
		 * 
		 *  @see mx.controls.menuClasses.IMenuBarItemRenderer#menuBarItemIndex
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get menuBarItemIndex():int
		{
			return _menuBarItemIndex;
		}
		
		/**
		 *  @private
		 */
		public function set menuBarItemIndex(value:int):void
		{
			_menuBarItemIndex = value;
		}   
		
		//----------------------------------
		//  menuBarItemState
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the menuBarItemState property. 
		 */
		private var _menuBarItemState:String;
		
		/**
		 *  The implementation of the <code>menuBarItemState</code> property
		 *  as defined by the IMenuBarItemRenderer interface.  
		 * 
		 *  @copy mx.controls.menuClasses.IMenuBarItemRenderer#menuBarItemState
		 * 
		 *  @see mx.controls.menuClasses.IMenuBarItemRenderer#menuBarItemState
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get menuBarItemState():String
		{
			return _menuBarItemState;
		}
		
		/**
		 *  @private
		 */
		public function set menuBarItemState(value:String):void
		{
			_menuBarItemState = value;
			viewSkin(_menuBarItemState);
		}   
		
		//--------------------------------------------------------------------------
		//
		//  Deprecated Properties 
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  dataProvider
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for data provider
		 */
		private var _dataProvider:Object;
		
		/**
		 *  The object that provides the data for the Menu that is popped up
		 *  when this MenuBarItem is selected.
		 * 
		 *  @default "undefined"
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get dataProvider():Object
		{
			return _dataProvider
		}
		
		[Deprecated(replacement="MenuBarItem.data")]
		
		/**
		 *  @private
		 */
		public function set dataProvider(value:Object):void
		{
			_dataProvider = value;
			
			invalidateProperties();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods: UIComponent
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			var styleDeclaration:CSSStyleDeclaration = new CSSStyleDeclaration(null, styleManager);
			styleDeclaration.factory = function():void
			{
				this.borderStyle = "none"
			};
			
			createLabel(-1);
		}
		
		/**
		 *  @private
		 */
		override protected function commitProperties():void
		{/*
			super.commitProperties();
			
			// if the font changed and we already created the label, we will need to 
			// destory it so it can be re-created, possibly in a different swf context.
			if (hasFontContextChanged() && label != null)
			{
				var index:int = getChildIndex(DisplayObject(label));
				removeLabel();
				createLabel(index);
			}
			
			var iconClass:Class;
			
			if (enabledChanged)
			{
				enabledChanged = false;
				if (label)
					label.enabled = enabled;
				
				if (!enabled)
					menuBarItemState = "itemUpSkin";
			}
			
			//Remove any existing icons. 
			//These will be recreated below if needed.
			if (icon)
			{
				removeChild(DisplayObject(icon));
				icon = null;
			}
			
			if (_data)
			{
				iconClass = menuBar.itemToIcon(data);
				if (iconClass)
				{
					icon = new iconClass();
					addChild(DisplayObject(icon));
				}
				
				label.visible = true;
				var labelText:String;
				if (menuBar.labelFunction != null)
					labelText = menuBar.labelFunction(_data);
				if (labelText == null)
					labelText = menuBar.itemToLabel(_data);
				label.text = labelText;
				label.enabled = enabled;    
			}
			else
			{
				label.text = " ";
			}
			
			// Invalidate layout here to ensure icons are positioned correctly.
			invalidateDisplayList();*/
		}
		
		/**
		 *  @private
		 */
		override protected function measure():void
		{
			super.measure();
			
			if (icon && leftMargin < icon.measuredWidth)
			{
				leftMargin = icon.measuredWidth;
			}
			measuredWidth = label.getExplicitOrMeasuredWidth() + leftMargin;
			measuredHeight = label.getExplicitOrMeasuredHeight();
			
			if (icon && icon.measuredHeight > measuredHeight)
				measuredHeight = icon.measuredHeight + 2;
		}   
		
		/**
		 *  @private
		 */
		override protected function updateDisplayList(unscaledWidth:Number,
													  unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if (icon)
			{
				icon.x = (leftMargin - icon.measuredWidth) / 2;
				icon.setActualSize(icon.measuredWidth, icon.measuredHeight);
				label.x = leftMargin;
			}
			else
				label.x = leftMargin / 2;
			
			label.setActualSize(unscaledWidth - leftMargin, 
				label.getExplicitOrMeasuredHeight());
			
			label.y = (unscaledHeight - label.height) / 2;
			
			if (icon)
				icon.y = (unscaledHeight - icon.height) / 2;
			
			menuBarItemState = "itemUpSkin";
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//-------------------------------------------------------------------------- 
		
		/**
		 *  @private
		 *  Creates the label and adds it as a child of this component.
		 * 
		 *  @param childIndex The index of where to add the child.
		 *  If -1, the text field is appended to the end of the list.
		 */
		mx_internal function createLabel(childIndex:int):void
		{
			/*if (!label)
			{
				label = IUITextField(createInFontContext(UITextField));
				
				label.styleName = this;
				label.selectable = false;
				
				if (childIndex == -1)
					addChild(DisplayObject(label));
				else 
					addChildAt(DisplayObject(label), childIndex);
			}*/
		}
		
		/**
		 *  @private
		 *  Removes the label from this component.
		 */
		mx_internal function removeLabel():void
		{/*
			if (label)
			{
				removeChild(DisplayObject(label));
				label = null;
			}*/
		}
		
		/**
		 *  @private
		 */
		private function viewSkin(state:String):void
		{  	/*
			var newSkinClass:Class = Class(getStyle(state));
			var newSkin:IFlexDisplayObject;
			var stateName:String = "";
			
			if (!newSkinClass)
			{
				// Try the default skin
				newSkinClass = Class(getStyle(skinName)); 		
				
				if (state == "itemDownSkin")
					stateName = "down";
				else if (state == "itemOverSkin")
					stateName = "over";
				else if (state == "itemUpSkin")
					stateName = "up";
				
				// If we are using the default skin, then 
				if (defaultSkinUsesStates)
					state = skinName;
				
				if (!checkedDefaultSkin && newSkinClass)
				{
					newSkin = IFlexDisplayObject(new newSkinClass());
					// Check if the skin class is a state client or a programmatic skin
					if (!(newSkin is IProgrammaticSkin) && newSkin is IStateClient)
					{
						defaultSkinUsesStates = true;
						state = skinName;
					}
					
					if (newSkin)
					{
						checkedDefaultSkin = true;
					}
				}
			}
			
			newSkin = IFlexDisplayObject(getChildByName(state));
			
			if (!newSkin)
			{
				if (newSkinClass)
				{
					newSkin = new newSkinClass();
					
					DisplayObject(newSkin).name = state;
					
					if (newSkin is ISimpleStyleClient)
						ISimpleStyleClient(newSkin).styleName = this;
					
					addChildAt(DisplayObject(newSkin), 0);
				}
			}
			
			newSkin.setActualSize(unscaledWidth, unscaledHeight);
			
			if (currentSkin)
				currentSkin.visible = false;
			
			if (newSkin)
				newSkin.visible = true;
			
			currentSkin = newSkin;
			
			// Update the state of the skin if it accepts states and it implements the IStateClient interface.
			if (defaultSkinUsesStates && currentSkin is IStateClient)
			{
				IStateClient(currentSkin).currentState = stateName;
			}*/
		}
		
		/**
		 *  @private
		 */
		mx_internal function getLabel():IUITextField
		{
			return label;
		}
		
		// These methods should have been defined in UIComponent.as
		
		//----------------------------------
		//  nestLevel
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the nestLevel property.
		 */
		private var _nestLevel:int = 0;
		
		[Inspectable(environment="none")]
		
		/**
		 *  Depth of this object in the containment hierarchy.
		 *  This number is used by the measurement and layout code.
		 *  The value is 0 if this component is not on the DisplayList.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get nestLevel():int
		{
			return _nestLevel;
		}
		
		/**
		 *  @private
		 */
		public function set nestLevel(value:int):void
		{/*
			// If my parent hasn't been attached to the display list, then its nestLevel
			// will be zero.  If it tries to set my nestLevel to 1, ignore it.  We'll
			// update nest levels again after the parent is added to the display list.
			if (value == 1)
				return;
			
			// Also punt if the new value for nestLevel is the same as my current value.
			// TODO: (aharui) add early exit if nestLevel isn't changing
			if (value > 1 && _nestLevel != value)
			{
				_nestLevel = value;
				
				updateCallbacks();
				
				value ++;
			}
			else if (value == 0)
				_nestLevel = value = 0;
			else
				value ++;
			
			var childList:IChildList = (this is IRawChildrenContainer) ?
				IRawChildrenContainer(this).rawChildren : IChildList(this);
			
			var n:int = childList.numChildren;
			for (var i:int = 0; i < n; i++)
			{
				var ui:ILayoutManagerClient  = childList.getChildAt(i) as ILayoutManagerClient;
				if (ui)
				{
					ui.nestLevel = value;
				}
				else
				{
					var textField:IUITextField = childList.getChildAt(i) as IUITextField;
					
					if (textField)
						textField.nestLevel = value;
				}
			}*/
		}
		
		//----------------------------------
		//  processedDescriptors
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the processedDescriptors property.
		 */
		private var _processedDescriptors:Boolean = false;
		
		[Inspectable(environment="none")]
		
		/**
		 *  Set to <code>true</code> after immediate or deferred child creation,
		 *  depending on which one happens. For a Container object, it is set
		 *  to <code>true</code> at the end of
		 *  the <code>createComponentsFromDescriptors()</code> method,
		 *  meaning after the Container object creates its children from its child descriptors.
		 *
		 *  <p>For example, if an Accordion container uses deferred instantiation,
		 *  the <code>processedDescriptors</code> property for the second pane of
		 *  the Accordion container does not become <code>true</code> until after
		 *  the user navigates to that pane and the pane creates its children.
		 *  But, if the Accordion had set the <code>creationPolicy</code> property
		 *  to <code>"all"</code>, the <code>processedDescriptors</code> property
		 *  for its second pane is set to <code>true</code> during application startup.</p>
		 *
		 *  <p>For classes that are not containers, which do not have descriptors,
		 *  it is set to <code>true</code> after the <code>createChildren()</code>
		 *  method creates any internal component children.</p>
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get processedDescriptors():Boolean
		{
			return _processedDescriptors;
		}
		
		/**
		 *  @private
		 */
		public function set processedDescriptors(value:Boolean):void
		{/*
			_processedDescriptors = value;
			
			if (value)
				dispatchEvent(new FlexEvent(FlexEvent.INITIALIZE));*/
		}

		//----------------------------------
		//  updateCompletePendingFlag
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the updateCompletePendingFlag property.
		 */
		private var _updateCompletePendingFlag:Boolean = false;
		
		[Inspectable(environment="none")]
		
		/**
		 *  A flag that determines if an object has been through all three phases
		 *  of layout validation (provided that any were required).
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get updateCompletePendingFlag():Boolean
		{
			return _updateCompletePendingFlag;
		}
		
		/**
		 *  @private
		 */
		public function set updateCompletePendingFlag(value:Boolean):void
		{
			_updateCompletePendingFlag = value;
		}

		/**
		 *  @private
		 *  This method is called at the beginning of each getter
		 *  for the baselinePosition property.
		 *  If it returns false, the getter should return NaN
		 *  because the baselinePosition can't be computed.
		 *  If it returns true, the getter can do computations
		 *  like textField.y + textField.baselinePosition
		 *  because these properties will be valid.
		 */
		mx_internal function validateBaselinePosition():Boolean
		{/*
			// If this component isn't parented,
			// then it doesn't know its text styles
			// and we can't compute a baselinePosition.
			if (!parent)
				return false;
			
			// If this component hasn't been sized yet, assign it
			// an actual size that's based on its explicit or measured size.
			//
			// TODO (egeorgie): remove this code when all SDK clients
			// follow the rule to size first and query baselinePosition later.
			if (!setActualSizeCalled && (width == 0 || height == 0))
			{
				validateNow();
				
				var w:Number = getExplicitOrMeasuredWidth();
				var h:Number = getExplicitOrMeasuredHeight();
				
				setActualSize(w, h);
			}
			
			// Ensure that this component's internal TextFields
			// are properly laid out, so that we can use
			// their locations to compute a baselinePosition.
			validateNow();
			
			*/
			return true;
		}
		
		/**
		 *  @private
		 *
		 *  Tests if the current font context has changed
		 *  since that last time createInFontContext() was called.
		 */
		private function hasFontContextChanged():Boolean
		{/*
			
			// If the font has not been set yet, then return false;
			// the font has not changed.
			if (!hasFontContextBeenSaved)
				return false;
			
			// Check if the module factory has changed.
			var fontName:String =
				StringUtil.trimArrayElements(getStyle("fontFamily"), ",");
			var fontWeight:String = getStyle("fontWeight");
			var fontStyle:String = getStyle("fontStyle");
			var bold:Boolean = fontWeight == "bold";
			var italic:Boolean = fontStyle == "italic";
			var fontContext:IFlexModuleFactory = noEmbeddedFonts ? null : 
				embeddedFontRegistry.getAssociatedModuleFactory(
					fontName, bold, italic, this, moduleFactory,
					systemManager);
			return fontContext != oldEmbeddedFontContext;*/
			return false;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods: Initialization
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		mx_internal function updateCallbacks():void
		{/*
			if (invalidateDisplayListFlag)
			UIComponentGlobals.layoutManager.invalidateDisplayList(this);
			
			if (invalidateSizeFlag)
			UIComponentGlobals.layoutManager.invalidateSize(this);
			
			if (invalidatePropertiesFlag)
			UIComponentGlobals.layoutManager.invalidateProperties(this);
			
			// systemManager getter tries to set the internal _systemManager varaible
			// if it is null. Hence a call to the getter is necessary.
			// Stage can be null when an untrusted application is loaded by an application
			// that isn't on stage yet.
			if (systemManager && (_systemManager.stage || usingBridge))
			{
			if (methodQueue.length > 0 && !listeningForRender)
			{
			_systemManager.addEventListener(FlexEvent.RENDER, callLaterDispatcher);
			_systemManager.addEventListener(FlexEvent.ENTER_FRAME, callLaterDispatcher);
			listeningForRender = true;
			}
			
			if (_systemManager.stage)
			_systemManager.stage.invalidate();
			}*/
		}
	}

}
