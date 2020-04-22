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
  import org.apache.royale.core.IState;
  import org.apache.royale.core.IStatesObject;
  import org.apache.royale.core.IStrand;
  import org.apache.royale.debugging.assert;
  import org.apache.royale.events.ValueEvent;
  import org.apache.royale.utils.callLater;

  public class RouteToState extends PathRouteBead
  {
    public function RouteToState()
    {
      
    }

    override public function set strand(value:IStrand):void
    {
      super.strand = value;
      listenOnStrand("stateChange",stateChanged);
      // attach state change event async to allow adding the parent strand after this is added.
      callLater(attachStateEvent);
    }
    /**
     * @royaleignorecoercion org.apache.royale.core.IStatesObject
     */
    private function attachStateEvent():void
    {
      getStateComponent().addEventListener("currentStateChange",handleStateChange);
    }
    private function handleStateChange():void
    {
      if(settingState)// don't do anything if the event was fired as a result of a hash.
        return;
      //TODO what about a parent path

      host.routeState.path = getStateComponent().currentState;
      host.setState();
    }
    override protected function urlNeeded(ev:ValueEvent):void
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
      
      ev.value = parentPath + getStateComponent().currentState + trailing;
    }
    private var settingState:Boolean;
    /**
     * @royaleignorecoercion org.apache.royale.core.IStatesObject
     */
    private function stateChanged(ev:ValueEvent):void
    {
        settingState = true;
        //TODO what about using the base name of the path?
        var stateName:String = host.routeState.path;
        var stateComponent:IStatesObject = getStateComponent();
        var states:Array = stateComponent.states;
        //only change the state if the new value is a valid state
        for each(var state:IState in states)
        {
          if(state.name == stateName)
          {
            stateComponent.currentState = stateName;
            break;
          }
        }
        settingState = false;

    }
    /**
     * @royaleignorecoercion org.apache.royale.core.IStatesObject
     */
    private function getStateComponent():IStatesObject
    {
      var statesObject:IStatesObject = component;
      if(!statesObject)
      {
        assert(host.host is IStatesObject,"syncState can only be used on IStatesObjects");
        statesObject = host.host as IStatesObject;
      }
      return statesObject;      
    }
    /**
     * The component whose state we sync. (Defaults to the strand of the router.)
     */
    public var component:IStatesObject;

  }
}