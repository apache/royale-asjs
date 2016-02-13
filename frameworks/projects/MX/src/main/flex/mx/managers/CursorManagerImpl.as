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

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.display.Sprite;
import flash.events.ContextMenuEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.MouseEvent;
import flash.events.ProgressEvent;
import flash.geom.Point;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.ui.Mouse;
import mx.core.FlexGlobals;
import org.apache.flex.core.UIBase;
import mx.core.mx_internal;
import mx.core.ISystemCursorClient;
import mx.core.IUIComponent;
import mx.events.Request;
import mx.styles.CSSStyleDeclaration;
import mx.styles.StyleManager;
import mx.core.IFlexModuleFactory;

use namespace mx_internal;

[ExcludeClass]

/**
 *  @private
 */
public class CursorManagerImpl extends EventDispatcher implements ICursorManager
{
    include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private static var instance:ICursorManager;

	/**
	 * @private
	 * 
	 * Place to hook in additional classes
	 */
	public static var mixins:Array;

    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    public static function getInstance():ICursorManager
    {
        if (!instance)
            instance = new CursorManagerImpl();

        return instance;
    }

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    public function CursorManagerImpl(systemManager:ISystemManager = null)
    {
        super();

        if (instance && !systemManager)
            throw new Error("Instance already exists.");

		if (systemManager)
			this.systemManager = systemManager as ISystemManager;
		else
			this.systemManager = SystemManagerGlobals.topLevelSystemManagers[0] as ISystemManager;

		if (mixins)
		{
			var n:int = mixins.length;
			for (var i:int = 0; i < n; i++)
			{
				new mixins[i](this);
		
			}
		}
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private var nextCursorID:int = 1;
    
    /**
     *  @private
     */
    private var cursorList:Array = [];
    
    /**
     *  @private
     */
    private var busyCursorList:Array = [];
    
    /**
     *  @private
     */
    mx_internal var initialized:Boolean = false;
    
    /**
     *  @private
     */
    mx_internal var cursorHolder:Sprite;
    
    /**
     *  @private
     */
    private var currentCursor:DisplayObject;

	/**
     *  @private
     */
	private var listenForContextMenu:Boolean = false;
    
    /*******************************************************************
     * Regarding overTextField, showSystemCursor, and showCustomCursor:
     *    Don't modify or read these variables unless you are certain
     *    you will not create race conditions. E.g. you may get the
     *    wrong (or no) cursor, and get stuck in an inconsistent state.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
     
    /**
     *  @private
     */
    private var overTextField:Boolean = false;
     
    /**
     *  @private
     */
    private var overLink:Boolean = false;
     
    /**
     *  @private
     */
    private var showSystemCursor:Boolean = false;
    
    /**
     *  @private
     */
    private var showCustomCursor:Boolean = false;
    
    /**
     *  @private
     * 
     * State variable -- set when there is a custom cursor and the
     * mouse has left the stage. Upon return, mouseMoveHandler will
     * restore the custom cursor and remove the system cursor.
     */
    private var customCursorLeftStage:Boolean = false;
    
    /*******************************************************************/

    /**
     *  @private
     */
    mx_internal var systemManager:ISystemManager = null;
    
    /**
     *  @private
     */
    mx_internal var sandboxRoot:IEventDispatcher = null;
    
    /**
     *  @private
     */
    private var sourceArray:Array = [];

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  currentCursorID
    //----------------------------------

    /**
     *  @private
     */
    mx_internal var _currentCursorID:int = 0 /* CursorManager.NO_CURSOR */;

    /**
     *  ID of the current custom cursor,
     *  or CursorManager.NO_CURSOR if the system cursor is showing.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get currentCursorID():int
    {
        return _currentCursorID;
    }
    
    /**
     *  @private
     */
    public function set currentCursorID(value:int):void
    {
        _currentCursorID = value;

        if (hasEventListener("currentCursorID"))
	    	dispatchEvent(new Event("currentCursorID"));
    }

    //----------------------------------
    //  currentCursorXOffset
    //----------------------------------

    /**
     *  @private
     */
    mx_internal var _currentCursorXOffset:Number = 0;

    /**
     *  The x offset of the custom cursor, in pixels,
     *  relative to the mouse pointer.
     *       
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get currentCursorXOffset():Number 
    {
        return _currentCursorXOffset;
    }
    
    /**
     *  @private
     */
    public function set currentCursorXOffset(value:Number):void
    {
        _currentCursorXOffset = value;

        if (hasEventListener("currentCursorXOffset"))
    		dispatchEvent(new Event("currentCursorXOffset"));
    }

    //----------------------------------
    //  currentCursorYOffset
    //----------------------------------

    /**
     *  @private
     */
    mx_internal var _currentCursorYOffset:Number = 0;

    /**
     *  The y offset of the custom cursor, in pixels,
     *  relative to the mouse pointer.
     *
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get currentCursorYOffset():Number 
    {
        return _currentCursorYOffset;
    }
    
    /**
     *  @private
     */
    public function set currentCursorYOffset(value:Number):void
    {
        _currentCursorYOffset = value;

        if (hasEventListener("currentCursorYOffset"))
    		dispatchEvent(new Event("currentCursorYOffset"));
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Makes the cursor visible.
     *  Cursor visibility is not reference-counted.
     *  A single call to the <code>showCursor()</code> method
     *  always shows the cursor regardless of how many calls
     *  to the <code>hideCursor()</code> method were made.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function showCursor():void
    {
        if (cursorHolder)
	        cursorHolder.visible = true;

        if (hasEventListener("showCursor"))
    		dispatchEvent(new Event("showCursor"));
    }
    
    /**
     *  Makes the cursor invisible.
     *  Cursor visibility is not reference-counted.
     *  A single call to the <code>hideCursor()</code> method
     *  always hides the cursor regardless of how many calls
     *  to the <code>showCursor()</code> method were made.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function hideCursor():void
    {
    	if (cursorHolder)
	        cursorHolder.visible = false;
		
        if (hasEventListener("hideCursor"))
    		dispatchEvent(new Event("hideCursor"));

    }

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
     *  @productversion Flex 3
     */
    public function setCursor(cursorClass:Class, priority:int = 2,
                                     xOffset:Number = 0,
                                     yOffset:Number = 0):int 
    {
        if (hasEventListener("setCursor"))
        {
		    var event:Request = new Request("setCursor", false, true);
		    event.value = [ cursorClass, priority, xOffset, yOffset ];
		    if (!dispatchEvent(event))
		    {
			    return event.value as int;
		    }
        }

        var cursorID:int = nextCursorID++;
        
        // Create a new CursorQueueItem.
        var item:CursorQueueItem = new CursorQueueItem();
        item.cursorID = cursorID;
        item.cursorClass = cursorClass;
        item.priority = priority;
        item.x = xOffset;
        item.y = yOffset;
        if (systemManager)
        	item.systemManager = systemManager;
        else
        	item.systemManager = FlexGlobals.topLevelApplication.systemManager;
        
        // Push it onto the cursor list.
        cursorList.push(item);
        
        // Re-sort the cursor list based on priority level.
        cursorList.sort(priorityCompare);

        // Determine which cursor to display
        showCurrentCursor();
        
        return cursorID;
    }
    
    /**
     *  @private
     */
    private function priorityCompare(a:CursorQueueItem, b:CursorQueueItem):int
    {
        if (a.priority < b.priority)
            return -1;
        else if (a.priority == b.priority)
            return 0;
        
        return 1;
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
     *  @productversion Flex 3
     */
    public function removeCursor(cursorID:int):void 
    {
        if (hasEventListener("removeCursor"))
    		if (!dispatchEvent(new Request("removeCursor", false, true, cursorID)))
	    		return;

        for (var i:Object in cursorList)
        {
            var item:CursorQueueItem = cursorList[i];
            if (item.cursorID == cursorID)
            {
                // Remove the element from the array.
                cursorList.splice(i, 1); 

                // Determine which cursor to display.
                showCurrentCursor();
                    
                break;
            }
        }
    }
    
    /**
     *  Removes all of the cursors from the cursor list
     *  and restores the system cursor.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function removeAllCursors():void
    {
        if (hasEventListener("removeAllCursors"))
    		if (!dispatchEvent(new Event("removeAllCursors", false, true)))
	    		return;

        cursorList.splice(0);
        
        showCurrentCursor();
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
     *  @productversion Flex 3
     */
    public function setBusyCursor():void 
    {
        if (hasEventListener("setBusyCursor"))
    		if (!dispatchEvent(new Event("setBusyCursor", false, true)))
	    		return;

        var cursorManagerStyleDeclaration:CSSStyleDeclaration =
            StyleManager.getStyleManager(systemManager as IFlexModuleFactory).
            getMergedStyleDeclaration("mx.managers.CursorManager");
        
        var busyCursorClass:Class =
            cursorManagerStyleDeclaration.getStyle("busyCursor");
        
        busyCursorList.push(setCursor(busyCursorClass, CursorManagerPriority.LOW));
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
     *  @productversion Flex 3
     */
    public function removeBusyCursor():void 
    {
        if (hasEventListener("removeBusyCursor"))
    		if (!dispatchEvent(new Event("removeBusyCursor", false, true)))
	    		return;

        if (busyCursorList.length > 0)
            removeCursor(int(busyCursorList.pop()));
    }

    /**
     *  @private
     *  Decides what cursor to display.
     */
    private function showCurrentCursor():void 
    {
        // if there are custom cursors...
        if (cursorList.length > 0)
        {
            if (!initialized)
            {
				initialized = true;

                var e:Event;
                if (hasEventListener("initialize"))
                {
                    e = new Event("initialize", false, true);
                }
				if (!e || dispatchEvent(e))
				{
					// The first time a cursor is requested of the CursorManager,
					// create a Sprite to hold the cursor symbol
					cursorHolder = new UIBase();
					cursorHolder.name = "cursorHolder";
					cursorHolder.mouseEnabled = false;
					cursorHolder.mouseChildren = false;
               		systemManager.cursorChildren.addChild(cursorHolder);
				}
            }

            // Get the top most cursor.
            var item:CursorQueueItem = cursorList[0];
                
            // If the system cursor was being displayed, hide it.
            if (currentCursorID == CursorManager.NO_CURSOR)
                Mouse.hide();
			
            // If the current cursor has changed...
            if (item.cursorID != currentCursorID)
            {
                if (cursorHolder.numChildren > 0)
                    cursorHolder.removeChildAt(0);
                
                currentCursor = new item.cursorClass(); 
                
                if (currentCursor)
                {
                    if (currentCursor is InteractiveObject)
                        InteractiveObject(currentCursor).mouseEnabled = false;
                    if (currentCursor is DisplayObjectContainer)
                        DisplayObjectContainer(currentCursor).mouseChildren = false;
                    cursorHolder.addChild(currentCursor);
                    
                    addContextMenuHandlers();

					var pt:Point;
                    // make sure systemManager is not other implementation of ISystemManager
                    if (systemManager is SystemManager)
                    {
						pt = new Point(SystemManager(systemManager).mouseX + item.x, SystemManager(systemManager).mouseY + item.y);
						pt = SystemManager(systemManager).localToGlobal(pt);
						pt = cursorHolder.parent.globalToLocal(pt);
                    	cursorHolder.x = pt.x;
                    	cursorHolder.y = pt.y;
                    }
                    // WindowedSystemManager
                    else if (systemManager is DisplayObject)
                    {
						pt = new Point(DisplayObject(systemManager).mouseX + item.x, DisplayObject(systemManager).mouseY + item.y);
						pt = DisplayObject(systemManager).localToGlobal(pt);
						pt = cursorHolder.parent.globalToLocal(pt);
                    	cursorHolder.x = DisplayObject(systemManager).mouseX + item.x;
                    	cursorHolder.y = DisplayObject(systemManager).mouseY + item.y;
                    }
                    // otherwise
                    else
                    {
                    	cursorHolder.x = item.x;
                    	cursorHolder.y = item.y;
                    }

					COMPILE::LATER
					{
                    var e2:Event;
                    if (hasEventListener("addMouseMoveListener"))
                        e2 = new Event("addMouseMoveListener", false, true);
					if (!e2 || dispatchEvent(e2))
						systemManager.stage.addEventListener(MouseEvent.MOUSE_MOVE,
                                                   mouseMoveHandler,true,EventPriority.CURSOR_MANAGEMENT);
                    
                    var e3:Event;
                    if (hasEventListener("addMouseOutListener"))
                        e3 = new Event("addMouseOutListener", false, true);
					if (!e3 || dispatchEvent(e3))
						systemManager.stage.addEventListener(MouseEvent.MOUSE_OUT,
                                                   mouseOutHandler,true,EventPriority.CURSOR_MANAGEMENT);
					}
                }
            	
                currentCursorID = item.cursorID;
                currentCursorXOffset = item.x;
                currentCursorYOffset = item.y;
            }
        }
        else
        {
            showCustomCursor = false;

            if (currentCursorID != CursorManager.NO_CURSOR)
            {
                // There is no cursor in the cursor list to display,
                // so cleanup and restore the system cursor.
                currentCursorID = CursorManager.NO_CURSOR;
                currentCursorXOffset = 0;
                currentCursorYOffset = 0;

				COMPILE::LATER
				{
                var e4:Event;
                if (hasEventListener("removeMouseMoveListener"))
                    e4 = new Event("removeMouseMoveListener", false, true)
				if (!e4 || dispatchEvent(e4))
                {
               		systemManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE,
                                          mouseMoveHandler,true);
                }

                var e5:Event;
                if (hasEventListener("removeMouseMoveListener"))
                    e5 = new Event("removeMouseOutListener", false, true)
				if (!e5 || dispatchEvent(e5))
                {
               		systemManager.stage.removeEventListener(MouseEvent.MOUSE_OUT,
                                          mouseOutHandler,true);
                }
				}
                cursorHolder.removeChild(currentCursor);
                
				removeContextMenuHandlers();
		    }
            Mouse.show();
        }
    }
    
    /**
     *  @private
     */
    private function addContextMenuHandlers():void
    {
        if (!listenForContextMenu)
        {
            const app:InteractiveObject = systemManager.document as InteractiveObject;
        	const sm:InteractiveObject = systemManager as InteractiveObject;
        	
			COMPILE::LATER
			{
        	if (app && app.contextMenu)
        	{
        		app.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT, contextMenu_menuSelectHandler,
        		                                 true, EventPriority.CURSOR_MANAGEMENT);
        		listenForContextMenu = true;
        	}
        	
        	if (sm && sm.contextMenu)
        	{
        		sm.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT, contextMenu_menuSelectHandler,
        		                                true, EventPriority.CURSOR_MANAGEMENT);
        		listenForContextMenu = true;
        	}     
			}
        }
    }
    
    /**
     *  @private
     */
    private function removeContextMenuHandlers():void
    {
        if (listenForContextMenu)
        {
            const app:InteractiveObject = systemManager.document as InteractiveObject;
        	const sm:InteractiveObject = systemManager as InteractiveObject;
        	
        	if (app && app.contextMenu)
        		app.contextMenu.removeEventListener(ContextMenuEvent.MENU_SELECT, contextMenu_menuSelectHandler, true);

        	if (sm && sm.contextMenu)
        		sm.contextMenu.removeEventListener(ContextMenuEvent.MENU_SELECT, contextMenu_menuSelectHandler, true);
   
        	listenForContextMenu = false; 	
        }
    }
    
    /**
     *  @private
     *  Called by other components if they want to display
     *  the busy cursor during progress events.
     */
    public function registerToUseBusyCursor(source:Object):void
    {
        if (hasEventListener("registerToUseBusyCursor"))
    		if (!dispatchEvent(new Request("registerToUseBusyCursor", false, true, source)))
	    		return;

        if (source && source is EventDispatcher) 
        {
            source.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            source.addEventListener(Event.COMPLETE, completeHandler);
            source.addEventListener(IOErrorEvent.IO_ERROR, completeHandler);
        }
    }

    /**
     *  @private
     *  Called by other components to unregister
     *  a busy cursor from the progress events.
     */
    public function unRegisterToUseBusyCursor(source:Object):void
    {
        if (hasEventListener("unRegisterToUseBusyCursor"))
    		if (!dispatchEvent(new Request("unRegisterToUseBusyCursor", false, true, source)))
	    		return;

        if (source && source is EventDispatcher) 
        {
            source.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
            source.removeEventListener(Event.COMPLETE, completeHandler);
            source.removeEventListener(IOErrorEvent.IO_ERROR, completeHandler);
        }
    }
    
    /**
     *  @private
     *  Called when contextMenu is opened
     */
    private function contextMenu_menuSelectHandler(event:ContextMenuEvent):void
    {
    	showCustomCursor = true; // Restore the custom cursor
    	// Standalone player doesn't initially send mouseMove when the contextMenu is closed,
    	// so we need to listen for mouseOver as well.   	
    	sandboxRoot.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
    }
    
    /**
     *  @private
     */
    private function mouseOverHandler(event:MouseEvent):void
    {
    	sandboxRoot.removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
    	mouseMoveHandler(event);
    }
    
    /**
     *  @private
     */
    private function findSource(target:Object):int
    {
        var n:int = sourceArray.length;
        for (var i:int = 0; i < n; i++)
        {
            if (sourceArray[i] === target)
                return i;
        }
        return -1;
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     * 
     * Handles the mouse leaving the stage; hides the custom cursor and restores the system cursor.
     */
    mx_internal function mouseOutHandler(event:MouseEvent):void
    {
        // relatedObject==null implies the mouse left the stage.
        // this also fires when you are returning from a context menu click.
        //
        // it sometimes fires after you drag off the stage, and back to the stage quickly,
        // and let go of the button -- this seems like a player bug
        if ((event.relatedObject == null) && (cursorList.length > 0))
        {
            //trace("mouseOutHandler", event);
            
            // this will get unset in mouseMoveHandler (since that fires when
            // the mouse returns/glides over the stage)
            customCursorLeftStage = true;
            hideCursor();
            Mouse.show();
        }
    }

    /**
     *  @private
     */
    mx_internal function mouseMoveHandler(event:MouseEvent):void
    {
        
		var pt:Point = new Point(event.stageX, event.stageY);
		pt = cursorHolder.parent.globalToLocal(pt);
		pt.x += currentCursorXOffset;
		pt.y += currentCursorYOffset;
       	cursorHolder.x = pt.x;
       	cursorHolder.y = pt.y;

        var target:Object = event.target;
        
        var isInputTextField:Boolean = 
            (target is TextField && target.type == TextFieldType.INPUT) ||
                (target is ISystemCursorClient && 
                    ISystemCursorClient(target).showSystemCursor);
        
        // Do target test.
        if (!overTextField && isInputTextField)
        {   
            overTextField = true;
            showSystemCursor = true;
        } 
        else if (overTextField && !isInputTextField)
        {
            overTextField = false;
            showCustomCursor = true;
        }
		else
		{
			showCustomCursor = true
		}
    
        // Handle switching between system and custom cursor.
        if (showSystemCursor)
        {
            showSystemCursor = false;
			cursorHolder.visible = false;
            Mouse.show();
        }
        if (showCustomCursor)
        {
            showCustomCursor = false;
			cursorHolder.visible = true;
            Mouse.hide();

            if (hasEventListener("showCustomCursor"))
	    		dispatchEvent(new Event("showCustomCursor"));
        }
    }
    
    /**
     *  @private
     *  Displays the busy cursor if a component is in a busy state.
     */
    private function progressHandler(event:ProgressEvent):void
    {
        // Only pay attention to the first progress call. Ignore all others.
        var sourceIndex:int = findSource(event.target);
        if (sourceIndex == -1)
        {
            // Add the target to the list of objects we are listening for.
            sourceArray.push(event.target);
            
            setBusyCursor();
        }
    }
    
    /**
     *  @private
     */
    private function completeHandler(event:Event):void
    {
        var sourceIndex:int = findSource(event.target);
        if (sourceIndex != -1)
        {
            // Remove from the list of targets we are listening to.
            sourceArray.splice(sourceIndex, 1);
            
            removeBusyCursor();
        }
    }

}

}

import mx.managers.CursorManager;
import mx.managers.CursorManagerPriority;
import mx.managers.ISystemManager;

////////////////////////////////////////////////////////////////////////////////
//
//  Helper class: CursorQueueItem
//
////////////////////////////////////////////////////////////////////////////////

/**
 *  @private
 */
class CursorQueueItem
{
    include "../core/Version.as";

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
    public function CursorQueueItem()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    public var cursorID:int = CursorManager.NO_CURSOR;

    /**
     *  @private
     */
    public var cursorClass:Class = null;

    /**
     *  @private
     */
    public var priority:int = CursorManagerPriority.MEDIUM;
    
     /**
     *  @private
     */
    public var systemManager:ISystemManager;

    /**
     *  @private
     */
    public var x:Number;

    /**
     *  @private
     */
    public var y:Number;
}

