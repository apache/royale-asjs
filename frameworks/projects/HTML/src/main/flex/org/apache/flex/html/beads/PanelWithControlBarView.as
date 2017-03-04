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
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IContentViewHost;
	import org.apache.flex.core.ILayoutChild;
	import org.apache.flex.core.IPanelModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.ITitleBarModel;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.IViewportModel;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.geom.Rectangle;
	import org.apache.flex.geom.Size;
	import org.apache.flex.html.Container;
	import org.apache.flex.html.ControlBar;
	import org.apache.flex.html.TitleBar;
	import org.apache.flex.utils.CSSContainerUtils;
	
	/**
	 *  The Panel class creates the visual elements of the org.apache.flex.html.Panel 
	 *  component. A Panel has a org.apache.flex.html.TitleBar, content, and an 
	 *  optional org.apache.flex.html.ControlBar.
	 *  
	 *  @viewbead
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
			if (!_titleBar) {
				_titleBar = new TitleBar();
				_titleBar.id = "panelTitleBar";
				_titleBar.height = 30;
			}
			// replace the TitleBar's model with the Panel's model (it implements ITitleBarModel) so that
			// any changes to values in the Panel's model that correspond values in the TitleBar will 
			// be picked up automatically by the TitleBar.
			_titleBar.model = host.model;
			
			var controlBarItems:Array = (host.model as IPanelModel).controlBar;
			if( controlBarItems && controlBarItems.length > 0 ) {
				_controlBar = new ControlBar();
				_controlBar.id = "panelControlBar";
				_controlBar.height = 30;
				
				for each(var comp:IUIBase in controlBarItems) {
					_controlBar.addElement(comp, false);
				}
			}
			
			super.strand = value;
		}
		
		override protected function completeSetup():void
		{
			super.completeSetup();
			
			(_strand as IContentViewHost).strandChildren.addElement(titleBar, false);
			
			if (controlBar) {
				(_strand as IContentViewHost).strandChildren.addElement(_controlBar, false);
			}
		}
		
        /**
         * Calculate the space taken up by non-content children like a TItleBar in a Panel.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        override protected function getChromeMetrics():Rectangle
        {
            return new Rectangle(0, titleBar.height, 0, controlBar.height - titleBar.height);
        }
        
        override protected function layoutViewBeforeContentLayout():void
        {
            var vm:IViewportModel = viewportModel;
            var host:ILayoutChild = this.host as ILayoutChild;
            var hasHeight:Boolean = !host.isHeightSizedToContent();
            var hasWidth:Boolean = !host.isWidthSizedToContent();
            vm.borderMetrics = CSSContainerUtils.getBorderMetrics(host);
            titleBar.x = vm.borderMetrics.left;
            titleBar.y = vm.borderMetrics.top;
            if (hasWidth) 
            {
                titleBar.width = host.width - vm.borderMetrics.left - vm.borderMetrics.right;
                controlBar.width = host.width - vm.borderMetrics.left - vm.borderMetrics.right;
            }
            vm.chromeMetrics = getChromeMetrics();
            controlBar.x = vm.borderMetrics.left;
            if (hasHeight && hasWidth) 
                controlBar.y = host.height - vm.borderMetrics.bottom - controlBar.height;
            
            viewport.setPosition(vm.borderMetrics.left + vm.chromeMetrics.left,
                vm.borderMetrics.top + vm.chromeMetrics.top);
            viewport.layoutViewportBeforeContentLayout(
                hasWidth ? 
                    host.width - vm.borderMetrics.left - vm.borderMetrics.right -
                        vm.chromeMetrics.left - vm.chromeMetrics.right : NaN,
                hasHeight ?
                    host.height - vm.borderMetrics.top - vm.borderMetrics.bottom -
                        vm.chromeMetrics.top - vm.chromeMetrics.bottom : NaN);
        }
        
        override protected function layoutViewAfterContentLayout():void
        {
            var vm:IViewportModel = viewportModel;
            var viewportSize:Size = this.viewport.layoutViewportAfterContentLayout();
            var host:ILayoutChild = this.host as ILayoutChild;
            var hasWidth:Boolean = !host.isWidthSizedToContent();
            var hasHeight:Boolean = !host.isHeightSizedToContent();
            if (!hasWidth) {
                titleBar.width = viewportSize.width; // should get titlebar to layout and get new height
                vm.chromeMetrics = this.getChromeMetrics();
                vm.chromeMetrics.top = titleBar.height;
                controlBar.width = viewportSize.width; // should get controlbar to layout and get new height
                vm.chromeMetrics.bottom = controlBar.height;
            }
            super.layoutViewAfterContentLayout();
            if (!hasHeight) {
                controlBar.y = host.height - vm.borderMetrics.bottom - controlBar.height;
            }
        }       
	}
}
