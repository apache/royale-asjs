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
package org.apache.royale.externsjs.inspiretree
{
    public interface IInspireTree
    {
        function isInitialized():Boolean;
        function prepareTreeDataFromArray(dpArray:Array):Array;
        function reCreateViewTree(onlyView:Boolean=false):void;
        function get jsTree():InspireTree;
        function set jsTree(value:InspireTree):void;
        function get jsTreeDOM():InspireTreeDOM;
        function set jsTreeDOM(value:InspireTreeDOM):void;
        function get uid():String;
        function set uid(value:String):void;
    }
}