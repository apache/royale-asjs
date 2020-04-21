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
  import org.apache.royale.events.Event;

  [DefaultProperty("routes")]
  public class RouteToParameters extends Bead
  {
    public function RouteToParameters()
    {
      
    }
    /**
     * @royaleignorecoercion org.apache.royale.routing.IRouter
     */
    private function get host():IRouter{
      return _strand as IRouter
    }
    override public function set strand(value:IStrand):void
    {
      _strand = value;
      listenOnStrand("urlNeeded",urlNeeded);
      listenOnStrand("urlReceived",urlReceived);
      listenOnStrand("stateChange",stateChanged)
    }

    protected function urlNeeded(event:ValueEvent):void
    {
      var hash:String = event.value;
      var paramStr:String = buildParameterString();
      var trailing:String = "";
      var index:int = hash.indexOf("#");
      if(index != -1)
      {
        trailing = hash.slice(index);
        hash = hash.slice(0,index);
      }
      event.value = hash + paramStr + trailing;

    }

    protected function urlReceived(event:ValueEvent):void
    {
      var hash:String = event.value;
      var index:int = hash.indexOf("?");
      if(index == -1)//no params
        return;
      hash = hash.slice(index + 1);
      index = hash.indexOf("#");
      if(index != -1)
      {
        hash = hash.slice(0,index);
      }
      host.routeState.parameters = parseParameters(hash);
    }

    protected function stateChanged(event:Event):void
    {
      var params:Object = host.routeState.parameters;
      // apply routes
      if(routes)
      {
        for(var i:int=0;i<routes.length;i++){
          var route:ParameterRoute = routes[i];
          var value:String = route.defaultValue;
          if(route.key in params)
          {
            value = params[route.key];
          }
          if(value)
          {
            route.callback(value);
            if(route.title)
              host.routeState.title = route.title;

          }
        }
      }      
    }
    public var routes:Array;

    private function buildParameterString():String{
      var retVal:String = "";
      var state:RouteState = host.routeState;
      if(state.parameters){
        retVal += "?";
        for(var x:String in state.parameters){
          retVal += x;
          if(state.parameters[x] != undefined){
            retVal += "=" + encodeURIComponent(state.parameters[x]);
            retVal += "&";
          }
        }
        //remove trailing &
        retVal = retVal.slice(0, -1);
      }

      return retVal;
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

  }
}