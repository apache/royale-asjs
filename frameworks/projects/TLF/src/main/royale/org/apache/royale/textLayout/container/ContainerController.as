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
package org.apache.royale.textLayout.container 
{
	import org.apache.royale.core.IChild;
	import org.apache.royale.core.IParentIUIBase;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.KeyboardEvent;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.geom.Matrix;
	import org.apache.royale.geom.Point;
	import org.apache.royale.geom.Rectangle;
	import org.apache.royale.graphics.ICompoundGraphic;
	import org.apache.royale.graphics.IRect;
	import org.apache.royale.graphics.SolidColor;
	import org.apache.royale.text.engine.ITextBlock;
	import org.apache.royale.text.engine.ITextLine;
	import org.apache.royale.text.events.IMEEvent;
	import org.apache.royale.text.events.TextEvent;
	import org.apache.royale.textLayout.compose.FloatCompositionData;
	import org.apache.royale.textLayout.compose.FlowDamageType;
	import org.apache.royale.textLayout.compose.IFlowComposer;
	import org.apache.royale.textLayout.compose.ITextFlowLine;
	import org.apache.royale.textLayout.compose.ITextFlowTableBlock;
	import org.apache.royale.textLayout.compose.TextLineRecycler;
	import org.apache.royale.textLayout.debug.Debugging;
	import org.apache.royale.textLayout.debug.assert;
	import org.apache.royale.textLayout.dummy.BoundsUtil;
	import org.apache.royale.textLayout.dummy.ContextMenu;
	import org.apache.royale.textLayout.edit.EditingMode;
	import org.apache.royale.textLayout.edit.IInteractionEventHandler;
	import org.apache.royale.textLayout.edit.ISelectionManager;
	import org.apache.royale.textLayout.edit.SelectionFormat;
	import org.apache.royale.textLayout.elements.CellCoordinates;
	import org.apache.royale.textLayout.elements.GlobalSettings;
	import org.apache.royale.textLayout.elements.IBackgroundManager;
	import org.apache.royale.textLayout.elements.IContainerFormattedElement;
	import org.apache.royale.textLayout.elements.IFlowLeafElement;
	import org.apache.royale.textLayout.elements.IInlineGraphicElement;
	import org.apache.royale.textLayout.elements.IParagraphElement;
	import org.apache.royale.textLayout.elements.ITableCellElement;
	import org.apache.royale.textLayout.elements.ITableRowElement;
	import org.apache.royale.textLayout.elements.ITextFlow;
	import org.apache.royale.textLayout.elements.TableBlockContainer;
	import org.apache.royale.textLayout.events.ActivateEvent;
	import org.apache.royale.textLayout.events.ContextMenuEvent;
	import org.apache.royale.textLayout.events.EditEvent;
	import org.apache.royale.textLayout.events.FlowElementMouseEventManager;
	import org.apache.royale.textLayout.events.FocusEvent;
	import org.apache.royale.textLayout.events.ModelChange;
	import org.apache.royale.textLayout.events.ScrollEvent;
	import org.apache.royale.textLayout.events.ScrollEventDirection;
	import org.apache.royale.textLayout.events.SelectionEvent;
	import org.apache.royale.textLayout.events.TextLayoutEvent;
	import org.apache.royale.textLayout.events.UpdateCompleteEvent;
	import org.apache.royale.textLayout.formats.BlockProgression;
	import org.apache.royale.textLayout.formats.Float;
	import org.apache.royale.textLayout.formats.FormatValue;
	import org.apache.royale.textLayout.formats.ITextLayoutFormat;
	import org.apache.royale.textLayout.formats.TextLayoutFormat;
	import org.apache.royale.textLayout.formats.TextLayoutFormatBase;
	import org.apache.royale.textLayout.utils.CreateTLFUtil;
	import org.apache.royale.textLayout.utils.Twips;
	import org.apache.royale.utils.DisplayUtils;
	import org.apache.royale.utils.ObjectMap;
	import org.apache.royale.utils.PointUtils;
	import org.apache.royale.utils.Timer;
	import org.apache.royale.graphics.IDrawable;



	/**
	 * The ContainerController class defines the relationship between a TextFlow object and a container.
	 * A TextFlow may have one or more rectangular areas that can hold text; the text is said to be flowing
	 * through the containers. Each container is a Sprite that is the parent DisplayObject for the TextLines.
	 * Each container has a ContainerController that manages the container; the controller holds the target 
	 * width and height for the text area, populates the container with TextLines, and handles scrolling. A
	 * controller also has a format associated with it that allows some formatting attributes to be applied 
	 * to the text in the container. This allows, for instance, a TextFlow to have one container where the
	 * text appears in a single column, and a second container in the same TextFlow with two column text. Not
	 * all formatting attributes that can be applied to the container will affect the text; only the ones that
	 * affect container-level layout. The diagram below illustrates the relationship between the TextFlow,
	 * its flowComposer, and the display list.
	 *
	 * <p><img src="../../../images/textLayout_multiController.gif" alt="IContainerController"></img></p>
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 *
	 * @see org.apache.royale.textLayout.compose.IFlowComposer
	 * @see org.apache.royale.textLayout.elements.TextFlow
	 * @see org.apache.royale.text.engine.ITextLine
	 */
	public class ContainerController extends TextLayoutFormatBase implements IInteractionEventHandler, ISandboxSupport, IContainerController
	{		
		
		private var _textFlowCache:ITextFlow;
		private var _rootElement:IContainerFormattedElement;
		
		private var _absoluteStart:int;
		private var _textLength:int;
		
		private var _container:IParentIUIBase;
		private var _mouseEventManager:FlowElementMouseEventManager;
        private var buttonDown:Boolean;
		
		// note must be protected - subclass sets or gets this variable but can't be public
		/** computed container attributes.  @private */
		protected var _computedFormat:TextLayoutFormat;
		
		// Generated column information
		// Generated column information
		private var _columnState:ColumnState;
		
		/** Container size to be composed */
		private var _compositionWidth:Number = 0;
		private var _compositionHeight:Number = 0;
		private var _measureWidth:Boolean; // true if we're measuring (isNaN(compositionWidth) optimization so we don't call isNaN too much
		private var _measureHeight:Boolean; // true if we're measuring (isNaN(compositionHeight) optimization so we don't call isNaN too much
		
		/* Text bounds after composition */
		private var _contentLeft:Number;
		private var _contentTop:Number;
		private var _contentWidth:Number;
		private var _contentHeight:Number;
		
		private var _uncomposedTextLength:int;	// 0 if composition was complete when contentHeight, etc registered, greater than one otherwise
		private var _finalParcelStart:int;
		
		// Scroll policy -- determines whether scrolling is enabled or not
		private var _horizontalScrollPolicy:String;
		private var _verticalScrollPolicy:String;
		
		// x, y location of the text in the container relative to the underlying scrollable area
		private var _xScroll:Number;
		private var _yScroll:Number;
		
		/** Are event listeners attached to the container */
		private var _minListenersAttached:Boolean = false;
		private var _allListenersAttached:Boolean = false;
		private var _selectListenersAttached:Boolean = false;
		public var _mouseWheelListenerAttached:Boolean = false;
		
		/** @private */
		public function get allListenersAttached():Boolean
		{ return _allListenersAttached; }
		
		/** Are the displayed shapes out of date? */
		private var _shapesInvalid:Boolean = false;
		
		private var _backgroundShape:IUIBase;
		
		private var _scrollTimer:Timer = null;
		
		/**
		 * @private use this boolean to determine if container.scrollRect is set.  Accessing scrollRect when null changes the rendering behavior of flash player.	
		 */
		protected var _hasScrollRect:Boolean;
		
		private var _linesInView:Array;	// lines that were in view according to the previous compose(). Empty if the lines have already been posted to the display list.
		private var _updateStart:int;
		private var _tableBlocksInView:Array; // // table blocks that were in view according to the previous compose(). Empty if the lines have already been posted to the display list.
		
		private var _composedFloats:Array;  // floats that were composed into the controller -- array of FloatCompositionData
		private var _floatsInContainer:Array;  // floats are currently in view -- array of DisplayObject
		
		/** Interactive Objects **/
		private var _interactiveObjects:ObjectMap = new ObjectMap(true);
		private var _oldInteractiveObjects:Array = new Array();
		
		public function get interactiveObjects():ObjectMap
		{
			return _interactiveObjects ;
		}
		
		public function get oldInteractiveObjects():Array
		{
			return _oldInteractiveObjects ;
		}
		
		/** 
		 * @private
		 * 
		 * <p>This property enables a client to test for a ScrollRect object without accessing 
		 * the DisplayObject.scrollRect property, which can have side effects in some cases.</p> 
		 *
		 * @return true if the controller has attached a ScrollRect instance.
		 */
		public function get hasScrollRect():Boolean
		{ return _hasScrollRect; }
		
		CONFIG::debug
		{
			protected var id:String;
			private static var contCount:int = 0;
		}
		
		private var _shapeChildren:Array;
				
		private var _containerRoot:IEventDispatcher;
		
		/* Controller have a non-zero default width and height so that if you construct a text example with a container and don't
		* specify width and height you will still see some text so that you can then have a clue what to do to correct its appearance.
		*/
		
		/** 
		 * Constructor - creates a ContainerController instance. The ContainerController has a default <code>compositionWidth</code>
		 * and <code>compositionHeight</code> so that some text appears in the container if you don't specify its width
		 * height.
		 *
		 * @param container The DisplayObjectContainer in which to manage the text lines.
		 * @param compositionWidth The initial width for composing text in the container.
		 * @param compositionHeight The initial height for composing text in the container.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		
		public function ContainerController(container:IParentIUIBase,compositionWidth:Number=100,compositionHeight:Number=100)
		{
			initialize(container,compositionWidth,compositionHeight);
		}
		
		private function initialize(container:IParentIUIBase,compositionWidth:Number,compositionHeight:Number):void
		{
			_container = container;
			_containerRoot =  null;
			
			_textLength = 0;
			_absoluteStart = -1;
			
			_columnState = new ColumnState(null/*blockProgression*/, null/*columnDirection*/, null/*controller*/, 0/*compositionWidth*/, 0/*compositionHeight*/);
			//_visibleRect = new Rectangle();
			_xScroll = _yScroll = 0;
			_contentWidth = _contentHeight = 0;
			_uncomposedTextLength = 0;
			
			// We have to set the flag so that we will get double click events. This
			// is a change to the container we are given, but a minor one.

//TODO doubleClickEnabled
//			_container.doubleClickEnabled = true;
			
			_horizontalScrollPolicy = _verticalScrollPolicy = String(ScrollPolicy.scrollPolicyPropertyDefinition.defaultValue);
			_hasScrollRect = false;
			
			CONFIG::debug { id = contCount.toString(); ++contCount; }
			
			_shapeChildren = [ ];
			_linesInView = [ ];
			_tableBlocksInView = [];
			
			setCompositionSize(compositionWidth, compositionHeight);
			format = containerControllerInitialFormat;
		}
		
		/** @private */
		public function get effectiveBlockProgression():String
		{
			return _rootElement ? _rootElement.computedFormat.blockProgression : BlockProgression.TB;
		}

		/** @private  Determine containerRoot in case the stage is not accessible. Normally the root is the stage. */
		public function getContainerRoot():IEventDispatcher
		{
			// safe to test for stage existence
			if (_containerRoot == null && _container) // && _container.stage)
			{
                _containerRoot = _container.topMostEventDispatcher;				
			}
			return _containerRoot;
		}
		
		/** 
		 * Returns the flow composer object that composes and highlights text into the container that this 
		 * controller manages. 
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * 
		 * @see org.apache.royale.textLayout.compose.IFlowComposer
		 */
		
		public function get flowComposer():IFlowComposer
		{ return textFlow ? textFlow.flowComposer : null; }
		
		/** @private */
		public function get shapesInvalid():Boolean
		{ return _shapesInvalid; }
		/** @private */
		public function set shapesInvalid(val:Boolean):void
		{ _shapesInvalid = val;	}
		
		/** 
		 * Returns a ColumnState object, which describes the number and characteristics of columns in
		 * the container. These values are updated when the text is recomposed, either as a result
		 * of <code>IFlowComposer.compose()</code> or <code>IFlowComposer.updateAllControllers()</code>.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 * @see ColumnState
		 */
		
		public function get columnState():ColumnState
		{
			if (_rootElement == null)
				return null;
			
			if (_computedFormat == null)
				calculateComputedFormat();
			
			_columnState.computeColumns();
			
			return _columnState; 
		}
		
		/** 
		 * Returns the container display object that holds the text lines for this ContainerController instance. 
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 * @see #ContainerController()
		 */
		
		public function get container():IParentIUIBase
		{ return _container; }
		
		/** 
		 * Returns the horizontal extent allowed for text inside the container. The value is specified in pixels.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 * @see #setCompositionSize()
		 */
		
		public function get compositionWidth():Number
		{ return _compositionWidth; }
		
		/** 
		 * Returns the vertical extent allowed for text inside the container. The value is specified in pixels.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 * @see #setCompositionSize()
		 */
		
		public function get compositionHeight():Number
		{ return _compositionHeight; }
		
		/** @private */
		public function get measureWidth():Boolean
		{ return _measureWidth; }
		
		/** @private */
		public function get measureHeight():Boolean
		{ return _measureHeight; }
		
		/** 
		 * Sets the width and height allowed for text in the container. Width and height can be specified in pixels or <code>NaN</code> can be used for either value.  <code>NaN</code> indicates measure that value. 
		 * This can be used to find the widest line and/or the total height of all the content.  When NaN is specified as the width lines are broken with a maximum width of <code>ITextLine.MAX_LINE_WIDTH</code>. 
		 * When <code>NaN</code> is specified as the height the container is assumed to have unlimited height.  The actual measured values can be read back in <code>getContentBounds</code>.  
		 * When the computed <code>blockProgression</code> property of <code>TextFlow</code>
		 * is <code>BlockProgression.RL</code> the meanings of width and height are exchanged.
		 *
		 * @param w The width in pixels that's available for text in the container.  <code>NaN</code> indicates no specified width.  
		 * @param h The height in pixels that's available for text in the container.   <code>NaN</code> indicates no specified height.  
		 *
		 * 
		 * @see org.apache.royale.text.engine.ITextLine#MAX_LINE_WIDTH
		 * @see org.apache.royale.textLayout.formats.BlockProgression
		 * @see #getContentBounds()
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		
		public function setCompositionSize(w:Number, h:Number):void
		{
		//	trace("setCompositionSize(" + w + ", " + h + ")");
			
			// note: NaN == NaN is always false
			var widthChanged:Boolean  =  !(_compositionWidth == w || (isNaN(_compositionWidth) && isNaN(w)));
			var heightChanged:Boolean =  !(_compositionHeight == h || (isNaN(_compositionHeight) && isNaN(h)));
			
			if (widthChanged || heightChanged)
			{
				_compositionHeight = h;
				_measureHeight = isNaN(_compositionHeight);
				_compositionWidth = w;
				_measureWidth = isNaN(_compositionWidth);
				// otherwise the reset will happen when the cascade is done
				if (_computedFormat)
					resetColumnState();
				// Invalidate all the lines, forcing FTE rebuild if they changed in the logical width direction
				if (effectiveBlockProgression == BlockProgression.TB ? widthChanged : heightChanged)
				{
					if (textFlow && _textLength)
						textFlow.damage(absoluteStart, _textLength, "invalid", false);
				}
				else
					invalidateContents();		 // don't need to rebuild FTE lines, just reflow them
				attachTransparentBackgroundForHit(false);
			}
		}
		
		/** 
		 * Returns the TextFlow object whose content appears in the container. Either the <code>textFlow</code> and  
		 * <code>rootElement</code> values are the same, or this is the root element's TextFlow object. For example,
		 * if the container's root element is a DivElement, the value would be the TextFlow object to which the
		 * DivElement belongs.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 * 
	 	 * @see org.apache.royale.textLayout.elements.TextFlow TextFlow
	 	 */		 
		public function get textFlow():ITextFlow
		{ 
			if (!_textFlowCache && _rootElement)
				_textFlowCache = _rootElement.getTextFlow();
			return _textFlowCache;
		}
		
		// Reserve possibility for future use as a IContainerFormattedElement within the TextFlow.
		
		/** 
		 * Returns the root element that appears in the container. The root element could be a DivElement or TextFlow
		 * instance, for example.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * 
		 * @see org.apache.royale.textLayout.elements.IContainerFormattedElement
		 * @see org.apache.royale.textLayout.elements.DivElement
		 * @see org.apache.royale.textLayout.elements.TextFlow
		 */
		
		public function get rootElement():IContainerFormattedElement
		{ return _rootElement; }
		
		/** Protected method used when updating the rootElement. 
		 * @param value new container to be controlled
		 * 
		 * @private
		 */
		public function setRootElement(value:IContainerFormattedElement):void
		{
			if (_rootElement != value)
			{
				if (_mouseEventManager)
					_mouseEventManager.stopHitTests();
				if (!value)
					_mouseEventManager = null;
				else if (!_mouseEventManager)
				{
					// Currently, the manager listens to all events itself.
					// TODO: forward at least mouseOver and mouseDown events without
					// causing side effects
					_mouseEventManager = new FlowElementMouseEventManager(container, null);
					//				[MouseEvent.MOUSE_DOWN, MouseEvent.MOUSE_UP, MouseEvent.MOUSE_MOVE, MouseEvent.MOUSE_DOWN, MouseEvent.MOUSE_OUT,
					//				 KeyboardEvent.KEY_DOWN, KeyboardEvent.KEY_UP]);
				}

				clearCompositionResults();
				detachContainer();
				_rootElement = value;
				_textFlowCache = null;
				_textLength = 0;
				_absoluteStart = -1;
				attachContainer();
				if (_rootElement)
					formatChanged();

				if (GlobalSettings.playerEnablesSpicyFeatures)
					_container["needsSoftKeyboard"] = (interactionManager && interactionManager.editingMode == EditingMode.READ_WRITE);
			}
		}
		
		/** 
		 * @copy org.apache.royale.textLayout.elements.TextFlow#interactionManager
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * 
		 * @see org.apache.royale.textLayout.elements.TextFlow#interactionManager
		 */
		
		public function get interactionManager():ISelectionManager
		{
			return textFlow ? textFlow.interactionManager : null;
		}
		
		
		/** @private */
		public function get uncomposedTextLength():int
		{ return _uncomposedTextLength; }

		/** @private */
		public function get finalParcelStart():int
		{ return _finalParcelStart; }
		
		/** @private */
		public function set finalParcelStart(val:int):void
		{ _finalParcelStart = val; }
		
		//--------------------------------------------------------------------------
		//
		//  Start and length
		//
		//--------------------------------------------------------------------------
		
		/** 
		 * Returns the first character in the container. If this is not the first container in the flow,
		 * this value is updated when the text is composed, that is when the IFlowComposer's <code>compose()</code> or 
		 * <code>updateAllControllers()</code> methods are called.
		 * 
		 * @see org.apache.royale.textLayout.compose.IFlowComposer
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		
		public function get absoluteStart():int
		{
			if (_absoluteStart != -1)
				return _absoluteStart;
			
			var rslt:int = 0;
			var composer:IFlowComposer = flowComposer;
			if (composer)
			{
				var stopIdx:int = composer.getControllerIndex(this);
				if (stopIdx != 0)
				{
					var prevController:IContainerController = composer.getControllerAt(stopIdx-1);
					rslt = prevController.absoluteStart + prevController.textLength;
				}
			}
			_absoluteStart = rslt;
			
			return rslt;
		}
		
		/** Returns the total number of characters in the container. This can include text that is not currently in view,
		 * if the container is scrollable. This value is updated when the text is composed (when the IFlowComposer's <code>compose()</code> 
		 * or <code>updateAllControllers()</code> methods are called).
		 * 
		 * @see org.apache.royale.textLayout.compose.IFlowComposer
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		
		public function get textLength():int
		{
			return _textLength;
		}
		/**
		 *  @private
		 * @royaleignorecoercion org.apache.royale.textLayout.container.ContainerController
		 */
		public function setTextLengthOnly(numChars:int):void
		{ 
			if (_textLength != numChars)
			{
				_textLength = numChars; 
				_uncomposedTextLength = 0;
				// all following containers must have absoluteStart invalidated
				if (_absoluteStart != -1)
				{
					var composer:IFlowComposer = flowComposer;
					if (composer)
					{
						var idx:int = composer.getControllerIndex(this)+1;
						while (idx < flowComposer.numControllers)
						{
							var controller:ContainerController = composer.getControllerAt(idx++) as ContainerController;
							if (controller._absoluteStart == -1)
								break;
							controller._absoluteStart = -1;
							controller._uncomposedTextLength = 0;
						}
					}
				}
			}
		}
		
		/** @private */
		public function setTextLength(numChars:int):void
		{
			CONFIG::debug { assert(numChars >= 0,"bad set textLength"); }
			
			// If its a scrollable container, and it is the last one, then it gets all the characters even though we might not have composed them all
			var uncomposedTextLength:int = 0;
			if (textFlow)
			{
				var verticalText:Boolean = effectiveBlockProgression == BlockProgression.RL;
				var flowComposer:IFlowComposer = textFlow.flowComposer;
				if (numChars != 0 && flowComposer.getControllerIndex(this) == flowComposer.numControllers - 1 &&
					((!verticalText && _verticalScrollPolicy != ScrollPolicy.OFF)||
						(verticalText && _horizontalScrollPolicy != ScrollPolicy.OFF)))
				{
					var containerAbsoluteStart:int = absoluteStart;
					CONFIG::debug { assert(textFlow.textLength >= containerAbsoluteStart,"ContainerController.setTextLength bad absoluteStart"); }
					uncomposedTextLength = textFlow.textLength-(numChars+containerAbsoluteStart);
					// _composeCompleteRatio = (textFlow.textLength-containerAbsoluteStart) == numChars ? 1 : 1.1;
					// var scaledContentHeight:Number = _composeCompleteRatio * _contentHeight;
					// trace("composeCompleteRatio:",_composeCompleteRatio,"composedContentHeight",_contentHeight,"scaledContentHeight",scaledContentHeight,"textLength",textFlow.textLength,"numChars",numChars);
					// include all remaining characters in this container when scroll enabled
					numChars = textFlow.textLength - containerAbsoluteStart;
				}
			}
			
			// this call clears uncomposedTextLength - set it immediately afterwards
			setTextLengthOnly(numChars); 	
			_uncomposedTextLength = uncomposedTextLength;

			CONFIG::debug
			{
				if (Debugging.debugOn && textFlow)
					assert(Math.min(textFlow.textLength, absoluteStart)+_textLength <= textFlow.textLength, "container textLength may not extend past end of root element!");
			}			
		}
		
		/** 
		 * Determines whether the container has text that requires composing. 
		 *
		 * @return 	true if the container requires composing.
		 *
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		
		public function isDamaged():Boolean
		{
			return flowComposer.isPotentiallyDamaged(absoluteStart + _textLength);
		}
		
		/** called whenever the container attributes are changed.  Mark computed attributes and columnstate as out of date. 
		 * @private
		 */
		public override function formatChanged(notifyModelChanged:Boolean = true):void
		{
			//has no meaning in ContainerController, but we're inheriting from TextLayoutFormatBase
			// The associated container, if there is one, inherits its container
			// attributes from here. So we need to tell it that these attributes
			// have changed.
			_computedFormat = null;
			invalidateContents();
		}
		
		/** This gets called when an element has changed its style selection related attributes. This may happen because an
		 * ancestor element changed it attributes.
		 * @private 
		 */		
		public override function styleSelectorChanged():void
		{
			modelChanged(ModelChange.STYLE_SELECTOR_CHANGED,this,0,this._textLength);
			_computedFormat = null;
		}
		
		/** @private */
		public function modelChanged(changeType:String, element:ContainerController, changeStart:int, changeLen:int, needNormalize:Boolean = true, bumpGeneration:Boolean = true):void
		{
			var tf:ITextFlow = _rootElement.getTextFlow();
			if (tf)
				tf.processModelChanged(changeType, element, absoluteStart+changeStart, changeLen, needNormalize, bumpGeneration);
		}
		
		/** @private */
		public function gatherVisibleLines(wmode:String, createShape:Boolean):void
		{
			CONFIG::debug { assert(_linesInView.length == 0,"gatherVisibleLines: bad _linesInView"); }
			if (_textLength != 0)
			{
				// Similar computations also done in BaseCompose.getControllerVisibleBounds
				var width:Number = _measureWidth ? _contentWidth : _compositionWidth;
				var height:Number = _measureHeight ? _contentHeight : _compositionHeight;
				var adjustX:Number = (wmode == BlockProgression.RL) ? _xScroll - width : _xScroll;
				var adjustY:Number = _yScroll;
				var scrollAdjustXTW:int = Twips.roundTo(adjustX);
				var scrollAdjustYTW:int = Twips.roundTo(adjustY);
				var scrollAdjustWidthTW:int = Twips.to(width);
				var scrollAdjustHeightTW:int = Twips.to(height);
				
				var flowComposer:IFlowComposer = this.flowComposer;
	
				// Iterate over the lines in the container, setting the x and y positions and 
				// adding them to the list to go into the container. Keep track of the width 
				// and height of the actual text in the container.
				var firstLine:int = flowComposer.findLineIndexAtPosition(absoluteStart);
				var lastLine:int = flowComposer.findLineIndexAtPosition(absoluteStart + _textLength - 1);
				
				var curLine:ITextFlowLine;
				var textLine:ITextLine;
				var lineIndex:int;
				var testRslt:*;
				
				//Use binary search when there is one single column
				if(columnCount == 1)
				{
					// First just test the firstLine - normal unscrolled case
					var testPos:int = firstLine;
					curLine = flowComposer.getLineAt(testPos++);
					while(curLine && curLine is ITextFlowTableBlock)
						curLine = flowComposer.getLineAt(testPos++);
					
					testRslt = testLineVisible(wmode, scrollAdjustXTW, scrollAdjustYTW, scrollAdjustWidthTW, scrollAdjustHeightTW, curLine, null);
					textLine = testRslt as ITextLine;
					firstLine++;	// its been tested
					if (textLine)
					{
						if (createShape)
							curLine.createShape(wmode, textLine);
						_linesInView.push(textLine);
					}
					else
					{
						var hi:int = lastLine;
						while (firstLine <= hi)
						{
							var mid:int = (firstLine+hi)/2;
							CONFIG::debug { assert(mid != 0,"ContainerController:gatherVisibleLines: bad mid"); }
							curLine = flowComposer.getLineAt(mid);
							testRslt = testLineVisible(wmode, scrollAdjustXTW, scrollAdjustYTW, scrollAdjustWidthTW, scrollAdjustHeightTW, curLine, null);
							
							if (testRslt && testRslt is ITextLine)
							{
								textLine = testRslt as ITextLine;
								// note that we tested firstLine above so going to mid-1 is always valid
								var tempLine:ITextFlowLine = flowComposer.getLineAt(mid-1);
								if (!(testLineVisible(wmode, scrollAdjustXTW, scrollAdjustYTW, scrollAdjustWidthTW, scrollAdjustHeightTW, tempLine, null) is ITextLine))
								{
									// Got the start
									if (createShape)
										curLine.createShape(wmode, textLine);
									_linesInView.push(textLine);
									firstLine = mid+1;
									break;
								}
								testRslt = -1;	// past the start
							}
							// need to deal with TextFlowTableBlocks
							
							if (testRslt < 0 || testRslt == 2)
								hi = mid-1;
							else
								firstLine = mid+1;
						}
					}
					
					for (lineIndex = firstLine; lineIndex <= lastLine; lineIndex++)
					{
						curLine = flowComposer.getLineAt(lineIndex);
						testRslt = testLineVisible(wmode, scrollAdjustXTW, scrollAdjustYTW, scrollAdjustWidthTW, scrollAdjustHeightTW, curLine, null);
						
						if(testRslt is TableBlockContainer)
							continue;
						textLine = testRslt as ITextLine;
						if (!textLine)
							break;
		
						if (createShape)
							curLine.createShape(wmode, textLine);
						_linesInView.push(textLine);
					}
				}
				else //multiple columns
				{
					for (lineIndex = firstLine; lineIndex <= lastLine; lineIndex++)
					{
						curLine = flowComposer.getLineAt(lineIndex);	
						if (curLine == null || curLine.controller != this)
							continue;
						
						textLine = oldTestLineVisible(wmode, scrollAdjustXTW, scrollAdjustYTW, scrollAdjustWidthTW, scrollAdjustHeightTW, curLine, null);
						if (textLine)
						{
							if (createShape)
								curLine.createShape(wmode, textLine);
							_linesInView.push(textLine);
						}
					}
				}
			}
			_updateStart = absoluteStart;	// we collected all lines from the start of the container
		}
		
		/** determines the shapechildren in the container and applies VJ. @private */
		public function fillShapeChildren():void
		{ 
			if (_textLength == 0)
				return;	// none				
			
			var wmode:String = effectiveBlockProgression;
			
			if (_linesInView.length == 0)		// no preexisting concpetion of what lines are in view: recalculate
				gatherVisibleLines(wmode, true);
			
			// If scrolling is turned off, and flow is vertical, then we need to adjust the positions of all the lines. With
			// scrolling turned on, we don't need to do this because the adjustment is done in the Player when the scrollRect
			// is set up correctly. But with the scrollRect, we also get clipping, and if scrolling is turned off we want to
			// have the clipping turned off as well. So in this case we do the adjustment manually so the scrollRect can be null.
			// NOTE: similar adjustments are made in TextContainerManager
			var adjustLines:Boolean = (wmode == BlockProgression.RL) &&
				(_horizontalScrollPolicy == ScrollPolicy.OFF && 
					_verticalScrollPolicy == ScrollPolicy.OFF);
			
			if (adjustLines)
			{			
				var width:Number = _measureWidth ? _contentWidth : _compositionWidth;
//				var height:Number = _measureHeight ? _contentHeight : _compositionHeight;
				var adjustX:Number = _xScroll - width;		// vertical text: blockProgression is rl
				var adjustY:Number = _yScroll;
				
				// Iterate over the lines in the container, setting the x and y positions. Keep track of the width 
				// and height of the actual text in the container.
				if (adjustX != 0 || adjustY != 0)
				{
					for each (var textLine:ITextLine in _linesInView)
					{
						if (!textLine)
							continue;
						
						if (adjustLines)
						{
							textLine.x -= adjustX;
							textLine.y -= adjustY;
						}
					}
					_contentLeft -= adjustX;
					_contentTop  -= adjustY;
				}
			}
			
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Scrolling
		//
		//--------------------------------------------------------------------------
		
		/** 
		 * Specifies the horizontal scrolling policy, which you can set by assigning one of the constants of
		 * the ScrollPolicy class: ON, OFF, or AUTO.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * 
		 * @see ScrollPolicy
		 */
		
		public function get horizontalScrollPolicy():String
		{
			return _horizontalScrollPolicy;
		}
		public function set horizontalScrollPolicy(scrollPolicy:String):void
		{
			var newScrollPolicy:String = ScrollPolicy.scrollPolicyPropertyDefinition.setHelper(_horizontalScrollPolicy, scrollPolicy) as String;
			
			if (newScrollPolicy != _horizontalScrollPolicy)
			{
				_horizontalScrollPolicy = newScrollPolicy;
				if (_horizontalScrollPolicy == ScrollPolicy.OFF)
					horizontalScrollPosition = 0;
				formatChanged();	// scroll policy affects composition
			}
		}
		
		/** @private */
		public function checkScrollBounds():void
		{
			var newHeight:Number;
			var visibleHeight:Number;
			var measuring:Boolean;
			
			// If we've either grown the content past the composition bounds in the logical vertical direction, 
			// or shrunk it down under the composition bounds, signal a scrolling change
			// If we're measuring we never scroll.
			if (effectiveBlockProgression == BlockProgression.RL)
			{
				newHeight = _contentWidth;
				visibleHeight = compositionWidth;
				measuring = _measureWidth;
			}
			else
			{
				newHeight = _contentHeight;
				visibleHeight = compositionHeight;
				measuring = _measureHeight;
			}

			// Called when the bounds have changed and they now exceed the composition area, to see if we need to attach a mouse wheel listener for scrolling
			if (textFlow && !_minListenersAttached)
			{
				var needToScroll:Boolean = !measuring && newHeight > visibleHeight;
				if (needToScroll != _mouseWheelListenerAttached)
				{
					if (_mouseWheelListenerAttached)
						removeMouseWheelListener();
					else
						addMouseWheelListener();
				}
			}
			
		}
		
		/** Specifies the vertical scrolling policy, which you can set by assigning one of the constants of the ScrollPolicy
		 * class: ON, OFF, or, AUTO.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 * @see ScrollPolicy
		 */
		
		public function get verticalScrollPolicy():String
		{
			return _verticalScrollPolicy;
		}
		public function set verticalScrollPolicy(scrollPolicy:String):void
		{
			var newScrollPolicy:String = ScrollPolicy.scrollPolicyPropertyDefinition.setHelper(_verticalScrollPolicy, scrollPolicy) as String;
			if (newScrollPolicy != _verticalScrollPolicy)
			{
				_verticalScrollPolicy = newScrollPolicy;
				if (_verticalScrollPolicy == ScrollPolicy.OFF)
					verticalScrollPosition = 0;
				formatChanged();	// scroll policy affects composition
			}
		}
		
		/** Specifies the current horizontal scroll location on the stage. The value specifies the number of
		 * pixels from the left.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		
		public function get horizontalScrollPosition():Number
		{
			return _xScroll;
		}
		
		public function set horizontalScrollPosition(x:Number):void
		{
			if (!_rootElement)
				return;
			
			if (_horizontalScrollPolicy == ScrollPolicy.OFF)
			{
				_xScroll = 0;
				return;
			}
			var oldScroll:Number = _xScroll;
			var newScroll:Number = computeHorizontalScrollPosition(x,true);
			
			if (newScroll != oldScroll)
			{	
				_shapesInvalid = true;
				_xScroll = newScroll;
				updateForScroll(ScrollEventDirection.HORIZONTAL, newScroll - oldScroll);
			}
		}
		
		static private function pinValue(value:Number, minimum:Number, maximum:Number):Number
		{
			return Math.min(Math.max(value, minimum), maximum);						
		}
		
		private function computeHorizontalScrollPosition(x:Number,okToCompose:Boolean):Number
		{
			var wmode:String = effectiveBlockProgression;
			var curEstimatedWidth:Number = contentWidth;
			var newScroll:Number = 0;
			
			if (curEstimatedWidth > _compositionWidth && !_measureWidth)
			{
				// Pin the lower and upper bounds of _x. If we're doing vertical text, then the right edge is 0 and the left edge is negative
				// We may not have composed all the way to the indicated position. If not, force composition so that we can be sure we're at
				// a legal position.
				if (wmode == BlockProgression.RL)
				{
					newScroll = pinValue(x, _contentLeft + _compositionWidth, _contentLeft + curEstimatedWidth);
					if (okToCompose && _uncomposedTextLength != 0 && newScroll != _xScroll)
					{
						// in order to compose have to set _xScroll
						_xScroll = x;
						if (_xScroll > _contentLeft + _contentWidth)
							_xScroll = _contentLeft + _contentWidth;
						flowComposer.composeToController(flowComposer.getControllerIndex(this));
						newScroll = pinValue(x, _contentLeft + _compositionWidth, _contentLeft + _contentWidth);
					}
				}
				else
					newScroll = pinValue(x, _contentLeft, (_contentLeft + curEstimatedWidth) - _compositionWidth);
			}
			return newScroll;
		}
		
		
		/** Specifies the current vertical scroll location on the stage. The value specifies the number of 
		 * pixels from the top.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		
		public function get verticalScrollPosition():Number
		{
			return _yScroll;
		}
		
		public function set verticalScrollPosition(y:Number):void
		{
			if (!_rootElement)
				return;
			
			if (_verticalScrollPolicy == ScrollPolicy.OFF)
			{
				_yScroll = 0;
				return;
			}
			
			var oldScroll:Number = _yScroll;
			var newScroll:Number = computeVerticalScrollPosition(y,true);
			
			if (newScroll != oldScroll)
			{			
				_shapesInvalid = true;
				_yScroll = newScroll;
				updateForScroll(ScrollEventDirection.VERTICAL, newScroll - oldScroll);
			}
		}	
		
		private function computeVerticalScrollPosition(y:Number,okToCompose:Boolean):Number
		{
			var newScroll:Number = 0;
			var curcontentHeight:Number = contentHeight;
			var wmode:String = effectiveBlockProgression;
			
			// Only try to scroll if the content height is greater than the composition height, then there is text that is not visible to scroll to
			if (curcontentHeight > _compositionHeight)
			{
				// new scroll value is somewhere between the topmost content, and the top of the last containerfull
				newScroll = pinValue(y, _contentTop, _contentTop + (curcontentHeight - _compositionHeight));
				
				// if we're not composed to the end, compose further so we can scroll to it. Sets the scroll position and then 
				// recomposes the container, which will compose through the end of the screenfull that starts at the requested position.
				if (okToCompose && _uncomposedTextLength != 0 && wmode == BlockProgression.TB)
				{
					_yScroll = y;
					if (_yScroll < _contentTop)
						_yScroll = _contentTop;
					flowComposer.composeToController(flowComposer.getControllerIndex(this));
					newScroll = pinValue(y, _contentTop, _contentTop + (curcontentHeight - _compositionHeight));
				}
			}
			return newScroll;
		}
		
		/** 
		 * Returns the area that the text occupies, as reflected by the last compose or update operation. 
		 * The width and the height might be estimated, if the container is scrollable and the text exceeds the 
		 * visible area.
		 * 
		 * @return describes the area that the text occupies.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 *
		 * @see org.apache.royale.geom.Rectangle Rectangle
		 */
		public function getContentBounds():Rectangle
		{
			return new Rectangle(_contentLeft, _contentTop, contentWidth, contentHeight);
		}
		
		/**
		 * @private
		 */
		
		public function get contentLeft():Number
		{
			return _contentLeft;
		}
		
		/**
		 * @private
		 */
		
		public function get contentTop():Number
		{
			return _contentTop;
		}
		
		/** @private */
		public function computeScaledContentMeasure(measure:Number):Number
		{
			CONFIG::debug { assert(_finalParcelStart != -1 && _finalParcelStart >= this.absoluteStart && _finalParcelStart <= textFlow.textLength-_uncomposedTextLength,"computeScaledContentMeasure bad _finalParcelStart"); }
			var charsInFinalParcel:int = textFlow.textLength-_finalParcelStart;
			var composeCompleteRatio:Number = charsInFinalParcel / (charsInFinalParcel-_uncomposedTextLength);
			// trace(measure*composeCompleteRatio,charsInFinalParcel,_uncomposedTextLength,measure,composeCompleteRatio);
			return measure * composeCompleteRatio;
		}
		
		/** 
		 * @private
		 *
		 * Returns the vertical extent of the text. For horizontal text, it includes space taken for descenders on the last line. 
		 * If not all the text is composed, this returns an estimated value based on how much text is already composed; the
		 * more text that is composed, the more accurate s the estimate. To get a completely accurate value, recompose
		 * with the rootElement's flowComposer before accessing contentHeight.
		 * You can get the composed bounds of the text by getting the contentLeft, contentTop, contentWidth, contentHeight properties.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		
		public function get contentHeight():Number
		{
			if (_uncomposedTextLength == 0 || effectiveBlockProgression != BlockProgression.TB)
				return _contentHeight;
			return computeScaledContentMeasure(_contentHeight);
		}
		
		/** 
		 * @private
		 *
		 * Returns the horizontal extent of the text. For vertical text, it includes space taken for descenders on the last line. 
		 * If not all the text is composed, this returns an estimated value based on how much text is already composed; the
		 * more text that is composed, the more accurate is the estimate. To get a completely accurate value, recompose
		 * with the rootElement's flowComposer before accessing contentWidth.
		 * You can get the composed bounds of the text by getting the contentLeft, contentTop, contentWidth, contentHeight properties.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		
		public function get contentWidth():Number
		{			
			if (_uncomposedTextLength == 0 || effectiveBlockProgression != BlockProgression.RL)
				return _contentWidth;
			return computeScaledContentMeasure(_contentWidth);
		}
		
		/** @private */
		public function setContentBounds(contentLeft:Number, contentTop:Number, contentWidth:Number, contentHeight:Number):void
		{
			_contentWidth = contentWidth;
			_contentHeight = contentHeight;
			_contentLeft = contentLeft;
			_contentTop = contentTop;
			checkScrollBounds();
		}
		
		private function updateForScroll(direction:String, delta:Number):void
		{
			_linesInView.length = 0;		// zero out array of previously gathered up lines; its invalid because we've changed the visible area
			var flowComposer:IFlowComposer = textFlow.flowComposer;
			flowComposer.updateToController(flowComposer.getControllerIndex(this));
			
			attachTransparentBackgroundForHit(false);
			
			// notify client that we scrolled.
			if (textFlow.hasEventListener(TextLayoutEvent.SCROLL))
				textFlow.dispatchEvent(new ScrollEvent(TextLayoutEvent.SCROLL, false, false, direction, delta));
			
			//	trace("contentHeight", contentHeight, "contentWidth", contentWidth);
			//	trace("contentHeight", contentHeight, "contentWidth", contentWidth);
		}
		
		/** @private */
		CONFIG::debug public function validateLines():void
		{
			if (!Debugging.containerLineValidation)
				return;
			
			// Optimally we would recalculate which lines are in view and make sure they are parented
			// to the container... but that causes side-effects (like creating TextLines) that affect
			// regular execution. So we don't try that.
			
			// Check all the children of the container. Verify that adornments go before or after lines, that lines are at the expected z-order position
			// And that extraneous lines are not parented to the container.
			var firstLineIndex:int = -1;
			var lastLineIndex:int = -1;
			var numChildren:int = _container.numElements;
			for (var childIndex:int = 0; childIndex < numChildren; ++childIndex)
			{
				var child:IChild = _container.getElementAt(childIndex);
				if (_shapeChildren.indexOf(child) < 0 && (!_floatsInContainer || _floatsInContainer.indexOf(child) < 0))
				{
					// the very last thing can be the selection sprite
					if (childIndex == numChildren - 1)
						assert(child == getSelectionSprite(false),"expected selectionsprite but not found");
					
					assert(firstLineIndex == -1 || lastLineIndex == childIndex - 1, "Found adornment in the middle of ITextLine children");
					continue;		// it's an adornment: skip
				}
				else 
				{
					if (firstLineIndex == -1)
						firstLineIndex = childIndex;
					lastLineIndex = childIndex;
				}
				if (_floatsInContainer && _floatsInContainer.indexOf(child) >= 0)	// it's a float
					continue;
				assert(child is ITextLine, "Expected child to be a ITextLine");
				
				// Check that the line comes after previous lines, in z-order
				var lineIndex:int = _shapeChildren.indexOf(child);
				if (lineIndex > 0)
					assert(_container.getElementIndex(_shapeChildren[lineIndex - 1]) < childIndex, "Line is visible but not at expected z-order position: earlier line is later in z-order");
				else if (lineIndex < 0)
					assert(false, "Found line that should not be in the container (its not considered visible)");
			}
		}
		
		private function get containerScrollRectLeft():Number
		{
			var rslt:Number;
			if (horizontalScrollPolicy == ScrollPolicy.OFF && verticalScrollPolicy == ScrollPolicy.OFF)
				rslt = 0;
			else
				rslt= effectiveBlockProgression == BlockProgression.RL ? horizontalScrollPosition - compositionWidth : horizontalScrollPosition;
			//CONFIG::debug { assert(container.scrollRect == null && rslt == 0 || int(rslt) == container.scrollRect.left,"Bad containerScrollRectLeft"); }
			return rslt;
		}
		
		private function get containerScrollRectRight():Number
		{
			var rslt:Number = containerScrollRectLeft+compositionWidth;
			//CONFIG::debug { assert(container.scrollRect == null && rslt == compositionWidth || int(rslt) == container.scrollRect.right,"Bad containerScrollRectRight"); }
			return rslt;
		}
		
		private function get containerScrollRectTop():Number
		{
			var rslt:Number;
			if (horizontalScrollPolicy == ScrollPolicy.OFF && verticalScrollPolicy == ScrollPolicy.OFF)
				rslt = 0;
			else
				rslt = verticalScrollPosition;
			//CONFIG::debug { assert(container.scrollRect == null && rslt == 0 || int(rslt) == container.scrollRect.top,"Bad containerScrollRectTop"); }
			return rslt;
		}
		
		private function get containerScrollRectBottom():Number
		{
			var rslt:Number = containerScrollRectTop+compositionHeight;
			//CONFIG::debug { assert(container.scrollRect == null && rslt == compositionHeight || int(rslt) == container.scrollRect.bottom,"Bad containerScrollRectBottom"); }
			return rslt;
		}
		
		/** 
		 * Scrolls so that the text range is visible in the container.
		 *
		 * @param activePosition	The end of the selection that is changed when you extend the selection. It can be
		 * 	either the start or the end of the selection, expressed as an offset from the start of the text flow.
		 * @param anchorPosition   	The stable end of the selection when you extend the selection. It can be either 
		 * 	the start or the end of the selection.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		
		public function scrollToRange(activePosition:int,anchorPosition:int):void
		{
			
			// return if we're not scrolling, or if it's not the last controller
			if (!_hasScrollRect || !flowComposer || flowComposer.getControllerAt(flowComposer.numControllers-1) != this)
				return;
			
			// clamp values to range absoluteStart,absoluteStart+_textLength
			var controllerStart:int = absoluteStart;
			var lastPosition:int = Math.min(controllerStart+_textLength, textFlow.textLength - 1);
			activePosition = Math.max(controllerStart,Math.min(activePosition,lastPosition));
			anchorPosition = Math.max(controllerStart,Math.min(anchorPosition,lastPosition));
			
			var verticalText:Boolean = effectiveBlockProgression == BlockProgression.RL;
			var begPos:int = Math.min(activePosition,anchorPosition);
			var endPos:int = Math.max(activePosition,anchorPosition);
			
			// is part of the selection in view?
			var begLineIndex:int = flowComposer.findLineIndexAtPosition(begPos,(begPos == textFlow.textLength));
			var endLineIndex:int = flowComposer.findLineIndexAtPosition(endPos,(endPos == textFlow.textLength));
			
			// no scrolling if any part of the selection is in view			
			var scrollRectLeft:Number = containerScrollRectLeft;
			var scrollRectTop:Number  = containerScrollRectTop;
			var scrollRectRight:Number = containerScrollRectRight;
			var scrollRectBottom:Number = containerScrollRectBottom;
			
			if (flowComposer.damageAbsoluteStart <= endPos)
			{
				endPos = Math.min(begPos + 100, endPos + 1);
				flowComposer.composeToPosition(endPos);
				begLineIndex = flowComposer.findLineIndexAtPosition(begPos,(begPos == textFlow.textLength));
				endLineIndex = flowComposer.findLineIndexAtPosition(endPos,(endPos == textFlow.textLength));
			}
			var rect:Rectangle = rangeToRectangle(begPos, endPos, begLineIndex, endLineIndex);
			if (rect) 
			{
//				var lastVisibleLine:ITextFlowLine;
				var horizontalScrollOK:Boolean;
				var verticalScrollOK:Boolean;
				
				// vertical scroll
				if (verticalText) {					
					// horizontal scroll
					horizontalScrollOK = (rect.left < scrollRectLeft || rect.right > scrollRectLeft);
					if (horizontalScrollOK)
					{
						if (rect.left < scrollRectLeft)
							horizontalScrollPosition = rect.left + _compositionWidth;
						if (rect.right > scrollRectRight)
							horizontalScrollPosition = rect.right;
					}
					
					// If we're showing a blinking insertion point, we need to scroll far enough that
					// we can see the insertion point, and it comes just after the character.
					if (rect.top < scrollRectTop)
						verticalScrollPosition = rect.top;
					if (activePosition == anchorPosition)
						rect.bottom += 2;							
					// vertical scroll
					if (rect.bottom > scrollRectBottom)
						verticalScrollPosition = rect.bottom - _compositionHeight;
				}
				else 
				{
					// vertical scroll
					
					// Don't scroll if the range extends both above and below
					verticalScrollOK = (rect.top > scrollRectTop || rect.bottom < scrollRectBottom);
					
					// vertical scroll
					if (verticalScrollOK)
					{
						if (rect.top < scrollRectTop)
							verticalScrollPosition = rect.top;
	
						if (rect.bottom > scrollRectBottom)
							verticalScrollPosition = rect.bottom - _compositionHeight;
					}
					
					// horizontal scroll

					// If we're showing a blinking insertion point, we need to scroll far enough to see the
					// insertion point, and it comes up to the right
					if (activePosition == anchorPosition)
						rect.right += 2;

					// Don't scroll if range extends both to the left and right
					horizontalScrollOK = (rect.left > scrollRectLeft || rect.right < scrollRectRight);
					if (horizontalScrollOK && rect.left < scrollRectLeft)
						horizontalScrollPosition = rect.left - _compositionWidth / 2;
					if (horizontalScrollOK && rect.right > scrollRectRight)
						horizontalScrollPosition = rect.right - _compositionWidth / 2;
				}
			}
		}		
		
		private function rangeToRectangle(start:int, end:int, startLineIndex:int, endLineIndex:int):Rectangle
		{
			var bbox:Rectangle;
			var blockProgression:String = effectiveBlockProgression;		
			var flowComposer:IFlowComposer = textFlow.flowComposer;
			
			if (!container || !flowComposer)
				return null;
			
			if (startLineIndex == endLineIndex)
			{
				var line:ITextFlowLine = flowComposer.getLineAt(startLineIndex); 
				if (line.isDamaged())
					return null;
				var textLine:ITextLine = line.getTextLine(true);
				var paragraphStart:int = line.paragraph.getAbsoluteStart();
				
				var isTCY:Boolean = false;
				if (blockProgression == BlockProgression.RL)
				{
					var leafElement:IFlowLeafElement = _rootElement.getTextFlow().findLeaf(start);
					isTCY =  leafElement.getParentByType("TCYElement") != null;
				}
				
				var minAtomIndex:int = textLine.atomCount;
				var maxAtomIndex:int = 0;
				if (start == end)
				{
					minAtomIndex = textLine.getAtomIndexAtCharIndex(start - paragraphStart);
					maxAtomIndex = minAtomIndex;
				}
				else
				{
					var atomIndex:int;
					var lastPosition:int = end - paragraphStart;
					for (var pos:int = start - paragraphStart; pos < lastPosition; ++pos)
					{
						atomIndex = textLine.getAtomIndexAtCharIndex(pos);
						if (atomIndex < minAtomIndex)
							minAtomIndex = atomIndex;
						if (atomIndex > maxAtomIndex)
							maxAtomIndex = atomIndex;
					}
				}
				bbox = atomToRectangle(minAtomIndex, line, textLine, blockProgression, isTCY);
				if (minAtomIndex != maxAtomIndex)
					bbox = bbox.union(atomToRectangle(maxAtomIndex, line, textLine, blockProgression, isTCY));
			}
			else
			{
				bbox = new Rectangle(_contentLeft, _contentTop, _contentWidth, _contentHeight);
				var startLine:ITextFlowLine = flowComposer.getLineAt(startLineIndex); 
				var endLine:ITextFlowLine = flowComposer.getLineAt(endLineIndex); 
				if (blockProgression == BlockProgression.TB)
				{
					bbox.top = startLine.y;
					bbox.bottom = endLine.y + endLine.textHeight;
				}
				else
				{
					bbox.right = startLine.x + startLine.textHeight;
					bbox.left = endLine.x;
				}
			}
			return bbox;
		}
		
		
		private function atomToRectangle(atomIdx:int, line:ITextFlowLine, textLine:ITextLine, blockProgression:String, isTCY:Boolean):Rectangle
		{
			var atomBounds:Rectangle;
			CONFIG::debug { assert(atomIdx > -1, "How'd we get here?"); }
			if (atomIdx > -1) 
				atomBounds = textLine.getAtomBounds(atomIdx);
			
			// special handling for TCY - no line height adjustments TCY is perpendicular to the height direction
			if (blockProgression == BlockProgression.RL)
			{
				if (isTCY)
					return new Rectangle(line.x+atomBounds.x,line.y+atomBounds.y,atomBounds.width,atomBounds.height);
				return new Rectangle(line.x, line.y + atomBounds.y, line.height, atomBounds.height);
			}
			return new Rectangle(line.x + atomBounds.x, line.y-line.height+line.ascent, atomBounds.width, line.height+textLine.descent);
		}
		
		/**
		 * @private
		 */
		
		public function resetColumnState():void
		{
			if (_rootElement)
				_columnState.updateInputs(effectiveBlockProgression, _rootElement.computedFormat.direction, this, _compositionWidth, _compositionHeight);
		}
		
		/** 
		 * Marks all the text in this container as needing composing. 
		 *
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 */
		
		public function invalidateContents():void
		{
			if (textFlow)
				textFlow.damage(absoluteStart, Math.min(_textLength, 1), FlowDamageType.GEOMETRY, false);
		}
		
		/** @private */
		private var _transparentBGX:Number;
		/** @private */
		private var _transparentBGY:Number;
		/** @private */
		private var _transparentBGWidth:Number;
		/** @private */
		private var _transparentBGHeight:Number;
		
		/** No mouse clicks or moves will be generated for the container unless it has a background covering its area.  Text Layout Framework
		 * wants those events so that clicking on a container will select the text in it.  This code
		 * adds or updates (on size change) that background for Sprite containers only. This may cause clients problems 
		 * - definitely no hits is a problem - add this code to explore the issues - expect feedback.  
		 * We may have to make this configurable. @private */
		
		
		public function attachTransparentBackgroundForHit(justClear:Boolean):void
		{
			if ((_minListenersAttached || _mouseWheelListenerAttached) && attachTransparentBackground)
			{
				var s:IParentIUIBase = _container;
                if (justClear)
                {
//TODO deal with graphics
//                    s.graphics.clear();
                    CONFIG::debug { Debugging.traceFTECall(null,s,"clearTransparentBackground()"); }
                    _transparentBGX = _transparentBGY = _transparentBGWidth = _transparentBGHeight = NaN;
                }
                else
                {
                    var bgwidth:Number = _measureWidth ? _contentWidth : _compositionWidth;
                    var bgheight:Number = _measureHeight ? _contentHeight : _compositionHeight;

                    var adjustHorizontalScroll:Boolean = effectiveBlockProgression == BlockProgression.RL && _horizontalScrollPolicy != ScrollPolicy.OFF;
                    var bgx:Number = adjustHorizontalScroll ? _xScroll - bgwidth : _xScroll;
                    var bgy:Number = _yScroll;

                    CONFIG::debug { assert(!isNaN(bgx) && !isNaN(bgy) && !isNaN(bgwidth) && ! isNaN(bgheight),"Bad background rectangle"); }

                    if (bgx != _transparentBGX || bgy != _transparentBGY || bgwidth != _transparentBGWidth || bgheight != _transparentBGHeight)
                    {
//TODO graphics
//                        s.graphics.clear();
//                        CONFIG::debug { Debugging.traceFTECall(null,s,"clearTransparentBackground()"); }
//                        if (bgwidth != 0 && bgheight != 0 )
//                        {
//                            s.graphics.beginFill(0, 0);
//                            s.graphics.drawRect(bgx, bgy, bgwidth, bgheight);
//                            s.graphics.endFill();
//                            CONFIG::debug { Debugging.traceFTECall(null,s,"drawTransparentBackground",bgx, bgy, bgwidth, bgheight); }
//                        }
                        _transparentBGX = bgx;
                        _transparentBGY = bgy;
                        _transparentBGWidth = bgwidth;
                        _transparentBGHeight = bgheight;
                    }
                }
			}
		}
		
		/** @private */
		public	function interactionManagerChanged(newInteractionManager:ISelectionManager):void
		{
			if (!newInteractionManager)
				detachContainer();
			attachContainer();
			checkScrollBounds();
			// Need to forward whether the Ctrl key is needed to have
			// hit-tested FlowElements emit events
			if (_mouseEventManager)
				_mouseEventManager.needsCtrlKey	= 
					(interactionManager != null && interactionManager.editingMode == EditingMode.READ_WRITE);

			// We have to tell the Player to bring up the soft keyboard on a
			// keyboard edit gesture. Note that needsSoftKeyboard is new with 10.2, so 
			// have to check for it. This is a change to the container, but unavoidable
			if (GlobalSettings.playerEnablesSpicyFeatures)
				_container["needsSoftKeyboard"] = (interactionManager && interactionManager.editingMode == EditingMode.READ_WRITE);
		}
		
		//--------------------------------------------------------------------------
		//  Event handlers for editing
		//  Listeners are attached on first compose
		//--------------------------------------------------------------------------
		
		/** @private */
		public function attachContainer():void
		{
			if (!_minListenersAttached && textFlow && textFlow.interactionManager)
			{
				_minListenersAttached = true;
				
                _container.addEventListener(FocusEvent.FOCUS_IN, requiredFocusInHandler);
                _container.addEventListener(MouseEvent.MOUSE_OVER, requiredMouseOverHandler);

                attachTransparentBackgroundForHit(false);

//TODO deal with reference to stage
                // If the container already has focus, we have to attach all listeners
//                if (_container.stage && _container.stage.focus == _container)
//                    attachAllListeners();
			}
		}
		
		/** @private */
		public function attachInteractionHandlers():void
		{
			// the receiver is either this or another class that is going to handle the methods.
			var receiver:IInteractionEventHandler = getInteractionHandler();
			
			// the required handlers are implemented here and forwarded to the receiver
			_container.addEventListener(MouseEvent.MOUSE_DOWN, requiredMouseDownHandler);
			_container.addEventListener(FocusEvent.FOCUS_OUT, requiredFocusOutHandler);
			_container.addEventListener(MouseEvent.DOUBLE_CLICK, receiver.mouseDoubleClickHandler);
			_container.addEventListener(ActivateEvent.ACTIVATE, receiver.activateHandler);
			_container.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, receiver.focusChangeHandler);
			_container.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, receiver.focusChangeHandler);
			_container.addEventListener(TextEvent.TEXT_INPUT, receiver.textInputHandler);
			_container.addEventListener(MouseEvent.MOUSE_OUT, receiver.mouseOutHandler);
			addMouseWheelListener();
			_container.addEventListener(ActivateEvent.DEACTIVATE, receiver.deactivateHandler);
			// attach by literal event name to avoid Argo dependency
			// normally this would be IMEEvent.START_COMPOSITION
			_container.addEventListener("imeStartComposition", receiver.imeStartCompositionHandler);
			
//TODO context menu
//			if (_container.contextMenu)
//				_container.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT, receiver.menuSelectHandler);
			_container.addEventListener(EditEvent.COPY, receiver.editHandler);
			_container.addEventListener(SelectionEvent.SELECT_ALL, receiver.editHandler);
			_container.addEventListener(EditEvent.CUT, receiver.editHandler);
			_container.addEventListener(EditEvent.PASTE, receiver.editHandler);
			_container.addEventListener(EditEvent.CLEAR, receiver.editHandler);
		}
		
		/** @private */
		public function removeInteractionHandlers():void
		{
			var receiver:IInteractionEventHandler = getInteractionHandler();
			
			_container.removeEventListener(MouseEvent.MOUSE_DOWN, requiredMouseDownHandler);
			_container.removeEventListener(FocusEvent.FOCUS_OUT, requiredFocusOutHandler);
			_container.removeEventListener(MouseEvent.DOUBLE_CLICK, receiver.mouseDoubleClickHandler);
			_container.removeEventListener(ActivateEvent.ACTIVATE, receiver.activateHandler);
			_container.removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, receiver.focusChangeHandler);
			_container.removeEventListener(FocusEvent.KEY_FOCUS_CHANGE, receiver.focusChangeHandler);
			_container.removeEventListener(TextEvent.TEXT_INPUT, receiver.textInputHandler);
			_container.removeEventListener(MouseEvent.MOUSE_OUT, receiver.mouseOutHandler);
			removeMouseWheelListener();
			_container.removeEventListener(ActivateEvent.DEACTIVATE, receiver.deactivateHandler);
			//	_container.removeEventListener(IMEEvent.IME_START_COMPOSITION, receiver.imeStartCompositionHandler); 
			// attach by literal event name to avoid Argo dependency
			_container.removeEventListener("imeStartComposition", receiver.imeStartCompositionHandler); 
			
//TODO context menu
//			if (_container.contextMenu) 
//				_container.contextMenu.removeEventListener(ContextMenuEvent.MENU_SELECT, receiver.menuSelectHandler);
			_container.removeEventListener(EditEvent.COPY, receiver.editHandler); 
			_container.removeEventListener(SelectionEvent.SELECT_ALL, receiver.editHandler);
			_container.removeEventListener(EditEvent.CUT, receiver.editHandler);
			_container.removeEventListener(EditEvent.PASTE, receiver.editHandler);
			_container.removeEventListener(EditEvent.CLEAR, receiver.editHandler);
			
			clearSelectHandlers();	
		}
		
		/** @private */
		private function detachContainer():void
		{
			if (_minListenersAttached)
			{
                _container.removeEventListener(FocusEvent.FOCUS_IN, requiredFocusInHandler);
                _container.removeEventListener(MouseEvent.MOUSE_OVER, requiredMouseOverHandler);

                if(_allListenersAttached)
                {
                    removeInteractionHandlers();
                    removeContextMenu();

                    attachTransparentBackgroundForHit(true);
                    _allListenersAttached = false;
                }
				_minListenersAttached = false;
			}
			removeMouseWheelListener();
		}
		
		
		private function attachAllListeners():void
		{	
			if (!_allListenersAttached && textFlow && textFlow.interactionManager)
			{
				CONFIG::debug { assert(_minListenersAttached,"Bad call to attachAllListeners - won't detach"); }
				_allListenersAttached = true;
                attachContextMenu();
                attachInteractionHandlers();
			}
		}
		
		/** @private */
		public function addMouseWheelListener():void
		{
			if (!_mouseWheelListenerAttached)
			{
				_container.addEventListener(MouseEvent.WHEEL, getInteractionHandler().mouseWheelHandler);
				_mouseWheelListenerAttached = true;
			}
		}
		
		/** @private */
		public function removeMouseWheelListener():void
		{
			if (_mouseWheelListenerAttached)
			{
				_container.removeEventListener(MouseEvent.WHEEL, getInteractionHandler().mouseWheelHandler);
				_mouseWheelListenerAttached = false;
			}
		}
		
		/** @private */
		public function attachContextMenu():void
		{
//TODO deal with context menu
//			_container.contextMenu = createContextMenu();
		}
		
		/** @private */
		public function removeContextMenu():void
		{
//TODO deal with context menu
//			 _container.contextMenu = null;
		}

		
		/** @private  
		 *
		 * Shared so that TextContainerManager can create the same ContextMenu. 
		 */
		static public function createDefaultContextMenu():ContextMenu
		{
			var contextMenu:ContextMenu = new ContextMenu();
			contextMenu.clipboardMenu = true;
			contextMenu.clipboardItems.clear = true;
			contextMenu.clipboardItems.copy = true;
			contextMenu.clipboardItems.cut = true;
			contextMenu.clipboardItems.paste = true;
			contextMenu.clipboardItems.selectAll = true;
			return contextMenu;
		}
		
		/** 
		 * Creates a context menu for the ContainerController. Use the methods of the ContextMenu class to 
		 * add items to the menu.
		 * <p>You can override this method to define a custom context menu.</p>
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 * @see flash.ui.ContextMenu ContextMenu
		 */
		protected function createContextMenu():ContextMenu
		{
			return createDefaultContextMenu();
		}
		
        public function dispose():void
        {
            stopMouseSelectionScrolling();
            clearSelectionShapes();
            setRootElement(null);
        }

        private function stopMouseSelectionScrolling(containerRoot:IEventDispatcher = null):void
        {
            if(_scrollTimer)
            {
                _scrollTimer.stop();
                _scrollTimer.removeEventListener(Timer.TIMER, scrollTimerHandler);

                if(!containerRoot)
                {
                    containerRoot = getContainerRoot();
                }

                if(containerRoot)
                {
                    containerRoot.removeEventListener(MouseEvent.MOUSE_UP, scrollTimerHandler);
                }

                _scrollTimer = null;
            }
        }
		/** @private */
		public function scrollTimerHandler(event:Event):void
		{
			// trace("BEGIN scrollTimerHandler");
			if (!_scrollTimer)
				return;
			
			// shut it down if not in this container
			if (textFlow.interactionManager == null || textFlow.interactionManager.activePosition < absoluteStart || textFlow.interactionManager.activePosition > absoluteStart+textLength)
				event = null;
			
			
			// We're listening for MOUSE_UP so we can cancel autoscrolling
			if (event is MouseEvent)
			{
				stopMouseSelectionScrolling(event.currentTarget as IEventDispatcher);
//				CONFIG::debug { assert(_container.stage ==  null || getContainerRoot() == event.currentTarget,"scrollTimerHandler bad target"); }
			}
			else if (!event)
			{
                stopMouseSelectionScrolling();
			}
//TODO deal with stage
//			else if (_container.stage)
//			{
//				var containerPoint:Point = new Point(_container.stage.mouseX, _container.stage.mouseY);
//				containerPoint = _container.globalToLocal(containerPoint);
//				var scrollChange:int = autoScrollIfNecessaryInternal(containerPoint);
//				if (scrollChange != 0 && interactionManager)		// force selection update if we actually scrolled and we have a selection manager
//				{
//					var mouseEvent:MouseEvent = new PsuedoMouseEvent(MouseEvent.MOUSE_MOVE,false,false,_container.stage.mouseX, _container.stage.mouseY,_container.stage,false,false,false,true);
//					var stashedScrollTimer:Timer = _scrollTimer;	
//					try
//					{
//						_scrollTimer =  null;
//						interactionManager.mouseMoveHandler(mouseEvent);
//					}
//					catch (e:Error)
//					{
//						throw(e);
//					}
//					finally
//					{
//						_scrollTimer = stashedScrollTimer;
//					}
//				}
//			}
			// trace("AFTER scrollTimerHandler");
		}
		
		/** 
		 * Handle a scroll event during a "drag" selection. 
		 *
		 * @param mouseX	The horizontal position of the mouse cursor on the stage.
		 * @param mouseY	The vertical position of the mouse cursor  on the stage.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		
		public function autoScrollIfNecessary(mouseX:int, mouseY:int):void
		{ 			
			if (flowComposer.getControllerAt(flowComposer.numControllers-1) != this)
			{
				var verticalText:Boolean = (effectiveBlockProgression == BlockProgression.RL);
				var lastController:IContainerController = flowComposer.getControllerAt(flowComposer.numControllers - 1);
				if ((verticalText && _horizontalScrollPolicy == ScrollPolicy.OFF) ||
					(!verticalText && _verticalScrollPolicy == ScrollPolicy.OFF))
					return;
				var r:Rectangle = DisplayUtils.getScreenBoundingRect(lastController.container);// lastController.container.getBounds(_container.stage);
				if (verticalText)
				{
					if (mouseY >= r.top && mouseY <= r.bottom)
						lastController.autoScrollIfNecessary(mouseX, mouseY);
				}
				else
				{
					if (mouseX >= r.left && mouseX <= r.right)
						lastController.autoScrollIfNecessary(mouseX, mouseY);
				}
			}
			
			// even if not the last container - may scroll if there are explicit linebreaks
			if (!_hasScrollRect)
				return;
			var containerPoint:Point = new Point(mouseX, mouseY);
			containerPoint = PointUtils.globalToLocal(containerPoint, _container);// _container.globalToLocal(containerPoint); 			
			autoScrollIfNecessaryInternal(containerPoint);
		}
		
		/** 
		 * Handle a scroll event during a "drag" selection. 
		 *
		 * @param mouseX	The horizontal position of the mouse cursor on the stage.
		 * @param mouseY	The vertical position of the mouse cursor  on the stage.
		 * @returns positive number if scroll went forward in reading order, negative number if it went backwards, and 0 if no scroll
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		
		private function autoScrollIfNecessaryInternal(extreme:Point):int
		{
			CONFIG::debug 
			{ 
				assert(_hasScrollRect, "internal scrolling function called on non-scrollable container");
			}
			
			
			var scrollDirection:int = 0;
			
			if (extreme.y - containerScrollRectBottom > 0) {
				verticalScrollPosition += textFlow.configuration.scrollDragPixels;
				scrollDirection = 1;
			}
			else if (extreme.y - containerScrollRectTop < 0) {
				verticalScrollPosition -= textFlow.configuration.scrollDragPixels;
				scrollDirection = -1;
			}
			
			if (extreme.x - containerScrollRectRight > 0) {
				horizontalScrollPosition += textFlow.configuration.scrollDragPixels;
				scrollDirection = -1;
			}
			else if (extreme.x - containerScrollRectLeft < 0) {
				horizontalScrollPosition -= textFlow.configuration.scrollDragPixels;
				scrollDirection = 1;
			}
			
			// we need a timer so that the mouse doesn't have to continue moving when the mouse is outside the content area
			if (scrollDirection != 0 && !_scrollTimer) 
			{
				_scrollTimer = new Timer(textFlow.configuration.scrollDragDelay);	// 35 ms is the default auto-repeat interval for ScrollBars.
				_scrollTimer.addEventListener(Timer.TIMER, scrollTimerHandler); // , false, 0, true);

				if (getContainerRoot())
				{
					getContainerRoot().addEventListener(MouseEvent.MOUSE_UP, scrollTimerHandler); // , false, 0, true);
//					beginMouseCapture(); // TELL CLIENTS WE WANT mouseUpSomewhere events
				}
				_scrollTimer.start();
			}
			
			return scrollDirection;
		}
		
		/** @private */ 
		public function getFirstVisibleLine():ITextFlowLine
		{ return _shapeChildren.length ? _shapeChildren[0].userData : null; }
		/** @private */
		public function getLastVisibleLine():ITextFlowLine
		{ return _shapeChildren.length ? _shapeChildren[_shapeChildren.length-1].userData : null; }
		
		/** 
		 * Figure out the scroll distance required to scroll up or down by the specified number of lines.
		 * Negative numbers scroll upward, bringing more of the top of the TextFlow into view. Positive numbers 
		 * scroll downward, bringing the next line from the bottom into full view.
		 * 
		 * <p>When scrolling up, for example, the method makes the next line fully visible. If the next line is partially
		 * obscured and the number of lines specified is 1, the partially obscured line becomes fully visible.</p>
		 *
		 * @param nLines	The number of lines to scroll.
		 *
		 * @return 	the delta amount of space to scroll
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		
		public function getScrollDelta(numLines:int):Number
		{
			var flowComposer:IFlowComposer = textFlow.flowComposer;
			
			if (flowComposer.numLines == 0)
				return 0;
			
			// Now we want to calculate the top & bottom lines within the scrollRect. It's ok if they're just partially
			// visible. Once we determine these lines, we figure out how much we need to scroll in order to bring the
			// lines completely into view.
			
			var firstVisibleLine:ITextFlowLine = getFirstVisibleLine();
			if (!firstVisibleLine)
				return 0;

			var lastVisibleLine:ITextFlowLine = getLastVisibleLine();
			CONFIG::debug { assert(lastVisibleLine != null,"Expect lastVisibleLine when there is a firstVisibleLine"); }
				
			// trace("    // findFirstAndLastVisibleLine ",flowComposer.findLineIndexAtPosition(firstVisibleLine.absoluteStart),flowComposer.findLineIndexAtPosition(lastVisibleLine.absoluteStart));
			
			var newLineIndex:int;
			var lineIndex:int;
			if (numLines > 0) 
			{
				lineIndex = flowComposer.findLineIndexAtPosition(lastVisibleLine.absoluteStart);
				// If the last visible line is only partly visible, don't count it as visible. But make sure it overlaps by
				// at least two pixels, otherwise it doesn't look like its clipped.

				var lastTextLine:ITextLine = lastVisibleLine.getTextLine(true);
				if (effectiveBlockProgression == BlockProgression.TB)
				{
					if ((lastTextLine.y + lastTextLine.descent) - containerScrollRectBottom > 2)
						--lineIndex;
				}
				else if (containerScrollRectLeft - (lastTextLine.x - lastTextLine.descent)  > 2)
					--lineIndex;
				
				// if we hit the end, force composition so that we get more lines - I picked a random amount to scroll forward, if its not enough, it will keep going
				while (lineIndex + numLines > flowComposer.numLines - 1 && flowComposer.damageAbsoluteStart < textFlow.textLength)	
				{
					var previousDamageStart:int = flowComposer.damageAbsoluteStart;
					flowComposer.composeToPosition(flowComposer.damageAbsoluteStart + 1000);
					// if we've made no progress, abort
					if (flowComposer.damageAbsoluteStart == previousDamageStart)
						return 0;
				}
				newLineIndex = Math.min(flowComposer.numLines-1, lineIndex + numLines);
			}
			if (numLines < 0) 
			{
				lineIndex = flowComposer.findLineIndexAtPosition(firstVisibleLine.absoluteStart);
				
				// If the first visible line is only partly visible, don't count it as visible. But make sure it overlaps by
				// at least two pixels, otherwise it doesn't look like its clipped.
				if (effectiveBlockProgression == BlockProgression.TB)
				{
					if (firstVisibleLine.y + 2 < containerScrollRectTop)
						++lineIndex;
				}
				else if (firstVisibleLine.x + firstVisibleLine.ascent > containerScrollRectRight + 2)
					++lineIndex;
				
				newLineIndex = Math.max(0, lineIndex + numLines);
			}
			
			var line:ITextFlowLine = flowComposer.getLineAt(newLineIndex);
			if (line.absoluteStart < absoluteStart)		// don't scroll past the start of this controller -- previous text is in previous controller
				return 0;
			if (line.validity != "valid")
			{
				var leaf:IFlowLeafElement = textFlow.findLeaf(line.absoluteStart);
				var paragraph:IParagraphElement = leaf.getParagraph();
				textFlow.flowComposer.composeToPosition(paragraph.getAbsoluteStart() + paragraph.textLength);
				line = flowComposer.getLineAt(newLineIndex);
				CONFIG::debug { assert(line.validity == "valid", "expected valid line after recomposing"); }
			}
			
			var verticalText:Boolean = effectiveBlockProgression == BlockProgression.RL;
			
			var newScrollPosition:Number;
			if (verticalText)
			{
				
				newScrollPosition =  numLines < 0 ? line.x + line.textHeight : line.x - line.descent + _compositionWidth;
				return newScrollPosition - horizontalScrollPosition;
			}
			
			newScrollPosition = numLines < 0 ? line.y : line.y + line.textHeight - _compositionHeight;
			return newScrollPosition - verticalScrollPosition;
		}
		
		/** 
		 * Processes the <code>MouseEvent.MOUSE_OVER</code> event when the client manages events. 
		 *
		 * @param event The MouseEvent object.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 *
		 * @see org.apache.royale.events.MouseEvent#MOUSE_OVER MouseEvent.MOUSE_OVER
		 */
		
		public function mouseOverHandler(event:MouseEvent):void
		{
			if(!event.buttonDown)
			event.buttonDown = buttonDown;
			if (interactionManager && !event.defaultPrevented)
				interactionManager.mouseOverHandler(event);
		}
		
		/** @private Does required mouseOver handling.  Calls mouseOverHandler.  @see #mouseOverHandler */
		public function requiredMouseOverHandler(event:MouseEvent):void
		{
			if(!event.buttonDown)
			event.buttonDown = buttonDown;
			attachAllListeners();
			getInteractionHandler().mouseOverHandler(event);
		}
		
		/** Processes the <code>MouseEvent.MOUSE_OUT</code> event when the client manages events.
		 *
		 * @param event The MouseEvent object.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 * @see org.apache.royale.events.MouseEvent#MOUSE_OUT MouseEvent.MOUSE_OUT
		 */				
		public function mouseOutHandler(event:MouseEvent):void
		{
			if(!event.buttonDown)
			event.buttonDown = buttonDown;
			if (interactionManager && !event.defaultPrevented)
				interactionManager.mouseOutHandler(event);
		}
		
		/** Processes the <code>MouseEvent.MOUSE_WHEEL</code> event when the client manages events.
		 *
		 * @param event The MouseEvent object.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 * @see org.apache.royale.events.MouseEvent#MOUSE_WHEEL MouseEvent.MOUSE_WHEEL
		 */
		public function mouseWheelHandler(event:MouseEvent):void
		{
			if (event.defaultPrevented)
				return;
			
			// Do the scroll and call preventDefault only if the there is enough text to scroll. Otherwise
			// we let the event bubble up and cause scrolling at the next level up in the client's container hierarchy.
			var verticalText:Boolean = effectiveBlockProgression == BlockProgression.RL;
			if (verticalText)
			{
				if (contentWidth > _compositionWidth && !_measureWidth)
				{
					horizontalScrollPosition += event.delta * textFlow.configuration.scrollMouseWheelMultiplier;
					event.preventDefault();
				}
			}
			else if (contentHeight > _compositionHeight && !_measureHeight)
			{
				verticalScrollPosition -= event.delta * textFlow.configuration.scrollMouseWheelMultiplier;
				event.preventDefault();
			}
		}
		
		
		/** Processes the <code>MouseEvent.MOUSE_DOWN</code> event when the client manages events. 
		 *
		 * @param event The MouseEvent object.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 * @see org.apache.royale.events.MouseEvent#MOUSE_DOWN MouseEvent.MOUSE_DOWN
		 */
		
		public function mouseDownHandler(event:MouseEvent):void
		{
			buttonDown = true;
			if (interactionManager && !event.defaultPrevented)
			{
				interactionManager.mouseDownHandler(event);
				// grab the focus - alternative is to listen to keyevents on the Application
				// is this necessary?
				if ( interactionManager.hasSelection())
					setFocus();
			}
		}
		
		/** @private Does required mouseDown handling.  Calls mouseDownHandler.  @see #mouseDownHandler */
		public function requiredMouseDownHandler(event:MouseEvent):void
		{
            buttonDown = true;
			if (!_selectListenersAttached)
			{
				var containerRoot:IEventDispatcher = getContainerRoot();
				if (containerRoot)
				{
					containerRoot.addEventListener(MouseEvent.MOUSE_MOVE, rootMouseMoveHandler); // , false, 0, true); 
					containerRoot.addEventListener(MouseEvent.MOUSE_UP,   rootMouseUpHandler); //, false, 0, true);
					
//					beginMouseCapture(); // TELL CLIENTS THAT WE WANT moueUpSomewhere EVENTS
					
					
					_selectListenersAttached = true;
				}
			}
			getInteractionHandler().mouseDownHandler(event); 
		}
		
		/** 
		 * Processes the <code>MouseEvent.MOUSE_UP</code> event when the client manages events.
		 *
		 * @param event The MouseEvent object.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 * @see org.apache.royale.events.MouseEvent#MOUSE_UP MouseEvent.MOUSE_UP
		 *
		 */
		public function mouseUpHandler(event:MouseEvent):void
		{
			buttonDown = false;
			if (interactionManager && event && !event.defaultPrevented)
			{
				interactionManager.mouseUpHandler(event);
			}
		}		
		
		/** @private */
		public function rootMouseUpHandler(event:MouseEvent):void
		{
            buttonDown = false;
			clearSelectHandlers();
			getInteractionHandler().mouseUpHandler(event);
		}
		
		
		private function clearSelectHandlers():void
		{	
			if (_selectListenersAttached)
			{
				CONFIG::debug { assert(getContainerRoot() != null,"No container root"); }
				getContainerRoot().removeEventListener(MouseEvent.MOUSE_MOVE, rootMouseMoveHandler); 					
				getContainerRoot().removeEventListener(MouseEvent.MOUSE_UP,   rootMouseUpHandler);
//				endMouseCapture(); // TELL CLIENTS WE NO LONGER WANT mouseUpSomewhere EVENTS
				_selectListenersAttached = false;
			}
		}
		
		/** 
		 * Called to request clients to begin the forwarding of mouseup and mousemove events from outside a security sandbox.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 */
		public function beginMouseCapture():void
		{
			// trace("BEGIN MOUSECAPTURE");
			var sandboxManager:ISandboxSupport = getInteractionHandler() as ISandboxSupport;
			if (sandboxManager && sandboxManager != this)
				sandboxManager.beginMouseCapture();
		}
		/** 
		 * Called to inform clients that the the forwarding of mouseup and mousemove events from outside a security sandbox is no longer needed.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 */
		public function endMouseCapture():void
		{
			// trace("END MOUSECAPTURE");
			var sandboxManager:ISandboxSupport = getInteractionHandler() as ISandboxSupport;
			if (sandboxManager && sandboxManager != this)
				sandboxManager.endMouseCapture();
		}
		/** Client call to forward a mouseUp event from outside a security sandbox.  Coordinates of the mouse up are not needed.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 */
		public function mouseUpSomewhere(event:Event):void
		{
			rootMouseUpHandler(null);
			scrollTimerHandler(null);
		}
		/** Client call to forward a mouseMove event from outside a security sandbox.  Coordinates of the mouse move are not needed.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 */
		public function mouseMoveSomewhere(event:Event):void
		{
			return;	// do nothing right now
		}
		
		// What'd I hit???
		private function hitOnMyFlowExceptLastContainer(event:MouseEvent):Boolean
		{
			if (event.target is ITextLine)
			{
				var tfl:ITextFlowLine = ITextLine(event.target).userData as ITextFlowLine;
				if (tfl)
				{
					var para:IParagraphElement = tfl.paragraph;
					if(para.getTextFlow() == textFlow)
						return true;
				}
			}
//TODO how to properly check?
//			else if (event.target is Sprite)
//			{
//				// skip the last container in the chain
//				for (var idx:int = 0; idx < textFlow.flowComposer.numControllers-1; idx++)
//					if (textFlow.flowComposer.getControllerAt(idx).container == event.target)
//						return true;
//			}
			return false;
		}
		/** 
		 * Processes the <code>MouseEvent.MOUSE_MOVE</code> event when the client manages events.
		 *
		 * @param event The MouseEvent object.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 * @see org.apache.royale.events.MouseEvent#MOUSE_MOVE MouseEvent.MOUSE_MOVE
		 */
		
		public function mouseMoveHandler(event:MouseEvent):void
		{
			if(!event.buttonDown)
				event.buttonDown = buttonDown;
			if (interactionManager && !event.defaultPrevented)
			{
//TODO fix this
				// only autoscroll if we haven't hit something on the stage related to this particular TextFlow
				if (event.buttonDown && !hitOnMyFlowExceptLastContainer(event))
					// autoScrollIfNecessary(event.stageX, event.stageY);
				interactionManager.mouseMoveHandler(event);
			}
		}
		
		/** @private */
		public function rootMouseMoveHandler(event:MouseEvent):void
		{   
			if(!event.buttonDown)
				event.buttonDown = buttonDown;
			getInteractionHandler().mouseMoveHandler(event); 
		}
		
		/** Processes the <code>MouseEvent.DOUBLE_CLICK</code> event when the client manages events.
		 *
		 * @param event The MouseEvent object.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 *
		 * @see org.apache.royale.events.MouseEvent#DOUBLE_CLICK MouseEvent.DOUBLE_CLICK
		 */
		public function mouseDoubleClickHandler(event:MouseEvent):void
		{
			if (interactionManager && !event.defaultPrevented)
			{
				interactionManager.mouseDoubleClickHandler(event);
				// grab the focus - alternative is to listen to keyevents on the Application
				// is this necessary?
				if ( interactionManager.hasSelection())
					setFocus();
			}
		}
		
		/** Give focus to the text container. @private */
		public function setFocus():void
		{
			//trace("setFocus container", id);
//TODO deal with stage and focus
//			if (_container.stage)
//				_container.stage.focus = _container; 
		}
		
		/**
		 *  @private
		 *  @royaleignorecoercion org.apache.royale.core.IParentIUIBase
		 */
		public function getContainerController(container:IParentIUIBase):IContainerController
		{
			try
			{
				while (container)
				{
					var flowComposer:IFlowComposer = flowComposer;
					for (var i:int = 0; i < flowComposer.numControllers; i++)
					{
						var controller:IContainerController = flowComposer.getControllerAt(i);
						if (controller.container == container)
							return controller;
					}
					container = container.parent as IParentIUIBase;
				}
			}
			catch (e:Error)
			{ }
			return null;
		}
		
		/** 
		 * Processes the <code>FocusEvent.KEY_FOCUS_CHANGE</code> and <code>FocusEvent.MOUSE_FOCUS_CHANGE</code> events
		 * when the client manages events.
		 *
		 * @param event The FocusEvent object.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 * @see org.apache.royale.events.FocusEvent#KEY_FOCUS_CHANGE FocusEvent.KEY_FOCUS_CHANGE
		 * @see org.apache.royale.events.FocusEvent#MOUSE_FOCUS_CHANGE FocusEvent.MOUSE_FOCUS_CHANGE
		 *  @royaleignorecoercion org.apache.royale.core.IParentIUIBase
		 */
		public function focusChangeHandler(event:Event):void
		{
			// Figure out which controllers, if any, correspond to the DisplayObjects passed in the event.
			// Disallow the focus change if it comes back to this controller again -- this prevents
			// a focusOut followed by a focusIn, which we would otherwise get after clicking in the 
			// container that already has focus.

//TODO looks like we need the relatedObject property of FocusEvent. We can probably replace this with ValueEvent.
			
			// This is the controller that currently has the focus
//			var focusController:ContainerController = getContainerController(event.target as IParentIUIBase);
			
			// This is the controller that is about to get the focus
//			var newFocusController:ContainerController = getContainerController(event.relatedObject);
			
			/*trace("focusChange from controller", 
			focusController is ContainerControllerBase ? ContainerControllerBase(focusController).id : "unknownType", 
			newFocusController is ContainerControllerBase ? ContainerControllerBase(newFocusController).id : "unknownType");
			*/
//			if (newFocusController == focusController)
//			{
//				//	trace("prevent focus change");
//				event.preventDefault();
//			}
		}
		
		/** Processes the <code>FocusEvent.FOCUS_IN</code> event when the client manages events.
		 *
		 * @param event The FocusEvent object.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 *
		 * @see org.apache.royale.events.FocusEvent#FOCUS_IN FocusEvent.FOCUS_IN
		 */
		public function focusInHandler(event:Event):void
		{
			var blinkRate:int = 0;
			//	trace("container", id, "focusIn");
			if (interactionManager)
			{
				interactionManager.focusInHandler(event);
				
				if (interactionManager.editingMode == EditingMode.READ_WRITE)
					blinkRate = interactionManager.focusedSelectionFormat.pointBlinkRate;				
			} 
			setBlinkInterval(blinkRate);
		}
		
		/** @private - does whatever focusIn handling is required and cannot be overridden */
		public function requiredFocusInHandler(event:Event):void
		{
			attachAllListeners();
			// trace("ContainerController requiredFocusInHandler adding key handlers");
			_container.addEventListener(KeyboardEvent.KEY_DOWN, getInteractionHandler().keyDownHandler);
			_container.addEventListener(KeyboardEvent.KEY_UP,   getInteractionHandler().keyUpHandler);		
			_container.addEventListener(FocusEvent.KEY_FOCUS_CHANGE,   getInteractionHandler().keyFocusChangeHandler);	
			if (GlobalSettings.playerEnablesSpicyFeatures && GlobalSettings.hasTouchScreen)
				_container.addEventListener("softKeyboardActivating", getInteractionHandler().softKeyboardActivatingHandler);
			getInteractionHandler().focusInHandler(event);
		}
		
		/** Processes the <code>FocusEvent.FOCUS_OUT</code> event when the client manages events.
		 *
		 * @param event The FocusEvent object.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 * @see org.apache.royale.events.FocusEvent#FOCUS_OUT FocusEvent.FOCUS_OUT
		 */
		
		public function focusOutHandler(event:Event):void
		{
			if (interactionManager)
			{
				interactionManager.focusOutHandler(event);
				setBlinkInterval(interactionManager.unfocusedSelectionFormat.pointBlinkRate);
			}
			else
				setBlinkInterval(0);
		}
		
		/** @private Does required focusOut handling.  Calls focusOutHandler.  @see #focusOutHandler */
		public function requiredFocusOutHandler(event:Event):void
		{
			// trace("ContainerController requiredFocusOutHandler removing key handlers");
			_container.removeEventListener(KeyboardEvent.KEY_DOWN, getInteractionHandler().keyDownHandler);
			_container.removeEventListener(KeyboardEvent.KEY_UP,   getInteractionHandler().keyUpHandler);   			
			_container.removeEventListener(FocusEvent.KEY_FOCUS_CHANGE,   getInteractionHandler().keyFocusChangeHandler);   			
			if (GlobalSettings.playerEnablesSpicyFeatures && GlobalSettings.hasTouchScreen)
				_container.removeEventListener("softKeyboardActivating", getInteractionHandler().softKeyboardActivatingHandler);
			getInteractionHandler().focusOutHandler(event);
		}
		
		/** Processes the <code>Event.ACTIVATE</code> event when the client manages events.
		 *
		 * @param event The Event object.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 *
		 * @see org.apache.royale.events.Event#ACTIVATE Event.ACTIVATE
		 */						
		public function activateHandler(event:Event):void
		{
			if (interactionManager)
				interactionManager.activateHandler(event);
		}
		
		/** Processes the <code>Event.DEACTIVATE</code> event when the client manages events. 
		 *
		 * @param event The Event object.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * 
		 * @see org.apache.royale.events.Event#DEACTIVATE Event.DEACTIVATE
		 */
		
		public function deactivateHandler(event:Event):void
		{
			if (interactionManager)
				interactionManager.deactivateHandler(event);
		}		
		
		/** Processes the <code>KeyboardEvent.KEY_DOWN</code> event when the client manages events.
		 *
		 * @param The KeyboardEvent object.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 * @see org.apache.royale.events.KeyboardEvent#KEY_DOWN KeyboardEvent.KEY_DOWN
		 */
		public function keyDownHandler(event:KeyboardEvent):void
		{
			if (interactionManager && !event.defaultPrevented)
				interactionManager.keyDownHandler(event);
		}
		
		/** Processes the <code>Keyboard.KEY_UP</code> event when the client manages events.
		 *
		 * @param event The KeyboardEvent object.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 *
		 * @see org.apache.royale.events.KeyboardEvent#KEY_UP KeyboardEvent.KEY_UP
		 */
		
		public function keyUpHandler(event:KeyboardEvent):void
		{
			if (interactionManager && !event.defaultPrevented)
				interactionManager.keyUpHandler(event);
		}
		
		/** Processes the <code>FocusEvent.KEY_FOCUS_CHANGE</code> event when the client manages events.
		 *
		 * @param event The FocusEvent object.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 * @see org.apache.royale.events.FocusEvent#KEY_FOCUS_CHANGE FocusEvent.KEY_FOCUS_CHANGE
		 */
		public function keyFocusChangeHandler(event:Event):void
		{
			if (interactionManager)
				interactionManager.keyFocusChangeHandler(event);
		}		
		/** Processes the <code>TextEvent.TEXT_INPUT</code> event when the client manages events.
		 *
		 * @param event  The TextEvent object.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * 
		 *
		 * @see org.apache.royale.events.TextEvent#TEXT_INPUT TextEvent.TEXT_INPUT
		 */
		
		public function textInputHandler(event:TextEvent):void
		{
			if (interactionManager && !event.defaultPrevented)
				interactionManager.textInputHandler(event);
		}
		
		/** Processes the <code>SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATING</code> event when the client manages events.
		 *
		 * @param event  The SoftKeyboardEvent object.
		 *
		 * @playerversion Flash 10.2
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * 
		 * @see org.apache.royale.events.SoftKeyboardEvent#SOFT_KEYBOARD_ACTIVATING SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATING
		 */
		
		public function softKeyboardActivatingHandler(event:Event):void
		{
			if (interactionManager)
				interactionManager.softKeyboardActivatingHandler(event);
		}
		
		/** Processes the <code>IMEEvent.IME_START_COMPOSITION</code> event when the client manages events.
		 *
		 * @param event  The IMEEvent object.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * 
		 * @see org.apache.royale.events.IMEEvent.IME_START_COMPOSITION
		 */
		
		public function imeStartCompositionHandler(event:IMEEvent):void
		{
			if (interactionManager)
				interactionManager.imeStartCompositionHandler(event);
		}
		
		
		/** 
		 * Processes the <code>ContextMenuEvent.MENU_SELECT</code> event when the client manages events.
		 * 
		 * @param The ContextMenuEvent object.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 * 
		 * @see org.apache.royale.events.ContextMenuEvent#MENU_SELECT ContextMenuEvent.MENU_SELECT
		 */						
		public function menuSelectHandler(event:ContextMenuEvent):void
		{			
			if (interactionManager)
			{
				interactionManager.menuSelectHandler(event);
			}
			else
			{
//TODO deal with context menus
//				var contextMenu:ContextMenu = _container.contextMenu;
//				if (contextMenu)
//				{
//					var cbItems:ContextMenuClipboardItems = contextMenu.clipboardItems;
//					cbItems.copy = false;
//					cbItems.cut = false;
//					cbItems.paste = false;
//					cbItems.selectAll = false;
//					cbItems.clear = false;
//				}
			}
		}
		
		/**
		 * Processes an edit event (CUT, COPY, PASTE, SELECT_ALL) when the client manages events.
		 * 
		 * @param The Event object.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 * 
		 * @see org.apache.royale.events.Event Event
		 */	
		
		public function editHandler(event:Event):void
		{
			if (interactionManager && !event.defaultPrevented)
				interactionManager.editHandler(event);
//TODO deal with context menus			
			// re-enable context menu so following keyboard shortcuts will work
//			var contextMenu:ContextMenu = _container.contextMenu;
//			if (contextMenu)
//			{
//				contextMenu.clipboardItems.clear = true;
//				contextMenu.clipboardItems.copy = true;
//				contextMenu.clipboardItems.cut = true;
//				contextMenu.clipboardItems.paste = true;
//				contextMenu.clipboardItems.selectAll = true;
//			}
		}
		
		/** 
		 * Sets the range of selected text in a component implementing ITextSupport.
		 * If either of the arguments is out of bounds the selection should not be changed.
		 * Components which wish to support inline IME should call into this method.
		 * 
		 * @param anchorIndex The zero-based index value of the character at the anchor end of the selection
		 *
		 * @param activeIndex The zero-based index value of the character at the active end of the selection.
		 * 
		 * @playerversion Flash 10.0
		 * @langversion 3.0
		 */
		public function selectRange(anchorIndex:int, activeIndex:int):void
		{
			if(interactionManager && interactionManager.editingMode != EditingMode.READ_ONLY)
			{
				interactionManager.selectRange(anchorIndex, activeIndex);
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Cursor blinking code
		//
		//--------------------------------------------------------------------------
		
		// TODO Want to evaluate whether there's a cleaner way to do this
		
		private var blinkTimer:Timer;
		private var blinkObject:IRect;
		
		/**
		 * Starts a DisplayObject cursor blinking by changing its alpha value
		 * over time.
		 * 
		 * @param obj The DisplayObject to use as the cursor.
		 * 
		 */
		private  var blinkState:Boolean;
		private function startBlinkingCursor(obj:IRect, blinkInterval:int):void
		{
			if (!blinkTimer)
				blinkTimer = new Timer(blinkInterval,0);
			blinkObject = obj;
//It was using weak references which Royale does not support
			// blinkTimer.addEventListener(Timer.TIMER,blinkTimerHandler, false, 0, true);
			blinkTimer.addEventListener(Timer.TIMER,blinkTimerHandler);
			blinkTimer.start();
		}
		
		/**
		 * Stops cursor from blinking
		 * @private
		 */
		protected function stopBlinkingCursor():void
		{
			if (blinkTimer)
				blinkTimer.stop();
			if(blinkObject)
			{
				var selFormat:SelectionFormat = interactionManager.currentSelectionFormat;
				var fill:SolidColor = blinkObject.fill as SolidColor;
				fill.alpha = selFormat.pointAlpha;
				fill.color = selFormat.pointColor;
				(blinkObject as IDrawable).draw();
				blinkObject.alpha = 1;
				blinkState = false;
			}
			blinkObject = null;
		}	
		
		private function blinkTimerHandler(event:Event):void
		{
			var selFormat:SelectionFormat = interactionManager.currentSelectionFormat;
			if(selFormat)
			{
				var fill:SolidColor = blinkObject.fill as SolidColor;
				if(blinkState)
				{
					fill.alpha = selFormat.pointBlinkAlpha;
					fill.color = selFormat.pointBlinkColor;
				}
				else
				{
					fill.alpha = selFormat.pointAlpha;
					fill.color = selFormat.pointColor;
				}
				(blinkObject as IDrawable).draw();
				blinkState = !blinkState;
			}
			else
				blinkObject.alpha = (blinkObject.alpha == 1.0) ? 0.0 : 1.0;
			
				
		}
		
		/** 
		 * Set the blink interval.
		 * 
		 * @param intervalMS - number of microseconds between blinks
		 * @private
		 */
		protected function setBlinkInterval(intervalMS:int):void
		{
			var blinkInterval:int = intervalMS;
			if (blinkInterval == 0)
			{
				// turn off the blinking
				if (blinkTimer)
					blinkTimer.stop();
				if (blinkObject)
					blinkObject.alpha = 1.0;
			}
			else if (blinkTimer)
			{
				blinkTimer.delay = blinkInterval;
				if (blinkObject)
					blinkTimer.start();
			}
		}
		
		/** Draw the caret for a selection 
		 * @param x	x-location where caret is drawn
		 * @param y y-location where caret is drawn
		 * @param w	width of caret
		 * @param h	height of caret
		 * @private
		 */
		public function drawPointSelection(selFormat:SelectionFormat, x:Number,y:Number,w:Number,h:Number):void
		{
//TODO create shape in abstract way
//AJH: probably should be graphicContainer with selection rectangles drawn at offset positions instead
//of positioning a rectangle.
			var selObj:IRect = textFlow.tlfFactory.getRect(selFormat.pointBlendMode);
			
			// Oh, this is ugly. If we are in right aligned text, and there is no padding, and the scrollRect is set, 
			// then in an empty line (or if the point is at the right edge of the line), the blinking cursor is not
			// visible because it is clipped out. Move it in so we can see it. 
			if (_hasScrollRect)
			{
				if (effectiveBlockProgression == BlockProgression.TB)
				{
					if (x >= containerScrollRectRight)
						x -= w;
				} 
				else if (y >= containerScrollRectBottom)
					y -= h;
			}
			
			CONFIG::debug { assert(interactionManager.activePosition == interactionManager.anchorPosition,"bad call to drawPointSelection"); }
			selObj.fill = new SolidColor(selFormat.pointColor);
//			selObj.graphics.beginFill(selFormat.pointColor);
			// pixel snap - works for unscaled text - scaled text will have to accept fuzzy cursors
			selObj.drawRect(0,0,w,h);
			selObj.width = w;
			selObj.height = h;
//			selObj.graphics.drawRect(int(x),int(y),w,h);
//			selObj.graphics.endFill();
			selObj.x = x;
			selObj.y = y;
			
			// make it blink.  But we never blink unless the text is r/w
			if (selFormat.pointBlinkRate != 0 && interactionManager.editingMode == EditingMode.READ_WRITE)
				startBlinkingCursor(selObj, selFormat.pointBlinkRate);
			
			addSelectionChild(selObj);
		}
		
		/** Add cell selection shapes to the displaylist. @private */
		public function addCellSelectionShapes(color:uint, tableBlock:ITextFlowTableBlock, startCoords:CellCoordinates, endCoords:CellCoordinates): void
		{
			if(!tableBlock)
				return;
			if(!startCoords.isValid() || !endCoords.isValid())
				return;
			var cells:Vector.<ITableCellElement> = tableBlock.getCellsInRange(startCoords,endCoords);
			var selObj:IRect = textFlow.tlfFactory.getRect();
			selObj.fill = new SolidColor(color);
//			selObj.graphics.beginFill(color);
			for each( var cell:ITableCellElement in cells)
			{
				var row:ITableRowElement = cell.getRow();
				var r:Rectangle = new Rectangle(cell.x, cell.y + tableBlock.y, cell.width, row.composedHeight);
				selObj.drawRect(r.x,r.y,r.width,r.height);
//				selObj.graphics.drawRect(r.x,r.y,r.width,r.height);
			}
			addSelectionChild(selObj);
		}
		
		/** 
		 * Add cell selection shapes to the displaylist.
		 * */
		public function addCellSelections(cells:Array, color:uint, tableBlock:ITextFlowTableBlock): void
		{
//TODO draw this in a abstract way
			var shape:ICompoundGraphic = textFlow.tlfFactory.getCompoundGraphic();
			shape.fill = new SolidColor(color);
//			shape.graphics.beginFill(color);
			
			for each(var cell:ITableCellElement in cells) {
				var row:ITableRowElement = cell.getRow();
				var rectangle:Rectangle = new Rectangle(cell.x, cell.y + tableBlock.y, cell.width, row.composedHeight);
				shape.drawRect(rectangle.x, rectangle.y, rectangle.width, rectangle.height);
//				shape.graphics.drawRect(rectangle.x, rectangle.y, rectangle.width, rectangle.height);
			}
			
			addSelectionChild(shape);
		}
		
		/** Add selection shapes to the displaylist. @private */
		public function addSelectionShapes(selFormat:SelectionFormat, selectionAbsoluteStart:int, selectionAbsoluteEnd:int): void
		{
			if (!interactionManager || _textLength == 0 || selectionAbsoluteStart == -1 || selectionAbsoluteEnd == -1)
				return;
			
			var prevLine:ITextFlowLine;
			var nextLine:ITextFlowLine;
			
			if (selectionAbsoluteStart != selectionAbsoluteEnd)
			{
				// adjust selectionAbsoluteStart and selectionAbsoluteEnd to be within this controller
				var absoluteControllerStart:int = this.absoluteStart;
				var absoluteControllerEnd:int = this.absoluteStart+this.textLength;
				
				if (selectionAbsoluteStart < absoluteControllerStart)
					selectionAbsoluteStart = absoluteControllerStart;
				else if (selectionAbsoluteStart >= absoluteControllerEnd)
					return;	// nothing to do
				
				// backup one so that 
				if (selectionAbsoluteEnd > absoluteControllerEnd)
					selectionAbsoluteEnd = absoluteControllerEnd;
				else if (selectionAbsoluteEnd < absoluteControllerStart)
					return;	// nothing to do
				
				CONFIG::debug { assert(selectionAbsoluteStart <= selectionAbsoluteEnd,"addSelectionShapes: bad range"); }
				CONFIG::debug { assert(selectionAbsoluteStart >= absoluteControllerStart,"addSelectionShapes: bad range"); }
				CONFIG::debug { assert(selectionAbsoluteEnd <= absoluteControllerEnd,"addSelectionShapes: bad range"); }
				
				var begLine:int = flowComposer.findLineIndexAtPosition(selectionAbsoluteStart);
				var endLine:int = selectionAbsoluteStart == selectionAbsoluteEnd ? begLine : flowComposer.findLineIndexAtPosition(selectionAbsoluteEnd);
				// watch for going past the end
				if (endLine >= flowComposer.numLines)
					endLine = flowComposer.numLines-1;
				
				var selObj:ICompoundGraphic = textFlow.tlfFactory.getCompoundGraphic(selFormat.rangeBlendMode);
				prevLine = begLine ? flowComposer.getLineAt(begLine-1) : null;
				var line:ITextFlowLine = flowComposer.getLineAt(begLine); 
				
				for (var idx:int = begLine; idx <= endLine; idx++)
				{
					nextLine = idx != flowComposer.numLines - 1 ? flowComposer.getLineAt(idx+1) : null;
					
					// 9-1-14 Harbs Do we draw a selection rect for tables? If yes, this needs special handling in TextFlowTableBlock
					line.hiliteBlockSelection(selObj, selFormat, this._container,
						selectionAbsoluteStart < line.absoluteStart ? line.absoluteStart : selectionAbsoluteStart,
						selectionAbsoluteEnd > line.absoluteStart+line.textLength ? line.absoluteStart+line.textLength : selectionAbsoluteEnd, prevLine, nextLine);
					
					var temp:ITextFlowLine = line;
					line = nextLine;
					prevLine = temp;
				}
				
				addSelectionChild(selObj);		
			}
			else
			{
				var lineIdx:int = flowComposer.findLineIndexAtPosition(selectionAbsoluteStart);
				// TODO: there is ambiguity - are we at the end of the currentLine or the beginning of the next one?
				// however must stick to the end of the last line
				if (lineIdx == flowComposer.numLines)
					lineIdx--;
				if (flowComposer.getLineAt(lineIdx).controller == this)
				{
					prevLine = lineIdx != 0 ? flowComposer.getLineAt(lineIdx-1) : null;
					nextLine = lineIdx != flowComposer.numLines-1 ? flowComposer.getLineAt(lineIdx+1) : null;
					flowComposer.getLineAt(lineIdx).hilitePointSelection(selFormat, selectionAbsoluteStart, this._container, prevLine, nextLine);
				}
			}
		}
		
		/** Remove all selection shapes. @private */
		public function clearSelectionShapes(): void
		{
			stopBlinkingCursor();
			
			var selectionSprite:IParentIUIBase = getSelectionSprite(false);
			if (selectionSprite != null)
			{
				if (selectionSprite.parent)
					removeSelectionContainer(selectionSprite);
				while (selectionSprite.numElements > 0)
					selectionSprite.removeElement(selectionSprite.getElementAt(0));
				return;
			}
		}
		
		/** Add a selection child. @private */
		public function addSelectionChild(child:IChild):void
		{
			// If there's no selectionSprite on this controller, we use the parent's.
			// That means we have to translate the coordinates.
			// TODO: this only supports one level of nesting
			var selectionSprite:IParentIUIBase = getSelectionSprite(true);
			
			if (selectionSprite == null)
			{
				return;
			}
			
			var selFormat:SelectionFormat = interactionManager.currentSelectionFormat;
			var curBlendMode:String = (interactionManager.activePosition == interactionManager.anchorPosition) ? selFormat.pointBlendMode : selFormat.rangeBlendMode;
			
			if (textFlow.tlfFactory.getBlendMode(selectionSprite) != curBlendMode)
				textFlow.tlfFactory.setBlendMode(selectionSprite,curBlendMode);
			
			var curAlpha:Number = (interactionManager.activePosition == interactionManager.anchorPosition) ? selFormat.pointAlpha : selFormat.rangeAlpha;
			if (selectionSprite.alpha != curAlpha)
				selectionSprite.alpha = curAlpha;
			
			if (selectionSprite.numElements == 0)
				addSelectionContainer(selectionSprite);
			
			selectionSprite.addElement(child);
		}
		
		/** Test for a selection child. @private */
		public function containsSelectionChild(child:IChild):Boolean
		{ 
			var selectionSprite:IParentIUIBase = getSelectionSprite(false);
			if (selectionSprite == null)
			{
				return false;
			}
			return selectionSprite.getElementIndex(child) > -1; 
		}
		
		/** @private */
		public function getBackgroundShape():IUIBase
		{
			if(!_backgroundShape)
			{
//TODO generalize
				_backgroundShape = textFlow.tlfFactory.getCompoundGraphic();
				addBackgroundShape(_backgroundShape);
			}
			
			return _backgroundShape;
		}
		
	/*	CONFIG::debug private function containsFloats(textFlow:TextFlow):Boolean
		{
			if (textFlow)
				for (var leaf:FlowLeafElement = textFlow.getFirstLeaf(); leaf != null; leaf = leaf.getNextLeaf())
					if (leaf is InlineGraphicElement && InlineGraphicElement(leaf).float != Float.NONE)
						return true;
			return false;
		} */
		
		/** @private */
		public function getEffectivePaddingLeft():Number
		{ return computedFormat.paddingLeft == FormatValue.AUTO ? computedFormat.borderLeftWidth + computedFormat.marginLeft : computedFormat.paddingLeft + computedFormat.borderLeftWidth + computedFormat.marginLeft; }
		/** @private */
		public function getEffectivePaddingRight():Number
		{ return computedFormat.paddingRight == FormatValue.AUTO ? computedFormat.borderRightWidth + computedFormat.marginRight : computedFormat.paddingRight + computedFormat.borderRightWidth + computedFormat.marginRight; }
		/** @private */
		public function getEffectivePaddingTop():Number
		{ return computedFormat.paddingTop == FormatValue.AUTO ? computedFormat.borderTopWidth + computedFormat.marginTop : computedFormat.paddingTop + computedFormat.borderTopWidth + computedFormat.marginTop; }
		/** @private */
		public function getEffectivePaddingBottom():Number
		{ return computedFormat.paddingBottom == FormatValue.AUTO ? computedFormat.borderBottomWidth + computedFormat.marginBottom : computedFormat.paddingBottom + computedFormat.borderBottomWidth + computedFormat.marginBottom; }
		
		/** @private */
		public function getTotalPaddingLeft():Number
		{ return getEffectivePaddingLeft() + (_rootElement ? _rootElement.getEffectivePaddingLeft() : 0); }
		/** @private */
		public function getTotalPaddingRight():Number
		{ return getEffectivePaddingRight() + (_rootElement ? _rootElement.getEffectivePaddingRight() : 0); }
		/** @private */
		public function getTotalPaddingTop():Number
		{ return getEffectivePaddingTop() + (_rootElement ? _rootElement.getEffectivePaddingTop() : 0); }
		/** @private */
		public function getTotalPaddingBottom():Number
		{ return getEffectivePaddingBottom() + (_rootElement ? _rootElement.getEffectivePaddingBottom() : 0); }
		
		private var _selectionSprite:IParentIUIBase;
		
		/** @private */
		public function getSelectionSprite(createForDrawing:Boolean):IParentIUIBase
		{
			if (createForDrawing)
			{
				if (_selectionSprite == null)
				{
					_selectionSprite = textFlow.tlfFactory.getContainer();
//					_selectionSprite.mouseEnabled = false;
//					_selectionSprite.mouseChildren = false;
				}
			}
			return _selectionSprite;
		}
		
		static private function createContainerControllerInitialFormat():ITextLayoutFormat
		{
			var ccif:TextLayoutFormat = new TextLayoutFormat();
			ccif.columnCount = FormatValue.INHERIT;
			ccif.columnGap = FormatValue.INHERIT;
			ccif.columnWidth = FormatValue.INHERIT;
			ccif.verticalAlign = FormatValue.INHERIT;
			return ccif;
		}
		
		static private var _containerControllerInitialFormat:ITextLayoutFormat;
		
		/** 
		* @private
		* Specifies the initial format (ITextLayoutFormat instance) for a new ContainerController. The runtime
		* applies this to the format property of all new containers on creation.
		*
		* By default, sets the column format values to "inherit"; all other format values are inherited.
		*
		* @playerversion Flash 10
		* @playerversion AIR 1.5
		* @langversion 3.0
		*
		* @see org.apache.royale.textLayout.elements.TextFlow TextFlow
		*/
		
		static public function get containerControllerInitialFormat():ITextLayoutFormat
		{
			if(_containerControllerInitialFormat == null)
				_containerControllerInitialFormat = createContainerControllerInitialFormat();
			
			return _containerControllerInitialFormat;
		}
		static public function set containerControllerInitialFormat(val:ITextLayoutFormat):void
		{ _containerControllerInitialFormat = val; }
		
		
		/** @private */
		protected function get attachTransparentBackground():Boolean
		{ return true; }
		
		/** @private */
		public function clearCompositionResults():void
		{
			setTextLength(0); 
			
			for each (var line:* in _shapeChildren)
			{
				if(line is ITextLine)
					removeTextLine(line as ITextLine);
				else
					removeTableBlock(line as TableBlockContainer);
				CONFIG::debug { Debugging.traceFTECall(null,_container,"removeTextLine",line); }
			}
			_shapeChildren.length = 0;
			_linesInView.length = 0;
			if (_floatsInContainer)
				_floatsInContainer.length = 0;
			if (_composedFloats)
				_composedFloats.length = 0;
		//	trace("clear composedFloats for container", flowComposer ? flowComposer.getControllerIndex(this) : 0);
		}
		private static var _scratchRectangle:Rectangle;
		private static function get scratchRectangle():Rectangle{
			if(_scratchRectangle == null)
				_scratchRectangle = new Rectangle();
			
			return _scratchRectangle;
		}
		
		private function intersperseTableBlocks(targetArray:Array):void{
			if(_tableBlocksInView.length == 0)
				return;
			var blockIdx:int = 0;
			var startLoc:int = (_tableBlocksInView[0] as TableBlockContainer).userData.parentTable.getAbsoluteStart();
			for(var i:int=0;i<targetArray.length;i++){
				if( targetArray[i].userData.absoluteStart < startLoc )
					continue;
				targetArray.splice(i,0,_tableBlocksInView[blockIdx++]);
				if(blockIdx == _tableBlocksInView.length)
					break;
			}
			while(blockIdx < _tableBlocksInView.length)
				targetArray.push(_tableBlocksInView[blockIdx++]);
		}
		/**
		 *  Add DisplayObjects that were created by composition to the container.
		 *  @private 
		 * @royaleignorecoercion org.apache.royale.textLayout.compose.ITextFlowTableBlock
		 */
		public function updateCompositionShapes():void
		{
			if(!shapesInvalid)
			{
				return;
			}			
			
			// reclamp vertical/horizontal scrollposition - addresses Watson 2380962
			var originalYScroll:Number = _yScroll;
			if (verticalScrollPolicy != ScrollPolicy.OFF && !_measureHeight)
				_yScroll = computeVerticalScrollPosition(_yScroll,false);
			var originalXScroll:Number = _xScroll;
			if (horizontalScrollPolicy != ScrollPolicy.OFF && !_measureWidth)
				_xScroll = computeHorizontalScrollPosition(_xScroll,false);
			var scrolled:Boolean = (originalYScroll != _yScroll || originalXScroll != _xScroll);	// true if scroll values were changed - we need to notify in this case
			
			// If we've scrolled, force all lines to be regathered since lines may now be in view that
			// previously were not.
			if (scrolled)
				_linesInView.length = 0;
			
			// Post all the new TextLines to the display list, and remove any old TextLines left from last time. Do this
			// in a non-destructive way so that lines that have not been changed are not touched. This reduces redraw time.
			fillShapeChildren();
			var newShapeChildren:Array = _linesInView;
			
			// Add in table blocks
			intersperseTableBlocks(newShapeChildren);
			
			var childIdx:int = getFirstTextLineChildIndex(); // index where the first text line must appear at in its container  
			var newIdx:int = 0;		// offset into newShapeChildren
			var shapeChildrenStartIdx:int = 0;	// starting offset into shapeChildren

			// If we composed starting at the middle of the container, then _linesInView will contain only the lines that were
			// in view and changed. In that case, we want to skip the lines in the beginning that weren't changed, and start 
			// the iteration from the point where the new lines start. So we get the first new line, go back one, and find where
			// we are in the old list. If the line before the first new line was not displayed before, thenwe start from the 
			// beginning as usual. This can happen if we're scrolled forward, and then edit the first visible line.
			if (_updateStart > absoluteStart && newShapeChildren.length > 0)
			{
				var firstLine:ITextFlowLine = ITextFlowLine(newShapeChildren[0].userData);
				var prevLine:ITextFlowLine = flowComposer.findLineAtPosition(firstLine.absoluteStart - 1);
				if(prevLine is ITextFlowTableBlock){
					shapeChildrenStartIdx = _shapeChildren.indexOf((prevLine as ITextFlowTableBlock).container);
				} else {
					var prevTextLine:ITextLine = prevLine.peekTextLine(); 
					shapeChildrenStartIdx = _shapeChildren.indexOf(prevTextLine);
				}
				if (shapeChildrenStartIdx >= 0)
				{
					shapeChildrenStartIdx++;
					childIdx += shapeChildrenStartIdx;
				}
				else
					shapeChildrenStartIdx = 0;
			}
			var oldIdx:int = shapeChildrenStartIdx;		// offset into shapeChildren
			
			while (newIdx != newShapeChildren.length)
			{
				var newChild:* = newShapeChildren[newIdx];
				if (newChild == _shapeChildren[oldIdx])
				{
					// Same shape is in both lists, no change necessary, advance to next item in each list
					CONFIG::debug { assert(newChild.parent == _container, "updateCompositionShapes expected line was already a child of the container"); }
					childIdx++;
					newIdx++;
					oldIdx++;
					if(newChild is TableBlockContainer)
					{
						// update the contents in case cells were added or removed. (There might be a more efficient way to do this, but this works.)
						(newChild as TableBlockContainer).userData.updateCompositionShapes();
					}
					continue;
				}
				var newChildIdx:int = _shapeChildren.indexOf(newChild);
				if(newChild is ITextLine){
					if (newChildIdx == -1)
					{
						// Shape is in the new list, but not in the old list, add it to the display list at the current location, and advance to next item
						addTextLine((newChild as ITextLine), childIdx++);
						CONFIG::debug { Debugging.traceFTECall(null,_container,"addTextLine",newChild); }
						newIdx++;
					}
					else
					{
						// The shape is on both lists, but there are several intervening "old" shapes in between. We'll remove the old shapes that
						// come before the new one we want to insert.
						removeAndRecycleTextLines (oldIdx, newChildIdx);
						oldIdx = newChildIdx;
					}
				} else {// it's a table block
					if (newChildIdx == -1)
					{
						// Shape is in the new list, but not in the old list, add it to the display list at the current location, and advance to next item
						addTableBlock((newChild as TableBlockContainer), childIdx++);
						CONFIG::debug { Debugging.traceFTECall(null,_container,"addTableBlock",newChild); }
						newIdx++;
					}
					else
					{
						// The shape is on both lists, but there are several intervening "old" shapes in between. We'll remove the old shapes that
						// come before the new one we want to insert.
						(newChild as TableBlockContainer).userData.updateCompositionShapes();
						removeAndRecycleTextLines (oldIdx, newChildIdx);
						oldIdx = newChildIdx;
					}					
				}
			}
			
			// remove any trailing children no longer displayed
			removeAndRecycleTextLines (oldIdx, _shapeChildren.length);
			
			// Update shapeChildren to reflect all these changes
			if (shapeChildrenStartIdx > 0)
			{
				// We only updated some of the lines. Remove the old versions off the end, and add in the new ones from _linesInView
				_shapeChildren.length = shapeChildrenStartIdx;		// truncate
				//_shapeChildren = _shapeChildren.concat(_linesInView);	// append _linesInView to end of _shapeChildren
				_shapeChildren = _shapeChildren.concat(newShapeChildren);	// append _linesInView to end of _shapeChildren
				_linesInView.length = 0;	// truncate
			}
			else
			{	// We updated all of the lines. 
				_linesInView = _shapeChildren;		// move the old array over to _linesInView, so we reuse its storage
				_linesInView.length = 0;
				_shapeChildren = newShapeChildren;
			}

			if ((_floatsInContainer && _floatsInContainer.length > 0) || (_composedFloats && _composedFloats.length > 0))
				updateGraphics(_updateStart);
			
			shapesInvalid = false;
			
			// _textFrame.updateVisibleRectangle(this._visibleRect);
			updateVisibleRectangle();
			
			var tf:ITextFlow = this.textFlow;
			// Set the Ctrl key condition
			var needsCtrlKey:Boolean = (interactionManager != null && interactionManager.editingMode == EditingMode.READ_WRITE);
			// Generate the hit test area for the LinkElements of the visible lines
			var firstVisibleLine:ITextFlowLine = getFirstVisibleLine();
			var lastVisibleLine:ITextFlowLine = getLastVisibleLine();
			scratchRectangle.left = _contentLeft; 
			scratchRectangle.top = _contentTop; 
			scratchRectangle.width = _contentWidth; 
			scratchRectangle.height = _contentHeight; 
			_mouseEventManager.updateHitTests(effectiveBlockProgression == BlockProgression.RL && _hasScrollRect ? _contentWidth : 0, 
				scratchRectangle, tf, 
				firstVisibleLine ? firstVisibleLine.absoluteStart : _absoluteStart, 
				lastVisibleLine ? lastVisibleLine.absoluteStart + lastVisibleLine.textLength - 1 : _absoluteStart, 
				this,
				needsCtrlKey);
			
			_updateStart = _rootElement.textLength;

			// If we're measuring, then the measurement values may have changed since last time.
			// Force the transparent background to redraw, so that mouse events will work for the 
			// entire content area.
			if (_measureWidth || _measureHeight)
				attachTransparentBackgroundForHit(false);
			
			if (tf.backgroundManager)
			{
				tf.backgroundManager.onUpdateComplete(this);
			}
			
			// If we updated the scroll values, we need to send an event
			if (scrolled && tf.hasEventListener(TextLayoutEvent.SCROLL))
			{
				if (originalYScroll != _yScroll)
					tf.dispatchEvent(new ScrollEvent(TextLayoutEvent.SCROLL, false, false, ScrollEventDirection.VERTICAL, _yScroll - originalYScroll));
				if (originalXScroll != _xScroll)
					tf.dispatchEvent(new ScrollEvent(TextLayoutEvent.SCROLL, false, false, ScrollEventDirection.HORIZONTAL, _xScroll - originalXScroll));
			}
			
			if (tf.hasEventListener(UpdateCompleteEvent.UPDATE_COMPLETE))
			{
				tf.dispatchEvent(new UpdateCompleteEvent(UpdateCompleteEvent.UPDATE_COMPLETE,false,false,tf, this));
			}
			
		//	CONFIG::debug { validateLines(); }
		} 
		
		CONFIG::debug private function updateGraphicsCheck(previousGraphics:Array):void
		{
			var graphicDisplayObject:IUIBase;
			var flowComposer:IFlowComposer = textFlow.flowComposer;
			
			// correctness check
			// iterate all graphics
			// for each one: is it visible?
			// if so, it should be a descendent of the container
			// if not, it should NOT be a descendent of the container

			// iterate all graphics previously visible
			// for each one: is it in the composedGraphics list?
			// if not, it should NOT be a descendent of the container
//TODO commented this out due to commenting out the assert
//			for each (graphicDisplayObject in previousGraphics)
//			{
//				if (getIndexOfFloat(graphicDisplayObject) < 0)
//					assert(!container.contains(graphicDisplayObject), "Previously visible graphic should have been removed from display list");
//			}

			// Calculate the last possible anchor position for a visible float. The float can't be past the line *after* the last line.
			// In case that's an uncomposed line with the entire rest of the TextFlow in it, we cap what we'll look at to 2000 chars
			// past the last visible line end. This keeps us from iterating forever in a long text flow.
			//	var followingLineIndex:int = flowComposer.findLineIndexAtPosition(lastVisiblePosition) + 1;
			var firstLine:ITextFlowLine = getFirstVisibleLine();
			var lastLine:ITextFlowLine = getLastVisibleLine();
			var firstVisiblePosition:int = firstLine ? firstLine.absoluteStart : this.absoluteStart;
			var lastVisiblePosition:int = lastLine ? lastLine.absoluteStart + lastLine.textLength : this.absoluteStart + textLength;
			var followingLine:ITextFlowLine = flowComposer.findLineAtPosition(lastVisiblePosition);
			var lastPossibleFloatPosition:int = followingLine ? followingLine.absoluteStart + followingLine.textLength : this.absoluteStart + textLength;
			lastPossibleFloatPosition = Math.min(lastPossibleFloatPosition, this.absoluteStart + textLength);
			lastPossibleFloatPosition = Math.min(lastPossibleFloatPosition, lastVisiblePosition + 2000);
			lastPossibleFloatPosition = Math.min(lastPossibleFloatPosition, flowComposer.damageAbsoluteStart);
			CONFIG::debug { assert(lastPossibleFloatPosition <= this.absoluteStart + textLength, "Expected lastPossibleFloatPosition to be before end of container"); }
			
			// Get visible area
			var wmode:String = effectiveBlockProgression;
			var width:Number = _measureWidth ? _contentWidth : _compositionWidth;
			var height:Number = _measureHeight ? _contentHeight : _compositionHeight;
			var adjustX:Number = (wmode == BlockProgression.RL) ? _xScroll - width : _xScroll;
			var adjustY:Number = _yScroll;
			
			var numGraphics:int = _composedFloats.length;
			for (var graphicIndex:int = 0; graphicIndex < numGraphics; ++graphicIndex)
			{
				var floatInfo:FloatCompositionData = _composedFloats[graphicIndex];
				graphicDisplayObject = floatInfo.graphic;
				
				var shouldDisplayGraphic:Boolean;
				if (!graphicDisplayObject)
					shouldDisplayGraphic = false;
				else 
				{
					if (floatInfo.floatType == Float.NONE)
						shouldDisplayGraphic = floatInfo.absolutePosition >= firstVisiblePosition && floatInfo.absolutePosition < lastVisiblePosition;
					else
						shouldDisplayGraphic = floatIsVisible(wmode, adjustX, adjustY, width, height, floatInfo) && floatInfo.absolutePosition < lastPossibleFloatPosition && floatInfo.absolutePosition >= this.absoluteStart;
				}
				
				if (shouldDisplayGraphic)
					assert(shouldDisplayGraphic == container.getElementIndex(graphicDisplayObject) > -1 , 
						shouldDisplayGraphic ? "Graphic should be in view, but is not a descendent of the container" : "Graphic should not be in view, but is a descendent of the container");
			}
		}
		
		
		/**
		 *  @royaleignorecoercion org.apache.royale.core.IParentIUIBase
		 *  @royaleignorecoercion org.apache.royale.core.IUIBase
		 */		
		public function updateGraphics(updateStart:int):void
		{
			var inlineHolder:IParentIUIBase;
			
			var visibleFloats:Array = [];
			
			// If we have new floats that have been composed into container, we add them here.
			// Also, we remove any that are no longer in the container. Only change those
			// floats that are within the area that was recomposed.
			
			var floatInfo:FloatCompositionData;
			var float:IUIBase;
			var firstLine:ITextFlowLine = getFirstVisibleLine();
			var lastLine:ITextFlowLine = getLastVisibleLine();
			var firstVisiblePosition:int = firstLine ? firstLine.absoluteStart : this.absoluteStart;
			var lastVisiblePosition:int = lastLine ? lastLine.absoluteStart + lastLine.textLength : this.absoluteStart + textLength;

			// Calculate the last possible anchor position for a visible float. The float can't be past the line *after* the last line.
			// In case that's an uncomposed line with the entire rest of the TextFlow in it, we cap what we'll look at to 2000 chars
			// past the last visible line end. This keeps us from iterating forever in a long text flow.
		//	var followingLineIndex:int = flowComposer.findLineIndexAtPosition(lastVisiblePosition) + 1;
			var followingLine:ITextFlowLine = flowComposer.findLineAtPosition(lastVisiblePosition);
			var lastPossibleFloatPosition:int = followingLine ? followingLine.absoluteStart + followingLine.textLength : this.absoluteStart + textLength;
			lastPossibleFloatPosition = Math.min(lastPossibleFloatPosition, this.absoluteStart + textLength);
			lastPossibleFloatPosition = Math.min(lastPossibleFloatPosition, lastVisiblePosition + 2000);
			lastPossibleFloatPosition = Math.min(lastPossibleFloatPosition, flowComposer.damageAbsoluteStart);
			CONFIG::debug { assert(lastPossibleFloatPosition <= this.absoluteStart + textLength, "Expected lastPossibleFloatPosition to be before end of container"); }
			
			// Get visible area
			var wmode:String = effectiveBlockProgression;
			var width:Number = _measureWidth ? _contentWidth : _compositionWidth;
			var height:Number = _measureHeight ? _contentHeight : _compositionHeight;
			var adjustX:Number = (wmode == BlockProgression.RL) ? _xScroll - width : _xScroll;
			var adjustY:Number = _yScroll;

			var floatIndex:int = findFloatIndexAtOrAfter(updateStart);
			var containerListIndex:int = 0;
			var childIdx:int = getFirstTextLineChildIndex(); // index where the first text line must appear at in its container  
			if (floatIndex > 0)		
			{
				// starting from the middle, need to skip over the initial entries already in the 
				// container list that are not being changed. Add them to the list of visible graphics, so they don't get dropped off.
				floatInfo = _composedFloats[floatIndex - 1];
				containerListIndex = _floatsInContainer.indexOf(floatInfo.graphic);
				while (containerListIndex == -1 && floatIndex > 0)
				{
					// Graphic anchor point appears earlier in the text, but the float isn't (or wasn't previously) visible
					--floatIndex;
					floatInfo = _composedFloats[floatIndex];
					containerListIndex = _floatsInContainer.indexOf(floatInfo.graphic);
				}
				containerListIndex++;
				CONFIG::debug { assert(containerListIndex >= 0, "Can't find previously visible float"); }
				for (var m:int = 0; m < floatIndex; ++m)
				{
					CONFIG::debug { assert(_composedFloats[m].absolutePosition >= this.absoluteStart, "Found float from previous container"); }
					if (_composedFloats[m].absolutePosition >= this.absoluteStart)
						visibleFloats.push(_composedFloats[m].graphic);
				}
			}
//			var firstContainerListIndex:int = containerListIndex;
			if (!_floatsInContainer)
				_floatsInContainer = [];
			var numContainerList:int = _floatsInContainer.length;
			
			CONFIG::debug
			{
				var oldChanges:Array = [];
				var visibleAtEnd:Array = [];
				oldUpdateGraphics(_updateStart, oldChanges, visibleAtEnd);
//				var changeIndex:int = 0;
//				var originalAlgorithmChange:Array;
//				var matrix:Matrix;
//				var oldMatrix:Matrix;
				var changes:Array = [];
			}

			// Add in the floats from the last compose, at the composed location
			var numFloats:int = _composedFloats.length;
			for (; floatIndex < numFloats; )
			{
				floatInfo = _composedFloats[floatIndex];
				float = floatInfo.graphic;
				var parent:IParentIUIBase = floatInfo.parent;
				var shouldDisplayGraphic:Boolean;
				if (!float)
					shouldDisplayGraphic = false;
				else 
				{
					if (floatInfo.floatType == Float.NONE)
						shouldDisplayGraphic = floatInfo.absolutePosition >= firstVisiblePosition && floatInfo.absolutePosition < lastVisiblePosition;
					else
						shouldDisplayGraphic = floatIsVisible(wmode, adjustX, adjustY, width, height, floatInfo) && floatInfo.absolutePosition < lastPossibleFloatPosition && floatInfo.absolutePosition >= this.absoluteStart;
				}
				
				if (!shouldDisplayGraphic)		// skip to the next
				{
					// Float may be after the last visible line and still visible if it is anchored to the following line because it was too wide for the column,
					// so we don't stop iterating until we've gone at least one line past the last visible line.
					if (floatInfo.absolutePosition >= lastPossibleFloatPosition)
						break;
					++floatIndex;
					continue;
				}
				
				// If we had to remove some no-longer visible graphics, we might have already gone past this graphic before. Only add once.
				if (visibleFloats.indexOf(float) < 0)
					visibleFloats.push(float);
				
				// If it's an inline, the ITextLine in the FloatCompositionData may have been replaced. Check for this and get a new line if necessary.
				if (floatInfo.floatType == Float.NONE)
				{
					// Check to see if the ITextLine has changed
					var tl:ITextLine = parent as ITextLine;
					if (tl)
					{
						var tfl:ITextFlowLine = tl.userData as ITextFlowLine;
						if (!tfl || floatInfo.absolutePosition < tfl.absoluteStart || floatInfo.absolutePosition >= tfl.absoluteStart + tfl.textLength || tl.parent == null || tl.validity == "invalid")
						{
							// ITextLine doesn't match ITextFlowLine -- refetch the ITextLine
							tfl = flowComposer.findLineAtPosition(floatInfo.absolutePosition);

							for (var i:int = 0; i < _shapeChildren.length; i++) 
								if ((_shapeChildren[i] as ITextLine).userData == tfl)		// if this is coded into the loop condition we get a warning
									break;
							parent = (i < _shapeChildren.length) ? _shapeChildren[i] : null;
						}
					}
				}

				inlineHolder = float.parent as IParentIUIBase;

				// Float is already visible in the right place in the z-order, leave it but update its position
				if (containerListIndex < numContainerList && floatInfo.parent == _container && inlineHolder && inlineHolder.parent == _container && float == _floatsInContainer[containerListIndex])
				{
//TODO deal with transforms
//					if (floatInfo.matrix)
//						inlineHolder.transform.matrix = floatInfo.matrix;
//					else
//					{
						inlineHolder.x = 0;
						inlineHolder.y = 0;
//					}
					inlineHolder.alpha = floatInfo.alpha;
					inlineHolder.x += floatInfo.x;
					inlineHolder.y += floatInfo.y;
					CONFIG::debug { assert(inlineHolder.getElementIndex(float) > -1, "expected float is already in display list"); }
//					CONFIG::debug  { changes.push(["update", floatInfo.absolutePosition, inlineHolder.transform.matrix ? inlineHolder.transform.matrix.clone() : null, inlineHolder.alpha, inlineHolder.x, inlineHolder.y]);  }
					++floatIndex;
					++containerListIndex;
					continue;
				}
				var index:int = _floatsInContainer.indexOf(float);
				if (index > containerListIndex && parent == _container)		// it's in the existing list, but not yet, remove the old items from the container
				{
					var floatToRemove:IUIBase = _floatsInContainer[containerListIndex++];
					if (floatToRemove.parent)
					{
						CONFIG::debug { changes.push(["remove", getIndexOfFloat(floatToRemove), floatToRemove, "going to add float", (floatToRemove.parent as IParentIUIBase).parent is ITextLine ? "removing inline" : "removing float"]);  }
						removeInlineGraphicElement(floatInfo.parent, floatToRemove.parent as IUIBase);
					}
				}
				else					
				{
					if (containerListIndex < numContainerList &&  float == _floatsInContainer[containerListIndex])		// it was previously a Float.NONE; so we don't want to remove it later
						containerListIndex++;
//TODO abstract this
					inlineHolder = textFlow.tlfFactory.getContainer();
//TODO deal with transforms
//					if (floatInfo.matrix)
//						inlineHolder.transform.matrix = floatInfo.matrix;
					inlineHolder.alpha = floatInfo.alpha;
					inlineHolder.x += floatInfo.x;
					inlineHolder.y += floatInfo.y;
					inlineHolder.addElement(float);
//					CONFIG::debug { changes.push(["add", floatInfo.absolutePosition, parent, parent == _container ? childIdx : 0,  
//						inlineHolder.transform.matrix ? inlineHolder.transform.matrix.clone() : null, inlineHolder.alpha, inlineHolder.x, inlineHolder.y]); }
					if (parent == _container)		// it's float - add to container
					{
						childIdx = Math.min(childIdx, _container.numElements);
						addInlineGraphicElement(_container, inlineHolder, childIdx++);
					}
					else	// it's an inline - add to ITextLine
						addInlineGraphicElement(parent, inlineHolder, 0);
					++floatIndex;
				}
			}
			while (containerListIndex < _floatsInContainer.length)		// remove trailing items
			{
				float = _floatsInContainer[containerListIndex++];
				if (float.parent && visibleFloats.indexOf(float) < 0)
				{
					CONFIG::debug { changes.push(["remove", getIndexOfFloat(float), float, "removeTrailing", float.parent is ITextLine ? "removing inline" : "removing float"]);  }
					removeInlineGraphicElement((float.parent as IParentIUIBase).parent as IParentIUIBase, float.parent as IParentIUIBase);
				}
			}
			
			CONFIG::debug { updateGraphicsCheck(_floatsInContainer); }
			
			// Update the container list
			_floatsInContainer = visibleFloats;

		//	CONFIG::debug { compareUpdateGraphicsResults(changes, oldChanges, _floatsInContainer, visibleAtEnd); }
		} 

		/*
		public function updateGraphics(updateStart:int):void
		{
			var inlineHolder:DisplayObjectContainer;
			
			var visibleFloats:Array = [];
			
			// If we have new floats that have been composed into container, we add them here.
			// Also, we remove any that are no longer in the container. Only change those
			// floats that are within the area that was recomposed.
			
			var floatInfo:FloatCompositionData;
			var float:DisplayObject;
			var firstLine:ITextFlowLine = getFirstVisibleLine();
			var lastLine:ITextFlowLine = getLastVisibleLine();
			var firstVisiblePosition:int = firstLine ? firstLine.absoluteStart : this.absoluteStart;
			var lastVisiblePosition:int = lastLine ? lastLine.absoluteStart + lastLine.textLength : this.absoluteStart + textLength;
			
			// Calculate the last possible anchor position for a visible float. The float can't be past the line *after* the last line.
			// In case that's an uncomposed line with the entire rest of the TextFlow in it, we cap what we'll look at to 2000 chars
			// past the last visible line end. This keeps us from iterating forever in a long text flow.
			//	var followingLineIndex:int = flowComposer.findLineIndexAtPosition(lastVisiblePosition) + 1;
			var followingLine:ITextFlowLine = flowComposer.findLineAtPosition(lastVisiblePosition);
			var lastPossibleFloatPosition:int = followingLine ? followingLine.absoluteStart + followingLine.textLength : this.absoluteStart + textLength;
			lastPossibleFloatPosition = Math.min(lastPossibleFloatPosition, this.absoluteStart + textLength);
			lastPossibleFloatPosition = Math.min(lastPossibleFloatPosition, lastVisiblePosition + 2000);
			lastPossibleFloatPosition = Math.min(lastPossibleFloatPosition, flowComposer.damageAbsoluteStart);
			CONFIG::debug { assert(lastPossibleFloatPosition <= this.absoluteStart + textLength, "Expected lastPossibleFloatPosition to be before end of container"); }
			
			// Get visible area
			var wmode:String = effectiveBlockProgression;
			var width:Number = _measureWidth ? _contentWidth : _compositionWidth;
			var height:Number = _measureHeight ? _contentHeight : _compositionHeight;
			var adjustX:Number = (wmode == BlockProgression.RL) ? _xScroll - width : _xScroll;
			var adjustY:Number = _yScroll;
			
			var floatIndex:int = findFloatIndexAtOrAfter(updateStart);
			var containerListIndex:int = 0;
			var childIdx:int = getFirstTextLineChildIndex(); // index where the first text line must appear at in its container  
			if (floatIndex > 0)		
			{
				// starting from the middle, need to skip over the initial entries already in the 
				// container list that are not being changed. Add them to the list of visible graphics, so they don't get dropped off.
				floatInfo = _composedFloats[floatIndex - 1];
				containerListIndex = _floatsInContainer.indexOf(floatInfo.graphic);
				while (containerListIndex == -1 && floatIndex > 0)
				{
					// Graphic anchor point appears earlier in the text, but the float isn't (or wasn't previously) visible
					floatIndex--;
					floatInfo = _composedFloats[floatIndex - 1];
					containerListIndex = _floatsInContainer.indexOf(floatInfo.graphic);
				}
				CONFIG::debug { assert(containerListIndex != -1, "Can't find previously visible float"); }
				containerListIndex++;
				for (var m:int = 0; m < floatIndex; ++m)
				{
					CONFIG::debug { assert(_composedFloats[m].absolutePosition >= this.absoluteStart, "Found float from previous container"); }
					if (_composedFloats[m].absolutePosition >= this.absoluteStart)
						visibleFloats.push(_composedFloats[m].graphic);
				}
			}
			var firstContainerListIndex:int = containerListIndex;
			if (!_floatsInContainer)
				_floatsInContainer = [];
			var numContainerList:int = _floatsInContainer.length;
			
			CONFIG::debug
			{
				var oldChanges:Array = [];
				var visibleAtEnd:Array = [];
				oldUpdateGraphics(_updateStart, oldChanges, visibleAtEnd);
				var changeIndex:int = 0;
				var originalAlgorithmChange:Array;
				var matrix:Matrix;
				var oldMatrix:Matrix;
				var changes:Array = [];
			}
			
			// Add in the floats from the last compose, at the composed location
			var numFloats:int = _composedFloats.length;
			for (; floatIndex < numFloats; )
			{
				floatInfo = _composedFloats[floatIndex];
				float = floatInfo.graphic;
				var parent:DisplayObjectContainer = floatInfo.parent;
				var shouldDisplayGraphic:Boolean;
				if (!float)
					shouldDisplayGraphic = false;
				else 
				{
					if (floatInfo.floatType == Float.NONE)
						shouldDisplayGraphic = floatInfo.absolutePosition >= firstVisiblePosition && floatInfo.absolutePosition < lastVisiblePosition;
					else
						shouldDisplayGraphic = floatIsVisible(wmode, adjustX, adjustY, width, height, floatInfo) && floatInfo.absolutePosition < lastPossibleFloatPosition && floatInfo.absolutePosition >= this.absoluteStart;
				}
				
				if (!shouldDisplayGraphic)		// skip to the next
				{
					// Float may be after the last visible line and still visible if it is anchored to the following line because it was too wide for the column,
					// so we don't stop iterating until we've gone at least one line past the last visible line.
					if (floatInfo.absolutePosition >= lastPossibleFloatPosition)
						break;
					++floatIndex;
					continue;
				}
				
				// If we had to remove some no-longer visible graphics, we might have already gone past this graphic before. Only add once.
				if (visibleFloats.indexOf(float) < 0)
					visibleFloats.push(float);
				
				// If it's an inline, the ITextLine in the FloatCompositionData may have been replaced. Check for this and get a new line if necessary.
				if (floatInfo.floatType == Float.NONE)
				{
					// Check to see if the ITextLine has changed
					var tl:ITextLine = parent as ITextLine;
					if (tl)
					{
						var tfl:ITextFlowLine = tl.userData as ITextFlowLine;
						if (!tfl || floatInfo.absolutePosition < tfl.absoluteStart || floatInfo.absolutePosition >= tfl.absoluteStart + tfl.textLength || tl.parent == null || tl.validity == "invalid")
						{
							// ITextLine doesn't match ITextFlowLine -- refetch the ITextLine
							tfl = flowComposer.findLineAtPosition(floatInfo.absolutePosition);
							
							for (var i:int = 0; i < _shapeChildren.length; i++) 
								if ((_shapeChildren[i] as ITextLine).userData == tfl)		// if this is coded into the loop condition we get a warning
									break;
							parent = (i < _shapeChildren.length) ? _shapeChildren[i] : null;
						}
					}
				}
				
				inlineHolder = float.parent;
				
				// Float is already visible in the right place in the z-order, leave it but update its position
				if (containerListIndex < numContainerList && floatInfo.parent == _container && inlineHolder && inlineHolder.parent == _container && float == _floatsInContainer[containerListIndex])
				{
					if (floatInfo.matrix)
						inlineHolder.transform.matrix = floatInfo.matrix;
					else
					{
						inlineHolder.x = 0;
						inlineHolder.y = 0;
					}
					inlineHolder.alpha = floatInfo.alpha;
					inlineHolder.x += floatInfo.x;
					inlineHolder.y += floatInfo.y;
					CONFIG::debug { assert(inlineHolder.contains(float), "expected float is already in display list"); }
					CONFIG::debug  { changes.push(["update", floatInfo.absolutePosition, inlineHolder.transform.matrix ? inlineHolder.transform.matrix.clone() : null, inlineHolder.alpha, inlineHolder.x, inlineHolder.y]);  }
					++floatIndex;
					++containerListIndex;
					continue;
				}
				var index:int = _floatsInContainer.indexOf(float);
				if (index > containerListIndex && parent == _container)		// it's in the existing list, but not yet, remove the old items from the container
				{
					var floatToRemove:DisplayObject = _floatsInContainer[containerListIndex++];
					if (floatToRemove.parent)
					{
						CONFIG::debug { changes.push(["remove", getIndexOfFloat(floatToRemove), floatToRemove, "going to add float", floatToRemove.parent.parent is ITextLine ? "removing inline" : "removing float"]);  }
						removeInlineGraphicElement(_container, floatToRemove.parent);
					}
				}
				else					
				{
					if (containerListIndex < numContainerList &&  float == _floatsInContainer[containerListIndex])		// it was previously a Float.NONE; so we don't want to remove it later
						containerListIndex++;
					
					inlineHolder = new Sprite();
					if (floatInfo.matrix)
						inlineHolder.transform.matrix = floatInfo.matrix;
					inlineHolder.alpha = floatInfo.alpha;
					inlineHolder.x += floatInfo.x;
					inlineHolder.y += floatInfo.y;
					inlineHolder.addChild(float);
					CONFIG::debug { changes.push(["add", floatInfo.absolutePosition, parent, parent == _container ? childIdx : 0,  
						inlineHolder.transform.matrix ? inlineHolder.transform.matrix.clone() : null, inlineHolder.alpha, inlineHolder.x, inlineHolder.y]); }
					if (parent == _container)		// it's float - add to container
					{
						childIdx = Math.min(childIdx, _container.numChildren);
						addInlineGraphicElement(_container, inlineHolder, childIdx++);
					}
					else	// it's an inline - add to ITextLine
						addInlineGraphicElement(parent, inlineHolder, 0);
					++floatIndex;
				}
			}
			while (containerListIndex < _floatsInContainer.length)		// remove trailing items
			{
				float = _floatsInContainer[containerListIndex++];
				if (float.parent)
				{
					CONFIG::debug { changes.push(["remove", getIndexOfFloat(float), float, "removeTrailing", float.parent is ITextLine ? "removing inline" : "removing float"]);  }
					removeInlineGraphicElement(_container, float.parent);
				}
			}
			
			// Update the container list
			_floatsInContainer = visibleFloats;
			
			//	CONFIG::debug { compareUpdateGraphicsResults(changes, oldChanges, _floatsInContainer, visibleAtEnd); }
		} 
*/
		
		private function floatIsVisible(wmode:String, scrollX:Number, scrollY:Number, scrollWidth:Number, scrollHeight:Number, floatInfo:FloatCompositionData):Boolean
		{
			var inlineGraphicElement:IInlineGraphicElement = textFlow.findLeaf(floatInfo.absolutePosition) as IInlineGraphicElement;
			
			return (wmode == BlockProgression.TB) ?
				(floatInfo.y + inlineGraphicElement.elementHeight >= scrollY) && 
					(floatInfo.y <= scrollY + scrollHeight) :
				(floatInfo.x + inlineGraphicElement.elementWidth >= scrollX) && 
					(floatInfo.x <= scrollX + scrollWidth);
		} 
		
		CONFIG::debug private function processResults(changes:Array):Array
		{
			var newProcessedResults:Array = [];
			var newResults:Array;
			for each (newResults in changes)
			{
				var i:int;
				var result:Object = {};
				result.absolutePosition = newResults[1];
				result.state = newResults;
				for (i = 0; i < newProcessedResults.length; ++i)
					if (newProcessedResults[i].absolutePosition == newResults[1])
						break;
				if (i < newProcessedResults.length)
					newProcessedResults[i] = result;
				newProcessedResults.push(result);
			}
			return newProcessedResults;
		}
		
		CONFIG::debug private function compareUpdateGraphicsResults(newAlgorithmChanges:Array, originalAlgorithmChanges:Array, visibleFloats:Array, oldVisibleFloats:Array):void
		{
		//	var newResults:Array;
//			var changeIndex:int = 0;
			var oldMatrix:Matrix;
			var matrix:Matrix;
			var result:Object;
			var newProcessedResults:Array = processResults(newAlgorithmChanges);
			var oldProcessedResults:Array = processResults(originalAlgorithmChanges);
			for each (result in newProcessedResults)
			{
				for (var i:int = 0; i < oldProcessedResults.length; ++i)
					if (oldProcessedResults[i].absolutePosition == result.absolutePosition)
						break;
				assert(i < oldProcessedResults.length, "Object at " + result.absolutePosition.toString() + "not changed by original algorithm is changed(" + result.state[0] + ") by new");
				if (i < oldProcessedResults.length)
				{
					var oldResult:Object = oldProcessedResults[i];
					var oldChanges:Array = oldResult.state;
					var newChanges:Array = result.state;
					assert (newChanges[0] == oldChanges[0], "New algorithm left object at " + newChanges[1].toString() + " in different state than old algorithm (now " + newChanges[0] + " was " + oldChanges[0]);
					if (newChanges[0] != oldChanges[0])
						continue;
					switch (newChanges[0])
					{
						case 'update':
							oldMatrix = oldChanges[2] as Matrix;
							matrix = newChanges[2] as Matrix;
							assert((matrix == null && oldMatrix == null) || 
								(matrix.a == oldMatrix.a && matrix.b == oldMatrix.b &&
									matrix.c == oldMatrix.c && matrix.d == oldMatrix.d &&
									matrix.tx == oldMatrix.tx && matrix.ty == oldMatrix.ty), "Expected matrix of new alogorithm to match matrix of old"); 
							assert(oldChanges[3] == newChanges[3], "Expected alpha of new alogirthm to match alpha of old"); 
							assert(oldChanges[4] == newChanges[4], "Expected X of new alogirthm to match X of old on update"); 
							assert(oldChanges[5] == newChanges[5], "Expected Y of new alogirthm to match Y of old on update"); 
							break;
						case 'add':
							assert(oldChanges[2] == newChanges[2], "After add new and old algorithm get different parent");
							assert(oldChanges[3] == newChanges[3], "After add new and old algorithm get different child index");
							matrix = oldChanges[4] as Matrix;
							oldMatrix = newChanges[4] as Matrix;
							assert((matrix == null && oldMatrix == null) ||
								(matrix.a == oldMatrix.a && matrix.b == oldMatrix.b &&
									matrix.c == oldMatrix.c && matrix.d == oldMatrix.d &&
									matrix.tx == oldMatrix.tx && matrix.ty == oldMatrix.ty), "After add new and old algorithm get different matrix"); 
							assert(oldChanges[5] == newChanges[5], "After add new and old algorithm get different alpha"); 
							assert(oldChanges[6] == newChanges[6], "After add new and old algorithm get different X"); 
							assert(oldChanges[7] == newChanges[7], "After add new and old algorithm get different Y"); 
							break;
						case 'remove':
							if (oldChanges[0] != "remove" && newChanges[3] == "going to add inline")
								return;
							if (oldChanges[2] != newChanges[2])
							{
								for (var j:int = 0; j < oldProcessedResults.length; ++j)
									if (oldProcessedResults[j].state[0] == "remove" && oldProcessedResults[j].state[2] == newChanges[2])
										break;
								assert(j < oldProcessedResults.length, "Float at " + newChanges[1].toString() + " removed by new algorithm " + oldChanges[0] + " by the old");
							}
							break;
					}
				}
			}
			var float:IUIBase;
			var floatPosition:int = -1;
			for each (float in visibleFloats)
			{
				if (oldVisibleFloats.indexOf(float) < 0)
				{
					floatPosition = getIndexOfFloat(float);
					assert (false, "new algorithm _floatsInContainer has visible graphic at " + floatPosition.toString() + " not in old algorithm in container " + flowComposer.getControllerIndex(this).toString());
				}
			}
			for each (float in oldVisibleFloats)
			{
				if (visibleFloats.indexOf(float) < 0)
				{
					floatPosition = getIndexOfFloat(float);
					assert (false, "old algorithm _floatsInContainer has visible graphic at " + floatPosition.toString() + " not in new algorithm" + flowComposer.getControllerIndex(this).toString());
				}
			}
		} 
		
		CONFIG::debug private function getIndexOfFloat(float:IUIBase):int
		{
			var floatPosition:int = -1;
			for (var m:int = 0; m < _composedFloats.length; m++)
			{
				if (_composedFloats[m].graphic == float)
				{
					floatPosition = _composedFloats[m].absolutePosition;
					break;
				}
			}
			return floatPosition;
		}
		
		// Add or remove graphis (floats or regular inlines) from the display list
		CONFIG::debug private function oldUpdateGraphics(updateStart:int, changes:Array, visibleAtEnd:Array):void
		{
			var inlineHolder:IParentIUIBase;
			
			// If we have new floats that have been composed into container, we add them here.
			// Also, we remove any that are no longer in the container. Only change those
			// floats that are within the area that was recomposed.
			
			var floatInfo:FloatCompositionData;
			var firstLine:ITextFlowLine = getFirstVisibleLine();
			var lastLine:ITextFlowLine = getLastVisibleLine();
			var firstVisiblePosition:int = firstLine ? firstLine.absoluteStart : this.absoluteStart;
			var lastVisiblePosition:int = lastLine ? lastLine.absoluteStart + lastLine.textLength : this.absoluteStart + textLength;

			var floatIndex:int = findFloatIndexAtOrAfter(updateStart);
			var lastFloatIndex:int = findFloatIndexAtOrAfter(lastVisiblePosition);
			var containerListIndex:int = 0;
			var childIdx:int = getFirstTextLineChildIndex(); // index where the first text line must appear at in its container  
			if (floatIndex > 0)		
			{
				// starting from the middle, need to skip over the initial entries already in the 
				// container list that are not being changed
				floatInfo = _composedFloats[floatIndex - 1];
				containerListIndex = _floatsInContainer.indexOf(floatInfo.graphic) + 1;
				CONFIG::debug { assert(containerListIndex >= 0, "Can't find pre-existing float in container list"); }
			}
			if (!_floatsInContainer)
				_floatsInContainer = [];
			var numContainerList:int = _floatsInContainer.length;

			// Add in the floats from the last compose, at the composed location
			for (; floatIndex < lastFloatIndex; )
			{
				floatInfo = _composedFloats[floatIndex];
				var float:IUIBase = floatInfo.graphic;
				var parent:IParentIUIBase = floatInfo.parent;
				if (floatInfo.floatType == Float.NONE)	// If the parent line is not in view, don't display the ILG
				{
					// Check to see if the ITextLine has changed
					var tl:ITextLine = parent as ITextLine;
					if (tl)
					{
						var tfl:ITextFlowLine = tl.userData as ITextFlowLine;
						if (!tfl || floatInfo.absolutePosition < tfl.absoluteStart || floatInfo.absolutePosition >= tfl.absoluteStart + tfl.textLength || tl.parent == null || tl.validity == "invalid")
						{
							// ITextLine doesn't match ITextFlowLine -- refetch the ITextLine
							tfl = flowComposer.findLineAtPosition(floatInfo.absolutePosition);

							for (var i:int = 0; i < _shapeChildren.length; i++) 
								if ((_shapeChildren[i] as ITextLine).userData == tfl)		// if this is coded into the loop condition we get a warning
									break;
							parent = (i < _shapeChildren.length) ? _shapeChildren[i] : null;
						}
					}
					if (!floatInfo.matrix || _shapeChildren.indexOf(parent) < 0)
					{
						++floatIndex;
						continue;
					}
				}
				if (floatInfo.floatType == Float.NONE && (!floatInfo.matrix || _shapeChildren.indexOf(parent) < 0))	// If the parent line is not in view, don't display the ILG
				{
					++floatIndex;
					continue;
				}
				if (float)
					inlineHolder = float.parent as IParentIUIBase;
				if (containerListIndex < numContainerList && floatInfo.parent == _container && inlineHolder && inlineHolder.parent == _container && float == _floatsInContainer[containerListIndex])		// its in both lists, just skip over
				{
					var updateSprite:IParentIUIBase = textFlow.tlfFactory.getContainer();
//TODO deal with transforms
//					updateSprite.transform.matrix = inlineHolder.transform.matrix;
					updateSprite.x = inlineHolder.x;
					updateSprite.y = inlineHolder.y;
					var updateAlpha:Number;
					
					// Update in place
//					if (floatInfo.matrix)
//						updateMatrix = floatInfo.matrix;
//					else
//					{
						updateSprite.x = 0;
						updateSprite.y = 0;
//					}
					updateAlpha = floatInfo.alpha;
					updateSprite.x += floatInfo.x;
					updateSprite.y += floatInfo.y;
					var updateX:Number = updateSprite.x;
					var updateY:Number = updateSprite.y;
//					var updateMatrix:Matrix = updateSprite.transform.matrix;
//					updateMatrix = updateMatrix.clone();
//temp until fix...
					var updateMatrix:Matrix = new Matrix();
					CONFIG::debug { assert(inlineHolder.getElementIndex(float) > -1, "expected float is already in display list"); }
					changes.push(["update", floatInfo.absolutePosition, updateMatrix, updateAlpha, updateX, updateY]);
					++floatIndex;
					++containerListIndex;
					continue;
				}
				var index:int = _floatsInContainer.indexOf(float);
				if (index > containerListIndex && parent == _container)		// it's in the existing list, but not yet, remove the old items from the container
				{
					var floatToRemove:IUIBase = _floatsInContainer[containerListIndex++];
					if (floatToRemove.parent)
					//	removeInlineGraphicElement(_container, floatToRemove.parent);
						changes.push(["remove", getIndexOfFloat(floatToRemove), floatToRemove, parent == _container ? "going to add float" : "going to add inline"]);
				}
				else					
				{
					if (containerListIndex < numContainerList &&  float == _floatsInContainer[containerListIndex])		// it was previously a Float.NONE; so we don't want to remove it later
						containerListIndex++;

//TODO no idea what this is all about...
//					var addSprite:Sprite = new Sprite();
//					var addAlpha:Number = floatInfo.alpha;
//
//					if (floatInfo.matrix)
//						addSprite.transform.matrix = floatInfo.matrix;
//					addSprite.x += floatInfo.x;	// addSprite x & y have values set up by matrix assignment - keep twip rounding same by assigning into Sprite
//					addSprite.y += floatInfo.y;
//					var addMatrix:Matrix = addSprite.transform.matrix;
//					var addX:Number = addSprite.x;
//					var addY:Number = addSprite.y;
//					addMatrix = addMatrix ? addMatrix.clone() : null;
					var addMatrix:Matrix = floatInfo.matrix;
					var addAlpha:Number = floatInfo.alpha;
					var addX:Number = 0;
					var addY:Number = 0;
					if (parent == _container)		// it's float - add to container
						changes.push(["add", floatInfo.absolutePosition, _container, childIdx++, addMatrix, addAlpha, addX, addY]);
					//	addInlineGraphicElement(_container, inlineHolder, childIdx++);
					else	// it's an inline - add to ITextLine
						changes.push(["add", floatInfo.absolutePosition, parent, 0, addMatrix, addAlpha, addX, addY]);
					//	addInlineGraphicElement(parent, inlineHolder, 0);
					++floatIndex;
				}
			}
			while (containerListIndex < _floatsInContainer.length)		// remove trailing items
			{
				float = _floatsInContainer[containerListIndex++];
				if (float.parent)
				{
					changes.push(["remove", getIndexOfFloat(float), float, "removeTrailing"]);
				//	removeInlineGraphicElement(_container, float.parent);
				}
			}

			// Update the container list
			visibleAtEnd.length = 0;
			for each (floatInfo in _composedFloats)
				if (floatInfo.absolutePosition >= firstVisiblePosition && floatInfo.absolutePosition < lastVisiblePosition)
					visibleAtEnd.push(floatInfo.graphic);
		}
			
		private function releaseLinesInBlock(textBlock:ITextBlock):void
		{
			// run through the textBlock and if all lines are not in view,
			// release the lines from the ITextBlock, and release the ITextBlock itself.
			for (var textLine:ITextLine = textBlock.firstLine; textLine && textLine.parent == null; textLine = textLine.nextLine)
			{	// do nothing 
			}
			if (!textLine && textBlock.firstLine)	// no lines in paragraph are in the view
			{
				var para:IParagraphElement;
				var line:ITextFlowLine = textBlock.firstLine.userData as ITextFlowLine;
				if (line)
					para = line.paragraph;
				textBlock.releaseLines(textBlock.firstLine, textBlock.lastLine);
				if (para)
					para.releaseTextBlock();
			}
		}
		
		private function removeAndRecycleTextLines (beginIndex:int, endIndex:int):void
		{
			var backgroundManager:IBackgroundManager = textFlow.backgroundManager;
			
			var child:ITextLine;
			var textBlock:ITextBlock;
			for (var index:int = beginIndex; index < endIndex; index++)
			{
				// we don't recycle table blocks
				if( !(_shapeChildren[index] is ITextLine) ){
					removeTableBlock(_shapeChildren[index]);
					child = null;
					continue;
				}
				child = _shapeChildren[index];					
				removeTextLine(child);
				CONFIG::debug { Debugging.traceFTECall(null,_container,"removeTextLine",child); }
				// when we've removed all the lines in the paragraph in shapeChildren, run through the textBlock and if all lines are not in view,
				// release the lines from the ITextBlock, and release the ITextBlock itself.
				if (child.textBlock != textBlock)		
				{
					if (textBlock)
						releaseLinesInBlock(textBlock);
					textBlock = child.textBlock;
				}
			}
			// To fix bug #2988783  -By Jin Huang
			// releaseLinesInBlock() can only be called here when
			// 1. the end of final container
			// 2. the end line of ITextBlock is the end line of the container
			if (textBlock && (textBlock.lastLine == child || flowComposer.getControllerAt(flowComposer.numControllers - 1) == this))
				releaseLinesInBlock(textBlock);
			
			// Recycle lines not in view and not in the ITextBlock
			if (TextLineRecycler.textLineRecyclerEnabled)
			{
				while (beginIndex < endIndex)
				{
					if( !(_shapeChildren[beginIndex] is ITextLine) ){
						beginIndex++;
						continue;
					}
					child = _shapeChildren[beginIndex++];
										
					// Recycle if its not displayed and not connected to the textblock
					if (!child.parent)
					{
						if (child.userData == null)
						{
							TextLineRecycler.addLineForReuse(child);
							if (backgroundManager)
								backgroundManager.removeLineFromCache(child);
						}
						else 
						{
							var tfl:ITextFlowLine = child.userData as ITextFlowLine;
							if (tfl && tfl.controller != this)		// don't release lines that belong to other containers
								continue;
							if (child.validity == "invalid" || (child.nextLine == null && child.previousLine == null && (!child.textBlock || child.textBlock.firstLine != child)))
							{
								child.userData = null;
								TextLineRecycler.addLineForReuse(child);
								if (backgroundManager)
									backgroundManager.removeLineFromCache(child);
							}
						}
					}
				}
			}
		} 
		
		/**
		 * Gets the index at which the first text line must appear in its parent.
		 * The default implementation of this method, which may be overriden, returns the child index 
		 * of the first <code>org.apache.royale.text.engine.ITextLine</code> child of <code>container</code>
		 * if one exists, and that of the last child of <code>container</code> otherwise. 
		 * 
		 * @return the index at which the first text line must appear in its parent.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * 
		 * @see org.apache.royale.text.engine.ITextLine
		 * @see #container
		 */	
		protected function getFirstTextLineChildIndex():int
		{			
			// skip past any non-ITextLine children below the text in the container,
			// This also means that in a container devoid of text, we will always
			// populate the text starting at index container.numChildren, which is intentional.
			var firstTextLine:int;
			for(firstTextLine = 0; firstTextLine<_container.numElements; ++firstTextLine)
			{
				if(_container.getElementAt(firstTextLine) is ITextLine)
				{
					break;
				}
				
				if(_container.getElementAt(firstTextLine) is TableBlockContainer)
					break;
				
			}
			return firstTextLine;
		}
		
		/**
		 * Adds a <code>org.apache.royale.text.engine.ITextLine</code> object as a descendant of <code>container</code>.
		 * The default implementation of this method, which may be overriden, adds the object
		 * as a direct child of <code>container</code> at the specified index.
		 * 
		 * @param textLine the <code>org.apache.royale.text.engine.ITextLine</code> object to add
		 * @param index insertion index of the text line in its parent 
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * 
		 * @see org.apache.royale.text.engine.ITextLine
		 * @see #container
		 * 
		 */	
		protected function addTextLine(textLine:ITextLine, index:int):void
		{ 
			if ( index > _container.numElements )
				index = _container.numElements;
			_container.addElementAt(textLine, index);
		}
		
		/**
		 * Removes a <code>org.apache.royale.text.engine.ITextLine</code> object from its parent. 
		 * The default implementation of this method, which may be overriden, removes the object
		 * from <code>container</code> if it is a direct child of the latter.
		 * 
		 * This method may be called even if the object is not a descendant of <code>container</code>.
		 * Any implementation of this method must ensure that no action is taken in this case.
		 * 
		 * @param textLine the <code>org.apache.royale.text.engine.ITextLine</code> object to remove 
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * 
		 * @see org.apache.royale.text.engine.ITextLine
		 * @see #container
		 * 
		 */	
		protected function removeTextLine(textLine:ITextLine):void
		{
			if (_container.getElementIndex(textLine) > -1)
				_container.removeElement(textLine);
		}
		
		/**
		 * Adds a <code>TableBlockContainer</code> object as a descendant of <code>container</code>.
		 * The default implementation of this method, which may be overriden, adds the object
		 * as a direct child of <code>container</code> at the specified index.
		 * 
		 * @param textLine the <code>TableBlockContainer</code> object to add
		 * @param index insertion index of the text line in its parent 
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * 
		 * @see #container
		 * 
		 */	
		protected function addTableBlock(block:TableBlockContainer, index:int):void
		{ 
			if ( index > _container.numElements )
				index = _container.numElements;
			_container.addElementAt(block, index);
			block.userData.updateCompositionShapes();
		}
		
		/**
		 * Removes a <code>TableBlockContainer</code> object from its parent. 
		 * The default implementation of this method, which may be overriden, removes the object
		 * from <code>container</code> if it is a direct child of the latter.
		 * 
		 * This method may be called even if the object is not a descendant of <code>container</code>.
		 * Any implementation of this method must ensure that no action is taken in this case.
		 * 
		 * @param textLine the <code>TableBlockContainer</code> object to remove 
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * 
		 * @see #container
		 * 
		 */	

		protected function removeTableBlock(block:TableBlockContainer):void
		{
			if (_container.getElementIndex(block) > -1)
				_container.removeElement(block);
		}

		
		/**
		 * Adds a <code>flash.display.Shape</code> object on which background shapes (such as background color) are drawn.
		 * The default implementation of this method, which may be overriden, adds the object to <code>container</code>
		 * just before the first <code>org.apache.royale.text.engine.ITextLine</code> child, if one exists, and after the last exisiting
		 * child otherwise. 
		 * 
		 * @param shape <code>flash.display.Shape</code> object to add
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * 
		 * @see flash.display.Shape
		 * @see org.apache.royale.text.engine.ITextLine
		 * @see #container
		 * 
		 */
		protected function addBackgroundShape(shape:IUIBase):void	// No PMD
		{
			_container.addElementAt(_backgroundShape, getFirstTextLineChildIndex());
		}
		
		/**
		 * Removes a <code>flash.display.Shape</code> object on which background shapes (such as background color) are drawn.
		 * The default implementation of this method, which may be overriden, removes the object from its <code>parent</code>.
		 * 
		 * @param shape <code>flash.display.Shape</code> object to remove
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * 
		 * @see flash.display.Shape
		 * @see org.apache.royale.text.engine.ITextLine
		 * @see #container
		 * 
		 */
		protected function removeBackgroundShape(shape:IUIBase):void	
		{
			if (shape.parent)
				shape.parent.removeElement(shape);
		}
		
		/**
		 * Adds a <code>flash.display.DisplayObjectContainer</code> object to which selection shapes (such as block selection highlight, cursor etc.) are added.
		 * The default implementation of this method, which may be overriden, has the following behavior:
		 * The object is added just before first <code>org.apache.royale.text.engine.ITextLine</code> child of <code>container</code> if one exists 
		 * and the object is opaque and has normal blend mode. 
		 * In all other cases, it is added as the last child of <code>container</code>.
		 * 
		 * @param selectionContainer <code>flash.display.DisplayObjectContainer</code> object to add
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * 
		 * @see flash.display.DisplayObjectContainer
		 * @see org.apache.royale.text.engine.ITextLine
		 * @see #container
		 */
		protected function addSelectionContainer(selectionContainer:IParentIUIBase):void
		{
//			if (selectionContainer.blendMode == BlendMode.NORMAL && selectionContainer.alpha == 1)
			if(textFlow.tlfFactory.getBlendMode(selectionContainer) == "normal")
			{
				// don't put selection behind background color or existing content in container, put it behind first text line
				_container.addElementAt(selectionContainer, getFirstTextLineChildIndex());
			}
			else
				_container.addElement(selectionContainer);
		}
		
		/**
		 * Removes the <code>flash.display.DisplayObjectContainer</code> object which contains selection shapes (such as block selection highlight, cursor etc.).
		 * The default implementation of this method, which may be overriden, removes the object from its parent if one exists.
		 * 
		 * @param selectionContainer <code>flash.display.DisplayObjectContainer</code> object to remove
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * 
		 * @see flash.display.DisplayObjectContainer
		 * @see #container
		 * 
		 */
		protected function removeSelectionContainer(selectionContainer:IParentIUIBase):void
		{	
			selectionContainer.parent.removeElement(selectionContainer);
		}
		
		/**
		 * Adds a <code>flash.display.DisplayObject</code> object as a descendant of <code>parent</code>.
		 * The default implementation of this method, which may be overriden, adds the object
		 * as a direct child of <code>parent</code> at the specified index. This is called to add 
		 * InlineGraphicElements to the ITextLine or container.
		 * 
		 * @param parent the <code>flash.display.DisplayObjectContainer</code> object to add the inlineGraphicElement to
		 * @param inlineGraphicElement the <code>flash.display.DisplayObject</code> object to add
		 * @param index insertion index of the float in its parent 
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 2.0
		 * @langversion 3.0
		 * 
		 * @see flash.display.DisplayObjectContainer
		 * @see flash.display.DisplayObject
		 * @see #container
		 * 
		 */	
		protected function addInlineGraphicElement(parent:IParentIUIBase, inlineGraphicElement:IUIBase, index:int):void
		{
			
			// We're adding the inline holder -- the float it owns should not be in the visible list
			CONFIG::debug { assert (parent != _container || !(parent.getElementIndex(inlineGraphicElement) > -1), "Float already in container"); }
			if (parent)
				parent.addElementAt(inlineGraphicElement, index);
		}
		
		/**
		 * Removes a <code>flash.display.DisplayObject</code> object from its parent. 
		 * The default implementation of this method, which may be overriden, removes the object
		 * from <code>container</code> if it is a direct child of the latter.
		 * 
		 * This method may be called even if the object is not a descendant of <code>parent</code>.
		 * Any implementation of this method must ensure that no action is taken in this case.
		 * 
		 * @param float the <code>flash.display.DisplayObject</code> object to remove 
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 2.0
		 * @langversion 3.0
		 * 
		 * @see flash.display.DisplayObjectContainer
		 * @see flash.display.DisplayObject
		 * @see #container
		 * 
		 */	
		protected function removeInlineGraphicElement(parent:IParentIUIBase, inlineGraphicElement:IUIBase):void
		{
			// We're removing the inline holder -- the float it owns should be in the visible list
			CONFIG::debug { assert (parent != _container || _floatsInContainer.indexOf(IParentIUIBase(inlineGraphicElement).getElementAt(0)) >= 0, "Float *not* already in container"); }
			if (null != parent && inlineGraphicElement.parent == parent)
				parent.removeElement(inlineGraphicElement);
		}
		
		/**
		 * @private
		 */
		public function get textLines():Array
		{
			return _shapeChildren;
		}
		
		/** 
		 * If scrolling, sets the scroll rectangle to the container rectangle so that any lines that are 
		 * halfway in view are clipped to the scrollable region. If not scrolling, clear the
		 * scroll rectangle so that no clipping occurs.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		
		protected function updateVisibleRectangle() :void
		{
			if (horizontalScrollPolicy == ScrollPolicy.OFF && verticalScrollPolicy == ScrollPolicy.OFF)
			{
				if (_hasScrollRect)
				{
//TODO deal with scrollRect
//					_container.scrollRect = null;
					_hasScrollRect = false;
					
				}
			}
			else
			{
				var contentRight:Number = _contentLeft+contentWidth;
				var contentBottom:Number = _contentTop+contentHeight;
				var width:Number;
				var compositionRight:Number;
				if (_measureWidth)
				{
					width = contentWidth;
					compositionRight = _contentLeft + width;
				}
				else
				{
					width = _compositionWidth;
					compositionRight = width;
				}
				var height:Number;
				var compositionBottom:Number;
				if (_measureHeight)
				{
					height = contentHeight;
					compositionBottom = _contentTop + height;
				}
				else
				{
					height = _compositionHeight;
					compositionBottom = height;
				}
				var xOrigin:Number = (effectiveBlockProgression == BlockProgression.RL) ? -width : 0;
				var xpos:int = horizontalScrollPosition + xOrigin;
				var ypos:int = verticalScrollPosition;
				//Fix bug 2869747 textFlow.flowComposer.getControllerAt(0)
                CONFIG::debug { 
                if(!_hasScrollRect)
				{
//TODO scrollRect
//						_container.scrollRect = null;
						Debugging.traceFTECall(null,_container,"clearContainerScrollRect()");
				}
                }
				
				if (textLength == 0 || xpos == 0 && ypos == 0 && _contentLeft >= xOrigin && _contentTop >= 0 && contentRight <= compositionRight && contentBottom <= compositionBottom)
				{
					if(_hasScrollRect)
					{
//TODO scrollRect
//						_container.scrollRect = null;
						CONFIG::debug { Debugging.traceFTECall(null,_container,"clearContainerScrollRect()"); }
						_hasScrollRect = false;
					}
				}
				else 
				{
					// don't look at hasScrollRect but do look at scrollRect - client may have messed with it; okay to touch it because about to set it
//TODO scrollRect
//					var rect:Rectangle = _container.scrollRect;
//					if (!rect || rect.x != xpos || rect.y != ypos || rect.width != width || rect.height != height)
//					{
//						_container.scrollRect = new Rectangle(xpos, ypos, width, height);
//						CONFIG::debug { Debugging.traceFTECall(null,_container,"setContainerScrollRect",xpos, ypos, width, height); }
//						_hasScrollRect = true;
//					}
				}
			}
			
			//Fix for Watson 2347938 - re-add the transparent background as the dimension of the
			//container are altered by sutting down the scrolls in vertical text.
			this.attachTransparentBackgroundForHit(false);
		}
		
		// include "../formats/TextLayoutFormatInc.as";
		
		/** Allows you to read and write user styles on a ContainerController object.  Note that reading this property
		 * makes a copy of the userStyles set in the format of this element. 
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * 
		 */
		public function get userStyles():Object
		{ return _format ? _format.userStyles : null; }
		public function set userStyles(styles:Object):void
		{
			var val:String;
			// clear the existing userstyles
			for (val in userStyles)
				this.setStyle(val,undefined);
			
			// set the new ones
			for (val in styles)
				this.setStyle(val,styles[val]);
		}
		
		/** Returns the <code>coreStyles</code> on this ContainerController.  Note that the getter makes a copy of the core 
		 * styles dictionary. The returned object includes the formats that are defined by TextLayoutFormat and are in TextLayoutFormat.description. The
		 * returned object consists of an array of <em>stylename-value</em> pairs.
		 * 
		 * @see org.apache.royale.textLayout.formats.TextLayoutFormat
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		
		public function get coreStyles():Object
		{ return _format ? _format.coreStyles : null; }
		
		/** Returns the styles on this ContainerController.  Note that the getter makes a copy of the  
		 * styles dictionary. The returned object includes all styles set in the format property including core and user styles. The
		 * returned object consists of an array of <em>stylename-value</em> pairs.
		 * 
		 * @see org.apache.royale.textLayout.formats.TextLayoutFormat
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get styles():Object
		{ return _format ? _format.styles : null; }

		/** 
		 * Stores the ITextLayoutFormat object that contains the attributes for this container. 
		 * The controller inherits the container properties from the TextFlow of which it is part. 
		 * This property allows different controllers in the same text flow to have, for example, 
		 * different column settings or padding.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 * @see org.apache.royale.textLayout.formats.ITextLayoutFormat
		 */
		public override function get format():ITextLayoutFormat
		{ return _format; }
		public override function set format(value:ITextLayoutFormat):void
		{
			if (value == _format)
				return;
			
			var oldStyleName:String = this.styleName;
			
			if (value == null)
				_format.clearStyles();
			else
				writableTextLayoutFormat().copy(value);

			formatChanged();
			if (oldStyleName != this.styleName)
				styleSelectorChanged();
		}
		
		/** Returns the value of the style specified by the <code>styleProp</code> parameter.
		 *
		 * @param styleProp The name of the style property whose value you want.
		 *
		 * @return	The current value for the specified style.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public override function getStyle(styleProp:String):*
		{ 
			if (TextLayoutFormat.description.hasOwnProperty(styleProp))
				return computedFormat.getStyle(styleProp);
			
			var tf:ITextFlow = _rootElement.getTextFlow();
			if (!tf || !tf.formatResolver)
				return computedFormat.getStyle(styleProp);
			
			return getUserStyleWorker(styleProp); 
		}
		
		/** @private worker function - any styleProp */
		public function getUserStyleWorker(styleProp:String):*
		{
			CONFIG::debug { assert(TextLayoutFormat.description[styleProp] === undefined,"bad call to getUserStyleWorker"); }
			
			var userStyle:* = _format.getStyle(styleProp);
			if (userStyle !== undefined)
				return userStyle;
			
			var tf:ITextFlow = _rootElement ? _rootElement.getTextFlow() : null;
			if (tf && tf.formatResolver)
			{
				userStyle = tf.formatResolver.resolveUserFormat(this,styleProp);
				if (userStyle !== undefined)
					return userStyle;
			}
			// or should it go to the container?
			return _rootElement ? _rootElement.getUserStyleWorker(styleProp) : undefined;
		}
		
		/** 
		 * Sets the value of the style specified by the <code>styleProp</code> parameter to the value
		 * specified by the <code>newValue</code> parameter.
		 *
		 * @param styleProp The name of the style property whose value you want to set.
		 * @param newValue The value that you want to assign to the style.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function setStyle(styleProp:String,newValue:*):void
		{
			if (TextLayoutFormat.description[styleProp])
				this[styleProp] = newValue;
			else
			{
				writableTextLayoutFormat().setStyle(styleProp,newValue);
				formatChanged();
			}
		}
		
		/** Clears the style specified by <code>styleProp</code> from this FlowElement. Sets the value to
		 * <code>undefined</code>.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function clearStyle(styleProp:String):void
		{ setStyle(styleProp,undefined); }
		
		
		/** 
		 * Returns an ITextLayoutFormat instance with the attributes applied to this container, including the attributes inherited from its
		 * root element.
		 * 
		 * @return 	object that describes the container's attributes.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 * @see #rootElement
		 */
		public function get computedFormat():ITextLayoutFormat
		{
			if (!_computedFormat)
			{
				// TODO: revise cascade so it goes up through the container chain
				calculateComputedFormat();
			}
			return _computedFormat;
		}
		private function calculateComputedFormat():void
		{
			var parentPrototype:TextLayoutFormat = _rootElement ? (_rootElement.computedFormat as TextLayoutFormat): null;
			_computedFormat =  CreateTLFUtil.createTLF(formatForCascade,parentPrototype);
			
			resetColumnState();
		}
		
		/** @private */
		public function get formatForCascade():ITextLayoutFormat
		{
			if (_rootElement)
			{
				var tf:ITextFlow = _rootElement.getTextFlow();
				if (tf)
				{
					var elemStyle:TextLayoutFormat  = tf.getTextLayoutFormatStyle(this);
					if (elemStyle)
					{
						var localFormat:ITextLayoutFormat = _format;
						if (localFormat == null)
							return elemStyle;
						
						var rslt:TextLayoutFormat = new TextLayoutFormat(elemStyle);
						rslt.apply(localFormat);
						return rslt;
					}
				}
			}
			return _format;
		}
		
		/** @private 
		 * @returns -1 BEFORE visible, ITextLine visible, 1 AFTER visible, 2 AFTER visible by auto-size image(bug #2988852)
		 * @royaleignorecoercion org.apache.royale.textLayout.compose.ITextFlowTableBlock
		 * @royaleignorecoercion org.apache.royale.textLayout.elements.IInlineGraphicElement
		 * */
		public function testLineVisible(wmode:String, scrollXTW:int, scrollYTW:int, scrollWidthTW:int, scrollHeightTW:int, textFlowLine:ITextFlowLine, textLine:ITextLine):*
		{
			// So this is another take on figuring out whether the line bounds intersects the visible area of the container. 
			// This code figures out the logical bounds of the line, and uses that for the intersection. There was a 
			// previous version of this code that uses the DisplayObject's getBounds function, which will include information
			// about the children, and also the bounds of visible glyphs. We decided that the logical bounds is close enough,
			// and is much faster to obtain. However, there may be some lines, that get a different result using the logical 
			// bounds than the getBounds. I've left the old code here for verification.
			CONFIG::debug { assert(textFlowLine != null,"testLineVisible"); }
			
			if(textFlowLine is ITextFlowTableBlock)
			{
				if(textFlowLine.controller == this)
					return ITextFlowTableBlock(textFlowLine).container;
				return null;
			}
			
			//Bug #2988852, scrolling in the application causes all text to disappear. When auto-size images make the line "after visible"
			//It's "after visible", but it cannot return 1. Because if it were 1, the binary-search in gatherVisibleLines() would make all the lines invisible.
			if(textFlowLine.controller == null)
			{
				var ilgs:Array = textFlow.getElementsByTypeName("img");
				var ilg:IInlineGraphicElement;
				for(var idx:int = 0; idx < ilgs.length; idx++)
				{
					ilg = ilgs[idx] as IInlineGraphicElement;
					if(ilg && ilg.getAbsoluteStart() < textFlowLine.absoluteStart)
					{
						if(wmode == BlockProgression.TB)
						{
							if(ilg.height == undefined || ilg.height == "auto")
								return 2; 
						}
						else
						{
							if(ilg.width == undefined || ilg.width == "auto")
								return 2;
						}
					}
					else 
						break;
				}
			}
			
			// assume the same textFlow and that it's composed.
			if (textFlowLine.controller != this)
				return textFlowLine.absoluteStart < this.absoluteStart ? -1 : 1;
			
			if (!textFlowLine.hasLineBounds())
			{
				if (!textLine)
					textLine = textFlowLine.getTextLine(true);
				textFlowLine.createShape(wmode, textLine);
//TODO I'm not sure what all these calculations are for. We're doing it the simple way for now.
				if (wmode == BlockProgression.TB)
					textFlowLine.cacheLineBounds(wmode, textLine.x, textLine.y - textLine.ascent, textLine.textWidth, textLine.textHeight);
				else
					textFlowLine.cacheLineBounds(wmode, textLine.x - textLine.descent, textLine.y, textLine.textHeight, textLine.textWidth);

				// if (textLine.numElements == 0)
				// {
				// 	// Get it the new way
				// 	if (wmode == BlockProgression.TB)
				// 		textFlowLine.cacheLineBounds(wmode, textLine.x, textLine.y - textLine.ascent, textLine.textWidth, textLine.textHeight);
				// 	else
				// 		textFlowLine.cacheLineBounds(wmode, textLine.x - textLine.descent, textLine.y, textLine.textHeight, textLine.textWidth);
				// }
				// else	// Phase this out after composition is updated to handle inline case correctly
				// {
				// 	var lineBounds:Rectangle = getPlacedTextLineBounds(textLine);
				// 	if (textLine.hasGraphicElement)
				// 		lineBounds = computeLineBoundsWithGraphics(textFlowLine, textLine, lineBounds);		
				// 	textFlowLine.cacheLineBounds(wmode, lineBounds.x, lineBounds.y, lineBounds.width, lineBounds.height);
				// }
			}
			var rslt:* = (wmode == BlockProgression.TB ? _measureHeight : _measureWidth) ? 0 : textFlowLine.testLineVisible(wmode, scrollXTW, scrollYTW, scrollWidthTW, scrollHeightTW);
			return (rslt == 0) ? (textLine ? textLine : textFlowLine.getTextLine(true)) : rslt;
		}
		
		/** @private 
		 * 	function testLineVisible that was used in old algorithm of gatherVisibleLines()
		 * */
		public function oldTestLineVisible(wmode:String, scrollXTW:int, scrollYTW:int, scrollWidthTW:int, scrollHeightTW:int, textFlowLine:ITextFlowLine, textLine:ITextLine):ITextLine
		{
			// So this is another take on figuring out whether the line bounds intersects the visible area of the container. 
			// This code figures out the logical bounds of the line, and uses that for the intersection. There was a 
			// previous version of this code that uses the DisplayObject's getBounds function, which will include information
			// about the children, and also the bounds of visible glyphs. We decided that the logical bounds is close enough,
			// and is much faster to obtain. However, there may be some lines, that get a different result using the logical 
			// bounds than the getBounds. I've left the old code here for verification.
			
			if(textFlowLine is ITextFlowTableBlock)
				return null;

			if (!textFlowLine.hasLineBounds())
			{
				if (!textLine)
					textLine = textFlowLine.getTextLine(true);
				textFlowLine.createShape(wmode, textLine);
				if (textLine.numElements == 0)
				{
					// Get it the new way
					if (wmode == BlockProgression.TB)
						textFlowLine.cacheLineBounds(wmode, textLine.x, textLine.y - textLine.ascent, textLine.textWidth, textLine.textHeight);
					else
						textFlowLine.cacheLineBounds(wmode, textLine.x - textLine.descent, textLine.y, textLine.textHeight, textLine.textWidth);
				}
				else	// Phase this out after composition is updated to handle inline case correctly
				{
					var lineBounds:Rectangle = getPlacedTextLineBounds(textLine);
					if (textLine.hasGraphicElement)
						lineBounds = computeLineBoundsWithGraphics(textFlowLine, textLine, lineBounds);		
					textFlowLine.cacheLineBounds(wmode, lineBounds.x, lineBounds.y, lineBounds.width, lineBounds.height);
				}
			}
			if ((wmode == BlockProgression.TB ? _measureHeight : _measureWidth) || textFlowLine.oldTestLineVisible(wmode, scrollXTW, scrollYTW, scrollWidthTW, scrollHeightTW))		
				return textLine ? textLine : textFlowLine.getTextLine(true);
			return null;
		}
		
	/*	This code may turn out to be useful for iterating through the floats and doing some function,
		similar to applyFunctionToElements. 
		public function applyFunctionToFloats(absoluteStart:int, absoluteEnd:int, func:Function):void
		{ 
			if (_composedFloats)
			{
				var floatIndex:int = findFloatIndexAtOrAfter(absoluteStart);
				var lastFloatIndex:int = findFloatIndexAtOrAfter(absoluteEnd);
				while (floatIndex < lastFloatIndex)
				{
					var floatInfo:FloatCompositionData = _composedFloats[floatIndex];
					if (!func(floatInfo))
						break;
					++floatIndex;
				}
			}
		} */

				
		/**
		 *  @royaleignorecoercion org.apache.royale.core.IParentIUIBase
		 *  @royaleignorecoercion org.apache.royale.textLayout.elements.IInlineGraphicElement
		 */
		private function computeLineBoundsWithGraphics(line:ITextFlowLine, textLine:ITextLine, boundsRect:Rectangle):Rectangle
		{
			if (_composedFloats)
			{
				var floatIndex:int = findFloatIndexAtOrAfter(line.absoluteStart);
				var lastFloatIndex:int = findFloatIndexAtOrAfter(line.absoluteStart + line.textLength);
				var inlineRect:Rectangle = new Rectangle();
//				var topLeft:Point = new Point();
				while (floatIndex < lastFloatIndex)
				{
					var floatInfo:FloatCompositionData = _composedFloats[floatIndex];
					if (floatInfo.floatType == Float.NONE)
					{
						var inlineGraphicElement:IInlineGraphicElement = textFlow.findLeaf(floatInfo.absolutePosition) as IInlineGraphicElement;
						var inlineHolder:IParentIUIBase = inlineGraphicElement.placeholderGraphic.parent as IParentIUIBase;
						if (inlineHolder)
						{
							inlineRect.x = textLine.x + inlineHolder.x;
							inlineRect.y = textLine.y + inlineHolder.y;
							inlineRect.width = inlineGraphicElement.elementWidth;
							inlineRect.height = inlineGraphicElement.elementHeight;
							boundsRect = boundsRect.union(inlineRect);
						}
					}
					++floatIndex;
				}
			}
			return boundsRect;
		}
		/** @private */
		public function findCellAtPosition(point:Point):CellCoordinates
		{
			point = point.clone();
			for each(var chld:Object in _shapeChildren)
			{
				if( !(chld is TableBlockContainer) )
					continue;
				
				var block:TableBlockContainer = chld as TableBlockContainer;
				if(block.y > point.y)
					continue;
				if(block.x > point.x)
					continue;
				if(block.y + block.height < point.y)
					continue;
				if(block.x + block.getTableWidth() < point.x)
					continue;
				
				point.x -= block.x;
				point.y -= block.y;
				
				// the point falls out inside the block. Find the cell...
				var cells:Vector.<ITableCellElement> = block.userData.getTableCells();
				for each (var cell:ITableCellElement in  cells)
				{
					if(cell.x + cell.width < point.x)
						continue;
					if(cell.y + cell.getRow().composedHeight < point.y)
						continue;
					if(cell.x > point.x)
						continue;
					if(cell.y > point.y)
						continue;
					return new CellCoordinates(cell.rowIndex,cell.colIndex,cell.table);
					
				}
			}
			
			return null;
		}
		/** @private */
		public function getPlacedTextLineBounds(textLine:ITextLine):Rectangle
		{
			var curBounds:Rectangle;
			curBounds = BoundsUtil.getBounds(textLine, textLine);// textLine.getBounds(textLine);
			curBounds.x += textLine.x;
			curBounds.y += textLine.y;
			CONFIG::debug { verifyPlacedTextLineBounds(textLine,curBounds); }
			return curBounds;
		}
		
		CONFIG::debug
		{

            // OLD style calculation - lets make sure its the same.
			static private var tempLineHolder:IParentIUIBase;
//			static private var tempLineHolder:Sprite = new Sprite();
			
			/** @private */
			public function verifyPlacedTextLineBounds(textLine:ITextLine,newBounds:Rectangle):void
			{
				// But AIR has a bug so they don't match in AIR
//TODO do we care?
//				if (Capabilities.playerType == "Desktop")
//					return;
				
				var curBounds:Rectangle;
				if (!textLine.parent)
				{
					// Has to be in the container to get the bounds
					/*addTextLine(textLine,0);
					curBounds = textLine.getBounds(_container);
					removeTextLine(textLine); */
//TODO see if there's a better way to do this when we actually implement it in Royale.
					tempLineHolder.addElementAt(textLine,0);
					curBounds = BoundsUtil.getBounds(textLine, tempLineHolder);// textLine.getBounds(tempLineHolder);
					tempLineHolder.removeElement(textLine);
					CONFIG::debug { assert(textLine.parent == null,"Bad removeChild in getPlacedTextLineBounds"); }
				}
				else
				{
					// Note: Relative to its parent, which may not be _container
					// but in all reasonable cases, should share its origin with _container -- really???
					curBounds = BoundsUtil.getBounds(textLine, textLine.parent as IUIBase);// textLine.getBounds(textLine.parent);
				}
				
				assert(Math.abs(newBounds.x-curBounds.x) <= .1 && Math.abs(newBounds.y-curBounds.y) <= .1 && Math.abs(newBounds.width-curBounds.width) <= .1 && Math.abs(newBounds.height-curBounds.height) <= .1,
					"verifyPlacedTextLineBounds: Bounds are different: "+curBounds.toString()+" : "+newBounds.toString());
			}
		}
		
		/** @private */
		public function addComposedLine(textLine:ITextLine):void
		{
			_linesInView.push(textLine);			
		}

		/** @private */
		public function addComposedTableBlock(block:TableBlockContainer):void
		{
			var idx:int = _tableBlocksInView.indexOf(block);
			if(idx >= 0)
				_tableBlocksInView.splice(idx,1);
			else
				_tableBlocksInView.push(block);
		}

		/** @private Return the array. Client code may add lines to the array. */
		public function get composedLines():Array
		{
			if (!_linesInView)
				_linesInView = [];
			var arr:Array = _linesInView.slice();
			intersperseTableBlocks(arr);
			return arr;
		}
		
		/** @private Empty out the linesInView, starting from the supplied text index. */
		public function clearComposedLines(pos:int):void
		{
			var index:int = 0;
			for each (var textLine:ITextLine in _linesInView)
			{
				var tfl:ITextFlowLine = textLine.userData as ITextFlowLine;
				if (tfl.absoluteStart >= pos)
					break;
				index++;
			}
			_linesInView.length = index;
			
			index = 0;
			for each (var tbc:TableBlockContainer in _tableBlocksInView)
			{
//				var tftb:ITextFlowTableBlock = tbc.userData;
				if(tbc.userData.absoluteStart >= pos)
					break;
				index++;
			}
			_tableBlocksInView.length = index;
			
			_updateStart = Math.min(_updateStart, pos);
		}
		
		/** @private */
		public function get numFloats():int
		{
			return _composedFloats ? _composedFloats.length : 0;
		}
		
		/** @private */
		public function getFloatAt(index:int):FloatCompositionData
		{
			return _composedFloats[index];
		}
		
		/** @private */
		public function getFloatAtPosition(absolutePosition:int):FloatCompositionData
		{
			if (!_composedFloats)
				return null;
			
			var i:int = findFloatIndexAtOrAfter(absolutePosition);
			return (i < _composedFloats.length) ?  _composedFloats[i] : null;
			
		}
		
		/** Add new float info (called by composition when a float is composed into the container
		 * @private
		 */
		public function addFloatAt(absolutePosition:int, float:IUIBase, floatType:String, x:Number, y:Number, alpha:Number, matrix:Matrix, depth:Number, knockOutWidth:Number, columnIndex:int, parent:IParentIUIBase):void
		{
		//	trace("addFloatAt", absolutePosition,  "for container", flowComposer.getControllerIndex(this));
			if (!_composedFloats)
				_composedFloats = [];
			var floatInfo:FloatCompositionData = new FloatCompositionData(absolutePosition, float, floatType, x, y, alpha, matrix, depth, knockOutWidth, columnIndex, parent);
			if (_composedFloats.length > 0 && _composedFloats[_composedFloats.length - 1] < absolutePosition)
				_composedFloats.push(floatInfo);
			else
			{
				var index:int = findFloatIndexAtOrAfter(absolutePosition);
				_composedFloats.splice(index, 0, floatInfo);
			} 
			CONFIG::debug { verifyComposedFloats(); }
		}
		
		/** Remove float info for all floats after the given text position
		 * @private
		 */
		public function clearFloatsAt(absolutePosition:int):void
		{
		//	trace("clearFloatsAt", absolutePosition,  "for container", flowComposer.getControllerIndex(this));
			if (_composedFloats)
				if (absolutePosition == this.absoluteStart)
					_composedFloats.length = 0;
				else
					_composedFloats.length = findFloatIndexAtOrAfter(absolutePosition);
		}
		
		/** @private */
		CONFIG::debug private function verifyComposedFloats():void
		{
			var previousPosition:int = -1;
			for ( var i:int = 0; i < _composedFloats.length; ++i)
			{
				var floatInfo:FloatCompositionData = _composedFloats[i];
				// Don't allow duplicate entries
				for ( var j:int = i + 1; j < _composedFloats.length && _composedFloats[j].absolutePosition != floatInfo.absolutePosition; ++j) {/* do nothing */}
				assert(j == _composedFloats.length, "Found duplicate entry in ContainerController _composedFloats list");
				// Entries should be ordered
				assert(floatInfo.absolutePosition > previousPosition, "Found out of order float in ContainerController _composedFloats list");
				previousPosition = floatInfo.absolutePosition;
				assert (floatInfo.floatType != Float.START && floatInfo.floatType != Float.END, "Unexpected float type in composed floats array");
			}
		}
		

		/** 
		 * @private
		 * Returns the index in the array of a knockOut at the specified location, or the first knockOut index past that location.
		 */	
		public function findFloatIndexAfter(absolutePosition:int):int
		{	
			for (var i:int = 0; i < _composedFloats.length && _composedFloats[i].absolutePosition <= absolutePosition; ++i)
			{
				// do nothing
			}
			return i;
		} 
		
		/** 
		 * @private
		 * Returns the index in the array of a knockOut at the specified location, or the first knockOut index past that location.
		 */	
		public function findFloatIndexAtOrAfter(absolutePosition:int):int
		{	
			for (var i:int = 0; i < _composedFloats.length && _composedFloats[i].absolutePosition < absolutePosition; ++i)
			{
				// do nothing
			}
			return i;
		} 
		/** @private */
		public function getInteractionHandler():IInteractionEventHandler
		{ return this; }
	}
	
}

import org.apache.royale.events.MouseEvent;

class PsuedoMouseEvent extends org.apache.royale.events.MouseEvent
{
	public function PsuedoMouseEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false, localX:Number = NaN, localY:Number = NaN, relatedObject:Object = null, ctrlKey:Boolean = false, altKey:Boolean = false, shiftKey:Boolean = false, buttonDown:Boolean = false)
	{
		super(type,bubbles,cancelable,localX,localY,relatedObject,ctrlKey,altKey,shiftKey,buttonDown);
	}
//TODO The Royale Compiler did not like these overrides
	// public override function get currentTarget():Object
	// { return relatedObject; }
	// public override function get target():Object
	// { return relatedObject; }
}

