/*
 *
 *  Licensed to the Apache Software Foundation (ASF) under one or more
 *  contributor license agreements.  See the NOTICE file distributed with
 *  this work for additional information regarding copyright ownership.
 *  The ASF licenses this file to You under the Apache License, Version 2.0
 *  (the "License"); you may not use this file except in compliance with
 *  the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 */

package
{

COMPILE::SWF
{
import flash.display.BlendMode;
import flash.display.Sprite;
import flash.events.FocusEvent;
import flash.utils.setTimeout;
}

import org.apache.flex.textLayout.beads.DispatchTLFKeyboardEventBead;
import org.apache.flex.textLayout.container.TextContainerManager;
import org.apache.flex.textLayout.edit.EditingMode;
import org.apache.flex.textLayout.edit.ISelectionManager;
import org.apache.flex.textLayout.edit.SelectionFormat;
import org.apache.flex.textLayout.events.CompositionCompleteEvent;
import org.apache.flex.textLayout.events.DamageEvent;

import org.apache.flex.core.UIBase;
import org.apache.flex.events.Event;
COMPILE::SWF
{
import org.apache.flex.html.beads.SingleLineBorderBead;
import org.apache.flex.html.beads.SolidBackgroundBead;
}
COMPILE::JS
{
import org.apache.flex.textLayout.events.FocusEvent;
}

//import flashx.textLayout.tlf_internal;
//use namespace tlf_internal;

public class TLFEditor extends UIBase
{
	public var multiline:Boolean = true;
	
	public function TLFEditor()
	{
		addEventListener(FocusEvent.FOCUS_IN, onSetFocus);
		addEventListener(FocusEvent.FOCUS_OUT, onLoseFocus);
		COMPILE::SWF
		{
		addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, onMouseFocusChange);
		Sprite($displayObject).tabEnabled = true;
		Sprite($displayObject).mouseChildren = false;
		}
		
		// Create the TLF TextContainerManager, using this component
		// as the DisplayObjectContainer for its TextLines.
		// This TextContainerManager instance persists for the lifetime
		// of the component.
		_textContainerManager = new TextContainerManager(this);

		_textContainerManager.addEventListener(
			CompositionCompleteEvent.COMPOSITION_COMPLETE,
			textContainerManager_compositionCompleteHandler);
		
		_textContainerManager.addEventListener(
			DamageEvent.DAMAGE, textContainerManager_damageHandler);
		
		COMPILE::SWF
		{
			// todo, see if this can be done in same place as for JS
        var selectionManager:ISelectionManager = _textContainerManager.beginInteraction();
		selectionManager.focusedSelectionFormat = new SelectionFormat(
            0x000000, 1.0, "normal" /*BlendMode.NORMAL*/, 
            0x000000, 1.0, "invert" /*BlendMode.INVERT*/);
		}
		/*
		_textContainerManager.addEventListener(
			Event.SCROLL, textContainerManager_scrollHandler);
		
		_textContainerManager.addEventListener(
			SelectionEvent.SELECTION_CHANGE,
			textContainerManager_selectionChangeHandler);
		
		_textContainerManager.addEventListener(
			FlowOperationEvent.FLOW_OPERATION_BEGIN,
			textContainerManager_flowOperationBeginHandler);
		
		_textContainerManager.addEventListener(
			FlowOperationEvent.FLOW_OPERATION_END,
			textContainerManager_flowOperationEndHandler);
		
		_textContainerManager.addEventListener(
			FlowOperationEvent.FLOW_OPERATION_COMPLETE,
			textContainerManager_flowOperationCompleteHandler);
		
		_textContainerManager.addEventListener(
			StatusChangeEvent.INLINE_GRAPHIC_STATUS_CHANGE, 
			textContainerManager_inlineGraphicStatusChangeHandler);
		*/
	}

	override public function addedToParent():void
	{
		super.addedToParent();
	
		COMPILE::SWF
		{
			addBead(new SingleLineBorderBead());
			addBead(new SolidBackgroundBead());
		}
		COMPILE::JS
		{
			if (element['tabIndex'] == -1)
				element['tabIndex'] = 0;
		}
		addBead(new DispatchTLFKeyboardEventBead());
		
		COMPILE::JS
		{
		trace("begin interaction");
		var selectionManager:ISelectionManager = _textContainerManager.beginInteraction();
		selectionManager.focusedSelectionFormat = new SelectionFormat(
            0x000000, 1.0, "normal" /*BlendMode.NORMAL*/, 
            0x000000, 1.0, "invert" /*BlendMode.INVERT*/);
		if (multiline)
		{
			if (!selectionManager.hasSelection())
				 selectionManager.selectRange(0, 0);
		} 
		else
		{
			selectionManager.selectAll();
		}

		selectionManager.refreshSelection();
		trace("end interaction");
		_textContainerManager.endInteraction();
		}

	}
	
        //----------------------------------
        //  textContainerManager
        //----------------------------------
        
        /**
         *  @private
         */
        private var _textContainerManager:TextContainerManager;
        
        
        /**
         *  @private
         */
        public function onSetFocus(event:Event):void
        {            
			trace("set focus");
			
            // We are about to set focus on this component.  If it is due to
            // a programmatic focus change we have to programatically do what the
            // mouseOverHandler and the mouseDownHandler do so that the user can 
            // type in this component without using the mouse first.  We need to
            // put a textFlow with a composer in place.
            if (/*editingMode != EditingMode.READ_ONLY &&*/
                _textContainerManager.composeState != 
                TextContainerManager.COMPOSE_COMPOSER)   
            {
				trace("begin interaction");
                var selectionManager:ISelectionManager = _textContainerManager.beginInteraction();
				if (multiline)
                {
                    if (!selectionManager.hasSelection())
                         selectionManager.selectRange(0, 0);
                } 
                else
                {
                    selectionManager.selectAll();
                }
    
                selectionManager.refreshSelection();
				trace("end interaction");
                _textContainerManager.endInteraction();
            }
        }
		
        /**
         *  @private
         */
        public function onLoseFocus(event:Event):void
        {            
			trace("lose focus");
		}
        
        /**
         *  @private
         */
        public function onMouseFocusChange(event:Event):void
        {            
			trace("mouse focus change");
		}
        
        /**
         *  @private
         *  Called when the TextContainerManager dispatches a 'compositionComplete'
         *  event when it has recomposed the text into TextLines.
         */
        private function textContainerManager_compositionCompleteHandler(
            event:CompositionCompleteEvent):void
        {
			/*
            //trace("compositionComplete");
            
            var oldContentWidth:Number = _contentWidth;
            var oldContentHeight:Number = _contentHeight;
            
            var newContentBounds:Rectangle = 
                _textContainerManager.getContentBounds();
            
            // If x and/or y are not 0, adjust for what is visible.  For example, if there is an 
            // image which is wider than the composeWidth and float="right", x will be negative
            // and the part of the image between x and 0 will not be visible so it should
            // not be included in the reported width.  This will avoid a scrollbar that does
            // nothing.
            newContentBounds.width += newContentBounds.x;
            newContentBounds.height += newContentBounds.y;
            
            // Try to prevent the scroller from getting into a loop while
            // adding/removing scroll bars.
            if (_textFlow && clipAndEnableScrolling)
                adjustContentBoundsForScroller(newContentBounds);
            
            var newContentWidth:Number = newContentBounds.width;        
            var newContentHeight:Number = newContentBounds.height;
            
            // TODO:(cframpto) handle blockProgression == RL
            
            if (newContentWidth != oldContentWidth)
            {
                _contentWidth = newContentWidth;
                
                //trace("composeWidth", _textContainerManager.compositionWidth, "contentWidth", oldContentWidth, newContentWidth);
                
                // If there is a scroller, this triggers the scroller layout.
                dispatchPropertyChangeEvent(
                    "contentWidth", oldContentWidth, newContentWidth);
            }
            
            if (newContentHeight != oldContentHeight)
            {
                _contentHeight = newContentHeight;
                
                //trace("composeHeight", _textContainerManager.compositionHeight, "contentHeight", oldContentHeight, newContentHeight);
                
                // If there is a scroller, this triggers the scroller layout.
                dispatchPropertyChangeEvent(
                    "contentHeight", oldContentHeight, newContentHeight);
            }
			*/
        }
		
        /**
         *  @private
         *  Called when the TextContainerManager dispatches a 'damage' event.
         *  The TextFlow could have been modified interactively or programatically.
         */
        private function textContainerManager_damageHandler(event:DamageEvent):void
        {
            if (event.damageLength == 0)
                return;
            
            //trace("damageHandler", "generation", _textFlow ? _textFlow.generation : -1, "lastGeneration", lastGeneration);
            
            // The following textContainerManager functions can trigger a damage
            // event:
            //    setText/setTextFlow
            //    set hostFormat
            //    set compositionWidth/compositionHeight
            //    set horizontalScrollPosition/veriticalScrollPosition
            //    set swfContext
            //    updateContainer or compose: always if TextFlowFactory, sometimes 
            //        if flowComposer
            // or the textFlow can be modified directly.
            
            // If no changes, don't recompose/update.  The TextFlowFactory 
            // createTextLines dispatches damage events every time the textFlow
            // is composed, even if there are no changes. 
            //if (_textFlow && _textFlow.generation == lastGeneration)
            //    return;
            
            // If there are pending changes, don't wipe them out.  We have
            // not gotten to commitProperties() yet.
            //if (textChanged || textFlowChanged || contentChanged)
            //    return;
            
            //_content = null;        
            //_textFlow = _textContainerManager.getTextFlow();
                        
            //lastGeneration = _textFlow.generation;
            
			setTimeout(compose_callback, 0);            
			
        }
		
		public function compose_callback():void
		{
			// Compose only.  The display should not be updated.
            _textContainerManager.compose();

		}

}
}