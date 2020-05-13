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

/*
import flash.display.BlendMode;
import flash.display.Graphics;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.ui.ContextMenu;
import flash.ui.Keyboard;
*/
    
import mx.core.mx_internal;
/*
import mx.events.SandboxMouseEvent;
import mx.styles.IStyleClient;
*/

import spark.components.RichEditableText;
/*
import spark.components.TextSelectionHighlighting;

import flashx.textLayout.tlf_internal;
import flashx.textLayout.container.ContainerController;
import flashx.textLayout.edit.EditManager;
import flashx.textLayout.edit.SelectionManager;
import flashx.textLayout.elements.FlowLeafElement;
import flashx.textLayout.elements.ParagraphElement;
import flashx.textLayout.formats.Category;
import flashx.textLayout.formats.TextLayoutFormat;
import flashx.textLayout.operations.ApplyFormatOperation;
import flashx.textLayout.property.Property;
import flashx.undo.IUndoManager;
import flashx.undo.UndoManager;
*/

import org.apache.royale.textLayout.edit.EditingMode;
import org.apache.royale.textLayout.edit.SelectionFormat;
import org.apache.royale.textLayout.edit.ElementRange;
import org.apache.royale.textLayout.elements.TextRange;
import org.apache.royale.textLayout.edit.IEditManager;
import org.apache.royale.textLayout.edit.ISelectionManager;
import org.apache.royale.textLayout.elements.IConfiguration;
import org.apache.royale.textLayout.elements.TextFlow;
import org.apache.royale.textLayout.formats.ITextLayoutFormat;
import org.apache.royale.textLayout.operations.InsertTextOperation;
import org.apache.royale.textLayout.edit.SelectionState;
import org.apache.royale.textLayout.container.TextContainerManager;
import org.apache.royale.textLayout.events.SelectionEvent;

use namespace mx_internal;

/*
use namespace tlf_internal;
*/

[ExcludeClass]

/**
 *  @private
 *  A subclass of TextContainerManager that manages the text in
 *  a RichEditableText component.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public class RichEditableTextContainerManager extends TextContainerManager
{
	//--------------------------------------------------------------------------
	//
	//  Class Variables
	//
	//--------------------------------------------------------------------------
	/**
	 *  @private
	 *  Disables blinking cursor so mustella test snapshots don't get intermittent
	 *  cursors.
	 */
	mx_internal static var hideCursor:Boolean = false;
	
    /**
     *  Constructor. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function RichEditableTextContainerManager(
                        container:RichEditableText, 
                        configuration:IConfiguration=null)
    {
        super(container, configuration);

        textDisplay = container;
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private var hasScrollRect:Boolean = false;

    /**
     *  @private
     */
    private var textDisplay:RichEditableText;

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------
        
    /**
     *  @private
    override public function drawBackgroundAndSetScrollRect(
                                    scrollX:Number, scrollY:Number):Boolean
    {
        // If not auto-sizing these are the same as the compositionWidth/Height.
        // If auto-sizing, the compositionWidth/Height may be NaN.  If no
        // constraints this will reflect the actual size of the text.
        var width:Number = textDisplay.width;
        var height:Number = textDisplay.height;
        
        var contentBounds:Rectangle = getContentBounds();
        
        // If measuring width, use the content width.
        if (isNaN(width))
            width = contentBounds.right;
        
        // If measuring height, use the content height.
        if (isNaN(height))
            height = contentBounds.bottom;

        // TODO:(cframpto)  Adjust for RL text.  
        // See ContainerController.updateVisibleRectangle().
        // (effectiveBlockProgression == BlockProgression.RL) ? -width : 0;
        var xOrigin:Number = 0;

        // If autoSize, and lineBreak="toFit" there should never be 
        // a scroll rect but if lineBreak="explicit" the text may need
        // to be clipped.
        if (scrollX == 0 && scrollY == 0 &&
            contentBounds.left >= xOrigin &&
            contentBounds.right <= width &&
            contentBounds.top >= 0 &&
            contentBounds.bottom <= height)
        {
            // skip the scrollRect
            if (hasScrollRect)
            {
                container.scrollRect = null;
                hasScrollRect = false;                  
            }
        }
        else
        {
            container.scrollRect = new Rectangle(scrollX, scrollY, width, height);
            hasScrollRect = true;
        }
        
        // Client must draw a background to get mouse events,
        // even it if is 100% transparent.
    	// If backgroundColor is defined, fill the bounds of the component
    	// with backgroundColor drawn with alpha level backgroundAlpha.
    	// Otherwise, fill with transparent black.
    	// (The color in this case is irrelevant.)
    	var color:uint = 0x000000;
    	var alpha:Number = 0.0;
    	var styleableContainer:IStyleClient = container as IStyleClient;
    	if (styleableContainer)
    	{
    		var backgroundColor:* =
    			styleableContainer.getStyle("backgroundColor");
    		if (backgroundColor !== undefined)
    		{
    			color = uint(backgroundColor);
    			alpha = styleableContainer.getStyle("backgroundAlpha");
    		}
    	}
        // TODO (cframpto):  Adjust for RL text.  See 
        // ContainerController.attachTransparentBackgroundForHit().
        var g:Graphics = container.graphics;
        g.clear();
        g.lineStyle();
        g.beginFill(color, alpha);
        g.drawRect(scrollX, scrollY, width, height);
        g.endFill();
        
        return hasScrollRect;
    }
    *      */

        
    /**
     *  @private
     * 
     * If the user specified a custom context menu then use
     * it rather than the default context menu. It must be set before the
     * first mouse over/mouse hover or foucsIn event to be used.
     * 
     * TLF will remove the context menu when it switches from the factory
     * to the composer and the controller will then request it again.
    override tlf_internal function getContextMenu():ContextMenu
    {
        // ToDo(cframpto): Ideally could specify the context
        // menu on the TextArea or the TextInput and it wouldn't be obscured
        // by TLF's context menu.

        // Return null to use the existing contextMenu on the container.
        // Otherwise the TCM will overwrite this contextMenu.
        return textDisplay.contextMenu != null ? null : super.getContextMenu();
    }
     */
    
    /**
     *  @private
    override protected function getUndoManager():IUndoManager
    {
        if (!textDisplay.undoManager)
        {
            textDisplay.undoManager = new UndoManager();
            textDisplay.undoManager.undoAndRedoItemLimit = int.MAX_VALUE;
        }
            
        return textDisplay.undoManager;
    }
     */
    
    /**
     *  @private
     */
    override protected function getFocusedSelectionFormat():SelectionFormat
    {
        var selectionColor:* = textDisplay.getStyle("focusedTextSelectionColor");

        var focusedPointAlpha:Number =
            editingMode == EditingMode.READ_WRITE ?
            1.0 :
            0.0;

        // If editable, the insertion point is black, inverted, which makes it
        // the inverse color of the background, for maximum readability.         
        // If not editable, then no insertion point.        
        return new SelectionFormat(
            selectionColor, 1.0, "normal" /*BlendMode.NORMAL*/, 
            0x000000, hideCursor ? 0 : focusedPointAlpha, "invert" /*BlendMode.INVERT*/);
    }
    
    /**
     *  @private
     */
    override protected function getUnfocusedSelectionFormat():SelectionFormat
    {
        var unfocusedSelectionColor:* = textDisplay.getStyle(
                                            "unfocusedTextSelectionColor");

        var unfocusedAlpha:Number =
            textDisplay.selectionHighlighting != 
            "whenFocused" /*TextSelectionHighlighting.WHEN_FOCUSED*/ ?
            1.0 :
            0.0;

        // No insertion point when no focus.
        return new SelectionFormat(
            unfocusedSelectionColor, unfocusedAlpha, "normal" /*BlendMode.NORMAL*/,
            unfocusedSelectionColor, 0.0);
    }
    
    /**
     *  @private
     */
    override protected function getInactiveSelectionFormat():SelectionFormat
    {
        var inactiveSelectionColor:* = textDisplay.getStyle(
                                            "inactiveTextSelectionColor"); 

        var inactivePointAlpha:Number = 0.0;
        
        var inactiveRangeAlpha:Number =
            textDisplay.selectionHighlighting == 
            "always" /*TextSelectionHighlighting.ALWAYS*/ ?
            1.0 :
            0.0;

        
        // This doesn't really matter since inactivePointAlpha is 0.
        var pointBlinkRate:Number = 0.0;
        
        return new SelectionFormat(
            inactiveSelectionColor, inactiveRangeAlpha, "normal" /* BlendMode.NORMAL */,
            inactiveSelectionColor, inactivePointAlpha, "invert" /* BlendMode.INVERT */,
            pointBlinkRate);
    }   
    
    /**
     *  @private
    override protected function createEditManager(
                        undoManager:flashx.undo.IUndoManager):IEditManager
    {
        var editManager:IEditManager = super.createEditManager(undoManager);
        
        // Default is to batch text input.  If the component, like ComboBox
        // wants to act on each keystroke then set this to false.
        editManager.allowDelayedOperations = textDisplay.batchTextInput;
        
        // Do not delayUpdates until further work is done to ensure our public API methods to
        // format and insert text work correctly.  TLF does not dispatch the selectionChange
        // event until the display is updated which means our selection properties may not
        // be in sync with the TLF values. This could matter for our API methods that
        // take the selection as parameters or default to the current selection.  In the
        // former case, the user could query for the selection or rely on the selectionChange
        // event and get incorrect values if there is a pending update and in the later case 
        // we fill in the default selection which might not be current if there is a pending 
        // update.
        editManager.delayUpdates = false;
        
        return editManager;
    }
     */

    /**
     *  @private
     */
    override public function setText(text:String):void
    {
        super.setText(text);
        
        // If we have focus, need to make sure we can still input text.
        //initForInputIfHaveFocus();
    }

    /**
     *  @private
     */
    override public function setTextFlow(textFlow:TextFlow):void
    {
        super.setTextFlow(textFlow);
        
        // If we have focus, need to make sure we can still input text.
        //initForInputIfHaveFocus();
    }

    /**
     *  @private
    private function initForInputIfHaveFocus():void
    {
        // If we have focus, need to make sure there is a composer in place,
        // the new controller knows it has focus, and there is an insertion
        // point so input works without a mouse over or mouse click.  Normally 
        // this is done in our focusIn handler by making sure there is a 
        // selection.  Test this by clicking an arrow in the NumericStepper 
        // and then entering a number without clicking on the input field first. 
        if (editingMode != EditingMode.READ_ONLY &&
            textDisplay.getFocus() == textDisplay)
        {
            // this will ensure a text flow with a comopser
            var im:ISelectionManager = beginInteraction();
            
            var controller:ContainerController = 
                getTextFlow().flowComposer.getControllerAt(0);
            
            controller.requiredFocusInHandler(null);
            
            if (!preserveSelectionOnSetText)
                im.selectRange(0, 0);
            
            endInteraction();
        }
    }
     */
    
    /**
     *  @private
     *  To apply a format to a selection in a textFlow without using the
     *  selection manager.
    mx_internal function applyFormatOperation(
                            leafFormat:ITextLayoutFormat, 
                            paragraphFormat:ITextLayoutFormat, 
                            containerFormat:ITextLayoutFormat,
                            anchorPosition:int, 
                            activePosition:int):Boolean
    {
        // Nothing to do.
        if (anchorPosition == -1 || activePosition == -1)
            return true;
        
        var textFlow:TextFlow = getTextFlowWithComposer();
        
        var operationState:SelectionState =
            new SelectionState(textFlow, anchorPosition, activePosition);
                    
        // If using the edit manager and the selection is the current selection,
        // need to set the flag so point selection is set with pending formats for next 
        // char typed.
        const editManager:IEditManager = textFlow.interactionManager as IEditManager;
        if (editManager)
        {
            const absoluteStart:int = getAbsoluteStart(anchorPosition, activePosition);
            const absoluteEnd:int = getAbsoluteEnd(anchorPosition, activePosition);
            
            if (editManager.absoluteStart == absoluteStart && editManager.absoluteEnd == absoluteEnd)
                operationState.selectionManagerOperationState = true;
        }
        
        // For the case when interactive editing is not allowed.
        var op:ApplyFormatOperation = 
            new ApplyFormatOperation(
                operationState, leafFormat, paragraphFormat, containerFormat);

        var success:Boolean = op.doOperation();
        if (success)
        {
            textFlow.normalize(); 
            textFlow.flowComposer.updateAllControllers(); 
        }
        
        return success;
    }
     */

    /**
     *  @private
     *  To get the format of a character.  Our API allows this operation even
     *  when the editingMode does not permit either interactive selection or
     *  editing.
     */
    mx_internal function getCommonCharacterFormat(
                                        anchorPosition:int, 
                                        activePosition:int):ITextLayoutFormat
    {
        if (anchorPosition == -1 || activePosition == -1)
            return null;
        
        var textFlow:TextFlow = getTextFlowWithComposer();
        
        if (textFlow.interactionManager)
        {
            // If there is a selection manager use it so that the format,
            // depending on the range, may include any attributes set on a point 
            // selection but not yet applied.	
            const range:TextRange = 
                new TextRange(textFlow, anchorPosition, activePosition);
            
            return textFlow.interactionManager.getCommonCharacterFormat(range);
        }
        else
        {
            // ElementRange will order the selection points.  Since there isn't
            // an interactionManager there is not a point selection to worry
            // about.
            var selRange:ElementRange = 
                ElementRange.createElementRange(textFlow, anchorPosition, activePosition); 
            
            return selRange.getCommonCharacterFormat();
        }
    }

    /**
     *  @private
     *  To get the format of the container without using a SelectionManager.
     *  The method should be kept in sync with the version in the 
     *  SelectionManager.
    mx_internal function getCommonContainerFormat():ITextLayoutFormat
    {
        var textFlow:TextFlow = getTextFlowWithComposer();
        
        // absoluteStart and absoluteEnd values not used. 
        var selRange:ElementRange = 
            ElementRange.createElementRange(textFlow, 0, textFlow.textLength - 1); 
        
        return selRange.getCommonContainerFormat();
    }
     */
    
    /**
     *  @private
     *  To get the format of a paragraph without using a SelectionManager.
     *  The method should be kept in sync with the version in the 
     *  SelectionManager.
    mx_internal function getCommonParagraphFormat(
                                        anchorPosition:int, 
                                        activePosition:int):ITextLayoutFormat
    {
        if (anchorPosition == -1 || activePosition == -1)
            return null;
                
        var textFlow:TextFlow = getTextFlowWithComposer();
    
        // ElementRange will order the selection points.
        var selRange:ElementRange = 
            ElementRange.createElementRange(textFlow, anchorPosition, activePosition); 
                
        return selRange.getCommonParagraphFormat();
    }
     */
    
    /**
     *  @private
     *  Insert or append text to the textFlow without using an EditManager.
     *  If there is a SelectionManager or EditManager its selection will be
     *  updated at the end of the operation to keep it in sync.
     */
    mx_internal function insertTextOperation(insertText:String, 
                                             anchorPosition:int, 
                                             activePosition:int):Boolean
    {
        // No insertion point.
        if (anchorPosition == -1 || activePosition == -1)
            return false;
        
        var textFlow:TextFlow = getTextFlowWithComposer();
        
        var absoluteStart:int = getAbsoluteStart(anchorPosition, activePosition);
        var absoluteEnd:int = getAbsoluteEnd(anchorPosition, activePosition);
        
        // Need to get the format of the insertion point so that the inserted
        // text will have this format.
        var pointFormat:ITextLayoutFormat = 
            getCommonCharacterFormat(absoluteStart, absoluteStart);

        var operationState:SelectionState = 
            new SelectionState(textFlow, absoluteStart, absoluteEnd, pointFormat);
 
        // If there is an interaction manager, this keeps it in sync with
        // the results of this operation.
        operationState.selectionManagerOperationState = true;
        
        var op:InsertTextOperation = 
            new InsertTextOperation(operationState, insertText);
        
        // Generations don't seem to be used in this code path since we
        // aren't doing composite, merge or undo operations so they were
        // optimized out.
        
        var success:Boolean = op.doOperation();
        if (success)
        {
            textFlow.normalize(); 
            
            textFlow.flowComposer.updateAllControllers(); 

            var insertPt:int = absoluteEnd - (absoluteEnd - absoluteStart) +
                                    + insertText.length;            
            
            // No point format.
            var selectionState:SelectionState =
                new SelectionState(textFlow, insertPt, insertPt);
            
            var selectionEvent:SelectionEvent = 
                new SelectionEvent(SelectionEvent.SELECTION_CHANGE, 
                                   false, false, selectionState);

            textFlow.dispatchEvent(selectionEvent);
            
            scrollToRange(insertPt, insertPt);            
        } 

        return success;
    }

    /**
     *  Note:  It is probably a TLF bug that, if delayedUpdates is true, we have to call 
     *  updateAllControllers before doing a format operation to guarantee the correct
     *  results.
     */
    mx_internal function getTextFlowWithComposer():TextFlow
    {
        var textFlow:TextFlow = getTextFlow() as TextFlow;
        
        // Make sure there is a text flow with a flow composer.  There will
        // not be an interaction manager if editingMode is read-only.  If
        // there is an interaction manager flush any pending inserts into the
        // text flow unless we are delaying updates in which case we may have to finish
        // composition.
        if (composeState != TextContainerManager.COMPOSE_COMPOSER)
        {
            convertToTextFlowWithComposer();
        }
        else if (textFlow.interactionManager)
        {
            const editManager:IEditManager = textFlow.interactionManager as IEditManager;
            if (editManager && editManager.delayUpdates)
                editManager.updateAllControllers();
            else
                textFlow.interactionManager.flushPendingOperations();
        }
        
        return textFlow;
    }
        
    /**
     *  @private
     */
    private function getAbsoluteStart(anchorPosition:int, activePosition:int):int
    {
        return (anchorPosition < activePosition) ? 
                    anchorPosition : activePosition;
    }
    
    /**
     *  @private
     */
    private function getAbsoluteEnd(anchorPosition:int, activePosition:int):int
    {
        return (anchorPosition > activePosition) ? 
                    anchorPosition : activePosition;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden event handlers
    //
    //--------------------------------------------------------------------------
        
    /**
     *  @private
    override public function focusInHandler(event:FocusEvent):void
    {
        textDisplay.focusInHandler(event);

        super.focusInHandler(event);
    }    
     */

    /**
     *  @private
    override public function focusOutHandler(event:FocusEvent):void
    {
        textDisplay.focusOutHandler(event);

        super.focusOutHandler(event);
    }    
     */

    /**
     *  @private
    override public function keyDownHandler(event:KeyboardEvent):void
    {
        textDisplay.keyDownHandler(event);

        if (!event.isDefaultPrevented())
        {
            var clone:KeyboardEvent = KeyboardEvent(event.clone());
            super.keyDownHandler(clone);
            if (clone.isDefaultPrevented())
                event.preventDefault();
        }
    }
     */

    /**
     *  @private
    override public function keyUpHandler(event:KeyboardEvent):void
    {
        if (!event.isDefaultPrevented())
        {
            var clone:KeyboardEvent = KeyboardEvent(event.clone());
            super.keyUpHandler(clone);
            if (clone.isDefaultPrevented())
                event.preventDefault();
        }
    }
     */
        
    /**
     *  @private
    override public function mouseDownHandler(event:MouseEvent):void
    {
        textDisplay.mouseDownHandler(event);
        
        super.mouseDownHandler(event);
    }
     */
        
    /**
     *  @private
     *  This handler gets called for ACTIVATE events from the player
     *  and FLEX_WINDOW_ACTIVATE events from Flex.  Because of the
     *  way AIR handles activation of AIR Windows, and because Flex
     *  has its own concept of popups or pseudo-windows, we
     *  ignore ACTIVATE and respond to FLEX_WINDOW_ACTIVATE instead
    override public function activateHandler(event:Event):void
    {
        // block ACTIVATE events
        if (event.type == Event.ACTIVATE)
            return;

        super.activateHandler(event);

        // TLF ties activation and focus together.  If a Flex PopUp is created 
        // it is possible to get deactivate/activate events without any 
        // focus events.  If we have focus when we are activated, the selection 
        // state should be SelectionFormatState.FOCUSED not 
        // SelectionFormatState.UNFOCUSED since there might not be a follow on
        // focusIn event.
        if (editingMode != EditingMode.READ_ONLY &&
            textDisplay.getFocus() == textDisplay)
        {
            var im:SelectionManager = SelectionManager(beginInteraction());
            im.setFocus();
            endInteraction();
       }
    }
     */

    /**
     *  @private
     *  This handler gets called for DEACTIVATE events from the player
     *  and FLEX_WINDOW_DEACTIVATE events from Flex.  Because of the
     *  way AIR handles activation of AIR Windows, and because Flex
     *  has its own concept of popups or pseudo-windows, we
     *  ignore DEACTIVATE and respond to FLEX_WINDOW_DEACTIVATE instead
    override public function deactivateHandler(event:Event):void
    {
        // block DEACTIVATE events
        if (event.type == Event.DEACTIVATE)
            return;

        super.deactivateHandler(event);
    }
     */

    /**
     *  @private
     *  sandbox support
    override public function beginMouseCapture():void
    {
        super.beginMouseCapture();
        textDisplay.systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, mouseUpSomewhereHandler);
        textDisplay.systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_MOVE_SOMEWHERE, mouseMoveSomewhereHandler);
    }
     */

    /**
     *  @private
     *  sandbox support
    override public function endMouseCapture():void
    {
        super.endMouseCapture();
        textDisplay.systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, mouseUpSomewhereHandler);
        textDisplay.systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_MOVE_SOMEWHERE, mouseMoveSomewhereHandler);
    }
     */

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    /*
    private function mouseUpSomewhereHandler(event:Event):void
    {
        mouseUpSomewhere(event);
    }

    private function mouseMoveSomewhereHandler(event:Event):void
    {
        mouseMoveSomewhere(event);
    }
    */
}

}
