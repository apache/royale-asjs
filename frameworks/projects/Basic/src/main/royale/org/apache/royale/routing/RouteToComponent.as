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
  import org.apache.royale.core.IChild;
  import org.apache.royale.core.IParent;
  import org.apache.royale.core.IStrand;
  [DefaultProperty("routes")]
  /**
   * RouteToComponent is a bead designed for IRouter
   * One or more routes should be assigned to the bead
   */
  public class RouteToComponent extends PathRouteBead
  {
    public function RouteToComponent()
    {
      
    }

    public var routes:Array;

    override public function set strand(value:IStrand):void
    {
      super.strand = value;
      listenOnStrand("stateChange",stateChanged)
    }

    /**
     * @royaleignorecoercion org.apache.royale.core.IParent
     */
    private function stateChanged():void
    {
      var defaultRoute:ComponentRoute;
      // apply routes
      if(routes)
      {
        var baseName:String = host.routeState.getBaseName();

        for(var i:int=0;i<routes.length;i++){
          var route:ComponentRoute = routes[i];
          if(route.defaultRoute)
            defaultRoute = route;
          if(route.baseName == baseName)
          {
            addComponent(route);
            return;
          }
        }
        if(defaultRoute)
        {
          addComponent(defaultRoute);
        }
      }      
    }
    private function addComponent(route:ComponentRoute):void{
      var parent:IParent = route.parent || host.host as IParent;
      while(parent.numElements > 0)
        parent.removeElement(parent.getElementAt(0));
      
      var comp:IChild = new route.component();
      parent.addElement(comp);
      if(route.title)
        host.routeState.title = route.title;

    }
  }
}