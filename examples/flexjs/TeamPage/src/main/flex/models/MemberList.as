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
package models
{
	import org.apache.royale.collections.LazyCollection;
	import org.apache.royale.core.Application;
	import org.apache.royale.core.IBeadModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.net.HTTPService;

	[Event(name="membersChanged", type="org.apache.royale.events.Event")]
	public class MemberList extends EventDispatcher implements IBeadModel
	{
		public function MemberList(target:IEventDispatcher=null)
		{
			super(target);
		}

		private var _members:Array = null;
		public function get members():Array
		{
			return _members;
		}
		public function set members(value:Array):void
		{
			_members = value;
		}

		private var app:Application;
		private var service:HTTPService;
		private var collection:LazyCollection;

		private var _strand:IStrand;
		public function set strand(value:IStrand):void
		{
			_strand = value;

			app = value as Application;
			if (app) {
				app.addEventListener("viewChanged", viewChangeHandler);
			}
		}

		private function viewChangeHandler(event:Event):void
		{
			service = app["service"] as HTTPService;
			collection = app["collection"] as LazyCollection;

			loadMembers();
		}

		public function loadMembers():void
		{
			service.url = "team.json";
			service.send();
			service.addEventListener("httpStatus", handleStatusReturn);
			service.addEventListener("complete", handleLoadComplete);
			service.addEventListener("ioError", handleError);
		}

		public function handleStatusReturn(event:org.apache.royale.events.Event):void
		{
			// tbd: should handle a bad status here
		}

		public function handleLoadComplete(event:org.apache.royale.events.Event):void
		{
			members = [];
			for (var i:int=0; i < collection.length; i++) {
				var item:Object = collection.getItemAt(i);
				members.push(item);
			}
			dispatchEvent( new Event("membersChanged") );
		}

		public function handleError(event:org.apache.royale.events.Event):void
		{
			// tbd: should handle error here
		}
	}
}
