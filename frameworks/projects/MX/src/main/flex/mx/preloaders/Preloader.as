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

package mx.preloaders
{

COMPILE::SWF
{
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;		
}
COMPILE::JS
{
	import flex.display.DisplayObject;
	import flex.display.MovieClip;
	import flex.display.Sprite;
	import flex.events.Event;
	import flex.events.IEventDispatcher;
	import flex.events.IOErrorEvent;
	import flex.events.ProgressEvent;
	import flex.events.TimerEvent;
	
	import org.apache.flex.utils.Timer;		
}

import flex.system.DefinitionManager;

COMPILE::LATER
{
import mx.core.RSLItem;
import mx.core.RSLListLoader;
import mx.core.ResourceModuleRSLItem;
import mx.events.RSLEvent;
import mx.managers.SystemManagerGlobals;
import mx.resources.IResourceManager;
}
import mx.core.mx_internal;
import mx.events.FlexEvent;

use namespace mx_internal;

/**
 *  The Preloader class is used by the SystemManager to monitor
 *  the download and initialization status of a Flex application.
 *  It is also responsible for downloading the runtime shared libraries (RSLs).
 *
 *  <p>The Preloader class instantiates a download progress bar, 
 *  which must implement the IPreloaderDisplay interface, and passes download
 *  and initialization events to the download progress bar.</p>
 *
 *  @see mx.preloaders.DownloadProgressBar
 *  @see mx.preloaders.Preloader
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class Preloader extends Sprite
{
    include "../core/Version.as";

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
    public function Preloader()
    {
        super()
    }   
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private var displayClass:IPreloaderDisplay = null;
    
    /**
     *  @private
     */
    private var timer:Timer;
    
    /**
     *  @private
     */
    private var showDisplay:Boolean;
    
    /**
     *  @private
     */
	COMPILE::LATER
    private var rslListLoader:RSLListLoader;
    
    /**
     *  @private
     */
	COMPILE::LATER
    private var resourceModuleListLoader:RSLListLoader;

    /**
     *  @private
     */
    private var rslDone:Boolean = false;
    
    /**
     *  @private
     */
    private var loadingRSLs:Boolean = false;

    /**
     *  @private
     */
    private var waitingToLoadResourceModules:Boolean = false;

    /**
     *  @private
     */
    private var sentDocFrameReady:Boolean = false;

    /**
     *  @private
     */
    private var app:IEventDispatcher = null;
    
    /**
     *  @private
     */
    private var applicationDomain:DefinitionManager = null;
    
    /**
     *  @private
     */
    private var waitedAFrame:Boolean = false;

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

	COMPILE::LATER
	public function initialize(showDisplay:Boolean, 
							   displayClassName:Class,
							   backgroundColor:uint,
							   backgroundAlpha:Number,
							   backgroundImage:Object,
							   backgroundSize:String,
							   displayWidth:Number,
							   displayHeight:Number,
							   libs:Array = null,
							   sizes:Array = null,
							   rslList:Array = null,
							   resourceModuleURLs:Array = null,
							   applicationDomain:DefinitionManager = null):void
	{
		
	}
	
    /**  
     *  Called by the SystemManager to initialize a Preloader object.
     * 
     *  @param showDisplay Determines if the display class should be displayed.
     *
     *  @param displayClassName The IPreloaderDisplay class to use
     *  for displaying the preloader status.
     *
     *  @param backgroundColor Background color of the application.
     *
     *  @param backgroundAlpha Background alpha of the application.
     *
     *  @param backgroundImage Background image of the application.
     *
     *  @param backgroundSize Background size of the application.
     *
     *  @param displayWidth Width of the application.
     *
     *  @param displayHeight Height of the application.
     *
     *  @param libs Array of string URLs for the runtime shared libraries.
     *
     *  @param sizes Array of uint values containing the byte size for each URL
     *  in the libs argument
     * 
     *  @param rslList Array of object of type RSLItem and CdRSLItem.
     *  This array describes all the RSLs to load.
     *  The libs and sizes parameters are ignored and must be set to null.
     *
     *  @param resourceModuleURLs Array of Strings specifying URLs
     *  from which to preload resource modules.
     *
     *  @param applicationDomain The application domain in which 
     *  your code is executing.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */ 
    public function initialize(showDisplay:Boolean, 
                               displayClassName:Class,
                               backgroundColor:uint,
                               backgroundAlpha:Number,
                               backgroundImage:Object,
                               backgroundSize:String,
                               displayWidth:Number,
                               displayHeight:Number,
                               libs:Array = null,
                               sizes:Array = null):void
    {
		COMPILE::LATER
		{
        if ((libs != null || sizes != null) && rslList != null)
        {
            // both args can't be used at the same time
            throw new Error("RSLs may only be specified by using libs and sizes or rslList, not both.");  // $NON-NLS-1$
        }
		}

        this.applicationDomain = applicationDomain;

		COMPILE::SWF
		{
			root.loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);				
		}
    
        var n:int;
        var i:int;
        
		COMPILE::LATER
		{
        // Store the RSL information.
        // Keep this code for API backwards compatibility
        if (libs && libs.length > 0)
        {
            if (rslList == null)
            {
                rslList = [];
            }
    
            n = libs.length;
            for (i = 0; i < n; i++)
            {
                var node:RSLItem = new RSLItem(libs[i]);
                rslList.push(node);
            }
        }

        var resourceModuleList:Array = [];
        // Preloading resource modules is similar enough to loading RSLs
        // that we can simply create ResourceModuleRSLItems for them
        if (resourceModuleURLs && resourceModuleURLs.length > 0)
        {
            n = resourceModuleURLs.length;
            for (i = 0; i < n; i++)
            {
                var resourceModuleNode:ResourceModuleRSLItem =
                    new ResourceModuleRSLItem(resourceModuleURLs[i], applicationDomain);
                resourceModuleList.push(resourceModuleNode);
            }
        }

        rslListLoader = new RSLListLoader(rslList);
        if (resourceModuleList.length)
            resourceModuleListLoader = new RSLListLoader(resourceModuleList);
		}
        this.showDisplay = showDisplay;

        // Create the timer (really should be adding event listeners to root.LoaderInfo)    
        timer = new Timer(10);
        timer.addEventListener(TimerEvent.TIMER, timerHandler);
        timer.start();
        
        // Create a new instance of the display class and attach it to the stage
        if (showDisplay)
        {
            displayClass = new displayClassName(); 
            // Listen for when the displayClass no longer needs to be on the stage
            displayClass.addEventListener(Event.COMPLETE,
                                          displayClassCompleteHandler);
            
            // Add the display class as a child of the Preloader
            addChild(DisplayObject(displayClass));
                        
            displayClass.backgroundColor = backgroundColor;
            displayClass.backgroundAlpha = backgroundAlpha;
            displayClass.backgroundImage = backgroundImage;
            displayClass.backgroundSize = backgroundSize;
            displayClass.stageWidth = displayWidth;
            displayClass.stageHeight = displayHeight;
            displayClass.initialize();  
            displayClass.preloader = this;
            
            // Listen for ENTER_FRAME to make sure that we are going to render the displayClass first,
            // before dispatching PRELOADER_DOC_FRAME_READY. This way we the run-time can render
            // the displayClass as soon as possible, before advancing onto frame 2.
            CONFIG::performanceInstrumentation
            {
                import mx.utils.PerfUtil;
                PerfUtil.getInstance().markTime("Preloader.displayClass created");
            }
            this.addEventListener(Event.ENTER_FRAME, waitAFrame);
        }   
        
		COMPILE::LATER
		{
        // move below showDisplay so error messages can be displayed
        if (rslListLoader.getItemCount() > 0)
        {
            // Start loading the RSLs.
            rslListLoader.load(rslProgressHandler,
                               rslCompleteHandler,
                               rslErrorHandler,
                               rslErrorHandler,
                               rslErrorHandler);
            loadingRSLs = true;
        }
        else if (resourceModuleListLoader && resourceModuleListLoader.getItemCount() > 0)
        {
            if (applicationDomain.hasDefinition("mx.resources::ResourceManager"))
            {
                rslListLoader = resourceModuleListLoader;
                // Start loading the resourceModules
                rslListLoader.load(rslProgressHandler,
                                   rslCompleteHandler,
                                   rslErrorHandler,
                                   rslErrorHandler,
                                   rslErrorHandler);
            }
            else
            {
                waitingToLoadResourceModules = true;
                rslDone = true;
            }
        }
        else
        {
            rslDone = true;
        }
		}
    }
    
    /**
     *  Called by the SystemManager after it has finished instantiating
     *  an instance of the application class. Flex calls this method; you 
     *  do not call it yourself.
     *
     *  @param app The application object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function registerApplication(app:IEventDispatcher):void
    {
        // Listen for events from the application.
        app.addEventListener("validatePropertiesComplete", appProgressHandler);
        app.addEventListener("validateSizeComplete", appProgressHandler);
        app.addEventListener("validateDisplayListComplete", appProgressHandler);
        app.addEventListener(FlexEvent.CREATION_COMPLETE, appCreationCompleteHandler);
        
        // Cache for later cleanup.
        this.app = app;
    }
    
    
    /**
     *  @private
     *  Return the number of bytes loaded and total for the SWF and any RSLs.
     */
    private function getByteValues():Object
    {
		COMPILE::SWF
		{
			var li:LoaderInfo = root.loaderInfo;
			var loaded:int = li.bytesLoaded;
			var total:int = li.bytesTotal;				
		}
		COMPILE::JS
		{
			var loaded:int = 100;
			var total:int = 100;				
		}
		COMPILE::LATER
		{
        // Look up the rsl bytes and include those
        var n:int = rslListLoader ? rslListLoader.getItemCount() : 0;
        for (var i:int = 0; i < n; i++)
        {
            loaded += rslListLoader.getItem(i).loaded;

            // If the rsl total is zero then provide an average rsl size
            // to set rough expectations.
            var rslTotal:int = rslListLoader.getItem(i).total;
            total += rslTotal;
        }
		}
        
        return { loaded: loaded, total: total };
    }
    
    /**
     *  @private
     */
    private function dispatchAppEndEvent(event:Object = null):void
    {
        // Dispatch the application initialization end event
        dispatchEvent(new FlexEvent(FlexEvent.INIT_COMPLETE));
        
        if (!showDisplay)
            displayClassCompleteHandler(null);
    }
    
    /**
     *  @private
     *  We don't listen for the events directly
     *  because we don't know which RSL is sending the event.
     *  So we have the RSLNode listen to the events
     *  and then pass them along to the Preloader.
     */ 
	COMPILE::LATER
    mx_internal function rslProgressHandler(event:ProgressEvent):void
    {
        var index:int = rslListLoader.getIndex();
        var item:RSLItem = rslListLoader.getItem(index);
        
        
        var rslEvent:RSLEvent = new RSLEvent(RSLEvent.RSL_PROGRESS);
        rslEvent.isResourceModule = (rslListLoader == resourceModuleListLoader);
        rslEvent.bytesLoaded = event.bytesLoaded;
        rslEvent.bytesTotal = event.bytesTotal;
        rslEvent.rslIndex = index;
        rslEvent.rslTotal = rslListLoader.getItemCount();
        rslEvent.url = item.urlRequest;
        dispatchEvent(rslEvent);
    }

    
    /**
     *  @private
     *  Load the next RSL in the list and dispatch an event.
     */
	COMPILE::LATER
    mx_internal function rslCompleteHandler(event:Event):void
    {
        var index:int = rslListLoader.getIndex();
        var item:RSLItem = rslListLoader.getItem(index);

        var rslEvent:RSLEvent = new RSLEvent(RSLEvent.RSL_COMPLETE);
        rslEvent.isResourceModule = (rslListLoader == resourceModuleListLoader);
        rslEvent.bytesLoaded = item.total;
        rslEvent.bytesTotal = item.total;
        rslEvent.loaderInfo = event.target as LoaderInfo;
        rslEvent.rslIndex = index;
        rslEvent.rslTotal = rslListLoader.getItemCount();
        rslEvent.url = item.urlRequest;
        dispatchEvent(rslEvent);
        
        if (loadingRSLs && resourceModuleListLoader && index + 1 == rslEvent.rslTotal)
        {
            loadingRSLs = false;
            waitingToLoadResourceModules = true;
            // timer will switch over to loading resource modules
        }

        rslDone = (index + 1 == rslEvent.rslTotal);
    }
        
    
    /**
     *  @private
     */
	COMPILE::LATER
    mx_internal function rslErrorHandler(event:ErrorEvent):void
    {
        // send an error event
        var index:int = rslListLoader.getIndex();
        var item:RSLItem = rslListLoader.getItem(index);
        var rslEvent:RSLEvent = new RSLEvent(RSLEvent.RSL_ERROR);
        rslEvent.isResourceModule = (rslListLoader == resourceModuleListLoader);
        rslEvent.bytesLoaded = 0;
        rslEvent.bytesTotal = 0;
        rslEvent.rslIndex = index;
        rslEvent.rslTotal = rslListLoader.getItemCount();
        rslEvent.url = item.urlRequest;
        rslEvent.errorText = decodeURI(event.text);
        dispatchEvent(rslEvent);

    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Listen or poll for progress events and dispatch events
     *  describing the current state of the download
     */
    private function timerHandler(event:TimerEvent):void
    {
        // loaded swfs may not have root right away
        if (!root)
            return;

        var bytes:Object = getByteValues();
        var loaded:int = bytes.loaded;
        var total:int = bytes.total;
        
        // Dispatch a progress event (later we might conditionalize this
        // so that it isn't sent on a cache load).
        dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS,
                                        false, false, loaded, total));

		COMPILE::LATER
		{
        if (waitingToLoadResourceModules)
        {
            if (applicationDomain.hasDefinition("mx.resources::ResourceManager"))
            {
                waitingToLoadResourceModules = false;
                rslListLoader = resourceModuleListLoader;
                rslDone = false;
                // Start loading the resourceModules
                rslListLoader.load(rslProgressHandler,
                                   rslCompleteHandler,
                                   rslErrorHandler,
                                   rslErrorHandler,
                                   rslErrorHandler);
            }
        }
		}

        // Check if we are finished
        if (rslDone &&
            ((loaded >= total && total > 0) || (total == 0 && loaded > 0) || (root is MovieClip && (MovieClip(root).totalFrames > 2) && (MovieClip(root).framesLoaded >= 2)) ))
        {
            if (!sentDocFrameReady)
            {
                // If there's a displayClass, don't send the PRELOADER_DOC_FRAME_READY 
                // event before we render at least one frame
                if (showDisplay && !waitedAFrame)
                    return;

                sentDocFrameReady = true;
                // Dispatch a Frame1 done event.
                dispatchEvent(new FlexEvent(FlexEvent.PRELOADER_DOC_FRAME_READY));
                return;
            }

			COMPILE::LATER
			{
            if (waitingToLoadResourceModules)
            {
                if (applicationDomain.hasDefinition("mx.resources::ResourceManager"))
                {
                    waitingToLoadResourceModules = false;
                    rslListLoader = resourceModuleListLoader;
                    rslDone = false;
                    // Start loading the resourceModules
                    rslListLoader.load(rslProgressHandler,
                                       rslCompleteHandler,
                                       rslErrorHandler,
                                       rslErrorHandler,
                                       rslErrorHandler);
                    return;
                }
            }

            if (resourceModuleListLoader)
            {
                var resourceManager:IResourceManager;
                // do this to prevent dependency on ResourceManager
                if (applicationDomain.hasDefinition("mx.resources::ResourceManager"))
                {
                    var resourceManagerClass:Class = 
                        Class(applicationDomain.getDefinition("mx.resources::ResourceManager"));
                    resourceManager = 
                        IResourceManager(resourceManagerClass["getInstance"]());
                }
                // The FlashVars of the SWF's HTML wrapper,
                // or the query parameters of the SWF URL,
                // can specify the ResourceManager's localeChain.
                var localeChainList:String =  
                    SystemManagerGlobals.parameters["localeChain"];
                if (localeChainList != null && localeChainList != "")
                    resourceManager.localeChain = localeChainList.split(",");
            }            
			}
            timer.removeEventListener(TimerEvent.TIMER, timerHandler);
            
            // Stop the timer.
            timer.reset();
        
            // Dispatch a complete event.
            dispatchEvent(new Event(Event.COMPLETE));
            
            // Dispatch an initProgress event.
            dispatchEvent(new FlexEvent(FlexEvent.INIT_PROGRESS));

        }
    }

    /**
     *  @private
     */
    private function ioErrorHandler(event:IOErrorEvent):void
    {
        // Ignore the event
    }

    /**
     *  @private
     *  Called when the displayClass has finished animating
     *  and no longer needs to be displayed.
     */
    private function displayClassCompleteHandler(event:Event):void
    {
        // Cleanup
        if (displayClass)
            displayClass.removeEventListener(Event.COMPLETE, displayClassCompleteHandler);
        
		COMPILE::SWF
		{
        if (root) 
            root.loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		
        if (app) 
        {
            app.removeEventListener("validatePropertiesComplete", appProgressHandler);
            app.removeEventListener("validateSizeComplete", appProgressHandler);
            app.removeEventListener("validateDisplayListComplete", appProgressHandler);
            app.removeEventListener(FlexEvent.CREATION_COMPLETE, appCreationCompleteHandler);
            app = null;
        }
            
        // Send an event to the SystemManager that we are completely finished
        dispatchEvent(new FlexEvent(FlexEvent.PRELOADER_DONE));
    }
        
    /**
     *  @private
     */
    private function appCreationCompleteHandler(event:FlexEvent):void
    {       
        dispatchAppEndEvent();
    }
    
    /**
     *  @private
     */
    private function appProgressHandler(event:Event):void
    {       
        dispatchEvent(new FlexEvent(FlexEvent.INIT_PROGRESS));
    }

    /**
     *  @private
     */
    private function waitAFrame(event:Event):void
    {
        CONFIG::performanceInstrumentation
        {
            mx.utils.PerfUtil.getInstance().markTime("Preloader.displayClass rendered");
        }

        this.removeEventListener(Event.ENTER_FRAME, waitAFrame);
        waitedAFrame = true;
    }

}

}

