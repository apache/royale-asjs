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
package org.apache.flex.net
{
	import org.apache.flex.net.events.FaultEvent;
	import org.apache.flex.net.events.ResultEvent;
	
	import org.apache.flex.events.EventDispatcher;
	import org.apache.flex.reflection.getClassByAlias;
	import org.apache.flex.reflection.registerClassAlias;

	[Event(name="result", type="org.apache.flex.net.events.ResultEvent")]
	[Event(name="fault", type="org.apache.flex.net.events.FaultEvent")]
	public class RemoteObject extends EventDispatcher
	{
		private var _endPoint:String;
		private var _destination:String;
		private var _source:String;
		
		/** 
		 * 
		 * <inject_html>
		 * <script src="https://rawgit.com/emilkm/amfjs/master/amf.js"></script>
		 * </inject_html>
		 */ 
		public function RemoteObject()
		{
		}
		
		public function set endPoint(value:String):void
		{
			_endPoint = value;	
		}
		public function get endPoint():String
		{
			return _endPoint;	
		}
		
		public function set destination(value:String):void
		{
			_destination = value;	
		}
		public function get destination():String
		{
			return _destination;	
		}
		
		public function set source(value:String):void
		{
			_source = value;	
		}
		public function get source():String
		{
			return _source;	
		}
		
		public function send(operation:String , params:Array):void
		{
			COMPILE::JS
			{				
				var amfClient:Object = new ((window as Object).amf).Client(_destination, _endPoint);
				var amfReq:Object = amfClient.invoke(_source, operation, params[0]);
				amfReq.then(resultHandler , faultHandler);
			}
		}
		
		private function resultHandler(param:Object):void
		{
			if(param is Object && param.hasOwnProperty("_explicitType"))
			{
				param = typeUntypedObject(param);
			}
			else if (param is Array && param.length > 0)
			{
				for(var i:uint ; i < param.length ; i++)
				{
					var typedObj:Object = typeUntypedObject(param[i]);
					param[i] = typedObj;
				}
			}			
			dispatchEvent(new ResultEvent(ResultEvent.RESULT,param));
		}
		
		private function faultHandler(param:Object):void
		{
			dispatchEvent(new FaultEvent(FaultEvent.FAULT,param));
		}
		
		private function typeUntypedObject(unTypeObject:Object):Object
		{
			registerClassAlias(unTypeObject['_explicitType'],getClassByAlias(unTypeObject['_explicitType']));
			
			var classToInstantiate:Class = getClassByAlias(unTypeObject['_explicitType']); 
			
			var typedInstance:Object = new classToInstantiate(); 
			
			for (var field:String in unTypeObject) 
			{ 
				if (field == "_explicitType") continue; //Do nothing incase of "_explicitType"
				
				typedInstance[field] = unTypeObject[field]; 
			}

			return  typedInstance;
		}
	}
}