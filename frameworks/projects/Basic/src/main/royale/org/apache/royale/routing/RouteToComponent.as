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
  import org.apache.royale.core.Bead;
  import org.apache.royale.core.IStrand;
  import org.apache.royale.events.ValueEvent;
  import org.apache.royale.core.IParent;
  import org.apache.royale.core.IChild;
  [DefaultProperty("routes")]
  /**
   * RouteToComponent is a bead designed for Router
   * One or more routes should be assigned to the bead
   */
  public class RouteToComponent extends Bead
  {
    public function RouteToComponent()
    {
      
    }

    public var routes:Array;

    /**
     * @royaleignorecoercion org.apache.royale.routing.Router
     */
    private function get host():Router{
      return _strand as Router
    }
    override public function set strand(value:IStrand):void
    {
      _strand = value;
      listenOnStrand("hashNeeded",hashNeeded);
      listenOnStrand("hashReceived",hashReceived);
      listenOnStrand("stateChange",stateChanged)
    }
    private function hashNeeded(ev:ValueEvent):void
    {
      var hash:String = ev.value;
      var trailing:String = "";
      var delim:String = ""
      if(hash.indexOf("?") != -1)
        delim = "?"

      else if(hash.indexOf("#") != -1)
        delim = "#"
      if(delim)
      {
        trailing = hash.slice(hash.indexOf(delim));
        hash = hash.slice(0,hash.indexOf(delim));
      }
      // no bead added the path yet
      if(!hash)
      {
        hash = host.routeState.path;
      }
      
      ev.value = hash + trailing;

    }

    private function hashReceived(ev:ValueEvent):void
    {
      var hash:String = ev.value;
      var trailing:String = "";
      // if we have parameters, we don't care if we also have an anchor
      var delim:String = ""
      var index:int = hash.indexOf("?")
      if(index == -1)
        index = hash.indexOf("#");
      
      if(index != -1)
        hash = hash.slice(0,index);
      
      host.routeState.path = hash;
    }

    /**
     * @royaleignorecoercion org.apache.royale.core.IParent
     */
    private function stateChanged():void
    {
      // apply routes
      if(routes)
      {
        var baseName:String = host.routeState.getBaseName();

        for(var i:int=0;i<routes.length;i++){
          var route:ComponentRoute = routes[i];
          if(route.baseName == baseName)
          {
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
    }

  }
}