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
	import org.apache.royale.html.elements.Select;
	}
	import org.apache.royale.core.IItemRenderer;
	import org.apache.royale.core.ISelectableItemRenderer;
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.events.Event;
	import org.apache.royale.html.beads.DataContainerView;
	import org.apache.royale.jewel.DropDownList;
	import org.apache.royale.jewel.beads.models.IDropDownListModel;
	import org.apache.royale.utils.getSelectionRenderBead;

	/**
	 *  The DropDownListView class creates the visual elements of the org.apache.royale.jewel.DropDownList
	 *  component. The job of the view bead is to put together the parts of the DropDownList such as the Select
	 *
	 *  @viewbead
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class DropDownListView extends DataContainerView
	{
		public function DropDownListView()
		{
			super();
		}

		private var dropDownList:DropDownList;

		/**
		 *  The prompt
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royalesuppresspublicvarwarning
		 */
		public var prompt:String = "";

		override protected function dataProviderChangeHandler(event:Event):void
		{
			super.dataProviderChangeHandler(event);

			changedSelection();
		}

		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.core.ISelectionModel
		 */
		override protected function handleInitComplete(event:Event):void
		{
			COMPILE::JS
			{
				dropDownList = _strand as DropDownList;
				dropDownList.dropDown = new Select();

				var name:String = "dropDownList" + Math.random();
				dropDownList.dropDown.element.name = name;

				dropDownList.addElement(dropDownList.dropDown);
			}

			model = _strand.getBeadByType(ISelectionModel) as ISelectionModel;
			model.addEventListener("selectionChanged", selectionChangeHandler);

			super.handleInitComplete(event);
		}

		protected var lastSelectedIndex:int = -1;
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.core.ISelectableItemRenderer
		 * @royaleignorecoercion org.apache.royale.jewel.beads.models.IDropDownListModel
		 */
		protected function selectionChangeHandler(event:Event):void
		{
			var selectionBead:ISelectableItemRenderer;
			var ir:IItemRenderer;
			if (lastSelectedIndex != -1) {
				ir = dataGroup.getItemRendererAt(lastSelectedIndex) as IItemRenderer;
			}

			if(ir)
			{
				selectionBead = getSelectionRenderBead(ir);
				if (selectionBead)
					selectionBead.selected = false;
			}
			var newIndex:int = model.selectedIndex;
			if (model is IDropDownListModel) {
				newIndex += IDropDownListModel(model).offset;
			}

			ir = dataGroup.getItemRendererAt(newIndex) as IItemRenderer;
			if(ir) 
			{
				selectionBead = getSelectionRenderBead(ir);
				if (selectionBead)
					selectionBead.selected = true;
			}

			lastSelectedIndex = newIndex;
		}

		override protected function itemsCreatedHandler(event:org.apache.royale.events.Event):void
		{
			super.itemsCreatedHandler(event);

			changedSelection();
		}

		private var model:ISelectionModel;

		private function changedSelection():void
		{
			model = dataModel as ISelectionModel;
			//var selectedIndex:int = dropDownList.selectedIndex;

		/*  if (model.selectedIndex > -1 && model.dataProvider)
			{*/
			dropDownList.selectedIndex = model.selectedIndex;
			dropDownList.selectedItem = model.selectedItem;
		/*  }*/
		}
	}
}
