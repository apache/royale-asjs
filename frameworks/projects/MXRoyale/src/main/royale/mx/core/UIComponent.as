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

package mx.core
{
/*
import flash.accessibility.Accessibility;
import flash.accessibility.AccessibilityProperties;
import flash.display.BlendMode;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.GradientType;
import flash.display.InteractiveObject;
import flash.display.Loader;
import flash.display.Shader;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.EventPhase;
import flash.events.FocusEvent;
import flash.events.IEventDispatcher;
*/

import mx.controls.beads.ToolTipBead;
import mx.core.mx_internal;
COMPILE::SWF
{
import flash.display.DisplayObject;
import flash.display.Graphics;
}
COMPILE::JS{
    import org.apache.royale.core.WrappedHTMLElement;
}
import mx.display.Graphics;
import mx.events.EffectEvent;
import mx.events.FlexEvent;
import mx.events.KeyboardEvent;
import mx.events.MoveEvent;
import mx.events.PropertyChangeEvent;
import mx.events.ResizeEvent;
import mx.events.utils.KeyboardEventConverter;
import mx.events.utils.FocusEventConverter;
import mx.managers.ICursorManager;
import mx.managers.IFocusManager;
import mx.managers.IFocusManagerContainer;
import mx.managers.ILayoutManagerClient;
import mx.managers.ISystemManager;
import mx.resources.IResourceManager;
import mx.resources.ResourceManager;
import mx.styles.ISimpleStyleClient;
import mx.styles.IStyleClient;
import mx.styles.IStyleManager2;
import mx.styles.StyleManager;
import mx.utils.StringUtil;
import mx.utils.NameUtil;
import org.apache.royale.utils.MXMLDataInterpreter;
use namespace mx_internal;

import org.apache.royale.core.CallLaterBead;
import org.apache.royale.core.IChild;
import org.apache.royale.core.IMXMLDocument;
import org.apache.royale.core.IStatesImpl;
import org.apache.royale.core.IStatesObject;
import org.apache.royale.core.IUIBase;
import org.apache.royale.core.TextLineMetrics;
import org.apache.royale.core.UIBase;
import org.apache.royale.core.ValuesManager;

import org.apache.royale.core.IBorderPaddingMarginValuesImpl;
import org.apache.royale.core.styles.BorderStyles;
import org.apache.royale.effects.IEffect;
import org.apache.royale.events.Event;
import org.apache.royale.events.IEventDispatcher;
import org.apache.royale.events.MouseEvent;
import org.apache.royale.events.ValueChangeEvent;
import org.apache.royale.geom.Point;
import org.apache.royale.geom.Rectangle;
import org.apache.royale.html.beads.DisableBead;
import org.apache.royale.html.beads.DisabledAlphaBead;
import org.apache.royale.html.supportClasses.ContainerContentArea;
import org.apache.royale.utils.PointUtils;
import org.apache.royale.utils.CSSUtils;
import org.apache.royale.utils.loadBeadFromValuesManager;

import mx.validators.IValidatorListener;
import mx.validators.ValidationResult;
import mx.events.ValidationResultEvent;
import org.apache.royale.utils.MXMLDataInterpreter;
import mx.managers.IFocusManagerComponent;
import mx.events.FocusEvent;

import org.apache.royale.utils.ClassSelectorList;

/**
 *  Set a different class for click events so that
 *  there aren't dependencies on the flash classes
 *  on the JS side.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10.2
 *  @playerversion AIR 2.6
 *  @productversion Royale 0.0
 */
[Event(name="click", type="mx.events.MouseEvent")]

/**
 *  Dispatched when the component has finished its construction
 *  and has all initialization properties set.
 *
 *  <p>After the initialization phase, properties are processed, the component
 *  is measured, laid out, and drawn, after which the
 *  <code>creationComplete</code> event is dispatched.</p>
 * 
 *  @eventType = mx.events.FlexEvent.SHOW
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="show", type="mx.events.FlexEvent")]
// not implemented
[Event(name="hide", type="mx.events.FlexEvent")]

/**
 *  Dispatched when the component has finished its construction
 *  and has all initialization properties set.
 *
 *  <p>After the initialization phase, properties are processed, the component
 *  is measured, laid out, and drawn, after which the
 *  <code>creationComplete</code> event is dispatched.</p>
 * 
 *  @eventType = mx.events.FocusEvent.FOCUS_IN
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="focusIn", type="mx.events.FocusEvent")]

/**
 *  Dispatched when the component has finished its construction
 *  and has all initialization properties set.
 *
 *  <p>After the initialization phase, properties are processed, the component
 *  is measured, laid out, and drawn, after which the
 *  <code>creationComplete</code> event is dispatched.</p>
 * 
 *  @eventType = mx.events.FlexEvent.VALID
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="valid", type="mx.events.FlexEvent")]

/**
 * The "preinitialize" event gets dispatched after everything about this
 * UIComponent has been initialized, and it has been attached to
 * its parent, but before any of its children have been created.

 * <p>This allows a "preinitialize" event handler to set properties which
 * affect child creation.
 * Note that this implies that "preinitialize" handlers are called
 * top-down; i.e., parents before children..</p>
 * 
 *  @eventType mx.events.FlexEvent.PREINITIALIZE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="preinitialize", type="mx.events.FlexEvent")]
/**
 *  Dispatched when the component has finished its construction
 *  and has all initialization properties set.
 *
 *  <p>After the initialization phase, properties are processed, the component
 *  is measured, laid out, and drawn, after which the
 *  <code>creationComplete</code> event is dispatched.</p>
 * 
 *  @eventType mx.events.FlexEvent.INITIALIZE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="initialize", type="mx.events.FlexEvent")]
/**
 *  Dispatched when the component has finished its construction,
 *  property processing, measuring, layout, and drawing.
 *
 *  <p>At this point, depending on its <code>visible</code> property,
 *  the component is not visible even though it has been drawn.</p>
 *
 *  @eventType mx.events.FlexEvent.CREATION_COMPLETE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="creationComplete", type="mx.events.FlexEvent")]

/**
 *  Dispatched when an object has had its <code>commitProperties()</code>,
 *  <code>measure()</code>, and
 *  <code>updateDisplayList()</code> methods called (if needed).
 *
 *  <p>This is the last opportunity to alter the component before it is
 *  displayed. All properties have been committed and the component has
 *  been measured and layed out.</p>
 *
 *  <p>This event is only dispatched when there are one or more 
 *  relevant listeners attached to the dispatching object.</p>
 * 
 *  @eventType mx.events.FlexEvent.UPDATE_COMPLETE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="updateComplete", type="mx.events.FlexEvent")]


/**
 *  Dispatched when values are changed programmatically
 *  or by user interaction.
 *
 *  <p>Because a programmatic change triggers this event, make sure
 *  that any <code>valueCommit</code> event handler does not change
 *  a value that causes another <code>valueCommit</code> event.
 *  For example, do not change a control's <code>dataProvider</code>
 *  property in a <code>valueCommit</code> event handler. </p>
 *
 *  @eventType mx.events.FlexEvent.VALUE_COMMIT
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="valueCommit", type="mx.events.FlexEvent")]


/**
 *  Dispatched after the <code>currentState</code> property changes,
 *  but before the view state changes.
 * 
 *  <p>This event is only dispatched when there are one or more 
 *  relevant listeners attached to the dispatching object.</p>
 *
 *  @eventType mx.events.StateChangeEvent.CURRENT_STATE_CHANGING
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="currentStateChange", type="org.apache.royale.events.ValueChangeEvent")]

[Event(name="focusOut", type="mx.events.FocusEvent")]

[Event(name="change", type="org.apache.royale.events.Event")]

//--------------------------------------
//  Drag-and-drop events
//--------------------------------------

/**
 *  Dispatched by a component when the user moves the mouse over the component
 *  during a drag operation.
 *  In an application running in Flash Player,
 *  the event is dispatched many times when you move the mouse over any component.
 *  In an application running in AIR, the event is dispatched only once.
 *
 *  <p>In order to be a valid drop target, you must define a handler
 *  for this event.
 *  In the handler, you can change the appearance of the drop target
 *  to provide visual feedback to the user that the component can accept
 *  the drag.
 *  For example, you could draw a border around the drop target,
 *  or give focus to the drop target.</p>
 *
 *  <p>If you want to accept the drag, you must call the
 *  <code>DragManager.acceptDragDrop()</code> method. If you don't
 *  call <code>acceptDragDrop()</code>, you do not get any of the
 *  other drag events.</p>
 *
 *  <p>In Flash Player, the value of the <code>action</code> property is always
 *  <code>DragManager.MOVE</code>, even if you are doing a copy.
 *  This is because the <code>dragEnter</code> event occurs before
 *  the control recognizes that the Control key is pressed to signal a copy.
 *  The <code>action</code> property of the event object for the
 *  <code>dragOver</code> event does contain a value that signifies the type of
 *  drag operation. You can change the type of drag action by calling the
 *  <code>DragManager.showFeedback()</code> method.</p>
 *
 *  <p>In AIR, the default value of the <code>action</code> property is
 *  <code>DragManager.COPY</code>.</p>
 *
 *  <p>Because of the way data to a Tree control is structured,
 *  the Tree control handles drag and drop differently from the other list-based controls.
 *  For the Tree control, the event handler for the <code>dragDrop</code> event
 *  only performs an action when you move or copy data in the same Tree control,
 *  or copy data to another Tree control.
 *  If you drag data from one Tree control and drop it onto another Tree control
 *  to move the data, the event handler for the <code>dragComplete</code> event
 *  actually performs the work to add the data to the destination Tree control,
 *  rather than the event handler for the dragDrop event,
 *  and also removes the data from the source Tree control.
 *  This is necessary because to reparent the data being moved,
 *  Flex must remove it first from the source Tree control.</p>
 *
 *  @see mx.managers.DragManager
 *
 *  @eventType mx.events.DragEvent.DRAG_ENTER
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="dragEnter", type="mx.events.DragEvent")]
/**
 *  Dispatched by the drop target when the user releases the mouse over it.
 *
 *  <p>You use this event handler to add the drag data to the drop target.</p>
 *
 *  <p>If you call <code>Event.preventDefault()</code> in the event handler
 *  for the <code>dragDrop</code> event for
 *  a Tree control when dragging data from one Tree control to another,
 *  it prevents the drop.</p>
 *
 *  @eventType mx.events.DragEvent.DRAG_DROP
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="dragDrop", type="mx.events.DragEvent")]

/**
 *  Dispatched when the component is resized.
 *
 *  <p>You can resize the component by setting the <code>width</code> or
 *  <code>height</code> property, by calling the <code>setActualSize()</code>
 *  method, or by setting one of
 *  the following properties either on the component or on other components
 *  such that the LayoutManager needs to change the <code>width</code> or
 *  <code>height</code> properties of the component:</p>
 *
 *  <ul>
 *    <li><code>minWidth</code></li>
 *    <li><code>minHeight</code></li>
 *    <li><code>maxWidth</code></li>
 *    <li><code>maxHeight</code></li>
 *    <li><code>explicitWidth</code></li>
 *    <li><code>explicitHeight</code></li>
 *  </ul>
 *
 *  <p>The <code>resize</code> event is not
 *  dispatched until after the property changes.</p>
 * 
 *  <p>This event only dispatched when there are one or more 
 *  relevant listeners attached to the dispatching object.</p>
 *
 *  @eventType mx.events.ResizeEvent.RESIZE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="resize", type="mx.events.ResizeEvent")]

/**
 *  Dispatched when the object has moved.
 *
 *  <p>You can move the component by setting the <code>x</code>
 *  or <code>y</code> properties, by calling the <code>move()</code>
 *  method, by setting one
 *  of the following properties either on the component or on other
 *  components such that the LayoutManager needs to change the
 *  <code>x</code> or <code>y</code> properties of the component:</p>
 *
 *  <ul>
 *    <li><code>minWidth</code></li>
 *    <li><code>minHeight</code></li>
 *    <li><code>maxWidth</code></li>
 *    <li><code>maxHeight</code></li>
 *    <li><code>explicitWidth</code></li>
 *    <li><code>explicitHeight</code></li>
 *  </ul>
 *
 *  <p>When you call the <code>move()</code> method, the <code>move</code>
 *  event is dispatched before the method returns.
 *  In all other situations, the <code>move</code> event is not dispatched
 *  until after the property changes.</p>
 * 
 *  <p>This event only dispatched when there are one or more 
 *  relevant listeners attached to the dispatching object.</p>
 *
 *  @eventType mx.events.MoveEvent.MOVE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="move", type="mx.events.MoveEvent")]

//Events Copied from InteractiveObject
[Event(name="keyUp", type="mx.events.KeyboardEvent")]
[Event(name="keyDown", type="mx.events.KeyboardEvent")]

/**
 *  The main color for a component.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
[Style(name="chromeColor", type="uint", format="Color", inherit="yes")]

// Excluding the property to enable code hinting for the layoutDirection style
[Exclude(name="layoutDirection", kind="property")]


/**
 *  The UIComponent class is the base class for all visual components,
 *  both interactive and noninteractive.
 *
 *  <p>An interactive component can participate in tabbing and other kinds of
 *  keyboard focus manipulation, accept low-level events like keyboard and
 *  mouse input, and be disabled so that it does not receive keyboard and
 *  mouse input.
 *  This is in contrast to noninteractive components, like Label and
 *  ProgressBar, which simply display contents and are not manipulated by
 *  the user.</p>
 *  <p>The UIComponent class is not used as an MXML tag, but is used as a base
 *  class for other classes.</p>
 *
 *  @mxml
 *
 *  <p>All user interface components in Flex extend the UIComponent class.
 *  Flex components inherit the following properties from the UIComponent
 *  class:</p>
 *
 *  <pre>
 *  &lt;mx:<i>tagname</i>
 *   <b>Properties </b>
 *    currentState="null"
 *    doubleClickEnabled="false|true"
 *    enabled="true|false"
 *    height="0"
 *    id=""
 *    maxHeight="10000"
 *    maxWidth="10000"
 *    measuredHeight=
 *    measuredMinHeight=
 *    measuredMinWidth=
 *    measuredWidth=
 *    minHeight="0"
 *    minWidth="0"
 *    percentHeight="NaN"
 *    percentWidth="NaN"
 *    states="null"
 *    styleName="undefined"
 *    toolTip="null"
 *    transitions=""
 *    width="0"
 *    x="0"
 *    y="0"
 *
 *  <b>Styles</b>
 *    bottom="undefined"
 *
 *  <b>Events</b>
 *    valueCommit="<i>No default</i>"
 *  &gt;
 *  </pre>
 *
 *  @see mx.core.UIComponent
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class UIComponent extends UIBase
    implements IChildList,
    IFlexDisplayObject,
    IMXMLDocument,
    IInvalidating,
    IStatesObject,
    ISimpleStyleClient,
    IUIComponent, IVisualElement, IFlexModule, IValidatorListener
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    
    /**
     *  The default value for the <code>measuredWidth</code> property.
     *  Most components calculate a measuredWidth but some are flow-based and
     *  have to pick a number that looks reasonable.
     *
     *  @default 160
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const DEFAULT_MEASURED_WIDTH:Number = 160;
    
    /**
     *  The default value for the <code>measuredMinWidth</code> property.
     *  Most components calculate a measuredMinWidth but some are flow-based and
     *  have to pick a number that looks reasonable.
     *
     *  @default 40
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const DEFAULT_MEASURED_MIN_WIDTH:Number = 40;
    
    /**
     *  The default value for the <code>measuredHeight</code> property.
     *  Most components calculate a measuredHeight but some are flow-based and
     *  have to pick a number that looks reasonable.
     *
     *  @default 22
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const DEFAULT_MEASURED_HEIGHT:Number = 22;
    
    /**
     *  The default value for the <code>measuredMinHeight</code> property.
     *  Most components calculate a measuredMinHeight but some are flow-based and
     *  have to pick a number that looks reasonable.
     *
     *  @default 22
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const DEFAULT_MEASURED_MIN_HEIGHT:Number = 22;

    /**
     *  The default value for the <code>maxWidth</code> property.
     *
     *  @default 10000
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const DEFAULT_MAX_WIDTH:Number = 10000;
    // When changing this constant, make sure you change
    // the constant with the same name in LayoutElementUIComponentUtils
    
    /**
     *  The default value for the <code>maxHeight</code> property.
     *
     *  @default 10000
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const DEFAULT_MAX_HEIGHT:Number = 10000;
    // When changing this constant, make sure you change
    // the constant with the same name in LayoutElementUIComponentUtils

    private static var sessionId:int;

    //--------------------------------------------------------------------------
    //
    //  Class properties
    //
    //--------------------------------------------------------------------------
    
	
    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------


    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function UIComponent()
    {
        super();
        if (this is IFocusManagerComponent)
        {
			COMPILE::SWF
			{
				KeyboardEventConverter.setupInstanceConverters(this);
				FocusEventConverter.setupInstanceConverters(this);
			}
            addEventListener(FocusEvent.FOCUS_IN, focusInHandler);
            addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
            addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
            addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
        }
    }
    
    //----------------------------------
    //  className
    //----------------------------------

    /**
     *  The name of this instance's class, such as <code>"Button"</code>.
     *
     *  <p>This string does not include the package name.
     *  If you need the package name as well, call the
     *  <code>getQualifiedClassName()</code> method in the flash.utils package.
     *  It returns a string such as <code>"mx.controls::Button"</code>.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function get className():String
    {
        return NameUtil.getUnqualifiedClassName(this);
    }
    
    public function executeBindings(recurse:Boolean = false):void
    {
	   recurse = false;
	   trace("UIComponent.executeBindings is not implemented");
    }

    //--------------------------------------------------------------------------
    //
    //  Variables: Creation
    //
    //--------------------------------------------------------------------------
    public function get maintainAspectRatio():Boolean
	{
	   return true;
	}
    public function set maintainAspectRatio(value:Boolean):void
	{
	
	}
	
	private var _index:int;
	
	/**
	 *  The position with the dataProvider being shown by the itemRenderer instance.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public function get index():int
	{
		return _index;
	}
	public function set index(value:int):void
	{
		_index = value;
	}				
				
    //----------------------------------
    //  chromeColor
    //----------------------------------
    private var _chromeColor:uint;
	
    public function get chromeColor():uint
       {
	  return _chromeColor;
       }
     public function set chromeColor(value:uint):void
       {
	  _chromeColor = value;
       }
	   
	
    //----------------------------------
    //  mouseFocusEnabled
    //----------------------------------
	
    public function get mouseFocusEnabled():Boolean
       {
	  return false;
       }
    public function set mouseFocusEnabled(value:Boolean):void
       {
	
       }
	
	
    //----------------------------------
    //  initialized
    //----------------------------------

    /**
     *  @private
     *  Storage for the initialized property.
     */
     
 
    private var _initialized:Boolean = false;

    [Inspectable(environment="none")]

    /**
     *  A flag that determines if an object has been through all three phases
     *  of layout: commitment, measurement, and layout (provided that any were required).
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get initialized():Boolean
    {
        return _initialized;
    }

    /**
     *  @private
     */
    public function set initialized(value:Boolean):void
    {
        _initialized = value;

        if (value)
        {
            dispatchEvent(new FlexEvent(FlexEvent.CREATION_COMPLETE));
        }
    }
    
	//----------------------------------
    //  graphics copied from Sprite
    //----------------------------------
		private var _graphics:mx.display.Graphics;

        COMPILE::SWF
        override public function get graphics():flash.display.Graphics
        {
            // in SWF, beads that are compiled against UIBase
            // outside of the emulation components will call
            // this expecting flash.display.Graphics.
            // Calls from within the emulation components should
            // resolve to royalegraphics below.
            // this override for SWF must be here in order
            // for the compiler to know which calls to map to
            // royalegraphics.  Emulation Components should resolve
            // calls to UIComponent.graphics and non-Emulation
            // Components should resolve to Sprite.graphics
            return super.graphics;        
        }
        
        COMPILE::JS
		public function get graphics():Graphics
		{
            if (_graphics == null)
                _graphics = new mx.display.Graphics(this);
			return _graphics;
		}

        // the compiler will resolve access to graphics with royalegraphics
        public function get royalegraphics():mx.display.Graphics
        {
            if (_graphics == null)
                _graphics = new mx.display.Graphics(this);
            return _graphics;
        }            
            
        COMPILE::SWF
        public function get flashgraphics():flash.display.Graphics
        {
            return super.graphics;
        }            
        
    COMPILE::JS{
	private var _mask:UIComponent;
		 public function set mask(value:UIComponent):void
		{
			
		}
		
		 public function get mask():UIComponent
		{
			return _mask
		}
	 
	 }

    COMPILE::JS
	private var _rotation:Number = 0;
	 
    COMPILE::JS
	public function get rotation():Number
	{
	    return _rotation;
	}
    
    COMPILE::JS
    public function set rotation(value:Number):void
	{
	   	_rotation = value;
        element.style.transform = computeTransformString();
        element.style["transform-origin-x"] = "0px";
        element.style["transform-origin-y"] = "0px";
	}
	
    COMPILE::JS
	private function computeTransformString():String
    {
        var s:String = "";
        var value:Number = _rotation;
        if (_rotation != 0)
        {
            if (value < 0)
                value += 360;
            s += "rotate(" + value.toString() + "deg)";
        }
        if (_scaleX != 1.0)
        {
            if (s.length)
                s += " ";
            s += "scaleX(" + _scaleX.toString() + ")";
        }
        if (_scaleY != 1.0)
        {
            if (s.length)
                s += " ";
            s += "scaleY(" + _scaleY.toString() + ")";
        }
        return s;
    }
    //----------------------------------
    //  name
    //----------------------------------
    
    /**
     *  @private
     */
    COMPILE::JS
    private var _name:String;
    
    /**
     *  @copy mx.core.IVisualElement#owner
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     *  @royaleignorecoercion mx.core.IUIComponent
     */
    COMPILE::JS
    public function get name():String
    {
        return _name;
    }
    
    COMPILE::JS
    public function set name(value:String):void
    {
        _name = value;
    }

    //--------------------------------------------------------------------------
    //
    //  Variables: Measurement
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Holds the last recorded value of the x property.
     *  Used in dispatching a MoveEvent.
     */
    private var oldX:Number = 0;

    /**
     *  @private
     *  Holds the last recorded value of the y property.
     *  Used in dispatching a MoveEvent.
     */
    private var oldY:Number = 0;

    /**
     *  @private
     *  Holds the last recorded value of the width property.
     *  Used in dispatching a ResizeEvent.
     */
    private var oldWidth:Number = 0;

    /**
     *  @private
     *  Holds the last recorded value of the height property.
     *  Used in dispatching a ResizeEvent.
     */
    private var oldHeight:Number = 0;

    /**
     *  @private
     *  Holds the last recorded value of the minWidth property.
     */
    private var oldMinWidth:Number;

    /**
     *  @private
     *  Holds the last recorded value of the minHeight property.
     */
    private var oldMinHeight:Number;

    /**
     *  @private
     *  Holds the last recorded value of the explicitWidth property.
     */
    private var oldExplicitWidth:Number;

    /**
     *  @private
     *  Holds the last recorded value of the explicitHeight property.
     */
    private var oldExplicitHeight:Number;

    //----------------------------------
    //  baselinePosition
    //----------------------------------
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get baselinePosition():Number
    {
        /*
        if (!validateBaselinePosition())
            return NaN;
        
        // Unless the height is very small, the baselinePosition
        // of a generic UIComponent is calculated as if there was
        // a UITextField using the component's styles
        // whose top coincides with the component's top.
        // If the height is small, the baselinePosition is calculated
        // as if there were text within whose ascent the component
        // is vertically centered.
        // At the crossover height, these two calculations
        // produce the same result.
        
        var lineMetrics:TextLineMetrics = measureText("Wj");
        
        if (height < 2 + lineMetrics.ascent + 2)
            return int(height + (lineMetrics.ascent - height) / 2);
        
        return 2 + lineMetrics.ascent;*/
        return 0;
    }

    //--------------------------------------------------------------------------
    //
    //  Variables: Styles
    //
    //--------------------------------------------------------------------------

    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------

    //------------------------------------------------------------------------
    //
    //  Properties: Accessibility
    //
    //------------------------------------------------------------------------
    
    /**
     *  A convenience accessor for the <code>silent</code> property
     *  in this UIComponent's <code>accessibilityProperties</code> object.
     *
     *  <p>Note that <code>accessibilityEnabled</code> has the opposite sense from silent;
     *  <code>accessibilityEnabled</code> is <code>true</code> 
     *  when <code>silent</code> is <code>false</code>.</p>
     *
     *  <p>The getter simply returns <code>accessibilityProperties.silent</code>,
     *  or <code>true</code> if <code>accessibilityProperties</code> is null.
     *  The setter first checks whether <code>accessibilityProperties</code> is null, 
     *  and if it is, sets it to a new AccessibilityProperties instance.
     *  Then it sets <code>accessibilityProperties.silent</code>.</p>
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
     
    COMPILE::JS{
    public function get tabChildren():Boolean
	{
	  return 0;
	}
    public function set tabChildren(value:Boolean):void
	{
	}
    }
    
    private var _accessibilityEnabled:Boolean = true;

    public function get accessibilityEnabled():Boolean
    {
        return _accessibilityEnabled;
    }
    
    public function set accessibilityEnabled(value:Boolean):void
    {
      _accessibilityEnabled = value;
    }
    
    /**
     *  From flash.display.Sprite
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    COMPILE::SWF
    { override }
    public function get useHandCursor():Boolean
    {
        trace("useHandCursor not implemented");
        return false;
    }
    
    COMPILE::SWF
    { override }
    public function set useHandCursor(value:Boolean):void
    {
        trace("useHandCursor not implemented");
    }
	
	 /**
     *  From flash.display.InteractiveObject
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    COMPILE::JS
    public function get mouseEnabled():Boolean
    {
        trace("mouseEnabled not implemented");
        return false;
    }
    
    COMPILE::JS
    public function set mouseEnabled(value:Boolean):void
    {
        trace("mouseEnabled not implemented");
    }
	
	 /**
     *  From flash.display.DisplayObjectContainer
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    COMPILE::JS
    public function get mouseChildren():Boolean
    {
        trace("mouseChildren not implemented");
        return false;
    }
    
    COMPILE::JS
    public function set mouseChildren(value:Boolean):void
    {
        trace("mouseChildren not implemented");
    }
	
	
	/**
     *  From flash.display.Sprite
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    COMPILE::SWF
    { override }
    public function get buttonMode():Boolean
    {
        trace("buttonMode not implemented");
        return false;
    }
    
    COMPILE::SWF
    { override }
    public function set buttonMode(value:Boolean):void
    {
        trace("buttonMode not implemented");
    }
    
    //----------------------------------
    //  errorString
    //----------------------------------
    
    /**
     *  @private
     *  Storage for errorString property.
     */
    mx_internal var _errorString:String = "";
    
    /**
     *  @private
     *  Storage for previous errorString property.
     */
    private var oldErrorString:String = "";
    
    [Bindable("errorStringChanged")]
    
    /**
     *  The text that displayed by a component's error tip when a
     *  component is monitored by a Validator and validation fails.
     *
     *  <p>You can use the <code>errorString</code> property to show a
     *  validation error for a component, without actually using a validator class.
     *  When you write a String value to the <code>errorString</code> property,
     *  Flex draws a red border around the component to indicate the validation error,
     *  and the String appears in a tooltip as the validation error message when you move
     *  the mouse over the component, just as if a validator detected a validation error.</p>
     *
     *  <p>To clear the validation error, write an empty String, "",
     *  to the <code>errorString</code> property.</p>
     *
     *  <p>Note that writing a value to the <code>errorString</code> property
     *  does not trigger the valid or invalid events; it only changes the border
     *  color and displays the validation error message.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get errorString():String
    {
        return _errorString;
    }
    
    /**
     *  @private
     */
    public function set errorString(value:String):void
    {
        if (value == _errorString)
            return;
        
        oldErrorString = _errorString;
        _errorString = value;
        
        toolTip = value;
        if (_toolTipBead)
            _toolTipBead.isError = value != null && value != "";
        
        //errorStringChanged = true;
        setBorderColorForErrorString();
        dispatchEvent(new Event("errorStringChanged"));
    }

    //--------------------------------------------------------------------------
    //
    //  Variables: Validation
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    mx_internal var saveBorderColor:Boolean = true;
    
    /**
     *  @private
     */
    mx_internal var origBorderColor:Number;
    
    /**
     *  @private
     *  Set the appropriate borderColor based on errorString.
     *  If we have an errorString, use errorColor. If we don't
     *  have an errorString, restore the original borderColor.
     */
    private function setBorderColorForErrorString():void
    {
        var showErrorSkin:Boolean = true; //FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_0 || getStyle("showErrorSkin");
        
        if (showErrorSkin)
        {
            
            if (!_errorString || _errorString.length == 0)
            {
                if (!isNaN(origBorderColor))
                {
                    setStyle("borderColor", origBorderColor);
                    saveBorderColor = true;
                }
            }
            else
            {
                // Remember the original border color
                if (saveBorderColor)
                {
                    saveBorderColor = false;
                    origBorderColor = getStyle("borderColor");
                    COMPILE::JS
                    {
                        if (isNaN(origBorderColor))
                        {
                            var borderImpl:IBorderPaddingMarginValuesImpl = ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl;
                            if (borderImpl)
                            {
                                var bs:BorderStyles = borderImpl.getBorderStyles(this);
                                origBorderColor = bs.color;
                            }
                        }
                    }                    
                }
                
                setStyle("borderColor", getStyle("errorColor"));
            }
            
            styleChanged("themeColor");
            
            /*
            var focusManager:IFocusManager = focusManager;
            var focusObj:DisplayObject = focusManager ?
                DisplayObject(focusManager.getFocus()) :
                null;
            if (focusManager && focusManager.showFocusIndicator &&
                focusObj == this)
            {
                drawFocus(true);
            }
            */
            
        }
    }

    //----------------------------------
    //  owner
    //----------------------------------

    /**
     *  @private
     */
    private var _owner:IUIComponent;

    /**
     *  @copy mx.core.IVisualElement#owner
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     *  @royaleignorecoercion mx.core.IUIComponent
     */
    public function get owner():IUIComponent
    {
        return _owner ? _owner : parent as IUIComponent;
    }

    public function set owner(value:IUIComponent):void
    {
        _owner = value;
    }

    //----------------------------------
    //  doubleClickEnabled
    //----------------------------------

    /**
     *  Specifies whether the UIComponent object receives <code>doubleClick</code> events.
     *  The default value is <code>false</code>, which means that the UIComponent object
     *  does not receive <code>doubleClick</code> events.
     *
     *  <p>The <code>mouseEnabled</code> property must also be set to <code>true</code>,
     *  its default value, for the object to receive <code>doubleClick</code> events.</p>
     *
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    COMPILE::SWF
    { override }
    [Inspectable(enumeration="true,false", defaultValue="true")]    
    public function get doubleClickEnabled():Boolean
    {
        // TODO
        trace("doubleClickEnabled not implemented");
        return false;
    }

    /**
     *  @private
     *  Propagate to children.
     */
    COMPILE::SWF
    {
        override 
    }
    public function set doubleClickEnabled(value:Boolean):void
    {
        // TODO
        trace("doubleClickEnabled not implemented");
    }

    //----------------------------------
    //  enabled
    //----------------------------------

    /**
     *  @private
     */
    private var _enabled:Boolean = true;

    [Inspectable(category="General", enumeration="true,false", defaultValue="true")]
    [Bindable("disabledChange")]

    /**
     *  @copy mx.core.IUIComponent#enabled
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get enabled():Boolean
    {
        return _enabled;
    }

    /**
     *  @private
     */
    public function set enabled(value:Boolean):void
    {
        _enabled = value;
        if (_disableBead == null) {
		_disableBead = new DisableBead();
		addBead(_disableBead);
		addBead(new DisabledAlphaBead());
	}
	_disableBead.disabled = !_enabled;
    }

    //----------------------------------
    //  focusEnabled
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the focusEnabled property.
     */
    private var _focusEnabled:Boolean = true;
    
    [Inspectable(defaultValue="true")]
    
    /**
     *  Indicates whether the component can receive focus when tabbed to.
     *  You can set <code>focusEnabled</code> to <code>false</code>
     *  when a UIComponent is used as a subcomponent of another component
     *  so that the outer component becomes the focusable entity.
     *  If this property is <code>false</code>, focus is transferred to
     *  the first parent that has <code>focusEnable</code>
     *  set to <code>true</code>.
     *
     *  <p>The default value is <code>true</code>, except for the 
     *  spark.components.Scroller component. 
     *  For that component, the default value is <code>false</code>.</p>
     *
     *  @see spark.components.Scroller
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get focusEnabled():Boolean
    {
        return _focusEnabled;
    }
    
    /**
     *  @private
     */
    public function set focusEnabled(value:Boolean):void
    {
        _focusEnabled =  value;
    }
    
    //----------------------------------
    //  hasFocusableChildren
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the hasFocusableChildren property.
     */
    private var _hasFocusableChildren:Boolean = false;
    
    [Bindable("hasFocusableChildrenChange")]
    [Inspectable(defaultValue="false")]
    
    /**
     *  A flag that indicates whether child objects can receive focus.
     * 
     *  <p><b>Note: </b>This property is similar to the <code>tabChildren</code> property
     *  used by Flash Player. 
     *  Use the <code>hasFocusableChildren</code> property with Flex applications.
     *  Do not use the <code>tabChildren</code> property.</p>
     * 
     *  <p>This property is usually <code>false</code> because most components
     *  either receive focus themselves or delegate focus to a single
     *  internal sub-component and appear as if the component has
     *  received focus. 
     *  For example, a TextInput control contains a focusable
     *  child RichEditableText control, but while the RichEditableText
     *  sub-component actually receives focus, it appears as if the
     *  TextInput has focus. TextInput sets <code>hasFocusableChildren</code>
     *  to <code>false</code> because TextInput is considered the
     *  component that has focus. Its internal structure is an
     *  abstraction.</p>
     *
     *  <p>Usually only navigator components, such as TabNavigator and
     *  Accordion, have this flag set to <code>true</code> because they
     *  receive focus on Tab but focus goes to components in the child
     *  containers on further Tabs.</p>
     *
     *  <p>The default value is <code>false</code>, except for the 
     *  spark.components.Scroller component. 
     *  For that component, the default value is <code>true</code>.</p>
     *
     *  @see spark.components.Scroller
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get hasFocusableChildren():Boolean
    {
        return _hasFocusableChildren;
    }
    
    /**
     *  @private
     */
    public function set hasFocusableChildren(value:Boolean):void
    {
        if (value != _hasFocusableChildren)
        {
            _hasFocusableChildren = value;
            dispatchEvent(new Event("hasFocusableChildrenChange"));
        }
    }
	
	//----------------------------------
    //  tabEnabled
    //----------------------------------
    private var _tabEnabled:Boolean = true;
	COMPILE::JS
	{
	 public function get tabEnabled():Boolean
    {
        return _tabEnabled;
    }
    
    /**
     *  @private
     */
    public function set tabEnabled(value:Boolean):void
    {
       _tabEnabled = value;
    }
	}
    //----------------------------------
    //  tabFocusEnabled
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the tabFocusEnabled property.
     */
    private var _tabFocusEnabled:Boolean = true;
    
    [Bindable("tabFocusEnabledChange")]
    [Inspectable(defaultValue="true")]
    
    /**
     *  A flag that indicates whether this object can receive focus
     *  via the TAB key
     * 
     *  <p>This is similar to the <code>tabEnabled</code> property
     *  used by the Flash Player.</p>
     * 
     *  <p>This is usually <code>true</code> for components that
     *  handle keyboard input, but some components in controlbars
     *  have them set to <code>false</code> because they should not steal
     *  focus from another component like an editor.
     *  </p>
     *
     *  @default true
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get tabFocusEnabled():Boolean
    {
        return _tabFocusEnabled;
    }
    
    /**
     *  @private
     */
    public function set tabFocusEnabled(value:Boolean):void
    {
        if (value != _tabFocusEnabled)
        {
            _tabFocusEnabled = value;
            dispatchEvent(new Event("tabFocusEnabledChange"));
        }
    }
    
    //----------------------------------
    //  tabIndex
    //----------------------------------
    

    COMPILE::JS
    public function get tabIndex():int
    {
        return element.tabIndex;
    }
    
    /**
     *  @private
     */
    COMPILE::JS
    public function set tabIndex(value:int):void
    {
        element.tabIndex =  value;
    }
    
    //----------------------------------
    //  cacheAsBitmap
    //----------------------------------

    COMPILE::JS
    public function get cacheAsBitmap():Boolean
    {
        // TODO
        trace("cacheAsBitmap not implemented");
        return false;
    }
    
    /**
     *  @private
     */
    COMPILE::SWF
    {
        override
    }
    public function set cacheAsBitmap(value:Boolean):void
    {
        // TODO
        trace("cacheAsBitmap not implemented");
    }

    //----------------------------------
    //  filters
    //----------------------------------

    /**
     *  @private
     *  Storage for the filters property.
     */
    private var _filters:Array;

    /**
     *  @private
     */
    COMPILE::SWF
    {
        override
    }
    public function get filters():Array
    {
        return _filters;
    }

    /**
     *  @private
     */
    COMPILE::SWF
    {
        override
    }
    public function set filters(value:Array):void
    {
        // TODO
        trace("filters not implemented");
    }

       
    //--------------------------------------------------------------------------
    //
    //  Properties: Manager access
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  cursorManager
    //----------------------------------

    /**
     *  Gets the CursorManager that controls the cursor for this component
     *  and its peers.
     *  Each top-level window has its own instance of a CursorManager;
     *  To make sure you're talking to the right one, use this method.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get cursorManager():ICursorManager
    {
        // TODO
        trace("cursorManager not implemented");

        return null;
        //return CursorManager.getInstance();
    }

    //----------------------------------
    //  focusManager
    //----------------------------------

    /**
     *  @private
     *  Storage for the focusManager property.
     */
    private var _focusManager:IFocusManager;

    [Inspectable(environment="none")]

    /**
     *  Gets the FocusManager that controls focus for this component
     *  and its peers.
     *  Each popup has its own focus loop and therefore its own instance
     *  of a FocusManager.
     *  To make sure you're talking to the right one, use this method.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get focusManager():IFocusManager
    {
        if (_focusManager)
            return _focusManager;
        
        var o:IUIBase = parent as IUIBase;
        
        while (o)
        {
            if (o is IFocusManagerContainer)
                return IFocusManagerContainer(o).focusManager;
            
            o = o.parent as IUIBase;
        }
        
        return null;
    }

    /**
     *  @private
     *  IFocusManagerContainers have this property assigned by the framework
     */
    public function set focusManager(value:IFocusManager):void
    {
        _focusManager = value;
    }
    
    //----------------------------------
    //  resourceManager
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the resourceManager property.
     */
    private var _resourceManager:IResourceManager = ResourceManager.getInstance();
    
    /**
     *  @private
     *  This metadata suppresses a trace() in PropertyWatcher:
     *  "warning: unable to bind to property 'resourceManager' ..."
     */
    [Bindable("unused")]
    
    /**
     *  A reference to the object which manages
     *  all of the application's localized resources.
     *  This is a singleton instance which implements
     *  the IResourceManager interface.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function get resourceManager():IResourceManager
    {
        return _resourceManager;
    }
    
    //----------------------------------
    //  styleManager
    //----------------------------------
    
    /**
     *  @private
     */
    private var _styleManager:IStyleManager2;
    
    /**
     *  Returns the StyleManager instance used by this component.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get styleManager():IStyleManager2
    {
        if (!_styleManager)
            _styleManager = StyleManager.getStyleManager(moduleFactory);
        
        return _styleManager;
    }
    
    //----------------------------------
    //  systemManager
    //----------------------------------

    /**
     *  @private
     *  Storage for the systemManager property.
     *  Set by the SystemManager so that each UIComponent
     *  has a references to its SystemManager
     */
    private var _systemManager:ISystemManager;

    [Inspectable(environment="none")]

    /**
     *  Returns the SystemManager object used by this component.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get systemManager():ISystemManager
    {
        // TODO
        if (_systemManager == null && parent != null && parent is UIComponent)
            _systemManager = (parent as UIComponent).systemManager;
        
        return _systemManager;
    }

    /**
     *  @private
     */
    public function set systemManager(value:ISystemManager):void
    {
        // TODO
        _systemManager = value;
    }
    
COMPILE::JS
{
    public function get stage():Object
    {
        return systemManager;
    }
}
    //--------------------------------------------------------------------------
    //
    //  Properties: Modules
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  moduleFactory
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the moduleFactory property.
     */
    private var _moduleFactory:IFlexModuleFactory;
    
    [Inspectable(environment="none")]
    
    /**
     *  A module factory is used as context for using embedded fonts and for
     *  finding the style manager that controls the styles for this 
     *  component. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get moduleFactory():IFlexModuleFactory
    {
        return _moduleFactory;
    }
    
    /**
     *  @private
     */
    public function set moduleFactory(factory:IFlexModuleFactory):void
    {
        //_styleManager = null;
        
        var n:int = numChildren;
        for (var i:int = 0; i < n; i++)
        {
            var child:IFlexModule = getChildAt(i) as IFlexModule;
            if (!child)
                continue;
            if (child == this)
                continue;  // in the browser, some child HTMLElements reference the main component
            if (child.moduleFactory == null || child.moduleFactory == _moduleFactory)
            {
                child.moduleFactory = factory;
            }
        }
        /*
        if (advanceStyleClientChildren != null)
        {
            for (var styleClient:Object in advanceStyleClientChildren)
            {
                var iAdvanceStyleClientChild:IFlexModule = styleClient
                    as IFlexModule;
                
                if (iAdvanceStyleClientChild && 
                    (iAdvanceStyleClientChild.moduleFactory == null 
                        || iAdvanceStyleClientChild.moduleFactory == _moduleFactory))
                {
                    iAdvanceStyleClientChild.moduleFactory = factory;
                }
            }
        }*/
        _moduleFactory = factory;
        
        //setDeferredStyles();
    }

    //--------------------------------------------------------------------------
    //
    //  Properties: MXML
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  _component (was 'document' in Flex)
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the document property.
     *  This variable is initialized in the init() method.
     *  A document object (i.e., an Object at the top of the hierarchy
     *  of a Flex application, MXML component, or AS component) has an
     *  autogenerated override of initalize() which sets its _document to
     *  'this', so that its 'document' property is a reference to itself.
     *  Other UIComponents set their _document to their parent's _document,
     *  so that their 'document' property refers to the document object
     *  that they are inside.
     */
    protected var _mxmlDocument:Object;
    
    [Inspectable(environment="none")]
    
    /**
     *  A reference to the document object associated with this UIComponent.
     *  A document object is an Object at the top of the hierarchy of a
     *  Flex application, MXML component, or AS component.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get mxmlDocument():Object
    {
        if (!_mxmlDocument && MXMLDescriptor != null)
            _mxmlDocument = this;
        return _mxmlDocument;
    }
    
    /**
     *  A reference to the document object associated with this UIComponent.
     *  A document object is an Object at the top of the hierarchy of a
     *  Flex application, MXML component, or AS component.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function set mxmlDocument(value:Object):void
    {
        var n:int = numChildren;
        for (var i:int = 0; i < n; i++)
        {
            var child:IUIComponent = getChildAt(i) as IUIComponent;
            if (!child)
                continue;
            // JS subtrees will point back to the component.  Ignore those.
            if (child == this)
                continue;
            
            if (child.mxmlDocument == _mxmlDocument ||
                child.mxmlDocument == FlexGlobals.topLevelApplication)
            {
                child.mxmlDocument = value;
            }
        }
        
        _mxmlDocument = value;
    }
    
    /**
     * If the component is going to be used in an absolute positioning layout
     */
    COMPILE::JS
    public var isAbsolute:Boolean = true;
    
    override public function addedToParent():void
    {
        COMPILE::JS
        {
            if (isAbsolute)
                // Flex layouts don't use percentages the way the browser
                // does, so we have to absolute position everything.
                element.style.position = "absolute";
        }
        super.addedToParent();
        
        COMPILE::JS
        {
            if (!isNaN(_backgroundAlpha) && _backgroundColor !== null)
            {
                var red:Number = parseInt("0x" + _backgroundColor.substring(1, 3));
                var green:Number = parseInt("0x" + _backgroundColor.substring(3, 5));
                var blue:Number = parseInt("0x" + _backgroundColor.substring(5, 7));
                var rgba:String = "rgba(" + red + "," + green + "," + blue + "," + _backgroundAlpha + ")";
                (element as HTMLElement).style['backgroundColor'] = rgba;
            }                
        }

        
        if (!initialized)
        {
            initialize();
            initialized = true;
        }

        if (!mxmlDocument)
		{
			var p:IChild = parent as IChild;
			while (p && !(p is UIComponent))
			{
				p = p.parent as IChild;
			}
			if (p)
				mxmlDocument = UIComponent(p).mxmlDocument;
		}
    }
    
    //----------------------------------
    //  parentApplication
    //----------------------------------

    [Bindable("initialize")]

    /*
     *  Note:
     *  There are two reasons that 'parentApplication' is typed as Object
     *  rather than as Application. The first is that typing it as Application
     *  would make UIComponent dependent on Application, slowing down compile
     *  times not only for SWCs for also for MXML and AS components. The
     *  second is that authors would not be able to access properties and
     *  methods in the <Script> of their <Application> without casting it
     *  to their application's subclass, as in
     *     MyApplication(paentApplication).myAppMethod().
     *  Therefore we decided to dispense with strict typing for
     *  'parentApplication'.
     */
    /**
     *  A reference to the Application object that contains this UIComponent
     *  instance.
     *  This Application object might exist in a SWFLoader control in another
     *  Application, and so on, creating a chain of Application objects that
     *  can be walked using parentApplication.
     *
     *  <p>The <code>parentApplication</code> property of an Application is never itself;
     *  it is either the Application into which it was loaded or null
     *  (for the top-level Application).</p>
     *
     *  <p>Walking the application chain using the <code>parentApplication</code>
     *  property is similar to walking the document chain using the
     *  <code>parentDocument</code> property.
     *  You can access the top-level application using the
     *  <code>application</code> property of the Application class.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get parentApplication():Object
    {
        // Look for the SystemManager's document,
        // which should be the Application.
        var o:Object = systemManager.mxmlDocument;

        // If this UIComponent is its own root, then it is an Application.
        // We want to return its parent Application, or null
        // (if it has no parent because it is the top-level Application).
        // The hierarchy in this situation looks something like this:
        //
        //  SystemManager
        //      Application
        //          SomeContainer
        //              Loader
        //                  Loaded App's SystemManager
        //                      Application
        //                          ThisComponent
        if (o == this)
        {
            var p:UIComponent = o.systemManager.parent as UIComponent;
            o = p ? p.systemManager.mxmlDocument : null;
        }

        return o;
    }

    //----------------------------------
    //  parentComponent
    //----------------------------------

    [Bindable("initialize")]

    /**
     *  A reference to the parent component object for this UIComponent.
     *  A component object is a UIComponent at the top of the hierarchy
     *  of a Flex application, MXML component, or AS component.
     *
     *  <p>For the Application object, the <code>parentDocument</code>
     *  property is null.
     *  This property  is useful in MXML scripts to go up a level
     *  in the chain of document objects.
     *  It can be used to walk this chain using
     *  <code>parentDocument.parentDocument</code>, and so on.</p>
     *
     *  <p>It is typed as Object so that authors can access properties
     *  and methods on ancestor document objects without casting.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get parentMxmlDocument():Object
    {
        if (mxmlDocument == this)
        {
            var p:IUIComponent = parent as IUIComponent;
            if (p)
                return p.mxmlDocument;

            var sm:ISystemManager = parent as ISystemManager;
            if (sm)
                return sm.mxmlDocument;

            return null;
        }
        else
        {
            return mxmlDocument;
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Properties: Measurement
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  measuredMinWidth
    //----------------------------------

    /**
     *  @private
     *  Storage for the measuredMinWidth property.
     */
    private var _measuredMinWidth:Number = 0;

    [Inspectable(environment="none")]

    /**
     *  The default minimum width of the component, in pixels.
     *  This value is set by the <code>measure()</code> method.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get measuredMinWidth():Number
    {
        return _measuredMinWidth;
    }

    /**
     *  @private
     */
    public function set measuredMinWidth(value:Number):void
    {
        _measuredMinWidth = value;
    }

    //----------------------------------
    //  measuredMinHeight
    //----------------------------------

    /**
     *  @private
     *  Storage for the measuredMinHeight property.
     */
    private var _measuredMinHeight:Number = 0;

    [Inspectable(environment="none")]

    /**
     *  The default minimum height of the component, in pixels.
     *  This value is set by the <code>measure()</code> method.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get measuredMinHeight():Number
    {
        return _measuredMinHeight;
    }

    /**
     *  @private
     */
    public function set measuredMinHeight(value:Number):void
    {
        _measuredMinHeight = value;
    }

    //----------------------------------
    //  measuredWidth
    //----------------------------------

    /**
     *  @private
     *  Storage for the measuredWidth property.
     */
    protected var _measuredWidth:Number = Number.NaN;

    [Inspectable(environment="none")]

    /**
     *  The default width of the component, in pixels.
     *  This value is set by the <code>measure()</code> method.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get measuredWidth():Number
    {
		COMPILE::SWF {
			if (isNaN(_measuredWidth))
            {
                measure();
                if (isNaN(_measuredWidth))
                    return width;
            }
		}
		COMPILE::JS {
			if (isNaN(_measuredWidth) || _measuredWidth <= 0) 
            {
                var oldWidth:Object;
                var oldLeft:String;
                var oldRight:String;
                oldWidth = this.positioner.style.width;
                oldLeft = this.positioner.style.left;
                oldRight = this.positioner.style.right;
                if (oldWidth.length)
                    this.positioner.style.width = "";
                if (oldLeft.length && oldRight.length) // if both are set, this also dictates width
                    return 0; // this.positioner.style.left = "";
                var mw:Number = this.positioner.offsetWidth;
                if (mw == 0 && numChildren > 0)
                {
                    // if children are aboslute positioned, offsetWidth can be 0 in Safari
                    for (var i:int = 0; i < numChildren; i++)
                    {
                        var child:IUIComponent = getChildAt(i);
                        if (child) // child is null for TextNodes
                            mw = Math.max(mw, child.getExplicitOrMeasuredWidth());
                    }
                }
                if (oldWidth.length)
                    this.positioner.style.width = oldWidth;
                if (oldLeft.length && oldRight.length) // if both are set, this also dictates width
                    this.positioner.style.left = oldLeft;
                if (!isNaN(percentWidth))
                    _measuredMinWidth = mw;
                return mw;
			}
		}
        return _measuredWidth;
    }

    /**
     *  @private
     */
    public function set measuredWidth(value:Number):void
    {
        _measuredWidth = value;
    }

    //----------------------------------
    //  measuredHeight
    //----------------------------------

    /**
     *  @private
     *  Storage for the measuredHeight property.
     */
    protected var _measuredHeight:Number = Number.NaN;

    [Inspectable(environment="none")]

    /**
     *  The default height of the component, in pixels.
     *  This value is set by the <code>measure()</code> method.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get measuredHeight():Number
    {
		COMPILE::SWF {
			if (isNaN(_measuredHeight))
            {
                measure();
                if (isNaN(_measuredHeight))
                    return height;
            }
		}
		COMPILE::JS {
            if (isNaN(_measuredHeight) || _measuredHeight <= 0)
            {
                var oldHeight:Object;
                var oldTop:String;
                var oldBottom:String;
                oldTop = this.positioner.style.top;
                oldBottom = this.positioner.style.bottom;
                oldHeight = this.positioner.style.height;
                if (oldHeight.length)
                    this.positioner.style.height = "";
                if (oldTop.length && oldBottom.length) // if both are set, this also dictates height
                    return 0; //this.positioner.style.top = "";
                var mh:Number = this.positioner.offsetHeight;
                if (mh == 0 && numChildren > 0)
                {
                    for (var i:int = 0; i < numChildren; i++)
                    {
                        var child:IUIComponent = getChildAt(i);
                        if (child)
                            mh = Math.max(mh, child.getExplicitOrMeasuredHeight());
                    }
                }
                if (oldHeight.length)
                    this.positioner.style.height = oldHeight;
                if (oldTop.length && oldBottom.length) // if both are set, this also dictates width
                    this.positioner.style.top = oldTop;
                if (!isNaN(percentHeight))
                    _measuredMinHeight = mh;
                return mh;
            }
		}
        return _measuredHeight;
    }

    /**
     *  @private
     */
    public function set measuredHeight(value:Number):void
    {
        _measuredHeight = value;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties: Layout
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  percentWidth
    //----------------------------------

    [Bindable("resize")]
    [Inspectable(environment="none")]

    /**
     *  Specifies the width of a component as a percentage
     *  of its parent's size. Allowed values are 0-100. The default value is NaN.
     *  Setting the <code>width</code> or <code>explicitWidth</code> properties
     *  resets this property to NaN.
     *
     *  <p>This property returns a numeric value only if the property was
     *  previously set; it does not reflect the exact size of the component
     *  in percent.</p>
     *
     *  <p>This property is always set to NaN for the UITextField control.</p>
     * 
     *  <p>When used with Spark layouts, this property is used to calculate the
     *  width of the component's bounds after scaling and rotation. For example 
     *  if the component is rotated at 90 degrees, then specifying 
     *  <code>percentWidth</code> will affect the component's height.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function get percentWidth():Number
    {
        return super.percentWidth;
    }

    /**
     *  @private
     */
    override public function set percentWidth(value:Number):void
    {
        super.percentWidth = value;
        
         invalidateParentSizeAndDisplayList();
    }

    //----------------------------------
    //  percentHeight
    //----------------------------------

    [Bindable("resize")]
    [Inspectable(environment="none")]

    /**
     *  Specifies the height of a component as a percentage
     *  of its parent's size. Allowed values are 0-100. The default value is NaN.
     *  Setting the <code>height</code> or <code>explicitHeight</code> properties
     *  resets this property to NaN.
     *
     *  <p>This property returns a numeric value only if the property was
     *  previously set; it does not reflect the exact size of the component
     *  in percent.</p>
     *
     *  <p>This property is always set to NaN for the UITextField control.</p>
     *  
     *  <p>When used with Spark layouts, this property is used to calculate the
     *  height of the component's bounds after scaling and rotation. For example 
     *  if the component is rotated at 90 degrees, then specifying 
     *  <code>percentHeight</code> will affect the component's width.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function get percentHeight():Number
    {
        return super.percentHeight;
    }

    /**
     *  @private
     */
    override public function set percentHeight(value:Number):void
    {
        super.percentHeight = value;

        invalidateParentSizeAndDisplayList();
    }

    //----------------------------------
    //  minWidth
    //----------------------------------

    [Bindable("explicitMinWidthChanged")]
    [Inspectable(category="Size", defaultValue="0")]

    /**
     *  The minimum recommended width of the component to be considered
     *  by the parent during layout. This value is in the
     *  component's coordinates, in pixels. The default value depends on
     *  the component's implementation.
     *
     *  <p>If the application developer sets the value of minWidth,
     *  the new value is stored in explicitMinWidth. The default value of minWidth
     *  does not change. As a result, at layout time, if
     *  minWidth was explicitly set by the application developer, then the value of
     *  explicitMinWidth is used for the component's minimum recommended width.
     *  If minWidth is not set explicitly by the application developer, then the value of
     *  measuredMinWidth is used.</p>
     *
     *  <p>This value is used by the container in calculating
     *  the size and position of the component.
     *  It is not used by the component itself in determining
     *  its default size.
     *  Thus this property may not have any effect if parented by
     *  Container, or containers that don't factor in
     *  this property.
     *  Because the value is in component coordinates,
     *  the true <code>minWidth</code> with respect to its parent
     *  is affected by the <code>scaleX</code> property.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get minWidth():Number
    {
        if (!isNaN(explicitMinWidth))
            return explicitMinWidth;

        return measuredMinWidth;
    }

    /**
     *  @private
     */
    public function set minWidth(value:Number):void
    {
        if (explicitMinWidth == value)
            return;

        explicitMinWidth = value;
    }

    //----------------------------------
    //  minHeight
    //----------------------------------

    [Bindable("explicitMinHeightChanged")]
    [Inspectable(category="Size", defaultValue="0")]

    /**
     *  The minimum recommended height of the component to be considered
     *  by the parent during layout. This value is in the
     *  component's coordinates, in pixels. The default value depends on
     *  the component's implementation.
     *
     *  <p>If the application developer sets the value of minHeight,
     *  the new value is stored in explicitMinHeight. The default value of minHeight
     *  does not change. As a result, at layout time, if
     *  minHeight was explicitly set by the application developer, then the value of
     *  explicitMinHeight is used for the component's minimum recommended height.
     *  If minHeight is not set explicitly by the application developer, then the value of
     *  measuredMinHeight is used.</p>
     *
     *  <p>This value is used by the container in calculating
     *  the size and position of the component.
     *  It is not used by the component itself in determining
     *  its default size.
     *  Thus this property may not have any effect if parented by
     *  Container, or containers that don't factor in
     *  this property.
     *  Because the value is in component coordinates,
     *  the true <code>minHeight</code> with respect to its parent
     *  is affected by the <code>scaleY</code> property.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get minHeight():Number
    {
        if (!isNaN(explicitMinHeight))
            return explicitMinHeight;

        return measuredMinHeight;
    }

    /**
     *  @private
     */
    public function set minHeight(value:Number):void
    {
        if (explicitMinHeight == value)
            return;

        explicitMinHeight = value;
    }

    //----------------------------------
    //  maxWidth
    //----------------------------------

    [Bindable("explicitMaxWidthChanged")]
    [Inspectable(category="Size", defaultValue="10000")]

    /**
     *  The maximum recommended width of the component to be considered
     *  by the parent during layout. This value is in the
     *  component's coordinates, in pixels. The default value of this property is
     *  set by the component developer.
     *
     *  <p>The component developer uses this property to set an upper limit on the
     *  width of the component.</p>
     *
     *  <p>If the application developer overrides the default value of maxWidth,
     *  the new value is stored in explicitMaxWidth. The default value of maxWidth
     *  does not change. As a result, at layout time, if
     *  maxWidth was explicitly set by the application developer, then the value of
     *  explicitMaxWidth is used for the component's maximum recommended width.
     *  If maxWidth is not set explicitly by the user, then the default value is used.</p>
     *
     *  <p>This value is used by the container in calculating
     *  the size and position of the component.
     *  It is not used by the component itself in determining
     *  its default size.
     *  Thus this property may not have any effect if parented by
     *  Container, or containers that don't factor in
     *  this property.
     *  Because the value is in component coordinates,
     *  the true <code>maxWidth</code> with respect to its parent
     *  is affected by the <code>scaleX</code> property.
     *  Some components have no theoretical limit to their width.
     *  In those cases their <code>maxWidth</code> is set to
     *  <code>UIComponent.DEFAULT_MAX_WIDTH</code>.</p>
     *
     *  @default 10000
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get maxWidth():Number
    {
        return !isNaN(explicitMaxWidth) ?
               explicitMaxWidth :
               DEFAULT_MAX_WIDTH;
    }

    /**
     *  @private
     */
    public function set maxWidth(value:Number):void
    {
        if (explicitMaxWidth == value)
            return;

        explicitMaxWidth = value;
    }

    //----------------------------------
    //  maxHeight
    //----------------------------------

    [Bindable("explicitMaxHeightChanged")]
    [Inspectable(category="Size", defaultValue="10000")]

    /**
     *  The maximum recommended height of the component to be considered
     *  by the parent during layout. This value is in the
     *  component's coordinates, in pixels. The default value of this property is
     *  set by the component developer.
     *
     *  <p>The component developer uses this property to set an upper limit on the
     *  height of the component.</p>
     *
     *  <p>If the application developer overrides the default value of maxHeight,
     *  the new value is stored in explicitMaxHeight. The default value of maxHeight
     *  does not change. As a result, at layout time, if
     *  maxHeight was explicitly set by the application developer, then the value of
     *  explicitMaxHeight is used for the component's maximum recommended height.
     *  If maxHeight is not set explicitly by the user, then the default value is used.</p>
     *
     *  <p>This value is used by the container in calculating
     *  the size and position of the component.
     *  It is not used by the component itself in determining
     *  its default size.
     * 
     *  Thus this property may not have any effect if parented by
     *  Container, or containers that don't factor in
     *  this property.
     *  Because the value is in component coordinates,
     *  the true <code>maxHeight</code> with respect to its parent
     *  is affected by the <code>scaleY</code> property.
     *  Some components have no theoretical limit to their height.
     *  In those cases their <code>maxHeight</code> is set to
     *  <code>UIComponent.DEFAULT_MAX_HEIGHT</code>.</p>
     *
     *  @default 10000
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get maxHeight():Number
    {
        return !isNaN(explicitMaxHeight) ?
               explicitMaxHeight :
               DEFAULT_MAX_HEIGHT;
    }

    /**
     *  @private
     */
    public function set maxHeight(value:Number):void
    {
        if (explicitMaxHeight == value)
            return;

        explicitMaxHeight = value;
    }

    //----------------------------------
    //  explicitMinWidth
    //----------------------------------

    /**
     *  @private
     *  Storage for the minWidth property.
     */
    protected var _explicitMinWidth:Number;

    [Bindable("explicitMinWidthChanged")]
    [Inspectable(environment="none")]

    /**
     *  The minimum recommended width of the component to be considered
     *  by the parent during layout. This value is in the
     *  component's coordinates, in pixels.
     *
     *  <p>Application developers typically do not set the explicitMinWidth property. Instead, they
     *  set the value of the minWidth property, which sets the explicitMinWidth property. The
     *  value of minWidth does not change.</p>
     *
     *  <p>At layout time, if minWidth was explicitly set by the application developer, then
     *  the value of explicitMinWidth is used. Otherwise, the value of measuredMinWidth
     *  is used.</p>
     *
     *  <p>This value is used by the container in calculating
     *  the size and position of the component.
     *  It is not used by the component itself in determining
     *  its default size.
     *  Thus this property may not have any effect if parented by
     *  Container, or containers that don't factor in
     *  this property.
     *  Because the value is in component coordinates,
     *  the true <code>minWidth</code> with respect to its parent
     *  is affected by the <code>scaleX</code> property.</p>
     *
     *  @default NaN
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get explicitMinWidth():Number
    {
        return _explicitMinWidth;
    }

    /**
     *  @private
     */
    public function set explicitMinWidth(value:Number):void
    {
        if (_explicitMinWidth == value)
            return;

        _explicitMinWidth = value;

        // We invalidate size because locking in width
        // may change the measured height in flow-based components.
        invalidateSize();
        invalidateParentSizeAndDisplayList();

        dispatchEvent(new Event("explicitMinWidthChanged"));
    }

    //----------------------------------
    //  minHeight
    //----------------------------------

    /**
     *  @private
     *  Storage for the minHeight property.
     */
    private var _explicitMinHeight:Number;

    [Bindable("explictMinHeightChanged")]
    [Inspectable(environment="none")]

    /**
     *  The minimum recommended height of the component to be considered
     *  by the parent during layout. This value is in the
     *  component's coordinates, in pixels.
     *
     *  <p>Application developers typically do not set the explicitMinHeight property. Instead, they
     *  set the value of the minHeight property, which sets the explicitMinHeight property. The
     *  value of minHeight does not change.</p>
     *
     *  <p>At layout time, if minHeight was explicitly set by the application developer, then
     *  the value of explicitMinHeight is used. Otherwise, the value of measuredMinHeight
     *  is used.</p>
     *
     *  <p>This value is used by the container in calculating
     *  the size and position of the component.
     *  It is not used by the component itself in determining
     *  its default size.
     *  Thus this property may not have any effect if parented by
     *  Container, or containers that don't factor in
     *  this property.
     *  Because the value is in component coordinates,
     *  the true <code>minHeight</code> with respect to its parent
     *  is affected by the <code>scaleY</code> property.</p>
     *
     *  @default NaN
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get explicitMinHeight():Number
    {
        return _explicitMinHeight;
    }

    /**
     *  @private
     */
    public function set explicitMinHeight(value:Number):void
    {
        if (_explicitMinHeight == value)
            return;

        _explicitMinHeight = value;

        // We invalidate size because locking in height
        // may change the measured width in flow-based components.
        invalidateSize();
        invalidateParentSizeAndDisplayList();

        dispatchEvent(new Event("explicitMinHeightChanged"));
    }

    //----------------------------------
    //  explicitMaxWidth
    //----------------------------------

    /**
     *  @private
     *  Storage for the maxWidth property.
     */
    private var _explicitMaxWidth:Number;

    [Bindable("explicitMaxWidthChanged")]
    [Inspectable(environment="none")]

    /**
     *  The maximum recommended width of the component to be considered
     *  by the parent during layout. This value is in the
     *  component's coordinates, in pixels.
     *
     *  <p>Application developers typically do not set the explicitMaxWidth property. Instead, they
     *  set the value of the maxWidth property, which sets the explicitMaxWidth property. The
     *  value of maxWidth does not change.</p>
     *
     *  <p>At layout time, if maxWidth was explicitly set by the application developer, then
     *  the value of explicitMaxWidth is used. Otherwise, the default value for maxWidth
     *  is used.</p>
     *
     *  <p>This value is used by the container in calculating
     *  the size and position of the component.
     *  It is not used by the component itself in determining
     *  its default size.
     *  Thus this property may not have any effect if parented by
     *  Container, or containers that don't factor in
     *  this property.
     *  Because the value is in component coordinates,
     *  the true <code>maxWidth</code> with respect to its parent
     *  is affected by the <code>scaleX</code> property.
     *  Some components have no theoretical limit to their width.
     *  In those cases their <code>maxWidth</code> is set to
     *  <code>UIComponent.DEFAULT_MAX_WIDTH</code>.</p>
     *
     *  @default NaN
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get explicitMaxWidth():Number
    {
        return _explicitMaxWidth;
    }

    /**
     *  @private
     */
    public function set explicitMaxWidth(value:Number):void
    {
        if (_explicitMaxWidth == value)
            return;

        _explicitMaxWidth = value;

        // Se invalidate size because locking in width
        // may change the measured height in flow-based components.
        invalidateSize();
        invalidateParentSizeAndDisplayList();

        dispatchEvent(new Event("explicitMaxWidthChanged"));
    }

    //----------------------------------
    //  explicitMaxHeight
    //----------------------------------

    /**
     *  @private
     *  Storage for the maxHeight property.
     */
    private var _explicitMaxHeight:Number;

    [Bindable("explicitMaxHeightChanged")]
    [Inspectable(environment="none")]

    /**
     *  The maximum recommended height of the component to be considered
     *  by the parent during layout. This value is in the
     *  component's coordinates, in pixels.
     *
     *  <p>Application developers typically do not set the explicitMaxHeight property. Instead, they
     *  set the value of the maxHeight property, which sets the explicitMaxHeight property. The
     *  value of maxHeight does not change.</p>
     *
     *  <p>At layout time, if maxHeight was explicitly set by the application developer, then
     *  the value of explicitMaxHeight is used. Otherwise, the default value for maxHeight
     *  is used.</p>
     *
     *  <p>This value is used by the container in calculating
     *  the size and position of the component.
     *  It is not used by the component itself in determining
     *  its default size.
     *  Thus this property may not have any effect if parented by
     *  Container, or containers that don't factor in
     *  this property.
     *  Because the value is in component coordinates,
     *  the true <code>maxHeight</code> with respect to its parent
     *  is affected by the <code>scaleY</code> property.
     *  Some components have no theoretical limit to their height.
     *  In those cases their <code>maxHeight</code> is set to
     *  <code>UIComponent.DEFAULT_MAX_HEIGHT</code>.</p>
     *
     *  @default NaN
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get explicitMaxHeight():Number
    {
        return _explicitMaxHeight;
    }

    /**
     *  @private
     */
    public function set explicitMaxHeight(value:Number):void
    {
        if (_explicitMaxHeight == value)
            return;

        _explicitMaxHeight = value;

        // Se invalidate size because locking in height
        // may change the measured width in flow-based components.
        invalidateSize();
        invalidateParentSizeAndDisplayList();

        dispatchEvent(new Event("explicitMaxHeightChanged"));
    }
	
    COMPILE::JS
    private var _scaleX:Number = 1.0;
    
	COMPILE::JS
	public function get scaleX():Number
	{
		return _scaleX;
	}
	
	COMPILE::JS
	public function set scaleX(value:Number):void
	{
        _scaleX = value;
        element.style.transform = computeTransformString();
	}
	
    COMPILE::JS
    private var _scaleY:Number = 1.0;
    
	COMPILE::JS
	public function get scaleY():Number
	{
		return _scaleY;
	}
	
	COMPILE::JS
	public function set scaleY(value:Number):void
	{
        _scaleY = value;
        element.style.transform = computeTransformString();
	}

    //----------------------------------
    //  alpha
    //----------------------------------

    /**
     *  @private
     *  Storage for the alpha property.
     */
    private var _alpha:Number = 1.0;
    
    [Bindable("alphaChanged")]
    [Inspectable(defaultValue="1.0", category="General", verbose="1", minValue="0.0", maxValue="1.0")]

    /**
     *  @private
     */
    override public function get alpha():Number
    {
        // Here we roundtrip alpha in the same manner as the 
        // player (purposely introducing a rounding error).
        return int(_alpha * 256.0) / 256.0;
    }
    
    /**
     *  @private
     */
    override public function set alpha(value:Number):void
    { 
        if (_alpha != value)
        {
            _alpha = value;
            
            super.alpha = value;
        
           /*  if (designLayer)
                value = value * designLayer.effectiveAlpha; 
            
            $alpha = value;
			*/
            dispatchEvent(new Event("alphaChanged"));
        }
    }
    //----------------------------------
    //  includeInLayout
    //----------------------------------

    /**
     *  @private
     *  Storage for the includeInLayout property.
     */
    private var _includeInLayout:Boolean = true;

    [Bindable("includeInLayoutChanged")]
    [Inspectable(category="General", defaultValue="true")]

    /**
     *  Specifies whether this component is included in the layout of the
     *  parent container.
     *  If <code>true</code>, the object is included in its parent container's
     *  layout and is sized and positioned by its parent container as per its layout rules.
     *  If <code>false</code>, the object size and position are not affected by its parent container's
     *  layout.
     * 
     *  @default true
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get includeInLayout():Boolean
    {
        return _includeInLayout;
    }

    /**
     *  @private
     */
    public function set includeInLayout(value:Boolean):void
    {
        if (_includeInLayout != value)
        {
            _includeInLayout = value;

            var p:IInvalidating = parent as IInvalidating;
            if (p)
            {
                p.invalidateSize();
                p.invalidateDisplayList();
            }

            dispatchEvent(new Event("includeInLayoutChanged"));
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties: States
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  currentState
    //----------------------------------

    /**
     *  @private
     *  Storage for the currentState property.
     */
    private var _currentState:String;

    /**
     *  @private
     *  Pending current state name.
     */
    private var requestedCurrentState:String;

    /**
     *  @private
     *  Flag to play state transition
     */
    private var playStateTransition:Boolean = true;

    /**
     *  @private
     *  Flag that is set when the currentState has changed and needs to be
     *  committed.
     *  This property name needs the initial underscore to avoid collisions
     *  with the "currentStateChange" event attribute.
     */
    private var _currentStateChanged:Boolean;

    [Bindable("currentStateChange")]

    /**
     *  The current view state of the component.
     *  Set to <code>""</code> or <code>null</code> to reset
     *  the component back to its base state.
     *
     *  <p>When you use this property to set a component's state,
     *  Flex applies any transition you have defined.
     *  You can also use the <code>setCurrentState()</code> method to set the
     *  current state; this method can optionally change states without
     *  applying a transition.</p>
     *
     *  @see #setCurrentState()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get currentState():String
    {
        return _currentStateChanged ? requestedCurrentState : _currentState;
    }

    /**
     *  @private
     */
    public function set currentState(value:String):void
    {
    	if (value == _currentState) return;
        var event:ValueChangeEvent = new ValueChangeEvent("currentStateChange", false, false, _currentState, value)
        _currentState = value;
        addEventListener("stateChangeComplete", stateChangeCompleteHandler);
        dispatchEvent(event);
    }
    
    public function setCurrentState(stateName:String, playTransition:Boolean=true):void
    {
        currentState = stateName;
    }
    
    private function stateChangeCompleteHandler(event:Event):void
    {
        callLater(dispatchUpdateComplete); 
    }
    
    protected function dispatchUpdateComplete():void
    {
        dispatchEvent(new Event("updateComplete"));
    }
    //----------------------------------
    //  states
    //----------------------------------

    private var _states:Array /* of State */ = [];

    [Inspectable(arrayType="mx.states.State")]
    [ArrayElementType("mx.states.State")]

    /**
     *  The view states that are defined for this component.
     *  You can specify the <code>states</code> property only on the root
     *  of the application or on the root tag of an MXML component.
     *  The compiler generates an error if you specify it on any other control.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get states():Array
    {
        return _states;
    }

    /**
     *  @private
     */
    public function set states(value:Array):void
    {
        _states = value;
        _currentState = _states[0].name;
        
        try {
            loadBeadFromValuesManager(IStatesImpl, "iStatesImpl", this);
        }
        //TODO:  Need to handle this case more gracefully
        catch(e:Error)
        {
            COMPILE::SWF
            {
                trace(e.message);                        
            }
        }
    }

    //----------------------------------
    //  transitions
    //----------------------------------

    private var _transitions:Array /* of Transition */ = [];

    [Inspectable(arrayType="mx.states.Transition")]
    [ArrayElementType("mx.states.Transition")]

    /**
     *  An Array of Transition objects, where each Transition object defines a
     *  set of effects to play when a view state change occurs.
     *
     *  @see mx.states.Transition
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get transitions():Array
    {
        return _transitions;
    }

    /**
     *  @private
     */
    public function set transitions(value:Array):void
    {
        _transitions = value;
    }
	
	
	
    //--------------------------------------------------------------------------
    //
    //  Properties: Other
    //
    //--------------------------------------------------------------------------


    //----------------------------------
    //  styleName
    //----------------------------------


    //
    COMPILE::JS
    override protected function computeFinalClassNames():String
    {
        var computed:String = super.computeFinalClassNames();
        if (typeof _styleName == 'string') computed += ' ' + _styleName;
        return  computed;
    }

    /**
     *  @private
     *  Storage for the styleName property.
     */
    private var _styleName:Object /* String, CSSStyleDeclaration, or UIComponent */;
    private var _classSelectorList:ClassSelectorList; //implementation support for styleName string values

    [Inspectable(category="General")]

    /**
     *  The class style used by this component. This can be a String, CSSStyleDeclaration
     *  or an IStyleClient.
     *
     *  <p>If this is a String, it is the name of one or more whitespace delimited class
     *  declarations in an <code>&lt;fx:Style&gt;</code> tag or CSS file. You do not include the period
     *  in the <code>styleName</code>. For example, if you have a class style named <code>".bigText"</code>,
     *  set the <code>styleName</code> property to <code>"bigText"</code> (no period).</p>
     *
     *  <p>If this is an IStyleClient (typically a UIComponent), all styles in the
     *  <code>styleName</code> object are used by this component.</p>
     *
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get styleName():Object /* String, CSSStyleDeclaration, or UIComponent */
    {
        return _styleName;
    }

    /**
     *  @private
     */
    public function set styleName(value:Object /* String, CSSStyleDeclaration, or UIComponent */):void
    {
        if (_styleName === value)
            return;
        if (typeof value == 'string' || !value) {
            COMPILE::JS{
                if (_styleName) element.classList.remove(_styleName);
                _styleName = value;
                if (value) element.classList.add(value)
            }
            COMPILE::SWF{
                trace("styleName not yet implemented for string assignments");
            }
        } else {
            // TODO
            trace("styleName not implemented for non-string assignments");
        }

    }

    //----------------------------------
    //  toolTip
    //----------------------------------

    /**
     *  @private
     *  Storage for the toolTip property.
     */
    private var _toolTip:String;
	
	private var _toolTipBead: ToolTipBead;
	private var _disableBead: DisableBead;

    [Bindable("toolTipChanged")]
    [Inspectable(category="General", defaultValue="null")]

    /**
     *  Text to display in the ToolTip.
     *
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get toolTip():String
    {
        return _toolTip;
    }

    /**
     *  @private
     */
    public function set toolTip(value:String):void
    {
        var oldValue:String = _toolTip;
        _toolTip = value;

        if (_toolTip != null && _toolTip != "" && _toolTipBead == null) {
			_toolTipBead = new ToolTipBead();
			addBead(_toolTipBead);
		}
		else if ((_toolTip == null || _toolTip == "") && _toolTipBead != null) {
		}
		
		if (_toolTipBead) {
			_toolTipBead.toolTip = _toolTip;
		}

        dispatchEvent(new Event("toolTipChanged"));
    }

    //--------------------------------------------------------------------------
    //
    //  Properties: Popups
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  isPopUp
    //----------------------------------

    /**
     *  @private
     */
    private var _isPopUp:Boolean;

    [Inspectable(environment="none")]

    /**
     *  Set to <code>true</code> by the PopUpManager to indicate
     *  that component has been popped up.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get isPopUp():Boolean
    {
        return _isPopUp;
    }
    public function set isPopUp(value:Boolean):void
    {
        _isPopUp = value;
    }


    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  @royaleignorecoercion mx.core.IUIComponent
     */
    [SWFOverride(params="flash.display.DisplayObject", altparams="mx.core.UIComponent", returns="flash.display.DisplayObject"))]
    COMPILE::SWF 
    { override }
    public function addChild(child:IUIComponent):IUIComponent
    {
        return addElement(child) as IUIComponent;
    }
    
    
    public function $uibase_addChild(child:IUIComponent):IUIComponent
    {
        // this should avoid calls to addingChild/childAdded
        var ret:IUIComponent = super.addElement(child) as IUIComponent;
        return ret;
    }

    /**
     *  @private
     *  @royaleignorecoercion mx.core.IUIComponent
     */
    [SWFOverride(params="flash.display.DisplayObject,int", altparams="mx.core.UIComponent,int", returns="flash.display.DisplayObject"))]
    COMPILE::SWF 
    { override }
    public function addChildAt(child:IUIComponent,
                                        index:int):IUIComponent
    {
        return addElementAt(child, index) as IUIComponent;
    }
    
    public function $uibase_addChildAt(child:IUIComponent,
                               index:int):IUIComponent
    {
        var ret:IUIComponent;
        // this should avoid calls to addingChild/childAdded
        if (index >= super.numElements)
            ret = super.addElement(child) as IUIComponent;
        else
            ret = super.addElementAt(child, index) as IUIComponent;
        return ret;
    }

    /**
     *  @private
     *  @royaleignorecoercion mx.core.IUIComponent
     */
    [SWFOverride(params="flash.display.DisplayObject", altparams="mx.core.UIComponent", returns="flash.display.DisplayObject"))]
    COMPILE::SWF 
    { override }
    public function removeChild(child:IUIComponent):IUIComponent
    {
        return removeElement(child) as IUIComponent;
    }
    
    public function $uibase_removeChild(child:IUIComponent):IUIComponent
    {
        // this should probably call the removingChild/childRemoved
        var ret:IUIComponent = super.removeElement(child) as IUIComponent;
        return ret;
    }
    
    COMPILE::JS
	public function swapChildren(child1:IUIComponent, child2:IUIComponent):void
	{
	
	}
    /**
     *  @private
     *  @royaleignorecoercion mx.core.IUIComponent
     */
    [SWFOverride(returns="flash.display.DisplayObject"))]
    COMPILE::SWF 
    { override }
    public function removeChildAt(index:int):IUIComponent
    {
        // this should probably call the removingChild/childRemoved
        return removeElement(getElementAt(index)) as IUIComponent;
    }
    
    public function $uibase_removeChildAt(index:int):IUIComponent
    {
        var ret:IUIComponent = super.removeElement(getElementAt(index)) as IUIComponent;
        return ret;
    }

    /**
     *  @private
     *  @royaleignorecoercion mx.core.IUIComponent
     */
    [SWFOverride(returns="flash.display.DisplayObject"))]
    COMPILE::SWF 
    { override }
    public function getChildAt(index:int):IUIComponent
    {
        return getElementAt(index) as IUIComponent;
    }
    
    /**
     *  @private
     */
    COMPILE::SWF 
    { override }
    public function get numChildren():int
    {
        return numElements;
    }

    /**
     *  @copy org.apache.royale.core.IParent#numElements
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     *  @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
     */
    override public function get numElements():int
    {
        COMPILE::SWF
        {
            return super.numElements;
        }
        COMPILE::JS
        {
            var arr:Array = internalChildren();
			var n:int = arr.length;
			var num:int = 0;
			for (var i:int = 0; i < n; i++)
			{
				if ((arr[i] as WrappedHTMLElement).royale_wrapper)
					num++;
			}
			return num;
        }
    }

    
    /**
     *  @private
     */
    [SWFOverride(params="flash.display.DisplayObject,int", altparams="mx.core.UIComponent,int"))]
    COMPILE::SWF 
    { override }
    public function setChildIndex(child:IUIComponent, index:int):void
    {
        trace("setChildIndex not implemented");
    }

    /**
     *  @private
     */
    [SWFOverride(params="flash.display.DisplayObject", altparams="mx.core.UIComponent"))]
    COMPILE::SWF 
    { override }
    public function getChildIndex(child:IUIComponent):int
    {
        return getElementIndex(child);
    }

    /**
     *  @private
     */
    [SWFOverride(returns="flash.display.DisplayObject"))]
    COMPILE::SWF 
    { override }
    public function getChildByName(name:String):IUIComponent
    {
        trace("getChildByName not implemented");
        return null;
    }

    /**
     *  @private
     */
    [SWFOverride(params="flash.display.DisplayObject", altparams="mx.core.UIComponent"))]
    COMPILE::SWF 
    { override }
    public function contains(child:IUIBase):Boolean
    {
        COMPILE::SWF
        {
            return super.contains(child as DisplayObject);
        }
        COMPILE::JS
        {
            return element.contains(child.element);
        }
    }
    
    /**
     *  @private
     */
    [SWFOverride(params="Boolean,flash.geom.Rectangle",altparams="Boolean,org.apache.royale.geom.Rectangle")]
    COMPILE::SWF 
    { override }
    public function startDrag(lockCenter:Boolean = false, bounds:Rectangle = null):void
    {
        trace("startDrag not implemented");
    }

    /**
     *  @private
     */
    COMPILE::SWF
    {
        override 
    }
    public function stopDrag():void
    {
        trace("stopDrag not implemented");
    }
    
    /**
     *  Initializes the internal structure of this component.
     *
     *  <p>Initializing a UIComponent is the fourth step in the creation
     *  of a visual component instance, and happens automatically
     *  the first time that the instance is added to a parent.
     *  Therefore, you do not generally need to call
     *  <code>initialize()</code>; the Flex framework calls it for you
     *  from UIComponent's override of the <code>addChild()</code>
     *  and <code>addChildAt()</code> methods.</p>
     *
     *  <p>The first step in the creation of a visual component instance
     *  is construction, with the <code>new</code> operator:</p>
     *
     *  <pre>
     *  var okButton:Button = new Button();</pre>
     *
     *  <p>After construction, the new Button instance is a solitary
     *  DisplayObject; it does not yet have a UITextField as a child
     *  to display its label, and it doesn't have a parent.</p>
     *
     *  <p>The second step is configuring the newly-constructed instance
     *  with the appropriate properties, styles, and event handlers:</p>
     *
     *  <pre>
     *  okButton.label = "OK";
     *  okButton.setStyle("cornerRadius", 0);
     *  okButton.addEventListener(MouseEvent.CLICK, clickHandler);</pre>
     *
     *  <p>The third step is adding the instance to a parent:</p>
     *
     *  <pre>
     *  someContainer.addChild(okButton);</pre>
     *
     *  <p>A side effect of calling <code>addChild()</code>
     *  or <code>addChildAt()</code>, when adding a component to a parent
     *  for the first time, is that <code>initialize</code> gets
     *  automatically called.</p>
     *
     *  <p>This method first dispatches a <code>preinitialize</code> event,
     *  giving developers using this component a chance to affect it
     *  before its internal structure has been created.
     *  Next it calls the <code>createChildren()</code> method
     *  to create the component's internal structure; for a Button,
     *  this method creates and adds the UITextField for the label.
     *  Then it dispatches an <code>initialize</code> event,
     *  giving developers a chance to affect the component
     *  after its internal structure has been created.</p>
     *
     *  <p>Note that it is the act of attaching a component to a parent
     *  for the first time that triggers the creation of its internal structure.
     *  If its internal structure includes other UIComponents, then this is a
     *  recursive process in which the tree of DisplayObjects grows by one leaf
     *  node at a time.</p>
     *
     *  <p>If you are writing a component, you do not need
     *  to override this method.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function initialize():void
    {
        if (initialized)
            return;
        
        // The "preinitialize" event gets dispatched after everything about this
        // DisplayObject has been initialized, and it has been attached to
        // its parent, but before any of its children have been created.
        // This allows a "preinitialize" event handler to set properties which
        // affect child creation.
        // Note that this implies that "preinitialize" handlers are called
        // top-down; i.e., parents before children.
        dispatchEvent(new FlexEvent(FlexEvent.PREINITIALIZE));
            
        createChildren();
		_measuredWidth = NaN;
		_measuredHeight = NaN;
		                
        // This should always be the last thing that initialize() calls.
        initializationComplete();
    }

    /**
     *  Finalizes the initialization of this component.
     *
     *  <p>This method is the last code that executes when you add a component
     *  to a parent for the first time using <code>addChild()</code>
     *  or <code>addChildAt()</code>.
     *  It handles some housekeeping related to dispatching
     *  the <code>initialize</code> event.
     *  If you are writing a component, you do not need
     *  to override this method.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function initializationComplete():void
    {
        dispatchEvent(new FlexEvent(FlexEvent.INITIALIZE));
    }
    
    /**
     *  Create child objects of the component.
     *  This is an advanced method that you might override
     *  when creating a subclass of UIComponent.
     *
     *  <p>A component that creates other components or objects within it is called a composite component.
     *  For example, the Flex ComboBox control is actually made up of a TextInput control
     *  to define the text area of the ComboBox, and a Button control to define the ComboBox arrow.
     *  Components implement the <code>createChildren()</code> method to create child
     *  objects (such as other components) within the component.</p>
     *
     *  <p>From within an override of the <code>createChildren()</code> method,
     *  you call the <code>addChild()</code> method to add each child object. </p>
     *
     *  <p>You do not call this method directly. Flex calls the
     *  <code>createChildren()</code> method in response to the call to
     *  the <code>addChild()</code> method to add the component to its parent. </p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function createChildren():void
    {
        MXMLDataInterpreter.generateMXMLInstances(mxmlDocument, this, MXMLDescriptor);
    }
    
    private var _mxmlDescriptor:Array;
    
    /**
     *  @copy org.apache.royale.core.Application#MXMLDescriptor
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     */
    public function get MXMLDescriptor():Array
    {
        return _mxmlDescriptor;
    }
    
    /**
     *  @private
     */
    public function setMXMLDescriptor(document:Object, value:Array):void
    {
        _mxmlDocument = document;
        _mxmlDescriptor = value;
    }
    
    /**
     *  @copy org.apache.royale.core.Application#generateMXMLAttributes()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     */
    public function generateMXMLAttributes(data:Array):void
    {
        if (!_mxmlDocument)
            _mxmlDocument = this;
        MXMLDataInterpreter.generateMXMLProperties(this, data);
    }
    
    /**
     *  @copy org.apache.royale.core.ItemRendererClassFactory#mxmlContent
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     * 
     *  @royalesuppresspublicvarwarning
     */
    public var mxmlContent:Array;

    //--------------------------------------------------------------------------
    //
    //  Methods: Invalidation
    //
    //--------------------------------------------------------------------------

    /**
     *  Marks a component so that its <code>commitProperties()</code>
     *  method gets called during a later screen update.
     *
     *  <p>Invalidation is a useful mechanism for eliminating duplicate
     *  work by delaying processing of changes to a component until a
     *  later screen update.
     *  For example, if you want to change the text color and size,
     *  it would be wasteful to update the color immediately after you
     *  change it and then update the size when it gets set.
     *  It is more efficient to change both properties and then render
     *  the text with its new size and color once.</p>
     *
     *  <p>Invalidation methods rarely get called.
     *  In general, setting a property on a component automatically
     *  calls the appropriate invalidation method.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function invalidateProperties():void
    {
        trace("invalidateProperties not implemented");
    }

    /**
     *  Marks a component so that its <code>measure()</code>
     *  method gets called during a later screen update.
     *
     *  <p>Invalidation is a useful mechanism for eliminating duplicate
     *  work by delaying processing of changes to a component until a
     *  later screen update.
     *  For example, if you want to change the text and font size,
     *  it would be wasteful to update the text immediately after you
     *  change it and then update the size when it gets set.
     *  It is more efficient to change both properties and then render
     *  the text with its new size once.</p>
     *
     *  <p>Invalidation methods rarely get called.
     *  In general, setting a property on a component automatically
     *  calls the appropriate invalidation method.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     * 
     *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
     */
    public function invalidateSize():void
    {
		_measuredWidth = NaN;
		_measuredHeight = NaN;
        if (parent)
            (parent as IEventDispatcher).dispatchEvent(new Event("layoutNeeded")); // might cause too many layouts
    }

    /**
     *  Helper method to invalidate parent size and display list if
     *  this object affects its layout (includeInLayout is true).
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function invalidateParentSizeAndDisplayList():void
    {
        trace("invalidateParentSizeAndDisplayList not implemented");
    }

    protected var invalidateDisplayListFlag:Boolean = false;
    
    /**
     *  Marks a component so that its <code>updateDisplayList()</code>
     *  method gets called during a later screen update.
     *
     *  <p>Invalidation is a useful mechanism for eliminating duplicate
     *  work by delaying processing of changes to a component until a
     *  later screen update.
     *  For example, if you want to change the width and height,
     *  it would be wasteful to update the component immediately after you
     *  change the width and then update again with the new height.
     *  It is more efficient to change both properties and then render
     *  the component with its new size once.</p>
     *
     *  <p>Invalidation methods rarely get called.
     *  In general, setting a property on a component automatically
     *  calls the appropriate invalidation method.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function invalidateDisplayList():void
    {
        trace("invalidateDisplayList not implemented");
        invalidateDisplayListFlag = true;
    }

    /**
     *  localToGlobal
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    [SWFOverride(params="flash.geom.Point", altparams="org.apache.royale.geom.Point", returns="flash.geom.Point"))]
    COMPILE::SWF 
    { override }
    public function localToGlobal(value:Point):Point
    {
        COMPILE::SWF
        {
            var o:Object = super.localToGlobal(value);
            return new org.apache.royale.geom.Point(o.x, o.y);
        }
        return PointUtils.localToGlobal(value, this);
    }
    
    /**
     *  globalToLocal
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    [SWFOverride(params="flash.geom.Point", altparams="org.apache.royale.geom.Point", returns="flash.geom.Point"))]
    COMPILE::SWF 
    { override }
    public function globalToLocal(value:Point):Point
    {
        COMPILE::SWF
        {
            var o:Object = super.globalToLocal(value);
            return new org.apache.royale.geom.Point(o.x, o.y);
        }
        return PointUtils.globalToLocal(value, this);
    }
    
    /**
     *  mouseX
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    COMPILE::JS
    public function get mouseX():Number
    {
        trace("mouseX not implemented");
        return 0;
    }
    
    /**
     *  mouseY
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    COMPILE::JS
    public function get mouseY():Number
    {
        trace("mouseX not implemented");
        return 0;
    }
    
    
    
    //--------------------------------------------------------------------------
    //  Method: getFocus
    //--------------------------------------------------------------------------
    
     public function getFocus():UIComponent
     {
	  return null;
     }
     
     
    /**
     *  Detects changes to style properties. When any style property is set,
     *  Flex calls the <code>styleChanged()</code> method,
     *  passing to it the name of the style being set.
     *
     *  <p>This is an advanced method that you might override
     *  when creating a subclass of UIComponent. When you create a custom component,
     *  you can override the <code>styleChanged()</code> method
     *  to check the style name passed to it, and handle the change accordingly.
     *  This lets you override the default behavior of an existing style,
     *  or add your own custom style properties.</p>
     *
     *  <p>If you handle the style property, your override of
     *  the <code>styleChanged()</code> method should call the
     *  <code>invalidateDisplayList()</code> method to cause Flex to execute
     *  the component's <code>updateDisplayList()</code> method at the next screen update.</p>
     *
     *  @param styleProp The name of the style property, or null if all styles for this
     *  component have changed.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function styleChanged(styleProp:String):void
    {
        trace("styleChanged not implemented");
    }

    /**
     *  Validate and update the properties and layout of this object
     *  and redraw it, if necessary.
     *
     *  Processing properties that require substantial computation are normally
     *  not processed until the script finishes executing.
     *  For example setting the <code>width</code> property is delayed, because it can
     *  require recalculating the widths of the objects children or its parent.
     *  Delaying the processing prevents it from being repeated
     *  multiple times if the script sets the <code>width</code> property more than once.
     *  This method lets you manually override this behavior.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function validateNow():void
    {
    }

    private var callLaterBead:CallLaterBead;

    /**
     *  Queues a function to be called later.
     *
     *  <p>Before each update of the screen, Flash Player or AIR calls
     *  the set of functions that are scheduled for the update.
     *  Sometimes, a function should be called in the next update
     *  to allow the rest of the code scheduled for the current
     *  update to be executed.
     *  Some features, like effects, can cause queued functions to be
     *  delayed until the feature completes.</p>
     *
     *  @param method Reference to a method to be executed later.
     *
     *  @param args Array of Objects that represent the arguments to pass to the method.
     *
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function callLater(method:Function,
                              args:Array /* of Object */ = null):void
    {
        if (!callLaterBead)
        {
            callLaterBead = new CallLaterBead();
            addBead(callLaterBead);
        }
        callLaterBead.callLater(method, args, this);
    }


    //--------------------------------------------------------------------------
    //
    //  Methods: Commitment
    //
    //--------------------------------------------------------------------------

    /**
     *  Used by layout logic to validate the properties of a component
     *  by calling the <code>commitProperties()</code> method.
     *  In general, subclassers should
     *  override the <code>commitProperties()</code> method and not this method.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function validateProperties():void
    {
        trace("validateProperties not implemented");
    }

    /**
     *  Processes the properties set on the component.
     *  This is an advanced method that you might override
     *  when creating a subclass of UIComponent.
     *
     *  <p>You do not call this method directly.
     *  Flex calls the <code>commitProperties()</code> method when you
     *  use the <code>addChild()</code> method to add a component to a container,
     *  or when you call the <code>invalidateProperties()</code> method of the component.
     *  Calls to the <code>commitProperties()</code> method occur before calls to the
     *  <code>measure()</code> method. This lets you set property values that might
     *  be used by the <code>measure()</code> method.</p>
     *
     *  <p>Some components have properties that affect the number or kinds
     *  of child objects that they need to create, or have properties that
     *  interact with each other, such as the <code>horizontalScrollPolicy</code>
     *  and <code>horizontalScrollPosition</code> properties.
     *  It is often best at startup time to process all of these
     *  properties at one time to avoid duplicating work.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function commitProperties():void
    {
        trace("commitProperties not implemented");
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Measurement
    //
    //--------------------------------------------------------------------------

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function validateSize(recursive:Boolean = false):void
    {
        trace("validateSize not implemented");
    }

    /**
     *  Calculates the default size, and optionally the default minimum size,
     *  of the component. This is an advanced method that you might override when
     *  creating a subclass of UIComponent.
     *
     *  <p>You do not call this method directly. Flex calls the
     *  <code>measure()</code> method when the component is added to a container
     *  using the <code>addChild()</code> method, and when the component's
     *  <code>invalidateSize()</code> method is called. </p>
     *
     *  <p>When you set a specific height and width of a component,
     *  Flex does not call the <code>measure()</code> method,
     *  even if you explicitly call the <code>invalidateSize()</code> method.
     *  That is, Flex only calls the <code>measure()</code> method if
     *  the <code>explicitWidth</code> property or the <code>explicitHeight</code>
     *  property of the component is NaN. </p>
     *
     *  <p>In your override of this method, you must set the
     *  <code>measuredWidth</code> and <code>measuredHeight</code> properties
     *  to define the default size.
     *  You can optionally set the <code>measuredMinWidth</code> and
     *  <code>measuredMinHeight</code> properties to define the default
     *  minimum size.</p>
     *
     *  <p>Most components calculate these values based on the content they are
     *  displaying, and from the properties that affect content display.
     *  A few components simply have hard-coded default values. </p>
     *
     *  <p>The conceptual point of <code>measure()</code> is for the component to provide
     *  its own natural or intrinsic size as a default. Therefore, the
     *  <code>measuredWidth</code> and <code>measuredHeight</code> properties
     *  should be determined by factors such as:</p>
     *  <ul>
     *     <li>The amount of text the component needs to display.</li>
     *     <li>The styles, such as <code>fontSize</code>, for that text.</li>
     *     <li>The size of a JPEG image that the component displays.</li>
     *     <li>The measured or explicit sizes of the component's children.</li>
     *     <li>Any borders, margins, and gaps.</li>
     *  </ul>
     *
     *  <p>In some cases, there is no intrinsic way to determine default values.
     *  For example, a simple GreenCircle component might simply set
     *  measuredWidth = 100 and measuredHeight = 100 in its <code>measure()</code> method to
     *  provide a reasonable default size. In other cases, such as a TextArea,
     *  an appropriate computation (such as finding the right width and height
     *  that would just display all the text and have the aspect ratio of a Golden Rectangle)
     *  might be too time-consuming to be worthwhile.</p>
     *
     *  <p>The default implementation of <code>measure()</code>
     *  sets <code>measuredWidth</code>, <code>measuredHeight</code>,
     *  <code>measuredMinWidth</code>, and <code>measuredMinHeight</code>
     *  to <code>0</code>.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function measure():void
    {
        measuredMinWidth = 0;
        measuredMinHeight = 0;
        COMPILE::JS
        {
            measuredWidth = 0;
            measuredHeight = 0;
        }
        COMPILE::SWF
        {
            measuredWidth = $width;
            measuredHeight = $height;            
        }
    }


    /**
     *  A convenience method for determining whether to use the
     *  explicit or measured width
     *
     *  @return A Number which is explicitWidth if defined
     *  or measuredWidth if not.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getExplicitOrMeasuredWidth():Number
    {
        return !isNaN(explicitWidth) ? explicitWidth : measuredWidth;
    }

    /**
     *  A convenience method for determining whether to use the
     *  explicit or measured height
     *
     *  @return A Number which is explicitHeight if defined
     *  or measuredHeight if not.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getExplicitOrMeasuredHeight():Number
    {
        return !isNaN(explicitHeight) ? explicitHeight : measuredHeight;
    }

    /**
     *  A convenience method for determining the unscaled width
     *  of the component
     *  All of a component's drawing and child layout should be done
     *  within a bounding rectangle of this width, which is also passed
     *  as an argument to <code>updateDisplayList()</code>.
     *
     *  @return A Number which is unscaled width of the component.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function get unscaledWidth():Number
    {
        return width;
    }


    /**
     *  A convenience method for determining the unscaled height
     *  of the component.
     *  All of a component's drawing and child layout should be done
     *  within a bounding rectangle of this height, which is also passed
     *  as an argument to <code>updateDisplayList()</code>.
     *
     *  @return A Number which is unscaled height of the component.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function get unscaledHeight():Number
    {
        return height;
    }


    /**
     *  Measures the specified text, assuming that it is displayed
     *  in a single-line UITextField (or UIFTETextField) using a UITextFormat
     *  determined by the styles of this UIComponent.  Does not 
     *  work for Spark components since they don't use UITextField
     *  (or UIFTETextField).  To measure text in Spark components, 
     *  get the measurements of a spark.components.Label 
     *  or spark.components.RichText
     *
     *  @param text A String specifying the text to measure.
     *
     *  @return A TextLineMetrics object containing the text measurements.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function measureText(text:String):TextLineMetrics
    {
        var uitf:UITextFormat = new UITextFormat(systemManager);
        return uitf.measureText(text);
    }
	
	//----------------------------------
	//  screen
	//----------------------------------
	
	/**
	 *  Returns an object that contains the size and position of the base
	 *  drawing surface for this object.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get screen():Rectangle
	{
		COMPILE::SWF {
			return new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
		}
		COMPILE::JS {
            var topLevelApplication:IUIBase = FlexGlobals.topLevelApplication as IUIBase;
			return new Rectangle(0, 0, topLevelApplication.width, topLevelApplication.height);
		}
	}

    //--------------------------------------------------------------------------
    //
    //  Methods: Drawing and Child Layout
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private var lastUnscaledWidth:Number;
    /**
     *  @private
     */
    private var lastUnscaledHeight:Number;


    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function validateDisplayList():void
    {
        trace("validateDisplayList not implemented");                    
    }

    /**
     *  Draws the object and/or sizes and positions its children.
     *  This is an advanced method that you might override
     *  when creating a subclass of UIComponent.
     *
     *  <p>You do not call this method directly. Flex calls the
     *  <code>updateDisplayList()</code> method when the component is added to a container
     *  using the <code>addChild()</code> method, and when the component's
     *  <code>invalidateDisplayList()</code> method is called. </p>
     *
     *  <p>If the component has no children, this method
     *  is where you would do programmatic drawing
     *  using methods on the component's Graphics object
     *  such as <code>graphics.drawRect()</code>.</p>
     *
     *  <p>If the component has children, this method is where
     *  you would call the <code>move()</code> and <code>setActualSize()</code>
     *  methods on its children.</p>
     *
     *  <p>Components can do programmatic drawing even if
     *  they have children. In doing either, use the
     *  component's <code>unscaledWidth</code> and <code>unscaledHeight</code>
     *  as its bounds.</p>
     *
     *  <p>It is important to use <code>unscaledWidth</code> and
     *  <code>unscaledHeight</code> instead of the <code>width</code>
     *  and <code>height</code> properties.</p>
     *
     *  @param unscaledWidth Specifies the width of the component, in pixels,
     *  in the component's coordinates, regardless of the value of the
     *  <code>scaleX</code> property of the component.
     *
     *  @param unscaledHeight Specifies the height of the component, in pixels,
     *  in the component's coordinates, regardless of the value of the
     *  <code>scaleY</code> property of the component.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function updateDisplayList(unscaledWidth:Number,
                                        unscaledHeight:Number):void
    {
        trace("updateDisplayList not implemented");  
        invalidateDisplayListFlag = false;
    }

    override public function isWidthSizedToContent():Boolean
    {
        if (!isNaN(_explicitWidth))
            return false;
        if (!isNaN(percentWidth))
            return false;
        var left:* = ValuesManager.valuesImpl.getValue(this, "left");
        var right:* = ValuesManager.valuesImpl.getValue(this, "right");
        if (typeof(left) === "string" && String(left).indexOf(":") != -1)
            left = undefined;
        if (typeof(right) === "string" && String(right).indexOf(":") != -1)
            right = undefined;        
        if (left === undefined || right === undefined) return true;
        if (parent is UIComponent)
            return (parent as UIComponent).isWidthSizedToContent();
        return false;
    }

    override public function isHeightSizedToContent():Boolean
    {
        if (!isNaN(_explicitHeight))
            return false;
        if (!isNaN(percentHeight))
            return false;
        var top:* = ValuesManager.valuesImpl.getValue(this, "top");
        var bottom:* = ValuesManager.valuesImpl.getValue(this, "bottom");
        if (typeof(top) === "string" && String(top).indexOf(":") != -1)
            top = undefined;
        if (typeof(bottom) === "string" && String(bottom).indexOf(":") != -1)
            bottom = undefined;        
        if (top === undefined || bottom === undefined) return true;
        if (parent is UIComponent)
            return (parent as UIComponent).isHeightSizedToContent();
        return false;
    }
    
    [Inspectable(category="General")]

    /**
     *  <p>For components, this layout constraint property is a
     *  facade on top of the similarly-named style. To set
     *  a state-specific value of the property in MXML to its default 
     *  value of <code>undefined</code>,
     *  use the &#64;Clear() directive. For example, in MXML code,
     *  <code>left.s2="&#64;Clear()"</code> unsets the <code>left</code>
     *  constraint in state s2. Or in ActionScript code, 
     *  <code>button.left = undefined</code> unsets the <code>left</code>
     *  constraint on <code>button</code>.</p>
     * 
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get left():Object
    {
        return ValuesManager.valuesImpl.getValue(this, "left");
    }
    public function set left(value:Object):void
    {
        setStyle("left", value);
    }

    [Inspectable(category="General")]

    /**
     *  <p>For components, this layout constraint property is a
     *  facade on top of the similarly-named style. To set
     *  the property to its default value of <code>undefined</code>,
     *  use the &#64;Clear() directive in MXML or the <code>undefined</code>
     *  value in ActionScript code. For example, in MXML code,
     *  <code>right.s2="&#64;Clear()"</code> unsets the <code>right</code>
     *  constraint in state s2. Or in ActionScript code, 
     *  <code>button.right = undefined</code> unsets the <code>right</code>
     *  constraint on <code>button</code>.</p>
     *  
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get right():Object
    {
        return ValuesManager.valuesImpl.getValue(this, "right");
    }
    public function set right(value:Object):void
    {
        setStyle("right", value);
    }

    [Inspectable(category="General")]

    /**
     *  <p>For components, this layout constraint property is a
     *  facade on top of the similarly-named style. To set
     *  the property to its default value of <code>undefined</code>,
     *  use the &#64;Clear() directive in MXML or the <code>undefined</code>
     *  value in ActionScript code. For example, in MXML code,
     *  <code>top.s2="&#64;Clear()"</code> unsets the <code>top</code>
     *  constraint in state s2. Or in ActionScript code, 
     *  <code>button.top = undefined</code> unsets the <code>top</code>
     *  constraint on <code>button</code>.</p>
     *  
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get top():Object
    {
        return ValuesManager.valuesImpl.getValue(this, "top");
    }
    public function set top(value:Object):void
    {
        setStyle("top", value);
    }

    [Inspectable(category="General")]

    /**
     *  <p>For components, this layout constraint property is a
     *  facade on top of the similarly-named style. To set
     *  the property to its default value of <code>undefined</code>,
     *  use the &#64;Clear() directive in MXML or the <code>undefined</code>
     *  value in ActionScript code. For example, in MXML code,
     *  <code>bottom.s2="&#64;Clear()"</code> unsets the <code>bottom</code>
     *  constraint in state s2. Or in ActionScript code, 
     *  <code>button.bottom = undefined</code> unsets the <code>bottom</code>
     *  constraint on <code>button</code>.</p>
     *  
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get bottom():Object
    {
        return ValuesManager.valuesImpl.getValue(this, "bottom");
    }
    public function set bottom(value:Object):void
    {
        setStyle("bottom", value);
    }
    
    [Inspectable(category="General")]
    
    /**
     *  Number of pixels between the container's left border
     *  and the left of its content area.
     *
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function get paddingLeft():Object
    {
        return ValuesManager.valuesImpl.getValue(this, "paddingLeft");
    }
    public function set paddingLeft(value:Object):void
    {
        setStyle("paddingLeft", value);
    }
    
    [Inspectable(category="General")]
    
    /**
     *  Number of pixels between the container's right border
     *  and the right of its content area.
     *
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function get paddingRight():Object
    {
        return ValuesManager.valuesImpl.getValue(this, "paddingRight");
    }
    public function set paddingRight(value:Object):void
    {
        setStyle("paddingRight", value);
    }
    
    [Inspectable(category="General")]
    
    /**
     *  Number of pixels between the container's top border
     *  and the top of its content area.
     *
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function get paddingTop():Object
    {
        return ValuesManager.valuesImpl.getValue(this, "paddingTop");
    }
    public function set paddingTop(value:Object):void
    {
        setStyle("paddingTop", value);
    }
    
    [Inspectable(category="General")]
    
    /**
     *  Number of pixels between the container's bottom border
     *  and the bottom of its content area.
     *
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function get paddingBottom():Object
    {
        return ValuesManager.valuesImpl.getValue(this, "paddingBottom");
    }
    public function set paddingBottom(value:Object):void
    {
        setStyle("paddingBottom", value);
    }

    [Inspectable(category="General")]

    /**
     *  <p>For components, this layout constraint property is a
     *  facade on top of the similarly-named style. To set
     *  the property to its default value of <code>undefined</code>,
     *  use the &#64;Clear() directive in MXML or the <code>undefined</code>
     *  value in ActionScript code. For example, in MXML code,
     *  <code>horizontalCenter.s2="&#64;Clear()"</code> unsets the 
     *  <code>horizontalCenter</code>
     *  constraint in state s2. Or in ActionScript code, 
     *  <code>button.horizontalCenter = undefined</code> unsets the 
     *  <code>horizontalCenter</code> constraint on <code>button</code>.</p>
     *  
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get horizontalCenter():Object
    {
        return ValuesManager.valuesImpl.getValue(this, "horizontalCenter");
    }
    public function set horizontalCenter(value:Object):void
    {
        setStyle("horizontalCenter", value);
    }

    [Inspectable(category="General")]

    /**
     *  <p>For components, this layout constraint property is a
     *  facade on top of the similarly-named style. To set
     *  the property to its default value of <code>undefined</code>,
     *  use the &#64;Clear() directive in MXML or the <code>undefined</code>
     *  value in ActionScript code. For example, in MXML code,
     *  <code>verticalCenter.s2="&#64;Clear()"</code> unsets the <code>verticalCenter</code>
     *  constraint in state s2. Or in ActionScript code, 
     *  <code>button.verticalCenter = undefined</code> unsets the <code>verticalCenter</code>
     *  constraint on <code>button</code>.</p>
     *  
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get verticalCenter():Object
    {
        return ValuesManager.valuesImpl.getValue(this, "verticalCenter");
    }
    public function set verticalCenter(value:Object):void
    {
        setStyle("verticalCenter", value);
    }
	
    [Inspectable(category="General")]

	/*	  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get fontWeight():Object
    {
        return ValuesManager.valuesImpl.getValue(this, "fontWeight");
    }
    public function set fontWeight(value:Object):void
    {
        setStyle("fontWeight", value);
    }
    
	[Inspectable(category="General")]

	/*	  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get cornerRadius():Object
    {
        return getStyle("borderRadius");
    }
    public function set cornerRadius(value:Object):void
    {
        setStyle("borderRadius", value);
    }
	[Inspectable(category="General")]
	
	/*	  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get fontFamily():Object
    {
        trace("fontFamily not implemented");
        return 0;
    }
    public function set fontFamily(value:Object):void
    {
        trace("fontFamily not implemented");
    }
	[Inspectable(category="General")]
	
	/*	  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private var _uid:String;
    public function get uid():String
    {
        if (!_uid)
        {
            COMPILE::SWF
            {
                _uid = toString();
            }
            COMPILE::JS // toString() doesn't give a unique id, a static var will at least be good for a session
            {
                _uid = "session_id" + sessionId++;
            }
        }

        return _uid;
    }
    public function set uid(uid:String):void
    {
        this._uid = uid;
    }
    
    /*	  
    *  @langversion 3.0
    *  @playerversion Flash 9
    *  @playerversion AIR 1.1
    *  @productversion Flex 3
    */
    public function get showErrorSkin():Object
    {
        return ValuesManager.valuesImpl.getValue(this, "showErrorSkin");
    }
    public function set showErrorSkin(value:Object):void
    {
        setStyle("showErrorSkin", value);
    }

    /*	  
    *  @langversion 3.0
    *  @playerversion Flash 9
    *  @playerversion AIR 1.1
    *  @productversion Flex 3
    */
    public function get showErrorTip():Object
    {
        return ValuesManager.valuesImpl.getValue(this, "showErrorTip");
    }
    public function set showErrorTip(value:Object):void
    {
        setStyle("showErrorTip", value);
    }
    
    /*	  
    *  @langversion 3.0
    *  @playerversion Flash 9
    *  @playerversion AIR 1.1
    *  @productversion Flex 3
    */
    public function get baseline():Object
    {
        return ValuesManager.valuesImpl.getValue(this, "baseline");
    }
    public function set baseline(value:Object):void
    {
        setStyle("baseline", value);
    }
    
	[Inspectable(category="General")]
	
	/*	  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get fontSize():Object
    {
        return ValuesManager.valuesImpl.getValue(this, "fontSize");
    }
    public function set fontSize(value:Object):void
    {
        setStyle("fontSize", value);
    }
    [Inspectable(category="General")]
    
    /*	  
    *  @langversion 3.0
    *  @playerversion Flash 9
    *  @playerversion AIR 1.1
    *  @productversion Flex 3
    */
    public function get fontStyle():Object
    {
        return ValuesManager.valuesImpl.getValue(this, "fontStyle");
    }
    public function set fontStyle(value:Object):void
    {
        setStyle("fontStyle", value);
    }
    
	[Inspectable(category="General")]
	
	/*	  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get textAlign():Object
    {
        return ValuesManager.valuesImpl.getValue(this, "textAlign");
    }
    public function set textAlign(value:Object):void
    {
        setStyle("textAlign", value);
    }
	[Inspectable(category="General")]
	
	
	/*	  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get color():Object
    {
        return getStyle("color");
    }
    public function set color(value:Object):void
    {
        if (value is String && value.charAt(0) != '#')
        {
            var c:uint = parseInt(value as String);
            value = '#' + c.toString(16);
        }
        setStyle("color", value);
    }
	[Inspectable(category="General")]

	/*	  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get selectedField():Object
    {
        trace("selectedField not implemented");
        return 0;
    }
    public function set selectedField(value:Object):void
    {
        trace("selectedField not implemented");
    }
    
     private var _contentMouseX:Number;
     public function get contentMouseX():Number
     {
	    return 0;
     }
     
     private var _contentMouseY:Number;
     public function get contentMouseY():Number
     {
	    return 0;
     }
	
	[Inspectable(category="General")]

	
    //--------------------------------------------------------------------------
    //
    //  Methods: Moving and sizing
    //
    //--------------------------------------------------------------------------

     /**
      *  Moves the component to a specified position within its parent.
      *  Calling this method is exactly the same as
      *  setting the component's <code>x</code> and <code>y</code> properties.
      *
      *  <p>If you are overriding the <code>updateDisplayList()</code> method
      *  in a custom component, call the <code>move()</code> method
      *  rather than setting the <code>x</code> and <code>y</code> properties.
      *  The difference is that the <code>move()</code> method changes the location
      *  of the component and then dispatches a <code>move</code> event when you
      *  call the method, while setting the <code>x</code> and <code>y</code>
      *  properties changes the location of the component and dispatches
      *  the event on the next screen refresh.</p>
      *
      *  @param x Left position of the component within its parent.
      *
      *  @param y Top position of the component within its parent.
      *  
      *  @langversion 3.0
      *  @playerversion Flash 9
      *  @playerversion AIR 1.1
      *  @productversion Flex 3
      */
    public function move(x:Number, y:Number):void
    {
		this.x = x;
		this.y = y;
    }

    /**
     *  Sizes the object.
     *  Unlike directly setting the <code>width</code> and <code>height</code>
     *  properties, calling the <code>setActualSize()</code> method
     *  does not set the <code>explictWidth</code> and
     *  <code>explicitHeight</code> properties, so a future layout
     *  calculation can result in the object returning to its previous size.
     *  This method is used primarily by component developers implementing
     *  the <code>updateDisplayList()</code> method, by Effects,
     *  and by the LayoutManager.
     *
     *  @param w Width of the object.
     *
     *  @param h Height of the object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function setActualSize(w:Number, h:Number):void
    {
    
    //    trace("setActualSize not implemented");
		this.setWidthAndHeight(w, h);
    }


    /**
     *  Sets the focus to this component.
     *  The component can in turn pass focus to a subcomponent.
     *
     *  <p><b>Note:</b> Only the TextInput and TextArea controls show a highlight
     *  when this method sets the focus.
     *  All controls show a highlight when the user tabs to the control.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function setFocus():void
    {
        COMPILE::SWF
        {
            stage.focus = this;
        }
        COMPILE::JS
        {
            element.focus();
        }
    }

	/**
     *  Deletes a style property from this component instance.
     *
     *  <p>This does not necessarily cause the <code>getStyle()</code> method
     *  to return <code>undefined</code>.</p>
     *
     *  @param styleProp The name of the style property.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function clearStyle(styleProp:String):void
    {
        setStyle(styleProp, undefined);
    }
    [Bindable(style="true")]
    /**
     *  Gets a style property that has been set anywhere in this
     *  component's style lookup chain.
     *
     *  <p>This same method is used to get any kind of style property,
     *  so the value returned can be a Boolean, String, Number, int,
     *  uint (for an RGB color), Class (for a skin), or any kind of object.
     *  Therefore the return type is simply specified as ~~.</p>
     *
     *  <p>If you are getting a particular style property, you 
     *  know its type and often want to store the result in a
     *  variable of that type.
     *  No casting from ~~ to that type is necessary.</p>
     *
     *  <p>
     *  <code>
     *  var backgroundColor:uint = getStyle("backgroundColor");
     *  </code>
     *  </p>
     *
     *  <p>If the style property has not been set anywhere in the
     *  style lookup chain, the value returned by <code>getStyle()</code>
     *  is <code>undefined</code>.
     *  Note that <code>undefined</code> is a special value that is
     *  not the same as <code>false</code>, <code>""</code>,
     *  <code>NaN</code>, <code>0</code>, or <code>null</code>.
     *  No valid style value is ever <code>undefined</code>.
     *  You can use the method
     *  <code>IStyleManager2.isValidStyleValue()</code>
     *  to test whether the value was set.</p>
     *
     *  @param styleProp Name of the style property.
     *
     *  @return Style value.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getStyle(styleProp:String):*
    {//            trace("getStyle not implemented");
//        return 0;
		var value:* = ValuesManager.valuesImpl.getValue(this,styleProp);
        if (value === undefined && _styleName != null && typeof(_styleName) === "object")
            value = styleName.getStyle(styleProp);
            
//		if (!value) value = 0;
		return value;
    }

    private var _backgroundAlpha:Number = NaN;
    private var _backgroundColor:String = null;
    
    /*	  
    *  @langversion 3.0
    *  @playerversion Flash 9
    *  @playerversion AIR 1.1
    *  @productversion Flex 3
    */
    public function get backgroundColor():Object
    {
        return ValuesManager.valuesImpl.getValue(this, "backgroundColor");
    }
    public function set backgroundColor(value:Object):void
    {
        setStyle("backgroundColor", value);
    }

    
    /**
     *  Sets a style property on this component instance.
     *
     *  <p>This can override a style that was set globally.</p>
     *
     *  <p>Calling the <code>setStyle()</code> method can result in decreased performance.
     *  Use it only when necessary.</p>
     *
     *  @param styleProp Name of the style property.
     *
     *  @param newValue New value for the style.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function setStyle(styleProp:String, newValue:*):void
    {
        if (styleProp == "backgroundAlpha")
            _backgroundAlpha = Number(newValue);
        else
        {
            if (styleProp == "backgroundColor")
            {
                if (typeof(newValue) === 'number')
                    _backgroundColor = CSSUtils.attributeFromColor(newValue);
                else
                    _backgroundColor = String(newValue);
            }
            if (!style)
                style = new FlexCSSStyles();
            style[styleProp] = newValue;
            COMPILE::JS
            {
                if (initialized)
                {
                    ValuesManager.valuesImpl.applyStyles(this, style);
                }
            }
        }
        COMPILE::JS
        {
            if (!isNaN(_backgroundAlpha) && _backgroundColor !== null)
            {
                var red:Number = parseInt("0x" + _backgroundColor.substring(1, 3));
                var green:Number = parseInt("0x" + _backgroundColor.substring(3, 5));
                var blue:Number = parseInt("0x" + _backgroundColor.substring(5, 7));
                var rgba:String = "rgba(" + red + "," + green + "," + blue + "," + _backgroundAlpha + ")";
                (element as HTMLElement).style['backgroundColor'] = rgba;
            }                
        }
    }



    //--------------------------------------------------------------------------
    //
    //  Event handlers: Keyboard
    //
    //--------------------------------------------------------------------------

    /**
     *  The event handler called for a <code>keyDown</code> event.
     *  If you override this method, make sure to call the base class version.
     *
     *  @param event The event object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function keyDownHandler(event:KeyboardEvent):void
    {
        // You must override this function if your component accepts focus
    }

    /**
     *  The event handler called for a <code>keyUp</code> event.
     *  If you override this method, make sure to call the base class version.
     *
     *  @param event The event object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function keyUpHandler(event:KeyboardEvent):void
    {
        // You must override this function if your component accepts focus
    }

    /**
     *  The event handler called for a <code>focusIn</code> event.
     *  If you override this method, make sure to call the base class version.
     *
     *  @param event The event object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function focusInHandler(event:FocusEvent):void
    {
        // You must override this function if your component accepts focus
    }


    /**
     *  The event handler called for a <code>focusOut</code> event.
     *  If you override this method, make sure to call the base class version.
     *
     *  @param event The event object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function focusOutHandler(event:FocusEvent):void
    {
        // You must override this function if your component accepts focus
    }


    //--------------------------------------------------------------------------
    //
    //  IUIComponent
    //
    //--------------------------------------------------------------------------

    /**
     *  Returns <code>true</code> if the chain of <code>owner</code> properties
     *  points from <code>child</code> to this UIComponent.
     *
     *  @param child A UIComponent.
     *
     *  @return <code>true</code> if the child is parented or owned by this UIComponent.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function owns(child:IUIBase):Boolean
    {
		if (!(child is IUIBase))
			return false;
			
        return contains(child as IUIBase);
    }
    
    /**
     *  Same as visible setter but does not dispatch events
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function setVisible(value:Boolean):void
    {
        COMPILE::JS
        {
            var oldValue:Boolean = (!positioner.style.visibility) ||
                                    positioner.style.visibility == 'visible';
            if (Boolean(value) !== oldValue)
            {
                if (!value) 
                {
                    positioner.style.visibility = 'hidden';
                } 
                else 
                {
                    positioner.style.visibility = '';
                }
            }
        }
        COMPILE::SWF
        {
            super.visible = value;
        }
    }

    //--------------------------------------------------------------------------
    //
    //  ILayoutElement
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function getPreferredBoundsWidth(postLayoutTransform:Boolean=true):Number
    {
        return LayoutElementUIComponentUtils.getPreferredBoundsWidth(this/*,postLayoutTransform? nonDeltaLayoutMatrix():null*/);
    }
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function getPreferredBoundsHeight(postLayoutTransform:Boolean=true):Number
    {
        return LayoutElementUIComponentUtils.getPreferredBoundsHeight(this/*,postLayoutTransform? nonDeltaLayoutMatrix():null*/);
    }
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function getMinBoundsWidth(postLayoutTransform:Boolean=true):Number
    {
        return LayoutElementUIComponentUtils.getMinBoundsWidth(this/*,postLayoutTransform? nonDeltaLayoutMatrix():null*/);
    }
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function getMinBoundsHeight(postLayoutTransform:Boolean=true):Number
    {
        return LayoutElementUIComponentUtils.getMinBoundsHeight(this/*,postLayoutTransform? nonDeltaLayoutMatrix():null*/);
    }
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function getMaxBoundsWidth(postLayoutTransform:Boolean=true):Number
    {
        return LayoutElementUIComponentUtils.getMaxBoundsWidth(this/*,postLayoutTransform? nonDeltaLayoutMatrix():null*/);
    }
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function getMaxBoundsHeight(postLayoutTransform:Boolean=true):Number
    {
        return LayoutElementUIComponentUtils.getMaxBoundsHeight(this/*,postLayoutTransform? nonDeltaLayoutMatrix():null*/);
    }
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function getBoundsXAtSize(width:Number, height:Number, postLayoutTransform:Boolean = true):Number
    {
        return LayoutElementUIComponentUtils.getBoundsXAtSize(this, width, height/*,
            postLayoutTransform ? nonDeltaLayoutMatrix() : null*/);
    }
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function getBoundsYAtSize(width:Number, height:Number, postLayoutTransform:Boolean = true):Number
    {
        return LayoutElementUIComponentUtils.getBoundsYAtSize(this, width, height/*,
            postLayoutTransform ? nonDeltaLayoutMatrix() : null*/);
    }
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function getLayoutBoundsWidth(postLayoutTransform:Boolean=true):Number
    {
        return LayoutElementUIComponentUtils.getLayoutBoundsWidth(this/*,postLayoutTransform? nonDeltaLayoutMatrix():null*/);
    }
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function getLayoutBoundsHeight(postLayoutTransform:Boolean=true):Number
    {
        return LayoutElementUIComponentUtils.getLayoutBoundsHeight(this/*,postLayoutTransform? nonDeltaLayoutMatrix():null*/);
    }
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function getLayoutBoundsX(postLayoutTransform:Boolean=true):Number
    {
        return LayoutElementUIComponentUtils.getLayoutBoundsX(this/*,postLayoutTransform? nonDeltaLayoutMatrix():null*/);
    }
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function getLayoutBoundsY(postLayoutTransform:Boolean=true):Number
    {
        return LayoutElementUIComponentUtils.getLayoutBoundsY(this/*,postLayoutTransform? nonDeltaLayoutMatrix():null*/);
    }
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function setLayoutBoundsPosition(x:Number, y:Number, postLayoutTransform:Boolean=true):void
    {
        LayoutElementUIComponentUtils.setLayoutBoundsPosition(this,x,y/*,postLayoutTransform? nonDeltaLayoutMatrix():null*/);
    }
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function setLayoutBoundsSize(width:Number,
                                        height:Number,
                                        postLayoutTransform:Boolean = true):void
    {
        LayoutElementUIComponentUtils.setLayoutBoundsSize(this,width,height/*,postLayoutTransform? nonDeltaLayoutMatrix():null*/);
    }

    /** 
     *  Helper method for dispatching a PropertyChangeEvent
     *  when a property is updated.
     * 
     *  @param prop Name of the property that changed.
     *
     *  @param oldValue Old value of the property.
     *
     *  @param value New value of the property.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function dispatchPropertyChangeEvent(prop:String, oldValue:*,
                                                   value:*):void
    {
        if (hasEventListener("propertyChange"))
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(
                this, prop, oldValue, value));
    }
    
    private var _rollOverEffect:IEffect;
    
    /**
     *  Played when the user rolls the mouse over the component.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get rollOverEffect():Object
    {
        return _rollOverEffect;
    }
    public function set rollOverEffect(value:Object):void
    {
        _rollOverEffect = value as IEffect;
    }
    
    private var _rollOutEffect:IEffect;
    
    /**
     *  Played when the user rolls the mouse so it is no longer over the component.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get rollOutEffect():Object
    {
        return _rollOutEffect;
    }
    public function set rollOutEffect(value:Object):void
    {
        _rollOutEffect = value as IEffect;
    }
    
    private var _mouseDownEffect:IEffect;
    
    /**
     *  Played when the user presses the mouse button.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get mouseDownEffect():Object
    {
        return _mouseDownEffect;
    }
    public function set mouseDownEffect(value:Object):void
    {
        _mouseDownEffect = value as IEffect;
        addEventListener(MouseEvent.MOUSE_DOWN, new EffectEventWatcher(_mouseDownEffect).listener);
    }
    
    private var _mouseUpEffect:IEffect;
    
    /**
     *  Played when the user releases the mouse button.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get mouseUpEffect():Object
    {
        return _mouseUpEffect;
    }
    public function set mouseUpEffect(value:Object):void
    {
        _mouseUpEffect = value as IEffect;
        addEventListener(MouseEvent.MOUSE_UP, new EffectEventWatcher(_mouseUpEffect).listener);
    }
    
    private var _hideEffect:IEffect;
    
    /**
     *  Played when the component becomes invisible.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get hideEffect():Object
    {
        return _hideEffect;
    }
    public function set hideEffect(value:Object):void
    {
        _hideEffect = value as IEffect;
        addEventListener("hide", new EffectEventWatcher(_hideEffect).listener);
    }

    private var _showEffect:IEffect;
    
    /**
     *  Played when the component becomes visible.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get showEffect():Object
    {
        return _showEffect;
    }
    public function set showEffect(value:Object):void
    {
        _showEffect = value as IEffect;
        addEventListener("hide", new EffectEventWatcher(_showEffect).listener);
    }

    /**
     *  Creates a new object using a context
     *  based on the embedded font being used.
     *
     *  <p>This method is used to solve a problem
     *  with access to fonts embedded  in an application SWF
     *  when the framework is loaded as an RSL
     *  (the RSL has its own SWF context).
     *  Embedded fonts can only be accessed from the SWF file context
     *  in which they were created.
     *  By using the context of the application SWF,
     *  the RSL can create objects in the application SWF context
     *  that has access to the application's  embedded fonts.</p>
     *
     *  <p>Call this method only after the font styles
     *  for this object are set.</p>
     *
     *  @param class The class to create.
     *
     *  @return The instance of the class created in the context
     *  of the SWF owning the embedded font.
     *  If this object is not using an embedded font,
     *  the class is created in the context of this object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function createInFontContext(classObj:Class):Object
    {
        return new classObj();
    }
    
    /**
     *  Flex calls the <code>stylesInitialized()</code> method when
     *  the styles for a component are first initialized.
     *
     *  <p>This is an advanced method that you might override
     *  when creating a subclass of UIComponent. Flex guarantees that
     *  your component's styles are fully initialized before
     *  the first time your component's <code>measure</code> and
     *  <code>updateDisplayList</code> methods are called.  For most
     *  components, that is sufficient. But if you need early access to
     *  your style values, you can override the stylesInitialized() function
     *  to access style properties as soon as they are initialized the first time.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function stylesInitialized():void
    {
    }
    
    //--------------------------------------------------------------------------
    //
    //  Event handlers: Validation
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     *  Individual error messages from validators
     */
    private var errorArray:Array;

    /**
     *  @private
     *  Array of validators who gave error messages
     */
    private var errorObjectArray:Array = null;
    
    //----------------------------------
    //  validationSubField
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the validationSubField property.
     */
    private var _validationSubField:String;
    
    /**
     *  Used by a validator to associate a subfield with this component.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get validationSubField():String
    {
        return _validationSubField;
    }
    
    /**
     *  @private
     */
    public function set validationSubField(value:String):void
    {
        _validationSubField = value;
    }

    /**
     *  Handles both the <code>valid</code> and <code>invalid</code> events from a
     *  validator assigned to this component.
     *
     *  <p>You typically handle the <code>valid</code> and <code>invalid</code> events
     *  dispatched by a validator by assigning event listeners to the validators.
     *  If you want to handle validation events directly in the component that is being validated,
     *  you can override this method to handle the <code>valid</code>
     *  and <code>invalid</code> events. You typically call
     *  <code>super.validationResultHandler(event)</code> in your override.</p>
     *
     *  @param event The event object for the validation.
     *
     *  @see mx.events.ValidationResultEvent
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function validationResultHandler(event:ValidationResultEvent):void
    {
        if (errorObjectArray === null)
        {
            errorObjectArray = [];
            errorArray = [];
        }
        
        var validatorIndex:int = errorObjectArray.indexOf(event.target);
        // If we are valid, then clear the error string
        if (event.type == ValidationResultEvent.VALID)
        {
            if (validatorIndex != -1)
            {
                errorObjectArray.splice(validatorIndex, 1);
                errorArray.splice(validatorIndex, 1);
                errorString = errorArray.join("\n");
                if (errorArray.length == 0)
                    dispatchEvent(new FlexEvent(FlexEvent.VALID));
            }
        }
        else // If we get an invalid event
        {
            var msg:String;
            var result:ValidationResult;
            
            // We are associated with a subfield
            if (validationSubField != null && validationSubField != "" && event.results)
            {
                for (var i:int = 0; i < event.results.length; i++)
                {
                    result = event.results[i];
                    // Find the result that is meant for us
                    if (result.subField == validationSubField)
                    {
                        if (result.isError)
                        {
                            msg = result.errorMessage;
                        }
                        else
                        {
                            if (validatorIndex != -1)
                            {
                                errorObjectArray.splice(validatorIndex, 1);
                                errorArray.splice(validatorIndex, 1);
                                errorString = errorArray.join("\n");
                                if (errorArray.length == 0)
                                    dispatchEvent(new FlexEvent(FlexEvent.VALID));
                            }
                        }
                        break;
                    }
                }
            }
            else if (event.results && event.results.length > 0)
            {
                msg = event.results[0].errorMessage;
            }
            
            if (msg && validatorIndex != -1)
            {
                // Handle the case where this target already had this invalid
                // event and the errorString has been cleared.
                errorArray[validatorIndex] = msg;
                errorString = errorArray.join("\n");
                dispatchEvent(new FlexEvent(FlexEvent.INVALID));
            }
            else if (msg && validatorIndex == -1)
            {
                errorObjectArray.push(event.target);
                errorArray.push(msg);
                errorString = errorArray.join("\n");
                dispatchEvent(new FlexEvent(FlexEvent.INVALID));
            }
        }
    }
    
    /**
     *  Returns a UITextFormat object corresponding to the text styles
     *  for this UIComponent.
     *
     *  @return UITextFormat object corresponding to the text styles
     *  for this UIComponent.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    COMPILE::SWF
    public function determineTextFormatFromStyles():UITextFormat
    {
        var textFormat:UITextFormat// = cachedTextFormat;
        
        /*
        if (!textFormat)
        {
            var font:String =
                StringUtil.trimArrayElements(_inheritingStyles.fontFamily, ",");
            textFormat = new UITextFormat(getNonNullSystemManager(), font);
            textFormat.moduleFactory = moduleFactory;
            
            // Not all flex4 textAlign values are valid so convert to a valid one.
            var align:String = _inheritingStyles.textAlign;
            if (align == "start") 
                align = TextFormatAlign.LEFT;
            else if (align == "end")
                align = TextFormatAlign.RIGHT;
            textFormat.align = align; 
            textFormat.bold = _inheritingStyles.fontWeight == "bold";
            textFormat.color = enabled ?
                _inheritingStyles.color :
                _inheritingStyles.disabledColor;
            textFormat.font = font;
            textFormat.indent = _inheritingStyles.textIndent;
            textFormat.italic = _inheritingStyles.fontStyle == "italic";
            textFormat.kerning = _inheritingStyles.kerning;
            textFormat.leading = _nonInheritingStyles.leading;
            textFormat.leftMargin = _nonInheritingStyles.paddingLeft;
            textFormat.letterSpacing = _inheritingStyles.letterSpacing;
            textFormat.rightMargin = _nonInheritingStyles.paddingRight;
            textFormat.size = _inheritingStyles.fontSize;
            textFormat.underline =
                _nonInheritingStyles.textDecoration == "underline";
            
            textFormat.antiAliasType = _inheritingStyles.fontAntiAliasType;
            textFormat.gridFitType = _inheritingStyles.fontGridFitType;
            textFormat.sharpness = _inheritingStyles.fontSharpness;
            textFormat.thickness = _inheritingStyles.fontThickness;
            
            textFormat.useFTE =
                getTextFieldClassName() == "mx.core::UIFTETextField" ||
                getTextInputClassName() == "mx.controls::MXFTETextInput";
            
            if (textFormat.useFTE)
            {
                textFormat.direction = _inheritingStyles.direction;
                textFormat.locale = _inheritingStyles.locale;
            }
            
            cachedTextFormat = textFormat;
        }*/
        
        return textFormat;
    }

    /**
     *  @private
     */
    mx_internal function addingChild(child:IUIBase):void
    {
        // If the document property isn't already set on the child,
        // set it to be the same as this component's document.
        // The document setter will recursively set it on any
        // descendants of the child that exist.
        if (child is IUIComponent &&
            !IUIComponent(child).mxmlDocument)
        {
            IUIComponent(child).mxmlDocument = mxmlDocument ?
                mxmlDocument :
                FlexGlobals.topLevelApplication;
        }
        
        // Propagate moduleFactory to the child, but don't overwrite an existing moduleFactory.
        if (child is IFlexModule && IFlexModule(child).moduleFactory == null)
        {
            if (moduleFactory != null)
                IFlexModule(child).moduleFactory = moduleFactory;
                
            else if (mxmlDocument is IFlexModule && mxmlDocument.moduleFactory != null)
                IFlexModule(child).moduleFactory = mxmlDocument.moduleFactory;
                
            else if (parent is IFlexModule && IFlexModule(parent).moduleFactory != null)
                IFlexModule(child).moduleFactory = IFlexModule(parent).moduleFactory;
        }
        
        // Flex didn't propagate SystemManager because it was derivable from a root property
        // which we don't have in the browser.
        if (child is IUIComponent)
            IUIComponent(child).systemManager = systemManager;
        
        /*
        
        // Set the font context in non-UIComponent children.
        // UIComponent children use moduleFactory.
        if (child is IFontContextComponent && !(child is UIComponent) &&
            IFontContextComponent(child).fontContext == null)
            IFontContextComponent(child).fontContext = moduleFactory;
        
        if (child is IUIComponent)
            IUIComponent(child).parentChanged(this);
        
        // Set the nestLevel of the child to be one greater
        // than the nestLevel of this component.
        // The nestLevel setter will recursively set it on any
        // descendants of the child that exist.
        if (child is ILayoutManagerClient)
            ILayoutManagerClient(child).nestLevel = nestLevel + 1;
        else if (child is IUITextField)
            IUITextField(child).nestLevel = nestLevel + 1;
        
        if (child is InteractiveObject)
            if (doubleClickEnabled)
                InteractiveObject(child).doubleClickEnabled = true;
        
        // Sets up the inheritingStyles and nonInheritingStyles objects
        // and their proto chains so that getStyle() works.
        // If this object already has some children,
        // then reinitialize the children's proto chains.
        if (child is IStyleClient)
            IStyleClient(child).regenerateStyleCache(true);
        else if (child is IUITextField && IUITextField(child).inheritingStyles)
            StyleProtoChain.initTextField(IUITextField(child));
        
        if (child is ISimpleStyleClient)
            ISimpleStyleClient(child).styleChanged(null);
        
        if (child is IStyleClient)
            IStyleClient(child).notifyStyleChangeInChildren(null, true);
        
        if (child is UIComponent)
            UIComponent(child).initThemeColor();
        
        // Inform the component that it's style properties
        // have been fully initialized. Most components won't care,
        // but some need to react to even this early change.
        if (child is UIComponent)
            UIComponent(child).stylesInitialized();
        */
    }
    
    /**
     *  @private
     */
    mx_internal function childAdded(child:IUIBase):void
    {
        /*
        if (!UIComponentGlobals.designMode)
        {
            if (child is UIComponent)
            {
                if (!UIComponent(child).initialized)
                    UIComponent(child).initialize();
            }
            else if (child is IUIComponent)
            {
                IUIComponent(child).initialize();
            }
        }
        else
        {
            try
            {
                if (child is UIComponent)
                {
                    if (!UIComponent(child).initialized)
                        UIComponent(child).initialize();
                }
                else if (child is IUIComponent)
                {
                    IUIComponent(child).initialize();
                }               
            }
            catch (e:Error)
            {
                // Dispatch a initializeError dynamic event for tooling. 
                var initializeErrorEvent:DynamicEvent = new DynamicEvent("initializeError");
                initializeErrorEvent.error = e;
                initializeErrorEvent.source = child; 
                systemManager.dispatchEvent(initializeErrorEvent);
            }
        }
        */
		_measuredWidth = NaN;
		_measuredHeight = NaN;
    }
    
    /**
     *  @private
     */
    mx_internal function removingChild(child:IUIBase):void
    {
    }
    
    /**
     *  @private
     */
    mx_internal function childRemoved(child:IUIBase):void
    {
        if (child is IUIComponent)
        {
            // only reset document if the child isn't
            // a document itself
            if (IUIComponent(child).mxmlDocument != child)
                IUIComponent(child).mxmlDocument = null;
            //IUIComponent(child).parentChanged(null);
        }
    }
    
    override public function addElement(c:IChild, dispatchEvent:Boolean=true):void
    {
        addingChild(c as IUIBase);
        super.addElement(c, dispatchEvent);
        childAdded(c as IUIBase);
    }

    override public function addElementAt(c:IChild, index:int, dispatchEvent:Boolean=true):void
    {
        addingChild(c as IUIBase);
        super.addElementAt(c, index, dispatchEvent);
        childAdded(c as IUIBase);
    }
    
    override public function removeElement(c:IChild, dispatchEvent:Boolean=true):void
    {
        removingChild(c as IUIBase);
        super.removeElement(c, dispatchEvent);
        childRemoved(c as IUIBase);
    }
    
    /**
     *  @copy org.apache.royale.core.IUIBase#topMostEventDispatcher
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     *  @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
     *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
     */
    override public function get topMostEventDispatcher():IEventDispatcher
    {
        return FlexGlobals.topLevelApplication.parent as IEventDispatcher;
    }

    COMPILE::JS
    override public function addEventListener(type:String, handler:Function, opt_capture:Boolean = false, opt_handlerScope:Object = null):void
    {
        if (type == "keyDown") type = "keydown";
        else if (type == "keyUp") type = "keyup";
        else if (type == "focusIn") type = "focusin";
        else if (type == "focusOut") type = "focusout";
        super.addEventListener(type, handler, opt_capture, opt_handlerScope);
    }
    
    COMPILE::JS
    override public function removeEventListener(type:String, handler:Function, opt_capture:Boolean = false, opt_handlerScope:Object = null):void
    {
        if (type == "keyDown") type = "keydown";
        else if (type == "keyUp") type = "keyup";
        else if (type == "focusIn") type = "focusin";
        else if (type == "focusOut") type = "focusout";
        super.removeEventListener(type, handler, opt_capture, opt_handlerScope);
    }

    [Bindable("visibleChanged")]
    COMPILE::JS
    override public function get visible():Boolean
    {
        if (!positioner.style.visibility) return true;
        
        return positioner.style.visibility != 'hidden';
    }
    
    COMPILE::JS
    override public function set visible(value:Boolean):void
    {
        var oldValue:Boolean = (!positioner.style.visibility) ||
                                positioner.style.visibility == 'visible';
        if (Boolean(value) !== oldValue)
        {
            if (!value) 
            {
                positioner.style.visibility = 'hidden';
                dispatchEvent(new Event('hide'));
            } 
            else 
            {
                positioner.style.visibility = '';
                dispatchEvent(new Event('show'));
            }
            dispatchEvent(new Event('visibleChanged'));
        }
    }

}

}

import org.apache.royale.effects.IEffect;
import org.apache.royale.events.Event;

/**
 *  @private
 *  An element of the methodQueue array.
 */
class EffectEventWatcher
{
    private var _effect:IEffect;
    
    public function EffectEventWatcher(effect:IEffect)
    {
        _effect = effect;
    }
    
    public function listener(event:Event):void
    {
        _effect.play();
    }
}

////////////////////////////////////////////////////////////////////////////////
//
//  Helper class: MethodQueueElement
//
////////////////////////////////////////////////////////////////////////////////

/**
 *  @private
 *  An element of the methodQueue array.
 */
class MethodQueueElement
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function MethodQueueElement(method:Function,
                                       args:Array /* of Object */ = null)
    {
        super();

        this.method = method;
        this.args = args;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  method
    //----------------------------------

    /**
     *  A reference to the method to be called.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     *  @royalesuppresspublicvarwarning
     */
    public var method:Function;

    //----------------------------------
    //  args
    //----------------------------------

    /**
     *  The arguments to be passed to the method.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     *  @royalesuppresspublicvarwarning
     */
    public var args:Array /* of Object */;
	
	
}
