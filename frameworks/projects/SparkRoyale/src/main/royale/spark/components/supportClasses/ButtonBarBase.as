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

package spark.components.supportClasses
{
	/*
	import flash.events.Event;
	import flash.events.EventPhase;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	*/
	
	import org.apache.royale.events.Event;
	import mx.events.MouseEvent;
	
	import mx.collections.IList;
	import mx.core.EventPriority;
	import mx.core.IFactory;
	// import mx.core.ISelectableList;
	import mx.core.IVisualElement;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	import mx.events.IndexChangedEvent;
	import mx.managers.IFocusManagerComponent;
	
	// import spark.components.ButtonBarButton;
	// import spark.components.IItemRenderer;
	import spark.components.supportClasses.ButtonBase;
	import spark.events.IndexChangeEvent;
	// import spark.events.RendererExistenceEvent;
	
	use namespace mx_internal;  // use of ListBase/setCurrentCaretIndex(index);
	
	//--------------------------------------
	//  Styles
	//--------------------------------------
	
	/**
	 *  Orientation of the icon in relation to the label.
	 *  Valid MXML values are <code>right</code>, <code>left</code>,
	 *  <code>bottom</code>, and <code>top</code>.
	 *
	 *  <p>In ActionScript, you can use the following constants
	 *  to set this property:
	 *  <code>IconPlacement.RIGHT</code>,
	 *  <code>IconPlacement.LEFT</code>,
	 *  <code>IconPlacement.BOTTOM</code>, and
	 *  <code>IconPlacement.TOP</code>.</p>
	 *
	 *  @default IconPlacement.LEFT
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	[Style(name="iconPlacement", type="String", enumeration="top,bottom,right,left", inherit="no")]
	
	//--------------------------------------
	//  Other metadata
	//--------------------------------------
	
	[AccessibilityClass(implementation="spark.accessibility.ButtonBarBaseAccImpl")]
	
	/**
	 *  The ButtonBarBase class defines the common behavior for the ButtonBar, TabBar and similar subclasses.   
	 *  This class does not add any new API however it refines selection, keyboard focus and keyboard navigation
	 *  behavior for the control's ItemRenderer elements.   
	 *  This base class is not intended to be instantiated directly.
	 * 
	 *  <p>Clicking on an ItemRenderer selects it by setting the <code>selectedIndex</code> and the 
	 *  <code>caretIndex</code> properties.  If <code>requireSelection</code> is <code>false</code>, then clicking 
	 *  again deselects it.  If the data provider is an <code>ISelectableList</code> object, then its 
	 *  <code>selectedIndex</code> is set as well.</p> 
	 * 
	 *  <p>Arrow key events are handled by adjusting the <code>caretIndex</code>.    
	 *  If <code>arrowKeysWrapFocus</code> is <code>true</code>, then the <code>caretIndex</code> wraps.  
	 *  Pressing the Space key selects the ItemRenderer at the <code>caretIndex</code>.</p>
	 * 
	 *  <p>The <code>showsCaret</code> property of the ItemRenderer at <code>caretIndex</code> 
	 *  is set to <code>true</code> when the ButtonBarBase object has focus and 
	 *  the <code>caretIndex</code> was reached as a consequence
	 *  of a keyboard gesture.   
	 *  If the <code>caretIndex</code> was set as a side effect of responding to a 
	 *  mouse click, then <code>showsCaret</code> is not set.</p>
	 * 
	 *  <p>The <code>allowDeselection</code> property of <code>ButtonBarButton</code> 
	 *  ItemRenderers is set to <code>!requireSelection</code>.</p>
	 *
	 *  @mxml
	 *
	 *  <p>The <code>&lt;s:ButtonBarBase&gt;</code> tag inherits all of the tag 
	 *  attributes of its superclass and adds no new tag attributes:</p>
	 *
	 *  <pre>
	 *  &lt;s:ButtonBarBase/&gt;
	 *  </pre> 
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */ 
	public class ButtonBarBase extends ListBase
	{
		// include "../../core/Version.as";    
		
		//--------------------------------------------------------------------------
		//
		//  Class mixins
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  Placeholder for mixin by ButtonBarBaseAccImpl.
		 */
		mx_internal static var createAccessibilityImplementation:Function;
		
		/**
		 *  Constructor.
		 * 
		 *  <p>Initializes tab processing: tabbing to this component will give it the focus, but not 
		 *  clicking on it with the mouse.  Tabbing to the children is disabled.</p> 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function ButtonBarBase()
		{
			super();
			
			tabChildren = false;
			tabEnabled = true;
			tabFocusEnabled = true;
			setCurrentCaretIndex(0);        
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  If false, don't show the focusRing for the tab at caretIndex, see
		 *  itemShowingCaret() below.
		 * 
		 *  If the caret index changes because of something other than a arrow
		 *  or space keypress then we don't show the focus ring, i.e. we do not 
		 *  set showsCaret=true for the item renderer at caretIndex.
		 *     
		 *  This flag is valid at commitProperties() time.  It's set to false
		 *  if at least one selectedIndex change (see item_clickHandler()) occurred 
		 *  because of a mouse click.
		 */
		private var enableFocusHighlight:Boolean = true;
		
		/**
		 *  @private
		 */    
		private var inCollectionChangeHandler:Boolean = false;
		
		/**
		 *  @private
		 *  Used to distinguish item_clickHandler() calls initiated by the mouse, from calls
		 *  initiated by pressing the space bar.
		 */
		private var inKeyUpHandler:Boolean = false;
		
		/**
		 *  @private
		 *  Index of item that is currently pressed by the
		 *  spacebar.
		 */
		private var pressedIndex:Number;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  dataProvider
		//----------------------------------
		
		[Inspectable(category="Data")]
		
		/**
		 *  @private
		 */    
		/*override public function set dataProvider(value:IList):void
		{
			if (dataProvider is ISelectableList)
			{
				dataProvider.removeEventListener(FlexEvent.VALUE_COMMIT, dataProvider_changeHandler);
				dataProvider.removeEventListener(IndexChangedEvent.CHANGE, dataProvider_changeHandler);
			}
			
			if (value is ISelectableList)
			{
				value.addEventListener(FlexEvent.VALUE_COMMIT, dataProvider_changeHandler, false, 0, true);
				value.addEventListener(IndexChangedEvent.CHANGE, dataProvider_changeHandler, false, 0, true);
			}
			
			super.dataProvider = value;
			
			if (value is ISelectableList)
				selectedIndex = ISelectableList(dataProvider).selectedIndex;
		}*/    
		
		//----------------------------------
		//  iconField
		//----------------------------------
		
		/**
		 *  @private
		 */
		private var _iconField:String = "icon";
		
		/**
		 *  @private
		 */
		private var iconFieldOrFunctionChanged:Boolean; 
		
		/**
		 *  The name of the field in the data provider items which serves
		 *  as the icon to display.
		 * 
		 *  The <code>iconFunction</code> property overrides this property.
		 *
		 *  @default null
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4.5
		 */
		public function get iconField():String
		{
			return _iconField;
		}
		
		/**
		 *  @private
		 */
		public function set iconField(value:String):void
		{
			if (value == _iconField)
				return; 
			
			_iconField = value;
			iconFieldOrFunctionChanged = true;
			invalidateProperties();
		}
		
		//----------------------------------
		//  iconFunction
		//----------------------------------
		
		/**
		 *  @private
		 */
		private var _iconFunction:Function; 
		
		/**
		 *  A user-supplied function to run on each item to determine its icon.  
		 *  The <code>iconFunction</code> property overrides 
		 *  the <code>iconField</code> property.
		 *
		 *  <p>You can supply an <code>iconFunction</code> that finds the 
		 *  appropriate fields and returns a displayable icon. </p>
		 *
		 *  <p>The icon function takes a single argument which is the item in 
		 *  the data provider and returns a valid BitmapImage source.</p>
		 *  <pre>
		 *  myIconFunction(item:Object):Object</pre>
		 *
		 *  @default null
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4.5
		 */
		public function get iconFunction():Function
		{
			return _iconFunction;
		}
		
		/**
		 *  @private
		 */
		public function set iconFunction(value:Function):void
		{
			if (value == _iconFunction)
				return; 
			
			_iconFunction = value;
			iconFieldOrFunctionChanged = true;
			invalidateProperties(); 
		}
		
		//----------------------------------
		//  requireSelection
		//---------------------------------- 
		
		private var requireSelectionChanged:Boolean;
		
		[Inspectable(category="General", defaultValue="false")]
		
		/**
		 *  @private
		 *  See commitProperties(). 
		 */
		override public function set requireSelection(value:Boolean):void
		{
			if (value == requireSelection)
				return;
			
			super.requireSelection = value;
			requireSelectionChanged = true;
			invalidateProperties();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  Called by the initialize() method of UIComponent
		 *  to hook in the accessibility code.
		 */
		/*override protected function initializeAccessibility():void
		{
			if (ButtonBarBase.createAccessibilityImplementation != null)
				ButtonBarBase.createAccessibilityImplementation(this);
		}*/
		
		/**
		 *  @private
		 *  if the collection is changing and the collection is a viewstack
		 *  the viewstack will also adjust the selection and notify us
		 *  via dataProvider_changeHandler so we want to 
		 *  ignore calls to adjustSelection that the base class
		 *  calls so we don't increment or decrement
		 *  selectedIndex twice
		 */
		/*override protected function dataProvider_collectionChangeHandler(event:Event):void
		{
			inCollectionChangeHandler = true;
			
			super.dataProvider_collectionChangeHandler(event);
			
			inCollectionChangeHandler = false;
			
		}*/
		
		/**
		 *  @private
		 */
		/*override protected function adjustSelection(newIndex:int, add:Boolean=false):void
		{
			// see comment in dataProvider_collectionChangeHandler
			if (inCollectionChangeHandler && dataProvider is ISelectableList)
				return;
			
			super.adjustSelection(newIndex, add);
		}*/
		
		/**
		 *  @private
		 */
		/*override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (requireSelectionChanged && dataGroup)
			{
				requireSelectionChanged = false;
				const n:int = dataGroup.numElements;
				for (var i:int = 0; i < n; i++)
				{
					var renderer:ButtonBarButton = dataGroup.getElementAt(i) as ButtonBarButton;
					if (renderer)
						renderer.allowDeselection = !requireSelection;
				}
			}
			
			if (iconFieldOrFunctionChanged)
			{
				updateRendererIcons();
				iconFieldOrFunctionChanged = false;
			}
			
			enableFocusHighlight = true;
		}  */  
		
		/**
		 *  @private
		 *  Return the item renderer at the specified index, or null.
		 */
		private function getItemRenderer(index:int):IVisualElement
		{
			if (!dataGroup || (index < 0) || (index >= dataGroup.numElements))
				return null;
			
			return dataGroup.getElementAt(index) as IVisualElement;
		}
		
		/**
		 *  @private
		 *  Called when setCurrentCaretIndex() moves the caret, or when it's moved as a consequence
		 *  of items being moved/removed.   See ListBase/caretIndexAdjusted.
		 */
		/*override protected function itemShowingCaret(index:int, showsCaret:Boolean):void
		{
			super.itemShowingCaret(index, showsCaret);
			
			const renderer:IVisualElement = getItemRenderer(index);
			if (renderer)
			{
				const hasFocus:Boolean = focusManager && (focusManager.getFocus() == this);
				renderer.depth = (showsCaret) ? 1 : 0;
				if (renderer is IItemRenderer)   
					IItemRenderer(renderer).showsCaret = showsCaret && enableFocusHighlight && hasFocus;
			}
		}*/
		
		/**
		 *  @private
		 *  Called when the focus is gained/lost by tabbing in or out.
		 */
		/*override public function drawFocus(isFocused:Boolean):void
		{
			const renderer:IVisualElement = getItemRenderer(caretIndex);
			if (renderer)
			{
				renderer.depth = (isFocused) ? 1 : 0;
				if (renderer is IItemRenderer)             
					IItemRenderer(renderer).showsCaret = isFocused;
			}
		}*/    
		
		/**
		 *  @private
		 */
		/*override protected function itemSelected(index:int, selected:Boolean):void
		{
			super.itemSelected(index, selected);
			
			const renderer:IItemRenderer = getItemRenderer(index) as IItemRenderer;
			if (renderer)
			{
				if (selected)
					setCurrentCaretIndex(index);  // causes itemShowingCaret() call
				renderer.selected = selected;
			}
			
			if ((dataProvider is ISelectableList) && selected)
				ISelectableList(dataProvider).selectedIndex = index;
		}*/
		
		/**
		 *  @private 
		 *  Detected changes to iconPlacement and update as necessary.
		 */ 
		/*override public function styleChanged(styleProp:String):void 
		{    
			if (!styleProp || 
				styleProp == "styleName" || styleProp == "iconPlacement")
			{
				// Cause icon association to reoccur, taking into consideration
				// the new placement.
				iconFieldOrFunctionChanged = true; 
				invalidateProperties();
			}
			
			super.styleChanged(styleProp);
		}*/
		
		/**
		 *  @private
		 */
		/*override public function updateRenderer(renderer:IVisualElement, itemIndex:int, data:Object):void
		{
			itemToIcon(renderer, data);
			super.updateRenderer(renderer, itemIndex, data);
		} */ 
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Gets the index for several of a ButtonBar's Buttons, referencing them by the ButtonBarbutton's <code>label</code>.  
		 *
		 *  <p>The method takes an array of ButtonBarButtons label and an optional field name.</p>
		 *  <pre>myButtonBar.getButtonIndices(["My Button Label1", "My Label2"])</pre>
		 *
		 *  @param labelValues Are the ButtonBarButton labels to find.
		 *  @param fieldName Field used for comparing the label (optional)
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 11.1
		 *  @playerversion AIR 3.4
		 *  @productversion Flex 4.10
		 */
		public function getButtonIndices(labelValues:Array, fieldName:String = ""):Array
		{
			var buttonIndices:Array;
			
			
			if (!dataGroup || labelValues.length < 1 || labelValues == null)
			{
				return [];
			}
			
			if (fieldName == "" || fieldName == null)
			{
				return findRowIndices(labelField, labelValues);
			}
			else
			{
				return findRowIndices(fieldName, labelValues);
			}
		}
		
		
		/**
		 *  Allows changing the <code>enabled</code> property of a the child ButtonBarbutton's.
		 *  It identifies the button given its label field (default) or an different optional field name may be passed. 
		 *
		 *  <p>The method takes a single ButtonBarButton label, a new <code>enabled</code> property value, and an optional field name to use as the comparison field.</p>
		 *  <pre>
		 *  myButtonBar.setButtonEnabled("My Button Label", false)</pre>
		 *
		 *  @param labelValue Is the ButtonBarButton label.
		 *  @param enabledValue The buttons new enabled value.
		 *  @param fieldName Field used to compare the label value against.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 11.1
		 *  @playerversion AIR 3.4
		 *  @productversion Flex 4.10
		 */
		public function setButtonEnabled(labelValue:String, enabledValue:Boolean, fieldName:String = ""):void
		{
			setButtonsEnabled([labelValue], enabledValue, fieldName);
		}
		
		
		/**
		 *  Allows changing the <code>enabled</code> property of several child ButtonBarbutton's.
		 *  It identifies the buttons given their label fields (default) or an different optional field name may be passed. 
		 *
		 *  <p>The method takes an array of ButtonBarButton labels, a new <code>enabled</code> property value, and an optional field name to use as the comparison field.</p>
		 *  <pre>
		 *  myButtonBar.setButtonsEnabled(["My Button Label1", "My Label2"], false)</pre>
		 *
		 *  @param labelValues Is an array of ButtonBarButton labels.
		 *  @param enabledValue The buttons new enabled value.
		 *  @param fieldName Field used to compare the label value against.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 11.1
		 *  @playerversion AIR 3.4
		 *  @productversion Flex 4.10
		 */
		public function setButtonsEnabled(labelValues:Array, enabledValue:Boolean, fieldName:String = ""):void
		{
			/*var btnCurrent:ButtonBarButton = null;
			var buttonIndices:Array;
			var indicesTotal:uint = 0;
			var loopingIndex:uint = 0;
			
			
			buttonIndices = getButtonIndices(labelValues, fieldName);
			indicesTotal = buttonIndices.length;
			
			if (indicesTotal == 0)
			{
				return;
			}
			
			
			for (loopingIndex; loopingIndex < indicesTotal; loopingIndex++)
			{
				btnCurrent = dataGroup.getElementAt(buttonIndices[loopingIndex]) as ButtonBarButton;
				btnCurrent.enabled = enabledValue;
			}*/
		}
		
		
		/**
		 *  @private
		 */
		private function itemToIcon(renderer:IVisualElement, item:Object):void
		{
			if (!(renderer is ButtonBase))
				return;
			
			// Assign iconPlacement if appropriate.
			var iconPlacement:String = getStyle("iconPlacement");
			if (iconPlacement)
				ButtonBase(renderer).setStyle("iconPlacement", iconPlacement);
			
			// iconFunction takes precedence.
			if (_iconFunction != null)
			{
				ButtonBase(renderer).setStyle("icon", _iconFunction(item));
				return;
			}
			
			// iconField
			if (_iconField && 
				_iconField.length > 0 && 
				item is Object)
			{
				try
				{
					if (item[_iconField] != null)
					{
						ButtonBase(renderer).setStyle("icon", item[_iconField]);
						return;
					}
				}
				catch(e:Error)
				{
				}
			}
			
			ButtonBase(renderer).clearStyle("icon");
		}
		
		/**
		 *  @private
		 */
		private function updateRendererIcons():void
		{
			/*if (!dataGroup)
				return;
			
			const count:int = dataGroup.numElements;
			for (var i:int = 0; i < count; i++)
			{
				var renderer:IItemRenderer = dataGroup.getElementAt(i) as IItemRenderer; 
				if (renderer && renderer.data)
					itemToIcon(renderer, renderer.data);
			}*/
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event Handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		private function dataProvider_changeHandler(event:Event):void
		{
			/*var newSelectedIndex:int = ISelectableList(dataProvider).selectedIndex;
			if (selectedIndex != newSelectedIndex)
			{
				selectedIndex = newSelectedIndex;
				commitSelection(false);
				dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
			}*/
		}
		
		/**
		 *  @private
		 */
		/*override protected function dataGroup_rendererAddHandler(event:RendererExistenceEvent):void
		{
			super.dataGroup_rendererAddHandler(event);
			
			const renderer:IVisualElement = event.renderer; 
			if (renderer)
			{
				renderer.addEventListener(MouseEvent.CLICK, item_clickHandler);
				if (renderer is IFocusManagerComponent)
					IFocusManagerComponent(renderer).focusEnabled = false;
				if (renderer is ButtonBarButton)
					ButtonBarButton(renderer).allowDeselection = !requireSelection;
			}
		}*/
		
		/**
		 *  @private
		 */
		/*override protected function dataGroup_rendererRemoveHandler(event:RendererExistenceEvent):void
		{   
			super.dataGroup_rendererRemoveHandler(event);
			
			const renderer:IVisualElement = event.renderer;
			if (renderer)
				renderer.removeEventListener(MouseEvent.CLICK, item_clickHandler);
		}*/
		
		/**
		 *  @private
		 *  Called synchronously when the space bar is pressed or the mouse is clicked. 
		 */
		private function item_clickHandler(event:MouseEvent):void
		{
			/*var newIndex:int;
			if (event.currentTarget is IItemRenderer)
				newIndex = IItemRenderer(event.currentTarget).itemIndex;
			else
				newIndex = dataGroup.getElementIndex(event.currentTarget as IVisualElement);
			
			var oldSelectedIndex:int = selectedIndex;
			if (newIndex == selectedIndex)
			{
				if (!requireSelection)
					setSelectedIndex(NO_SELECTION, true);
			}
			else
				setSelectedIndex(newIndex, true);
			
			// Changing the selectedIndex typically causes a call to itemSelected() at 
			// commitProperties() time.   We'll update the caretIndex then.  If this 
			// method was -not- called as a consequence of a keypress, we will not show
			// the focus highlight at caretIndex.  See itemShowingCaret().
			
			if (enableFocusHighlight && (selectedIndex != oldSelectedIndex))
				enableFocusHighlight = inKeyUpHandler;*/
		}
		
		/**
		 *  @private
		 *  Increment or decrement the caretIndex.  Wrap if arrowKeysWrapFocus=true.
		 */
		private function adjustCaretIndex(delta:int):void
		{/*
			if (!dataGroup || (caretIndex < 0))
				return;
			
			const oldCaretIndex:int = caretIndex;
			const length:int = dataGroup.numElements;
			
			if (arrowKeysWrapFocus)
				setCurrentCaretIndex((caretIndex + delta + length) % length);
			else
				setCurrentCaretIndex(Math.min(length - 1, Math.max(0, caretIndex + delta)));
			
			if (oldCaretIndex != caretIndex)
				dispatchEvent(new IndexChangeEvent(IndexChangeEvent.CARET_CHANGE, false, false, oldCaretIndex, caretIndex)); */
		}
		
		/**
		 *  @private
		 */
		/*override protected function keyDownHandler(event:KeyboardEvent):void
		{
			if (event.eventPhase == EventPhase.BUBBLING_PHASE)
				return;
			
			if (!enabled || !dataGroup || event.isDefaultPrevented())
				return;
			
			// Block input if space bar is being held down.
			if (!isNaN(pressedIndex))
			{
				event.preventDefault();
				return;
			}
			
			super.keyDownHandler(event);
			
			// If rtl layout, need to swap LEFT/UP and RIGHT/DOWN so correct action
			// is done.
			var keyCode:uint = mapKeycodeForLayoutDirection(event, true);
			
			switch (keyCode)
			{
				case Keyboard.UP:
				case Keyboard.LEFT:
				{
					adjustCaretIndex(-1);
					event.preventDefault();
					break;
				}
				case Keyboard.DOWN:
				case Keyboard.RIGHT:
				{
					adjustCaretIndex(+1);
					event.preventDefault();
					break;
				}            
				case Keyboard.SPACE:
				{
					const renderer:IItemRenderer = getItemRenderer(caretIndex) as IItemRenderer;
					if (renderer && ((!renderer.selected && requireSelection) || !requireSelection))
					{
						renderer.dispatchEvent(event);
						pressedIndex = caretIndex;
					}
					break;
				}            
			}
		}*/
		
		/**
		 *  @private
		 */
		/*override protected function keyUpHandler(event:KeyboardEvent):void
		{
			if (event.eventPhase == EventPhase.BUBBLING_PHASE)
				return;
			
			if (!enabled)
				return;
			
			super.keyUpHandler(event);
			
			switch (event.keyCode)
			{
				case Keyboard.SPACE:
				{
					inKeyUpHandler = true;
					
					// Need to check pressedIndex for NaN for the case when key up
					// happens on an already selected renderer and under the condition
					// that requireSelection=true.
					if (!isNaN(pressedIndex))
					{
						// Dispatch key up to the previously pressed item in case focus was lost
						// through other interaction (e.g. mouse clicks, etc...)
						const renderer:IItemRenderer = getItemRenderer(pressedIndex) as IItemRenderer;
						if (renderer && ((!renderer.selected && requireSelection) || !requireSelection))
						{
							renderer.dispatchEvent(event);
							pressedIndex = NaN;
						}
					}
					inKeyUpHandler = false;
					break;
				}            
			}
		}*/
	}
}