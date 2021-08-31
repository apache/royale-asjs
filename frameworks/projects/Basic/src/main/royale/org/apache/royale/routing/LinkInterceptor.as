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
  import org.apache.royale.events.Event;

  public class LinkInterceptor extends Bead
  {
    public function LinkInterceptor()
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
      COMPILE::JS
      {
        document.addEventListener('click', interceptClickEvent);
      }
    }
    /**
     * If requireHash is true, any link that does not start with hash will be handled by a browser redirect
     */
    public var requireHash:Boolean = false;
    private function interceptClickEvent(ev:Event):void
    {
      //TODO find the link target and handle the click event
      trace(ev);
    }
  }
}