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

package mx.managers.systemClasses
{

COMPILE::SWF
{
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.events.IEventDispatcher;
import flex.events.FlashEventConverter;
}
COMPILE::JS
{
	import flex.display.DisplayObject;
	import flex.display.DisplayObjectContainer;
	import flex.display.InteractiveObject;
	import flex.events.IEventDispatcher;	
}

import mx.core.IFlexDisplayObject;
import mx.core.IFlexModule;
import mx.core.IFlexModuleFactory;
import mx.core.IFontContextComponent;
import mx.core.IInvalidating;
import mx.core.IUIComponent;
import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.events.FlexEvent;
import mx.managers.ILayoutManagerClient;
import mx.managers.ISystemManager;
import mx.managers.ISystemManagerChildManager;
import mx.managers.SystemManager;
COMPILE::LATER
{
import mx.messaging.config.LoaderConfig;
}
import mx.preloaders.Preloader;
import mx.styles.ISimpleStyleClient;
import mx.styles.IStyleClient;
import mx.utils.LoaderUtil;

use namespace mx_internal;

[ExcludeClass]

public class ChildManager implements ISystemManagerChildManager
{
    include "../../core/Version.as";

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
	 */
	public function ChildManager(systemManager:IFlexModuleFactory)
	{
		super();

		if (systemManager is ISystemManager)
		{
            systemManager["childManager"] = this;
            this.systemManager = ISystemManager(systemManager);
            this.systemManager.registerImplementation("mx.managers::ISystemManagerChildManager", this);
		}
	}

	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	private var systemManager:ISystemManager;


	//--------------------------------------------------------------------------
	//
	//  Methods: Child management
	//
	//--------------------------------------------------------------------------

	/**
     *  @private
     */
	public function addingChild(child:DisplayObject):void
	{
		var newNestLevel:int = 1;
		
		// non-top level system managers may not be able to reference their parent if
		// they are a proxy for popups.
		if (!topLevel && DisplayObject(systemManager).parent)
		{
			// non-topLevel SystemManagers are buried by Flash.display.Loader and
			// other non-framework layers so we have to figure out the nestlevel
			// by searching up the parent chain.
			var obj:DisplayObjectContainer = DisplayObject(systemManager).parent.parent;
			while (obj)
			{
				if (obj is ILayoutManagerClient)
				{
					newNestLevel = ILayoutManagerClient(obj).nestLevel + 1;
					break;
				}
				obj = obj.parent;
			}
		}
		nestLevel = newNestLevel;

		if (child is IUIComponent)
			IUIComponent(child).systemManager = systemManager;

		// If the document property isn't already set on the child,
		// set it to be the same as this component's document.
		// The document setter will recursively set it on any
		// descendants of the child that exist.
		if (child is IUIComponent &&
			!IUIComponent(child).document)
		{
			IUIComponent(child).document = systemManager.document;
		}

        // Set the moduleFactory to the child, but don't overwrite an existing moduleFactory.
        if (child is IFlexModule && IFlexModule(child).moduleFactory == null)
            IFlexModule(child).moduleFactory = systemManager;

        // Set the font context in non-UIComponent children.
        // UIComponent children use moduleFactory.
        if (child is IFontContextComponent && !child is UIComponent &&
            IFontContextComponent(child).fontContext == null)
            IFontContextComponent(child).fontContext = systemManager;
        
		// Set the nestLevel of the child to be one greater
		// than the nestLevel of this component.
		// The nestLevel setter will recursively set it on any
		// descendants of the child that exist.
		if (child is ILayoutManagerClient)
        	ILayoutManagerClient(child).nestLevel = nestLevel + 1;

		COMPILE::LATER
		{
		if (child is InteractiveObject)
			if (InteractiveObject(systemManager).doubleClickEnabled)
				InteractiveObject(child).doubleClickEnabled = true;
		}
		
		if (child is IUIComponent)
			IUIComponent(child).parentChanged(DisplayObjectContainer(systemManager));

		// Sets up the inheritingStyles and nonInheritingStyles objects
		// and their proto chains so that getStyle() works.
		// If this object already has some children,
		// then reinitialize the children's proto chains.
        if (child is IStyleClient)
			IStyleClient(child).regenerateStyleCache(true);

		if (child is ISimpleStyleClient)
			ISimpleStyleClient(child).styleChanged(null);

        if (child is IStyleClient)
			IStyleClient(child).notifyStyleChangeInChildren(null, true);

		// Need to check to see if the child is an UIComponent
		// without actually linking in the UIComponent class.
		if (child is UIComponent)
			UIComponent(child).initThemeColor();

		// Inform the component that it's style properties
		// have been fully initialized. Most components won't care,
		// but some need to react to even this early change.
		if (child is UIComponent)
			UIComponent(child).stylesInitialized();
	}

	/**
	 *  @private
	 */
	public function childAdded(child:DisplayObject):void
	{
        if (child.hasEventListener(FlexEvent.ADD))
		    child.dispatchEvent(new FlexEvent(FlexEvent.ADD));

		if (child is IUIComponent)
			IUIComponent(child).initialize(); // calls child.createChildren()
	}

	/**
     *  @private
     */
	public function removingChild(child:DisplayObject):void
	{
        if (child.hasEventListener(FlexEvent.REMOVE))
		    child.dispatchEvent(new FlexEvent(FlexEvent.REMOVE));
	}

	/**
     *  @private
     */
	public function childRemoved(child:DisplayObject):void
	{
		if (child is IUIComponent)
			IUIComponent(child).parentChanged(null);
	}

	//--------------------------------------------------------------------------
	//
	//  Methods: Styles
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 *  Call regenerateStyleCache() on all children of this SystemManager.
	 *  If the recursive parameter is true, continue doing this
	 *  for all descendants of these children.
	 */
	public function regenerateStyleCache(recursive:Boolean):void
	{
		var foundTopLevelWindow:Boolean = false;

		var n:int = systemManager.rawChildren.numChildren;
		for (var i:int = 0; i < n; i++)
		{
			var child:IStyleClient =
				systemManager.rawChildren.getChildAt(i) as IStyleClient;

			if (child)
				child.regenerateStyleCache(recursive);

			if (isTopLevelWindow(DisplayObject(child)))
				foundTopLevelWindow = true;

			// Refetch numChildren because notifyStyleChangedInChildren()
			// can add/delete a child and therefore change numChildren.
			n = systemManager.rawChildren.numChildren;
		}

		// During startup the top level window isn't added
		// to the child list until late into the startup sequence.
		// Make sure we call regenerateStyleCache()
		// on the top level window even if it isn't a child yet.
		if (!foundTopLevelWindow && topLevelWindow is IStyleClient)
			IStyleClient(topLevelWindow).regenerateStyleCache(recursive);
	}

	/**
	 *  @private
	 *  Call styleChanged() and notifyStyleChangeInChildren()
	 *  on all children of this SystemManager.
	 *  If the recursive parameter is true, continue doing this
	 *  for all descendants of these children.
	 */
	public function notifyStyleChangeInChildren(styleProp:String,
													 recursive:Boolean):void
	{
		var foundTopLevelWindow:Boolean = false;

		var n:int = systemManager.rawChildren.numChildren;
		for (var i:int = 0; i < n; i++)
		{
			var child:IStyleClient =
				systemManager.rawChildren.getChildAt(i) as IStyleClient;

			if (child)
			{
				child.styleChanged(styleProp);
				child.notifyStyleChangeInChildren(styleProp, recursive);
			}

			if (isTopLevelWindow(DisplayObject(child)))
				foundTopLevelWindow = true;

			// Refetch numChildren because notifyStyleChangedInChildren()
			// can add/delete a child and therefore change numChildren.
			n = systemManager.rawChildren.numChildren;
		}

		// During startup the top level window isn't added
		// to the child list until late into the startup sequence.
		// Make sure we call notifyStyleChangeInChildren()
		// on the top level window even if it isn't a child yet.
		if (!foundTopLevelWindow && topLevelWindow is IStyleClient)
		{
			IStyleClient(topLevelWindow).styleChanged(styleProp);
			IStyleClient(topLevelWindow).notifyStyleChangeInChildren(
				styleProp, recursive);
		}
	}

	/**
	 *  @private
	 *  Instantiates an instance of the top level window
	 *  and adds it as a child of the SystemManager.
	 */
	public function initializeTopLevelWindow(width:Number, height:Number):void
	{
        CONFIG::performanceInstrumentation
        {
            var perfUtil:mx.utils.PerfUtil = mx.utils.PerfUtil.getInstance();
            perfUtil.markTime("ChildManager.initializeTopLevelWindow().start");
            perfUtil.markTime("SystemManager.create().start");
        }
        
		var app:IUIComponent;
        if (!systemManager.document)
        {
    		// Create a new instance of the toplevel class
            systemManager.document = app = topLevelWindow = IUIComponent(systemManager.create());
        }
        else
            app = topLevelWindow = systemManager.document as IUIComponent;

		COMPILE::SWF
		{
			FlashEventConverter.setupAllConverters(app as DisplayObject);
		}			

        CONFIG::performanceInstrumentation
        {
            perfUtil.markTime("SystemManager.create().end");
        }        

		if (systemManager.document)
		{
			// Add listener for the creationComplete event
			IEventDispatcher(app).addEventListener(FlexEvent.CREATION_COMPLETE,
												   appCreationCompleteHandler);
        }
        
		COMPILE::LATER
		{
		// if somebody has set this in our applicationdomain hierarchy, don't overwrite it
		if (!LoaderConfig._url)
		{
			LoaderConfig._url = LoaderUtil.normalizeURL(systemManager.loaderInfo);
			LoaderConfig._parameters = systemManager.loaderInfo.parameters;
            LoaderConfig._swfVersion = systemManager.loaderInfo.swfVersion;
        }
		}
		
		IFlexDisplayObject(app).setActualSize(width, height);

		// Wait for the app to finish its initialization sequence
		// before doing an addChild(). 
		// Otherwise, the measurement/layout code will cause the
		// player to do a bunch of unnecessary screen repaints,
		// which slows application startup time.
		
		// Pass the application instance to the preloader.
		// Note: preloader can be null when the user chooses
		// Control > Play in the standalone player.
		if (preloader)
			preloader.registerApplication(app);
					
		// The Application doesn't get added to the SystemManager in the standard way.
		// We want to recursively create the entire application subtree and process
		// it with the LayoutManager before putting the Application on the display list.
		// So here we what would normally happen inside an override of addChild().
		// Leter, when we actually attach the Application instance,
		// we call super.addChild(), which is the bare player method.
		addingChild(DisplayObject(app));

        CONFIG::performanceInstrumentation
        {
            perfUtil.markTime("Application.createChildren().start");
        }
        
        childAdded(DisplayObject(app)); // calls app.createChildren()

        CONFIG::performanceInstrumentation
        {
            perfUtil.markTime("Application.createChildren().end");
        }
    
        CONFIG::performanceInstrumentation
        {
            perfUtil.markTime("ChildManager.initializeTopLevelWindow().end");
        }
	}
	
 	/**
	 *  Override this function if you want to perform any logic
	 *  when the application has finished initializing itself.
	 */
	private function appCreationCompleteHandler(event:FlexEvent):void
	{
		if (!topLevel && DisplayObject(systemManager).parent)
		{
			var obj:DisplayObjectContainer = DisplayObject(systemManager).parent.parent;
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
 	}

    //--------------------------------------------------------------------------
    //
    //  Methods to implement SystemManager methods
    //
    //  systemManager may be a SystemManager or WindowedSystemManager
    //  so we use the array access operertor to get at the methods/properties.  
    //  
    //--------------------------------------------------------------------------

    private function isTopLevelWindow(object:DisplayObject):Boolean
    {
        return systemManager["isTopLevelWindow"](object);
    }    
    

    private function get topLevel():Boolean
    {
        return systemManager["topLevel"];
    }    
    
    private function set topLevel(topLevel:Boolean):void
    {
        systemManager["topLevel"] = topLevel;
    }    

    private function get topLevelWindow():IUIComponent
    {
        return systemManager["topLevelWindow"]; 	
    }
    
    private function set topLevelWindow(window:IUIComponent):void
    {
        systemManager["topLevelWindow"] = window;     
    }

    private function get nestLevel():int
    {
        return systemManager["nestLevel"];     
    }   
    
    private function set nestLevel(level:int):void
    {
        systemManager["nestLevel"] = level;     
    }

    private function get preloader():Preloader
    {
        return systemManager["preloader"];     
    }   
    
    private function set preloader(preloader:Preloader):void
    {
        systemManager["preloader"] = preloader;     
    } 
}

}


