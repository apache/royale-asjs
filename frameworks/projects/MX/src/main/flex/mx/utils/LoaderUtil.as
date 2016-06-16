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

package mx.utils
{
COMPILE::SWF
{
import flash.display.DisplayObject;
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.events.IEventDispatcher;
import flash.system.Capabilities;
import flash.utils.Dictionary;
}
COMPILE::JS
{
}
COMPILE::LATER
{
import mx.core.ApplicationDomainTarget;
import mx.core.RSLData;
}
import mx.core.IFlexModuleFactory;
import mx.core.mx_internal;
import mx.events.Request;
import mx.managers.SystemManagerGlobals;
import mx.utils.Platform;

use namespace mx_internal;

  /**
   *  The LoaderUtil class defines utility methods for use with Flex RSLs and
   *  generic Loader instances.
   *  
   *  @langversion 3.0
   *  @playerversion Flash 9
   *  @playerversion AIR 1.1
   *  @productversion Flex 3
   */
    public class LoaderUtil
    {
        
    include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class variables
    //
    //--------------------------------------------------------------------------

    /**
     *   @private
     * 
     *   An array of search strings and filters. These are used in the normalizeURL
     *   method. normalizeURL is used to remove special Flash Player markup from 
     *   urls, but the array could be appended to by the user to modify urls in other
     *   ways.
     *  
     *   Each object in the array has two fields:
     * 
     *   1. searchString - the string to search the url
     *   2. filterFunction - a function that accepts an url and an index to the first
     *   occurrence of the search string in the url. The function may modify the url
     *   and return a new url. A filterFunction is only called once, for the first
     *   occurrence of where the searchString was found. If there
     *   are multiple strings in the url that need to be processed the filterFunction
     *   should handle all of them on the call. A filter function should 
     *   be defined as follows:
     * 
     *   @param url the url to process.
     *   @param index the index of the first occurrence of the seachString in the url.
     *   @return the new url.
     * 
     *   function filterFunction(url:String, index:int):String
     * 
     */
    mx_internal static var urlFilters:Array = 
            [
                { searchString: "/[[DYNAMIC]]/", filterFunction: dynamicURLFilter}, 
                { searchString: "/[[IMPORT]]/",  filterFunction: importURLFilter}
            ];
    
    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------
        
    /**
     *  The root URL of a cross-domain RSL contains special text 
     *  appended to the end of the URL. 
     *  This method normalizes the URL specified in the specified LoaderInfo instance 
     *  to remove the appended text, if present. 
     *  Classes accessing <code>LoaderInfo.url</code> should call this method 
     *  to normalize the URL before using it.
     *  This method also encodes the url by calling the encodeURI() method
     *  on it. If you want the unencoded url, you must call unencodeURI() on
     *  the results.
     *
     *  @param loaderInfo A LoaderInfo instance or url string.
     *
     *  @return A normalized <code>LoaderInfo.url</code> property.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function normalizeURL(loaderInfo:Object):String
    {
        var url:String;
		COMPILE::SWF
		{
			if (loaderInfo is LoaderInfo)
			  url = loaderInfo.url;
			else
			  url = loaderInfo.toString();
		}
		COMPILE::JS
		{
			url = loaderInfo.toString();
		}
        var index:int;
        var searchString:String;
        var urlFilter:Function;
        var n:uint = LoaderUtil.urlFilters.length;
        
        for (var i:uint = 0; i < n; i++)
        {
            searchString = LoaderUtil.urlFilters[i].searchString;
            if ((index = url.indexOf(searchString)) != -1)
            {
                urlFilter = LoaderUtil.urlFilters[i].filterFunction;
                url = urlFilter(url, index);
            }
        }
        
        // On the mac, the player doesn't like filenames with high-ascii
        // characters. Calling encodeURI fixes this problem. We restrict
        // this call to mac-only since it causes problems on Windows.
        if (Platform.isMac)
            return encodeURI(url);
        
        return url;
    }

    /**
     *  @private 
     * 
     *  Use this method when you want to load resources with relative URLs.
     * 
     *  Combine a root url with a possibly relative url to get a absolute url.
     *  Use this method to convert a relative url to an absolute URL that is 
     *  relative to a root URL.
     * 
     *  @param rootURL An url that will form the root of the absolute url.
     *  If the <code>rootURL</code> does not specify a file name it must be 
     *  terminated with a slash. For example, "http://a.com" is incorrect, it
     *  should be terminated with a slash, "http://a.com/". If the rootURL is
     *  taken from loaderInfo, it must be passed thru <code>normalizeURL</code>
     *  before being passed to this function.
     * 
     *  When loading resources relative to an application, the rootURL is 
     *  typically the loaderInfo.url of the application.
     * 
     *  @param url The url of the resource to load (may be relative).
     * 
     *  @return If <code>url</code> is already an absolute URL, then it is 
     *  returned as is. If <code>url</code> is relative, then an absolute URL is
     *  returned where <code>url</code> is relative to <code>rootURL</code>. 
     */ 
    public static function createAbsoluteURL(rootURL:String, url:String):String
    {
        var absoluteURL:String = url;

        // make relative paths relative to the SWF loading it, not the top-level SWF
        if (rootURL &&
            !(url.indexOf(":") > -1 || url.indexOf("/") == 0 || url.indexOf("\\") == 0))
        {
            // First strip off the search string and then any url fragments.
            var index:int;
            
            if ((index = rootURL.indexOf("?")) != -1 )
                rootURL = rootURL.substring(0, index);

            if ((index = rootURL.indexOf("#")) != -1 )
                rootURL = rootURL.substring(0, index);
            
            // If the url starts from the current directory, then just skip
            // over the "./".
            // If the url start from the parent directory, the we need to
            // modify the rootURL.
            var lastIndex:int = Math.max(rootURL.lastIndexOf("\\"), rootURL.lastIndexOf("/"));
            if (url.indexOf("./") == 0)
            {
                url = url.substring(2);
            }
            else
            {
                while (url.indexOf("../") == 0)
                {
                    url = url.substring(3);
                    lastIndex = Math.max(rootURL.lastIndexOf("\\", lastIndex - 1), 
                                                   rootURL.lastIndexOf("/", lastIndex - 1));
                }
            }
                                        
            if (lastIndex != -1)
                absoluteURL = rootURL.substr(0, lastIndex + 1) + url;
        }

        return absoluteURL;
    }
    
    /**
     *  @private
     * 
     *  Takes a list of required rsls and determines:
     *       - which RSLs have not been loaded
     *       - the application domain and IModuleFactory where the
     *         RSL should be loaded
     * 
     *  @param moduleFactory The module factory of the application or module 
     *  to get load information for. If the moduleFactory has not loaded the 
     *  module, then its parent is asked for load information. Each successive
     *  parent is asked until the load information is found or there are no
     *  more parents to ask. Only parents in parent ApplicationDomains are 
     *  searched. Applications in different security domains or sibling
     *  ApplicationDomains do not share RSLs.
     *  
     *  @param rsls An array of RSLs that are required for 
     *  <code>moduleFactory</code>. Each RSL is in an array of RSLData where
     *  the first element is the primary RSL and the remaining elements are 
     *  failover RSLs.
     *  @return Array of RSLData that represents the RSLs to load. RSLs that are
     *  already loaded are not in the listed. 
     */
	COMPILE::LATER
    mx_internal static function processRequiredRSLs(moduleFactory:IFlexModuleFactory, 
                                                    rsls:Array):Array
    {
        var rslsToLoad:Array = [];  // of Array, where each element is an array 
                                    // of RSLData (primary and failover), return value
        var topLevelModuleFactory:IFlexModuleFactory = SystemManagerGlobals.topLevelSystemManagers[0];
        var currentModuleFactory:IFlexModuleFactory = topLevelModuleFactory;
        var parentModuleFactory:IFlexModuleFactory = null;
        var loaded:Dictionary = new Dictionary();   // contains rsls that are loaded
        var loadedLength:int = 0;
        var resolved:Dictionary = new Dictionary(); // contains rsls that have the app domain resolved
        var resolvedLength:int = 0;
        var moduleFactories:Array = null;
        
        // Start at the top level module factory and work our way down the 
        // module factory chain checking if the any of the rsls are loaded 
        // and resolving application domain targets.
        // We start at the top level module factory because the default rsls
        // will all be loaded here and we won't often have to check other 
        // module factories.
        while (currentModuleFactory != moduleFactory)
        {
            // Need to loop over all the rsls, to see which one are loaded
            // and resolve application domains.
            var n:int = rsls.length;
            for (var i:int = 0; i < n; i++)
            {
                var rsl:Array = rsls[i];

                // Check if the RSL has already been loaded.
                if (!loaded[rsl])
                {
                    if (isRSLLoaded(currentModuleFactory, rsl[0].digest))
                    {
                        loaded[rsl] = 1;
                        loadedLength++;
                        
                        // We may find an rsl loaded in a module factory as we work
                        // our way down the module factory list. If we find one then 
                        // remove it.
                        if (currentModuleFactory != topLevelModuleFactory)
                        {
                            var index:int = rslsToLoad.indexOf(rsl); 
                            if (index != -1)
                                rslsToLoad.splice(index, 1);                        
                        }
                    }
                    else if (rslsToLoad.indexOf(rsl) == -1)
                    {
                        rslsToLoad.push(rsl);   // assume we have to load it
                    }
                } 

                // If the rsl is already loaded or already resolved then
                // skip resolving it.
                if (!loaded[rsl] && resolved[rsl] == null)
                {
                    // Get the parent module factory if we are going to need to 
                    // resolve the application domain target.
                    if (!parentModuleFactory && 
                        RSLData(rsl[0]).applicationDomainTarget == ApplicationDomainTarget.PARENT)
                    {
                        parentModuleFactory = getParentModuleFactory(moduleFactory);           
                    }
                    
                    // Resolve the application domain target.
                    if (resolveApplicationDomainTarget(rsl,
                            moduleFactory,
                            currentModuleFactory,
                            parentModuleFactory,
                            topLevelModuleFactory))
                    {
                        resolved[rsl] = 1;
                        resolvedLength++;                        
                    }
                }
            }
            
            // If process all rsls then get out.
            if (loadedLength + resolvedLength >= rsls.length)
                break;
                
             // If we didn't find everything in the top level module factory then work
            // down towards the rsl's owning module factory. 
            // Build up the module factory parent chain so we can traverse it.
            if (!moduleFactories)
            {
                moduleFactories = [moduleFactory];
                currentModuleFactory = moduleFactory;
                while (currentModuleFactory != topLevelModuleFactory)
                {

                    currentModuleFactory = getParentModuleFactory(currentModuleFactory);
                    
                    // If we couldn't get the parent module factory, then we 
                    // will have to load into the highest application domain
                    // that is available. We won't be able to get a parent 
                    // if a module was loaded without specifying a parent 
                    // module factory.
                    if (!currentModuleFactory)
                        break;
                    
                    if (currentModuleFactory != topLevelModuleFactory)
                        moduleFactories.push(currentModuleFactory);
                    
                    if (!parentModuleFactory)
                        parentModuleFactory = currentModuleFactory;
                }
            }

            currentModuleFactory = moduleFactories.pop();
        }
        
        return rslsToLoad;
    }
    
    /**
     * @private
     * Test whether a url is on the local filesystem. We can only
     * really tell this with URLs that begin with "file:" or a
     * Windows-style drive notation such as "C:". This fails some
     * cases like the "/" notation on Mac/Unix.
     * 
     * @param url
     * the url to check against
     * 
     * @return
     * true if url is local, false if not or unable to determine
     **/
    mx_internal static function isLocal(url:String):Boolean 
    {
        return (url.indexOf("file:") == 0 || url.indexOf(":") == 1);
    }
    
    /**
     * @private
     * Currently (FP 10.x) the ActiveX player (Explorer on Windows) does not
     * handle encoded URIs containing UTF-8 on the local filesystem, but
     * it does handle those same URIs unencoded. The plug-in requires
     * encoded URIs.
     * 
     * @param url
     * url to properly encode, may be fully or partially encoded with encodeURI
     * 
     * @param local
     * true indicates the url is on the local filesystem
     * 
     * @return
     * encoded url that may be loaded with a URLRequest
     **/
	COMPILE::SWF
    mx_internal static function OSToPlayerURI(url:String, local:Boolean):String 
    {
        
        // First strip off the search string and any url fragments so
        // they will not be decoded/encoded.
        // Next decode the url.
        // Before returning the decoded or encoded string add the search
        // string and url fragment back.
        var searchStringIndex:int;
        var fragmentUrlIndex:int;
        var decoded:String = url;
        
        if ((searchStringIndex = decoded.indexOf("?")) != -1 )
        {
            decoded = decoded.substring(0, searchStringIndex);
        }
        
        if ((fragmentUrlIndex = decoded.indexOf("#")) != -1 )
            decoded = decoded.substring(0, fragmentUrlIndex);
        
        try
        {
            // decode the url
            decoded = decodeURI(decoded);
        }
        catch (e:Error)
        {
            // malformed url, but some are legal on the file system
        }
        
        // create the string to hold the the search string url fragments.
        var extraString:String = null;
        if (searchStringIndex != -1 || fragmentUrlIndex != -1)
        {
            var index:int = searchStringIndex;
            
            if (searchStringIndex == -1 || 
                (fragmentUrlIndex != -1 && fragmentUrlIndex < searchStringIndex))
            {
                index = fragmentUrlIndex;
            }
            
            extraString = url.substr(index);
        }
        
        if (local && flash.system.Capabilities.playerType == "ActiveX")
        {
            if (extraString)
                return decoded + extraString;
            else 
                return decoded;
        }
        
        if (extraString)
            return encodeURI(decoded) + extraString;
        else
            return encodeURI(decoded);            
    }

    /**
     *  @private
     *  Get the parent module factory. 
     * 
     *  @param moduleFactory The module factory to get the parent of.
     * 
     *  @return the parent module factory if available, null otherwise. 
     */
	COMPILE::SWF
    private static function getParentModuleFactory(moduleFactory:IFlexModuleFactory):IFlexModuleFactory    
    {
        var request:Request = new Request(Request.GET_PARENT_FLEX_MODULE_FACTORY_REQUEST);
        DisplayObject(moduleFactory).dispatchEvent(request); 
        return request.value as IFlexModuleFactory;
    }
    
    /**
     *  @private
     *  Resolve the application domain target. 
     * 
     *  @param rsl to resolve.
     *  @param moduleFactory The module factory loading the RSLs.
     *  @param currentModuleFactory The module factory to search for placeholders.
     *  @param parentModuleFactory The rsl's parent module factory.
     *  @param topLevelModuleFactory The top-level module factory.
     * 
     *  @return true if the application domain target was resolved, 
     *  false otherwise.
     */
	COMPILE::LATER
    private static function resolveApplicationDomainTarget(rsl:Array, 
                                    moduleFactory:IFlexModuleFactory, 
                                    currentModuleFactory:IFlexModuleFactory, 
                                    parentModuleFactory:IFlexModuleFactory, 
                                    topLevelModuleFactory:IFlexModuleFactory):Boolean 
    {
        var resolvedRSL:Boolean = false;
        var targetModuleFactory:IFlexModuleFactory = null;
        
        var applicationDomainTarget:String = rsl[0].applicationDomainTarget;
        if (isLoadedIntoTopLevelApplicationDomain(moduleFactory))
        {
            targetModuleFactory = topLevelModuleFactory;
        }
        else if (applicationDomainTarget == ApplicationDomainTarget.DEFAULT)
        {
            if (hasPlaceholderRSL(currentModuleFactory, rsl[0].digest))
            {
                targetModuleFactory = currentModuleFactory;
            }
        }
        else if (applicationDomainTarget == ApplicationDomainTarget.TOP_LEVEL)
        {
            targetModuleFactory = topLevelModuleFactory;
        }
        else if (applicationDomainTarget == ApplicationDomainTarget.CURRENT)
        {
            resolvedRSL = true;
        }
        else if (applicationDomainTarget == ApplicationDomainTarget.PARENT)
        {
            // If there is no parent, ignore the target and load into the current
            // app domain. 
            targetModuleFactory = parentModuleFactory;
        }
        else
        {
            resolvedRSL = true; // bogus target, load into current application domain
        }
        
        if (resolvedRSL || targetModuleFactory)
        {
            if (targetModuleFactory)
                updateRSLModuleFactory(rsl, targetModuleFactory);
            return true;
        }
        
        return false;
    }
    
    /**
     *  @private
     *  Determine if the moduleFactory has loaded an rsl that matches the 
     *  specified digest.
     * 
     *  @param moduleFactory The module factory to search.
     *  @param digest The digest to search for.
     *  @return true if a loaded rsl matching the digest was found.
     */
	COMPILE::LATER
    private static function isRSLLoaded(moduleFactory:IFlexModuleFactory, digest:String):Boolean
    {
        var preloadedRSLs:Dictionary = moduleFactory.preloadedRSLs;
        
        if (preloadedRSLs)
        {
            // loop over the rsls to find a matching digest
            for each (var rsl:Vector.<RSLData> in preloadedRSLs)
            {
                var n:int = rsl.length;
                for (var i:int = 0; i < n; i++)
                {
                    if (rsl[i].digest == digest)
                    {
                        return true;
                    }
                }
            }
        }
        
        return false;
    }
    
    /**
     *  @private
     * 
     *  Determine if the moduleFactory has a placeholder rsl that matches the 
     *  specified digest.
     * 
     *  @param moduleFactory The module factory to search.
     *  @param digest The digest to search for.
     *  @return true if a placeholder rsl matching the digest was found.
     */
    private static function hasPlaceholderRSL(moduleFactory:IFlexModuleFactory, digest:String):Boolean
    {
        var phRSLs:Array = moduleFactory.info()["placeholderRsls"];
        
        if (phRSLs)
        {
            // loop over the rsls to find a matching digest
            var n:int = phRSLs.length;
            for (var i:int = 0; i < n; i++)
            {
                var rsl:Object = phRSLs[i];
                var m:int = rsl.length;
                for (var j:int = 0; j < m; j++)
                {
                    if (rsl[j].digest == digest)
                    {
                        return true;
                    }
                }
            }
        }
        
        return false;
    }
 
    /**
     *  @private
     *  Test if a module factory has been loaded into the top-level application domain.
     * 
     *  @return true if loaded into the top-level application domain, false otherwise.
     */ 
	COMPILE::LATER
    private static function isLoadedIntoTopLevelApplicationDomain(moduleFactory:IFlexModuleFactory):Boolean
    {
        if (moduleFactory is DisplayObject)
        {
            var displayObject:DisplayObject = DisplayObject(moduleFactory);
            var loaderInfo:LoaderInfo = displayObject.loaderInfo;
            if (loaderInfo && loaderInfo.applicationDomain &&
                loaderInfo.applicationDomain.parentDomain == null)
            {
                return true;
            }
        }
        
        return false;        
    }
    
    /**
     *  @private
     * 
     *  Update the module factory of an rsl, both the primary rsl and all 
     *  failover rsls.
     * 
     *  @param rsl One RSL represented by an array of RSLData. The 
     *  first element in the array is the primary rsl, the others are failovers.
     *  @param moduleFactory  The moduleFactory to set in the primary and 
     *  failover rsls.
     */
	COMPILE::LATER
    private static function updateRSLModuleFactory(rsl:Array, moduleFactory:IFlexModuleFactory):void
    {
        var n:int = rsl.length;
        for (var i:int = 0; i < n; i++)
        {
            rsl[i].moduleFactory = moduleFactory;
        }
    }
    
    /**
     *  @private
     * 
     *  Strip off the DYNAMIC string(s) appended to the url.
     */
    private static function dynamicURLFilter(url:String, index:int):String
    {
        return url.substring(0, index);
    }

    /**
     *  @private
     * 
     *  Add together the protocol plus everything after "/[[IMPORT]]/".
     */
    private static function importURLFilter(url:String, index:int):String
    {
        var protocolIndex:int = url.indexOf("://");
        return url.substring(0,protocolIndex + 3) + url.substring(index + 12);
    }
    
    }
}
