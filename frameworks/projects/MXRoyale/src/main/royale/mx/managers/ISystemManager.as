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

import org.apache.royale.events.IEventDispatcher;
import mx.core.IChildList;
import mx.core.UIComponent;
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
 *  @productversion Royale 0.9.4
 */
public interface ISystemManager extends IEventDispatcher, IChildList /*, IFlexModuleFactory */
{
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

    //----------------------------------
    //  component
    //----------------------------------
    
    /**
     *  A reference to the document object. 
     *  A document object is an Object at the top of the hierarchy of a 
     *  Flex application, MXML component, or AS component.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    function get mxmlDocument():Object;
    
    /**
     *  @private
     */
    function set mxmlDocument(value:Object):void;
    function get rawChildren():IChildList;
    function get numModalWindows():int;
    function set numModalWindows(value:int):void;
 
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	/**
     *  Gets the system manager that is the root of all
     *  top level system managers in this SecurityDomain.
     *
     *  @return the highest-level systemManager in the sandbox
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    function getSandboxRoot():Object;
    
}

}
