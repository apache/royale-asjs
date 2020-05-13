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
package spark.core
{
	// import flash.accessibility.AccessibilityProperties;
	
	
	/**
	 *  The IEditableText interface defines the properties and methods
	 *  for editable text.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.7
	 */
	public interface IEditableText extends IDisplayText
	{ 
		/**
		 *  @copy flash.display.DisplayObject#accessibilityProperties
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.1
		 *  @playerversion AIR 2.0
		 *  @productversion Flex 4.5
		 */
		// function get accessibilityProperties():AccessibilityProperties;
		// function set accessibilityProperties(value:AccessibilityProperties):void;
		
		/**
		 *  @copy flash.text.TextField#displayAsPassword
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.1
		 *  @playerversion AIR 2.0
		 *  @productversion Flex 4.5
		 */
		function get displayAsPassword():Boolean;
		function set displayAsPassword(value:Boolean):void;
		
		/**
		 *  Flag that indicates whether the text is editable.
		 * 
		 *  @default false
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.1
		 *  @playerversion AIR 2.0
		 *  @productversion Flex 4.5
		 */
		function get editable():Boolean;
		function set editable(value:Boolean):void;
		
		/**
		 *  @copy mx.core.UIComponent#enabled
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.1
		 *  @playerversion AIR 2.0
		 *  @productversion Flex 4.5
		 */
		function get enabled():Boolean;
		function set enabled(value:Boolean):void;
		
		/**
		 *  @copy mx.core.UIComponent#focusEnabled
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.1
		 *  @playerversion AIR 2.0
		 *  @productversion Flex 4.5
		 */
		function get focusEnabled():Boolean;
		function set focusEnabled(value:Boolean):void;
		
		/**
		 *  The horizontal scroll position of the text.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.1
		 *  @playerversion AIR 2.0
		 *  @productversion Flex 4.5
		 */
		function get horizontalScrollPosition():Number;
		function set horizontalScrollPosition(value:Number):void;
		
		/**
		 *  Controls word wrapping within the text. This property corresponds
		 *  to the lineBreak style.
		 * 
		 *  @see flashx.textLayout.formats.ITextLayoutFormat#lineBreak 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.1
		 *  @playerversion AIR 2.0
		 *  @productversion Flex 4.5
		 */
		function get lineBreak():String;
		function set lineBreak(value:String):void;
		
		/**
		 *  @copy flash.text.TextField#maxChars
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.1
		 *  @playerversion AIR 2.0
		 *  @productversion Flex 4.5
		 */
		function get maxChars():int;
		function set maxChars(value:int):void;
		
		/**
		 *  @copy flash.text.TextField#multiline
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.1
		 *  @playerversion AIR 2.0
		 *  @productversion Flex 4.5
		 */
		function get multiline():Boolean;
		function set multiline(value:Boolean):void;
		
		/**
		 *  @copy flash.text.TextField#restrict
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.1
		 *  @playerversion AIR 2.0
		 *  @productversion Flex 4.5
		 */
		function get restrict():String;
		function set restrict(value:String):void;
		
		/**
		 *  @copy flash.text.TextField#selectable
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.1
		 *  @playerversion AIR 2.0
		 *  @productversion Flex 4.5
		 */
		function get selectable():Boolean;
		function set selectable(value:Boolean):void;
		
		/**
		 *  The active, or last clicked position, of the selection.
		 *  If the implementation does not support selection anchor
		 *  this is the last character of the selection.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.1
		 *  @playerversion AIR 2.0
		 *  @productversion Flex 4.5
		 */
		function get selectionActivePosition():int;
		
		/**
		 *  The anchor, or first clicked position, of the selection.
		 *  If the implementation does not support selection anchor
		 *  this is the first character of the selection.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.1
		 *  @playerversion AIR 2.0
		 *  @productversion Flex 4.5
		 */
		function get selectionAnchorPosition():int;
		
		/**
		 *  @copy flash.display.InteractiveObject#tabIndex
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.1
		 *  @playerversion AIR 2.0
		 *  @productversion Flex 4.5
		 */
		function get tabIndex():int;
		function set tabIndex(value:int):void;
		
		/**
		 *  The vertical scroll position of the text.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.1
		 *  @playerversion AIR 2.0
		 *  @productversion Flex 4.5
		 */
		function get verticalScrollPosition():Number;
		function set verticalScrollPosition(value:Number):void;
		
		/**
		 *  Scroll so the specified range is in view.
		 *  
		 *  @param anchorPosition The anchor position of the selection range.
		 *  @param activePosition The active position of the selection range.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.1
		 *  @playerversion AIR 2.0
		 *  @productversion Flex 4.5
		 */
		function scrollToRange(anchorPosition:int, activePosition:int):void;
		
		/**
		 *  Inserts the specified text into the text component
		 *  as if you had typed it.
		 *
		 *  <p>If a range was selected, the new text replaces the selected text.
		 *  If there was an insertion point, the new text is inserted there.</p>
		 *
		 *  <p>An insertion point is then set after the new text.
		 *  If necessary, the text will scroll to ensure
		 *  that the insertion point is visible.</p>
		 *
		 *  @param text The text to be inserted.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.1
		 *  @playerversion AIR 2.0
		 *  @productversion Flex 4.5
		 */
		function insertText(text:String):void;
		
		/**
		 *  Appends the specified text to the end of the text component,
		 *  as if you had clicked at the end and typed.
		 *
		 *  <p>An insertion point is then set after the new text.
		 *  If necessary, the text will scroll to ensure
		 *  that the insertion point is visible.</p>
		 *
		 *  @param text The text to be appended.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.1
		 *  @playerversion AIR 2.0
		 *  @productversion Flex 4.5
		 */
		function appendText(text:String):void;
		
		/**
		 *  Selects a specified range of characters.
		 *
		 *  <p>If either position is negative, it will deselect the text range.</p>
		 *
		 *  @param anchorPosition The character position specifying the end
		 *  of the selection that stays fixed when the selection is extended.
		 *
		 *  @param activePosition The character position specifying the end
		 *  of the selection that moves when the selection is extended.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.1
		 *  @playerversion AIR 2.0
		 *  @productversion Flex 4.5
		 */ 
		function selectRange(anchorIndex:int, activeIndex:int):void;
		
		/**
		 *  Selects all of the text.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.1
		 *  @playerversion AIR 2.0
		 *  @productversion Flex 4.5
		 */ 
		function selectAll():void;
		
		/**
		 *  Set focus to this text field.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.1
		 *  @playerversion AIR 2.0
		 *  @productversion Flex 4.5
		 */ 
		function setFocus():void;
	}
}