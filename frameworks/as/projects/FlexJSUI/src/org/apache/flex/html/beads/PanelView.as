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
package org.apache.flex.html.beads
{
	import flash.display.Sprite;
	
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.UIMetrics;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.Container;
	import org.apache.flex.html.ControlBar;
	import org.apache.flex.html.Panel;
	import org.apache.flex.html.TitleBar;
	import org.apache.flex.utils.BeadMetrics;
	
	/**
	 *  The Panel class creates the visual elements of the org.apache.flex.html.Panel 
	 *  component. A Panel has a org.apache.flex.html.TitleBar, content, and an 
	 *  optional org.apache.flex.html.ControlBar.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class PanelView extends ContainerView implements IBeadView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function PanelView()
		{
			_titleBar = new TitleBar();
		}
		
		private var _titleBar:TitleBar;
		
		/**
		 *  The org.apache.flex.html.TitleBar component of the 
		 *  org.apache.flex.html.Panel.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get titleBar():TitleBar
		{
			return _titleBar;
		}
		
		private var _controlBar:ControlBar;
		
		/**
		 *  The org.apache.flex.html.ControlBar for the Panel; may be null.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get controlBar():ControlBar
		{
			return _controlBar;
		}
		
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			
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
		
		/**
		 *  Always returns true because Panel's content is separate from its chrome
		 *  elements such as the title bar and optional control bar.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		override protected function contentAreaNeeded():Boolean
		{
			return true;
		}
		
		/**
		 * @private
		 */
		private function changeHandler(event:Event):void
		{
			var metrics:UIMetrics = BeadMetrics.getMetrics(_strand);
			
			var w:Number = UIBase(_strand).explicitWidth;
			if (isNaN(w)) w = Math.max(titleBar.width,actualParent.width+metrics.left+metrics.right,controlBar?controlBar.width:0);
			
			var h:Number = UIBase(_strand).explicitHeight;
			if (isNaN(h)) h = titleBar.height + actualParent.height + (controlBar ? controlBar.height : 0) +
				metrics.top + metrics.bottom;
			
			titleBar.x = 0;
			titleBar.y = 0;
			titleBar.width = w;
			
			var remainingHeight:Number = h - titleBar.height;
			
			if( controlBar ) {
				controlBar.x = 0;
				controlBar.y = h - controlBar.height;
				//controlBar.y = actualParent.y + actualParent.height + metrics.bottom;
				controlBar.width = w;
				
				remainingHeight -= controlBar.height;
			}
			
			actualParent.x = metrics.left;
			actualParent.y = titleBar.y + titleBar.height + metrics.top;
			actualParent.width = w;
			actualParent.height = remainingHeight - metrics.top - metrics.bottom;
			
			UIBase(_strand).width = w;
			UIBase(_strand).height = h;
		}
        
	}
}
