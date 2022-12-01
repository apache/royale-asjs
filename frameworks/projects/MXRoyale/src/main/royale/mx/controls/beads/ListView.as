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
package mx.controls.beads
{
	COMPILE::SWF
	{
	import org.apache.royale.core.IStrand;
	}
	import org.apache.royale.core.IItemRenderer;
	import org.apache.royale.core.ISelectableItemRenderer;
	import org.apache.royale.events.Event;
	import org.apache.royale.utils.getSelectionRenderBead;
	import org.apache.royale.html.beads.ListView;

	/**
	 *  The List class creates the visual elements of the org.apache.royale.html.List
	 *  component. A List consists of the area to display the data (in the dataGroup), any
	 *  scrollbars, and so forth.
	 *
	 *  @viewbead
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.10
	 */
	COMPILE::JS
	public class ListView extends org.apache.royale.html.beads.ListView
	{
		override protected function selectionChangeHandler(event:Event):void
		{
			var selectionBead:ISelectableItemRenderer;
			var ir:IItemRenderer = dataGroup.getItemRendererForIndex(lastSelectedIndex) as IItemRenderer;
			if (ir) 
			{
				selectionBead = getSelectionRenderBead(ir);
				if (selectionBead)
				{
					selectionBead.selected = false;
					selectionBead.down = false;
				}
			}
			ir = dataGroup.getItemRendererForIndex(listModel.selectedIndex) as IItemRenderer;
			if (ir) {
				selectionBead = getSelectionRenderBead(ir);
				if (selectionBead)
					selectionBead.selected = true;
			}
			lastSelectedIndex = listModel.selectedIndex;
		}

	}
}
