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

import mx.core.IFlexModuleFactory;
import mx.core.mx_internal;
//import mx.core.Singleton;
//import mx.events.ModuleEvent;
//import mx.events.ResourceEvent;
import mx.modules.IModuleInfo;
import mx.modules.ModuleManager;
import mx.utils.StringUtil;

/**
 *  This class is used to get a single instance of the IResourceManager
 *  implementation.
 *  The IResourceManager and IResourceBundle interfaces work together
 *  to provide internationalization support for Flex applications.
 *
 *  <p>A single instance of an IResourceManager implementation
 *  manages all localized resources
 *  for a Flex application.</p>
 *  
 *  @see mx.resources.IResourceManager
 *  @see mx.resources.IResourceBundle
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class ResourceManager
{
//    include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Linker dependency on implementation class.
     */
    private static var implClassDependency:ResourceManagerImpl;

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
     *  Gets the single instance of the ResourceManager class.
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
        {
            /*
			if (!Singleton.getClass("mx.resources::IResourceManager"))
				// install ResourceManagerImpl if not registered already
				Singleton.registerClass("mx.resources::IResourceManager",
					Class(getDefinitionByName("mx.resources::ResourceManagerImpl")));


            try
			{
				instance = IResourceManager(
					Singleton.getInstance("mx.resources::IResourceManager"));
			}
			catch(e:Error)
			{
				// In non-Flex apps and modules, the Singleton manager
				// won't have been initialized by SystemManager
				// or FlexModuleFactory (since these don't get linked in)
				// so the above call to getInstance() will throw an exception.
			}
			
			// In this situation, the ResourceManager simply creates
			// its own ResourceManagerImpl.
            */
			if (!instance)
				instance = new ResourceManagerImpl();

        }
        
        return instance;
    }
    
}

}