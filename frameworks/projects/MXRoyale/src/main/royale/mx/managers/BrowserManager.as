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

//import mx.core.Singleton;

/**
 *  The BrowserManager is a Singleton manager that acts as
 *  a proxy between the browser and the application.
 *  It provides access to the URL in the browser address
 *  bar similar to accessing the <code>document.location</code> property in JavaScript.
 *  Events are dispatched when the <code>url</code> property is changed. 
 *  Listeners can then respond, alter the URL, and/or block others
 *  from getting the event. 
 * 
 *  <p>To use the BrowserManager, you call the <code>getInstance()</code> method to get the current
 *  instance of the manager, and call methods and listen to
 *  events on that manager. See the IBrowserManager class for the
 *  methods, properties, and events to use.</p>
 *
 *  @see mx.managers.IBrowserManager
 *  @see mx.managers.HistoryManager
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class BrowserManager
{
   // include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Linker dependency on implementation class.
     */
   // private static var implClassDependency:BrowserManagerImpl;

    /**
     *  @private
     */
    private static var instance:IBrowserManager;

    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Returns the sole instance of this Singleton class;
     *  creates it if it does not already exist.
     *
     *  @return Returns the sole instance of this Singleton class;
     *  creates it if it does not already exist.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function getInstance():IBrowserManager
    {
        if (!instance)
        {
           /*  instance = IBrowserManager(
                Singleton.getInstance("mx.managers::IBrowserManager")); */
        }

        return instance;
    }
}

}
