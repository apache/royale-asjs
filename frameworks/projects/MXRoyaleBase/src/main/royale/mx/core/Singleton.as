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

package mx.core
{

[ExcludeClass]

/**
 *  @private
 *  This all-static class serves as a singleton registry.
 *
 *  For example, pop-up management throughout a Flex application
 *  is provided by a single instance of the PopUpManagerImpl class,
 *  even when the main application loads modules and sub-applications
 *  each of which might have PopUpManagerImpl linked in.
 *
 *  The factory class for a framework-based application
 *  or a module (i.e., SystemManager or FlexModuleFactory,
 *  both of which implements IFlexModuleFactory) calls
 *  the registerClass() method to populate the registry.
 *
 *  Later, other classes call getInstance() to access
 *  the singleton instance.
 *
 *  The registry policy is "first class in wins".
 *  For example, if the main application registers its
 *  PopUpManagerImpl, then a loaded SWF will use that one.
 *  However, if the main application doesn't contain
 *  a PopUpManagerImpl, then it registers null,
 *  and the first loaded SWF containing a PopUpManagerImpl
 *  will register that one.
 */
public class Singleton
{
    // include "../core/Version.as";
    
    //--------------------------------------------------------------------------
    //
    //  Class variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
	 *  A map of fully-qualified interface names,
	 *  such as "mx.managers::IPopUpManager",
	 *  to implementation classes which produce singleton instances,
	 *  such as mx.managers.PopUpManagerImpl.
     */
    private static var classMap:Object = {};

    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
	 *  Adds an interface-name-to-implementation-class mapping to the registry,
	 *  if a class hasn't already been registered for the specified interface.
	 *  The class must implement a getInstance() method which returns
	 *  its singleton instance.
     */
    public static function registerClass(interfaceName:String,
										 clazz:Class):void
    {
        var c:Class = classMap[interfaceName];
		if (!c)
            classMap[interfaceName] = clazz;
    }

    /**
     *  @private
	 *  Returns the implementation class registered for the specified
	 *  interface, or null if no class has been registered for that interface.
	 *
	 *  This method should not be called at static initialization time,
	 *  because the factory class may not have called registerClass() yet.
     */
    public static function getClass(interfaceName:String):Class
    {
        return classMap[interfaceName];
    }

    /**
     *  @private
	 *  Returns the singleton instance of the implementation class
	 *  that was registered for the specified interface,
	 *  by looking up the class in the registry
	 *  and calling its getInstance() method.
	 *
	 *  This method should not be called at static initialization time,
	 *  because the factory class may not have called registerClass() yet.
     */
    public static function getInstance(interfaceName:String):Object
    {
        var c:Class = classMap[interfaceName];
		if (!c)
		{
			throw new Error("No class registered for interface '" +
							interfaceName + "'.");
		}
		return c["getInstance"]();
    }
}

}
