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
package org.apache.royale.routing
{
  /**
   * ParameterRoutes are declared in (or added to) RouteToParamter beads.
   * If the key exists in thge parameters, the callback will be called with the value as the argument to the function.
   */
  public class ParameterRoute
  {
    public function ParameterRoute()
    {
      
    }
    /**
     * Parameter key to use
     */
    public var key:String;
    /**
     * If a default value is specified, the callback will be called
     * with the default if no matching key is specified in the URL
     */
    public var defaultValue:String;
    /**
     * Optional window title
     */
    public var title:String;
    /**
     * Function to call if the parameter exists. (The value is supplied as an argument.)
     */
    public var callback:Function;
  }
}