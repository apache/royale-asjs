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
package org.apache.royale.textLayout.elements {
	import org.apache.royale.textLayout.edit.SelectionFormat;
	import org.apache.royale.textLayout.formats.IListMarkerFormat;
	import org.apache.royale.textLayout.formats.ITextLayoutFormat;
	/** Read-only interface to a configuration object.  Used by TextFlow to guarantee it has an unchangeable 
	 * configuration once its constructed.
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 */
	public interface IConfiguration 
	{
		/** Creates a writeable clone of the IConfiguration object.
		 *
		 * @playerversion Flash 10.2
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		function clone():IConfiguration;
		
		/** 
		* Specifies whether the TAB key is entered as text by Text Layout Framework, or Flash Player or AIR handles it and 
		* turns it into a tabbed panel event. 
		*
		* <p>Default value is <code>false</code>.</p>
		*
		* @playerversion Flash 10
		* @playerversion AIR 1.5
		* @langversion 3.0
		*/
		
		function get manageTabKey():Boolean;

		/** 
		* Specifies whether the Enter / Return key is entered as text by Text Layout Framework, to split a paragraph for example,
		* or the client code handles it. The client code might handle it by committing a form that has a default button 
		* for that purpose, for example. 
		*
		* <p>Default value is <code>true</code>.</p>
		*
		* @playerversion Flash 10
		* @playerversion AIR 1.5
		* @langversion 3.0
		*/
		
		function get manageEnterKey():Boolean;
		
		/** 
		 * Determines how shift-enter is treated. Shift-enter can be treated as a soft return or hard return.
		 * There are three possible levels. Level 0 means all shift-returns will be hard returns.
		 * Level 1 means shift-returns inside lists will be treated as hard returns. Otherwise they will be treated as hard returns.
		 * Level 2 means all shift-returns will be treated as soft returns.
		 *
		 * <p>Default value is <code>2</code>.</p>
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		
		function get shiftEnterLevel():int;
		/** 
		* Policy used for deciding whether the last line of a container fits in the container, or whether it overflows.
		* Use the constants of the OverflowPolicy class to set this property.
		*
		* <p>Default value is OverflowPolicy.FIT_DESCENDERS, which fits the line in the composition area if the area
		* from the top to the baseline fits.</p>
		*
		* @playerversion Flash 10
		* @playerversion AIR 1.5
		* @langversion 3.0
		*
		* @see OverflowPolicy
		*/
		
		function get overflowPolicy():String;
		
		/** 
		* Specifies whether accessibility support is turned on or not.  If <code>true</code>, screen readers can read the TextFlow contents.
		*
		* <p>Default value is <code>false</code>.</p>
		*
		* @playerversion Flash 10
		* @playerversion AIR 1.5
		* @langversion 3.0
		*
		* @see TextFlow
		*/
		
		function get enableAccessibility():Boolean;
		
		/** 
		* Specifies the initial link attributes for all LinkElement objects in the text flow. These are default
		* values for new LinkElement objects that don't specify values for these attributes.
		*
		* The default normal format displays the link in blue with underlining.
		*
		* @playerversion Flash 10
		* @playerversion AIR 1.5
	 	* @langversion 3.0
	 	*
		* @see FlowElement#linkNormalFormat
		* @see org.apache.royale.textLayout.formats.ITextLayoutFormat ITextLayoutFormat
		* @see LinkElement
		*/
		
		function get defaultLinkNormalFormat():ITextLayoutFormat;
		
		/** 
		* Specifies the initial character format attributes that apply to a link (LinkElement) in the text flow when
		* the cursor hovers over it. These are defaults for new LinkElement objects that don't specify values
		* for these attributes.
		*
		* <p>Default is <code>null</code>.</p>
		*
		* @playerversion Flash 10
		* @playerversion AIR 1.5
		* @langversion 3.0
		*
		* @see  FlowElement#linkHoverFormat
		* @see org.apache.royale.textLayout.formats.ITextLayoutFormat ITextLayoutFormat
		* @see LinkElement
		*/
		
		function get defaultLinkHoverFormat():ITextLayoutFormat;
		
		/** 
		* Specifies the active character format attributes that initially apply for all links (LinkElement objects) in the text 
		* flow. These are defaults for new LinkElement objects that don't specify values for these attributes. 
		*
		* <p>Default is <code>null</code>.</p>
		*
		* @playerversion Flash 10
		* @playerversion AIR 1.5
		* @langversion 3.0
		*
		* @see FlowElement#linkActiveFormat 
		* @see org.apache.royale.textLayout.formats.ITextLayoutFormat ITextLayoutFormat
		* @see LinkElement
		*/
		
		function get defaultLinkActiveFormat():ITextLayoutFormat;

		/** 
		 * Specifies the active character format attributes that initially apply for all ListItems in the text 
		 * flow. These are defaults for new ListItemElements objects that don't specify values for these attributes. 
		 *
		 * <p>Default is <code>null</code>.</p>
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 * @see FlowElement#linkActiveFormat 
		 * @see org.apache.royale.textLayout.formats.ITextLayoutFormat ITextLayoutFormat
		 * @see LinkElement
		 */
		
		function get defaultListMarkerFormat():IListMarkerFormat;
			
		/** 
		* Specifies the initial format TextLayoutFormat configuration for a text flow (TextFlow object).
		*
		* <p>Default is <code>null</code>.</p>
		*
		* @playerversion Flash 10
		* @playerversion AIR 1.5
		* @langversion 3.0
		*
		* @see TextFlow
		* @see org.apache.royale.textLayout.formats.ITextLayoutFormat ITextLayoutFormat
		*/
		
		function get textFlowInitialFormat():ITextLayoutFormat;
		
		/** 
		* The initial selection format (SelectionFormat) for a text flow (TextFlow) when its window has focus. 
		* Text Layout Framework uses <code>focusedSelectionFormat</code> to draw the selection when the window is active and one of 
		* the containers in the TextFlow has focus. You can override this format using 
		* <code>SelectionManager.focusedSelectionFormat</code>, if desired.
		*
		* <p>The SelectionFormat class specifies the default values, which invert the color of the text and its background.</p>
		*
		* @playerversion Flash 10
		* @playerversion AIR 1.5
		* @langversion 3.0
		*
		* @see org.apache.royale.textLayout.edit.SelectionFormat SelectionFormat
		* @see org.apache.royale.textLayout.edit.SelectionManager#focusedSelectionFormat SelectionManager.focusedSelectionFormat
		* @see TextFlow
		*/
		
		function get focusedSelectionFormat():SelectionFormat;
		
		/** 
		* The initial selection format that Text Layout Framework uses to draw the selection when the window is active but none of the containers
		* in the TextFlow have focus. You can override this format using <code>SelectionManager.unfocusedSelectionFormat</code>, if desired.
		*
		* <p>If you do not override <code>unfocusedSelectionFormat</code> the SelectionFormat values used are:</p>
		*
		* <ul>
		*   <li><code>color = 0xffffff</code> (white)</li>
		*   <li><code>alpha = 0</code></li>
		*   <li><code>blendMode = flash.display.BlendMode.DIFFERENCE</code></li>
		* </ul>
		* <p>The result is no selection is displayed.</p>
		*
		* @playerversion Flash 10
		* @playerversion AIR 1.5
		* @langversion 3.0
		*
		* @see org.apache.royale.textLayout.edit.SelectionFormat SelectionFormat
		* @see org.apache.royale.textLayout.edit.SelectionManager#unfocusedSelectionFormat SelectionManager.unfocusedSelectionFormat
		* @see TextFlow
		*/
		
		function get unfocusedSelectionFormat():SelectionFormat;
		
		/** 
		* The initial selection format (SelectionFormat) for a text flow (TextFlow) when its window is inactive. Text Layout Framework uses 
		* <code>inactiveSelectionFormat</code> for drawing the selection when the window is inactive. You can override 
		* this format using <code>SelectionManager.inactiveSelectionFormat</code>, if desired.
		*
		* <p>If you do not override <code>unfocusedSelectionFormat</code> the SelectionFormat values used are:</p> 
		* <ul>
		*   <li><code>color = 0xffffff</code> (white)</li>
		*   <li><code>alpha = 0</code></li>
		*   <li><code>blendMode = flash.display.BlendMode.DIFFERENCE</code></li>
		* </ul>
		* <p>The result is no selection is displayed.</p>
		*
		* @playerversion Flash 10
		* @playerversion AIR 1.5
		* @langversion 3.0
		*
		* @see org.apache.royale.textLayout.edit.SelectionFormat SelectionFormat
		* @see org.apache.royale.textLayout.edit.SelectionManager#inactiveSelectionFormat SelectionManager.inactiveSelectionFormat
		* @see TextFlow
		*/
		
		function get inactiveSelectionFormat():SelectionFormat;	
		
		/** 
		* Specifies a timed delay between one scroll and the next to prevent scrolling from going 
		* too fast. This value specifies what the delay is in milliseconds. The default value is 35.
		*
		* @playerversion Flash 10
		* @playerversion AIR 1.5
		* @langversion 3.0
		*/
		
		function get scrollDragDelay():Number;
		
		/** Specifies the default number of pixels to scroll when the user initiates auto scrolling by dragging 
		* the selection. Default value is 20.
		*
		* @playerversion Flash 10
		* @playerversion AIR 1.5
		* @langversion 3.0
		*/
		
		function get scrollDragPixels():Number;
		
		/**
		* Specifies the default percentage of the text flow to scroll for page scrolls. Default value is
		* 7.0 / 8.0, or .875.
		*
		* @playerversion Flash 10
		* @playerversion AIR 1.5
		* @langversion 3.0
		*/
		
		function get scrollPagePercentage(): Number;
		
		/** Specifies the default number of pixels to scroll for Mouse wheel events. Default value is 20.
		*
		* @playerversion Flash 10
		* @playerversion AIR 1.5
		* @langversion 3.0
		*/
		
		function get scrollMouseWheelMultiplier(): Number;
		
		/** Specifies the type of flow composer to attach to a new TextFlow object by default. Default value is StandardFlowComposer.
		*
		* @see org.apache.royale.textLayout.compose.StandardFlowComposer StandardFlowComposer
		* @see org.apache.royale.textLayout.elements.TextFlow TextFlow
		* 
		* @playerversion Flash 10
		* @playerversion AIR 1.5
		* @langversion 3.0
		*/
		
		function get flowComposerClass():Class;
		
		/** Requests that the process of composing text release line creation data after composing each paragraph.  
		* This request saves memory but slows down the composing process.
		*
		* <p>Default value is <code>false</code>.</p>
		*
		* @see org.apache.royale.textLayout.compose.StandardFlowComposer StandardFlowComposer
		* @see org.apache.royale.text.engine.TextBlock#releaseLineCreationData() TextBlock.releaseLineCreationData()
		* 
		* @playerversion Flash 10
		* @playerversion AIR 1.5
		* @langversion 3.0
		*/
		function get releaseLineCreationData():Boolean;
		
		/** Specifies the callback used for resolving an inline graphic element.
		* The callback takes a <code>org.apache.royale.textLayout.elements.InlineGraphicElement</code> object and returns
		* the value to be used as the element's <code>org.apache.royale.textLayout.elements.InlineGraphicElement#source</code>.
		* 
		* This callback provides the mechanism to delay providing an inline graphic element's source until just before it is composed.
		* <p><strong>Note:</strong> this callback will be invoked only if a 
		* placeholder source of String type is already set. Moreover, it may be invoked
		* multiple times. </p>
		* 
		* @see org.apache.royale.textLayout.elements.InlineGraphicElement InlineGraphicElement
		* 
		* @playerversion Flash 10
		* @playerversion AIR 1.5
		* @langversion 3.0
		*/
		function get inlineGraphicResolverFunction():Function;

		/** Specifies the callback used for custom cursor.
		 * The callback takes a <code>String</code> object, string is cursor name and returns the value to
		 * be used in MouseCursor.cursor.
		 * 
		 * This callback provides the user to customize the cursor
		 * 
		 * 
		 * 
		 * @playerversion Flash 10.2
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		function get cursorFunction():Function;

		function set flowComposerClass(flowComposerClass:Class):void;

		function set textFlowInitialFormat(textFlowInitialFormat:ITextLayoutFormat):void;
		function getImmutableClone():IConfiguration;
	}
}
