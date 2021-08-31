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
  import org.apache.royale.events.ValueEvent;
  import org.apache.royale.core.IStrand;

  public class PathRouteBead extends Bead implements IPathRouteBead
  {
    public function PathRouteBead()
    {
      
    }

    /**
     * @royaleignorecoercion org.apache.royale.routing.IRouter
     */
    protected function get host():IRouter{
      return _strand as IRouter
    }
    override public function set strand(value:IStrand):void
    {
      _strand = value;
      listenOnStrand("urlNeeded",urlNeeded);
      listenOnStrand("urlReceived",urlReceived);
    }

    protected function urlReceived(ev:ValueEvent):void
    {
      var hash:String = ev.value;
      // if we have parameters, we don't care if we also have an anchor
      var delim:String = ""
      var index:int = hash.indexOf("?");
      // if not found then we need to check for an anchor
      if(index == -1)
        index = hash.indexOf("#");
      
      if(index != -1)
        hash = hash.slice(0,index);
      
      host.routeState.path = hash;
    }

    protected function urlNeeded(ev:ValueEvent):void
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

  }
}