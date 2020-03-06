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
	COMPILE::JS
	{
	import org.apache.royale.core.UIBase;
	import org.apache.royale.jewel.beads.views.ComboBoxView;
	}
	import org.apache.royale.jewel.beads.controls.Disabled;
	
	/**
	 *  The ComboBoxDisabled bead class is a specialty bead that can be used to disable a Jewel ComboBox.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.6
	 */
	public class ComboBoxDisabled extends Disabled
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
		public function ComboBoxDisabled()
		{
		}

		override protected function updateHost():void
		{
			super.updateHost();
			
			COMPILE::JS
			{
			var view:ComboBoxView = (_strand as UIBase).view as ComboBoxView;

			if (view) {
                if(disabled) {
					view.textinput.element.setAttribute('disabled', '');
					view.textinput.positioner.setAttribute('disabled', '');
					view.button.element.setAttribute('disabled', '');
					view.button.positioner.setAttribute('disabled', '');
					
					view.textinput.element.setAttribute('tabindex', '-1');
					view.textinput.positioner.setAttribute('tabindex', '-1');
					view.button.element.setAttribute('tabindex', '-1');
					view.button.positioner.setAttribute('tabindex', '-1');
				} else {
					view.textinput.element.removeAttribute('disabled');
					view.textinput.positioner.removeAttribute('disabled');
					view.button.element.removeAttribute('disabled');
					view.button.positioner.removeAttribute('disabled');

					if(lastTabVal) {
						view.textinput.element.setAttribute('tabindex', lastTabVal);
						view.textinput.positioner.setAttribute('tabindex', lastTabVal);
						view.button.element.setAttribute('tabindex', lastTabVal);
						view.button.positioner.setAttribute('tabindex', lastTabVal);
					} else {
						view.textinput.element.removeAttribute('tabindex');
						view.textinput.positioner.removeAttribute('tabindex');
						view.button.element.removeAttribute('tabindex');
						view.button.positioner.removeAttribute('tabindex');
					}
				}
            }
			}
		}
	}
}
