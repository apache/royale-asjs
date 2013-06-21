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
package org.apache.flex.html.staticControls.beads
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.UIMetrics;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.staticControls.Container;
	import org.apache.flex.html.staticControls.ControlBar;
	import org.apache.flex.html.staticControls.Panel;
	import org.apache.flex.html.staticControls.TitleBar;
	import org.apache.flex.utils.BeadMetrics;
	
	public class PanelBead implements IBead, IContainerBead
	{
		public function PanelBead()
		{
			_titleBar = new TitleBar();
			_titleBar.initModel();
			_titleBar.initSkin();
		}
		
		private var _titleBar:TitleBar;
		public function get titleBar():TitleBar
		{
			return _titleBar;
		}
		
		private var _controlBar:ControlBar;
		public function get controlBar():ControlBar
		{
			return _controlBar;
		}
		
		private var _strand:IStrand;
		
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			Container(_strand).addChild(titleBar);
			
			var controlBarItems:Array = Panel(_strand).controlBar;
			if( controlBarItems && controlBarItems.length > 0 ) {
				_controlBar = new ControlBar();
				_controlBar.initModel();
				_controlBar.initSkin();
				
				for each(var comp:IUIBase in controlBarItems) {
					comp.addToParent(_controlBar);
				}
				
				Container(_strand).addChild(controlBar);
			}
			
			var paddingLeft:Object;
			var paddingTop:Object;
			var padding:Object = ValuesManager.valuesImpl.getValue(value, "padding");
			if (padding is Array)
			{
				if (padding.length == 1)
					paddingLeft = paddingTop = padding[0];
				else if (padding.length <= 3)
				{
					paddingLeft = padding[1];
					paddingTop = padding[0];
				}
				else if (padding.length == 4)
				{
					paddingLeft = padding[3];
					paddingTop = padding[0];					
				}
			}
			else if (padding == null)
			{
				paddingLeft = ValuesManager.valuesImpl.getValue(value, "padding-left");
				paddingTop = ValuesManager.valuesImpl.getValue(value, "padding-top");
			}
			else
			{
				paddingLeft = paddingTop = padding;
			}
			var pl:Number = Number(paddingLeft);
			var pt:Number = Number(paddingTop);
			
			if( isNaN(pl) ) pl = 0;
			if( isNaN(pt) ) pt = 0;
			
			var actualParent:Sprite = new Sprite();
			DisplayObjectContainer(value).addChild(actualParent);
			Container(value).setActualParent(actualParent);
			actualParent.x = pl;
			actualParent.y = pt;
			
			contentArea = actualParent;
			
			IEventDispatcher(_strand).addEventListener("childrenAdded", changeHandler);
		}
		
		private var contentArea:DisplayObjectContainer;
		private var controlBarArea:ControlBar;
		
		private function changeHandler(event:Event):void
		{
			var metrics:UIMetrics = BeadMetrics.getMetrics(_strand);
			
			titleBar.x = metrics.left;
			titleBar.y = metrics.top;
			titleBar.width = UIBase(_strand).width - (metrics.left + metrics.right);
			
			contentArea.x = metrics.left;
			contentArea.y = titleBar.y + titleBar.height;
			contentArea.width = UIBase(_strand).width - (metrics.left + metrics.right);
			
			if( controlBar ) {
				controlBar.x = metrics.left;
				controlBar.y = contentArea.y + contentArea.height;
				controlBar.width = UIBase(_strand).width - (metrics.left + metrics.right);
			} 
			
			UIBase(_strand).height = metrics.top + metrics.bottom + titleBar.height + contentArea.height +
				(controlBar ? controlBar.height : 0);
		}
	}
}