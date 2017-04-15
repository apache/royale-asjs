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
package controller
{	
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IBeadModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.events.EventDispatcher;
	import org.apache.flex.events.CollectionEvent;
	
	public class DataModelChangeNotifier extends EventDispatcher implements IBead
	{
		public function DataModelChangeNotifier()
		{
			super();
		}
		
		private var _strand:IStrand;
		private var _propertyName:String = "dataProvider";
		
		public function get propertyName():String
		{
			return _propertyName;
		}
		public function set propertyName(value:String):void
		{
			_propertyName = value;
		}
		
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			IEventDispatcher(_strand).addEventListener("initBindings", handleInitBindings);
		}
		
		private function handleInitBindings(event:Event):void
		{
			var model:Object = _strand.getBeadByType(IBeadModel) as Object;
			var property:IEventDispatcher = model[propertyName] as IEventDispatcher;
			
			property.addEventListener(CollectionEvent.ITEM_ADDED, handleModelChanges);
			property.addEventListener(CollectionEvent.ITEM_REMOVED, handleModelChanges);
			property.addEventListener(CollectionEvent.ITEM_UPDATED, handleModelChanges);
		}
		
		private function handleModelChanges(event:CollectionEvent):void
		{
			var model:IEventDispatcher = _strand.getBeadByType(IBeadModel) as IEventDispatcher;
			model.dispatchEvent(new Event("dataProviderChanged"));
		}
	}
}