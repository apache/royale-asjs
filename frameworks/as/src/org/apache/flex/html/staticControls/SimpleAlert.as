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
package org.apache.flex.html.staticControls
{
	import flash.display.DisplayObjectContainer;
	
	import org.apache.flex.core.IAlertModel;
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IInitSkin;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.html.staticControls.beads.ISimpleAlertBead;
	
	[Event(name="close", type="org.apache.flex.events.Event")]
	
	public class SimpleAlert extends UIBase implements IInitSkin
	{
		public function SimpleAlert()
		{
			super();
		}
		
		override public function initModel():void
		{
			if (getBeadByType(IAlertModel) == null)
				addBead(new (ValuesManager.valuesImpl.getValue(this, "iAlertModel")) as IBead);
		}
		
		private function get message():String
		{
			return IAlertModel(model).message;
		}
		private function set message(value:String):void
		{
			IAlertModel(model).message = value;
		}
		
		private function get htmlMessage():String
		{
			return IAlertModel(model).htmlMessage;
		}
		private function set htmlMessage(value:String):void
		{
			IAlertModel(model).htmlMessage = value;
		}
		
		public function initSkin():void
		{
			if( getBeadByType(ISimpleAlertBead) == null ) {
				addBead(new (ValuesManager.valuesImpl.getValue(this, "iAlertBead")) as IBead);
			}
		}
		
		public function show(parent:Object) : void
		{
			(getBeadByType(ISimpleAlertBead) as ISimpleAlertBead).showPopUp(parent as DisplayObjectContainer);
		}
		
		public function hide() : void
		{
			(getBeadByType(ISimpleAlertBead) as ISimpleAlertBead).hidePopUp();
		}
		
		static public function show(message:String, parent:Object):SimpleAlert
		{
			var alert:SimpleAlert = new SimpleAlert();
			alert.initModel();
			alert.message = message;
			alert.initSkin();
			alert.show(parent);
			
			return alert;
		}
	}
}