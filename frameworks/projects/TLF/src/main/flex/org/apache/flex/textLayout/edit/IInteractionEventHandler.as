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
package org.apache.royale.textLayout.edit
{
	import org.apache.royale.text.events.TextEvent;
	import org.apache.royale.text.events.IMEEvent;
	import org.apache.royale.textLayout.events.ContextMenuEvent;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.KeyboardEvent;
	import org.apache.royale.events.MouseEvent;
	
	/**
	 * The IInteractionEventHandler interface defines the event handler functions that
	 * are handled by a Text Layout Framework selection or edit manager.
	 * 
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 */
	public interface IInteractionEventHandler
	{
		/** 
		 * Processes an edit event.
		 * 
		 * <p>Edit events are dispatched for cut, copy, paste, and selectAll commands.</p>
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
 		 * @langversion 3.0
		 */	
		function editHandler(event:Event):void;
		
		/** 
		* Processes a keyDown event.
		*  
		* @playerversion Flash 10
		* @playerversion AIR 1.5
 		* @langversion 3.0
		*/	
		function keyDownHandler(event:KeyboardEvent):void;
		
		/** 
		* Processes a keyUp event.
		* 
		* @playerversion Flash 10
		* @playerversion AIR 1.5
 		* @langversion 3.0
		*/	
		function keyUpHandler(event:KeyboardEvent):void;		
		
		/** 
		* Processes a keyFocusChange event.
		* 
		* @playerversion Flash 10
		* @playerversion AIR 1.5
 		* @langversion 3.0
		*/	
		function keyFocusChangeHandler(event:Event):void;
		
		/** 
		 * Processes a TextEvent.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
 		 * @langversion 3.0
		 */
		function textInputHandler(event:TextEvent):void;

		/** 
		 * Processes an imeStartComposition event
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
 		 * @langversion 3.0
		 */
		function imeStartCompositionHandler(event:IMEEvent):void;
		
		/** 
		 * Processes an softKeyboardActivating event
		 * 
		 * @playerversion Flash 10.2
		 * @playerversion AIR 1.5
 		 * @langversion 3.0
		 */
		function softKeyboardActivatingHandler(event:Event):void;
		
		/** 
		 * Processes a mouseDown event.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
 		 * @langversion 3.0
		 */	
		function mouseDownHandler(event:MouseEvent):void;

		/** 
		 * Processes a mouseMove event.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
 		 * @langversion 3.0
		 */	
		function mouseMoveHandler(event:MouseEvent):void;
		
		/** 
		 * Processes a mouseUp event.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
 		 * @langversion 3.0
		 */	
		function mouseUpHandler(event:MouseEvent):void;		
		
		/** 
		 * Processes a mouseDoubleClick event.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
 		 * @langversion 3.0
		 */	
		function mouseDoubleClickHandler(event:MouseEvent):void;

		/** 
		 * Processes a mouseOver event.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
 		 * @langversion 3.0
		 */			
		function mouseOverHandler(event:MouseEvent):void;

		/** 
		 * Processes a mouseOut event.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
 		 * @langversion 3.0
		 */					
		function mouseOutHandler(event:MouseEvent):void;
		
		/** 
		 * Processes a focusIn event.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
 		 * @langversion 3.0
		 */
		function focusInHandler(event:Event):void;
		 
		/** 
		 * Processes a focusOut event.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
 		 * @langversion 3.0
		 */
		function focusOutHandler(event:Event):void;

		/** 
		 * Processes an activate event.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
 		 * @langversion 3.0
		 */				
		function activateHandler(event:Event):void;
		
		/** 
		 * Processes a deactivate event.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
 		 * @langversion 3.0
		 */				
		function deactivateHandler(event:Event):void;
		
		/** 
		 * Processes a focusChange event.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
 		 * @langversion 3.0
		 */				
		function focusChangeHandler(event:Event):void
		
		/** 
		 * Processes a menuSelect event.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
 		 * @langversion 3.0
		 */				
		function menuSelectHandler(event:ContextMenuEvent):void
		
		/** 
		 * Processes a mouseWheel event.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
 		 * @langversion 3.0
		 */				
		function mouseWheelHandler(event:MouseEvent):void
	}
}
