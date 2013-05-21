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
	
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.ITitleBarModel;
	import org.apache.flex.core.ITitleBarBead;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	
	public class TitleBar extends UIBase
	{
		public function TitleBar()
		{
			super();
			
			this.addEventListener('widthChanged',handleSizeChange);
			this.addEventListener('heightChanged',handleSizeChange);
		}
		
		public function get text():String
		{
			return ITitleBarModel(model).title;
		}
		public function set text(value:String):void
		{
			ITitleBarModel(model).title = value;
		}
		
		public function get html():String
		{
			return ITitleBarModel(model).htmlTitle;
		}
		public function set html(value:String):void
		{
			ITitleBarModel(model).htmlTitle = value;
		}
		
		override public function initModel():void
		{
			if (getBeadByType(ITitleBarModel) == null)
				addBead(new (ValuesManager.valuesImpl.getValue(this, "iTitleBarModel")) as IBead);
		}
		
		public function initSkin():void
		{
			if (getBeadByType(ITitleBarBead) == null)
				addBead(new (ValuesManager.valuesImpl.getValue(this, "iTitleBarBead")) as IBead);			
		}
		
		private function handleSizeChange(event:Event):void
		{
			IEventDispatcher(getBeadByType(ITitleBarModel)).dispatchEvent(new Event("widthChanged"));
			IEventDispatcher(getBeadByType(ITitleBarModel)).dispatchEvent(new Event("heightChanged"));
		}
	}
}