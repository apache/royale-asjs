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
 *  @productversion Royale 0.9.3
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
     *  @productversion Royale 0.9.3
     */
    public static function getModule(url:String):Object //:IModuleInfo
    {
		return null;
        //return getSingleton().getModule(url);
    }

}

} 
	
