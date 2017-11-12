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
package org.apache.royale.textLayout.accessibility
{
	COMPILE::SWF{
		import flash.accessibility.Accessibility;
		import flash.accessibility.AccessibilityImplementation;
		import flash.accessibility.AccessibilityProperties;
		import flash.display.DisplayObject;
	}
	import org.apache.royale.events.Event;
	
	import org.apache.royale.textLayout.edit.EditingMode;
	import org.apache.royale.textLayout.edit.ISelectionManager;
	import org.apache.royale.textLayout.elements.IFlowLeafElement;
	import org.apache.royale.textLayout.elements.GlobalSettings;
	import org.apache.royale.textLayout.elements.IParagraphElement;
	import org.apache.royale.textLayout.elements.TextFlow;
	import org.apache.royale.textLayout.events.CompositionCompleteEvent;
	

    //TODO this is in text_edit... which violates MVC yet again... what to do?
    //import org.apache.royale.textLayout.events.SelectionEvent;
    
	//TODO handle selectable text when FP implements the new selection API:
	//     http://frpbugapp.macromedia.com/bugapp/detail.asp?id=217540
	//     To catch the selection changes reliably, listen for SelectionEvent,
	//     which is dispatched on the TextFlow whenever the selection changes.

    //TODO handle scrolling? might need to expose scrolling in here
    
	//TODO handle hyperlinks? I don't know if MSAA has a concept for this
	//    (what other text advanced features must be accessible? graphics?)
	//TODO what if there is HTML in it? strip it, or read it? we don't have an
	//     htmlText property, do we?

    // TODO Do we want to read the contents of each sprite and stop, even if the
    // text flows into other sprite, meaning we read text in taborder; or do we
    // want to read the entire model and not worry about the presentation
    // (simpler)? Not sure if I can get the contents of each sprite separately.
    
    // TODO TESTING:
    //   * Test that JAWS reads when setting the focus programmatically.
    //   * Tests for changing every part of the model programmatically -- role
    //     and state should update accordingly, visibility, and text contents.
    //   * Test that setting tabOrder reads as expected. What happens if you set
    //     tabOrder on multiple flowComposers?
    
    //TODO update this comment after integration
	/**
	 * @private
	 * The TextAccImpl class adds accessibility for text components.
	 * This hooks into DisplayObjects when TextFlow.container is set.
	 */
	COMPILE::SWF
	public class TextAccImpl extends AccessibilityImplementation
	{
	    //TODO might want to put these constants in a new class if they are
	    //     used anywhere else.
	    
		/** Default state */
		protected static const STATE_SYSTEM_NORMAL:uint = 0x00000000;
		
		/** Read-only text */
		protected static const STATE_SYSTEM_READONLY:uint = 0x00000040;
		
		/** Inivisible text */
		//TODO unused, but supported state for text in MSAA
		protected static const STATE_SYSTEM_INVISIBLE:uint = 0x00008000;
		
		/** Default role -- read-only, unselectable text. */
		protected static const ROLE_SYSTEM_STATICTEXT:uint = 0x29;
		
		/** Editable OR read-only, selectable text. */
		protected static const ROLE_SYSTEM_TEXT:uint = 0x2a;
		
		/* When the name changes (name is the text conent in STATICTEXT). */
		protected static const EVENT_OBJECT_NAMECHANGE:uint = 0x800c;
		
		/* When the value changes (value is the text content in TEXT). */
		protected static const EVENT_OBJECT_VALUECHANGE:uint = 0x800e;
	
		/**
		 *  A reference to the DisplayObject that is hosting accessible text.
		 */
		//TODO for now this assumes only the first DO in a flow is accessible
		//     in the future each flow DO should host its own accimpl and read
		//     the text only for its own box.
		//
		//     Or... perhaps we use getChildIDArray to manage all the text
		//     flows if they are linked below some master component (but I don't
		//     think this is the way it will happen).
		protected var textContainer:DisplayObject;
		
		/**
		 *  A reference to the TextFlow where our text originates.
		 */
		protected var textFlow:TextFlow;
		
		/**
		 *  Constructor.
		 * 
		 *  @param textContainer The DisplayObject instance that this
		 *                       TextAccImpl instance is making accessible.
		 *  @param textFlow The TextFlow that is hosting the textContainer.
		 */
		public function TextAccImpl(textCont:DisplayObject, textFlow:TextFlow)
		{
			super();
	
			this.textContainer = textCont;
			this.textFlow = textFlow;
			
			// stub is true when you are NOT providing an acc implementation
			// reports to reader as graphic
			stub = false;
			
			if (textCont.accessibilityProperties == null)
			{
    			textCont.accessibilityProperties =
    			    new AccessibilityProperties();
			}

            //TODO
            // setup event listeners for text selection and model changes
            //textFlow.addEventListener(SelectionEvent.SELECTION_CHANGE,
            //                          eventHandler);
            textFlow.addEventListener(CompositionCompleteEvent.COMPOSITION_COMPLETE, eventHandler);
		}
		
		public function detachListeners():void
		{
			textFlow.removeEventListener(CompositionCompleteEvent.COMPOSITION_COMPLETE, eventHandler);
		}
		
		/**
		 *  Returns the system role for the text.
		 *
		 *  @param childID uint.
		 *  @return Role associated with the text.
		 */
		override public function get_accRole(childID:uint):uint
		{
		    // trace("get_accRole()");
		    
		    const iManager:ISelectionManager = textFlow.interactionManager;
		    if (iManager == null)
		    {
		        // non-selectable, non-editable text is STATICTEXT
		        return ROLE_SYSTEM_STATICTEXT;
		    }
		    else // iManager is an IEditManager and/or ISelectionManager
		    {
		        // read-only selectable or editable selectable text are TEXT
		        return ROLE_SYSTEM_TEXT;
		    }
		}
		
		/**
		 *  Returns the state of the text.
		 *
		 *  @param childID uint.
		 *  @return Role associated with the text.
		 */
		override public function get_accState(childID:uint):uint
		{
		    // trace("get_accState()");
		    
		    const iManager:ISelectionManager = textFlow.interactionManager;
		    
		    //TODO handle STATE_SYSTEM_INVISIBLE for all cases below
		    //     and add an event to detect changes--does Flash support this?
		    
		    //TODO handle STATE_SYSTEM_PROTECTED for all cases below
		    //     if vellum gets a concept of password fields, then it needs to 
		    //     emit this value if the field is converted to a password;
		    //     otherwise the Flex framework will need to be sure to emit
		    //     this state in a text input component.
		    
		    // note: focus-related states are handled by the player
		    
		    if (iManager == null)
		    {
		        // non-selectable, non-editable text
		        return STATE_SYSTEM_READONLY;
		    }
		    // must check IEditManager before ISelectionManager (it can be both)
		    else if (iManager.editingMode == EditingMode.READ_WRITE)
		    {
		        // editable selectable text
		        return STATE_SYSTEM_NORMAL;
		    }
		    else // if (iManager instanceof ISelectionManager)
		    {
		        // read-only selectable text
		        return STATE_SYSTEM_READONLY;
		    }
		}
		
		/**
		 *  Returns the name of the text.
		 *
		 *  @param childID uint.
		 *  @return Name of the text.
		 */
		override public function get_accName(childID:uint):String
		{
		    // trace("get_accName()");
		    
		    switch (get_accRole(childID))
		    {
    		    case ROLE_SYSTEM_STATICTEXT:
    		    {
        		    //TODO this SHOULD come from TextConverter, but then there is a
        		    //     circular build dependency since importExport builds
        		    //     against model, and it probably violates mvc
        			//return TextConverter.export(textFlow,
        			//                         TextConverter.PLAIN_TEXT_FORMAT);
        			
        			//TODO this is probably expensive. is there a way to cache
        			//      this and know when dirty?
        			//TODO  look at the generation and determine when it's dirty
        			return exportToString(textFlow);
    		    }
    		    
		        case ROLE_SYSTEM_TEXT:
		        default:
            		return null;
    		}
		}
		
		/**
		 *  Returns the value of the text.
		 *
		 *  @param childID uint.
		 *  @return Name of the text.
		 */
		override public function get_accValue(childID:uint):String
		{
		    // trace("get_accValue()");
		    
		    switch (get_accRole(childID))
		    {
		        case ROLE_SYSTEM_TEXT:
    		    {
        		    //TODO this SHOULD come from TextConverter, but then there is a
        		    //     circular build dependency since importExport builds
        		    //     against model, and it probably violates mvc
        			//return TextConverter.export(textFlow,
        			//                         TextConverter.PLAIN_TEXT_FORMAT);
        			
        			// TODO this is probably expensive. is there a way to cache
        			//      this and know when dirty?
        			//TODO  look at the generation and determine when it's dirty
        			return exportToString(textFlow);
    		    }
    		    
    		    case ROLE_SYSTEM_STATICTEXT:
		        default:
            		return null;
    		}
		}

		/**
		 * Handles COMPOSITION_COMPLETE and SELECTION_CHANGE events,
		 * updates the MSAA model.
    	 */
    	protected function eventHandler(event:Event):void
    	{
    		switch (event.type)
    		{
                // This updates the entire accessibility DOM.
                // get_accName is probably expensive here, it happens ONLY if
                // JAWS is running, otherwise Accessibility.* calls are NOOP.
                //
                // Event does NOT fire when interactionManager changes; ideally
                // we'd want to tell MSAA the role changed, but apparently roles
                // are typically static and that's not a supported workflow.
                // instead, Flash occasionally polls the displaylist, e.g. when
                // you mouseover. calling updateProperties() doesn't necessarily
                // trigger role updates (calls to get_acc*()).
    			case CompositionCompleteEvent.COMPOSITION_COMPLETE:
    			{
    			    // TODO change childID from 0 if we use getChildIDArray
    			    //      otherwise delete this comment
	 				try {
	    				Accessibility.sendEvent(textContainer, 0,
    					                        EVENT_OBJECT_NAMECHANGE);
    					Accessibility.sendEvent(textContainer, 0,
    					                        EVENT_OBJECT_VALUECHANGE);
    					Accessibility.updateProperties();
					} catch (e_err:Error) {
	 					// generic error occurred.
                        // this can happen in the SA player since there is no
                        // Accessibility implementation.
	 				}
    				break;
    			}
    			
                //TODO when we have the FP selection APIs
    			// case SelectionEvent.SELECTION_CHANGE:
    			// {
                //   // this is just stubbed code, I don't know what *needs* to
                //   // be done for SELECTION_CHANGE
    			// 	Accessibility.sendEvent(textContainer, 0,
    			//                          EVENT_OBJECT_TEXTSELECTIONCHANGED);
    			// 	Accessibility.updateProperties();
    			// 	break;
    			// }
    		}
    	}
		
		/**
		 * TODO HACK, remove and refactor.
		 * 
		 * This is copied from PlainTextExportFilter, which I would prefer to
		 * access through TextConverter.export(textFlow,
		 *                                  TextConverter.PLAIN_TEXT_FORMAT);
		 * 
		 * But, PTEF is in importExport, which builds against text_model,
		 * which is a circular dependency.
		 * 
		 * Also, it seems to be adding a trailing newline, which is bad for
		 * accessibility unless it is really there.
		 * 
		 * Might want to export and strip out hyphens.
		 * Move it to the model?
		 */
		private static function exportToString(source:TextFlow):String
		{
			var leaf:IFlowLeafElement = source.getFirstLeaf();
			var rslt:String = "";
			var curString:String = "";
			var discretionaryHyphen:String = String.fromCharCode(0x00AD);
			while (leaf)
			{
            	var p:IParagraphElement = leaf.getParagraph();
            	while (true)
            	{
            		curString = leaf.text;
            		
            		//split out discretionary hyphen and put string back together
					var temparray:Array = curString.split(discretionaryHyphen);
					curString = temparray.join("");
					
	               	rslt += curString;
					leaf = leaf.getNextLeaf(p);
					if (!leaf)
                    {
                        // we want newlines between paragraphs but not at the end
                    	rslt += "\n";
						break;
					}
            	}
            	leaf = p.getLastLeaf().getNextLeaf();
   			}
   			return rslt;
		}
		
		/** 
		 * The zero-based character index value of the first character in the current selection.
		 * Components which wish to support inline IME or Accessibility should call into this method.
		 *
		 * @return the index of the character at the anchor end of the selection, or <code>-1</code> if no text is selected.
		 * 
		 * @playerversion Flash 10.0
		 * @langversion 3.0
		 */
		public function get selectionActiveIndex():int
		{
			var selMgr:ISelectionManager = textFlow.interactionManager;
			var selIndex:int = -1;
			if(selMgr && selMgr.editingMode != EditingMode.READ_ONLY)
			{
				selIndex = selMgr.activePosition;
			}
			
			return selIndex;
		}
		
		/** 
		 * The zero-based character index value of the last character in the current selection.
		 * Components which wish to support inline IME or Accessibility should call into this method.
		 *
		 * @return the index of the character at the active end of the selection, or <code>-1</code> if no text is selected.
		 * 
		 * @playerversion Flash 10.0
		 * @langversion 3.0
		 */
		public function get selectionAnchorIndex():int
		{
			var selMgr:ISelectionManager = textFlow.interactionManager;
			var selIndex:int = -1;
			if(selMgr && selMgr.editingMode != EditingMode.READ_ONLY)
			{
				selIndex = selMgr.anchorPosition;
			}
			
			return selIndex;
		}
		
		/** Enable search index for Ichabod
		 * Returns the entire text of the TextFlow, or null if search index is not enabled
		 * @see GlobalSettings.searchIndexEnabled
		 */
		public function get searchText():String
		{
			return GlobalSettings.enableSearch ? textFlow.getText() : null;
		}
		
	}
}

