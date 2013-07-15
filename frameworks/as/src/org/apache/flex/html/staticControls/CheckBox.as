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
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IBeadModel;
	import org.apache.flex.core.IToggleButtonModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.UIButtonBase;
	import org.apache.flex.events.Event;
	
	[Event(name="change", type="org.apache.flex.events.Event")]

	public class CheckBox extends UIButtonBase implements IStrand
	{
		public function CheckBox(upState:DisplayObject=null, overState:DisplayObject=null, downState:DisplayObject=null, hitTestState:DisplayObject=null)
		{
			super(upState, overState, downState, hitTestState);
			
			addEventListener(MouseEvent.CLICK, internalMouseHandler);
		}
		
		public function get text():String
		{
			return IToggleButtonModel(model).text;
		}
		public function set text(value:String):void
		{
			IToggleButtonModel(model).text = value;
		}
		
		public function get selected():Boolean
		{
			return IToggleButtonModel(model).selected;
		}
		
		public function set selected(value:Boolean):void
		{
			IToggleButtonModel(model).selected = value;
		}
				
		private function internalMouseHandler(event:MouseEvent) : void
		{
			selected = !selected;
			dispatchEvent(new Event("change"));
		}
	}
}