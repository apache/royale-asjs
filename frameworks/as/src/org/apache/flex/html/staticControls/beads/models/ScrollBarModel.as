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
package org.apache.flex.html.staticControls.beads.models
{
	import flash.events.Event;
	
	import org.apache.flex.core.IScrollBarModel;
		
	public class ScrollBarModel extends RangeModel implements IScrollBarModel
	{
		public function ScrollBarModel()
		{
		}
		
		private var _pageSize:Number;
		public function get pageSize():Number
		{
			return _pageSize;
		}
		
		public function set pageSize(value:Number):void
		{
			if (value != _pageSize)
			{
				_pageSize = value;
				dispatchEvent(new Event("pageSizeChange"));
			}
		}
				
		private var _pageStepSize:Number;
		public function get pageStepSize():Number
		{
			return _pageStepSize;
		}
		
		public function set pageStepSize(value:Number):void
		{
			if (value != _pageStepSize)
			{
				_pageStepSize = value;
				dispatchEvent(new Event("pageStepSizeChange"));
			}
		}
		
	}
}