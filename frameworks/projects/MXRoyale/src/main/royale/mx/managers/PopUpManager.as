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

//import flash.display.DisplayObject;
//import mx.core.IFlexModuleFactory;
//import mx.core.Singleton;
import mx.core.FlexGlobals;
import mx.core.IFlexDisplayObject;
import mx.core.IUIComponent;
import mx.core.UIComponent;

import org.apache.royale.core.IChild;
import org.apache.royale.core.IPopUpHost;
import org.apache.royale.core.IPopUpHostParent;
import org.apache.royale.core.IStrand;
import org.apache.royale.core.IUIBase;
import org.apache.royale.html.beads.plugin.IModalDisplay;
import org.apache.royale.utils.UIUtils;


/**
 *  The PopUpManager singleton class creates new top-level windows and
 *  places or removes those windows from the layer on top of all other
 *  visible windows.  See the SystemManager for a description of the layering.
 *  It is used for popup dialogs, menus, and dropdowns in the ComboBox control 
 *  and in similar components.
 * 
 *  <p>The PopUpManager also provides modality, so that windows below the popup
 *  cannot receive mouse events, and also provides an event if the user clicks
 *  the mouse outside the window so the developer can choose to dismiss
 *  the window or warn the user.</p>
 * 
 *  @see PopUpManagerChildList
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class PopUpManager
{
  //  include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Linker dependency on implementation class.
     */
   // private static var implClassDependency:PopUpManagerImpl;

	/**
	 *  @private
	 *  Storage for the impl getter.
	 *  This gets initialized on first access,
	 *  not at static initialization time, in order to ensure
	 *  that the Singleton registry has already been initialized.
	 */
    // private static var _impl:IPopUpManager;

    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Creates a top-level window and places it above other windows in the
     *  z-order.
     *  It is good practice to call the <code>removePopUp()</code> method 
     *  to remove popups created by using the <code>createPopUp()</code> method.
     *
     *  If the class implements IFocusManagerContainer, the window will have its
     *  own FocusManager so that, if the user uses the TAB key to navigate between
     *  controls, only the controls in the window will be accessed.
     *
     *  <p><b>Example</b></p> 
     *
     *  <pre>pop = mx.managers.PopUpManager.createPopUp(pnl, TitleWindow, false); </pre>
     *  
     *  <p>Creates a popup window based on the TitleWindow class, using <code>pnl</code> as the MovieClip 
     *  for determining where to place the popup. It is defined to be a non-modal window 
     *  meaning that other windows can receive mouse events</p>
     *
     *  @param parent DisplayObject to be used for determining which SystemManager's layers
     *  to use and optionally the reference point for centering the new
     *  top level window.  It may not be the actual parent of the popup as all popups
     *  are parented by the SystemManager.
     * 
     *  @param className Class of object that is to be created for the popup.
     *  The class must implement IFlexDisplayObject.
     *
     *  @param modal If <code>true</code>, the window is modal which means that
     *  the user will not be able to interact with other popups until the window
     *  is removed.
     *
     *  @param childList The child list in which to add the popup.
     *  One of <code>PopUpManagerChildList.APPLICATION</code>, 
     *  <code>PopUpManagerChildList.POPUP</code>, 
     *  or <code>PopUpManagerChildList.PARENT</code> (default).
     *
     *  @param moduleFactory The moduleFactory where this pop-up should look for
     *  its embedded fonts and style manager.
     *
     *  @return Reference to new top-level window.
     *
     *  @see PopUpManagerChildList
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	
    public static function createPopUp(parent:Object, //DisplayObject,
                                       className:Class,
                                       modal:Boolean = false,
                                       childList:String = null,
                                       moduleFactory:Object = null):Object //IFlexModuleFactory = null):IFlexDisplayObject
    {   
		var instance:IUIComponent = new className() as IUIComponent;
        addPopUp(instance, parent, modal);
        return instance;
    }
    
    /**
     *  Pops up a top-level window.
     *  It is good practice to call <code>removePopUp()</code> to remove popups
     *  created by using the <code>addPopUp()</code> method.
     *  If the class implements IFocusManagerContainer, the window will have its
     *  own FocusManager so that, if the user uses the TAB key to navigate between
     *  controls, only the controls in the window will be accessed.
     *
     *  <p><b>Example</b></p> 
     *
     *  <pre>var tw:TitleWindow = new TitleWindow();
     *    tw.title = "My Title";
     *    mx.managers.PopUpManager.addPopUp(tw, pnl, false);</pre>
     *
     *  <p>Creates a popup window using the <code>tw</code> instance of the 
     *  TitleWindow class and <code>pnl</code> as the Sprite for determining
     *  where to place the popup.
     *  It is defined to be a non-modal window.</p>
     *  
     *  @param window The IFlexDisplayObject to be popped up.
     *
     *  @param parent DisplayObject to be used for determining which SystemManager's layers
     *  to use and optionally  the reference point for centering the new
     *  top level window.  It may not be the actual parent of the popup as all popups
     *  are parented by the SystemManager.
     *
     *  @param modal If <code>true</code>, the window is modal which means that
     *  the user will not be able to interact with other popups until the window
     *  is removed.
     *
     *  @param childList The child list in which to add the pop-up.
     *  One of <code>PopUpManagerChildList.APPLICATION</code>, 
     *  <code>PopUpManagerChildList.POPUP</code>, 
     *  or <code>PopUpManagerChildList.PARENT</code> (default).
     *
     *  @param moduleFactory The moduleFactory where this pop-up should look for
     *  its embedded fonts and style manager.
     * 
     *  @see PopUpManagerChildList
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	
    public static function addPopUp(window:IFlexDisplayObject,
                    parent:Object, //DisplayObject,
                    modal:Boolean = false,
                    childList:String = null,
                    moduleFactory:Object = null):void //IFlexModuleFactory = null):void
    {
        var popUpHost:IPopUpHost = UIUtils.findPopUpHost(parent as IUIBase);
        if (modal)
        {
            var appStrand:IStrand = FlexGlobals.topLevelApplication as IStrand;
            var modalBead:IModalDisplay = appStrand.getBeadByType(IModalDisplay) as IModalDisplay;
            if (modalBead)
                modalBead.show(popUpHost);
        }
        if (popUpHost is UIComponent)
            (window as UIComponent).systemManager = (popUpHost as UIComponent).systemManager;
        popUpHost.popUpParent.addElement(window as IUIComponent);
    }
	
    /**
     *  Centers a popup window over whatever window was used in the call 
     *  to the <code>createPopUp()</code> or <code>addPopUp()</code> method.
     *
     *  <p>Note that the position of the popup window may not
     *  change immediately after this call since Flex may wait to measure and layout the
     *  popup window before centering it.</p>
     *
     *  @param The IFlexDisplayObject representing the popup.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	
    public static function centerPopUp(popUp:IFlexDisplayObject):void
    {
        UIUtils.center(popUp as IUIBase, (popUp.parent as IPopUpHostParent).popUpHost as IUIBase);
    }
	
    /**
     *  Removes a popup window popped up by 
     *  the <code>createPopUp()</code> or <code>addPopUp()</code> method.
     *  
     *  @param window The IFlexDisplayObject representing the popup window.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	
    public static function removePopUp(popUp:IFlexDisplayObject):void
    {
		UIUtils.removePopUp(popUp as IChild)
    }
} // class
} // package
