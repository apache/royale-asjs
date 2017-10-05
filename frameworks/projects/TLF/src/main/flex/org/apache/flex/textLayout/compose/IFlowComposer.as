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
package org.apache.royale.textLayout.compose
{
	import org.apache.royale.text.engine.ITextLine;
	import org.apache.royale.textLayout.container.IContainerController;
	import org.apache.royale.textLayout.edit.ISelectionManager;
	import org.apache.royale.textLayout.elements.IBackgroundManager;
	import org.apache.royale.textLayout.elements.IContainerFormattedElement;
	import org.apache.royale.textLayout.elements.IListItemElement;
	import org.apache.royale.textLayout.elements.IParagraphElement;

	/**
	 * IFlowComposer defines the interface for managing the layout and display of a text flow.
	 * 
	 * <p>Text flows displayed with a flow composer implementation can be dynamic and interactive.
	 * A flow composer manages one or more display controller. Each controller is associated with
	 * a display object container (such as a Sprite) through which the lines created for the text
	 * flow are ultimately displayed. The following diagram illustrates the relationship between TextFlow,
	 * IFlowComposer, ContainerController, and DisplayObjectContainer objects:</p>
	 * 
	 * <p><img src="../../../images/textLayout_singleController.gif" alt="IFlowComposer"></img></p>
	 *
	 * <p>A flow composer calculates which portion of a text flow fits in each container and 
	 * adds the appropriate text lines to the container's display object. The IFlowComposer interface 
	 * defines separate methods for layout calculations and for updating the display. IFlowComposer also 
	 * defines methods for incrementally composing and updating a text flow. These methods can be used 
	 * to avoid blocking the user interface when updating long text flows.</p>
	 * 
	 * <p>In addition to managing text composition and display, a flow composer controls which container has focus, 
	 * manages the display of the selection highlight (which can cross container boundaries), and provides
	 * direct access to all the TextLine objects in the flow.</p>
	 * 
	 * <p>To use an IFlowComposer implementation, assign an instance of that implementation to the
	 * <code>flowComposer</code> property of a TextFlow object. Call the <code>updateAllControllers()</code>
	 * method to lay out and display the text in the containers attached to the flow composer.</p>
	 * 
	 * <p><b>Note:</b> For simple, static text flows, you can also use the one of the text line factory classes.
	 * These factory classes will typically create lines with less overhead than a flow composer, but do not
	 * support editing, dynamic changes, or user interaction.</p>
	 * 
	 * @see org.apache.royale.textLayout.container.ContainerController ContainerController
	 * @see FlowComposerBase
	 * @see StandardFlowComposer
	 * @see org.apache.royale.textLayout.elements.TextFlow TextFlow
	 * @see org.apache.royale.textLayout.factory.StringTextLineFactory StringTextLineFactory
	 * @see org.apache.royale.textLayout.factory.TextFlowTextLineFactory TextFlowTextLineFactory
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 */
	public interface IFlowComposer
	{
		/** 
		 * The root element associated with this IFlowComposer instance. 
		 * 
		 * <p>Only a TextFlow object can be a root element.</p>
		 *  
		 * @see org.apache.royale.textLayout.elements.IContainerFormattedElement IContainerFormattedElement
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
		 */
		function get rootElement():IContainerFormattedElement;

		function setRootElement(newRootElement:IContainerFormattedElement):void;
			
		/** 
		 * The first invalid position in the root element, as an absolute position from the start of the flow.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 */
	 	 
		function get damageAbsoluteStart():int;
		
		/** 
		 * Composes the content of the root element and updates the display.  
		 *
		 * <p>Text layout is typically conducted in two phases: composition and display. In the composition phase,
		 * the flow composer calculates how many lines are necesary to display the content as well as the position of these 
		 * lines in the flow's display containers. In the display phase, 
		 * the flow composer updates the display object children of its containers. The <code>updateAllControllers()</code>
		 * method is expected to carry out both phases. An efficient implementation will keep track of changes to content
		 * so that a full cycle of composition and display is only performed when necessary.</p>
		 * 
		 * <p>This method updates all the text lines and the display list immediately and synchronously.</p>
		 *
		 * <p>If the contents of any container is changed, the method must return <code>true</code>.</p>
		 * 
		 * @return true if anything changed.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 * 
		 */
		function updateAllControllers():Boolean;
		
		/** 
		 * Composes and updates the display up to and including the container at the specified index.
		 * 
		 * <p>The <code>updateToController()</code> method is expected to both compose the content and 
		 * update the display so that all containers up to and including the container at the specified index are current.
		 * For example, if you have a chain of twenty containers and specify an index of 10, 
		 * <code>updateToController()</code> must ensures that the first through the tenth (indexes 0-9) containers
		 * are composed and displayed. Composition can stop at that point. If <code>controllerIndex</code> 
		 * is -1 (or not specified), then all containers should be updated.</p>
		 *
		 * <p>This method updates all the text lines and the display list immediately and synchronously.</p>
		 * 
		 * <p>If the contents of any container is changed, the method must return <code>true</code>.</p>
		 * 
		 * @param controllerIndex index of the last container to update, by default will update all containers
		 * @return true if anything changed.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 *
		 */
		 
		function updateToController(index:int = 2147483647):Boolean;
		
		/** 
		 * Sets the focus to the container that contains the location specified by the <code>absolutePosition</code>
		 * parameter. 
		 *
		 * <p>It is the responsibility of the implementation to define what setting the focus means. For example, an 
		 * implementation could use the built-in <code>focus</code> property of the Stage object (as long as the
		 * containers were InteractiveObjects) or the implementation could manage the focus some other way.</p>
		 * 
		 * @param absolutePosition Specifies the position in the text flow of the container to receive focus.
		 * @param preferPrevious If true and the position is the before the first character in a container, sets focus to the end of 
		 *  the previous container.
		 * 
		 * @see flash.display.Stage#focus
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 */
	 	 
		function setFocus(absolutePosition:int,preferPrevious:Boolean=false):void;

		/** 
		 * Calculates how many lines are necessary to display the content in the root element of the flow and the positions of these 
		 * lines in the flow's display containers.
		 * 
		 * <p>Implementations of this method should not update the display, but should save the results so that subsequent
		 * calls to <code>compose()</code> or <code>updateAllControllers()</code> do not perform an additional recomposition
		 * if the flow content has not changed.</p>
		 * 
		 * <p>If the contents of any container have changed, the method must return <code>true</code>.</p>
		 * 
		 * @return true if anything changed.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 *
	 	 * @see #updateAllControllers()
	 	 * @see #updateToController()
		 */
		 
		function compose():Boolean;
		
		/** 
		 * Composes the content of the root element up to the specified position.
		 * 
		 * <p>If the contents of any container up to and including the container holding the content at the specified
		 * position has changed, the method returns <code>true</code>. If <code>absolutePosition</code> is greater than the length of the TextFlow 
		 * (or not specified), then the entire flow is composed.</p>
		 * 
		 * @param absolutePosition compose at least up to this position in the TextFlow. By default or if absolutePosition is past the end of the flow compose to the end of the flow.
		 * @return true if anything changed.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 *
	 	 * @see #updateAllControllers()
	 	 * @see #updateToController()
		 */
		 
		function composeToPosition(absolutePosition:int = 2147483647):Boolean;
		
		/** 
		 * Composes the content of the root element up to and including the container at the specified index.
		 * 
		 * <p>If the contents of any container up to and including the container at the specified
		 * index has changed, the method returns <code>true</code>. If <code>index</code> is greater than the number of controllers
		 * (or not specified), then all containers are composed.</p>
		 * 
		 * @param controllerIndex compose at least up to this container in the TextFlow. If controllerIndex is greater than the number of controllers, compose to the end of the last container.
		 * @return true if anything changed.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 *
	 	 * @see #updateAllControllers()
	 	 * @see #updateToController()
		 */
		 
		function composeToController(index:int = 2147483647):Boolean;

		/** 
		 * The number of containers assigned to this IFlowComposer instance. 
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 */
	 	 
		function get numControllers():int;
		
		/** 
		 * Adds a controller to this IFlowComposer instance.
		 *
		 * <p>The container is added to the end of the container list.</p>
		 * 
		 * @param controller The ContainerController object to add.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
		 */
		 
		function addController(controller:IContainerController):void;
		
		/** 
		 * Adds a controller to this IFlowComposer instance at the specified index.
		 *
		 * <p>The list of controllers is 0-based (the first controller has an index of 0).</p>
		 * 
		 * @param controller The ContainerController object to add.
		 * @param index A numeric index that specifies the position in the controller list at which to insert the ContainerController object.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
		 */
		 
		function addControllerAt(controller:IContainerController, index:int):void;
		
		/** 
		 * Removes a controller from this IFlowComposer instance. 
		 * 
		 * @param controller The ContainerController instance to remove.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
		 */
		function removeController(controller:IContainerController):void;

		/** 
		 * Removes the controller at the specified index from this IFlowComposer instance.
		 *
		 * @param index The index of the ContainerController object to remove.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
		 */
		 
		function removeControllerAt(index:int):void;

		/** 
		 * Removes all controllers from this IFlowComposer instance. 
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
		 */
		function removeAllControllers():void;

		/** 
		 * Returns the ContainerController object at the specified index. 
		 * 
		 * @param index The index of the ContainerController object to return.
		 * @return 	the ContainerController object at the specified position.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 */
	 	
		function getControllerAt(index:int):IContainerController;
		
		/** 
		 * Returns the index of the specified ContainerController object. 
		 * 
		 * @param controller A reference to the ContainerController object to find.
		 * @return the index of the specified ContainerController object or -1 if the controller is not attached to this flow composer.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 */
	 	
		function getControllerIndex(controller:IContainerController):int;
		
		/** 
		 * Returns the index of the controller containing the content at the specified position. 
		 * 
		 * <p>A position can be considered to be the division between two characters or other elements of a text flow. If 
		 * the value in <code>absolutePosition</code> is a position between the last character of one 
		 * container and the first character of the next, then the preceding container is returned if
		 * the <code>preferPrevious</code> parameter is set to <code>true</code> and the later container is returned if
		 * the <code>preferPrevious</code> parameter is set to <code>false</code>.</p>
		 *
		 * <p>The method must return -1 if the content at the specified position is not in any container or is outside
		 * the range of positions in the text flow.</p>
		 * 
		 * @param absolutePosition The position of the content for which the container index is sought.
		 * @param preferPrevious Specifies which container index to return when the position is between the last element in 
		 * one container and the first element in the next.
		 * 
		 * @return 	the index of the container controller or -1 if not found.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 */ 
	 	 
		function findControllerIndexAtPosition(absolutePosition:int,preferPrevious:Boolean=false):int;

		/** 
		 * Returns the sequential line number of the ITextFlowLine object that contains the content at the specified position. 
		 * 
		 * <p>The number of the first line is 0 and the number of the last line is equal to the number of lines minus one.
		 * If the position specified in <code>absolutePosition</code> is past the end of the text flow, this method must return
		 * the number that will be assigned to the next new line added to the text flow (which is equal to the number of current lines).</p>
		 *
		 * <p>A position can be considered to be the division between two characters or other elements of a text flow. If 
		 * the value in <code>absolutePosition</code> is a position between the last line of one 
		 * container and the first line of the next, then the preceding container is returned if
		 * the <code>preferPrevious</code> parameter is set to <code>true</code> and the later container is returned if
		 * the <code>preferPrevious</code> parameter is set to <code>false</code>.</p>
		 * 
		 * @param absolutePosition	The position of the content for which you want the text line.
		 * @param preferPrevious Specifies which container index to return when the position is between the last line in 
		 * one container and the first line in the next.
		 *
		 * @return the index of the text line at the specified position. If not found, treats as past the end and returns the
		 * number of lines.
		 * 	 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 */
	 	 
		function findLineIndexAtPosition(absolutePosition:int,preferPrevious:Boolean = false):int;
		
		/** 
		* Returns the ITextFlowLine object containing the content at the specified position.
		*
		* <p>A position can be considered to be the division between two characters or other elements of a text flow. If 
		* the value in <code>absolutePosition</code> is a position between the last element of one 
		* line and the first element of the next, then the preceding line is returned if
		* the <code>preferPrevious</code> parameter is set to <code>true</code> and the later line is returned if
		* the <code>preferPrevious</code> parameter is set to <code>false</code>.</p>
		* 
		* @param absolutePosition	The position of the content for which you want the ITextFlowLine object.
		* @param preferPrevious		Specifies which line to return when the position is between the last element of 
		* one line and the first element of the next.
		*
		* @return	the ITextFlowLine containing the content at the specified position, or null if not found.
		*
		* @playerversion Flash 10
		* @playerversion AIR 1.5
	 	* @langversion 3.0
	 	*/
	 	
		function findLineAtPosition(absolutePosition:int,preferPrevious:Boolean = false):ITextFlowLine;
		
		/** 
		 * Returns the line with the specified line number. 
		 *
		 * <p>The list of lines is numbered from zero to the number of lines minus one. If the value in <code>index</code>
		 * is outside the bounds of the list of lines, then this function returns <code>null</code>.</p>
		 * 
		 * @param index		The line number of the ITextFlowLine object to return.
		 * @return	the ITextFlowLine with the specified line number, or <code>null</code>, if not found.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 */
		function getLineAt(index:int):ITextFlowLine;
		
		/** 
		 * The total number of lines composed in the flow.  By default TLF does not compose the entire flow and this value may be innacruate.
		 * Use composeToPosition to get all lines composed.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 */
	 	 
		function get numLines():int;
		
		/** 
		 * Indicates whether any ITextFlowLine objects between the beginning of the flow and the line containing the content at 
		 * the specified position are marked as damaged. 
		 *
		 * @param absolutePosition the last position in the area of interest
		 * @return 	true if any of the ITextFlowLine objects from the start of the flow up to the line containing the content at
		 * <code>absolutePosition</code> are marked as damaged.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 */
	 	 
		function isDamaged(absolutePosition:int):Boolean;

		/**
		 * Indicates whether any ITextFlowLine objects between the beginning of the flow and the line containing the content at
		 * the specified position are marked as damaged OR if there are other clues that the textFlow should be rebuilt.
		 *
		 * @param absolutePosition the last position in the area of interest
		 * @return 	true if any of the ITextFlowLine objects from the start of the flow up to the line containing the content at
		 * <code>absolutePosition</code> are marked as damaged OR if there are other reasons to believe the textFlow is damaged.
		 *
         * @see org.apache.royale.textLayout.compose.IFlowComposer#isDamaged()
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 */

		function isPotentiallyDamaged(absolutePosition:int):Boolean;

		
		/** 
		 * True, if the flow composer is currently performing a composition operation.
		 *  
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
		 */
		function get composing():Boolean;
		
		/** 
		 * The ISWFContext instance to be used for calls that must be made in a specific SWF context  
		 * 
		 * <p>Implementations of IFlowComposer should allow this property to be set so that users
		 * of the interface can create lines in a different SWF context than the one containing the 
		 * implementation.  A default implementation of ISWFContext should also be supplied.</p>
		 * 
		 * @see flashx.elements.ISWFContext ISWFContext
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 */
		function get swfContext():ISWFContext;
		function set swfContext(creator:ISWFContext):void;
		
		/**
		 * Called by the TextFlow when the interaction manager changes. 
		 * 
		 * <p>Implementations of IFlowComposer should update event listeners and properties
		 * that reference the interaction manager.</p>
		 * 
		 * @param newInteractionManager The new ISelectionManager instance.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */

		function interactionManagerChanged(newInteractionManager:ISelectionManager):void;
		
		/** Update the lengths in the lines to maintain mapping to the TextFlow. 
		 * 
		 * @param startPosition beginning of change in length
		 * @param deltaLength change in number of characters.
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		function updateLengths(startPosition:int,deltaLength:int):void;
		
		/** Mark lines as damaged and needing a recompose.
		 * @param damageStart beginning of range to damage
		 * @param damageLength number of characters to damage
		 * @param damageType type of damage.  One of org.apache.royale.textLayout.compose.FlowDamageType
		 * @see org.apache.royale.textLayout.compose.FlowDamageType
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		function damage(startPosition:int, damageLength:int, damageType:String):void;
		function createBackgroundManager():IBackgroundManager;
		CONFIG::debug function debugCheckTextFlowLines(validateControllers:Boolean=true):int;
		function get lines():Array;
		function addLine(newLine:ITextFlowLine,workIndex:int):void;
		function createNumberLine(listItemElement:IListItemElement, curParaElement:IParagraphElement, swfContext:ISWFContext, totalStartIndent:Number):ITextLine;
	}

}
