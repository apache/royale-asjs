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


package spark.components
{
/* import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.SoftKeyboardEvent;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.system.Capabilities;
import flash.text.TextField;
import flash.ui.Keyboard;
import flash.utils.Timer; */

/* import mx.core.EventPriority;
import mx.core.FlexGlobals;
import mx.core.IFactory;
import mx.core.IInvalidating;
import mx.core.InteractionMode;
import mx.core.LayoutDirection;
import mx.core.UIComponent;
import mx.events.EffectEvent;
import mx.events.FlexEvent;
import mx.events.FlexMouseEvent;
import mx.events.PropertyChangeEvent;
import mx.events.TouchInteractionEvent;
import mx.managers.IFocusManager;
import mx.styles.IStyleClient;

import spark.components.supportClasses.GroupBase;
import spark.components.supportClasses.ScrollerLayout;
import spark.components.supportClasses.TouchScrollHelper;
import spark.core.IGraphicElement;
import spark.core.NavigationUnit;
import spark.effects.Animate;
import spark.effects.ThrowEffect;
import spark.effects.animation.MotionPath;
import spark.effects.animation.SimpleMotionPath;
import spark.events.CaretBoundsChangeEvent;
import spark.layouts.supportClasses.LayoutBase;
import spark.utils.MouseEventUtil; */
import mx.core.IVisualElement;
import mx.core.IVisualElementContainer;
import mx.core.mx_internal;
import mx.core.UIComponent;
import mx.managers.IFocusManagerComponent;

import spark.components.supportClasses.SkinnableComponent;
import spark.core.IViewport;

import org.apache.royale.core.IChild;
import org.apache.royale.events.Event;

use namespace mx_internal;
/* 
include "../styles/metadata/BasicInheritingTextStyles.as"
include "../styles/metadata/AdvancedInheritingTextStyles.as"
include "../styles/metadata/SelectionFormatTextStyles.as"
 */
//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched when the scroll position is going to change due to a 
 *  <code>mouseWheel</code> event.
 *  
 *  <p>If there is a visible verticalScrollBar, then by default
 *  the viewport is scrolled vertically by <code>event.delta</code> "steps".
 *  The height of the step is determined by the viewport's 
 *  <code>getVerticalScrollPositionDelta</code> method using 
 *  either <code>UP</code> or <code>DOWN</code>, depending on the scroll 
 *  direction.</p>
 *
 *  <p>Otherwise, if there is a visible horizontalScrollBar, then by default
 *  the viewport is scrolled horizontally by <code>event.delta</code> "steps".
 *  The width of the step is determined by the viewport's 
 *  <code>getHorizontalScrollPositionDelta</code> method using 
 *  either <code>LEFT</code> or <code>RIGHT</code>, depending on the scroll 
 *  direction.</p>
 *
 *  <p>Calling the <code>preventDefault()</code> method
 *  on the event prevents the scroll position from changing.
 *  Otherwise if you modify the <code>delta</code> property of the event,
 *  that value will be used as the number of "steps".</p>
 *
 *  @eventType mx.events.FlexMouseEvent.MOUSE_WHEEL_CHANGING
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Royale 0.9.4
 */
//[Event(name="mouseWheelChanging", type="mx.events.FlexMouseEvent")]

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *  @copy spark.components.supportClasses.GroupBase#style:alternatingItemColors
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[Style(name="alternatingItemColors", type="Array", arrayType="uint", format="Color", inherit="yes", theme="spark, mobile")]

/**
 *  The alpha of the content background for this component.
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[Style(name="contentBackgroundAlpha", type="Number", inherit="yes", theme="spark, mobile")]

/**
 *  @copy spark.components.supportClasses.GroupBase#style:contentBackgroundColor
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */ 
//[Style(name="contentBackgroundColor", type="uint", format="Color", inherit="yes", theme="spark, mobile")]

/**
 *  @copy spark.components.supportClasses.GroupBase#style:downColor
 *   
 *  @langversion 3.0
 *  @playerversion Flash 10.1
 *  @playerversion AIR 2.5
 *  @productversion Royale 0.9.4
 */
//[Style(name="downColor", type="uint", format="Color", inherit="yes", theme="mobile")]

/**
 *  @copy spark.components.supportClasses.GroupBase#style:focusColor
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */ 
//[Style(name="focusColor", type="uint", format="Color", inherit="yes", theme="spark, mobile")]

/**
 *  Indicates under what conditions the horizontal scroll bar is displayed.
 * 
 *  <ul>
 *  <li>
 *  <code>ScrollPolicy.ON</code> ("on") - the scroll bar is always displayed.
 *  </li> 
 *  <li>
 *  <code>ScrollPolicy.OFF</code> ("off") - the scroll bar is never displayed.
 *  The viewport can still be scrolled programmatically, by setting its
 *  horizontalScrollPosition property.
 *  </li>
 *  <li>
 *  <code>ScrollPolicy.AUTO</code> ("auto") - the scroll bar is displayed when 
 *  the viewport's contentWidth is larger than its width.
 *  </li>
 *  </ul>
 * 
 *  <p>
 *  The scroll policy affects the measured size of the Scroller component.
 *  </p>
 * 
 *  @default ScrollPolicy.AUTO
 *
 *  @see mx.core.ScrollPolicy
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */ 
[Style(name="horizontalScrollPolicy", type="String", inherit="no", enumeration="off,on,auto")]

/**
 *  A proxy for the <code>liveDragging</code> style of the scrollbars 
 *  used by the Scroller component.   
 * 
 *  <p>If this style is set to <code>true</code>, then the 
 *  <code>liveDragging</code> styles are set to <code>true</code> (the default).
 *  That means dragging a scrollbar thumb immediately updates the viewport's scroll position.
 *  If this style is set to <code>false</code>, then the <code>liveDragging</code> styles 
 *  are set to <code>false</code>.
 *  That means when a scrollbar thumb is dragged the viewport's scroll position is only updated 
 *  then the mouse button is released.</p>
 * 
 *  <p>Setting this style to <code>false</code> can be helpful 
 *  when updating the viewport's display is so 
 *  expensive that "liveDragging" performs poorly.</p> 
 *  
 *  <p>By default this style is <code>undefined</code>, which means that 
 *  the <code>liveDragging</code> styles are not modified.</p>
 * 
 *  @default undefined
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[Style(name="liveScrolling", type="Boolean", inherit="no")]

/**
 *  @copy spark.components.supportClasses.GroupBase#style:rollOverColor
 *   
 *  @default 0xCEDBEF
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[Style(name="rollOverColor", type="uint", format="Color", inherit="yes", theme="spark")]

/**
 *  @copy spark.components.supportClasses.GroupBase#style:symbolColor
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */ 
//[Style(name="symbolColor", type="uint", format="Color", inherit="yes", theme="spark, mobile")]

/**
 *  @copy spark.components.supportClasses.GroupBase#style:touchDelay
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10.1
 *  @playerversion AIR 2.5
 *  @productversion Royale 0.9.4
 */
//[Style(name="touchDelay", type="Number", format="Time", inherit="yes", minValue="0.0")]

/**
 *  Indicates under what conditions the vertical scroll bar is displayed.
 * 
 *  <ul>
 *  <li>
 *  <code>ScrollPolicy.ON</code> ("on") - the scroll bar is always displayed.
 *  </li> 
 *  <li>
 *  <code>ScrollPolicy.OFF</code> ("off") - the scroll bar is never displayed.
 *  The viewport can still be scrolled programmatically, by setting its
 *  verticalScrollPosition property.
 *  </li>
 *  <li>
 *  <code>ScrollPolicy.AUTO</code> ("auto") - the scroll bar is displayed when 
 *  the viewport's contentHeight is larger than its height.
 *  </li>
 *  </ul>
 * 
 *  <p>
 *  The scroll policy affects the measured size of the Scroller component.
 *  </p>
 * 
 *  @default ScrollPolicy.AUTO
 *
 *  @see mx.core.ScrollPolicy
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
     */ 
//[Style(name="verticalScrollPolicy", type="String", inherit="no", enumeration="off,on,auto")]

//--------------------------------------
//  Other metadata
//--------------------------------------

//[ResourceBundle("components")]
    
[DefaultProperty("viewport")]

//[IconFile("Scroller.png")]

/**
 *  The Scroller component displays a single scrollable component, 
 *  called a viewport, and horizontal and vertical scroll bars. 
 *  The viewport must implement the IViewport interface.  Its skin
 *  must be a derivative of the Group class.
 *
 *  <p>The Spark Group, DataGroup, and RichEditableText components implement 
 *  the IViewport interface and can be used as the children of the Scroller control,
 *  as the following example shows:</p>
 * 
 *  <pre>
 *  &lt;s:Scroller width="100" height="100"&gt;
 *       &lt;s:Group&gt; 
 *          &lt;mx:Image width="300" height="400" 
 *               source="&#64;Embed(source='assets/logo.jpg')"/&gt; 
 *       &lt;/s:Group&gt;        
 *  &lt;/s:Scroller&gt;</pre>     
 *
 *  <p>The size of the Image control is set larger than that of its parent Group container. 
 *  By default, the child extends past the boundaries of the parent container. 
 *  Rather than allow the child to extend past the boundaries of the parent container, 
 *  the Scroller specifies to clip the child to the boundaries and display scroll bars.</p>
 *
 *  <p>Not all Spark containers implement the IViewPort interface. 
 *  Therefore, those containers, such as the BorderContainer and SkinnableContainer containers, 
 *  cannot be used as the direct child of the Scroller component.
 *  However, all Spark containers can have a Scroller component as a child component. 
 *  For example, to use scroll bars on a child of the Spark BorderContainer, 
 *  wrap the child in a Scroller component. </p>
 *
 *  <p>To make the entire BorderContainer scrollable, wrap it in a Group container. 
 *  Then, make the Group container the child of the Scroller component,
 *  For skinnable Spark containers that do not implement the IViewport interface, 
 *  you can also create a custom skin for the container that 
 *  includes the Scroller component. </p>
 * 
 *  <p>The IViewport interface defines a viewport for the components that implement it.
 *  A viewport is a rectangular subset of the area of a container that you want to display, 
 *  rather than displaying the entire container.
 *  The scroll bars control the viewport's <code>horizontalScrollPosition</code> and
 *  <code>verticalScrollPosition</code> properties.
 *  scroll bars make it possible to view the area defined by the viewport's 
 *  <code>contentWidth</code> and <code>contentHeight</code> properties.</p>
 *
 *  <p>You can directly set properties on the component wrapped by the Scroller by 
 *  using the <code>Scroller.viewport</code> property. 
 *  For example, you can modify the viewport's <code>horizontalScrollPosition</code> and
 *  <code>verticalScrollPosition</code> properties.</p>
 *
 *  <p>To directly access the scroll bar instances, either HScrollBar or VScrollBar, 
 *  created by the Scroller, use the <code>Scroller.horizontalScrollBar</code> and
 *  <code>Scroller.verticalScrollBar</code> properties.</p>
 *
 *  <p>You can combine scroll bars with explicit settings for the container's viewport. 
 *  The viewport settings determine the initial position of the viewport, 
 *  and then you can use the scroll bars to move it, as the following example shows: </p>
 *  
 *  <pre>
 *  &lt;s:Scroller width="100" height="100"&gt;
 *      &lt;s:Group
 *          horizontalScrollPosition="50" verticalScrollPosition="50"&gt; 
 *          &lt;mx:Image width="300" height="400" 
 *              source="&#64;Embed(source='assets/logo.jpg')"/&gt; 
 *      &lt;/s:Group&gt;                 
 *  &lt;/s:Scroller&gt;</pre>
 * 
 *  <p>The scroll bars are displayed according to the vertical and horizontal scroll bar
 *  policy, which can be <code>auto</code>, <code>on</code>, or <code>off</code>.
 *  The <code>auto</code> policy means that the scroll bar will be visible and included
 *  in the layout when the viewport's content is larger than the viewport itself.</p>
 * 
 *  <p>The Scroller skin layout cannot be changed. It is unconditionally set to a 
 *  private layout implementation that handles the scroll policies.  Scroller skins
 *  can only provide replacement scroll bars.  To gain more control over the layout
 *  of a viewport and its scroll bars, instead of using Scroller, just add them 
 *  to a <code>Group</code> and use the scroll bar <code>viewport</code> property 
 *  to link them together.</p>
 *
 *  <p>The Scroller control has the following default characteristics:</p>
 *     <table class="innertable">
 *        <tr>
 *           <th>Characteristic</th>
 *           <th>Description</th>
 *        </tr>
 *        <tr>
 *           <td>Default size</td>
 *           <td>0</td>
 *        </tr>
 *        <tr>
 *           <td>Minimum size</td>
 *           <td>0</td>
 *        </tr>
 *        <tr>
 *           <td>Maximum size</td>
 *           <td>10000 pixels wide and 10000 pixels high</td>
 *        </tr>
 *        <tr>
 *           <td>Default skin class</td>
 *           <td>spark.skins.spark.ScrollerSkin</td>
 *        </tr>
 *     </table>
 *
 *  @mxml
 *
 *  <p>The <code>&lt;s:Scroller&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;s:Scroller
 *   <strong>Properties</strong>
 *    measuredSizeIncludesScrollBars="true"
 *    minViewportInset="0"
 *    pageScrollingEnabled="false"
 *    scrollSnappingMode="none"
 *    viewport="null"
 *  
 *    <strong>Styles</strong>
 *    alignmentBaseline="use_dominant_baseline"
 *    alternatingItemColors=""
 *    baselineShift="0.0"
 *    blockProgression="TB"
 *    breakOpportunity="auto"
 *    cffHinting="horizontal_stem"
 *    clearFloats="none"
 *    color="0"
 *    contentBackgroundAlpha=""
 *    contentBackgroundColor=""
 *    digitCase="default"
 *    digitWidth="default"
 *    direction="LTR"
 *    dominantBaseline="auto"
 *    downColor=""
 *    firstBaselineOffset="auto"
 *    focusColor=""
 *    focusedTextSelectionColor=""
 *    fontFamily="Arial"
 *    fontLookup="device"
 *    fontSize="12"
 *    fontStyle="normal"
 *    fontWeight="normal"
 *    horizontalScrollPolicy="auto"
 *    inactiveTextSelection=""
 *    justificationRule="auto"
 *    justificationStyle="auto"
 *    kerning="auto"
 *    leadingModel="auto"
 *    ligatureLevel="common"
 *    lineHeight="120%"
 *    lineThrough="false"
 *    listAutoPadding="40"
 *    listStylePosition="outside"
 *    listStyleType="disc"
 *    locale="en"
 *    paragraphEndIndent="0"
 *    paragraphSpaceAfter="0"
 *    paragraphSpaceBefore="0"
 *    paragraphStartIndent="0"
 *    renderingMode="CFF"
 *    rollOverColor=""
 *    symbolColor=""
 *    tabStops="null"
 *    textAlign="start"
 *    textAlignLast="start"
 *    textAlpha="1"
 *    textDecoration="none"
 *    textIndent="0"
 *    textJustify="inter_word"
 *    textRotation="auto"
 *    trackingLeft="0"
 *    trackingRight="0"
 *    typographicCase="default"
 *    unfocusedTextSelectionColor=""
 *    verticalScrollPolicy="auto"
 *    whiteSpaceCollapse="collapse"
 *    wordSpacing="100%,50%,150%"
 *  /&gt;
 *  </pre>
 *  
 *  @see spark.core.IViewport
 *  @see spark.components.DataGroup
 *  @see spark.components.Group
 *  @see spark.components.RichEditableText
 *  @see spark.skins.spark.ScrollerSkin
 *
 *  @includeExample examples/ScrollerExample.mxml
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */

public class Scroller extends SkinnableComponent 
       implements IFocusManagerComponent, IVisualElementContainer
{
    //include "../core/Version.as";
    
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     *  The ratio that determines how far the list scrolls when pulled past its end.
     */
   // private static const PULL_TENSION_RATIO:Number = 0.5;
    
    /**
     *  @private
     *  Used so we don't have to keep allocating Point(0,0) to do coordinate conversions
     *  while draggingg
     */
    //private static const ZERO_POINT:Point = new Point(0,0); 
    
    /**
     *  @private
     *  The name of the viewport's horizontal scroll position property
     */
   // private static const HORIZONTAL_SCROLL_POSITION:String = "horizontalScrollPosition";
    
    /**
     *  @private
     *  The name of the viewport's vertical scroll position property
     */
  //  private static const VERTICAL_SCROLL_POSITION:String = "verticalScrollPosition";

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
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function Scroller()
    {
        super();
        typeNames = "Scroller";
        
       /*  hasFocusableChildren = true;
        focusEnabled = false;

        addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
        addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler); */
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables: Touch Scrolling
    //
    //--------------------------------------------------------------------------    
    
    /**
     *  @private
     *  Threshold for screen distance they must move to count as a scroll
     *  Based on 20 pixels on a 252ppi device.
     */
   // mx_internal var minSlopInches:Number = 0.079365; // 20.0/252.0
    
    /**
     *  @private
     *  The amount of deceleration to apply to the velocity for each effect period
     *  For a faster deceleration, you can switch this to 0.990.
     */
  //  mx_internal var throwEffectDecelFactor:Number = 0.998;
    
    /**
     *  @private
     *  When pageScrollingEnabled is true, this var specifies the minimum distance 
     *  (as a percentage of the viewport size) that the content needs to be dragged 
     *  in order to switch to an adjacent page. 
     */
  //  mx_internal var pageDragDistanceThreshold:Number = 0.5;
    
    /**
     *  @private
     *  When pageScrollingEnabled is true, this var specifies the minimum velocity 
     *  (in inches/second) that a throw needs in order to switch to an adjacent page. 
     */
  //  mx_internal var pageThrowVelocityThreshold:Number = 0.8;  
    
    /**
     *  @private
     */
   // private var scrollRangesChanged:Boolean = false;
    
    /**
     *  @private
     */
  //  private var pageScrollingChanged:Boolean = false;
    
    /**
     *  @private
     */
  //  private var snappingModeChanged:Boolean = false;

    /**
     *  @private
     */
  //  private var _pullEnabled:Boolean = true;

    /**
     *  @private
     */
  /*   mx_internal function get pullEnabled():Boolean
    {
        return _pullEnabled;    
    } */

	public function set verticalScrollPolicy(value:String):void
	{
		// not implemented
	}

    
    /**
     *  @private
     */
    /* mx_internal function set pullEnabled(value:Boolean):void
    {
		if (_pullEnabled == value)
			return;
		
        _pullEnabled = value;
        scrollRangesChanged = true;
        invalidateProperties();
    } */

    /**
     *  @private
     */
  //  private var _bounceEnabled:Boolean = true;

    /**
     *  @private
     */
   /*  mx_internal function get bounceEnabled():Boolean
    {
        return _bounceEnabled;    
    } */
    
    /**
     *  @private
     */
   /*  mx_internal function set bounceEnabled(value:Boolean):void
    {
		if (_bounceEnabled == value)
			return;
		
        _bounceEnabled = value;
        scrollRangesChanged = true;
        invalidateProperties();
    } */
    
    
    /**
     *  @private
     *  Touch Scroll Helper -- used to help figure out 
     *  scrolling velocity and other information
     */
   // private var touchScrollHelper:TouchScrollHelper;
    
    /**
     *  @private
     *  Keeps track of the horizontal scroll position
     *  before scrolling started, so we can figure out 
     *  how to related it to the dragX that are 
     *  associated with the touchScrollDrag events.
     */
   // private var hspBeforeTouchScroll:Number;
    
    /**
     *  @private
     *  Keeps track of the vertical scroll position
     *  before scrolling started, so we can figure out 
     *  how to related it to the dragY that are 
     *  associated with the touchScrollDrag events.
     */
  //  private var vspBeforeTouchScroll:Number;
    
    /**
     *  @private
     *  Effect used for touch scroll throwing
     */
  //  mx_internal var throwEffect:ThrowEffect;
    
    /**
     *  @private
     *  The final position in the throw effect's vertical motion path
     */
  //  private var throwFinalVSP:Number;
    
    /**
     *  @private
     *  The final position in the throw effect's horizontal motion path
     */
 //   private var throwFinalHSP:Number;

    /**
     *  @private
     *  Indicates whether the previous throw reached one of the maximum
     *  scroll positions (vsp or hsp) that was in effect at the time. 
     */
  //  private var throwReachedMaximumScrollPosition:Boolean;
    
    /**
     *  @private
     *  Used to keep track of whether the throw animation 
     *  was stopped pre-emptively.  We stop propogation of 
     *  the mouse event, but in the throwEffect.EFFECT_END
     *  event handler, we need to tell it not to exit the
     *  scrolling state.
     */
  //  private var stoppedPreemptively:Boolean = false;
    
    /**
     *  @private
     *  Used to keep track of whether we should capture the next 
     *  click event that we receive or whether we should let it dispatch 
     *  normally.  We capture the click event if a scroll happened.  We 
     *  set this property in mouseDown and touchScrollStart.
     */
   // private var captureNextClick:Boolean = false;
    
    /**
     *  @private
     *  Used to keep track of whether we should capture the next 
     *  mousedown event that we receive or whether we should let it dispatch 
     *  normally.  We capture the mousedown event if a scroll-throw is 
     *  currently happening.  We set this property in mouseDown, touchInteractionStart, 
     *  and touchInteractionEnd.
     */
   // private var captureNextMouseDown:Boolean = false;
    
    /**
     *  @private
     *  Animation to fade the scrollbars out when we are done
     *  throwing or dragging
     */
 //   private var hideScrollBarAnimation:Animate;
    
    /**
     *  @private
     *  Use to figure out whether the animation ended naturally and finished or 
     *  whether we called stop() on it.  Unfortunately, we get an EFFECT_END in 
     *  both cases, so we must keep track of it ourselves.
     */
 //   private var hideScrollBarAnimationPrematurelyStopped:Boolean;
    
    /**
     *  @private
     *  Keeps track of whether a touch interaction is in progress. 
     */
  //  mx_internal var inTouchInteraction:Boolean = false;
    
    
    /**
     *  @private
     *  These are the minimum and maximum scroll positions allowed
     *  for both axes. They determine the points at which bounce and
     *  pull occur.
     */
  /*   private var minVerticalScrollPosition:Number = 0;
    private var maxVerticalScrollPosition:Number = 0;
    private var minHorizontalScrollPosition:Number = 0;
    private var maxHorizontalScrollPosition:Number = 0;
     */
    /**
     *  @private
     *  The animation used by the snapElement function.
     */
   // private var snapElementAnimation:Animate;

    /**
     *  @private
     *  When pageScrollingEnabled is true, this contains the 
     *  scroll position of the current page.
     */
  //  private var currentPageScrollPosition:Number;
    

    /**
     *  @private
     *  Keeps track of the most recently snapped item, or -1 if none.
     *  This value is set as a side-effect of calling getSnappedPosition. 
     */
   // private var lastSnappedElement:int = -1;

    /**
     *  @private
     *  Remembers which part of the content is snapped at the
     *  time an orientation change begins.  For paging without
     *  item snapping, this value is a page number.  For item
     *  snapping, the value is an element number. 
     */
  //  private var orientationChangeSnapElement:int = -1;
    
    /**
     *  @private
     *  Remembers the number of pages right before an orientation
     *  change occurs.
     */
  //  private var previousOrientationPageCount:int = 0;

    

    //--------------------------------------------------------------------------
    //
    //  Variables: SoftKeyboard Support
    //
    //--------------------------------------------------------------------------  
    
    /**
     *  @private
     * 
     *  Some devices do not support a hardware keyboard. 
     *  Instead, these devices use a keyboard that opens on 
     *  the screen when necessary. 
     *  A value of <code>true</code> means that when a component in 
     *  the container wrapped by the scroller receives focus, 
     *  the Scroller scrolls that component into view if the keyboard is 
     *  opening
     */    
   // mx_internal var ensureElementIsVisibleForSoftKeyboard:Boolean = true;
    
    /**
     *  @private 
     */ 
   // private var lastFocusedElement:IVisualElement;
    
    /**
     *  @private 
     *  Used to detect when the device orientation (landscape/portrait) has changed
     */
   // private var aspectRatio:String;
    
    /**
     *  @private 
     */
   // private var oldSoftKeyboardHeight:Number = NaN;
    
    /**
     *  @private 
     */
   // private var oldSoftKeyboardWidth:Number = NaN;
    
    /**
     *  @private 
     */
  //  mx_internal var preventThrows:Boolean = false;
    
    /**
     *  @private 
     */
   // private var lastFocusedElementCaretBounds:Rectangle;
    
    /**
     *  @private 
     */
   // private var captureNextCaretBoundsChange:Boolean = false;
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  horizontalScrollBar
    //---------------------------------- 
    
    //[SkinPart(required="false")]
   // [Bindable]    

    /**
     *  A skin part that defines the horizontal scroll bar.
     * 
     *  This property should be considered read-only. It is only
     *  set by the Scroller's skin.
     * 
     *  This property is Bindable.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    //public var horizontalScrollBar:HScrollBar;
    
    //----------------------------------
    //  horizontalScrollBarFactory
    //---------------------------------- 
    
    //[SkinPart(required="false", type="spark.components.HScrollBar")]
    
    /**
     *  A skin part that defines the horizontal scroll bar component.
     * 
     *  The <code>horizontalScrollBar</code> skin part takes precedence over this
     *  skin part.
     * 
     *  When Scroller creates an instance of this part, it will set the
     *  <code>horizontalScrollBar</code> skin part to that instance.
     * 
     *  This property should be considered read-only. It is only
     *  set by the Scroller's skin.
     *  To access the HScrollBar instance, use <code>horizontalScrollBar</code>.
     */
   // public var horizontalScrollBarFactory:IFactory;
    
    /**
     *  Creates the horizontalScrollBar part from the horizontalScrollBarFactory part. 
     */
    /* private function ensureDeferredHScrollBarCreated():void
    {
        if (!horizontalScrollBar && horizontalScrollBarFactory)
        {
            horizontalScrollBar = HScrollBar(createDynamicPartInstance("horizontalScrollBarFactory"));
            Group(this.skin).addElement(horizontalScrollBar);
            partAdded("horizontalScrollBar", horizontalScrollBar);
        }
    } */
    
    //----------------------------------
    //  horizontalScrollInProgress
    //---------------------------------- 

    /**
     *  Storage for the horizontalScrollInProgress property  
     */
   // private var _horizontalScrollInProgress:Boolean = false;
    
    /**
     *  @private
     *  Property used to communicate with ScrollerLayout to let it 
     *  know when a horizontal scroll is in progress or not (and when 
     *  the horizontal scroll bar should be hidden or not)
     */
   /*  mx_internal function get horizontalScrollInProgress():Boolean
    {
        return _horizontalScrollInProgress;
    } */
    
    /**
     *  @private 
     */
    /* mx_internal function set horizontalScrollInProgress(value:Boolean):void
    {
        _horizontalScrollInProgress = value;
        if (value && getStyle("interactionMode") == InteractionMode.TOUCH)
            ensureDeferredHScrollBarCreated();
    } */

    //----------------------------------
    //  verticalScrollBar
    //---------------------------------- 
    
    /* [SkinPart(required="false")]
    [Bindable] */
    
    /**
     *  A skin part that defines the vertical scroll bar.
     * 
     *  This property should be considered read-only. It is only
     *  set by the Scroller's skin.
     * 
     *  This property is Bindable.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    //public var verticalScrollBar:VScrollBar;

    //----------------------------------
    //  verticalScrollBarFactory
    //---------------------------------- 
    
    //[SkinPart(required="false", type="spark.components.VScrollBar")]
    
    /**
     *  A skin part that defines the vertical scroll bar.
     * 
     *  The <code>verticalScrollBar</code> skin part takes precedence over this
     *  skin part.
     * 
     *  When Scroller creates an instance of this part, it will set the
     *  <code>verticalScrollBar</code> skin part to that instance.
     *
     *  This property should be considered read-only. It is only
     *  set by the Scroller's skin. 
     *  To access the VScrollBar instance, use <code>verticalScrollBar</code>.
     */
    //public var verticalScrollBarFactory:IFactory;
    
    /**
     *  Creates the verticalScrollBar part from the verticalScrollBarFactory part. 
     */
    /* private function ensureDeferredVScrollBarCreated():void
    {
        if (!verticalScrollBar && verticalScrollBarFactory)
        {
            verticalScrollBar = VScrollBar(createDynamicPartInstance("verticalScrollBarFactory"));
            Group(this.skin).addElement(verticalScrollBar);
            partAdded("verticalScrollBar", verticalScrollBar);
        }
    } */
    
    //----------------------------------
    //  verticalScrollInProgress
    //---------------------------------- 
    
    /**
     *  Storage for the verticalScrollInProgress property  
     */
   // private var _verticalScrollInProgress:Boolean = false;
    
    /**
     *  @private
     *  Property used to communicate with ScrollerLayout to let it 
     *  know when a vertical scroll is in progress or not (and when 
     *  the vertical scroll bar should be hidden or not)
     */
   /*  mx_internal function get verticalScrollInProgress():Boolean
    {
        return _verticalScrollInProgress;
    } */
    
    /**
     *  @private 
     */
   /*  mx_internal function set verticalScrollInProgress(value:Boolean):void
    {
        _verticalScrollInProgress = value;
        if (value && getStyle("interactionMode") == InteractionMode.TOUCH)
            ensureDeferredVScrollBarCreated();
    } */

    //----------------------------------
    //  viewport - default property
    //----------------------------------    
    
    private var _viewport:IViewport;
    
    [Bindable(event="viewportChanged")]
    
    /**
     *  The viewport component to be scrolled.
     * 
     *  <p>
     *  The viewport is added to the Scroller component's skin, 
     *  which lays out both the viewport and scroll bars.
     * 
     *  When the <code>viewport</code> property is set, the viewport's 
     *  <code>clipAndEnableScrolling</code> property is 
     *  set to true to enable scrolling.
     * 
     *  The Scroller does not support rotating the viewport directly.  The viewport's
     *  contents can be transformed arbitrarily, but the viewport itself cannot.
     * </p>
     * 
     *  This property is Bindable.
     * 
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function get viewport(): IViewport
    {       
        return _viewport;
    }
    
    /**
     *  @private
     */
    public function set viewport(value:IViewport):void
    {
        if (value == _viewport)
            return;
        
       uninstallViewport();
        _viewport = value;
        if (parent)
           installViewport();
        dispatchEvent(new Event("viewportChanged"));
    }
    
    /**
     *  @private
     *  This is used to disable thinning for automated testing.
     */
    //mx_internal static var dragEventThinning:Boolean = true;
    
    /**
     *  @private
     *  @royaleignorecoercion org.apache.royale.core.IChild
     */
    private function installViewport():void
    {
        /*  SWF?
        if (skin && viewport)
        {*/
            viewport.clipAndEnableScrolling = true;
            /*
            Group(skin).addElementAt(viewport, 0);
            viewport.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, viewport_propertyChangeHandler);
            viewport.addEventListener(Event.RESIZE, viewport_resizeHandler);
        }
        if (verticalScrollBar)
            verticalScrollBar.viewport = viewport;
        if (horizontalScrollBar)
            horizontalScrollBar.viewport = viewport;
        */
        COMPILE::JS
        {
            addElement(viewport as IChild);
        }
    } 
    
    /**
     *  @private
     *  @royaleignorecoercion org.apache.royale.core.IChild
     */
    private function uninstallViewport():void
    {
        /*
        if (horizontalScrollBar)
            horizontalScrollBar.viewport = null;
        if (verticalScrollBar)
            verticalScrollBar.viewport = null;        
        if (skin && viewport)
        {
            viewport.clipAndEnableScrolling = false;
            Group(skin).removeElement(viewport);
            viewport.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, viewport_propertyChangeHandler);
            viewport.removeEventListener(Event.RESIZE, viewport_resizeHandler);
        }
        */
        COMPILE::JS
        {
            if (viewport)
                removeElement(viewport as IChild);
        }
    }
    
    //----------------------------------
    //  minViewportInset
    //----------------------------------

    private var _minViewportInset:Number = 0;
    
    [Inspectable(category="General", defaultValue="0")]

    /**
     *  The minimum space between the viewport and the edges of the Scroller.  
     * 
     *  If neither of the scroll bars is visible, then the viewport is inset by 
     *  <code>minViewportInset</code> on all four sides.
     * 
     *  If a scroll bar is visible then the viewport is inset by <code>minViewportInset</code>
     *  or by the scroll bar's size, whichever is larger.
     * 
     *  ScrollBars are laid out flush with the edges of the Scroller.   
     * 
     *  @default 0 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Royale 0.9.4
     */
    public function get minViewportInset():Number
    {
        return _minViewportInset;
    }

    /**
     *  @private
     */
    public function set minViewportInset(value:Number):void
    {
        if (value == _minViewportInset)
            return;
            
        _minViewportInset = value;
      //  invalidateSkin();
    }

    //----------------------------------
    //  measuredSizeIncludesScrollBars
    //----------------------------------
    
    private var _measuredSizeIncludesScrollBars:Boolean = true;
    
    [Inspectable(category="General", defaultValue="true")]
    
    /**
     *  If <code>true</code>, the Scroller's measured size includes the space required for
     *  the visible scroll bars, otherwise the Scroller's measured size depends
     *  only on its viewport.
     * 
     *  <p>Components like TextArea, which "reflow" their contents to fit the
     *  available width or height may use this property to stabilize their
     *  measured size.  By default a TextArea's is defined by its <code>widthInChars</code>
     *  and <code>heightInChars</code> properties and in many applications it's preferable
     *  for the measured size to remain constant, event when scroll bars are displayed
     *  by the TextArea skin's Scroller.</p>
     * 
     *  <p>In components where the content does not reflow, like a typical List's
     *  items, the default behavior is preferable because it makes it less
     *  likely that the component's content will be obscured by a scroll bar.</p>
     * 
     *  @default true
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Royale 0.9.4
     */
    public function get measuredSizeIncludesScrollBars():Boolean
    {
        return _measuredSizeIncludesScrollBars;
    }
    
    /**
     *  @private 
     */
    public function set measuredSizeIncludesScrollBars(value:Boolean):void
    {
        if (value == _measuredSizeIncludesScrollBars)
            return;

        _measuredSizeIncludesScrollBars = value;
      //  invalidateSkin();
    }

    //----------------------------------
    //  pageScrollingEnabled
    //----------------------------------

   /*  private var _pageScrollingEnabled:Boolean = false;
    
    [Inspectable(category="General", defaultValue="false")] */
    
    /**
     *  By default, for mobile applications, scrolling is pixel based. 
     *  The final scroll location is any pixel location based on 
     *  the drag and throw gesture.
     *  Set <code>pageScrollingEnabled</code> to <code>true</code> to 
     *  enable page scrolling.
     *
     *  <p><b>Note: </b>This property is only valid when the <code>interactionMode</code> style 
     *  is set to <code>touch</code>, indicating a mobile application.</p>
     *
     *  <p>The size of the page is determined by the size of the viewport 
     *  of the scrollable component. 
     *  You can only scroll a single page at a time, regardless of the scroll gesture.</p>
     *
     *  <p>You must scroll at least 50% of the visible area of the component 
     *  to cause the page to change. 
     *  If you scroll less than 50%, the component remains on the current page. 
     *  Alternatively, if the velocity of the scroll is high enough, the next page display. 
     *  If the velocity is not high enough, the component remains on the current page.</p>
     *
     *  @default false
     *
     *  @langversion 3.0
     *  @playerversion AIR 3
     *  @productversion Royale 0.9.4
     */
   /*  public function get pageScrollingEnabled():Boolean
    {
        return _pageScrollingEnabled;
    } */

    /**
     *  @private 
     */
    /* public function set pageScrollingEnabled(value:Boolean):void
    {
        if (value == _pageScrollingEnabled)
            return;
        
        _pageScrollingEnabled = value;
        if (getStyle("interactionMode") == InteractionMode.TOUCH)
        {
            if (canScrollHorizontally && canScrollVertically)
                throw new Error(resourceManager.getString("components", "operationSupportedForOneAxisOnly"));
            
            scrollRangesChanged = true;
            pageScrollingChanged = true;
            invalidateProperties();
        }
    }
  */
    //----------------------------------
    //  scrollSnappingMode
    //----------------------------------
    
   /*  private var _scrollSnappingMode:String = ScrollSnappingMode.NONE; 

    [Inspectable(category="General", enumeration="none,leadingEdge,center,trailingEdge", defaultValue="none")]
	*/
    /**
     *  By default, for mobile applications, scrolling is pixel based. 
     *  The final scroll location is any pixel location based on 
     *  the drag and throw gesture.
     *  Set <code>scrollSnappingMode</code> to other than <code>none</code> to 
     *  enable scroll snapping.
     *  With scroll snapping enabled, 
	 *  the content snaps to a final position based on the value of <code>scrollSnappingMode</code>.
     *
     *  <p><b>Note: </b>This property is only valid when the <code>interactionMode</code> style 
     *  is set to <code>touch</code>, indicating a mobile application.</p>
     *
     *  <p>For example, you scroll a List vertically with <code>scrollSnappingMode</code> 
     *  set to a value of <code>leadingEdge</code>. 
     *  The List control snaps to a final scroll position where the top list element 
     *  is aligned to the top of the list.</p>
     *
     *  <p>Changing this property to anything other than <code>none</code> can
     *  result in an immediate change in scroll position to ensure
     *  an element is correctly snapped into position.  
     *  This change in scroll position is not animated</p>
     *
     *  <p>in MXML, the possible values are <code>"leadingEdge"</code>, <code>"center"</code>, 
     *  <code>"trailingEdge"</code>, and <code>"none"</code>.
     *  ActionScript values are defined by spark.components.ScrollSnappingMode. </p>
     *
     *  @see spark.components.ScrollSnappingMode
     *
     *  @default "none"
     *
     *  @langversion 3.0
     *  @playerversion AIR 3
     *  @productversion Royale 0.9.4
     */
    /* public function get scrollSnappingMode():String
    {
        return _scrollSnappingMode;
    } */

    /**
     *  @private 
     */
    /* public function set scrollSnappingMode(value:String):void    
    {
        if (value == _scrollSnappingMode)
            return;
        
        _scrollSnappingMode = value;
        if (getStyle("interactionMode") == InteractionMode.TOUCH)
        {
            if (canScrollHorizontally && canScrollVertically)
                throw new Error(resourceManager.getString("components", "operationSupportedForOneAxisOnly"));
            
            scrollRangesChanged = true;
            snappingModeChanged = true;
            invalidateProperties();
        }
    } */
    
	//----------------------------------
	//  maxDragRate
	//----------------------------------
	
	/* private static var _maxDragRate:Number = 30;
	
	[Inspectable(category="General", defaultValue="30")] */
	
	/**
	 *
	 *  Maximum number of times per second the scroll position
	 *  and the display will be updated while dragging.
	 *
	 *  @default 30
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.5
	 *  @productversion Royale 0.9.4
	 */
	
	/* public static function get maxDragRate():Number
	{
		return _maxDragRate;
	}
	
	public static function set maxDragRate(value:Number):void
	{
		_maxDragRate = value;
	} */
	
	
	
    //--------------------------------------------------------------------------
    // 
    // Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Scrolls the viewport so the specified element is visible.
     * 
     *  @param element A child element of the container, 
     *  or of a nested container, wrapped by the Scroller.  
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Royale 0.9.4
     */ 
   /*  public function ensureElementIsVisible(element:IVisualElement):void
    {   
        ensureElementPositionIsVisible(element);
    } */
    
    /**
     *  @private
     *  
     *  @param elementLocalBounds ensure that these bounds of the element are 
     *  visible. The bounds are in the coordinate system of the element
     *  @param doValidateNow if true, call validateNow() at the end of the 
     *  function 
     */  
    /* private function ensureElementPositionIsVisible(element:IVisualElement, 
                                                    elementLocalBounds:Rectangle = null,
                                                    entireElementVisible:Boolean = true,
                                                    doValidateNow:Boolean = true):void
    {
        // First check that the element is a descendant
        // If we are a GraphicElement, use the element's parent
        var possibleDescendant:DisplayObject = element as DisplayObject;
        
        if (element is IGraphicElement)
            possibleDescendant = IGraphicElement(element).parent as DisplayObject;
        
        if (!possibleDescendant || !contains(possibleDescendant))
            return;
        
        var layout:LayoutBase = viewportLayout;
        
        if (layout)
        {
            // Before we change the scroll position, make sure there is
            // no throw effect playing.
            if (throwEffect && throwEffect.isPlaying)
            {
                throwEffect.stop();
                snapContentScrollPosition();
            }
            
            // Scroll the element into view
            var delta:Point = layout.getScrollPositionDeltaToAnyElement(element, 
                elementLocalBounds, entireElementVisible);
            
            // Compute new delta if element is visible in the viewport bounds but is
            // clipped/obscured by the soft keyboard
            var topLevelApp:Application = FlexGlobals.topLevelApplication as Application;
            var eltBounds:Rectangle;
            var adjustForSoftKeyboard:Boolean = topLevelApp && 
                                                (!topLevelApp.resizeForSoftKeyboard) &&
                                                (stage && stage.softKeyboardRect.height > 0);
            
            if (adjustForSoftKeyboard)
            {
                eltBounds = layout.getChildElementBounds(element);
                
                // Get keyboard y-position in the scroller's coordinates
                var keyboardTopLocal:Number = this.globalToLocal(stage.softKeyboardRect.topLeft).y;
                var scrollerHeight:Number = this.getLayoutBoundsHeight();
                
                // Does the keyboard clip the scroller?
                // Is the bottom of the element clipped or outside the visible
                // scroller height?
                if ((keyboardTopLocal >= 0) &&
                    (keyboardTopLocal < scrollerHeight) && 
                    ((eltBounds.bottom - viewport.verticalScrollPosition) > keyboardTopLocal))
                {
                    // Compute a new delta to accomodate the soft keyboard
                    var dy:Number = 0;
                    
                    if (eltBounds.height > keyboardTopLocal)
                    {
                        // Top justify if the element is taller than the 
                        // scroller's visible height
                        dy = eltBounds.top;
                    }
                    else
                    {
                        // Bottom justify the element
                        dy = eltBounds.bottom - keyboardTopLocal;
                    }
                    
                    var dx:Number = (delta) ? delta.x : 0;
                    
                    // account for current verticalScrollPosition
                    delta = new Point(dx, dy - viewport.verticalScrollPosition);
                }
            }
            
            if (delta)
            {
                viewport.horizontalScrollPosition += delta.x; 
                viewport.verticalScrollPosition += delta.y;
                
                // We only care about focusThickness if we are positioning the whole element 
                if (!elementLocalBounds)
                {
                    if (!eltBounds)
                        eltBounds = layout.getChildElementBounds(element);
                    
                    var focusThickness:Number = 0;
                
                    if (element is IStyleClient)
                        focusThickness = IStyleClient(element).getStyle("focusThickness");
                    
                    // Make sure that the focus ring is visible. Top and left sides have priority
                    if (focusThickness)
                    {
                        if (viewport.verticalScrollPosition > eltBounds.top - focusThickness)
                            viewport.verticalScrollPosition = eltBounds.top - focusThickness;
                        else if (viewport.verticalScrollPosition + height < eltBounds.bottom + focusThickness)
                            viewport.verticalScrollPosition = eltBounds.bottom + focusThickness - height;
                        
                        if (viewport.horizontalScrollPosition > eltBounds.left - focusThickness)
                            viewport.horizontalScrollPosition = eltBounds.left - focusThickness;
                        else if (viewport.horizontalScrollPosition + width < eltBounds.right + focusThickness)
                            viewport.horizontalScrollPosition = eltBounds.right + focusThickness - width;
                    }
                }
                
                if (doValidateNow && viewport is UIComponent)
                    UIComponent(viewport).validateNow();
            }
        }
    } */
    
    /**
     *  @private
     *  Internal API for programmatically snapping to a particular element.
     *  Can optionally animate the position change.
     */
    /* mx_internal function snapElement(elementIndex:int,animate:Boolean):Animate
    {
        var layout:LayoutBase = viewportLayout;
        if (!layout)
            throw new Error(resourceManager.getString("components", "operationRequiresViewportLayout"));

        var elementBounds:Rectangle = layout.getElementBounds(elementIndex);
        var snapScrollPosition:Number;
        
        // Find the scroll position that puts the specified element into 
        // the appropriate snapped position.
        switch (scrollSnappingMode)
        {
            case ScrollSnappingMode.NONE:
            {
                throw new Error(resourceManager.getString("components", "operationRequiresSnappingMode"));
            }
                
            case ScrollSnappingMode.LEADING_EDGE:
            {
                if (canScrollHorizontally)
                    snapScrollPosition = elementBounds.left;
                    
                else if (canScrollVertically)
                    snapScrollPosition = elementBounds.top;
                break;        
            }
            case ScrollSnappingMode.CENTER:
            {
                if (canScrollHorizontally)
                    snapScrollPosition = elementBounds.left + elementBounds.width/2 - viewport.width/2;
                else if (canScrollVertically)
                    snapScrollPosition = elementBounds.top + elementBounds.height/2 - viewport.height/2;
                break;        
            }
            case ScrollSnappingMode.TRAILING_EDGE:                
            {
                if (canScrollHorizontally)
                    snapScrollPosition = elementBounds.right - viewport.width;
                else if (canScrollVertically)
                    snapScrollPosition = elementBounds.bottom - viewport.height;
                break;
            }
        }
        
        var scrollProperty:String;
        if (canScrollHorizontally)
            scrollProperty = HORIZONTAL_SCROLL_POSITION;
        else if (canScrollVertically)
            scrollProperty = VERTICAL_SCROLL_POSITION;
        
        // If there's an animation playing, we need 	 
        // to stop it before we snap the element into 	 
        // position. 	 
        stopAnimations(); 	 
        
        if (animate)
        {
            if (!snapElementAnimation)
            {
                snapElementAnimation = new Animate();
                snapElementAnimation.duration = 300;
                snapElementAnimation.target = viewport;
            }
            var snapMotionPath:Vector.<MotionPath> = Vector.<MotionPath>([new SimpleMotionPath(scrollProperty, null, snapScrollPosition)]);
            snapElementAnimation.motionPaths = snapMotionPath;
            snapElementAnimation.play();

            // If paging is enabled, make sure the destination snap position
            // also becomes the current page.
            if (pageScrollingEnabled)
                currentPageScrollPosition = snapScrollPosition; 			

            return snapElementAnimation;
        }
        else
        {
			if (scrollProperty)
           		viewport[scrollProperty] = snapScrollPosition;
			
			return null;
        }
    } */
    
    /** 	 
     *  @private 	 
     */ 	 
    /* mx_internal function stopAnimations():void 	 
    { 	 
        if (throwEffect && throwEffect.isPlaying) 	 
            throwEffect.stop(); 	 
        if (snapElementAnimation && snapElementAnimation.isPlaying) 	 
            snapElementAnimation.stop(); 	 
    } 	 */ 
    
    //--------------------------------------------------------------------------
    // 
    // Event Handlers
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private 
     */
    /* private function getCurrentPageCount():int
    {
        var viewportWidth:Number = isNaN(viewport.width) ? 0 : viewport.width;
        var viewportHeight:Number = isNaN(viewport.height) ? 0 : viewport.height;
        
        var pageCount:int = 0;
        
        if (canScrollHorizontally && viewportWidth != 0)
        {
            pageCount = Math.ceil(viewport.contentWidth / viewportWidth);
        }
        else if (canScrollVertically && viewportHeight != 0)
        {
            pageCount = Math.ceil(viewport.contentHeight/ viewportHeight);
        }
        
        return pageCount;
    } */
    
    /**
     *  @private 
     */
    /* private function checkScrollPosition():void
    {
        // TODO (eday): This function is a mess.  It needs to be refactored and simplified.
        // It does too many things and has too many subtle behaviors.  But as I'm 
        // writing this we're too late in the release (4.6) schedule to make any
        // changes of that size.  This should be revisited during 5.0 development.
        
        // If the content size has changed, we may need to recalculate
        // the minimum and maximum scroll positions.
        determineScrollRanges();
        
        // Determine whether there's been a device orientation change
        // Note:  the first time this code runs it may falsely appear as though an orientation 
        // change has occurred (aspectRatio is null).  This is okay since there will be no 
        // throw animation playing, so orientationChange will not be acted upon.
        var orientationChange:Boolean = aspectRatio != FlexGlobals.topLevelApplication.aspectRatio;
        aspectRatio = FlexGlobals.topLevelApplication.aspectRatio;
        
        // See whether we possibly need to re-throw because of changed max positions.
        var needRethrow:Boolean = false;
        
        // Here we check to see whether the current throw has maybe not gone far enough
        // given the new content size. 
        // We don't rethrow for this reason in paging mode, as we don't want to go any further
        // than to the adjacent page.
        if (!pageScrollingEnabled)
        {
            if (throwReachedMaximumScrollPosition && (throwFinalVSP < maxVerticalScrollPosition || throwFinalHSP < maxHorizontalScrollPosition))
                needRethrow = true;                
            
            if (throwFinalVSP > maxVerticalScrollPosition || throwFinalHSP > maxHorizontalScrollPosition)
                needRethrow = true;
        }

        // See whether we possibly need to re-throw because the final snapped position is
        // no longer snapped.  This can occur when the snapped position was estimated due to virtual
        // layout, and the actual snapped position (i.e. once the relevent elements have been measured)
        // turns out to be different.
        // We also do this when pageScrolling is enabled to make sure we snap to a valid page position
        // after an orientation change - since an orientation change necessarily moves all the page
        // boundaries.
        if (scrollSnappingMode != ScrollSnappingMode.NONE || pageScrollingEnabled)
        {
            // NOTE: a lighter-weight way of doing this would be to retain the element
            // at the end of the throw and see whether its bounds have changed.
            if (canScrollHorizontally)
                if (getSnappedPosition(throwFinalHSP, HORIZONTAL_SCROLL_POSITION) != throwFinalHSP)
                    needRethrow = true;
            
            if (canScrollVertically)
                if (getSnappedPosition(throwFinalVSP, VERTICAL_SCROLL_POSITION) != throwFinalVSP)
                    needRethrow = true;
        }
        
        if (throwEffect && throwEffect.isPlaying && needRethrow)
        {
            // There's currently a throw animation playing, and it's throwing to a 
            // now-incorrect position.
            if (orientationChange)
            {
                // The throw end position became invalid because the device
                // orientation changed.  In this case, we just want to stop
                // the throw animation and snap to valid positions.  We don't
                // want to animate to the final position because this may
                // require changing directions relative to the current throw,
                // which looks strange.
                throwEffect.stop();
                snapContentScrollPosition();
            }
            else
            {
                // The size of the content may have changed during the throw.
                // In this case, we'll stop the current animation and start
                // a new one that gets us to the correct position.
                
                // Get the effect's current velocity
                var velocity:Point = throwEffect.getCurrentVelocity();
                
                // Stop the existing throw animation now that we've determined its current velocities.
                stoppedPreemptively = true;
                throwEffect.stop();
                stoppedPreemptively = false;
                
                // Now perform a new throw to get us to the right position.
                if (setUpThrowEffect(-velocity.x, -velocity.y))
                    throwEffect.play();
            }
        }
        else if (!inTouchInteraction)
        {
            // No touch interaction is in effect, but the content may be sitting at
            // a scroll position that is now invalid.  If so, snap the content to
            // a valid position.  The most likely reason we get here is that the
            // device orientation changed while the content is stationary (i.e. not
            // in an animated throw)
            
            // If the orientation changed and orientationChangeSnapElement is set to a 
            // valid value, then we will attempt to snap to the same item/page that
            // was snapped prior to the orientation change.
            if (orientationChange && orientationChangeSnapElement != -1)
            {
                if (scrollSnappingMode == ScrollSnappingMode.NONE && pageScrollingEnabled)
                {
                    // Paging without item snapping.  We want to snap to the same page, as
                    // long as the number of pages is the same.
                    // The number of pages being different indicates that the relationship
                    // between pages and content is unknown, and it makes no sense to try and 
                    // retain the same page.
                    if (previousOrientationPageCount == getCurrentPageCount())
                    {
                        var viewportWidth:Number = isNaN(viewport.width) ? 0 : viewport.width;
                        var viewportHeight:Number = isNaN(viewport.height) ? 0 : viewport.height;
                        
                        if (canScrollHorizontally)
                        {
                            viewport.horizontalScrollPosition = orientationChangeSnapElement * viewportWidth; 
                            currentPageScrollPosition = viewport.horizontalScrollPosition;  
                        }

                        else if (canScrollVertically)
                        {
                            viewport.verticalScrollPosition = orientationChangeSnapElement * viewportHeight; 
                            currentPageScrollPosition = viewport.verticalScrollPosition;  
                        }
                    }
                }
                else
                {
                    // Snap directly to the item that was snapped before the orientation changed.
                    // If this results in an invalid scroll position for the new orientation, the
                    // call to snapContentScrollPosition below will fix this. 
                    snapElement(orientationChangeSnapElement,false);
                }
                orientationChangeSnapElement = -1;
            }
            snapContentScrollPosition();
        }
    } */
    
    
    /**
     *  @private 
     */
    /* private function handleSizeChange():void
    {
        // The content size has changed, so the current scroll
        // position and/or any in-progress throw may need to be adjusted.
        checkScrollPosition();

        // See whether the current page scroll position still needs to be initialized.
        if (pageScrollingEnabled && isNaN(currentPageScrollPosition))
            determineCurrentPageScrollPosition();
    }*/
        
    /**
     *  @private 
     *  Determines the minimum/maximum allowed scroll positions 
     *  when in leading-edge snapping mode
     */
    /*private function determineLeadingEdgeSnappingScrollRanges():void
    {
        var layout:LayoutBase = viewportLayout;
        var maxPositionItemIndex:int;
        var maxPositionItemBounds:Rectangle;
        
        // Locate the element nearest the leading edge: top for vertical scrolling, left for horizontal.
        var firstItemIndex:int = layout.getElementNearestScrollPosition(new Point(0, 0), "topLeft");
        var firstItemBounds:Rectangle = layout.getElementBounds(firstItemIndex);
        if (canScrollHorizontally)
        {
            // The minimum scroll position aligns the first element's leading (left) edge
            // with the left edge of the viewport.
            minHorizontalScrollPosition = firstItemBounds.left;
            
            // The maximum scroll position is one which aligns an element's leading edge 
            // with the leading edge of the viewport, but also leaves the last element
            // fully visible.
            var viewportWidth:Number = isNaN(viewport.width) ? 0 : viewport.width;
            maxPositionItemIndex = layout.getElementNearestScrollPosition(new Point(viewport.contentWidth-viewportWidth, 0), "topLeft");
            do
            {
                maxPositionItemBounds = layout.getElementBounds(maxPositionItemIndex);
                if ((viewport.contentWidth - maxPositionItemBounds.left) <= viewportWidth)
                    break;
            }
            while (++maxPositionItemIndex < layout.target.numElements); 
            maxHorizontalScrollPosition = maxPositionItemBounds.left;
        }
        else if (canScrollVertically)
        {
            // The minimum scroll position aligns the first element's leading (left) edge
            // with the left edge of the viewport.
            minVerticalScrollPosition = firstItemBounds.top; 
            
            // The maximum scroll position is one which aligns an element's leading edge 
            // with the leading edge of the viewport, but also leaves the last element
            // fully visible.
            var viewportHeight:Number = isNaN(viewport.height) ? 0 : viewport.height;
            maxPositionItemIndex = layout.getElementNearestScrollPosition(new Point(0, viewport.contentHeight-viewportHeight), "topLeft");
            do
            {
                maxPositionItemBounds = layout.getElementBounds(maxPositionItemIndex);
                if ((viewport.contentHeight - maxPositionItemBounds.top) <= viewportHeight)
                    break;
            }
            while (++maxPositionItemIndex < layout.target.numElements); 
            maxVerticalScrollPosition = maxPositionItemBounds.top; 
        }
    } */

    /**
     *  @private
     *  Determines the minimum/maximum allowed scroll positions 
     *  when in center snapping mode
     */
    /* private function determineCenterSnappingScrollRanges():void
    {
        var layout:LayoutBase = viewportLayout;
        var leadingItemIndex:int;
        var leadingItemBounds:Rectangle;
        var trailingItemIndex:int;
        var trailingItemBounds:Rectangle;
        
        // For center snapping mode, the min/max positions must be set such that
        // any element in the layout can be scrolled into the center position.
        
        // Find the element nearest the zero point.
        leadingItemIndex = layout.getElementNearestScrollPosition(new Point(0, 0), "center");
        leadingItemBounds = layout.getElementBounds(leadingItemIndex);
        
        if (canScrollHorizontally)
        {
            var viewportWidth:Number = isNaN(viewport.width) ? 0 : viewport.width;
            trailingItemIndex = layout.getElementNearestScrollPosition(new Point(viewport.contentWidth, 0), "center");
            trailingItemBounds = layout.getElementBounds(trailingItemIndex);
            minVerticalScrollPosition = maxVerticalScrollPosition = 0;

            // Calculate the scroll position that puts the first element into the center.
            minHorizontalScrollPosition = leadingItemBounds.left + (leadingItemBounds.width/2) - (viewportWidth/2);
            
            // Calculate the scroll position that puts the last element into the center.
            maxHorizontalScrollPosition = trailingItemBounds.left + (trailingItemBounds.width/2) - (viewportWidth/2);
        }
        else if (canScrollVertically)
        {
            var viewportHeight:Number = isNaN(viewport.height) ? 0 : viewport.height;
            trailingItemIndex = layout.getElementNearestScrollPosition(new Point(0, viewport.contentHeight), "center");
            trailingItemBounds = layout.getElementBounds(trailingItemIndex);
            minHorizontalScrollPosition = maxHorizontalScrollPosition = 0;
            
            // Calculate the scroll position that puts the first element into the center.
            minVerticalScrollPosition = leadingItemBounds.top + (leadingItemBounds.height/2) - (viewportHeight/2);
            
            // Calculate the scroll position that puts the last element into the center.
            maxVerticalScrollPosition = trailingItemBounds.top + (trailingItemBounds.height/2) - (viewportHeight/2);
        }
    } */
                
    /**
     *  @private
     *  Determines the minimum/maximum allowed scroll positions 
     *  when in trailing-edge snapping mode
     */
    /* private function determineTrailingEdgeSnappingScrollRanges():void
    {
        var layout:LayoutBase = viewportLayout;
        var snappedItemIndex:int;
        var snappedItemBounds:Rectangle;
        var lastItemIndex:int;
        var lastItemBounds:Rectangle;
        
        if (canScrollHorizontally)
        {
            // The max scroll position is the one which aligns the last element's right edge 
            // with the viewport's right edge
            var viewportWidth:Number = isNaN(viewport.width) ? 0 : viewport.width;
            lastItemIndex = layout.getElementNearestScrollPosition(new Point(viewport.contentWidth, 0), "bottomRight");
            lastItemBounds = layout.getElementBounds(lastItemIndex);
            maxHorizontalScrollPosition = lastItemBounds.right - viewportWidth;
            
            // The minimum scroll position is the one which aligns an element's right edge with the 
            // right edge of the viewport, but also leaves the first element fully visible.
            snappedItemIndex = layout.getElementNearestScrollPosition(new Point(viewportWidth, 0), "bottomRight");
            do
            {
                snappedItemBounds = layout.getElementBounds(snappedItemIndex);
                if (snappedItemBounds.right <= viewportWidth)
                    break;
            }
            while (--snappedItemIndex >= 0); 
            minHorizontalScrollPosition = snappedItemBounds.right - viewportWidth; 
        }
        else if (canScrollVertically)
        {
            // The max scroll position is the one which aligns the last element's bottom edge 
            // with the viewport's bottom edge
            var viewportHeight:Number = isNaN(viewport.height) ? 0 : viewport.height;
            lastItemIndex = layout.getElementNearestScrollPosition(new Point(0, viewport.contentHeight), "bottomRight");
            lastItemBounds = layout.getElementBounds(lastItemIndex);
            maxVerticalScrollPosition = lastItemBounds.bottom - viewportHeight;
            
            // The minimum scroll position is the one which aligns an element's right edge with the 
            // right edge of the viewport, but also leaves the first element fully visible.
            snappedItemIndex = layout.getElementNearestScrollPosition(new Point(0, viewportHeight), "bottomRight");
            do
            {
                snappedItemBounds = layout.getElementBounds(snappedItemIndex);
                if (snappedItemBounds.bottom <= viewportHeight)
                    break;
            }
            while (--snappedItemIndex >= 0); 
            minVerticalScrollPosition = snappedItemBounds.bottom - viewportHeight; 
        }
    } */
    
    /**
     *  @private
     *  Determines the minimum/maximum allowed scroll positions. 
     */
    /* private function determineScrollRanges():void
    {
        minVerticalScrollPosition = maxVerticalScrollPosition = 0;
        minHorizontalScrollPosition = maxHorizontalScrollPosition = 0;
        
        if (viewport)
        {
            var viewportHeight:Number = isNaN(viewport.height) ? 0 : viewport.height;
            var viewportWidth:Number = isNaN(viewport.width) ? 0 : viewport.width;
            
            // For now, having both bounce and pull disabled puts us into a sort of
            // "endless" scrolling mode, in which there are practically no minimum/maximum
            // edges to bounce/pull against.
            // TODO (eday): bounce and pull probably don't need to be controlled separately.  These 
            // should be combined into a single property.
            if (!bounceEnabled && !pullEnabled)
            {
                minVerticalScrollPosition = minHorizontalScrollPosition = -Number.MAX_VALUE;
                maxVerticalScrollPosition = maxHorizontalScrollPosition = Number.MAX_VALUE;
            }
            else if (scrollSnappingMode == ScrollSnappingMode.NONE)
            {
                var remaining:Number;
                maxVerticalScrollPosition = viewport.contentHeight > viewportHeight ? 
                    viewport.contentHeight-viewportHeight : 0; 
                if (pageScrollingEnabled && canScrollVertically && viewportHeight != 0)
                {
                    // If the content height isn't an exact multiple of the viewport height,
                    // then we make sure the max scroll position allows for a full page (including
                    // padding) at the end.
                    remaining = viewport.contentHeight % viewportHeight;
                    if (remaining)
                        maxVerticalScrollPosition += viewportHeight - remaining;                  
                }
                
                maxHorizontalScrollPosition = viewport.contentWidth > viewportWidth ? 
                    viewport.contentWidth-viewportWidth : 0;
                if (pageScrollingEnabled && canScrollHorizontally && viewportWidth != 0)
                {
                    // If the content width isn't an exact multiple of the viewport width,
                    // then we make sure the max scroll position allows for a full page (including
                    // padding) at the end.
                    remaining = viewport.contentWidth % viewportWidth;
                    if (remaining)
                        maxHorizontalScrollPosition += viewportWidth - remaining;                  
                }
            }
            else
            {
                var layout:LayoutBase = viewportLayout;
                
                // Nothing to do if there is no layout or no layout elements
                if (!layout || layout.target.numElements == 0) 
                    return;
                
                // Nothing to do if the viewport dimensions have not been set yet
                if ((canScrollHorizontally && viewportWidth == 0) || (canScrollVertically && viewportHeight == 0)) 
                    return;
                
                switch (scrollSnappingMode)
                {
                    case ScrollSnappingMode.LEADING_EDGE:
                        determineLeadingEdgeSnappingScrollRanges();
                        break;
                    case ScrollSnappingMode.CENTER:
                        determineCenterSnappingScrollRanges();
                        break;
                    case ScrollSnappingMode.TRAILING_EDGE:                
                        determineTrailingEdgeSnappingScrollRanges();
                        break;
                }
            }
        }
        if (verticalScrollBar)
        {
            verticalScrollBar.contentMinimum = minVerticalScrollPosition;
            verticalScrollBar.contentMaximum = maxVerticalScrollPosition;
        }
        if (horizontalScrollBar)
        {
            horizontalScrollBar.contentMinimum = minHorizontalScrollPosition;
            horizontalScrollBar.contentMaximum = maxHorizontalScrollPosition;
        }
    } */

    /**
     *  @private 
     */
    /* private function determineCurrentPageScrollPosition():void
    {
        if (canScrollHorizontally)
        {
            viewport.horizontalScrollPosition = getSnappedPosition(viewport.horizontalScrollPosition,HORIZONTAL_SCROLL_POSITION);
            currentPageScrollPosition = viewport.horizontalScrollPosition;
        }
        else if (canScrollVertically)
        {
            viewport.verticalScrollPosition = getSnappedPosition(viewport.verticalScrollPosition,VERTICAL_SCROLL_POSITION);
            currentPageScrollPosition = viewport.verticalScrollPosition;
        }
    } */
    
    /**
     *  @private 
     */
    /* private function handleSizeChangeOnUpdateComplete(event:FlexEvent):void
    {
        viewport.removeEventListener(FlexEvent.UPDATE_COMPLETE, 
            handleSizeChangeOnUpdateComplete);
        
        handleSizeChange();
    } */
    
    /**
     *  @private 
     */
    /* private function viewport_resizeHandler(event:Event):void
    {
        if (getStyle("interactionMode") == InteractionMode.TOUCH)
        {
            // If the viewport dimensions have changed, then we may need to update the
            // scroll ranges and snap the scroll position per the new viewport size.
            viewport.addEventListener(FlexEvent.UPDATE_COMPLETE, 
                handleSizeChangeOnUpdateComplete);
        }
    } */
    
    /**
     *  @private 
     */
    /* private function viewport_propertyChangeHandler(event:PropertyChangeEvent):void
    {
        switch(event.property) 
        {
            case "contentWidth": 
            case "contentHeight": 
                invalidateSkin();
                if (getStyle("interactionMode") == InteractionMode.TOUCH)
                {
                    // If the content size changed, then the valid scroll position ranges 
                    // may have changed.  In this case, we need to schedule an updateComplete 
                    // handler to check and potentially correct the scroll positions. 
                    viewport.addEventListener(FlexEvent.UPDATE_COMPLETE, 
                        handleSizeChangeOnUpdateComplete);
                }
                break;

            case VERTICAL_SCROLL_POSITION:
            case HORIZONTAL_SCROLL_POSITION:
                if (getStyle("interactionMode") == InteractionMode.TOUCH)
                {
                    // Determine whether the scroll position is being modified programmatically (i.e.
                    // not due to a touch interaction or animation)
                    if (!inTouchInteraction && (!snapElementAnimation || !snapElementAnimation.isPlaying))
                    {
                        // We need to ensure the scroll position is always an appropriately snapped value.
                        if (!settingScrollPosition)
                        {
                            settingScrollPosition = true;
                            viewport[event.property] = getSnappedPosition(Number(event.newValue), String(event.property));
                            settingScrollPosition = false;
                        }
                        
                        // Reset the page scroll position from the programmatically-changed scroll position. 
                        if (canScrollHorizontally && event.property == HORIZONTAL_SCROLL_POSITION)
                            currentPageScrollPosition = viewport.horizontalScrollPosition;
                        if (canScrollVertically && event.property == VERTICAL_SCROLL_POSITION)
                            currentPageScrollPosition = viewport.verticalScrollPosition;
                    }
                    else if (throwEffect && throwEffect.isPlaying && throwEffect.isSnapping)
                    {
                        // If a throw animation is playing just to snap an element into position,
                        // then we want to stop the animation as soon as the final position is reached
                        // to avoid very short snaps taking a relatively long time to complete.
                        if (Math.abs(viewport.horizontalScrollPosition - throwEffect.finalPosition.x) < 1 &&
                            Math.abs(viewport.verticalScrollPosition - throwEffect.finalPosition.y) < 1)
                        {
                            throwEffect.stop();
                            snapContentScrollPosition();
                        }
                    }
                }
                break;
        }
    } */
    
    // This keeps us from infinitely recursing while changing a scroll position from 
    // within the scroll position change handler.
    //private var settingScrollPosition:Boolean = false;
    
    /**
     *  @private 
     *  Listens for any focusIn events from descendants 
     */ 
    /* override protected function focusInHandler(event:FocusEvent):void
    {
        super.focusInHandler(event);
        
		var fm:IFocusManager = focusManager;
		
        // When we gain focus, make sure the focused element is visible
        if (fm && viewport && ensureElementIsVisibleForSoftKeyboard)
        {
            var elt:IVisualElement = fm.getFocus() as IVisualElement; 
            lastFocusedElement = elt;
        }
    } */
    
    /**
     *  @private
     */ 
    /* override protected function focusOutHandler(event:FocusEvent):void
    {
        super.focusOutHandler(event);
        lastFocusedElement = null;
    } */
    
    /**
     *  @private 
     */
    /* private function orientationChangingHandler(event:Event):void
    {
        orientationChangeSnapElement = -1;
        
        // The orientation is about to change, so we see which item/page is currently snapped
        // and remember it so we can snap to it again when the orientation change is complete.
        if (scrollSnappingMode == ScrollSnappingMode.NONE && pageScrollingEnabled)
        {
            // For paging without item snapping, we remember the number of the current page.
            var viewportWidth:Number = isNaN(viewport.width) ? 0 : viewport.width;
            var viewportHeight:Number = isNaN(viewport.height) ? 0 : viewport.height;
            
            if (canScrollHorizontally && viewportWidth != 0)
                orientationChangeSnapElement = currentPageScrollPosition / viewportWidth; 
            else if (canScrollVertically && viewportHeight != 0)
                orientationChangeSnapElement = currentPageScrollPosition / viewportHeight;

            // Remember the page count so we'll know whether it changed.
            previousOrientationPageCount = getCurrentPageCount();
        }
        else if (scrollSnappingMode != ScrollSnappingMode.NONE)
        {
            // For item snapping, we remember which specific element is currently snapped. 
            
            if (canScrollHorizontally)
                getSnappedPosition(viewport.horizontalScrollPosition, HORIZONTAL_SCROLL_POSITION);
            else if (canScrollVertically)
                getSnappedPosition(viewport.verticalScrollPosition, VERTICAL_SCROLL_POSITION);
            
            // lastSnappedElement was set as a side-effect of the call to getSnappedPosition above.  
            orientationChangeSnapElement = lastSnappedElement;
        }
    
        // Force the viewport layout to clear its cache of element
        // dimensions so it can be repopulated with correct values
        // after the orientation change is complete.
        if (viewportLayout)
            viewportLayout.clearVirtualLayoutCache();
    } */
    
    //--------------------------------------------------------------------------
    //
    //  Methods: IVisualElementContainer
    //
    //--------------------------------------------------------------------------

    /**
     *  Returns 1 if there is a viewport, 0 otherwise.
     * 
     *  @return The number of visual elements in this visual container
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function get numElements():int
    {
        return viewport ? 1 : 0;
    } */
    
    /**
     *  Returns the viewport if there is a viewport and the 
     *  index passed in is 0.  Otherwise, it throws a RangeError.
     *
     *  @param index The index of the element to retrieve.
     *
     *  @return The element at the specified index.
     * 
     *  @throws RangeError If the index position does not exist in the child list.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */ 
    /* public function getElementAt(index:int):IVisualElement
    {
        if (viewport && index == 0)
            return viewport;
        else
            throw new RangeError(resourceManager.getString("components", "indexOutOfRange", [index]));
    } */
    
    /**
     *  Returns 0 if the element passed in is the viewport.  
     *  Otherwise, it throws an ArgumentError.
     *
     *  @param element The element to identify.
     *
     *  @return The index position of the element to identify.
     * 
     *  @throws ArgumentError If the element is not a child of this object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */ 
    /* public function getElementIndex(element:IVisualElement):int
    {
        if (element != null && element == viewport)
            return 0;
        else
            throw ArgumentError(resourceManager.getString("components", "elementNotFoundInScroller", [element]));
    } */
    
    /**
     * 
     *  This operation is not supported in Scroller.  
     *  A Scroller control has only one child. 
     *  Use the <code>viewport</code> property to manipulate 
     *  it.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function addElement(element:IVisualElement):IVisualElement
    {
        throw new ArgumentError(resourceManager.getString("components", "operationNotSupported"));
    } */
    
    /**
     *  This operation is not supported in Scroller.  
     *  A Scroller control has only one child.  Use the <code>viewport</code> property to manipulate 
     *  it.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function addElementAt(element:IVisualElement, index:int):IVisualElement
    {
        throw new ArgumentError(resourceManager.getString("components", "operationNotSupported"));
    } */
    
    /**
     * 
     *  This operation is not supported in Scroller.  
     *  A Scroller control has only one child.  Use the <code>viewport</code> property to manipulate 
     *  it.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function removeElement(element:IVisualElement):IVisualElement
    {
        throw new ArgumentError(resourceManager.getString("components", "operationNotSupported"));
    } */
    
    /**
     * 
     *  This operation is not supported in Scroller.  
     *  A Scroller control has only one child.  Use the <code>viewport</code> property to manipulate 
     *  it.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function removeElementAt(index:int):IVisualElement
    {
        throw new ArgumentError(resourceManager.getString("components", "operationNotSupported"));
    } */
    
    /**
     * 
     *  This operation is not supported in Scroller.  
     *  A Scroller control has only one child. Use the <code>viewport</code> property to manipulate 
     *  it.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function removeAllElements():void
    {
        throw new ArgumentError(resourceManager.getString("components", "operationNotSupported"));
    } */
    
    /**
     * 
     *  This operation is not supported in Scroller.  
     *  A Scroller control has only one child.  Use the <code>viewport</code> property to manipulate 
     *  it.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function setElementIndex(element:IVisualElement, index:int):void
    {
        throw new ArgumentError(resourceManager.getString("components", "operationNotSupported"));
    } */
    
    /**
     * 
     *  This operation is not supported in Scroller.  
     *  A Scroller control has only one child.  Use the <code>viewport</code> property to manipulate 
     *  it.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function swapElements(element1:IVisualElement, element2:IVisualElement):void
    {
        throw new ArgumentError(resourceManager.getString("components", "operationNotSupported"));
    } */
    
    /**
     * 
     *  This operation is not supported in Scroller.  
     *  A Scroller control has only one child.  Use the <code>viewport</code> property to manipulate 
     *  it.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function swapElementsAt(index1:int, index2:int):void
    {
        throw new ArgumentError(resourceManager.getString("components", "operationNotSupported"));
    } */
    
    //--------------------------------------------------------------------------
    //
    //  Private Helper Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     *  Helper method to easily invalidate the skins's size and display list.
     */
    /* private function invalidateSkin():void
    {
        if (skin)
        {
            skin.invalidateSize()
            skin.invalidateDisplayList();
        }
    } */
    
    /**
     *  @private
     *  Helper method to grab the ScrollerLayout.
     */
    /* mx_internal function get scrollerLayout():ScrollerLayout
    {
        if (skin)
            return Group(skin).layout as ScrollerLayout;
        
        return null;
    } */
    
    /**
     *  @private
     *  Helper method to grab scrollerLayout.canScrollHorizontally
     */
    /* private function get canScrollHorizontally():Boolean
    {
        var layout:ScrollerLayout = scrollerLayout;
        if (layout)
            return layout.canScrollHorizontally;

        return false;
    } */
    
    /**
     *  @private
     *  Helper method to grab scrollerLayout.canScrollVertically
     */
   /*  private function get canScrollVertically():Boolean
    {
        var layout:ScrollerLayout = scrollerLayout;
        if (layout)
            return layout.canScrollVertically;

        return false;
    } */
    
    /**
     *  @private
     *  Helper method to grab viewport.layout
     */
    /* private function get viewportLayout():LayoutBase
    {
        if (viewport is GroupBase)
            return GroupBase(viewport).layout;
        else if (viewport is SkinnableContainer)
            return SkinnableContainer(viewport).layout;
        return null;
    } */
    
    //--------------------------------------------------------------------------
    //
    //  Touch scrolling methods
    //
    //--------------------------------------------------------------------------
	
    /**
     *  @private
     *  Add touch listeners
     */
    /* private function installTouchListeners():void
    {
        addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
        addEventListener(TouchInteractionEvent.TOUCH_INTERACTION_STARTING, touchInteractionStartingHandler);
        addEventListener(TouchInteractionEvent.TOUCH_INTERACTION_START, touchInteractionStartHandler);
        addEventListener(TouchInteractionEvent.TOUCH_INTERACTION_END, touchInteractionEndHandler);
        
        // capture mouse listeners to help block click and mousedown events.
        // mousedown is blocked when a scroll is in progress
        // click is blocked when a scroll is in progress (or just finished)
        addEventListener(MouseEvent.CLICK, touchScrolling_captureMouseHandler, true);
        addEventListener(MouseEvent.MOUSE_DOWN, touchScrolling_captureMouseHandler, true);
    } */
    
    /**
     *  @private
     */
    /* private function uninstallTouchListeners():void
    {
        removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
        removeEventListener(TouchInteractionEvent.TOUCH_INTERACTION_STARTING, touchInteractionStartingHandler);
        removeEventListener(TouchInteractionEvent.TOUCH_INTERACTION_START, touchInteractionStartHandler);
        removeEventListener(TouchInteractionEvent.TOUCH_INTERACTION_END, touchInteractionEndHandler);
        
        removeEventListener(MouseEvent.CLICK, touchScrolling_captureMouseHandler, true);
        removeEventListener(MouseEvent.MOUSE_DOWN, touchScrolling_captureMouseHandler, true);
    } */
    
    /**
     *  @private
     *  This function determines whether a switch to an adjacent page is warranted, given 
     *  the distance dragged and/or the velocity thrown. 
     */
    /* private function determineNewPageScrollPosition(velocityX:Number, velocityY:Number):void
    {
        // Convert the paging velocity threshold from inches/second to pixels/millisecond 
        var minVelocityPixels:Number = pageThrowVelocityThreshold * Capabilities.screenDPI / 1000;
        
        if (canScrollHorizontally)
        {
            // Check both the throw velocity and the drag distance.  If either exceeds our threholds, then we switch to the next page.
            if (velocityX < -minVelocityPixels || viewport.horizontalScrollPosition >= currentPageScrollPosition + viewport.width * pageDragDistanceThreshold)
            {
                // Go to the next horizontal page
                // Set the new page scroll position so the throw effect animates the page into place
                currentPageScrollPosition = Math.min(currentPageScrollPosition + viewport.width, maxHorizontalScrollPosition);
            }
            else if (velocityX > minVelocityPixels || viewport.horizontalScrollPosition <= currentPageScrollPosition - viewport.width * pageDragDistanceThreshold)
            {
                // Go to the previous horizontal page
                currentPageScrollPosition = Math.max(currentPageScrollPosition - viewport.width, minHorizontalScrollPosition);     
            }
            
            // Ensure the new page position is snapped appropriately 
            currentPageScrollPosition = getSnappedPosition(currentPageScrollPosition, HORIZONTAL_SCROLL_POSITION);
        }
        else if (canScrollVertically)
        {
            // Check both the throw velocity and the drag distance.  If either exceeds our threholds, then we switch to the next page.
            if (velocityY < -minVelocityPixels || viewport.verticalScrollPosition >= currentPageScrollPosition + viewport.height * pageDragDistanceThreshold)
            {
                // Go to the next vertical page
                // Set the new page scroll position so the throw effect animates the page into place
                currentPageScrollPosition = Math.min(currentPageScrollPosition + viewport.height, maxVerticalScrollPosition);     
            }
            else if (velocityY > minVelocityPixels || viewport.verticalScrollPosition <= currentPageScrollPosition - viewport.height * pageDragDistanceThreshold)
            {
                // Go to the previous vertical page
                currentPageScrollPosition = Math.max(currentPageScrollPosition - viewport.height, minVerticalScrollPosition);     
            }

            // Ensure the new page position is snapped appropriately 
            currentPageScrollPosition = getSnappedPosition(currentPageScrollPosition, VERTICAL_SCROLL_POSITION);
        }
    } */
    
    /**
     *  @private
     *  Set up the effect to be used for the throw animation
     */
    /* private function setUpThrowEffect(velocityX:Number, velocityY:Number):Boolean
    {
        if (!throwEffect)
        {
            throwEffect = new ThrowEffect();
            throwEffect.target = viewport;
            throwEffect.addEventListener(EffectEvent.EFFECT_END, throwEffect_effectEndHandler);
        }

        var minHSP:Number = minHorizontalScrollPosition;
        var minVSP:Number = minVerticalScrollPosition;
        var maxHSP:Number = maxHorizontalScrollPosition;
        var maxVSP:Number = maxVerticalScrollPosition;

        if (pageScrollingEnabled)
        {
            // See whether a page switch is warranted for this touch gesture.
            determineNewPageScrollPosition(velocityX, velocityY);
            
            // The throw velocity is greatly attenuated in paging mode.
            // Note that this must be done after the call above to
            // determineNewPageScrollPosition which compares the velocity
            // to our threshold.
            const PAGING_VELOCITY_FACTOR:Number = 0.25; 
            velocityX *= PAGING_VELOCITY_FACTOR;
            velocityY *= PAGING_VELOCITY_FACTOR;

            // Make the scroller "lock" to the current page
            if (canScrollHorizontally)
                minHSP = maxHSP = currentPageScrollPosition;
            else if (canScrollVertically)
                minVSP = maxVSP = currentPageScrollPosition;
        }

        throwEffect.propertyNameX = canScrollHorizontally ? HORIZONTAL_SCROLL_POSITION : null;
        throwEffect.propertyNameY = canScrollVertically ? VERTICAL_SCROLL_POSITION : null;
        throwEffect.startingVelocityX = velocityX;
        throwEffect.startingVelocityY = velocityY;
        throwEffect.startingPositionX = viewport.horizontalScrollPosition;
        throwEffect.startingPositionY = viewport.verticalScrollPosition;
        throwEffect.minPositionX = minHSP;
        throwEffect.minPositionY = minVSP;
        throwEffect.maxPositionX = maxHSP;
        throwEffect.maxPositionY = maxVSP;
        throwEffect.decelerationFactor = throwEffectDecelFactor;
        
        // In snapping mode, we need to ensure that the final throw position is snapped appropriately.
        throwEffect.finalPositionFilterFunction = scrollSnappingMode == ScrollSnappingMode.NONE ? null : getSnappedPosition; 
        
        throwReachedMaximumScrollPosition = false;
        if (throwEffect.setup())
        {
            throwFinalHSP = throwEffect.finalPosition.x;
            if (canScrollHorizontally && bounceEnabled && throwFinalHSP == maxHorizontalScrollPosition)
                throwReachedMaximumScrollPosition = true;
            throwFinalVSP = throwEffect.finalPosition.y;
            if (canScrollVertically && bounceEnabled && throwFinalVSP == maxVerticalScrollPosition)
                throwReachedMaximumScrollPosition = true;
        }
        else
        {
            touchScrollHelper.endTouchScroll();
            return false;
        }
        return true;
    } */
        
    
    /**
     *  @private
     *  This function takes a scroll position and the associated property name, and finds
     *  the nearest snapped position (i.e. one that satifises the current scrollSnappingMode).
     */
    /* private function getSnappedPosition(position:Number, propertyName:String):Number
    {
        var layout:LayoutBase = viewportLayout;
        var nearestElementIndex:int = -1;
        var nearestElementBounds:Rectangle;
        
        var viewportWidth:Number = isNaN(viewport.width) ? 0 : viewport.width;
        var viewportHeight:Number = isNaN(viewport.height) ? 0 : viewport.height;

        if (scrollSnappingMode == ScrollSnappingMode.NONE && pageScrollingEnabled)
        {
            // If we're in paging mode and no snapping is enabled, then we must snap
            // the position to the beginning of a page.  i.e. a multiple of the 
            // viewport size.
            var offset:Number;
            if (canScrollHorizontally && propertyName == HORIZONTAL_SCROLL_POSITION && 
                viewportWidth != 0 && viewport.contentWidth != 0)
            {
                // Get the offset into the current page.  If less than half way, snap
                // to the beginning of the page.  Otherwise, snap to the beginning
                // of the next page
                offset = position % viewportWidth;
                if (offset < viewportWidth / 2)
                    position -= offset;
                else
                    position += viewportWidth - offset;
                
                // Clip the position to the valid min/max range
                position = Math.min(Math.max(minHorizontalScrollPosition, position), maxHorizontalScrollPosition);
            }
            else if (canScrollVertically && propertyName == VERTICAL_SCROLL_POSITION && 
                viewportHeight != 0 && viewport.contentHeight != 0)
            {
                offset = position % viewportHeight;
                if (offset < viewportHeight / 2)
                    position -= offset;
                else
                    position += viewportHeight - offset;

                // Clip the position to the valid min/max range
                position = Math.min(Math.max(minVerticalScrollPosition, position), maxVerticalScrollPosition);
            }
        }
        
        if (layout && layout.target.numElements > 0)
        {
            switch (_scrollSnappingMode)
            {
                case ScrollSnappingMode.LEADING_EDGE:
                    if (canScrollHorizontally && propertyName == HORIZONTAL_SCROLL_POSITION)
                    {
                        nearestElementIndex = layout.getElementNearestScrollPosition(new Point(position, 0), "topLeft");
                        nearestElementBounds = layout.getElementBounds(nearestElementIndex);
                        position = nearestElementBounds.left;
                    }
                    else if (canScrollVertically && propertyName == VERTICAL_SCROLL_POSITION)
                    {
                        nearestElementIndex = layout.getElementNearestScrollPosition(new Point(0, position), "topLeft");
                        nearestElementBounds = layout.getElementBounds(nearestElementIndex);
                        position = nearestElementBounds.top;
                    }
                    break;
                case ScrollSnappingMode.CENTER:
                    if (canScrollHorizontally && propertyName == HORIZONTAL_SCROLL_POSITION)
                    {
                        nearestElementIndex = layout.getElementNearestScrollPosition(new Point(position + viewportWidth/2, 0), "center");
                        nearestElementBounds = layout.getElementBounds(nearestElementIndex);
                        position = nearestElementBounds.left + (nearestElementBounds.width / 2) - (viewportWidth / 2);
                    }
                    else if (canScrollVertically && propertyName == VERTICAL_SCROLL_POSITION)
                    {
                        nearestElementIndex = layout.getElementNearestScrollPosition(new Point(0, position + viewportHeight/2), "center");
                        nearestElementBounds = layout.getElementBounds(nearestElementIndex);
                        position = nearestElementBounds.top + (nearestElementBounds.height / 2) - (viewportHeight / 2);
                    }
                    break;
                case ScrollSnappingMode.TRAILING_EDGE:                
                    if (canScrollHorizontally && propertyName == HORIZONTAL_SCROLL_POSITION)
                    {
                        nearestElementIndex = layout.getElementNearestScrollPosition(new Point(position + viewportWidth, 0), "bottomRight");
                        nearestElementBounds = layout.getElementBounds(nearestElementIndex);
                        position = nearestElementBounds.right - viewportWidth;
                    }
                    else if (canScrollVertically && propertyName == VERTICAL_SCROLL_POSITION)
                    {
                        nearestElementIndex = layout.getElementNearestScrollPosition(new Point(0, position + viewportHeight), "bottomRight");
                        nearestElementBounds = layout.getElementBounds(nearestElementIndex);
                        position = nearestElementBounds.bottom - viewportHeight;
                    }
                    break;
            }
        }
        lastSnappedElement = nearestElementIndex;
        return Math.round(position);
    } */

    /**
     *  @private
     *  When the throw or drag scroll is over, we should play a nice 
     *  animation to hide the scrollbars.
     */
    /* private function hideScrollBars():void
    {
        if (!hideScrollBarAnimation)
        {
            hideScrollBarAnimation = new Animate();
            hideScrollBarAnimation.addEventListener(EffectEvent.EFFECT_END, hideScrollBarAnimation_effectEndHandler);
            hideScrollBarAnimation.duration = 500;
            var alphaMP:Vector.<MotionPath> = Vector.<MotionPath>([new SimpleMotionPath("alpha", 1, 0)]);
            hideScrollBarAnimation.motionPaths = alphaMP;
        }
        
        // set up the target scrollbars (hsb and/or vsb)
        var targets:Array = [];
        if (horizontalScrollBar && horizontalScrollBar.visible)
        {
            targets.push(horizontalScrollBar);
        }
        
        if (verticalScrollBar && verticalScrollBar.visible)
        {
            targets.push(verticalScrollBar);
        }
        
        // we keep track of hideScrollBarAnimationPrematurelyStopped so that we know 
        // if the effect ended naturally or if we prematurely called stop()
        hideScrollBarAnimationPrematurelyStopped = false;
        
        hideScrollBarAnimation.play(targets);
    } */
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    /*override  protected function createChildren():void
    {
        super.createChildren();
        
        // Only listen for softKeyboardEvents if the 
        // softKeyboardBehavior attribute in the application descriptor equals "none"
        if (Application.softKeyboardBehavior == "none")
        {
            addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE, 
                softKeyboardActivateHandler, false, 
                EventPriority.DEFAULT, true);
            addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE, 
                softKeyboardActivateCaptureHandler, true, 
                EventPriority.DEFAULT, true);
            addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, 
                softKeyboardDeactivateHandler, false, 
                EventPriority.DEFAULT, true);  
            addEventListener(CaretBoundsChangeEvent.CARET_BOUNDS_CHANGE,
                caretBoundsChangeHandler);
        }
    } */
    
    /**
     *  @private
     */
    /* override public function styleChanged(styleProp:String):void
    {
        super.styleChanged(styleProp);
        
        var allStyles:Boolean = (styleProp == null || styleProp == "styleName");
        
        if (allStyles || styleProp == "horizontalScrollPolicy" || 
            styleProp == "verticalScrollPolicy")
        {
            invalidateSkin();
        }
        
        if (allStyles || styleProp == "interactionMode")
        {
            if (getStyle("interactionMode") == InteractionMode.TOUCH)
            {
                installTouchListeners();
                
                // Need to make sure the scroll ranges are updated now, since they may 	 
                // not have been if the scroller was in non-touch mode when the content 	 
                // was created/changed. 	 
                scrollRangesChanged = true; 	 
                invalidateProperties(); 	 
                
                if (!touchScrollHelper)
                {
                    touchScrollHelper = new TouchScrollHelper();
                    touchScrollHelper.target = this;
                    
                    // Install callbacks with the helper
                    // The dragFunction is called repeatedly during dragging/scrolling.
                    touchScrollHelper.dragFunction = performDrag;
                    
                    // The throwFunction is called once when dragging is done and the finger is released.
                    touchScrollHelper.throwFunction = performThrow;
                }
                
                // We don't support directly interacting with the scrollbars in touch mode
                if (horizontalScrollBar)
                {
                    horizontalScrollBar.mouseEnabled = false;
                    horizontalScrollBar.mouseChildren = false;
                }
                if (verticalScrollBar)
                {
                    verticalScrollBar.mouseEnabled = false;
                    verticalScrollBar.mouseChildren = false;
                }
            }
            else
            {
                // In case we're not in touch mode, we need to instantiate our deferred skin parts immediately
                // TODO (egeorgie): support deferred scrollbar parts in non-touch mode
                ensureDeferredHScrollBarCreated();
                ensureDeferredVScrollBarCreated();
                
                uninstallTouchListeners();
                
                if (horizontalScrollBar)
                {
                    horizontalScrollBar.mouseEnabled = true;
                    horizontalScrollBar.mouseChildren = true;
                }
                if (verticalScrollBar)
                {
                    verticalScrollBar.mouseEnabled = true;
                    verticalScrollBar.mouseChildren = true;
                }
            }
        }
        
        // If the liveScrolling style was set, set the scrollbars' liveDragging styles
        
        if (allStyles || styleProp == "liveScrolling")
        {
            const liveScrolling:* = getStyle("liveScrolling");
            if ((liveScrolling === true) || (liveScrolling === false))
            {
                if (verticalScrollBar)
                    verticalScrollBar.setStyle("liveDragging", Boolean(liveScrolling));
                if (horizontalScrollBar)
                    horizontalScrollBar.setStyle("liveDragging", Boolean(liveScrolling));
            }
        }
    }
	*/
    /**
     *  @private
     */
    /* override protected function attachSkin():void
    {
        super.attachSkin();
        
        if (getStyle("interactionMode") != InteractionMode.TOUCH)
        {
            // TODO (egeorgie): support deferred scrollbar parts in non-touch mode
            // In case we're not in touch mode, we need to instantiate our deferred skin parts immediately
            ensureDeferredHScrollBarCreated();
            ensureDeferredVScrollBarCreated();
        }
        
        Group(skin).layout = new ScrollerLayout();
        installViewport();
        skin.addEventListener(MouseEvent.MOUSE_WHEEL, skin_mouseWheelHandler);
    } */
    
    /**
     *  @private
     */
    /* override protected function detachSkin():void
    {    
        uninstallViewport();
        Group(skin).layout = null;
        skin.removeEventListener(MouseEvent.MOUSE_WHEEL, skin_mouseWheelHandler);
        super.detachSkin();
    } */
    
    /**
     *  @private
     */
    /* override protected function partAdded(partName:String, instance:Object):void
    {
        super.partAdded(partName, instance);
        
        const liveScrolling:* = getStyle("liveScrolling");
        const liveScrollingSet:Boolean = (liveScrolling === true) || (liveScrolling === false);
        const inTouchMode:Boolean =  (getStyle("interactionMode") == InteractionMode.TOUCH);
        
        if (instance == verticalScrollBar)
        {
            verticalScrollBar.viewport = viewport;
            if (liveScrollingSet)
                verticalScrollBar.setStyle("liveDragging", Boolean(liveScrolling));
            verticalScrollBar.contentMinimum = minVerticalScrollPosition;
            verticalScrollBar.contentMaximum = maxVerticalScrollPosition;

            // We don't support directly interacting with the scrollbars in touch mode
            if (inTouchMode)
            {
                verticalScrollBar.mouseEnabled = false;
                verticalScrollBar.mouseChildren = false;
            }
                
        }
        else if (instance == horizontalScrollBar)
        {
            horizontalScrollBar.viewport = viewport;
            if (liveScrollingSet)
                horizontalScrollBar.setStyle("liveDragging", Boolean(liveScrolling));            
            horizontalScrollBar.contentMinimum = minHorizontalScrollPosition;
            horizontalScrollBar.contentMaximum = maxHorizontalScrollPosition; 

            // We don't support directly interacting with the scrollbars in touch mode
            if (inTouchMode)
            {
                horizontalScrollBar.mouseEnabled = false;
                horizontalScrollBar.mouseChildren = false;
            }
        }
    } */
    
    /**
     *  @private
     */
    /* override protected function partRemoved(partName:String, instance:Object):void
    {
        super.partRemoved(partName, instance);
        
        if (instance == verticalScrollBar)
            verticalScrollBar.viewport = null;
        else if (instance == horizontalScrollBar)
            horizontalScrollBar.viewport = null;
    } */
    
    /**
     *  @private
     */
    /* override protected function commitProperties():void
    {
        super.commitProperties();
        
        if (scrollRangesChanged)
        {
            determineScrollRanges();
            scrollRangesChanged = false;
        }
        
        if (pageScrollingChanged)
        {
            stopAnimations();
            determineCurrentPageScrollPosition();
            pageScrollingChanged = false;
        }
        
        if (snappingModeChanged)
        {
            stopAnimations();
            snapContentScrollPosition();
            snappingModeChanged = false;                
        }
    } */
    
    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    /* override protected function keyDownHandler(event:KeyboardEvent):void
    {
        super.keyDownHandler(event);

        var vp:IViewport = viewport;
        if (!vp || event.isDefaultPrevented())
            return;

        // If a TextField has the focus, then assume it will handle all keyboard
        // events, and that it will not use Event.preventDefault().
        if (getFocus() is TextField)
            return;
    
        if (verticalScrollBar && verticalScrollBar.visible)
        {
            var vspDelta:Number = NaN;
            switch (event.keyCode)
            {
                case Keyboard.UP:
                     vspDelta = vp.getVerticalScrollPositionDelta(NavigationUnit.UP);
                     break;
                case Keyboard.DOWN:
                     vspDelta = vp.getVerticalScrollPositionDelta(NavigationUnit.DOWN);
                     break;
                case Keyboard.PAGE_UP:
                     vspDelta = vp.getVerticalScrollPositionDelta(NavigationUnit.PAGE_UP);
                     break;
                case Keyboard.PAGE_DOWN:
                     vspDelta = vp.getVerticalScrollPositionDelta(NavigationUnit.PAGE_DOWN);
                     break;
                case Keyboard.HOME:
                     vspDelta = vp.getVerticalScrollPositionDelta(NavigationUnit.HOME);
                     break;
                case Keyboard.END:
                     vspDelta = vp.getVerticalScrollPositionDelta(NavigationUnit.END);
                     break;
            }
            if (!isNaN(vspDelta))
            {
                vp.verticalScrollPosition += vspDelta;
                event.preventDefault();
            }
        }

        if (horizontalScrollBar && horizontalScrollBar.visible)
        {
            var hspDelta:Number = NaN;
            switch (event.keyCode)
            {
                case Keyboard.LEFT:
                    hspDelta = (layoutDirection == LayoutDirection.LTR) ?
                        vp.getHorizontalScrollPositionDelta(NavigationUnit.LEFT) :
                        vp.getHorizontalScrollPositionDelta(NavigationUnit.RIGHT);
                    break;
                case Keyboard.RIGHT:
                    hspDelta = (layoutDirection == LayoutDirection.LTR) ?
                        vp.getHorizontalScrollPositionDelta(NavigationUnit.RIGHT) :
                        vp.getHorizontalScrollPositionDelta(NavigationUnit.LEFT);
                    break;
                case Keyboard.HOME:
                    hspDelta = vp.getHorizontalScrollPositionDelta(NavigationUnit.HOME);
                    break;
                case Keyboard.END:                
                    hspDelta = vp.getHorizontalScrollPositionDelta(NavigationUnit.END);
                    break;
                // If there's no vertical scrollbar, then map page up/down to
                // page left,right
                case Keyboard.PAGE_UP:
                     if (!verticalScrollBar || !(verticalScrollBar.visible)) 
                     {
                         hspDelta = (LayoutDirection.LTR) ?
                             vp.getHorizontalScrollPositionDelta(NavigationUnit.LEFT) :
                             vp.getHorizontalScrollPositionDelta(NavigationUnit.RIGHT);
                     }
                     break;
                case Keyboard.PAGE_DOWN:
                     if (!verticalScrollBar || !(verticalScrollBar.visible)) 
                     {
                         hspDelta = (LayoutDirection.LTR) ?
                             vp.getHorizontalScrollPositionDelta(NavigationUnit.RIGHT) :
                             vp.getHorizontalScrollPositionDelta(NavigationUnit.LEFT);
                     }
                     break;
            }
            if (!isNaN(hspDelta))
            {
                vp.horizontalScrollPosition += hspDelta;
                event.preventDefault();
            }
        }
    } */
    
    /* private function skin_mouseWheelHandler(event:MouseEvent):void
    {
        const vp:IViewport = viewport;
        if (event.isDefaultPrevented() || !vp || !vp.visible)
            return;
            
        // Dispatch the "mouseWheelChanging" event. If preventDefault() is called
        // on this event, the event will be cancelled.  Otherwise if  the delta
        // is modified the new value will be used.
        var changingEvent:FlexMouseEvent = MouseEventUtil.createMouseWheelChangingEvent(event);
        if (!dispatchEvent(changingEvent))
        {
            event.preventDefault();
            return;
        }
        
        const delta:int = changingEvent.delta;
        
        var nSteps:uint = Math.abs(event.delta);
        var navigationUnit:uint;

        // Scroll delta "steps".  If the VSB is up, scroll vertically,
        // if -only- the HSB is up then scroll horizontally.
         
        // TODO: The problem is that viewport.validateNow() doesn’t necessarily 
        // finish the job, see http://bugs.adobe.com/jira/browse/SDK-25740.   
        // Since some imprecision in mouse-wheel scrolling is tolerable this is
        // ok for now.  For 4.next we should add Scroller API for (reliably) 
        // scrolling in different increments and refactor code like this to 
        // depend on it.  Also applies to VScroller and HScroller mouse
        // handlers.
        
        if (verticalScrollBar && verticalScrollBar.visible)
        {
            navigationUnit = (delta < 0) ? NavigationUnit.DOWN : NavigationUnit.UP;
            for (var vStep:int = 0; vStep < nSteps; vStep++)
            {
                var vspDelta:Number = vp.getVerticalScrollPositionDelta(navigationUnit);
                if (!isNaN(vspDelta))
                {
                    vp.verticalScrollPosition += vspDelta;
                    if (vp is IInvalidating)
                        IInvalidating(vp).validateNow();
                }
            }
            event.preventDefault();
        }
        else if (horizontalScrollBar && horizontalScrollBar.visible)
        {
            navigationUnit = (delta < 0) ? NavigationUnit.RIGHT : NavigationUnit.LEFT;
            for (var hStep:int = 0; hStep < nSteps; hStep++)
            {
                var hspDelta:Number = vp.getHorizontalScrollPositionDelta(navigationUnit);
                if (!isNaN(hspDelta))
                {
                    vp.horizontalScrollPosition += hspDelta;
                    if (vp is IInvalidating)
                        IInvalidating(vp).validateNow();
                }
            }
            event.preventDefault();
        }            
    } */
    
    //--------------------------------------------------------------------------
    //
    //  Event handlers: Touch Scrolling
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     *  Event handler dispatched when someone is about to start scrolling.
     */
   /*  private function touchInteractionStartingHandler(event:TouchInteractionEvent):void
    {
        // if it's us, don't do anything
        // if it's someone else and we've started scrolling, cancel this event
        // if it's someone else and we haven't started scrolling, don't do anything
        // here yet. Worry about it in the touchInteractionStartHandler().
        if (event.relatedObject != this && inTouchInteraction)
        {
            event.preventDefault();
        }
    } */
    
    /**
     *  @private
     *  Event handler dispatched when someone has started scrolling.
     */
    /* private function touchInteractionStartHandler(event:TouchInteractionEvent):void
    {
        if (event.relatedObject != this)
        {
            // if it's not us scrolling, abort our scrolling attempt
            touchScrollHelper.stopScrollWatch();
        }
        else
        {
            // we are scrolling
            captureNextClick = true;
            captureNextMouseDown = true;
            preventThrows = false;
            
            hspBeforeTouchScroll = viewport.horizontalScrollPosition;
            vspBeforeTouchScroll = viewport.verticalScrollPosition;
            
            // TODO (rfrishbe): should the ScrollerLayout just listen to 
            // Scroller events to determine this rather than doing it here.
            // Also should figure out who's in charge of fading the alpha of the
            // scrollbars...Scroller or ScrollerLayout (or even HScrollbar/VScrollbar)?
            if (canScrollHorizontally)
                horizontalScrollInProgress = true;
            
            if (canScrollVertically)
                verticalScrollInProgress = true;
            
            // need to invaliadte the ScrollerLayout object so it'll update the
            // scrollbars in overlay mode
            skin.invalidateDisplayList();
            
            // make sure our alpha is set back to normal from hideScrollBarAnimation
            if (hideScrollBarAnimation && hideScrollBarAnimation.isPlaying)
            {
                // stop the effect, but make sure our code for EFFECT_END doesn't actually 
                // run since the effect didn't end on its own.
                hideScrollBarAnimationPrematurelyStopped = true;
                hideScrollBarAnimation.stop();
            }
            
            // We only show want the scroll bars to be visible if some content might actually be
            // off screen.  We determine this by looking at the min/max scroll positions.
            if (horizontalScrollBar)
                horizontalScrollBar.alpha = (maxHorizontalScrollPosition == 0 && minHorizontalScrollPosition == 0) ? 0.0 : 1.0;
            
            if (verticalScrollBar)
                verticalScrollBar.alpha = (maxVerticalScrollPosition == 0 && minVerticalScrollPosition == 0) ? 0.0 : 1.0;
            
            inTouchInteraction = true;
        }
    } */
    
    /**
     *  @private
     *  Snap the scroll positions to valid values.
     */
    /* private function snapContentScrollPosition(snapHorizontal:Boolean = true, snapVertical:Boolean = true):void
    {
        // Note that we only snap the scroll position if content is present.  This allows existing scroll position
        // values to be retained before content is added or when it is removed/readded.
        if (snapHorizontal && viewport.contentWidth != 0)
    {
        viewport.horizontalScrollPosition = getSnappedPosition( 
            Math.min(Math.max(minHorizontalScrollPosition, viewport.horizontalScrollPosition), maxHorizontalScrollPosition),
            HORIZONTAL_SCROLL_POSITION);
        }

        if (snapVertical && viewport.contentHeight != 0)
        {
        viewport.verticalScrollPosition = getSnappedPosition( 
            Math.min(Math.max(minVerticalScrollPosition, viewport.verticalScrollPosition), maxVerticalScrollPosition),
            VERTICAL_SCROLL_POSITION);
    }
    } */
    
    /**
     *  @private
     *  Stop the effect if it's currently playing and prepare for a possible scroll
     */
    /* private function stopThrowEffectOnMouseDown():void
    {
        if (throwEffect && throwEffect.isPlaying)
        {
            // stop the effect.  we don't want to move it to its final value...we want to stop it in place
            stoppedPreemptively = true;
            throwEffect.stop();
                    
            // Snap the scroll position to the content in case the empty space beyond the edge was visible
            // due to bounce/pull.
            snapContentScrollPosition();
            
            // get new values in case we start scrolling again
            hspBeforeTouchScroll = viewport.horizontalScrollPosition;
            vspBeforeTouchScroll = viewport.verticalScrollPosition;
        }
    } */
    
    /**
     *  @private
     *  Event listeners added while a scroll/throw animation is in effect
     */
    /* private function touchScrolling_captureMouseHandler(event:MouseEvent):void
    {
        switch(event.type)
        {
            case MouseEvent.MOUSE_DOWN:
                // If we get a mouse down when the throw animation is within a few
                // pixels of its final destination, we'll go ahead and stop the 
                // touch interaction and allow the event propogation to continue
                // so other handlers can see it.  Otherwise, we'll capture the 
                // down event and start watching for the next scroll.
                
                // 5 pixels at 252dpi worked fairly well for this heuristic.
                const THRESHOLD_INCHES:Number = 0.01984; // 5/252 
                var captureThreshold:Number = Math.round(THRESHOLD_INCHES * Capabilities.screenDPI);
                
                // Need to convert the pixel delta to the local coordinate system in 
                // order to compare it to a scroll position delta. 
                captureThreshold = globalToLocal(
                    new Point(captureThreshold,0)).subtract(globalToLocal(ZERO_POINT)).x;

                if (captureNextMouseDown &&  
                    (Math.abs(viewport.verticalScrollPosition - throwFinalVSP) > captureThreshold || 
                     Math.abs(viewport.horizontalScrollPosition - throwFinalHSP) > captureThreshold))
                {
                    // Capture the down event.
                    stopThrowEffectOnMouseDown();
                    
                    // Watch for a scroll to begin.  The helper object will call our
                    // performDrag and performThrow callbacks as appropriate.
                    touchScrollHelper.startScrollWatch(
                        event,
                        canScrollHorizontally,
                        canScrollVertically,
                        Math.round(minSlopInches * Capabilities.screenDPI), 
                        dragEventThinning ? _maxDragRate : NaN);
                    event.stopImmediatePropagation();
                }
                else
                {
                    // Stop the current throw and allow the down event
                    // to propogate normally.
                    if (throwEffect && throwEffect.isPlaying)
                    {
                        throwEffect.stop();
                        snapContentScrollPosition();
                    }
                }
                break;
            case MouseEvent.CLICK:
                if (!captureNextClick)
                    return;
                
                event.stopImmediatePropagation();
                break;
        }
    } */
    
    /**
     *  @private
     *  Mousedown listener that adds the other listeners to watch for a scroll.
     */
    /* private function mouseDownHandler(event:MouseEvent):void
    {
        stopThrowEffectOnMouseDown();
        
        // If the snap animation is playing, we need to stop it 	 
        // before watching for a scroll and potentially beginning 	 
        // a new touch interaction.
        if (snapElementAnimation && snapElementAnimation.isPlaying)
        {
            snapElementAnimation.stop(); 	 

            // If paging is enabled and the user interrupted the snap animation,
            // we need to set the current page to where the animation was stopped.
            if (pageScrollingEnabled)
                determineCurrentPageScrollPosition();            
        }
                
        captureNextClick = false;
        
        // Watch for a scroll to begin.  The helper object will call our
        // performDrag and performThrow callbacks as appropriate.
        touchScrollHelper.startScrollWatch(
            event, 
            canScrollHorizontally,
            canScrollVertically,
            Math.round(minSlopInches * Capabilities.screenDPI), 
            dragEventThinning ? _maxDragRate : NaN);
    } */
    	
    /**
     *  @private
     */
    /* mx_internal function performDrag(dragX:Number, dragY:Number):void
    {
        if (textSelectionAutoScrollEnabled)
        {
            setUpTextSelectionAutoScroll();
            return;
        }

        // dragX and dragY are delta value in the global coordinate space.
        // In order to use them to change the scroll position we must convert
        // them to the scroller's local coordinate space first.
        // This code converts the deltas from global to local.
        var localDragDeltas:Point = 
            globalToLocal(new Point(dragX,dragY)).subtract(globalToLocal(ZERO_POINT));
        dragX = localDragDeltas.x;
        dragY = localDragDeltas.y;

        var xMove:int = 0;
        var yMove:int = 0;
		
        if (canScrollHorizontally)
            xMove = dragX;
        
        if (canScrollVertically)
            yMove = dragY;
        
        var newHSP:Number = hspBeforeTouchScroll - xMove;
        var newVSP:Number = vspBeforeTouchScroll - yMove;
        
        var viewportWidth:Number = isNaN(viewport.width) ? 0 : viewport.width;
        
        // If we're pulling the list past its end, we want it to move
        // only a portion of the finger distance to simulate tension.
        if (pullEnabled)
        {
            if (newHSP < minHorizontalScrollPosition)
                newHSP = Math.round(minHorizontalScrollPosition + ((newHSP-minHorizontalScrollPosition) * PULL_TENSION_RATIO));
            if (newHSP > maxHorizontalScrollPosition)
                newHSP = Math.round(maxHorizontalScrollPosition + ((newHSP-maxHorizontalScrollPosition) * PULL_TENSION_RATIO));
            
            var viewportHeight:Number = isNaN(viewport.height) ? 0 : viewport.height;
            
            if (newVSP < minVerticalScrollPosition)
                newVSP = Math.round(minVerticalScrollPosition + ((newVSP-minVerticalScrollPosition) * PULL_TENSION_RATIO));
            
            if (newVSP > maxVerticalScrollPosition)
                newVSP = Math.round(maxVerticalScrollPosition + ((newVSP-maxVerticalScrollPosition) * PULL_TENSION_RATIO));
            
            // clamp the values here
            newHSP = Math.min(Math.max(newHSP, -viewportWidth), maxHorizontalScrollPosition+viewportWidth);
            newVSP = Math.min(Math.max(newVSP, -viewportHeight), maxVerticalScrollPosition+viewportHeight);
        }
		
        viewport.horizontalScrollPosition = newHSP;
        viewport.verticalScrollPosition = newVSP;
    } */
    
    /**
     *  @private
     */ 
    /* private function throwEffect_effectEndHandler(event:EffectEvent):void
    {
        // if we stopped the effect ourself (because someone pressed down), then let's not consider
        // this the end
        if (stoppedPreemptively)
            return;
        
        touchScrollHelper.endTouchScroll();
    } */

    /**
     *  @private
     */ 
    /* mx_internal function performThrow(velocityX:Number, velocityY:Number):void
    {
        // Don't throw if we're doing a text selection auto scroll
        if (textSelectionAutoScrollEnabled)
        {
            stopTextSelectionAutoScroll();
            touchScrollHelper.endTouchScroll();
            return;
        }

        // If the soft keyboard is up (or about to come up), or 
        // we're offscreen for some reason, don't start a throw.
        if (preventThrows || !stage)
        {
            touchScrollHelper.endTouchScroll();
            return;
        }

        stoppedPreemptively = false;

        // The velocity values are deltas in the global coordinate space.
        // In order to use them to change the scroll position we must convert
        // them to the scroller's local coordinate space first.
        // This code converts the deltas from global to local.
        //        
        // Note that we scale the velocity values up and then back down around the 
        // calls to globalToLocal.  This is because the runtime only returns values
        // rounded to the nearest 0.05.  The velocities are small number (<4.0) with 
        // lots of precision that we don't want to lose.  The scaling preserves
        // a sufficient level of precision for our purposes.
        var throwVelocity:Point = new Point(velocityX, velocityY);
        throwVelocity.x *= 100000;
        throwVelocity.y *= 100000;
        
        // Because we subtract out the difference between the two coordinate systems' origins,
        // This is essentially just multiplying by a scaling factor.
        throwVelocity = 
            this.globalToLocal(throwVelocity).subtract(this.globalToLocal(new Point(0, 0)));
        
        throwVelocity.x /= 100000;
        throwVelocity.y /= 100000;
        
        if (setUpThrowEffect(throwVelocity.x, throwVelocity.y))
            throwEffect.play();
    } */
    
    /**
     *  @private
     *  When the throw is over, no need to listen for mouse events anymore.
     *  Also, use this to hide the scrollbars.
     */
/*     private function touchInteractionEndHandler(event:TouchInteractionEvent):void
    {
        if (event.relatedObject == this)
        {
            captureNextMouseDown = false;
            // don't reset captureNextClick here because touchScrollEnd
            // may be invoked on mouseUp and mouseClick occurs immediately 
            // after that, so we want to block this next mouseClick
            
            hideScrollBars();
            inTouchInteraction = false;
        }
    } */
    
    /**
     *  @private
     *  Called when the effect finishes playing on the scrollbars.  This is so ScrollerLayout 
     *  can hide the scrollbars completely and go back to controlling its visibility.
     */
    /* private function hideScrollBarAnimation_effectEndHandler(event:EffectEvent):void
    {
        // distinguish between if we called stop() and if the effect ended naturally
        if (hideScrollBarAnimationPrematurelyStopped)
            return;
        
        // now get rid of the scrollbars visibility
        horizontalScrollInProgress = false;
        verticalScrollInProgress = false;
        
        // need to invalidate the ScrollerLayout object so it'll update the
        // scrollbars in overlay mode
        skin.invalidateDisplayList();
    } */
	
	//--------------------------------------------------------------------------
	//
	//  Text selection auto scroll
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  @private
	 *  When true, use the text selection scroll behavior instead of the 
	 *  typical "throw" behavior. This is only used when interactionMode="touch"
	 */
	/* mx_internal var textSelectionAutoScrollEnabled:Boolean = false;
	private var textSelectionAutoScrollTimer:Timer;
	private var minTextSelectionVScrollPos:int = 0;
	private var maxTextSelectionVScrollPos:int = -1;
	private var minTextSelectionHScrollPos:int = 0;
	private var maxTextSelectionHScrollPos:int = -1;
	private static const TEXT_SELECTION_AUTO_SCROLL_FPS:int = 10; */
	
	/**
	 *  @private
	 *  Change scroll behavior when selecting text. 
	 */
	/* mx_internal function enableTextSelectionAutoScroll(enable:Boolean,
					   minHScrollPosition:int = 0, maxHScrollPosition:int = -1,
					   minVScrollPosition:int = 0, maxVScrollPosition:int = -1):void
	{
		if (getStyle("interactionMode") == InteractionMode.TOUCH)
		{
			this.textSelectionAutoScrollEnabled = enable;
			this.minTextSelectionHScrollPos = minHScrollPosition;
			this.maxTextSelectionHScrollPos = maxHScrollPosition;
			this.minTextSelectionVScrollPos = minVScrollPosition;
			this.maxTextSelectionVScrollPos = maxVScrollPosition;
		}
	} */
	
	/**
	 *  @private
	 */
	/* mx_internal function setUpTextSelectionAutoScroll():void
	{
		if (!textSelectionAutoScrollTimer)
		{
			textSelectionAutoScrollTimer = new Timer(1000 / TEXT_SELECTION_AUTO_SCROLL_FPS);
			textSelectionAutoScrollTimer.addEventListener(TimerEvent.TIMER, 
				textSelectionAutoScrollTimerHandler);
			
			textSelectionAutoScrollTimer.start();
		}
	} */
	
	/**
	 *  @private
	 */
	/* mx_internal function stopTextSelectionAutoScroll():void
	{
		if (textSelectionAutoScrollTimer)
		{
			textSelectionAutoScrollTimer.stop();
			textSelectionAutoScrollTimer.removeEventListener(TimerEvent.TIMER,
				textSelectionAutoScrollTimerHandler);
			textSelectionAutoScrollTimer = null;
		}
	} */
	
	/**
	 *  @private
	 */
	/* private function textSelectionAutoScrollTimerHandler(event:TimerEvent):void
	{
		const SLOW_SCROLL_THRESHOLD:int = 12;		// Distance from edge to trigger a slow scroll
		const SLOW_SCROLL_SPEED:int = 20;			// Pixels per timer callback to scroll
		const FAST_SCROLL_THRESHOLD:int = 3;		// Distance from edge to trigger a fast scroll
		const FAST_SCROLL_DELTA:int = 30; 			// Added to SLOW_SCROLL_SPEED to determine fast speed
		
		var newVSP:Number = viewport.verticalScrollPosition;
		var newHSP:Number = viewport.horizontalScrollPosition;
		
		if (canScrollHorizontally)
		{
			if (mouseX > width - SLOW_SCROLL_THRESHOLD)
			{
				newHSP += SLOW_SCROLL_SPEED;
				
				if (mouseX > width - FAST_SCROLL_THRESHOLD)
					newHSP += FAST_SCROLL_DELTA;
				
				if (maxTextSelectionHScrollPos != -1 && newHSP > maxTextSelectionHScrollPos)
					newHSP = maxTextSelectionHScrollPos;
			}
			
			if (mouseX < SLOW_SCROLL_THRESHOLD)
			{
				newHSP -= SLOW_SCROLL_SPEED;
				
				if (mouseX < FAST_SCROLL_THRESHOLD)
					newHSP -= FAST_SCROLL_DELTA;
				
				if (newHSP < minTextSelectionHScrollPos)
					newHSP = minTextSelectionHScrollPos;
    		}
		}
		
		if (canScrollVertically)
		{
			if (mouseY > height - SLOW_SCROLL_THRESHOLD)
			{
				newVSP += SLOW_SCROLL_SPEED;
				
				if (mouseY > height - FAST_SCROLL_THRESHOLD)
					newVSP += FAST_SCROLL_DELTA;
				
				if (maxTextSelectionVScrollPos != -1 && newVSP > maxTextSelectionVScrollPos)
					newVSP = maxTextSelectionVScrollPos;
			}
			
			if (mouseY < SLOW_SCROLL_THRESHOLD)
			{
				newVSP -= SLOW_SCROLL_SPEED;
				
				if (mouseY < FAST_SCROLL_THRESHOLD)
					newVSP -= FAST_SCROLL_DELTA;
				
				if (newVSP < minTextSelectionVScrollPos)
					newVSP = minTextSelectionVScrollPos;
			}
		}
		
		if (newHSP != viewport.horizontalScrollPosition)
			viewport.horizontalScrollPosition = newHSP;
		if (newVSP != viewport.verticalScrollPosition)
			viewport.verticalScrollPosition = newVSP;
	} */

    //--------------------------------------------------------------------------
    //
    //  Event handlers: SoftKeyboard Interaction
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */  
    /* private function addedToStageHandler(event:Event):void
    {
        if (getStyle("interactionMode") == InteractionMode.TOUCH)
        {
            // Note that we listen for orientationChanging in the capture phase.  This is done so we get the event 
            // before Application does to ensure that the pre-orientation-change dimensions are still in effect.
            // On iOS, Application swaps the dimensions and forces a validation in its orientationChanging handler.
            systemManager.stage.addEventListener("orientationChanging", orientationChangingHandler, true);
        }
    } */
    
    /**
     *  @private
     */
    /* private function removedFromStageHandler(event:Event):void
    {
        if (getStyle("interactionMode") == InteractionMode.TOUCH)
            systemManager.stage.removeEventListener("orientationChanging", orientationChangingHandler, true);
    } */
    
    /**
     *  @private
     *  Called when the soft keyboard is activated. 
     * 
     *  There are three use cases for Scroller and text component interaction
     * 
     *  A. Pressing a TextInput to open up the soft keyboard
     *  B. Pressing in the middle of a TextArea to open up the soft keyboard
     *  C. Pressing in a text component on a device that doesn't support soft keyboard
     * 
     *  For use case A, lastFocusedElementCaretBounds is never set, so we just
     *  call ensureElementIsVisible on the TextInput
     * 
     *  For use case B, we first get a softKeyboard active event in the 
     *  capture phase. We then receive a caretBoundsChange event from the 
     *  TextArea skin. We store the bounds in lastFocusedElementCaretBounds
     *  and use that value in the call to ensureElementPositionIsVisible in
     *  the softKeyboard activate bubble phase. 
     * 
     *  For use case C, we never receive a soft keyboard activate event, so 
     *  we just listen for caretBoundsChange. 
     */  
    /* private function softKeyboardActivateHandler(event:SoftKeyboardEvent):void
    {
        preventThrows = true;

        // Size of app has changed, so run this logic again
        var keyboardRect:Rectangle = stage.softKeyboardRect;
        
        if (keyboardRect.width > 0 && keyboardRect.height > 0)
        {
            if (lastFocusedElement && ensureElementIsVisibleForSoftKeyboard &&
                (keyboardRect.height != oldSoftKeyboardHeight ||
                 keyboardRect.width != oldSoftKeyboardWidth))
            {
                // lastFocusedElementCaretBounds might have been set in the 
                // caretBoundsChange event handler
                if (lastFocusedElementCaretBounds == null)
                {
                    ensureElementIsVisible(lastFocusedElement);
                }
                else
                {
                    // Only show entire element if we just activated the soft keyboard
                    // If the predictive text bar showed up, we don't want the
                    // the element to jump
                    var isSoftKeyboardActive:Boolean = oldSoftKeyboardHeight > 0 || oldSoftKeyboardWidth > 0;
                    ensureElementPositionIsVisible(lastFocusedElement, lastFocusedElementCaretBounds, !isSoftKeyboardActive);   
                    lastFocusedElementCaretBounds = null;
                }
            }
            
            oldSoftKeyboardHeight = keyboardRect.height;
            oldSoftKeyboardWidth = keyboardRect.width;
        }
    } */
    
    /**
     *  @private 
     *  Listen for softKeyboard activate in the capture phase so we know if
     *  we need to delay calling ensureElementPositionIsVisible if we get
     *  a caretBoundsChange event
     */ 
    /* private function softKeyboardActivateCaptureHandler(event:SoftKeyboardEvent):void
    {
        var keyboardRect:Rectangle = stage.softKeyboardRect;
        
        if (keyboardRect.width > 0 && keyboardRect.height > 0)
        {
            captureNextCaretBoundsChange = true;
        }
    } */
    
    /**
     *  @private
     *  Called when the soft keyboard is deactivated. Tells the top level 
     *  application to resize itself and fix the scroll position if necessary
     */ 
    /* private function softKeyboardDeactivateHandler(event:SoftKeyboardEvent):void
    {   
        // Adjust the scroll position after the application's size is restored. 
        adjustScrollPositionAfterSoftKeyboardDeactivate();
        oldSoftKeyboardHeight = NaN;
        oldSoftKeyboardWidth = NaN;
        preventThrows = false;
    } */
    
    /**
     *  @private
     */ 
    /* mx_internal function adjustScrollPositionAfterSoftKeyboardDeactivate():void
    {      
        // If the throw animation is still playing, stop it.
        if (throwEffect && throwEffect.isPlaying)
            throwEffect.stop();
        
        // Fix the scroll position in case we're off the end from the animation
        snapContentScrollPosition();
    } */
    
    /**
     *  @private
     * 
     *  If we just received a softKeyboardActivate event in the capture phase,
     *  we will wait until the bubble phase to call ensureElementPositionIsVisible
     *  For now, store the caret bounds to be used. 
     */
    /* private function caretBoundsChangeHandler(event:CaretBoundsChangeEvent):void
    {
        if (event.isDefaultPrevented())
            return;
        
        event.preventDefault();

        if (captureNextCaretBoundsChange)
        {
            lastFocusedElementCaretBounds = event.newCaretBounds;
            captureNextCaretBoundsChange = false;
            return;
        }
        
        // If caretBounds is changing, minimize the scroll
        ensureElementPositionIsVisible(lastFocusedElement, event.newCaretBounds, false, false);
    } */
    
    override public function addedToParent():void
    {
        super.addedToParent();
		var vp:UIComponent = _viewport as UIComponent;
		if (vp.isWidthSizedToContent())
        		vp.setWidth(width);
		if (vp.isHeightSizedToContent())
        		vp.setHeight(height);
        installViewport();
    }
    
    override public function setActualSize(w:Number, h:Number):void
    {
        super.setActualSize(w, h);
		var vp:UIComponent = _viewport as UIComponent;
		if (vp.isWidthSizedToContent())
        		vp.setWidth(width);
		if (vp.isHeightSizedToContent())
        		vp.setHeight(height);
    }
}

}
