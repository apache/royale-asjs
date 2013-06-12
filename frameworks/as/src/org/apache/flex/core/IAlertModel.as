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
	
	public interface IAlertModel extends IEventDispatcher, IBeadModel
	{
		function get title():String;
		function set title(value:String):void;
		
		function get htmlTitle():String;
		function set htmlTitle(value:String):void;
		
		function get message():String;
		function set message(value:String):void;
		
		function get htmlMessage():String;
		function set htmlMessage(value:String):void;
		
		function get flags():uint;
		function set flags(value:uint):void;
		
		function get okLabel():String;
		function set okLabel(value:String):void;
		
		function get cancelLabel():String;
		function set cancelLabel(value:String):void;
		
		function get yesLabel():String;
		function set yesLabel(value:String):void;
		
		function get noLabel():String;
		function set noLabel(value:String):void;
	}
}