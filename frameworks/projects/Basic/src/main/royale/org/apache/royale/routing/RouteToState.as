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
  import org.apache.royale.core.IStatesObject;
  import org.apache.royale.textLayout.debug.assert;
  import org.apache.royale.utils.callLater;

  public class RouteToState extends Bead
  {
    public function RouteToState()
    {
      
    }
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
      // attach state change event async to allow adding the parent strand after this is added.
      callLater(attachStateEvent);
    }
    /**
     * @royaleignorecoercion org.apache.royale.core.IStatesObject
     */
    private function attachStateEvent():void
    {
      assert(host.host is IStatesObject,"syncState can only be used on IStatesObjects");
      (host.host as IStatesObject).addEventListener("currentStateChange",handleStateChange);

    }
    private function handleStateChange():void
    {
      if(settingState)// don't do anything if the event was fired as a result of a hash.
        return;
      //TODO what about a parent path
      host.routeState.path = (host.host as IStatesObject).currentState;
      host.setState();
    }
    private function hashNeeded(ev:ValueEvent):void
    {
      var hash:String = ev.value;
      // don't overwrite path, parameters and anchor
      var parentPath:String = ""
      if(hash.indexOf("/") != -1)
      {
        parentPath = hash.slice(0,hash.lastIndexOf("/")+1);
      }
      var trailing:String = "";
      // if we have parameters, we don't care if we also have an anchor
      var delim:String = ""
      if(hash.indexOf("?") != -1)
        delim = "?"

      else if(hash.indexOf("#") != -1)
        delim = "#"
      if(delim)
        trailing = hash.slice(hash.indexOf(delim));
      
      ev.value = parentPath + (host.host as IStatesObject).currentState + trailing;
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
    private var settingState:Boolean;
    /**
     * @royaleignorecoercion org.apache.royale.core.IStatesObject
     */
    private function stateChanged(ev:ValueEvent):void
    {
        assert(host.host is IStatesObject,"syncState can only be used on IStatesObjects");
        settingState = true;
        //TODO what about using the base name of the path?
        (host.host as IStatesObject).currentState = host.routeState.path;
        settingState = false;

    }

  }
}