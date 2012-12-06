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
package org.apache.flex.binding
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;

	public class SimpleBinding
	{
		public function SimpleBinding()
		{
		}
		
		public var source:IEventDispatcher;
		public var sourcePropertyName:String;
		public var eventName:String;
		public var destination:Object;
		public var destinationPropertyName:String;
		
		public function initialize():void
		{
			source.addEventListener(eventName, changeHandler);
			destination[destinationPropertyName] = source[sourcePropertyName];
		}
		
		private function changeHandler(event:Event):void
		{
			destination[destinationPropertyName] = source[sourcePropertyName];
		}
	}
}