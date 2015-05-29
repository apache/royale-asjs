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
    import org.apache.flex.core.IPanelModel;
    import org.apache.flex.core.ITitleBarModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.UIMetrics;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.Container;
	import org.apache.flex.html.ControlBar;
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
	public class PanelWithControlBarView extends ContainerView implements IBeadView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function PanelWithControlBarView()
		{
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
			var host:UIBase = UIBase(value);
			
			// TODO: (aharui) get class to instantiate from CSS
			if (!_titleBar)
				_titleBar = new TitleBar();
			_titleBar.percentWidth = 100;
			// replace the TitleBar's model with the Panel's model (it implements ITitleBarModel) so that
			// any changes to values in the Panel's model that correspond values in the TitleBar will 
			// be picked up automatically by the TitleBar.
			titleBar.model = host.model;
			host.addElement(titleBar, false);
			titleBar.addEventListener("heightChanged", changeHandler);
			if (isNaN(host.explicitWidth) && isNaN(host.percentWidth))
				titleBar.addEventListener("widthChanged", changeHandler);
			
			var controlBarItems:Array = (host.model as IPanelModel).controlBar;
			if( controlBarItems && controlBarItems.length > 0 ) {
				_controlBar = new ControlBar();
				_controlBar.percentWidth = 100;
				_controlBar.height = 30;
				
				for each(var comp:IUIBase in controlBarItems) {
					_controlBar.addElement(comp, false);
				}
				_controlBar.dispatchEvent(new Event("layoutNeeded"));
				
				host.addElement(controlBar, false);
				controlBar.addEventListener("heightChanged", changeHandler);
				if (isNaN(host.explicitWidth) && isNaN(host.percentWidth))
					controlBar.addEventListener("widthChanged", changeHandler);
			}
			
			super.strand = value;
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
		override protected function determinePadding():Object
		{
			var paddings:Object = super.determinePadding();
			titleBar.width = UIBase(_strand).width;
			paddings.paddingTop += titleBar.height;
			
			controlBar.width = UIBase(_strand).width;
			paddings.paddingBottom += controlBar.height;

			return paddings;
		}
		
		/**
		 * @private
		 */
		override protected function changeHandler(event:Event):void
		{
			super.changeHandler(event);
			
			controlBar.y = UIBase(_strand).height - controlBar.height;
		}
		
		/**
		 * @private
		 */
		private function layoutChromeElements():void
		{
			var paddings:Object = determinePadding();
			titleBar.x = 0;
			titleBar.y = 0;
			titleBar.width = UIBase(_strand).width;
			
			if (controlBar) {
				controlBar.x = 0;
				controlBar.y = UIBase(_strand).height - controlBar.height;
				controlBar.width = UIBase(_strand).width;
			}
			
			actualParent.x = paddings.paddingLeft;
			actualParent.y = titleBar.height + paddings.paddingTop;
			actualParent.width = UIBase(_strand).width - paddings.paddingLeft - paddings.paddingRight;
			actualParent.height = UIBase(_strand).height - titleBar.height - paddings.paddingTop - paddings.paddingBottom;
			if (controlBar) actualParent.height -= controlBar.height;
		}
	}
}
