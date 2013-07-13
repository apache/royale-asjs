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
		
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			_strand = value;
			
			Container(_strand).addChild(titleBar);
			
			var controlBarItems:Array = Panel(_strand).controlBar;
			if( controlBarItems && controlBarItems.length > 0 ) {
				_controlBar = new ControlBar();
				_controlBar.initSkin();
				
				for each(var comp:IUIBase in controlBarItems) {
					comp.addToParent(_controlBar);
				}
				
				Container(_strand).addChild(controlBar);
			}
			
			IEventDispatcher(_strand).addEventListener("childrenAdded", changeHandler);
            
		}
		
		private var controlBarArea:ControlBar;
		
		private function changeHandler(event:Event):void
		{
			var metrics:UIMetrics = BeadMetrics.getMetrics(_strand);
			
			titleBar.x = metrics.left;
			titleBar.y = metrics.top;
			titleBar.width = UIBase(_strand).width - (metrics.left + metrics.right);
			
			actualParent.x = metrics.left;
			actualParent.y = titleBar.y + titleBar.height;
			actualParent.width = UIBase(_strand).width - (metrics.left + metrics.right);
			
			if( controlBar ) {
				controlBar.x = metrics.left;
				controlBar.y = actualParent.y + actualParent.height;
				controlBar.width = UIBase(_strand).width - (metrics.left + metrics.right);
			} 
			
			UIBase(_strand).height = metrics.top + metrics.bottom + titleBar.height + actualParent.height +
				(controlBar ? controlBar.height : 0);
		}
        
	}
}