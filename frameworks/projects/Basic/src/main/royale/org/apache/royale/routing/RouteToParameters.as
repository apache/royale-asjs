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

  [DefaultProperty("routes")]
  public class RouteToParameters extends Bead
  {
    public function RouteToParameters()
    {
      
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

    }

    private function hashReceived(ev:ValueEvent):void
    {
      
    }
    private function stateChanged():void
    {

    }
    public var routes:Array;

    // private function buildParameterString():String{
    //   var retVal:String = "";
    //   if(_routeState.parameters){
    //     retVal += "?";
    //     for(var x:String in _routeState.parameters){
    //       retVal += x;
    //       if(_routeState.parameters[x] != undefined){
    //         retVal += "=" + encodeURIComponent(_routeState.parameters[x]);
    //         retVal += "&";
    //       }
    //     }
    //     //remove trailing &
    //     retVal = retVal.slice(0, -1);
    //   }

    //   return retVal;
    // }

    // private function parseParameters(query:String):Object
    // {
    //   var urlVars:Object;
    //   if(query){
    //     var vars:Array = query.split("&");
    //     if(vars.length){
    //       urlVars = {};
    //     }
    //     for (var i:int=0;i<vars.length;i++) {
    //         var pair:Array = vars[i].split("=");
    //         urlVars[pair[0]] = pair[1] == undefined ? undefined : decodeURIComponent(pair[1]);
    //     }
    //   }
    //   return urlVars;
    // }

  }
}