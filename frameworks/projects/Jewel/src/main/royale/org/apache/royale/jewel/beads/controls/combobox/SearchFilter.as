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
package org.apache.royale.jewel.beads.controls.combobox
{
	import org.apache.royale.events.Event;
	import org.apache.royale.jewel.beads.controls.combobox.IComboBoxView;
	import org.apache.royale.jewel.beads.controls.textinput.SearchFilterForList;
	import org.apache.royale.jewel.beads.views.ComboBoxView;
	import org.apache.royale.jewel.supportClasses.textinput.TextInputBase;

	/**
	 *  The SearchFilter bead class is a specialty bead that can be used with
     *  a Jewel ComboBox to filter options as we type
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.5
	 */
	public class SearchFilter extends SearchFilterForList
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.5
		 */
		public function SearchFilter()
		{
		}

		override protected function textInputKeyUpLogic(input:Object):void
		{
			// first remove a previous selection
			if(list.selectedIndex != -1)
			{
				var tmp:String = input.text;
				list.selectedItem = null;
				input.text = tmp;
			}

			var popUpVisible:Boolean = input.parent.view.popUpVisible;
            if (!popUpVisible) {
                input.parent.view.popUpVisible = true;
            }
			
			// fill "list" with the internal list in the combobox popup
			list = input.parent.view.popup.view.list;
			
			applyFilter(input.parent.view.textinput.text.toUpperCase());

			ComboBoxView(_strand['view']).autoResizeHandler(); //as we filter the popup list will be smaller, and we want to reposition
		}

		override protected function onBeadsAdded(event:Event):void{
            if ('view' in _strand && _strand['view'] is IComboBoxView) {
                var _textInput:TextInputBase = IComboBoxView(_strand['view']).textinput as TextInputBase;
                if (_textInput) {
					COMPILE::JS {
                        _textInput.element.addEventListener('focus', onInputFocus);
                    }
            	}
            }
		}

		override protected function onInputFocus(event:Event):void{
            var popUpVisible:Boolean =  IComboBoxView(_strand['view']).popUpVisible;
            if (!popUpVisible) {
                //force popup ?:
                IComboBoxView(_strand['view']).popUpVisible = true;

                //or avoid ?:
                //return;
            }
			
			// fill "list" with the internal list in the combobox popup
			list = event.target.royale_wrapper.parent.view.popup.view.list;

			//applyFilter(IComboBoxView(_strand['view']).textinput.text.toUpperCase());
		}
	}
}
