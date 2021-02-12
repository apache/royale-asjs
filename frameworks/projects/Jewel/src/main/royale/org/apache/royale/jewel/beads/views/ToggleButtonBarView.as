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
package org.apache.royale.jewel.beads.views
{
	COMPILE::JS
	{
	import org.apache.royale.events.Event;
	import org.apache.royale.jewel.ToggleButtonBar;
	import org.apache.royale.jewel.itemRenderers.ToggleButtonBarItemRenderer;
	}

	/**
	 *  The ToggleButtonBarView class creates the visual elements of the org.apache.royale.jewel.TabBar
	 *  component.
	 *
	 *  @viewbead
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.8
	 */
	public class ToggleButtonBarView extends ButtonBarView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 */
		public function ToggleButtonBarView()
		{
			super();
		}

		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.core.StyledMXMLItemRenderer
		 */
		COMPILE::JS
		override protected function selectionChangeHandler(event:Event):void
		{
			// var toggleButtonBar:ToggleButtonBar = buttonBar as ToggleButtonBar;
			
			var prev_ir:ToggleButtonBarItemRenderer = dataGroup.getItemRendererAt(lastSelectedIndex) as ToggleButtonBarItemRenderer;
			var ir:ToggleButtonBarItemRenderer = dataGroup.getItemRendererAt(listModel.selectedIndex) as ToggleButtonBarItemRenderer;

			if(listModel.selectedIndex != -1)
			{
				if(prev_ir != ir)
				{
					if(prev_ir)
						prev_ir.selected = false;
					ir.selected = true;
				} else {
					if(listModel.selectedIndex == ir.index && ir.selected)
					{
						ir.selected = false;
						listModel.selectedIndex = -1;
					}
				}
			}
			
			lastSelectedIndex = listModel.selectedIndex;
		}
	}
}
