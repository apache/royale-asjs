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
package org.apache.royale.jewel.beads.controllers
{
	COMPILE::SWF
	{
	import flash.utils.setTimeout;
    }
	import org.apache.royale.core.IBeadController;
	import org.apache.royale.core.IComboBoxModel;
	import org.apache.royale.core.IItemRendererOwnerView;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.KeyboardEvent;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.html.beads.IListView;
	import org.apache.royale.html.supportClasses.StyledDataItemRenderer;
	import org.apache.royale.jewel.List;
	import org.apache.royale.jewel.beads.controls.combobox.IComboBoxView;
	import org.apache.royale.jewel.beads.models.IJewelSelectionModel;
	import org.apache.royale.jewel.beads.views.ComboBoxPopUpView;
	import org.apache.royale.jewel.supportClasses.combobox.ComboBoxPopUp;

	/**
	 *  The ComboBoxController class is responsible for listening to
	 *  mouse event related to ComboBox. Events such as selecting a item
	 *  or changing the sectedItem.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class ComboBoxController implements IBeadController
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function ComboBoxController()
		{
		}

		protected var viewBead:IComboBoxView;
		private var list:List;
		private var model:IComboBoxModel;

		private var _strand:IStrand;
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
         *  @royaleignorecoercion org.apache.royale.jewel.beads.controls.combobox.IComboBoxView
         *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			model = _strand.getBeadByType(IComboBoxModel) as IComboBoxModel;
			viewBead = _strand.getBeadByType(IComboBoxView) as IComboBoxView;
			if (viewBead) {
				finishSetup();
			} else {
				IEventDispatcher(_strand).addEventListener("viewChanged", finishSetup);
			}
			if (model is IJewelSelectionModel) {
                IJewelSelectionModel(model).dispatcher = IEventDispatcher(value);
			}
			else {
                IEventDispatcher(model).addEventListener('dataProviderChanged', modelChangeHandler);
				IEventDispatcher(model).addEventListener('selectionChanged', modelChangeHandler);
            }
		}

		/**
         *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		protected function finishSetup(event:Event = null):void
		{
			IEventDispatcher(viewBead.button).addEventListener(MouseEvent.CLICK, clickHandler);
            IEventDispatcher(viewBead.textinput).addEventListener(MouseEvent.CLICK, clickHandler);
			IEventDispatcher(viewBead.textinput).addEventListener(KeyboardEvent.KEY_DOWN, textInputKeyEventHandler);
            COMPILE::JS{
			//keyboard navigation from textfield should also close the popup
			viewBead.textinput.element.addEventListener('blur', handleFocusOut);
			}
		}

		/**
         *  @royaleignorecoercion org.apache.royale.core.UIBase
         *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		protected function clickHandler(event:MouseEvent):void
		{
			event.stopImmediatePropagation();

			viewBead.popUpVisible = true;

			COMPILE::JS {
			//put focus in the textinput
			if (event.target == viewBead.button)
				viewBead.textinput.element.focus();
			}

			// viewBead.popup is ComboBoxPopUp that fills 100% of browser window-> We want List inside its view
			popup = viewBead.popup as ComboBoxPopUp;
			popup.addEventListener(MouseEvent.MOUSE_DOWN, removePopUpWhenClickOutside);

			list = (popup.view as ComboBoxPopUpView).list;
			list.addEventListener(MouseEvent.MOUSE_DOWN, handleControlMouseDown);
			list.addEventListener(KeyboardEvent.KEY_DOWN, listKeyEventHandler);
			list.addEventListener(Event.CHANGE, changeHandler);
            if (model is IJewelSelectionModel) {
				//don't let the pop-up's list take over as primary dispatcher
				//it needs to stay with the ComboBox (for selection bindings to work)
                IJewelSelectionModel(model).dispatcher = IEventDispatcher(_strand);
            }
		}

		/**
		 * key listener at TextInput level
		 * @private
		 */
		protected function textInputKeyEventHandler(event:KeyboardEvent):void
		{
			COMPILE::JS
			{
			if (document.activeElement !== viewBead.textinput.element)
				return;	
			}
			
			// from this point we don't want to perform this actions if textinput is not active

			if(event.key === KeyboardEvent.KEYCODE__DOWN)
			{
				keyPressed = true
				var view:IListView = list.view as IListView;
				var dataGroup:IItemRendererOwnerView = view.dataGroup;
				var goToIndex:int = list.selectedIndex == -1 ? 0 : list.selectedIndex; 
				list.scrollToIndex(goToIndex);
				var ir:StyledDataItemRenderer = dataGroup.getItemRendererForIndex(goToIndex) as StyledDataItemRenderer;
				COMPILE::JS
				{
				// this 'hack' is needed due to browsers scrolling list on popups when get focus
				if(list.element.classList.contains("scroll"));
				{
					list.element.classList.remove("scroll");
					setTimeout(restoreScroll, 300);
				}
				list.element.focus({preventScroll:true});
				list.selectedIndex = goToIndex;
				}
			}
		}

		/**
		 * key listener at global List level
		 * @private
		 */
		protected function listKeyEventHandler(event:KeyboardEvent):void
		{
			if(event.key === KeyboardEvent.KEYCODE__ENTER)
			{
				dismissPopUp();
			}
		}

		COMPILE::JS
		private function restoreScroll():void
		{
			list.element.classList.add("scroll");
		}

		private var popup:ComboBoxPopUp;

		protected function handleControlMouseDown(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
		}

        /**
         * @private
         */
        protected function handleFocusOut(event:Event):void
        {
            if (viewBead.popUpVisible) {
				//allow a time to handle a selection from
				//the popup as the possible reason for loss of focus
				//(event.relatedObject seems null, so cannot check here)
				//this should be less than 300
                setTimeout(hidePopup, 280);
            }
        }

        protected function hidePopup():void{
			if(!keyPressed)
            	viewBead.popUpVisible = false;
			keyPressed = false;
        }
		/**
         *  @royaleignorecoercion org.apache.royale.core.UIBase
         *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		protected function removePopUpWhenClickOutside(event:MouseEvent = null):void
		{
			dismissPopUp();
		}

		/**
         *  @royaleignorecoercion org.apache.royale.core.UIBase
         *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		private function changeHandler(event:Event):void
		{
			event.stopImmediatePropagation();
			model.selectedItem = IComboBoxModel(list.getBeadByType(IComboBoxModel)).selectedItem;
			IEventDispatcher(_strand).dispatchEvent(new Event(Event.CHANGE));
			dismissPopUp();
		}

        protected function modelChangeHandler(event:Event):void{
            IEventDispatcher(_strand).dispatchEvent(new Event(event.type));
        }

		private var keyPressed:Boolean;

		private function dismissPopUp():void
		{
			if(!keyPressed)
			{
				popup.removeEventListener(MouseEvent.MOUSE_DOWN, removePopUpWhenClickOutside);
				list.removeEventListener(MouseEvent.MOUSE_DOWN, handleControlMouseDown);
				list.removeEventListener(Event.CHANGE, changeHandler);
				list.removeEventListener(KeyboardEvent.KEY_DOWN, listKeyEventHandler);
				viewBead.popUpVisible = false;
			}
			keyPressed = false;
		}
	}
}
