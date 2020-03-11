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

package mx.charts
{
//    import mx.binding.BindingManager;
    import mx.charts.chartClasses.ChartBase;
    import mx.charts.events.LegendMouseEvent;
    import mx.collections.ArrayCollection;
    import mx.collections.ICollectionView;
    import mx.collections.IList;
    import mx.collections.ListCollectionView;
//    import mx.containers.utilityClasses.PostScaleAdapter;
//    import mx.core.ComponentDescriptor;
    import mx.core.ContainerCreationPolicy;
//    import mx.core.ContainerGlobals;
    import mx.core.EdgeMetrics;
    import mx.core.FlexGlobals;
//    import mx.core.FlexSprite;
    import mx.core.FlexVersion;
    import mx.core.IChildList;
//    import mx.core.IContainer;
//    import mx.core.IDeferredInstantiationUIComponent;
    import mx.core.IFlexDisplayObject;
    import mx.core.IFlexModuleFactory;
    import mx.core.IInvalidating;
//    import mx.core.ILayoutDirectionElement;
//    import mx.core.IRectangularBorder;
//    import mx.core.IRepeater;
//    import mx.core.IRepeaterClient;
    import mx.core.IUIComponent;
    import mx.core.IUITextField;
    import mx.core.IVisualElement;
    import mx.core.Keyboard;
    import mx.core.ScrollPolicy;
    import mx.core.UIComponent;
    import mx.core.mx_internal;
    import mx.display.Graphics;
//    import mx.events.ChildExistenceChangedEvent;
    import mx.events.FlexEvent;
    import mx.events.IndexChangedEvent;
//    import mx.geom.RoundedRectangle;
    import mx.managers.ILayoutManagerClient;
    import mx.managers.ISystemManager;
    import mx.styles.CSSStyleDeclaration;
    import mx.styles.ISimpleStyleClient;
    import mx.styles.IStyleClient;
//    import mx.styles.StyleProtoChain;
    
    import org.apache.royale.core.IUIBase;
    import org.apache.royale.events.Event;
    import mx.events.KeyboardEvent;
    import org.apache.royale.events.MouseEvent;
    import org.apache.royale.geom.Point;
    import org.apache.royale.geom.Rectangle;
    import org.apache.royale.reflection.getDefinitionByName;
    
    use namespace mx_internal;
    
    //--------------------------------------
    //  Events
    //--------------------------------------
    
    /**
     *  Dispatched when the user clicks on a LegendItem in the Legend control.
     *
     *  @eventType mx.charts.events.LegendMouseEvent.ITEM_CLICK
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    [Event(name="itemClick", type="mx.charts.events.LegendMouseEvent")]
    
    /**
     *  Dispatched when the user presses the mouse button
     *  while over a LegendItem in the Legend control.
     *
     *  @eventType mx.charts.events.LegendMouseEvent.ITEM_MOUSE_DOWN
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    [Event(name="itemMouseDown", type="mx.charts.events.LegendMouseEvent")]
    
    /**
     *  Dispatched when the user moves the mouse off of a LegendItem in the Legend.
     *
     *  @eventType mx.charts.events.LegendMouseEvent.ITEM_MOUSE_OUT
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    [Event(name="itemMouseOut", type="mx.charts.events.LegendMouseEvent")]
    
    /**
     *  Dispatched when the user moves the mouse over a LegendItem in the Legend control.
     *
     *  @eventType mx.charts.events.LegendMouseEvent.ITEM_MOUSE_OVER
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    [Event(name="itemMouseOver", type="mx.charts.events.LegendMouseEvent")]
    
    /**
     *  Dispatched when the user releases the mouse button
     *  while over a LegendItem in the Legend.
     *
     *  @eventType mx.charts.events.LegendMouseEvent.ITEM_MOUSE_UP
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    [Event(name="itemMouseUp", type="mx.charts.events.LegendMouseEvent")]
    
    /**
     *  Dispatched after a child has been added to a legend.
     *
     *  <p>The childAdd event is dispatched when the <code>addChild()</code>
     *  or <code>addChildAt()</code> method is called.
     *  When a container is first created, the <code>addChild()</code>
     *  method is automatically called for each child component declared
     *  in the MXML file.
     *  The <code>addChildAt()</code> method is automatically called
     *  whenever a Repeater object adds or removes child objects.
     *  The application developer may also manually call these
     *  methods to add new children.</p>
     *
     *  <p>At the time when this event is sent, the child object has been
     *  initialized, but its width and height have not yet been calculated,
     *  and the child has not been drawn on the screen.
     *  If you want to be notified when the child has been fully initialized
     *  and rendered, then register as a listener for the child's
     *  <code>creationComplete</code> event.</p>
     *
     *  @eventType mx.events.ChildExistenceChangedEvent.CHILD_ADD
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    [Event(name="childAdd", type="mx.events.ChildExistenceChangedEvent")]
    
    /**
     *  Dispatched after the index (among the legend children) 
     *  of a legend child changes.
     *  This event is only dispatched for the child specified as the argument to 
     *  the <code>setChildIndex()</code> method; it is not dispatched 
     *  for any other child whose index changes as a side effect of the call 
     *  to the <code>setChildIndex()</code> method.
     *
     *  <p>The child's index is changed when the
     *  <code>setChildIndex()</code> method is called.</p>
     *
     *  @eventType mx.events.IndexChangedEvent.CHILD_INDEX_CHANGE
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    [Event(name="childIndexChange", type="mx.events.IndexChangedEvent")]
    
    /**
     *  Dispatched before a child of a legend is removed.
     *
     *  <p>This event is delivered when any of the following methods is called:
     *  <code>removeChild()</code>, <code>removeChildAt()</code>,
     *  or <code>removeAllChildren()</code>.</p>
     *
     *  @eventType mx.events.ChildExistenceChangedEvent.CHILD_REMOVE
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    [Event(name="childRemove", type="mx.events.ChildExistenceChangedEvent")]
    
    /**
     *  Dispatched when the <code>data</code> property changes.
     *
     *  <p>When a legend is used as a renderer in a List or other components,
     *  the <code>data</code> property is used pass to the legend 
     *  the data to display.</p>
     *
     *  @eventType mx.events.FlexEvent.DATA_CHANGE
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    [Event(name="dataChange", type="mx.events.FlexEvent")]

    
    //--------------------------------------
    //  Styles
    //--------------------------------------
    
//    include "../styles/metadata/BorderStyles.as"
//    include "../styles/metadata/PaddingStyles.as"
//    include "../styles/metadata/TextStyles.as"
//    include "../styles/metadata/GapStyles.as"
    
    //--------------------------------------
    //  Styles
    //--------------------------------------
    
    /**
     *  Accent color used by component skins. The default button skin uses this color
     *  to tint the background. Slider track highlighting uses this color. 
     * 
     *  @default #0099FF
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    [Style(name="accentColor", type="uint", format="Color", inherit="yes", theme="spark")]
    
    /**
     *  If a background image is specified, this style specifies
     *  whether it is fixed with regard to the viewport (<code>"fixed"</code>)
     *  or scrolls along with the content (<code>"scroll"</code>).
     *
     *  @default "scroll"
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    [Style(name="backgroundAttachment", type="String", inherit="no")]   
    
    /**
     *  Alpha level of the color defined by the <code>backgroundColor</code>
     *  property, of the image or SWF file defined by the <code>backgroundImage</code>
     *  style.
     *  Valid values range from 0.0 to 1.0. For most controls, the default value is 1.0, 
     *  but for ToolTip controls, the default value is 0.95 and for Alert controls, the default value is 0.9.
     *  
     *  @default 1.0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    [Style(name="backgroundAlpha", type="Number", inherit="no", theme="halo, spark")]
    
    /**
     *  Background color of a component.
     *  You can have both a <code>backgroundColor</code> and a
     *  <code>backgroundImage</code> set.
     *  Some components do not have a background.
     *  The DataGrid control ignores this style.
     *  The default value is <code>undefined</code>, which means it is not set.
     *  If both this style and the <code>backgroundImage</code> style
     *  are <code>undefined</code>, the component has a transparent background.
     *
     *  <p>For the Application container, this style specifies the background color
     *  while the application loads, and a background gradient while it is running. 
     *  Flex calculates the gradient pattern between a color slightly darker than 
     *  the specified color, and a color slightly lighter than the specified color.</p>
     * 
     *  <p>The default skins of most Flex controls are partially transparent. As a result, the background color of 
     *  a container partially "bleeds through" to controls that are in that container. You can avoid this by setting the 
     *  alpha values of the control's <code>fillAlphas</code> property to 1, as the following example shows:
     *  <pre>
     *  &lt;mx:<i>Container</i> backgroundColor="0x66CC66"/&gt;
     *      &lt;mx:<i>ControlName</i> ... fillAlphas="[1,1]"/&gt;
     *  &lt;/mx:<i>Container</i>&gt;</pre>
     *  </p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    [Style(name="backgroundColor", type="uint", format="Color", inherit="no", theme="halo, spark")]
    
    /**
     *  Determines the color of a ProgressBar.
     *  A ProgressBar is filled with a vertical gradient between this color
     *  and a brighter color computed from it.
     *  This style has no effect on other components, but can be set on a container
     *  to control the appearance of all progress bars found within.
     *  The default value is <code>undefined</code>, which means it is not set. 
     *  In this case, the <code>themeColor</code> style property is used.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    [Style(name="barColor", type="uint", format="Color", inherit="yes", theme="halo")]
    
    /**
     *  The alpha of the content background for this component.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    [Style(name="contentBackgroundAlpha", type="Number", inherit="yes", theme="spark")]
    
    /**
     *  Color of the content area of the component.
     *   
     *  @default 0xFFFFFF
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */ 
    [Style(name="contentBackgroundColor", type="uint", format="Color", inherit="yes", theme="spark")]
    
    /**
     *  Radius of component corners.
     *  The default value depends on the component class;
     *  if not overridden for the class, the default value
     *  is 0.
     *  The default value for ApplicationControlBar is 5.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    [Style(name="cornerRadius", type="Number", format="Length", inherit="no", theme="halo, spark")]
    
    /**
     *  The alpha value for the overlay that is placed on top of the
     *  container when it is disabled.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    [Style(name="disabledOverlayAlpha", type="Number", inherit="no")]
    
    /**
     *  Color of focus ring when the component is in focus
     *   
     *  @default 0x70B2EE
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */ 
    [Style(name="focusColor", type="uint", format="Color", inherit="yes", theme="spark")]
    
    /**
     *  Horizontal alignment of each child inside its tile cell.
     *  Possible values are <code>"left"</code>, <code>"center"</code>, and
     *  <code>"right"</code>.
     *  If the value is <code>"left"</code>, the left edge of each child
     *  is at the left edge of its cell.
     *  If the value is <code>"center"</code>, each child is centered horizontally
     *  within its cell.
     *  If the value is <code>"right"</code>, the right edge of each child
     *  is at the right edge of its cell.
     *
     *  @default "left"
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    [Style(name="horizontalAlign", type="String", enumeration="left,center,right", inherit="no")]
    
    /**
     *  Specifies the label placement of the legend element.
     *  Valid values are <code>"top"</code>, <code>"bottom"</code>,
     *  <code>"right"</code>, and <code>"left"</code>.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    [Style(name="labelPlacement", type="String", enumeration="top,bottom,right,left", inherit="yes")]
    
    /**
     *  Specifies the height of the legend element.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    [Style(name="markerHeight", type="Number", format="Length", inherit="yes")]
    
    /**
     *  Specifies the width of the legend element.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    [Style(name="markerWidth", type="Number", format="Length", inherit="yes")]
    
    /**
     *  Number of pixels between the legend's bottom border
     *  and the bottom of its content area.
     *
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    [Style(name="paddingBottom", type="Number", format="Length", inherit="no")]
    
    /**
     *  Number of pixels between the legend's top border
     *  and the top of its content area.
     *
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    [Style(name="paddingTop", type="Number", format="Length", inherit="no")]
    
    /**
     *  Color of any symbol of a component. Examples include the check mark of a CheckBox or
     *  the arrow of a ScrollBar button.
     *   
     *  @default 0x000000
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */ 
    [Style(name="symbolColor", type="uint", format="Color", inherit="yes", theme="spark")]  
    
    /**
     *  Specifies the line stroke for the legend element.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    [Style(name="stroke", type="Object", inherit="no")]
    
    /**
     *  Vertical alignment of each child inside its tile cell.
     *  Possible values are <code>"top"</code>, <code>"middle"</code>, and
     *  <code>"bottom"</code>.
     *  If the value is <code>"top"</code>, the top edge of each child
     *  is at the top edge of its cell.
     *  If the value is <code>"middle"</code>, each child is centered vertically
     *  within its cell.
     *  If the value is <code>"bottom"</code>, the bottom edge of each child
     *  is at the bottom edge of its cell.
     *
     *  @default "top"
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    [Style(name="verticalAlign", type="String", enumeration="bottom,middle,top", inherit="no")]
    
//    [ResourceBundle("core")]
    
    //--------------------------------------
    //  Excluded APIs
    //--------------------------------------
    [Exclude(name="defaultButton", kind="property")]
    [Exclude(name="horizontalScrollPolicy", kind="property")]
    [Exclude(name="icon", kind="property")]
    [Exclude(name="label", kind="property")]
    [Exclude(name="tileHeight", kind="property")]
    [Exclude(name="tileWidth", kind="property")]
    [Exclude(name="verticalScrollPolicy", kind="property")]
    
    [Exclude(name="focusIn", kind="event")]
    [Exclude(name="focusOut", kind="event")]
    
    [Exclude(name="focusBlendMode", kind="style")]
    [Exclude(name="focusSkin", kind="style")]
    [Exclude(name="focusThickness", kind="style")]
    
    [Exclude(name="focusInEffect", kind="effect")]
    [Exclude(name="focusOutEffect", kind="effect")]
    
    
    //--------------------------------------
    //  Other metadata
    //--------------------------------------
    
    [DefaultBindingProperty(destination="dataProvider")]
    
    [DefaultTriggerEvent("itemClick")]
    
//    [IconFile("Legend.png")]
    
    /**
     *  The Legend control adds a legend to your charts,
     *  where the legend displays the label for each data series in the chart
     *  and a key showing the chart element for the series.
     *  
     *  <p>You can initialize a Legend control by binding a chart control
     *  identifier to the Legend control's <code>dataProvider</code> property,
     *  or you can define an Array of LegendItem objects.</p>
     *
     *  @mxml
     *  
     *  <p>The <code>&lt;mx:Legend&gt;</code> tag inherits all the properties
     *  of its parent classes and adds the following properties:</p>
     *  
     *  <pre>
     *  &lt;mx:Legend
     *    <strong>Properties</strong>
     *    autoLayout="true|false"
     *    clipContent="true|false"
     *    creationIndex="undefined"
     *    creationPolicy="auto|all|queued|none"
     *    dataProvider="<i>No default</i>"
     *    direction="horizontal|vertical"
     *    horizontalScrollPosition="0"
     *    legendItemClass="<i>No default</i>"
     *    verticalScrollPosition="0"   
     * 
     *    <strong>Styles</strong>
     *    backgroundAlpha="1.0"
     *    backgroundAttachment="scroll"
     *    backgroundColor="undefined"
     *    backgroundDisabledColor="undefined"
     *    backgroundImage="undefined"
     *    backgroundSize="auto" 
     *    barColor="undefined"
     *    borderColor="0xAAB3B3"
     *    borderSides="left top right bottom"
     *    borderSkin="mx.skins.halo.HaloBorder"
     *    borderStyle="inset|none|solid|outset"
     *    borderThickness="1"
     *    color="0x0B333C"
     *    cornerRadius="0"
     *    disabledColor="0xAAB3B3"
     *    disbledOverlayAlpha="undefined"
     *    dropShadowColor="0x000000"
     *    dropShadowEnabled="false"
     *    fontAntiAliasType="advanced"
     *    fontfamily="Verdana"
     *    fontGridFitType="pixel"
     *    fontSharpness="0""
     *    fontSize="10"
     *    fontStyle="normal"
     *    fontThickness="0"
     *    fontWeight="normal"
     *    horizontalAlign="left|center|right"
     *    horizontalGap="<i>8</i>"
     *    labelPlacement="right|left|top|bottom"
     *    markerHeight="15"
     *    markerWidth="10"
     *    paddingBottom="0"
     *    paddingLeft="0"
     *    paddingRight="0"
     *    paddingTop="0"
     *    shadowDirection="center"
     *    shadowDistance="2"
     *    stroke="<i>IStroke; no default</i>"
     *    textAlign="left"
     *    textDecoration="none|underline"
     *    textIndent="0"
     *    verticalAlign="top|middle|bottom"
     *    verticalGap="<i>6</i>"
     *    
     *    <strong>Events</strong>
     *    childAdd="<i>No default</i>"
     *    childIndexChange="<i>No default</i>"
     *    childRemove="<i>No default</i>"
     *    dataChange="<i>No default</i>"
     *    itemClick="<i>Event; no default</i>"
     *    itemMouseDown="<i>Event; no default</i>"
     *    itemMouseOut="<i>Event; no default</i>"
     *    itemMouseOver="<i>Event; no default</i>"
     *    itemMouseUp="<i>Event; no default</i>"
     *  /&gt;
     *  </pre>
     *
     *  @see mx.charts.LegendItem
     *
     *  @includeExample examples/PlotChartExample.mxml
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */ 
     
    public class Legend extends UIComponent// implements IContainer
        
    {
//        include "../core/Version.as"
        
        //--------------------------------------------------------------------------
        //
        //  Notes: Child management
        //
        //--------------------------------------------------------------------------
        
        /*
        
        Although at the level of a Flash DisplayObjectContainer, all
        children are equal, in a Flex Container some children are "more
        equal than others". (George Orwell, "Animal Farm")
        
        In particular, Flex distinguishes between content children and
        non-content (or "chrome") children. Content children are the kind
        that can be specified in MXML. If you put several controls
        into a VBox, those are its content children. Non-content children
        are the other ones that you get automatically, such as a
        background/border, scrollbars, the titlebar of a Panel,
        AccordionHeaders, etc.
        
        Most application developers are uninterested in non-content children,
        so Container overrides APIs such as numChildren and getChildAt()
        to deal only with content children. For example, Container, keeps
        its own _numChildren counter.
        
        Container assumes that content children are contiguous, and that
        non-content children come before or after the content children.
        In order words, Container partitions DisplayObjectContainer's
        index range into three parts:
        
        A B C D E F G H I
        0 1 2 3 4 5 6 7 8    <- index for all children
        0 1 2 3        <- index for content children
        
        The content partition contains the content children D E F G.
        The pre-content partition contains the non-content children
        A B C that always stay before the content children.
        The post-content partition contains the non-content children
        H I that always stay after the content children.
        
        Container maintains two state variables, _firstChildIndex
        and _numChildren, which keep track of the partitioning.
        In this example, _firstChildIndex would be 3 and _numChildren
        would be 4.
        
        */
        
        //--------------------------------------------------------------------------
        //
        //  Class constants
        //
        //--------------------------------------------------------------------------
        
        /**
         *  @private
         *  See changedStyles, below
         */
        private static const MULTIPLE_PROPERTIES:String = "<MULTIPLE>";
        
        //--------------------------------------------------------------------------
        //
        //  Class methods
        //
        //--------------------------------------------------------------------------
        
        mx_internal function getLayoutChildAt(index:int):IUIComponent
        {
            return /*PostScaleAdapter.getCompatibleIUIComponent(*/getChildAt(index)/*)*/;
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
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function Legend()
        {
            super();
            
            tabEnabled = false;
            tabFocusEnabled = false;
            
            //showInAutomationHierarchy = false;
            
            // If available, get soft-link to the RichEditableText class
            // to use in keyDownHandler().
            try
            {
                richEditableTextClass =
                    Class(getDefinitionByName(
                        "spark.components.RichEditableText"));
            }
            catch (e:Error)
            {
                
            }
            
            direction = "vertical";
            
            addEventListener(MouseEvent.CLICK, childMouseEventHandler);
            addEventListener(MouseEvent.MOUSE_OVER, childMouseEventHandler);
            addEventListener(MouseEvent.MOUSE_OUT, childMouseEventHandler);
            addEventListener(MouseEvent.MOUSE_UP, childMouseEventHandler);
            addEventListener(MouseEvent.MOUSE_DOWN, childMouseEventHandler);
            
            _dataProvider = new ArrayCollection();
        }
        
        //--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------
        
        //----------------------------------
        //  Child creation vars
        //----------------------------------
        
        /**
         *  The creation policy of this container. 
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        protected var actualCreationPolicy:String;
        
        /**
         *  @private
         */
        private var numChildrenBefore:int;
        
        /**
         *  @private
         *  @royalesuppresspublicvarwarning
         */
        public var recursionFlag:Boolean = true;
        
        //----------------------------------
        //  Layout vars
        //----------------------------------
        
        /**
         *  @private
         *  Remember when a child has been added or removed.
         *  When that occurs, we want to run the LayoutManager
         *  (even if autoLayout is false).
         */
        private var forceLayout:Boolean = false;
        
        /**
         *  @private
         */
        mx_internal var doingLayout:Boolean = false;
        
        //----------------------------------
        //  Style vars
        //----------------------------------
        
        /**
         *  @private
         *  If this value is non-null, then we need to recursively notify children
         *  that a style property has changed.  If one style property has changed,
         *  this field holds the name of the style that changed.  If multiple style
         *  properties have changed, then the value of this field is
         *  Container.MULTIPLE_PROPERTIES.
         */
        private var changedStyles:String = null;
        
        //----------------------------------
        //  Scrolling vars
        //----------------------------------
        
        /**
         *  @private
         */
        private var _creatingContentPane:Boolean = false;
        
        /**
         *  Containers use an internal content pane to control scrolling. 
         *  The <code>creatingContentPane</code> is <code>true</code> while the container is creating 
         *  the content pane so that some events can be ignored or blocked.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function get creatingContentPane():Boolean
        {
            return _creatingContentPane;
        }
        public function set creatingContentPane(value:Boolean):void
        {
            _creatingContentPane = value;
        }
        
        /**
         *  @private
         *  A box that takes up space in the lower right corner,
         *  between the horizontal and vertical scrollbars.
         */
        protected var whiteBox:UIComponent;
        
        /**
         *  @private
         */
        mx_internal var contentPane:UIComponent = null;
        
        /**
         *  @private
         *  Flags that remember what work to do during the next updateDisplayList().
         */
        private var scrollPositionChanged:Boolean = true;
        private var horizontalScrollPositionPending:Number;
        private var verticalScrollPositionPending:Number;
        
        /**
         *  @private
         *  Cached values describing the total size of the content being scrolled
         *  and the size of the area in which the scrolled content is displayed.
         */
        private var scrollableWidth:Number = 0;
        private var scrollableHeight:Number = 0;
        private var viewableWidth:Number = 0;
        private var viewableHeight:Number = 0;
        
        //----------------------------------
        //  Other vars
        //----------------------------------
        
        /**
         *  @private
         *  The border/background object.
         */
        mx_internal var border:IFlexDisplayObject;
        
        /**
         *  @private
         *  Sprite used to block user input when the container is disabled.
         */
        mx_internal var blocker:UIComponent;
        
        /**
         *  @private
         *  Keeps track of the number of mouse events we are listening for
         */
        private var mouseEventReferenceCount:int = 0;
        
        /**
         *  @private
         *  Soft-link to RichEditableText class object, if available.
         */
        private var richEditableTextClass:Class;
        
        //--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------
        
        /**
         *  @private
         *  Cached value from findCellSize() call in measure(),
         *  so that updateDisplayList() doesn't also have to call findCellSize().
         */
        mx_internal var cellWidth:Number;
        
        /**
         *  @private
         *  Cached value from findCellSize() call in measure(),
         *  so that updateDisplaylist() doesn't also have to call findCellSize().
         */
        mx_internal var cellHeight:Number;
        
        //--------------------------------------------------------------------------
        //
        //  Properties
        //
        //--------------------------------------------------------------------------
        
        //----------------------------------
        //  direction
        //----------------------------------
        
        /**
         *  @private
         *  Storage for the direction property.
         */
        private var _direction:String = "horizontal";
        
        [Bindable("directionChanged")]
        [Inspectable(category="General", enumeration="vertical,horizontal", defaultValue="horizontal")]
        
        /**
         *  Determines how children are placed in the container.
         *  Possible MXML values  are <code>"horizontal"</code> and
         *  <code>"vertical"</code>.
         *  In ActionScript, you can set the direction using the values
         *  TileDirection.HORIZONTAL or TileDirection.VERTICAL.
         *  The default value is <code>"horizontal"</code>.
         *  (If the container is a Legend container, which is a subclass of Tile,
         *  the default value is <code>"vertical"</code>.)
         *
         *  <p>The first child is always placed at the upper-left of the
         *  Tile container.
         *  If the <code>direction</code> is <code>"horizontal"</code>,
         *  the children are placed left-to-right in the topmost row,
         *  and then left-to-right in the second row, and so on.
         *  If the value is <code>"vertical"</code>, the children are placed
         *  top-to-bottom in the leftmost column, and then top-to-bottom
         *  in the second column, and so on.</p>
         *
         *  @default "horizontal"
         * 
         *  @see TileDirection
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function get direction():String
        {
            return _direction;
        }
        
        /**
         *  @private
         */
        public function set direction(value:String):void
        {
            _direction = value;
            
            invalidateSize();
            invalidateDisplayList();
            
            dispatchEvent(new Event("directionChanged"));
        }
        
        //----------------------------------
        //  tileHeight
        //----------------------------------
        
        /**
         *  @private
         *  Storage for the tileHeight property.
         */
        private var _tileHeight:Number;
        
        [Bindable("resize")]
        [Inspectable(category="General")]
        
        /**
         *  Height of each tile cell, in pixels. 
         *  If this property is <code>NaN</code>, the default, the height
         *  of each cell is determined by the height of the tallest child.
         *  If you set this property, the specified value overrides
         *  this calculation.
         *
         *  @default NaN
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function get tileHeight():Number
        {
            return _tileHeight;
        }
        
        /**
         *  @private
         */
        public function set tileHeight(value:Number):void
        {
            _tileHeight = value;
            
            invalidateSize();
        }
        
        //----------------------------------
        //  tileWidth
        //----------------------------------
        
        /**
         *  @private
         *  Storage for the tileWidth property.
         */
        private var _tileWidth:Number;
        
        [Bindable("resize")]
        [Inspectable(category="General")]
        
        /**
         *  Width of each tile cell, in pixels.
         *  If this property is <code>NaN</code>, the defualt, the width
         *  of each cell is determined by the width of the widest child.
         *  If you set this property, the specified value overrides
         *  this calculation.
         *
         *  @default NaN
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function get tileWidth():Number
        {
            return _tileWidth;
        }
        
        /**
         *  @private
         */
        public function set tileWidth(value:Number):void
        {
            _tileWidth = value;
            
            invalidateSize();
        }
        
        /**
         *  @private
         */
        private var _preferredMajorAxisLength:Number;
        
        /**
         *  @private
         */
        private var _actualMajorAxisLength:Number;
        
        /**
         *  @private
         */
        private var _childrenDirty:Boolean = false;
        
        /**
         *  @private
         */
        private var _unscaledWidth:Number;
        
        /**
         *  @private
         */
        private var _unscaledHeight:Number;
        
        /**
         *  @private
         */
        private static var legendItemLinkage:LegendItem = null;
        
        /**
         *  @private
         */
        private var _dataProviderChanged:Boolean = false;
        
        
        
        //--------------------------------------------------------------------------
        //
        //  Overridden properties
        //
        //--------------------------------------------------------------------------
        
        //----------------------------------
        //  baselinePosition
        //----------------------------------
        
        /**
         *  @private
         *  The baselinePosition of a Container is calculated
         *  as if there was a UITextField using the Container's styles
         *  whose top is at viewMetrics.top.
         */
        override public function get baselinePosition():Number
        {
            //if (!validateBaselinePosition())
            //    return NaN;
            
            // Unless the height is very small, the baselinePosition
            // of a generic Container is calculated as if there was
            // a UITextField using the Container's styles
            // whose top is at viewMetrics.top.
            // If the height is small, the baselinePosition is calculated
            // as if there were text within whose ascent the Container
            // is vertically centered.
            // At the crossover height, these two calculations
            // produce the same result.
            
            /*
            var lineMetrics:TextLineMetrics = measureText("Wj");
            
            if (height < 2 * viewMetrics.top + 4 + lineMetrics.ascent)
                return int(height + (lineMetrics.ascent - height) / 2);
            */
            return viewMetrics.top/* + 2 + lineMetrics.ascent*/;
        }
        
        //----------------------------------
        //  contentMouseX
        //----------------------------------
        
        /**
         *  @copy mx.core.UIComponent#contentMouseX
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        override public function get contentMouseX():Number
        {
            if (contentPane)
                return contentPane.mouseX;
            
            return super.contentMouseX;
        }
        
        //----------------------------------
        //  contentMouseY
        //----------------------------------
        
        /**
         *  @copy mx.core.UIComponent#contentMouseY
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        override public function get contentMouseY():Number
        {
            if (contentPane)
                return contentPane.mouseY;
            
            return super.contentMouseY;
        }
        
        //----------------------------------
        //  doubleClickEnabled
        //----------------------------------
        
        /**
         *  @private
         *  Propagate to children.
         */
        override public function set doubleClickEnabled(value:Boolean):void
        {
            super.doubleClickEnabled = value;
            
            if (contentPane)
            {
                var n:int = contentPane.numChildren;
                for (var i:int = 0; i < n; i++)
                {
                    var child:UIComponent =
                        contentPane.getChildAt(i) as UIComponent;
                    if (child)
                        child.doubleClickEnabled = value;
                }
            }
        }
        
        //----------------------------------
        //  enabled
        //----------------------------------
        
        [Inspectable(category="General", enumeration="true,false", defaultValue="true")]
        
        /**
         *  @private
         */
        override public function set enabled(value:Boolean):void
        {
            super.enabled = value;
            
            invalidateProperties();
            
            /*if (border && border is IInvalidating)
                IInvalidating(border).invalidateDisplayList();*/
        }
        
        //----------------------------------
        //  focusPane
        //----------------------------------
        
        /**
         *  @private
         *  Storage for the focusPane property.
         */
        private var _focusPane:UIComponent;
        
        /**
         *  @private
         *  Focus pane associated with this object.
         *  An object has a focus pane when one of its children has got focus.
        override public function get focusPane():UIComponent
        {
            return _focusPane;
        }
         */
        
        /**
         *  @private
        override public function set focusPane(o:UIComponent):void
        {
            // The addition or removal of the focus sprite should not trigger
            // a measurement/layout pass.  Temporarily set the invalidation flags,
            // so that calls to invalidateSize() and invalidateDisplayList() have
            // no effect.
            var oldInvalidateSizeFlag:Boolean = invalidateSizeFlag;
            var oldInvalidateDisplayListFlag:Boolean = invalidateDisplayListFlag;
            invalidateSizeFlag = true;
            invalidateDisplayListFlag = true;
            
            if (o)
            {
                rawChildren.addChild(o);
                
                o.x = 0;
                o.y = 0;
                o.scrollRect = null;
                
                _focusPane = o;
            }
            else
            {
                rawChildren.removeChild(_focusPane);
                
                _focusPane = null;
            }
            
            if (o && contentPane)
            {
                o.x = contentPane.x;
                o.y = contentPane.y;
                o.scrollRect = contentPane.scrollRect;
            }
            
            invalidateSizeFlag = oldInvalidateSizeFlag;
            invalidateDisplayListFlag = oldInvalidateDisplayListFlag;
        }
         */
        
        //----------------------------------
        //  moduleFactory
        //----------------------------------
        /**
         *  @private
        override public function set moduleFactory(moduleFactory:IFlexModuleFactory):void
        {
            super.moduleFactory = moduleFactory;
            
            // Register the _creationPolicy style as inheriting. See the creationPolicy
            // getter for details on usage of this style.
            styleManager.registerInheritingStyle("_creationPolicy");
        }
         */
        
        //----------------------------------
        //  $numChildren
        //----------------------------------
        
        /**
         *  @private
         *  This property allows access to the Player's native implementation
         *  of the numChildren property, which can be useful since components
         *  can override numChildren and thereby hide the native implementation.
         *  Note that this "base property" is final and cannot be overridden,
         *  so you can count on it to reflect what is happening at the player level.
         */
        COMPILE::JS
        mx_internal final function get $sprite_numChildren():int
        {
            return super.numChildren;
        }
        
        //----------------------------------
        //  numChildren
        //----------------------------------
        
        /**
         *  @private
         *  Storage for the numChildren property.
         */
        mx_internal var _numChildren:int = 0;
        
        /**
         *  Number of child components in this container.
         *
         *  <p>The number of children is initially equal
         *  to the number of children declared in MXML.
         *  At runtime, new children may be added by calling
         *  <code>addChild()</code> or <code>addChildAt()</code>,
         *  and existing children may be removed by calling
         *  <code>removeChild()</code>, <code>removeChildAt()</code>,
         *  or <code>removeAllChildren()</code>.</p>
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        override public function get numChildren():int
        {
            return contentPane ? contentPane.numChildren : _numChildren;
        }
        
        //--------------------------------------------------------------------------
        //
        //  Properties
        //
        //--------------------------------------------------------------------------
        
        //----------------------------------
        //  dataProvider
        //----------------------------------
        
        /**
         *  @private
         *  Storage for the dataProvider property.
         */
        private var _dataProvider:Object;
        
        [Bindable("collectionChange")]
        [Inspectable(category="Data")]
        
        /**
         *  Set of data to be used in the Legend.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function get dataProvider():Object
        {
            return _dataProvider;
        }
        
        /**
         *  @private
         */
        public function set dataProvider(
            value:Object /* String, ViewStack or Array */):void
        {
            if (_dataProvider is ChartBase)
            {
                _dataProvider.removeEventListener("legendDataChanged",
                    legendDataChangedHandler);
            }
            
            _dataProvider = value ? value : [];
            
            if (_dataProvider is ChartBase)
            {
                // weak listeners to collections and dataproviders
                _dataProvider.addEventListener("legendDataChanged",
                    legendDataChangedHandler, false, 0, true);
            }
            else if (_dataProvider is ICollectionView)
            {
            }
            else if (_dataProvider is IList)
            {
                _dataProvider = new ListCollectionView(IList(_dataProvider));
            }
            else if (_dataProvider is Array)
            {
                _dataProvider = new ArrayCollection(_dataProvider as Array);
            }
            else if (_dataProvider != null)
            {
                _dataProvider = new ArrayCollection([_dataProvider]);
            }
            else
            {
                _dataProvider = new ArrayCollection();
            }
            
            invalidateProperties();
            invalidateSize();
            _childrenDirty = true;

            if (parent)
            {
                commitProperties();
                measure();
                // layoutVertical cares about width/height (via UIComponent unscaledWidth/Height)
                setActualSize(getExplicitOrMeasuredWidth(), getExplicitOrMeasuredHeight());
                updateDisplayList(width, height);
            }

            dispatchEvent(new Event("collectionChange"));
        }
        
        //----------------------------------
        //  legendItemClass
        //----------------------------------
        
        /**
         *  The class used to instantiate LegendItem objects.
         *  When a legend's content is derived from the chart or data,
         *  it instantiates one instance of <code>legendItemClass</code>
         *  for each item described by the <code>dataProvider</code>.
         *  If you want custom behavior in your legend items, 
         *  you can assign a subclass of LegendItem to this property
         *  to have the Legend create instances of their derived type instead.  
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         * 
         *  @royalesuppresspublicvarwarning
         */
        public var legendItemClass:Class = LegendItem;
        
        //----------------------------------
        //  autoLayout
        //----------------------------------
        
        /**
         *  @private
         *  Storage for the autoLayout property.
         */
        private var _autoLayout:Boolean = true;
        
        [Inspectable(defaultValue="true")]
        
        /**
         *  If <code>true</code>, measurement and layout are done
         *  when the position or size of a child is changed.
         *  If <code>false</code>, measurement and layout are done only once,
         *  when children are added to or removed from the container.
         *
         *  <p>When using the Move effect, the layout around the component that
         *  is moving does not readjust to fit that the Move effect animates.
         *  Setting a container's <code>autoLayout</code> property to
         *  <code>true</code> has no effect on this behavior.</p>
         *
         *  <p>The Zoom effect does not work when the <code>autoLayout</code> 
         *  property is <code>false</code>.</p>
         *
         *  <p>The <code>autoLayout</code> property does not apply to
         *  Accordion or ViewStack containers.</p>
         * 
         *  @default true
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function get autoLayout():Boolean
        {
            return _autoLayout;
        }
        
        /**
         *  @private
         */
        public function set autoLayout(value:Boolean):void
        {
            _autoLayout = value;
            
            // If layout is being turned back on, trigger a layout to occur now.
            if (value)
            {
                invalidateSize();
                invalidateDisplayList();
                
                var p:IInvalidating = parent as IInvalidating;
                if (p)
                {
                    p.invalidateSize();
                    p.invalidateDisplayList();
                }
            }
        }
        
        //----------------------------------
        //  borderMetrics
        //----------------------------------
        
        /**
         *  Returns an EdgeMetrics object that has four properties:
         *  <code>left</code>, <code>top</code>, <code>right</code>,
         *  and <code>bottom</code>.
         *  The value of each property is equal to the thickness of one side
         *  of the border, expressed in pixels.
         *
         *  <p>Unlike <code>viewMetrics</code>, this property is not
         *  overridden by subclasses of Container.</p>
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function get borderMetrics():EdgeMetrics
        {
            /*return border && border is IRectangularBorder ?
                IRectangularBorder(border).borderMetrics :
                EdgeMetrics.EMPTY;*/
            return EdgeMetrics.EMPTY;
        }
        
        //----------------------------------
        //  childDescriptors
        //----------------------------------
        
        /**
         *  @private
         *  Storage for the childDescriptors property.
         *  This variable is initialized in the construct() method
         *  using the childDescriptors in the initObj, which is autogenerated.
         *  If this Container was not created by createComponentFromDescriptor(),
         *  its childDescriptors property is null.
         */
        private var _childDescriptors:Array /* of UIComponentDescriptor */;
        
        /**
         *  Array of UIComponentDescriptor objects produced by the MXML compiler.
         *
         *  <p>Each UIComponentDescriptor object contains the information 
         *  specified in one child MXML tag of the container's MXML tag.
         *  The order of the UIComponentDescriptor objects in the Array
         *  is the same as the order of the child tags.
         *  During initialization, the child descriptors are used to create
         *  the container's child UIComponent objects and its Repeater objects, 
         *  and to give them the initial property values, event handlers, effects, 
         *  and so on, that were specified in MXML.</p>
         *
         *  @see mx.core.UIComponentDescriptor
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function get childDescriptors():Array /* of UIComponentDescriptor */
        {
            return _childDescriptors;
        }
        
        public function set childDescriptors(value:Array):void /* of UIComponentDescriptor */
        {
            _childDescriptors = value;
        }
        
        //----------------------------------
        //  childRepeaters
        //----------------------------------
        
        /**
         *  @private
         *  Storage for the childRepeaters property.
         */
        private var _childRepeaters:Array;
        
        /**
         *  @private
         *  An array of the Repeater objects found within this container.
         */
        mx_internal function get childRepeaters():Array
        {
            return _childRepeaters;
        }
        
        /**
         *  @private
         */
        mx_internal function set childRepeaters(value:Array):void
        {
            _childRepeaters = value;
        }
        
        //----------------------------------
        //  clipContent
        //----------------------------------
        
        /**
         *  @private
         *  Storage for the clipContent property.
         */
        private var _clipContent:Boolean = true;
        
        [Inspectable(defaultValue="true")]
        
        /**
         *  Whether to apply a clip mask if the positions and/or sizes
         *  of this container's children extend outside the borders of
         *  this container.
         *  If <code>false</code>, the children of this container
         *  remain visible when they are moved or sized outside the
         *  borders of this container.
         *  If <code>true</code>, the children of this container are clipped.
         *
         *  <p>If <code>clipContent</code> is <code>false</code>, then scrolling
         *  is disabled for this container and scrollbars will not appear.
         *  If <code>clipContent</code> is true, then scrollbars will usually
         *  appear when the container's children extend outside the border of
         *  the container.
         *  For additional control over the appearance of scrollbars,
         *  see <code>horizontalScrollPolicy</code> and <code>verticalScrollPolicy</code>.</p>
         * 
         *  @default true
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function get clipContent():Boolean
        {
            return _clipContent;
        }
        
        /**
         *  @private
         */
        public function set clipContent(value:Boolean):void
        {
            if (_clipContent != value)
            {
                _clipContent = value;
                
                invalidateDisplayList();
            }
        }
        
        //----------------------------------
        //  createdComponents
        //----------------------------------
        
        /**
         *  @private
         *  Internal variable used to keep track of the components created
         *  by this Container.  This is different than the list maintained
         *  by DisplayObjectContainer, because it includes Repeaters.
         */
        private var _createdComponents:Array;
        
        /**
         *  @private
         *  An array of all components created by this container including
         *  Repeater components.
         */
        mx_internal function get createdComponents():Array
        {
            return _createdComponents;
        }
        
        /**
         *  @private
         */
        mx_internal function set createdComponents(value:Array):void
        {
            _createdComponents = value;
        }
        
        //----------------------------------
        //  creationIndex
        //----------------------------------
        
        /**
         *  @private
         *  Storage for the creationIndex property.
         */
        private var _creationIndex:int = -1;
        
        [Inspectable(defaultValue="undefined")]
        
        /**
         *  Specifies the order to instantiate and draw the children
         *  of the container.
         *
         *  <p>This property can only be used when the <code>creationPolicy</code>
         *  property is set to <code>ContainerCreationPolicy.QUEUED</code>.
         *  Otherwise, it is ignored.</p>
         *
         *  @default -1
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        [Deprecated]
        public function get creationIndex():int
        {
            return _creationIndex;
        }
        
        /**
         *  @private
         */
        public function set creationIndex(value:int):void
        {
            _creationIndex = value;
        }
        
        //----------------------------------
        //  creationPolicy
        //----------------------------------
        
        // Internal flag used when creationPolicy="none".
        // When set, the value of the backing store _creationPolicy
        // style is "auto" so descendants inherit the correct value.
        private var creationPolicyNone:Boolean = false;
        
        [Inspectable(enumeration="all,auto,none")]
        
        /**
         *  The child creation policy for this MX Container.
         *  ActionScript values can be <code>ContainerCreationPolicy.AUTO</code>, 
         *  <code>ContainerCreationPolicy.ALL</code>,
         *  or <code>ContainerCreationPolicy.NONE</code>.
         *  MXML values can be <code>auto</code>, <code>all</code>, 
         *  or <code>none</code>.
         *
         *  <p>If no <code>creationPolicy</code> is specified for a container,
         *  that container inherits its parent's <code>creationPolicy</code>.
         *  If no <code>creationPolicy</code> is specified for the Application,
         *  it defaults to <code>ContainerCreationPolicy.AUTO</code>.</p>
         *
         *  <p>A <code>creationPolicy</code> of <code>ContainerCreationPolicy.AUTO</code> means
         *  that the container delays creating some or all descendants
         *  until they are needed, a process which is known as <i>deferred
         *  instantiation</i>.
         *  This policy produces the best startup time because fewer
         *  UIComponents are created initially.
         *  However, this introduces navigation delays when a user navigates
         *  to other parts of the application for the first time.
         *  Navigator containers such as Accordion, TabNavigator, and ViewStack
         *  implement the <code>ContainerCreationPolicy.AUTO</code> policy by creating all their
         *  children immediately, but wait to create the deeper descendants
         *  of a child until it becomes the selected child of the navigator
         *  container.</p>
         *
         *  <p>A <code>creationPolicy</code> of <code>ContainerCreationPolicy.ALL</code> means
         *  that the navigator containers immediately create deeper descendants
         *  for each child, rather than waiting until that child is
         *  selected. For single-view containers such as a VBox container,
         *  there is no difference  between the <code>ContainerCreationPolicy.AUTO</code> and
         *  <code>ContainerCreationPolicy.ALL</code> policies.</p>
         *
         *  <p>A <code>creationPolicy</code> of <code>ContainerCreationPolicy.NONE</code> means
         *  that the container creates none of its children.
         *  In that case, it is the responsibility of the MXML author
         *  to create the children by calling the
         *  <code>createComponentsFromDescriptors()</code> method.</p>
         *  
         *  @default ContainerCreationPolicy.AUTO
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
        public function get creationPolicy():String
        {
            // Use an inheriting style as the backing storage for this property.
            // This allows the property to be inherited by either mx or spark
            // containers, and also to correctly cascade through containers that
            // don't have this property (ie Group).
            // This style is an implementation detail and should be considered
            // private. Do not set it from CSS.
            if (creationPolicyNone)
                return ContainerCreationPolicy.NONE;
            return getStyle("_creationPolicy");
        }
         */
        
        /**
         *  @private
        public function set creationPolicy(value:String):void
        {
            var styleValue:String = value;
            
            if (value == ContainerCreationPolicy.NONE)
            {
                // creationPolicy of none is not inherited by descendants.
                // In this case, set the style to "auto" and set a local
                // flag for subsequent access to the creationPolicy property.
                creationPolicyNone = true;
                styleValue = ContainerCreationPolicy.AUTO;
            }
            else
            {
                creationPolicyNone = false;
            }
            
            setStyle("_creationPolicy", styleValue);
            
            setActualCreationPolicies(value);
        }
         */
        
        //----------------------------------
        //  defaultButton
        //----------------------------------
        
        /**
         *  @private
         *  Storage for the defaultButton property.
         */
        private var _defaultButton:IFlexDisplayObject;
        
        [Inspectable(category="General")]
        
        /**
         *  The Button control designated as the default button
         *  for the container.
         *  When controls in the container have focus, pressing the
         *  Enter key is the same as clicking this Button control.
         *
         *  @default null
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
        public function get defaultButton():IFlexDisplayObject
        {
            return _defaultButton;
        }
         */
        
        /**
         *  @private
        public function set defaultButton(value:IFlexDisplayObject):void
        {
            _defaultButton = value;
            ContainerGlobals.focusedContainer = null;
        }
         */
        
        //----------------------------------
        //  deferredContentCreated
        //----------------------------------
        
        /**
         *  IDeferredContentOwner equivalent of processedDescriptors
         * 
         *  @see UIComponent#processedDescriptors
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
        public function get deferredContentCreated():Boolean
        {
            return processedDescriptors;
        }
         */
        
        //----------------------------------
        //  data
        //----------------------------------
        
        /**
         *  @private
         *  Storage for the data property.
         */
        private var _data:Object;
        
        [Bindable("dataChange")]
        [Inspectable(environment="none")]
        
        /**
         *  The <code>data</code> property lets you pass a value
         *  to the component when you use it in an item renderer or item editor.
         *  You typically use data binding to bind a field of the <code>data</code>
         *  property to a property of this component.
         *
         *  <p>You do not set this property in MXML.</p>
         *
         *  @default null
         *  @see mx.core.IDataRenderer
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
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
            _data = value;
            
            dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
            
            invalidateDisplayList();
        }
        
        //----------------------------------
        //  firstChildIndex
        //----------------------------------
        
        /**
         *  @private
         *  Storage for the firstChildIndex property.
         */
        private var _firstChildIndex:int = 0;
        
        /**
         *  @private
         *  The index of the first content child,
         *  when dealing with both content and non-content children.
         */
        mx_internal function get firstChildIndex():int
        {
            return _firstChildIndex;
        }
        
        //----------------------------------
        //  horizontalScrollPosition
        //----------------------------------
        
        /**
         *  @private
         *  Storage for the horizontalScrollPosition property.
         */
        private var _horizontalScrollPosition:Number = 0;
        
        [Bindable("scroll")]
        [Bindable("viewChanged")]
        [Inspectable(defaultValue="0")]
        
        /**
         *  The current position of the horizontal scroll bar.
         *  This is equal to the distance in pixels between the left edge
         *  of the scrollable surface and the leftmost piece of the surface
         *  that is currently visible.
         *  
         *  @default 0
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function get horizontalScrollPosition():Number
        {
            if (!isNaN(horizontalScrollPositionPending))
                return horizontalScrollPositionPending;
            return _horizontalScrollPosition;
        }
        
        /**
         *  @private
         */
        public function set horizontalScrollPosition(value:Number):void
        {
            if (_horizontalScrollPosition == value)
                return;
            
            // Note: We can't use maxHorizontalScrollPosition to clamp the value here.
            // The horizontalScrollBar may not exist yet,
            // or its maxPos might change during layout.
            // (For example, you could set the horizontalScrollPosition of a childless container,
            // then add a child which causes it to have a scrollbar.)
            // The horizontalScrollPosition gets clamped to the range 0 through maxHorizontalScrollPosition
            // late, in the updateDisplayList() method, just before the scrollPosition
            // of the horizontalScrollBar is set.
            
            _horizontalScrollPosition = value;
            scrollPositionChanged = true;
            if (!initialized)
                horizontalScrollPositionPending = value;
            
            invalidateDisplayList();
            
            dispatchEvent(new Event("viewChanged"));
        }
        
        //----------------------------------
        //  horizontalScrollPolicy
        //----------------------------------
        
        /**
         *  @private
         *  Storage for the horizontalScrollPolicy property.
         */
        mx_internal var _horizontalScrollPolicy:String = ScrollPolicy.AUTO;
        
        [Bindable("horizontalScrollPolicyChanged")]
        [Inspectable(category="General", enumeration="off,on,auto", defaultValue="auto")]
        
        /**
         *  Specifies whether the horizontal scroll bar is always present,
         *  always absent, or automatically added when needed.
         *  ActionScript values can be <code>ScrollPolicy.ON</code>, <code>ScrollPolicy.OFF</code>,
         *  and <code>ScrollPolicy.AUTO</code>. 
         *  MXML values can be <code>"on"</code>, <code>"off"</code>,
         *  and <code>"auto"</code>.
         *
         *  <p>Setting this property to <code>ScrollPolicy.OFF</code> also prevents the
         *  <code>horizontalScrollPosition</code> property from having an effect.</p>
         *
         *  <p>Note: This property does not apply to the ControlBar container.</p>
         *
         *  <p>If the <code>horizontalScrollPolicy</code> is <code>ScrollPolicy.AUTO</code>,
         *  the horizontal scroll bar appears when all of the following
         *  are true:</p>
         *  <ul>
         *    <li>One of the container's children extends beyond the left
         *      edge or right edge of the container.</li>
         *    <li>The <code>clipContent</code> property is <code>true</code>.</li>
         *    <li>The width and height of the container are large enough to
         *      reasonably accommodate a scroll bar.</li>
         *  </ul>
         *
         *  @default ScrollPolicy.AUTO
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function get horizontalScrollPolicy():String
        {
            return ScrollPolicy.OFF;
        }
        
        /**
         *  @private
         */
        public function set horizontalScrollPolicy(value:String):void
        {
        }
        
        //----------------------------------
        //  icon
        //----------------------------------
        
        /**
         *  @private
         *  Storage for the icon property.
         */
        private var _icon:Class = null;
        
        [Bindable("iconChanged")]
        [Inspectable(category="General", defaultValue="", format="EmbeddedFile")]
        
        /**
         *  The Class of the icon displayed by some navigator
         *  containers to represent this Container.
         *
         *  <p>For example, if this Container is a child of a TabNavigator,
         *  this icon appears in the corresponding tab.
         *  If this Container is a child of an Accordion,
         *  this icon appears in the corresponding header.</p>
         *
         *  <p>To embed the icon in the SWF file, use the &#64;Embed()
         *  MXML compiler directive:</p>
         *
         *  <pre>
         *    icon="&#64;Embed('filepath')"
         *  </pre>
         *
         *  <p>The image can be a JPEG, GIF, PNG, SVG, or SWF file.</p>
         *
         *  @default null
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function get icon():Class
        {
            return _icon;
        }
        
        /**
         *  @private
         */
        public function set icon(value:Class):void
        {
            _icon = value;
            
            dispatchEvent(new Event("iconChanged"));
        }
        
        //----------------------------------
        //  label
        //----------------------------------
        
        /**
         *  @private
         *  Storage for the label property.
         */
        private var _label:String = "";
        
        [Bindable("labelChanged")]
        [Inspectable(category="General", defaultValue="")]
        
        /**
         *  The text displayed by some navigator containers to represent
         *  this Container.
         *
         *  <p>For example, if this Container is a child of a TabNavigator,
         *  this string appears in the corresponding tab.
         *  If this Container is a child of an Accordion,
         *  this string appears in the corresponding header.</p>
         *
         *  @default ""
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
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
            _label = value;
            
            dispatchEvent(new Event("labelChanged"));
        }
        
        //----------------------------------
        //  maxHorizontalScrollPosition
        //----------------------------------
        
        /**
         *  The largest possible value for the
         *  <code>horizontalScrollPosition</code> property.
         *  Defaults to 0 if the horizontal scrollbar is not present.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function get maxHorizontalScrollPosition():Number
        {
            return Math.max(scrollableWidth - viewableWidth, 0);
        }
        
        //----------------------------------
        //  maxVerticalScrollPosition
        //----------------------------------
        
        /**
         *  The largest possible value for the
         *  <code>verticalScrollPosition</code> property.
         *  Defaults to 0 if the vertical scrollbar is not present.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function get maxVerticalScrollPosition():Number
        {
            return Math.max(scrollableHeight - viewableHeight, 0);
        }
        
        //----------------------------------
        //  numChildrenCreated
        //----------------------------------
        
        /**
         *  @private
         */
        private var _numChildrenCreated:int = -1;
        
        /**
         *  @private
         *  The number of children created inside this container.
         *  The default value is 0.
         */
        mx_internal function get numChildrenCreated():int
        {
            return _numChildrenCreated;
        }
        
        /**
         *  @private
         */
        mx_internal function set numChildrenCreated(value:int):void
        {
            _numChildrenCreated = value;
        }
        
        //----------------------------------
        //  numRepeaters
        //----------------------------------
        
        /**
         *  @private 
         *  The number of Repeaters in this Container.
         *
         *  <p>This number includes Repeaters that are immediate children of this
         *  container and Repeaters that are nested inside other Repeaters.
         *  Consider the following example:</p>
         *
         *  <pre>
         *  &lt;mx:HBox&gt;
         *    &lt;mx:Repeater dataProvider="[1, 2]"&gt;
         *      &lt;mx:Repeater dataProvider="..."&gt;
         *        &lt;mx:Button/&gt;
         *      &lt;/mx:Repeater&gt;
         *    &lt;/mx:Repeater&gt;
         *  &lt;mx:HBox&gt;
         *  </pre>
         *
         *  <p>In this example, the <code>numRepeaters</code> property
         *  for the HBox would be set equal to 3 -- one outer Repeater
         *  and two inner repeaters.</p>
         *
         *  <p>The <code>numRepeaters</code> property does not include Repeaters
         *  that are nested inside other containers.
         *  Consider this example:</p>
         *
         *  <pre>
         *  &lt;mx:HBox&gt;
         *    &lt;mx:Repeater dataProvider="[1, 2]"&gt;
         *      &lt;mx:VBox&gt;
         *        &lt;mx:Repeater dataProvider="..."&gt;
         *          &lt;mx:Button/&gt;
         *        &lt;/mx:Repeater&gt;
         *      &lt;/mx:VBox&gt;
         *    &lt;/mx:Repeater&gt;
         *  &lt;mx:HBox&gt;
         *  </pre>
         *
         *  <p>In this example, the <code>numRepeaters</code> property
         *  for the outer HBox would be set equal to 1 -- just the outer repeater.
         *  The two inner VBox containers would also have a
         *  <code>numRepeaters</code> property equal to 1 -- one Repeater
         *  per VBox.</p>
         */
        mx_internal function get numRepeaters():int
        {
            return childRepeaters ? childRepeaters.length : 0;
        }
        
        //----------------------------------
        //  rawChildren
        //----------------------------------
        
        /**
         *  @private
         *  The single IChildList object that's always returned
         *  from the rawChildren property, below.
         */
        private var _rawChildren:LegendRawChildrenList;
        
        /**
         *  A container typically contains child components, which can be enumerated
         *  using the <code>Container.getChildAt()</code> method and 
         *  <code>Container.numChildren</code> property.  In addition, the container
         *  may contain style elements and skins, such as the border and background.
         *  Flash Player and AIR do not draw any distinction between child components
         *  and skins.  They are all accessible using the player's 
         *  <code>getChildAt()</code> method  and
         *  <code>numChildren</code> property.  
         *  However, the Container class overrides the <code>getChildAt()</code> method 
         *  and <code>numChildren</code> property (and several other methods) 
         *  to create the illusion that
         *  the container's children are the only child components.
         *
         *  <p>If you need to access all of the children of the container (both the
         *  content children and the skins), then use the methods and properties
         *  on the <code>rawChildren</code> property instead of the regular Container methods. 
         *  For example, use the <code>Container.rawChildren.getChildAt())</code> method.
         *  However, if a container creates a ContentPane Sprite object for its children,
         *  the <code>rawChildren</code> property value only counts the ContentPane, not the
         *  container's children.
         *  It is not always possible to determine when a container will have a ContentPane.</p>
         * 
         *  <p><b>Note:</b>If you call the <code>addChild</code> or 
         *  <code>addChildAt</code> method of the <code>rawChildren</code> object,
         *  set <code>tabFocusEnabled = false</code> on the component that you have added.
         *  Doing so prevents users from tabbing to the visual-only component
         *  that you have added.</p>
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function get rawChildren():IChildList
        {
            if (!_rawChildren)
                _rawChildren = new LegendRawChildrenList(this);
            
            return _rawChildren;
        }
        
        //----------------------------------
        //  usePadding
        //----------------------------------
        
        /**
         *  @private
         */
        mx_internal function get usePadding():Boolean
        {
            // Containers, by default, always use padding.
            return true;
        }
        
        //----------------------------------
        //  verticalScrollPosition
        //----------------------------------
        
        /**
         *  @private
         *  Storage for the verticalScrollPosition property.
         */
        private var _verticalScrollPosition:Number = 0;
        
        [Bindable("scroll")]
        [Bindable("viewChanged")]
        [Inspectable(defaultValue="0")]
        
        /**
         *  The current position of the vertical scroll bar.
         *  This is equal to the distance in pixels between the top edge
         *  of the scrollable surface and the topmost piece of the surface
         *  that is currently visible.
         *
         *  @default 0
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function get verticalScrollPosition():Number
        {
            if (!isNaN(verticalScrollPositionPending))
                return verticalScrollPositionPending;
            
            return _verticalScrollPosition;
        }
        
        /**
         *  @private
         */
        public function set verticalScrollPosition(value:Number):void
        {
            if (_verticalScrollPosition == value)
                return;
            
            // Note: We can't use maxVerticalScrollPosition to clamp the value here.
            // The verticalScrollBar may not exist yet,
            // or its maxPos might change during layout.
            // (For example, you could set the verticalScrollPosition of a childless container,
            // then add a child which causes it to have a scrollbar.)
            // The verticalScrollPosition gets clamped to the range 0 through maxVerticalScrollPosition
            // late, in the updateDisplayList() method, just before the scrollPosition
            // of the verticalScrollBar is set.
            
            _verticalScrollPosition = value;
            scrollPositionChanged = true;
            if (!initialized)
                verticalScrollPositionPending = value;
            
            invalidateDisplayList();
            
            dispatchEvent(new Event("viewChanged"));
        }
        
        //----------------------------------
        //  verticalScrollPolicy
        //----------------------------------
        
        /**
         *  @private
         *  Storage for the verticalScrollPolicy property.
         */
        mx_internal var _verticalScrollPolicy:String = ScrollPolicy.AUTO;
        
        [Bindable("verticalScrollPolicyChanged")]
        [Inspectable(category="General", enumeration="off,on,auto", defaultValue="auto")]
        
        /**
         *  Specifies whether the vertical scroll bar is always present,
         *  always absent, or automatically added when needed.
         *  Possible values are <code>ScrollPolicy.ON</code>, <code>ScrollPolicy.OFF</code>,
         *  and <code>ScrollPolicy.AUTO</code>.
         *  MXML values can be <code>"on"</code>, <code>"off"</code>,
         *  and <code>"auto"</code>.
         *
         *  <p>Setting this property to <code>ScrollPolicy.OFF</code> also prevents the
         *  <code>verticalScrollPosition</code> property from having an effect.</p>
         *
         *  <p>Note: This property does not apply to the ControlBar container.</p>
         *
         *  <p>If the <code>verticalScrollPolicy</code> is <code>ScrollPolicy.AUTO</code>,
         *  the vertical scroll bar appears when all of the following
         *  are true:</p>
         *  <ul>
         *    <li>One of the container's children extends beyond the top
         *      edge or bottom edge of the container.</li>
         *    <li>The <code>clipContent</code> property is <code>true</code>.</li>
         *    <li>The width and height of the container are large enough to
         *      reasonably accommodate a scroll bar.</li>
         *  </ul>
         *
         *  @default ScrollPolicy.AUTO
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function get verticalScrollPolicy():String
        {
            return ScrollPolicy.OFF;
        }
        
        /**
         *  @private
         */
        public function set verticalScrollPolicy(value:String):void
        {
        }
        
        //----------------------------------
        //  viewMetrics
        //----------------------------------
        
        /**
         *  @private
         *  Offsets including borders and scrollbars
         */
        private var _viewMetrics:EdgeMetrics;
        
        /**
         *  Returns an object that has four properties: <code>left</code>,
         *  <code>top</code>, <code>right</code>, and <code>bottom</code>.
         *  The value of each property equals the thickness of the chrome
         *  (visual elements) around the edge of the container. 
         *
         *  <p>The chrome includes the border thickness.
         *  If the <code>horizontalScrollPolicy</code> or <code>verticalScrollPolicy</code> 
         *  property value is <code>ScrollPolicy.ON</code>, the
         *  chrome also includes the thickness of the corresponding
         *  scroll bar. If a scroll policy is <code>ScrollPolicy.AUTO</code>,
         *  the chrome measurement does not include the scroll bar thickness, 
         *  even if a scroll bar is displayed.</p>
         *
         *  <p>Subclasses of Container should override this method, so that
         *  they include other chrome to be taken into account when positioning
         *  the Container's children.
         *  For example, the <code>viewMetrics</code> property for the
         *  Panel class should return an object whose <code>top</code> property
         *  includes the thickness of the Panel container's title bar.</p>
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function get viewMetrics():EdgeMetrics
        {
            var bm:EdgeMetrics = borderMetrics;
            
            // If scrollPolicy is ScrollPolicy.ON, then the scrollbars are accounted for
            // during both measurement and layout.
            //
            // If scrollPolicy is ScrollPolicy.AUTO, then scrollbars are ignored during
            // measurement.  Otherwise, the entire layout of the app could change
            // everytime that the scrollbars turn on or off.
            //
            // However, we do take the width of scrollbars into account when laying
            // out our children.  That way, children that have a percentage width or
            // percentage height will only expand to consume space that's left over
            // after leaving room for the scrollbars.
            var verticalScrollBarIncluded:Boolean = false;
                /*verticalScrollBar != null &&
                (doingLayout || verticalScrollPolicy == ScrollPolicy.ON);*/
            var horizontalScrollBarIncluded:Boolean = false;
                /*horizontalScrollBar != null &&
                (doingLayout || horizontalScrollPolicy == ScrollPolicy.ON);*/
            if (!verticalScrollBarIncluded && !horizontalScrollBarIncluded)
                return bm;
            
            // The viewMetrics property needs to return its own object.
            // Rather than allocating a new one each time, we'll allocate one once
            // and then hold a reference to it.
            if (!_viewMetrics)
            {
                _viewMetrics = bm.clone();
            }
            else
            {
                _viewMetrics.left = bm.left;
                _viewMetrics.right = bm.right;
                _viewMetrics.top = bm.top;
                _viewMetrics.bottom = bm.bottom;
            }
            
            if (verticalScrollBarIncluded)
                _viewMetrics.right;// += verticalScrollBar.minWidth;
            if (horizontalScrollBarIncluded)
                _viewMetrics.bottom;// += horizontalScrollBar.minHeight;
            
            return _viewMetrics;
        }
        
        //----------------------------------
        //  viewMetricsAndPadding
        //----------------------------------
        
        /**
         *  @private
         *  Cached value containing the view metrics plus the object's margins.
         */
        private var _viewMetricsAndPadding:EdgeMetrics;
        
        /**
         *  Returns an object that has four properties: <code>left</code>,
         *  <code>top</code>, <code>right</code>, and <code>bottom</code>.
         *  The value of each property is equal to the thickness of the chrome
         *  (visual elements)
         *  around the edge of the container plus the thickness of the object's margins.
         *
         *  <p>The chrome includes the border thickness.
         *  If the <code>horizontalScrollPolicy</code> or <code>verticalScrollPolicy</code> 
         *  property value is <code>ScrollPolicy.ON</code>, the
         *  chrome also includes the thickness of the corresponding
         *  scroll bar. If a scroll policy is <code>ScrollPolicy.AUTO</code>,
         *  the chrome measurement does not include the scroll bar thickness, 
         *  even if a scroll bar is displayed.</p>
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function get viewMetricsAndPadding():EdgeMetrics
        {
            // If this object has scrollbars, and if the verticalScrollPolicy
            // is not ScrollPolicy.ON, then the view metrics change
            // depending on whether we're doing layout or not.
            // In that case, we can't use a cached value.
            // In all other cases, use the cached value if it exists.
            if (_viewMetricsAndPadding &&
                (horizontalScrollPolicy == ScrollPolicy.ON) &&
                (verticalScrollPolicy == ScrollPolicy.ON))
            {
                return _viewMetricsAndPadding;
            }
            
            if (!_viewMetricsAndPadding)
                _viewMetricsAndPadding = new EdgeMetrics();
            
            var o:EdgeMetrics = _viewMetricsAndPadding;
            var vm:EdgeMetrics = viewMetrics;
            
            o.left = vm.left + getStyle("paddingLeft");
            o.right = vm.right + getStyle("paddingRight");
            o.top = vm.top + getStyle("paddingTop");
            o.bottom = vm.bottom + getStyle("paddingBottom");
            
            return o;
        }
        
        //--------------------------------------------------------------------------
        //
        //  Overridden methods: EventDispatcher
        //
        //--------------------------------------------------------------------------
        
        /**
         *  @private
         *  If we add a mouse event, then we need to add a mouse shield
         *  to us and to all our children
         *  The mouseShield style is a non-inheriting style
         *  that is used by the view.
         *  The mouseShieldChildren style is an inherting style
         *  that is used by the children views.
        override public function addEventListener(
            type:String, listener:Function,
            useCapture:Boolean = false,
            priority:int = 0,
            useWeakReference:Boolean = false):void
        {
            super.addEventListener(type, listener, useCapture,
                priority, useWeakReference);
            
            // If we are a mouse event, then create a mouse shield.
            if (type == MouseEvent.CLICK ||
                type == MouseEvent.DOUBLE_CLICK ||
                type == MouseEvent.MOUSE_DOWN ||
                type == MouseEvent.MOUSE_MOVE ||
                type == MouseEvent.MOUSE_OVER ||
                type == MouseEvent.MOUSE_OUT ||
                type == MouseEvent.MOUSE_UP ||
                type == MouseEvent.MOUSE_WHEEL)
            {
                if (mouseEventReferenceCount < 0x7FFFFFFF // int_max
                    && mouseEventReferenceCount++ == 0)
                {
                    setStyle("mouseShield", true);
                    setStyle("mouseShieldChildren", true);
                }
            }
        }
*/
        
        /**
         *  @private
         *  We're doing special behavior on addEventListener to make sure that 
         *  we successfully capture mouse events, even when there's no background.
         *  However, this means adding an event listener changes the behavior 
         *  a little, and this can be troublesome for overlapping components
         *  that now don't get any mouse events.  This is acceptable normally; 
         *  however, automation adds certain events to the Container, and 
         *  it'd be better if automation support didn't modify the behavior of 
         *  the component.  For this reason, especially, we have an mx_internal 
         *  $addEventListener to add event listeners without affecting the behavior 
         *  of the component.
        mx_internal function $addEventListener(
            type:String, listener:Function,
            useCapture:Boolean = false,
            priority:int = 0,
            useWeakReference:Boolean = false):void
        {
            super.addEventListener(type, listener, useCapture,
                priority, useWeakReference);
        }
         */
        
        /**
         *  @private
         *  Remove the mouse shield if we no longer listen to any mouse events
        
        override public function removeEventListener(
            type:String, listener:Function,
            useCapture:Boolean = false):void
        {
            super.removeEventListener(type, listener, useCapture);
            
            // If we are a mouse event,
            // then decrement the mouse shield reference count.
            if (type == MouseEvent.CLICK ||
                type == MouseEvent.DOUBLE_CLICK ||
                type == MouseEvent.MOUSE_DOWN ||
                type == MouseEvent.MOUSE_MOVE ||
                type == MouseEvent.MOUSE_OVER ||
                type == MouseEvent.MOUSE_OUT ||
                type == MouseEvent.MOUSE_UP ||
                type == MouseEvent.MOUSE_WHEEL)
            {
                if (mouseEventReferenceCount > 0 &&
                    --mouseEventReferenceCount == 0)
                {
                    setStyle("mouseShield", false);
                    setStyle("mouseShieldChildren", false);
                }
            }
        }
                 */

        /**
         *  @private
         *  We're doing special behavior on removeEventListener to make sure that 
         *  we successfully capture mouse events, even when there's no background.
         *  However, this means removing an event listener changes the behavior 
         *  a little, and this can be troublesome for overlapping components
         *  that now don't get any mouse events.  This is acceptable normally; 
         *  however, automation adds certain events to the Container, and 
         *  it'd be better if automation support didn't modify the behavior of 
         *  the component.  For this reason, especially, we have an mx_internal 
         *  $removeEventListener to remove event listeners without affecting the behavior 
         *  of the component.
        mx_internal function $removeEventListener(
            type:String, listener:Function,
            useCapture:Boolean = false):void
        {
            super.removeEventListener(type, listener, useCapture);
        }
         */
        
        //--------------------------------------------------------------------------
        //
        //  Overridden methods: DisplayObjectContainer
        //
        //--------------------------------------------------------------------------
        
        /**
         *  Adds a child DisplayObject to this Container.
         *  The child is added after other existing children,
         *  so that the first child added has index 0,
         *  the next has index 1, an so on.
         *
         *  <p><b>Note: </b>While the <code>child</code> argument to the method
         *  is specified as of type DisplayObject, the argument must implement
         *  the IUIComponent interface to be added as a child of a container.
         *  All Flex components implement this interface.</p>
         *
         *  <p>Children are layered from back to front.
         *  In other words, if children overlap, the one with index 0
         *  is farthest to the back, and the one with index
         *  <code>numChildren - 1</code> is frontmost.
         *  This means the newly added children are layered
         *  in front of existing children.</p>
         *
         *  @param child The DisplayObject to add as a child of this Container.
         *  It must implement the IUIComponent interface.
         *
         *  @return The added child as an object of type DisplayObject. 
         *  You typically cast the return value to UIComponent, 
         *  or to the type of the added component.
         *
         *  @see mx.core.IUIComponent
         *
         *  @tiptext Adds a child object to this container.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        [SWFOverride(params="flash.display.DisplayObject", altparams="mx.core.UIComponent", returns="flash.display.DisplayObject"))]
        override public function addChild(child:IUIComponent):IUIComponent
        {
            return addChildAt(child, numChildren);
            
            /* Application and Panel are depending on addChild calling addChildAt */
            
            /*
            addingChild(child);
            
            if (contentPane)
            contentPane.addChild(child);
            else
            $addChild(child);
            
            childAdded(child);
            
            return child;
            */
        }
        
        /**
         *  Adds a child DisplayObject to this Container.
         *  The child is added at the index specified.
         *
         *  <p><b>Note: </b>While the <code>child</code> argument to the method
         *  is specified as of type DisplayObject, the argument must implement
         *  the IUIComponent interface to be added as a child of a container.
         *  All Flex components implement this interface.</p>
         *
         *  <p>Children are layered from back to front.
         *  In other words, if children overlap, the one with index 0
         *  is farthest to the back, and the one with index
         *  <code>numChildren - 1</code> is frontmost.
         *  This means the newly added children are layered
         *  in front of existing children.</p>
         *
         *  <p>When you add a new child at an index that is already occupied
         *  by an old child, it doesn't replace the old child; instead the
         *  old child and the ones after it "slide over" and have their index
         *  incremented by one.
         *  For example, suppose a Container contains the children
         *  (A, B, C) and you add D at index 1.
         *  Then the container will contain (A, D, B, C).
         *  If you want to replace an old child, you must first remove it
         *  before adding the new one.</p>
         *
         *  @param child The DisplayObject to add as a child of this Container.
         *  It must implement the IUIComponent interface.
         *
         *  @param index The index to add the child at.
         *
         *  @return The added child as an object of type DisplayObject. 
         *  You typically cast the return value to UIComponent, 
         *  or to the type of the added component.
         *
         *  @see mx.core.IUIComponent
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        [SWFOverride(params="flash.display.DisplayObject,int", altparams="mx.core.UIComponent,int", returns="flash.display.DisplayObject"))]
        override public function addChildAt(child:IUIComponent,
                                            index:int):IUIComponent
        {
            var formerParent:UIComponent = child.parent as UIComponent;
            if (formerParent /* && !(formerParent is Loader)*/)
            {
                // Adjust index if necessary when former parent happens
                // to be the same container.
                if (formerParent == this)
                    index = (index == numChildren) ? index - 1 : index;
                
                formerParent.removeChild(child);
            }
            
            addingChild(child);
            
            // Add the child to either this container or its contentPane.
            // The player will dispatch an "added" event from the child
            // after it has been added, so all "added" handlers execute here.
            if (contentPane)
                contentPane.addChildAt(child, index);
            else
                $uibase_addChildAt(child, _firstChildIndex + index);
            
            childAdded(child);
            
            //if ((child is UIComponent) && UIComponent(child).isDocument)
            //    BindingManager.setEnabled(child, true);
            
            return child;
        }
        
        /**
         *  Removes a child DisplayObject from the child list of this Container.
         *  The removed child will have its <code>parent</code>
         *  property set to null. 
         *  The child will still exist unless explicitly destroyed.
         *  If you add it to another container,
         *  it will retain its last known state.
         *
         *  @param child The DisplayObject to remove.
         *
         *  @return The removed child as an object of type DisplayObject. 
         *  You typically cast the return value to UIComponent, 
         *  or to the type of the removed component.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        [SWFOverride(params="flash.display.DisplayObject", altparams="mx.core.UIComponent", returns="flash.display.DisplayObject"))]
        override public function removeChild(child:IUIComponent):IUIComponent
        {
            /*
            if (child is IDeferredInstantiationUIComponent && 
                IDeferredInstantiationUIComponent(child).descriptor)
            {
                // if child's descriptor is present, it means child was created
                // with MXML.  Need to go through and remove component in 
                // createdComponents so there is no memory leak by keeping 
                // a reference to the removed child (SDK-12506)
                
                if (createdComponents)
                {
                    var n:int = createdComponents.length;
                    for (var i:int = 0; i < n; i++)
                    {
                        if (createdComponents[i] === child)
                        {
                            // delete this reference
                            createdComponents.splice(i, 1);
                        }
                    }
                }
            }
            */
            
            removingChild(child);
            
            //if ((child is UIComponent) && UIComponent(child).isDocument)
            //    BindingManager.setEnabled(child, false);
            
            // Remove the child from either this container or its contentPane.
            // The player will dispatch a "removed" event from the child
            // before it is removed, so all "removed" handlers execute here.
            if (contentPane)
                contentPane.removeChild(child);
            else
                $uibase_removeChild(child);
            
            childRemoved(child);
            
            return child;
        }
        
        /**
         *  Removes a child DisplayObject from the child list of this Container
         *  at the specified index.
         *  The removed child will have its <code>parent</code>
         *  property set to null. 
         *  The child will still exist unless explicitly destroyed.
         *  If you add it to another container,
         *  it will retain its last known state.
         *
         *  @param index The child index of the DisplayObject to remove.
         *
         *  @return The removed child as an object of type DisplayObject. 
         *  You typically cast the return value to UIComponent, 
         *  or to the type of the removed component.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        [SWFOverride(returns="flash.display.DisplayObject"))]
        override public function removeChildAt(index:int):IUIComponent
        {
            return removeChild(getChildAt(index));
            
            /*
            
            Shouldn't implement removeChildAt() in terms of removeChild().
            If we change this ViewStack IList, Application, and Panel are depending on it
            
            */
        }
        
        /**
         *  Gets the <i>n</i>th child component object.
         *
         *  <p>The children returned from this method include children that are
         *  declared in MXML and children that are added using the
         *  <code>addChild()</code> or <code>addChildAt()</code> method.</p>
         *
         *  @param childIndex Number from 0 to (numChildren - 1).
         *
         *  @return Reference to the child as an object of type DisplayObject. 
         *  You typically cast the return value to UIComponent, 
         *  or to the type of a specific Flex control, such as ComboBox or TextArea.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        [SWFOverride(returns="flash.display.DisplayObject"))]
        override public function getChildAt(index:int):IUIComponent
        {
            if (contentPane)
            {
                return contentPane.getChildAt(index);
            }
            else
            {
                // The DisplayObjectContainer implementation of getChildAt()
                // in the Player throws this error if the index is bad,
                // so we should too.
                //          if (index < 0 || index >= _numChildren)
                //              throw new RangeError("The supplied index is out of bounds");
                
                return super.getChildAt(_firstChildIndex + index);
            }
        }
        
        /**
         *  Returns the child whose <code>name</code> property is the specified String.
         *
         *  @param name The identifier of the child.
         *
         *  @return The DisplayObject representing the child as an object of type DisplayObject.
         *  You typically cast the return value to UIComponent, 
         *  or to the type of a specific Flex control, such as ComboBox or TextArea.
         *  Throws a run-time error if the child of the specified name does not exist.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        [SWFOverride(returns="flash.display.DisplayObject"))]
        override public function getChildByName(name:String):IUIComponent
        {
            if (contentPane)
            {
                return contentPane.getChildByName(name);
            }
            else
            {
                var child:IUIComponent = super.getChildByName(name);
                if (!child)
                    return null;
                
                // Check if the child is in the index range for content children.
                var index:int = super.getChildIndex(child) - _firstChildIndex;
                if (index < 0 || index >= _numChildren)
                    return null;
                
                return child;
            }
        }
        
        /**
         *  Gets the zero-based index of a specific child.
         *
         *  <p>The first child of the container (i.e.: the first child tag
         *  that appears in the MXML declaration) has an index of 0,
         *  the second child has an index of 1, and so on.
         *  The indexes of a container's children determine
         *  the order in which they get laid out.
         *  For example, in a VBox the child with index 0 is at the top,
         *  the child with index 1 is below it, etc.</p>
         *
         *  <p>If you add a child by calling the <code>addChild()</code> method,
         *  the new child's index is equal to the largest index among existing
         *  children plus one.
         *  You can insert a child at a specified index by using the
         *  <code>addChildAt()</code> method; in that case the indices of the
         *  child previously at that index, and the children at higher indices,
         *  all have their index increased by 1 so that all indices fall in the
         *  range from 0 to <code>(numChildren - 1)</code>.</p>
         *
         *  <p>If you remove a child by calling <code>removeChild()</code>
         *  or <code>removeChildAt()</code> method, then the indices of the
         *  remaining children are adjusted so that all indices fall in the
         *  range from 0 to <code>(numChildren - 1)</code>.</p>
         *
         *  <p>If <code>myView.getChildIndex(myChild)</code> returns 5,
         *  then <code>myView.getChildAt(5)</code> returns myChild.</p>
         *
         *  <p>The index of a child may be changed by calling the
         *  <code>setChildIndex()</code> method.</p>
         *
         *  @param child Reference to child whose index to get.
         *
         *  @return Number between 0 and (numChildren - 1).
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        [SWFOverride(params="flash.display.DisplayObject", altparams="mx.core.UIComponent"))]
        override public function getChildIndex(child:IUIComponent):int
        {
            if (contentPane)
            {
                return contentPane.getChildIndex(child);
            }
            else
            {
                var index:int = super.getChildIndex(child) - _firstChildIndex;
                
                // The DisplayObjectContainer implementation of getChildIndex()
                // in the Player throws this error if the child isn't a child,
                // so we should too.
                //          if (index < 0 || index >= _numChildren)
                //              throw new /*Argument*/Error("The DisplayObject supplied must be a child of the caller.");
                
                return index;
            }
        }
        
        /**
         *  Sets the index of a particular child.
         *  See the <code>getChildIndex()</code> method for a
         *  description of the child's index.
         *
         *  @param child Reference to child whose index to set.
         *
         *  @param newIndex Number that indicates the new index.
         *  Must be an integer between 0 and (numChildren - 1).
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        [SWFOverride(params="flash.display.DisplayObject,int", altparams="mx.core.UIComponent,int"))]
        override public function setChildIndex(child:IUIComponent, newIndex:int):void
        {
            var oldIndex:int;
            
            var eventOldIndex:int = oldIndex;
            var eventNewIndex:int = newIndex;
            
            if (contentPane)
            {
                contentPane.setChildIndex(child, newIndex);
                
                if (_autoLayout || forceLayout)
                    invalidateDisplayList();
            }
            else
            {
                oldIndex = super.getChildIndex(child);
                
                // Offset the index, to leave room for skins before the list of children
                newIndex += _firstChildIndex;
                
                if (newIndex == oldIndex)
                    return;
                
                // Change the child's index, shifting around other children to make room
                super.setChildIndex(child, newIndex);
                
                invalidateDisplayList();
                
                eventOldIndex = oldIndex - _firstChildIndex;
                eventNewIndex = newIndex - _firstChildIndex;
            }
            
            // Notify others that the child index has changed
            var event:IndexChangedEvent = new IndexChangedEvent(IndexChangedEvent.CHILD_INDEX_CHANGE);
            event.relatedObject = child;
            event.oldIndex = eventOldIndex;
            event.newIndex = eventNewIndex;
            dispatchEvent(event);
            
            dispatchEvent(new Event("childrenChanged"));
        }
        
        /**
         *  @private
         */
        [SWFOverride(params="flash.display.DisplayObject", altparams="mx.core.UIComponent"))]
        override public function contains(child:IUIBase):Boolean
        {
            if (contentPane)
                return contentPane.contains(child);
            else
                return super.contains(child);
        }
        
        //--------------------------------------------------------------------------
        //
        //  Methods: IVisualElementContainer
        //
        //--------------------------------------------------------------------------
        
        /**
         *  @copy mx.core.IVisualElementContainer#numElements
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Flex 4
        public function get numElements():int
        {
            return numChildren;
        }
         */ 
        
        /**
         *  @copy mx.core.IVisualElementContainer#getElementAt()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Flex 4
        public function getElementAt(index:int):IVisualElement
        {
            return getChildAt(index) as IVisualElement;
        }
         */ 
        
        /**
         *  @copy mx.core.IVisualElementContainer#getElementIndex()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Flex 4
        public function getElementIndex(element:IVisualElement):int
        {
            if (! (element is IUIComponent) )
                throw Error(element + " is not found in this Container");
                // throw Error(element + " is not found in this Container");
            
            return getChildIndex(element as IUIComponent);
        }
         */
        
        /**
         *  @copy mx.core.IVisualElementContainer#addElement()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Flex 4
        public function addElement(element:IVisualElement):IVisualElement
        {
            if (! (element is IUIComponent) )
                throw Error(element + " is not supported in this Container");
                // throw Error(element + " is not supported in this Container");
            
            return addChild(element as IUIComponent) as IVisualElement;
        }
    */ 
        
        /**
         *  @copy mx.core.IVisualElementContainer#addElementAt()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Flex 4
        public function addElementAt(element:IVisualElement, index:int):IVisualElement
        {
            if (! (element is IUIComponent) )
                throw Error(element + " is not supported in this Container");
                // throw Error(element + " is not supported in this Container");
            
            return addChildAt(element as IUIComponent, index) as IVisualElement;
        }
    */
        
        /**
         *  @copy mx.core.IVisualElementContainer#removeElement()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Flex 4
        public function removeElement(element:IVisualElement):IVisualElement
        {
                throw Error(element + " is not found in this Container");
                // throw Error(element + " is not found in this Container");
            
            return removeChild(element as IUIComponent) as IVisualElement;
        }
    */
        
        /**
         *  @copy mx.core.IVisualElementContainer#removeElementAt()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Flex 4
        public function removeElementAt(index:int):IVisualElement
        {
            return removeChildAt(index) as IVisualElement;
        }
         */
        
        /**
         *  @copy mx.core.IVisualElementContainer#removeAllElements()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Flex 4
        public function removeAllElements():void
        {
            for (var i:int = numElements - 1; i >= 0; i--)
            {
                removeElementAt(i);
            }
        }
         */
        
        /**
         *  @copy mx.core.IVisualElementContainer#setElementIndex()
         *
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Flex 4
         */
        public function setElementIndex(element:IVisualElement, index:int):void
        {
            if (! (element is IUIComponent) )
                throw /*Argument*/Error(element + " is not found in this Container");
            
            return setChildIndex(element as IUIComponent, index);
        }
        
        /**
         *  @copy mx.core.IVisualElementContainer#swapElements()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Flex 4
         */
        public function swapElements(element1:IVisualElement, element2:IVisualElement):void
        {
            if (! (element1 is IUIComponent) )
                throw /*Argument*/Error(element1 + " is not found in this Container");
            if (! (element2 is IUIComponent) )
                throw /*Argument*/Error(element2 + " is not found in this Container");
            
            //swapChildren(element1 as IUIComponent, element2 as IUIComponent);
        }
        
        /**
         *  @copy mx.core.IVisualElementContainer#swapElementsAt()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Flex 4
         */
        public function swapElementsAt(index1:int, index2:int):void
        {
            trace("Legend:swapElemetsAt not implemented");
            //swapChildrenAt(index1, index2);
        }
        
        //--------------------------------------------------------------------------
        //
        //  Overridden methods: UIComponent
        //
        //--------------------------------------------------------------------------
        
        /**
         *  @private
        override public function initialize():void
        {
            // Until component templating is implemented, the childDescriptors
            // come either from the top-level descriptor in the component itself
            // (i.e., the defined children) or from a descriptor for an instance
            // of that component in some other component or app (i.e., the
            // instance children). At this point _childDescriptors already
            // contains the instance children if there are any; but if the
            // document defines any children, we have to use them instead.
            
            if (documentDescriptor && !processedDescriptors)
            {
                // NOTE: documentDescriptor.properties is a potentially
                // expensive function call, so do it only once.
                var props:* = documentDescriptor.properties;
                if (props && props.childDescriptors)
                {
                    if (_childDescriptors)
                    {
                        var message:String = resourceManager.getString(
                            "core", "multipleChildSets_ClassAndInstance");
                        throw new Error(message);
                    }
                    else
                    {
                        _childDescriptors = props.childDescriptors;
                    }
                }
            }
            
            super.initialize();
        }
         */
        
        /**
         *  @private
         *  Create components that are children of this Container.
        override protected function createChildren():void
        {
            super.createChildren();
            
            // Create the border/background object.
            createBorder();
            
            // Determine the child-creation policy (ContainerCreationPolicy.AUTO,
            // ContainerCreationPolicy.ALL, or ContainerCreationPolicy.NONE).
            // If the author has specified a policy, use it.
            // Otherwise, use the parent's policy.
            // This must be set before createChildren() gets called.
            if (actualCreationPolicy == null)
            {
                if (creationPolicy != null)
                    actualCreationPolicy = creationPolicy;
                
                if (actualCreationPolicy == ContainerCreationPolicy.QUEUED)
                    actualCreationPolicy = ContainerCreationPolicy.AUTO;
            }
            
            // It is ok for actualCreationPolicy to be null. Popups require it.
            
            if (actualCreationPolicy == ContainerCreationPolicy.NONE)
            {
                actualCreationPolicy = ContainerCreationPolicy.AUTO;
            }
            else if (actualCreationPolicy == ContainerCreationPolicy.QUEUED)
            {
                var mainApp:* = parentApplication ?
                    parentApplication :
                    FlexGlobals.topLevelApplication;
                
                if ("addToCreationQueue" in mainApp)
                    mainApp.addToCreationQueue(this, _creationIndex, null, this);
                else // If the app doesn't support queued creation, create our components now
                    createComponentsFromDescriptors();
            }
            else if (recursionFlag)
            {
                // Create whatever children are appropriate. If any were
                // previously created, they don't get re-created.
                createComponentsFromDescriptors();
            }
            
            // If autoLayout is initially false, we still want to do
            // measurement once (even if we don't have any children)
            if (autoLayout == false)
                forceLayout = true;
            
            // weak references
            //UIComponentGlobals.layoutManager.addEventListener(
            //    FlexEvent.UPDATE_COMPLETE, layoutCompleteHandler, false, 0, true);
        }
                 */

        /**
         *  @private
         *  Override to NOT set precessedDescriptors.
         */
        override protected function initializationComplete():void
        {
            // Don't call super.initializationComplete().
        }
        
        /**
         *  @private
        override public function invalidateLayoutDirection():void
        {
            super.invalidateLayoutDirection();
            
            // We have to deal with non-styled raw children here.
            if (_rawChildren)
            {
                const rawNumChildren:int = _rawChildren.numChildren;
                
                for (var i:int = 0; i < rawNumChildren; i++)
                {
                    var child:IUIComponent = _rawChildren.getChildAt(i);
                    if (!(child is IStyleClient) && child is ILayoutDirectionElement)
                        ILayoutDirectionElement(child).invalidateLayoutDirection();
                }
            }
        }
         */
        
        /**
         *  @private
         */
        override protected function commitProperties():void
        {
            super.commitProperties();
            
            if (changedStyles)
            {
                // If multiple properties have changed, set styleProp to null.
                // Otherwise, set it to the name of the style that has changed.
                var styleProp:String = changedStyles == MULTIPLE_PROPERTIES ?
                    null :
                    changedStyles;
                
                //super.notifyStyleChangeInChildren(styleProp, true);
                
                changedStyles = null;
            }
            
            createOrDestroyBlocker();
            
            if (_childrenDirty)
            {
                populateFromArray(_dataProvider);
                _childrenDirty = false;
            }
        }
        
        /**
         *  @private
         */
        override public function validateSize(recursive:Boolean = false):void
        {
            // If autoLayout is turned off and we haven't recently created
            // or destroyed any children, then we're not doing any
            // measurement or layout.
            // Return false indicating that the measurements haven't changed.
            if (autoLayout == false && forceLayout == false)
            {
                if (recursive)
                {
                    var n:int = super.numChildren;
                    for (var i:int = 0; i < n; i++)
                    {
                        var child:IUIComponent = super.getChildAt(i);
                        if (child is ILayoutManagerClient )
                            ILayoutManagerClient (child).validateSize(true);
                    }
                }
                //adjustSizesForScaleChanges();
            }
            else
            {
                super.validateSize(recursive);
            }
        }
        
        /**
         *  @private
         */
        override public function validateDisplayList():void
        {
            // trace(">>Container validateLayoutPhase " + this);
            
            var vm:EdgeMetrics;
            
            // If autoLayout is turned off and we haven't recently created or
            // destroyed any children, then don't do any layout
            if (_autoLayout || forceLayout)
            {
                doingLayout = true;
                super.validateDisplayList();
                doingLayout = false;
            }
            else
            {
                // Layout borders, Panel headers, and other border chrome.
                layoutChrome(unscaledWidth, unscaledHeight);
            }
            
            // Set this to block requeuing when sizing children.
            //invalidateDisplayListFlag = true;
            
            // Based on the positions of the children, determine
            // whether a clip mask and scrollbars are needed.
            if (createContentPaneAndScrollbarsIfNeeded())
            {
                // Redo layout if scrollbars just got created or destroyed (because
                // now we may have more or less space).
                if (_autoLayout || forceLayout)
                {
                    doingLayout = true;
                    super.validateDisplayList();
                    doingLayout = false;
                }
                
                // If a scrollbar was created, that may precipitate the need
                // for a second scrollbar, so run it a second time.
                createContentPaneAndScrollbarsIfNeeded();
            }
            
            // The relayout performed by the above calls
            // to super.validateDisplayList() may result
            // in new max scroll positions that are less
            // than previously-set scroll positions.
            // For example, when a maximally-scrolled container
            // is resized to be larger, the new max scroll positions
            // are reduced and the current scroll positions
            // will be invalid unless we clamp them.
            if (clampScrollPositions())
                scrollChildren();
            
            if (contentPane)
            {
                vm = viewMetrics;
                
                /*
                // Set the position and size of the overlay .
                if (effectOverlay)
                {
                    effectOverlay.x = 0;
                    effectOverlay.y = 0;
                    effectOverlay.width = unscaledWidth;
                    effectOverlay.height = unscaledHeight;
                }
                */
                
                // Set the positions and sizes of the scrollbars.
                /*if (horizontalScrollBar || verticalScrollBar)
                {
                    // Get the view metrics and remove the thickness
                    // of the scrollbars from the view metrics.
                    // We can't simply get the border metrics,
                    // because some subclass (e.g.: Window)
                    // might add to the metrics.
                    if (verticalScrollBar &&
                        verticalScrollPolicy == ScrollPolicy.ON)
                    {
                        vm.right -= verticalScrollBar.minWidth;
                    }
                    if (horizontalScrollBar &&
                        horizontalScrollPolicy == ScrollPolicy.ON)
                    {
                        vm.bottom -= horizontalScrollBar.minHeight;
                    }
                    
                    if (horizontalScrollBar)
                    {
                        var w:Number = unscaledWidth - vm.left - vm.right;
                        if (verticalScrollBar)
                            w -= verticalScrollBar.minWidth;
                        
                        horizontalScrollBar.setActualSize(
                            w, horizontalScrollBar.minHeight);
                        
                        horizontalScrollBar.move(vm.left,
                            unscaledHeight - vm.bottom -
                            horizontalScrollBar.minHeight);
                    }
                    
                    if (verticalScrollBar)
                    {
                        var h:Number = unscaledHeight - vm.top - vm.bottom;
                        if (horizontalScrollBar)
                            h -= horizontalScrollBar.minHeight;
                        
                        verticalScrollBar.setActualSize(
                            verticalScrollBar.minWidth, h);
                        
                        verticalScrollBar.move(unscaledWidth - vm.right -
                            verticalScrollBar.minWidth,
                            vm.top);
                    }
                    
                    // Set the position of the box
                    // that covers the gap between the scroll bars.
                    if (whiteBox)
                    {
                        whiteBox.x = verticalScrollBar.x;
                        whiteBox.y = horizontalScrollBar.y;
                    }
                }*/
                
                contentPane.x = vm.left;
                contentPane.y = vm.top;
                
                /*
                if (focusPane)
                {
                    focusPane.x = vm.left
                    focusPane.y = vm.top;
                }
                */
                
                scrollChildren();
            }
            
            //invalidateDisplayListFlag = false;
            
            // that blocks UI input as well as draws an alpha overlay.
            // Make sure the blocker is correctly positioned and sized here.
            if (blocker)
            {
                vm = viewMetrics;
                
                //if (FlexVersion.compatibilityVersion >= FlexVersion.VERSION_4_0)
                    vm = EdgeMetrics.EMPTY;
                
                var bgColor:Object = enabled ?
                    null :
                    getStyle("backgroundDisabledColor");
                if (bgColor === null || isNaN(Number(bgColor)))
                    bgColor = getStyle("backgroundColor");
                
                if (bgColor === null || isNaN(Number(bgColor)))
                    bgColor = 0xFFFFFF;
                
                var blockerAlpha:Number = getStyle("disabledOverlayAlpha");
                
                if (isNaN(blockerAlpha))
                    blockerAlpha = 0.6;
                
                blocker.x = vm.left;
                blocker.y = vm.top;
                
                var widthToBlock:Number = unscaledWidth - (vm.left + vm.right);
                var heightToBlock:Number = unscaledHeight - (vm.top + vm.bottom);
                
                blocker.graphics.clear();
                blocker.graphics.beginFill(uint(bgColor), blockerAlpha);
                blocker.graphics.drawRect(0, 0, widthToBlock, heightToBlock);
                blocker.graphics.endFill();
                
                // Blocker must be in front of everything
                rawChildren.setChildIndex(blocker, rawChildren.numChildren - 1);
            }
            
            // trace("<<Container internalValidateDisplayList " + this);
        }
        
        /**
         *  Respond to size changes by setting the positions and sizes
         *  of this container's children.
         *
         *  <p>See the <code>UIComponent.updateDisplayList()</code> method for more information
         *  about the <code>updateDisplayList()</code> method.</p>
         *
         *  <p>The <code>Container.updateDisplayList()</code> method sets the position
         *  and size of the Container container's border.
         *  In every subclass of Container, the subclass's <code>updateDisplayList()</code>
         *  method should call the <code>super.updateDisplayList()</code> method,
         *  so that the border is positioned properly.</p>
         *
         *  @param unscaledWidth Specifies the width of the component, in pixels,
         *  in the component's coordinates, regardless of the value of the
         *  <code>scaleX</code> property of the component.
         *
         *  @param unscaledHeight Specifies the height of the component, in pixels,
         *  in the component's coordinates, regardless of the value of the
         *  <code>scaleY</code> property of the component.
         *
         *  @see mx.core.UIComponent
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        override protected function updateDisplayList(unscaledWidth:Number,
                                                      unscaledHeight:Number):void
        {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            
            layoutChrome(unscaledWidth, unscaledHeight);
            
            if (scrollPositionChanged)
            {
                clampScrollPositions();
                
                scrollChildren();
                
                scrollPositionChanged = false;
            }
                        
            /*
            if (contentPane && contentPane.scrollRect)
            {
                // Draw content pane
                
                var backgroundColor:Object = enabled ?
                    null :
                    getStyle("backgroundDisabledColor");
                
                if (backgroundColor === null || isNaN(Number(backgroundColor)))
                    backgroundColor = getStyle("backgroundColor");
                
                var backgroundAlpha:Number = getStyle("backgroundAlpha");
                
                if (!_clipContent ||
                    isNaN(Number(backgroundColor)) ||
                    backgroundColor === "" ||
                    (!cacheAsBitmap))
                {
                    backgroundColor = null;
                }
                    
                    // If there's a backgroundImage or background, unset
                    // opaqueBackground.
                else if (getStyle("backgroundImage") ||
                    getStyle("background"))
                {
                    backgroundColor = null;
                }
                    
                    // If the background is not opaque, unset opaqueBackground.
                else if (backgroundAlpha != 1)
                {
                    backgroundColor = null;
                }
                
                contentPane.opaqueBackground = backgroundColor;
                
                // Set cacheAsBitmap only if opaqueBackground is also set (to avoid
                // text anti-aliasing issue with device text on Windows).
                contentPane.cacheAsBitmap = (backgroundColor != null);
            }
            */
            
            // The measure function isn't called if the width and height of
            // the Tile are hard-coded. In that case, we compute the cellWidth
            // and cellHeight now.
            if (isNaN(cellWidth) || isNaN(cellHeight))
                findCellSize();
            
            var vm:EdgeMetrics = viewMetricsAndPadding;
            
            var paddingLeft:Number = getStyle("paddingLeft");
            var paddingTop:Number = getStyle("paddingTop");
            
            var horizontalGap:Number = getStyle("horizontalGap");
            var verticalGap:Number = getStyle("verticalGap");
            
            var horizontalAlign:String = getStyle("horizontalAlign");
            var verticalAlign:String = getStyle("verticalAlign");
            
            var xPos:Number = paddingLeft;
            var yPos:Number = paddingTop;
            
            var xOffset:Number;
            var yOffset:Number;
            
            var n:int = numChildren;
            var i:int;
            var child:IUIComponent;
            
            if (direction == "horizontal")
            {
                var xEnd:Number = Math.ceil(unscaledWidth) - vm.right;
                
                for (i = 0; i < n; i++)
                {
                    child = getLayoutChildAt(i);
                    
                    if (!child.includeInLayout)
                        continue;
                    
                    // Start a new row?
                    if (xPos + cellWidth > xEnd)
                    {
                        // Only if we have not just started one...
                        if (xPos != paddingLeft)
                        {
                            yPos += (cellHeight + verticalGap);
                            xPos = paddingLeft;
                        }
                    }
                    
                    setChildSize(child); // calls child.setActualSize()
                    
                    // Calculate the offsets to align the child in the cell.
                    xOffset = Math.floor(calcHorizontalOffset(
                        child.width, horizontalAlign));
                    yOffset = Math.floor(calcVerticalOffset(
                        child.height, verticalAlign));
                    
                    child.move(xPos + xOffset, yPos + yOffset);
                    
                    xPos += (cellWidth + horizontalGap);
                }
            }
            else
            {
                var yEnd:Number = Math.ceil(unscaledHeight) - vm.bottom;
                
                for (i = 0; i < n; i++)
                {
                    child = getLayoutChildAt(i);
                    
                    if (!child.includeInLayout)
                        continue;
                    
                    // Start a new column?
                    if (yPos + cellHeight > yEnd)
                    {
                        // Only if we have not just started one...
                        if (yPos != paddingTop)
                        {
                            xPos += (cellWidth + horizontalGap);
                            yPos = paddingTop;
                        }
                    }
                    
                    setChildSize(child); // calls child.setActualSize()
                    
                    // Calculate the offsets to align the child in the cell.
                    xOffset = Math.floor(calcHorizontalOffset(
                        child.width, horizontalAlign));
                    yOffset = Math.floor(calcVerticalOffset(
                        child.height, verticalAlign));
                    
                    child.move(xPos + xOffset, yPos + yOffset);
                    
                    yPos += (cellHeight + verticalGap);
                }
            }
            
            // Clear the cached cell size, because if a child's size changes
            // it will be invalid. These cached values are only used to
            // avoid recalculating in updateDisplayList() the same values
            // that were just calculated in measure().
            // They should not persist across invalidation/validation cycles.
            // (An alternative approach we tried was to clear these
            // values in an override of invalidateSize(), but this gets called
            // called indirectly by setChildSize() and child.move() inside
            // the loops above. So we had to save and restore cellWidth
            // and cellHeight around these calls in the loops, which is ugly.)
            cellWidth = NaN;
            cellHeight = NaN;
            
            _unscaledWidth = unscaledWidth;
            _unscaledHeight = unscaledHeight;
            
            // The measure function isn't called if the width and height of
            // the Tile are hard-coded.  In that case, we compute the cellWidth
            // and cellHeight now.
            if (isNaN(cellWidth))
                findCellSize();
            
            if (direction == "vertical")
                layoutVertical();
            else
                layoutHorizontal();
        }
        
        /**
         *  @copy mx.core.UIComponent#contentToGlobal()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
        override public function contentToGlobal(point:Point):Point
        {
            if (contentPane)
                return contentPane.localToGlobal(point);
            
            return localToGlobal(point);
        }
         */
        
        /**
         *  @copy mx.core.UIComponent#globalToContent()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
        override public function globalToContent(point:Point):Point
        {
            if (contentPane)
                return contentPane.globalToLocal(point);
            
            return globalToLocal(point);
        }
         */
        
        /**
         *  @copy mx.core.UIComponent#contentToLocal()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
        override public function contentToLocal(point:Point):Point
        {
            if (!contentPane)
                return point;
            
            point = contentToGlobal(point);
            return globalToLocal(point);
        }
         */
        
        /**
         *  @copy mx.core.UIComponent#localToContent()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
        override public function localToContent(point:Point):Point
        {
            if (!contentPane)
                return point;
            
            point = localToGlobal(point);
            return globalToContent(point);
        }
         */
        
        /**
         *  @private
        override public function styleChanged(styleProp:String):void
        {
            var allStyles:Boolean = styleProp == null || styleProp == "styleName";
            
            // Check to see if this is one of the style properties that is known
            // to affect page layout.
            if (allStyles || styleManager.isSizeInvalidatingStyle(styleProp))
            {
                // Some styles, such as horizontalAlign and verticalAlign,
                // affect the layout of this object's children without changing the
                // view's size.  This function forces the view to be remeasured
                // and layed out.
                invalidateDisplayList();
            }
            
            // Replace the borderSkin
            if (allStyles || styleProp == "borderSkin")
            {
                if (border)
                {
                    rawChildren.removeChild(IUIComponent(border));
                    border = null;
                    createBorder();
                }
            }
            
            // Create a border object, if none previously existed and
            // one is needed now.
            if (allStyles ||
                styleProp == "borderStyle" ||
                styleProp == "backgroundColor" ||
                styleProp == "backgroundImage" ||
                styleProp == "mouseShield" ||
                styleProp == "mouseShieldChildren")
            {
                createBorder();
            }
            
            super.styleChanged(styleProp);
            
            // Check to see if this is one of the style properties that is known.
            // to affect page layout.
            if (allStyles ||
                styleManager.isSizeInvalidatingStyle(styleProp))
            {
                invalidateViewMetricsAndPadding();
            }
        }
         */
        
        /**
         *  @private
         *  Call the styleChanged method on children of this container
         *
         *  Notify chrome children immediately, and recursively call this
         *  function for all descendants of the chrome children.  We recurse
         *  regardless of the recursive flag because one of the descendants
         *  might have a styleName property that points to this object.
         *
         *  If recursive is true, then also notify content children ... but
         *  do it later.  Notification is deferred so that multiple calls to
         *  setStyle can be batched up into one traversal.
        override public function notifyStyleChangeInChildren(
            styleProp:String, recursive:Boolean):void
        {
            // Notify chrome children immediately, recursively calling this
            // this function
            var n:int = super.numChildren;
            for (var i:int = 0; i < n; i++)
            {
                // Is this a chrome child?
                if (contentPane ||
                    i < _firstChildIndex ||
                    i >= _firstChildIndex + _numChildren)
                {
                    var child:ISimpleStyleClient = super.getChildAt(i) as ISimpleStyleClient;
                    if (child)
                    {
                        child.styleChanged(styleProp);
                        if (child is IStyleClient)
                            IStyleClient(child).notifyStyleChangeInChildren(styleProp, recursive);
                    }
                }
            }
            
            // If recursive, then remember to notify the content children later
            if (recursive)
            {
                // If multiple styleProps have changed, set changedStyles to
                // MULTIPLE_PROPERTIES.  Otherwise, set it to the name of the
                // changed property.
                changedStyles = (changedStyles != null || styleProp == null) ?
                    MULTIPLE_PROPERTIES : styleProp;
                invalidateProperties();
            }
        }
         */
        
        /**
         *  @private
        override public function regenerateStyleCache(recursive:Boolean):void
        {
            super.regenerateStyleCache(recursive);
            
            if (contentPane)
            {
                // Do the same thing as UIComponent, but don't check the child's index to
                // ascertain that it's a content child (we already know that here).
                
                var n:int = contentPane.numChildren;
                for (var i:int = 0; i < n; i++)
                {
                    var child:IUIComponent = getChildAt(i);
                    
                    if (child is UIComponent)
                    {
                        // Does this object already have a proto chain?  If not,
                        // there's no need to regenerate a new one.
                        if (UIComponent(child).inheritingStyles != StyleProtoChain.STYLE_UNINITIALIZED)
                            UIComponent(child).regenerateStyleCache(recursive);
                    }
                    else if (child is IUITextField && IUITextField(child).inheritingStyles)
                    {
                        StyleProtoChain.initTextField(IUITextField(child));
                    }
                }
            }
        }
         */
        
        /**
         *  Used internally by the Dissolve Effect to add the overlay to the chrome of a container. 
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
        override protected function attachOverlay():void
        {
            rawChildren_addChild(effectOverlay);
        }
         */
        
        /**
         *  Fill an overlay object which is always the topmost child in the container.
         *  This method is used
         *  by the Dissolve effect; never call it directly. It is called
         *  internally by the <code>addOverlay()</code> method.
         *
         *  The Container fills the overlay object so it covers the viewable area returned
         *  by the <code>viewMetrics</code> property and uses the <code>cornerRadius</code> style.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
        override mx_internal function fillOverlay(overlay:UIComponent, color:uint,
                                                  targetArea:RoundedRectangle = null):void
        {
            var vm:EdgeMetrics = viewMetrics;
            var cornerRadius:Number = 0; //getStyle("cornerRadius");
            
            if (!targetArea)
            {
                targetArea = new RoundedRectangle(
                    vm.left, vm.top,
                    unscaledWidth - vm.right - vm.left,
                    unscaledHeight - vm.bottom - vm.top,cornerRadius);
            }
            
            if (isNaN(targetArea.x) || isNaN(targetArea.y) ||
                isNaN(targetArea.width) || isNaN(targetArea.height) ||
                isNaN(targetArea.cornerRadius))
                return;
            
            var g:Graphics = overlay.graphics;
            g.clear();
            g.beginFill(color);
            g.drawRoundRect(targetArea.x, targetArea.y,
                targetArea.width, targetArea.height,
                targetArea.cornerRadius * 2,
                targetArea.cornerRadius * 2);
            g.endFill();
        }
         */
        
        /**
         *  Executes all the data bindings on this Container. Flex calls this method
         *  automatically once a Container has been created to cause any data bindings that
         *  have destinations inside of it to execute.
         *
         *  Workaround for MXML container/bindings problem (177074):
         *  override Container.executeBindings() to prefer descriptor.document over parentDocument in the
         *  call to BindingManager.executeBindings().
         *
         *  This should always provide the correct behavior for instances created by descriptor, and will
         *  provide the original behavior for procedurally-created instances. (The bug may or may not appear
         *  in the latter case.)
         *
         *  A more complete fix, guaranteeing correct behavior in both non-DI and reparented-component
         *  scenarios, is anticipated for updater 1.
         *
         *  @param recurse If <code>false</code>, then only execute the bindings
         *  on this Container. 
         *  If <code>true</code>, then also execute the bindings on this
         *  container's children, grandchildren,
         *  great-grandchildren, and so on.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
        override public function executeBindings(recurse:Boolean = false):void
        {
            var bindingsHost:Object = descriptor && descriptor.document ? descriptor.document : parentDocument;
            BindingManager.executeBindings(bindingsHost, id, this);
            
            if (recurse)
                executeChildBindings(recurse);
        }
         */
        
        /**
         *  @private
         *  Prepare the Object for printing
         *
         *  @see mx.printing.FlexPrintJob
        override public function prepareToPrint(target:IFlexDisplayObject):Object
        {
            var rect:Rectangle = (contentPane &&  contentPane.scrollRect) ? contentPane.scrollRect : null;
            
            if (rect)
                contentPane.scrollRect = null;
            
            super.prepareToPrint(target);
            
            return rect;
        }
         */
        
        /**
         *  @private
         *  After printing is done
         *
         *  @see mx.printing.FlexPrintJob
        override public function finishPrint(obj:Object, target:IFlexDisplayObject):void
        {
            if (obj)
                contentPane.scrollRect = Rectangle(obj);
            
            super.finishPrint(obj,target);
        }
         */
        
        //--------------------------------------------------------------------------
        //
        //  Methods: Child management
        //
        //--------------------------------------------------------------------------
        
        /**
         *  @private
         */
        override mx_internal function addingChild(child:IUIComponent):void
        {
            // Throw an RTE if child is not an IUIComponent.
            var uiChild:IUIComponent = IUIComponent(child);
            
            // Set the child's virtual parent, nestLevel, document, etc.
            super.addingChild(child);
            
            invalidateSize();
            invalidateDisplayList();
            
            if (!contentPane)
            {
                // If this is the first content child, then any chrome
                // that already exists is positioned in front of it.
                // If other content children already existed, then set the
                // depth of this object to be just behind the existing
                // content children.
                if (_numChildren == 0)
                    _firstChildIndex = super.numChildren;
                
                // Increment the number of content children.
                _numChildren++;
            }
            
            if (contentPane && !autoLayout)
            {
                forceLayout = true;
                // weak reference
                //UIComponentGlobals.layoutManager.addEventListener(
                //    FlexEvent.UPDATE_COMPLETE, layoutCompleteHandler, false, 0, true);
            }
        }
        
        /**
         *  @private
         */
        override mx_internal function childAdded(child:IUIComponent):void
        {
            /*
            if (hasEventListener("childrenChanged"))
                dispatchEvent(new Event("childrenChanged"));
            
            if (hasEventListener(ChildExistenceChangedEvent.CHILD_ADD))
            {
                var event:ChildExistenceChangedEvent =
                    new ChildExistenceChangedEvent(
                        ChildExistenceChangedEvent.CHILD_ADD);
                event.relatedObject = child;
                dispatchEvent(event);
            }
            
            if (hasEventListener(FlexEvent.ADD))
                child.dispatchEvent(new FlexEvent(FlexEvent.ADD));
            
            super.childAdded(child); // calls createChildren()
            */
        }
        
        /**
         *  @private
         */
        override mx_internal function removingChild(child:IUIComponent):void
        {
            /*
            super.removingChild(child);
            
            if (hasEventListener(FlexEvent.REMOVE))
                child.dispatchEvent(new FlexEvent(FlexEvent.REMOVE));
            
            if (hasEventListener(ChildExistenceChangedEvent.CHILD_REMOVE))
            {
                var event:ChildExistenceChangedEvent =
                    new ChildExistenceChangedEvent(
                        ChildExistenceChangedEvent.CHILD_REMOVE);
                event.relatedObject = child;
                dispatchEvent(event);
            }
            */
        }
        
        /**
         *  @private
         */
        override mx_internal function childRemoved(child:IUIComponent):void
        {
            super.childRemoved(child);
            
            invalidateSize();
            invalidateDisplayList();
            
            if (!contentPane)
            {
                _numChildren--;
                
                if (_numChildren == 0)
                    _firstChildIndex = super.numChildren;
            }
            
            if (contentPane && !autoLayout)
            {
                forceLayout = true;
                // weak reference
                //UIComponentGlobals.layoutManager.addEventListener(
                //    FlexEvent.UPDATE_COMPLETE, layoutCompleteHandler, false, 0, true);
            }
            
            if (hasEventListener("childrenChanged"))
                dispatchEvent(new Event("childrenChanged"));
        }
        
        [Bindable("childrenChanged")]
        
        /**
         *  Returns an Array of DisplayObject objects consisting of the content children 
         *  of the container.
         *  This array does <b>not</b> include the DisplayObjects that implement 
         *  the container's display elements, such as its border and 
         *  the background image.
         *
         *  @return Array of DisplayObject objects consisting of the content children 
         *  of the container.
         * 
         *  @see #rawChildren
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function getChildren():Array
        {
            var results:Array = [];
            
            var n:int = numChildren;
            for (var i:int = 0; i < n; i++)
            {
                results.push(getChildAt(i));
            }
            
            return results;
        }
        
        /**
         *  Removes all children from the child list of this container.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function removeAllChildren():void
        {
            while (numChildren > 0)
            {
                removeChildAt(0);
            }
        }
        
        //--------------------------------------------------------------------------
        //
        //  Methods: Deferred instantiation
        //
        //--------------------------------------------------------------------------
        
        /**
         *  @private
         *  For containers, we need to ensure that at most one set of children
         *  has been specified for the component.
         *  There are two ways to specify multiple sets of children:
         *  a) the component itself, as well as an instance of the component,
         *  might specify children;
         *  b) both a base and derived component might specify children.
         *  Case (a) is handled in initialize(), above.
         *  Case (b) is handled here.
         *  This method is called in overrides of initialize()
         *  that are generated for MXML components.
         */
        mx_internal function setDocumentDescriptor(/*desc:UIComponentDescriptor*/):void
        {
            /*
            if (processedDescriptors)
                return;
            
            if (_documentDescriptor && _documentDescriptor.properties.childDescriptors)
            {
                if (desc.properties.childDescriptors)
                {
                    var message:String = resourceManager.getString(
                        "core", "multipleChildSets_ClassAndSubclass");
                    throw new Error(message);
                }
            }
            else
            {
                _documentDescriptor = desc;
                _documentDescriptor.document = this;
            }
            */
        }
        
        /**
         *  @private
         *  Used by subclasses, so must be public.
         */
        mx_internal function setActualCreationPolicies(policy:String):void
        {
            /*
            actualCreationPolicy = policy;
            
            // Recursively set the actualCreationPolicy of all descendant
            // containers which have an undefined creationPolicy.
            var childPolicy:String = policy;
            
            if (policy == ContainerCreationPolicy.QUEUED)
                childPolicy = ContainerCreationPolicy.AUTO;
            
            //trace("setActualCreationPolicies policy", policy, "childPolicy", childPolicy);
            
            var n:int = numChildren;
            for (var i:int = 0; i < n; i++)
            {
                var child:IFlexDisplayObject = IFlexDisplayObject(getChildAt(i));
                *//*if (child is Container)
                {
                    var childContainer:Container = Container(child);
                    if (childContainer.creationPolicy == null)
                        childContainer.setActualCreationPolicies(childPolicy);
                }*//*
            }*/
        }
        
        
        /**
         *  Iterate through the Array of <code>childDescriptors</code>,
         *  and call the <code>createComponentFromDescriptor()</code> method for each one.
         *  
         *  <p>If the value of the container's <code>creationPolicy</code> property is
         *  <code>ContainerCreationPolicy.ALL</code>, then this method is called
         *  automatically during the initialization sequence.</p>
         *  
         *  <p>If the value of the container's <code>creationPolicy</code> is
         *  <code>ContainerCreationPolicy.AUTO</code>,
         *  then this method is called automatically when the
         *  container's children are about to become visible.</p>
         *  
         *  <p>If the value of the container's <code>creationPolicy</code> property is
         *  <code>ContainerCreationPolicy.NONE</code>,
         *  then you should call this function
         *  when you want to create this container's children.</p>
         *
         *  @param recurse If <code>true</code>, recursively
         *  create components.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
        public function createComponentsFromDescriptors(
            recurse:Boolean = true):void
        {
            numChildrenBefore = numChildren;
            
            createdComponents = [];
            
            var n:int = childDescriptors ? childDescriptors.length : 0;
            for (var i:int = 0; i < n; i++)
            {
                var component:IFlexDisplayObject =
                    createComponentFromDescriptor(childDescriptors[i], recurse);
                
                createdComponents.push(component);
            }
            
            if (creationPolicy == ContainerCreationPolicy.QUEUED ||
                creationPolicy == ContainerCreationPolicy.NONE)
            {
                UIComponentGlobals.layoutManager.usePhasedInstantiation = false;
            }
            
            numChildrenCreated = numChildren - numChildrenBefore;
            
            processedDescriptors = true;
            dispatchEvent(new FlexEvent(FlexEvent.CONTENT_CREATION_COMPLETE));
        }
         */
        
        /**
         *  Performs the equivalent action of calling 
         *  the <code>createComponentsFromDescriptors(true)</code> method for containers 
         *  that implement the IDeferredContentOwner interface to support deferred instantiation.
         *
         *  @see #createComponentsFromDescriptors()
         *
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Flex 4
         */
        public function createDeferredContent():void
        {
            //createComponentsFromDescriptors(true);
        }
        
        /**
         *  Given a single UIComponentDescriptor, create the corresponding
         *  component and add the component as a child of this container.
         *  
         *  <p>This method instantiates the new object but does not add it to the display list, so the object does not 
         *  appear on the screen by default. To add the new object to the display list, call the <code>validateNow()</code>
         *  method on the container after calling the <code>createComponentFromDescriptor()</code> method,
         *  as the following example shows:
         *  <pre>
         *  myVBox.createComponentFromDescriptor(myVBox.childDescriptors[0],false);
         *  myVBox.validateNow();
         *  </pre>
         *  </p>
         *  
         *  <p>Alternatively, you can call the <code>createComponentsFromDescriptors()</code> method on the 
         *  container to create all components at one time. You are not required to call the <code>validateNow()</code>
         *  method after calling the <code>createComponentsFromDescriptors()</code> method.</p>
         *
         *  @param descriptor The UIComponentDescriptor for the
         *  component to be created. This argument is either a
         *  UIComponentDescriptor object or the index of one of the container's
         *  children (an integer between 0 and n-1, where n is the total
         *  number of children of this container).
         *
         *  @param recurse If <code>false</code>, create this component
         *  but none of its children.
         *  If <code>true</code>, after creating the component, Flex calls
         *  the <code>createComponentsFromDescriptors()</code> method to create all or some
         *  of its children, based on the value of the component's <code>creationPolicy</code> property.
         *
         *  @return The component that is created.
         * 
         *  @see mx.core.UIComponentDescriptor
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
        public function createComponentFromDescriptor(
            descriptor:ComponentDescriptor,
            recurse:Boolean):IFlexDisplayObject
        {
            // If recurse is 'false', we create this component but none
            // of its children.
            
            // If recurse is 'true', after creating the component we call
            // createComponentsFromDescriptors() to create all or some
            // of its children, based on the component's
            // actualContainerCreationPolicy.
            
            var childDescriptor:UIComponentDescriptor =
                UIComponentDescriptor(descriptor);
            
            var childProperties:Object = childDescriptor.properties;
            
            // This function could be asked to create the same child component
            // twice.  That's fine if the child component is inside a repeater.
            // In other cases, though, we want to avoid creating the same child
            // twice.
            //
            // The hasChildMatchingDescriptor function is a bit expensive, so
            // we try to avoid calling it if we know we're inside the first call
            // to createComponents.
            if ((numChildrenBefore != 0 || numChildrenCreated != -1) &&
                childDescriptor.instanceIndices == null &&
                hasChildMatchingDescriptor(childDescriptor))
            {
                return null;
            }
            
            // Turn on the three-frame instantiation scheme.
            UIComponentGlobals.layoutManager.usePhasedInstantiation = true;
            
            // Create the new child object and give it a unique name
            var childType:Class = childDescriptor.type;
            var child:IDeferredInstantiationUIComponent = new childType();
            child.id = childDescriptor.id;
            if (child.id && child.id != "")
                child.name = child.id;
            
            // Copy property values from the descriptor
            // to the newly created component.
            child.descriptor = childDescriptor;
            if (childProperties.childDescriptors && child is IContainer && (child as Object).hasOwnProperty("_childDescriptors"))
            {
                (child as Object)._childDescriptors =
                    childProperties.childDescriptors;
                delete childProperties.childDescriptors;
            }
            for (var p:String in childProperties)
            {
                child[p] = childProperties[p];
            }
            
            // Set a flag indicating whether we should call
            // this function recursively.
            if (child is IContainer && (child as Object).hasOwnProperty("recursionFlag"))
                (child as Object).recursionFlag = recurse;
            
            if (childDescriptor.instanceIndices)
            {
                if (child is IRepeaterClient)
                {
                    var rChild:IRepeaterClient = IRepeaterClient(child);
                    rChild.instanceIndices = childDescriptor.instanceIndices;
                    rChild.repeaters = childDescriptor.repeaters;
                    rChild.repeaterIndices = childDescriptor.repeaterIndices;
                }
            }
            
            if (child is IStyleClient)
            {
                var scChild:IStyleClient = IStyleClient(child);
                
                // Initialize the CSSStyleDeclaration.
                // It is used by initProtoChain(), which is called by addChild().
                if (childDescriptor.stylesFactory != null)
                {
                    if (!scChild.styleDeclaration)
                        scChild.styleDeclaration = new CSSStyleDeclaration(null, styleManager);
                    scChild.styleDeclaration.factory =
                        childDescriptor.stylesFactory;
                }
            }
            
            // For each event, register the handle method, which is specified in
            // the descriptor by name, as one of the child's event listeners.
            var childEvents:Object = childDescriptor.events;
            if (childEvents)
            {
                for (var eventName:String in childEvents)
                {
                    var eventHandler:String = childEvents[eventName];
                    child.addEventListener(eventName,
                        childDescriptor.document[eventHandler]);
                }
            }
            
            // For each effect, register the EffectManager as an event listener
            var childEffects:Array = childDescriptor.effects;
            if (childEffects)
                child.registerEffects(childEffects);
            
            if (child is IRepeaterClient)
                IRepeaterClient(child).initializeRepeaterArrays(this);
            
            // If an MXML id was specified, create a property with this name on
            // the MXML document object whose value references the child.
            // This should be the last step in initializing the child, so that
            // it can't be referenced until initialization is complete.
            // However, it must be done before executing executeBindings().
            child.createReferenceOnParentDocument(
                IFlexDisplayObject(childDescriptor.document));
            
            if (!child.document)
                child.document = childDescriptor.document;
            
            // Repeaters don't get added as children of the Container,
            // so they have their own initialization sequence.
            if (child is IRepeater)
            {
                // Add this repeater to the list maintained by the parent
                // container
                if (!childRepeaters)
                    childRepeaters = [];
                childRepeaters.push(child);
                
                // The Binding Manager may have some data that it wants to bind to
                // various properties of the newly created repeater.
                child.executeBindings();
                
                IRepeater(child).initializeRepeater(this, recurse);
            }
            else
            {
                // This needs to run before child.executeBindings(), because
                // executeBindings() depends on the parent being set.
                addChild(IUIComponent(child));
                
                child.executeBindings();
                
                if (creationPolicy == ContainerCreationPolicy.QUEUED ||
                    creationPolicy == ContainerCreationPolicy.NONE)
                {
                    child.addEventListener(FlexEvent.CREATION_COMPLETE,
                        creationCompleteHandler);
                }
            }
            
            // Return a reference to the child UIComponent that was just created.
            return child;
        }
                 */

        /**
         *  @private
        private function hasChildMatchingDescriptor(
            descriptor:UIComponentDescriptor):Boolean
        {
            // Optimization: If the descriptor has an id but no such id
            // reference exists on the document, then there are no children
            // in this container with that descriptor.
            // (On the other hand, if there IS an id reference on the document,
            // we can't be sure that it is for a child of this container. It
            // could be an indexed reference in which some instances are
            // in other containers. This happens when you have
            // <Repeater>
            //     <VBox>
            //         <Button>
            var id:String = descriptor.id;
            if (id != null && (id in document) && document[id] == null)
                return false;
            
            var n:int = numChildren;
            var i:int;
            
            // Iterate over this container's children, looking for one
            // that matches this descriptor
            for (i = 0; i < n; i++)
            {
                var child:IUIComponent = IUIComponent(getChildAt(i));
                if (child is IDeferredInstantiationUIComponent &&
                    IDeferredInstantiationUIComponent(child)
                    .descriptor == descriptor)
                {
                    return true;
                }
            }
            
            // Also check this container's Repeaters, if there are any.
            if (childRepeaters)
            {
                n = childRepeaters.length;
                for (i = 0; i < n; i++)
                {
                    if (IDeferredInstantiationUIComponent(childRepeaters[i])
                        .descriptor == descriptor)
                    {
                        return true;
                    }
                }
            }
            
            return false;
        }
                 */

        //--------------------------------------------------------------------------
        //
        //  Methods: Support for rawChildren access
        //
        //--------------------------------------------------------------------------
        
        /**
         *  @private
         *  This class overrides addChild() to deal with only content children,
         *  so in order to implement the rawChildren property we need
         *  a parallel method that deals with all children.
         */
        mx_internal function rawChildren_addChild(child:IUIComponent):IUIComponent
        {
            // This method is only used to implement rawChildren.addChild(),
            // so the child being added is assumed to be a non-content child.
            // (You would use just addChild() to add a content child.)
            // If there are no content children, the new child is placed
            // in the pre-content partition.
            // If there are content children, the new child is placed
            // in the post-content partition.
            if (_numChildren == 0)
                _firstChildIndex++;
            
            super.addingChild(child);
            $uibase_addChild(child);
            super.childAdded(child);
            
            dispatchEvent(new Event("childrenChanged"));
            
            return child;
        }
        
        /**
         *  @private
         *  This class overrides addChildAt() to deal with only content children,
         *  so in order to implement the rawChildren property we need
         *  a parallel method that deals with all children.
         */
        mx_internal function rawChildren_addChildAt(child:IUIComponent,
                                                    index:int):IUIComponent
        {
            if (_firstChildIndex < index &&
                index < _firstChildIndex + _numChildren + 1)
            {
                _numChildren++;
            }
            else if (index <= _firstChildIndex)
            {
                _firstChildIndex++;
            }
            
            super.addingChild(child);
            $uibase_addChildAt(child, index);
            super.childAdded(child);
            
            dispatchEvent(new Event("childrenChanged"));
            
            return child;
        }
        
        /**
         *  @private
         *  This class overrides removeChild() to deal with only content children,
         *  so in order to implement the rawChildren property we need
         *  a parallel method that deals with all children.
         */
        mx_internal function rawChildren_removeChild(
            child:IUIComponent):IUIComponent
        {
            var index:int = rawChildren_getChildIndex(child);
            return rawChildren_removeChildAt(index);
        }
        
        /**
         *  @private
         *  This class overrides removeChildAt() to deal with only content children,
         *  so in order to implement the rawChildren property we need
         *  a parallel method that deals with all children.
         */
        mx_internal function rawChildren_removeChildAt(index:int):IUIComponent
        {
            var child:IUIComponent = super.getChildAt(index);
            
            super.removingChild(child);
            $uibase_removeChildAt(index);
            super.childRemoved(child);
            
            if (_firstChildIndex < index &&
                index < _firstChildIndex + _numChildren)
            {
                _numChildren--;
            }
            else if (_numChildren == 0 || index < _firstChildIndex)
            {
                _firstChildIndex--;
            }
            
            invalidateSize();
            invalidateDisplayList();
            
            dispatchEvent(new Event("childrenChanged"));
            
            return child;
        }
        
        /**
         *  @private
         *  This class overrides getChildAt() to deal with only content children,
         *  so in order to implement the rawChildren property we need
         *  a parallel method that deals with all children.
         */
        mx_internal function rawChildren_getChildAt(index:int):IUIComponent
        {
            return super.getChildAt(index);
        }
        
        /**
         *  @private
         *  This class overrides getChildByName() to deal with only content children,
         *  so in order to implement the rawChildren property we need
         *  a parallel method that deals with all children.
         */
        mx_internal function rawChildren_getChildByName(name:String):IUIComponent
        {
            return super.getChildByName(name);
        }
        
        /**
         *  @private
         *  This class overrides getChildIndex() to deal with only content children,
         *  so in order to implement the rawChildren property we need
         *  a parallel method that deals with all children.
         */
        mx_internal function rawChildren_getChildIndex(child:IUIComponent):int
        {
            return super.getChildIndex(child);
        }
        
        /**
         *  @private
         *  This class overrides setChildIndex() to deal with only content children,
         *  so in order to implement the rawChildren property we need
         *  a parallel method that deals with all children.
         */
        mx_internal function rawChildren_setChildIndex(child:IUIComponent,
                                                       newIndex:int):void
        {
            var oldIndex:int = super.getChildIndex(child);
            
            super.setChildIndex(child, newIndex);
            
            // Is this a piece of chrome that was previously before
            // the content children and is now after them in the list?
            if (oldIndex < _firstChildIndex && newIndex >= _firstChildIndex)
            {
                _firstChildIndex--;
            }
                
                // Is this a piece of chrome that was previously after
                // the content children and is now before them in the list?
            else if (oldIndex >= _firstChildIndex && newIndex <= _firstChildIndex)
            {
                _firstChildIndex++
            }
            
            dispatchEvent(new Event("childrenChanged"));
        }
        
        /**
         *  @private
         *  This class overrides getObjectsUnderPoint() to deal with only content children,
         *  so in order to implement the rawChildren property we need
         *  a parallel method that deals with all children.
         */
        mx_internal function rawChildren_getObjectsUnderPoint(pt:Point):Array
        {
            return null; //super.getObjectsUnderPoint(pt);
        }
        
        /**
         *  @private
         *  This class overrides contains() to deal with only content children,
         *  so in order to implement the rawChildren property we need
         *  a parallel method that deals with all children.
         */
        mx_internal function rawChildren_contains(child:IUIBase):Boolean
        {
            return super.contains(child);
        }
        
        //--------------------------------------------------------------------------
        //
        //  Methods: Chrome management
        //
        //--------------------------------------------------------------------------
        
        /**
         *  Respond to size changes by setting the positions and sizes
         *  of this container's borders.
         *  This is an advanced method that you might override
         *  when creating a subclass of Container.
         *
         *  <p>Flex calls the <code>layoutChrome()</code> method when the
         *  container is added to a parent container using the <code>addChild()</code> method,
         *  and when the container's <code>invalidateDisplayList()</code> method is called.</p>
         *
         *  <p>The <code>Container.layoutChrome()</code> method is called regardless of the
         *  value of the <code>autoLayout</code> property.</p>
         *
         *  <p>The <code>Container.layoutChrome()</code> method sets the
         *  position and size of the Container container's border.
         *  In every subclass of Container, the subclass's <code>layoutChrome()</code>
         *  method should call the <code>super.layoutChrome()</code> method,
         *  so that the border is positioned properly.</p>
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
        protected function layoutChrome(unscaledWidth:Number,
                                        unscaledHeight:Number):void
        {
            // Border covers the whole thing.
            if (border)
            {
                updateBackgroundImageRect();
                
                border.move(0, 0);
                border.setActualSize(unscaledWidth, unscaledHeight);
            }
        }
        
        /**
         *  Creates the container's border skin 
         *  if it is needed and does not already exist.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        protected function createBorder():void
        {
            if (!border && isBorderNeeded())
            {
                var borderClass:Class = getStyle("borderSkin");
                
                if (borderClass != null)
                {
                    border = new borderClass();
                    border.name = "border";
                    
                    if (border is IUIComponent)
                        IUIComponent(border).enabled = enabled;
                    if (border is ISimpleStyleClient)
                        ISimpleStyleClient(border).styleName = this;
                    
                    // Add the border behind all the children.
                    rawChildren.addChildAt(IUIComponent(border), 0);
                    
                    invalidateDisplayList();
                }
            }
        }
        
        /**
         *  @private 
         *  Store references to the default border classes here so we don't have to look them up
         *  every time.
         */
        private static var haloBorder:Class;
        private static var sparkBorder:Class;
        private static var sparkContainerBorder:Class;
        private static var didLookup:Boolean = false;
        
        private static function getDefinition(name:String):Class
        {
            var result:Object = null;
            
            try
            {
                result = getDefinitionByName(name);
            }
            catch(e:Error)
            {
            }
            
            return result as Class;
        }
        /**
         *  @private
         */
        private function isBorderNeeded():Boolean
        {
            //trace("isBorderNeeded",this,"ms",getStyle("mouseShield"),"borderStyle",getStyle("borderStyle"));
            
            // If the borderSkin is a custom class, always assume the border is needed.
            var c:Class = getStyle("borderSkin");
            
            if (!didLookup)
            {
                // Lookup the default border classes by name to avoid a linkage dependency.
                // Note: this code assumes either HaloBorder or spark BorderSkin is the default border skin. 
                // If this is changed in defaults.css, it must also be changed here.
                haloBorder = getDefinition("mx.skins.halo::HaloBorder");
                sparkBorder = getDefinition("mx.skins.spark::BorderSkin");
                sparkContainerBorder = getDefinition("mx.skins.spark::ContainerBorderSkin");
                didLookup = true;
            }
            
            if (!(c == haloBorder || c == sparkBorder || c == sparkContainerBorder))
                return true;
            
            var v:Object = getStyle("borderStyle");
            if (v)
            {
                // If borderStyle is "none", then only create a border if the mouseShield style is true
                // (meaning that there is a mouse event listener on this view). We don't create a border
                // if our parent's mouseShieldChildren style is true.
                if ((v != "none") || (v == "none" && getStyle("mouseShield")))
                {
                    return true;
                }    
            }
            
            v = getStyle("contentBackgroundColor");
            if (c == sparkBorder && v !== null)
                return true;
            
            v = getStyle("backgroundColor");
            if (v !== null && v !== "")
                return true;
            
            v = getStyle("backgroundImage");
            return v != null && v != "";
        }
        
        /**
         *  @private
         */
        mx_internal function invalidateViewMetricsAndPadding():void
        {
            _viewMetricsAndPadding = null;
        }
        
        /**
         *  @private
         */
        private function createOrDestroyBlocker():void
        {
            /*
            // If this container is being enabled and a blocker exists,
            // remove it. If this container is being disabled and a
            // blocker doesn't exist, create it.
            if (enabled)
            {
                if (blocker)
                {
                    rawChildren.removeChild(blocker);
                    blocker = null;
                }
            }
            else
            {
                if (!blocker)
                {
                    blocker = new FlexSprite();
                    blocker.name = "blocker";
                    blocker.mouseEnabled = true;
                    rawChildren.addChild(blocker);
                    
                    blocker.addEventListener(MouseEvent.CLICK,
                        blocker_clickHandler);
                    
                    // If the focus is a child of ours, we clear it here.
                    var o:IUIComponent =
                        focusManager ?
                        IUIComponent(focusManager.getFocus()) :
                        null;
                    
                    while (o)
                    {
                        if (o == this)
                        {
                            var sm:ISystemManager = systemManager;
                            if (sm && sm.stage)
                                sm.stage.focus = null;
                            break;
                        }
                        o = o.parent;
                    }
                }
            }
            */
        }
        
        /**
         *  @private
         */
        private function updateBackgroundImageRect():void
        {
            /*
            var rectBorder:IRectangularBorder = border as IRectangularBorder;
            
            if (!rectBorder)
                return;
            
            // If viewableWidth and viewableHeight are 0, we don't have any
            // scrollbars or clipped content.
            if (viewableWidth == 0 && viewableHeight == 0)
            {
                rectBorder.backgroundImageBounds = null;
                return;
            }
            
            var vm:EdgeMetrics = viewMetrics;
            var bkWidth:Number = viewableWidth ? viewableWidth :
                unscaledWidth - vm.left - vm.right;
            var bkHeight:Number = viewableHeight ? viewableHeight :
                unscaledHeight - vm.top - vm.bottom;
            
            if (getStyle("backgroundAttachment") == "fixed")
            {
                rectBorder.backgroundImageBounds = new Rectangle(vm.left, vm.top,
                    bkWidth, bkHeight);
            }
            else
            {
                rectBorder.backgroundImageBounds = new Rectangle(vm.left, vm.top,
                    Math.max(scrollableWidth, bkWidth),
                    Math.max(scrollableHeight, bkHeight));
            }
            */
        }
        
        //--------------------------------------------------------------------------
        //
        //  Methods: Scrolling
        //
        //--------------------------------------------------------------------------
        
        /**
         *  @private
         */
        private function createContentPaneAndScrollbarsIfNeeded():Boolean
        {
            var bounds:Rectangle;
            var changed:Boolean = false;
            
            // No mask is needed if clipping isn't active
            if (_clipContent)
            {
                // Get the new scrollable width, which is the equal to the right
                // edge of the rightmost child.  Also get the new scrollable height.
                bounds = getScrollableRect();
                
                if (border)
                    updateBackgroundImageRect();
                
                return changed;
            }
            else
            {
                // Get scrollableWidth and scrollableHeight for scrollChildren()
                bounds = getScrollableRect();
                scrollableWidth = bounds.right;
                scrollableHeight = bounds.bottom;
                
                if (changed && border)
                    updateBackgroundImageRect();
                
                return changed;
            }
        }
        
        /**
         *  @private
         */
        mx_internal function getScrollableRect():Rectangle
        {
            var left:Number = 0;
            var top:Number = 0;
            var right:Number = 0;
            var bottom:Number = 0;
            
            var n:int = numChildren;
            for (var i:int = 0; i < n; i++)
            {
                var x:Number;
                var y:Number;
                var width:Number;
                var height:Number;
                
                var child:IUIComponent = getChildAt(i);
                if (child is IUIComponent)
                {
                    if (!IUIComponent(child).includeInLayout)
                        continue;
                    var uic:IUIComponent = /*PostScaleAdapter.getCompatibleIUIComponent(*/child/*)*/ as IUIComponent;
                    width = uic.width;
                    height = uic.height;
                    x = uic.x;
                    y = uic.y;
                }
                else
                {
                    width = child.width;
                    height = child.height;
                    x = child.x;
                    y = child.y;
                }
                
                left = Math.min(left, x);
                top = Math.min(top, y);
                
                // width/height can be NaN if using percentages and
                // hasn't been layed out yet.
                if (!isNaN(width))
                    right = Math.max(right, x + width);
                if (!isNaN(height))
                    bottom = Math.max(bottom, y + height);
            }
            
            // Add in the right/bottom margins and view metrics.
            var vm:EdgeMetrics = viewMetrics;
            
            var bounds:Rectangle = new Rectangle();
            bounds.left = left;
            bounds.top = top;
            bounds.right = right;
            bounds.bottom = bottom;
            
            if (usePadding)
            {
                bounds.right += getStyle("paddingRight");
                bounds.bottom += getStyle("paddingBottom");
            }
            
            return bounds;
        }
        
        
        /**
         *  @private
         *  Ensures that horizontalScrollPosition is in the range
         *  from 0 through maxHorizontalScrollPosition and that
         *  verticalScrollPosition is in the range from 0 through
         *  maxVerticalScrollPosition.
         *  Returns true if either horizontalScrollPosition or
         *  verticalScrollPosition was changed to ensure this.
         */
        private function clampScrollPositions():Boolean
        {
            var changed:Boolean = false;
            
            // Clamp horizontalScrollPosition to the range
            // 0 through maxHorizontalScrollPosition.
            // If horizontalScrollBar doesn't exist,
            // maxHorizontalScrollPosition will be 0.
            if (_horizontalScrollPosition < 0)
            {
                _horizontalScrollPosition = 0;
                changed = true;
            }
            else if (_horizontalScrollPosition > maxHorizontalScrollPosition)
            {
                _horizontalScrollPosition = maxHorizontalScrollPosition;
                changed = true;
            }
            
            // Clamp verticalScrollPosition to the range
            // 0 through maxVerticalScrollPosition.
            // If verticalScrollBar doesn't exist,
            // maxVerticalScrollPosition will be 0.
            if (_verticalScrollPosition < 0)
            {
                _verticalScrollPosition = 0;
                changed = true;
            }
            else if (_verticalScrollPosition > maxVerticalScrollPosition)
            {
                _verticalScrollPosition = maxVerticalScrollPosition;
                changed = true;
            }
            
            return changed;
        }
        
        /**
         *  @private
         */
        mx_internal function createContentPane():void
        {
            if (contentPane)
                return;
         
            /*
            creatingContentPane = true;
            
            // Reparent the children.  Get the number before we create contentPane
            // because that changes logic of how many children we have
            var n:int = numChildren;
            
            var newPane:Sprite = new FlexSprite();
            newPane.name = "contentPane";
            
            // Place content pane above border and background image but below
            // all other chrome.
            var childIndex:int;
            if (border)
            {
                childIndex = rawChildren.getChildIndex(IUIComponent(border)) + 1;
                if (border is IRectangularBorder && IRectangularBorder(border).hasBackgroundImage)
                    childIndex++;
            }
            else
            {
                childIndex = 0;
            }
            rawChildren.addChildAt(newPane, childIndex);
            
            for (var i:int = 0; i < n; i++)
            {
                // use super because contentPane now exists and messes up getChildAt();
                var child:IUIComponent =
                    IUIComponent(super.getChildAt(_firstChildIndex));
                newPane.addChild(IUIComponent(child));
                child.parentChanged(newPane);
                _numChildren--; // required
            }
            
            contentPane = newPane;
            
            creatingContentPane = false
            
            // UIComponent sets $visible to false. If we don't make it true here,
            // nothing shows up. Making this true should be harmless, as the
            // container itself should be false, and so should all its children.
            contentPane.visible = true;
            */
        }
        
        /**
         *  Positions the container's content area relative to the viewable area 
         *  based on the horizontalScrollPosition and verticalScrollPosition properties. 
         *  Content that doesn't appear in the viewable area gets clipped. 
         *  This method should be overridden by subclasses that have scrollable 
         *  chrome in the content area.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        protected function scrollChildren():void
        {
            /*
            if (!contentPane)
                return;
            
            var vm:EdgeMetrics = viewMetrics;
            
            var x:Number = 0;
            var y:Number = 0;
            var w:Number = unscaledWidth - vm.left - vm.right;
            var h:Number = unscaledHeight - vm.top - vm.bottom;
            
            if (_clipContent)
            {
                x += _horizontalScrollPosition;
                
                y += _verticalScrollPosition;
            }
            else
            {
                w = scrollableWidth;
                h = scrollableHeight;
            }
            
            // If we have enough space to display everything, don't set
            // scrollRect.
            var sr:Rectangle = getScrollableRect();
            if (x == 0 && y == 0                            // Not scrolled
                && w >= sr.right && h >= sr.bottom &&   // Vertical content visible
                sr.left >= 0 && sr.top >= 0 && _forceClippingCount <= 0)            // No negative coordinates
            {
                contentPane.scrollRect = null;
                contentPane.opaqueBackground = null;
                contentPane.cacheAsBitmap = false;
            }
            else
            {
                contentPane.scrollRect = new Rectangle(x, y, w, h);
            }
            
            if (focusPane)
                focusPane.scrollRect = contentPane.scrollRect;
            
            if (border && border is IRectangularBorder &&
                IRectangularBorder(border).hasBackgroundImage)
            {
                IRectangularBorder(border).layoutBackgroundImage();
            }
            */
        }
        
        /**
         *  @private
         *  Used by a child component to force clipping during a Move effect
         */
        private var _forceClippingCount:int;
        
        mx_internal function set forceClipping(value:Boolean):void
        {
            if (_clipContent) // Can only force clipping if clipContent == true
            {
                if (value)
                    _forceClippingCount++
                else
                    _forceClippingCount--;
                
                createContentPane();
                scrollChildren();
            }
        }
        
        //--------------------------------------------------------------------------
        //
        //  Methods: Binding
        //
        //--------------------------------------------------------------------------
        
        /**
         *  Executes the bindings into this Container's child UIComponent objects.
         *  Flex calls this method automatically once a Container has been created.
         *
         *  @param recurse If <code>false</code>, then only execute the bindings
         *  on the immediate children of this Container. 
         *  If <code>true</code>, then also execute the bindings on this
         *  container's grandchildren,
         *  great-grandchildren, and so on.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function executeChildBindings(recurse:Boolean):void
        {
            /*
            var n:int = numChildren;
            for (var i:int = 0; i < n; i++)
            {
                var child:IUIComponent = IUIComponent(getChildAt(i));
                if (child is IDeferredInstantiationUIComponent)
                {
                    IDeferredInstantiationUIComponent(child).
                        executeBindings(recurse);
                }
            }
            */
        }
        
        //--------------------------------------------------------------------------
        //
        //  Overridden event handlers
        //
        //--------------------------------------------------------------------------
        
        /**
         *  @private
         */
        override protected function keyDownHandler(event:KeyboardEvent):void
        {
            // If a text field currently has focus, it is handling all arrow keys.
            // We shouldn't also scroll this Container.
            var focusObj:Object = getFocus();
            /*
            if ((focusObj is TextField) ||
                (richEditableTextClass && focusObj is richEditableTextClass))
            {
                return;
            }
            */
            
            // If the KeyBoardEvent can be canceled and a descendant has done so,
            // don't process it at all.  
            if (event.isDefaultPrevented())
                return;     
            
        }
        
        //--------------------------------------------------------------------------
        //
        //  Event handlers
        //
        //--------------------------------------------------------------------------
        
        /**
         *  @private
         *  This method copied verbatim from mx.core.ScrollControlBase.
         */
        private function mouseWheelHandler(event:MouseEvent):void
        {
            // If this Container has a vertical scrollbar, then handle the event
            // and prevent further bubbling
        }
        
        /**
         *  @private
         *  This function is called when the LayoutManager finishes running.
         *  Clear the forceLayout flag that was set earlier.
         */
        private function layoutCompleteHandler(event:FlexEvent):void
        {
            //UIComponentGlobals.layoutManager.removeEventListener(
            //    FlexEvent.UPDATE_COMPLETE, layoutCompleteHandler);
            forceLayout = false;
            
            var needToScrollChildren:Boolean = false;
            
            if (!isNaN(horizontalScrollPositionPending))
            {
                if (horizontalScrollPositionPending < 0)
                    horizontalScrollPositionPending = 0;
                else if (horizontalScrollPositionPending > maxHorizontalScrollPosition)
                    horizontalScrollPositionPending = maxHorizontalScrollPosition;
                
                horizontalScrollPositionPending = NaN;
            }
            
            if (!isNaN(verticalScrollPositionPending))
            {
                // Clamp verticalScrollPosition to the range 0 through maxVerticalScrollPosition.
                // If verticalScrollBar doesn't exist, maxVerticalScrollPosition will be 0.
                if (verticalScrollPositionPending < 0)
                    verticalScrollPositionPending = 0;
                else if (verticalScrollPositionPending > maxVerticalScrollPosition)
                    verticalScrollPositionPending = maxVerticalScrollPosition;
                
                verticalScrollPositionPending = NaN;
            }
            
            if (needToScrollChildren)
                scrollChildren();
        }
        
        /**
         *  @private
         */
        private function creationCompleteHandler(event:FlexEvent):void
        {
            numChildrenCreated--;
            if (numChildrenCreated <= 0)
                dispatchEvent(new FlexEvent("childrenCreationComplete"));
        }
        
        /**
         *  @private
         */
        private function blocker_clickHandler(event:Event):void
        {
            // Swallow click events from blocker.
            event.stopPropagation();
        }
        
        /**
         *  @private
         */     
        override protected function measure():void
        {
            super.measure();
            
            var preferredWidth:Number;
            var preferredHeight:Number;
            var minWidth:Number;
            var minHeight:Number;
            
            // Determine the size of each tile cell and cache the values
            // in cellWidth and cellHeight for later use by updateDisplayList().
            findCellSize();
            
            // Min width and min height are large enough to display a single child.
            minWidth = cellWidth;
            minHeight = cellHeight;
            
            // Determine the width and height necessary to display the tiles
            // in an N-by-N grid (with number of rows equal to number of columns).
            var n:int = this.numChildren;
            
            // Don't count children that don't need their own layout space.
            var temp:int = n;
            for (var i:int = 0; i < n; i++)
            {
                if (!IUIComponent(getChildAt(i)).includeInLayout)
                    temp--;
            }
            n = temp;
            
            if (n > 0)
            {
                var horizontalGap:Number = getStyle("horizontalGap");
                var verticalGap:Number = getStyle("verticalGap");
                
                var majorAxis:Number;
                
                // If an explicit dimension or flex is set for the majorAxis,
                // set as many children as possible along the axis.
                if (direction == "horizontal")
                {
                    var unscaledExplicitWidth:Number = explicitWidth / Math.abs(scaleX);
                    if (!isNaN(unscaledExplicitWidth))
                    {
                        // If we have an explicit height set,
                        // see how many children can fit in the given height:
                        // majorAxis * (cellWidth + horizontalGap) - horizontalGap == unscaledExplicitWidth
                        majorAxis = Math.floor((unscaledExplicitWidth + horizontalGap) /
                            (cellWidth + horizontalGap));
                    }
                }
                else
                {
                    var unscaledExplicitHeight:Number = explicitHeight / Math.abs(scaleY);
                    if (!isNaN(unscaledExplicitHeight))
                    {
                        // If we have an explicit height set,
                        // see how many children can fit in the given height:
                        // majorAxis * (cellHeight + verticalGap) - verticalGap == unscaledExplicitHeight
                        majorAxis = Math.floor((unscaledExplicitHeight + verticalGap) /
                            (cellHeight + verticalGap));
                    }
                }
                
                // Finally, if majorAxis still isn't defined, use the
                // square root of the number of children.
                if (isNaN(majorAxis))
                    majorAxis = Math.ceil(Math.sqrt(n));
                
                // Even if there's not room, force at least one cell
                // on each row/column.
                if (majorAxis < 1)
                    majorAxis = 1;
                
                var minorAxis:Number = Math.ceil(n / majorAxis);
                
                if (direction == "horizontal")
                {
                    preferredWidth = majorAxis * cellWidth +
                        (majorAxis - 1) * horizontalGap;
                    
                    preferredHeight = minorAxis * cellHeight +
                        (minorAxis - 1) * verticalGap;
                }
                else
                {
                    preferredWidth = minorAxis * cellWidth +
                        (minorAxis - 1) * horizontalGap;
                    
                    preferredHeight = majorAxis * cellHeight +
                        (majorAxis - 1) * verticalGap;
                }
            }
            else
            {
                preferredWidth = minWidth;
                preferredHeight = minHeight;
            }
            
            var vm:EdgeMetrics = viewMetricsAndPadding;
            var hPadding:Number = vm.left + vm.right;
            var vPadding:Number = vm.top + vm.bottom;
            
            // Add padding for margins and borders.
            minWidth += hPadding;
            preferredWidth += hPadding;
            minHeight += vPadding;
            preferredHeight += vPadding;
            
            measuredMinWidth = Math.ceil(minWidth);
            measuredMinHeight = Math.ceil(minHeight);
            measuredWidth = Math.ceil(preferredWidth);
            measuredHeight = Math.ceil(preferredHeight);
            
            
            var colCount:int;
            
            // Determine the size of each tile cell
            findCellSize();
            
            // Min width and min height are large enough to display a single child
            minWidth = cellWidth;
            minHeight = cellHeight;
            
            // Determine the width and height necessary to display the tiles in an
            // N-by-N grid (with number of rows equal to number of columns).
            var numChildren:int = this.numChildren;
            if (numChildren > 0)
            {
                horizontalGap = getStyle("horizontalGap");
                verticalGap = getStyle("verticalGap");
                var columns:Array /* of Number */;
                vm = viewMetricsAndPadding;
                var rowCount:int;
                
                // If an explicit dimension or flex is set for the majorAxis,
                // set as many children as possible along the axis.
                if (direction == "vertical")
                {
                    var bCalcColumns:Boolean = false;
                    
                    if (!isNaN(explicitHeight))
                    {
                        preferredHeight = explicitHeight - vm.top - vm.bottom;
                        bCalcColumns = true;
                    }
                    else if (!isNaN(_actualMajorAxisLength))
                    {
                        preferredHeight = _actualMajorAxisLength * cellHeight +
                            (_actualMajorAxisLength - 1) * verticalGap;
                        _actualMajorAxisLength = NaN;
                        bCalcColumns = true;
                    }
                    
                    if (bCalcColumns)
                    {
                        columns = calcColumnWidthsForHeight(preferredHeight);
                        preferredWidth = 0;
                        colCount = columns.length;
                        n = colCount;
                        for (i = 0; i < n; i++)
                        {
                            preferredWidth += columns[i];
                        }
                        preferredWidth += (colCount - 1) * horizontalGap;
                        
                        rowCount = Math.min(numChildren,
                            Math.max(1, Math.floor(
                                (preferredHeight + verticalGap) /
                                (cellHeight + verticalGap))));
                        preferredHeight = rowCount * cellHeight +
                            (rowCount - 1) * verticalGap;
                        _preferredMajorAxisLength = rowCount;
                    }
                    else
                    {
                        // If we have flex,
                        // our majorAxis can contain all our children
                        preferredHeight = numChildren * cellHeight +
                            (numChildren - 1) * verticalGap;
                        preferredWidth = cellWidth;
                        _preferredMajorAxisLength = numChildren;
                    }
                }
                else
                {
                    if (!isNaN(explicitWidth))
                    {
                        // If we have an explicit height set,
                        // see how many children can fit in the given height.
                        preferredWidth = explicitWidth - vm.left - vm.right;
                    }
                    else if (!isNaN(_actualMajorAxisLength))
                    {
                        preferredWidth = _actualMajorAxisLength - vm.left - vm.right;
                        _actualMajorAxisLength = NaN;
                    }
                    else
                    {
                        preferredWidth = screen.width - vm.left - vm.right;
                    }
                    
                    columns = calcColumnWidthsForWidth(preferredWidth);
                    preferredWidth = 0;
                    colCount = columns.length;
                    n = colCount;
                    for (i = 0; i < n; i++)
                    {
                        preferredWidth += columns[i];
                    }
                    
                    preferredWidth += (colCount - 1) * horizontalGap;
                    rowCount = Math.ceil(numChildren / colCount);
                    preferredHeight = rowCount * cellHeight +
                        (rowCount - 1) * verticalGap;
                    _preferredMajorAxisLength = colCount;
                }
                
            }
            else
            {
                preferredWidth = minWidth;
                preferredHeight = minHeight;
            }
            
            // Add extra for borders and margins.
            vm = viewMetricsAndPadding;
            var hExtra:Number = vm.left + vm.right;
            var vExtra:Number = vm.top + vm.bottom;
            minWidth += hExtra;
            preferredWidth += hExtra;
            minHeight += vExtra;
            preferredHeight += vExtra;
            
            measuredMinWidth = minWidth;
            measuredMinHeight = minHeight;
            measuredWidth = preferredWidth;
            measuredHeight = preferredHeight;
        }
        
        //--------------------------------------------------------------------------
        //
        //  Methods
        //
        //--------------------------------------------------------------------------
        
        /**
         *  @private
         *  Calculate and store the cellWidth and cellHeight.
         */
        mx_internal function findCellSize():void
        {
            // If user explicitly supplied both a tileWidth and
            // a tileHeight, then use those values.
            var widthSpecified:Boolean = !isNaN(tileWidth);
            var heightSpecified:Boolean = !isNaN(tileHeight);
            if (widthSpecified && heightSpecified)
            {
                cellWidth = tileWidth;
                cellHeight = tileHeight;
                return;
            }
            
            // Reset the max child width and height
            var maxChildWidth:Number = 0;
            var maxChildHeight:Number = 0;
            
            // Loop over the children to find the max child width and height.
            var n:int = numChildren;
            for (var i:int = 0; i < n; i++)
            {
                var child:IUIComponent = getLayoutChildAt(i);
                
                if (!child.includeInLayout)
                    continue;
                
                var width:Number = child.getExplicitOrMeasuredWidth();
                if (width > maxChildWidth)
                    maxChildWidth = width;
                
                var height:Number = child.getExplicitOrMeasuredHeight();
                if (height > maxChildHeight) 
                    maxChildHeight = height;
            }
            
            // If user explicitly specified either width or height, use the
            // user-supplied value instead of the one we computed.
            cellWidth = widthSpecified ? tileWidth : maxChildWidth;
            cellHeight = heightSpecified ? tileHeight : maxChildHeight;
        }
        
        /**
         *  @private
         *  Assigns the actual size of the specified child,
         *  based on its measurement properties and the cell size.
         */
        private function setChildSize(child:IUIComponent):void
        {
            var childWidth:Number;
            var childHeight:Number;
            var childPref:Number;
            var childMin:Number;
            
            if (child.percentWidth > 0)
            {
                // Set child width to be a percentage of the size of the cell.
                childWidth = Math.min(cellWidth,
                    cellWidth * child.percentWidth / 100);
            }
            else
            {
                // The child is not flexible, so set it to its preferred width.
                childWidth = child.getExplicitOrMeasuredWidth();
                
                // If an explicit tileWidth has been set on this Tile,
                // then the child may extend outside the bounds of the tile cell.
                // In that case, we'll honor the child's width or minWidth,
                // but only if those values were explicitly set by the developer,
                // not if they were implicitly set based on measurements.
                if (childWidth > cellWidth)
                {
                    childPref = isNaN(child.explicitWidth) ?
                        0 :
                        child.explicitWidth;
                    
                    childMin = isNaN(child.explicitMinWidth) ?
                        0 :
                        child.explicitMinWidth;
                    
                    childWidth = (childPref > cellWidth ||
                        childMin > cellWidth) ?
                        Math.max(childMin, childPref) :
                        cellWidth;
                }
            }
            
            if (child.percentHeight > 0)
            {
                childHeight = Math.min(cellHeight,
                    cellHeight * child.percentHeight / 100);
            }
            else
            {
                childHeight = child.getExplicitOrMeasuredHeight();
                
                if (childHeight > cellHeight)
                {
                    childPref = isNaN(child.explicitHeight) ?
                        0 :
                        child.explicitHeight;
                    
                    childMin = isNaN(child.explicitMinHeight) ?
                        0 :
                        child.explicitMinHeight;
                    
                    childHeight = (childPref > cellHeight ||
                        childMin > cellHeight) ?
                        Math.max(childMin, childPref) :
                        cellHeight;
                }
            }
            
            child.setActualSize(childWidth, childHeight);
        }
        
        /**
         *  @private
         *  Compute how much adjustment must occur in the x direction
         *  in order to align a component of a given width into the cell.
         */
        mx_internal function calcHorizontalOffset(width:Number,
                                                  horizontalAlign:String):Number
        {
            var xOffset:Number;
            
            if (horizontalAlign == "left")
                xOffset = 0;
                
            else if (horizontalAlign == "center")
                xOffset = (cellWidth - width) / 2;
                
            else if (horizontalAlign == "right")
                xOffset = (cellWidth - width);
            
            return xOffset;
        }
        
        /**
         *  @private
         *  Compute how much adjustment must occur in the y direction
         *  in order to align a component of a given height into the cell.
         */
        mx_internal function calcVerticalOffset(height:Number,
                                                verticalAlign:String):Number
        {
            var yOffset:Number;
            
            if (verticalAlign == "top")
                yOffset = 0;
                
            else if (verticalAlign == "middle")
                yOffset = (cellHeight - height) / 2;
                
            else if (verticalAlign == "bottom")
                yOffset = (cellHeight - height);
            
            return yOffset;
        }
        
        
        //--------------------------------------------------------------------------
        //
        //  Methods
        //
        //--------------------------------------------------------------------------
        
        /**
         *  @private
         */
        private function addLegendItem(legendData:Object):void
        {
            var c:Class = legendItemClass;
            var newItem:LegendItem = new c();
            
            if (legendData.label != "")
                newItem.label = legendData.label;
            
            if (legendData.element)
                newItem.chartElement = legendData.element;
            
            if ("fill" in legendData)
                newItem.setStyle("fill",legendData["fill"]);
            
            newItem.markerAspectRatio = legendData.aspectRatio;
            newItem.legendData = legendData;
            newItem.percentWidth = 100;
            newItem.percentHeight = 100;
            
            addChild(newItem);
            
			newItem.marker = legendData.marker;
			
			newItem.setStyle("backgroundColor", 0xEEEEFF);
        }
        
        /**
         *  @private
         */
        private function populateFromArray(dp:Object):void
        {
            if (dp is ChartBase)
                dp = dp.legendData;
            
            removeAllChildren();
            
            var curItem:Object;
            var n:int = dp.length;
            for (var i:int = 0; i < n; i++)
            {
                var curList:Array /* of LegendData */ = (dp[i] as Array);
                if (!curList)
                {
                    curItem = dp[i];
                    addLegendItem(curItem);
                }
                else
                {
                    var m:int = curList.length;
                    for (var j:int = 0; j < m; j++)
                    {
                        curItem = curList[j];
                        addLegendItem(curItem);
                    }
                }
            }
            
            _actualMajorAxisLength = NaN;
        }
        
        /**
         *  @private
         *  Returns a numeric value for the align setting.
         *  0 = left/top, 0.5 = center, 1 = right/bottom
         */
        private function findHorizontalAlignValue():Number
        {
            var horizontalAlign:String = getStyle("horizontalAlign");
            
            if (horizontalAlign == "center")
                return 0.5;
                
            else if (horizontalAlign == "right")
                return 1;
            
            // default = left
            return 0;
        }
        
        /**
         *  @private
         *  Returns a numeric value for the align setting.
         *  0 = left/top, 0.5 = center, 1 = right/bottom
         */
        private function findVerticalAlignValue():Number
        {
            var verticalAlign:String = getStyle("verticalAlign");
            
            if (verticalAlign == "middle")
                return 0.5;
                
            else if (verticalAlign == "bottom")
                return 1;
            
            // default = top
            return 0;
        }
        
        /**
         *  @private
         */
        private function widthPadding(numChildren:Number):Number
        {
            var vm:EdgeMetrics = viewMetricsAndPadding;
            var padding:Number = vm.left + vm.right;
            
            if (numChildren > 1 && direction == "horizontal")
                padding += getStyle("horizontalGap") * (numChildren - 1);
            
            return padding;
        }
        
        /**
         *  @private
         */
        private function heightPadding(numChildren:Number):Number
        {
            var vm:EdgeMetrics = viewMetricsAndPadding;
            var padding:Number = vm.top + vm.bottom;
            
            if (numChildren > 1 && direction == "vertical")
                padding += getStyle("verticalGap") * (numChildren - 1);
            
            return padding;
        }
        
        /**
         *  @private
         */
        private function calcColumnWidthsForHeight(h:Number):Array /* of Number */
        {
            var n:Number = numChildren;
            
            var verticalGap:Number = getStyle("verticalGap");
            if (isNaN(verticalGap))
                verticalGap = 0;
            
            var rowCount:int = Math.min(n, Math.max(
                1, Math.floor((h + verticalGap) / (cellHeight + verticalGap))));
            
            var nColumns:int = rowCount == 0 ? 0: Math.ceil(n / rowCount);
            
            var columnSizes:Array /* of Number */;
            if (nColumns <= 1)
            {
                columnSizes = [cellWidth];
            }
            else
            {
                columnSizes = [];
                for (var i:int = 0; i < nColumns; i++)
                {
                    columnSizes[i] = 0;
                }
                
                for (i = 0; i < n; i++)
                {
                    var child:IUIComponent = IUIComponent(getChildAt(i));
                    var col:int = Math.floor(i / rowCount);
                    columnSizes[col] = Math.max(columnSizes[col],
                        child.getExplicitOrMeasuredWidth());
                }
            }
            
            return columnSizes;
        }
        
        /**
         *  @private
         *  Bound the layout in the vertical direction
         *  and let it grow horizontally.
         */
        private function layoutVertical():void
        {
            var n:Number = numChildren;
            
            var vm:EdgeMetrics = viewMetricsAndPadding;
            
            var horizontalGap:Number = getStyle("horizontalGap");
            var verticalGap:Number = getStyle("verticalGap");
            
            var horizontalAlign:String = getStyle("horizontalAlign");
            var verticalAlign:String = getStyle("verticalAlign");
            
            var xPos:Number = vm.left;
            var yPos:Number = vm.top;
            var yEnd:Number = unscaledHeight - vm.bottom;
            
            var rowCount:int = Math.min(n, Math.max(1, Math.floor(
                (yEnd - yPos + verticalGap) / (cellHeight + verticalGap))));
            
            var columnSizes:Array /* of Number */ = [];
            
            columnSizes = calcColumnWidthsForHeight(yEnd - yPos);
            var nColumns:int = columnSizes.length;
            
            for (var i:Number = 0; i < n; i++)
            {
                var child:IUIComponent = IUIComponent(getChildAt(i));
                
                var col:int = Math.floor(i / rowCount);
                var colWidth:Number = columnSizes[col];
                
                var childWidth:Number;
                var childHeight:Number;
                
                if (child.percentWidth > 0)
                {
                    childWidth = Math.min(colWidth,
                        colWidth * child.percentWidth / 100);
                }
                else
                {
                    childWidth = child.getExplicitOrMeasuredWidth();
                }
                
                if (child.percentHeight > 0)
                {
                    childHeight = Math.min(cellHeight,
                        cellHeight * child.percentHeight / 100);
                }
                else
                {
                    childHeight = child.getExplicitOrMeasuredHeight();
                }
                
                child.setActualSize(childWidth, childHeight);
                
                //  Align the child in the cell.
                var xOffset:Number =
                    Math.floor(calcHorizontalOffset(child.width, horizontalAlign));
                var yOffset:Number =
                    Math.floor(calcVerticalOffset(child.height, verticalAlign));
                child.move(xPos + xOffset, yPos + yOffset);
                
                if ((i % rowCount) == rowCount - 1)
                {
                    yPos = vm.top;
                    xPos += (colWidth + horizontalGap);
                }
                else
                {
                    yPos += (cellHeight + verticalGap);
                }
            }
            
            if (rowCount != _preferredMajorAxisLength)
            {
                _actualMajorAxisLength = rowCount;
                invalidateSize();
            }
        }
        
        /**
         *  @private
         */
        private function calcColumnWidthsForWidth(w:Number):Array /* of Number */
        {
            var n:Number = numChildren;
            
            var horizontalGap:Number = getStyle("horizontalGap");
            
            var xPos:Number = 0;
            var xEnd:Number = w;
            
            // first determine the max number of columns we can have;
            var nColumns:int = 0;
            var columnSizes:Array /* of Number */;
            
            for (var i:Number = 0; i < n; i++)
            {
                var child:IUIComponent = IUIComponent(getChildAt(i));
                var childPreferredWidth:Number = child.getExplicitOrMeasuredWidth();
                
                // start a new row?
                if (xPos + childPreferredWidth > xEnd)
                {
                    break;
                }
                xPos += (childPreferredWidth + horizontalGap);
                
                nColumns++;
            }
            
            var columnsTooWide:Boolean = true;
            
            while (nColumns > 1 && columnsTooWide)
            {
                columnSizes = [];
                for (i = 0; i < nColumns; i++)
                {
                    columnSizes[i] = 0;
                }
                for (i = 0; i < n; i++)
                {
                    var col:int = i % nColumns;
                    columnSizes[col] = Math.max(columnSizes[col],
                        IUIComponent(getChildAt(i)).getExplicitOrMeasuredWidth());
                }
                xPos = 0;
                
                for (i = 0; i < nColumns; i++)
                {
                    if (xPos + columnSizes[i] > xEnd)
                        break;
                    xPos += columnSizes[i] + horizontalGap;
                }
                if (i == nColumns)
                    columnsTooWide = false;
                else
                    nColumns--;
            }
            
            if (nColumns <= 1)
            {
                nColumns = 1;
                columnSizes = [cellWidth];
            }
            
            return columnSizes;
        }
        
        /**
         *  @private
         */
        private function layoutHorizontal():void
        {
            var n:Number = numChildren;
            
            var vm:EdgeMetrics = viewMetricsAndPadding;
            
            var horizontalGap:Number = getStyle("horizontalGap");
            var verticalGap:Number = getStyle("verticalGap")
            
            var horizontalAlign:String = getStyle("horizontalAlign");
            var verticalAlign:String = getStyle("verticalAlign");
            
            var xPos:Number = vm.left;
            var xEnd:Number = _unscaledWidth - vm.right;
            var yPos:Number = vm.top;
            
            // First determine the max number of columns we can have.
            var nColumns:int = 0;
            var columnSizes:Array /* of Number */;
            
            columnSizes = calcColumnWidthsForWidth(xEnd - xPos);
            nColumns = columnSizes.length;
            
            for (var i:Number = 0; i < n; i++)
            {
                var child:IUIComponent = IUIComponent(getChildAt(i));
                
                var col:int = i % nColumns;
                var colWidth:Number = columnSizes[col];
                
                var childWidth:Number;
                var childHeight:Number;
                
                if (child.percentWidth > 0)
                {
                    childWidth = Math.min(colWidth,
                        colWidth * child.percentWidth / 100);
                }
                else
                {
                    childWidth = child.getExplicitOrMeasuredWidth();
                }
                
                if (child.percentHeight > 0)
                {
                    childHeight = Math.min(cellHeight,
                        cellHeight * child.percentHeight / 100);
                }
                else
                {
                    childHeight = child.getExplicitOrMeasuredHeight();
                }
                
                child.setActualSize(childWidth, childHeight);
                
                // Align the child in the cell.
                var xOffset:Number =
                    Math.floor(calcHorizontalOffset(child.width, horizontalAlign));
                var yOffset:Number =
                    Math.floor(calcVerticalOffset(child.height, verticalAlign));
                child.move(xPos + xOffset, yPos + yOffset);
                
                if (col == nColumns - 1)
                {
                    xPos = vm.left;
                    yPos += (cellHeight + verticalGap);
                }
                else
                {
                    xPos += (columnSizes[col] + horizontalGap);
                }
            }
            
            if (nColumns != _preferredMajorAxisLength)
            {
                _actualMajorAxisLength = _unscaledWidth;
                invalidateSize();
            }
        }
        
        //--------------------------------------------------------------------------
        //
        //  Event handlers
        //
        //--------------------------------------------------------------------------
        
        /**
         *  @private
         */
        private function legendDataChangedHandler(event:Event = null):void
        {
            invalidateProperties();
            invalidateSize();
            _childrenDirty = true;;
            
            if (parent)
            {
                commitProperties();
                measure();
                updateDisplayList(getExplicitOrMeasuredWidth(), getExplicitOrMeasuredHeight());
            }            
        }
        
        /**
         *  @private
         */
        private function childMouseEventHandler(event:MouseEvent):void
        {
            var p:IUIComponent = IUIComponent(event.target);
            
            while (p != this && p.parent != this)
            {
                p = p.parent as IUIComponent;
            }
            
            if (p is LegendItem)
                dispatchEvent(new LegendMouseEvent(event.type, event, LegendItem(p)));
        }
    }
}


import mx.core.IUIComponent;
import org.apache.royale.core.IUIBase;
import org.apache.royale.geom.Point;

import mx.charts.Legend;
import mx.core.IChildList;
import mx.core.mx_internal;

use namespace mx_internal;
/**
 *  @private
 *  Helper class for the rawChildren property of the Container class.
 *  For descriptions of the properties and methods,
 *  see the IChildList interface.
 *
 *  @see mx.core.Container
 */
class LegendRawChildrenList implements IChildList
{
//    include "../core/Version.as";
    
    //--------------------------------------------------------------------------
    //
    //  Notes
    //
    //--------------------------------------------------------------------------
    
    /*
    
    Although at the level of a Flash DisplayObjectContainer, all
    children are equal, in a Flex Container some children are "more
    equal than others". (George Orwell, "Animal Farm")
    
    In particular, Flex distinguishes between content children and
    non-content (or "chrome") children. Content children are the kind
    that can be specified in MXML. If you put several controls
    into a VBox, those are its content children. Non-content children
    are the other ones that you get automatically, such as a
    background/border, scrollbars, the titlebar of a Panel,
    AccordionHeaders, etc.
    
    Most application developers are uninterested in non-content children,
    so Container overrides APIs such as numChildren and getChildAt()
    to deal only with content children. For example, Container, keeps
    its own _numChildren counter.
    
    However, developers of custom containers need to be able to deal
    with both content and non-content children, so they require similar
    APIs that operate on all children.
    
    For the public API, it would be ugly to have double APIs on Container
    such as getChildAt() and all_getChildAt(). Instead, Container has
    a public rawChildren property which lets you access APIs which
    operate on all the children, in the same way that the
    DisplayObjectContainer APIs do. For example, getChildAt(0) returns
    the first content child, while rawChildren.getChildAt(0) returns
    the first child (either content or non-content).
    
    This ContainerRawChildrenList class implements the rawChildren
    property. Note that it simply calls a second set of parallel
    mx_internal APIs in Container. (They're named, for example,
    _getChildAt() instead of all_getChildAt()).
    
    Many of the all-children APIs in Container such as _getChildAt()
    simply call super.getChildAt() in order to get the implementation
    in DisplayObjectContainer. It would be nice if we could eliminate
    _getChildAt() in Container and simply implement the all-children
    version in this class by calling the DisplayObjectContainer method.
    But once Container overrides getChildAt(), there is no way
    to call the supermethod through an instance.
    
    */
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     *  Constructor.
     */
    public function LegendRawChildrenList(owner:Legend)
    {
        super();
        
        this.owner = owner;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    private var owner:Legend;
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  numChildren
    //----------------------------------
    
    /**
     *  @private
     */
    public function get numChildren():int
    {
        return owner.$sprite_numChildren;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    public function addChild(child:IUIComponent):IUIComponent
    {
        return owner.rawChildren_addChild(child);
    }
    
    /**
     *  @private
     */
    public function addChildAt(child:IUIComponent, index:int):IUIComponent
    {
        return owner.rawChildren_addChildAt(child, index);
    }
    
    /**
     *  @private
     */
    public function removeChild(child:IUIComponent):IUIComponent
    {
        return owner.rawChildren_removeChild(child);
    }
    
    /**
     *  @private
     */
    public function removeChildAt(index:int):IUIComponent
    {
        return owner.rawChildren_removeChildAt(index);
    }
    
    /**
     *  @private
     */
    public function getChildAt(index:int):IUIComponent
    {
        return owner.rawChildren_getChildAt(index);
    }
    
    /**
     *  @private
     */
    public function getChildByName(name:String):IUIComponent
    {
        return owner.rawChildren_getChildByName(name);
    }
    
    /**
     *  @private
     */
    public function getChildIndex(child:IUIComponent):int
    {
        return owner.rawChildren_getChildIndex(child);
    }
    
    /**
     *  @private
     */
    public function setChildIndex(child:IUIComponent, newIndex:int):void
    {       
        owner.rawChildren_setChildIndex(child, newIndex);
    }
    
    /**
     *  @private
     */
    public function getObjectsUnderPoint(point:Point):Array
    {
        return owner.rawChildren_getObjectsUnderPoint(point);
    }
    
    /**
     *  @private
     */
    public function contains(child:IUIBase):Boolean
    {
        return owner.rawChildren_contains(child);
    }   
}   
