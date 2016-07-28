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

package mx.managers
{

COMPILE::SWF
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.EventPhase;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.system.ApplicationDomain;
	import flash.text.Font;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import flex.events.FlashEventConverter;
}
COMPILE::JS
{
	import flex.display.DisplayObject;
	import flex.display.DisplayObjectContainer;
	import flex.display.Graphics;
	import flex.display.MovieClip;
	import flex.display.Sprite;
	import flex.events.Event;
	import flex.events.EventPhase;
	import flex.ui.Keyboard;
	
	import org.apache.flex.events.MouseEvent;
	import org.apache.flex.geom.Point;
}
import org.apache.flex.utils.Timer;
import flex.system.DefinitionManager;
import org.apache.flex.reflection.getQualifiedClassName;

import mx.core.IChildList;
import mx.core.IFlexDisplayObject;
import mx.core.IFlexModuleFactory;
import mx.core.IInvalidating;
import mx.core.IRawChildrenContainer;
import mx.core.IUIComponent;
COMPILE::LATER
{
import mx.core.RSLData;
import mx.core.RSLItem;
}
import mx.core.Singleton;
import mx.core.mx_internal;
import mx.events.DynamicEvent;
import mx.events.FlexEvent;
COMPILE::LATER
{	
import mx.events.RSLEvent;
import mx.events.Request;
import mx.events.SandboxMouseEvent;
}
import mx.preloaders.Preloader;
import mx.utils.DensityUtil;
COMPILE::LATER
{
import mx.utils.LoaderUtil;
}
import flex.display.ModuleInfo;
COMPILE::SWF
{
import flex.display.TopOfDisplayList;
}
COMPILE::LATER
{

import org.apache.flex.core.UIBase;
}
import org.apache.flex.events.EventDispatcher;
import org.apache.flex.events.IEventDispatcher;
import org.apache.flex.geom.Rectangle;
import org.apache.flex.core.IFlexJSElement;

COMPILE::SWF
{
import org.apache.flex.core.IBeadView;
import org.apache.flex.core.IBead;
import org.apache.flex.core.IBeadModel
};

// NOTE: Minimize the non-Flash classes you import here.
// Any dependencies of SystemManager have to load in frame 1,
// before the preloader, or anything else, can be displayed.

use namespace mx_internal;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched when the application has finished initializing
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
 *  Dispatched every 100 milliseconds when there has been no keyboard
 *  or mouse activity for 1 second.
 *
 *  @eventType mx.events.FlexEvent.IDLE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="idle", type="mx.events.FlexEvent")]

/**
 *  Dispatched when the Stage is resized.
 *
 *  @eventType flash.events.Event.RESIZE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="resize", type="flash.events.Event")]

/**
 *  The SystemManager class manages an application window.
 *  Every application that runs on the desktop or in a browser
 *  has an area where the visuals of the application are 
 *  displayed.  
 *  It may be a window in the operating system
 *  or an area within the browser.  That area is an application window
 *  and different from an instance of <code>mx.core.Application</code>, which
 *  is the main, or top-level, window within an application.
 *
 *  <p>Every application has a SystemManager.  
 *  The SystemManager sends an event if
 *  the size of the application window changes (you cannot change it from
 *  within the application, but only through interaction with the operating
 *  system window or browser).  It parents all displayable things within the
 *  application like the main mx.core.Application instance and all popups, 
 *  tooltips, cursors, and so on.  Any object parented by the SystemManager is
 *  considered to be a top-level window, even tooltips and cursors.</p>
 *
 *  <p>The SystemManager also switches focus between top-level windows if there 
 *  are more than one IFocusManagerContainer displayed and users are interacting
 *  with components within the IFocusManagerContainers.  </p>
 *
 *  <p>All keyboard and mouse activity that is not expressly trapped is seen by
 *  the SystemManager, making it a good place to monitor activity should you need
 *  to do so.</p>
 *
 *  <p>If an application is loaded into another application, a SystemManager
 *  will still be created, but will not manage an application window,
 *  depending on security and domain rules.
 *  Instead, it will be the <code>content</code> of the <code>Loader</code> 
 *  that loaded it and simply serve as the parent of the sub-application</p>
 *
 *  <p>The SystemManager maintains multiple lists of children, one each for tooltips, cursors,
 *  popup windows.  This is how it ensures that popup windows "float" above the main
 *  application windows and that tooltips "float" above that and cursors above that.
 *  If you simply examine the <code>numChildren</code> property or 
 *  call the <code>getChildAt()</code> method on the SystemManager, you are accessing
 *  the main application window and any other windows that aren't popped up.  To get the list
 *  of all windows, including popups, tooltips and cursors, use 
 *  the <code>rawChildren</code> property.</p>
 *
 *  <p>The SystemManager is the first display class created within an application.
 *  It is responsible for creating an <code>mx.preloaders.Preloader</code> that displays and
 *  <code>mx.preloaders.SparkDownloadProgressBar</code> while the application finishes loading,
 *  then creates the <code>mx.core.Application</code> instance.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class SystemManager extends MovieClip
                           implements IChildList, IFlexDisplayObject,
                           IFlexModuleFactory, ISystemManager
{
    include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  The number of milliseconds that must pass without any user activity
     *  before SystemManager starts dispatching 'idle' events.
     */
    private static const IDLE_THRESHOLD:Number = 1000;

    /**
     *  @private
     *  The number of milliseconds between each 'idle' event.
     */
    private static const IDLE_INTERVAL:Number = 100;

    //--------------------------------------------------------------------------
    //
    //  Class variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  An array of SystemManager instances loaded as child app domains
     */
	COMPILE::LATER
    mx_internal static var allSystemManagers:Dictionary = new Dictionary(true);

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  <p>This is the starting point for all Flex applications.
     *  This class is set to be the root class of a Flex SWF file.
         *  Flash Player instantiates an instance of this class,
     *  causing this constructor to be called.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function SystemManager()
    {
        CONFIG::performanceInstrumentation
        {
            var perfUtil:mx.utils.PerfUtil = mx.utils.PerfUtil.getInstance();
            perfUtil.startSampling("Application Startup", true /*absoluteTime*/);
            perfUtil.markTime("SystemManager c-tor");
        }

        super();

		COMPILE::SWF
		{
			// Loaded SWFs don't get a stage right away
			// and shouldn't override the main SWF's setting anyway.
			if (stage)
			{
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
				stage.quality = StageQuality.HIGH;
			}				
		}

		COMPILE::SWF
		{
        // If we don't have a stage then we are not top-level,
        // unless there are no other top-level managers, in which
        // case we got loaded by a non-Flex shell or are sandboxed.
        if (SystemManagerGlobals.topLevelSystemManagers.length > 0 && !stage)
            topLevel = false;

        if (!stage)
            isStageRoot = false;
		}
		
        if (topLevel)
            SystemManagerGlobals.topLevelSystemManagers.push(this);

		COMPILE::SWF
		{
			// Make sure to stop the playhead on the current frame.
			stop();				
		}

        // Listen for the last frame (param is 0-indexed) to be executed.
        //addFrameScript(totalFrames - 1, frameEndHandler);

		COMPILE::SWF
		{
			if (root && root.loaderInfo)
				root.loaderInfo.addEventListener(Event.INIT, initHandler);				
		}
		COMPILE::JS
		{
			initHandler(null);
			super.addEventListener(MouseEvent.MOUSE_MOVE, js_mouseMoveHandler);
		}
            
    }

	//----------------------------------
	//  bindingEventDispatcher
	//----------------------------------
	
	/**
	 *  @private
	 *  Storage for the binding event dispatcher.
	 */
	private var _bindingEventDispatcher:EventDispatcher;
	
	[Inspectable(environment="none")]
	
	/**
	 *  Events get dispatched here first
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get bindingEventDispatcher():IEventDispatcher
	{
		if (_bindingEventDispatcher == null)
			_bindingEventDispatcher = new EventDispatcher();
		return _bindingEventDispatcher;
	}
	
	//----------------------------------
	//  effectEventDispatcher
	//----------------------------------
	
	/**
	 *  @private
	 *  Storage for the effect event dispatcher.
	 */
	private var _effectEventDispatcher:EventDispatcher;
	
	[Inspectable(environment="none")]
	
	/**
	 *  Events get dispatched here last
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get effectEventDispatcher():IEventDispatcher
	{
		if (_effectEventDispatcher == null)
			_effectEventDispatcher = new EventDispatcher();
		return _effectEventDispatcher;
	}
    
    
    /**
     *  @private
     */
	COMPILE::SWF
    private function deferredNextFrame():void
    {
        if (currentFrame + 1 > totalFrames)
            return;

        if (currentFrame + 1 <= framesLoaded)
        {
            CONFIG::performanceInstrumentation
            {
                var perfUtil:mx.utils.PerfUtil = mx.utils.PerfUtil.getInstance();
                perfUtil.markTime("SystemManager.nextFrame().start");
            }

            nextFrame();

            CONFIG::performanceInstrumentation
            {
                perfUtil.markTime("SystemManager.nextFrame().end");
            }
        }
        else
        {
            // Next frame isn't baked yet, so we'll check back...
            nextFrameTimer = new Timer(100);
            nextFrameTimer.addEventListener(TimerEvent.TIMER,
                                            nextFrameTimerHandler);
            nextFrameTimer.start();
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Whether we are in the top-level list or not;
     *  top-level means we are the highest level SystemManager
     *  for this stage.
     */
    mx_internal var topLevel:Boolean = true;

    /**
     *  @private
     * 
     * true if redipatching a resize event.
     */
    private var isDispatchingResizeEvent:Boolean;
    
    /**
     *  @private
     *  Whether we are the stage root or not.
     *  We are only the stage root if we were the root
     *  of the first SWF that got loaded by the player.
     *  Otherwise we could be top level but not stage root
     *  if we are loaded by some other non-Flex shell
     *  or are sandboxed.
     */
    mx_internal var isStageRoot:Boolean = true;

    /**
     *  @private
     *  Whether we are the first SWF loaded into a bootstrap
     *  and therefore, the topLevelRoot
     */
    mx_internal var isBootstrapRoot:Boolean = false;

    /**
     *  @private
     *  If we're not top level, then we delegate many things
     *  to the top level SystemManager.
     */
    private var _topLevelSystemManager:ISystemManager;

    /**
     *  @private
     *  The childAdded/removed code
     */
    mx_internal var childManager:ISystemManagerChildManager;

    /**
     * cached value of the stage.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	COMPILE::SWF
    private var _stage:Stage;
    
    /**
     *  Depth of this object in the containment hierarchy.
     *  This number is used by the measurement and layout code.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    mx_internal var nestLevel:int = 0;

    /**
     *  @private
     *  A reference to the preloader.
     */
    mx_internal var preloader:Preloader;

    /**
     *  @private
     *  The mouseCatcher is the 0th child of the SystemManager,
     *  behind the application, which is child 1.
     *  It is the same size as the stage and is filled with
     *  transparent pixels; i.e., they've been drawn, but with alpha 0.
     *
     *  Its purpose is to make every part of the stage
     *  able to detect the mouse.
     *  For example, a Button puts a mouseUp handler on the SystemManager
     *  in order to capture mouseUp events that occur outside the Button.
     *  But if the children of the SystemManager don't have "drawn-on"
     *  pixels everywhere, the player won't dispatch the mouseUp.
     *  We can't simply fill the SystemManager itself with
     *  transparent pixels, because the player's pixel detection
     *  logic doesn't look at pixels drawn into the root DisplayObject.
     *
     *  Here is an example of what would happen without the mouseCatcher:
     *  Run a fixed-size Application (e.g. width="600" height="600")
     *  in the standalone player. Make the player window larger
     *  to reveal part of the stage. Press a Button, drag off it
     *  into the stage area, and release the mouse button.
     *  Without the mouseCatcher, the Button wouldn't return to its "up" state.
     */
    private var mouseCatcher:Sprite;

    /**
     *  @private
     *  The top level window.
     */
    mx_internal var topLevelWindow:IUIComponent;

    /**
     *  @private
     *  Number of frames since the last mouse or key activity.
     */
    mx_internal var idleCounter:int = 0;

    /**
     *  @private
     *  The Timer used to determine when to dispatch idle events.
     */
    private var idleTimer:Timer;

    /**
     *  @private
     *  A timer used when it is necessary to wait before incrementing the frame
     */
    private var nextFrameTimer:Timer = null;

    /**
     *  @private
     *  Track which frame was last processed
     */
    private var lastFrame:int;

    /**
     *  @private
     *  A boolean as to whether we've seen COMPLETE event from preloader
     */
    private var readyForKickOff:Boolean;

    /**
     *  @private
     * 
     *  This variable exists only to provide a reference to this 
     *  app's resource bundles. This application is opting
     *  into referencing its own resource bundles so the
     *  ResourceManager does not need to do it. This 
     *  arrangement keeps the ResourceManager from pinning
     *  the application in memory. 
     * 
     *  If this is the main app, then this variable will be null.
     *  If this is a sub-app then ResourceManagerImpl set 
     *  this variable to the apps resource bundles. This variable 
     *  is public so it is visible to ResourceManagerImpl but starts
     *  with an underscore to hint that it is an implementation detail 
     *  and should not be relied on. 
     */
    public var _resourceBundles:Array;

    /**
     *  @private
     *  Array of RSLData objects that represent the list of RSLs this
     *  module factory is loading. Each element of the Array is an 
     *  Array of RSLData.
     */ 
	COMPILE::LATER
    private var rslDataList:Array
    
    //--------------------------------------------------------------------------
    //
    //  Overridden properties: DisplayObject
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  height
    //----------------------------------

    /**
     *  @private
     */
    private var _height:Number;

    /**
     *  The height of this object.  For the SystemManager
     *  this should always be the width of the stage unless the application was loaded
     *  into another application.  If the application was not loaded
     *  into another application, setting this value has no effect.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function get height():Number
    {
        return _height;
    }

    //----------------------------------
    //  stage
    //----------------------------------

    /**
     *  @private
     *  get the main stage if we're loaded into another swf in the same sandbox
     */
	COMPILE::SWF
    override public function get stage():Stage
    {
        if (_stage)
            return _stage;
            
        var s:Stage = super.stage;
        if (s)
        {
            _stage = s;
            return s;
        }

		COMPILE::LATER
		{
        if (!topLevel && _topLevelSystemManager)
        {
            _stage = _topLevelSystemManager.stage; 
            return _stage;
        }
		}

        // Case for version skew, we are a top level system manager, but
        // a child of the top level root system manager and we have access 
        // to the stage. 
        if (!isStageRoot && topLevel)
        {
            var root:DisplayObject = getTopLevelRoot();
            if (root)
            {
                _stage = root.stage;
                return _stage;
            }
        }

        return null;
    }

    //----------------------------------
    //  width
    //----------------------------------

    /**
     *  @private
     */
    private var _width:Number;

    /**
     *  The width of this object.  For the SystemManager
     *  this should always be the width of the stage unless the application was loaded
     *  into another application.  If the application was not loaded
     *  into another application, setting this value will have no effect.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function get width():Number
    {
        return _width;
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden properties: DisplayObjectContainer
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  numChildren
    //----------------------------------

    /**
     *  The number of non-floating windows.  This is the main application window
     *  plus any other windows added to the SystemManager that are not popups,
     *  tooltips or cursors.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function get numChildren():int
    {
        return noTopMostIndex - applicationIndex;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  allowDomainsInNewRSLs
    //----------------------------------
    
    /**
     *  @private
     */ 
	COMPILE::LATER
    private var _allowDomainsInNewRSLs:Boolean = true;
    
    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Flex 4.5
     */   
	COMPILE::LATER
    public function get allowDomainsInNewRSLs():Boolean
    {
        return _allowDomainsInNewRSLs;
    }
    
    /**
     *  @private
     */ 
	COMPILE::LATER
    public function set allowDomainsInNewRSLs(value:Boolean):void
    {
        _allowDomainsInNewRSLs = value;
    }
    
    //----------------------------------
    //  allowInsecureDomainsInNewRSLs
    //----------------------------------
    
    /**
     *  @private
     */ 
	COMPILE::LATER
    private var _allowInsecureDomainsInNewRSLs:Boolean = true;
    
    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Flex 4.5
     */   
	COMPILE::LATER
    public function get allowInsecureDomainsInNewRSLs():Boolean
    {
        return _allowInsecureDomainsInNewRSLs;
    }
    
    /**
     *  @private
     */ 
	COMPILE::LATER
    public function set allowInsecureDomainsInNewRSLs(value:Boolean):void
    {
        _allowInsecureDomainsInNewRSLs = value;
    }
    
    //----------------------------------
    //  application
    //----------------------------------

    /**
     *  The application parented by this SystemManager.
     *  SystemManagers create an instance of an Application
     *  even if they are loaded into another Application.
     *  Thus, this may not match mx.core.Application.application
     *  if the SWF has been loaded into another application.
     *  <p>Note that this property is not typed as mx.core.Application
     *  because of load-time performance considerations
     *  but can be coerced into an mx.core.Application.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get application():IUIComponent
    {
        return IUIComponent(_document);
    }

    //----------------------------------
    //  applicationIndex
    //----------------------------------

    /**
     *  @private
     *  Storage for the applicationIndex property.
     */
    private var _applicationIndex:int = 1;

    /**
     *  @private
     *  The index of the main mx.core.Application window, which is
     *  effectively its z-order.
     */
    mx_internal function get applicationIndex():int
    {
        return _applicationIndex;
    }

    /**
     *  @private
     */
    mx_internal function set applicationIndex(value:int):void
    {
        _applicationIndex = value;
    }

    
    //----------------------------------
    //  cursorChildren
    //----------------------------------

    /**
     *  @private
     *  Storage for the cursorChildren property.
     */
    private var _cursorChildren:SystemChildrenList;

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get cursorChildren():IChildList
    {
        if (!topLevel)
            return _topLevelSystemManager.cursorChildren;

        if (!_cursorChildren)
        {
            _cursorChildren = new SystemChildrenList(this,
                new QName(mx_internal, "toolTipIndex"),
                new QName(mx_internal, "cursorIndex"));
        }

        return _cursorChildren;
    }

    //----------------------------------
    //  cursorIndex
    //----------------------------------

    /**
     *  @private
     *  Storage for the toolTipIndex property.
     */
    private var _cursorIndex:int = 0;

    /**
     *  @private
     *  The index of the highest child that is a cursor.
     */
    mx_internal function get cursorIndex():int
    {
        return _cursorIndex;
    }

    /**
     *  @private
     */
    mx_internal function set cursorIndex(value:int):void
    {
        var delta:int = value - _cursorIndex;
        _cursorIndex = value;
    }

    //----------------------------------
    //  densityScale
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the densityScale property 
     */
    private var _densityScale:Number = NaN;
    
    /**
     *  The density scale factor of the application.
     * 
     *  When density scaling is enabled, Flex applies a scale factor based on
     *  the application author density and the density of the current device
     *  that Flex is running on. 
     * 
     *  Returns 1.0 when there is no scaling.
     * 
     *  @see spark.components.Application#applicationDPI
     *  @see mx.core.DensityUtil
     * 
     *  @private
     */
    mx_internal function get densityScale():Number
    {
        if (isNaN(_densityScale))
        {    
            var applicationDPI:Number = info()["applicationDPI"];
            var runtimeDPI:Number = DensityUtil.getRuntimeDPI();
            _densityScale = DensityUtil.getDPIScale(applicationDPI, runtimeDPI);
            if (isNaN(_densityScale))
                _densityScale = 1;
        }

        return _densityScale;
    }
    
    //----------------------------------
    //  document
    //----------------------------------

    /**
     *  @private
     *  Storage for the document property.
     */
    private var _document:Object;

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get document():Object
    {
        return _document;
    }

    /**
     *  @private
     */
    public function set document(value:Object):void
    {
        _document = value;
    }

    //----------------------------------
    //  embeddedFontList
    //----------------------------------

    /**
     *  @private
     *  Storage for the fontList property.
     */
    private var _fontList:Object = null;

    /**
     *  A table of embedded fonts in this application.  The 
     *  object is a table indexed by the font name.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get embeddedFontList():Object
    {
        if (_fontList == null)
        {
            _fontList = {};

            var o:Object = info()["fonts"];

            var p:String;

            for (p in o)
            {
                _fontList[p] = o[p];
            }

            // Top level systemManager may not be defined if SWF is loaded
            // as a background image in download progress bar.
            if (!topLevel && _topLevelSystemManager)                   
            {
                var fl:Object = _topLevelSystemManager.embeddedFontList;
                for (p in fl)
                {
                    _fontList[p] = fl[p];
                }
            }
        }

        return _fontList;
    }

    //----------------------------------
    //  explicitHeight
    //----------------------------------

    /**
     *  @private
     */
    private var _explicitHeight:Number;

    /**
     *  The explicit width of this object.  For the SystemManager
     *  this should always be NaN unless the application was loaded
     *  into another application.  If the application was not loaded
     *  into another application, setting this value has no effect.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	COMPILE::SWF
    public function get explicitHeight():Number
    {
        return _explicitHeight;
    }

    /**
     *  @private
     */
	COMPILE::SWF
    public function set explicitHeight(value:Number):void
    {
        _explicitHeight = value;
    }

    //----------------------------------
    //  explicitWidth
    //----------------------------------

    /**
     *  @private
     */
    private var _explicitWidth:Number;

    /**
     *  The explicit width of this object.  For the SystemManager
     *  this should always be NaN unless the application was loaded
     *  into another application.  If the application was not loaded
     *  into another application, setting this value has no effect.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	COMPILE::SWF
    public function get explicitWidth():Number
    {
        return _explicitWidth;
    }

    /**
     *  @private
     */
	COMPILE::SWF
    public function set explicitWidth(value:Number):void
    {
        _explicitWidth = value;
    }

    //----------------------------------
    //  focusPane
    //----------------------------------

    /**
     *  @private
     */
    private var _focusPane:Sprite;

    /**
     *  @copy mx.core.UIComponent#focusPane
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get focusPane():Sprite
    {
        return _focusPane;
    }

    /**
     *  @private
     */
    public function set focusPane(value:Sprite):void
    {
        if (value)
        {
            addChild(value);

            value.x = 0;
            value.y = 0;
			COMPILE::SWF
			{
            value.scrollRect = null;
			}

            _focusPane = value;
        }
        else
        {
            removeChild(_focusPane);

            _focusPane = null;
        }
    }

    //----------------------------------
    //  isProxy
    //----------------------------------

    /**
     *  True if SystemManager is a proxy and not a root class
     */
    public function get isProxy():Boolean
    {
        return false;
    }

    //----------------------------------
    //  measuredHeight
    //----------------------------------

    /**
     *  The measuredHeight is the explicit or measuredHeight of 
     *  the main mx.core.Application window
     *  or the starting height of the SWF if the main window 
     *  has not yet been created or does not exist.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get measuredHeight():Number
    {
		COMPILE::SWF
		{
        return topLevelWindow ?
               topLevelWindow.getExplicitOrMeasuredHeight() :
               loaderInfo.height;
		}
		COMPILE::JS
		{
			return topLevelWindow ?
				topLevelWindow.getExplicitOrMeasuredHeight() :
				height;
		}
    }

    //----------------------------------
    //  measuredWidth
    //----------------------------------

    /**
     *  The measuredWidth is the explicit or measuredWidth of 
     *  the main mx.core.Application window,
     *  or the starting width of the SWF if the main window 
     *  has not yet been created or does not exist.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get measuredWidth():Number
    {
		COMPILE::SWF
		{
			return topLevelWindow ?
				topLevelWindow.getExplicitOrMeasuredWidth() :
				loaderInfo.width;				
		}
		COMPILE::JS
		{
			return topLevelWindow ?
				topLevelWindow.getExplicitOrMeasuredWidth() :
				width;				
		}
    }

    //----------------------------------
    //  noTopMostIndex
    //----------------------------------

    /**
     *  @private
     *  Storage for the noTopMostIndex property.
     */
    private var _noTopMostIndex:int = 0;

    /**
     *  @private
     *  The index of the highest child that isn't a topmost/popup window
     */
    mx_internal function get noTopMostIndex():int
    {
        return _noTopMostIndex;
    }

    /**
     *  @private
     */
    mx_internal function set noTopMostIndex(value:int):void
    {
        var delta:int = value - _noTopMostIndex;
        _noTopMostIndex = value;
        topMostIndex += delta;
    }

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
    mx_internal final function get $numChildren():int
    {
        return super.numChildren;
    }

    //----------------------------------
    //  numModalWindows
    //----------------------------------

    /**
     *  @private
     *  Storage for the numModalWindows property.
     */
    private var _numModalWindows:int = 0;

    /**
     *  The number of modal windows.  Modal windows don't allow
     *  clicking in another windows which would normally
     *  activate the FocusManager in that window.  The PopUpManager
     *  modifies this count as it creates and destroys modal windows.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get numModalWindows():int
    {
        return _numModalWindows;
    }

    /**
     *  @private
     */
    public function set numModalWindows(value:int):void
    {
        _numModalWindows = value;
    }

    //----------------------------------
    //  preloadedRSLs
    //----------------------------------
    
    /**
     *  @inheritDoc 
     *  
     */
	COMPILE::LATER
    public function  get preloadedRSLs():Dictionary
    {
        // Overridden by compiler generate code.
        return null;                
    }
    
    /**
     *  @inheritDoc 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 4.5
     */ 
	COMPILE::LATER
    public function addPreloadedRSL(loaderInfo:LoaderInfo, rsl:Vector.<RSLData>):void
    {
        preloadedRSLs[loaderInfo] = rsl;
        if (hasEventListener(RSLEvent.RSL_ADD_PRELOADED))
        {
            var rslEvent:RSLEvent = new RSLEvent(RSLEvent.RSL_ADD_PRELOADED);
            rslEvent.loaderInfo = loaderInfo;
            dispatchEvent(rslEvent);
        }
        
    }
    
    //----------------------------------
    //  preloaderBackgroundAlpha
    //----------------------------------

    /**
     *  The background alpha used by the child of the preloader.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get preloaderBackgroundAlpha():Number
    {
        return info()["backgroundAlpha"];
    }

    //----------------------------------
    //  preloaderBackgroundColor
    //----------------------------------

    /**
     *  The background color used by the child of the preloader.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get preloaderBackgroundColor():uint
    {
        var value:* = info()["backgroundColor"];
        if (value == undefined)
            return 0xFFFFFFFF;
        else
            return value;
    }

    //----------------------------------
    //  preloaderBackgroundImage
    //----------------------------------

    /**
     *  The background color used by the child of the preloader.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get preloaderBackgroundImage():Object
    {
        return info()["backgroundImage"];
    }

    //----------------------------------
    //  preloaderBackgroundSize
    //----------------------------------

    /**
     *  The background size used by the child of the preloader.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get preloaderBackgroundSize():String
    {
        return info()["backgroundSize"];
    }

    //----------------------------------
    //  popUpChildren
    //----------------------------------

    /**
     *  @private
     *  Storage for the popUpChildren property.
     */
    private var _popUpChildren:SystemChildrenList;

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get popUpChildren():IChildList
    {
        if (!topLevel)
            return _topLevelSystemManager.popUpChildren;

        if (!_popUpChildren)
        {
            _popUpChildren = new SystemChildrenList(this,
                new QName(mx_internal, "noTopMostIndex"),
                new QName(mx_internal, "topMostIndex"));
        }

        return _popUpChildren;
    }

    //----------------------------------
    //  rawChildren
    //----------------------------------

    /**
     *  @private
     *  Storage for the rawChildren property.
     */
    private var _rawChildren:SystemRawChildrenList;

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get rawChildren():IChildList
    {
        //if (!topLevel)
        //  return _topLevelSystemManager.rawChildren;

        if (!_rawChildren)
            _rawChildren = new SystemRawChildrenList(this);

        return _rawChildren;
    }

    //--------------------------------------------------------------------------
    //  screen
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Storage for the screen property.
     */
    mx_internal var _screen:Rectangle;

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get screen():Rectangle
    {
		COMPILE::SWF
		{
        if (!_screen)
            Stage_resizeHandler();

        if (!isStageRoot)
        {
            Stage_resizeHandler();
        }
		}
        return _screen;
    }

    //----------------------------------
    //  toolTipChildren
    //----------------------------------

    /**
     *  @private
     *  Storage for the toolTipChildren property.
     */
    private var _toolTipChildren:SystemChildrenList;

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get toolTipChildren():IChildList
    {
        if (!topLevel)
            return _topLevelSystemManager.toolTipChildren;

        if (!_toolTipChildren)
        {
            _toolTipChildren = new SystemChildrenList(this,
                new QName(mx_internal, "topMostIndex"),
                new QName(mx_internal, "toolTipIndex"));
        }

        return _toolTipChildren;
    }

    //----------------------------------
    //  toolTipIndex
    //----------------------------------

    /**
     *  @private
     *  Storage for the toolTipIndex property.
     */
    private var _toolTipIndex:int = 0;

    /**
     *  @private
     *  The index of the highest child that is a tooltip
     */
    mx_internal function get toolTipIndex():int
    {
        return _toolTipIndex;
    }

    /**
     *  @private
     */
    mx_internal function set toolTipIndex(value:int):void
    {
        var delta:int = value - _toolTipIndex;
        _toolTipIndex = value;
        cursorIndex += delta;
    }

    //----------------------------------
    //  topLevelSystemManager
    //----------------------------------

    /**
     *  Returns the SystemManager responsible for the application window.  This will be
     *  the same SystemManager unless this application has been loaded into another
     *  application.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get topLevelSystemManager():ISystemManager
    {
        if (topLevel)
            return this;

        return _topLevelSystemManager;
    }

    //----------------------------------
    //  topMostIndex
    //----------------------------------

    /**
     *  @private
     *  Storage for the topMostIndex property.
     */
    private var _topMostIndex:int = 0;

    /**
     *  @private
     *  The index of the highest child that is a topmost/popup window
     */
    mx_internal function get topMostIndex():int
    {
        return _topMostIndex;
    }

    mx_internal function set topMostIndex(value:int):void
    {
        var delta:int = value - _topMostIndex;
        _topMostIndex = value;
        toolTipIndex += delta;
    }


    //--------------------------------------------------------------------------
    //
    //  Overridden methods: EventDispatcher
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  allows marshal implementation to add events
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    mx_internal final function $addEventListener(type:String, listener:Function,
                                              useCapture:Boolean = false,
                                              priority:int = 0,
                                              useWeakReference:Boolean = false):void
    {   
        super.addEventListener(type, listener, useCapture, priority, useWeakReference);
    }

    /**
     * @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */    
	COMPILE::LATER
    public function get childAllowsParent():Boolean
    {
        try
        {
            return loaderInfo.childAllowsParent;
        }
        catch (error:Error)
        {
            //Error #2099: The loading object is not sufficiently loaded to provide this information.
        }
        
        return false;   // assume the worst
    }

    /**
     *  @copy mx.core.ISWFBridgeProvider#parentAllowsChild
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */    
	COMPILE::LATER
    public function get parentAllowsChild():Boolean
    {
        try
        {
            return loaderInfo.parentAllowsChild;
        }
        catch (error:Error)
        {
            //Error #2099: The loading object is not sufficiently loaded to provide this information.
        }
        
        return false;   // assume the worst
    }

    /**
     * @private
     *  Only create idle events if someone is listening.
     */
	COMPILE::SWF
    override public function addEventListener(type:String, listener:Function,
                                              useCapture:Boolean = false,
                                              priority:int = 0,
                                              useWeakReference:Boolean = false):void
    {
        if (type == MouseEvent.MOUSE_MOVE || type == MouseEvent.MOUSE_UP || type == MouseEvent.MOUSE_DOWN 
                || type == Event.ACTIVATE || type == Event.DEACTIVATE)
        {
            // also listen to stage if allowed
            try
            {
                if (stage)
                {
                    // Use weak listener because we don't always know when we
                    // no longer need this listener
                    stage.addEventListener(type, stageEventHandler, false, 0, true);
					stage.addEventListener(type, flashListener, true, 9999);
                }
            }
            catch (error:SecurityError)
            {
            }
        }

        if (hasEventListener("addEventListener"))
        {
            var request:DynamicEvent = new DynamicEvent("addEventListener", false, true);
            request.eventType = type;
            request.listener = listener;
            request.useCapture = useCapture;
            request.priority = priority;
            request.useWeakReference = useWeakReference;
            if (!dispatchEvent(request))
                return;
        }

		COMPILE::LATER
		{
        if (type == SandboxMouseEvent.MOUSE_UP_SOMEWHERE)
        {
            // If someone wants this event, also listen for mouseLeave.
            // Use weak listener because we don't always know when we
            // no longer need this listener
            try
            {
                if (stage)
                {
                    stage.addEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler, false, 0, true);
					stage.addEventListener(type, flashListener, false, 9999);
                }
                else
                {
                    super.addEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler, false, 0, true);
					super.addEventListener(type, flashListener, true, 9999);
                }
            }
            catch (error:SecurityError)
            {
                super.addEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler, false, 0, true);
            }
        }
		}
		
        // These two events will dispatched to applications in sandboxes.
        if (type == FlexEvent.RENDER || type == FlexEvent.ENTER_FRAME)
        {
            if (type == FlexEvent.RENDER)
                type = Event.RENDER;
            else
                type = Event.ENTER_FRAME;
                
            try
            {
                if (stage)
				{
                    stage.addEventListener(type, listener, useCapture, priority, useWeakReference);
					stage.addEventListener(type, flashListener, false, 9999);
				}
                else
				{
                    super.addEventListener(type, listener, useCapture, priority, useWeakReference);
					super.addEventListener(type, flashListener, true, 9999);
				}
            }
            catch (error:SecurityError)
            {
                super.addEventListener(type, listener, useCapture, priority, useWeakReference);
            }
        
            if (stage && type == Event.RENDER)
                stage.invalidate();

            return;
        }

		COMPILE::LATER
		{
        // When the first listener registers for 'idle' events,
        // create a Timer that will fire every IDLE_INTERVAL.
        if (type == FlexEvent.IDLE && !idleTimer)
        {
            idleTimer = new Timer(IDLE_INTERVAL);
            idleTimer.addEventListener(TimerEvent.TIMER,
                                       idleTimer_timerHandler);
            idleTimer.start();

            // Make sure we get all activity
            // in case someone calls stopPropagation().
            addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, true);
            addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, true);
        }
		}
		

        super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		super.addEventListener(type, flashListener, true, 9999);
    }

	COMPILE::SWF
	private function flashListener(e:flash.events.Event):void
	{
		trace(e.type, e.target);
	}
	
    /**
     *  @private
     */
    mx_internal final function $removeEventListener(type:String, listener:Function,
                                                 useCapture:Boolean = false):void
    {
        super.removeEventListener(type, listener, useCapture);
    }
    
    /**
     *  @private
     */
	COMPILE::SWF
    override public function removeEventListener(type:String, listener:Function,
                                                 useCapture:Boolean = false):void
    {
        if (hasEventListener("removeEventListener"))
        {
            var request:DynamicEvent = new DynamicEvent("removeEventListener", false, true);
            request.eventType = type;
            request.listener = listener;
            request.useCapture = useCapture;
            if (!dispatchEvent(request))
                return;
        }

        // These two events will dispatched to applications in sandboxes.
        if (type == FlexEvent.RENDER || type == FlexEvent.ENTER_FRAME)
        {
            if (type == FlexEvent.RENDER)
                type = Event.RENDER;
            else
                type = Event.ENTER_FRAME;
                
            try
            {
                if (stage)
                    stage.removeEventListener(type, listener, useCapture);
            }
            catch (error:SecurityError)
            {
            }
            // Remove both listeners in case the system manager was added
            // or removed from the stage after the listener was added.
            super.removeEventListener(type, listener, useCapture);
        
            return;
        }

        // When the last listener unregisters for 'idle' events,
        // stop and release the Timer.
        if (type == FlexEvent.IDLE)
        {
            super.removeEventListener(type, listener, useCapture);

            if (!hasEventListener(FlexEvent.IDLE) && idleTimer)
            {
                idleTimer.stop();
                idleTimer = null;

                removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
                removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
            }
        }
        else
        {
            super.removeEventListener(type, listener, useCapture);
        }

        if (type == MouseEvent.MOUSE_MOVE || type == MouseEvent.MOUSE_UP || type == MouseEvent.MOUSE_DOWN 
                || type == Event.ACTIVATE || type == Event.DEACTIVATE)
        {
            if (!hasEventListener(type))
            {
                // also listen to stage if allowed
                try
                {
                    if (stage)
                    {
                        stage.removeEventListener(type, stageEventHandler, false);
                    }
                }
                catch (error:SecurityError)
                {
                }
            }
        }

		COMPILE::LATER
		{
        if (type == SandboxMouseEvent.MOUSE_UP_SOMEWHERE)
        {
            if (!hasEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE))
            {
                // nobody wants this event any more for now
                try
                {
                    if (stage)
                    {
                        stage.removeEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler);
                    }
                }
                catch (error:SecurityError)
                {
                }
                // Remove both listeners in case the system manager was added
                // or removed from the stage after the listener was added.
                super.removeEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler);
            }
        }
		}
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: DisplayObjectContainer
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override public function addChild(child:DisplayObject):DisplayObject
    {
        var addIndex:int = numChildren;
        if (child.parent == this)
            addIndex--;

        return addChildAt(child, addIndex);
    }

    /**
     *  @private
     */
    override public function addChildAt(child:DisplayObject,
                                        index:int):DisplayObject
    {
        // Adjust the partition indexes before the 
        // "added" event is dispatched.
        noTopMostIndex = noTopMostIndex + 1;

        var oldParent:DisplayObjectContainer = child.parent;
        if (oldParent)
            oldParent.removeChild(child);
        
        return rawChildren_addChildAt(child, applicationIndex + index);
    }

    /**
     *  @private
     * 
     * Used by SystemManagerProxy to add a mouse catcher as a child.
     */ 
    mx_internal final function $addChildAt(child:DisplayObject,
                                        index:int):DisplayObject
    {
        return super.addChildAt(child, index);
    }

    /**
     *  @private
     * 
     *  Companion to $addChildAt.
     */
    mx_internal final function $removeChildAt(index:int):DisplayObject
    {
        return super.removeChildAt(index);
    }


    /**
     *  @private
     */
    override public function removeChild(child:DisplayObject):DisplayObject
    {
        // Adjust the partition indexes
        // before the "removed" event is dispatched.
        noTopMostIndex = noTopMostIndex - 1;

        return rawChildren_removeChild(child);
    }

    /**
     *  @private
     */
    override public function removeChildAt(index:int):DisplayObject
    {
        // Adjust the partition indexes
        // before the "removed" event is dispatched.
        noTopMostIndex = noTopMostIndex - 1;

        return rawChildren_removeChildAt(applicationIndex + index);
    }

    /**
     *  @private
     */
    override public function getChildAt(index:int):DisplayObject
    {
        return super.getChildAt(applicationIndex + index)
    }

    /**
     *  @private
     */
    override public function getChildByName(name:String):DisplayObject
    {
        return super.getChildByName(name);
    }

    /**
     *  @private
     */
    override public function getChildIndex(child:DisplayObject):int
    {
        return super.getChildIndex(child) - applicationIndex;
    }

    /**
     *  @private
     */
    override public function setChildIndex(child:DisplayObject, newIndex:int):void
    {
        super.setChildIndex(child, applicationIndex + newIndex)
    }

    /**
     *  @private
     */
	COMPILE::LATER
    override public function getObjectsUnderPoint(point:Point):Array
    {
        var children:Array = [];

        // Get all the children that aren't tooltips and cursors.
        var n:int = topMostIndex;
        for (var i:int = 0; i < n; i++)
        {
            var child:DisplayObject = super.getChildAt(i);
            if (child is DisplayObjectContainer)
            {
                var temp:Array =
                    DisplayObjectContainer(child).getObjectsUnderPoint(point);

                if (temp)
                    children = children.concat(temp);
            }
        }

        return children;
    }

    /**
     *  @private
     */
    override public function contains(child:DisplayObject):Boolean
    {
        if (super.contains(child))
        {
            if (child.parent == this)
            {
                var childIndex:int = super.getChildIndex(child);
                if (childIndex < noTopMostIndex)
                    return true;
            }
            else
            {
                for (var i:int = 0; i < noTopMostIndex; i++)
                {
                    var myChild:DisplayObject = super.getChildAt(i);
                    if (myChild is IRawChildrenContainer)
                    {
                        if (IRawChildrenContainer(myChild).rawChildren.contains(child))
                            return true;
                    }
                    if (myChild is DisplayObjectContainer)
                    {
                        if (DisplayObjectContainer(myChild).contains(child))
                            return true;
                    }
                }
            }
        }
        return false;
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: IFlexModuleFactory
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  This method is overridden in the autogenerated subclass.
     *  It is part of TLF's ISWFContext interface.
     *  Although this class does not declare that it implements this interface,
     *  the autogenerated subclass does.
     */
    public function callInContext(fn:Function, thisArg:Object,
                                  argArray:Array, returns:Boolean = true):*
    {
        return undefined;
    }

    /**
     *  A factory method that requests an instance of a
     *  definition known to the module.
     * 
     *  You can provide an optional set of parameters to let building
     *  factories change what they create based on the
     *  input. Passing null indicates that the default definition
     *  is created, if possible. 
     *
     *  This method is overridden in the autogenerated subclass.
     *
     *  @param params An optional list of arguments. You can pass
     *  any number of arguments, which are then stored in an Array
     *  called <code>parameters</code>. 
     *
     *  @return An instance of the module, or <code>null</code>.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function create(... params):Object
    {
        var mainClassName:String = info()["mainClassName"];

		COMPILE::SWF
		{
			if (mainClassName == null)
			{
				var url:String = loaderInfo.loaderURL;
				var dot:int = url.lastIndexOf(".");
				var slash:int = url.lastIndexOf("/");
				mainClassName = url.substring(slash + 1, dot);
			}				
		}

        var mainClass:Class = Class(getDefinitionByName(mainClassName));
        
        return mainClass ? new mainClass() : null;
    }

    /**
     *  @private
     */
    public function info():Object
    {
        return {};
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Creates an instance of the preloader, adds it as a child, and runs it.
     *  This is needed by Flash Builder. Do not modify this function.
     */
    mx_internal function initialize():void
    {
        var runtimeDPIProviderClass:Class = info()["runtimeDPIProvider"] as Class;
        if (runtimeDPIProviderClass)
            Singleton.registerClass("mx.core::RuntimeDPIProvider", runtimeDPIProviderClass);
        
		COMPILE::SWF
		{
        if (isStageRoot)
        {
            // TODO: Finalize scaling behavior
            Stage_resizeHandler();
            // _width = stage.stageWidth;
            // _height = stage.stageHeight;
        }
        else
        {
            _width = loaderInfo.width;
            _height = loaderInfo.height;
        }		
		}

        // Create an instance of the preloader and add it to the stage
        preloader = new Preloader();

		COMPILE::SWF
		{
			// Listen for preloader events
			// preloader notifes when it is ok to go to frame2
			preloader.addEventListener(FlexEvent.PRELOADER_DOC_FRAME_READY,
				preloader_preloaderDocFrameReadyHandler);				
		}
        // wait for a complete event.  This gives the preloader
        // a chance to load resource modules before
        // everything really gets kicked off
        preloader.addEventListener(Event.COMPLETE,
                                   preloader_completeHandler);
        // when the app is fully backed remove the preloader and show the app
        preloader.addEventListener(FlexEvent.PRELOADER_DONE,
                                   preloader_preloaderDoneHandler);
		COMPILE::LATER
		{
        preloader.addEventListener(RSLEvent.RSL_COMPLETE, 
                                   preloader_rslCompleteHandler);
		}
		
        // Add the preloader as a child.  Use backing variable because when loaded
        // we redirect public API to parent systemmanager
        if (!_popUpChildren)
        {
				_popUpChildren = new SystemChildrenList(
					this, new QName(mx_internal, "noTopMostIndex"), new QName(mx_internal, "topMostIndex"));					
        }
        _popUpChildren.addChild(preloader);

        var rsls:Array = info()["rsls"];
        var cdRsls:Array = info()["cdRsls"];
        var usePreloader:Boolean = true;
        if (info()["usePreloader"] != undefined)
            usePreloader = info()["usePreloader"];

        var preloaderDisplayClass:Class = info()["preloader"] as Class;

		COMPILE::LATER
		{
        // Put cross-domain RSL information in the RSL list.
        var rslItemList:Array = [];
        var n:int;
        var i:int;
        if (cdRsls && cdRsls.length > 0)
        {
            if (isTopLevel())
                rslDataList = cdRsls;
            else
                rslDataList = LoaderUtil.processRequiredRSLs(this, cdRsls);
            
            var normalizedURL:String = LoaderUtil.normalizeURL(this.loaderInfo);
            var crossDomainRSLItem:Class = Class(getDefinitionByName("mx.core::CrossDomainRSLItem"));
            n = rslDataList.length;
            for (i = 0; i < n; i++)
            {
                var rslWithFailovers:Array = rslDataList[i];

                // If crossDomainRSLItem is null, then this is a compiler error. It should not be null.
                var cdNode:Object = new crossDomainRSLItem(rslWithFailovers,
                                                    normalizedURL,
                                                    this);
                rslItemList.push(cdNode);               
            }
        }

        // Append RSL information in the RSL list.
        if (rsls != null && rsls.length > 0)
        {
            if (rslDataList == null)
                rslDataList = [];
            
            if (normalizedURL == null)
                normalizedURL = LoaderUtil.normalizeURL(this.loaderInfo);

            n = rsls.length;
            for (i = 0; i < n; i++)
            {
                var node:RSLItem = new RSLItem(rsls[i].url, 
                                               normalizedURL,
                                               this);
                rslItemList.push(node);
                rslDataList.push([new RSLData(rsls[i].url, null, null, null, 
                                  false, false, "current")]);
            }
        }

        // They can also specify a comma-separated list of URLs
        // for resource modules to be preloaded during frame 1.
        var resourceModuleURLList:String =
            loaderInfo.parameters["resourceModuleURLs"];
        var resourceModuleURLs:Array =
            resourceModuleURLList ? resourceModuleURLList.split(",") : null;

        var domain:ApplicationDomain =
            !topLevel && parent is Loader ?
            Loader(parent).contentLoaderInfo.applicationDomain :
            info()["currentDomain"] as ApplicationDomain;
		
		COMPILE::SWF
		{
        // Initialize the preloader.
        preloader.initialize(
            usePreloader,
            preloaderDisplayClass,
            preloaderBackgroundColor,
            preloaderBackgroundAlpha,
            preloaderBackgroundImage,
            preloaderBackgroundSize,
            isStageRoot ? stage.stageWidth : loaderInfo.width,
            isStageRoot ? stage.stageHeight : loaderInfo.height,
            null,
            null,
            rslItemList,
            resourceModuleURLs,
            domain);
		}
		}
		COMPILE::SWF
		{
			// Initialize the preloader.
			preloader.initialize(
				usePreloader,
				preloaderDisplayClass,
				preloaderBackgroundColor,
				preloaderBackgroundAlpha,
				preloaderBackgroundImage,
				preloaderBackgroundSize,
				isStageRoot ? stage.stageWidth : loaderInfo.width,
				isStageRoot ? stage.stageHeight : loaderInfo.height,
				null,
				null);
		}
		
		COMPILE::JS
		{
		// Initialize the preloader.
		preloader.initialize(
			usePreloader,
			preloaderDisplayClass,
			preloaderBackgroundColor,
			preloaderBackgroundAlpha,
			preloaderBackgroundImage,
			preloaderBackgroundSize,
			width,
			height,
			null,
			null);
		}
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Support for rawChildren access
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    mx_internal function rawChildren_addChild(child:DisplayObject):DisplayObject
    {
        childManager.addingChild(child);

        super.addChild(child);

        childManager.childAdded(child); // calls child.createChildren()

        return child;
    }

    /**
     *  @private
     */
    mx_internal function rawChildren_addChildAt(child:DisplayObject,
                                                index:int):DisplayObject
    {
        // preloader goes through here before childManager is set up
        if (childManager) 
            childManager.addingChild(child);

        super.addChildAt(child, index);

        if (childManager) 
            childManager.childAdded(child); // calls child.createChildren()

        return child;
    }

    /**
     *  @private
     */
    mx_internal function rawChildren_removeChild(child:DisplayObject):DisplayObject
    {
        childManager.removingChild(child);
        super.removeChild(child);
        childManager.childRemoved(child);

        return child;
    }

    /**
     *  @private
     */
    mx_internal function rawChildren_removeChildAt(index:int):DisplayObject
    {
        var child:DisplayObject = super.getChildAt(index);

        childManager.removingChild(child);

        super.removeChildAt(index);

        childManager.childRemoved(child);

        return child;
    }

    /**
     *  @private
     */
    mx_internal function rawChildren_getChildAt(index:int):DisplayObject
    {
        return super.getChildAt(index);
    }

    /**
     *  @private
     */
    mx_internal function rawChildren_getChildByName(name:String):DisplayObject
    {
        return super.getChildByName(name);
    }

    /**
     *  @private
     */
    mx_internal function rawChildren_getChildIndex(child:DisplayObject):int
    {
        return super.getChildIndex(child);
    }

    /**
     *  @private
     */
    mx_internal function rawChildren_setChildIndex(child:DisplayObject, newIndex:int):void
    {
        super.setChildIndex(child, newIndex);
    }

    /**
     *  @private
     */
    mx_internal function rawChildren_getObjectsUnderPoint(pt:Point):Array
    {
        return super.getObjectsUnderPoint(pt);
    }

    /**
     *  @private
     */
    mx_internal function rawChildren_contains(child:DisplayObject):Boolean
    {
        return super.contains(child);
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Security
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Calls Security.allowDomain() for the SWF associated with this SystemManager
     *  plus all the SWFs assocatiated with RSLs preloaded by this SystemManager.
     * 
     */  
    public function allowDomain(... domains):void
    {
        // Overridden by compiler generated code.
    }
    
    /**
     *  Calls Security.allowInsecureDomain() for the SWF associated with this SystemManager
     *  plus all the SWFs assocatiated with RSLs preloaded by this SystemManager.
     * 
     */  
    public function allowInsecureDomain(... domains):void
    {
        // Overridden by compiler generated code.
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Measurement and Layout
    //
    //--------------------------------------------------------------------------

    /**
     *  A convenience method for determining whether to use the
     *  explicit or measured width.
     *
     *  @return A Number that is the <code>explicitWidth</code> if defined,
     *  or the <code>measuredWidth</code> property if not.
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
     *  explicit or measured height.
     *
     *  @return A Number that is the <code>explicitHeight</code> if defined,
     *  or the <code>measuredHeight</code> property if not.
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
     *  Calling the <code>move()</code> method
     *  has no effect as it is directly mapped
     *  to the application window or the loader.
     *
     *  @param x The new x coordinate.
     *
     *  @param y The new y coordinate.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function move(x:Number, y:Number):void
    {
    }

    /**
     *  Calling the <code>setActualSize()</code> method
     *  has no effect if it is directly mapped
     *  to the application window and if it is the top-level window.
     *  Otherwise attempts to resize itself, clipping children if needed.
     *
     *  @param newWidth The new width.
     *
     *  @param newHeight The new height.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function setActualSize(newWidth:Number, newHeight:Number):void
    {
        if (isStageRoot) return;

        // mouseCatcher is a mask if not stage root
        // sometimes it is not in sync so we always
        // sync it up
        if (mouseCatcher)
        {
            mouseCatcher.width = newWidth;
            mouseCatcher.height = newHeight;
        }

        if (_width != newWidth || _height != newHeight)
        {
            _width = newWidth;
            _height = newHeight;

            dispatchEvent(new Event(Event.RESIZE));
        }
    }



    //--------------------------------------------------------------------------
    //
    //  Methods: Other
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
    public function getDefinitionByName(name:String):Object
    {
		COMPILE::SWF
		{
        var domain:ApplicationDomain =
            !topLevel && parent is Loader ?
            Loader(parent).contentLoaderInfo.applicationDomain :
            info()["currentDomain"] as ApplicationDomain;
		var dm:DefinitionManager = new DefinitionManager(domain);
		}
		COMPILE::JS
		{
			var dm:DefinitionManager = new DefinitionManager();			
		}
		
        //trace("SysMgr.getDefinitionByName domain",domain,"currentDomain",info()["currentDomain"]);    
            
        var definition:Object;

        if (dm.hasDefinition(name))
        {
            definition = dm.getDefinition(name);
            //trace("SysMgr.getDefinitionByName got definition",definition,"name",name);
        }

        return definition;
    }

    /**
     *  Returns the root DisplayObject of the SWF that contains the code
     *  for the given object.
     *
     *  @param object Any Object. 
     * 
     *  @return The root DisplayObject
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function getSWFRoot(object:Object):DisplayObject
    {
        var className:String = getQualifiedClassName(object);

		COMPILE::LATER
		{
        for (var p:* in allSystemManagers)
        {
            var sm:ISystemManager = p as ISystemManager;
            var domain:ApplicationDomain = sm.loaderInfo.applicationDomain;
            try
            {
                var cls:Class = Class(domain.getDefinition(className));
                if (object is cls)
                    return sm as DisplayObject;
            }
            catch(e:Error)
            {
            }
        }
        return null;
		}
		return SystemManagerGlobals.topLevelSystemManagers[0] as DisplayObject;
    }
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function isTopLevel():Boolean
    {
        return topLevel;
    }

    /**
     * @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */ 
    public function isTopLevelRoot():Boolean
    {
        return isStageRoot || isBootstrapRoot;
    }
    
    /**
         *  Determines if the given DisplayObject is the 
     *  top-level window.
     *
     *  @param object The DisplayObject to test.
     *
     *  @return <code>true</code> if the given DisplayObject is the 
     *  top-level window.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function isTopLevelWindow(object:DisplayObject):Boolean
    {
        return object is IUIComponent &&
               IUIComponent(object) == topLevelWindow;
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	COMPILE::LATER
    public function isFontFaceEmbedded(textFormat:TextFormat):Boolean
    {
        var fontName:String = textFormat.font;
        var bold:Boolean = textFormat.bold;
        var italic:Boolean = textFormat.italic;

        var fontList:Array = Font.enumerateFonts();
        
        var n:int = fontList.length;
        for (var i:int = 0; i < n; i++)
        {
            var font:Font = Font(fontList[i]);
            if (font.fontName == fontName)
            {
                var style:String = "regular";
                if (bold && italic)
                    style = "boldItalic";
                else if (bold)
                    style = "bold";
                else if (italic)
                    style = "italic";

                if (font.fontStyle == style)
                    return true;
            }
        }

        if (!fontName ||
            !embeddedFontList ||
            !embeddedFontList[fontName])
        {
            return false;
        }

        var info:Object = embeddedFontList[fontName];

        return !((bold && !info.bold) ||
                 (italic && !info.italic) ||
                 (!bold && !italic && !info.regular));
    }

    /**
     *  @private
     *  Makes the mouseCatcher the same size as the stage,
     *  filling it with transparent pixels.
     */
    private function resizeMouseCatcher():void
    {
        if (mouseCatcher)
        {
            try
            {
            var g:Graphics = mouseCatcher.graphics;
            var s:Rectangle = screen;
            g.clear();
            g.beginFill(0x000000, 0);
            g.drawRect(0, 0, s.width, s.height);
            g.endFill();
            }
            catch (e:Error)
            {
				COMPILE::SWF
				{
					if (!(e is SecurityError))
						throw e;
				}
                // trace("resizeMouseCatcher: ignoring security error " + e);
            }
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
    private function initHandler(event:Event):void
    {
        CONFIG::performanceInstrumentation
        {
            var perfUtil:mx.utils.PerfUtil = mx.utils.PerfUtil.getInstance();
            perfUtil.markTime("SystemManager.initHandler().start");
        }
        
        // we can still be the top level root if we can access our
        // parent and get a positive response to the query or
        // or there is not a listener for the new application event
        // that SWFLoader always adds. 
		COMPILE::LATER
		{
	        if (!isStageRoot)
	        {
	            if (root.loaderInfo.parentAllowsChild)
	            {
	                try
	                {
	                    if (!parent.dispatchEvent(new Event("mx.managers.SystemManager.isBootstrapRoot", false, true)) ||
	                        // use string literal to avoid link dependency on SWFBridgeEvent.BRIDGE_NEW_APPLICATION
	                        !root.loaderInfo.sharedEvents.hasEventListener("bridgeNewApplication"))
	                        isBootstrapRoot = true;
	                }
	                catch (e:Error)
	                {
	                }
	            }
	        }

			allSystemManagers[this] = this.loaderInfo.url;
		}
		COMPILE::SWF
		{
        root.loaderInfo.removeEventListener(Event.INIT, initHandler);
		}

        if (!SystemManagerGlobals.info)
            SystemManagerGlobals.info = info();
		COMPILE::SWF
		{
        if (!SystemManagerGlobals.parameters)
            SystemManagerGlobals.parameters = loaderInfo.parameters;
        var docFrame:int = (totalFrames == 1)? 0 : 1;
        addEventListener(Event.ENTER_FRAME, docFrameListener);
		}

        /*
        addFrameScript(docFrame, docFrameHandler);
        for (var f:int = docFrame + 1; f < totalFrames; ++f)
        {
            addFrameScript(f, extraFrameHandler);
        }
        */

        initialize();

        CONFIG::performanceInstrumentation
        {
            perfUtil.markTime("SystemManager.initHandler().end");
        }
    }

	COMPILE::SWF
    private function docFrameListener(event:Event):void
    {
        if (currentFrame == 2)
        {
            removeEventListener(Event.ENTER_FRAME, docFrameListener);
            if (totalFrames > 2)
                addEventListener(Event.ENTER_FRAME, extraFrameListener);

            docFrameHandler();
        }
    }

	COMPILE::SWF
    private function extraFrameListener(event:Event):void
    {
        if (lastFrame == currentFrame)
            return;

        lastFrame = currentFrame;

        if (currentFrame + 1 > totalFrames)
            removeEventListener(Event.ENTER_FRAME, extraFrameListener);

        extraFrameHandler();
    }

    /**
     *  @private
     *  Once the swf has been fully downloaded,
     *  advance the playhead to the next frame.
     *  This will cause the framescript to run, which runs frameEndHandler().
     */
	COMPILE::SWF
    private function preloader_preloaderDocFrameReadyHandler(event:Event):void
    {
        // Advance the next frame
        preloader.removeEventListener(FlexEvent.PRELOADER_DOC_FRAME_READY,
                                      preloader_preloaderDocFrameReadyHandler);

        deferredNextFrame();
    }

    /**
     *  @private
     *  Remove the preloader and add the application as a child.
     */
    private function preloader_preloaderDoneHandler(event:Event):void
    {
        var app:IUIComponent = topLevelWindow;

        // Once the preloader dispatches the PRELOADER_DONE event, remove the preloader
        // and add the application as the child
        preloader.removeEventListener(FlexEvent.PRELOADER_DONE,
                                      preloader_preloaderDoneHandler);
		COMPILE::LATER
		{
			preloader.removeEventListener(RSLEvent.RSL_COMPLETE, 
				preloader_rslCompleteHandler);				
		}

        _popUpChildren.removeChild(preloader);
        preloader = null;

        // Add the mouseCatcher as child 0.
        mouseCatcher = new Sprite();
        mouseCatcher.name = "mouseCatcher";
        // Must use addChildAt because a creationComplete handler can create a
        // dialog and insert it at 0.
        noTopMostIndex = noTopMostIndex + 1;
        super.addChildAt(mouseCatcher, 0);  
        resizeMouseCatcher();
		COMPILE::LATER
		{
        if (!topLevel)
        {
            mouseCatcher.visible = false;
            mask = mouseCatcher;
        }
		}
        // Add the application as child 1.
        noTopMostIndex = noTopMostIndex + 1;
		COMPILE::SWF
		{
			FlashEventConverter.removeAllConverters(app as DisplayObject);
		}			
        super.addChildAt(DisplayObject(app), 1);

        CONFIG::performanceInstrumentation
        {
            var perfUtil:mx.utils.PerfUtil = mx.utils.PerfUtil.getInstance();
            perfUtil.markTime("APPLICATION_COMPLETE");
            perfUtil.finishSampling("Application Startup");
        }

        // Dispatch the applicationComplete event from the Application
        // and then agaom from the SystemManager
        // (so that loading apps know we're done).
        app.dispatchEvent(new FlexEvent(FlexEvent.APPLICATION_COMPLETE));
        dispatchEvent(new FlexEvent(FlexEvent.APPLICATION_COMPLETE));
    }

    /**
     *  @private
     *  The preloader has completed loading an RSL.
     */
	COMPILE::LATER
    private function preloader_rslCompleteHandler(event:RSLEvent):void
    {
        if (!event.isResourceModule && event.loaderInfo)
        {
            var rsl:Vector.<RSLData> = Vector.<RSLData>(rslDataList[event.rslIndex]);
            var moduleFactory:IFlexModuleFactory = this;
            if (rsl && rsl[0].moduleFactory)
                moduleFactory = rsl[0].moduleFactory; 

            if (moduleFactory == this)
                preloadedRSLs[event.loaderInfo] =  rsl;
            else
                moduleFactory.addPreloadedRSL(event.loaderInfo, rsl);
        }
    }
    
    /**
     *  @private
     *  This is attached as the framescript at the end of frame 2.
     *  When this function is called, we know that the application
     *  class has been defined and read in by the Player.
     */
	COMPILE::SWF
	mx_internal function docFrameHandler(event:Event = null):void
	{
		
		if (readyForKickOff)
			kickOff();
	}			

    /**
     *  @private
     *  kick off if we're ready
     */
    mx_internal function preloader_completeHandler(event:Event):void
    {
        preloader.removeEventListener(Event.COMPLETE,
                                   preloader_completeHandler);
        readyForKickOff = true;
		COMPILE::SWF
		{
        if (currentFrame >= 2)
            kickOff();
		}
    }   

    /**
     *  @private
     *  kick off 
     */
    mx_internal function kickOff():void
    {
        // already been here
        if (document)
            return;

        CONFIG::performanceInstrumentation
        {
            var perfUtil:mx.utils.PerfUtil = mx.utils.PerfUtil.getInstance();
            perfUtil.markTime("SystemManager.kickOff().start");
        }
        
		COMPILE::LATER
		{
        if (!isTopLevel())
            SystemManagerGlobals.topLevelSystemManagers[0].
                // dispatch a FocusEvent so we can pass ourselves along
                dispatchEvent(new FocusEvent(FlexEvent.NEW_CHILD_APPLICATION, false, false, this));
		}
		
        // Generated code will bring in EmbeddedFontRegistry
        Singleton.registerClass("mx.core::IEmbeddedFontRegistry",
                Class(getDefinitionByName("mx.core::EmbeddedFontRegistry")));
                
        Singleton.registerClass("mx.styles::IStyleManager",
            Class(getDefinitionByName("mx.styles::StyleManagerImpl")));
        
        Singleton.registerClass("mx.styles::IStyleManager2",
            Class(getDefinitionByName("mx.styles::StyleManagerImpl")));

        // Register other singleton classes.
        // Note: getDefinitionByName() will return null
        // if the class can't be found.

        Singleton.registerClass("mx.managers::IBrowserManager",
            Class(getDefinitionByName("mx.managers::BrowserManagerImpl")));

        Singleton.registerClass("mx.managers::ICursorManager",
            Class(getDefinitionByName("mx.managers::CursorManagerImpl")));

        Singleton.registerClass("mx.managers::IHistoryManager",
            Class(getDefinitionByName("mx.managers::HistoryManagerImpl")));

        Singleton.registerClass("mx.managers::ILayoutManager",
            Class(getDefinitionByName("mx.managers::LayoutManager")));

        Singleton.registerClass("mx.managers::IPopUpManager",
            Class(getDefinitionByName("mx.managers::PopUpManagerImpl")));

        Singleton.registerClass("mx.managers::IToolTipManager2",
            Class(getDefinitionByName("mx.managers::ToolTipManagerImpl")));

        var dragManagerClass:Class = null;
                
        // Make this call to create a new instance of the DragManager singleton. 
        // Try to link in the NativeDragManager first. This will allow the  
        // application to receive NativeDragEvents that originate from the
        // desktop.  If it can't be found, then we're 
        // not in AIR, and it can't be linked in, so we should just work off of 
        // the regular Flex DragManager.
        var dmInfo:Object = info()["useNativeDragManager"];
                 
        var useNative:Boolean = dmInfo == null ? true : String(dmInfo) == "true";
         
        if (useNative)
            dragManagerClass = Class(getDefinitionByName("mx.managers::NativeDragManagerImpl"));
    
        if (dragManagerClass == null)
            dragManagerClass = Class(getDefinitionByName("mx.managers::DragManagerImpl"));
        
        Singleton.registerClass("mx.managers::IDragManager", dragManagerClass);

        Singleton.registerClass("mx.core::ITextFieldFactory", 
            Class(getDefinitionByName("mx.core::TextFieldFactory")));

        var mixinList:Array = info()["mixins"];
        if (mixinList && mixinList.length > 0)
        {
            var n:int = mixinList.length;
            for (var i:int = 0; i < n; ++i)
            {
                CONFIG::performanceInstrumentation
                {
                    var token:int = perfUtil.markStart();
                }
                
                // trace("initializing mixin " + mixinList[i]);
                var c:Class = Class(getDefinitionByName(mixinList[i]));
                c["init"](this);

                CONFIG::performanceInstrumentation
                {
                    perfUtil.markEnd(mixinList[i], token);
                }
            }
        }
        
        c = Singleton.getClass("mx.managers::IActiveWindowManager");
        if (c)
        {
            registerImplementation("mx.managers::IActiveWindowManager", new c(this));
        }

        // depends on having IActiveWindowManager installed first
        c = Singleton.getClass("mx.managers::IMarshalSystemManager");
        if (c)
        {
            registerImplementation("mx.managers::IMarshalSystemManager", new c(this));
        }

        CONFIG::performanceInstrumentation
        {
            // Finish here, since initializeTopLevelWidnow is instrumented separately???
            perfUtil.markTime("SystemManager.kickOff().end");
        }

        initializeTopLevelWindow(null);

		COMPILE::SWF
		{
			deferredNextFrame();				
		}
    }

    /**
     *  @private
     *  The Flash Player dispatches KeyboardEvents with cancelable=false. 
     *  We'd like to be able to use the preventDefault() method on some
     *  KeyBoard events to record the fact that they've been handled. 
     *  This method stops propagation of the original event and redispatches
     *  the new one from the original event's target.
     * 
     *  We're only handling a small subset of keyboard events, to 
     *  avoid unnecessary copying.   Most of events in the subset are
     *  handled by both Scroller and by Spark classes like TextArea or
     *  or List that include a Scroller in their skin. 
     */
	COMPILE::SWF
    private function keyDownHandler(e:KeyboardEvent):void
    {
        if (!e.cancelable)
        {
            switch (e.keyCode)
            {
                case Keyboard.UP:
                case Keyboard.DOWN:
                case Keyboard.PAGE_UP:
                case Keyboard.PAGE_DOWN:
                case Keyboard.HOME:
                case Keyboard.END:
                case Keyboard.LEFT:
                case Keyboard.RIGHT:
                case Keyboard.ENTER:
                {
                    e.stopImmediatePropagation();
                    var cancelableEvent:KeyboardEvent =
                        new KeyboardEvent(e.type, e.bubbles, true, e.charCode, e.keyCode, 
                                          e.keyLocation, e.ctrlKey, e.altKey, e.shiftKey)              
                    e.target.dispatchEvent(cancelableEvent);
                }
            }
        }
    }
    
    /**
     *  @private 
     *  Similar to keyDownHandler above.  We want to re-dispatch 
     *  mouse events that are cancellable.  Currently we are only doing 
     *  this for a few mouse events and not all of them (MOUSE_WHEEL and 
     *  MOUSE_DOWN).
     */
	COMPILE::SWF
    private function mouseEventHandler(e:MouseEvent):void
    {
        if (!e.cancelable && e.eventPhase != EventPhase.BUBBLING_PHASE)
        {
            e.stopImmediatePropagation();
            var cancelableEvent:MouseEvent = null;
            if ("clickCount" in e)
            {
                // AIR MouseEvent. We need to use a constructor so we can
                // pass in clickCount because it is a read-only property.
                var mouseEventClass:Class = MouseEvent;
                
                cancelableEvent = new mouseEventClass(e.type, e.bubbles, true, e.localX,
                                e.localY, e.relatedObject, e.ctrlKey, e.altKey,
                                e.shiftKey, e.buttonDown, e.delta, 
                                e["commandKey"], e["controlKey"], e["clickCount"]);
            }
            else
            {
                cancelableEvent = new MouseEvent(e.type, e.bubbles, true, e.localX, 
                                 e.localY, e.relatedObject, e.ctrlKey, e.altKey,
                                 e.shiftKey, e.buttonDown, e.delta);
            }
            
            e.target.dispatchEvent(cancelableEvent);               
        }
    }

	COMPILE::SWF
    private function extraFrameHandler(event:Event = null):void
    {
        var frameList:Object = info()["frames"];
                        
        if (frameList && frameList[currentLabel])
        {
            var c:Class = Class(getDefinitionByName(frameList[currentLabel]));
            c["frame"](this);
        }

        deferredNextFrame();
    }
    
    /**
     *  @private
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	COMPILE::SWF
    private function nextFrameTimerHandler(event:TimerEvent):void
    {
        if (currentFrame + 1 <= framesLoaded)
        {
            nextFrame();
            nextFrameTimer.removeEventListener(TimerEvent.TIMER, nextFrameTimerHandler);
            // stop the timer
            nextFrameTimer.reset();
                }
            }
    

    /**
     *  @private
     *  Instantiates an instance of the top level window
     *  and adds it as a child of the SystemManager.
     */
    private function initializeTopLevelWindow(event:Event):void
    {
		COMPILE::LATER
		{
        // This listener is intended to run before any other KeyboardEvent listeners
        // so that it can redispatch a cancelable=true copy of the event. 
        if (getSandboxRoot() == this)
        {
            addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, true, 1000);
            addEventListener(MouseEvent.MOUSE_WHEEL, mouseEventHandler, true, 1000);
            addEventListener(MouseEvent.MOUSE_DOWN, mouseEventHandler, true, 1000);
        }
		}
		COMPILE::SWF
		{
        if (isTopLevelRoot() && stage)
        {
            stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, false, 1000);
            stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseEventHandler, false, 1000);
            stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseEventHandler, false, 1000);
			FlashEventConverter.setupAllConverters(this);
        }
		}
        
		COMPILE::LATER
		{
			// access to our parent.  Add a check for this case.
			if (!parent && parentAllowsChild)
				return;				
		}
		
        // Parent may be null if in another sandbox and don't have
        if (!topLevel)
        {
            // We are not top-level and don't have a parent. This can happen
            // when the application has already been unloaded by the time
            // we get to this point.
            if (!parent)
                return;

            var obj:DisplayObjectContainer = parent.parent;

            // if there is no grandparent at this point, we might have been removed and
            // are about to be killed so just bail.  Other code that runs after
            // this point expects us to be grandparented.  Another scenario
            // is that someone loaded us but not into a parented loader, but that
            // is not allowed.
            if (!obj)
                return;
  
            while (obj)
            {
                if (obj is IUIComponent)
                {
                    var sm:ISystemManager = IUIComponent(obj).systemManager;
                    if (sm && !sm.isTopLevel())
                        sm = sm.topLevelSystemManager;
                        
                    _topLevelSystemManager = sm;
                    break;
                }
                obj = obj.parent;
            }
        }

		COMPILE::SWF
		{
        if (isTopLevelRoot() && stage)
            stage.addEventListener(Event.RESIZE, Stage_resizeHandler, false, 0, true);
        else if (topLevel && stage)
        {
			COMPILE::LATER
			{
            // listen to resizes on the sandbox root
            var sandboxRoot:DisplayObject = getSandboxRoot();
            if (sandboxRoot != this)
                sandboxRoot.addEventListener(Event.RESIZE, Stage_resizeHandler, false, 0, true);
			}
        }
		
        var w:Number;
        var h:Number;

        if (isStageRoot && stage)
        {
            // stageWidth/stageHeight may have changed between initialize() and now,
            // so refresh our _width and _height here. 

            // TODO: finalize scaling behavior
            Stage_resizeHandler();
            //_width = stage.stageWidth;
            //_height = stage.stageHeight;
            
            // Detect and account for special case where our stage in some 
            // contexts has not actually been initialized fully, as is the 
            // case with IE if the window is fully obscured upon loading.
            if (_width == 0 && _height == 0 && 
                loaderInfo.width != _width && 
                loaderInfo.height != _height)
            {
                _width = loaderInfo.width;
                _height = loaderInfo.height;
            }
            w = _width;
            h = _height;
        }   
        else
        {
            w = loaderInfo.width;
            h = loaderInfo.height;
        }
		}
		COMPILE::JS
		{
			var w:Number = this.width;
			var h:Number = this.height;
		}
        childManager.initializeTopLevelWindow(w, h);
    }
    
    /**
     *  listen for creationComplete" on the application
     *  if you want to perform any logic
     *  when the application has finished initializing itself.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private function appCreationCompleteHandler(event:FlexEvent):void
    {
        invalidateParentSizeAndDisplayList();
    }

    /**
     *  Attempts to notify the parent SWFLoader that the
     *  Application's size has changed.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function invalidateParentSizeAndDisplayList():void
    {
        if (!topLevel && parent)
        {
            var obj:DisplayObjectContainer = parent.parent;
            while (obj)
            {
                if (obj is IInvalidating)
                {
                    IInvalidating(obj).invalidateSize();
                    IInvalidating(obj).invalidateDisplayList();
                    return;
                }
                obj = obj.parent;
            }
        }

        // re-dispatch from here so MarshallPlan mixins can see it
        dispatchEvent(new Event("invalidateParentSizeAndDisplayList"));
    }

    /**
     *  @private
     *  Keep track of the size and position of the stage.
     */
	COMPILE::SWF
    private function Stage_resizeHandler(event:Event = null):void
    {   
        if (isDispatchingResizeEvent)
            return;

        var w:Number = 0;
        var h:Number = 0;
        var m:Number;
        var n:Number;
        
        try
        {
            m = loaderInfo.width;
            n = loaderInfo.height;
        }
        catch (error:Error)
        {
            // Error #2099: The loading object is not sufficiently loaded to provide this information.
            // We get this error because an old Event.RESIZE listener with a weak reference
            // is being called but the SWF has been unloaded.
            if (!_screen)
                _screen = new Rectangle();
                
            return; 
        }
                
        var align:String = StageAlign.TOP_LEFT;

        // If we don't have access to the stage, then use the size of 
        // the sandbox root and align to StageAlign.TOP_LEFT.                        
        try 
        {
            if (stage)
            {
                w = stage.stageWidth;
                h = stage.stageHeight;
                align = stage.align;
            }
        }
        catch (error:SecurityError)
        {
            if (hasEventListener("getScreen"))
            {
                dispatchEvent(new Event("getScreen"));
                if (_screen)
                {
                    w = _screen.width;
                    h = _screen.height;
                }
            }
        }
        
        var x:Number = (m - w) / 2;
        var y:Number = (n - h) / 2;
        
        if (align == StageAlign.TOP)
        {
            y = 0;
        }
        else if (align == StageAlign.BOTTOM)
        {
            y = n - h;
        }
        else if (align == StageAlign.LEFT)
        {
            x = 0;
        }
        else if (align == StageAlign.RIGHT)
        {
            x = m - w;
        }
        else if (align == StageAlign.TOP_LEFT || align == "LT") // player bug 125020
        {
            y = 0;
            x = 0;
        }
        else if (align == StageAlign.TOP_RIGHT)
        {
            y = 0;
            x = m - w;
        }
        else if (align == StageAlign.BOTTOM_LEFT)
        {
            y = n - h;
            x = 0;
        }
        else if (align == StageAlign.BOTTOM_RIGHT)
        {
            y = n - h;
            x = m - w;
        }
        
        if (!_screen)
            _screen = new Rectangle();
        _screen.x = x;
        _screen.y = y;
        _screen.width = w;
        _screen.height = h;

        if (isStageRoot)
        {
            var scale:Number = densityScale;
            
            root.scaleX = root.scaleY = scale;
            _width = stage.stageWidth / scale;
            _height = stage.stageHeight / scale;
            
            // Update the screen
            _screen.x /= scale;
            _screen.y /= scale;
            _screen.width /= scale;
            _screen.height /= scale;
        }

        if (event)
        {
            resizeMouseCatcher();
            isDispatchingResizeEvent = true;
            dispatchEvent(event);
            isDispatchingResizeEvent = false;
        }
    }
    
    /**
     *  @private
     * 
     * Get the index of an object in a given child list.
     * 
     * @return index of f in childList, -1 if f is not in childList.
     */ 
    private static function getChildListIndex(childList:IChildList, f:Object):int
    {
        var index:int = -1;
        try
        {
            index = childList.getChildIndex(DisplayObject(f)); 
        }
        catch (e:Error)
        {
			COMPILE::SWF
			{
				if (!(e is ArgumentError))
					throw e;
			}
            // index has been preset to -1 so just continue.    
        }
        
        return index; 
    }

    /**
     *  @private
     *  Track mouse moves in order to determine idle
     */
    private function mouseMoveHandler(event:MouseEvent):void
    {
        // Reset the idle counter.
        idleCounter = 0;
    }

    /**
     *  @private
     *  Track mouse moves in order to determine idle.
     */
    private function mouseUpHandler(event:MouseEvent):void
    {
        // Reset the idle counter.
        idleCounter = 0;
    }

    /**
     *  @private
     *  Called every IDLE_INTERVAL after the first listener
     *  registers for 'idle' events.
     *  After IDLE_THRESHOLD goes by without any user activity,
     *  we dispatch an 'idle' event.
     */
	COMPILE::LATER
    private function idleTimer_timerHandler(event:TimerEvent):void
    {
        idleCounter++;

        if (idleCounter * IDLE_INTERVAL > IDLE_THRESHOLD)
            dispatchEvent(new FlexEvent(FlexEvent.IDLE));
    }

    
    
    // fake out mouseX/mouseY
    mx_internal var _mouseX:*;
    mx_internal var _mouseY:*;


    /**
     *  @private
     */
	COMPILE::SWF
    override public function get mouseX():Number
    {
        if (_mouseX === undefined)
            return super.mouseX;
        return _mouseX;
    }

    /**
     *  @private
     */
	COMPILE::SWF
    override public function get mouseY():Number
    {
        if (_mouseY === undefined)
            return super.mouseY;
        return _mouseY;
    }
    
    
    private function getTopLevelSystemManager(parent:DisplayObject):ISystemManager
    {
        var localRoot:DisplayObjectContainer = DisplayObjectContainer(parent.root);
        var sm:ISystemManager;
        
        // If the parent isn't rooted yet,
        // Or the root is the stage (which is the case in a second AIR window)
        // use the global system manager instance.
		COMPILE::SWF
		{
			if ((!localRoot || localRoot is Stage) && parent is IUIComponent)
				localRoot = DisplayObjectContainer(IUIComponent(parent).systemManager);				
		}
        if (localRoot is ISystemManager)
        {
            sm = ISystemManager(localRoot);
            if (!sm.isTopLevel())
                sm = sm.topLevelSystemManager;
        }

        return sm;
    }

    /**
     * Override parent property to handle the case where the parent is in
     * a differnt sandbox. If the parent is in the same sandbox it is returned.
     * If the parent is in a diffent sandbox, then null is returned.
     * 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */ 
    override public function get parent():DisplayObjectContainer
    {
        try
        {
            return super.parent;
        }   
        catch (e:Error) 
        {
			COMPILE::SWF
			{
				if (!(e is SecurityError))
					throw e;
			}
            // trace("parent: ignoring security error");
        }
        
        return null;
    }

    
    /**
     *  Go up the parent chain to get the top level system manager.
     * 
     *  Returns <code>null</code> if not on the display list or we don't have
     *  access to the top-level system manager.
     *  
     *  @return The root system manager.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
	 * 
	 *  @flexjsignorecoercion flex.display.DisplayObject
     */
    public function getTopLevelRoot():DisplayObject
    {
		COMPILE::SWF
		{
			// work our say up the parent chain to the root. This way we
			// don't have to rely on this object being added to the stage.
			try
			{
				var sm:ISystemManager = this;
				if (sm.topLevelSystemManager)
					sm = sm.topLevelSystemManager;
				var parent:DisplayObject = DisplayObject(sm).parent;
				var lastParent:DisplayObject = DisplayObject(sm);
				while (parent)
				{
					if (parent is Stage)
						return lastParent;
					lastParent = parent; 
					parent = parent.parent;             
				}
			}
			catch (error:SecurityError)
			{
			}       				
		}
        COMPILE::JS
		{
			return topOfDisplayList as DisplayObject;
		}
        return null;
    }

    /**
     *  Go up the parent chain to get the top level system manager in this 
     *  SecurityDomain.
     * 
     *  @return The root system manager in this SecurityDomain.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	COMPILE::LATER
    public function getSandboxRoot():DisplayObject
    {
        // work our say up the parent chain to the root. This way we
        // don't have to rely on this object being added to the stage.
        var sm:ISystemManager = this;

        try
        {
            if (sm.topLevelSystemManager)
                sm = sm.topLevelSystemManager;
            var parent:DisplayObject = DisplayObject(sm).parent;
            if (parent is Stage)
                return DisplayObject(sm);
            // test to see if parent is a Bootstrap
            if (parent && !parent.dispatchEvent(new Event("mx.managers.SystemManager.isBootstrapRoot", false, true)))
                return this;
            var lastParent:DisplayObject = this;
            while (parent)
            {
                if (parent is Stage)
                    return lastParent;
                // test to see if parent is a Bootstrap
                if (!parent.dispatchEvent(new Event("mx.managers.SystemManager.isBootstrapRoot", false, true)))
                    return lastParent;
                    
                // Test if the childAllowsParent so we know there is mutual trust between
                // the sandbox root and this sm.
                // The parentAllowsChild is taken care of by the player because it returns null
                // for the parent if we do not have access.
                if (parent is Loader)
                {
                    var loader:Loader = Loader(parent);
                    var loaderInfo:LoaderInfo = loader.contentLoaderInfo;
                    if (!loaderInfo.childAllowsParent)
                        return loaderInfo.content;
                }
                
                // If an object is listening for system manager request we assume it is a sandbox
                // root. If not, don't assign lastParent to this parent because it may be a
                // non-Flex application. We only want Flex apps to be returned as sandbox roots.
                // use constant to avoid link dependency on InterManagerRequest.SYSTEM_MANAGER_REQUEST

                if (parent.hasEventListener("systemManagerRequest" 
                            ))
                lastParent = parent; 
                parent = parent.parent;             
            }
        }
        catch (error:Error)
        {
            // Either we don't have security access to a parent or
            // the swf is unloaded and loaderInfo.childAllowsParent is throwing Error #2099.
        }       
        
        return lastParent != null ? lastParent : DisplayObject(sm);
    }
    
    /**
     * @private
     *  A map of fully-qualified interface names,
     *  such as "mx.managers::IPopUpManager",
     *  to instances,
     */
    private var implMap:Object = {};
        
    /**
     * @private
     *  Adds an interface-name-to-implementation-class mapping to the registry,
     *  if a class hasn't already been registered for the specified interface.
     *  The class must implement a getInstance() method which returns
     *  its singleton instance.
     */
    public function registerImplementation(interfaceName:String,
                                         impl:Object):void
    {
        var c:Object = implMap[interfaceName];
        if (!c)
            implMap[interfaceName] = impl;
    }
        
    /**
     * @private
     *  Returns the singleton instance of the implementation class
     *  that was registered for the specified interface,
     *  by looking up the class in the registry
     *  and calling its getInstance() method.
     * 
     *  This method should not be called at static initialization time,
     *  because the factory class may not have called registerClass() yet.
     */
    public function getImplementation(interfaceName:String):Object
    {
        var c:Object = implMap[interfaceName];
        return c;
    }

    /**
    *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	COMPILE::LATER
    public function getVisibleApplicationRect(bounds:Rectangle = null, skipToSandboxRoot:Boolean = false):Rectangle
    {
        if (hasEventListener("getVisibleApplicationRect"))
        {
            var request:Request = new Request("getVisibleApplicationRect", false, true);
			request.value = { bounds: bounds, skipToSandboxRoot: skipToSandboxRoot };
            if (!dispatchEvent(request)) 
                return Rectangle(request.value);
        }
        
		if (skipToSandboxRoot && !topLevel)
			return topLevelSystemManager.getVisibleApplicationRect(bounds, skipToSandboxRoot);
		
        if (!bounds)
        {
            bounds = Rectangle.convert(getBounds(DisplayObject(this)));
        
            var sandboxRoot:DisplayObject = getSandboxRoot();
            var s:Rectangle = Rectangle.convert(screen.clone());
            s.topLeft = sandboxRoot.localToGlobal(screen.topLeft);
            s.bottomRight = sandboxRoot.localToGlobal(screen.bottomRight);
            var pt:Point = new Point(Math.max(0, bounds.x), Math.max(0, bounds.y));
            pt = localToGlobal(pt);
            bounds.x = pt.x;
            bounds.y = pt.y;
            bounds.width = s.width;
            bounds.height = s.height;
            
            // No backwards compatibility
            // See https://bugs.adobe.com/jira/browse/SDK-31377
            // FlexVersion.compatibilityVersion >= FlexVersion.VERSION_4_6
            
            // softKeyboardRect is in global coordinates.
            // Keyboard size may change size while active. Listen for
            // SoftKeyboardEvents on the stage and call 
            // getVisibleApplicationRect() to get updated visible bounds.
            var softKeyboardRect:Rectangle = Rectangle.convert(stage.softKeyboardRect);
            bounds.height = bounds.height - softKeyboardRect.height;
        }
        
		if (!topLevel)
		{
			var obj:DisplayObjectContainer = parent.parent;
			
			if ("getVisibleApplicationRect" in obj)
			{
				var visibleRect:Rectangle = obj["getVisibleApplicationRect"](true);
				bounds = Rectangle.convert(bounds.intersection(visibleRect));
			}
		}
        return bounds;
    }
 
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function deployMouseShields(deploy:Boolean):void
    {
        if (hasEventListener("deployMouseShields"))
        {
            var dynamicEvent:DynamicEvent = new DynamicEvent("deployMouseShields");
            dynamicEvent.deploy = deploy;
            dispatchEvent(dynamicEvent);
        }
    }

    /**
     *  @private
     *  dispatch certain stage events from sandbox root
     */
	COMPILE::SWF
    private function stageEventHandler(event:Event):void
    {
        if (event.target is Stage && mouseCatcher)
        {
            // need to fix up the coordinate space before re-dispatching the mouse event  
            // to put it in the same coordinate space as the mouseCatcher since the 
            // mouseCatcher may be scaled while outside of the stage, we are not
            if (event is MouseEvent)
            {
                var mouseEvent:MouseEvent = MouseEvent(event);
                var stagePoint:Point = new Point(mouseEvent.stageX, mouseEvent.stageY);
                var mouesCatcherLocalPoint:Point = mouseCatcher.globalToLocal(stagePoint);
                mouseEvent.localX = mouesCatcherLocalPoint.x;
                mouseEvent.localY = mouesCatcherLocalPoint.y;
            }
            
            // dispatch them from mouseCatcher so capture phase listeners on 
            // systemManager will work
            mouseCatcher.dispatchEvent(event);
        }
    }

    /**
     *  @private
     *  convert MOUSE_LEAVE to MOUSE_UP_SOMEWHERE
     */
	COMPILE::LATER
    private function mouseLeaveHandler(event:Event):void
    {
        dispatchEvent(new SandboxMouseEvent(SandboxMouseEvent.MOUSE_UP_SOMEWHERE));
    }

	public function get moduleInfo():ModuleInfo
	{
		COMPILE::SWF
		{
			return new ModuleInfo(loaderInfo);				
		}
		COMPILE::JS
		{
			return new ModuleInfo();				
		}
	}
	
	COMPILE::SWF
	private var _topOfDisplayList:TopOfDisplayList;
	
	/**
	 *  @flexjsignorecoercion flex.display.TopOfDisplayList
	 */
	COMPILE::SWF
	public function get topOfDisplayList():TopOfDisplayList
	{
		if (!_topOfDisplayList)
			_topOfDisplayList = new TopOfDisplayList(stage);
		return _topOfDisplayList;
	}
	
	/**
	 *  @private
	 *  Track mouse moves in order to determine idle
	 */
	COMPILE::JS
	private function js_mouseMoveHandler(event:MouseEvent):void
	{
		SystemManagerGlobals.lastMouseEvent = event;
	}
	
	COMPILE::SWF
	private var _beads:Vector.<IBead>;
	
	/**
	 *  @copy org.apache.flex.core.IStrand#addBead()
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */ 
	COMPILE::SWF
	public function addBead(bead:IBead):void
	{
		if (!_beads)
			_beads = new Vector.<IBead>;
		bead.strand = this;		
	}
	
	/**
	 *  @copy org.apache.flex.core.IStrand#getBeadByType()
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	COMPILE::SWF
	public function getBeadByType(classOrInterface:Class):IBead
	{
		for each (var bead:IBead in _beads)
		{
			if (bead is classOrInterface)
				return bead;
		}
		return null;
	}
	
	/**
	 *  @copy org.apache.flex.core.IStrand#removeBead()
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	COMPILE::SWF
	public function removeBead(value:IBead):IBead	
	{
		var n:int = _beads.length;
		for (var i:int = 0; i < n; i++)
		{
			var bead:IBead = _beads[i];
			if (bead == value)
			{
				_beads.splice(i, 1);
				return bead;
			}
		}
		return null;
	}
	
	/**
	 *  @copy org.apache.flex.core.IUIBase#element
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	COMPILE::SWF
	public function get element():IFlexJSElement
	{
		return null;
	}
	
	/**
	 *  The method called when added to a parent.  This is a good
	 *  time to set up beads.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 *  @flexjsignorecoercion Class
	 *  @flexjsignorecoercion Number
	 */
	COMPILE::SWF
	public function addedToParent():void
	{
		// do nothing for now
	}

	COMPILE::SWF
	public function get topMostEventDispatcher():IEventDispatcher
	{
		return this;
	}
}

}
