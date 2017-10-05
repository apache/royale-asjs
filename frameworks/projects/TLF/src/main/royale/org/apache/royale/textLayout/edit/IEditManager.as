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
	import org.apache.royale.textLayout.elements.IDivElement;
	import org.apache.royale.textLayout.elements.IFlowElement;
	import org.apache.royale.textLayout.elements.IFlowGroupElement;
	import org.apache.royale.textLayout.elements.IInlineGraphicElement;
	import org.apache.royale.textLayout.elements.ILinkElement;
	import org.apache.royale.textLayout.elements.IListElement;
	import org.apache.royale.textLayout.elements.IParagraphElement;
	import org.apache.royale.textLayout.elements.ISubParagraphGroupElement;
	import org.apache.royale.textLayout.elements.ITCYElement;
	import org.apache.royale.textLayout.elements.ITableElement;
	import org.apache.royale.textLayout.formats.ITextLayoutFormat;
	import org.apache.royale.textLayout.operations.FlowOperation;
	import org.apache.royale.utils.undo.IOperation;
	import org.apache.royale.utils.undo.IUndoManager;
    
    [Exclude(name="delayedOperations",kind="property")]
    /** 
     * IEditManager defines the interface for handling edit operations of a text flow.
     * 
     * <p>To enable text flow editing, assign an IEditManager instance to the <code>interactionManager</code> 
     * property of the TextFlow object. The edit manager handles changes to the text (such as insertions, 
     * deletions, and format changes). Changes are reversible if the edit manager has an undo manager. The edit
     * manager triggers the recomposition and display of the text flow, as necessary.</p>
     * 
     * @playerversion Flash 10
     * @playerversion AIR 1.5
     * @langversion 3.0
     * 
     * @see EditManager
     * @see org.apache.royale.textLayout.elements.TextFlow
     * @see flashx.undo.UndoManager
     * 
     */
    public interface IEditManager extends ISelectionManager
    {               

        /** 
         * The UndoManager object assigned to this EditManager instance, if there is one.
         * 
         * <p>An undo manager handles undo and redo operations.</p>
         * 
         * @playerversion Flash 10
         * @playerversion AIR 1.5
         * @langversion 3.0
         */
        function get undoManager():IUndoManager

        /** 
         * Changes the formats of the specified (or current) selection.
         * 
         * <p>Executes an undoable operation that applies the new formats.
         * Only style attributes set for the TextLayoutFormat objects are applied.
         * Undefined attributes in the format objects are not changed.
         * </p>
         * 
         * @param leafFormat    The format to apply to leaf elements such as spans and inline graphics.
         * @param paragraphFormat   The format to apply to paragraph elements.
         * @param containerFormat   The format to apply to the containers.
         * @param operationState    Specifies the text to which this operation applies; 
         * if <code>null</code>, the operation applies to the current selection.
         *
         * 
         * @playerversion Flash 10
         * @playerversion AIR 1.5
         * @langversion 3.0
         */     
        function applyFormat(leafFormat:ITextLayoutFormat, paragraphFormat:ITextLayoutFormat, containerFormat:ITextLayoutFormat, operationState:SelectionState = null):void

        
        /** 
         * Undefines formats of the specified (or current) selection.
         * 
         * <p>Executes an undoable operation that undefines the specified formats.
         * Only style attributes set for the TextLayoutFormat objects are applied.
         * Undefined attributes in the format objects are not changed.
         * </p>
         * 
         * @param leafFormat     The format whose set values indicate properties to undefine to LeafFlowElement objects in the selected range.
         * @param paragraphFormat The format whose set values indicate properties to undefine to ParagraphElement objects in the selected range.
         * @param containerFormat The format whose set values indicate properties to undefine to ContainerController objects in the selected range.
         * @param operationState    Specifies the text to which this operation applies; 
         * if <code>null</code>, the operation applies to the current selection.
         * 
         * @playerversion Flash 10
         * @playerversion AIR 1.5
         * @langversion 3.0
         */     
        function clearFormat(leafFormat:ITextLayoutFormat, paragraphFormat:ITextLayoutFormat, containerFormat:ITextLayoutFormat, operationState:SelectionState = null):void

        /** 
         * Changes the format applied to the leaf elements in the 
         * specified (or current) selection.
         * 
         * <p>Executes an undoable operation that applies the new format to leaf elements such as
         * SpanElement and InlineGraphicElement objects.
         * Only style attributes set for the TextLayoutFormat objects are applied.
         * Undefined attributes in the format object are changed.</p>
         * 
         * @param format    The format to apply.
         * @param operationState    Specifies the text to which this operation applies; 
         * if <code>null</code>, the operation applies to the current selection.
         * 
         * 
         * @playerversion Flash 10
         * @playerversion AIR 1.5
         * @langversion 3.0
         */     
        function applyLeafFormat(format:ITextLayoutFormat, operationState:SelectionState = null):void;

        /** 
         * Transforms text into a TCY run, or a TCY run into non-TCY text. 
         * 
         * <p>TCY, or tate-chu-yoko, causes text to draw horizontally within a vertical line, and is 
         * used to make small blocks of non-Japanese text or numbers, such as dates, more readable in vertical text.</p>
         * 
         * @param tcyOn Set to <code>true</code> to apply TCY to a text range, <code>false</code> to remove TCY. 
         * @param operationState    Specifies the text to which this operation applies; 
         * if <code>null</code>, the operation applies to the current selection.
         * @return The TCYElement that was created.
         * 
         * @see org.apache.royale.textLayout.elements.TCYElement
         * 
         * @playerversion Flash 10
         * @playerversion AIR 1.5
         * @langversion 3.0
         */         
        function applyTCY(tcyOn:Boolean, operationState:SelectionState = null):ITCYElement;
        
        /** 
         * Transforms a selection into a link, or a link into normal text.
         * 
         * <p>Executes an undoable operation that creates or removes the link.</p>
         * 
         *  <p>If a <code>target</code> parameter is specified, it must be one of the following values:</p>
         * <ul>
         *  <li>"_self"</li>
         *  <li>"_blank"</li>
         *  <li>"_parent"</li>
         *  <li>"_top"</li>
         * </ul>
         * <p>In browser-hosted runtimes, a target of "_self" replaces the current html page.  
         * So, if the SWF content containing the link is in a page within
         * a frame or frameset, the linked content loads within that frame.  If the page 
         * is at the top level, the linked content opens to replace the original page.  
         * A target of "_blank" opens a new browser window with no name.  
         * A target of "_parent" replaces the parent of the html page containing the SWF content.  
         * A target of "_top" replaces the top-level page in the current browser window.</p>
         * 
         * <p>In other runtimes, such as Adobe AIR, the link opens in the user's default browser and the
         * <code>target</code> parameter is ignored.</p>
         * 
         * <p>The <code>extendToLinkBoundary</code> parameter determines how the edit manager 
         * treats a selection that intersects with one or more existing links. If the parameter is 
         * <code>true</code>, then the operation is applied as a unit to the selection and the
         * whole text of the existing links. Thus, a single link is created that spans from
         * the beginning of the first link intersected to the end of the last link intersected.
         * In contrast, if <code>extendToLinkBoundary</code> were <code>false</code> in this situation, 
         * the existing partially selected links would be split into two links.</p>
         *
         * @param href The uri referenced by the link.
         * @param target The target browser window of the link.
         * @param extendToLinkBoundary Specifies whether to consolidate selection with any overlapping existing links, and then apply the change.
         * @param operationState    Specifies the text to which this operation applies; 
         * if <code>null</code>, the operation applies to the current selection.
         * @return The LinkElement that was created.
         * 
         * @see org.apache.royale.textLayout.elements.LinkElement
         * 
         * @playerversion Flash 10
         * @playerversion AIR 1.5
         * @langversion 3.0
		 */
		function applyLink(href:String, target:String = null, extendToLinkBoundary:Boolean = false, operationState:SelectionState = null):ILinkElement;
        
        /**
        * Changes the ID of an element.
        * 
         * <p>If the <code>relativeStart</code> or <code>relativeEnd</code> parameters are set (to
         * anything other than the default values), then the element is split. The parts of the element
         * outside this range retain the original ID. Setting both the <code>relativeStart</code> and 
         * <code>relativeEnd</code> parameters creates elements with duplicate IDs.</p>
         * 
        * @param newID The new ID value.
        * @param targetElement The element to modify.
        * @param relativeStart An offset from the beginning of the element at which to split the element when assigning the new ID.
        * @param relativeEnd An offset from the beginning of the element at which to split the element when assigning the new ID.
        * @param operationState Specifies the selection to restore when undoing this operation; 
        * if <code>null</code>, the operation saves the current selection.
        * 
         * 
        * @playerversion Flash 10
        * @playerversion AIR 1.5
        * @langversion 3.0 
        */
        function changeElementID(newID:String, targetElement:IFlowElement, relativeStart:int = 0, relativeEnd:int = -1, operationState:SelectionState = null):void;
        
        [Deprecated(replacement="applyFormatToElement", deprecatedSince="2.0")]
        /**
        * Changes the styleName of an element or part of an element.
         * 
         * <p>If the <code>relativeStart</code> or <code>relativeEnd</code> parameters are set (to
         * anything other than the default values), then the element is split. The parts of the element
         * outside this range retain the original style.</p>
         * 
        * @param newName The name of the new style.
        * @param targetElement Specifies the element to change.
        * @param relativeStart An offset from the beginning of the element at which to split the element when assigning the new style.
        * @param relativeEnd An offset from the end of the element at which to split the element when assigning the new style.
        * @param operationState Specifies the selection to restore when undoing this operation; 
        * if <code>null</code>, the operation saves the current selection.
        * 
        * @playerversion Flash 10
        * @playerversion AIR 1.5
        * @langversion 3.0 
        */
        function changeStyleName(newName:String, targetElement:IFlowElement, relativeStart:int = 0, relativeEnd:int = -1, operationState:SelectionState = null):void;

        /**
         * Changes the typeName of an element or part of an element.
         * 
         * <p>If the <code>relativeStart</code> or <code>relativeEnd</code> parameters are set (to
         * anything other than the default values), then the element is split. The parts of the element
         * outside this range retain the original style.</p>
         * 
         * @param newName The name of the new type.
         * @param targetElement Specifies the element to change.
         * @param relativeStart An offset from the beginning of the element at which to split the element when assigning the new style
         * @param relativeEnd An offset from the end of the element at which to split the element when assigning the new style
         * @param operationState    Specifies the selection to restore when undoing this operation; 
         * if <code>null</code>, the operation saves the current selection.
         * 
         * @playerversion Flash 10
         * @playerversion AIR 1.5
         * @langversion 3.0 
         */
        function changeTypeName(newName:String, targetElement:IFlowElement, relativeStart:int = 0, relativeEnd:int = -1, operationState:SelectionState = null):void;

        /** 
         * Deletes a range of text, or, if a point selection is given, deletes the next character.
         * 
         * @param operationState    specifies the text to which this operation applies; 
         * if <code>null</code>, the operation applies to the current selection.
         * 
         * 
         * @playerversion Flash 10
         * @playerversion AIR 1.5
         * @langversion 3.0
         */
        function deleteNextCharacter(operationState:SelectionState = null):void;
        
        /** 
         * Deletes a range of text, or, if a point selection is given, deletes the previous character.
         * 
         * @param operationState    Specifies the text to which this operation applies; 
         * if <code>null</code>, the operation applies to the current selection.
         * 
         * 
         * @playerversion Flash 10
         * @playerversion AIR 1.5
         * @langversion 3.0
         */
        function deletePreviousCharacter(operationState:SelectionState = null):void;
        
        /** 
         * Deletes the next word.
         * 
         * <p>If a range is selected, the first word of the range is deleted.</p>
         * 
         * @param operationState Specifies the text to which this operation applies; 
         * if <code>null</code>, the operation applies to the current selection.
         * 
         * 
         * @playerversion Flash 10
         * @playerversion AIR 1.5
         * @langversion 3.0
         */     
        function deleteNextWord(operationState:SelectionState = null):void;
        
        /** 
         * Deletes the previous word.
         * 
         * <p>If a range is selected, the first word of the range is deleted.</p>
         * 
         * @param operationState    Specifies the text to which this operation applies; 
         * if <code>null</code>, the operation applies to the current selection.
         * 
         * 
         * @playerversion Flash 10
         * @playerversion AIR 1.5
         * @langversion 3.0
         */     
        function deletePreviousWord(operationState:SelectionState = null):void;     
        
        /** 
         * Deletes a range of text.
         * 
         * @param operationState    Specifies the text to which this operation applies; 
         * if <code>null</code>, the operation applies to the current selection.
         * 
         * 
         * @playerversion Flash 10
         * @playerversion AIR 1.5
         * @langversion 3.0
         */
        function deleteText(operationState:SelectionState = null):void

        /** 
         * Inserts an image.
         * 
         * <p>The source of the image can be a string containing a URI, URLRequest object, a Class object representing an embedded asset,
         * or a DisplayObject instance.</p>
         *  
         * <p>The width and height values can be the number of pixels, a percent, or the string, 'auto', 
         * in which case the actual dimension of the graphic is used.</p>
         * 
         * <p>Set the <code>float</code> to one of the constants defined in the Float class to specify whether
         * the image should be displayed to the left or right of any text or inline with the text.</p>
         * 
         *  @param  source  Can be either a String interpreted as a uri, a Class interpreted as the class of an Embed DisplayObject, 
         *                  a DisplayObject instance or a URLRequest. 
         *  @param  width   The width of the image to insert (number, percent, or 'auto').
         *  @param  height  The height of the image to insert (number, percent, or 'auto').
         *  @param  options None supported.
         * @param operationState    Specifies the text to which this operation applies; 
         * if <code>null</code>, the operation applies to the current selection.
         * 
         * 
         * @see org.apache.royale.textLayout.elements.InlineGraphicElement
         * 
         * @playerversion Flash 10
         * @playerversion AIR 1.5
         * @langversion 3.0
		 */
		function insertInlineGraphic(source:Object, width:Object, height:Object, options:Object = null, operationState:SelectionState = null):IInlineGraphicElement;
		
		function insertTableElement(table:ITableElement, operationState:SelectionState = null):void;
        
        /** 
         * Modifies an existing inline graphic.
         * 
         * <p>Set unchanging properties to the values in the original graphic. (Modifying an existing graphic object
         * is typically more efficient than deleting and recreating one.)</p>
         * 
         *  @param  source  Can be either a String interpreted as a uri, a Class interpreted as the class of an Embed DisplayObject, 
         *                  a DisplayObject instance or a URLRequest. 
         *  @param  width   The new width for the image (number or percent).
         *  @param  height  The new height for the image (number or percent).
         *  @param  options None supported.
         * @param operationState    Specifies the text to which this operation applies; 
         * if <code>null</code>, the operation applies to the current selection.
         * 
         * 
         *  @see org.apache.royale.textLayout.elements.InlineGraphicElement
         * 
        * @playerversion Flash 10
        * @playerversion AIR 1.5
         * @langversion 3.0
         */         
        function modifyInlineGraphic(source:Object, width:Object, height:Object, options:Object = null, operationState:SelectionState = null):void;

        /** 
         * Inserts text.
         * 
         * <p>Inserts the text at a position or range in the text. If the location supplied in the 
         * <code>operationState</code> parameter is a range (or the parameter is <code>null</code> and the
         * current selection is a range), then the text currently in the range 
         * is replaced by the inserted text.</p>
         * 
         * @param   text        The string to insert.
         * @param operationState    Specifies the text in the flow to which this operation applies; 
         * if <code>null</code>, the operation applies to the current selection.
         * 
         * 
         * @playerversion Flash 10
         * @playerversion AIR 1.5
         * @langversion 3.0
         */ 
        function insertText(text:String, operationState:SelectionState = null):void;
        
        /** 
         * Overwrites the selected text.
         * 
         * <p>If the selection is a point selection, the first character is overwritten by the new text.</p>
         * 
         * @param text The string to insert.
         * @param operationState Specifies the text to which this operation applies; 
         * if <code>null</code>, the operation applies to the current selection.
         * 
         * 
         * @playerversion Flash 10
         * @playerversion AIR 1.5
         * @langversion 3.0
         */ 
        function overwriteText(text:String, operationState:SelectionState = null):void;

        /** 
         * Applies paragraph styles to any paragraphs in the selection.
         * 
         * <p>Any style properties in the format object that are <code>null</code> are left unchanged.</p> 
         * 
         * @param format The format to apply to the selected paragraphs.
         * @param operationState    Specifies the text to which this operation applies; 
         * if <code>null</code>, the operation applies to the current selection.
         * 
         * 
         * @playerversion Flash 10
         * @playerversion AIR 1.5
         * @langversion 3.0
         */     
        function applyParagraphFormat(format:ITextLayoutFormat, operationState:SelectionState = null):void;

        /** 
         * Applies container styles to any containers in the selection.
         * 
         * <p>Any style properties in the format object that are <code>null</code> are left unchanged.</p> 
         * 
         * @param format    The format to apply to the containers in the range
         * @param operationState    Specifies the text to which this operation applies; 
         * if <code>null</code>, the operation applies to the current selection.
         * 
         * 
         * @playerversion Flash 10
         * @playerversion AIR 1.5
         * @langversion 3.0
         */     
        function applyContainerFormat(format:ITextLayoutFormat, operationState:SelectionState = null):void;
        
        /** 
         * Applies styles to the specified element.
         * 
         * <p>Any style properties in the format object that are <code>null</code> are left unchanged.
         * Only styles that are relevant to the specified element are applied.</p> 
         * 
         * @param   targetElement The element to which the styles are applied.
         * @param   format  The format containing the styles to apply.
         * @param relativeStart An offset from the beginning of the element at which to split the element when assigning the new formatting.
         * @param relativeEnd An offset from the beginning of the element at which to split the element when applying the new formatting.
         * @param operationState    Specifies the text to which this operation applies; 
         * if <code>null</code>, the operation applies to the current selection.
         * 
         * 
         * @playerversion Flash 10
         * @playerversion AIR 1.5
         * @langversion 3.0
         */ 
        function applyFormatToElement(targetElement:IFlowElement, format:ITextLayoutFormat, relativeStart:int = 0, relativeEnd:int = -1, operationState:SelectionState = null):void;
        
        /** 
         * Undefines styles to the specified element.
         * 
         * <p>Any style properties in the format object that are <code>undefined</code> are left unchanged.
         * Any styles that are defined in the specififed format are undefined on the specified element.</p> 
         * 
         * @param   targetElement The element to which the styles are applied.
         * @param   format  The format containing the styles to undefine.
         * @param operationState    Specifies the text to which this operation applies; 
         * if <code>null</code>, the operation applies to the current selection.
         * 
         * @playerversion Flash 10
         * @playerversion AIR 1.5
         * @langversion 3.0
         */ 
        function clearFormatOnElement(targetElement:IFlowElement, format:ITextLayoutFormat, operationState:SelectionState = null):void;
        
        /** 
         * Splits the paragraph at the current position, creating a new paragraph after the current one.
         *   
         * <p>If a range of text is specified, the text 
         * in the range is deleted.</p>
         * 
         * @param operationState    Specifies the text to which this operation applies; 
         * if <code>null</code>, the operation applies to the current selection.
         * 
         * @return  The new paragraph that was created.
         * 
         * 
         * @playerversion Flash 10
         * @playerversion AIR 1.5
         * @langversion 3.0
         */
        function splitParagraph(operationState:SelectionState = null):IParagraphElement;
        
        /** Splits the target element at the location specified, creating a new element after the current one.
         * If the operationState is a range, the text within the range is deleted. The new element is created 
         * after the text position specified by operationState. Note that splitting a SubParagraphGroupElement 
         * will have no effect because they will automatically remerge with the adejacent elements.
         * 
         * <p>An example where you might want to use this is if you have a list, and you want to divide it into two lists.</p>
         * 
         * @param target  The element to be split.
         * @param operationState    Specifies the text to which this operation applies; 
         * if <code>null</code>, the operation applies to the current selection.
         * @return The new paragraph that was created.
         * 
         * @playerversion Flash 10
         * @playerversion AIR 1.5
         * @langversion 3.0
		 */
		function splitElement(target : IFlowGroupElement, operationState : SelectionState = null) : IFlowGroupElement;
        
        /** Creates a new IDivElement that contains the entire range specified in the operationState at the lowest
         * common parent element that contains both the start and end points of the range. If the start and end
         * points are the same, a new IDivElement is created at that position with a single child paragraph.
         * 
         * @param parent    Specifies a parent element for the new IDivElement.
         * If <code>null</code> the new parent will be lowest level that contains the SelectionState.
         * @param format    Formatting attributes to apply to the new IDivElement.
         * @param operationState    Specifies the text to which this operation applies; 
         * if <code>null</code>, the operation applies to the current selection.
         * @return  The new IDivElement that was created.
         * 
         * @playerversion Flash 10
         * @playerversion AIR 1.5
         * @langversion 3.0
          */
        function createDiv(parent:IFlowGroupElement = null, format:ITextLayoutFormat = null, operationState:SelectionState = null):IDivElement;
        
        /** Creates a new ListElement that contains the entire range specified in the operationState at the lowest
         * common parent element that contains both the start and end points of the range. Each paragraph within the 
         * range will become a ListItemElement in the new ListElement. If the start and end
         * points are the same, a new ListElement is created at that position with a single ListItemElement child.
         * 
         * @param parent Optionally specifies a parent element for the new ListElement.  
         * If <code>null</code> the new parent will be lowest level that contains the SelectionState.
         * @param format Formatting attributes to apply to the new ListElement.
         * @param operationState    Specifies the text to which this operation applies; 
         * if <code>null</code>, the operation applies to the current selection.
         * @return  The new ListElement that was created.
         * 
         * @playerversion Flash 10
         * @playerversion AIR 1.5
         * @langversion 3.0
		 */
		function createList(parent:IFlowGroupElement = null, format:ITextLayoutFormat = null, operationState:SelectionState = null):IListElement;

        /** Move a set of FlowElements from one IFlowGroupElement to another. The desinationElement must be a legal parent type for the children being moved,
         * or an exception is thrown.
         * 
         * @param source    The orginal parent of the elements to be moved.
         * @param sourceIndex   The child index within the source of the first element to be moved.
         * @param numChildren   The number of children being moved.
         * @param destination   The new parent of elements after move.
         * @param destinationIndex  The child index within the destination to where elements are moved to.
         * @param operationState    Specifies the text to which this operation applies, and to which selection returns to upon undo.  
         * If <code>null</code>, the operation applies to the current selection.  If there is no current selection, this parameter must be non-null.
         * 
         * @playerversion Flash 10
         * @playerversion AIR 1.5
         * @langversion 3.0
         */
        function moveChildren(source:IFlowGroupElement, sourceIndex:int, numChildren:int, destination:IFlowGroupElement, destinationIndex:int, operationState:SelectionState = null):void

        /** Creates a new SubParagraphGroupElement that contains the entire range specified in the operationState at the lowest
         * common parent element that contains both the start and end points of the range. If the start and end
         * points are the same, nothing is done.
         * 
         * @param parent Specifies a parent element for the new SubParagraphGroupElement element.
         * If <code>null</code> the new parent will be lowest level that contains the SelectionState.
         * @param format    Formatting attributes to apply to the new SubParagraphGroupElement
         * @param operationState    Specifies the text to which this operation applies; 
         * if <code>null</code>, the operation applies to the current selection.
         * @return  The new SubParagraphGroupElement that was created.
         * 
         * @playerversion Flash 10
         * @playerversion AIR 1.5
         * @langversion 3.0
         */
        function createSubParagraphGroup(parent:IFlowGroupElement = null, format:ITextLayoutFormat = null, operationState:SelectionState = null):ISubParagraphGroupElement;

        /** 
         * Deletes the selected area and returns the deleted area in a TextScrap object. 
         * 
         * <p>The resulting TextScrap can be posted to the system clipboard or used in a 
         * subsequent <code>pasteTextOperation()</code> operation.</p>
         * 
         * @param operationState    Specifies the text to which this operation applies; 
         * if <code>null</code>, the operation applies to the current selection.
         * @return The TextScrap that was cut.
         * 
         * 
         * @see org.apache.royale.textLayout.edit.IEditManager.pasteTextScrap
         * @see org.apache.royale.textLayout.edit.TextClipboard.setContents
         *  
         * @playerversion Flash 10
         * @playerversion AIR 1.5
         * @langversion 3.0
         */
        function cutTextScrap(operationState:SelectionState = null):TextScrap;
        
        /** 
         * Pastes the TextScrap into the selected area.
         * 
         * <p>If a range of text is specified, the text 
         * in the range is deleted.</p>
         * 
         * @param scrapToPaste  The TextScrap to paste.
         * @param operationState    Specifies the text to which this operation applies; 
         * if <code>null</code>, the operation applies to the current selection.
         * 
         * 
         * @see org.apache.royale.textLayout.edit.IEditManager.cutTextScrap
         * @see org.apache.royale.textLayout.edit.TextClipboard.getContents
         * @see org.apache.royale.textLayout.edit.TextScrap
         * 
         * @playerversion Flash 10
         * @playerversion AIR 1.5
         * @langversion 3.0
         */
         function pasteTextScrap(scrapToPaste:TextScrap, operationState:SelectionState = null):void;        

        /** 
         * Begins a new group of operations. 
         * 
         * <p>All operations executed after the call to <code>beginCompositeOperation()</code>, and before the 
         * matching call to <code>endCompositeOperation()</code> are executed and grouped together as a single 
         * operation that can be undone as a unit.</p> 
         * 
         * <p>A <code>beginCompositeOperation</code>/<code>endCompositeOperation</code> block can be nested inside another 
         * <code>beginCompositeOperation</code>/<code>endCompositeOperation</code> block.</p>
         * 
         * 
         * @see org.apache.royale.textLayout.edit.IEditManager.endCompositeOperation
         * 
         * @playerversion Flash 10
         * @playerversion AIR 1.5
         * @langversion 3.0
         */
        function beginCompositeOperation():void;
        
        /** 
         * Ends a group of operations. 
         * 
         * <p>All operations executed since the last call to <code>beginCompositeOperation()</code> are 
         * grouped as a CompositeOperation that is then completed. This CompositeOperation object is added 
         * to the undo stack or, if this composite operation is nested inside another composite operation, 
         * added to the parent operation.</p>
         * 
         * @see org.apache.royale.textLayout.edit.IEditManager.beginCompositeOperation
         * 
         * @playerversion Flash 10
         * @playerversion AIR 1.5
         * @langversion 3.0
         */
        function endCompositeOperation():void;

        /** 
         * Executes a FlowOperation.  
          * 
          * <p>The <code>doOperation()</code> method is called by IEditManager functions that 
          * update the text flow. You do not typically need to call this function directly unless 
          * you create your own custom operations.</p>
          * 
          * <p>This function proceeds in the following steps:</p>
          * <ol>
          * <li>Flush any pending operations before performing this operation.</li>
          * <li>Send a cancelable flowOperationBegin event.  If canceled this method returns immediately.</li>
          * <li>Execute the operation.  The operation returns <code>true</code> or <code>false</code>.  
          * <code>False</code> indicates that no changes were made.</li>
          * <li>Push the operation onto the undo stack.</li>
          * <li>Clear the redo stack.</li>
          * <li>Update the display.</li>
          * <li>Send a cancelable flowOperationEnd event.</li>
          * </ol>
          * <p>Exception handling:  If the operation throws an exception, it is caught and the error is 
          * attached to the flowOperationEnd event.  If the event is not canceled the error is rethrown.</p>
          * 
          * @param operation a FlowOperation object
          * 

          * 
          * @playerversion Flash 10
          * @playerversion AIR 1.5
          * @langversion 3.0
          */
        function doOperation(operation:FlowOperation):void;

        /** 
         * Reverses the previous operation. 
         * 
         * <p><b>Note:</b> If the IUndoManager associated with this IEditManager is also associated with 
         * another IEditManager, then it is possible that the undo operation associated with the other 
         * IEditManager is the one undone.  This can happen if the FlowOperation of another IEditManager 
         * is on top of the undo stack.</p>  
         * 
         * <p>This function does nothing if undo is not turned on.</p>
         * 
         * 
         * @see flashx.undo.IUndoManager#undo()
         * 
         * @playerversion Flash 10
         * @playerversion AIR 1.5
         * @langversion 3.0
         */
        function undo():void;

        /** 
         * Reperforms the previous undone operation.
         * 
         * <p><b>Note:</b> If the IUndoManager associated with this IEditManager is also associated with 
         * another IEditManager, then it is possible that the redo operation associated with the other 
         * IEditManager is the one redone. This can happen if the FlowOperation of another IEditManager 
         * is on top of the redo stack.</p>  
         * 
         * <p>This function does nothing if undo is not turned on.</p>
         * 
         * 
         * @see flashx.undo.IUndoManager#redo()
         * 
         * @playerversion Flash 10
         * @playerversion AIR 1.5
         * @langversion 3.0
         */
        function redo():void;
        
        /** @private */
        function performUndo(operation:IOperation):void;

        /** @private */
        function performRedo(operation:IOperation):void;

        /**
         * By default, calls into IEditManager handle updates synchronously, so the requested change is made and the text recomposed 
         * and added to the display list within the IEditManager method. To get a delayed redraw, set <code>delayUpdates</code> to <code>true</code>. This 
         * causes the IEditManager to only update the model, and recompose and redraw on the next <code>enter_frame</code> event. 
         * 
         * @playerversion Flash 10.2
         * @playerversion AIR 2.0
         * @langversion 3.0
         */
        function get delayUpdates():Boolean;
        function set delayUpdates(value:Boolean):void;

        /** Controls whether operations can be queued up for later execution.
         * 
         * <p>Execution of some operations might be delayed as a performance optimization. For example, it is 
         * convenient to be able to combine multiple keystrokes into a single insert operation. If 
         * <code>allowDelayedOperations</code> is <code>true</code>, then operations may be queued up. If <code>false</code>, all operations are
         * executed immediately. By default, it is <code>true</code>.</p>
         * 
         * @see flashx.edit.ISelectionManager#flushPendingOperations
         * 
         * @playerversion Flash 10.2
         * @playerversion AIR 2.0
         * @langversion 3.0
         */
        function get allowDelayedOperations():Boolean;
        function set allowDelayedOperations(value:Boolean):void;
        
        /** Updates the display after an operation has modified it. Normally this is handled automatically, but call
         * this method if <code>delayUpdates</code> is on, and the display should be updated before the next <code>enter_frame</code> event. 
         * 
         * @playerversion Flash 10.2
         * @playerversion AIR 2.0
         * @langversion 3.0
         */
        function updateAllControllers():void;
    }
}
