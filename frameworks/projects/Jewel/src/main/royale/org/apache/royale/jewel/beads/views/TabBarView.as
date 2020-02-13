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
    import org.apache.royale.core.ISelectableItemRenderer;

	COMPILE::JS
	{
	import org.apache.royale.events.Event;
	import org.apache.royale.jewel.itemRenderers.TabBarButtonItemRenderer;
	}

	/**
	 *  The TabBarView class creates the visual elements of the org.apache.royale.jewel.TabBar
	 *  component.
	 *
	 *  @viewbead
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.6
	 */
	public class TabBarView extends ListView
	{
		/**
		 *  constructor.
		 *
		 *  <inject_html>
         *  <script src="https://cdnjs.cloudflare.com/ajax/libs/web-animations/2.3.1/web-animations.min.js"></script>
         *  </inject_html>
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
		public function TabBarView()
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
			var prev_ir:TabBarButtonItemRenderer = dataGroup.getItemRendererAt(lastSelectedIndex) as TabBarButtonItemRenderer;
			var ir:TabBarButtonItemRenderer = dataGroup.getItemRendererAt(listModel.selectedIndex) as TabBarButtonItemRenderer;
            var selectionBead:ISelectableItemRenderer;

			if(prev_ir) {
                selectionBead = prev_ir.getBeadByType(ISelectableItemRenderer) as ISelectableItemRenderer;
                selectionBead.selected = false;
				var lastRect:ClientRect = prev_ir.getBoundingBox;
				var currentRect:ClientRect = ir.getBoundingBox;
				var widthDiff:Number = lastRect.width / currentRect.width;
				if(isNaN(widthDiff))
					widthDiff = 1;
				var positionDiff:Number = lastRect.left - currentRect.left;
				
                selectionBead = ir.getBeadByType(ISelectableItemRenderer) as ISelectableItemRenderer;
                selectionBead.selected = true;
				ir.animateIndicator(positionDiff, widthDiff, 300, 'ease-in-out');				
			} else
			{
                selectionBead = ir.getBeadByType(ISelectableItemRenderer) as ISelectableItemRenderer;
                selectionBead.selected = true;
			}
			
			lastSelectedIndex = listModel.selectedIndex;
		}
	}
}
