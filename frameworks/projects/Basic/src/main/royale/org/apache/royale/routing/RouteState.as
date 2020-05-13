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
  public class RouteState
  {
    public function RouteState(path:String="")
    {
      this.path = path;
      this.parameters = {};
    }
    public var anchor:String;
    public var parameters:Object;
    public var path:String;
    public var title:String;
    public function getBaseName():String
    {
        var lastdelim:int = path.lastIndexOf("/");
        if(lastdelim != -1)
          return path.slice(lastdelim+1);
      
      return path;
    }
  }
}