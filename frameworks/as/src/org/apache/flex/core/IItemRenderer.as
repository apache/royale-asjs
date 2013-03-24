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
package org.apache.flex.core
{
	import org.apache.flex.events.IEventDispatcher;

	public interface IItemRenderer extends IEventDispatcher
	{
		function get data():Object;
		function set data(value:Object):void;
		
		function get index():int;
		function set index(value:int):void;
		
		function get selected():Boolean;
		function set selected(value:Boolean):void;
        
        function get hovered():Boolean;
        function set hovered(value:Boolean):void;

        function get down():Boolean;
        function set down(value:Boolean):void;
	}
}