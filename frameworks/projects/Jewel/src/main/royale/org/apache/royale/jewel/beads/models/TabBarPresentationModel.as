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
package org.apache.royale.jewel.beads.models
{	
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;

	/**
	 *  The TabBarPresentationModel holds values used by tabbar controls for presenting
	 *  their user interfaces.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.10.0
	 */
	public class TabBarPresentationModel extends ListPresentationModel
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.10.0
		 */
		public function TabBarPresentationModel()
		{
			super();

			// (ListPresentationModel) rowHeight is not set by default, so set it to NaN
			//rowHeight = NaN;

			// by default the row height (if set) rules
			variableRowHeight = false;

			// the most basic tabbar item is not just text, are text inside content.
			// so this time layout takes control.
			// also default is center alignment of content
			align = "center";
		}

		private var _indicatorToOppositeSide:Boolean = false;
		/**
		 *  Indicator is positioned by default at the bottom on horizontal tabbars, 
		 *  and to right on vertical tabbars. Setting this to "true", make the indicator
		 *  be positioned on top (horizontal tabbars), or left (vertical tabbars).
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.10.0
		 */
		public function get indicatorToOppositeSide():Boolean
		{
			return _indicatorToOppositeSide;
		}
		public function set indicatorToOppositeSide(value:Boolean):void
		{
			if (value != _indicatorToOppositeSide) {
				_indicatorToOppositeSide = value;
				if(_strand)
					(_strand as IEventDispatcher).dispatchEvent(new Event("indicatorToOppositeSideChanged"));
			}
		}
	}
}
