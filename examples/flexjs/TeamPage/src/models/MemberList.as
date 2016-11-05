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
	import org.apache.flex.collections.LazyCollection;
	import org.apache.flex.core.Application;
	import org.apache.flex.core.IBeadModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.EventDispatcher;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.net.HTTPService;

	[Event(name="membersChanged", type="org.apache.flex.events.Event")]
	public class MemberList extends EventDispatcher implements IBeadModel
	{
		public function MemberList(target:IEventDispatcher=null)
		{
			super(target);
		}

		public var members:Array = null;

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
			service.addEventListener("complete", handleLoadComplete);
		}

		public function handleLoadComplete(event:org.apache.flex.events.Event):void
		{
			members = [];
			trace("We got something back");
			trace("Collection: "+collection.length+" items");
			for (var i:int=0; i < collection.length; i++) {
				var item:Object = collection.getItemAt(i);
				members.push(item);
			}
			dispatchEvent( new Event("membersChanged") );
		}
	}
}
