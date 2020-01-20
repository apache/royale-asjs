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

package mx.modules
{

import mx.containers.VBox;
import mx.core.FlexVersion;
import mx.events.FlexEvent;
import mx.events.ModuleEvent;
import mx.system.ApplicationDomain;

import org.apache.royale.utils.UIModuleUtils;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched when the ModuleLoader starts to load a URL.
 *
 *  @eventType mx.events.FlexEvent.LOADING
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
//[Event(name="loading", type="flash.events.Event")]

/**
 *  Dispatched when the ModuleLoader is given a new URL.
 *
 *  @eventType mx.events.FlexEvent.URL_CHANGED
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
//[Event(name="urlChanged", type="flash.events.Event")]

/**
 *  Dispatched when information about the module is 
 *  available (with the <code>info()</code> method), 
 *  but the module is not yet ready.
 *
 *  @eventType mx.events.ModuleEvent.SETUP
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
//[Event(name="setup", type="mx.events.ModuleEvent")]

/**
 *  Dispatched when the module is finished loading.
 *
 *  @eventType mx.events.ModuleEvent.READY
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
[Event(name="ready", type="mx.events.ModuleEvent")]

/**
 *  Dispatched when the module throws an error.
 *
 *  @eventType mx.events.ModuleEvent.ERROR
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
//[Event(name="error", type="mx.events.ModuleEvent")]

/**
 *  Dispatched at regular intervals as the module loads.
 *
 *  @eventType mx.events.ModuleEvent.PROGRESS
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
[Event(name="progress", type="mx.events.ModuleEvent")]

/**
 *  Dispatched when the module data is unloaded.
 *
 *  @eventType mx.events.ModuleEvent.UNLOAD
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
//[Event(name="unload", type="mx.events.ModuleEvent")]

//--------------------------------------
//  Other metadata
//--------------------------------------

/*   NOTE: This class does not use the "containers" resource bundle. This 
 *   metadata is here to add the "containers" resource bundle to an 
 *   application loading a module. We do this because we know a Module will
 *   pull in the "containers" resource bundle and if the Module uses a resource
 *   bundle that is not already in use it will cause the module to be leaked.
 *
 *   This is only an issue for Spark applications because they do not link in
 *   the CanvasLayout class, which has the "containers" resource bundle. Halo
 *   applications always use the CanvasLayout class. This can be removed
 *   after the module leak caused by the ResourceManager has been fixed.
 *   
 */
//[ResourceBundle("containers")]

// Resource bundles used by this class.
//[ResourceBundle("modules")]

//[IconFile("ModuleLoader.png")]

//[Alternative(replacement="spark.modules.ModuleLoader", since="4.5")]

/**
 *  ModuleLoader is a component that behaves much like a SWFLoader except
 *  that it follows a contract with the loaded content. This contract dictates that the child
 *  SWF file implements IFlexModuleFactory and that the factory
 *  implemented can be used to create multiple instances of the child class
 *  as needed.
 *
 *  <p>The ModuleLoader is connected to deferred instantiation and ensures that
 *  only a single copy of the module SWF file is transferred over the network by using the
 *  ModuleManager singleton.</p>
 *  
 *  <pre>
 *  &lt;mx:ModuleLoader
 *    <strong>Properties</strong>
 *    url="<i>No default</i>"
 *    trustContent="false|true"
 *  
 *    <strong>Events</strong>
 *    error="<i>No default</i>"
 *    loading="<i>No default</i>"
 *    progress="<i>No default</i>"
 *    ready="<i>No default</i>"
 *    setup="<i>No default</i>"
 *    unload="<i>No default</i>"
 *  /&gt;
 *  </pre>
 * 
 *  @see mx.modules.ModuleManager
 *  @see mx.controls.SWFLoader
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
public class ModuleLoader extends VBox
                        // implements IDeferredInstantiationUIComponent
{   
   // include "../core/Version.as";

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
    public function ModuleLoader()
    {
        super();
    }

    private var utils:UIModuleUtils = new UIModuleUtils();
    
    /**
     * These APIs keep properties in ROYALE_CLASS_INFO from being minified.
     * When a module is being loaded, both the loading .js file and the loaded
     * .js file need to have an agreement on which plain object field names
     * can be minified.  If you run into other issues with plain object renaming
     * you can add your own getters.
     */
    private static function get interfaces():Boolean
    {
        return true;
    }
    private static function get qName():Boolean
    {
        return true;
    }
    
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    //private var module:IModuleInfo;

    /**
     *  @private
     */
    private var loadRequested:Boolean = true;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  applicationDomain
    //----------------------------------

    /**
     *  The application domain to load your module into.
     *  Application domains are used to partition classes that are in the same 
     *  security domain. They allow multiple definitions of the same class to 
     *  exist and allow children to reuse parent definitions.
     *  
     *  @see flash.system.ApplicationDomain
     *  @see flash.system.SecurityDomain
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
	 *	@royalesuppresspublicvarwarning
     */
    public var applicationDomain:ApplicationDomain;

    //----------------------------------
    //  child
    //----------------------------------

    /**
     *  The DisplayObject created from the module factory.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
	 *	@royalesuppresspublicvarwarning
     */
    public function get child():Object //DisplayObject
    {
        return utils.moduleInstance;
    }

    //----------------------------------
    //  trustContent
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the trustContent property.
     */
    private var _trustContent:Boolean = false;
    
    [Bindable("trustContentChanged")]
    [Inspectable(defaultValue="false")]
    
    //----------------------------------
    //  url
    //----------------------------------

    /**
     *  The location of the module, expressed as a URL.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function get url():String
    {
        return utils.modulePath + "/" + utils.moduleName + ".swf";
    }

    /**
     *  @private
     */
     public function set url(value:String):void
    {
        //if (value == _url)
        //    return;
		/*
        var wasLoaded:Boolean = false;
        
        if (module)
        {
                    
		   module.removeEventListener(ModuleEvent.PROGRESS,
                                       moduleProgressHandler);
            module.removeEventListener(ModuleEvent.SETUP, moduleSetupHandler);
            module.removeEventListener(ModuleEvent.READY, moduleReadyHandler);
            module.removeEventListener(ModuleEvent.ERROR, moduleErrorHandler);
            module.removeEventListener(ModuleEvent.UNLOAD, moduleUnloadHandler);
		
            module.release();
            module = null;
		
            if (child)
            {
                removeChild(child);
                child = null;
            }
        }
          */
        var c:int = value.lastIndexOf("/");
        if (c == -1)
        {
            utils.modulePath = "";
            utils.moduleName = value.replace(".swf", "");
        }
        else
        {
            utils.modulePath = value.substring(0, c);
            utils.moduleName = value.substring(c + 1).replace(".swf", "");;
        }

        dispatchEvent(new FlexEvent(FlexEvent.URL_CHANGED));

        utils.loadModule(this);
    }
 
}

}
