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
package org.apache.flex.mobile.beads
{
	import org.apache.flex.core.IBeadModel;
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.events.Event;
	import org.apache.flex.html.beads.layouts.NonVirtualHorizontalLayout;
	import org.apache.flex.mobile.ManagerBase;
	import org.apache.flex.mobile.chrome.NavigationBar;
	import org.apache.flex.mobile.chrome.ToolBar;
	import org.apache.flex.mobile.models.ViewManagerModel;
	
	/**
	 * The StackedViewManagerView creates the visual elements of the StackedViewManager. This
	 * includes a NavigationBar, ToolBar, and contentArea.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class StackedViewManagerView implements IBeadView
	{
		/**
		 * Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function StackedViewManagerView()
		{
			super();
			
			layoutReady = false;
		}
		
		private var _navigationBar:NavigationBar;
		private var _toolBar:ToolBar;
		
		private var layoutReady:Boolean;
		
		private var _strand:ManagerBase;
		
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value as ManagerBase;
			_strand.addEventListener("widthChanged", changeHandler);
			_strand.addEventListener("heightChanged", changeHandler);
			
			var model:ViewManagerModel = value.getBeadByType(IBeadModel) as ViewManagerModel;
			model.addEventListener("viewsChanged", handleModelChanged);
			model.addEventListener("viewPushed", handleModelChanged);
			model.addEventListener("viewPopped", handleModelChanged);
			
			if (model.navigationBarItems)
			{
				_navigationBar = new NavigationBar();
				_navigationBar.controls = model.navigationBarItems;
				_navigationBar.addBead(new NonVirtualHorizontalLayout());
				_strand.addElement(_navigationBar);
			}
			
			if (model.toolBarItems)
			{
				_toolBar = new ToolBar();
				_toolBar.controls = model.toolBarItems;
				_toolBar.addBead(new NonVirtualHorizontalLayout());
				_strand.addElement(_toolBar);
			}
			
			layoutReady = true;
			layoutChromeElements();			
		}

		/**
		 * @private
		 */
		private function layoutChromeElements():void
		{
			var contentAreaY:Number = 0;
			var contentAreaHeight:Number = _strand.height;
			
			var model:ViewManagerModel = _strand.getBeadByType(IBeadModel) as ViewManagerModel;
			
			if (_navigationBar)
			{
				_navigationBar.x = 0;
				_navigationBar.y = 0;
				_navigationBar.width = _strand.width;
				
				contentAreaY = _navigationBar.height;
				contentAreaHeight -= _navigationBar.height;
				
				model.navigationBar = _navigationBar;
			}
			
			if (_toolBar)
			{
				_toolBar.x = 0;
				_toolBar.y = _strand.height - _toolBar.height;
				_toolBar.width = _strand.width;
				
				contentAreaHeight -= _toolBar.height;
				
				model.toolBar = _toolBar;
			}
			
			_strand.contentArea.x = 0;
			_strand.contentArea.y = contentAreaY;
			_strand.contentArea.width = _strand.width;
			_strand.contentArea.height = contentAreaHeight;
		}
		
		
		/**
		 * @private
		 */
		protected function changeHandler(event:Event):void
		{
			if (layoutReady) layoutChromeElements();
		}
		
		/**
		 * @private
		 */
		private function handleModelChanged(event:Event):void
		{
			trace("Model event: "+event.type);
		}
		
		/**
		 * @private
		 */
		public function get host():IUIBase
		{
			return _strand;
		}
		
		/**
		 * @private
		 */
		public function get viewWidth():Number
		{
			return _strand.width;
		}
		
		/**
		 * @private
		 */
		public function get viewHeight():Number
		{
			return _strand.height;
		}
	}
}