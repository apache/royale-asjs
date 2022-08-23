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

import org.apache.royale.events.EventDispatcher;
import org.apache.royale.events.IEventDispatcher;
import org.apache.royale.core.IStrand;


import mx.core.DragSource;
import mx.core.IFlexDisplayObject;
import mx.core.IFlexModule;
import mx.core.IFlexModuleFactory;
import mx.core.IUIComponent;
import mx.core.LayoutDirection;
import mx.core.UIComponentGlobals;
import mx.core.mx_internal;
// import mx.events.DragEvent;
import mx.styles.CSSStyleDeclaration;
import mx.styles.IStyleManager2;
import mx.styles.StyleManager;
import org.apache.royale.core.IBead;
import org.apache.royale.html.beads.controllers.DragMouseController;
import org.apache.royale.html.beads.DragDropListView;
import org.apache.royale.events.DragEvent;
import org.apache.royale.html.beads.controllers.DropMouseController;
import org.apache.royale.html.accessories.RestrictTextInputBead;

// use namespace mx_internal;

// [ExcludeClass]

/**
 *  @private
 */
public class DragManagerImpl extends EventDispatcher implements IDragManager, IBead
{
//     include "../core/Version.as";

	//--------------------------------------------------------------------------
	//
	//  Class variables
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	private static var sm:ISystemManager;

	/**
	 *  @private
	 */
	private static var instance:IDragManager;

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
	public static function getInstance():IDragManager
	{
		if (!instance)
		instance = new DragManagerImpl();

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
	public function DragManagerImpl()
	{
		super();

		if (instance)
			throw new Error("Instance already exists.");
			
		if (mixins)
		{
			var n:int = mixins.length;
			for (var i:int = 0; i < n; i++)
			{
				new mixins[i](this);
			}
		}

		// sandboxRoot = sm.getSandboxRoot();

		// if (sm.isTopLevelRoot())
		// {
		// 	sm.addEventListener(MouseEvent.MOUSE_DOWN, sm_mouseDownHandler, false, 0, true);
		// 	sm.addEventListener(MouseEvent.MOUSE_UP, sm_mouseUpHandler, false, 0, true);
		// }

        if (hasEventListener("initialize"))
		    dispatchEvent(new Event("initialize"));

	}

	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
	

	/**
	 *  @private
	 *  The highest place we can listen for events in our DOM
	 */
	private var sandboxRoot:IEventDispatcher;

	/**
	 *  @private
	 *  Object that initiated the drag.
	 */
	private var dragInitiator:IUIComponent;

	/**
	 *  @private
	 *  Object being dragged around.
	 */
	public var dragProxy:DragProxy;

	/**
	 *  @private
	 */
	public var bDoingDrag:Boolean = false;

	/**
	 *  @private
	 */
	private var mouseIsDown:Boolean = false;

	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  Read-only property that returns <code>true</code>
	 *  if a drag is in progress.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get isDragging():Boolean
	{
		return bDoingDrag;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------

	/**
	 *  Initiates a drag and drop operation.
	 *
	 *  @param dragInitiator IUIComponent that specifies the component initiating
	 *  the drag.
	 *
	 *  @param dragSource DragSource object that contains the data
	 *  being dragged.
	 *
	 *  @param mouseEvent The MouseEvent that contains the mouse information
	 *  for the start of the drag.
	 *
	 *  @param dragImage The image to drag. This argument is optional.
	 *  If omitted, a standard drag rectangle is used during the drag and
	 *  drop operation. If you specify an image, you must explicitly set a 
	 *  height and width of the image or else it will not appear.
	 *
	 *  @param xOffset Number that specifies the x offset, in pixels, for the
	 *  <code>dragImage</code>. This argument is optional. If omitted, the drag proxy
	 *  is shown at the upper-left corner of the drag initiator. The offset is expressed
	 *  in pixels from the left edge of the drag proxy to the left edge of the drag
	 *  initiator, and is usually a negative number.
	 *
	 *  @param yOffset Number that specifies the y offset, in pixels, for the
	 *  <code>dragImage</code>. This argument is optional. If omitted, the drag proxy
	 *  is shown at the upper-left corner of the drag initiator. The offset is expressed
	 *  in pixels from the top edge of the drag proxy to the top edge of the drag
	 *  initiator, and is usually a negative number.
	 *
	 *  @param imageAlpha Number that specifies the alpha value used for the
	 *  drag image. This argument is optional. If omitted, the default alpha
	 *  value is 0.5. A value of 0.0 indicates that the image is transparent;
	 *  a value of 1.0 indicates it is fully opaque. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function doDrag(
			dragInitiator:IUIComponent, 
			dragSource:DragSource, 
			mouseEvent:MouseEvent,
			dragImage:IFlexDisplayObject = null, // instance of dragged item(s)
			xOffset:Number = 0,
			yOffset:Number = 0,
			imageAlpha:Number = 0.5,
			allowMove:Boolean = true):void
	{
	// 	var proxyWidth:Number;
	// 	var proxyHeight:Number;
		
	// 	// Can't start a new drag if we're already in the middle of one...
	// 	if (bDoingDrag)
	// 		return;
		
	// 	// Can't do a drag if the mouse isn't down
	// 	if (!(mouseEvent.type == MouseEvent.MOUSE_DOWN ||
	// 		  mouseEvent.type == MouseEvent.CLICK ||
	// 		  mouseIsDown ||
	// 		  mouseEvent.buttonDown))
	// 	{
	// 		return;
	// 	}    
			
	// 	bDoingDrag = true;

        if (hasEventListener("doDrag"))
    		dispatchEvent(new Event("doDrag"));

	// 	this.dragInitiator = dragInitiator;

	// 	// The drag proxy is a UIComponent with a single child -
	// 	// an instance of the dragImage.
	// 	dragProxy = new DragProxy(dragInitiator, dragSource);

        // var e:Event; 
        // if (hasEventListener("popUpChildren"))
        //     e = new DragEvent("popUpChildren", false, true, dragProxy);
        // if (!e || dispatchEvent(e))	
	// 		sm.popUpChildren.addChild(dragProxy);	

	// 	if (!dragImage)
	// 	{
	// 		// No drag image specified, use default
	// 		var dragManagerStyleDeclaration:CSSStyleDeclaration =
        //         getStyleManager(dragInitiator).getMergedStyleDeclaration("mx.managers.DragManager");
	// 		var dragImageClass:Class =
	// 			dragManagerStyleDeclaration.getStyle("defaultDragImageSkin");
	// 		dragImage = new dragImageClass();
	// 		dragProxy.addChild(DisplayObject(dragImage));
	// 		proxyWidth = dragInitiator.width;
	// 		proxyHeight = dragInitiator.height;
	// 	}
	// 	else
	// 	{
	// 		dragProxy.addChild(DisplayObject(dragImage));
	// 		if (dragImage is ILayoutManagerClient )
	// 			UIComponentGlobals.layoutManager.validateClient(ILayoutManagerClient (dragImage), true);
	// 		if (dragImage is IUIComponent)
	// 		{
	// 			proxyWidth = (dragImage as IUIComponent).getExplicitOrMeasuredWidth();
	// 			proxyHeight = (dragImage as IUIComponent).getExplicitOrMeasuredHeight();
	// 		}
	// 		else
	// 		{
	// 			proxyWidth = dragImage.measuredWidth;
	// 			proxyHeight = dragImage.measuredHeight;
	// 		}
	// 	}

        // // Set the layoutDirection of the dragProxy and dragImage to match the dragInitiator
        // // to ensure that they will be in the right position and orientation.
        // if (dragInitiator is ILayoutDirectionElement &&
        //     ILayoutDirectionElement(dragInitiator).layoutDirection == LayoutDirection.RTL)
        //     dragProxy.layoutDirection = LayoutDirection.RTL;
        
	// 	dragImage.setActualSize(proxyWidth, proxyHeight);
	// 	dragProxy.setActualSize(proxyWidth, proxyHeight);
		
	// 	// Alpha
	// 	dragProxy.alpha = imageAlpha;

	// 	dragProxy.allowMove = allowMove;
		
        // // Make sure any scale/rotation from the initiator will be reflected.
        // var concatenatedMatrix:Matrix = 
        //     MatrixUtil.getConcatenatedMatrix(DisplayObject(dragInitiator), 
        //                                      DisplayObject(sandboxRoot));
        
        // // Zero out the translation part of the matrix, as we're going to 
        // // position the dragProxy explicitly further below.        
        // concatenatedMatrix.tx = 0;
        // concatenatedMatrix.ty = 0;
        // // Combine with the matrix of the dragImage if it has any.
        // var m:Matrix = dragImage.transform.matrix;
        // if (m)
        // {
        //     concatenatedMatrix.concat(dragImage.transform.matrix);
        //     dragImage.transform.matrix = concatenatedMatrix;
        // }
        
        // // Find mouse coordinates in global space
        // var nonNullTarget:Object = mouseEvent.target;
	// 	if (nonNullTarget == null)
	// 		nonNullTarget = dragInitiator;
		
	// 	var point:Point = new Point(mouseEvent.localX, mouseEvent.localY);
	// 	point = DisplayObject(nonNullTarget).localToGlobal(point);
	// 	point = DisplayObject(sandboxRoot).globalToLocal(point);
	// 	var mouseX:Number = point.x;
	// 	var mouseY:Number = point.y;

        // // Find the proxy origin in global space
        // var proxyOrigin:Point = DisplayObject(dragInitiator).localToGlobal(new Point(-xOffset, -yOffset));
        // proxyOrigin = DisplayObject(sandboxRoot).globalToLocal(proxyOrigin);
        
        // // Set dragProxy.offset to the mouse offset within the drag proxy.
        // dragProxy.xOffset = mouseX - proxyOrigin.x;
        // dragProxy.yOffset = mouseY - proxyOrigin.y;
                
        // // Setup the initial position of the drag proxy.
        // dragProxy.x = proxyOrigin.x;
        // dragProxy.y = proxyOrigin.y;
		
	// 	// Remember the starting location of the drag proxy so it can be
	// 	// "snapped" back if the drop was refused.
	// 	dragProxy.startX = dragProxy.x;
	// 	dragProxy.startY = dragProxy.y;

	// 	// Turn on caching.
	// 	if (dragImage is DisplayObject) 
	// 		DisplayObject(dragImage).cacheAsBitmap = true;
			

	// 	var delegate:Object = dragProxy.automationDelegate;
	// 	if (delegate)
	// 		delegate.recordAutomatableDragStart(dragInitiator, mouseEvent);
		
		var dragController:DragMouseController = (dragInitiator as IStrand).getBeadByType(DragMouseController) as DragMouseController;
		if (!dragController)
		{
			dragController = new DragMouseController();
		}
		(dragInitiator as IStrand).addBead(dragController);
		dragController.addEventListener("dragMove", dragMoveHandler)
	}

	private function dragMoveHandler(event:DragEvent):void
	{
		var relatedObject:IEventDispatcher = event.relatedObject as IEventDispatcher;
		if (!relatedObject)
		{
			return;
		}
		if (relatedObject.hasEventListener(DragEvent.DRAG_ENTER) || relatedObject.hasEventListener(DragEvent.DRAG_EXIT) || relatedObject.hasEventListener(DragEvent.DRAG_OVER) || relatedObject.hasEventListener(DragEvent.DRAG_DROP))
		{
			var relatedStrand:IStrand = relatedObject as IStrand;
			var dropController:DropMouseController = relatedStrand.getBeadByType(DropMouseController) as DropMouseController;
			if (!dropController)
			{
				dropController = new DropMouseController();
				relatedStrand.addBead(dropController);
			}
		}
	}
	
	/**
	 *  Call this method from your <code>dragEnter</code> event handler if you accept
	 *  the drag/drop data.
	 *  For example: 
	 *
	 *  <pre>DragManager.acceptDragDrop(event.target);</pre>
	 *
	 *	@param target The drop target accepting the drag.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function acceptDragDrop(target:IUIComponent):void
	{
		// trace("-->acceptDragDrop for DragManagerImpl", sm, target);

		if (dragProxy)
			dragProxy.target = target as DisplayObject;

        if (hasEventListener("acceptDragDrop"))
    		dispatchEvent(new Request("acceptDragDrop", false, false, target));

	}
	
	/**
	 *  Sets the feedback indicator for the drag and drop operation.
	 *  Possible values are <code>DragManager.COPY</code>, <code>DragManager.MOVE</code>,
	 *  <code>DragManager.LINK</code>, or <code>DragManager.NONE</code>.
	 *
	 *  @param feedback The type of feedback indicator to display.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function showFeedback(feedback:String):void
	{
		// trace("-->showFeedback for DragManagerImpl", sm, feedback);
		if (dragProxy)
		{
			if (feedback == DragManager.MOVE && !dragProxy.allowMove)
				feedback = DragManager.COPY;

			dragProxy.action = feedback;
		}

        if (hasEventListener("showFeedback"))
    		dispatchEvent(new Request("showFeedback", false, false, feedback));

	}
	
	/**
	 *  Returns the current drag and drop feedback.
	 *
	 *  @return  Possible return values are <code>DragManager.COPY</code>, 
	 *  <code>DragManager.MOVE</code>,
	 *  <code>DragManager.LINK</code>, or <code>DragManager.NONE</code>.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function getFeedback():String
	{
        if (hasEventListener("getFeedback"))
        {
		    var request:Request = new Request("getFeedback", false, true);
		    if (!dispatchEvent(request))
		    {
			    return request.value as String;
		    }
        }

		// trace("<--getFeedback for DragManagerImpl", sm);
		return dragProxy ? dragProxy.action : DragManager.NONE;
	}
	
	/**
	 *  @private
	 */
	public function endDrag():void
	{
        var e:Event;
        if (hasEventListener("endDrag"))
        {
            e = new Event("endDrag", false, true);
        }
        
		if (!e || dispatchEvent(e))
		{
			if (dragProxy)
			{
				sm.popUpChildren.removeChild(dragProxy);	
				
                if (dragProxy.numChildren > 0)
				    dragProxy.removeChildAt(0);	// The drag image is the only child
				dragProxy = null;
			}
		}

		dragInitiator = null;
		bDoingDrag = false;

	}

    /**
     *  @private
     */
    static private function getStyleManager(dragInitiator:IUIComponent):IStyleManager2
    {
        // If the dragInitiator has a styleManager, use that one.
        // In a situation where a main application that loads a module with drag initiator,
        // the main application may not link in the DragManager and appropriate styles.
        // We want to use the styles of the module of the dragInitiator. See SDK-24324.
        if (dragInitiator is IFlexModule)
            return StyleManager.getStyleManager(IFlexModule(dragInitiator).moduleFactory);
        
        return StyleManager.getStyleManager(sm as IFlexModuleFactory);
    }

	//--------------------------------------------------------------------------
	//
	//  Event handlers
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	private function sm_mouseDownHandler(event:MouseEvent):void
	{
		mouseIsDown = true;
	}
	
	/**
	 *  @private
	 */
	private function sm_mouseUpHandler(event:MouseEvent):void
	{
		mouseIsDown = false;
	}

	private var _strand:IStrand;
	public function set strand(value:IStrand):void
	{
		_strand = value;
	}

}

}
