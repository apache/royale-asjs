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
  import org.apache.royale.core.DispatcherBead;
  import org.apache.royale.core.IStrand;
  import org.apache.royale.debugging.assert;
  import org.apache.royale.core.IStatesObject;
  import org.apache.royale.events.Event;
  import org.apache.royale.core.IInitialViewApplication;
    /**
     *  Dispatched when the state is changed.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.7
     */
    [Event(name="stateChange", type="org.apache.royale.events.Event")]

    /**
     * Router is a bead which automatically handles browsing history.
     * It could be attached to any strand, but typically it would be attached to Application or View
     * Listen to stateChange events to handle changes to browsing history and use setState and renderState for modifying the history.
     * The state of the router can be modified before committing the state changes.
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.7
     */
  public class Router extends DispatcherBead
  {
    public function Router()
    {
      
    }
    /**
     * Use this to automatically sync the state of the strand.
     * This only works for the state property of the RouterState.
     * It also assumes that the strand is an IStatesObject.
     * For this to work correctly, it's usually assumed that the bead is attached to the application View
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.7
     */
    public var syncState:Boolean;
		override public function set strand(value:IStrand):void
		{	
			_strand = value;
			COMPILE::JS
			{
				window.addEventListener("hashchange", hashChangeHandler);
        initialTitle = document.title;
			}
      // If it's an Application, listen to applicationComplete
      if(_strand is IInitialViewApplication)
        listenOnStrand("applicationComplete",onInit);
      //Otherwise listen to initComplete
      else
        listenOnStrand("initComplete",onInit);
		}
    private function onInit(event:Event):void
    {
      COMPILE::JS
      {
        if(location.hash)
        {
          hashChangeHandler();
        }
      }
    }
    private var initialTitle:String;
		private function hashChangeHandler():void
		{
      parseHash();
      if(syncState)
      {
        assert(_strand is IStatesObject,"syncState can only be used on IStatesObjects");
        (_strand as IStatesObject).currentState = _routeState.state;
      }
			dispatchEvent(new Event("stateChange"));
		}
    private function parseHash():void
    {
      //TODO SWF implementation
      COMPILE::JS
      {
        var hash:String = location.hash;
        var index:int = 0;
        if(hash.indexOf("!")==1){
          index = 1;
        }
        hash = hash.slice(index+1);
        var paths:Array = hash.split("/");
        var statePart:String = paths.pop();
        var splitParts:Array = statePart.split("?");
        statePart = splitParts[0];
        _routeState = new RouteState(statePart,document.title);
        _routeState.path = paths;
        _routeState.parameters = parseParameters(splitParts[1]);
      }
    }
    private function parseParameters(query:String):Object
    {
      var urlVars:Object;
      if(query){
        var vars:Array = query.split("&");
        if(vars.length){
          urlVars = {};
        }
        for (var i:int=0;i<vars.length;i++) {
            var pair:Array = vars[i].split("=");
            urlVars[pair[0]] = pair[1] == undefined ? undefined : decodeURIComponent(pair[1]);
        }
      }
      return urlVars;
    }

    private function buildHash():String
    {
      var hash:String = "#!";
      if(_routeState.path && routeState.path.length){
        hash += (_routeState.path.join("/") + "/");
      }
      if(_routeState.state){
        hash += _routeState.state;
      }
      hash+= buildParameterString();
      return hash;
    }
    private function buildParameterString():String{
      var retVal:String = "";
      if(_routeState.parameters){
        retVal += "?";
        for(var x:String in _routeState.parameters){
          retVal += x;
          if(_routeState.parameters[x] != undefined){
            retVal += "=" + encodeURIComponent(_routeState.parameters[x]);
            retVal += "&";
          }
        }
        //remove trailing &
        retVal = retVal.slice(0, -1);
      }

      return retVal;
    }

    private var _routeState:RouteState;

    public function get routeState():RouteState
    {
      if(!_routeState){
        _routeState = new RouteState();
      }
    	return _routeState;
    }

    public function set routeState(value:RouteState):void
    {
    	_routeState = value;
    }
    /**
     * Commits the current state to the browsing history
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.7
     */
    public function setState():void
    {
      COMPILE::JS
      {
        window.history.pushState({"title":_routeState.title},_routeState.title,buildHash());
        if(_routeState.title)
        {
          document.title = _routeState.title;
        }
      }
    }
    /**
     * Same as setState, but also notifies of the state change 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.7
     */
    public function renderState():void
    {
      setState();
      if(syncState)
      {
        assert(_strand is IStatesObject,"syncState can only be used on IStatesObjects");
        (_strand as IStatesObject).currentState = _routeState.state;
      }
      dispatchEvent(new Event("stateChange"));
    }
    private function setTitle():void
    {
      COMPILE::JS
      {
        if(window.history.state){
          document.title = window.history.state["title"];
        } else {
          document.title = initialTitle;
        }
      }
    }
    /**
     * Goes forward in the history
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.7
     */
    public function forward():void{
      COMPILE::JS
      {
         window.history.forward();
         setTitle();
         parseHash();
      }
    }
    /**
     * Goes backwards in the history
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.7
     */
    public function back():void{
      COMPILE::JS
      {
         window.history.back();
         setTitle();
         parseHash();
      }
    }

    /**
     * Moved the specified number of steps (forward or backwards) in the history
     * calling it with 0 or no value will reload the page.
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.7
     */
    public function go(steps:int=0):void{
      COMPILE::JS
      {
         window.history.go(steps);
         parseHash();
      }
    }

  }
}