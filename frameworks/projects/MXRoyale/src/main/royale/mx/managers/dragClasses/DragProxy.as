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

package mx.managers.dragClasses
{

/*import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.system.ApplicationDomain;
import flash.utils.getQualifiedClassName;*/

import mx.events.KeyboardEvent;

import mx.core.DragSource;
import mx.core.IFlexModule;
import mx.core.IUIComponent;
import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.effects.EffectInstance;
import mx.effects.Move;
//import mx.effects.Zoom;
import mx.events.DragEvent;
import mx.events.EffectEvent;
//import mx.events.InterDragManagerEvent;
//import mx.events.InterManagerRequest;
import mx.events.SandboxMouseEvent;
import mx.managers.CursorManager;
import mx.managers.DragManager;
import mx.managers.ISystemManager;
import mx.managers.SystemManager;
import mx.modules.ModuleManager;
import mx.styles.CSSStyleDeclaration;
import mx.styles.IStyleManager2;
import mx.styles.StyleManager;

use namespace mx_internal;

[ExcludeClass]

/**
 *  @private
 *  A helper class for DragManager that displays the drag image
 */
public class DragProxy extends UIComponent
{
    //include "../../core/Version.as";

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
    public function DragProxy(dragInitiator:IUIComponent,
							  dragSource:DragSource)
    {
		super();
        typeNames = 'DragProxy';
        this.dragInitiator = dragInitiator;
        this.dragSource = dragSource;

        /*var sm:ISystemManager = dragInitiator.systemManager.
									topLevelSystemManager as ISystemManager;
		
		var ed:IEventDispatcher = sandboxRoot = sm.getSandboxRoot();

        ed.addEventListener(MouseEvent.MOUSE_MOVE,
							mouseMoveHandler, true);
        
		ed.addEventListener(MouseEvent.MOUSE_UP,
							mouseUpHandler, true);

        ed.addEventListener(KeyboardEvent.KEY_DOWN,
							keyDownHandler);

        ed.addEventListener(KeyboardEvent.KEY_UP,
							keyUpHandler);*/
        COMPILE::JS{
            this.element.style.pointerEvents = 'none';
        }
        COMPILE::SWF{
            this.mouseEnabled = false;
            this.mouseChildren = false;
        }

    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	/*override public function initialize():void
	{
		super.initialize();
		// in case we go offscreen
		dragInitiator.systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, 
													 mouseLeaveHandler);

		// Make sure someone has focus, otherwise we
		// won't get keyboard events.
		if (!getFocus())
			setFocus();
	}*/

    /**
     *  @private
     */
    /*override public function get styleManager():IStyleManager2
    {
        // If the dragInitiator has a styleManager, use that one.
        // In a situation where a main application that loads a module with drag initiator,
        // the main application may not link in the DragManager and appropriate styles.
        // We want to use the styles of the module of the dragInitiator. See SDK-24324.
        if (this.dragInitiator is IFlexModule)
            return StyleManager.getStyleManager(IFlexModule(dragInitiator).moduleFactory);
        
        return super.styleManager;
    }*/
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Class of current cursor being displayed.
     */
    private var cursorClass:Object = null;

    /**
     *  @private
     *  ID of current cursor.
     */
    private var cursorID:int = CursorManager.NO_CURSOR;

    /**
     *  @private
     *  Last keyboard event received
     */
  //  private var lastKeyEvent:KeyboardEvent;

    /**
     *  @private
     *  Last Mouse event received
     */
  //  private var lastMouseEvent:MouseEvent;

    /**
     *  @private
     *  Root of sandbox
     */
 //   private var sandboxRoot:IEventDispatcher;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    public var dragInitiator:IUIComponent;

    /**
     *  @private
     */
    public var dragSource:DragSource;

    /**
     *  @private
     */
    public var xOffset:Number;

    /**
     *  @private
     */
    public var yOffset:Number;

    /**
     *  @private
     */
    public var startX:Number;

    /**
     *  @private
     */
    public var startY:Number;

    /**
     *  @private
     */
    public var target:IUIComponent/*DisplayObject*/ = null;

    /**
     *  @private
     *  Current drag action - NONE, COPY, MOVE or LINK
     */
    public var action:String;

    /**
     *  @private
     *  whether move is allowed or not
     */
    public var allowMove:Boolean = true;

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    //temp DEV support:

    /*COMPILE::JS
    private static var _devTarget:HTMLElement;

    /!**
     * @royaleignorecoercion HTMLElement
     *!/
    COMPILE::JS
    override public function addedToParent():void{
        super.addedToParent();
        var target:HTMLElement = _devTarget || (_devTarget = document.createElement('div') as HTMLElement);
        target.textContent = '';


        var content:String = element.outerHTML;
        target.innerHTML = content;
        document.body.appendChild(target);

        target.style.top = '0px'
        target.style.left = '400px';
        target.style.position = 'absolute';
        target.style.width = element.style.width;
        target.style.height = element.style.width;
        //DragProxy clone:
        target.firstElementChild.style.top = '0'
        target.firstElementChild.style.left = '0'
        //LookAlike clone
        target.firstElementChild.firstElementChild.style.top = '0'
        target.firstElementChild.firstElementChild.style.left = '0'

    }*/

    COMPILE::JS
    override protected function computeFinalClassNames():String{
        var ret:String = super.computeFinalClassNames();
        if (this.action) ret += ' ' + action;
        return ret;
    }

    COMPILE::JS
    private var actionClass:String;
    /**
     *  @private
     */
    public function showFeedback():void
    {
        var newCursorClass:Object = cursorClass;
        //@todo reimplement:
		/*var styleSheet:CSSStyleDeclaration =
						styleManager.getStyleDeclaration("mx.managers.DragManager");

        if (action == DragManager.COPY)
            newCursorClass = styleSheet.getStyle("copyCursor");
        else if (action == DragManager.LINK)
            newCursorClass = styleSheet.getStyle("linkCursor");
        else if (action == DragManager.NONE)
            newCursorClass = styleSheet.getStyle("rejectCursor");
        else
            newCursorClass = styleSheet.getStyle("moveCursor");*/

        COMPILE::JS {

            switch(action) {
                case DragManager.COPY :
                    newCursorClass = 'copy';
                    break;
                case DragManager.LINK :
                    newCursorClass = 'alias';
                    break;
                case DragManager.NONE :
                    newCursorClass = 'no-drop';
                    break;
                default:
                    newCursorClass = 'move';
                    break;
            }
        }

        if (newCursorClass != cursorClass)
        {
            cursorClass = newCursorClass;
            if (cursorID != CursorManager.NO_CURSOR)
                cursorManager.removeCursor(cursorID);

           cursorID = cursorManager.setCursor(cursorClass, 2, 0, 0);
        }

        COMPILE::JS {
            if (action != actionClass) {
                if (actionClass) element.classList.remove(actionClass);
                if (action) element.classList.add(action);

               /*//TODO REMOVE Temp Dev support
                if (_devTarget) {
                    var devElement:HTMLElement = _devTarget.firstElementChild as HTMLElement;
                    if (actionClass) devElement.classList.remove(actionClass);
                    if (action) devElement.classList.add(action);
                }*/

                actionClass = action;
            }
        }
    }

    /**
     *  @private
     */
    public function checkKeyEvent(event:KeyboardEvent):void
    {
        if (target)
        {
            // Ignore repeat events. We only send the dragOver
            // event when the key state changes.
            /*if (lastKeyEvent
                && (event.type == lastKeyEvent.type)
                && (event.keyCode == lastKeyEvent.keyCode))
            {
                return;
            }

            lastKeyEvent = event;

            // Dispatch a "dragOver" event.
            var dragEvent:DragEvent = new DragEvent(DragEvent.DRAG_OVER);
			dragEvent.dragInitiator = dragInitiator;
            dragEvent.dragSource = dragSource;
            dragEvent.action = action;
            dragEvent.ctrlKey = event.ctrlKey;
            dragEvent.altKey = event.altKey;
            dragEvent.shiftKey = event.shiftKey;
            var pt:Point = new Point();
            pt.x = lastMouseEvent.localX;
            pt.y = lastMouseEvent.localY;
            pt = DisplayObject(lastMouseEvent.target).localToGlobal(pt);
            pt = DisplayObject(target).globalToLocal(pt);
            dragEvent.localX = pt.x;
            dragEvent.localY = pt.y;

            _dispatchDragEvent(target, dragEvent);*/

            showFeedback();
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden event handlers
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override protected function keyDownHandler(event:KeyboardEvent):void
    {
        // On every key down call the mouseMove because the drag
        // feedback may change
        checkKeyEvent(event);
    }

    /**
     *  @private
     */
    override protected function keyUpHandler(event:KeyboardEvent):void
    {
        checkKeyEvent(event);
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------


    /**
     *  @private
     */
    /*public function stage_mouseMoveHandler(event:MouseEvent):void
    {
		if (event.target != stage)
			return;

		mouseMoveHandler(event);
	}*/

	/**
	 *  @private
	 */
	/*private function dispatchDragEvent(type:String, mouseEvent:MouseEvent, eventTarget:Object):void
	{
		var dragEvent:DragEvent = new DragEvent(type);
		var pt:Point = new Point();
		
		dragEvent.dragInitiator = dragInitiator;
		dragEvent.dragSource = dragSource;
		dragEvent.action = action;
		dragEvent.ctrlKey = mouseEvent.ctrlKey;
		dragEvent.altKey = mouseEvent.altKey;
		dragEvent.shiftKey = mouseEvent.shiftKey;
		pt.x = lastMouseEvent.localX;
		pt.y = lastMouseEvent.localY;
		pt = DisplayObject(lastMouseEvent.target).localToGlobal(pt);
		pt = DisplayObject(eventTarget).globalToLocal(pt);
		dragEvent.localX = pt.x;
		dragEvent.localY = pt.y;
		_dispatchDragEvent(DisplayObject(eventTarget), dragEvent);
	}*/
	
    /**
     *  @private
     */
    /*private function _dispatchDragEvent(target:DisplayObject, event:DragEvent):void
    {
		// in trusted mode, the target could be in another application domain
		// in untrusted mode, the mouse events shouldn't work so we shouldn't be here

		// same domain
		if (isSameOrChildApplicationDomain(target))
			target.dispatchEvent(event);
		else
		{
			// wake up all the other DragManagers
			var me:InterManagerRequest = new InterManagerRequest(InterManagerRequest.INIT_MANAGER_REQUEST);
			me.name = "mx.managers::IDragManager";
			sandboxRoot.dispatchEvent(me);
			// bounce this message off the sandbox root and hope
			// another DragManager picks it up
			var mde:InterDragManagerEvent = new InterDragManagerEvent(InterDragManagerEvent.DISPATCH_DRAG_EVENT, false, false,
													event.localX,
													event.localY,
													event.relatedObject,
													event.ctrlKey,
													event.altKey,
													event.shiftKey,
													event.buttonDown,
													event.delta,
													target,
													event.type,
													event.dragInitiator,
													event.dragSource,
													event.action,
													event.draggedItem
													);
			sandboxRoot.dispatchEvent(mde);
		}
	}*/

	/*private function isSameOrChildApplicationDomain(target:Object):Boolean
	{
		var swfRoot:DisplayObject = SystemManager.getSWFRoot(target);
		if (swfRoot)
			return true;

        if (ModuleManager.getAssociatedFactory(target))
            return true;
        
		var me:InterManagerRequest = new InterManagerRequest(InterManagerRequest.SYSTEM_MANAGER_REQUEST);
		me.name = "hasSWFBridges";
		sandboxRoot.dispatchEvent(me);
		
		// if no bridges, it might be a private/internal class so return true and hope we're right
		if (!me.value) return true;

		return false;
	}*/

    /**
     *  @private
     */
    /*public function mouseMoveHandler(event:MouseEvent):void
    {
        var dragEvent:DragEvent;
        var dropTarget:DisplayObject;
        var i:int;

        lastMouseEvent = event;

        var pt:Point = new Point();
        var point:Point = new Point(event.localX, event.localY);
        var stagePoint:Point = DisplayObject(event.target).localToGlobal(point);
        point = DisplayObject(sandboxRoot).globalToLocal(stagePoint);
        var mouseX:Number = point.x;
        var mouseY:Number = point.y;
        x = mouseX - xOffset;
        y = mouseY - yOffset;

        // The first time through we only want to position the proxy.
        if (!event)
        {
            return;
        }


		// trace("===>DragProxy:mouseMove");
		var targetList:Array; /!* of DisplayObject *!/
		targetList = [];
		DragProxy.getObjectsUnderPoint(DisplayObject(sandboxRoot), stagePoint, targetList);

		var newTarget:DisplayObject = null;
		// trace("   ", targetList.length, "objects under point");
		
		// targetList is in depth order, and we want the top of the list. However, we
		// do not want the target to be a decendent of us.
		var targetIndex:int = targetList.length - 1;
		while (targetIndex >= 0)
		{
			newTarget = targetList[targetIndex];
			if (newTarget != this && !contains(newTarget))
				break;
			targetIndex--;
		}
		// trace("    skipped", targetList.length - targetIndex - 1);
			
        // If we already have a target, send it a dragOver event
        // if we're still over it.
        // If we're not over it, send it a dragExit event.
        if (target)
        {
            var foundIt:Boolean = false;
            var oldTarget:DisplayObject = target;

			dropTarget = newTarget;

			while (dropTarget)
			{
				if (dropTarget == target)
				{
					// trace("    dispatch DRAG_OVER on", dropTarget);
					// Dispatch a "dragOver" event
					dispatchDragEvent(DragEvent.DRAG_OVER, event, dropTarget);
					foundIt = true;
					break;
				} 
				else 
				{
					// trace("    dispatch DRAG_ENTER on", dropTarget);
					// Dispatch a "dragEnter" event and see if a new object
					// steals the target.
					dispatchDragEvent(DragEvent.DRAG_ENTER, event, dropTarget);
					
					// If the potential target accepted the drag, our target
					// now points to the dropTarget. Bail out here, but make 
					// sure we send a dragExit event to the oldTarget.
					if (target == dropTarget)
					{
						foundIt = false;
						break;
					}
				}
				dropTarget = dropTarget.parent;
			}

            if (!foundIt)
            {
				// trace("    dispatch DRAG_EXIT on", oldTarget);
                // Dispatch a "dragExit" event on the old target.
                dispatchDragEvent(DragEvent.DRAG_EXIT, event, oldTarget);

				if (target == oldTarget)
               		target = null;
            }
        }

        // If we don't have an existing target, go look for one.
        if (!target)
        {
            action = DragManager.MOVE;

            // Dispatch a "dragEnter" event.
			dropTarget = newTarget;
			while (dropTarget)
			{
				if (dropTarget != this)
				{
					// trace("    dispatch DRAG_ENTER on", dropTarget);
					dispatchDragEvent(DragEvent.DRAG_ENTER, event, dropTarget);
					if (target)
						break;
				}
				dropTarget = dropTarget.parent;
			}

            if (!target)
                action = DragManager.NONE;
        }
		// trace("<===DragProxy:mouseMove");


        showFeedback();
    }*/

    /**
     *  @private
     */
	/*public function mouseLeaveHandler(event:Event):void
	{
		mouseUpHandler(lastMouseEvent);
	}*/

    /**
     *  @private
     */
    /*public function mouseUpHandler(event:MouseEvent):void
    {
        var dragEvent:DragEvent;

        var sm:ISystemManager = dragInitiator.systemManager.
									topLevelSystemManager as ISystemManager;
		
		var ed:IEventDispatcher = sandboxRoot;

		ed.removeEventListener(MouseEvent.MOUSE_MOVE,
                               mouseMoveHandler, true);

        ed.removeEventListener(MouseEvent.MOUSE_UP,
                               mouseUpHandler, true);

        ed.removeEventListener(KeyboardEvent.KEY_DOWN,
                               keyDownHandler);

		// in case we go offscreen
		ed.removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, 
							   mouseLeaveHandler);

        ed.removeEventListener(KeyboardEvent.KEY_UP,
                               keyUpHandler);
		var delegate:Object = automationDelegate;
        if (target && action != DragManager.NONE)
        {
			// Dispatch a "dragDrop" event.
            dragEvent = new DragEvent(DragEvent.DRAG_DROP);
			dragEvent.dragInitiator = dragInitiator;
            dragEvent.dragSource = dragSource;
            dragEvent.action = action;
            dragEvent.ctrlKey = event.ctrlKey;
            dragEvent.altKey = event.altKey;
            dragEvent.shiftKey = event.shiftKey;
            var pt:Point = new Point();
            pt.x = lastMouseEvent.localX;
            pt.y = lastMouseEvent.localY;
            pt = DisplayObject(lastMouseEvent.target).localToGlobal(pt);
            pt = DisplayObject(target).globalToLocal(pt);
            dragEvent.localX = pt.x;
            dragEvent.localY = pt.y;
			if (delegate)
            	delegate.recordAutomatableDragDrop(target, dragEvent);
            _dispatchDragEvent(target, dragEvent);
        }
        else
        {
            action = DragManager.NONE;
        }

        // Do the drop effect.
        // If the drop was accepted, zoom the proxy image into
        // the current mouse location.
        // If the drop was rejected, move the proxy image
        // back to its original location.
        if (action == DragManager.NONE)
        {
            // Tween back to original position
            var m1:Move = new Move(this);
            m1.addEventListener(EffectEvent.EFFECT_END, effectEndHandler);
            m1.xFrom = x;
            m1.yFrom = y;
            m1.xTo = startX;
            m1.yTo = startY;
            m1.duration = 200;
            m1.play();
        }
        else
        {
            // Zoom into mouse location to show drag was accepted.
            var e:Zoom = new Zoom(this);
            e.zoomWidthFrom = e.zoomHeightFrom = 1.0;
            e.zoomWidthTo = e.zoomHeightTo = 0;
            e.duration = 200;
            e.play();

            var m:Move = new Move(this);
            m.addEventListener(EffectEvent.EFFECT_END, effectEndHandler);
            m.xFrom = x;
            m.yFrom = y;
            m.xTo = parent.mouseX;
            m.yTo = parent.mouseY;
            m.duration = 200;
            m.play();
        }

        // Dispatch a "dragComplete" event.
        dragEvent = new DragEvent(DragEvent.DRAG_COMPLETE);
		dragEvent.dragInitiator = dragInitiator;
        dragEvent.dragSource = dragSource;
        dragEvent.relatedObject = InteractiveObject(target);
        dragEvent.action = action;
        dragEvent.ctrlKey = event.ctrlKey;
        dragEvent.altKey = event.altKey;
        dragEvent.shiftKey = event.shiftKey;
        dragInitiator.dispatchEvent(dragEvent);

       if (delegate && action == DragManager.NONE)
	   delegate.recordAutomatableDragCancel(dragInitiator, dragEvent);
        // Hide the drag cursor
        cursorManager.removeCursor(cursorID);
        cursorID = CursorManager.NO_CURSOR;

        this.lastMouseEvent = null;
    }*/

    /**
     *  @private
     */
    private function effectEndHandler(event:EffectEvent):void
    {
        DragManager.endDrag();
    }

	/**
	 *  Player doesn't handle this correctly so we have to do it ourselves
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	/*private static function getObjectsUnderPoint(obj:DisplayObject, pt:Point, arr:Array):void
	{
		if (!obj.visible)
			return;

        if ((obj is UIComponent) && !UIComponent(obj).$visible)
			return;

		if (obj.hitTestPoint(pt.x, pt.y, true))
		{
			if (obj is InteractiveObject && InteractiveObject(obj).mouseEnabled)
				arr.push(obj);
			if (obj is DisplayObjectContainer)
			{
				var doc:DisplayObjectContainer = obj as DisplayObjectContainer;
				if (doc.mouseChildren)
				{
					// we use this test so we can test in other application domains
					if ("rawChildren" in doc)
					{
						var rc:Object = doc["rawChildren"];
						n = rc.numChildren;
						for (i = 0; i < n; i++)
						{
							try
							{
								getObjectsUnderPoint(rc.getChildAt(i), pt, arr);
							}
							catch (e:Error)
							{
								//another sandbox?
							}
						}
					}
					else
					{
						if (doc.numChildren)
						{
							var n:int = doc.numChildren;
							for (var i:int = 0; i < n; i++)
							{
								try
								{
									var child:DisplayObject = doc.getChildAt(i);
									getObjectsUnderPoint(child, pt, arr);
								}
								catch (e:Error)
								{
									//another sandbox?
								}
							}
						}
					}
				}
			}
		}
	}*/

}

}
