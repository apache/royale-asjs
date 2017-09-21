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
package {

COMPILE::SWF
{
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.display.Stage;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.FocusEvent;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.events.UncaughtErrorEvent;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.net.Socket;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;
import flash.system.Security;
import flash.system.fscommand;
import flash.utils.Dictionary;
import flash.utils.Timer;
import flash.utils.getQualifiedClassName;
import flash.utils.setTimeout;
}

/*
import mx.binding.Binding;
import mx.binding.BindingManager;
import mx.binding.FunctionReturnWatcher;
import mx.binding.PropertyWatcher;
import mx.binding.StaticPropertyWatcher;
import mx.binding.Watcher;
import mx.binding.XMLWatcher;
import mx.core.IMXMLObject;
import mx.core.mx_internal;

use namespace mx_internal;
*/

COMPILE::JS
{
import org.apache.flex.events.EventDispatcher;
import org.apache.flex.geom.Point;
}

[Mixin]
/**
 *  The test engine for unit testing Flex framework components.
 *  A UnitTester gets linked in as a mixin and when initialized
 *  finds a set of tests to run and runs them.
 *  
 *  Test scripts are written as MXML components derived from
 *  this class, and contain a bunch of TestCases with TestStep-
 *  derived child tags.  They must also be [Mixin] and call
 *  setScript.
 */
public class UnitTester extends EventDispatcher
{
	/**
	* This holds settings which are considered in ConditionalValue
	* work.
	**/
    COMPILE::SWF
	public static var cv:ConditionalValue;

	/**
	* This tells whether to write baselines to disk.
	* Set by MobileConfigWriter.
	**/
	public static var writeBaselinesToDisk:Boolean = false;

	/**
	* This tells UnitTester where it can write files.
	* Set by MobileConfigWriter.
	**/
	public static var mustellaWriteLocation:String = "";

	/**
	* This is the name of the exclude file.
	* Set by MobileConfigWriter.
	**/
	public static var excludeFile:String = "";

    /**
     *  The location of the mustella test directory.
     */
    public static var mustellaTestDir:String = "";
    
    /**
     *  Set by either ExcludeFileLocation or ExcludeFileLocationApollo so they
     *  can be called back to load the exclude file after mustellaTestDir has 
     *  been set in the init() method.
     */
    public static var loadExcludeFile:Function;
    
	/**
	* This is a placeholder.  We don't do portrait and landscape runs right now
	* and probablay won't.  Delete.
	**/
	//public static var deviceOrientation:String = null;
	
	/**
	 * port number that will be used by tests that require a webserver.
	 */
	 public static var portNumber : Number=80;

     /**
      * waitEvent, if we're waiting for one.
      */
     public static var waitEvent : String;
     
     /**
      * UIComponentGlobals.
      */
     public static var uiComponentGlobals : Object;
     
	/**
	 * additional wait before exit for coverage
	 */
	 public static var coverageTimeout : Number = 0;

	/**
	 * Last executed step
	 */
	 public static var lastStep:TestStep = null;

	/**
	 * Step # of that last step 
	 */
	 public static var lastStepLine:int = -1;

	/**
	 * IGNORE all failures and only report passing.
	 * This allows creation of multiple .bad.png files in testcases 
	 * where there are many CompareBitmap tags	
	 * DANGEROUS flag, for obvious reasons
	 */
	 public static var noFail:Boolean = false;

		
	/**
	 * a pixel tolerance multiplier that CompareBitmap will use to judge comparisons
	 */
	 public static var pixelToleranceMultiplier:Number = 1;

		
	/**
	 *  Mixin callback that gets everything ready to go.
	 *  The UnitTester waits for an event before starting
	 */
    COMPILE::SWF
	public static function init(root:DisplayObject):void
	{
	
        if (waitForExcludes && loadExcludeFile != null)
            loadExcludeFile();
        
		// don't let child swfs override this
		if (!_root)
			_root = root;

		/// set device if not set.
		if (cv == null){
			cv = new ConditionalValue();
		}
		
		if (cv.os == null)
		{
			cv.os = DeviceNames.getFromOS();

		}

		if (cv.device == null)
		{
			if (Security.sandboxType == Security.APPLICATION)
				cv.device = "air";
		}
		
		if(root.loaderInfo != null && root.loaderInfo.parameters != null)
		{
			for (var ix:String in root.loaderInfo.parameters) 
			{
				if(ix == "port") 
				{
					portNumber = Number(root.loaderInfo.parameters[ix]);	
				}
				else if(ix == "pixelToleranceMultiplier") 
				{ 
					pixelToleranceMultiplier = Number(root.loaderInfo.parameters[ix]);
				} 
			}
		}  
		
		// load a run id if not loaded (used in full runs)
		if (!run_id_loaded)
		{
			/// esp. for MP, avoid doing this twice:
			run_id_loaded=true;

			/// avoid 304 returns from the web server:
			var endBit:String = "?" + Math.random() + new Date().getTime();

	                reader = new URLLoader();
                	var req:URLRequest = new URLRequest();			

			/// by convention, we use the /staging alias for the vetting run workspace
			if (isVettingRun)
			{
				req.url = "http://localhost:" + portNumber + "/staging/runid.properties" + endBit;
			} 
			else
			{
				req.url = "http://localhost:" + portNumber + "/runid.properties" + endBit;
			}

			reader.dataFormat=URLLoaderDataFormat.TEXT;
                	reader.addEventListener(Event.COMPLETE, readCompleteHandler);
                	reader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, readErrorHandler);
                	reader.addEventListener(IOErrorEvent.IO_ERROR, readErrorHandler);
			reader.load(req);


		}

		// load a run id if not loaded (used in full runs)
		if (!timeout_plus_loaded)
		{

	                timeout_reader = new URLLoader();
                	var req2:URLRequest = new URLRequest();			

			/// by convention, we use the /staging alias for the vetting run workspace
			req2.url = "http://localhost:" + runnerPort + "/step_timeout";

			timeout_reader.dataFormat=URLLoaderDataFormat.TEXT;
                	timeout_reader.addEventListener(Event.COMPLETE, timeout_readCompleteHandler);
                	timeout_reader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, timeout_readErrorHandler);
                	timeout_reader.addEventListener(IOErrorEvent.IO_ERROR, timeout_readErrorHandler);

			timeout_reader.load(req2);


		} 

		var mixins:Array = root["info"]()["mixins"];
		var appdom:ApplicationDomain = root["info"]().currentDomain;
		if (!appdom)
			appdom = ApplicationDomain.currentDomain;
		for (var i:int = 0; i < mixins.length; i++)
		{
			var c:Class = Class(appdom.getDefinition(mixins[i]));
			var o:Object = new c();
			if (o is UnitTester && mixins[i] != "UnitTester")
			{
				var eventScripts:Array = scripts[o.startEvent];
				if (!eventScripts)
				{
					eventScripts = scripts[o.startEvent] = new Array();
					root.addEventListener(o.startEvent, pre_startEventHandler);
				}
				eventScripts.push(o);
			}
		}

        var passive:Boolean;
        try {
            passive = !(root.loaderInfo.parentAllowsChild && root.loaderInfo.childAllowsParent);
        } catch (e:Error)
        {
            // in single-frame apps, loaderInfo may not be ready
            passive = false;
        }
		// if we're sandboxed and have no scripts, assume we're passive.
		if (passive)
		{
			if (eventScripts == null)
			{
				sandboxed = true;
				sandboxHelper = new UnitTester();
				root.loaderInfo.sharedEvents.addEventListener(MustellaSandboxEvent.STRING_TO_OBJECT, sandboxStringToObjectHandler);
				root.loaderInfo.sharedEvents.addEventListener(MustellaSandboxEvent.GET_BITMAP, sandboxGetBitmapHandler);
				root.loaderInfo.sharedEvents.addEventListener(MustellaSandboxEvent.GET_EFFECTS, sandboxGetEffectsHandler);
				root.loaderInfo.sharedEvents.addEventListener(MustellaSandboxEvent.GET_OBJECTS_UNDER_POINT, sandboxObjectsUnderPointHandler);
				root.loaderInfo.sharedEvents.addEventListener(MustellaSandboxEvent.RESET_COMPONENT, sandboxResetComponentHandler);
				root.loaderInfo.sharedEvents.addEventListener(MustellaSandboxEvent.MOUSEXY, sandboxMouseXYHandler);
				root.loaderInfo.sharedEvents.addEventListener(MustellaSandboxEvent.GET_FOCUS, sandboxGetFocusHandler);
				root.loaderInfo.sharedEvents.addEventListener(MustellaSandboxEvent.APP_READY, sandboxAppReadyHandler);
				trace("sending mustellaStarted");
				root.loaderInfo.sharedEvents.dispatchEvent(new MustellaSandboxEvent(MustellaSandboxEvent.MUSTELLA_STARTED));
				root.addEventListener("applicationComplete", applicationCompleteHandler);
				root.addEventListener("enterFrame", enterFrameHandler, false, -9999);
				return;
			}
		}
		else if(root.parent != root.stage && root.loaderInfo.applicationDomain != root.parent.parent.loaderInfo.applicationDomain)
		{
			root.loaderInfo.sharedEvents.addEventListener(MustellaSandboxEvent.GET_EFFECTS, sandboxGetEffectsHandler);
			root.loaderInfo.sharedEvents.addEventListener(MustellaSandboxEvent.MOUSEXY, sandboxMouseXYHandler);
			root.addEventListener("applicationComplete", applicationCompleteHandler);
			root.loaderInfo.sharedEvents.addEventListener(MustellaSandboxEvent.APP_READY, sandboxAppReadyHandler);
		}

		root.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler);


		/*  uncaught exceptions should be grabbd by the global handler, making this
		    obsolete
		try
		{
			if (RTESocketAddress)
			{
				RTESocket = new Socket();
				RTESocket.connect(RTESocketAddress, 2561);
				RTESocket.addEventListener(ProgressEvent.SOCKET_DATA, RTEDefaultHandler, false, -1);
				RTESocket.addEventListener(IOErrorEvent.IO_ERROR, RTEIOErrorHandler);
				RTESocket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, RTEIOErrorHandler);
			}
		}
		catch (e:Error)
		{
		}
		*/

		var g:Class = appdom.hasDefinition("mx.core.UIComponentGlobals") ? 
                            Class(appdom.getDefinition("mx.core.UIComponentGlobals")) : null;
		if (g)
        {
			g["catchCallLaterExceptions"] = true;
            uiComponentGlobals = g;
        }

		if (eventScripts != null)
		{
			try
			{
				_root.stage.addEventListener("enterFrame", enterFrameHandler, false, -9999);
			}
			catch (e:Error)
			{
				_root.addEventListener("enterFrame", enterFrameHandler, false, -9999);
			}
			_root.addEventListener("focusIn", focusBlockingHandler, true);
			_root.addEventListener("focusOut", focusBlockingHandler, true);
			_root.addEventListener("deactivate", activateBlockingHandler, true);
			_root.addEventListener("activate", activateBlockingHandler, true);
		}
		
		if (appdom.hasDefinition("spark.components.supportClasses.RichEditableTextContainerManager"))
		{
			g = Class(appdom.getDefinition("spark.components.supportClasses.RichEditableTextContainerManager"));
			if (g)
			{
				var q:QName = new QName(mx_internal, "hideCursor");
				g[q] = true;
			}
		}	
	}

    COMPILE::JS
    public static function init(root:Object):void
    {
        
    }

	/**
	 *  Repeat variables. Used in leak testing. Set by mixin.
	 */
	public static var repeat:int = 0;
	public static var repeatCount:int = 0;


	/**
	 *  A test run id. This is loaded from a web served file. No id by default. 
	 */
	public static var run_id:String = "-1";

	/**
	 *  Indicate the run as vetting
	 */
	public static var isVettingRun:Boolean = false;

	/**
	 *  flag to skip reloading run id
	 */
	public static var run_id_loaded:Boolean = false;

	/**
	 *  flag to skip rechecking for timeout extender
	 */
	public static var timeout_plus_loaded:Boolean = false;

	/**
	 *  value to extend each test step timeout
	 */
	public static var timeout_plus:int = 0;

	/**
	 *  the URL loader for the run id
	 */
    COMPILE::SWF
	public static var reader:URLLoader;

	/**
	 *  the URL loader for the run id
	 */
    COMPILE::SWF
	public static var timeout_reader:URLLoader;


	/**
	 *  The directory that this test lives in
	 */
	public var testDir:String;

	/**
	 *	Whether or not we've seen the applicationComplete event
	 */
	public static var applicationComplete:Boolean = false;

	/**
	 *	Whether or not we're subordinate to another UnitTester in another sandbox
	 */
	public static var sandboxed:Boolean = false;

	/**
	 *	UnitTester used for sandbox work
	 */
	public static var sandboxHelper:UnitTester;

	/**
	 *	cache of known swfLoaders
	 */
    COMPILE::SWF
	public static var swfLoaders:Dictionary = new Dictionary(true);

	/**
	 *	note if an RTE has been detected
	 */
	public static var hasRTE:Boolean = false;

	/**
	 *	The RTE trace
	 */
	public static var RTEMsg:String = "";

	/**
	 *	For mini_run, we want to show the RTE
	 */
	public static var showRTE:Boolean = false;


    COMPILE::SWF
    private static function uncaughtErrorHandler(e:flash.events.UncaughtErrorEvent):void
	{
		hasRTE = true;

		/// Not yet seen
		if (e is Error)
		{
			RTEMsg = format(e.error.getStackTrace());
		} 
		else if (e is ErrorEvent)
		{ 
			RTEMsg = format(e.error.getStackTrace());
		}


		e.stopImmediatePropagation();

		// preventDefault will swallow the dialog pop up that shows the RTE
		// for mini run, we want to show that; for server runs, just swallow it
		if (!showRTE)
		{
			e.preventDefault();
		}

	}

    COMPILE::SWF
	private static function format(msg0:String):String 
	{
		var tmp:Array = null;

		var ret:String = "";

		/// collapse newlines in the messages:
		//// TEST ON MAC
		var culprit:String = "\n";

		var replaceChar:String = "^";


		var fileSepPat:RegExp = /\\/g; 
		var msg:String = msg0.replace (fileSepPat, "/");

		if (msg.indexOf (culprit) != -1)
		{ 
			tmp = msg.split (culprit);
			for (var i:int = 0;i<tmp.length;i++) 
			{
			
				if (ret != "")			
				{
					ret = ret + replaceChar  + tmp[i];
				} 
				else 
				{
					ret = tmp[i];
				}	

			}
		}  
		else 
		{
			return msg;
		}

		return ret;

	}



    COMPILE::SWF
    private static function readCompleteHandler(event:Event):void
    {
		run_id_loaded=true;
		run_id = reader.data;
	
		if (run_id.indexOf ("=") != -1)	
		{
			run_id = run_id.substring (run_id.indexOf ("=")+1);
		}

    }

    COMPILE::SWF
    private static function readErrorHandler(event:Event):void
    {
		trace ("runid.properties ERROR handler with: " + event);
		run_id_loaded=true;
    }


    COMPILE::SWF
    private static function timeout_readCompleteHandler(event:Event):void
    {
		timeout_plus_loaded=true;
		var tmp:String = timeout_reader.data;
	
		if (tmp.indexOf ("=") != -1)	
		{
			timeout_plus = new int(tmp.substring (tmp.indexOf ("=")+1))
		} else { 
			timeout_plus = new int(tmp);
		}
 		TestOutput.logResult("timeout_plus is: " + timeout_plus);
        }

        private static function timeout_readErrorHandler(event:Event):void
        {
		timeout_plus_loaded=true;
    }


	/**
	 *	set mouseXY in other SWFLoaders
	 */
    COMPILE::SWF
	public static function getFocus():InteractiveObject
	{
		for (var p:* in swfLoaders)
		{
			var swfLoader:Object = p;
			if (swfLoader)
			{
				var e:MustellaSandboxEvent = new MustellaSandboxEvent(MustellaSandboxEvent.GET_FOCUS);
				swfLoader.contentHolder.contentLoaderInfo.sharedEvents.dispatchEvent(e);
				if (e["obj"] != null)
					return e["obj"];
			}
		}
		return null;
	}

	/**
	 *	set mouseXY in other SWFLoaders
	 */
    COMPILE::SWF
	public static function setMouseXY(stagePt:Point):void
	{
		for (var p:* in swfLoaders)
		{
			var swfLoader:Object = p;
			if (swfLoader)
			{
				try
				{
					if (stagePt)
					{
						var pt:Point = swfLoader.content.globalToLocal(stagePt);
						swfLoader.content[mouseX] = pt.x;
						swfLoader.content[mouseY] = pt.y;
					}
					else
					{
						swfLoader.content[mouseX] = undefined;
						swfLoader.content[mouseY] = undefined;
					}
				}
				catch (se:SecurityError)
				{
					var e:MustellaSandboxEvent = new MustellaSandboxEvent(MustellaSandboxEvent.MOUSEXY);
					e.obj = stagePt;
					swfLoader.contentHolder.contentLoaderInfo.sharedEvents.dispatchEvent(e);
				}
				catch (ee:Error)
				{
				}
			}
		}
	}
    
    COMPILE::JS
    public static function setMouseXY(stagePt:Point):void
    {
        
    }

	/**
	 *	ask other sandboxes for objects underneath them
	 */
    COMPILE::SWF
	public static function getObjectsUnderPoint(target:DisplayObject, pt:Point):Array
	{
		var arr:Array = [];
		var root:DisplayObject = target.root;
		if (root != _root && !(root is Stage))
		{
			try
			{
				// Walk up as high as you can get
				while (!(root.parent is Stage))
				{
					root = root.parent.root;
				}
			}
			catch (e:Error)
			{
				// in another sandbox, start from our root.
				// probably won't work in an AIR window with
				// loaded content.
				root = _root;
			}
		}
		else if (root != _root && (root is Stage))
		{
			// seems to happen in AIR windows
			root = target;
			try
			{
				// Walk up as high as you can get
				while (!(root.parent is Stage))
				{
					root = root.parent;
				}
			}
			catch (e:Error)
			{
				// in another sandbox, start from our root.
				// probably won't work in an AIR window with
				// loaded content.
				root = _root;
			}
		}
		_getObjectsUnderPoint(root, pt, arr);

		return arr;
	}

    COMPILE::SWF
	private static var effectsInEffect:QName = new QName(mx_internal, "effectsInEffect");
    COMPILE::SWF
	private static var activeTweens:QName = new QName(mx_internal, "activeTweens");

	/**
	 *	ask other sandboxes if they are running effects
	 */
    COMPILE::SWF
	public static function getSandboxedEffects():Boolean
	{
		for (var p:* in swfLoaders)
		{
			var swfLoader:Object = p;
			if (swfLoader)
			{
				var e:MustellaSandboxEvent = new MustellaSandboxEvent(MustellaSandboxEvent.GET_EFFECTS);
				if ("contentLoaderInfo" in swfLoader.contentHolder)
				{
					swfLoader.contentHolder.contentLoaderInfo.sharedEvents.dispatchEvent(e);
					if (e.obj)
					{
						return e.obj;
					}
				}
			}
		}
		return false;
	}

	/**
	 *	get the trusted appdom from one of the loaded swfs
	 */
    COMPILE::SWF
	public static function getApplicationDomain(target:String, actualTarget:Object, className:String):ApplicationDomain
	{
		var appdom:ApplicationDomain = _root["info"]().currentDomain;
		if (!appdom)
			appdom = ApplicationDomain.currentDomain;

		if (appdom.hasDefinition(className))
		{
			var c:Class = Class(appdom.getDefinition(className));
			if (actualTarget is c)
				return appdom;
			// try again to handle some cases in existing mustella tests that
			// reset to a different class
			var cn:String = getQualifiedClassName(actualTarget);
			if (appdom.hasDefinition(cn))
			{
				c = Class(appdom.getDefinition(cn));
				if (actualTarget is c)
					return appdom;
			}
		}

		for (var p:* in swfLoaders)
		{
			var swfLoader:Object = p;
			if (swfLoader)
			{
				try 
				{
					// if parent is null, then this is a sandboxed app loaded from file::
					// and we don't want to return its appdom
					if (swfLoader.content.parent)
					{
						if (swfLoader.content["info"]().currentDomain.hasDefinition(className))
						{
							c = Class(swfLoader.content["info"]().currentDomain.getDefinition(className));
							if (actualTarget is c)
								return swfLoader.content["info"]().currentDomain;
						}
					}
				}
				catch (se:SecurityError)
				{
				}
			}
		}
		return null;
	}

	/**
	 *	reset a component in another sandbox
	 */
    COMPILE::SWF
	public static function resetSandboxedComponent(target:String, className:String):void
	{
		for (var p:* in swfLoaders)
		{
			var swfLoader:Object = p;
			var path:String = swfLoaders[p];
			if (swfLoader)
			{
				// find the right one based on path
				var c:int = target.indexOf(path);
				if (c == 0)
				{
					// clip off swfloader from path
					target = target.substr(path.length + 1, target.length);
					var e:MustellaSandboxEvent = new MustellaSandboxEvent(MustellaSandboxEvent.RESET_COMPONENT);
					e.string = target;
					e.obj = className;
					swfLoader.contentHolder.contentLoaderInfo.sharedEvents.dispatchEvent(e);
					return;
				}
			}
		}
	}

	/**
	 *	ask other sandboxes for their images
	 */
    COMPILE::SWF
	public static function getSandboxBitmaps():Array
	{
		var arr:Array = new Array();

		for (var p:* in swfLoaders)
		{
			var swfLoader:Object = p;
			if (swfLoader)
			{
				var e:MustellaSandboxEvent = new MustellaSandboxEvent(MustellaSandboxEvent.GET_BITMAP);
				e.obj = getSWFLoaderVisibleBounds(swfLoader as DisplayObject);
				swfLoader.contentHolder.contentLoaderInfo.sharedEvents.dispatchEvent(e);
				if (e.obj is Array && e.obj.length > 0)
				{
					arr = arr.concat(e.obj as Array);
				}
			}
		}
		return arr;
	}

	/**
	 *	hide all sandboxed SWFLoaders
	 */
    COMPILE::SWF
	public static function hideSandboxes():void
	{
		for (var p:* in swfLoaders)
		{
			var swfLoader:Object = p;
			if (swfLoader)
			{
				swfLoader.removeChildAt(0);
			}
		}
	}

	/**
	 *	hide all sandboxed SWFLoaders
	 */
    COMPILE::SWF
	public static function showSandboxes():void
	{
		for (var p:* in swfLoaders)
		{
			var swfLoader:Object = p;
			if (swfLoader)
			{
				swfLoader.addChildAt(swfLoader.contentHolder, 0);
			}
		}
	}

    COMPILE::SWF
	private static function getSWFLoaderVisibleBounds(obj:DisplayObject):Object
	{
		var pt:Point = obj.localToGlobal(new Point(0, 0));
		var rect:Rectangle = new Rectangle(pt.x, pt.y, obj.width, obj.height);
		var p:DisplayObject = obj.parent;
		while (rect.width && rect.height)
		{
			pt = p.localToGlobal(new Point(0, 0));
			var prect:Rectangle = new Rectangle(pt.x, pt.y, p.width, p.height);
			if ("viewMetrics" in p)
			{
				var o:Object = p;
				o = o.viewMetrics;
				prect.x += o.left;
				prect.y += o.top;
				prect.width -= o.right;
				prect.height -= o.bottom;
			}
			rect = prect.intersection(rect);
			p = p.parent;
			if (p == _root)
				break;
		}
		return { width: rect.width, height: rect.height };

	}

	/**
	 *  see if sandbox has focus
	 */
	private static function applicationCompleteHandler(event:Event):void
	{
		applicationComplete = true
	}

	/**
	 *  see if sandbox has focus
	 */
    COMPILE::SWF
	private static function sandboxAppReadyHandler(event:Event):void
	{
		// if we sent it, ignore it
		if (event is MustellaSandboxEvent)
			return;

		if (applicationComplete)
		{
			event["obj"] = true;
			return;
		}
	}

	/**
	 *  see if sandbox has focus
	 */
    COMPILE::SWF
	private static function sandboxGetFocusHandler(event:Event):void
	{
		// if we sent it, ignore it
		if (event is MustellaSandboxEvent)
			return;

		if (_root.stage.focus)
		{
			event["obj"] = _root.stage.focus;
			return;
		}

		var focus:InteractiveObject = getFocus();
		if (focus)
			event["obj"] = focus;
	}

	/**
	 *  reset component in sandbox
	 */
    COMPILE::SWF
	private static function sandboxMouseXYHandler(event:Event):void
	{
		// if we sent it, ignore it
		if (event is MustellaSandboxEvent)
			return;

		var eventObj:Object = event;
		var stagePt:Point = Point(eventObj.obj);
		if (stagePt)
		{
			var pt:Point = _root.globalToLocal(stagePt);
			_root[mouseX] = pt.x;
			_root[mouseY] = pt.y;
		}
		else
		{
			_root[mouseX] = undefined;
			_root[mouseY] = undefined;
		}
	}

	/**
	 *  reset component in sandbox
	 */
    COMPILE::SWF
	private static function sandboxResetComponentHandler(event:Event):void
	{
		// if we sent it, ignore it
		if (event is MustellaSandboxEvent)
			return;

		var rc:ResetComponent = new ResetComponent();
		rc.target = Object(event).string;
		rc.className = Object(event).obj;
		sandboxHelper.startTests();

		rc.execute(_root, sandboxHelper, new TestCase(), new TestResult());
	}

	/**
	 *  get bitmap as bytearray
	 */
    COMPILE::SWF
	private static function sandboxGetBitmapHandler(event:Event):void
	{
		// if we sent it, ignore it
		if (event is MustellaSandboxEvent)
			return;

		var arr2:Array = [];

		var data:Object = {};
		var pt:Point = _root.localToGlobal(new Point(0, 0));
		data.x = pt.x;
		data.y = pt.y;
		var bm:BitmapData = new BitmapData(event["obj"].width, event["obj"].height);
		try 
		{
			bm.draw(_root, new Matrix(1, 0, 0, 1, 0, 0));
		}
		catch (se:SecurityError)
		{
			hideSandboxes();
			bm = new BitmapData(event["obj"].width, event["obj"].height);
			showSandboxes();
			arr2 = getSandboxBitmaps(); 
		}
		var arr:Array = [];
		data.bits = bm.getPixels(new Rectangle(0, 0, bm.width, bm.height));
		data.bits.position = 0;
		data.width = bm.width;
		data.height = bm.height;
		arr.push(data);
		event["obj"] = arr.concat(arr2);
	}

	/**
	 *  get bitmap as bytearray
	 */
    COMPILE::SWF
	private static function sandboxGetEffectsHandler(event:Event):void
	{
		// if we sent it, ignore it
		if (event is MustellaSandboxEvent)
			return;

		var effects:Boolean = false;

		var effectMgr:Class = Class(_root["topLevelSystemManager"]["info"]().currentDomain.getDefinition("mx.effects.EffectManager"));
		if (effectMgr)
		{
			effects = effectMgr[effectsInEffect]();
		}
		if (!effects)
		{
			effectMgr = Class(_root["topLevelSystemManager"]["info"]().currentDomain.getDefinition("mx.effects.Tween"));
			if (effectMgr)
			{
				effects = effectMgr[activeTweens].length > 0;
			}
		}
		if (!effects)
			effects = UnitTester.getSandboxedEffects();

		if (effects)
			event["obj"] = true;
	}

	/**
	 *  Handle request from main Mustella UnitTester
	 */
    COMPILE::SWF
	private static function sandboxStringToObjectHandler(event:Event):void
	{
		// if we sent it, ignore it
		if (event is MustellaSandboxEvent)
			return;

		// we got here because someone tried to access .content which is the
		// systemManager so we prepend that since stringToObject always starts
		// with the root.document
		event["obj"] = sandboxHelper.stringToObject(event["string"].length == 0 ? "" : "systemManager." + event["string"]);
	}

	/**
	 *  Handle request from main Mustella UnitTester
	 */
    COMPILE::SWF
	private static function sandboxObjectsUnderPointHandler(event:Event):void
	{
		// if we sent it, ignore it
		if (event is MustellaSandboxEvent)
			return;

		var pt:Point = Object(event).obj as Point;
		var arr:Array = new Array();
		_getObjectsUnderPoint(_root, pt, arr);
		Object(event).obj = arr;
	}

	/**
	 *  Player doesn't handle this correctly so we have to do it ourselves
	 */
    COMPILE::SWF
	private static function _getObjectsUnderPoint(obj:DisplayObject, pt:Point, arr:Array):void
	{
		if (!obj.visible)
			return;

		try
		{
			if (!obj[$visible])
				return;
		}
		catch (e:Error)
		{
		}

		if (obj.hitTestPoint(pt.x, pt.y, true))
		{
			arr.push(obj);
			if (obj is DisplayObjectContainer)
			{
				var doc:DisplayObjectContainer = obj as DisplayObjectContainer;
				if ("rawChildren" in doc)
				{
					var rc:Object = doc["rawChildren"];
					n = rc.numChildren;
					for (i = 0; i < n; i++)
					{
						_getObjectsUnderPoint(rc.getChildAt(i), pt, arr);
					}
				}
				else
				{
					if (doc.numChildren)
					{
						var n:int = doc.numChildren;
						for (var i:int = 0; i < n; i++)
						{
							var child:DisplayObject = doc.getChildAt(i);
							if (swfLoaders[doc] && child is flash.display.Loader)
							{
								// if sandboxed then ask it for its targets
								var e:MustellaSandboxEvent = new MustellaSandboxEvent(MustellaSandboxEvent.GET_OBJECTS_UNDER_POINT);
								e.obj = pt;
								flash.display.Loader(child).contentLoaderInfo.sharedEvents.dispatchEvent(e);
								if (e.obj is Array && e.obj.length > 0)
								{
									// add them and we're done
									var objs:Array = e.obj as Array;
									while (objs.length)
										arr.push(objs.shift());
								}
								else
									_getObjectsUnderPoint(child, pt, arr);
							}
							else
								_getObjectsUnderPoint(child, pt, arr);
						}
					}
				}
			}
		}
	}

	/**
	 *	Whether or not to block focus events
	 */
	public static var blockFocusEvents:Boolean = true;


	/**
	 *	Whether to wait for Excludes to load from a file
	 */
	public static var waitForExcludes:Boolean = false;

	/**
	 *	Whether to wait for Includes to load from a file
	 */
	public static var waitForIncludes:Boolean = false;

	/**
	 *	The handler for blocking focus events
	 */
    COMPILE::SWF
	private static function focusBlockingHandler(event:FocusEvent):void
	{
        // yes, there is a chance that you've clicked on the test
        // just as it is waiting for a focusIn event or
        // deferring focus assignment
        // but I think that's the best we can do for now
        if (waitEvent == "focusIn" || (uiComponentGlobals && uiComponentGlobals.nextFocusObject != null))
            return;
        
		if (blockFocusEvents && event.relatedObject == null)
		{
			event.stopImmediatePropagation();
			// attempt restore focus
			if (event.type == "focusOut")
				_root.stage.focus = InteractiveObject(event.target);
		}
	}

	/**
	 *	Whether or not to block activation events
	 */
	public static var blockActivationEvents:Boolean = true;

	/**
	 *	The handler for blocking activation events
	 */
	private static function activateBlockingHandler(event:Event):void
	{
		if (blockActivationEvents)
		{
			event.stopImmediatePropagation();
		}
	}

	/**
	 *	A simplified callLater mechanism for running our tests
	 */
	public static var callback:Function;

	/**
	 *	The handler for the enter frame
	 */
	private static function enterFrameHandler(event:Event):void
	{
		if (callback != null)
		{
			var cb:Function = callback;
			callback = null;
			cb();
		}
	}

	/**
	 * holder of startEvent occurence
	 */
	public static var sawStartEvent:Boolean = false;

	/**
	 * holder of the event to pass to the real start
	 */
	private static var saveEvent:Event = null;

    COMPILE::SWF
	public static function pre_startEventHandler(event:Event):void 
	{
        if ("topLevelSystemManager" in _root)
    		_root["topLevelSystemManager"].addEventListener("callLaterError", callLaterErrorDefaultHandler, false, -1);

		if (event.type == "applicationComplete")
		{
			sawStartEvent=true;
			saveEvent= event;
		} 
		
		if (sawStartEvent && !waitForExcludes && !waitForIncludes)
		{ 
			startEventHandler (saveEvent);	
		}
	}

	/**
	 *  The handler for the start event that starts the sequence
	 *  of tests.
	 */
    COMPILE::SWF
	public static function startEventHandler(event:Event):void
	{
		var eventScripts:Array = scripts[event.type];
		var actualScripts:Array = [];

		var n:int = eventScripts.length;
		for (var i:int = 0; i < n; i++)
		{
			var name:String = eventScripts[i].scriptName;
			if (includeList)
			{
				if (!includeList[name])
				{
					TestOutput.logResult("Script: " + name + " not in include list but we don't care");
					// continue;
				}
			}
			if (excludeList)
			{
				if (excludeList[name])
				{
					TestOutput.logResult("Script: " + name + " in exclude list");
					continue;
				}
			}
			actualScripts.push(eventScripts[i]);
		}
		var scriptRunner:ScriptRunner = new ScriptRunner();
		scriptRunner.addEventListener("scriptsComplete", scriptsCompleteHandler);
		scriptRunner.scripts = actualScripts;
		if (isApollo && waitForWindow)
		{
			callback = waitForWindowFunction;
			waitForWindowScripts = scriptRunner.runScripts;
		}
		else
			callback = scriptRunner.runScripts;
	}

	/**
	 *	The handler for when the script runner finishes
	 */
    COMPILE::SWF
	private static function scriptsCompleteHandler(event:Event):void
	{
		cleanUpAndExit();
	}
	
    COMPILE::SWF
	private static function cleanUpAndExit():void
	{
		if (pendingOutput > 0)
		{
			if (lastPendingOutput == 0)
				lastPendingOutput = pendingOutput;
			if (pendingOutput == lastPendingOutput)
			{
				if (frameWaitCount < 30) // wait about 30 frames to see if results come back
				{
					trace("waiting on pending output", pendingOutput);
					frameWaitCount++;
					callback = cleanUpAndExit;
					return;
				}
			}
			else
			{
				lastPendingOutput = pendingOutput;
				frameWaitCount = 0;
				callback = cleanUpAndExit;
				return;
			}
		}

		var allDone:Boolean = true;
		var n:int = scripts.length;
		for (var i:int = 0; i < n; i++)
		{
			if (!scripts[i].isDone())
			{
				allDone = false;
				break;
			}
		}
		if (originalRoot)
			_root = originalRoot;

		TestOutput.logResult("ScriptComplete: completely done");
        try {
    		_root[mouseX] = undefined;
	    	_root[mouseY] = undefined;
		    setMouseXY(null);
        } catch (e:Error)
        {
            // not all use cases support this
        }
		_root.removeEventListener("focusIn", focusBlockingHandler, true);
		_root.removeEventListener("focusOut", focusBlockingHandler, true);
		_root.removeEventListener("deactivate", activateBlockingHandler, true);
		_root.removeEventListener("activate", activateBlockingHandler, true);

		/* 
		try
		{
			if (RTESocket)
				RTESocket.close();
		}
		catch (e:Error)
		{
		}
		*/

		if (exitWhenDone) 
		{
			setTimeout(exit, UnitTester.coverageTimeout);				
		}
	}
	
	public static var pendingOutput:int = 0;
	public static var lastPendingOutput:int = 0;
	public static var frameWaitCount:int = 0;
	
	private static var frameCounter:int = 0;

	/**
	 *	the callback that waits for an air window to be created
	 */
    COMPILE::SWF
	private static function waitForWindowFunction():void
	{
		var window:Object = new UnitTester().stringToObject(waitForWindow);
		if (window)
		{
			window.addEventListener("windowComplete", windowCompleteHandler);
			callback = waitForWindowFunction;
			frameCounter++;
			if (frameCounter > 2)	// see code in Window.as enterFrameHandler
			{
				callback = waitForWindowScripts;
				window.removeEventListener("windowComplete", windowCompleteHandler);
				originalRoot = _root;
				_root = window["systemManager"];
			}
		}
		else
			callback = waitForWindowFunction;
	}

	/**
	 *	the callback that waits for an air window to be ready
	 */
    COMPILE::SWF
	private static function windowCompleteHandler(event:Event):void
	{
		callback = waitForWindowScripts;
		event.target.removeEventListener("windowComplete", windowCompleteHandler);
		originalRoot = _root;
		_root = event.target["systemManager"];
	}

    COMPILE::SWF
	public static var exit:Function = function ():void  { fscommand ("quit"); };

    COMPILE::SWF
	private static var layoutManager:QName = new QName(mx_internal, "layoutManager");
    COMPILE::SWF
	private static var getTextField:QName = new QName(mx_internal, "getTextField");
    COMPILE::SWF
	private static var getTextInput:QName = new QName(mx_internal, "getTextInput");
    COMPILE::SWF
	private static var getLabel:QName = new QName(mx_internal, "getLabel");

    COMPILE::SWF
	private static var mouseX:QName = new QName(mx_internal, "_mouseX");
    COMPILE::SWF
	private static var mouseY:QName = new QName(mx_internal, "_mouseY");
    COMPILE::SWF
	private static var $visible:QName = new QName(mx_internal, "$visible");

	/**
	 *  The list of tests to run by start event
	 */
	private static var scripts:Array = new Array();

	/**
	 *  Whether we're running on Apollo. If true, 
	 *  a mixin will set this variable and
	 *  CompareBitmaps will use a static call to Apollo methods
  	 *  to resolve baseline URLs
	 */
	public static var isApollo:Boolean = false;

	/**
	 *  If isApollo=true, then if this is set to a dot-path
	 *  we will wait for the expression to become valid
	 *  and wait for a windowComplete event from the 
	 *  object before actually running the test
	 */
	public static var waitForWindow:String;

	/**
	 *  function to call to run scripts when window is ready
	 */
	private static var waitForWindowScripts:Function;

	/**
	 *  remember the original root
	 */
    COMPILE::SWF
	private static var originalRoot:DisplayObject;

	/**
	 *  Whether to check to see if the test is using
	 *  embedded fonts.  This is set by mixin and is expensive
	 *  so it should only be used when new tests are created.
	 *  This is checked by CompareBitmap.
	 */
	public static var checkEmbeddedFonts:Boolean = false;

	/**
	 *  Whether to save out the bitmaps or compare them
	 *  Default is false, bitmaps are read in from the
	 *  url and compared to the target.
	 *  Include the CreateBitmapReferences class to 
	 *  cause all scripts to write out the target's bitmap
	 *  to the url.
	 */
	public static var createBitmapReferences:Boolean = false;

	/**
	 *  Whether to display additional information during the
	 *  running of a test
	 */
	public static var verboseMode:Boolean = false;

	/**
	 *  Which port to talk to the Runner on
	 *  
	 */
	public static var runnerPort:int = 9999;


	/**
	 *  Whether to close the Standalone player when done
	 *  running the tests
	 */
	public static var exitWhenDone:Boolean = false;

	/**
	 *  Control over the running of a test
	 */
	public static var playbackControl:String = "play";

	/**
	 *  When saving out bitmaps, the server to talk to
	 *  to save them
	 */
	public static var bitmapServerPrefix:String;

	/**
	 *  To upload failed bitmaps, this is the url to talk. Set by SaveBitmapFailure mixin
	 */
	public static var serverCopy:String;


	/**
	 *  To upload failed bitmaps, this is function assembles the url
	 */
	public static function urlAssemble (type:String, testDir:String, testFile:String, testCase:String, run_id:String):String 
	{

		testDir=encodeURIComponent(testDir);
		testFile = encodeURIComponent(testFile);
		testCase = encodeURIComponent(testCase);

		var back:String = "type=" + type + "&testFile="+ testDir + testFile + "&testCase=" + testCase + "&runid=" + run_id;

		return UnitTester.serverCopy + back;



	}

	/**
	 *  currentTestID - a holder for other guys to know what's current
	 */
	public static var currentTestID:String;

	/**
	 *  currentScript - a holder for other guys to know what's current
	 */
	public static var currentScript:String;


	/**
	 *  the root display object (SystemManager)
	 */
    COMPILE::SWF
	public static var _root:DisplayObject;
    COMPILE::JS
    public static var _root:Object;

    /**
     *  the object to use for property lookups in stringToObject
     */
    public static var contextFunction:Function;
    
	/**
	 *  the list of tests to run (if not specified, runs all tests)
	 */
	public static var includeList:Object;

	/**
	 *  the list of tests not to run (if not specified, runs all tests)
	 */
	public static var excludeList:Object;

	/**
	 *  constructor
	 */
	public function UnitTester()
	{
		super();
        COMPILE::SWF
        {
		scriptName = getQualifiedClassName(this);
		if (scriptName.indexOf("::") >= 0)
			scriptName = scriptName.substring(scriptName.indexOf("::") + 2);
        }
			
	}

	//----------------------------------
	//  MXML Descriptor
	//----------------------------------
	
	/**
	 *  The descriptor of MXML children.
	 */
	private var _MXMLDescriptor:Array;
	
	public function get MXMLDescriptor():Array
	{
		return _MXMLDescriptor;
	}
	
	public function setMXMLDescriptor(value:Array):void
	{
		_MXMLDescriptor = value;    
	}
	
	//----------------------------------
	//  MXML Properties
	//----------------------------------
	
	/**
	 *  The attributes of MXML top tag.
	 */
	private var _MXMLProperties:Array;
	
	public function get MXMLProperties():Array
	{
		return _MXMLProperties;
	}
	
	public function setMXMLProperties(value:Array):void
	{
		_MXMLProperties = value;    
	}

	/**
	 *  The name of the script
	 */
	public var scriptName:String;

	/**
	 *  The name of the swf this script test
	 */
	public var testSWF:String;

	/**
	 *  The event to wait for before starting this script
	 */
	public var startEvent:String = "applicationComplete";

	/**
	 *  The list of TestCases
	 */
	public var testCases:Array;

	/**
	 *  The last event object captured in an AssertEvent
	 */
	public var lastEvent:Event;

	/**
	 *  The index into the list of TestCases that we are currently running
	 */
	private var currentIndex:int = 0;

	/**
	 *  overall count of cases excluded, across scripts. Sent with ScriptDone to Runner
	 *  if used. 
	 */
	public static var excludedCount:int = 0;

	/**
	 *  The total number of testCases to run
	 */
	private var numTests:int;

	/**
	 *  a shortcut to the application's variables
	 */
	public function get application():Object
	{
		return _root["document"];
	}

	/**
	 *  take an expression, find the object.
	 *  handles mx_internal:propName
	 *  a.b.c
	 *  getChildAt()
	 */
	public function stringToObject(s:*):Object
	{
        COMPILE::SWF
        {
        var context:Object;
        if (contextFunction != null)
            context = contextFunction();
        else
            context = _root["document"];
        
		if (s == null || s == "")
			return context;

		var original:String = s;

		try
		{
			var propName:* = s;
            /*
			if (s.indexOf("mx_internal:") == 0)
				propName = new QName(mx_internal, s.substring(12));
            */
			if (s.indexOf("getChildAt(") == 0 && s.indexOf(".") == -1)
			{
				s = s.substring(11);
				s = s.substring(0, s.indexOf(")"));
				return context.getChildAt(parseInt(s));
			}
			if (s.indexOf("getLayoutElementAt(") == 0 && s.indexOf(".") == -1)
			{
				s = s.substring(19);
				s = s.substring(0, s.indexOf(")"));
				return context.getLayoutElementAt(parseInt(s));
			}
			if (s.indexOf("getElementAt(") == 0 && s.indexOf(".") == -1)
			{
				s = s.substring(13);
				s = s.substring(0, s.indexOf(")"));
				return context.getElementAt(parseInt(s));
			}
			if (s.indexOf("script:") == 0)
			{
				propName = s.substring(7);
				return this[propName];
			}
			return context[propName];
		}
		catch (e:Error)
		{
			// maybe it is a class
			var dot:int;
			var test:Object;
			var c:int;
			var cc:int = s.indexOf("::");
			var gd:int = -1;
            var className:String = s;
            var obj:Object = context;
            if (cc > 0)
            {
				gd = s.indexOf("getDefinition");
				if (gd == -1)
				{
					dot = s.indexOf(".", cc);
					if (dot >= 0)
					{
						className = s.substring(0, dot);
						s = s.substring(dot + 1);
					}
					else
						s = "";
				}
			}
			else
				dot = s.indexOf(".");

            try
            {
				if (gd == -1)
				{
                    COMPILE::SWF
                    {
					var appdom:ApplicationDomain = _root["info"]().currentDomain;
					if (!appdom)
						appdom = ApplicationDomain.currentDomain;
					obj = appdom.getDefinition(className);
                    }
				}
            }
            catch (e:Error)
            {
				if (dot == -1)
					return null;
            }
            if (dot == -1 && gd == -1)
                return obj;

			//var q:QName = new QName(mx_internal, "contentHolder");
			var list:Array = s.split(".");
			if (list[0].indexOf("script:") == 0)
			{
				obj = this;
				list[0] = list[0].substring(7);
			}
			while (list.length)
			{
				try 
				{
					s = list.shift();
                    /*
					if (s.indexOf("mx_internal:") == 0)
						s = new QName(mx_internal, s.substring(12));
                    */
					if (s is String && s.indexOf("getChildAt(") == 0)
					{
						s = s.substring(11);
						s = s.substring(0, s.indexOf(")"));
						obj = obj.getChildAt(parseInt(s));
					}
					else if (s is String && s.indexOf("getLayoutElementAt(") == 0)
					{
						s = s.substring(19);
						s = s.substring(0, s.indexOf(")"));
						obj = obj.getLayoutElementAt(parseInt(s));
					}
					else if (s is String && s.indexOf("getElementAt(") == 0)
					{
						s = s.substring(13);
						s = s.substring(0, s.indexOf(")"));
						obj = obj.getElementAt(parseInt(s));
					}
					else if (s is String && s == "getTextField()")
					{
						obj = obj[getTextField]();
					}
					else if (s is String && s == "getTextInput()")
					{
						obj = obj[getTextInput]();
					}
					else if (s is String && s == "getLabel()")
					{
						obj = obj[getLabel]();
					}
					else if (s is String && s == "getTextFormat()")
					{
						obj = obj.getTextFormat();
					}
					else if (s is String && s == "getInstance()")
					{
						obj = obj.getInstance();
					}
                    else if (s is String && s == "info()")
                    {
                        obj = obj.info();
                    }
                    else if (s is String && s.indexOf("getDefinition(") == 0)
                    {
                        s = s.substring(14);
						dot = s.indexOf(")");
						while (dot == -1)
						{
							s += "." + list.shift();
							dot = s.indexOf(")");
						}
						s = s.substring(0, dot);
                        obj = obj.getDefinition(s);
                    }
					else
						obj = obj[s];
				}
				catch (se:SecurityError)
				{
					try
					{
						test = obj[q];
					}
					catch (e:Error)
					{
						return null;
					}
					var event:MustellaSandboxEvent = new MustellaSandboxEvent(MustellaSandboxEvent.STRING_TO_OBJECT);
					event.string = list.join(".");
					if (!swfLoaders[obj])
					{
					// cache known swfloaders, associate with string path
						c = original.lastIndexOf(event.string);
						swfLoaders[obj] = original.substr(0, c);
					}
					test.contentLoaderInfo.sharedEvents.dispatchEvent(event);
					return event.obj;
				}
				catch (e:Error)
				{
					return null;
				}
				// hunt for other swfloaders with other application domains
				// we shouldn't get here if the object is in another security domain
				// unless the object is sandboxed but the loading app is coming from file::
				// This also assumes that the test script will access the SWFLoader's contentHolder
				// before doing any steps that require the swfLoaders list to be set up properly
				try 
				{
					test = obj[q];
					if (test is flash.display.Loader)
					{
						if (!swfLoaders[obj])
						{
							var path:String = list.join(".");
							// cache known swfloaders, associate with string path
							c = original.lastIndexOf(path);
							swfLoaders[obj] = original.substr(0, c) + "content";
						}
					}
				}
				catch (e:Error)
				{
				}
			}
			return obj;
		}
        }
		return null;
	}

	/**
	 *  storage for value property
	 */
	private var _value:Object;

	/**
	 *  A variable used to hold results from valueExpressions
	 */
	public function get value():Object
	{
		return _value;
	}

	/**
	 *  A variable used to hold results from valueExpressions
	 */
	public function set value(v:Object):void
	{
		_value = v;
		valueChanged = true;
	}

	/**
	 *  Whether or not the value changed
	 */
	public var valueChanged:Boolean;

	/**
	 *  Whether or not the value changed
	 */
	public function resetValue():void
	{
		valueChanged = false;
		_value = null;

	}

	/**
	 *  The set of display objects at the start of the script.
	 *  Used to clean up by ResetComponent
	 */
    COMPILE::SWF
	public var knownDisplayObjects:Dictionary = new Dictionary(true);

	/**
	 *  A timer used by TestCases to know when to give up waiting for something
	 */
    COMPILE::SWF
	private var timer:Timer;

	/**
	 *  Create a timer that can check every second to see
	 *  if we're hung, and then run the test cases
	 */
    COMPILE::SWF
	public function startTests():void
	{
		var children:Array =  this.MXMLDescriptor;
		if (children)
			generateMXMLInstances(this, children);

		var r:Object = _root;
        if ("topLevelSystemManager" in _root)
        {
    		r = r["topLevelSystemManager"];
	    	r = r.rawChildren;
        }
		var n:int = r.numChildren;
		for (var i:int = 0; i < n; i++)
		{
			knownDisplayObjects[r.getChildAt(i)] = 1;
		}

		if (!timer)
		{
			timer = new Timer(1000);
			timer.start();
		}

		
		// if (RTESocket)
		//	RTESocket.addEventListener(ProgressEvent.SOCKET_DATA, RTEHandler);

        if ("topLevelSystemManager" in _root)
    		_root["topLevelSystemManager"].addEventListener("callLaterError", callLaterErrorHandler);

		if (testCases)
			numTests = testCases.length;

		TestOutput.logResult("LengthOfTestcases: " + numTests);

			
		if (runTests())
			testComplete();
	}

	/**
	 *  The current test that is running
	 */
	public function get currentTest():TestCase
	{
		return testCases[currentIndex];
	}

	/**
	 *  Run the test cases
	 *  Returns false if we have to wait for the TestCase to complete.
	 *  Returns true if no tests required waiting.
	 */
    COMPILE::SWF
	private function runTests():Boolean
	{


		if (testDir == null || testDir == "" )
		{
			testDir="";

		}

		while (currentIndex < numTests)
		{


			if (hasRTE)
			{ 
				break;
			}

			var testCase:TestCase = testCases[currentIndex];

			currentTestID = testCase.testID;

			var testName:String = testDir + scriptName + "$" + testCase.testID;
			currentScript = scriptName;
			if (includeList)
			{
				if (!includeList[testName])
				{
					currentIndex++;
					continue;
				}
			}
			if (excludeList)
			{
				if (excludeList[testName])
				{
					currentIndex++;
					excludedCount++;
					continue;
				}
			} 


			// TestOutput.logResult("TestCase Start: " + testCase.testID);
			TestOutput.logResult("TestCase Start: " + testName);
			// add listener early.  If runTest catches an exception it will call 
			// runCompleteHandler before returning
			testCase.addEventListener("runComplete", runCompleteHandler);
			if (testCase.runTest(_root, timer, this))
			{
				testCase.removeEventListener("runComplete", runCompleteHandler);
				var tr:TestResult = currentTest.testResult;
				if (!tr.hasStatus())
					tr.result = TestResult.PASS;
				if (hasRTE)
					tr.result = TestResult.FAIL;
				tr.endTime = new Date().getTime();
				TestOutput.logResult (tr.toString());
				if (hasRTE)
					return true;
			}
			else
			{
				return false;
			} 
			currentIndex++;

		}
		return true;
	}

	/**
	 *  The handler that receives notice from the current TestCase that it
	 *  is done
	 */
    COMPILE::SWF
	private function runCompleteHandler(event:Event):void
	{

		var tr:TestResult = currentTest.testResult;
		if (!tr.hasStatus())
			tr.result = TestResult.PASS;
		tr.endTime = new Date().getTime();
		TestOutput.logResult (tr.toString());
		currentIndex++;
		if (UnitTester.playbackControl == "play")
			UnitTester.callback = runMoreTests;
		else
			UnitTester.callback = pauseHandler;
	}

    COMPILE::SWF
	private function runMoreTests():void
	{
		if (runTests())
			testComplete();
	}

	/**
	 *  called when test script is finished
	 */
    COMPILE::SWF
	private function testComplete():void
	{
		// if (RTESocket)
		// 	RTESocket.removeEventListener(ProgressEvent.SOCKET_DATA, RTEHandler);

        if ("topLevelSystemManager" in _root)
    		_root["topLevelSystemManager"].removeEventListener("callLaterError", callLaterErrorHandler);
		TestOutput.logResult("testComplete");
		dispatchEvent(new Event("testComplete"));
	}

	/**
	 *  Determines which set of steps (setup, body, cleanup) to run next
	 */
    COMPILE::SWF
	private function pauseHandler():void
	{
		if (UnitTester.playbackControl == "step")
		{
			UnitTester.playbackControl = "pause";
			runMoreTests();
		}
		else if (UnitTester.playbackControl == "play")
			runMoreTests();
		else
			UnitTester.callback = pauseHandler;
	}

    /*
	private function RTEHandler(event:Event):void
	{
		var s:String = RTESocket.readUTFBytes(RTESocket.bytesAvailable);
		TestOutput.logResult("Exception caught by RTE Monitor.");
		var tr:TestResult = currentTest.testResult;
		tr.doFail (s);	
		event.stopImmediatePropagation();

	}

	private static function RTEDefaultHandler(event:Event):void
	{
		var s:String = RTESocket.readUTFBytes(RTESocket.bytesAvailable);
		TestOutput.logResult("Exception caught by RTE Monitor when no tests running.");
		TestOutput.logResult(s);
	}

	private function callLaterErrorHandler(event:Event):void
	{
		var o:Object = event;
		var s:String = o["error"].getStackTrace();
		TestOutput.logResult("Exception caught by CallLater Monitor.");
		var tr:TestResult = currentTest.testResult;
		tr.doFail (s);	
		event.stopImmediatePropagation();

		var appdom:ApplicationDomain = _root["info"]().currentDomain;
		if (!appdom)
			appdom = ApplicationDomain.currentDomain;

		var g:Class = appdom.hasDefinition("mx.core.UIComponentGlobals") ?
                        Class(appdom.getDefinition("mx.core.UIComponentGlobals")) : null;
		if (g)
		{
			o = g[layoutManager];

			while (true)
			{
				try
				{
					o.validateNow();
					break;
				}
				catch (e:Error)
				{
				}
			}
		}

	}

	protected function addMXMLChildren(comps:Array):void
	{
	}
	
	protected function generateMXMLObject(document:Object, data:Array):Object
	{
		var i:int = 0;
		var cls:Class = data[i++];
		var comp:Object = new cls();
		
		var m:int;
		var j:int;
		var name:String;
		var simple:*;
		var value:Object;
		var id:String;
		
		m = data[i++]; // num props
		for (j = 0; j < m; j++)
		{
			name = data[i++];
			simple = data[i++];
			value = data[i++];
			if (simple == null)
				value = generateMXMLArray(document, value as Array);
			else if (simple == false)
				value = generateMXMLObject(document, value as Array);
			if (name == "id")
			{
				document[value] = comp;
				id = value as String;
			}
			else if (name == "_id")
			{
				document[value] = comp;
				id = value as String;
				continue; // skip assignment to comp
			}
			comp[name] = value;
		}
		if (comp is IMXMLObject)
			comp.initialized(document, id);
		return comp;
	}
	
	public function generateMXMLArray(document:Object, data:Array, recursive:Boolean = true):Array
	{
		var comps:Array = [];
		
		var n:int = data.length;
		var i:int = 0;
		while (i < n)
		{
			var cls:Class = data[i++];
			var comp:Object = new cls();
			
			var m:int;
			var j:int;
			var name:String;
			var simple:*;
			var value:Object;
			var id:String = null;
			
			m = data[i++]; // num props
			for (j = 0; j < m; j++)
			{
				name = data[i++];
				simple = data[i++];
				value = data[i++];
				if (simple == null)
					value = generateMXMLArray(document, value as Array, recursive);
				else if (simple == false)
					value = generateMXMLObject(document, value as Array);
				if (name == "id")
					id = value as String;
				if (name == "document" && !comp.document)
					comp.document = document;
				else if (name == "_id")
					id = value as String; // and don't assign to comp
				else
					comp[name] = value;
			}
			m = data[i++]; // num styles
			for (j = 0; j < m; j++)
			{
				name = data[i++];
				simple = data[i++];
				value = data[i++];
				if (simple == null)
					value = generateMXMLArray(document, value as Array, recursive);
				else if (simple == false)
					value = generateMXMLObject(document, value as Array);
				//comp.setStyle(name, value);
			}
			
			m = data[i++]; // num effects
			for (j = 0; j < m; j++)
			{
				name = data[i++];
				simple = data[i++];
				value = data[i++];
				if (simple == null)
					value = generateMXMLArray(document, value as Array, recursive);
				else if (simple == false)
					value = generateMXMLObject(document, value as Array);
				//comp.setStyle(name, value);
			}
			
			m = data[i++]; // num events
			for (j = 0; j < m; j++)
			{
				name = data[i++];
				value = data[i++];
				comp.addEventListener(name, value);
			}
			
			var children:Array = data[i++];
			if (children)
			{
				if (recursive)
					comp.generateMXMLInstances(document, children, recursive);
				else
					comp.setMXMLDescriptor(children);
			}
			
			if (id)
			{
				document[id] = comp;
				mx.binding.BindingManager.executeBindings(document, id, comp); 
			}
			if (comp is IMXMLObject)
				comp.initialized(document, id);
			comps.push(comp);
		}
		return comps;
	}
	
	protected function generateMXMLInstances(document:Object, data:Array, recursive:Boolean = true):void
	{
		var comps:Array = generateMXMLArray(document, data, recursive);
		addMXMLChildren(comps);
	}
	
	protected function generateMXMLAttributes(data:Array):void
	{
		var i:int = 0;
		var m:int;
		var j:int;
		var name:String;
		var simple:*;
		var value:Object;
		var id:String = null;
		
		m = data[i++]; // num props
		for (j = 0; j < m; j++)
		{
			name = data[i++];
			simple = data[i++];
			value = data[i++];
			if (simple == null)
				value = generateMXMLArray(this, value as Array, false);
			else if (simple == false)
				value = generateMXMLObject(this, value as Array);
			if (name == "id")
				id = value as String;
			if (name == "_id")
				id = value as String; // and don't assign
			else
				this[name] = value;
		}
		m = data[i++]; // num styles
		for (j = 0; j < m; j++)
		{
			name = data[i++];
			simple = data[i++];
			value = data[i++];
			if (simple == null)
				value = generateMXMLArray(this, value as Array, false);
			else if (simple == false)
				value = generateMXMLObject(this, value as Array);
			// this.setStyle(name, value);
		}
		
		m = data[i++]; // num effects
		for (j = 0; j < m; j++)
		{
			name = data[i++];
			simple = data[i++];
			value = data[i++];
			if (simple == null)
				value = generateMXMLArray(this, value as Array, false);
			else if (simple == false)
				value = generateMXMLObject(this, value as Array);
			// this.setStyle(name, value);
		}
		
		m = data[i++]; // num events
		for (j = 0; j < m; j++)
		{
			name = data[i++];
			value = data[i++];
			this.addEventListener(name, value as Function);
		}
	}

	mx_internal function setupBindings(bindingData:Array):void
	{
		var fieldWatcher:Object;
		var n:int = bindingData[0];
		var bindings:Array = [];
		var i:int;
		var index:int = 1;
		for (i = 0; i < n; i++)
		{
			var source:Object = bindingData[index++];
			var destFunc:Object = bindingData[index++];
			var destStr:Object = bindingData[index++];
			var binding:Binding = new Binding(this,
				(source is Function) ? source as Function : null,
				(destFunc is Function) ? destFunc as Function : null,
				(destStr is String) ? destStr as String : destStr.join("."),
				(source is Function) ? null : (source is String) ? source as String : source.join("."));
			bindings.push(binding);
		}
		var watchers:Object = decodeWatcher(this, bindingData.slice(index), bindings);
		this["_bindings"] = bindings;
		this["_watchers"] = watchers;
	}
	
	private function decodeWatcher(target:Object, bindingData:Array, bindings:Array):Array
	{
		var watcherMap:Object = {};
		var watchers:Array = [];
		var n:int = bindingData.length;
		var index:int = 0;
		var watcherData:Object;
		var theBindings:Array;
		var bindingIndices:Array;
		var bindingIndex:int;
		var propertyName:String;
		var eventNames:Array;
		var eventName:String;
		var eventObject:Object;
		var getterFunction:Function;
		var value:*;
		var w:Watcher;
		
		while (index < n)
		{
			var watcherIndex:int = bindingData[index++];
			var type:int = bindingData[index++];
			switch (type)
			{
				case 0:
				{
					var functionName:String = bindingData[index++];
					var paramFunction:Function = bindingData[index++];
					value = bindingData[index++];
					if (value is String)
						eventNames = [ value ];
					else
						eventNames = value;
					eventObject = {};
					for each (eventName in eventNames)
						eventObject[eventName] = true;
					value = bindingData[index++];
					if (value is Array)
						bindingIndices = value;
					else
						bindingIndices = [ value ];
					theBindings = [];
					for each (bindingIndex in bindingIndices)
						theBindings.push(bindings[bindingIndex]);
					w = new FunctionReturnWatcher(functionName,
						this,
						paramFunction,
						eventObject,
						theBindings);
					break;
				}
				case 1:
				{
					propertyName = bindingData[index++];
					value = bindingData[index++];
					if (value is String)
						eventNames = [ value ];
					else
						eventNames = value;
					eventObject = {};
					for each (eventName in eventNames)
						eventObject[eventName] = true;
					value = bindingData[index++];
					if (value is Array)
						bindingIndices = value;
					else
						bindingIndices = [ value ];
					theBindings = [];
					for each (bindingIndex in bindingIndices)
						theBindings.push(bindings[bindingIndex]);
					getterFunction = bindingData[index++];
					w = new StaticPropertyWatcher(propertyName, 
						eventObject, theBindings, getterFunction);
					break;
				}
				case 2:
				{
					propertyName = bindingData[index++];
					value = bindingData[index++];
					if (value is String)
						eventNames = [ value ];
					else
						eventNames = value;
					eventObject = {};
					for each (eventName in eventNames)
						eventObject[eventName] = true;
					value = bindingData[index++];
					if (value is Array)
						bindingIndices = value;
					else
						bindingIndices = [ value ];
					theBindings = [];
					for each (bindingIndex in bindingIndices)
						theBindings.push(bindings[bindingIndex]);
					getterFunction = bindingData[index++];
					w = new PropertyWatcher(propertyName, 
						eventObject, theBindings, getterFunction);
					break;
				}
				case 3:
				{
					propertyName = bindingData[index++];
					value = bindingData[index++];
					if (value is Array)
						bindingIndices = value;
					else
						bindingIndices = [ value ];
					theBindings = [];
					for each (bindingIndex in bindingIndices)
						theBindings.push(bindings[bindingIndex]);
					w = new XMLWatcher(propertyName, theBindings);
					break;
				}
			}
			watchers.push(w);
			w.updateParent(target);
			if (target is Watcher)
			{
				if (w is FunctionReturnWatcher)
					FunctionReturnWatcher(w).parentWatcher = Watcher(target);
				Watcher(target).addChild(w);
			}
			
			var children:Array = bindingData[index++];
			if (children != null)
			{
				children = decodeWatcher(w, children, bindings);
			}
		}            
		return watchers;
	}

	private static function callLaterErrorDefaultHandler(event:Event):void
	{
		var o:Object = event;
		var s:String = o["error"].getStackTrace();
		TestOutput.logResult("Exception caught by CallLater Monitor when no tests running.");
		TestOutput.logResult(s);
	}

	private static function RTEIOErrorHandler(event:Event):void
	{
		
	}
    */
    
    COMPILE::SWF
    private static var typeInfoCache:Dictionary;
    
    /**
     * Helper used for object introspection.
     */
    COMPILE::SWF
    public function getTypeInfo(object:*):TypeInfo
    {
        if (UnitTester.typeInfoCache == null)
        {
            UnitTester.typeInfoCache = new Dictionary();
        }
        var className:String = flash.utils.getQualifiedClassName(object);
        var typeInfo:TypeInfo = UnitTester.typeInfoCache[className];
        if (typeInfo == null)
        {
            typeInfo = new TypeInfo(className);
            UnitTester.typeInfoCache[className] = typeInfo;
        }
        return typeInfo;
    }
    
	/**
	 *  Socket used by RTE monitor
	 */
    COMPILE::SWF
	public static var RTESocket:Socket;

	/**
	 *  Socket used by RTE monitor
	 */
    COMPILE::SWF
	public static var RTESocketAddress:String;

}

}
