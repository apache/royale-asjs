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
/***
 * Based on the
 * Swiz Framework library by Chris Scott, Ben Clinkinbeard, Sönke Rohde, John Yanarella, Ryan Campbell, and others https://github.com/swiz/swiz-framework
 */
package org.apache.royale.crux.utils.chain
{
	import org.apache.royale.events.IEventDispatcher;
	
	[Event(name="chainStart", type="org.apache.royale.crux.events.ChainEvent")]
	[Event(name="chainStepComplete", type="org.apache.royale.crux.events.ChainEvent")]
	[Event(name="chainStepError", type="org.apache.royale.crux.events.ChainEvent")]
	[Event(name="chainComplete", type="org.apache.royale.crux.events.ChainEvent")]
	[Event(name="chainFail", type="org.apache.royale.crux.events.ChainEvent")]
	
	public interface IChain extends IEventDispatcher
	{
		function get position():int;
		function set position( value:int ):void;
		
		function get isComplete():Boolean;
		
		function get stopOnError():Boolean;
		function set stopOnError( value:Boolean ):void;
		
		function hasNext():Boolean;
		function stepComplete():void;
		function stepError():void;
		
		function addStep( step:IChainStep ):IChain;
		
		function start():void;
		function doProceed():void;
	}
}
