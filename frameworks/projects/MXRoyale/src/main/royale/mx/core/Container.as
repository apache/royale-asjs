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
	import org.apache.royale.core.IChild;
	import org.apache.royale.core.IContainer;
	import org.apache.royale.core.IContentViewHost;
	import org.apache.royale.core.ILayoutHost;
	import org.apache.royale.core.ILayoutParent;
	import org.apache.royale.core.ILayoutView;
	import org.apache.royale.core.IMXMLDocument;
	import org.apache.royale.core.IParent;
	import org.apache.royale.core.IStatesImpl;
	import org.apache.royale.core.IStrandPrivate;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.ValueChangeEvent;
	import org.apache.royale.events.ValueEvent;
	import org.apache.royale.geom.Rectangle;
	import org.apache.royale.states.State;
	import org.apache.royale.utils.CSSContainerUtils;
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
 *  @productversion Flex 3
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
 *  @productversion Flex 3
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
 *  @productversion Flex 3
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
 *  @productversion Flex 3
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
 *  @productversion Flex 3
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
 *  @productversion Flex 3
 */
public class Container extends UIComponent
					   implements IDataRenderer, IChildList,
					   IContainer, ILayoutParent, ILayoutView, IContentViewHost,
					   IStrandPrivate, IMXMLDocument, IFocusManagerContainer
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
     *  @productversion Flex 3
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
     *  @productversion Flex 3
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
     *  @productversion Flex 3
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
     *  Number of pixels between children in the vertical direction.
     *  The default value depends on the component class;
     *  if not overridden for the class, the default value is 6.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
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
	private var _initialized:Boolean;
	
	override public function addedToParent():void
	{
		if (!_initialized) {
			// each MXML file can also have styles in fx:Style block
			ValuesManager.valuesImpl.init(this);
		}
		
        if (MXMLDescriptor)
            component = this;
        
		super.addedToParent();
		
		if (!_initialized) {
			MXMLDataInterpreter.generateMXMLInstances(_mxmlDocument, this, MXMLDescriptor);
			
			dispatchEvent(new Event("initBindings"));
			dispatchEvent(new Event("initComplete"));
			_initialized = true;
		}
		
		// Load the layout bead if it hasn't already been loaded.
		if (loadBeadFromValuesManager(IBeadLayout, "iBeadLayout", this))
			dispatchEvent(new Event("layoutNeeded"));
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
	 *  @productversion Flex 3
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
		var vm:EdgeMetrics = new EdgeMetrics();//viewMetrics;
		var rect:Rectangle = CSSContainerUtils.getBorderMetrics(this);
		vm.convertFromRectangle(rect);
		
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
	* IStrandPrivate
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
}

}
