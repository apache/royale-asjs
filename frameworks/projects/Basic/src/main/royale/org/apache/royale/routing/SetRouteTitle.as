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

  public class SetRouteTitle extends Bead
  {
    public function SetRouteTitle()
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
      COMPILE::JS
      {
        initialTitle = document.title;
      }
      listenOnStrand("stateSet",handleStateSet);
      listenOnStrand("urlReceived",urlReceived);
    }
    private function urlReceived(ev:ValueEvent):void
    {
      setTitle();
    }
    private var initialTitle:String;
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

    protected function handleStateSet():void
    {
      COMPILE::JS
      {
        if(host.routeState.title)
        {
          document.title = host.routeState.title;
        }

      }

    }

  }
}