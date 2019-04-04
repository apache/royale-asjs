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

package spark.components.gridClasses
{
	COMPILE::SWF {
		import flash.display.DisplayObject;
		import flash.events.Event;
		import flash.geom.Point;
		import flash.geom.Rectangle;
	}
		
	COMPILE::JS {
		import org.apache.royale.events.Event;
		import org.apache.royale.geom.Point;
		import org.apache.royale.geom.Rectangle;
	}	
	
	import mx.core.IToolTip;
	import mx.core.IUIComponent;
	import mx.core.LayoutDirection;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	import mx.events.ToolTipEvent;
	import mx.managers.IToolTipManagerClient;
	import mx.managers.ToolTipManager;
	import mx.utils.PopUpUtil;
	import mx.validators.IValidatorListener;
	
	import spark.components.Grid;
	import spark.components.Group;
	import spark.components.supportClasses.TextBase;
	
	use namespace mx_internal;
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 *  Dispatched when the <code>data</code> property changes.
	 *
	 *  @eventType mx.events.FlexEvent.DATA_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.5
	 *  @productversion Flex 4.5
	 */
	[Event(name="dataChange", type="mx.events.FlexEvent")]
	
	//--------------------------------------
	//  Excluded APIs
	//--------------------------------------
	
	[Exclude(name="transitions", kind="property")]
	
	/**
	 *  The GridItemRenderer class defines the base class for custom item renderers
	 *  for the Spark grid controls, such as DataGrid and Grid.   
	 *  Item renderers are only required to display column-specific aspects of their data.  
	 *  They are not responsible for displaying the selection or hover indicators, 
	 *  the alternating background color (if any), or row or column separators.
	 *
	 *  <p>Item renderers are associated with each column of a grid.
	 *  Set the item renderer for a column by using 
	 *  the <code>GridColumn.itemRenderer property</code>.</p> 
	 * 
	 *  <p>By default, an item renderer does not clip to the boundaries of the cell.
	 *  If your renderer extends past the bounds of the cell, you can set 
	 *  <code>clipAndEnableScrolling</code> to <code>true</code> to clip the renderer to the bounds 
	 *  of the cell.</p>
	 * 
	 *  <p>Transitions in DataGrid item renderers aren't supported. The GridItemRenderer class 
	 *  has disabled its <code>transitions</code> property so setting it will have no effect.</p>
	 * 
	 *  <p><b>Efficiency Considerations</b></p>
	 *  
	 *  <p>DataGrid scrolling and startup performance are directly linked
	 *  to item renderer complexity and the number of item renderers that
	 *  are visible within the DataGrid's scroller.  Custom GridItemRenderer 
	 *  instances are used and reused repeatedly so it's important to define 
	 *  them as simply and efficiently as  possible.</p>
	 *  
	 *  <p>If an item renderer's responsibility is limited to displaying
	 *  one or more lines of text, then developers should seriously
	 *  consider using the DefaultItemRenderer class which does so very
	 *  economically (an application that's only going to be deployed on
	 *  Windows one can gain some additional performance by using the
	 *  UITextFieldGridItemRenderer class instead).  The most efficient
	 *  way to use GridItemRenderer to display the GridColumn's dataField
	 *  as text is to identify the GridItemRenderer's text displaying
	 *  element with <code>id="labelDisplay"</code>.  The labelDisplay
	 *  component must be a <code>TextBase</code> subclass like
	 *  <code>Label</code> or <code>RichText</code>.  You might take this
	 *  approach, instead of just using DefaultGridItemRenderer, if your
	 *  item renderer included some additional elements that did not
	 *  depend on the item renderer's data, like borders or other graphic
	 *  elements.</p>
	 *  
	 *  <p>An item renderer that contains more than one visual element
	 *  whose properties depend on the item renderer's data can use data
	 *  binding to define the values of those properties.  This approach
	 *  yields MXML code that's straightforward to read and maintain and
	 *  its performance may be adequate if the number of visible item
	 *  renderers is limited (see the DataGrid <code>requestedRowCount</code> 
	 *  and <code>requestedColumnCount</code> properties).  The most efficient
	 *  way to configure this kind of item renderer is to override its
	 *  <code>prepare()</code> method and do the work there.  The
	 *  renderer's <code>prepare()</code> method is called each time the
	 *  renderer is redisplayed and so it's important that it's coded
	 *  efficiently.  If your item renderer is stateful, for example if it
	 *  caches internal values, you can clear its state in its
	 *  <code>discard()</code> method.  The <code>discard()</code> method
	 *  is called each time the renderer is moved to the DataGrid's
	 *  internal free list, where it's available for reuse.</p>
	 *  
	 *  <p>GridItemRenderers should be as simple as possible.  To gain the
	 *  best possible performance, minimize the number of components, and
	 *  the depth of the hierarchy.  If it's practical, use explicit
	 *  positions and sizes rather than constraints to define the layout.
	 *  DataGrid's with <code>variableRowHeight="false"</code> (the
	 *  default) tend to perform better, likewise for
	 *  <code>showDataTips="false"</code> (the default) and
	 *  <code>clipAndEnableScrolling="false"</code> (the default).</p>
	 *  
	 *  <p>Examples of the various GridItemRenderer configurations described 
	 *  here are available in the examples section.</p>
	 * 
	 *  @see spark.components.DataGrid
	 *  @see spark.components.Grid
	 *  @see spark.components.gridClasses.GridColumn
	 *  @see spark.components.gridClasses.GridColumn#itemRenderer
	 *  @see spark.skins.spark.DefaultGridItemRenderer
	 *  
	 *  @includeExample examples/GridItemRendererExample.mxml
	 *  @includeExample examples/GridItemRendererCustomBindingExample.mxml
	 *  @includeExample examples/GridItemRendererCustomPrepareExample.mxml
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.5
	 *  @productversion Flex 4.5
	 */
	public class GridItemRenderer extends Group implements IGridItemRenderer
	{
		// include "../../core/Version.as";
		
		//--------------------------------------------------------------------------
		//
		//  Static Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * If the effective value of showDataTips has changed for this column, then
		 * set the renderer's toolTip property to a placeholder.  The real tooltip
		 * text is computed in the TOOL_TIP_SHOW handler below.
		 */    
		static mx_internal function initializeRendererToolTip(renderer:IGridItemRenderer):void
		{
			/*const toolTipClient:IToolTipManagerClient = renderer as IToolTipManagerClient;
			if (!toolTipClient)
				return;
			
			const showDataTips:Boolean = (renderer.rowIndex != -1) && renderer.column && renderer.column.getShowDataTips();
			const dataTip:String = toolTipClient.toolTip;
			
			if (!dataTip && showDataTips)
				toolTipClient.toolTip = "<dataTip>";
			else if (dataTip && !showDataTips)
				toolTipClient.toolTip = null;*/
		}
		
		/**
		 *  Shows the tooltip for one of the grid's item renderers.
		 *  This is the handler for the <code>ToolTipEvent.TOOL_TIP_SHOW</code>
		 *  event in GridItemRenderer, DefaultGridItemRenderer, and 
		 *  UITextFieldGridItemRenderer which are installed by the corresponding
		 *  constructors.
		 *  The item renderer's tool tip is computed just before it is shown.
		 * 
		 *  If the item renderer's column <code>showDataTips<code> property is true, 
		 *  a placeholder tool tip is registered with the tool tip manager so that 
		 *  mouse handlers are put in place to detect when the tool tip should be
		 *  shown by calling this handler.
		 *   
		 *  This handler replaces the placeholder text with the actual text and 
		 *  resizes the tooltip before moving it into position.  
		 *  The tip is positioned over the item renderer with the origin of the tip 
		 *  at 0, 0, after accounting for the layoutDirection of the grid.
		 *  
		 *  The current target is expected to implement IGridItemRenderer and
		 *  IUIComponent.
		 */ 
		static mx_internal function toolTipShowHandler(event:ToolTipEvent):void
		{/*
			var toolTip:IToolTip = event.toolTip;
			
			const renderer:IGridItemRenderer = event.currentTarget as IGridItemRenderer;
			if (!renderer)
				return;
			
			const uiComp:IUIComponent = event.currentTarget as IUIComponent;
			if (!uiComp)
				return;
			
			if(uiComp is IValidatorListener && IValidatorListener(uiComp).errorString)
				return;
			
			// If the renderer is partially obscured because the Grid has been 
			// scrolled, we'll put the tooltip in the center of the exposed portion
			// of the renderer.
			
			var rendererR:Rectangle = new Rectangle(
				renderer.getLayoutBoundsX(),
				renderer.getLayoutBoundsY(),
				renderer.getLayoutBoundsWidth(),
				renderer.getLayoutBoundsHeight());
			
			const scrollR:Rectangle = renderer.grid.scrollRect;
			if (scrollR)
				rendererR = rendererR.intersection(scrollR);  // exposed renderer b
			
			if ((rendererR.height == 0) || (rendererR.width == 0))
				return;
			
			// Determine if the toolTip needs to be adjusted for RTL layout.
			const mirror:Boolean = false; *//*renderer.layoutDirection == LayoutDirection.RTL;*/
			
			// Lazily compute the tooltip text and recalculate its width.
			/*toolTip.text = renderer.column.itemToDataTip(renderer.data);
			ToolTipManager.sizeTip(toolTip);
			
			// We need to position the tooltip at same x coordinate, 
			// center vertically and make sure it doesn't overlap the screen.
			// Call the helper function to handle this for us.
			
			// x,y: tooltip's location relative to the renderer's layout bounds
			// Assume there's no scaling in the coordinate space between renderer.width and toolTip.width 
			const x:int =  mirror ? (renderer.width - toolTip.width) : (rendererR.x - renderer.getLayoutBoundsX());
			const y:int = rendererR.y - renderer.getLayoutBoundsY() + ((rendererR.height - toolTip.height) / 2);*/
			
			/*var pt:Point = PopUpUtil.positionOverComponent(DisplayObject(uiComp),
			uiComp.systemManager,
			toolTip.width, 
			toolTip.height,
			NaN, 
			null, 
			new Point(x, y)); 
			toolTip.move(pt.x, pt.y);*/
		}
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function GridItemRenderer()
		{
			super();
			
			setCurrentStateNeeded = true;
			accessibilityEnabled = false;
			
			addEventListener(ToolTipEvent.TOOL_TIP_SHOW, GridItemRenderer.toolTipShowHandler);           
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  True if the renderer has been created and commitProperties hasn't
		 *  run yet. See commitProperties.
		 */
		private var setCurrentStateNeeded:Boolean = false;
		
		/**
		 *  @private
		 *  A flag determining if this renderer should play any 
		 *  associated transitions when a state change occurs. 
		 */
		mx_internal var playTransitions:Boolean = false; 
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		private function dispatchChangeEvent(eventType:String):void
		{
			/*if (hasEventListener(eventType))
				dispatchEvent(new Event(eventType));*/
		}
		
		//----------------------------------
		//  baselinePosition override
		//----------------------------------
		
		/**
		 *  @private
		 */
		override public function get baselinePosition():Number
		{
			/*if (!validateBaselinePosition() || !labelDisplay)
				return super.baselinePosition;
			
			const labelPosition:Point = globalToLocal(labelDisplay.parent.localToGlobal(
				new Point(labelDisplay.x, labelDisplay.y)));
			
			return labelPosition.y + labelDisplay.baselinePosition;*/
			return 0;
		}
		
		//----------------------------------
		//  column
		//----------------------------------
		
		private var _column:GridColumn = null;
		
		[Bindable("columnChanged")]
		
		/**
		 *  @inheritDoc
		 * 
		 *  <p>The Grid's <code>updateDisplayList()</code> method sets this property 
		 *  before calling <code>preprare()</code></p>. 
		 *  
		 *  @default null
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function get column():GridColumn
		{
			return _column;
		}
		
		/**
		 *  @private
		 */
		public function set column(value:GridColumn):void
		{
			if (_column == value)
				return;
			
			_column = value;
			dispatchChangeEvent("columnChanged");
		}
		
		//----------------------------------
		//  columnIndex
		//----------------------------------
		
		/**
		 *  @inheritDoc 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function get columnIndex():int
		{
			return (column) ? column.columnIndex : -1;
		}
		
		//----------------------------------
		//  data
		//----------------------------------
		
		private var _data:Object = null;
		
		[Bindable("dataChange")]  // compatible with FlexEvent.DATA_CHANGE
		
		/**
		 *  The value of the data provider item for the grid row 
		 *  corresponding to the item renderer.
		 *  This value corresponds to the object returned by a call to the 
		 *  <code>dataProvider.getItemAt(rowIndex)</code> method.
		 *
		 *  <p>Item renderers can override this property definition to access 
		 *  the data for the entire row of the grid. </p>
		 *  
		 *  @default null
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function get data():Object
		{
			return _data;
		}
		
		/**
		 *  @private
		 */
		public function set data(value:Object):void
		{
			if (_data == value)
				return;
			
			_data = value;
			
			const eventType:String = "dataChange"; 
			if (hasEventListener(eventType))
				dispatchEvent(new FlexEvent(eventType));  
		}
		
		//----------------------------------
		//  down
		//----------------------------------
		
		/**
		 *  @private
		 *  storage for the down property 
		 */
		private var _down:Boolean = false;
		
		/**
		 *  @inheritDoc
		 *
		 *  @default false
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */    
		public function get down():Boolean
		{
			return _down;
		}
		
		/**
		 *  @private
		 */    
		public function set down(value:Boolean):void
		{
			if (value == _down)
				return;
			
			_down = value;
			// setCurrentState(getCurrentRendererState(), playTransitions);
		}
		
		//----------------------------------
		//  grid
		//----------------------------------
		
		/**
		 *  Returns the Grid associated with this item renderer.
		 *  This is the same value as <code>column.grid</code>.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5 
		 */
		public function get grid():Grid
		{
			return (column) ? column.grid : null;
		}    
		
		//----------------------------------
		//  hovered
		//----------------------------------
		
		private var _hovered:Boolean = false;
		
		/**
		 *  @inheritDoc
		 *
		 *  @default false
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */    
		public function get hovered():Boolean
		{
			return _hovered;
		}
		
		/**
		 *  @private
		 */    
		public function set hovered(value:Boolean):void
		{
			if (value == _hovered)
				return;
			
			_hovered = value;
			// setCurrentState(getCurrentRendererState(), playTransitions);
		}
		
		//----------------------------------
		//  rowIndex
		//----------------------------------
		
		private var _rowIndex:int = -1;
		
		[Bindable("rowIndexChanged")]
		
		/**
		 *  @inheritDoc
		 * 
		 *  <p>The Grid's <code>updateDisplayList()</code> method sets this property 
		 *  before calling <code>prepare()</code></p>.   
		 * 
		 *  @default -1
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */    
		public function get rowIndex():int
		{
			return _rowIndex;
		}
		
		/**
		 *  @private
		 */    
		public function set rowIndex(value:int):void
		{
			if (_rowIndex == value)
				return;
			
			_rowIndex = value;
			dispatchChangeEvent("rowIndexChanged");        
		}
		
		//----------------------------------
		//  showsCaret
		//----------------------------------
		
		private var _showsCaret:Boolean = false;
		
		[Bindable("showsCaretChanged")]    
		
		/**
		 *  @inheritDoc
		 * 
		 *  <p>The Grid's <code>updateDisplayList()</code> method sets this property 
		 *  before calling <code>preprare()</code></p>.   
		 * 
		 *  @default false
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */    
		public function get showsCaret():Boolean
		{
			return _showsCaret;
		}
		
		/**
		 *  @private
		 */    
		public function set showsCaret(value:Boolean):void
		{
			if (_showsCaret == value)
				return;
			
			_showsCaret = value;
			// setCurrentState(getCurrentRendererState(), playTransitions);
			dispatchChangeEvent("labelDisplayChanged");           
		}
		
		//----------------------------------
		//  selected
		//----------------------------------
		
		private var _selected:Boolean = false;
		
		[Bindable("selectedChanged")]    
		
		/**
		 *  @inheritDoc
		 * 
		 *  <p>The Grid's <code>updateDisplayList()</code> method sets this property 
		 *  before calling <code>preprare()</code></p>.   
		 * 
		 *  @default false
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */    
		public function get selected():Boolean
		{
			return _selected;
		}
		
		/**
		 *  @private
		 */    
		public function set selected(value:Boolean):void
		{
			if (_selected == value)
				return;
			
			_selected = value;
			// setCurrentState(getCurrentRendererState(), playTransitions);
			dispatchChangeEvent("selectedChanged");        
		}
		
		//----------------------------------
		//  dragging
		//----------------------------------
		
		private var _dragging:Boolean = false;
		
		[Bindable("draggingChanged")]        
		
		/**
		 *  @inheritDoc
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function get dragging():Boolean
		{
			return _dragging;
		}
		
		/**
		 *  @private  
		 */
		public function set dragging(value:Boolean):void
		{
			if (_dragging == value)
				return;
			
			_dragging = value;
			// setCurrentState(getCurrentRendererState(), playTransitions);
			dispatchChangeEvent("draggingChanged");        
		}
		
		//----------------------------------
		//  label
		//----------------------------------
		
		private var _label:String = "";
		
		[Bindable("labelChanged")]
		
		/**
		 *  @copy IGridItemRenderer#label
		 *
		 *  @default ""
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function get label():String
		{
			return _label;
		}
		
		/**
		 *  @private
		 */ 
		public function set label(value:String):void
		{
			if (_label == value)
				return;
			
			_label = value;
			
			if (labelDisplay)
				labelDisplay.text = _label;
			
			dispatchChangeEvent("labelChanged");
		}
		
		//----------------------------------
		//  labelDisplay
		//----------------------------------
		
		private var _labelDisplay:TextBase = null;
		
		[Bindable("labelDisplayChanged")]
		
		/**
		 *  An optional visual component in the item renderer 
		 *  for displaying the <code>label</code> property.   
		 *  If you use this property to specify a visual component, 
		 *  the component's <code>text</code> property is kept synchronized 
		 *  with the item renderer's <code>label</code> property.
		 * 
		 *  @default null
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */    
		public function get labelDisplay():TextBase
		{
			return _labelDisplay
		}
		
		/**
		 *  @private
		 */    
		public function set labelDisplay(value:TextBase):void
		{
			if (_labelDisplay == value)
				return;
			
			_labelDisplay = value;
			dispatchChangeEvent("labelDisplayChanged");        
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods - ItemRenderer State Support 
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Returns the name of the state to be applied to the renderer. 
		 *  For example, a basic item renderer returns the String "normal", "hovered", 
		 *  or "selected" to specify the renderer's state. 
		 *  If dealing with touch interactions (or mouse interactions where selection
		 *  is ignored), "down" and "downAndSelected" can also be returned.
		 * 
		 *  <p>A subclass of GridItemRenderer must override this method to return a value 
		 *  if the behavior desired differs from the default behavior.</p>
		 * 
		 *  <p>In Flex 4.0, the 3 main states were "normal", "hovered", and "selected".
		 *  In Flex 4.5, "down" and "downAndSelected" have been added.</p>
		 *  
		 *  <p>The full set of states supported (in order of precedence) are: 
		 *    <ul>
		 *      <li>dragging</li>
		 *      <li>downAndSelected</li>
		 *      <li>selectedAndShowsCaret</li>
		 *      <li>hoveredAndShowsCaret</li>
		 *      <li>normalAndShowsCaret</li>
		 *      <li>down</li>
		 *      <li>selected</li>
		 *      <li>hovered</li>
		 *      <li>normal</li>
		 *    </ul>
		 *  </p>
		 * 
		 *  @return A String specifying the name of the state to apply to the renderer. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		protected function getCurrentRendererState():String
		{
			// this code is pretty confusing without multi-dimensional states, but it's
			// defined in order of precedence.
			/*
			if (dragging && hasState("dragging"))
				return "dragging";
			
			if (selected && down && hasState("downAndSelected"))
				return "downAndSelected";
			
			if (selected && showsCaret && hasState("selectedAndShowsCaret"))
				return "selectedAndShowsCaret";
			
			if (hovered && showsCaret && hasState("hoveredAndShowsCaret"))
				return "hoveredAndShowsCaret";
			
			if (showsCaret && hasState("normalAndShowsCaret"))
				return "normalAndShowsCaret"; 
			
			if (down && hasState("down"))
				return "down";
			
			if (selected && hasState("selected"))
				return "selected";
			
			if (hovered && hasState("hovered"))
				return "hovered";
			
			if (hasState("normal"))    
				return "normal";
			*/
			// If none of the above states are defined in the item renderer,
			// we return null. This means the user-defined renderer
			// will display but essentially be non-interactive visually. 
			return null;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */ 
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (setCurrentStateNeeded)
			{
				// setCurrentState(getCurrentRendererState(), playTransitions); 
				setCurrentStateNeeded = false;
			}
		}
		
		/**
		 *  @private
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(width, height);
			
			initializeRendererToolTip(this);
		} 
		
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function prepare(hasBeenRecycled:Boolean):void
		{
		}
		
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function discard(willBeRecycled:Boolean):void
		{
		}
		
	}
}