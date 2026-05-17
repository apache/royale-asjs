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
  import org.apache.royale.core.IParent;
  import org.apache.royale.core.IChild;
  /**
   * ComponentRoutes are declared in RouteToComponent beads.
   * This maps a base name of a route path to a component class.
   */
  public class ComponentRoute
  {
    public function ComponentRoute()
    {
      
    }
    /**
     * The component class to attach to the parent. I new one is instantiated each time we have a new route.
     */
    public var component:Class;
    /**
     * Use getComponent to auto-generate the component instance.
     * If preserveState is true, the same instance will be returned each time.
     * Otherwise, a new instance will be created each time.
     */
    public function getComponent():IChild
    {
      if(_instance)
        return _instance;
      var comp:IChild = new component() as IChild;
      if(preserveState)
        _instance = comp;
      return comp;
    }
    private var _instance:IChild;
    /**
     * This is the base name (leaf) of the route path.
     */
    public var baseName:String;
    /**
     * The parent to add the component to. (Defaults to the strand of the router.)
     */
    public var parent:IParent;
    /**
     * The title of the route, typically used for display purposes.
     */
    public var title:String;

    public var defaultRoute:Boolean = false;
    /**
     * If true, the same instance of the component with its state will be preserved and returned
     * each time this route is hit. Otherwise, a new instance will be created each time.
     */
    public var preserveState:Boolean = false;
  }
}