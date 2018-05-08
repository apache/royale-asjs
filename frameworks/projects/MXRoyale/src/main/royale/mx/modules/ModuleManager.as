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

/* import flash.utils.ByteArray;

 import mx.core.IFlexModuleFactory;
 import mx.events.Request;
*/
/**
 *  The ModuleManager class centrally manages dynamically loaded modules.
 *  It maintains a mapping of URLs to modules.
 *  A module can exist in a state where it is already loaded
 *  (and ready for use), or in a not-loaded-yet state.
 *  The ModuleManager dispatches events that indicate module status.
 *  Clients can register event handlers and then call the 
 *  <code>load()</code> method, which dispatches events when the factory is ready
 *  (or immediately, if it was already loaded).
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class ModuleManager
{
 //   include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Get the IModuleInfo interface associated with a particular URL.
     *  There is no requirement that this URL successfully load,
     *  but the ModuleManager returns a unique IModuleInfo handle for each unique URL.
     *  
     *  @param url A URL that represents the location of the module.
     *  
     *  @return The IModuleInfo interface associated with a particular URL.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function getModule(url:String):IModuleInfo
    {
        return getSingleton().getModule(url);
    }

    /**
     *  @private
     *  Typed as Object, for now. Ideally this should be IModuleManager.
     */
    private static function getSingleton():Object
    {
		if (!ModuleManagerGlobals.managerSingleton)
            ModuleManagerGlobals.managerSingleton = new ModuleManagerImpl(); 
         
        return ModuleManagerGlobals.managerSingleton;
    }
}

} 
	
    import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;  
	import mx.modules.IModuleInfo;
	import org.apache.royale.events.ProgressEvent; 
	import mx.events.ModuleEvent;
/*
import flash.display.Loader;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;
import flash.system.Security;
import flash.system.SecurityDomain;
import flash.utils.ByteArray;
import flash.utils.Dictionary;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;

import mx.core.IFlexModuleFactory;
import mx.events.ModuleEvent;
import mx.modules.IModuleInfo;
*/
////////////////////////////////////////////////////////////////////////////////
//
//  Helper class: ModuleManagerImpl
//
////////////////////////////////////////////////////////////////////////////////
// import mx.events.Request;

/**
 *  @private
 *  ModuleManagerImpl is the Module Manager singleton,
 *  hidden from direct access by the ModuleManager class.
 *  See the documentation for ModuleManager for the details on this class.
 */
class ModuleManagerImpl extends EventDispatcher
{
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
    public function ModuleManagerImpl()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
  // private var moduleDictionary:Dictionary = new Dictionary(true);

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    public function getModule(url:String):IModuleInfo
    {
         var info:ModuleInfo = null;
       /*
        for (var m:Object in moduleDictionary)
        {
            var mi:ModuleInfo = m as ModuleInfo;
            if (moduleDictionary[mi] == url)
            {
                info = mi;
                break;
            }
        }

        if (!info)
        {
            info = new ModuleInfo(url);
            moduleDictionary[info] = url;
        } 
		*/

        return new ModuleInfoProxy(info);
    }
}

////////////////////////////////////////////////////////////////////////////////
//
//  Helper class: ModuleInfo
//
////////////////////////////////////////////////////////////////////////////////


/**
 *  @private
 *  The ModuleInfo class encodes the loading state of a module.
 *  It isn't used directly, because there needs to be only one single
 *  ModuleInfo per URL, even if that URL is loaded multiple times,
 *  yet individual clients need their own dedicated events dispatched
 *  without re-dispatching to clients that already received their events.
 *  ModuleInfoProxy holds the public IModuleInfo implementation
 *  that can be externally manipulated.
 */
class ModuleInfo extends EventDispatcher
{
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
    public function ModuleInfo(url:String)
    {
        super();

        _url = url;
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
  //  private var factoryInfo:FactoryInfo;

    /**
     *  @private
     */
   //private var loader:Loader;

    /**
     *  @private
     */
    private var numReferences:int = 0;

    /**
     *  @private
     */
 //   private var parentModuleFactory:IFlexModuleFactory;
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  applicationDomain
    //----------------------------------

    /**
     *  @private
     */
	/*
    public function get applicationDomain():ApplicationDomain
    {
        return factoryInfo ? factoryInfo.applicationDomain : null;
    }
	*/
    //----------------------------------
    //  error
    //----------------------------------

    /**
     *  @private
     *  Storage for the error property.
     */
    private var _error:Boolean = false;

    /**
     *  @private
     */
    public function get error():Boolean
    {
        return _error;
    }

    //----------------------------------
    //  factory
    //----------------------------------

    /**
     *  @private
     */
	/*
   public function get factory():IFlexModuleFactory
    {
        return factoryInfo ? factoryInfo.factory : null;
    }
	*/
    //----------------------------------
    //  loaded
    //----------------------------------

    /**
     *  @private
     *  Storage for the loader property.
     */
    private var _loaded:Boolean = false;

    /**
     *  @private
     */
    public function get loaded():Boolean
    {
        return _loaded;
    }

    //----------------------------------
    //  ready
    //----------------------------------

    /**
     *  @private
     *  Storage for the ready property.
     */
    private var _ready:Boolean = false;

    /**
     *  @private
     */
    public function get ready():Boolean
    {
        return _ready;
    }

    //----------------------------------
    //  setup
    //----------------------------------

    /**
     *  @private
     *  Storage for the setup property.
     */
    private var _setup:Boolean = false;

    /**
     *  @private
     */
    public function get setup():Boolean
    {
        return _setup;
    }

    //----------------------------------
    //  size
    //----------------------------------

    /**
     *  @private
     */
	 /*
    public function get size():int
    {
        return factoryInfo ? factoryInfo.bytesTotal : 0;
    }
	*/

    //----------------------------------
    //  url
    //----------------------------------

    /**
     *  @private
     *  Storage for the url property.
     */
    private var _url:String;

    /**
     *  @private
     */
    public function get url():String
    {
        return _url;
    }

   
}

////////////////////////////////////////////////////////////////////////////////
//
//  Helper class: FactoryInfo
//
////////////////////////////////////////////////////////////////////////////////

/**
 *  @private
 *  Used for weak dictionary references to a GC-able module.
 */
class FactoryInfo
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
 
    public function FactoryInfo()
    {
        super();
    }
 
     
}

////////////////////////////////////////////////////////////////////////////////
//
//  Helper class: ModuleInfoProxy
//
////////////////////////////////////////////////////////////////////////////////

/**
 *  @private
 *  ModuleInfoProxy implements IModuleInfo and allows each caller of load()
 *  to have their own dedicated module events, while still using the same
 *  backing load state.
 */
class ModuleInfoProxy extends EventDispatcher implements IModuleInfo
{
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
    public function ModuleInfoProxy(info:ModuleInfo)
    {
        super();

        this.info = info;
		/*
        info.addEventListener(ModuleEvent.SETUP, moduleEventHandler, false, 0, true);
        info.addEventListener(ModuleEvent.PROGRESS, moduleEventHandler, false, 0, true);
        info.addEventListener(ModuleEvent.READY, moduleEventHandler, false, 0, true);
        info.addEventListener(ModuleEvent.ERROR, moduleEventHandler, false, 0, true);
        info.addEventListener(ModuleEvent.UNLOAD, moduleEventHandler, false, 0, true);*/
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private var info:ModuleInfo;

    /**
     *  @private
     */
    private var referenced:Boolean = false;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  data
    //----------------------------------

    /**
     *  @private
     *  Storage for the data property.
     */
    private var _data:Object;

    /**
     *  @private
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
    }

    //----------------------------------
    //  error
    //----------------------------------

    /**
     *  @private
     */
    public function get error():Boolean
    {
        return info.error;
    }

    
    //----------------------------------
    //  loaded
    //----------------------------------

    /**
     *  @private
     */
    public function get loaded():Boolean
    {
        return info.loaded;
    }

    //----------------------------------
    //  ready
    //----------------------------------

    /**
     *  @private
     */
    public function get ready():Boolean
    {
        return info.ready;
    }

    //----------------------------------
    //  setup
    //----------------------------------

    /**
     *  @private
     */
    public function get setup():Boolean
    {
        return info.setup;
    }

    //----------------------------------
    //  url
    //----------------------------------

    /**
     *  @private
     */
    public function get url():String
    {
        return info.url;
    }

     
}
