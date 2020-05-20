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
import flash.display.DisplayObject;
import flash.display.InteractiveObject;
import flash.events.ContextMenuEvent;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.external.ExternalInterface;
import flash.net.URLRequest;
import flash.net.navigateToURL;
import flash.system.Capabilities;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;
import flash.utils.setInterval;

import mx.containers.utilityClasses.ApplicationLayout;
import mx.effects.EffectManager;
import mx.events.FlexEvent;
import mx.managers.IActiveWindowManager;
import mx.managers.ILayoutManager;
import mx.styles.CSSStyleDeclaration;
import mx.styles.IStyleClient;
import mx.utils.LoaderUtil;
import mx.utils.Platform;

use namespace mx_internal;
*/
COMPILE::SWF {
import flash.events.Event;
import flash.display.DisplayObject;
import flash.display.StageAlign;
import flash.display.StageQuality;
import flash.display.StageScaleMode;
import flash.system.ApplicationDomain;
import flash.utils.getQualifiedClassName;
}

import mx.containers.beads.ApplicationLayout;
import mx.containers.beads.BoxLayout;
import mx.events.KeyboardEvent;
import mx.events.utils.FocusEventConverter;
import mx.events.utils.KeyboardEventConverter;
import mx.events.utils.MouseEventConverter;
import mx.managers.FocusManager;
import mx.managers.ISystemManager;
import mx.events.FlexEvent;

COMPILE::JS {
    import org.apache.royale.core.ElementWrapper;
    import org.apache.royale.events.ElementEvents;
}

import org.apache.royale.binding.ContainerDataBinding;
import org.apache.royale.core.AllCSSValuesImpl;
import org.apache.royale.core.IBead;
import org.apache.royale.core.IBeadLayout;
import org.apache.royale.core.IFlexInfo;
import org.apache.royale.core.IInitialViewApplication;
import org.apache.royale.core.ILayoutChild;
import org.apache.royale.core.IParent;
import org.apache.royale.core.IPopUpHost;
import org.apache.royale.core.IPopUpHostParent;
import org.apache.royale.core.IRenderedObject;
import org.apache.royale.core.IStatesImpl;
import org.apache.royale.core.IStrand;
import org.apache.royale.core.IValuesImpl;
import org.apache.royale.core.ValuesManager;
import org.apache.royale.events.Event;
import org.apache.royale.events.IEventDispatcher;
import org.apache.royale.events.ValueChangeEvent;
import org.apache.royale.reflection.beads.ClassAliasBead;
import org.apache.royale.states.State;
import org.apache.royale.utils.MXMLDataInterpreter;
import org.apache.royale.utils.MixinManager;
import org.apache.royale.utils.Timer;
import org.apache.royale.utils.loadBeadFromValuesManager;
    
//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched after the Application has been initialized,
 *  processed by the LayoutManager, and attached to the display list.
 * 
 *  @eventType mx.events.FlexEvent.APPLICATION_COMPLETE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="applicationComplete", type="mx.events.FlexEvent")]

/**
 *  Dispatched when an HTTPService call fails.
 * 
 *  @eventType flash.events.ErrorEvent.ERROR
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="error", type="flash.events.ErrorEvent")]


//--------------------------------------
//  Excluded APIs
//--------------------------------------

[Exclude(name="direction", kind="property")]
[Exclude(name="icon", kind="property")]
[Exclude(name="label", kind="property")]
[Exclude(name="tabIndex", kind="property")]
[Exclude(name="toolTip", kind="property")]
[Exclude(name="x", kind="property")]
[Exclude(name="y", kind="property")]

//--------------------------------------
//  Other metadata
//--------------------------------------

/**
 *  The frameworks must be initialized by SystemManager.
 *  This factoryClass will be automatically subclassed by any
 *  MXML applications that don't explicitly specify a different
 *  factoryClass.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Frame(factoryClass="mx.managers.SystemManager")]

[DefaultProperty("mxmlContent")]

/**
 *  Flex defines a default, or Application, container that lets you start
 *  adding content to your application without explicitly defining
 *  another container.
 *  Flex creates this container from the <code>&lt;mx:Application&gt;</code>
 *  tag, the first tag in an MXML application file.
 *  While you might find it convenient to use the Application container
 *  as the only  container in your application, in most cases you explicitly
 *  define at least one more container before you add any controls
 *  to your application.
 *
 *  <p>Applications support a predefined plain style that sets
 *  a white background, left alignment, and removes all margins.
 *  To use this style, do the following:</p>
 *
 *  <pre>
 *    &lt;mx:Application styleName="plain" /&gt;
 *  </pre>
 *
 *  <p>This is equivalent to setting the following style attributes:</p>
 *
 *  <pre>
 *    backgroundColor="0xFFFFFF"
 *    horizontalAlign="left"
 *    paddingLeft="0"
 *    paddingTop="0"
 *    paddingBottom="0"
 *    paddingRight="0"
 *  </pre>
 * 
 *  @mxml
 *
 *  <p>The <code>&lt;mx:Application&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;mx:Application
 *    <strong>Properties</strong>
 *    application="<i>No default</i>"
 *    controlBar="null"
 *    frameRate="24"
 *    historyManagementEnabled="true|false"
 *    layout="vertical|horizontal|absolute"
 *    pageTitle"<i>No default</i>"
 *    preloader="<i>No default</i>"
 *    resetHistory="false|true"
 *    scriptRecursionLimit="1000"
 *    scriptTimeLimit="60"
 *    usePreloader="true|false"
 *    viewSourceURL=""
 *    xmlns:<i>No default</i>="<i>No default</i>"
 * 
 *    <strong>Styles</strong> 
 *    backgroundGradientAlphas="[ 1.0, 1.0 ]"
 *    backgroundGradientColors="undefined"
 *    horizontalAlign="center|left|right"
 *    horizontalGap="8"
 *    modalTransparency="0.5"
 *    modalTransparencyBlur="3"
 *    modalTransparencyColor="#DDDDDD"
 *    modalTransparencyDuration="100"
 *    paddingBottom="24"
 *    paddingTop="24"
 *    verticalAlign="top|bottom|middle"
 *    verticalGap="6"
 *  
 *    <strong>Events</strong>
 *    applicationComplete="<i>No default</i>"
 *    error="<i>No default</i>"
 *  /&gt;
 *  </pre>
 *
 *  @includeExample examples/SimpleApplicationExample.mxml
 *  
 *  @see mx.managers.CursorManager
 *  @see mx.managers.LayoutManager
 *  @see mx.managers.SystemManager
 *  @see flash.events.EventDispatcher
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class Application extends Container implements IStrand, IParent, IEventDispatcher, IPopUpHost, IPopUpHostParent, IRenderedObject, IFlexInfo
{

    //--------------------------------------------------------------------------
    //
    //  Class properties
    //
    //--------------------------------------------------------------------------

    /**
     *  A reference to the top-level application.
     *
     *  <p>In general, there can be a hierarchy of Application objects,
     *  because an Application can use a SWFLoader control to dynamically
     *  load another Application.
     *  The <code>parentApplication</code> property of a UIComponent can be
     *  used to access the sub-Application in which that UIComponent lives,
     *  and to walk up the hierarchy to the top-level Application.</p>
     *  
     *  <p>This property has been deprecated starting in Flex4. Note that this
     *  property will still return applications of type mx.core.Application and 
     *  mx.core.WindowedApplication as in previous versions. Starting in Flex 4
     *  it will also return applications of type spark.components.Application or 
     *  spark.components.WindowedApplication.</p>
     * 
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    /*
     *  Note: here are two reasons that 'application' is typed as Object
     *  rather than as Application. The first is for consistency with
     *  the 'parentApplication' property of UIComponent. That property is not
     *  typed as Application because it would make UIComponent dependent
     *  on Application, slowing down compile times not only for SWCs
     *  for also for MXML and AS components. Second, if it were typed
     *  as Application, authors would not be able to access properties
     *  and methods in the <Script> of their <Application> without
     *  casting it to their application's subclass, as in
     *  MyApplication(Application.application).myAppMethod().
     *  Therefore we decided to dispense with strict typing for
     *  'application'.
     */
    public static function get application():Object
    {
        return FlexGlobals.topLevelApplication;
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
    public function Application()
    {
        if (!FlexGlobals.topLevelApplication)
            FlexGlobals.topLevelApplication = this;

        super();
		
        typeNames += " Application";
		
		this.valuesImpl = new AllCSSValuesImpl();
		addBead(new ContainerDataBinding()); // ApplicationDataBinding fires too soon
        addBead(new ClassAliasBead());

        instanceParent = this;
        
    }
	
    private var _info:Object;
    
    /**
     *  An Object containing information generated
     *  by the compiler that is useful at startup time.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function info():Object
    {
        COMPILE::SWF
        {
        if (!_info)
        {
            var mainClassName:String = getQualifiedClassName(this);
            var initClassName:String = "_" + mainClassName + "_FlexInit";
            var c:Class = ApplicationDomain.currentDomain.getDefinition(initClassName) as Class;
            _info = c.info();
        }
        }
        return _info;
    }
    
    COMPILE::SWF
    {
    [SWFOverride(returns="flash.display.DisplayObjectContainer")]
    override public function get parent():IParent
    {
        var p:* = $sprite_parent;
        return p;
    }
    }
        
    COMPILE::SWF
    override public function addedToParent():void
    {
        super.addedToParent();
        initHandler(null);    
    }
    
	COMPILE::SWF
	private function initHandler(event:flash.events.Event):void
	{
		MouseEventConverter.setupAllConverters(stage);
		FocusEventConverter.setupAllConverters(stage);
		KeyboardEventConverter.setupAllConverters(stage);
		
		if (initialized || dispatchEvent(new org.apache.royale.events.Event("preinitialize", false, true)))
			this.initializeApplication();
		else
			addEventListener(flash.events.Event.ENTER_FRAME, enterFrameHandler);
		
	}
	
	COMPILE::SWF
	private function enterFrameHandler(event:flash.events.Event):void
	{
		if (initialized || dispatchEvent(new org.apache.royale.events.Event("preinitialize", false, true)))
		{
			removeEventListener(flash.events.Event.ENTER_FRAME, enterFrameHandler);
			this.initializeApplication();
		}
	}
	
    private var _parameters:Object;
    
    /**
     *  The parameters property returns an Object containing name-value
     *  pairs representing the parameters provided to this Application.
     *
     *  <p>You can use a for-in loop to extract all the names and values
     *  from the parameters Object.</p>
     *
     *  <p>There are two sources of parameters: the query string of the
     *  Application's URL, and the value of the FlashVars HTML parameter
     *  (this affects only the main Application).</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get parameters():Object
    {
        COMPILE::SWF
        {
            return loaderInfo.parameters;
        }
        COMPILE::JS
        {
            if (!_parameters)
            {
                _parameters = {};
                var query:String = location.search.substring(1);
                if(query)
                {
                    var vars:Array = query.split("&");
                    for (var i:int=0;i<vars.length;i++) {
                        var pair:Array = vars[i].split("=");
                        _parameters[pair[0]] = decodeURIComponent(pair[1]);
                    }
                }
            }
            return _parameters;
        }
    }

    public function set parameters(value:Object):void
    {
        // do nothing in SWF.  It is determined by loaderInfo.
        COMPILE::JS
        {
            _parameters = value;
        }
    }
    
	/**
	 *  This method gets called when all preinitialize handlers
	 *  no longer call preventDefault();
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
    COMPILE::SWF
    public function initializeApplication():void
    {
        //addBead(new MixinManager());  should now be handled by SystemManager
        
		this.initManagers();

        dispatchEvent(new FlexEvent("applicationComplete"));
    }
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  The org.apache.royale.core.IValuesImpl that will
	 *  determine the default values and other values
	 *  for the application.  The most common choice
	 *  is org.apache.royale.core.SimpleCSSValuesImpl.
	 *
	 *  @see org.apache.royale.core.SimpleCSSValuesImpl
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
    public function set valuesImpl(value:IValuesImpl):void
    {
        ValuesManager.valuesImpl = value;
        ValuesManager.valuesImpl.init(this);
    }
	
	private var instanceParent:mx.core.Application;
	
	//----------------------------------
	//  layout
	//----------------------------------
	
	/**
	 *  @private
	 *  Storage for layout property.
	 */
	private var _layout:String = ContainerLayout.VERTICAL;
	
	[Bindable("layoutChanged")]
	[Inspectable(category="General", enumeration="vertical,horizontal,absolute", defaultValue="vertical")]
	
	/**
	 *  Specifies the layout mechanism used for this application. 
	 *  Applications can use <code>"vertical"</code>, <code>"horizontal"</code>, 
	 *  or <code>"absolute"</code> positioning. 
	 *  Vertical positioning lays out each child component vertically from
	 *  the top of the application to the bottom in the specified order.
	 *  Horizontal positioning lays out each child component horizontally
	 *  from the left of the application to the right in the specified order.
	 *  Absolute positioning does no automatic layout and requires you to
	 *  explicitly define the location of each child component. 
	 *
	 *  @default "vertical"
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get layout():String
	{
		return _layout;
	}
	
	/**
	 *  @private
	 */
	public function set layout(value:String):void
	{
		if (value != _layout) {
			// do something here - find the right bead, remove the old bead??
			var layoutBead:IBeadLayout = getBeadByType(IBeadLayout) as IBeadLayout;
			if (layoutBead is BoxLayout) {
				(layoutBead as BoxLayout).direction = value;
			}
		}
	}
	
	//----------------------------------
    //  url
    //----------------------------------

    /**
     *  @private
     *  Storage for the url property.
     *  This variable is set in the initialize() method.
     */
    /* mx_internal */ private var _url:String;

    /**
     *  The URL from which this Application's SWF file was loaded.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get url():String
    {
        return _url;
    }		
	//--------------------------------------------------------------------------
	//
	//  Initialization and Start-up
	//
	//--------------------------------------------------------------------------

    override protected function createChildren():void
    {
        COMPILE::JS
        {
            ElementEvents.elementEvents["focusin"] = 1;
            ElementEvents.elementEvents["focusout"] = 1;
        }
        super.createChildren();        
        dispatchEvent(new org.apache.royale.events.Event("viewChanged"));
    }

	/**
	 *  @private
	 */
	private function initManagers():void
	{
		focusManager = new FocusManager(this);
	}
		
	COMPILE::JS
	protected var startupTimer:Timer;
	
    private var _started:Boolean = false;
    
    COMPILE::JS
    override public function setActualSize(w:Number, h:Number):void
    {
        super.setActualSize(w, h);
        if (!_started)
        {
            start();
            _started = true;
        }
    }
    
	/**
	 * @royaleignorecoercion org.apache.royale.core.IBead
	 */
	COMPILE::JS
	public function start():void
	{
		if (initialized || dispatchEvent(new FlexEvent("preinitialize", false, true)))
			initializeApplication();
		else {			
			startupTimer = new Timer(34, 0);
			startupTimer.addEventListener("timer", handleStartupTimer);
			startupTimer.start();
		}
	}
	
	/**
	 * @private
	 */
	COMPILE::JS
	protected function handleStartupTimer(event:Event):void
	{
		if (initialized || dispatchEvent(new FlexEvent("preinitialize", false, true)))
		{
			startupTimer.stop();
			initializeApplication();
		}
	}
	
	/**
	 * @royaleignorecoercion org.apache.royale.core.IBead
	 */
	COMPILE::JS
	public function initializeApplication():void
	{
        ElementWrapper.converterMap["MouseEvent"] = MouseEventConverter.convert;
        ElementWrapper.converterMap["KeyboardEvent"] = KeyboardEventConverter.convert;
        ElementWrapper.converterMap["FocusEvent"] = FocusEventConverter.convert;
        addEventListener(KeyboardEvent.KEY_DOWN, keyDownForCapsLockHandler);
        
        initManagers();
        
//		if (initialView)
//		{
//            initialView.applicationModel = model;
//            addElement(initialView);
//            
//			var baseView:UIBase = initialView as UIBase;
//			if (!isNaN(baseView.percentWidth) || !isNaN(baseView.percentHeight)) {
//				this.element.style.height = window.innerHeight.toString() + 'px';
//				this.element.style.width = window.innerWidth.toString() + 'px';
//				this.initialView.dispatchEvent('sizeChanged'); // kick off layout if % sizes
//			}
//			
//			dispatchEvent(new org.apache.royale.events.Event("viewChanged"));
//		}
		dispatchEvent(new FlexEvent("applicationComplete"));
	}
	
    COMPILE::JS
    public function keyDownForCapsLockHandler(event:KeyboardEvent):void
    {
        
    }

	//--------------------------------------------------------------------------
	//
	//  Other overrides
	//
	//--------------------------------------------------------------------------
	
	COMPILE::SWF
	override public function get $displayObject():DisplayObject
	{
		return this;
	}
	
	COMPILE::SWF
	override public function set width(value:Number):void
	{
		// just eat this.  
		// The stageWidth will be set by SWF metadata. 
		// Setting this directly doesn't do anything
	}
	
	COMPILE::SWF
	override public function set height(value:Number):void
	{
		// just eat this.  
		// The stageWidth will be set by SWF metadata. 
		// Setting this directly doesn't do anything
	}

    //--------------------------------------------------------------------------
    //
    //  IPopUpHost
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Application can host popups but in the strandChildren
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function get popUpParent():IPopUpHostParent
    {
        COMPILE::JS
        {
            return systemManager as IPopUpHostParent;
        }
        COMPILE::SWF
        {
            return strandChildren as IPopUpHostParent;
        }
    }
    
    override public function get systemManager():ISystemManager
    {
        return parent as ISystemManager;
    }
    
    /**
     */
    public function get popUpHost():IPopUpHost
    {
        return this;
    }

}

}
