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
package org.apache.royale.html.beads.models
{
	
	import org.apache.royale.core.IScrollBarModel;
	import org.apache.royale.events.Event;
		
	/**
	 *  The ScrollBarModel class bead extends the org.apache.royale.html.beads.models.RangeModel 
	 *  and adds page size and page step sizes.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class ScrollBarModel extends RangeModel implements IScrollBarModel
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function ScrollBarModel()
		{
		}
		
		private var _pageSize:Number;
		
		/**
		 *  The amount represented by the thumb control of the org.apache.royale.html.ScrollBar.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
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
		
		/**
		 *  The amount to adjust the org.apache.royale.html.ScrollBar if the scroll bar's 
		 *  track area is selected.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
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
