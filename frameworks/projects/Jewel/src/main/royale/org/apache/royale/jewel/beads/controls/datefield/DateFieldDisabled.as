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
package org.apache.royale.jewel.beads.controls.datefield
{
	COMPILE::JS
	{
	import org.apache.royale.core.HTMLElementWrapper;
	import org.apache.royale.jewel.DateField;
	import org.apache.royale.jewel.beads.views.DateFieldView;
	}
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.jewel.beads.controls.Disabled;

	/**
	 *  The DateFieldDisabled bead class is a specialty bead that can be used to disable a Jewel DateField control.
	 *  This disables all the internal native controls.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.6
	 */
	public class DateFieldDisabled extends Disabled
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
		public function DateFieldDisabled()
		{
		}
		
		COMPILE::JS
		protected var lastTextInputElementTabVal:String = null;
		COMPILE::JS
		protected var lastButtonElementTabVal:String = null;

		override protected function updateHost():void
		{
			COMPILE::JS
			{
			var view:DateFieldView = (_strand as DateField).view as DateFieldView;
			
			if (view) {
				var pos:HTMLElement = (_strand as IUIBase).positioner;

				if(!initialized)
				{
					initialized = true;
					lastElementTabVal = (_strand as HTMLElementWrapper).element.getAttribute("tabindex");
					lastTextInputElementTabVal = view.textInput.element.getAttribute("tabindex");
					lastButtonElementTabVal = view.menuButton.element.getAttribute("tabindex");
				}

				if (disabled) {
					setDisableAndTabIndex(pos, true);
					setDisableAndTabIndex(view.textInput.positioner, true);
					setDisableAndTabIndex(view.textInput.element);
					setDisableAndTabIndex(view.menuButton.positioner, true);
					setDisableAndTabIndex(view.menuButton.element);
				} else {
					removeDisableAndTabIndex(pos, true);
					removeDisableAndTabIndex(view.textInput.positioner, true);
					removeDisableAndTabIndex(view.textInput.element, false, lastTextInputElementTabVal);
					removeDisableAndTabIndex(view.menuButton.positioner, true);
					removeDisableAndTabIndex(view.menuButton.element, false, lastButtonElementTabVal);
				}
			}
			}
		}
	}
}
