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
 * @private
 * This class is used to satisfy old MXML codegen
 * for both Falcon and MXML, but in FlexJS with mxml.children-as-data output
 * it isn't needed so there is no JS equivalent
 */
public interface IFlexModuleFactory
{

    
    /**
     *  Calls the <code>Security.allowDomain()</code> method for the SWF 
     *  associated with this IFlexModuleFactory plus all the SWFs associated
     *  with RSLs preloaded by this IFlexModuleFactory. RSLs loaded after this
     *  call will, by default, allow the same domains as have been allowed by
     *  previous calls to this method. This behavior is controlled by the <code>
     *  allowDomainsInNewRSLs</code> property.
     *
     *  @param domains One or more strings or URLRequest objects that name 
     *  the domains from which you want to allow access. 
     *  You can specify the special domain "&#42;" to allow access from all domains. 
     *
     *  @see flash.system.Security#allowDomain()
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Flex 4.5
     */  
    function allowDomain(... domains):void;
    
    /**
     *  Calls the <code>Security.allowInsecureDomain()</code> method for the 
     *  SWF associated with this IFlexModuleFactory
     *  plus all the SWFs associated with RSLs preloaded by this 
     *  IFlexModuleFactory. RSLs loaded after this call will, by default, 
     *  allow the same domains as have been allowed by
     *  previous calls to this method. This behavior is controlled by the <code>
     *  allowInsecureDomainsInNewRSLs</code> property.
     *
     *  @param domains One or more strings or URLRequest objects that name 
     *  the domains from which you want to allow access. 
     *  You can specify the special domain "&#42;" to allow access from all domains. 
     *
     *  @see flash.system.Security#allowInsecureDomain()
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Flex 4.5
     */  
    function allowInsecureDomain(... domains):void;
    
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
    function callInContext(fn:Function, thisArg:Object,
                           argArray:Array, returns:Boolean = true):*;
    
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
    function create(... parameters):Object;
    
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
    
}

}
