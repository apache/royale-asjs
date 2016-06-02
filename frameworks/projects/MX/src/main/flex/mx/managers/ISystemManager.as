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

COMPILE::AS3
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;		
	import flash.display.Stage;		
}
COMPILE::JS
{
	import flex.display.DisplayObject;
	import flex.display.Sprite;		
}
import flex.display.ModuleInfo;
import flex.display.TopOfDisplayList;		

import flex.events.IEventDispatcher;
import org.apache.flex.geom.Rectangle;
COMPILE::LATER
{
import flash.text.TextFormat;
}

import mx.core.IChildList;
import mx.core.IFlexModuleFactory;

/**
 *  An ISystemManager manages an "application window".
 *  Every application that runs on the desktop or in a browser
 *  has an area where the visuals of the application will be
 *  displayed.  It may be a window in the operating system
 *  or an area within the browser.  That is an "application window"
 *  and different from an instance of <code>mx.core.Application</code>, which
 *  is the main "top-level" window within an application.
 *
 *  <p>Every application has an ISystemManager.  
 *  The ISystemManager  sends an event if
 *  the size of the application window changes (you cannot change it from
 *  within the application, but only through interaction with the operating
 *  system window or browser).  It parents all displayable items within the
 *  application, such as the main mx.core.Application instance and all popups, 
 *  tooltips, cursors, an so on.  Any object parented by the ISystemManager is
 *  considered to be a "top-level" window, even tooltips and cursors.</p>
 *
 *  <p>The ISystemManager also switches focus between top-level windows
 *  if there  are more than one IFocusManagerContainer displayed and users
 *  are interacting with components within the IFocusManagerContainers.</p>
 *
 *  <p>All keyboard and mouse activity that is not expressly trapped is seen
 *  by the ISystemManager, making it a good place to monitor activity
 *  should you need to do so.</p>
 *
 *  <p>If an application is loaded into another application, an ISystemManager
 *  will still be created, but will not manage an "application window",
 *  depending on security and domain rules.
 *  Instead, it will be the <code>content</code> of the <code>Loader</code> 
 *  that loaded it and simply serve as the parent of the sub-application</p>
 *
 *  <p>The ISystemManager maintains multiple lists of children, one each for
 *  tooltips, cursors, popup windows.
 *  This is how it ensures that popup windows "float" above the main
 *  application windows and that tooltips "float" above that
 *  and cursors above that.
 *  If you examine the <code>numChildren</code> property 
 *  or <code>getChildAt()</code> method on the ISystemManager
 *  you are accessing the main application window and any other windows
 *  that aren't popped up.
 *  To get the list of all windows, including popups, tooltips and cursors,
 *  use the <code>rawChildren</code> property.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public interface ISystemManager extends IEventDispatcher, IChildList, IFlexModuleFactory
{
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

    //----------------------------------
    //  cursorChildren
    //----------------------------------

	/**
	 *  An list of the custom cursors
	 *  being parented by this ISystemManager.
	 *
	 *  <p>An ISystemManager has various types of children,
	 *  such as the Application, popups, top-most windows,
	 *  tooltips, and custom cursors.
	 *  You can access the custom cursors through
	 *  the <code>cursorChildren</code> property.</p>
	 *
	 *  <p>The IChildList object has methods like <code>getChildAt()</code>
	 *  and properties like <code>numChildren</code>.
	 *  For example, <code>cursorChildren.numChildren</code> gives
	 *  the number of custom cursors (which will be either 0 or 1)
	 *  and, if a custom cursor exists, you can access it as
	 *  <code>cursorChildren.getChildAt(0)</code>.</p>
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	function get cursorChildren():IChildList;
	
    //----------------------------------
    //  document
    //----------------------------------

	/**
	 *  A reference to the document object. 
	 *  A document object is an Object at the top of the hierarchy of a 
	 *  Flex application, MXML component, or AS component.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	function get document():Object;

	/**
	 *  @private
	 */
	function set document(value:Object):void;

    //----------------------------------
    //  embeddedFontList
    //----------------------------------

	/**
     *  @private
	 */
	function get embeddedFontList():Object;

    //----------------------------------
    //  focusPane
    //----------------------------------

	/**
	 *  A single Sprite shared among components used as an overlay for drawing focus.
	 *  You share it if you parent a focused component, not if you are IFocusManagerComponent.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	function get focusPane():Sprite;

	/**
	 *  @private
	 */
	function set focusPane(value:Sprite):void;

    //----------------------------------
    //  isProxy
    //----------------------------------

	/**
	 *  True if the ISystemManager is a proxy and not a root class.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	function get isProxy():Boolean;

    //----------------------------------
    //  loaderInfo
    //----------------------------------

	/**
	 *  The LoaderInfo object that represents information about the application.
     *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	function get moduleInfo():ModuleInfo;

    //----------------------------------
    //  numModalWindows
    //----------------------------------

    /**
     *  The number of modal windows.  
     *
     *  <p>Modal windows don't allow
     *  clicking in another windows which would normally 
     *  activate the FocusManager in that window.  The PopUpManager
     *  modifies this count as it creates and destroy modal windows.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get numModalWindows():int;

    /**
     *  @private
     */
    function set numModalWindows(value:int):void;

    //----------------------------------
    //  popUpChildren
    //----------------------------------

	/**
	 *  An list of the topMost (popup)
	 *  windows being parented by this ISystemManager.
	 *
	 *  <p>An ISystemManager has various types of children,
	 *  such as the Application, popups,
	 *  tooltips, and custom cursors.
	 *  You can access the top-most windows through
	 *  the <code>popUpChildren</code> property.</p>
	 *
	 *  <p>The IChildList object has methods like <code>getChildAt()</code>
	 *  and properties like <code>numChildren</code>.
	 *  For example, <code>popUpChildren.numChildren</code> gives
	 *  the number of topmost windows and you can access them as
	 *  <code>popUpChildren.getChildAt(i)</code>.</p>
	 *
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	function get popUpChildren():IChildList;

    //----------------------------------
    //  rawChildren
    //----------------------------------

	/**
	 *  A list of all children
	 *  being parented by this ISystemManager.
	 *
	 *  <p>An ISystemManager has various types of children,
	 *  such as the Application, popups, 
	 *  tooltips, and custom cursors.</p>
	 * 
	 *  <p>The IChildList object has methods like <code>getChildAt()</code>
	 *  and properties like <code>numChildren</code>.</p>
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	function get rawChildren():IChildList;
	
    //----------------------------------
    //  screen
    //----------------------------------

	/**
	 *  The size and position of the application window.
	 *
	 *  The Rectangle object contains <code>x</code>, <code>y</code>,
	 *  <code>width</code>, and <code>height</code> properties.
     * 
     *  The Rectangle is in sandbox root coordinates.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	function get screen():Rectangle

    //----------------------------------
    //  topOfDisplayList
    //----------------------------------

	/**
	 *  The flash.display.Stage that represents the application window
	 *  mapped to this SystemManager
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	function get topOfDisplayList():TopOfDisplayList

    //----------------------------------
    //  toolTipChildren
    //----------------------------------

	/**
	 *  A list of the tooltips
	 *  being parented by this ISystemManager.
	 *
	 *  <p>An ISystemManager has various types of children,
	 *  such as the Application, popups, topmost windows,
	 *  tooltips, and custom cursors.</p>
	 *
	 *  <p>The IChildList object has methods like <code>getChildAt()</code>
	 *  and properties like <code>numChildren</code>.
	 *  For example, <code>toolTipChildren.numChildren</code> gives
	 *  the number of tooltips (which will be either 0 or 1)
	 *  and, if a tooltip exists, you can access it as
	 *  <code>toolTipChildren.getChildAt(0)</code>.</p>
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	function get toolTipChildren():IChildList;
	
    //----------------------------------
    //  topLevelSystemManager
    //----------------------------------

	/**
	 *  The ISystemManager responsible for the application window.
	 *  This will be the same ISystemManager unless this application
	 *  has been loaded into another application.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	function get topLevelSystemManager():ISystemManager;


	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------

	/**
	 *  Converts the given String to a Class or package-level Function.
	 *  Calls the appropriate <code>ApplicationDomain.getDefinition()</code> 
	 *  method based on
	 *  whether you are loaded into another application or not.
	 *
	 *  @param name Name of class, for example "mx.video.VideoManager".
	 * 
	 *  @return The Class represented by the <code>name</code>, or null.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	function getDefinitionByName(name:String):Object;

	/**
	 *  Returns <code>true</code> if this ISystemManager is responsible
	 *  for an application window, and <code>false</code> if this
	 *  application has been loaded into another application.
	 *
	 *  @return <code>true</code> if this ISystemManager is responsible
	 *  for an application window.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	function isTopLevel():Boolean;

    /**
     *  Returns <code>true</code> if the required font face is embedded
	 *  in this application, or has been registered globally by using the 
	 *  <code>Font.registerFont()</code> method.
	 *
	 *  @param tf The TextFormat class representing character formatting information.
	 *
	 *  @return <code>true</code> if the required font face is embedded
	 *  in this application, or has been registered globally by using the 
	 *  <code>Font.registerFont()</code> method.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	COMPILE::LATER
    function isFontFaceEmbedded(tf:TextFormat):Boolean;

    /**
     *  Tests if this system manager is the root of all
     *  top level system managers.
     * 
     *  @return <code>true</code> if the SystemManager
     *  is the root of all SystemManagers on the display list,
     *  and <code>false</code> otherwise.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function isTopLevelRoot():Boolean;
    
    /**
     *  Attempts to get the system manager that is the in the main application.
     *
     *  @return The main application's systemManager if allowed by
	 *  security restrictions or null if it is in a different SecurityDomain.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function getTopLevelRoot():DisplayObject;

    /**
     *  Gets the system manager that is the root of all
     *  top level system managers in this SecurityDomain.
     *
     *  @return the highest-level systemManager in the sandbox
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	COMPILE::LATER
    function getSandboxRoot():DisplayObject;

    /**
     *  Get the bounds of the loaded application that are visible to the user
     *  on the screen.
     * 
     *  @param bounds Optional. The starting bounds for the visible rect. The
     *  bounds are in global coordinates. If <code>bounds</code> is null the 
     *  starting bounds is defined by the <code>screen</code> property of the 
     *  system manager. 
     * 
     *  @return a <code>Rectangle</code> including the visible portion of the this 
     *  object. The rectangle is in global coordinates.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */  
	COMPILE::LATER
	function getVisibleApplicationRect(bounds:Rectangle = null, skipToSandboxRoot:Boolean = false):Rectangle;
    
    /**
     *  Deploy or remove mouse shields. Mouse shields block mouse input to untrusted
     *  applications. The reason you would want to block mouse input is because
     *  when you are dragging over an untrusted application you would normally not
     *  receive any mouse move events. The Flash Player does not send events
     *  across trusted/untrusted boundries due to security concerns. By covering
     *  the untrusted application with a mouse shield (assuming you are its parent)
     *  you can get mouse move message and the drag operation will work as expected. 
     * 
     *  @param deploy <code>true</code> to deploy the mouse shields, <code>false</code>
     *  to remove the mouse shields.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function deployMouseShields(deploy:Boolean):void;

    /**
     *  Attempt to notify the parent SWFLoader that the application's size may
     *  have changed.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function invalidateParentSizeAndDisplayList():void;

	
	//----------------------------------
	//  stage
	//----------------------------------
	
	/**
	 *  The flash.display.Stage that represents the application window
	 *  mapped to this SystemManager
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	COMPILE::AS3
	function get stage():Stage

}

}
