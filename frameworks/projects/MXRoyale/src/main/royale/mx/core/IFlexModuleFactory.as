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

/**
 *  The IFlexModuleFactory interface represents the contract expected
 *  for bootstrapping Flex applications and dynamically loaded
 *  modules.
 *
 *  <p>Calling the <code>info()</code> method is legal immediately after
 *  the <code>complete</code> event is dispatched.</p>
 *
 *  <p>A well-behaved module dispatches a <code>ready</code> event when
 *  it is safe to call the <code>create()</code> method.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public interface IFlexModuleFactory
{
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    

    /**
     *  A way to call a method in this IFlexModuleFactory's context
     *
     *  @param fn The function or method to call.
     *  @param thisArg The <code>this</code> pointer for the function.
     *  @param argArray The arguments for the function.
     *  @param returns If <code>true</code>, the function returns a value.
     *
     *  @return Whatever the function returns, if anything.
     *  
     *  @see Function.apply
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 3
     */
    //function callInContext(fn:Function, thisArg:Object,
    //                       argArray:Array, returns:Boolean = true):*;
    
    /**
     *  A factory method that requests
     *  an instance of a definition known to the module.
     *
     *  <p>You can provide an optional set of parameters to let
     *  building factories change what they create based
     *  on the input.
     *  Passing <code>null</code> indicates that the default
     *  definition is created, if possible.</p>
     *
     *  @param parameters An optional list of arguments. You can pass any number
     *  of arguments, which are then stored in an Array called <code>parameters</code>.
     *
     *  @return An instance of the module, or <code>null</code>.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    //function create(... parameters):Object;
    
    /**
     *  Get the implementation for an interface.
     *  Similar to <code>Singleton.getInstance()</code> method, but per-
     *  IFlexModuleFactory.
     *
     *  @param interfaceName The interface.
     *
     *  @return The implementation for the interface.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function getImplementation(interfaceName:String):Object;
    
    /**
     *  Returns a block of key/value pairs
     *  that hold static data known to the module.
     *  This method always succeeds, but can return an empty object.
     *
     *  @return An object containing key/value pairs. Typically, this object
     *  contains information about the module or modules created by this 
     *  factory; for example:
     * 
     *  <pre>
     *  return {"description": "This module returns 42."};
     *  </pre>
     *  
     *  Other common values in the returned object include the following:
     *  <ul>
     *   <li><code>fonts</code>: A list of embedded font faces.</li>
     *   <li><code>rsls</code>: A list of run-time shared libraries.</li>
     *   <li><code>mixins</code>: A list of classes initialized at startup.</li>
     *  </ul>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function info():Object;
    
    /**
     *  Register an implementation for an interface.
     *  Similar to the <code>Singleton.registerClass()</code> method, but per-
     *  IFlexModuleFactory, and takes an instance not a class.
     *
     *  @param interfaceName The interface.
     *
     *  @param impl The implementation.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    //function registerImplementation(interfaceName:String,
    //                                impl:Object):void;
    
}

}
