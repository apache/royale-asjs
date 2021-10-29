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

import mx.core.IUIComponent;
/* import mx.core.Singleton;
 */
 import mx.core.mx_internal;

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *  The skin for the busy cursor.
 *
 *  @default mx.skins.halo.BusyCursor
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
[Style(name="busyCursor", type="Class", inherit="no")]

/**
 *  The class to use as the skin for the busy cursor background.
 *  The default value is the "cursorStretch" symbol from the Assets.swf file.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
//[Style(name="busyCursorBackground", type="Class", inherit="no")]

/**
 *  The CursorManager class controls a prioritized list of cursors,
 *  where the cursor with the highest priority is currently visible.
 *  If the cursor list contains more than one cursor with the same priority,
 *  the Cursor Manager displays the most recently created cursor.
 *  
 *  <p>For example, if your application performs processing
 *  that requires the user to wait until the processing completes,
 *  you can change the cursor so that it reflects the waiting period.
 *  In this case, you can change the cursor to an hourglass
 *  or other image.</p>
 *  
 *  <p>You also might want to change the cursor to provide feedback
 *  to the user to indicate the actions that the user can perform.
 *  For example, you can use one cursor image to indicate that user input
 *  is enabled, and another to indicate that input is disabled. 
 *  You can use a JPEG, GIF, PNG, or SVG image, a Sprite object, or a SWF file
 *  as the cursor image.</p>
 *  
 *  <p>All methods and properties of the CursorManager are static,
 *  so you do not need to create an instance of it.</p>
 *
 *  <p>In AIR, each mx.core.Window instance uses its own instance of the CursorManager class. 
 *  Instead of directly referencing the static methods and properties of the CursorManager class, 
 *  use the <code>Window.cursorManager</code> property to reference the CursorManager instance 
 *  for the Window instance. </p>
 *
 *  @see mx.managers.CursorManagerPriority
 *  @see mx.core.Window
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
public class CursorManager 
{
    //include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Constant that is the value of <code>currentCursorID</code> property
     *  when there is no cursor managed by the CursorManager and therefore
     *  the system cursor is being displayed.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
   /*  public static const NO_CURSOR:int = 0;
     */
    //--------------------------------------------------------------------------
    //
    //  Class variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Linker dependency on implementation class.
     */
    /* private static var implClassDependency:CursorManagerImpl;
 */
    /**
     *  @private
     *  Storage for the impl getter.
     *  This gets initialized on first access,
     *  not at static initialization time, in order to ensure
     *  that the Singleton registry has already been initialized.
     */
    private static var _impl:ICursorManager;
    
    /**
     *  @private
     *  The singleton instance of CursorManagerImpl which was
     *  registered as implementing the ICursorManager interface.
     */
     private static function get impl():ICursorManager
    {
        if (!_impl)
        {
            _impl = ICursorManager(
                getInstance("mx.managers::ICursorManager"));
        }

        return _impl;
    } 
    //getInstance copied from mx.core.Singleton
	/**
     *  @private
	 *  Returns the singleton instance of the implementation class
	 *  that was registered for the specified interface,
	 *  by looking up the class in the registry
	 *  and calling its getInstance() method.
	 *
	 *  This method should not be called at static initialization time,
	 *  because the factory class may not have called registerClass() yet.
     */
	 public static function getInstance(interfaceName:String):Object
    {
	    var classMap:Object = {};

        var c:Class = classMap[interfaceName];
		if (!c)
		{
			throw new Error("No class registered for interface '" +
							interfaceName + "'.");
		}
		return c["getInstance"]();
    }
	
    /**
     *  Each mx.core.Window instance in an AIR application has its own CursorManager instance. 
     *  This method returns the CursorManager instance for the main Window instance.  
     *
     *  @return The CursorManager instance for the main Window instance in an AIR application.  
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    /*  public static function getInstance():ICursorManager
    {
        return impl;
    }  */

    //--------------------------------------------------------------------------
    //
    //  Class properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  currentCursorID
    //----------------------------------

    /**
     *  ID of the current custom cursor,
     *  or NO_CURSOR if the system cursor is showing.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public static function get currentCursorID():int
    {
        return impl.currentCursorID;
    }
    
    /**
     *  @private
     */
    public static function set currentCursorID(value:int):void
    {
        impl.currentCursorID = value;
    }

    //----------------------------------
    //  currentCursorXOffset
    //----------------------------------

    /**
     *  The x offset of the custom cursor, in pixels,
     *  relative to the mouse pointer.
     *       
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    /* public static function get currentCursorXOffset():Number
    {
        return impl.currentCursorXOffset;
    } */
    
    /**
     *  @private
     */
  /*   public static function set currentCursorXOffset(value:Number):void
    {
        impl.currentCursorXOffset = value;
    } */

    //----------------------------------
    //  currentCursorYOffset
    //----------------------------------

    /**
     *  The y offset of the custom cursor, in pixels,
     *  relative to the mouse pointer.
     *
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    /* public static function get currentCursorYOffset():Number
    {
        return impl.currentCursorYOffset;
    } */
    
    /**
     *  @private
     */
    /* public static function set currentCursorYOffset(value:Number):void
    {
        impl.currentCursorYOffset = value;
    } */

    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Makes the cursor visible.
     *  Cursor visibility is not reference-counted.
     *  A single call to the <code>showCursor()</code> method
     *  always shows the cursor regardless of how many calls
     *  to the <code>hideCursor()</code> method were made.
     *
     *  <p>Calling this method does not affect the system cursor. 
     *  Use the <code>Mouse.show()</code> and 
     *  <code>Mouse.hide()</code> methods to directly 
     *  control the system cursor. </p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    /* public static function showCursor():void
    {
        impl.showCursor();
    } */
    
    /**
     *  Makes the cursor invisible.
     *  Cursor visibility is not reference-counted.
     *  A single call to the <code>hideCursor()</code> method
     *  always hides the cursor regardless of how many calls
     *  to the <code>showCursor()</code> method were made.
     * 
     *  <p>Calling this method does not affect the system cursor. 
     *  Use the <code>Mouse.show()</code> and 
     *  <code>Mouse.hide()</code> methods to directly 
     *  control the system cursor. </p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    /* public static function hideCursor():void
    {
        impl.hideCursor();
    } */

    /**
     *  Creates a new cursor and sets an optional priority for the cursor.
     *  Adds the new cursor to the cursor list.
     *
     *  @param cursorClass Class of the cursor to display.
     *
     *  @param priority Integer that specifies
     *  the priority level of the cursor.
     *  Possible values are <code>CursorManagerPriority.HIGH</code>,
     *  <code>CursorManagerPriority.MEDIUM</code>, and <code>CursorManagerPriority.LOW</code>.
     *
     *  @param xOffset Number that specifies the x offset
     *  of the cursor, in pixels, relative to the mouse pointer.
     *
     *  @param yOffset Number that specifies the y offset
     *  of the cursor, in pixels, relative to the mouse pointer.
     *
     *  @param setter The IUIComponent that set the cursor. Necessary (in multi-window environments) 
     *  to know which window needs to display the cursor. 
     *
     *  @return The ID of the cursor.
     *
     *  @see mx.managers.CursorManagerPriority
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public static function setCursor(cursorClass:Class, priority:int = 2,
                                     xOffset:Number = 0,
                                     yOffset:Number = 0):int 
    {
        return impl.setCursor(cursorClass, priority, xOffset, yOffset);
    }
    
    /**
     *  Removes a cursor from the cursor list.
     *  If the cursor being removed is the currently displayed cursor,
     *  the CursorManager displays the next cursor in the list, if one exists.
     *  If the list becomes empty, the CursorManager displays
     *  the default system cursor.
     *
     *  @param cursorID ID of cursor to remove.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public static function removeCursor(cursorID:int):void 
    {
        impl.removeCursor(cursorID);
    } 
    
    /**
     *  Removes all of the cursors from the cursor list
     *  and restores the system cursor.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
     public static function removeAllCursors():void
    {
        impl.removeAllCursors();
    }

    /**
     *  Displays the busy cursor.
     *  The busy cursor has a priority of CursorManagerPriority.LOW.
     *  Therefore, if the cursor list contains a cursor
     *  with a higher priority, the busy cursor is not displayed 
     *  until you remove the higher priority cursor.
     *  To create a busy cursor at a higher priority level,
     *  use the <code>setCursor()</code> method.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public static function setBusyCursor():void 
    {
        COMPILE::JS
        {
            document.body.style.cursor = "wait";        
        }
        // impl.setBusyCursor();
    }

    /**
     *  Removes the busy cursor from the cursor list.
     *  If other busy cursor requests are still active in the cursor list,
     *  which means you called the <code>setBusyCursor()</code> method more than once,
     *  a busy cursor does not disappear until you remove
     *  all busy cursors from the list.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public static function removeBusyCursor():void 
    {
        COMPILE::JS
        {
            document.body.style.cursor = "auto";        
        }
        //impl.removeBusyCursor();
    }
            
    
    /**
     *  @private
     *  Called by other components if they want to display
     *  the busy cursor during progress events.
     */
    /* mx_internal static function registerToUseBusyCursor(source:Object):void
    {
        impl.registerToUseBusyCursor(source);
    } */

    /**
     *  @private
     *  Called by other components to unregister
     *  a busy cursor from the progress events.
     */
    /* mx_internal static function unRegisterToUseBusyCursor(source:Object):void
    {
        impl.unRegisterToUseBusyCursor(source);
    } */
    
}

} 
        
