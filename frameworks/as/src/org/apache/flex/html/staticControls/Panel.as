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
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IPanelModel;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.html.staticControls.beads.IPanelBead;
	import org.apache.flex.html.staticControls.beads.PanelBead;

	[Event(name="close", type="org.apache.flex.events.Event")]
	
	public class Panel extends Container
	{
		public function Panel()
		{
			super();
		}
		
		public function get title():String
		{
			return IPanelModel(model).title;
		}
		public function set title(value:String):void
		{
			IPanelModel(model).title = value;
		}
		
		public function get htmlTitle():String
		{
			return IPanelModel(model).htmlTitle;
		}
		public function set htmlTitle(value:String):void
		{
			IPanelModel(model).htmlTitle = value;
		}
		
		public function get showCloseButton():Boolean
		{
			return IPanelModel(model).showCloseButton;
		}
		public function set showCloseButton(value:Boolean):void
		{
			IPanelModel(model).showCloseButton = value;
		}
		
		private var _controlBar:Array;
		public function get controlBar():Array
		{
			return _controlBar;
		}
		public function set controlBar(value:Array):void
		{
			_controlBar = value;
		}
		
		override public function initSkin():void
		{
			super.initSkin();
			
			if( getBeadByType(IPanelBead) == null) {
				addBead(new (ValuesManager.valuesImpl.getValue(this,"iPanelBead")) as IBead);
			}
			
		}
	}
}