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
package org.apache.royale.text.ime
{

	import org.apache.royale.geom.Rectangle;

	//
	// IIMEClient
	//
	/**
	* Dispatched when the user begins to use an IME (input method editor).
	* @eventType org.apache.royale.events.IMEEvent.IME_START_COMPOSITION
	* @playerversion Flash 10
	* @playerversion AIR 1.5
	* @langversion 3.0
	*/
//	[Event(name="imeStartComposition", type="org.apache.royale.text.events.IMEEvent.IME_START_COMPOSITION")]

	/**
	* Dispatched when the user enters text. For IME (input method editor) clients, the receiver should 
	* insert the string contained in the event object's <code>text</code> property at the current insertion point.
	* @eventType org.apache.royale.events.TextEvent.TEXT_INPUT
	* @playerversion Flash 10
	* @playerversion AIR 1.5
	* @langversion 3.0
	*/
//	[Event(name="textInput", type="org.apache.royale.text.events.TextEvent.TEXT_INPUT")]

	/**
	* Interface for IME (input method editor) clients.  Components based on the org.apache.royale.text.engine package must implement 
	* this interface to support editing text inline using an IME. This interface is not used with TextField objects. 
	* TextLayoutFramework (TLF) uses this interface to support inline IME, so clients using TLF do not need to implement this 
	* interface. 
	* <p>To support inline IME, set the <code>imeClient</code> property of an <code>ImeEvent.IME_START_COMPOSITION</code> event to
	* an object which implements this interface.</p>
	*
	* @see org.apache.royale.text.ime.CompositionAttributeRange
	* @see org.apache.royale.events.ImeEvent:imeClient
	* 
	* @playerversion Flash 10.1
	* @playerversion AIR 1.5
	* @langversion 3.0
	*/
	public interface IIMEClient
	{
		/**
		* Callback for updating the contents of the inline editing session.
		* This gets called whenever the text being edited with the IME has changed
		* and its contents are used by the client to redraw the entire inline edit session.
		* 
		* @playerversion Flash 10.1
		* @langversion 3.0
		* 
		* @param text  contains the text of the inline edit session from the IME
		* @param attributes  contains an array of composition clauses with adornment info 
		* @param relativeSelectionStart  start of the inline session relative to the start of the text object
		* @param relativeSelectionEnd  end of the inline session relative to the start of the text object
		*/
		function updateComposition(text:String, attributes:Vector.<CompositionAttributeRange>,
									compositionStartIndex:int, compositionEndIndex:int):void;
									
		/**
		* Use this callback to end the inline editing session and confirm the text.
		* 
		* @playerversion Flash 10.1
		* @langversion 3.0
		* 
		* @param text  the final state of the text in the inline session (the text that got confirmed).
		* @param preserveSelection  when true, you should not reset the current selection to the end of the confirmed text.
		*/
		function confirmComposition(text:String = null, preserveSelection:Boolean = false):void;

		/**
		* This callback is used by the IME to query the bounding box of the text being edited with the IME client.
		* Use this method to place the candidate window and set the mouse cursor in the IME client when the mouse is over the 
		* text field or other component that supports IME.
		* 
		* @playerversion Flash 10.1
		* @langversion 3.0
		* 
		* @param startIndex an integer that specifies the starting location of the range of text for which you need to measure the bounding box.
		* @param endIndex Optional; an integer that specifies the ending location of the range of text for which you need to measure the bounding box.
		*
		* @return  the bounding box of the specified range of text, or <code>null</code> if either or both of the indexes are invalid.
		* The same value should be returned independant of whether <code>startIndex</code> is greater or less than <code>endIndex</code>.
		*/
		function getTextBounds(startIndex:int, endIndex:int):Rectangle;

		/** 
		* The zero-based character index value of the start of the current edit session text (i.e.
		* all text in the inline session that is still not yet confirmed to the document).
		*
		* @return the index of the first character of the composition, or <code>-1</code> if there is no active composition.
		* 
		* @playerversion Flash 10.1
		* @langversion 3.0
		*/
		function get compositionStartIndex():int;

		/** 
		* The zero-based character index value of the end of the current edit session text (i.e.
		* all text in the inline session that is still not yet confirmed to the document).
		*
		* @return the index of the last character of the composition, or <code>-1</code> if there is no active composition.
		* 
		* @playerversion Flash 10.1
		* @langversion 3.0
		*/
		function get compositionEndIndex():int;

		/** 
		* Indicates whether the text in the component is vertical or not.  This will affect the positioning
		* of the candidate window (beside vertical text, below horizontal text).
		*
		* @return <code>true</code> if the text is vertical, otherwise false.
		* 
		* @playerversion Flash 10.1
		* @langversion 3.0
		*/
		function get verticalTextLayout():Boolean;

		/** 
		* The zero-based character index value of the first character in the current selection.
		*
		* @return the index of the character at the anchor end of the selection, or <code>-1</code> if no text is selected.
		* 
		* @playerversion Flash 10.1
		* @langversion 3.0
		*/
		function get selectionAnchorIndex():int;

		/** 
		* The zero-based character index value of the last character in the current selection.
		*
		* @return the index of the character at the active end of the selection, or <code>-1</code> if no text is selected.
		* 
		* @playerversion Flash 10.1
		* @langversion 3.0
		*/
		function get selectionActiveIndex():int;
		
		/** 
		* Sets the range of selected text in the component.
		* If either of the arguments is out of bounds the selection should not be changed.
		* 
		* @param anchorIndex The zero-based index value of the character at the anchor end of the selection
		* @param activeIndex The zero-based index value of the character at the active end of the selection.
		* 
		* @playerversion Flash 10.1
		* @langversion 3.0
		*/
		function selectRange(anchorIndex:int, activeIndex:int):void;
		
		/** 
		* Gets the specified range of text from the component.  This method is called during IME reconversion.
		* 
		* @param startIndex an integer that specifies the starting location of the range of text to be retrieved.
		* @param endIndex an integer that specifies the ending location of the range of text to be retrieved.
		* 
		* @return The requested text, or <code>null</code> if no text is available in the requested range
		* or if either or both of the indexes are invalid.  The same value should be returned 
		* independant of whether <code>startIndex</code> is greater or less than <code>endIndex</code>.
		* 
		* @playerversion Flash 10.1
		* @langversion 3.0
		*/
		function getTextInRange(startIndex:int, endIndex:int):String;
	} // end of class
} // end of package
