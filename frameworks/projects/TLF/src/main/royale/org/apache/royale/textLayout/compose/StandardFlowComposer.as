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
	import org.apache.royale.core.IParentIUIBase;
	import org.apache.royale.textLayout.container.IContainerController;
	import org.apache.royale.textLayout.container.ScrollPolicy;
	import org.apache.royale.textLayout.debug.assert;
	import org.apache.royale.textLayout.edit.ISelectionManager;
	import org.apache.royale.textLayout.elements.BackgroundManager;
	import org.apache.royale.textLayout.elements.IBackgroundManager;
	import org.apache.royale.textLayout.elements.IContainerFormattedElement;
	import org.apache.royale.textLayout.elements.ITableCellElement;
	import org.apache.royale.textLayout.elements.ITableElement;
	import org.apache.royale.textLayout.elements.ITextFlow;
	import org.apache.royale.textLayout.events.CompositionCompleteEvent;
	import org.apache.royale.textLayout.events.ModelChange;
	import org.apache.royale.textLayout.formats.BlockProgression;
	import org.apache.royale.textLayout.utils.ComposeUtils;
    
	// import org.apache.royale.textLayout.accessibility.TextAccImpl;



	
	/** 
	* The StandardFlowComposer class provides a standard composer and container manager. 
	*
	* <p>Each call to <code>compose()</code> or <code>updateAllControllers()</code> normalizes the text flow as a first step.  
	* The normalizing process checks the parts of the TextFlow object that were modified and takes the following steps:
	* <ol>
	* <li> Deletes empty FlowLeafElement and SubParagraphGroupElement objects.</li>
	* <li> Merges sibling spans that have identical attributes.</li>
	* <li> Adds an empty paragraph if a flow is empty.</li>
 	* </ol>
 	* </p>
	*
	* <p>To use a StandardFlowComposer, assign it to the
	* <code>flowComposer</code> property of a TextFlow object. Call the <code>updateAllControllers()</code>
	* method to lay out and display the text in the containers attached to the flow composer.</p>
	* 
	* <p><b>Note:</b> For simple, static text flows, you can also use the one of the text line factory classes.
	* These factory classes will typically create lines with less overhead than a flow composer, but do not
	* support editing, dynamic changes, or user interaction.</p>
	* 
	* @see org.apache.royale.textLayout.elements.TextFlow#flowComposer
	* @playerversion Flash 10
	* @playerversion AIR 1.5
	* @langversion 3.0
	*/
	
	public class StandardFlowComposer extends FlowComposerBase implements IFlowComposer
	{
		/** @private */
		protected var _rootElement:IContainerFormattedElement;
		private var _controllerList:Array;
		private var _composing:Boolean;

		
		/** 
		* Creates a StandardFlowComposer object. 
		*
		* <p>To use an StandardFlowComposer object, assign it to the
		* <code>flowComposer</code> property of a TextFlow object. Call the <code>updateAllControllers()</code>
		* method to lay out and display the text in the containers attached to the flow composer.</p>
		* 

		* 
		* @playerversion Flash 10
		* @playerversion AIR 1.5
	 	* @langversion 3.0
	 	*/
	 	
		public function StandardFlowComposer()
		{
			super();
			_controllerList = [];
			_composing = false;
		}

		/** 
		 * True, if the flow composer is currently performing a composition operation. 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get composing():Boolean
		{ return _composing; }
		
		/** 
		 * Returns the absolute position of the first content element in the specified ContainerController object.
		 *
		 * <p>A position is calculated by counting the division between two characters or other elements of a text flow. 
		 * The position preceding the first element of a flow is zero. An absolute position is the position
		 * counting from the beginning of the flow.</p>
		 * 
		 * @param controller A ContainerController object associated with this flow composer.
		 * @return the position before the first character or graphic in the ContainerController.
		 *
		 *  
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 */
		 
		public function getAbsoluteStart(controller:IContainerController):int
		{
			// don't look at controller's relativeStart property - it uses this method.  hmmmm 
			// TODO: that does seem odd - clean the above implementation up.
			var stopIdx:int = getControllerIndex(controller);
			CONFIG::debug { assert(stopIdx != -1,"bad controller to LayoutFlowComposer.getRelativeStart"); }
			var rslt:int = _rootElement.getAbsoluteStart();
			for (var idx:int = 0; idx < stopIdx; idx++)
				rslt += _controllerList[idx].textLength;
				
			return rslt;
		}
		
		/** @copy IFlowComposer#rootElement
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
		 */
		
		public function get rootElement():IContainerFormattedElement
		{ return _rootElement; }
		
		
		/** @copy IFlowComposer#setRootElement()
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 * @royaleignorecoercion org.apache.royale.textLayout.elements.ITextFlow
		 */
		public function setRootElement(newRootElement:IContainerFormattedElement):void
		{

			if (_rootElement != newRootElement)
			{
				if (newRootElement is ITextFlow && (newRootElement as ITextFlow).flowComposer != this)
					(newRootElement as ITextFlow).flowComposer = this;
				else
				{
					clearCompositionResults();

					detachAllContainers();
					_rootElement = newRootElement;
					_textFlow = _rootElement ? _rootElement.getTextFlow() :  null;
					attachAllContainers();
				}
			}
		}
		
		/** @private */
		public function detachAllContainers():void
		{
			
			// detatch accessibility from the containers
			// Why only the first container?
			// No accessibility yet...
			// if (_controllerList.length > 0 && _textFlow)
			// {
			// 	var firstContainerController:ContainerController = getControllerAt(0);
			// 	var firstContainer:Sprite = firstContainerController.container;
			// 	if (firstContainer)
			// 		clearContainerAccessibilityImplementation(firstContainer);
		  	// }
		  	
		  	var cont:IContainerController;
			for each (cont in _controllerList)
			{
				cont.dispose();
			}
		}
		
		// static private function clearContainerAccessibilityImplementation(cont:Sprite):void
		// {
		// 	if (cont.accessibilityImplementation)
		// 	{
		// 		if (cont.accessibilityImplementation is TextAccImpl)
		// 			TextAccImpl(cont.accessibilityImplementation).detachListeners();
		// 		cont.accessibilityImplementation = null;
		// 	}
		// }
		
		/** @private */
		public function attachAllContainers():void
		{
			var cont:IContainerController;
			for each (cont in _controllerList)
				cont.setRootElement(_rootElement);
			

			if (_controllerList.length > 0 && _textFlow)
			{
				// attach accessibility to the containers
				// Why only the first container?  There are workflows that this will fail
				// for example: a pagination workflow that has a composed chain of containers but only displays one at a time.
				//TODO No accessibility yet...
				// if (textFlow.configuration.enableAccessibility && Capabilities.hasAccessibility)
				// {
				// 	var firstContainer:Sprite = getControllerAt(0).container;
				// 	if (firstContainer)
				// 	{
				// 		clearContainerAccessibilityImplementation(firstContainer);
				// 		firstContainer.accessibilityImplementation = new TextAccImpl(firstContainer, _textFlow);
				// 	}
				// }
				
				var curContainer:IParentIUIBase;
				// turn off focusRect on all containers
				for (var i:int = 0; i < _controllerList.length; ++i)
				{
					curContainer = getControllerAt(i).container;
//TODO
//					if (curContainer)
//						curContainer.focusRect = false;
				} 
		  	}

			// TODO: can be more efficient? - just damage all
			clearCompositionResults();				
		}
		
		/** @copy IFlowComposer#numControllers
		*
		* @playerversion Flash 10
		* @playerversion AIR 1.5
	 	* @langversion 3.0
		*/
		
		public function get numControllers():int
		{ return _controllerList ? _controllerList.length : 0; }
		
		/** @copy IFlowComposer#addController()
		 *
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
		 */
		 
		public function addController(controller:IContainerController):void
		{
			CONFIG::debug { assert (_controllerList.indexOf(controller) < 0, "adding controller twice"); }
			_controllerList.push(IContainerController(controller));
			if (this.numControllers == 1)
			{				
				attachAllContainers();
			}
			else
			{
				controller.setRootElement(_rootElement);
//TODO
//				var curContainer:IParentIUIBase = controller.container;
//				if (curContainer)
//					curContainer.focusRect = false;
				if (textFlow)
				{
					// mark the previous container as geometry damaged - this is more than is needed
					controller = this.getControllerAt(this.numControllers-2);
					var damageStart:int = controller.absoluteStart;
					var damageLen:int = controller.textLength;
					// watch out for an empty previous container
					if (damageLen == 0)
					{
						if (damageStart != textFlow.textLength)
							damageLen++;
						else if (damageStart != 0)
						{
							damageStart--;
							damageLen++;
						}
					}
					if (damageLen)
						textFlow.damage(damageStart,damageLen,FlowDamageType.GEOMETRY,false);
				}
			}
		}
		/** @copy IFlowComposer#addControllerAt()
		 *
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
		 */
		 
		public function addControllerAt(controller:IContainerController, index:int):void
		{
			CONFIG::debug { assert (_controllerList.indexOf(controller) == -1, "adding controller twice"); }
			detachAllContainers();
			_controllerList.splice(index,0,IContainerController(controller));
			attachAllContainers();
		}
		
		/** Removes a trailing controller with no content without doing any damage */
		private function fastRemoveController(index:int):Boolean
		{
			if (index == -1)
				return true;
			var cont:IContainerController = _controllerList[index];
			if (!cont)
				return true;
			if (!_textFlow || cont.absoluteStart == _textFlow.textLength)
			{
//TODO Accessibility
//				if (index == 0)
//				{
//					var firstContainer:IParentIUIBase = cont.container;
//					if (firstContainer)
//						clearContainerAccessibilityImplementation(firstContainer);				
//				}
				cont.setRootElement(null);
				_controllerList.splice(index,1);
				return true;
			} 	
			return false;
		}
		
		/** @copy IFlowComposer#removeController()
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
		 */
		 
		public function removeController(controller:IContainerController):void
		{ 
			var index:int = getControllerIndex(controller);
			if (!fastRemoveController(index))
			{
				detachAllContainers();
				_controllerList.splice(index,1);
				attachAllContainers();
			}
		}
		/** @copy IFlowComposer#removeControllerAt()
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 */
		 
		public function removeControllerAt(index:int):void
		{ 
			if (!fastRemoveController(index))
			{
				detachAllContainers();
				_controllerList.splice(index,1);
				attachAllContainers();
			}
		}
		/** @copy IFlowComposer#removeAllControllers()
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
		 */
		 
		public function removeAllControllers():void
		{
			detachAllContainers();
			_controllerList.splice(0,_controllerList.length);
		}
		
		/** @copy IFlowComposer#getControllerAt()  
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 */
		
		public function getControllerAt(index:int):IContainerController
		{
			return _controllerList[index];
		}
		
		/** @copy IFlowComposer#getControllerIndex()  
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 */
	 	 
		public function getControllerIndex(controller:IContainerController):int
		{
			// TODO: binary search? 
			for (var idx:int = 0; idx < _controllerList.length; idx++)
			{
				if (_controllerList[idx] == controller)
					return idx;
			}
			return -1; 
		}
		
		/** 
		 * Returns the index of the controller containing the content at the specified position. 
		 * 
		 * <p>A position can be considered to be the division between two characters or other elements of a text flow. If 
		 * the value in <code>absolutePosition</code> is a position between the last character of one 
		 * container and the first character of the next, then the preceding container is returned if
		 * the <code>preferPrevious</code> parameter is set to <code>true</code> and the later container is returned if
		 * the <code>preferPrevious</code> parameter is set to <code>false</code>.</p>
		 *
		 * <p>The method returns -1 if the content at the specified position is not in any container or is outside
		 * the range of positions in the text flow.</p>
		 * 
		 * @param absolutePosition The position of the content for which the container index is sought.
		 * @param preferPrevious Specifies which container index to return when the position is between the last element in 
		 * one container and the first element in the next.
		 * 
		 * @return 	the index of the container controller or -1 if not found.
		 *
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
		 */
		
		public function findControllerIndexAtPosition(absolutePosition:int,preferPrevious:Boolean=false):int
		{
			
			var lo:int = 0;
			var hi:int = _controllerList.length-1;
			while (lo <= hi)
			{
				var mid:int = Math.floor((lo+hi)/2);
				var cont:IContainerController = _controllerList[mid];
				if (cont.absoluteStart <= absolutePosition)
				{
					if (preferPrevious)
					{
						if (cont.absoluteStart + cont.textLength >= absolutePosition)
						{
							// find first container or first one with non-zero textLength
							while (mid != 0 && cont.absoluteStart == absolutePosition)
							{
								mid--;
								cont = _controllerList[mid];
							}
							return mid;
						}
					}
					else
					{

						if (cont.absoluteStart == absolutePosition && cont.textLength != 0)
						{
							while (mid != 0)
							{
								cont = _controllerList[mid-1];
								if (cont.textLength != 0)
									break;
								mid--;
							}
							return mid;
						}
						if (cont.absoluteStart + cont.textLength > absolutePosition)
							return mid;
					}
					lo = mid+1;
				}
				else
					hi = mid-1;
			}
			return -1;
		}

		/** Clear whatever computed values are left from the last composition, in the flow composer and
		 * in each of its controllers. @private
		 */
		 
		public function clearCompositionResults():void
		{
			initializeLines();
			for each (var cont:IContainerController in _controllerList)
				cont.clearCompositionResults();
		}

		/** 
		 * Composes the content of the root element and updates the display.  
		 *
		 * <p>Text layout is conducted in two phases: composition and display. In the composition phase,
		 * the flow composer calculates how many lines are necessary to display the content as well as the position of these 
		 * lines in the flow's display containers. In the display phase, 
		 * the flow composer updates the display object children of its containers. The <code>updateAllControllers()</code>
		 * method initiates both phases in sequence. The StandardFlowComposer keeps track of changes to content
		 * so that a full cycle of composition and display is only performed when necessary.</p>
		 * 
		 * <p>This method updates all the text lines and the display list immediately and synchronously.</p>
		 *
		 * <p>If the contents of any container is changed, the method returns <code>true</code>.</p>
		 * 
		 * @return true if anything changed.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 * 
		 */
		 
		public function updateAllControllers():Boolean
		{
			return updateToController();
		}
		
		/** 
		 * Composes and updates the display up to and including the container at the specified index.
		 * 
		 * <p>The <code>updateToController()</code> method composes the content and 
		 * updates the display of all containers up to and including the container at the specified index.
		 * For example, if you have a chain of 20 containers and specify an index of 10, 
		 * <code>updateToController()</code> ensures that the first through the tenth (indexes 0-9) 
		 * containers are composed and displayed. Composition stops at that point. If <code>controllerIndex</code> 
		 * is -1 (or not specified), then all containers are updated.</p>
		 *
		 * <p>This method updates all the text lines and the display list immediately and synchronously.</p>
		 * 
		 * <p>If the contents of any container is changed, the method returns <code>true</code>.</p>
		 * 
		 * @param index index of the last container to update (by default updates all containers)
		 * @return <code>true</code>, if anything changed.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 * @royaleignorecoercion org.apache.royale.textLayout.elements.ITableCellElement
	 	 *
		 */
		 
		public function updateToController(index:int = 2147483647):Boolean
		{
			//CONFIG::debug { assert(!_composing,"updateToController: compose in process"); }
			if (_composing)
				return false;
			
			var cellHeight:Number = 0;
			if(textFlow.nestedInTable())
			{
				var controller:IContainerController = getControllerAt(0);
				if (controller)
					cellHeight = controller.container.height;

			}
			//note that this will always update the display AND update the
			//selection.  So, even if nothing has changed that would cause
			//a recompose, the selection would still be redrawn.
			var sm:ISelectionManager = textFlow.interactionManager;
			if (sm)
				sm.flushPendingOperations();
			CONFIG::debug { assert(!_composing, "Didn't expect to be composing here"); }
			internalCompose(-1, index);	
			var shapesDamaged:Boolean = areShapesDamaged();
			if (shapesDamaged)
				updateCompositionShapes();

			// recompose the containing table if the cell height changed.
			// This should be ok because updateAllControllers() should be ignored if the parent textFlow is in middle of a compose.
			if(cellHeight && controller.container.height != cellHeight)
			{
				var table:ITableElement = (textFlow.parentElement as ITableCellElement).table;
				table.modelChanged(ModelChange.ELEMENT_MODIFIED, table, 0, table.textLength);
				table.getTextFlow().flowComposer.updateAllControllers();
				if(sm && sm.focused)
					controller.setFocus();
			}

			if (sm)
				sm.refreshSelection();
			return shapesDamaged;
		}
		
		/** 
		 * Sets the focus to the container that contains the location specified by the <code>absolutePosition</code>
		 * parameter. 
		 *
		 * <p>The StandardFlowComposer calls the <code>setFocus()</code> method of the ContainerController object
		 * containing the specified text flow position.</p>
		 * 
		 * @param absolutePosition Specifies the position in the text flow of the container to receive focus.
		 * @param leanLeft If true and the position is before the first character in a container, sets focus to the end of
		 *  the previous container.
		 * 
		 * @see flash.display.Stage#focus
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 */
	 	 
		public function setFocus(absolutePosition:int,leanLeft:Boolean=false):void
		{
			var idx:int = findControllerIndexAtPosition(absolutePosition,leanLeft);
			if (idx == -1)
				idx = this.numControllers-1;
			if (idx != -1)
				_controllerList[idx].setFocus();
		}
		
		/**
		 * Called by the TextFlow when the interaction manager changes. 
		 * 
		 * <p>This function is called automatically. Your code does not typically need to call this
		 * method. Classes that extend StandardFlowComposer can override this method to update
		 * event listeners and other properties that depend on the interaction manager.</p>
		 * 
		 * @param newInteractionManager The new ISelectionManager instance.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public	function interactionManagerChanged(newInteractionManager:ISelectionManager):void
		{
			for each (var controller:IContainerController in _controllerList)
				controller.interactionManagerChanged(newInteractionManager);
		}

		
		private function updateCompositionShapes():void
		{
			for each (var controller:IContainerController in _controllerList)
				controller.updateCompositionShapes(); 
		}
		
		//--------------------------------------------------------------------------
		//
		//  Composition
		//
		//--------------------------------------------------------------------------
		
		/** @private Override required because we may be damaged if the last container has scrolling */
		public override function isPotentiallyDamaged(absolutePosition:int):Boolean
		{
			// Returns true if any text from _damageAbsoluteStart through absolutePosition needs to be recomposed
			if (!super.isPotentiallyDamaged(absolutePosition))
			{	
				if (absolutePosition == _textFlow.textLength)
				{
					var container:IContainerController = getControllerAt(numControllers-1);
					if (container && (container.verticalScrollPolicy != ScrollPolicy.OFF || container.horizontalScrollPolicy != ScrollPolicy.OFF))
						return true;
				}
				return false;
			}
				
			return true;
		}

		/** Returns true if composition is necessary, false otherwise */
		protected function preCompose():Boolean
		{
			CONFIG::debug { checkFirstDamaged(); }
			rootElement.preCompose();
			
			// No content, nothing to compose - TextFlow isn't loaded  or connected
			CONFIG::debug { assert(rootElement.textLength != 0,"bad TextFlow after normalize"); }
			
			// brand new content
			if (numLines == 0)
				initializeLines();
				
			return isDamaged(rootElement.getAbsoluteStart() + rootElement.textLength);
		}
		
		/** @private */
		public function getComposeState():IComposer
		{ return ComposeUtils.getComposeState(); }
		
		/** @private */
		public function releaseComposeState(state:IComposer):void
		{ ComposeUtils.releaseComposeState(state); }
		
		/** @private Return the first damaged controller */
		public function callTheComposer(composeToPosition:int, controllerEndIndex:int):IContainerController
		{
			
			if (_damageAbsoluteStart == rootElement.getAbsoluteStart()+rootElement.textLength)
				return getControllerAt(numControllers-1);
				
			var state:IComposer = getComposeState();
			
			var lastComposedPosition:int = state.composeTextFlow(textFlow, composeToPosition, controllerEndIndex);
			if (_damageAbsoluteStart < lastComposedPosition)
				_damageAbsoluteStart = lastComposedPosition;
			CONFIG::debug { checkFirstDamaged(); }
			
			// make sure there is an empty TextFlowLine covering any trailing content
			finalizeLinesAfterCompose();
			var startController:IContainerController = state.startController;
			
			releaseComposeState(state);
			
			if (textFlow.hasEventListener(CompositionCompleteEvent.COMPOSITION_COMPLETE))
				textFlow.dispatchEvent(new CompositionCompleteEvent(CompositionCompleteEvent.COMPOSITION_COMPLETE,false,false,textFlow, 0,lastComposedPosition));

			CONFIG::debug { textFlow.debugCheckTextFlow(); }
			return startController;
		}
		
		private var lastBPDirectionScrollPosition:Number = Number.NEGATIVE_INFINITY;
		
		static private function getBPDirectionScrollPosition(bp:String,cont:IContainerController):Number
		{
			return bp == BlockProgression.TB ? cont.verticalScrollPosition : cont.horizontalScrollPosition;
		}
		
		/** Bottleneck function for all types of compose. Does the work of compose, no matter how it is called. @private 
		 * @return first controller with changed shapes
		 */
		private function internalCompose(composeToPosition:int = -1, composeToControllerIndex:int = -1):IContainerController
		{
			var bp:String;

				// Flush pending events (e.g. insert events)
			var sm:ISelectionManager = textFlow.interactionManager;
			if (sm)
				sm.flushPendingOperations();
			
			CONFIG::debug { assert(_composing == false,"internalCompose: Recursive call"); }
				
			_composing = true;

			var startController:IContainerController;
			try
			{	
				if (preCompose())
				{
					if (textFlow && numControllers != 0)
					{
						// This code should really be in preCompose, but we cannot add new parameters to it without breaking the API.
						var damageLimit:int = _textFlow.textLength;		// If we aren't composed up to this point, we'll have to force composition
						// If the container index is above the range, set it to the last container
						composeToControllerIndex = Math.min(composeToControllerIndex,numControllers-1);
						if (composeToPosition != -1 || composeToControllerIndex != -1)
						{
							if (composeToControllerIndex < 0)
							{
								if (composeToPosition >= 0)
									damageLimit = composeToPosition;
							}
							else 
							{
								// We're composing the container, make sure the entire container is composed
								var controller:IContainerController = getControllerAt(composeToControllerIndex);
								if (controller.textLength != 0)
									damageLimit = controller.absoluteStart+controller.textLength;
	
								// If we're composing the last container, and its scrollable, only require valid composition to the end of the scrolled position
								if (composeToControllerIndex == numControllers - 1)
								{
									bp = rootElement.computedFormat.blockProgression;
	
										// skip it if damageAbsoluteStart is past the end of the controller.  are there risks here? AND scrollpositions haven't changed since last composeToControllerIndex
									var lastVisibleLine:ITextFlowLine = controller.getLastVisibleLine();
									if (lastVisibleLine && getBPDirectionScrollPosition(bp,controller) == this.lastBPDirectionScrollPosition)
										damageLimit = lastVisibleLine.absoluteStart+lastVisibleLine.textLength;
								}
	
							}
						}
						
						lastBPDirectionScrollPosition = Number.NEGATIVE_INFINITY;
				
						if (_damageAbsoluteStart < damageLimit)
						{
							startController = callTheComposer(composeToPosition, composeToControllerIndex);
							if (startController)
							{
								var idx:int = this.getControllerIndex(startController);
								while (idx < numControllers)
									getControllerAt(idx++).shapesInvalid = true;
							}
						}
					}
				}
			}
			catch (e:Error)
			{
				_composing = false;
				throw(e);
			}
			_composing = false;
			
			if (controller && composeToControllerIndex == numControllers - 1)
			{
				lastBPDirectionScrollPosition = getBPDirectionScrollPosition(bp,controller);
			}
			
			return startController;
		}
		
		
		/** @private */
		public function areShapesDamaged():Boolean
		{
			var cont:IContainerController;	// scratch
			// TODO: a flag on this?
			for each (cont in _controllerList)
			{
				if (cont.shapesInvalid)
					return true;
			}
			return false;
		}
		
		/** 
		 * Calculates how many lines are necessary to display the content in the root element of the flow and the positions of these 
		 * lines in the flow's display containers.
		 * 
		 * <p>The <code>compose()</code> method only composes content if it has changed since the last composition operation. 
		 * Results are saved so that subsequent
		 * calls to <code>compose()</code> or <code>updateAllControllers()</code> do not perform an additional recomposition
		 * if the flow content has not changed.</p>
		 * 
		 * <p>If the contents of any container have changed, the method returns <code>true</code>.</p>
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
		public function compose():Boolean
		{
			//CONFIG::debug { assert(!_composing,"compose: compose in process"); }
			return _composing ? false : internalCompose() != null;
		}
		
		/** @copy IFlowComposer#composeToPosition()
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
		 */
		public function composeToPosition(absolutePosition:int = 2147483647):Boolean
		{
			//CONFIG::debug { assert(!_composing,"composeToPosition: compose in process"); }
			return _composing ? false : internalCompose(absolutePosition, -1) != null;
		}
		
		/** @copy IFlowComposer#composeToController()
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
		 */
		public function composeToController(index:int = 2147483647):Boolean
		{
			//CONFIG::debug { assert(!_composing,"composeToController: compose in process"); }
			return _composing ? false : internalCompose(-1, index) != null;
		}
		
		/** @private */
		override public function createBackgroundManager():IBackgroundManager
		{ return new BackgroundManager(); }
	}
}
