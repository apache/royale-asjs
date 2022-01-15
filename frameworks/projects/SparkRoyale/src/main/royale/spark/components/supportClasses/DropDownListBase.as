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


package spark.components.supportClasses
{

/* import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Point; */

import mx.collections.IList;
//import mx.core.InteractionMode;
import mx.events.CollectionEvent;
import mx.events.FlexEvent;

import spark.components.List;
//import spark.core.NavigationUnit;
import spark.events.DropDownEvent;
import spark.events.IndexChangeEvent;

import org.apache.royale.core.ISelectionModel;

import mx.core.mx_internal;
use namespace mx_internal;
import spark.components.supportClasses.DropDownController;
import org.apache.royale.geom.Point;
import mx.core.UIComponent;
import org.apache.royale.core.IHasLabelField;

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *  The radius of the corners for this component.
 *
 *  @default 4
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
[Style(name="cornerRadius", type="Number", format="Length", inherit="no", theme="spark")]

/**
 *  Controls the visibility of the drop shadow for this component.
 *
 *  @default true
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[Style(name="dropShadowVisible", type="Boolean", inherit="no", theme="spark")]

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched when the drop-down list closes for any reason, such when 
 *  the user:
 *  <ul>
 *      <li>Selects an item in the drop-down list.</li>
 *      <li>Clicks outside of the drop-down list.</li>
 *      <li>Clicks the anchor button while the drop-down list is 
 *  displayed.</li>
 *  </ul>
 *
 *  @eventType spark.events.DropDownEvent.CLOSE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[Event(name="close", type="spark.events.DropDownEvent")]

/**
 *  Dispatched when the user clicks the anchor button
 *  to display the drop-down list.  
 *  It is also dispatched if the user
 *  uses Control-Down to open the dropDown.
 *
 *  @eventType spark.events.DropDownEvent.OPEN
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
[Event(name="open", type="spark.events.DropDownEvent")]

//--------------------------------------
//  SkinStates
//--------------------------------------

/**
 *  Skin state for the open state of the DropDownListBase control.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[SkinState("open")]

//--------------------------------------
//  Excluded APIs
//--------------------------------------

[Exclude(name="allowMultipleSelection", kind="property")]
[Exclude(name="dragEnabled", kind="property")]
[Exclude(name="dragMoveEnabled", kind="property")]
[Exclude(name="dropEnabled", kind="property")]
[Exclude(name="selectedIndices", kind="property")]
[Exclude(name="selectedItems", kind="property")]

//--------------------------------------
//  Other metadata
//--------------------------------------

//[AccessibilityClass(implementation="spark.accessibility.DropDownListBaseAccImpl")]

/**
 *  The DropDownListBase control contains a drop-down list
 *  from which the user can select a single value.
 *  Its functionality is very similar to that of the
 *  SELECT form element in HTML.
 *
 *  <p>The DropDownListBase control consists of the anchor button, 
 *  and drop-down-list. 
 *  Use the anchor button to open and close the drop-down-list. 
 *  </p>
 *
 *  <p>When the drop-down list is open:</p>
 *  <ul>
 *    <li>Clicking the anchor button closes the drop-down list 
 *      and commits the currently selected data item.</li>
 *    <li>Clicking outside of the drop-down list closes the drop-down list 
 *      and commits the currently selected data item.</li>
 *    <li>Clicking on a data item selects that item and closes the drop-down list.</li>
 *    <li>If the <code>requireSelection</code> property is <code>false</code>, 
 *      clicking on a data item while pressing the Control key deselects 
 *      the item and closes the drop-down list.</li>
 *  </ul>
 *
 *  @mxml <p>The <code>&lt;s:DropDownListBase&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass and adds the following attributes:</p>
 *
 *  <pre>
 *  &lt;s:DropDownListBase 
 *    <strong>Styles</strong>
 *    cornerRadius="4"
 *    dropShadowVisible="true"
 * 
 *    <strong>Events</strong>
 *    closed="<i>No default</i>"
 *    open="<i>No default</i>"
 *  /&gt;
 *  </pre>
 *
 *  @see spark.skins.spark.DropDownListSkin
 *  @see spark.components.supportClasses.DropDownController
 *
 *  @includeExample examples/DropDownListExample.mxml
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
public class DropDownListBase extends List implements IHasLabelField
{
    //include "../../core/Version.as";
 
    //--------------------------------------------------------------------------
    //
    //  Class mixins
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     *  Placeholder for mixin by DropDownListBaseAccImpl.
     */
   // mx_internal static var createAccessibilityImplementation:Function;
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function DropDownListBase()
    {
        super();
	if((model as ISelectionModel).labelField == null) 
			labelField =  "label";
        dropDownController = new DropDownController();
    }
    
    //--------------------------------------------------------------------------
    //
    //  Skin parts
    //
    //--------------------------------------------------------------------------    

    //----------------------------------
    //  dropDown
    //----------------------------------

    //[SkinPart(required="false")]

    /**
     *  A skin part that defines the drop-down list area. When the DropDownListBase is open,
     *  clicking anywhere outside of the dropDown skin part closes the   
     *  drop-down list. 
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public var dropDown:UIComponent;
    
    //----------------------------------
    //  openButton
    //----------------------------------

    //[SkinPart(required="true")]

    /**
     *  A skin part that defines the anchor button.  
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public var openButton:ButtonBase;
       
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    //private var labelChanged:Boolean = false;
    // Stores the user selected index until the dropDown closes
    
    /**
     *  @private
     */
    //mx_internal static var PAGE_SIZE:int = 5;
    
    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  allowMultipleSelection
    //----------------------------------
    
    /**
     *  @private
     */
    /* override public function set allowMultipleSelection(value:Boolean):void
    {
        // Don't allow this value to be set. If the multiple
        // selection related properties are set and 
        // allowMultipleSelection is false, List will
        // select the first item passed in. 
        return;
    } */
       
    //----------------------------------
    //  dataProvider
    //----------------------------------

    [Bindable("dataProviderChanged")]
    [Inspectable(category="Data")]
    override public function get dataProvider():IList
    {
        return (model as ISelectionModel).dataProvider as IList;
    }

    /**
     *  @private
     *  Update the label if the dataProvider has changed
     */
    override public function set dataProvider(value:IList):void
    {   
        if (dataProvider === value)
            return;
            
        super.dataProvider = value; // this passes it to DataGroup
        
        (model as ISelectionModel).dataProvider = value;
       // labelChanged = true;
        invalidateProperties();
    }
    
    //----------------------------------
    //  dragEnabled
    //----------------------------------

    /**
     *  @private
     *  Excluded property
     */
    /* override public function set dragEnabled(value:Boolean):void
    {
    } */

    //----------------------------------
    //  dragMoveEnabled
    //----------------------------------

    /**
     *  @private
     *  Excluded property
     */
   /*  override public function set dragMoveEnabled(value:Boolean):void
    {
    } */
    
    //----------------------------------
    //  dropEnabled
    //----------------------------------

    /**
     *  @private
     *  Excluded property
     */
    /* override public function set dropEnabled(value:Boolean):void
    {
    } */
    
    //----------------------------------
    //  labelField
    //----------------------------------
    
    //[Inspectable(category="Data", defaultValue="label")]

    override public function get labelField():String
    {
        return (model as ISelectionModel).labelField;
    }

    /**
     *  @private
     */
    override public function set labelField(value:String):void
    {
        (model as ISelectionModel).labelField = value;
        super.labelField = value; // this passes it to DataGroup

        //labelChanged = true;
        //invalidateProperties();
    }

    [Bindable("change")]
    [Bindable("valueCommit")]
    [Inspectable(category="General", defaultValue="-1")]
    override public function get selectedIndex():int
    {
        /*  if (_proposedSelectedIndex != NO_PROPOSED_SELECTION)
             return _proposedSelectedIndex; */

        return (model as ISelectionModel).selectedIndex;
    }

    /**
     *  @private
     */
    override public function set selectedIndex(value:int):void
    {
        (model as ISelectionModel).selectedIndex = value;
        super.selectedIndex = value;
        /*  setSelectedIndex(value, false); */
    }

    [Bindable("change")]
    [Bindable("valueCommit")]
    [Inspectable(category="General", defaultValue="null")]
    override public function get selectedItem():*
    {
        return (model as ISelectionModel).selectedItem;
    }

    /**
     *  @private
     */
    override public function set selectedItem(value:*):void
    {
        (model as ISelectionModel).selectedItem = value;
        super.selectedItem = value;
    }
    //----------------------------------
    //  labelFunction
    //----------------------------------
    
   // [Inspectable(category="Data")]
    
    /**
     *  @private
     */
   /*  override public function set labelFunction(value:Function):void
    {
        if (labelFunction == value)
            return;
            
        super.labelFunction = value;
        labelChanged = true;
        invalidateProperties();
    } */
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  dropDownController
    //----------------------------------
    
    /**
     *  @private
     */
    private var _dropDownController:DropDownController; 
    
    /**
     *  Instance of the DropDownController class that handles all of the mouse, keyboard 
     *  and focus user interactions. 
     * 
     *  Flex calls the <code>initializeDropDownController()</code> method after 
     *  the DropDownController instance is created in the constructor.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
	protected function get dropDownController():DropDownController
    {
        return _dropDownController;
    }
    
    /**
     *  @private
     */
    protected function set dropDownController(value:DropDownController):void
    {
        if (_dropDownController == value)
            return;
            
        _dropDownController = value;
		
        _dropDownController.addEventListener(DropDownEvent.OPEN, dropDownController_openHandler);
        _dropDownController.addEventListener(DropDownEvent.CLOSE, dropDownController_closeHandler);
            
		_dropDownController.closeOnResize = _closeDropDownOnResize;

		if (openButton)
            _dropDownController.openButton = openButton;
        if (dropDown)
            _dropDownController.dropDown = dropDown;    
    }
    
    //----------------------------------
    //  isDropDownOpen
    //----------------------------------
    
    /**
     *  @copy spark.components.supportClasses.DropDownController#isOpen
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function get isDropDownOpen():Boolean // not implemented
    {
        //if (dropDownController)
            //return dropDownController.isOpen;
        //else
            return false;
    }
        
	//----------------------------------
	//  closeDropDownOnResize
	//----------------------------------

    /**
     *  @private
     *
     *  cached value: getStyle("interactionMode") == InteractionMode.TOUCH
     */
    //private var isTouchInteractionMode:Boolean = false;

    /**
     *  @private
     *
     *  do not know what default value for closeDropDownOnResize will be until styles have been applied,
     *  but user may set property before that. this flag indicates whether property has been explicitly set,
     *  and so will not need to be determined from css when stylesInitialized() or styleChanged() is called.
     */
    private var isCloseDropDownOnResizeExplicitlySet:Boolean = false;

    /**
     *  @private
     */
     protected var _closeDropDownOnResize:Boolean = true;
	
    [Inspectable(category="General", enumeration="true,false", defaultValue="true")]
	
    /**
     *  When <code>true</code>, resizing the system manager
     *  closes the drop down.
     *  For mobile applications, this property is set
 	 *  to <code>false</code> so that the drop down stays open when the
     *  page orientation changes.
     *
 	 *  @default true
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function get closeDropDownOnResize():Boolean
	{
        return _closeDropDownOnResize;
    }

    /**
     *  @private
     */
    public function set closeDropDownOnResize(value:Boolean):void
	{
        setCloseDropDownOnResize(value, true);
    }
		
    /**
     *  @private
     */
     private function setCloseDropDownOnResize(value:Boolean, explicitlySet:Boolean):void
	{
        _closeDropDownOnResize = value;
        isCloseDropDownOnResizeExplicitlySet ||= explicitlySet;
        if (dropDownController)
            dropDownController.closeOnResize = _closeDropDownOnResize;
	}     

	//----------------------------------
    //  userProposedSelectedIndex
    //----------------------------------

    /**
     *  @private
     */
    private var _userProposedSelectedIndex:Number = NO_SELECTION;
    
    /**
     *  @private
     */
     mx_internal function set userProposedSelectedIndex(value:Number):void
    {
        _userProposedSelectedIndex = value;
    }
    
    /**
     *  @private
     */
     mx_internal function get userProposedSelectedIndex():Number
    {
        return _userProposedSelectedIndex;
    } 
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------
    
	/**
	 *  @private
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* override public function stylesInitialized():void
    {
        super.stylesInitialized();
        setInteractionMode();
    } */
	
    /**
     *  @private
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
	/* override public function styleChanged(styleProp:String):void
	{
        super.styleChanged(styleProp);
        if (!styleProp || styleProp == "styleName" || styleProp == "interactionMode")
            setInteractionMode();
    } */
		
    /**
     *  @private
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* private function setInteractionMode():void
    {
	    isTouchInteractionMode = getStyle("interactionMode") == InteractionMode.TOUCH;
        if (!isCloseDropDownOnResizeExplicitlySet)
            setCloseDropDownOnResize(!isTouchInteractionMode, false);
    } */
		
    /**
     *  @private
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* override public function setSelectedIndex(rowIndex:int, dispatchChangeEvent:Boolean = false, changeCaret:Boolean = true):void
    {
	    super.setSelectedIndex(rowIndex, dispatchChangeEvent, changeCaret);
	    if (isTouchInteractionMode)
	    {
            userProposedSelectedIndex = rowIndex;
            closeDropDown(true);
        }
    } */
		
		
    /**
     *  @private
     *  Called by the initialize() method of UIComponent
     *  to hook in the accessibility code.
     */ 
    /* override protected function initializeAccessibility():void
    {
        if (DropDownListBase.createAccessibilityImplementation != null)
            DropDownListBase.createAccessibilityImplementation(this);
    } */
    /**
     *  @private
     */ 
    /* override protected function commitProperties():void
    {
        super.commitProperties();
        
        if (labelChanged)
        {
            labelChanged = false;
            updateLabelDisplay();
        }
    } */
    
    /**
     *  @private
     */ 
    /* override protected function partAdded(partName:String, instance:Object):void
    {
        super.partAdded(partName, instance);
 
        if (instance == openButton)
        {
            if (dropDownController)
                dropDownController.openButton = openButton;
        }
        else if (instance == dropDown && dropDownController)
		{
            dropDownController.dropDown = dropDown;
		}
    } */
    
    /**
     *  @private
     */
    /* override protected function partRemoved(partName:String, instance:Object):void
    {
        if (dropDownController)
        {
            if (instance == openButton)
                dropDownController.openButton = null;
        
            if (instance == dropDown)
                dropDownController.dropDown = null;
        }

        super.partRemoved(partName, instance);
    } */
    
    /**
     *  @private
     */ 
    /* override protected function getCurrentSkinState():String
    {
        return !enabled ? "disabled" : isDropDownOpen ? "open" : "normal";
    }  */  
       
    /**
     *  @private
     */ 
    /* override protected function commitSelection(dispatchChangedEvents:Boolean = true):Boolean
    {
        var retVal:Boolean = super.commitSelection(dispatchChangedEvents);
        updateLabelDisplay();
        return retVal; 
    } */
    
    /**
     *  @private
     *  In updateRenderer, we want to select the proposedSelectedIndex
     */
    /* override mx_internal function isItemIndexSelected(index:int):Boolean
    {
        return userProposedSelectedIndex == index;
    } */
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------   

    /**
     *  Open the drop-down list and dispatch 
     *  a <code>DropdownEvent.OPEN</code> event.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */ 
    public function openDropDown():void
    {
        dropDownController.openDropDown();
    }
    
    /**
     *  Close the drop-down list and dispatch a <code>DropDownEvent.CLOSE</code> event. 
     *   
     *  @param commit If <code>true</code>, commit the selected
     *  data item. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function closeDropDown(commit:Boolean):void
    {
        dropDownController.closeDropDown(commit);
    }
    
    /**
     *  @private
     *  Called whenever we need to update the text passed to the labelDisplay skin part
     */
    // TODO (jszeto): Make this protected and make the name more generic (passing data to skin) 
    mx_internal function updateLabelDisplay(displayItem:* = undefined):void
    {
        // DropDownList and ComboBox will override this function
    }
    
    /**
     *  @private
     *  Called whenever we need to change the highlighted selection while the dropDown is open
     *  ComboBox overrides this behavior
     */
    /* mx_internal function changeHighlightedSelection(newIndex:int, scrollToTop:Boolean = false):void
    {
        // Store the selection in userProposedSelectedIndex because we 
        // don't want to update selectedIndex until the dropdown closes
        itemSelected(userProposedSelectedIndex, false);
        userProposedSelectedIndex = newIndex;
        itemSelected(userProposedSelectedIndex, true);
        
        positionIndexInView(userProposedSelectedIndex, scrollToTop ? 0 : NaN);
        
        var e:IndexChangeEvent = new IndexChangeEvent(IndexChangeEvent.CARET_CHANGE); 
        e.oldIndex = caretIndex;
        setCurrentCaretIndex(userProposedSelectedIndex);
        e.newIndex = caretIndex;
        dispatchEvent(e);
    } */
    
    /**
     *  @private 
     */ 
    mx_internal function positionIndexInView(index:int, topOffset:Number = NaN, 
                                             bottomOffset:Number = NaN, 
                                             leftOffset:Number = NaN,
                                             rightOffset:Number = NaN):void
    {
        if (!layout || dataGroup == null)
            return;
        
        var spDelta:Point = 
            dataGroup.layout.getScrollPositionDeltaToElementHelper(index, topOffset, bottomOffset,
                                                                   leftOffset, rightOffset);
        
        if (spDelta)
        {
            dataGroup.horizontalScrollPosition += spDelta.x;
            dataGroup.verticalScrollPosition += spDelta.y;
        }
    }
          
    /**
     *  @private
     */ 
    /* override mx_internal function findKey(eventCode:int):Boolean
    {
        if (!dataProvider || dataProvider.length == 0)
            return false;
        
        if (eventCode >= 33 && eventCode <= 126)
        {
            var matchingIndex:Number;
            var keyString:String = String.fromCharCode(eventCode);
            var startIndex:int = isDropDownOpen ? userProposedSelectedIndex  + 1 : selectedIndex + 1;
            startIndex = Math.max(0, startIndex);
            
            matchingIndex = findStringLoop(keyString, startIndex, dataProvider.length); 
            
            // We didn't find the item, loop back to the top 
            if (matchingIndex == -1)
            {
                matchingIndex = findStringLoop(keyString, 0,  startIndex); 
            }
            
            
            if (matchingIndex != -1)
            {
                if (isDropDownOpen)
                    changeHighlightedSelection(matchingIndex);
                else
                    setSelectedIndex(matchingIndex, true); 
                
                return true;
            }
        }
        
        return false;
    }
     */
    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------   

    /**
     *  @private
     */ 
    /* override protected function dataProvider_collectionChangeHandler(event:Event):void
    {       
        super.dataProvider_collectionChangeHandler(event);
        
        if (event is CollectionEvent)
        {
            labelChanged = true;
            invalidateProperties();         
        }
    } */
       
    /**
     *  @private
     */
    /* override protected function item_mouseDownHandler(event:MouseEvent):void
    {
        super.item_mouseDownHandler(event);
        if (!isTouchInteractionMode)
	    {
            userProposedSelectedIndex = selectedIndex;
            closeDropDown(true);
        }
    } */
            
    /**
     *  @private
     */
    /* override protected function keyDownHandler(event:KeyboardEvent) : void
    {
        if (!enabled)
            return; 
                
        if (!dropDownController.processKeyDown(event))
        {
            // If rtl layout, need to swap Keyboard.LEFT and Keyboard.RIGHT.
            var navigationUnit:uint = mapKeycodeForLayoutDirection(event);
                                    
            if (findKey(event.charCode))
            {
                event.preventDefault();
                return;
            }
            
            if (!NavigationUnit.isNavigationUnit(navigationUnit))
                return;
            
            var proposedNewIndex:int = NO_SELECTION;
            var currentIndex:int;
                        
            if (isDropDownOpen && layout)
            {   
                // Normalize the proposed index for getNavigationDestinationIndex
                currentIndex = userProposedSelectedIndex < NO_SELECTION ? NO_SELECTION : userProposedSelectedIndex;
                proposedNewIndex = layout.getNavigationDestinationIndex(currentIndex, navigationUnit, arrowKeysWrapFocus);
                
                if (proposedNewIndex != NO_SELECTION)
                {
                    changeHighlightedSelection(proposedNewIndex);
                    event.preventDefault();
                }
            }
            else if (dataProvider)
            {
                var maxIndex:int = dataProvider.length - 1;
                
                // Normalize the proposed index for getNavigationDestinationIndex
                currentIndex = caretIndex < NO_SELECTION ? NO_SELECTION : caretIndex;
                
                switch (navigationUnit)
                {
                    case NavigationUnit.UP:
                    {
                        if (arrowKeysWrapFocus && 
                            (currentIndex == 0 || 
                             currentIndex == NO_SELECTION || 
                             currentIndex == CUSTOM_SELECTED_ITEM))
                            proposedNewIndex = maxIndex;
                        else
                            proposedNewIndex = currentIndex - 1;  
                        event.preventDefault();
                        break;
                    }                      
        
                    case NavigationUnit.DOWN:
                    {
                        if (arrowKeysWrapFocus && 
                            (currentIndex == maxIndex || 
                             currentIndex == NO_SELECTION || 
                             currentIndex == CUSTOM_SELECTED_ITEM))
                            proposedNewIndex = 0;
                        else
                            proposedNewIndex = currentIndex + 1;  
                        event.preventDefault();
                        break;
                    }
                        
                    case NavigationUnit.PAGE_UP:
                    {
                        proposedNewIndex = currentIndex == NO_SELECTION ? 
                            NO_SELECTION : Math.max(currentIndex - PAGE_SIZE, 0);
                        event.preventDefault();
                        break;
                    }
                        
                    case NavigationUnit.PAGE_DOWN:
                    {    
                        proposedNewIndex = currentIndex == NO_SELECTION ?
                                           PAGE_SIZE : (currentIndex + PAGE_SIZE);
                        event.preventDefault();
                        break;
                    }
                       
                    case NavigationUnit.HOME:
                    {
                        proposedNewIndex = 0;
                        event.preventDefault();
                        break;
                    }

                    case NavigationUnit.END:
                    {
                        proposedNewIndex = maxIndex;  
                        event.preventDefault();
                        break;
                    }  
                       
                }
                
                proposedNewIndex = Math.min(proposedNewIndex, maxIndex);
                
                if (proposedNewIndex >= 0)
                {
                    userProposedSelectedIndex = proposedNewIndex;
                    setSelectedIndex(proposedNewIndex, true);
                }
            }
        }
        else
        {
            event.preventDefault();
        }
    }
     */
    /**
     *  @private
     */
    /* override protected function focusOutHandler(event:FocusEvent):void
    {
        if (isOurFocus(DisplayObject(event.target)))
            dropDownController.processFocusOut(event);

        super.focusOutHandler(event);
    } */
        
    /**
     *  @private
     *  Event handler for the <code>dropDownController</code> 
     *  <code>DropDownEvent.OPEN</code> event. Updates the skin's state and 
     *  ensures that the selectedItem is visible. 
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
     mx_internal function dropDownController_openHandler(event:DropDownEvent):void
    {
        addEventListener(FlexEvent.UPDATE_COMPLETE, open_updateCompleteHandler);
        userProposedSelectedIndex = selectedIndex;
        invalidateSkinState();  
    }
    
    /**
     *  @private
     */
    mx_internal function open_updateCompleteHandler(event:FlexEvent):void
    {   
        removeEventListener(FlexEvent.UPDATE_COMPLETE, open_updateCompleteHandler);
        positionIndexInView(selectedIndex, 0);
        
        dispatchEvent(new DropDownEvent(DropDownEvent.OPEN));
    }
    
    /**
     *  @private
     *  Event handler for the <code>dropDownController</code> 
     *  <code>DropDownEvent.CLOSE</code> event. Updates the skin's state.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    protected function dropDownController_closeHandler(event:DropDownEvent):void
    {
        addEventListener(FlexEvent.UPDATE_COMPLETE, close_updateCompleteHandler);
        invalidateSkinState();
        
        if (!event.isDefaultPrevented())
        {
            // Even if the dropDown was programmatically closed, assume the selection 
            // changed as a result of a previous user interaction
           // setSelectedIndex(userProposedSelectedIndex, true);  
        }
        /* else
        {
            changeHighlightedSelection(selectedIndex);
        } */
    }

    /**
     *  @private
     */
    private function close_updateCompleteHandler(event:FlexEvent):void
    {   
        removeEventListener(FlexEvent.UPDATE_COMPLETE, close_updateCompleteHandler);
        
        dispatchEvent(new DropDownEvent(DropDownEvent.CLOSE));
    }
}

}
