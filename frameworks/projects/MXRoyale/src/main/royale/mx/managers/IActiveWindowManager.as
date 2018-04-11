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

import mx.managers.IFocusManagerContainer;

[ExcludeClass]

/**
 *  Interface for subsystem that manages which focus manager is active
 *  when there is more than one IFocusManagerContainer on screen.
 */
public interface IActiveWindowManager
{
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

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
	 */
	function get numModalWindows():int;

	/**
	 *  @private
	 */
	function set numModalWindows(value:int):void;


	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------

	/**
	 *  Registers a top-level window containing a FocusManager.
	 *  Called by the FocusManager, generally not called by application code.
	 *
	 *  @param f The top-level window in the application.
	 */
	function addFocusManager(f:IFocusManagerContainer):void;

	/**
	 *  Unregisters a top-level window containing a FocusManager.
	 *  Called by the FocusManager, generally not called by application code.
	 *
	 *  @param f The top-level window in the application.
	 */
	function removeFocusManager(f:IFocusManagerContainer):void;

	/**
	 *  Activates the FocusManager in an IFocusManagerContainer.
	 * 
	 *  @param f IFocusManagerContainer the top-level window
	 *  whose FocusManager should be activated.
	 */
	function activate(f:Object):void;
	
	/**
	 *  Deactivates the FocusManager in an IFocusManagerContainer, and activate
	 *  the FocusManager of the next highest window that is an IFocusManagerContainer.
	 * 
	 *  @param f IFocusManagerContainer the top-level window
	 *  whose FocusManager should be deactivated.
	 */
	function deactivate(f:Object):void;

}

}
