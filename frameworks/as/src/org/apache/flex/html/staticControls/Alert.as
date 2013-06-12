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
	import org.apache.flex.core.IAlertModel;
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IInitSkin;
	import org.apache.flex.core.IPopUp;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.html.staticControls.beads.IAlertBead;
	
	public class Alert extends UIBase implements IInitSkin, IPopUp
	{
		public static const YES:uint    = 0x000001;
		public static const NO:uint     = 0x000002;
		public static const OK:uint     = 0x000004;
		public static const CANCEL:uint = 0x000008;
		
		public function Alert()
		{
			super();
		}
		
		// note: only passing parent to this function as I don't see a way to identify
		// the 'application' or top level view without supplying a place to start to
		// look for it.
		static public function show( text:String, parent:Object, title:String="", flags:uint=Alert.OK ) : void
		{
			var alert:Alert = new Alert();
			alert.initModel();
			alert.message = text;
			alert.title  = title;
			alert.flags = flags;
			alert.initSkin();
			
			alert.show(parent);
		}
		
		public function show(parent:Object) : void
		{
			addToParent(parent);
		}
		
		override public function initModel():void
		{
			if (getBeadByType(IAlertModel) == null)
				addBead(new (ValuesManager.valuesImpl.getValue(this, "iAlertModel")) as IBead);
		}
		
		public function get title():String
		{
			return IAlertModel(model).title;
		}
		public function set title(value:String):void
		{
			IAlertModel(model).title = value;
		}
		
		public function get message():String
		{
			return IAlertModel(model).message;
		}
		public function set message(value:String):void
		{
			IAlertModel(model).message = value;
		}
		
		public function get flags():uint
		{
			return IAlertModel(model).flags;
		}
		public function set flags(value:uint):void
		{
			IAlertModel(model).flags = value;
		}
		
		
		public function initSkin():void
		{
			if( getBeadByType(IAlertBead) == null ) {
				addBead(new (ValuesManager.valuesImpl.getValue(this, "iAlertBead")) as IBead);
			}
			
			addEventListener("close",handleAlertClose);
		}
		
		private function handleAlertClose(event:Event):void
		{
			this.parent.removeChild(this);
		}
	}
}