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
package org.apache.royale.html.beads
{
	import org.apache.royale.core.IBeadView;
	import org.apache.royale.core.IChild;
	import org.apache.royale.core.IContentViewHost;
	import org.apache.royale.core.ILayoutChild;
	import org.apache.royale.core.IPanelModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.ITitleBarModel;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.IViewportModel;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.geom.Rectangle;
	import org.apache.royale.geom.Size;
	import org.apache.royale.html.Container;
	import org.apache.royale.html.Panel;
	import org.apache.royale.html.ControlBar;
	import org.apache.royale.html.TitleBar;
	
	COMPILE::SWF {
		import org.apache.royale.core.SimpleCSSStylesWithFlex;
	}
	
	/**
	 *  The Panel class creates the visual elements of the org.apache.royale.html.Panel 
	 *  component. A Panel has a org.apache.royale.html.TitleBar, content, and an 
	 *  optional org.apache.royale.html.ControlBar.
	 *  
	 *  @viewbead
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class PanelWithControlBarView extends PanelView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function PanelWithControlBarView()
		{
			super();
		}
		
		private var _controlBar:ControlBar;
		
		/**
		 *  The org.apache.royale.html.ControlBar for the Panel; may be null.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get controlBar():ControlBar
		{
			return _controlBar;
		}
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			
			var host:UIBase = UIBase(_strand);
			
			_controlBar = new ControlBar();
			_controlBar.id = "panelControlBar";
			
			COMPILE::SWF {
				_controlBar.percentWidth = 100;
				
				if (_controlBar.style == null) {
					_controlBar.style = new SimpleCSSStylesWithFlex();
				}
				_controlBar.style.flexGrow = 0;
				_controlBar.style.order = 3;
			}
				
			COMPILE::JS {
				_controlBar.element.style["flex-grow"] = "0";
				_controlBar.element.style["order"] = "3";
			}
		}
		
		override protected function completeSetup():void
		{
			if (titleBar.parent == null) {
				(_strand as Panel).$addElement(titleBar);
			}
			if (contentArea.parent == null) {
				(_strand as Panel).$addElement(contentArea as IChild);
			}
			if (controlBar.parent == null) {
				(_strand as Panel).$addElement(controlBar);
			}
			
			var host:UIBase = UIBase(_strand);
			
			var controlBarItems:Array = (host.model as IPanelModel).controlBar;
			if( controlBarItems && controlBarItems.length > 0 ) {
				for each(var comp:IUIBase in controlBarItems) {
					controlBar.addElement(comp, false);
				}
				controlBar.childrenAdded();
			}
			
			super.completeSetup();
			
			performLayout(null);
		}
		
		override protected function handleSizeChange(event:Event):void
		{
			COMPILE::JS {
				titleBar.percentWidth = 100;
				contentArea.percentWidth = 100;
				controlBar.percentWidth = 100;
			}
				
			performLayout(event);
		}       
	}
}
