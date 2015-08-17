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
package org.apache.flex.html.beads.models
{
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.IViewportModel;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.EventDispatcher;
	
	public class ViewportModel extends EventDispatcher implements IViewportModel
	{
		public function ViewportModel()
		{
			super();
		}
		
		private var _contentIsHost:Boolean = false;
		private var _contentArea:IUIBase;
		private var _contentWidth:Number = 0;
		private var _contentHeight:Number = 0;
		private var _contentX:Number = 0;
		private var _contentY:Number = 0;
		private var _viewportWidth:Number = 0;
		private var _viewportHeight:Number = 0;
		private var _viewportX:Number = 0;
		private var _viewportY:Number = 0;
		private var _verticalScrollPosition:Number = 0;
		private var _horizontalScrollPosition:Number = 0;
		
		public function get contentArea():IUIBase
		{
			return _contentArea;
		}
		public function set contentArea(value:IUIBase):void
		{
			_contentArea = value;
			dispatchEvent( new Event("contentAreaChanged") );
		}
		
		public function get contentIsHost():Boolean
		{
			return _contentIsHost;
		}
		public function set contentIsHost(value:Boolean):void
		{
			_contentIsHost = value;
		}
		
		public function get viewportWidth():Number
		{
			return _viewportWidth;
		}
		public function set viewportWidth(value:Number):void
		{
			_viewportWidth = value;
		}
		
		public function get viewportHeight():Number
		{
			return _viewportHeight;
		}
		public function set viewportHeight(value:Number):void
		{
			_viewportHeight = value;
		}
		
		public function get viewportX():Number
		{
			return _viewportX;
		}
		public function set viewportX(value:Number):void
		{
			_viewportX = value;
		}
		
		public function get viewportY():Number
		{
			return _viewportY;
		}
		public function set viewportY(value:Number):void
		{
			_viewportY = value;
		}
		
		public function get contentWidth():Number
		{
			return _contentWidth;
		}
		public function set contentWidth(value:Number):void
		{
			_contentWidth = value;
		}
		
		public function get contentHeight():Number
		{
			return _contentHeight;
		}
		public function set contentHeight(value:Number):void
		{
			_contentHeight = value;
		}
		
		public function get contentX():Number
		{
			return _contentX;
		}
		public function set contentX(value:Number):void
		{
			_contentX = value;
		}
		
		public function get contentY():Number
		{
			return _contentY;
		}
		public function set contentY(value:Number):void
		{
			_contentY = value;
		}
		
		public function get verticalScrollPosition():Number
		{
			return _verticalScrollPosition;
		}
		public function set verticalScrollPosition(value:Number):void
		{
			_verticalScrollPosition = value;
			dispatchEvent( new Event("verticalScrollPositionChanged") );
		}
		
		public function get horizontalScrollPosition():Number
		{
			return _horizontalScrollPosition;
		}
		public function set horizontalScrollPosition(value:Number):void
		{
			_horizontalScrollPosition = value;
		}
		
		private var _strand:IStrand;
		
		public function set strand(value:IStrand):void
		{
			_strand = value;
		}
	}
}