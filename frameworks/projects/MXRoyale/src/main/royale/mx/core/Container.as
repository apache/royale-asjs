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
	import org.apache.royale.core.ContainerBaseStrandChildren;
	import org.apache.royale.core.IBeadLayout;
    import org.apache.royale.core.IBorderPaddingMarginValuesImpl
	import org.apache.royale.core.IChild;
	import org.apache.royale.core.IContainer;
	import org.apache.royale.core.IContentViewHost;
	import org.apache.royale.core.ILayoutHost;
	import org.apache.royale.core.ILayoutParent;
	import org.apache.royale.core.ILayoutView;
	import org.apache.royale.core.IMXMLDocument;
	import org.apache.royale.core.IParent;
	import org.apache.royale.core.IStatesImpl;
	import org.apache.royale.core.IContainerBaseStrandChildrenHost;
    import org.apache.royale.core.layout.EdgeData;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.ValueChangeEvent;
	import org.apache.royale.events.ValueEvent;
	import org.apache.royale.states.State;
	import org.apache.royale.utils.MXMLDataInterpreter;
	import org.apache.royale.utils.loadBeadFromValuesManager;

COMPILE::JS
{
    import goog.DEBUG;
	import org.apache.royale.core.WrappedHTMLElement;
	import org.apache.royale.html.util.addElementToWrapper;
}
/*
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Graphics;
import flash.display.InteractiveObject;
import flash.display.Loader;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.system.ApplicationDomain;
import flash.text.TextField;
import flash.text.TextLineMetrics;
import flash.ui.Keyboard;
import flash.utils.getDefinitionByName;

import mx.binding.BindingManager;
import mx.containers.utilityClasses.PostScaleAdapter;
import mx.controls.HScrollBar;
import mx.controls.VScrollBar;
import mx.controls.listClasses.IListItemRenderer;
import mx.controls.scrollClasses.ScrollBar;
import mx.core.IUITextField;
import mx.events.ChildExistenceChangedEvent;
*/
import mx.events.FlexEvent;
import mx.events.IndexChangedEvent;
import mx.managers.IFocusManagerContainer;
COMPILE::SWF
{
import flash.display.DisplayObject;
}

/*
import mx.events.ScrollEvent;
import mx.events.ScrollEventDetail;
import mx.events.ScrollEventDirection;
import mx.geom.RoundedRectangle;
import mx.managers.IFocusManager;
import mx.managers.ILayoutManagerClient;
import mx.managers.ISystemManager;
import mx.styles.CSSStyleDeclaration;
import mx.styles.ISimpleStyleClient;
import mx.styles.IStyleClient;
import mx.styles.StyleProtoChain;

use namespace mx_internal;
*/

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched after a child has been added to a container.
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
 *  @productversion Royale 0.9.3
 */
//[Event(name="childAdd", type="mx.events.ChildExistenceChangedEvent")]

/**
 *  Dispatched after the index (among the container children)
 *  of a container child changes.
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
 *  @productversion Royale 0.9.3
 */
[Event(name="childIndexChange", type="mx.events.IndexChangedEvent")]

/**
 *  Dispatched before a child of a container is removed.
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
 *  @productversion Royale 0.9.3
 */
//[Event(name="childRemove", type="mx.events.ChildExistenceChangedEvent")]

/**
 *  Dispatched when the <code>data</code> property changes.
 *
 *  <p>When a container is used as a renderer in a List or other components,
 *  the <code>data</code> property is used pass to the container
 *  the data to display.</p>
 *
 *  @eventType mx.events.FlexEvent.DATA_CHANGE
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
[Event(name="dataChange", type="mx.events.FlexEvent")]

/**
 *  Dispatched when the user manually scrolls the container.
 *
 *  <p>The event is dispatched when the scroll position is changed using
 *  either the mouse (e.g. clicking on the scrollbar's "down" button)
 *  or the keyboard (e.g., clicking on the down-arrow key).
 *  However, this event is not dispatched if the scroll position
 *  is changed programatically (e.g., setting the value of the
 *  <code>horizontalScrollPosition</code> property).
 *  The <code>viewChanged</code> event is delivered whenever the
 *  scroll position is changed, either manually or programatically.</p>
 *
 *  <p>At the time when this event is dispatched, the scrollbar has
 *  been updated to the new position, but the container's child objects
 *  have not been shifted to reflect the new scroll position.</p>
 *
 *  @eventType mx.events.ScrollEvent.SCROLL
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
//[Event(name="scroll", type="mx.events.ScrollEvent")]

/**
 * The default property uses when additional MXML content appears within an element's
 * definition in an MXML file.
 */
[DefaultProperty("mxmlContent")]

/**
 *  The Container class is an abstract base class for components that
 *  controls the layout characteristics of child components.
 *  You do not create an instance of Container in an application.
 *  Instead, you create an instance of one of Container's subclasses,
 *  such as Canvas or HBox.
 *
 *  <p>The Container class contains the logic for scrolling, clipping,
 *  and dynamic instantiation.
 *  It contains methods for adding and removing children.
 *  It also contains the <code>getChildAt()</code> method, and the logic
 *  for drawing the background and borders of containers.</p>
 *
 *  @mxml
 *
 *  Flex Framework containers inherit the following attributes from the Container
 *  class:</p>
 *
 *  <pre>
 *  &lt;mx:<i>tagname</i>
 *    <strong>Properties</strong>
 *    autoLayout="true|false"
 *    clipContent="true|false"
 *    creationIndex="undefined"
 *    creationPolicy="auto|all|queued|none"
 *    defaultButton="<i>No default</i>"
 *    horizontalLineScrollSize="5"
 *    horizontalPageScrollSize="0"
 *    horizontalScrollBar="null"
 *    horizontalScrollPolicy="auto|on|off"
 *    horizontalScrollPosition="0"
 *    icon="undefined"
 *    label=""
 *    verticalLineScrollSize="5"
 *    verticalPageScrollSize="0"
 *    verticalScrollBar="null"
 *    verticalScrollPolicy="auto|on|off"
 *    verticalScrollPosition="0"
 *
 *    <strong>Styles</strong>
 *    backgroundAlpha="1.0"
 *    backgroundAttachment="scroll"
 *    backgroundColor="undefined"
 *    backgroundDisabledColor="undefined"
 *    backgroundImage="undefined"
 *    backgroundSize="auto"
 *    <i>    For the Application container only,</i> backgroundSize="100%"
 *    barColor="undefined"
 *    borderColor="0xAAB3B3"
 *    borderSides="left top right bottom"
 *    borderSkin="mx.skins.halo.HaloBorder"
 *    borderStyle="inset"
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
 *    horizontalScrollBarStyleName="undefined"
 *    paddingBottom="0"
 *    paddingLeft="0"
 *    paddingRight="0"
 *    paddingTop="0"
 *    shadowDirection="center"
 *    shadowDistance="2"
 *    textAlign="left"
 *    textDecoration="none|underline"
 *    textIndent="0"
 *    verticalScrollBarStyleName="undefined"
 *
 *    <strong>Events</strong>
 *    childAdd="<i>No default</i>"
 *    childIndexChange="<i>No default</i>"
 *    childRemove="<i>No default</i>"
 *    dataChange="<i>No default</i>"
 *    scroll="<i>No default</i>"
 *    &gt;
 *      ...
 *      <i>child tags</i>
 *      ...
 *  &lt;/mx:<i>tagname</i>&gt;
 *  </pre>
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
public class Container extends UIComponent
					   implements IDataRenderer, IChildList,
					   IContainer, ILayoutParent, ILayoutView, IContentViewHost,
					   IContainerBaseStrandChildrenHost, IMXMLDocument, IFocusManagerContainer
                       //implements IContainer, IDataRenderer,
                       //IListItemRenderer,
                       //IRawChildrenContainer, IChildList, IVisualElementContainer,
                       //INavigatorContent

{

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
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function Container()
    {
        super();
		typeNames = "Container";
    }
	
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
        if (GOOG::DEBUG)
            trace("paddingTop not implemented");
        return 0;
    }
    public function set paddingTop(value:Object):void
    {
        if (GOOG::DEBUG)
            trace("paddingTop not implemented");
    }
    
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
        if (GOOG::DEBUG)
            trace("paddingBottom not implemented");
        return 0;
    }
    public function set paddingBottom(value:Object):void
    {
        if (GOOG::DEBUG)
            trace("paddingBottom not implemented");
    }
	
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
        if (GOOG::DEBUG)
            trace("paddingLeft not implemented");
        return 0;
    }
    public function set paddingLeft(value:Object):void
    {
        if (GOOG::DEBUG)
            trace("paddingLeft not implemented");
    }
	
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
        if (GOOG::DEBUG)
            trace("paddingRight not implemented");
        return 0;
    }
    public function set paddingRight(value:Object):void
    {
        if (GOOG::DEBUG)
            trace("paddingRight not implemented");
    }

    /**
     *  Number of pixels between children in the vertical direction.
     *  The default value depends on the component class;
     *  if not overridden for the class, the default value is 6.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function get verticalGap():Object
    {
        if (GOOG::DEBUG)
            trace("verticalGap not implemented");
        return 0;
    }
    public function set verticalGap(value:Object):void
    {
        if (GOOG::DEBUG)
            trace("verticalGap not implemented");
    }
	
	 public function get horizontalGap():Object
    {
        if (GOOG::DEBUG)
            trace("horizontalGap not implemented");
        return 0;
    }
    public function set horizontalGap(value:Object):void
    {
        if (GOOG::DEBUG)
            trace("horizontalGap not implemented");
    }
     public function get verticalAlign():Object
    {
        if (GOOG::DEBUG)
            trace("verticalAlign not implemented");
        return 0;
    }
    public function set verticalAlign(value:Object):void
    {
        if (GOOG::DEBUG)
            trace("verticalAlign not implemented");
    }
	/*	  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get borderStyle():Object
    {
        if (GOOG::DEBUG)
            trace("borderStyle not implemented");
        return 0;
    }
    public function set borderStyle(value:Object):void
    {
        if (GOOG::DEBUG)
            trace("borderStyle not implemented");
    }
	[Inspectable(category="General")]
	
	/*	  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get backgroundColor():Object
    {
        if (GOOG::DEBUG)
            trace("backgroundColor not implemented");
        return 0;
    }
    public function set backgroundColor(value:Object):void
    {
        if (GOOG::DEBUG)
            trace("backgroundColor not implemented");
    }
	[Inspectable(category="General")]
    /**
	 * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
	 */
	COMPILE::JS
	override protected function createElement():WrappedHTMLElement
	{
		return addElementToWrapper(this,'div');
	}
	
	//--------------------------------------------------------------------------
	//
	//  IMXMLDocument et al
	//
	//--------------------------------------------------------------------------
	
	private var _mxmlDescriptor:Array;
	private var _mxmlDocument:Object = this;
	
	override public function addedToParent():void
	{
		if (!initialized) {
			// each MXML file can also have styles in fx:Style block
			ValuesManager.valuesImpl.init(this);
		}
		
        if (MXMLDescriptor)
            component = this;
        
		super.addedToParent();		
		
		// Load the layout bead if it hasn't already been loaded.
		if (loadBeadFromValuesManager(IBeadLayout, "iBeadLayout", this))
			dispatchEvent(new Event("layoutNeeded"));
	}
	
    override protected function createChildren():void
    {
        MXMLDataInterpreter.generateMXMLInstances(_mxmlDocument, this, MXMLDescriptor);
        
        dispatchEvent(new Event("initBindings"));
        dispatchEvent(new Event("initComplete"));
    }
    
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
	
	/*
	* IContainer
	*/
	
	/**
	 *  @private
	 */
	public function childrenAdded():void
	{
		dispatchEvent(new ValueEvent("childrenAdded"));
	}
	
	/*
	* Utility
	*/
	
	/**
	 * Dispatches a "layoutNeeded" event
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	public function layoutNeeded():void
	{
		dispatchEvent( new Event("layoutNeeded") );
	}
	
	
	//----------------------------------
	//  data
	//----------------------------------
	
	/**
	 *  @private
	 *  Storage for the data property;
	 */
	private var _data:Object;
	
	[Bindable("dataChange")]
	[Inspectable(environment="none")]
	
	/**
	 *  The <code>data</code> property lets you pass a value
	 *  to the component when you use it as an item renderer or item editor.
	 *  You typically use data binding to bind a field of the <code>data</code>
	 *  property to a property of this component.
	 *
	 *  <p>When you use the control as a drop-in item renderer or drop-in
	 *  item editor, Flex automatically writes the current value of the item
	 *  to the <code>selected</code> property of this control.</p>
	 *
	 *  <p>You do not set this property in MXML.</p>
	 *
	 *  @default null
	 *  @see mx.core.IDataRenderer
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 0.9.3
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
	}
	
	/*
	* ILayoutParent
	*/
	
	/**
	 * Returns the ILayoutHost which is its view. From ILayoutParent.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	public function getLayoutHost():ILayoutHost
	{
		return view as ILayoutHost;
	}
	
	//----------------------------------
	//  getLayoutChildAt for compatibility
	//----------------------------------
	
	public function getLayoutChildAt(index:int):IUIComponent
	{
		return getElementAt(index) as IUIComponent;
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
	 *  @productversion Royale 0.9.3
	 */
	public function get viewMetricsAndPadding():EdgeMetrics
	{		
		// If this object has scrollbars, and if the verticalScrollPolicy
		// is not ScrollPolicy.ON, then the view metrics change
		// depending on whether we're doing layout or not.
		// In that case, we can't use a cached value.
		// In all other cases, use the cached value if it exists.
//		if (_viewMetricsAndPadding &&
//			(!horizontalScrollBar ||
//				horizontalScrollPolicy == ScrollPolicy.ON) &&
//			(!verticalScrollBar ||
//				verticalScrollPolicy == ScrollPolicy.ON))
		if (_viewMetricsAndPadding)
		{
			return _viewMetricsAndPadding;
		}
		
		if (!_viewMetricsAndPadding) {
			_viewMetricsAndPadding = new EdgeMetrics();
		}
		
		var o:EdgeMetrics = _viewMetricsAndPadding;
		var ed:EdgeData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getBorderMetrics(this);
        var vm:EdgeMetrics = new EdgeMetrics(ed.left, ed.top, ed.right, ed.bottom);
		
		o.left = vm.left + getStyle("paddingLeft");
		o.right = vm.right + getStyle("paddingRight");
		o.top = vm.top + getStyle("paddingTop");
		o.bottom = vm.bottom + getStyle("paddingBottom");
		
		return o;
	}
	
	//--------------------------------------------------------------------------
	//  StrandChildren
	//--------------------------------------------------------------------------
	
	private var _strandChildren:ContainerBaseStrandChildren;
	
	/**
	 * @copy org.apache.royale.core.IContentViewHost#strandChildren
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	
	/**
	 * @private
	 */
	public function get strandChildren():IParent
	{
		if (_strandChildren == null) {
			_strandChildren = new ContainerBaseStrandChildren(this);
		}
		return _strandChildren;
	}

    //--------------------------------------------------------------------------
    //
    //  element/child handlers
    //
    //--------------------------------------------------------------------------

	
	/**
	 * @private
	 */
	COMPILE::JS
	override public function addElement(c:IChild, dispatchEvent:Boolean = true):void
	{
		super.addElement(c, dispatchEvent);
		if (dispatchEvent)
			this.dispatchEvent(new ValueEvent("childrenAdded", c));
	}
	
	/**
	 * @private
	 */
	COMPILE::JS
	override public function addElementAt(c:IChild, index:int, dispatchEvent:Boolean = true):void
	{
		super.addElementAt(c, index, dispatchEvent);
		if (dispatchEvent)
			this.dispatchEvent(new ValueEvent("childrenAdded", c));
	}
	
	/**
	 * @private
	 */
	COMPILE::JS
	override public function removeElement(c:IChild, dispatchEvent:Boolean = true):void
	{
		super.removeElement(c, dispatchEvent);
		//TODO This should possibly be ultimately refactored to be more PAYG
		if (dispatchEvent)
			this.dispatchEvent(new ValueEvent("childrenRemoved", c));
	}
	
	/*
	* The following functions are for the SWF-side only and re-direct element functions
	* to the content area, enabling scrolling and clipping which are provided automatically
	* in the JS-side. 
	*/
	
	/**
	 * @private
	 */
	COMPILE::SWF
	override public function addElement(c:IChild, dispatchEvent:Boolean = true):void
	{
		var contentView:IParent = getLayoutHost().contentView as IParent;
		contentView.addElement(c, dispatchEvent);
		if (dispatchEvent)
			this.dispatchEvent(new ValueEvent("childrenAdded", c));
	}
	
	/**
	 * @private
	 */
	COMPILE::SWF
	override public function addElementAt(c:IChild, index:int, dispatchEvent:Boolean = true):void
	{
		var contentView:IParent = getLayoutHost().contentView as IParent;
		contentView.addElementAt(c, index, dispatchEvent);
		if (dispatchEvent)
			this.dispatchEvent(new ValueEvent("childrenAdded", c));
	}
	
	/**
	 * @private
	 */
	COMPILE::SWF
	override public function getElementIndex(c:IChild):int
	{
		var layoutHost:ILayoutHost = view as ILayoutHost;
		var contentView:IParent = layoutHost.contentView as IParent;
		return contentView.getElementIndex(c);
	}
	
	/**
	 * @private
	 */
	COMPILE::SWF
	override public function removeElement(c:IChild, dispatchEvent:Boolean = true):void
	{
		var layoutHost:ILayoutHost = view as ILayoutHost;
		var contentView:IParent = layoutHost.contentView as IParent;
		contentView.removeElement(c, dispatchEvent);
		//TODO This should possibly be ultimately refactored to be more PAYG
		if(dispatchEvent)
			this.dispatchEvent(new ValueEvent("childrenRemoved", c));
	}
	
	/**
	 * @private
	 */
	COMPILE::SWF
	override public function get numElements():int
	{
		var layoutHost:ILayoutHost = view as ILayoutHost;
		var contentView:IParent = layoutHost.contentView as IParent;
		return contentView.numElements;
	}
	
	/**
	 * @private
	 */
	COMPILE::SWF
	override public function getElementAt(index:int):IChild
	{
		var layoutHost:ILayoutHost = view as ILayoutHost;
		var contentView:IParent = layoutHost.contentView as IParent;
		return contentView.getElementAt(index);
	}
	
    COMPILE::SWF
    override public function getChildAt(index:int):DisplayObject
    {
        var layoutHost:ILayoutHost = view as ILayoutHost;
        var contentView:IParent = layoutHost.contentView as IParent;
        return contentView.getElementAt(index) as DisplayObject;
    }

	/*
	* IContainerBaseStrandChildrenHost
	*
	* These "internal" function provide a backdoor way for proxy classes to
	* operate directly at strand level. While these function are available on
	* both SWF and JS platforms, they really only have meaning on the SWF-side. 
	* Other subclasses may provide use on the JS-side.
	*
	* @see org.apache.royale.core.IContainer#strandChildren
	*/
	
	/**
	 * @private
	 * @suppress {undefinedNames}
	 * Support strandChildren.
	 */
	public function $numElements():int
	{
		return super.numElements;
	}
	
	/**
	 * @private
	 * @suppress {undefinedNames}
	 * Support strandChildren.
	 */
	public function $addElement(c:IChild, dispatchEvent:Boolean = true):void
	{
		super.addElement(c, dispatchEvent);
	}
	
	/**
	 * @private
	 * @suppress {undefinedNames}
	 * Support strandChildren.
	 */
	public function $addElementAt(c:IChild, index:int, dispatchEvent:Boolean = true):void
	{
		super.addElementAt(c, index, dispatchEvent);
	}
	
	/**
	 * @private
	 * @suppress {undefinedNames}
	 * Support strandChildren.
	 */
	public function $removeElement(c:IChild, dispatchEvent:Boolean = true):void
	{
		super.removeElement(c, dispatchEvent);
	}
	
	/**
	 * @private
	 * @suppress {undefinedNames}
	 * Support strandChildren.
	 */
	public function $getElementIndex(c:IChild):int
	{
		return super.getElementIndex(c);
	}
	
	/**
	 * @private
	 * @suppress {undefinedNames}
	 * Support strandChildren.
	 */
	public function $getElementAt(index:int):IChild
	{
		return super.getElementAt(index);
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
     *  @productversion Royale 0.9.3
     */
    public function get childDescriptors():Array /* of UIComponentDescriptor */
    {
        return _childDescriptors;
    }

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
     *  @productversion Royale 0.9.3
     */
	COMPILE::SWF
    override public function addChild(child:DisplayObject):DisplayObject
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
     *  @productversion Royale 0.9.3
     */
    public function get creationPolicy():String
    {
        // Use an inheriting style as the backing storage for this property.
        // This allows the property to be inherited by either mx or spark
        // containers, and also to correctly cascade through containers that
        // don't have this property (ie Group).
        // This style is an implementation detail and should be considered
        // private. Do not set it from CSS.
        /*if (creationPolicyNone)
            return ContainerCreationPolicy.NONE;*/
        return getStyle("_creationPolicy");
    }

    /**
     *  @private
     */
    public function set creationPolicy(value:String):void
    {
        var styleValue:String = value;
        
        /*if (value == ContainerCreationPolicy.NONE)
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
        }*/
        
        setStyle("_creationPolicy", styleValue);

        //setActualCreationPolicies(value);
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

        // Scrollbars must be enabled/disabled when this container is.
        /*if (horizontalScrollBar)
            horizontalScrollBar.enabled = value;
        if (verticalScrollBar)
            verticalScrollBar.enabled = value;

        invalidateProperties();
        
        if (border && border is IInvalidating)
            IInvalidating(border).invalidateDisplayList();*/
    }

    //----------------------------------
    //  numChildren
    //----------------------------------

    /**
     *  @private
     *  Storage for the numChildren property.
     */
    /*mx_internal*/private var _numChildren:int = 0;

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
     *  @productversion Royale 0.9.3
     */
    override public function get numChildren():int
    {
        return _numChildren;//contentPane ? contentPane.numChildren : _numChildren;
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function removeElementAt(index:int):IVisualElement
    {
        return removeChildAt(index) as IVisualElement;
    }
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function removeAllElements():void
    {
        for (var i:int = numElements - 1; i >= 0; i--)
        {
            removeElementAt(i);
        }
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
     *  @productversion Royale 0.9.3
     */
	COMPILE::SWF
    override public function removeChildAt(index:int):DisplayObject
    {
        return removeChild(getChildAt(index));

        /*

        Shouldn't implement removeChildAt() in terms of removeChild().
        If we change this ViewStack IList, Application, and Panel are depending on it

        */
    }

    /**
     *  @private
     */
    override public function validateDisplayList():void
    {
        // trace(">>Container validateLayoutPhase " + this);
        
        var vm:EdgeMetrics;
		/*
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
        invalidateDisplayListFlag = true;

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

            // Set the position and size of the overlay .
            if (effectOverlay)
            {
                effectOverlay.x = 0;
                effectOverlay.y = 0;
                effectOverlay.width = unscaledWidth;
                effectOverlay.height = unscaledHeight;
            }

            // Set the positions and sizes of the scrollbars.
            if (horizontalScrollBar || verticalScrollBar)
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
            }

            contentPane.x = vm.left;
            contentPane.y = vm.top;

            if (focusPane)
            {
                focusPane.x = vm.left
                focusPane.y = vm.top;
            }

            scrollChildren();
        }

        invalidateDisplayListFlag = false;

        // that blocks UI input as well as draws an alpha overlay.
        // Make sure the blocker is correctly positioned and sized here.
        if (blocker)
        {
            vm = viewMetrics;

            if (FlexVersion.compatibilityVersion >= FlexVersion.VERSION_4_0)
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

        // trace("<<Container internalValidateDisplayList " + this);*/
    }

}

}
