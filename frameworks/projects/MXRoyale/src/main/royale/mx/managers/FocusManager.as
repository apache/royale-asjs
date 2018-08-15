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

package mx.managers
{

COMPILE::SWF
{
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.system.Capabilities;
import flash.system.IME;
import flash.text.TextField;
import flash.ui.Keyboard;
}

//import mx.core.IButton;
import mx.core.IChildList;
import mx.core.IUIComponent;
import mx.core.mx_internal;
import mx.events.FlexEvent;
//import mx.utils.Platform;

use namespace mx_internal;

import org.apache.royale.events.EventDispatcher;
import org.apache.royale.events.MouseEvent;
import mx.core.UIComponent;

/**
 *  The FocusManager class manages the focus on components in response to mouse
 *  activity or keyboard activity (Tab key).  There can be several FocusManager
 *  instances in an application.  Each FocusManager instance 
 *  is responsible for a set of components that comprise a "tab loop".  If you
 *  hit Tab enough times, focus traverses through a set of components and
 *  eventually get back to the first component that had focus.  That is a "tab loop"
 *  and a FocusManager instance manages that loop.  If there are popup windows
 *  with their own set of components in a "tab loop" those popup windows will have
 *  their own FocusManager instances.  The main application always has a
 *  FocusManager instance.
 *
 *  <p>The FocusManager manages focus from the "component level".
 *  In Flex, a UITextField in a component is the only way to allow keyboard entry
 *  of text. To the Flash Player or AIR, that UITextField has focus. However, from the 
 *  FocusManager's perspective the component that parents the UITextField has focus.
 *  Thus there is a distinction between component-level focus and player-level focus.
 *  Application developers generally only have to deal with component-level focus while
 *  component developers must understand player-level focus.</p>
 *
 *  <p>All components that can be managed by the FocusManager must implement
 *  mx.managers.IFocusManagerComponent, whereas objects managed by player-level focus do not.</p>  
 *
 *  <p>The FocusManager also managers the concept of a defaultButton, which is
 *  the Button on a form that dispatches a click event when the Enter key is pressed
 *  depending on where focus is at that time.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
COMPILE::SWF
public class FocusManager extends EventDispatcher implements IFocusManager
{

	//--------------------------------------------------------------------------
	//
	//  Class constants
	//
	//--------------------------------------------------------------------------

	/**
	 * @private
	 * 
	 * Default value of parameter, ignore. 
	 */
	private static const FROM_INDEX_UNSPECIFIED:int = -2;
	
	//--------------------------------------------------------------------------
	//
	//  Class variables
	//
	//--------------------------------------------------------------------------

	/**
	 * @private
	 * 
	 * Place to hook in additional classes
	 */
	public static var mixins:Array;

    // flag to turn on/off some ie specific behavior
    mx_internal static var ieshifttab:Boolean = true;

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  <p>A FocusManager manages the focus within the children of an IFocusManagerContainer.
     *  It installs itself in the IFocusManagerContainer during execution
     *  of the constructor.</p>
     *
     *  @param container An IFocusManagerContainer that hosts the FocusManager.
     *
     *  @param popup If <code>true</code>, indicates that the container
     *  is a popup component and not the main application.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function FocusManager(container:IFocusManagerContainer, popup:Boolean = false)
    {
        super();

		this.popup = popup;

        IMEEnabled = true;
        
        /*
		// Only <= IE8 supported focus cycling out of the SWF
        browserMode = Capabilities.playerType == "ActiveX" && !popup;
        desktopMode = Platform.isAir && !popup;
        // Flash main windows come up activated, AIR main windows don't
        windowActivated = !desktopMode;
        */
        
        container.focusManager = this; // this property name is reserved in the parent

        // trace("FocusManager constructor " + container + ".focusManager");
        
        _form = container;
        
        focusableObjects = [];

        focusPane = new Sprite();
        focusPane.name = "focusPane";

        addFocusables(DisplayObject(container));
        
        // Listen to the stage so we know when the root application is loaded.
        container.addEventListener(Event.ADDED, addedHandler);
        container.addEventListener(Event.REMOVED, removedHandler);
        container.addEventListener(FlexEvent.SHOW, showHandler);
        container.addEventListener(FlexEvent.HIDE, hideHandler);
        container.addEventListener(FlexEvent.HIDE, childHideHandler, true);
        container.addEventListener("_navigationChange_",viewHideHandler, true);
        
        /*
        //special case application and window
        if (container.systemManager is SystemManager)
        {
            // special case application.  It shouldn't need to be made
            // active and because we defer appCreationComplete, this 
            // would steal focus back from any popups created during
            // instantiation
            if (container != SystemManager(container.systemManager).application)
                container.addEventListener(FlexEvent.CREATION_COMPLETE,
                                       creationCompleteHandler);
        }
        */
        
		if (mixins)
		{
			var n:int = mixins.length;
			for (var i:int = 0; i < n; i++)
			{
				new mixins[i](this);
			}
		}

        // Make sure the SystemManager is running so it can tell us about
        // mouse clicks and stage size changes.
		try
		{
            /*
			var awm:IActiveWindowManager = 
				IActiveWindowManager(container.systemManager.getImplementation("mx.managers::IActiveWindowManager"));
			if (awm)
        		awm.addFocusManager(container); // build a message that does the equal
            */
            if (hasEventListener("initialize"))
		    	dispatchEvent(new Event("initialize"));

		}
		catch (e:Error)
		{
			// ignore null pointer errors caused by container using a 
			// systemManager from another sandbox.
		}
        
        // may need to remove this and use ActiveWindowManager
        activate();
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var LARGE_TAB_INDEX:int = 99999;

    mx_internal var calculateCandidates:Boolean = true;

	/**
	 * @private
	 * 
	 * True if this focus manager is a popup, false if it is a main application.
	 * 
	 */
	mx_internal var popup:Boolean;

    /**
     * @private
     * 
     * True if this focus manager will try to enable/disable the IME based on
     * whether the focused control uses IME.  Leaving this as a backdoor just in case.
     * 
     */
    mx_internal var IMEEnabled:Boolean;

    /**
     *  @private
     *  We track whether we've been last activated or saw a TAB
     *  This is used in browser tab management
     */
    mx_internal var lastAction:String;

    /**
     *  @private
     *  Tab management changes based on whether were in a browser or not
     *  This value is also affected by whether you are a modal dialog or not
     */
    public var browserMode:Boolean;

    /**
     *  @private
     *  Activation changes depending on whether we're running in AIR or not
     */
    public var desktopMode:Boolean;

    /**
     *  @private
     *  Tab management changes based on whether were in a browser or not
     *  If non-null, this is the object that will
     *  lose focus to the browser
     */
    private var browserFocusComponent:InteractiveObject;

    /**
     *  @private
     *  Total set of all objects that can receive focus
     *  but might be disabled or invisible.
     */
    mx_internal var focusableObjects:Array;
    
    /**
     *  @private
     *  Filtered set of objects that can receive focus right now.
     */
    private var focusableCandidates:Array;

    /**
     *  @private
     */
    private var activated:Boolean;
    /**
     *  @private
     */
    private var windowActivated:Boolean;
    
    /**
     * 	@private
     * 
     * 	true if focus was changed to one of focusable objects. False if focus passed to 
     * 	the browser.
     */
	mx_internal var focusChanged:Boolean;

    /**
	 * 	@private
	 * 
	 * 	if non-null, the location to move focus from instead of the object 
	 *  that has focus in the stage.
	 */
	mx_internal var fauxFocus:DisplayObject;
	 
	 
	//--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  showFocusIndicator
    //----------------------------------

    /**
     *  @private
     *  Storage for the showFocusIndicator property.
     */
    mx_internal var _showFocusIndicator:Boolean = false;
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get showFocusIndicator():Boolean
    {
        return _showFocusIndicator;
    }
    
    /**
     *  @private
     */
    public function set showFocusIndicator(value:Boolean):void
    {
        var changed:Boolean = _showFocusIndicator != value;
        // trace("FM " + this + " showFocusIndicator = " + value);
        _showFocusIndicator = value;

        if (hasEventListener("showFocusIndicator"))
            dispatchEvent(new Event("showFocusIndicator"));
    }

    //----------------------------------
    //  defaultButton
    //----------------------------------

    /**
     *  @private
     *  The current default button.
     */
    //private var defButton:IButton;

    /**
     *  @private
     */
    //private var _defaultButton:IButton;

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    //public function get defaultButton():IButton
    //{
	//	return _defaultButton;
    //}

    /**
     *  @private
     *  We don't type the value as Button for dependency reasons
    public function set defaultButton(value:IButton):void
    {
		var button:IButton = value ? IButton(value) : null;

        if (button != _defaultButton)
        {
            if (_defaultButton)
                _defaultButton.emphasized = false;
            
            if (defButton)  
                defButton.emphasized = false;
            
            _defaultButton = button;
            
            if (defButton != _lastFocus || _lastFocus == _defaultButton)
            {
            	defButton = button;
            
           		if (button)
                	button.emphasized = true;
        	}
    	}
    }
     */

    //----------------------------------
    //  defaultButtonEnabled
    //----------------------------------

    /**
     *  @private
     *  Storage for the defaultButtonEnabled property.
     */
    //private var _defaultButtonEnabled:Boolean = true;

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
    public function get defaultButtonEnabled():Boolean
    {
        return _defaultButtonEnabled;
    }
     */
    
    /**
     *  @private
    public function set defaultButtonEnabled(value:Boolean):void
    {
        _defaultButtonEnabled = value;
        
        // Synchronize with the new value. We ensure that our 
        // default button is de-emphasized if defaultButtonEnabled
        // is false.
        if (defButton)
            defButton.emphasized = value;
    }
     */
    
    //----------------------------------
    //  focusPane
    //----------------------------------

    /**
     *  @private
     *  Storage for the focusPane property.
     */
    private var _focusPane:Sprite;

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get focusPane():Sprite
    {
        return _focusPane;
    }

    /**
     *  @private
     */
    public function set focusPane(value:Sprite):void
    {
        _focusPane = value;
    }

    //----------------------------------
    //  form
    //----------------------------------

    /**
     *  @private
     *  Storage for the form property.
     */
    private var _form:IFocusManagerContainer;
    
    /**
     *  @private
     *  The form is the property where we store the IFocusManagerContainer
     *  that hosts this FocusManager.
     */
    mx_internal function get form():IFocusManagerContainer
    {
        return _form;
    }
    
    /**
     *  @private
     */
    mx_internal function set form (value:IFocusManagerContainer):void
    {
        _form = value;
    }


    //----------------------------------
    //  _lastFocus
    //----------------------------------
    
    /**
     *  @private
     *  the object that last had focus
     */
    private var _lastFocus:IFocusManagerComponent;


	/**
	 * 	@private
	 */
	mx_internal function get lastFocus():IFocusManagerComponent
	{
		return _lastFocus;
	}
	 
	/**
	 * 	@private
	 */
	mx_internal function set lastFocus(value:IFocusManagerComponent):void
	{
		_lastFocus = value;
	}

    //----------------------------------
    //  nextTabIndex
    //----------------------------------

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get nextTabIndex():int
    {
        return getMaxTabIndex() + 1;
    }

    /**
     *  Gets the highest tab index currently used in this Focus Manager's form or subform.
     *
     *  @return Highest tab index currently used.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private function getMaxTabIndex():int
    {
        var z:Number = 0;

        var n:int = focusableObjects.length;
        for (var i:int = 0; i < n; i++)
        {
            var t:Number = focusableObjects[i].tabIndex;
            if (!isNaN(t))
                z = Math.max(z, t);
        }
        
        return z;
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getFocus():IFocusManagerComponent
    {
        var stage:Stage = Sprite(form)./*systemManager.*/stage;
        
        if (!stage)
            return null;
            
        var o:InteractiveObject = stage.focus;
        
        // If a Stage* object (such as StageText or StageWebView) has focus,
        // stage.focus will be set to null. Much of the focus framework is not
        // set up to handle this. So, if stage.focus is null, we return the last
        // IFocusManagerComponent that had focus.  In ADL, focus works slightly
        // different than it does on device when using StageText.  In ADL, when
        // the focus is a StageText component, a TextField whose parent is the 
        // stage is assigned focus.  
        if ((!o && _lastFocus) || (o is TextField && o.parent == stage))
            return _lastFocus;
        
        return findFocusManagerComponent(o);
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function setFocus(o:IFocusManagerComponent):void
    {
        // trace("FM " + this + " setting focus to " + o);

        o.setFocus();
        
        if (hasEventListener("setFocus"))
    		dispatchEvent(new Event("setFocus"));
        // trace("FM set focus");
    }

    /**
     *  @private
     */
    private function focusInHandler(event:FocusEvent):void
    {
        var target:InteractiveObject = InteractiveObject(event.target);
        // trace("FocusManager focusInHandler in  = " + this._form.systemManager.loaderInfo.url);
        // trace("FM " + this + " focusInHandler " + target);

		// dispatch cancelable FocusIn to see if Marshal Plan mixin wants it
        if (hasEventListener(FocusEvent.FOCUS_IN))
    		if (!dispatchEvent(new FocusEvent(FocusEvent.FOCUS_IN, false, true, target)))
    			return;

        if (isParent(DisplayObjectContainer(form), target))
        {
            /*
            if (_defaultButton)
            {
                if (target is IButton && target != _defaultButton 
                    && !(target is IToggleButton))
                    _defaultButton.emphasized = false;
                else if (_defaultButtonEnabled)
                    _defaultButton.emphasized = true;
            }
            */
            
            // trace("FM " + this + " setting last focus " + target);
            _lastFocus = findFocusManagerComponent(InteractiveObject(target));
            
            /*
			if (Capabilities.hasIME)
            {
                var usesIME:Boolean;
                if (_lastFocus is IIMESupport)
                {
                    var imeFocus:IIMESupport = IIMESupport(_lastFocus);
                    if (imeFocus.enableIME)
                        usesIME = true;
                }
                if (IMEEnabled)
                    IME.enabled = usesIME;
            }
            */
            
            /*
			// handle default button here
			// we can't check for Button because of cross-versioning so
			// for now we just check for an emphasized property
            if (_lastFocus is IButton && !(_lastFocus is IToggleButton))
			{
                defButton = _lastFocus as IButton;
			}
			else
			{
				// restore the default button to be the original one
				if (defButton && defButton != _defaultButton)
					defButton = _defaultButton;
			}
            */
		}
	}

    /**
     *  @private  Useful for debugging
     */
    private function focusOutHandler(event:FocusEvent):void
    {
        var target:InteractiveObject = InteractiveObject(event.target);
        // trace("FocusManager focusOutHandler in  = " + this._form.systemManager.loaderInfo.url);
        // trace("FM " + this + " focusOutHandler " + target);
    }

    /**
     *  @private
     *  restore focus to whoever had it last
     */
    private function activateHandler(event:Event):void
    {
//        var target:InteractiveObject = InteractiveObject(event.target);
        // trace("FM " + this + " activateHandler ", _lastFocus);
		
        // if we were the active FM when we were deactivated
        // and we're not running in AIR, then dispatch the event now
        // otherwise wait for the AIR events to fire
        if (activated && !desktopMode)
        {
            dispatchEvent(new FlexEvent(FlexEvent.FLEX_WINDOW_ACTIVATE));
		    // restore focus if this focus manager had last focus
            if (_lastFocus && (!browserMode || ieshifttab))
	    	    _lastFocus.setFocus();
	        lastAction = "ACTIVATE";
        }
    }

    /**
     *  @private  
     *  Dispatch event if we're not running in AIR.  AIR will
     *  dispatch windowDeactivate that we respond to instead
     */
    private function deactivateHandler(event:Event):void
    {
        // var target:InteractiveObject = InteractiveObject(event.target);
        // trace("FM " + this + " deactivateHandler ", _lastFocus);

        // if we are the active FM when we were deactivated
        // and we're not running in AIR, then dispatch the event now
        // otherwise wait for the AIR events to fire
        if (activated && !desktopMode)
        {
            dispatchEvent(new FlexEvent(FlexEvent.FLEX_WINDOW_DEACTIVATE));
        }
    }

    /**
     *  @private
     *  restore focus to whoever had it last
     */
    private function activateWindowHandler(event:Event):void
    {
//        var target:InteractiveObject = InteractiveObject(event.target);
        // trace("FM " + this + " activateWindowHandler ", _lastFocus);
		
        windowActivated = true;

        if (activated)
        {
            dispatchEvent(new FlexEvent(FlexEvent.FLEX_WINDOW_ACTIVATE));
		    // restore focus if this focus manager had last focus
	        if (_lastFocus && !browserMode)
	    	    _lastFocus.setFocus();
	        lastAction = "ACTIVATE";
        }
    }

    /**
     *  @private  
     *  If we're responsible for the focused control, remove focus from it
     *  so it gets the same events as it would if the whole app lost focus
     */
    private function deactivateWindowHandler(event:Event):void
    {
        // var target:InteractiveObject = InteractiveObject(event.target);
        // trace("FM " + this + " deactivateWindowHandler ", _lastFocus);

        /*
        windowActivated = false;

        if (activated)
        {
            dispatchEvent(new FlexEvent(FlexEvent.FLEX_WINDOW_DEACTIVATE));
            if (form.systemManager.stage)
                form.systemManager.stage.focus = null;
        }
        */
    }   

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function showFocus():void
    {
        /*
        if (!showFocusIndicator)
        {
            showFocusIndicator = true;
            if (_lastFocus)
                _lastFocus.drawFocus(true);
        }
        */
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function hideFocus():void
    {
        // trace("FOcusManger " + this + " Hide Focus");
        /*
        if (showFocusIndicator)
        {
            showFocusIndicator = false;
            if (_lastFocus)
                _lastFocus.drawFocus(false);
        }
        */
        // trace("END FOcusManger Hide Focus");
    }
    
    /**
     *  The SystemManager activates and deactivates a FocusManager
     *  if more than one IFocusManagerContainer is visible at the same time.
     *  If the mouse is clicked in an IFocusManagerContainer with a deactivated
     *  FocusManager, the SystemManager will call 
     *  the <code>activate()</code> method on that FocusManager.
     *  The FocusManager that was activated will have its <code>deactivate()</code> method
     *  called prior to the activation of another FocusManager.
     *
     *  <p>The FocusManager adds event handlers that allow it to monitor
     *  focus related keyboard and mouse activity.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function activate():void
    {
        // we can get a double activation if we're popping up and becoming visible
        // like the second time a menu appears
        if (activated)
        {
        	// trace("FocusManager is already active " + this);
            return;
        }

        // trace("FocusManager activating = " + this._form.systemManager.loaderInfo.url);
        // trace("FocusManager activating " + this);

        // listen for focus changes, use weak references for the stage
		// form.systemManager can be null if the form is created in a sandbox and 
		// added as a child to the root system manager.
		var sm:ISystemManager = form.systemManager;
		if (sm)
		{
            /*
			if (sm.isTopLevelRoot())
			{
		        sm.stage.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, mouseFocusChangeHandler, false, 0, true);
		        sm.stage.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, keyFocusChangeHandler, false, 0, true);
	    	    sm.stage.addEventListener(Event.ACTIVATE, activateHandler, false, 0, true);
	        	sm.stage.addEventListener(Event.DEACTIVATE, deactivateHandler, false, 0, true);
	  		}
	  		else
	  		{
            */
		        sm.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, mouseFocusChangeHandler, false, 0, true);
		        sm.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, keyFocusChangeHandler, false, 0, true);
	    	    sm.addEventListener(Event.ACTIVATE, activateHandler, false, 0, true);
	        	sm.addEventListener(Event.DEACTIVATE, deactivateHandler, false, 0, true);	  			
	  		//}
		}      
	        
        form.addEventListener(FocusEvent.FOCUS_IN, focusInHandler, true);
        form.addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler, true);
        form.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler); 
        form.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownCaptureHandler, true); 
        //form.addEventListener(KeyboardEvent.KEY_DOWN, defaultButtonKeyHandler);
        form.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, true);
        if (sm)
        {
            // AIR Window events, but don't want to link in AIREvent
            // use capture phase because these get sent by the main Window
            // and we might be managing a popup in that window
            sm.addEventListener("windowActivate", activateWindowHandler, true, 0, true);
            sm.addEventListener("windowDeactivate", deactivateWindowHandler, true, 0, true);
        }

        activated = true;
        dispatchEvent(new FlexEvent(FlexEvent.FLEX_WINDOW_ACTIVATE));
        
        // Restore focus to the last control that had it if there was one.
        if (_lastFocus)
            setFocus(_lastFocus);

        if (hasEventListener("activateFM"))
    		dispatchEvent(new Event("activateFM"));

    }

    /**
     *  The SystemManager activates and deactivates a FocusManager
     *  if more than one IFocusManagerContainer is visible at the same time.
     *  If the mouse is clicked in an IFocusManagerContainer with a deactivated
     *  FocusManager, the SystemManager will call 
     *  the <code>activate()</code> method on that FocusManager.
     *  The FocusManager that was activated will have its <code>deactivate()</code> method
     *  called prior to the activation of another FocusManager.
     *
     *  <p>The FocusManager removes event handlers that allow it to monitor
     *  focus related keyboard and mouse activity.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function deactivate():void
    {
        // trace("FocusManager deactivating " + this);
        // trace("FocusManager deactivating = " + this._form.systemManager.loaderInfo.url);
         
        // listen for focus changes
		var sm:ISystemManager = form.systemManager;
        if (sm)
        {
            /*
			if (sm.isTopLevelRoot())
			{
		        sm.stage.removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, mouseFocusChangeHandler);
		        sm.stage.removeEventListener(FocusEvent.KEY_FOCUS_CHANGE, keyFocusChangeHandler);
	    	    sm.stage.removeEventListener(Event.ACTIVATE, activateHandler);
	        	sm.stage.removeEventListener(Event.DEACTIVATE, deactivateHandler);
	  		}
	  		else
	  		{
            */
		        sm.removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, mouseFocusChangeHandler);
		        sm.removeEventListener(FocusEvent.KEY_FOCUS_CHANGE, keyFocusChangeHandler);
	    	    sm.removeEventListener(Event.ACTIVATE, activateHandler);
	        	sm.removeEventListener(Event.DEACTIVATE, deactivateHandler);	  			
	  		//}
        }

        form.removeEventListener(FocusEvent.FOCUS_IN, focusInHandler, true);
        form.removeEventListener(FocusEvent.FOCUS_OUT, focusOutHandler, true);
        form.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler); 
        form.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownCaptureHandler, true); 
        //form.removeEventListener(KeyboardEvent.KEY_DOWN, defaultButtonKeyHandler);
        // stop listening for default button in Capture phase
        form.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, true);

        activated = false;
        dispatchEvent(new FlexEvent(FlexEvent.FLEX_WINDOW_DEACTIVATE));

        if (hasEventListener("deactivateFM"))
    		dispatchEvent(new Event("deactivateFM"));
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function findFocusManagerComponent(
                            o:InteractiveObject):IFocusManagerComponent
    {
    	return findFocusManagerComponent2(o) as IFocusManagerComponent;
    }
    
    
    /**
    * @private
    * 
    * This version of the method differs from the old one to support SWFLoader
    * being in the focusableObjects list but not being a component that
    * gets focus. SWFLoader is in the list of focusable objects so
    * focus may be passed over a bridge to the components on the other
    * side of the bridge.
    */
    private function findFocusManagerComponent2(
                            o:InteractiveObject):DisplayObject

    {
    	try
    	{
	        while (o)
	        {
	            if ((o is IFocusManagerComponent && IFocusManagerComponent(o).focusEnabled) /*||
	            	 o is ISWFLoader*/)
	                return o;
	            
	            o = o.parent;
	        }
	    }
	    catch (error:SecurityError)
	    {
	    	// can happen in a loaded child swf
	    	// trace("findFocusManagerComponent: handling security error");
	    }

        // tab was set somewhere else
        return null;
    }

    /**
     *  @private
     *  Returns true if p is a parent of o.
     */
    private function isParent(p:DisplayObjectContainer, o:DisplayObject):Boolean
    {
        if (p == o)
            return false;
        
        //if (p is IRawChildrenContainer)
        //    return IRawChildrenContainer(p).rawChildren.contains(o);
        
        return p.contains(o);
    }
    
    private function isEnabledAndVisible(o:DisplayObject):Boolean
    {
        var formParent:DisplayObjectContainer = DisplayObjectContainer(form);
        
        while (o != formParent)
        {
            if (o is IUIComponent)
                if (!IUIComponent(o).enabled)
                    return false;
            
            /*
            if (o is IVisualElement)
                if (IVisualElement(o).designLayer && !IVisualElement(o).designLayer.effectiveVisibility)
                    return false;
            */
            
            if (!o.visible) 
                return false;
            o = o.parent;

            // if no parent, then not on display list
            if (!o)
                return false;
        }
        return true;
    }

    /**
     *  @private
     */
    private function sortByTabIndex(a:InteractiveObject, b:InteractiveObject):int
    {
        var aa:int = a.tabIndex;
        var bb:int = b.tabIndex;

        if (aa == -1)
            aa = int.MAX_VALUE;
        if (bb == -1)
            bb = int.MAX_VALUE;

        return (aa > bb ? 1 :
                aa < bb ? -1 : sortByDepth(DisplayObject(a), DisplayObject(b)));
    }

    /**
     *  @private
     */
    private function sortFocusableObjectsTabIndex():void
    {
        // trace("FocusableObjectsTabIndex");
        
        focusableCandidates = [];
        
        var n:int = focusableObjects.length;
        for (var i:int = 0; i < n; i++)
        {
            var c:IFocusManagerComponent = focusableObjects[i] as IFocusManagerComponent;
            if ((c && c.tabIndex && !isNaN(Number(c.tabIndex))) /*||
                 focusableObjects[i] is ISWFLoader*/)
            {
                // if we get here, it is a candidate
                focusableCandidates.push(focusableObjects[i]);
            }
        }
        
        focusableCandidates.sort(sortByTabIndex);
    }

    /**
     *  @private
     */
    private function sortByDepth(aa:DisplayObject, bb:DisplayObject):Number
    {
        var val1:String = "";
        var val2:String = "";
        var index:int;
        var tmp:String;
        var tmp2:String;
        var zeros:String = "0000";

        var a:DisplayObject = DisplayObject(aa);
        var b:DisplayObject = DisplayObject(bb);

		// TODO (egreenfi):  If a component lives inside of a group, we care about not its display object index, but
		// its index within the group. See SDK-25144
		
        while (a != DisplayObject(form) && a.parent)
        {
            index = getChildIndex(a.parent, a);
            tmp = index.toString(16);
            if (tmp.length < 4)
            {
                tmp2 = zeros.substring(0, 4 - tmp.length) + tmp;
            }
            val1 = tmp2 + val1;
            a = a.parent;
        }
        
        while (b != DisplayObject(form) && b.parent)
        {
            index = getChildIndex(b.parent, b);
            tmp = index.toString(16);
            if (tmp.length < 4)
            {
                tmp2 = zeros.substring(0, 4 - tmp.length) + tmp;
            }
            val2 = tmp2 + val2;
            b = b.parent;
        }

        return val1 > val2 ? 1 : val1 < val2 ? -1 : 0;
    }

    private function getChildIndex(parent:DisplayObjectContainer, child:DisplayObject):int
    {
        try 
        {
            return parent.getChildIndex(child);
        }
        catch(e:Error)
        {
            //if (parent is IRawChildrenContainer)
           //     return IRawChildrenContainer(parent).rawChildren.getChildIndex(child);
            throw e;
        }
        throw new Error("FocusManager.getChildIndex failed");   // shouldn't ever get here
    }

    /**
     *  @private
     *  Calculate what focusableObjects are valid tab candidates.
     */
    private function sortFocusableObjects():void
    {
        // trace("FocusableObjects " + focusableObjects.length.toString());
        focusableCandidates = [];
        
        var n:int = focusableObjects.length;
        for (var i:int = 0; i < n; i++)
        {
            var c:InteractiveObject = focusableObjects[i];
            // trace("  " + c);
            if (c.tabIndex && !isNaN(Number(c.tabIndex)) && c.tabIndex > 0)
            {
                sortFocusableObjectsTabIndex();
                return;
            }
            focusableCandidates.push(c);
        }
        
        focusableCandidates.sort(sortByDepth);
    }

    /**
     *  Call this method to make the system
     *  think the Enter key was pressed and the defaultButton was clicked
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
    mx_internal function sendDefaultButtonEvent():void
    {
        // trace("FocusManager.sendDefaultButtonEvent " + defButton);
        defButton.dispatchEvent(new MouseEvent("click"));
    }
     */

    /**
     *  @private
     *  Do a tree walk and add all children you can find.
     */
    mx_internal function addFocusables(o:DisplayObject, skipTopLevel:Boolean = false):void
    {
        // trace(">>addFocusables " + o);
        if ((o is IFocusManagerComponent) && !skipTopLevel)
        {
			
			var addToFocusables:Boolean = false;
        	if (o is IFocusManagerComponent)
        	{
	            var focusable:IFocusManagerComponent = IFocusManagerComponent(o);
	            if (focusable.focusEnabled)
	            {
	                if (focusable.tabFocusEnabled && isTabVisible(o))
	                {
						addToFocusables = true;	                	
	                }
                }
            }

			if (addToFocusables)
			{            
               	if (focusableObjects.indexOf(o) == -1)
            	{
                    focusableObjects.push(o);
	                calculateCandidates = true;
    	            // trace("FM added " + o);
    	        }
   			}
            o.addEventListener("tabFocusEnabledChange", tabFocusEnabledChangeHandler);
            o.addEventListener("tabIndexChange", tabIndexChangeHandler);

        }
        
        if (o is DisplayObjectContainer)
        {
            var doc:DisplayObjectContainer = DisplayObjectContainer(o);
            // Even if they aren't focusable now,
            // listen in case they become later.
            var checkChildren:Boolean;

            if (o is IFocusManagerComponent)
            {
                o.addEventListener("hasFocusableChildrenChange", hasFocusableChildrenChangeHandler);
                checkChildren = IFocusManagerComponent(o).hasFocusableChildren;
            }
            else
            {
                o.addEventListener("tabChildrenChange", tabChildrenChangeHandler);
                checkChildren = doc.tabChildren;
            }

            var i:int;
            if (checkChildren)
            {
                /*
                if (o is IRawChildrenContainer)
                {
                    // trace("using view rawChildren");
                    var rawChildren:IChildList = IRawChildrenContainer(o).rawChildren;
                    // recursively visit and add children of components
                    // we don't do this for containers because we get individual
                    // adds for the individual children
                    for (i = 0; i < rawChildren.numChildren; i++)
                    {
                        try
                        {
                            addFocusables(rawChildren.getChildAt(i));
                        }
                        catch(error:SecurityError)
                        {
                            // Ignore this child if we can't access it
                            // trace("addFocusables: ignoring security error getting child from rawChildren: " + error);
                        }
                    }

                }
                else
                {
                */
                    // trace("using container's children");
                    // recursively visit and add children of components
                    // we don't do this for containers because we get individual
                    // adds for the individual children
                    for (i = 0; i < doc.numChildren; i++)
                    {
                        try
                        {
                            addFocusables(doc.getChildAt(i));
                        }
                        catch(error:SecurityError)
                        {
                            // Ignore this child if we can't access it
                            // trace("addFocusables: ignoring security error getting child at document." + error);
                        }
                    }
                //}
            }
        }
        // trace("<<addFocusables " + o);
    }

    /**
     *  @private
     *  is it really tabbable?
     */
    private function isTabVisible(o:DisplayObject):Boolean
    {
        var s:DisplayObject = DisplayObject(form.systemManager);
        if (!s) return false;

        var p:DisplayObjectContainer = o.parent;
        while (p && p != s)
        {
            if (!p.tabChildren)
                return false;
            if (p is IFocusManagerComponent && !(IFocusManagerComponent(p).hasFocusableChildren))
                return false;
            p = p.parent;
        }
        return true;
    }

    private function isValidFocusCandidate(o:DisplayObject, g:String):Boolean
    {
        if (o is IFocusManagerComponent)
            if (!IFocusManagerComponent(o).focusEnabled)
                return false;

        if (!isEnabledAndVisible(o))
            return false;

        if (o is IFocusManagerGroup)
        {
            // reject if it is in the same tabgroup
            var tg:IFocusManagerGroup = IFocusManagerGroup(o);
            if (g == tg.groupName) return false;
        }
        return true;
    }
    
    private function getIndexOfFocusedObject(o:DisplayObject):int
    {
        if (!o)
            return -1;

        var n:int = focusableCandidates.length;
        // trace(" focusableCandidates " + n);
        var i:int = 0;
        for (i = 0; i < n; i++)
        {
            // trace(" comparing " + focusableCandidates[i]);
            if (focusableCandidates[i] == o)
                return i;
        }

        // no match?  try again with a slower match for certain
        // cases like DG editors
        for (i = 0; i < n; i++)
        {
            var iui:IUIComponent = focusableCandidates[i] as IUIComponent;
            if (iui && iui.owns(o as IUIComponent))
                return i;
        }

        return -1;
    }


    private function getIndexOfNextObject(i:int, shiftKey:Boolean, bSearchAll:Boolean, groupName:String):int
    {
        var n:int = focusableCandidates.length;
        var start:int = i;

        while (true)
        {
            if (shiftKey)
                i--;
            else
                i++;
            if (bSearchAll)
            {
                if (shiftKey && i < 0)
                    break;
                if (!shiftKey && i == n)
                    break;
            }
            else
            {
                i = (i + n) % n;
                // came around and found the original
                if (start == i)
                    break;
                // if start is -1, set start to first valid value of i
                if (start == -1)
                    start = i;
            }
            // trace("testing " + focusableCandidates[i]);
            if (isValidFocusCandidate(focusableCandidates[i], groupName))
            {
                // trace(" stopped at " + i);
                var o:DisplayObject = DisplayObject(findFocusManagerComponent2(focusableCandidates[i]));     
                if (o is IFocusManagerGroup)
                {
                    
                    // when landing on an element that is part of group, try to
                    // advance selection to the selected group element
                    var j:int;
                    var obj:DisplayObject;
                    var tg1:IFocusManagerGroup = IFocusManagerGroup(o);
                    var tg2:IFocusManagerGroup;
                    
                    // normalize the "no selected group element" case
                    // to the "first group element selected" case
                    // (respecting the tab direction)
                    var groupElementToFocus:IFocusManagerGroup = null;
                    for (j = 0; j < focusableCandidates.length; j++)
                    {
                        obj = focusableCandidates[j];
                        if (obj is IFocusManagerGroup)
                        {
                            tg2 = IFocusManagerGroup(obj);
                            if (tg2.groupName == tg1.groupName && isEnabledAndVisible(obj) &&
                                tg2["document"] == tg1["document"])
                            {
                                if (tg2.selected) 
                                {
                                    groupElementToFocus = tg2;
                                    break;
                                }
                                if ((!shiftKey && groupElementToFocus == null) || shiftKey)
                                    groupElementToFocus = tg2;
                            }
                        }
                    }
                    
                    if (tg1 != groupElementToFocus)
                    {
                        var foundAnotherGroup:Boolean = false;
                        // cycle the entire focusable candidates array forward or backward,
                        // wrapping around boundaries, searching for our focus candidate
                        j = i;
                        for (var k:int = 0; k < focusableCandidates.length - 1; k++)
                        {
                            
                            if (!shiftKey) 
                            {
                                j++;
                                if (j == focusableCandidates.length)
                                    j = 0;
                            }
                            else
                            {
                                j--;
                                if (j == -1)
                                    j = focusableCandidates.length - 1;
                            }
                            
                            obj = focusableCandidates[j];
                            if (isEnabledAndVisible(obj))
                            {
                                if (foundAnotherGroup)
                                {
                                    // we're now just trying to find a selected member of this group
                                    if (obj is IFocusManagerGroup)
                                    {
                                        tg2 = IFocusManagerGroup(obj);
                                        if (tg2.groupName == tg1.groupName && tg2["document"] == tg1["document"])
                                        {
                                            if (tg2.selected)
                                            {
                                                i = j;
                                                break;
                                            }
                                        }
                                    }
                                }
                                else if (obj is IFocusManagerGroup)
                                {
                                    tg2 = IFocusManagerGroup(obj);
                                    if (tg2.groupName == tg1.groupName && tg2["document"] == tg1["document"])
                                    {
                                        if (tg2 == groupElementToFocus)
                                        {
                                            // if objects of same group have different tab index
                                            // skip you aren't selected.
                                            if (InteractiveObject(obj).tabIndex != InteractiveObject(o).tabIndex && !tg1.selected)
                                                return getIndexOfNextObject(i, shiftKey, bSearchAll, groupName);
                                            i = j;
                                            break;
                                        }
                                    }
                                    else
                                    {
                                        // switch to new group and hunt for selected item
                                        tg1 = tg2;
                                        i = j;
                                        // element is part of another group, stop if selected
                                        if (tg2.selected)
                                            break;
                                        else
                                            foundAnotherGroup = true;
                                    }
                                }
                                else
                                {
                                    // element isn't part of any group, stop
                                    i = j;
                                    break;
                                }
                            }
                        }
                    }
                }
                return i;
            }
        }
        return i;
    }

    /**
     *  @private
     */
    private function setFocusToNextObject(event:FocusEvent):void
    {
     	focusChanged = false;
        if (focusableObjects.length == 0)
            return;

		var focusInfo:FocusInfo = getNextFocusManagerComponent2(event.shiftKey, fauxFocus);
		// trace("winner = ", focusInfo.displayObject);

		// If we are about to wrap focus around, send focus back to the parent.
		if (!popup && (focusInfo.wrapped || !focusInfo.displayObject))
		{
            if (hasEventListener("focusWrapping"))
	    		if (!dispatchEvent(new FocusEvent("focusWrapping", false, true, null, event.shiftKey)))
		    		return;
		}
		
		if (!focusInfo.displayObject)
		{
			event.preventDefault();
			return;
		}

		setFocusToComponent(focusInfo.displayObject, event.shiftKey);		
	}

	private function setFocusToComponent(o:Object, shiftKey:Boolean):void
	{
		focusChanged = false;
		if (o)
		{
            if (hasEventListener("setFocusToComponent"))
    			if (!dispatchEvent(new FocusEvent("setFocusToComponent", false, true, InteractiveObject(o), shiftKey)))
	    			return;

			if (o is IFocusManagerComplexComponent)
			{
				IFocusManagerComplexComponent(o).assignFocus(shiftKey ? "bottom" : "top");
				focusChanged = true;
			}
			else if (o is IFocusManagerComponent)
			{
				setFocus(IFocusManagerComponent(o));
				focusChanged = true;
			}
				
		}
		
	}

	/**
	 *  @private
	 */
	mx_internal function setFocusToNextIndex(index:int, shiftKey:Boolean):void
	{
		if (focusableObjects.length == 0)
			return;
			
        // I think we'll have time to do this here instead of at creation time
        // this makes and orders the focusableCandidates array
        if (calculateCandidates)
        {
            sortFocusableObjects();
            calculateCandidates = false;
        }

		var focusInfo:FocusInfo = getNextFocusManagerComponent2(shiftKey, null, index);			

		// If we are about to wrap focus around, send focus back to the parent.
		if (!popup && focusInfo.wrapped)
		{
            if (hasEventListener("setFocusToNextIndex"))
    			if (!dispatchEvent(new FocusEvent("setFocusToNextIndex", false, true, null, shiftKey)))
	    			return;
		}
		
		setFocusToComponent(focusInfo.displayObject, shiftKey);
	}
	
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getNextFocusManagerComponent(
                            backward:Boolean = false):IFocusManagerComponent
	{
        const focusInfo:FocusInfo = getNextFocusManagerComponent2(backward, fauxFocus); 
        return focusInfo ? focusInfo.displayObject as IFocusManagerComponent : null; 
	}
	
	/**
	 * Find the next object to set focus to.
	 * 
	 * @param backward true if moving in the backwards in the tab order, false if moving forward.
	 * @param fromObject object to move focus from, if null move from the current focus.
	 * @param formIndex index to move focus from, if specified use fromIndex to find the 
	 * 		   			object, not fromObject.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	private function getNextFocusManagerComponent2(
                            backward:Boolean = false, 
                            fromObject:DisplayObject = null,
                            fromIndex:int = FROM_INDEX_UNSPECIFIED):FocusInfo
                            
    {
        if (focusableObjects.length == 0)
            return null;

        // I think we'll have time to do this here instead of at creation time
        // this makes and orders the focusableCandidates array
        if (calculateCandidates)
        {
            sortFocusableObjects();
            calculateCandidates = false;
        }

        // trace("focus was at " + fromObject);
        // trace("focusableObjects " + focusableObjects.length);
        var i:int = fromIndex;
        if (fromIndex == FROM_INDEX_UNSPECIFIED)
        {
	        // if there is no passed in object, then get the object that has the focus
    	    var o:DisplayObject = fromObject; 
        	if (!o)
        		o = Sprite(form)./*systemManager,*/stage.focus;
            else if (o == Sprite(form)./*systemManager.*/stage)
                o == null;
        
	        o = DisplayObject(findFocusManagerComponent2(InteractiveObject(o)));
	
	        var g:String = "";
	        if (o is IFocusManagerGroup)
	        {
	            var tg:IFocusManagerGroup = IFocusManagerGroup(o);
	            g = tg.groupName;
	        }
	        i = getIndexOfFocusedObject(o);
        }
        
        // trace(" starting at " + i);
        var bSearchAll:Boolean = false;
        var start:int = i;
        if (i == -1) // we didn't find it
        {
            if (backward)
                i = focusableCandidates.length;
            bSearchAll = true;
            // trace("search all " + i);
        }

        var j:int = getIndexOfNextObject(i, backward, bSearchAll, g);

        // if we wrapped around, get if we have a parent we should pass
        // focus to.
        var wrapped:Boolean = false;
        if (backward)
        {
        	if (j >= i)
        		wrapped = true;
        }
        else if (j <= i)
      		wrapped = true;

		var focusInfo:FocusInfo = new FocusInfo();
		
		focusInfo.displayObject = findFocusManagerComponent2(focusableCandidates[j]);
		focusInfo.wrapped = wrapped;
		
        return focusInfo;
    }


    /**
     *  @private
     */
    private function getTopLevelFocusTarget(o:InteractiveObject):InteractiveObject
    {
        while (o != InteractiveObject(form))
        {
            if (o is IFocusManagerComponent &&
                IFocusManagerComponent(o).focusEnabled &&
                /*IFocusManagerComponent(o).mouseFocusEnabled &&*/
                (o is IUIComponent ? IUIComponent(o).enabled : true))
                return o;

            if (hasEventListener("getTopLevelFocusTarget"))
    			if (!dispatchEvent(new FocusEvent("getTopLevelFocusTarget", false, true, o.parent)))
			    	return null;

            o = o.parent;

            if (o == null)
                break;
        }

        return null;
    }

    /**
     *  Returns a String representation of the component hosting the FocusManager object, 
     *  with the String <code>".focusManager"</code> appended to the end of the String.
     *
     *  @return Returns a String representation of the component hosting the FocusManager object, 
     *  with the String <code>".focusManager"</code> appended to the end of the String.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function toString():String
    {
        return Object(form).toString() + ".focusManager";
    }
    
    /**
     *  @private
     * 
     *  Clear the browser focus component and undo any tab index we may have set.
     */
    private function clearBrowserFocusComponent():void
    {
        if (browserFocusComponent)
        {
            if (browserFocusComponent.tabIndex == LARGE_TAB_INDEX)
                browserFocusComponent.tabIndex = -1;
            
            browserFocusComponent = null;
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Listen for children being added
     *  and see if they are focus candidates.
     */
    private function addedHandler(event:Event):void
    {
        var target:DisplayObject = DisplayObject(event.target);
        
        // trace("FM: addedHandler: got added for " + target);
        
        // if it is truly parented, add it, otherwise it will get added when the top of the tree
        // gets parented.
        if (target.stage)
        {
            // trace("FM: addedHandler: adding focusables");
            addFocusables(DisplayObject(event.target));
        }
    }

    /**
     *  @private
     *  Listen for children being removed.
     */
    private function removedHandler(event:Event):void
    {
        var i:int;
        var o:DisplayObject = DisplayObject(event.target);
        var focusPaneParent:DisplayObject = focusPane ? focusPane.parent : null;

        // Remove the focusPane to allow the focusOwner to be garbage collected.
        // Avoid recursion by not processing the removal of the focusPane itself.    
        /*
        if (focusPaneParent && o != focusPane)
        {
            if (o is DisplayObjectContainer && 
                isParent(DisplayObjectContainer(o), focusPane))
            {
                if (focusPaneParent is ISystemManager)
                    ISystemManager(focusPaneParent).focusPane = null;
                else
                    IUIComponent(focusPaneParent).focusPane = null;
            }
        }
        */
        
        // trace("FM got added for " + event.target);

        if (o is IFocusManagerComponent)
        {
            for (i = 0; i < focusableObjects.length; i++)
            {
                if (o == focusableObjects[i])
                {
                    /*
                    if (o == _lastFocus)
                    {
                        _lastFocus.drawFocus(false);
                        _lastFocus = null;
                    }
                    */
                    // trace("FM removed " + o);
                    focusableObjects.splice(i, 1);
                    focusableCandidates = [];
                    calculateCandidates = true;                 
                    break;
                }
            }
            o.removeEventListener("tabFocusEnabledChange", tabFocusEnabledChangeHandler);
            o.removeEventListener("tabIndexChange", tabIndexChangeHandler);
        }
        removeFocusables(o, false);
    }

    /**
     *  @private
     */
    private function removeFocusables(o:DisplayObject, dontRemoveTabChildrenHandler:Boolean):void
    {
        var i:int;
        if (o is DisplayObjectContainer)
        {
            if (!dontRemoveTabChildrenHandler)
            {
                o.removeEventListener("tabChildrenChange", tabChildrenChangeHandler);
                o.removeEventListener("hasFocusableChildrenChange", hasFocusableChildrenChangeHandler);
            }

            for (i = 0; i < focusableObjects.length; i++)
            {
                if (isParent(DisplayObjectContainer(o), focusableObjects[i]))
                {
                    /*
                    if (focusableObjects[i] == _lastFocus)
                    {
                        _lastFocus.drawFocus(false);
                        _lastFocus = null;
                    }
                    */
                    // trace("FM removed " + focusableObjects[i]);
                    focusableObjects[i].removeEventListener(
                        "tabFocusEnabledChange", tabFocusEnabledChangeHandler);
                    focusableObjects[i].removeEventListener(
                        "tabIndexChange", tabIndexChangeHandler);
                    focusableObjects.splice(i, 1);
                    i = i - 1;  // because increment would skip one
                    
                    focusableCandidates = [];
                    calculateCandidates = true;                 
                }
            }
        }
    }

    /**
     *  @private
     */
    private function showHandler(event:Event):void
    {
        /*
		var awm:IActiveWindowManager = 
			IActiveWindowManager(form.systemManager.getImplementation("mx.managers::IActiveWindowManager"));
		if (awm)
        	awm.activate(form); // build a message that does the equal
        */
    }

    /**
     *  @private
     */
    private function hideHandler(event:Event):void
    {
        /*
		var awm:IActiveWindowManager = 
			IActiveWindowManager(form.systemManager.getImplementation("mx.managers::IActiveWindowManager"));
		if (awm)
        	awm.deactivate(form); // build a message that does the equal
        */
    }

    /**
     *  @private
     */
    private function childHideHandler(event:Event):void
    {
        var target:DisplayObject = DisplayObject(event.target);
        // trace("FocusManager focusInHandler in  = " + this._form.systemManager.loaderInfo.url);
        // trace("FM " + this + " focusInHandler " + target);

        if (lastFocus && !isEnabledAndVisible(DisplayObject(lastFocus)) && DisplayObject(form).stage)
        {
            DisplayObject(form).stage.focus = null;
            lastFocus = null;
        }
    }
    
    /**
     *  @private
     */
    private function viewHideHandler(event:Event):void
    {
        // Target is the active view that is about to be hidden
        var target:DisplayObjectContainer = event.target as DisplayObjectContainer;
        var lastFocusDO:DisplayObject = lastFocus as DisplayObject;
       
        // If the lastFocus is in the view about to be hidden, clear focus
        if (target && lastFocusDO && target.contains(lastFocusDO))
            lastFocus = null;
    }

    /**
     *  @private
     */
    private function creationCompleteHandler(event:FlexEvent):void
    {
        /*
        var o:DisplayObject = DisplayObject(form);
        if (o.parent && o.visible && !activated)
		{
			var awm:IActiveWindowManager = 
				IActiveWindowManager(form.systemManager.getImplementation("mx.managers::IActiveWindowManager"));
			if (awm)
	        	awm.activate(form); // build a message that does the equal
		}
        */
    }

    /**
     *  @private
     *  Add or remove if tabbing properties change.
     */
    private function tabIndexChangeHandler(event:Event):void
    {
        calculateCandidates = true;
    }

    /**
     *  @private
     *  Add or remove if tabbing properties change.
     */
    private function tabFocusEnabledChangeHandler(event:Event):void
    {
        calculateCandidates = true;

        var o:IFocusManagerComponent = IFocusManagerComponent(event.target);
        var n:int = focusableObjects.length;
        for (var i:int = 0; i < n; i++)
        {
            if (focusableObjects[i] == o)
                break;
        }
        if (o.tabFocusEnabled)
        {
            if (i == n && isTabVisible(DisplayObject(o)))
            {
                // trace("FM tpc added " + o);
                // add it if were not already
               	if (focusableObjects.indexOf(o) == -1)
	                focusableObjects.push(o);
            }
        }
        else
        {
            // remove it
            if (i < n)
            {
                // trace("FM tpc removed " + o);
                focusableObjects.splice(i, 1);
            }
        }
    }

    /**
     *  @private
     *  Add or remove if tabbing properties change.
     */
    private function tabChildrenChangeHandler(event:Event):void
    {
        if (event.target != event.currentTarget)
            return;

        calculateCandidates = true;

        var o:DisplayObjectContainer = DisplayObjectContainer(event.target);
        if (o.tabChildren)
        {
            addFocusables(o, true);
        }
        else
        {
            removeFocusables(o, true);
        }
    }

    /**
     *  @private
     *  Add or remove if tabbing properties change.
     */
    private function hasFocusableChildrenChangeHandler(event:Event):void
    {
        if (event.target != event.currentTarget)
            return;

        calculateCandidates = true;

        var o:IFocusManagerComponent = IFocusManagerComponent(event.target);
        if (o.hasFocusableChildren)
        {
            addFocusables(DisplayObject(o), true);
        }
        else
        {
            removeFocusables(DisplayObject(o), true);
        }
    }

    /**
     *  @private
     *  This gets called when mouse clicks on a focusable object.
     *  We block player behavior
     */
    private function mouseFocusChangeHandler(event:FocusEvent):void
    {
        // trace("FocusManager: mouseFocusChangeHandler  in  = " + this._form.systemManager.loaderInfo.url);
    	// trace("FocusManager: mouseFocusChangeHandler " + event);
        
        if (event.isDefaultPrevented())
            return;

        // If relatedObject is null because we don't have access to the 
        // object getting focus then allow the Player to set focus
        // to the object. The isRelatedObjectInaccessible property is 
        // Player 10 only so we have to test if it is available. We
        // will only see isRelatedObjectInaccessible if we are a version "10" swf
        // (-target-player=10). Version "9" swfs will not see the property
        // even if running in Player 10.
        if (event.relatedObject == null && 
            "isRelatedObjectInaccessible" in event &&
            event["isRelatedObjectInaccessible"] == true)
        {
            // lost focus to a control in different sandbox.
            return;
        }
        
        if (event.relatedObject is TextField)
        {
            var tf:TextField = event.relatedObject as TextField;
            if (tf.type == "input" || tf.selectable)
            {
                return; // pass it on
            }
        }

        event.preventDefault();
    }

    /**
     *  @private
     *  This gets called when the tab key is hit.
     */
    mx_internal function keyFocusChangeHandler(event:FocusEvent):void
    {
        // trace("keyFocusChangeHandler handled by " + this);
    	// trace("keyFocusChangeHandler event = " + event);
    	
    	var sm:ISystemManager = form.systemManager;

        if (hasEventListener("keyFocusChange"))
    		if (!dispatchEvent(new FocusEvent("keyFocusChange", false, true, InteractiveObject(event.target))))
	    		return;

        showFocusIndicator = true;
		focusChanged = false;

        var haveBrowserFocusComponent:Boolean = (browserFocusComponent != null);
        if (browserFocusComponent)
            clearBrowserFocusComponent();
        
        // see if we got here from a tab.  We also need to check for 
        // keyCode == 0 because in IE sometimes the first time you tab 
        // in to the flash player, you get keyCode == 0 instead of TAB.
        // Flash Player bug #2295688.
        if ((event.keyCode == Keyboard.TAB || (browserMode && event.keyCode == 0)) 
                && !event.isDefaultPrevented())
        {
            if (haveBrowserFocusComponent)
            {
                if (hasEventListener("browserFocusComponent"))
	    			dispatchEvent(new FocusEvent("browserFocusComponent", false, false, InteractiveObject(event.target)));
				
                return;
            }

            /*
            if (ieshifttab && lastAction == "ACTIVATE")
            {
                // IE seems to now require that we set focus to something during activate
                // but then we get this keyFocusChange event.  I think we used to not
                // need to set focus on activate and we still got the keyFocusChange
                // and then stage.focus was null and we'd use the keyFocusChange event
                // to determine which control (first or last) got focus based on
                // the shift key.
                // If we set focus on activate, then we get this keyFocusChange which moves
                // the focus somewhere else, so we set fauxFocus to the stage as a signal
                // to the setFocusToNextObject logic that it shouldn't use the stage.focus
                // as the starting point.
                fauxFocus = sm.stage;
            }
            */
            // trace("tabHandled by " + this);
            setFocusToNextObject(event);
            if (ieshifttab && lastAction == "ACTIVATE")
            {
                fauxFocus = null;
            }

            // if we changed focus or if we're the main app
            // eat the event
            /*
			if (focusChanged || sm == sm.getTopLevelRoot())
            	event.preventDefault();
            */
        }
    }

    /**
     *  @private
     *  Watch for TAB keys.
     */
    mx_internal function keyDownHandler(event:KeyboardEvent):void
    {
        // trace("onKeyDown handled by " + this);
    	// trace("onKeyDown event = " + event);
		// if the target is in a bridged application, let it handle the click.
		var sm:ISystemManager = form.systemManager;

        if (hasEventListener("keyDownFM"))
    		if (!dispatchEvent(new FocusEvent("keyDownFM", false, true, InteractiveObject(event.target))))
   	    		return;

        /*
        if (sm is SystemManager)
            SystemManager(sm).idleCounter = 0;
        */
        
        if (event.keyCode == Keyboard.TAB)
        {
            lastAction = "KEY";

            // I think we'll have time to do this here instead of at creation time
            // this makes and orders the focusableCandidates array
            if (calculateCandidates)
            {
                sortFocusableObjects();
                calculateCandidates = false;
            }
        }

        /*
        if (browserMode)
        {
            if (browserFocusComponent)
                clearBrowserFocusComponent();
            
            if (event.keyCode == Keyboard.TAB && focusableCandidates.length > 0)
            {
                // get the object that has the focus
                var o:DisplayObject = fauxFocus;
				if (!o)
				{
					o = form.systemManager.stage.focus;
				}
				
                // trace("focus was at " + o);
                // trace("focusableObjects " + focusableObjects.length);
                o = DisplayObject(findFocusManagerComponent2(InteractiveObject(o)));
                var g:String = "";
                if (o is IFocusManagerGroup)
                {
                    var tg:IFocusManagerGroup = IFocusManagerGroup(o);
                    g = tg.groupName;
                }

                var i:int = getIndexOfFocusedObject(o);
                var j:int = getIndexOfNextObject(i, event.shiftKey, false, g);
                if (event.shiftKey)
                {
                    if (j >= i)
                    {
                        // we wrapped so let browser have it
                        browserFocusComponent = getBrowserFocusComponent(event.shiftKey);
                        if (browserFocusComponent.tabIndex == -1)
                            browserFocusComponent.tabIndex = 0;
                    }
                }
                else
                {
                    if (j <= i)
                    {
                        // we wrapped so let browser have it
                        browserFocusComponent = getBrowserFocusComponent(event.shiftKey);
                        if (browserFocusComponent.tabIndex == -1)
                            browserFocusComponent.tabIndex = LARGE_TAB_INDEX;
                    }
                }
            }
        }
        */
    }

    /**
     *  @private
     *  Watch for ENTER key.
    private function defaultButtonKeyHandler(event:KeyboardEvent):void
    {        
        var sm:ISystemManager = form.systemManager;
        if (hasEventListener("defaultButtonKeyHandler"))
    		if (!dispatchEvent(new FocusEvent("defaultButtonKeyHandler", false, true)))
	    		return;
            
        if (defaultButtonEnabled && event.keyCode == Keyboard.ENTER &&
			defButton && defButton.enabled)
        {
            sendDefaultButtonEvent();
    	}
    }
     */

    /**
     *  @private
     *  This gets called when the focus changes due to a mouse click.
     *
     *  Note: If the focus is changing to a TextField, we don't call
     *  setFocus() on it because the player handles it;
     *  calling setFocus() on a TextField which has scrollable text
     *  causes the text to autoscroll to the end, making the
     *  mouse click set the insertion point in the wrong place.
     */
    private function mouseDownCaptureHandler(event:MouseEvent):void
    {
        // trace("FocusManager mouseDownCaptureHandler in  = " + this._form.systemManager.loaderInfo.url);
        // trace("FocusManager mouseDownCaptureHandler target " + event.target);
        showFocusIndicator = false;
    }

    /**
     *  @private
     *  This gets called when the focus changes due to a mouse click.
     *
     *  Note: If the focus is changing to a TextField, we don't call
     *  setFocus() on it because the player handles it;
     *  calling setFocus() on a TextField which has scrollable text
     *  causes the text to autoscroll to the end, making the
     *  mouse click set the insertion point in the wrong place.
     */
    private function mouseDownHandler(event:MouseEvent):void
    {
        // trace("FocusManager mouseDownHandler in  = " + this._form.systemManager.loaderInfo.url);
        // trace("FocusManager mouseDownHandler target " + event.target);
        
		// if the target is in a bridged application, let it handle the click.
		var sm:ISystemManager = form.systemManager;
        var o:DisplayObject = getTopLevelFocusTarget(
            InteractiveObject(event.target));

        if (!o)
            return;

        // trace("FocusManager mouseDownHandler on " + o);
        
        // Make sure the containing component gets notified.
        // As the note above says, we don't set focus to a TextField ever
        // because the player already did and took care of where
        // the insertion point is, and we also don't call setfocus
        // on a component that last the last focused object unless
        // the last action was just to activate the player and didn't
        // involve tabbing or clicking on a component
        if ((o != _lastFocus || lastAction == "ACTIVATE") && !(o is TextField))
            setFocus(IFocusManagerComponent(o));
		else if (_lastFocus)
		{
			// trace("FM: skipped setting focus to " + _lastFocus);
		}
		
        if (hasEventListener("mouseDownFM"))
    		dispatchEvent(new FocusEvent("mouseDownFM", false, false, InteractiveObject(o)));

        lastAction = "MOUSEDOWN";
	
    }
	
    /*
	private function getBrowserFocusComponent(shiftKey:Boolean):InteractiveObject
	{
    	var focusComponent:InteractiveObject = form.systemManager.stage.focus;
		
		// if the focus is null it means focus is in an application we
		// don't have access to. Use either the last object or the first
		// object in this focus manager's list.
		if (!focusComponent)
		{
			var index:int = shiftKey ? 0 : focusableCandidates.length - 1;
			focusComponent = focusableCandidates[index];
		}
		
		return focusComponent;
    }
    */
}

COMPILE::JS
public class FocusManager extends EventDispatcher implements IFocusManager
{
    public function FocusManager(container:IFocusManagerContainer, popup:Boolean = false)
    {
        super();
        
        form = container;
        form.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownCaptureHandler, true); 
    }
    
    private var form:IFocusManagerContainer;
    
    private function mouseDownCaptureHandler(event:MouseEvent):void
    {
        var target:Object = event.target;
        if (target is UIComponent)
            target["element"].focus();
    }
	public function getNextFocusManagerComponent(
                            backward:Boolean = false):IFocusManagerComponent
	{
       return null;
	}
	
	
	private var _getFocus:IFocusManagerComponent;
        public function getFocus():IFocusManagerComponent
    {
                  return _getFocus;
       //var stage:Stage = Sprite(form)./*systemManager.*/stage;
        
        /* if (!stage)
            return null;
            
        var o:InteractiveObject = stage.focus;
        
        // If a Stage* object (such as StageText or StageWebView) has focus,
        // stage.focus will be set to null. Much of the focus framework is not
        // set up to handle this. So, if stage.focus is null, we return the last
        // IFocusManagerComponent that had focus.  In ADL, focus works slightly
        // different than it does on device when using StageText.  In ADL, when
        // the focus is a StageText component, a TextField whose parent is the 
        // stage is assigned focus.  
        if ((!o && _lastFocus) || (o is TextField && o.parent == stage))
            return _lastFocus;
        
        return findFocusManagerComponent(o); */
    }

    public function setFocus(o:IFocusManagerComponent):void
    {
        // trace("FM " + this + " setting focus to " + o);

        o.setFocus();
        
        if (hasEventListener("setFocus"))
    		dispatchEvent(new Event("setFocus"));
        // trace("FM set focus");
    }
}

}

COMPILE::SWF
{
import flash.display.DisplayObject;
}

/** 
 * @private
 * 
 *  Plain old class to return multiple items of info about the potential
 *  change in focus.
 */
COMPILE::SWF
class FocusInfo
{
	public var displayObject:DisplayObject;	// object to get focus
	public var wrapped:Boolean;				// true if focus wrapped around
}
