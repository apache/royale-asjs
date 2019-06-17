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

package mx.resources
{

import org.apache.royale.events.Event;
import org.apache.royale.events.EventDispatcher;
import org.apache.royale.events.IEventDispatcher;
import org.apache.royale.utils.LocaleUtils;
import org.apache.royale.reflection.getDefinitionByName;
/*
import flash.events.FocusEvent;
import flash.events.TimerEvent;
import flash.system.ApplicationDomain;
import flash.system.Capabilities;
import flash.system.SecurityDomain;
import flash.utils.Dictionary;
import flash.utils.Timer;
*/
import mx.core.IFlexModuleFactory;
import mx.core.mx_internal;
//import mx.core.Singleton;
import mx.events.FlexEvent;
import mx.events.ModuleEvent;
//import mx.events.ResourceEvent;
import mx.managers.SystemManagerGlobals;
import mx.modules.IModuleInfo;
import mx.modules.ModuleManager;
import mx.utils.StringUtil;


use namespace mx_internal;

/**
 *  @copy mx.resources.IResourceManager#change
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="change", type="org.apache.royale.events.Event")]

[ExcludeClass]

/**
 *  @private
 *  This class provides an implementation of the IResourceManager interface.
 *  The IResourceManager and IResourceBundle interfaces work together
 *  to provide internationalization support for Flex applications.
 *
 *  <p>A single instance of this class manages all localized resources
 *  for a Flex application.</p>
 *  
 *  @see mx.resources.IResourceManager
 *  @see mx.resources.IResourceBundle
 */
public class ResourceManagerImpl extends EventDispatcher implements IResourceManager
{
//    include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  The sole instance of the ResourceManager.
     */
    private static var instance:IResourceManager;
    
    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Gets the single instance of the ResourceManagerImpl class.
     *  This object manages all localized resources for a Flex application.
     *  
     *  @return An object implementing IResourceManager.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function getInstance():IResourceManager
    {
        if (!instance)
            instance = new ResourceManagerImpl();

        return instance;
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
    public function ResourceManagerImpl()
    {
        super();

        if (SystemManagerGlobals.topLevelSystemManagers.length)
        {
            if (SystemManagerGlobals.topLevelSystemManagers[0].currentFrame == 1)
            {
                ignoreMissingBundles = true;
				inFrame1 = true;
                /* figure this out later, if needed
                SystemManagerGlobals.topLevelSystemManagers[0].
                    addEventListener(Event.ENTER_FRAME, enterFrameHandler);
                */
            }
        }
        
        var info:Object = SystemManagerGlobals.info;
		// Falcon injects this property and it is always false
		// We ignore missing bundles because Falcon doesn't
		// generate fallback bundles like MXMLC;
		if (!inFrame1)
			ignoreMissingBundles = info && info.hasOwnProperty("isMXMLC");
		
        if (info)
            processInfo(info, false);

        ignoreMissingBundles = info && info.hasOwnProperty("isMXMLC");
        
        /*
        if (SystemManagerGlobals.topLevelSystemManagers.length)
		    SystemManagerGlobals.topLevelSystemManagers[0].
			    addEventListener(FlexEvent.NEW_CHILD_APPLICATION, newChildApplicationHandler);
        */
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

	/**
	 *  @private
	 * 
	 *  Whether or ignoreMissingBundles was set in frame 1
	 */
	private var inFrame1:Boolean = false;
	
    /**
     *  @private
     * 
     *  Whether or not to throw an error.
     */
    private var ignoreMissingBundles:Boolean = false;
    
    /**
     *  @private
     * 
     *  The dictionary to hold all of the weak reference resource bundles.
    private var bundleDictionary:Dictionary;
     */
    
    /**
     *  @private
     *  A map whose keys are locale strings like "en_US"
     *  and whose values are "bundle maps".
     *  A bundle map is a map whose keys are bundle names
     *  like "SharedResources" and whose values are ResourceBundle instances.
     *  You can get to an individual resource value like this:
     *  localeMap["en_US"]["SharedResources"].content["currencySymbol"]
     */
    private var localeMap:Object = {};
    
    /**
     *  @private
     *  A map whose keys are URLs for resource modules that have been loaded
     *  and whose values are ResourceModuleInfo instances for those modules.
     */
    private var resourceModules:Object = {};

    /**
     *  @private
     */
    private var initializedForNonFrameworkApp:Boolean = false;
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  localeChain
    //----------------------------------

    /**
     *  @private
     *  Storage for the localeChain property.
     */
    private var _localeChain:Array /* of String */;
    
    /**
     *  @copy mx.resources.IResourceManager#localeChain
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get localeChain():Array /* of String */
    {
        return _localeChain;
    }
    
    /**
     *  @private
     */
    public function set localeChain(value:Array /* of String */):void
    {
        _localeChain = value;
        
        update();
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  This method is called by the SystemManager class of an Application
     *  when the application starts.
     *  It is also called by the FlexModuleFactory class of a code module
     *  when that module gets loaded.
     *
     *  The MXML compiler autogenerated code which set the
     *  "compiledLocales" and "compiledResourceBundleNames" properties
     *  of the info() Object required by the IFlexModuleFactory
     *  interface that these classes implement.
     *  These two properties together indicate which resource bundle
     *  classes the MXML compiler autogenerated and linked into the
     *  application or module.
     *
     *  The "compiledLocales" property has been set to the locales
     *  which were specified at compile time using the -locale option.
     *  For example, if you compile with -locale=en_US,ja_JP
     *  then the "compiledLocales" property is the array [ "en_US", "ja_JP" ].
     *
     *  The "compiledResourceBundleNames" property has been set
     *  to the names of the resource bundles which are used by
     *  the application or module, as determined by the compiler
     *  from [ResourceBundle] metadata and ~~Resource() directives.
     *  For example, if the classes in the application or module
     *  declare that they use resource bundles named "core" and "MyApp",
     *  then the "compiledResourceBundleNames" property is the array
     *  [ "core", "MyApp" ].
     *
     *  The compiler autogenerated a ResourceBundle subclass for each
     *  (locale, bundle name) pair.
     *  For example, with the above locales and bundle names,
     *  there would be four classes:
     *    en_US$core_properties
     *    en_US$MyApp_properties
     *    ja_JP$core_properties
     *    ja_JP$MyApp_properties
     *
     *  This method creates one instance of each such class
     *  and installs it into the ResourceManager with addResourceBundle().
     *  If a bundle for a given locale and bundle name already exists
     *  in the ResourceManager already exists, it does not get replaced.
     *  This can happen when a code module gets loaded into an application.
     * 
     *  When sub-applications and modules install their resource bundles 
     *  they set useWeakReference = true. Any new resource bundles they 
     *  create will be weak referenced by the ResourceManager. The 
     *  sub-application or module will then provide a hard reference
     *  to the returned Array of resource bundles to keep them from 
     *  being garbage collected.
     */
    public function installCompiledResourceBundles(
                                /* applicationDomain:ApplicationDomain,*/
                                locales:Array /* of String */,
                                bundleNames:Array /* of String */,
                                useWeakReference:Boolean = false):Array
    {
        //trace("locales", locales);
        //trace("bundleNames", bundleNames);
        var bundles:Array = [];
        var bundleCount:uint = 0;
        var n:int = locales ? locales.length : 0;
        var m:int = bundleNames ? bundleNames.length : 0;

        // Loop over the locales.
        for (var i:int = 0; i < n; i++)
        {
            var locale:String = locales[i];
            
            // Loop over the bundle names.
            for (var j:int = 0; j < m; j++)
            {
                var bundleName:String = bundleNames[j];
                
                var bundle:IResourceBundle = installCompiledResourceBundle(
                    /*applicationDomain,*/ locale, bundleName, 
                    useWeakReference);
                
                if (bundle)
                    bundles[bundleCount++] = bundle;
            }
        }
        
        return bundles;
    }

    /**
     *  @private
     *  @royaleignorecoercion Class
     */
    private function installCompiledResourceBundle(
                                /*applicationDomain:ApplicationDomain,*/
                                locale:String, bundleName:String,
                                useWeakReference:Boolean = false):IResourceBundle
    {
        var packageName:String = null;
        var localName:String = bundleName;
        var colonIndex:int = bundleName.indexOf(":");
        if (colonIndex != -1)
        {
            packageName = bundleName.substring(0, colonIndex);
            localName = bundleName.substring(colonIndex + 1);
        }

        // If a bundle with that locale and bundle name already exists
        // in the ResourceManager, don't replace it.
        // If we want to install a  weakReferenceDictionary then don't rely on
        // a weak reference dictionary because it may go way when the 
        // application goes away.
        var resourceBundle:IResourceBundle = getResourceBundleInternal(locale,
                                                    bundleName, 
                                                    useWeakReference);
        if (resourceBundle)
            return resourceBundle;
        
        // The autogenerated resource bundle classes produced by the
        // mxmlc and compc compilers have names that incorporate
        // the locale and bundle name, such as "en_US$core_properties".
        var resourceBundleClassName:String =
            locale + "$" + localName + "_properties";
        if (packageName != null)
            resourceBundleClassName = packageName + "." + resourceBundleClassName;
                
        // Find the bundle class by its name.
        // We do a hasDefinition() check before calling getDefinition()
        // because getDefinition() will throw an RTE
        // if the class doesn't exist.
        var bundleClass:Class = null;
        bundleClass = getDefinitionByName(resourceBundleClassName) as Class;

        if (!bundleClass)
        {
            resourceBundleClassName = bundleName;
            bundleClass = getDefinitionByName(resourceBundleClassName) as Class;
        }
        
        // In case we linked against a Flex 2 SWC, look for the old
        // class name.
        if (!bundleClass)
        {
            resourceBundleClassName = bundleName + "_properties";
            bundleClass = getDefinitionByName(resourceBundleClassName) as Class;
        }
        
        if (!bundleClass)
        {
            if (ignoreMissingBundles)
                return null;
            
            throw new Error(
                "Could not find compiled resource bundle '" + bundleName +
                "' for locale '" + locale + "'.");
        }
        
        // Create a proxy
        var proxy:ResourceBundleProxy = new ResourceBundleProxy();
        
		proxy.bundleClass = bundleClass;
		proxy.useWeakReference = useWeakReference;

        // In case we just created a ResourceBundle from a Flex 2 SWC,
        // set its locale and bundleName, because the old constructor
        // didn't used to do this.
        proxy.locale = locale;
        proxy.bundleName = bundleName;
                
        // Add that resource bundle instance to the ResourceManager.
        resourceBundle = proxy;
        addResourceBundle(resourceBundle, useWeakReference);
        
        return resourceBundle;
    }
    
    /*
    // FocusEvent is used just so we can add a relatedObject
	private function newChildApplicationHandler(event:FocusEvent):void
	{
		var info:Object = event.relatedObject["info"]();
        var weakReference:Boolean = false;
        if ("_resourceBundles" in event.relatedObject)
            weakReference = true;
        
        // If the application has a "_resourceBundles" object for us to put
        // the bundles into then we will. Otherwise have the ResourceManager
        // create a hard reference to the resources.
        var bundles:Array = processInfo(info, weakReference);
        if (weakReference)
            event.relatedObject["_resourceBundles"] = bundles;
    }
    */
		
    private function processInfo(info:Object, useWeakReference:Boolean):Array
    {
		var compiledLocales:Array = info["compiledLocales"];

		ResourceBundle.locale =
			compiledLocales != null && compiledLocales.length > 0 ?
			compiledLocales[0] :
			"en_US";

        /*
		var applicationDomain:ApplicationDomain = info["currentDomain"];
        */

		var compiledResourceBundleNames:Array /* of String */ =
			info["compiledResourceBundleNames"];
		
		var bundles:Array = installCompiledResourceBundles(
			/*applicationDomain,*/ compiledLocales, compiledResourceBundleNames,
            useWeakReference);

		// If the localeChain wasn't specified in the FlashVars of the SWF's
		// HTML wrapper, or in the query parameters of the SWF URL,
		// then initialize it to the list of compiled locales,
        // sorted according to the system's preferred locales as reported by
        // Capabilities.languages or Capabilities.language.
		// For example, if the applications was compiled with, say,
		// -locale=en_US,ja_JP and Capabilities.languages reports [ "ja-JP" ],
        // set the localeChain to [ "ja_JP" "en_US" ].
		if (!localeChain)
			initializeLocaleChain(compiledLocales);

        return bundles;
	}

    /**
     *  @copy mx.resources.IResourceManager#initializeLocaleChain()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function initializeLocaleChain(compiledLocales:Array):void
    {
        localeChain = LocaleSorter.sortLocalesByPreference(
            compiledLocales, getSystemPreferredLocales(), null, true);
    }

    /**
     *  @copy mx.resources.IResourceManager#loadResourceModule()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
    public function loadResourceModule(url:String, updateFlag:Boolean = true,
                                       applicationDomain:ApplicationDomain = null,
                                       securityDomain:SecurityDomain = null):
                                       IEventDispatcher
    {
        var moduleInfo:IModuleInfo = ModuleManager.getModule(url);

        // Create the per-load IEventDispatcher that we'll return.
        var resourceEventDispatcher:ResourceEventDispatcher =
            new ResourceEventDispatcher(moduleInfo);

        // Set up a handler for the "ready" event from the module.
        // We use a local Function rather than a method
        // so that it can access the 'update' argument.
        var readyHandler:Function = function(event:ModuleEvent):void
        {
            //trace("readyHandler");

            var resourceModule:* = // IResourceModule
                event.module.factory.create();
        
            //dumpResourceModule(resourceModule);
        
            resourceModules[event.module.url].resourceModule = resourceModule;

            if (updateFlag)
                update();
        };
        moduleInfo.addEventListener(ModuleEvent.READY, readyHandler,
                                    false, 0, true);

        // Set up a handler for the "error" event from the module.
        // We use a local Function rather than a method
        // for symmetry with the readyHandler.
        var errorHandler:Function = function(event:ModuleEvent):void
        {
            var message:String = "Unable to load resource module from " + url;

            if (resourceEventDispatcher.willTrigger(ResourceEvent.ERROR))
            {
                var resourceEvent:ResourceEvent = new ResourceEvent(
                    ResourceEvent.ERROR, event.bubbles, event.cancelable);
                resourceEvent.bytesLoaded = 0;
                resourceEvent.bytesTotal = 0;
                resourceEvent.errorText = message;
                resourceEventDispatcher.dispatchEvent(resourceEvent);
            }
            else
            {
                throw new Error(message);
            }
        };
        moduleInfo.addEventListener(ModuleEvent.ERROR, errorHandler,
                                    false, 0, true);

        resourceModules[url] =
            new ResourceModuleInfo(moduleInfo, readyHandler, errorHandler);

        // This Timer gives the loadResourceModules() caller a chance
        // to add event listeners to the return value, before the module
        // is loaded.
        // We use a local Function for the timerHandler rather than a method
        // so that it can access the 'moduleInfo' local var.
        var timer:Timer = new Timer(0);
        var timerHandler:Function = function(event:TimerEvent):void
        {
            timer.removeEventListener(TimerEvent.TIMER, timerHandler);
            timer.stop();
            
            //trace("loading");

            // Start loading the module.
            moduleInfo.load(applicationDomain, securityDomain);
        };
        timer.addEventListener(TimerEvent.TIMER, timerHandler,
                               false, 0, true);
        timer.start();
        
        return resourceEventDispatcher;
    }
     */

    /**
     *  @copy mx.resources.IResourceManager#unloadResourceModule()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
    public function unloadResourceModule(url:String, update:Boolean = true):void
    {
        // Get the resource module info.
        var rmi:ResourceModuleInfo = resourceModules[url];        
        if (!rmi)
            return;
        
        if (rmi.resourceModule)
        {
            // Get the bundles in this module.
            var bundles:Array = rmi.resourceModule.resourceBundles;
            if (bundles)
            {
               var n:int = bundles.length;
               for (var i:int = 0; i < n; i++)
               {
                   // Remove each bundle.
                   var locale:String = bundles[i].locale;
                   var bundleName:String = bundles[i].bundleName;
                   removeResourceBundle(locale, bundleName);
               }
            }
        }

        // Remove all links to the module.
        resourceModules[url] = null;
        delete resourceModules[url];
        
        // Unload the module.
        rmi.moduleInfo.unload();
        
        // Update if necessary.
        if (update)
            this.update();
    }
     */
 
    /**
     *  @copy mx.resources.IResourceManager#addResourceBundle()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function addResourceBundle(resourceBundle:IResourceBundle, 
                                      useWeakReference:Boolean = false):void
    {
        var locale:String = resourceBundle.locale;
        var bundleName:String = resourceBundle.bundleName;
        
        if (!localeMap[locale])
            localeMap[locale] = {};
            
        if (useWeakReference)
        {
            /*
            if (!bundleDictionary)
            {
                bundleDictionary = new Dictionary(true);
            }
            
            bundleDictionary[resourceBundle] = locale + bundleName;
            localeMap[locale][bundleName] = bundleDictionary;
            */
        }
        else
        {
            localeMap[locale][bundleName] = resourceBundle;
        }
    }
    
    /**
     *  @copy mx.resources.IResourceManager#getResourceBundle()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getResourceBundle(locale:String,
                                      bundleName:String):IResourceBundle
    {
        return getResourceBundleInternal(locale, bundleName, false);
    }
    
    /**
     *  @private
     *  
     *  @param ignoreWeakReferenceBundles if true, do not search weak
     *  reference bundles.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private function getResourceBundleInternal(locale:String,
                                      bundleName:String,
                                      ignoreWeakReferenceBundles:Boolean):IResourceBundle
    {
        var bundleMap:Object = localeMap[locale];
        if (!bundleMap)
            return null;
           
        var bundle:IResourceBundle = null;
        var bundleObject:Object = bundleMap[bundleName];
        /*
        if (bundleObject is Dictionary)
        {
            if (ignoreWeakReferenceBundles)
                return null;
            
            var localeBundleNameString:String = locale + bundleName;
            for (var obj:Object in bundleObject)
            {
                if (bundleObject[obj] == localeBundleNameString)
                {
					if (obj is ResourceBundleProxy)
						bundle = loadResourceBundleProxy(ResourceBundleProxy(obj));
					else 
						bundle = obj as IResourceBundle;
                    break;
                }
            }
        }
        else*/ if (bundleObject is ResourceBundleProxy)
        {
        	bundle = loadResourceBundleProxy(ResourceBundleProxy(bundleObject));
        }
        else 
        {
            bundle = bundleObject as IResourceBundle;
        }
        
        return bundle;
    }
    
    private function loadResourceBundleProxy(proxy:ResourceBundleProxy):ResourceBundle {
    	var proxyClass:Class = proxy.bundleClass;
        var resourceBundle:ResourceBundle = ResourceBundle(new proxyClass());
   		resourceBundle._locale = proxy.locale;
    	resourceBundle._bundleName = proxy.bundleName;
    	
    	addResourceBundle(resourceBundle, proxy.useWeakReference);
    	
    	return resourceBundle;
    }
    
    /**
     *  @copy mx.resources.IResourceManager#removeResourceBundle()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function removeResourceBundle(locale:String, bundleName:String):void
    {
        // Remove the specified bundle.
        delete localeMap[locale][bundleName];

        // If that leaves a locale node with no bundles,
        // delete the locale node.
        if (getBundleNamesForLocale(locale).length == 0)
            delete localeMap[locale];
    }
    
    /**
     *  @copy mx.resources.IResourceManager#removeResourceBundlesForLocale()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function removeResourceBundlesForLocale(locale:String):void
    {
        delete localeMap[locale];
    }
    
    /**
     *  @copy mx.resources.IResourceManager#update()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function update():void
    {
        dispatchEvent(new Event(Event.CHANGE));
    }

    /**
     *  @copy mx.resources.IResourceManager#getLocales()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getLocales():Array /* of String */
    {
        var locales:Array = [];
        for (var p:String in localeMap)
        {
            locales.push(p);
        }
        return locales;
    }

    /**
     *  @copy mx.resources.IResourceManager#getPreferredLocaleChain()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getPreferredLocaleChain():Array /* of String */
    {
        return LocaleSorter.sortLocalesByPreference(
            getLocales(), getSystemPreferredLocales(), null, true);
    }
    
    /**
     *  @copy mx.resources.IResourceManager#getBundleNamesForLocale()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getBundleNamesForLocale(locale:String):Array /* of String */
    {
        var bundleNames:Array = [];
        for (var p:String in localeMap[locale])
        {
            bundleNames.push(p);
        }
        return bundleNames;
    }

    /**
     *  @copy mx.resources.findResourceBundleWithResource
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     * 
     *  @royaleignorecoercion mx.resources.IResourceBundle
     */
    public function findResourceBundleWithResource(
                        bundleName:String, resourceName:String):IResourceBundle
    {
        if (!_localeChain)
            return null;
        
        var n:int = _localeChain.length;
        for (var i:int = 0; i < n; i++)
        {
            var locale:String = localeChain[i];
            
            var bundleMap:Object = localeMap[locale];
            if (!bundleMap)
                continue;
            
            var bundleObject:Object = bundleMap[bundleName];
            if (!bundleObject)
                continue;
                
            var bundle:IResourceBundle = null;
            
            /*if (bundleObject is Dictionary)
            {
                var localeBundleNameString:String = locale + bundleName;
                for (var obj:Object in bundleObject)
                {
                    if (bundleObject[obj] == localeBundleNameString)
                    {
						if (obj is ResourceBundleProxy)
							bundle = loadResourceBundleProxy(ResourceBundleProxy(obj));
						else 
							bundle = obj as IResourceBundle;
                        break;
                    }
                }
            }
            else*/ if (bundleObject is ResourceBundleProxy)
            {
        		bundle = loadResourceBundleProxy(ResourceBundleProxy(bundleObject));
            }
            else 
            {
                bundle = bundleObject as IResourceBundle;
            }
                
            if (bundle && resourceName in bundle.content)
                return bundle;
        }

        return null;
    }

    [Bindable("change")]
    
    /**
     *  @copy mx.resources.IResourceManager#getObject()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getObject(bundleName:String, resourceName:String,
                              locale:String = null):*
    {
        var resourceBundle:IResourceBundle =
            findBundle(bundleName, resourceName, locale);
        if (!resourceBundle)
            return undefined;

        return resourceBundle.content[resourceName];
    }
    
    [Bindable("change")]
    
    /**
     *  @copy mx.resources.IResourceManager#getString()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getString(bundleName:String, resourceName:String,
                              parameters:Array = null,
                              locale:String = null):String
    {
        var resourceBundle:IResourceBundle = findBundle(bundleName, resourceName, locale);
        if (!resourceBundle)
            return null;
        
        if(!(resourceName in resourceBundle.content))
            return null;

        var value:String = String(resourceBundle.content[resourceName]);
        
        if (parameters)
            value = StringUtil.substitute(value, parameters);
            
        return value;
    }
    
    [Bindable("change")]
    
    /**
     *  @copy mx.resources.IResourceManager#getStringArray()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getStringArray(bundleName:String,
                                   resourceName:String,
                                   locale:String = null):Array /* of String */
    {
        var resourceBundle:IResourceBundle =
            findBundle(bundleName, resourceName, locale);
        if (!resourceBundle)
            return null;

        var value:* = resourceBundle.content[resourceName];
        
        var array:Array = String(value).split(",");
        
        var n:int = array.length;
        for (var i:int = 0; i < n; i++)
        {
             array[i] = StringUtil.trim(array[i]);
        }  
        
        return array;
    }
    
    [Bindable("change")]
    
    /**
     *  @copy mx.resources.IResourceManager#getNumber()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getNumber(bundleName:String, resourceName:String,
                              locale:String = null):Number
    {
        var resourceBundle:IResourceBundle =
            findBundle(bundleName, resourceName, locale);
        if (!resourceBundle)
            return NaN;

        var value:* = resourceBundle.content[resourceName];
        
        return Number(value);
    }
    
    [Bindable("change")]
    
    /**
     *  @copy mx.resources.IResourceManager#getInt()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getInt(bundleName:String, resourceName:String,
                           locale:String = null):int
    {
        var resourceBundle:IResourceBundle =
            findBundle(bundleName, resourceName, locale);
        if (!resourceBundle)
            return 0;

        var value:* = resourceBundle.content[resourceName];

        return int(value);
    }
    
    [Bindable("change")]
    
    /**
     *  @copy mx.resources.IResourceManager#getUint()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getUint(bundleName:String, resourceName:String,
                            locale:String = null):uint
    {
        var resourceBundle:IResourceBundle =
            findBundle(bundleName, resourceName, locale);
        if (!resourceBundle)
            return 0;

        var value:* = resourceBundle.content[resourceName];

        return uint(value);
    }
    
    [Bindable("change")]
    
    /**
     *  @copy mx.resources.IResourceManager#getBoolean()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getBoolean(bundleName:String, resourceName:String,
                               locale:String = null):Boolean
    {
        var resourceBundle:IResourceBundle =
            findBundle(bundleName, resourceName, locale);
        if (!resourceBundle)
            return false;

        var value:* = resourceBundle.content[resourceName];

        return String(value).toLowerCase() == "true";
    }
    
    [Bindable("change")]
    
    /**
     *  @copy mx.resources.IResourceManager#getClass()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getClass(bundleName:String, resourceName:String,
                             locale:String = null):Class
    {
        var resourceBundle:IResourceBundle =
            findBundle(bundleName, resourceName, locale);
        if (!resourceBundle)
            return null;

        var value:* = resourceBundle.content[resourceName];

        return value as Class;
    }

    /**
     *  @private.
     */
    private function findBundle(bundleName:String, resourceName:String,
                                locale:String):IResourceBundle
    {
        //supportNonFrameworkApps();

        return locale != null ?
               getResourceBundle(locale, bundleName) :
               findResourceBundleWithResource(bundleName, resourceName);

    }

    /**
     *  @private.
    private function supportNonFrameworkApps():void
    {
        if (initializedForNonFrameworkApp)
            return;
        initializedForNonFrameworkApp = true;

        if (getLocales().length > 0)
            return;
        
        var applicationDomain:ApplicationDomain =
            ApplicationDomain.currentDomain;
        
        if (!applicationDomain.hasDefinition("_CompiledResourceBundleInfo"))
            return;
        var c:Class = Class(applicationDomain.getDefinition(
                                "_CompiledResourceBundleInfo"));

        var locales:Array *//* of String *//* = c.compiledLocales;
        var bundleNames:Array *//* of String *//* = c.compiledResourceBundleNames;

        installCompiledResourceBundles(
            applicationDomain, locales, bundleNames);

        localeChain = locales;
    }
    */

    
    /**
     *  @private
     */  
    private function getSystemPreferredLocales():Array /* of String */
    {
        var systemPreferences:Array;
        
        /*
        // Capabilities.languages was added in AIR 1.1,
        // so this API may not exist.
        if (Capabilities["languages"])
            systemPreferences = Capabilities["languages"];
        else
            systemPreferences = [ Capabilities.language ];
        */
        systemPreferences = [ LocaleUtils.getLocale() ];
        
        return systemPreferences;
    }
    
    /**
     *  @private.
     */
    private function dumpResourceModule(resourceModule:*):void
    {
        for each (var bundle:ResourceBundle in resourceModule.resourceBundles)
        {
            trace(bundle.locale, bundle.bundleName);
            for (var p:String in bundle.content)
            {
                //trace(p, bundle.getObject(p));
            }
        }
    }

    /**
     *  @private
    private function enterFrameHandler(event:Event):void
    {
        if (SystemManagerGlobals.topLevelSystemManagers.length)
        {
            if (SystemManagerGlobals.topLevelSystemManagers[0].currentFrame == 2)
            {
				inFrame1 = false;
                SystemManagerGlobals.topLevelSystemManagers[0].
                    removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
            }
            else
                return;
        }
        
        var info:Object = SystemManagerGlobals.info;
        if (info)
            processInfo(info, false);
    }
     */
}

}

import org.apache.royale.events.EventDispatcher;
//import mx.events.ModuleEvent;
//import mx.events.ResourceEvent;
import mx.modules.IModuleInfo;
import mx.resources.IResourceBundle;
//import mx.resources.IResourceModule;

////////////////////////////////////////////////////////////////////////////////
//
//  Helper class: ResourceModuleInfo
//
////////////////////////////////////////////////////////////////////////////////

/**
 *  @private
 */
class ResourceModuleInfo
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
    public function ResourceModuleInfo(moduleInfo:IModuleInfo,
                                       readyHandler:Function,
                                       errorHandler:Function)
    {
        super();

        this.moduleInfo = moduleInfo;
        this.readyHandler = readyHandler;
        this.errorHandler = errorHandler;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  errorHandler
    //----------------------------------

    /**
     *  @private
     */
    public var errorHandler:Function;
    
    //----------------------------------
    //  moduleInfo
    //----------------------------------

    /**
     *  @private
     */
    public var moduleInfo:IModuleInfo;
    
    //----------------------------------
    //  readyHandler
    //----------------------------------

    /**
     *  @private
     */
    public var readyHandler:Function;
    
    //----------------------------------
    //  resourceModule
    //----------------------------------

    /**
     *  @private
     */
    //public var resourceModule:IResourceModule;
}

////////////////////////////////////////////////////////////////////////////////
//
//  Helper class: ResourceEventDispatcher
//
////////////////////////////////////////////////////////////////////////////////

/**
 *  @private
 */
class ResourceEventDispatcher extends EventDispatcher
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
    public function ResourceEventDispatcher(moduleInfo:IModuleInfo)
    {
        super();

        moduleInfo.addEventListener(
            ModuleEvent.ERROR, moduleInfo_errorHandler, false, 0, true);

        moduleInfo.addEventListener(
            ModuleEvent.PROGRESS, moduleInfo_progressHandler, false, 0, true);
        
        moduleInfo.addEventListener(
            ModuleEvent.READY, moduleInfo_readyHandler, false, 0, true);
    }
     */

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
    private function moduleInfo_errorHandler(event:ModuleEvent):void
    {
        var resourceEvent:ResourceEvent = new ResourceEvent(
            ResourceEvent.ERROR, event.bubbles, event.cancelable);
        resourceEvent.bytesLoaded = event.bytesLoaded;
        resourceEvent.bytesTotal = event.bytesTotal;
        resourceEvent.errorText = event.errorText;
        dispatchEvent(resourceEvent);
    }
     */

    /**
     *  @private
    private function moduleInfo_progressHandler(event:ModuleEvent):void
    {
        var resourceEvent:ResourceEvent = new ResourceEvent(
            ResourceEvent.PROGRESS, event.bubbles, event.cancelable);
        resourceEvent.bytesLoaded = event.bytesLoaded;
        resourceEvent.bytesTotal = event.bytesTotal;
        dispatchEvent(resourceEvent);
    }
     */

    /**
     *  @private
    private function moduleInfo_readyHandler(event:ModuleEvent):void
    {
        var resourceEvent:ResourceEvent =
            new ResourceEvent(ResourceEvent.COMPLETE);
        dispatchEvent(resourceEvent);
    }
     */
}

////////////////////////////////////////////////////////////////////////////////
//
//  Helper class: ResourceBundleProxy
//
////////////////////////////////////////////////////////////////////////////////

/**
 *  @private
 */
class ResourceBundleProxy implements IResourceBundle
{
	public var bundleClass:Class;
	public var useWeakReference:Boolean;
	
	private var _bundleName:String;
	private var _locale:String;
 
    public function ResourceBundleProxy()
	{
	}
       
	public function get bundleName():String {
		return _bundleName;
	}
	
	public function set bundleName(value:String):void {
		_bundleName = value;
	}
       
    public function get content():Object {
    	return null;
    }
        
	public function get locale():String {
		return _locale;
	}
	
	public function set locale(value:String):void {
		_locale = value;
	}
}
