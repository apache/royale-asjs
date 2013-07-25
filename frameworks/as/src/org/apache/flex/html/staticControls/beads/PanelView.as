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
	import flash.display.Sprite;
	
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.UIMetrics;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.staticControls.Container;
	import org.apache.flex.html.staticControls.ControlBar;
	import org.apache.flex.html.staticControls.Panel;
	import org.apache.flex.html.staticControls.TitleBar;
	import org.apache.flex.utils.BeadMetrics;
	
	public class PanelView extends ContainerView implements IBeadView
	{
		public function PanelView()
		{
			_titleBar = new TitleBar();
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
		
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			_strand = value;
			
			// replace the TitleBar's model with the Panel's model (it implements ITitleBarModel) so that
			// any changes to values in the Panel's model that correspond values in the TitleBar will 
			// be picked up automatically by the TitleBar.
			titleBar.model = Panel(_strand).model;
			Container(_strand).addElement(titleBar);
			
			var controlBarItems:Array = Panel(_strand).controlBar;
			if( controlBarItems && controlBarItems.length > 0 ) {
				_controlBar = new ControlBar();
				
				for each(var comp:IUIBase in controlBarItems) {
					_controlBar.addElement(comp);
				}
				
				Container(_strand).addElement(controlBar);
			}
			
			IEventDispatcher(_strand).addEventListener("childrenAdded", changeHandler);
            
		}
		
		private var controlBarArea:ControlBar;
		
		private function changeHandler(event:Event):void
		{
			var metrics:UIMetrics = BeadMetrics.getMetrics(_strand);
			
			var w:Number = Math.max(titleBar.width,actualParent.width+metrics.left+metrics.right,controlBar?controlBar.width:0);
			
			var h:Number = titleBar.height + actualParent.height + (controlBar ? controlBar.height : 0) +
				metrics.top + metrics.bottom;
			
			titleBar.x = 0;
			titleBar.y = 0;
			titleBar.width = w;
			
			actualParent.x = metrics.left;
			actualParent.y = titleBar.y + titleBar.height + metrics.top;
			
			if( controlBar ) {
				controlBar.x = 0;
				controlBar.y = actualParent.y + actualParent.height + metrics.bottom;
				controlBar.width = w;
			}
			
			UIBase(_strand).width = w;
			UIBase(_strand).height = h;
		}
        
	}
}