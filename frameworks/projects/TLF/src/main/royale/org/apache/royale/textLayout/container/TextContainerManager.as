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
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.events.KeyboardEvent;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.geom.Rectangle;
	import org.apache.royale.text.engine.ITextBlock;
	import org.apache.royale.text.engine.ITextLine;
	import org.apache.royale.text.events.IMEEvent;
	import org.apache.royale.text.events.TextEvent;
	import org.apache.royale.textLayout.compose.ISWFContext;
	import org.apache.royale.textLayout.compose.ISimpleCompose;
	import org.apache.royale.textLayout.compose.SWFContext;
	import org.apache.royale.textLayout.compose.ITextFlowLine;
	import org.apache.royale.textLayout.compose.TextLineRecycler;
	import org.apache.royale.textLayout.compose.utils.FactoryHelper;
	import org.apache.royale.textLayout.compose.utils.StandardHelper;
	import org.apache.royale.textLayout.debug.Debugging;
	import org.apache.royale.textLayout.debug.assert;
	import org.apache.royale.textLayout.dummy.ContextMenu;
	import org.apache.royale.textLayout.dummy.Mouse;
	import org.apache.royale.textLayout.dummy.MouseCursor;
	import org.apache.royale.textLayout.edit.EditManager;
	import org.apache.royale.textLayout.edit.EditingMode;
	import org.apache.royale.textLayout.edit.IEditManager;
	import org.apache.royale.textLayout.edit.IInteractionEventHandler;
	import org.apache.royale.textLayout.edit.ISelectionManager;
	import org.apache.royale.textLayout.edit.SelectionFormat;
	import org.apache.royale.textLayout.edit.SelectionManager;
	import org.apache.royale.textLayout.edit.SelectionState;
	import org.apache.royale.textLayout.elements.Configuration;
	import org.apache.royale.textLayout.elements.ElementHelper;
	import org.apache.royale.textLayout.elements.IConfiguration;
	import org.apache.royale.textLayout.elements.IFlowLeafElement;
	import org.apache.royale.textLayout.elements.IParagraphElement;
	import org.apache.royale.textLayout.elements.ISpanElement;
	import org.apache.royale.textLayout.elements.ITextFlow;
	import org.apache.royale.textLayout.elements.TextFlow;
	import org.apache.royale.textLayout.events.CompositionCompleteEvent;
	import org.apache.royale.textLayout.events.ContextMenuEvent;
	import org.apache.royale.textLayout.events.DamageEvent;
	import org.apache.royale.textLayout.events.FlowOperationEvent;
	import org.apache.royale.textLayout.events.FocusEvent;
	import org.apache.royale.textLayout.events.SelectionEvent;
	import org.apache.royale.textLayout.events.StatusChangeEvent;
	import org.apache.royale.textLayout.events.TextLayoutEvent;
	import org.apache.royale.textLayout.events.UpdateCompleteEvent;
	import org.apache.royale.textLayout.factory.StringTextLineFactory;
	import org.apache.royale.textLayout.factory.TCMTextFlowTextLineFactory;
	import org.apache.royale.textLayout.factory.TLFFactory;
	import org.apache.royale.textLayout.factory.TextLineFactoryBase;
	import org.apache.royale.textLayout.formats.BlockProgression;
	import org.apache.royale.textLayout.formats.FormatValue;
	import org.apache.royale.textLayout.formats.ITextLayoutFormat;
	import org.apache.royale.textLayout.formats.TextLayoutFormat;
	import org.apache.royale.textLayout.property.Property;
	import org.apache.royale.textLayout.property.PropertyFactory;
	import org.apache.royale.textLayout.utils.FactoryUtil;
	import org.apache.royale.utils.ObjectMap;
	import org.apache.royale.utils.undo.IUndoManager;
	import org.apache.royale.utils.undo.UndoManager;

	/**
	 *
	 *  @eventType org.apache.royale.textLayout.events.FlowOperationEvent.FLOW_OPERATION_BEGIN
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 */
	 
	[Event(name="flowOperationBegin", type="org.apache.royale.textLayout.events.FlowOperationEvent")]
	
	/**
	 * 
	 * @eventType org.apache.royale.textLayout.events.FlowOperationEvent.FLOW_OPERATION_END
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 */
	 
	[Event(name="flowOperationEnd", type="org.apache.royale.textLayout.events.FlowOperationEvent")]
	
	
	/**
	 * 
	 * @eventType org.apache.royale.textLayout.events.FlowOperationEvent.FLOW_OPERATION_COMPLETE
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 */
	
	[Event(name="flowOperationComplete", type="org.apache.royale.textLayout.events.FlowOperationEvent")]
	
	/** Dispatched whenever the selection is changed.  Primarily used to update selection-dependent user interface. 
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 */
	
	[Event(name="selectionChange", type="org.apache.royale.textLayout.events.SelectionEvent")]
	
	/** Dispatched after every recompose. 
	*
	* @playerversion Flash 10
	* @playerversion AIR 1.5
	* @langversion 3.0
	*/
	
	[Event(name="compositionComplete", type="org.apache.royale.textLayout.events.CompositionCompleteEvent")]
	
	/** Dispatched when the mouse is pressed down over any link. 
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 */
	
	[Event(name="mouseDown", type="org.apache.royale.textLayout.events.FlowElementMouseEvent")]
	
	/** Dispatched when the mouse is released over any link. 
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 */
	
	[Event(name="mouseUp", type="org.apache.royale.textLayout.events.FlowElementMouseEvent")]
	
	/** Dispatched when the mouse passes over any link. 
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 */
	
	[Event(name="mouseMove", type="org.apache.royale.textLayout.events.FlowElementMouseEvent")]	
	
	/** Dispatched when the mouse first enters any link. 
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 */
	
	[Event(name="rollOver", type="org.apache.royale.textLayout.events.FlowElementMouseEvent")]
	
	/** Dispatched when the mouse goes out of any link. 
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 */
	
	[Event(name="rollOut", type="org.apache.royale.textLayout.events.FlowElementMouseEvent")]	
	
	/** Dispatched when any link is clicked. 
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 */
	
	[Event(name="click", type="org.apache.royale.textLayout.events.FlowElementMouseEvent")]
	
	/** Dispatched when a InlineGraphicElement is resized due to having width or height as auto or percent 
	 * and the graphic has finished loading. 
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 */
	
	[Event(name="inlineGraphicStatusChanged", type="org.apache.royale.textLayout.events.StatusChangeEvent")]
	
	/** Dispatched by a ITextFlow object after text is scrolled within a controller container.  
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 */
	
	[Event(name="scroll", type="org.apache.royale.textLayout.events.TextLayoutEvent")]
	
	/** Dispatched by a ITextFlow object each time it is damaged 
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 */
	
	[Event(name="damage", type="org.apache.royale.textLayout.events.DamageEvent")]

	/** Dispatched by a ITextFlow object each time a container has had new DisplayObjects added or updated as a result of composition.
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 */
	
	[Event(name="updateComplete", type="org.apache.royale.textLayout.events.UpdateCompleteEvent")]
		
	[Exclude(name="getBaseSWFContext",kind="method")]
	
	[Exclude(name="callInContext",kind="method")]
	/** Manages text in a container. Assumes that it manages all children of the container. 
	 * Consider using TextContainerManager for better performance in cases where there is a 
	 * one container per ITextFlow, and the ITextFlow is not the main focus, is static text, or
	 * is infrequently selected. Good for text in form fields, for example.
	 * 
 	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 * 
	 * @see ContainerController
	 */
	public class TextContainerManager extends EventDispatcher implements ISWFContext, IInteractionEventHandler, ISandboxSupport, ITextContainerManager
	{		
		// all events that are listened for need to be in this list.
		private const eventList:Array = [ 
			FlowOperationEvent.FLOW_OPERATION_BEGIN,
			FlowOperationEvent.FLOW_OPERATION_END,
			FlowOperationEvent.FLOW_OPERATION_COMPLETE,
			SelectionEvent.SELECTION_CHANGE,
			CompositionCompleteEvent.COMPOSITION_COMPLETE,
			MouseEvent.CLICK,		//from FlowElementMouseEvent
			MouseEvent.MOUSE_DOWN,	//from FlowElementMouseEvent
			MouseEvent.MOUSE_OUT,	//from FlowElementMouseEvent
			MouseEvent.MOUSE_UP,	//from FlowElementMouseEvent
			MouseEvent.MOUSE_OVER,	//from FlowElementMouseEvent
			MouseEvent.MOUSE_OUT,	//from FlowElementMouseEvent
			StatusChangeEvent.INLINE_GRAPHIC_STATUS_CHANGE,
		 	TextLayoutEvent.SCROLL,
			DamageEvent.DAMAGE,
			UpdateCompleteEvent.UPDATE_COMPLETE
		];
		
		/** Configuration to be used by the TextContainerManager.  This can only be set once and before the inputmanager is used.  */
		static private var _defaultConfiguration:IConfiguration = null;

		/** The default configuration for this TextContainerManager. Column and padding attributes
		 * are set to <code>FormatValue.INHERIT</code>.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 * 
	 	 * @see org.apache.royale.textLayout.elements.IConfiguration IConfiguration
	 	 * @see org.apache.royale.textLayout.formats.FormatValue#INHERIT FormatValue.INHERIT
		 */
		static public function get defaultConfiguration():IConfiguration
		{
			if (_defaultConfiguration == null)
				_defaultConfiguration = customizeConfiguration(null);
			return _defaultConfiguration; 
		}
		
		/** @private Make a configuration acceptable to the TCM */
		static public function customizeConfiguration(config:IConfiguration):IConfiguration
		{
			var newConfig:IConfiguration;
			if (config)
			{
				if (config.flowComposerClass == FactoryUtil.getDefaultFlowComposerClass())
					return config;
				newConfig = config.clone();
			}
			else
				newConfig = new Configuration();
			newConfig.flowComposerClass = FactoryUtil.getDefaultFlowComposerClass();
			return newConfig;
		}
		
		static private var _inputManagerTextFlowFactory:TCMTextFlowTextLineFactory;
		static private function inputManagerTextFlowFactory():TCMTextFlowTextLineFactory
		{
			if (!_inputManagerTextFlowFactory)
				_inputManagerTextFlowFactory  = new TCMTextFlowTextLineFactory();
			return _inputManagerTextFlowFactory;
		}

		// dictionary of stringfactories so that they can share a configuration
		static private var stringFactoryDictionary:ObjectMap;
		static private function inputManagerStringFactory(config:IConfiguration):StringTextLineFactory
		{
			if (!stringFactoryDictionary)
				stringFactoryDictionary = new ObjectMap(true);
			var factory:StringTextLineFactory = stringFactoryDictionary[config];
			if (factory == null)
			{
				factory = new StringTextLineFactory(config);
				stringFactoryDictionary[config] = factory;
			}
			return factory;
		}
		
		/** @private Method to release all references to factories so they can be gc'ed, for example when Flex unloads a module. */
		static public function releaseReferences():void
		{
			stringFactoryDictionary = null;
			_inputManagerTextFlowFactory = null;
		}
		
		/** Shared definition of the scrollPolicy property. @private */
		public const editingModePropertyDefinition:Property = PropertyFactory.enumString("editingMode", EditingMode.READ_WRITE, false, null, 
			EditingMode.READ_WRITE, EditingMode.READ_ONLY, EditingMode.READ_SELECT);	
		
		private var _container:IParentIUIBase;
		private var _compositionWidth:Number;
		private var _compositionHeight:Number;
		
		private var _text:String;
		private var _textDamaged:Boolean;				// indicates the _text property needs updating when sourceState is SOURCE_TEXTFLOW
		private var _lastSeparator:String;
		
		private var _hostFormat:ITextLayoutFormat;
		// textFlow format to be used by a string factory - combination of config.initialTextLayoutFormat and hostFormat
		private var _stringFactoryTextFlowFormat:ITextLayoutFormat;
		
		private var _contentTop:Number;
		private var _contentLeft:Number;
		private var _contentHeight:Number;
		private var _contentWidth:Number;
		
		private var _horizontalScrollPolicy:String;
		private var _verticalScrollPolicy:String;
		
		private var _swfContext:ISWFContext;
		private var _config:IConfiguration;
		
		//Decide whether to preserve the selection state when calling setText() [bug #2931406 from Flex SDK]
		private var _preserveSelectionOnSetText:Boolean = false;
		
		/** @private */
		static public const SOURCE_STRING:int = 0;
		/** @private */
		static public const SOURCE_TEXTFLOW:int = 1;
		
		/** @private */
		static public const COMPOSE_FACTORY:int = 0;
		/** @private */
		static public const COMPOSE_COMPOSER:int = 1;
		
		/** @private */
		static public const HANDLERS_NOTADDED:int  = 0;
		/** @private */
		static public const HANDLERS_NONE:int      = 1;
		/** @private */
		static public const HANDLERS_CREATION:int  = 2;
		/** @private */
		static public const HANDLERS_ACTIVE:int    = 3;
		/** @private */
		static public const HANDLERS_MOUSEWHEEL:int = 4;
		
		private var _sourceState:int;
		private var _composeState:int;
		private var _handlersState:int;
		// track hasFocus.  Depending on various factors focus and mouseDown can occur in different order
		private var _hasFocus:Boolean;
		private var _editingMode:String;
		private var _ibeamCursorSet:Boolean;
		private var _interactionCount:int;
		
		/** @private */
		public function get sourceState():int
		{ return _sourceState; }
		/** @private */
		public function get composeState():int
		{ return _composeState; }
		/** @private */
		public function get handlersState():int
		{ return _handlersState; }
	
		// Tracks damage when sourceState is SOURCE_STRING. TODO - Might be worthwhile to always set and clear this
		private var _damaged:Boolean;			
		private var _textFlow:ITextFlow;
		private var _needsRedraw:Boolean;
		
		/** Constructor function - creates a TextContainerManager instance.
		 *
		 * For best results:
		 * <ol>
		 *	<li>Start with TextContainerManager.defaultConfiguration and modify it</li>   
		 *	<li>Share the same Configuration among many InputManagers</li>
		 * </ol>
		 *
		 * @param container The DisplayObjectContainer in which to manage the text lines.
		 * @param config - The IConfiguration instance to use with this TextContainerManager instance. 
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0	 	
		 */
		public function TextContainerManager(container:IParentIUIBase,configuration:IConfiguration =  null)
		{
			_container = container;
			_compositionWidth = 100;
			_compositionHeight = 100;
			
			_config = configuration ? customizeConfiguration(configuration) : defaultConfiguration;				
			_config = _config.getImmutableClone();

			_horizontalScrollPolicy = _verticalScrollPolicy = String(ScrollPolicy.scrollPolicyPropertyDefinition.defaultValue);

			_damaged = true;
			_needsRedraw = false;
			_text = "";
			_textDamaged = false;
			
			_sourceState = SOURCE_STRING;
			_composeState = COMPOSE_FACTORY;
			_handlersState = HANDLERS_NOTADDED;
			_hasFocus = false;
			
			_editingMode = editingModePropertyDefinition.defaultValue as String;
			_ibeamCursorSet = false;
			_interactionCount = 0;

//TODO deal with Flash properties below.
			
//			if (_container is InteractiveObject)
//			{
//				_container.doubleClickEnabled = true;
//				// so the textlines can be swapped on the first click and a double click still works
//				_container.mouseChildren = false;
//				_container.focusRect = false;
//			}
		}

		/** Returns the container (DisplayObjectContainer) that holds the text that this TextContainerManager manages.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 *
	 	 * @see ContainerController#container
	 	 */
	 	 
		public function get container():IParentIUIBase
		{ return _container; }
		
		/** Returns <code>true</code> if the content needs composing. 
		 * 
		 * @return	<code>true</code> if the content needs composing; <code>false</code> otherwise.
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 */
		public function isDamaged():Boolean
		{ return _composeState == COMPOSE_FACTORY ? _damaged : _textFlow.flowComposer.isPotentiallyDamaged(_textFlow.textLength); }
		
		/** Editing mode of this TextContainerManager. Modes are reading only, reading and selection permitted, 
		 * and editing (reading, selection, and writing)  permitted. Use the constant values of the EditingMode
		 * class to set this property. 
		 * <p>Default value is READ_WRITE.</p>
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 *
		 * @see org.apache.royale.textLayout.edit.EditingMode EditingMode
		 */
		public function get editingMode():String
		{ return _editingMode; }
		public function set editingMode(val:String):void
		{
			var newMode:String = editingModePropertyDefinition.setHelper(_editingMode, val) as String;
			
			if (newMode != _editingMode)
			{
				if (composeState == COMPOSE_COMPOSER)
				{
					_editingMode = newMode;
					invalidateInteractionManager();
				}
				else
				{
					removeActivationEventListeners();
					_editingMode = newMode;
					// there is no way to turn it on here if going from READ_ONLY to editable and mouse is over the inputmanager field
					if (_editingMode == EditingMode.READ_ONLY)
						removeIBeamCursor();
					addActivationEventListeners();
				}
			}
		}
		
		/**
		 * Returns the current text using a separator between paragraphs.
		 * The separator can be specified with the <code>separator</code>
		 * argument. The default value of the <code>separator</code> argument
		 * is the Unicode character <code>'PARAGRAPH SEPARATOR' (U+2029)</code>.
		 *
		 * <p>Calling the setter discards any attached ITextFlow. Any selection is lost.</p>
		 * 
		 * @param separator String to set between paragraphs.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
	 	 */
		public function getText(separator:String = '\u2029'):String
		{
			if (_sourceState == SOURCE_STRING)
				return _text;

			if (_textDamaged || _lastSeparator != separator)
			{
				_text = "";
				var firstLeaf:IFlowLeafElement = _textFlow.getFirstLeaf();
				if (firstLeaf != null)
				{
					var para:IParagraphElement = firstLeaf.getParagraph();
					while (para)
					{
						var nextPara:IParagraphElement = para.getNextParagraph();
						_text += para.getText();
						_text += nextPara ? separator : "";
						para = nextPara;
					}
				}
				_textDamaged = false;
				_lastSeparator = separator;
			}
			return _text;
		}
		/**
		 * Sets the <code>text</code> property to the specified String.
		 *
		 * Discards any attached ITextFlow. Any selection is lost.
		 * 
		 * @param str the String to set
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
	 	 */
		public function setText(text:String):void
		{
			var hadPreviousSelection:Boolean = false;
			var selectionChanged:Boolean = false;
//			var selectionState:SelectionState = null;
            
            var oldAnchorPosition:int = -1;
            var oldActivePosition:int = -1;
            
			if (_sourceState == SOURCE_TEXTFLOW)
			{
				if (_textFlow.interactionManager && _textFlow.interactionManager.hasSelection()){
					hadPreviousSelection = true;
					
					//preserve the selection state [bug #2931406 from Flex SDK]
					if (_preserveSelectionOnSetText && text != null)
                    {
                        oldAnchorPosition = Math.min(_textFlow.interactionManager.anchorPosition, text.length);
                        oldActivePosition = Math.min(_textFlow.interactionManager.activePosition, text.length);
						if(oldAnchorPosition != _textFlow.interactionManager.anchorPosition || oldActivePosition != _textFlow.interactionManager.activePosition)
							selectionChanged = true;
					}
				}
				
				removeTextFlowListeners();
				if (_textFlow.flowComposer)
					_textFlow.flowComposer.removeAllControllers();
				_textFlow.unloadGraphics();
				_textFlow = null;
				_sourceState = SOURCE_STRING;
				_composeState = COMPOSE_FACTORY;
				//TODO do we need to fix this?
//				if (_container is InteractiveObject)
//					_container.mouseChildren = false;
			}
			addActivationEventListeners();
			_text = text ? text : ""; 
			_damaged = true;
			_textDamaged = false;
			
			// Generate a damage event 
			if (hasEventListener(DamageEvent.DAMAGE))
				dispatchEvent(new DamageEvent(DamageEvent.DAMAGE, false, false, null, 0, _text.length));
			
            // If the original tcm had selection, the selection needs to be preserved after setText.
            if (hadPreviousSelection)
            {
                if (_preserveSelectionOnSetText)
                {
					if (_composeState != COMPOSE_COMPOSER)
                    	convertToTextFlowWithComposer();
                    if (_textFlow.interactionManager)
					{
						_textFlow.interactionManager.setSelectionState(new SelectionState(_textFlow, oldAnchorPosition, oldActivePosition));
						if(selectionChanged)
							_textFlow.dispatchEvent(new SelectionEvent(SelectionEvent.SELECTION_CHANGE, false, false, _textFlow.interactionManager.getSelectionState()));
					}
                }
                else if (hasEventListener(SelectionEvent.SELECTION_CHANGE))
                {
                    // generate a selection changed event.
                    dispatchEvent(new SelectionEvent(SelectionEvent.SELECTION_CHANGE, false, false, null));
                }
            }    

			if (_hasFocus)
				requiredFocusInHandler(null);
		}
				
		/** Sets the format when display just a string.  If displaying a ITextFlow this has no immediate effect.  The supplied ITextLayoutFormat is not copied.  Modifying it without calling this setter has indeterminate effects. */
		public function get hostFormat():ITextLayoutFormat
		{ return _hostFormat; }
		public function set hostFormat(val:ITextLayoutFormat):void
		{
			_hostFormat = val;
			_stringFactoryTextFlowFormat = null;
			
			if (_sourceState == SOURCE_TEXTFLOW)
				_textFlow.hostFormat = _hostFormat;
			if (_composeState == COMPOSE_FACTORY)
				_damaged = true;
		}
		
		/** Returns the horizontal extent allowed for text inside the container. The value is specified in pixels.
		 * 
		 * <p>After setting this property, the text in the container is damaged and requires composing.</p>
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0  
	 	 */
		public function get compositionWidth():Number
		{ return _compositionWidth; }
		public function set compositionWidth(val:Number):void
		{
			if (_compositionWidth == val || (isNaN(_compositionWidth) && isNaN(val)))
				return;
			_compositionWidth = val; 
			if (_composeState == COMPOSE_COMPOSER)
			{
				getController().setCompositionSize(_compositionWidth,_compositionHeight);
			}
			else
			{
				_damaged = true; 
			}
		}
	
		/** Returns the vertical extent allowed for text inside the container. The value is specified in pixels. 
		 * <p>After setting this property, the text in the container is damaged and requires composing.</p>
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 */
	 	 
		public function get compositionHeight():Number
		{ return _compositionHeight; }
		public function set compositionHeight(val:Number):void
		{
			if (_compositionHeight == val || (isNaN(_compositionHeight) && isNaN(val)))
				return;
			_compositionHeight = val; 
			if (_composeState == COMPOSE_COMPOSER)
			{
				getController().setCompositionSize(_compositionWidth,_compositionHeight);
			}
			else
			{
				_damaged = true; 
			}
		}
		
		/** The Configuration object for this TextContainerManager. 
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 *
	 	 * @see org.apache.royale.textLayout.IConfiguration IConfiguration
	 	 */
		public function get configuration():IConfiguration
		{ return _config; }
			
		/** Creates a rectangle that shows where the last call to either the <code>compose()</code> 
		 * method or the <code>updateContainer()</code> method placed the text.
		 *
		 * @return  the bounds of the content
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 *
	 	 * @see #compose()
	 	 * @see #updateContainer()
		 */
		public function getContentBounds():Rectangle
		{
			if (_composeState == COMPOSE_FACTORY)
				return new Rectangle(_contentLeft, _contentTop, _contentWidth, _contentHeight);
			var controller:IContainerController = getController();
			return controller.getContentBounds();
		}	
		
		/** The current ITextFlow. Converts this to a full ITextFlow representation if it 
		 * isn't already one. 
		 *
		 * @return 	the current ITextFlow object
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 */
		public function getTextFlow():ITextFlow
		{
			if (_sourceState != SOURCE_TEXTFLOW)
			{
				var wasDamaged:Boolean = isDamaged();
				convertToTextFlow();
				if (!wasDamaged)
					updateContainer();
			}
			return _textFlow;
		}

		/** Sets a ITextFlow into this TextContainerManager replacing any existing ITextFlow and discarding the 
		 * current text. 
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 */
		public function setTextFlow(textFlow:ITextFlow):void
		{
			if (textFlow == _textFlow)
				return;
			
			if (textFlow == null)
			{
				setText(null);
				return;
			}
						
			// Remove the old textFlow from its TextContainerManager, if it has one
			if (textFlow.flowComposer && textFlow.flowComposer.numControllers > 0 && textFlow.flowComposer.getControllerAt(0) is TMContainerController)
			{
				var controller:TMContainerController = textFlow.flowComposer.getControllerAt(0) as TMContainerController;
				if (controller.textContainerManager && controller.textContainerManager.getTextFlow() == textFlow)
					controller.textContainerManager.setTextFlow(null);
			}  

			if (_sourceState == SOURCE_TEXTFLOW)
			{
				removeTextFlowListeners();
				if (_textFlow.flowComposer)
					_textFlow.flowComposer.removeAllControllers();
				_textFlow.unloadGraphics();
				_textFlow = null;
			}
				
			_textFlow = textFlow;
			// damages the entire flow
			_textFlow.hostFormat = hostFormat;
			_sourceState = SOURCE_TEXTFLOW;
			_composeState = textFlow.interactionManager || textFlow.mustUseComposer() ? COMPOSE_COMPOSER : COMPOSE_FACTORY;
			_textDamaged = true;
			addTextFlowListeners();
			
			if (_composeState == COMPOSE_COMPOSER)
			{
				// Possible issue - this clear call could be delayed until updateToController
				//TODO mouseChildren
//				_container.mouseChildren = true;
				clearContainerChildren(true);
				clearComposedLines();
				_textFlow.flowComposer = StandardHelper.getNewComposer();
				_textFlow.flowComposer.swfContext = _swfContext;
				_textFlow.flowComposer.addController(new TMContainerController(_container,_compositionWidth,_compositionHeight,this));
				
				invalidateInteractionManager();
				
				// always start with an empty selection
				if (_textFlow.interactionManager)
					_textFlow.interactionManager.selectRange(-1,-1);
			}
			else
				_damaged = true;
			
			if (_hasFocus)
				requiredFocusInHandler(null);
			
			addActivationEventListeners();
		}
		
		/** 
		 * Controls whether the factory generates all text lines or stops when the container bounds are filled.
		 * 
		 * @copy org.apache.royale.textLayout.container.ContainerController#horizontalScrollPolicy 
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
	 	 */
	 	public function get horizontalScrollPolicy():String
		{
			return _horizontalScrollPolicy;
		}
		public function set horizontalScrollPolicy(scrollPolicy:String):void
		{
			_horizontalScrollPolicy = ScrollPolicy.scrollPolicyPropertyDefinition.setHelper(_horizontalScrollPolicy, scrollPolicy) as String;
			if (_composeState == COMPOSE_COMPOSER)
				getController().horizontalScrollPolicy = _horizontalScrollPolicy;
			else
				_damaged = true;
		}
		
		/** 
		 * Controls whether the factory generates all text lines or stops when the container bounds are filled.
		 * 
		 * @copy org.apache.royale.textLayout.container.ContainerController#verticalScrollPolicy 
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
	 	 */
	 	 
		public function get verticalScrollPolicy():String
		{
			return _verticalScrollPolicy;
		}
		public function set verticalScrollPolicy(scrollPolicy:String):void
		{
			_verticalScrollPolicy = ScrollPolicy.scrollPolicyPropertyDefinition.setHelper(_verticalScrollPolicy, scrollPolicy) as String;
			if (_composeState == COMPOSE_COMPOSER)
				getController().verticalScrollPolicy = _verticalScrollPolicy;
			else
				_damaged = true;
		}
			
		/** 
		 * @copy org.apache.royale.textLayout.container.ContainerController#horizontalScrollPosition
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
	 	 */
		public function get horizontalScrollPosition():Number
		{ return _composeState == COMPOSE_COMPOSER ? getController().horizontalScrollPosition : 0; }
		public function set horizontalScrollPosition(val:Number):void
		{ 
			if (val == 0 && _composeState == COMPOSE_FACTORY)
				return;
			if (_composeState != COMPOSE_COMPOSER)
				convertToTextFlowWithComposer();
			getController().horizontalScrollPosition = val;
		}
		
		/** 
		 * @copy org.apache.royale.textLayout.container.ContainerController#verticalScrollPosition 
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
	 	 */
		public function get verticalScrollPosition():Number
		{ return _composeState == COMPOSE_COMPOSER ? getController().verticalScrollPosition : 0; }
		public function set verticalScrollPosition(val:Number):void
		{
			if (val == 0 && _composeState == COMPOSE_FACTORY)
				return;
			if (_composeState != COMPOSE_COMPOSER)
				convertToTextFlowWithComposer();
			getController().verticalScrollPosition = val;
		}

		/** 
		* @copy org.apache.royale.textLayout.container.ContainerController#getScrollDelta() 
		*
		* @playerversion Flash 10
		* @playerversion AIR 1.5
		* @langversion 3.0
	 	*/
		public function getScrollDelta(numLines:int):Number
		{
			if (_composeState != COMPOSE_COMPOSER)
				convertToTextFlowWithComposer();
			return getController().getScrollDelta(numLines);
		}
		
		/** 
		* @copy org.apache.royale.textLayout.container.ContainerController#scrollToRange() 
		*
		* @playerversion Flash 10
		* @playerversion AIR 1.5
		* @langversion 3.0
	 	*/
	 	public function scrollToRange(activePosition:int,anchorPosition:int):void
	 	{
			if (_composeState != COMPOSE_COMPOSER)
				convertToTextFlowWithComposer();
			getController().scrollToRange(activePosition,anchorPosition);	 		
	 	}

		/** 
		* Optional ISWFContext instance used to make FTE calls as needed in the proper swf context. 
		*
		* 
		* @see org.apache.royale.textLayout.compose.ISWFContext
		* 
		* @playerversion Flash 10
		* @playerversion AIR 1.5
	 	* @langversion 3.0
	 	*/
 	
		public function get swfContext():ISWFContext
		{ return _swfContext; }
		public function set swfContext(context:ISWFContext):void
		{ 
			_swfContext = context;
			if (_composeState == COMPOSE_COMPOSER)
				_textFlow.flowComposer.swfContext = _swfContext;
			else
				_damaged = true;
		}
		
		/** @private - TextContainerManager wraps an underlying swfcontext - tell it to FlowComposerBase so it can avoid extra invalidation */
		public function getBaseSWFContext():ISWFContext
		{ return _swfContext; }
				
		/** @private - this is part of a performance optimziation for reusing existing TextLines in place iff recreateTextLine is available. */
	    public function callInContext(fn:Function, thisArg:Object, argsArray:Array, returns:Boolean=true):*
		{
			var textBlock:ITextBlock = thisArg as ITextBlock;
			if (textBlock && _expectedFactoryCompose == FactoryHelper.staticComposer)
			{
			 	if (fn == textBlock.createTextLine)
					return createTextLine(textBlock,argsArray);
				// if (Configuration.playerEnablesArgoFeatures && fn == thisArg["recreateTextLine"])
					return recreateTextLine(textBlock,argsArray);
			}

			var swfContext:ISWFContext = _swfContext ? _swfContext : SWFContext.globalSWFContext;
	        if (returns)
	            return swfContext.callInContext(fn,thisArg,argsArray,returns);
			swfContext.callInContext(fn,thisArg,argsArray,returns);
		}
		
		public function resetLine(textLine:ITextLine):void
		{
			// this line is being reset
			if (textLine == _composedLines[_composeRecycledInPlaceLines-1])
				_composeRecycledInPlaceLines--;
		}
		
		/** 
		 * Uses the <code>textBlock</code> parameter, and calls the <code>ITextBlock.createTextLine()</code> method on it 
		 * using the remaining parameters.
		 * WARNING: modifies argsArray
		 *  
		 * @copy org.apache.royale.text.engine.ITextBlock
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 */
		private function createTextLine(textBlock:ITextBlock, argsArray:Array):ITextLine
		{
			var swfContext:ISWFContext = _swfContext ? _swfContext : SWFContext.globalSWFContext;
			// CONFIG::debug { assert(Configuration.playerEnablesArgoFeatures,"Bad call to createTextLine"); }

			if (_composeRecycledInPlaceLines < _composedLines.length && _expectedFactoryCompose == FactoryHelper.staticComposer)
			{
				var textLine:ITextLine = _composedLines[_composeRecycledInPlaceLines++];

				argsArray.splice(0,0,textLine);
				return swfContext.callInContext(textBlock["recreateTextLine"],textBlock,argsArray);
			}

			return swfContext.callInContext(textBlock.createTextLine,textBlock,argsArray);
		}

		/** 
		 * Uses the <code>textBlock</code> parameter, and calls the <code>FlowComposerBase.recreateTextLine()</code> method on it 
		 * using the remaining parameters.
		 *
		 * @param textBlock The ITextBlock to which the ITextLine belongs.
		 * @param textLine  The ITextLine to be recreated.
		 * @param previousLine Specifies the previously broken line after 
		 *	which breaking is to commence. Can be null when breaking the first line.  
		 * @param width Specifies the desired width of the line in pixels. The 
		 * 	actual width may be less.  
		 * @param lineOffset An optional parameter which specifies the difference in 
		 *	pixels between the origin of the line and the origin of the tab stops. This can be used when lines are not aligned, 
		 * 	but it is desirable for their tabs to be so. 
		 * @param fitSomething An optional parameter that instructs the runtime to fit at least one 
		 * 	character into the text line, no matter what width has been specified (even if width is zero or negative, which 
		 * 	would otherwise result in an exception being thrown).  
		 * @return The recreated ITextLine instance.
		 *  
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 */
		private function recreateTextLine(textBlock:ITextBlock, argsArray:Array):ITextLine
		{
			var swfContext:ISWFContext = _swfContext ? _swfContext : SWFContext.globalSWFContext;
			// CONFIG::debug { assert(Configuration.playerEnablesArgoFeatures,"Bad call to createTextLine"); }

			if (_composeRecycledInPlaceLines < _composedLines.length)
			{
				CONFIG::debug {assert(argsArray[0] != _composedLines[_composeRecycledInPlaceLines],"Bad args"); }
				TextLineRecycler.addLineForReuse(argsArray[0]);	// not going to use this one
				argsArray[0] = _composedLines[_composeRecycledInPlaceLines++];
			}
			return swfContext.callInContext(textBlock["recreateTextLine"],textBlock,argsArray);
		}

		
		/** Returns the current ISelectionManager instance. Converts to ITextFlow instance and creates one if necessary. 
		 *
		 * @return  the interaction manager for this TextContainerManager instance.
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 *
	 	 * @see org.apache.royale.textLayout.edit.ISelectionManager ISelectionManager
	 	 */
		public function beginInteraction():ISelectionManager
		{
			++_interactionCount;
			if (_composeState != COMPOSE_COMPOSER)
				convertToTextFlowWithComposer();
			return _textFlow.interactionManager;
		}
		
		/** Terminates interaction. 
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 * @see org.apache.royale.textLayout.edit.ISelectionManager ISelectionManager
	 	 */
		
		public function endInteraction():void
		{
			--_interactionCount;
		}
		
		/** Call this if you are editing, and want to reset the undo manager used for editing.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 */
		public function invalidateUndoManager():void
		{
			if (_editingMode == EditingMode.READ_WRITE)
				invalidateInteractionManager(true);
		}
		
		
		/** Call this if you change the selection formats (SelectionFormat) and want the interactionManager 
		 * to update. 
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
	 	 */
		public function invalidateSelectionFormats():void
		{
			invalidateInteractionManager();
		}
		
		/** The interactionManager is invalid - update it. Clients should call this if they change the 
		 * selectionFormats.  Its called automatically if editingMode is changed. */
		private function invalidateInteractionManager(alwaysRecreateManager:Boolean = false):void
		{
			if (_composeState == COMPOSE_COMPOSER)
			{
				var interactionManager:ISelectionManager = _textFlow.interactionManager;
				var activePos:int = interactionManager ? interactionManager.activePosition : -1;
				var anchorPos:int = interactionManager ? interactionManager.anchorPosition : -1;

				if (_editingMode == EditingMode.READ_ONLY)
				{
					if (interactionManager)
						_textFlow.interactionManager = null;
				}
				else if (_editingMode == EditingMode.READ_WRITE)
				{
					if (alwaysRecreateManager || interactionManager == null || interactionManager.editingMode == EditingMode.READ_SELECT)
					{
						_textFlow.interactionManager = createEditManager(getUndoManager());
						if (_textFlow.interactionManager is SelectionManager)
							SelectionManager(_textFlow.interactionManager).cloneSelectionFormatState(interactionManager);
					}
				}
				else if (_editingMode == EditingMode.READ_SELECT)
				{
					if (alwaysRecreateManager || interactionManager == null || interactionManager.editingMode == EditingMode.READ_WRITE)
					{
						_textFlow.interactionManager = createSelectionManager();
						if (_textFlow.interactionManager is SelectionManager)
							SelectionManager(_textFlow.interactionManager).cloneSelectionFormatState(interactionManager);
					}
				}
				
				interactionManager = _textFlow.interactionManager;
				if (interactionManager)
				{
					interactionManager.unfocusedSelectionFormat  = getUnfocusedSelectionFormat();
					interactionManager.focusedSelectionFormat    = getFocusedSelectionFormat();
					interactionManager.inactiveSelectionFormat = getInactiveSelectionFormat();
					interactionManager.selectRange(anchorPos,activePos);
				}				
			}
		}
		
		/**Create a selection manager to use for selection. Override this method if you have a custom SelectionManager that you
		 * want to use in place of the default.
		 *
		 * @return	a new SelectionManager instance.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
		 */
		protected function createSelectionManager():ISelectionManager
		{
			return new SelectionManager();
		}
		
		/**Create an edit manager to use for editing. Override this method if you have a custom EditManager that you
		 * want to use in place of the default.
		 *
		 * @param  an IUndoManager instance for the EditManager being created.
		 * @return	the editing manager for this TextContainerManager instance.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
		 */
		protected function createEditManager(undoManager:IUndoManager):IEditManager
		{
			return new EditManager(undoManager);
		}
		
		private function getController():TMContainerController
		{ return _textFlow.flowComposer.getControllerAt(0) as TMContainerController; }

		/** @private */
		public var _composedLines:Array = [];
		
		/** Return the ITextLine at the index from array of composed lines.
		 *
		 * @param index	Finds the line at this index position in the text.
		 *
		 * @return 	the ITextLine that occurs at the specified index.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
		 */
		public function getLineAt(index:int):ITextLine
		{ 
			// note: this method is not reliable for damaged text
			if (_composeState == COMPOSE_FACTORY)
			{
				// watch out for the empty TCM optimization and make a ITextLine
				if (_sourceState == SOURCE_STRING && _text.length == 0 && !_damaged && _composedLines.length == 0)
				{					
					if (_needsRedraw)
						compose();
					else
						updateContainer();
					CONFIG::debug { assert(_composeState == COMPOSE_FACTORY,"no longer a factory??"); }
				}
				return _composedLines[index];
			}
			var tfl:ITextFlowLine = _textFlow.flowComposer.getLineAt(index);
			return tfl ? tfl.getTextLine(true) : null;
		}
		
		/** @copy org.apache.royale.textLayout.compose.IFlowComposer#numLines 
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 */
		public function get numLines():int
		{ 
			// note: this method is not reliable for damaged text
			if (_composeState == COMPOSE_COMPOSER)
				return _textFlow.flowComposer.numLines;
			// watch out for possibly optimized zero length text
			if (_sourceState == SOURCE_STRING && _text.length == 0)
				return 1;
			return _composedLines.length; 
		}
		
		/** @private 
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function getActualNumLines():int
		{ 
			if (_composeState != COMPOSE_COMPOSER)
				convertToTextFlowWithComposer();
			// composes all lines
			_textFlow.flowComposer.composeToPosition();
			return _textFlow.flowComposer.numLines;
		}
		
		/** @private */
		public function clearComposedLines():void
		{
			if (_composedLines)
				_composedLines.length = 0;
		}
		
		private function populateComposedLines(displayObject:ITextLine):void
		{
			_composedLines.push(displayObject);
		}
		
		// TODO FOR ARGO - think about moving these variables into a separate helper class 
		private var _composeRecycledInPlaceLines:int;
		private var _composePushedLines:int;
		private function populateAndRecycleComposedLines(object:Object):void
		{
			var textLine:ITextLine = object as ITextLine;
			if (textLine)
			{
				CONFIG::debug { assert(_composePushedLines >= _composedLines.length || _composedLines[_composePushedLines] == textLine,"mismatched recycled textline"); }
				if (_composePushedLines >= _composedLines.length)
					_composedLines.push(textLine);
			}
			else	// this is the background color and goes at the head of the list
				_composedLines.splice(0,0,object);
			_composePushedLines++;
		}		
		
		static private var _expectedFactoryCompose:ISimpleCompose;

		
		/** Composes the container text; calls either the factory or <code>updateAllControllers()</code>.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 */
		public function compose():void
		{
			if (_composeState == COMPOSE_COMPOSER)
				_textFlow.flowComposer.compose();
			else if (_damaged)
			{
				if (_sourceState == SOURCE_TEXTFLOW && _textFlow.mustUseComposer())
				{
					convertToTextFlowWithComposer(false);
					_textFlow.flowComposer.compose();
					return;
				}
				else
				{
					var callback:Function;
					// if (Configuration.playerEnablesArgoFeatures)
					// {
						// while the first thing in the array is not a ITextLine its the background color OR its some floats OR something else from the last compose - remove it
						for (;;)
						{
							var firstObj:Object = _composedLines[0];
							if (firstObj == null || (firstObj is ITextLine))
								break;
							_composedLines.splice(0,1);
						}
						_composeRecycledInPlaceLines = 0;
						_composePushedLines = 0;
						callback = populateAndRecycleComposedLines;
					// }
					// else
					// {
					// 	clearComposedLines();
					// 	callback = populateComposedLines;
					// }
					var inputManagerFactory:TextLineFactoryBase = (_sourceState == SOURCE_STRING) ? inputManagerStringFactory(_config) : inputManagerTextFlowFactory();
					inputManagerFactory.verticalScrollPolicy = _verticalScrollPolicy;
					inputManagerFactory.horizontalScrollPolicy = _horizontalScrollPolicy;
					inputManagerFactory.compositionBounds = new Rectangle(0,0,_compositionWidth,_compositionHeight);
					inputManagerFactory.swfContext = this;//Configuration.playerEnablesArgoFeatures ? this : _swfContext;
					
					// compose can recurse for composing.  this sets up the swfContext so it doesn't recycle a line into a numberline
					_expectedFactoryCompose = TextLineFactoryBase.peekFactoryCompose();
					if (_sourceState == SOURCE_STRING)
					{
						var stringFactory:StringTextLineFactory = inputManagerFactory as StringTextLineFactory;
						if (!_stringFactoryTextFlowFormat)
						{
							if (_hostFormat == null)
								_stringFactoryTextFlowFormat = _config.textFlowInitialFormat;
							else
							{
								// mini cascade of initialFormat onto the hostFormat
								var format:TextLayoutFormat = new TextLayoutFormat(_hostFormat);
								TextLayoutFormat.resetModifiedNoninheritedStyles(format);
								var holderStyles:Object = (_config.textFlowInitialFormat as TextLayoutFormat).getStyles();
								for (var key:String in holderStyles)
								{
									var val:* = holderStyles[key];
									format[key] = (val !== FormatValue.INHERIT) ? val : _hostFormat[key];
								}
								_stringFactoryTextFlowFormat = format;
							}
						}
						if (!TextLayoutFormat.isEqual(stringFactory.textFlowFormat,_stringFactoryTextFlowFormat))
							stringFactory.textFlowFormat = _stringFactoryTextFlowFormat;
						stringFactory.text = _text;
						stringFactory.createTextLines(callback);
					}
					else
					{
						var factory:TCMTextFlowTextLineFactory = inputManagerFactory as TCMTextFlowTextLineFactory;
						factory.tcm = this;
						factory.createTextLines(callback,_textFlow);
						factory.tcm = null;
					}
					inputManagerFactory.swfContext = null;	// release any references to the swfContext
					_expectedFactoryCompose = null;
							
					// if (Configuration.playerEnablesArgoFeatures)
						_composedLines.length = _composePushedLines;

					var bounds:Rectangle = inputManagerFactory.getContentBounds();
					
					_contentLeft   = bounds.x;
					_contentTop    = bounds.y;
					_contentWidth  = bounds.width;
					_contentHeight = bounds.height;
					_damaged = false;
					
					// generate a compositionComplete event.  Note that the last composed position isn't known
					if (hasEventListener(CompositionCompleteEvent.COMPOSITION_COMPLETE))
						dispatchEvent(new CompositionCompleteEvent(CompositionCompleteEvent.COMPOSITION_COMPLETE,false,false,_textFlow,0,-1));						
				}
				_needsRedraw = true;
			}

		}
		
		/** Updates the display; calls either the factory or updateAllControllers().
		 * 
		 * @return true if anything changed.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 */
		public function updateContainer():Boolean
		{
			if (_composeState == COMPOSE_COMPOSER)
				return _textFlow.flowComposer.updateAllControllers();
			
			compose();
			
			// depending on edits the Flow may now have a composer
			if (_composeState == COMPOSE_COMPOSER)
			{
				_textFlow.flowComposer.updateAllControllers();
				return true;
			}
				
			if (!_needsRedraw)
				return false;
			
			factoryUpdateContainerChildren();									
			drawBackgroundAndSetScrollRect(0,0);
					
			if (_handlersState == HANDLERS_NOTADDED)
				addActivationEventListeners();
	
			// generate a updateComplete event.  Note that the controller isn't known
			if (hasEventListener(UpdateCompleteEvent.UPDATE_COMPLETE))
				dispatchEvent(new UpdateCompleteEvent(UpdateCompleteEvent.UPDATE_COMPLETE,false,false,null));	
			
			_needsRedraw = false;
			return true;	// things changed
		}
		
		/** @private */
		public function factoryUpdateContainerChildren():void
		{
			var textObject:IChild; 	// scratch - TextLines and background shapes
			// if (Configuration.playerEnablesArgoFeatures)
			// {
				// while the first child in the container is a Shape - its the background color OR a Float OR something else - lose it
				while (_container.numElements != 0)
				{
					textObject = _container.getElementAt(0);
					if (textObject is ITextLine)
						break;
					_container.removeElement(textObject);
				}
				
				// add leading children _composedLines that are not TextLines into the Container
				for (var idx:int = 0; idx < _composedLines.length; idx++)
				{
					textObject = _composedLines[idx];
					if (textObject is ITextLine)
						break;
					_container.addElementAt(textObject,idx);
				}
				
				// expect the leading lines are reused
				while (_container.numElements < _composedLines.length)
					_container.addElement(_composedLines[_container.numElements]);
				// recycle any trailing lines
				while (_container.numElements > _composedLines.length)
				{
					var textLine:ITextLine = _container.getElementAt(_composedLines.length) as ITextLine;
					_container.removeElement(textLine);
					if (textLine)
					{
						// lines were rebroken but aren't being displayed
						if (textLine.validity == "valid")
							textLine.textBlock.releaseLines(textLine,textLine.textBlock.lastLine);
						textLine.userData = null;
						TextLineRecycler.addLineForReuse(textLine);
					}
				}
			// }
			// else
			// {
			// 	clearContainerChildren(false);
				
			// 	for each (textObject in _composedLines)
			// 		_container.addElement(textObject);
				
			// 	clearComposedLines();
			// }
		}
		
		private function addActivationEventListeners():void
		{	
			var newState:int =  HANDLERS_NONE;
			
			if (_composeState == COMPOSE_FACTORY)
			{
				if (_editingMode == EditingMode.READ_ONLY)
					newState = HANDLERS_MOUSEWHEEL;
				else
					newState = _handlersState == HANDLERS_NOTADDED ? HANDLERS_CREATION : HANDLERS_ACTIVE;
			}
			
			if (newState == _handlersState)
				return;
			
			removeActivationEventListeners();
				
			if (newState == HANDLERS_CREATION)
			{
				_container.addEventListener(FocusEvent.FOCUS_IN, requiredFocusInHandler);				
				_container.addEventListener(MouseEvent.MOUSE_OVER, requiredMouseOverHandler);
			}
			else if (newState == HANDLERS_ACTIVE)
			{
				_container.addEventListener(FocusEvent.FOCUS_IN, requiredFocusInHandler);				
				_container.addEventListener(MouseEvent.MOUSE_OVER, requiredMouseOverHandler);
				_container.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				_container.addEventListener(MouseEvent.MOUSE_OUT,  mouseOutHandler);
				_container.addEventListener(MouseEvent.WHEEL, mouseWheelHandler);
			//	_container.addEventListener(IMEEvent.IME_START_COMPOSITION, imeStartCompositionHandler);
			// attach by literal event name to avoid Argo dependency
				_container.addEventListener("imeStartComposition", imeStartCompositionHandler);
				
				//TODO deal with contxt menus
				// If TCM's getContextMenu returns null assume client has control of the contextMenu
//				if (getContextMenu() != null)
//					_container.contextMenu = _contextMenu;
//				if (_container.contextMenu)
//					_container.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT, menuSelectHandler);
		            
		        _container.addEventListener(SelectionEvent.SELECT_ALL, editHandler);
			}
			else if (newState == HANDLERS_MOUSEWHEEL)
				_container.addEventListener(MouseEvent.WHEEL, mouseWheelHandler);				
			
			_handlersState = newState;
		}
		
		// The ContextMenu to be used.  The idea is that this is undefined until createContextMenu is called and then 
		// createContextMenu is only called once and the result is shared with the ContainerController when it gets created
		private var _contextMenu:*;
		
		/** @private  Returns the already created contextMenu.  If not created yet create it.  */
		public function getContextMenu():ContextMenu
		{
			if (_contextMenu === undefined)
				_contextMenu = createContextMenu();
			return _contextMenu;
		}

		private function removeActivationEventListeners():void
		{
			if (_handlersState == HANDLERS_CREATION)
			{
				CONFIG::debug { assert(_composeState != COMPOSE_COMPOSER,"Bad call to removeActivationEventListeners"); }
				_container.removeEventListener(FocusEvent.FOCUS_IN, requiredFocusInHandler);				
				_container.removeEventListener(MouseEvent.MOUSE_OVER, requiredMouseOverHandler);
			}
			else if (_handlersState == HANDLERS_ACTIVE)
			{
				CONFIG::debug { assert(_composeState != COMPOSE_COMPOSER,"Bad call to removeActivationEventListeners"); }
				_container.removeEventListener(FocusEvent.FOCUS_IN, requiredFocusInHandler);				
				_container.removeEventListener(MouseEvent.MOUSE_OVER, requiredMouseOverHandler);
				_container.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				_container.removeEventListener(MouseEvent.MOUSE_OUT,  mouseOutHandler);
				_container.removeEventListener(MouseEvent.WHEEL, mouseWheelHandler);
			//	_container.removeEventListener(IMEEvent.IME_START_COMPOSITION, imeStartCompositionHandler);
			// detach by literal event name to avoid Argo dependency
				_container.removeEventListener("imeStartComposition", imeStartCompositionHandler);
				// if _contextMenu is set then this TCM created the contextMenu and is manging it
				//TODO deal with context menus
//				if (_container.contextMenu)
//					_container.contextMenu.removeEventListener(ContextMenuEvent.MENU_SELECT, menuSelectHandler);
//				// otherwise client is managing it
//				if (_contextMenu)	
//					_container.contextMenu = null;

		        _container.removeEventListener(SelectionEvent.SELECT_ALL, editHandler);
			}
			else if (_handlersState == HANDLERS_MOUSEWHEEL)
			{
				CONFIG::debug { assert(_composeState != COMPOSE_COMPOSER,"Bad call to removeActivationEventListeners"); }
				_container.removeEventListener(MouseEvent.WHEEL, mouseWheelHandler);		
			}

			_handlersState = HANDLERS_NOTADDED;
		}
		
		private function addTextFlowListeners():void
		{
			for each (var event:String in eventList)			
				_textFlow.addEventListener(event,dispatchEvent);
		}
		
		private function removeTextFlowListeners():void
		{
			for each (var event:String in eventList)			
				_textFlow.removeEventListener(event,dispatchEvent);
			_handlersState = HANDLERS_NONE;
		}
		
		/**
		 * @copy org.apache.royale.events.IEventDispatcher#dispatchEvent()
		 * @private
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
 		 */
//TODO is this really needed?
//		public override function dispatchEvent(event:Event):Boolean
//		{
//			if (event.type == DamageEvent.DAMAGE)
//			{
//				_textDamaged = true;
//				if (_composeState == COMPOSE_FACTORY)
//					_damaged = true;
//			}
//			else if (event.type == FlowOperationEvent.FLOW_OPERATION_BEGIN)
//			{
//				//TODO fix mouseChildren
////				if (_container.mouseChildren == false)
////					_container.mouseChildren = true;
//			}
//			var result:Boolean = super.dispatchEvent(event);
//			if (!result)
//				event.preventDefault();
//			return result;
//		}
		
		/** @private */
		public function clearContainerChildren(recycle:Boolean):void
		{
			while(_container.numElements)
			{
				var textLine:ITextLine = _container.getElementAt(0) as ITextLine;
				_container.removeElement(textLine);
				if (textLine)
				{
					// releasing all textLines so release each still connected textBlock
					if (textLine.validity != "invalid" && textLine.validity != "static")
					{
						var textBlock:ITextBlock = textLine.textBlock;
						CONFIG::debug { Debugging.traceFTECall(null,textBlock,"releaseLines",textBlock.firstLine, textBlock.lastLine); }	
						textBlock.releaseLines(textBlock.firstLine,textBlock.lastLine);
					}					
					if (recycle)
					{
						textLine.userData = null;	// clear any userData
						TextLineRecycler.addLineForReuse(textLine);
					}
				}
			}
		}
		
		private function convertToTextFlow():void
		{
			CONFIG::debug { assert(_sourceState != SOURCE_TEXTFLOW,"bad call to convertToTextFlow"); }
	
			TLFFactory.defaultTLFFactory.currentContainer = container;								
			_textFlow = new TextFlow(TLFFactory.defaultTLFFactory, _config);
			_textFlow.hostFormat = _hostFormat;
			if(_swfContext)
			{
				_textFlow.flowComposer.swfContext = _swfContext;
			}
	
			var p:IParagraphElement = ElementHelper.getParagraph();
			_textFlow.addChild(p);
			var s:ISpanElement = ElementHelper.getSpan();
			s.text = _text;
			p.addChild(s);
			_sourceState = SOURCE_TEXTFLOW;
			addTextFlowListeners();			
		}
				
		/** @private */
		public function convertToTextFlowWithComposer(callUpdateContainer:Boolean = true):void
		{
			removeActivationEventListeners();
			
			if (_sourceState != SOURCE_TEXTFLOW)
				convertToTextFlow();
			
			if (_composeState != COMPOSE_COMPOSER)
			{
				clearContainerChildren(true);
				clearComposedLines();
				var controller:TMContainerController = new TMContainerController(_container,_compositionWidth,_compositionHeight,this);
				_textFlow.flowComposer = StandardHelper.getNewComposer();
				_textFlow.flowComposer.addController(controller);
				_textFlow.flowComposer.swfContext = _swfContext;
				_composeState = COMPOSE_COMPOSER;
				
				invalidateInteractionManager();
				if (callUpdateContainer)
					updateContainer();
			}
		}
		
		private function get effectiveBlockProgression():String
		{
			if (_textFlow)
				return _textFlow.computedFormat.blockProgression;
			return _hostFormat && _hostFormat.blockProgression && _hostFormat.blockProgression != FormatValue.INHERIT ? _hostFormat.blockProgression : BlockProgression.TB;
		}
		
		/* CONFIG::debug private static function doTrace(msg:String):void
		{ trace(msg); } */
		
		private function removeIBeamCursor():void
		{
			if (_ibeamCursorSet)
			{
				Mouse.cursor = Configuration.getCursorString(configuration, MouseCursor.AUTO);
				_ibeamCursorSet = false;
			}
		}
		
		private var _hasScrollRect:Boolean = false;
		
		/** 
		 * Specifies whether this container has attached a ScrollRect object. Value is <code>true</code>
		 * or <code>false</code>. A display object is cropped to the size defined by the scroll rectangle, and 
		 * it scrolls within the rectangle when you change the x and y properties of the scrollRect object. 
		 *
		 * <p>This property enables a client to test for a ScrollRect object without accessing 
		 * the DisplayObject.scrollRect property, which can have side effects in some cases.</p> 
		 *
		 * @return true if the controller has attached a ScrollRect instance.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 *
		 * @see #drawBackgroundAndSetScrollRect 
		 */
		private function get hasScrollRect():Boolean
		{ return _hasScrollRect; }
		private function set hasScrollRect(value:Boolean):void
		{ _hasScrollRect = value; }
		
		/**   
		 * Returns <code>true</code> if it has filled in the container's scrollRect property.  
		 * This method enables you to test whether <code>scrollRect</code> is set without actually accessing the <code>scrollRect</code> property 
		 * which can possibly create a  performance issue. 
		 * <p>Override this method to draw a background or a border.  Overriding this method can be tricky as the scrollRect <bold>must</bold> 
		 * be set as specified.</p>
		 * 
		 * @param scrollX The starting horizontal position of the scroll rectangle.
		 * @param scrollY The starting vertical position of the scroll rectangle.
		 * 
		 * @return 	<code>true</code> if it has created the <code>scrollRect</code> object.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 */
		public function drawBackgroundAndSetScrollRect(scrollX:Number,scrollY:Number):Boolean
		{
//			var cont:IParentIUIBase = this.container;

 			var contentWidth:Number;
			var contentHeight:Number;
			if (_composeState == COMPOSE_FACTORY)
			{
				contentWidth = _contentWidth;
				contentHeight = _contentHeight;
			}
			else
			{
				var controller:IContainerController = getController();
				contentWidth = controller.contentWidth;
				contentHeight = controller.contentHeight;
			}
			var width:Number;
			if (isNaN(compositionWidth))
			{
				var contentLeft:Number = (_composeState == COMPOSE_FACTORY) ? _contentLeft : controller.contentLeft;
				width = contentLeft + contentWidth - scrollX;
			}
			else
				width = compositionWidth;
			var height:Number;
			if (isNaN(compositionHeight))
			{ 
				var contentTop:Number = (_composeState == COMPOSE_FACTORY) ? _contentTop : controller.contentTop;
				height = contentTop + contentHeight - scrollY;
			}
			else
				height = compositionHeight;
			
			//TODO fix scrollRect logic commented out below
			if (scrollX == 0 && scrollY == 0 && contentWidth <= width && contentHeight <= height)
			{
				// skip the scrollRect
				if (_hasScrollRect)
				{
//					cont.scrollRect = null;
					_hasScrollRect = false;					
				}
			}
			else
			{
//				cont.scrollRect = new Rectangle(scrollX, scrollY, width, height);
				_hasScrollRect = true;
				
				// adjust to the values actually in the scrollRect
//				scrollX = cont.scrollRect.x;
//				scrollY = cont.scrollRect.y;
//				width = cont.scrollRect.width;
//				height = cont.scrollRect.height;
			}
			//TODO convert Sprite logic to FLexJS
	        // NOTE: must draw a background for interaction support - even it if is 100% transparent
//	        var s:Sprite = cont as Sprite;
//	        if (s)
//	        {
//				s.graphics.clear();
//				s.graphics.beginFill(0, 0); 
//		       	s.graphics.drawRect(scrollX,scrollY,width,height);
//		        s.graphics.endFill();
//		    }
	
	        return _hasScrollRect;
		}
		
		/** Returns the focusedSelectionFormat - by default get it from the configuration.
		 * This can be overridden in the subclass to supply a different SelectionFormat
		 */
		protected function getFocusedSelectionFormat():SelectionFormat
		{
			return _config.focusedSelectionFormat;
		}
		
		/** Returns the inactiveSelectionFormat - by default get it from the configuration 
		 * This can be overridden in the subclass to supply a different SelectionFormat
		 */
		protected function getInactiveSelectionFormat():SelectionFormat
		{
			return _config.inactiveSelectionFormat;
		}
		
		/** Returns the unfocusedSelectionFormat - by default get it from the configuration 
		 * You can override this method in the subclass to supply a different SelectionFormat.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		protected function getUnfocusedSelectionFormat():SelectionFormat
		{
			return _config.unfocusedSelectionFormat;
		}
		
		/** 
		 * Returns the undo manager to use. By default, creates a unique undo manager. 
		 * You can override this method in the subclass if you want to customize the undo manager
		 * (for example, to use a shared undo manager for multiple TextContainerManager instances).
		 *
		 * @return 	new IUndoManager instance.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
	 	 */
		 
		protected function getUndoManager():IUndoManager
		{
			return new UndoManager();
		}
						
		/** Creates a ContextMenu for the TextContainerManager. Use the methods of the ContextMenu 
		 *  class to add items to the menu. 
		 * <p>You can override this method to define a custom context menu.</p>
		 *
		 * @return 	the created context menu.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 * @see flash.ui.ContextMenu ContextMenu
		 */
		protected function createContextMenu():ContextMenu
		{
			return ContainerController.createDefaultContextMenu();
		}
		/** @copy org.apache.royale.textLayout.container.ContainerController#editHandler()
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
 		 * @langversion 3.0
 		 *
 		 * @see org.apache.royale.events.Event Event
		 */	
		public function editHandler(event:Event):void
		{
			if (_composeState == COMPOSE_FACTORY)
			{
				convertToTextFlowWithComposer();
				getController().editHandler(event);
				_textFlow.interactionManager.setFocus();
			}
			else
				getController().editHandler(event);
		}
		
		/** @copy org.apache.royale.textLayout.container.ContainerController#keyDownHandler() 
		*
		* @playerversion Flash 10
		* @playerversion AIR 1.5
 		* @langversion 3.0
 		* @see org.apache.royale.events.KeyboardEvent#KEY_DOWN KeyboardEvent.KEY_DOWN
		*/	
		public function keyDownHandler(event:KeyboardEvent):void
		{
			if (_composeState == COMPOSE_COMPOSER)
				getController().keyDownHandler(event);
		}
		
		/** @copy org.apache.royale.textLayout.container.ContainerController#keyUpHandler().
		* @playerversion Flash 10
		* @playerversion AIR 1.5
 		* @langversion 3.0
 		* @see org.apache.royale.events.KeyboardEvent#KEY_UP KeyboardEvent.KEY_UP
		*/	
		public function keyUpHandler(event:KeyboardEvent):void
		{
			if (_composeState == COMPOSE_COMPOSER)
				getController().keyUpHandler(event);
		}

		/** @copy org.apache.royale.textLayout.container.ContainerController#keyFocusChangeHandler().
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
 	 	 * @langversion 3.0
		 * 	@param	event	the FocusChange event
		 */	
		public function keyFocusChangeHandler(event:Event):void
		{
			if (_composeState == COMPOSE_COMPOSER)
				getController().keyFocusChangeHandler(event);
		}
		
		/** @copy org.apache.royale.textLayout.container.ContainerController#textInputHandler()
		* @playerversion Flash 10
		* @playerversion AIR 1.5
 		* @langversion 3.0
 		* @see org.apache.royale.events.TextEvent#TEXT_INPUT TextEvent.TEXT_INPUT
		*/
		public function textInputHandler(event:TextEvent):void
		{
			if (_composeState == COMPOSE_COMPOSER)
				getController().textInputHandler(event);
		}

		/** Processes the <code>IME_START_COMPOSITION</code> event when the client manages events.
		 *
		 * @param event  The IMEEvent object.
		 *
		 * @playerversion Flash 10.1
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * 
		 *
		 * @see org.apache.royale.events.IMEEvent#IME_START_COMPOSITION IMEEvent.IME_START_COMPOSITION
		 */
		public function imeStartCompositionHandler(event:IMEEvent):void
		{
			if (_composeState == COMPOSE_COMPOSER)
				getController().imeStartCompositionHandler(event);
		}
		
		/** Processes the <code>SOFT_KEYBOARD_ACTIVATING</code> event when the client manages events.
		 *
		 * @param event  The SoftKeyboardEvent object.
		 *
		 * @playerversion Flash 10.2
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * 
		 *
		 * @see org.apache.royale.events.SoftKeyboardEvent#SOFT_KEYBOARD_ACTIVATING SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATING
		 */
		public function softKeyboardActivatingHandler(event:Event):void
		{
			if (_composeState == COMPOSE_COMPOSER)
				getController().softKeyboardActivatingHandler(event);
		}
		
		/** @copy org.apache.royale.textLayout.container.ContainerController#mouseDownHandler()
		* @playerversion Flash 10
		* @playerversion AIR 1.5
 		* @langversion 3.0
 		* @see org.apache.royale.events.MouseEvent#MOUSE_DOWN MouseEvent.MOUSE_DOWN
		*/	
		public function mouseDownHandler(event:MouseEvent):void
		{
			// doTrace("IM:mouseDownHandler");
			// before the mouseDown do a mouseOver
			if (_composeState == COMPOSE_FACTORY)
			{
				CONFIG::debug { assert(event.currentTarget == this.container,"TextContainerManager:mouseDownHandler - unexpected currentTarget"); }
				convertToTextFlowWithComposer();
				getController().requiredFocusInHandler(null);
				getController().requiredMouseOverHandler(event.target != container ? new RemappedMouseEvent(event) : event);
				if (_hasFocus)
					getController().requiredFocusInHandler(null);
				getController().requiredMouseDownHandler(event);
			}
			else
				getController().mouseDownHandler(event);
		}

		/** @copy org.apache.royale.textLayout.container.ContainerController#mouseMoveHandler()
		* @playerversion Flash 10
		* @playerversion AIR 1.5
 		* @langversion 3.0
 		* @see org.apache.royale.events.MouseEvent#MOUSE_MOVE MouseEvent.MOUSE_MOVE
		*/	
		public function mouseMoveHandler(event:MouseEvent):void
		{
			if (_composeState == COMPOSE_COMPOSER)
				getController().mouseMoveHandler(event);
		}
		
		/** @copy org.apache.royale.textLayout.container.ContainerController#mouseUpHandler()
		* @playerversion Flash 10
		* @playerversion AIR 1.5
 		* @langversion 3.0
 		* @see org.apache.royale.events.MouseEvent#MOUSE_UP MouseEvent.MOUSE_UP
		*/	
		public function mouseUpHandler(event:MouseEvent):void
		{
			if (_composeState == COMPOSE_COMPOSER)
				getController().mouseUpHandler(event);
		}
		
		/** @copy org.apache.royale.textLayout.container.ContainerController#mouseDoubleClickHandler()
		* @playerversion Flash 10
		* @playerversion AIR 1.5
 		* @langversion 3.0
 		* @see org.apache.royale.events.MouseEvent#DOUBLE_CLICK MouseEvent.DOUBLE_CLICK
		*/	
		public function mouseDoubleClickHandler(event:MouseEvent):void
		{
			if (_composeState == COMPOSE_COMPOSER)
				getController().mouseDoubleClickHandler(event);
		}

		/** @private Process a mouseOver event.
		* @playerversion Flash 10
		* @playerversion AIR 1.5
 		* @langversion 3.0
		*/			
		public final function requiredMouseOverHandler(event:MouseEvent):void
		{
			if (_composeState == COMPOSE_FACTORY)
				mouseOverHandler(event);
			if (_composeState == COMPOSE_COMPOSER)
				getController().requiredMouseOverHandler(event);
		}
		

		/** Process a mouseOver event.
		* @playerversion Flash 10
		* @playerversion AIR 1.5
 		* @langversion 3.0
 		* @see org.apache.royale.events.MouseEvent#MOUSE_OVER MouseEvent.MOUSE_OVER
		*/			
		public function mouseOverHandler(event:MouseEvent):void
		{
			if (_composeState == COMPOSE_COMPOSER)
				getController().mouseOverHandler(event);
			else
			{
				// doTrace("IM:mouseOverHandler");
				if (effectiveBlockProgression != BlockProgression.RL)
				{
					//TODO Cursor management
//					Mouse.cursor = MouseCursor.IBEAM;
					_ibeamCursorSet = true;
				}	
				addActivationEventListeners();
			}
		}
		/** @copy org.apache.royale.textLayout.container.ContainerController#mouseOutHandler()
		* @playerversion Flash 10
		* @playerversion AIR 1.5
 		* @langversion 3.0
 		* @see org.apache.royale.events.MouseEvent#MOUSE_OUT MouseEvent.MOUSE_OUT
		*/					
		public function mouseOutHandler(event:MouseEvent):void
		{
			// doTrace("IM:mouseOutHandler");
			if (_composeState == COMPOSE_FACTORY)
				removeIBeamCursor();
			else
				getController().mouseOutHandler(event);
		}		
		/** @copy org.apache.royale.textLayout.container.ContainerController#focusInHandler()
		* @playerversion Flash 10
		* @playerversion AIR 1.5
 		* @langversion 3.0
 		* @see org.apache.royale.events.FocusEvent#FOCUS_IN FocusEvent.FOCUS_IN
		*/

		
		/** Process a focusIn event.
		* @playerversion Flash 10
		* @playerversion AIR 1.5
 		* @langversion 3.0
		*/
		public function focusInHandler(event:Event):void
		{
			_hasFocus = true;
			if (_composeState == COMPOSE_COMPOSER)
				getController().focusInHandler(event);
		}
		
		/** @private hook to get at requiredFocusOutHandler as needed */
		public function requiredFocusOutHandler(event:Event):void
		{
			if (_composeState == COMPOSE_COMPOSER)
				getController().requiredFocusOutHandler(event);
		}
		/** @copy org.apache.royale.textLayout.container.ContainerController#focusOutHandler()
		* @playerversion Flash 10
		* @playerversion AIR 1.5
 		* @langversion 3.0
 		* @see org.apache.royale.events.FocusEvent#FOCUS_OUT FocusEvent.FOCUS_OUT
		*/
		public function focusOutHandler(event:Event):void
		{
			_hasFocus = false;
			if (_composeState == COMPOSE_COMPOSER)
				getController().focusOutHandler(event);
		}

		/** @copy org.apache.royale.textLayout.container.ContainerController#activateHandler()
		* @playerversion Flash 10
		* @playerversion AIR 1.5
 		* @langversion 3.0
 		* @see org.apache.royale.events.Event#ACTIVATE Event.ACTIVATE
		*/				
		public function activateHandler(event:Event):void
		{
			if (_composeState == COMPOSE_COMPOSER)
				getController().activateHandler(event);
		}		
		/** @copy org.apache.royale.textLayout.container.ContainerController#deactivateHandler()
		* @playerversion Flash 10
		* @playerversion AIR 1.5
 		* @langversion 3.0
 		* @see org.apache.royale.events.Event#DEACTIVATE Event.DEACTIVATE
		*/				
		public function deactivateHandler(event:Event):void
		{
			if (_composeState == COMPOSE_COMPOSER)
				getController().deactivateHandler(event);
		}
		
		/** @copy org.apache.royale.textLayout.container.ContainerController#focusChangeHandler()
		* @playerversion Flash 10
		* @playerversion AIR 1.5
 		* @langversion 3.0
 		*
 		* @see org.apache.royale.events.FocusEvent#KEY_FOCUS_CHANGE FocusEvent.KEY_FOCUS_CHANGE
		* @see org.apache.royale.events.FocusEvent#MOUSE_FOCUS_CHANGE FocusEvent.MOUSE_FOCUS_CHANGE
		*/				
		public function focusChangeHandler(event:Event):void
		{
			if (_composeState == COMPOSE_COMPOSER)
				getController().focusChangeHandler(event);
		}
		
		/** @copy org.apache.royale.textLayout.container.ContainerController#menuSelectHandler()
		* @playerversion Flash 10
		* @playerversion AIR 1.5
 		* @langversion 3.0
 		*
 		* @see org.apache.royale.events.ContextMenuEvent#MENU_SELECT ContextMenuEvent.MENU_SELECT
		*/				
		public function menuSelectHandler(event:ContextMenuEvent):void
		{
			if (_composeState == COMPOSE_FACTORY)
			{
//TODO context menus
				// there is no selection
//				var contextMenu:ContextMenu = _container.contextMenu as ContextMenu;
//				if (contextMenu)
//				{
//					var cbItems:ContextMenuClipboardItems = contextMenu.clipboardItems;
//					cbItems.selectAll = _editingMode != EditingMode.READ_ONLY;
//					cbItems.clear = false;
//					cbItems.copy = false;
//					cbItems.cut = false;
//					cbItems.paste = false;
//				}
			}
			else
				getController().menuSelectHandler(event);			
		}
		
		/** @copy org.apache.royale.textLayout.container.ContainerController#mouseWheelHandler()
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

			if (_composeState == COMPOSE_FACTORY)
			{
				convertToTextFlowWithComposer();
				getController().requiredMouseOverHandler(event);
			}
			getController().mouseWheelHandler(event);
		}

		
		/** @private required FocusIn handler.  Clients override focusInHandler
		* @playerversion Flash 10
		* @playerversion AIR 1.5
 		* @langversion 3.0
		*/
		public final function requiredFocusInHandler(event:Event):void
		{			
			// doTrace("IM:focusInHandler");
			if (_composeState == COMPOSE_FACTORY)
			{
				addActivationEventListeners();
				focusInHandler(event);
			}			
			if (_composeState == COMPOSE_COMPOSER)
				getController().requiredFocusInHandler(event);
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
		{ }
		/** 
		 * Called to inform clients that the the forwarding of mouseup and mousemove events from outside a security sandbox is no longer needed.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 */
		public function endMouseCapture():void
		{ }
		/** Client call to forward a mouseUp event from outside a security sandbox.  Coordinates of the mouse up are not needed.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 */
		public function mouseUpSomewhere(e:Event):void
		{
			if (_composeState == COMPOSE_COMPOSER)
				getController().mouseUpSomewhere(e);
		}
		/** Client call to forward a mouseMove event from outside a security sandbox.  Coordinates of the mouse move are not needed.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 */		
		public function mouseMoveSomewhere(e:Event):void
		{ 
			if (_composeState == COMPOSE_COMPOSER)
				getController().mouseUpSomewhere(e);
		}
	
		/** @private
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
		public function getFirstTextLineChildIndex():int
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
			}
			return firstTextLine;
		}
		
		/** @private
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
		public function addTextLine(textLine:ITextLine, index:int):void
		{ 
			_container.addElementAt(textLine, index);
		}
		
		/** @private
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
		public function removeTextLine(textLine:ITextLine):void
		{
			if (_container.getElementIndex(textLine)>-1)
				_container.removeElement(textLine);
		}
		
		/** @private
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
		public function addBackgroundShape(shape:IUIBase):void	// No PMD
		{
			_container.addElementAt(shape, getFirstTextLineChildIndex());
		}
		
		/** @private
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
		public function removeBackgroundShape(shape:IUIBase):void	
		{
			if (shape.parent)
				shape.parent.removeElement(shape);
		}
		
		/** @private
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
		public function addSelectionContainer(selectionContainer:IParentIUIBase):void
		{
			//TODO deal with selection blend modes
//			if (selectionContainer.blendMode == BlendMode.NORMAL && selectionContainer.alpha == 1)
//			{
//				// don't put selection behind background color or existing content in container, put it behind first text line
				_container.addElementAt(selectionContainer, getFirstTextLineChildIndex());
//			}
//			else
//				_container.addElement(selectionContainer);
		}
		
		/** @private
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
		public function removeSelectionContainer(selectionContainer:IParentIUIBase):void
		{	
			selectionContainer.parent.removeElement(selectionContainer);
		}
		
		/** @private
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
		public function addInlineGraphicElement(parent:IParentIUIBase, inlineGraphicElement:IUIBase, index:int):void
		{
			if (parent)
				parent.addElementAt(inlineGraphicElement, index);
		}
		
		/** @private
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
		public function removeInlineGraphicElement(parent:IParentIUIBase, inlineGraphicElement:IUIBase):void
		{
			if (parent && inlineGraphicElement.parent == parent)
				parent.removeElement(inlineGraphicElement);
		}

		/** @public
		 * It's <code>_preserveSelectionOnSetText</code> to decide whether or not TLF preserve selection state during setText().
		 * 
		 * The default value is false, which means <code>setText()</code> does not preserve original selection state, 
		 * <code>setText()</code> acts as what it was. If <code>_preserveSelectionOnSetText</code> is true, 
		 * the original selection state is preserved during <code>setText()</code>.  
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0  
		 */
		public function get preserveSelectionOnSetText():Boolean
		{
			return _preserveSelectionOnSetText;
		}
		public function set preserveSelectionOnSetText(value:Boolean):void
		{
			_preserveSelectionOnSetText = value;
		}

	}
	
}

import org.apache.royale.events.IRoyaleEvent;
import org.apache.royale.events.MouseEvent;
import org.apache.royale.geom.Point;
import org.apache.royale.utils.PointUtils;

// remap the mouse event for processing inside TLF.  This is just the initial click.  Make it as if the event was on the container and not the textline
class RemappedMouseEvent extends org.apache.royale.events.MouseEvent
{
	private var _event:org.apache.royale.events.MouseEvent;
	
	public function RemappedMouseEvent(event:org.apache.royale.events.MouseEvent,cloning:Boolean = false)
	{
		var containerPoint:Point;
		if (!cloning)
		{
			containerPoint = PointUtils.localToGlobal(new Point(event.localX, event.localY), event.target);// DisplayObject(event.target).localToGlobal(new Point(event.localX, event.localY));
			containerPoint = PointUtils.globalToLocal(containerPoint, event.currentTarget);// DisplayObject(event.currentTarget).globalToLocal(containerPoint);
		}
		else
			containerPoint = new Point();

		/* event.commandKey,event.controlKey,event.clickCount are also supported in AIR.  IMHO they are a nonissue for the initial click */
		super(event.type,event.bubbles,event.cancelable,containerPoint.x,containerPoint.y,event.relatedObject,event.ctrlKey,event.altKey,event.shiftKey,event.buttonDown,event.delta);
		
		_event = event;
	}

	// override methods/getters for things we couldn't set in the base class	
//TODO The Royale Compiler did not like these overrides
	// public override function get target():Object
	// { return _event.currentTarget; }
	
	// public override function get currentTarget():Object
	// { return _event.currentTarget; }
	
	COMPILE::SWF
	public override function get eventPhase():uint
	{ return _event.eventPhase; }
	
	COMPILE::SWF
	public override function get isRelatedObjectInaccessible():Boolean
	{ return _event.isRelatedObjectInaccessible; }
	
	COMPILE::SWF
	public override function get stageX():Number
	{ return _event.stageX; }
	
	COMPILE::SWF
	public override function get stageY():Number
	{ return _event.stageY; }
	
	COMPILE::SWF
	public override function updateAfterEvent():void
	{ _event.updateAfterEvent(); }
	
	public override function isDefaultPrevented():Boolean
	{ return _event.defaultPrevented; }
	
	public override function preventDefault():void
	{ _event.preventDefault(); }
	
	public override function stopImmediatePropagation():void
	{ _event.stopImmediatePropagation(); }
	
	public override function stopPropagation():void
	{ _event.stopPropagation(); }
}




