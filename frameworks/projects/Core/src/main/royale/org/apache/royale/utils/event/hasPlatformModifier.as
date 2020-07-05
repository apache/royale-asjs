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
package org.apache.royale.utils.event
{
  import org.apache.royale.events.MouseEvent;
  import org.apache.royale.events.KeyboardEvent;
  import org.apache.royale.utils.OSUtils;
  /**
   * @royalesuppressexport
	 * @royaleignorecoercion org.apache.royale.events.MouseEvent
	 * @royaleignorecoercion org.apache.royale.events.KeyboardEvent
   */
  COMPILE::JS
  public function hasPlatformModifier(event:*):Boolean{
    var isMac:Boolean = OSUtils.getOS() == OSUtils.MAC_OS;
    if(event is MouseEvent){
      return isMac ? (event as MouseEvent).metaKey : (event as MouseEvent).ctrlKey;
    } else if(event is KeyboardEvent){
      return isMac ? (event as KeyboardEvent).metaKey : (event as KeyboardEvent).ctrlKey;
    } else if(event.constructor.name == "MouseEvent" || event.constructor.name == "KeyboardEvent"){
      return isMac ? event.metaKey : event.ctrlKey;
    }
    return false;
  }

  COMPILE::SWF
  public function hasPlatformModifier(event:*):Boolean{
    try{
      return event.controlKey;
    }catch(err:Error){
      return false;
    }
  }
}