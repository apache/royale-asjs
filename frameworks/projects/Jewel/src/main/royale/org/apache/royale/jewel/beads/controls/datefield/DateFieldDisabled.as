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
	import org.apache.royale.core.UIBase;
	import org.apache.royale.jewel.beads.views.DateFieldView;
}
	import org.apache.royale.jewel.beads.controls.Disabled;
	
	/**
	 *  The DateFieldDisabled bead class is a specialty bead that can be used to disable a Jewel DateField.
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

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion HTMLInputElement
		 *  @royaleignorecoercion org.apache.royale.core.UIBase;
		 */
		// override public function set strand(value:IStrand):void
		// {
		// 	_strand = value;

		// 	COMPILE::JS
		// 	{
		// 	if (DateField(value).numElements ==2) {
		// 		updateHost();
		// 	} else {
		// 		DateField(value).addEventListener('beadsAdded', onBeadsAdded);
		// 	}
		// 	}
		// }

		// COMPILE::JS
		// private function onBeadsAdded(event:Event):void
		// {
		// 	DateField(_strand).removeEventListener('beadsAdded', onBeadsAdded);
		// 	updateHost();
		// }

		COMPILE::JS
		override protected function updateHost():void
		{
			super.updateHost();

			var view:DateFieldView = (_strand as UIBase).view as DateFieldView;

			if (view) {
                if(disabled) {
					view.textInput.element.setAttribute('disabled', '');
					view.menuButton.element.setAttribute('disabled', '');
				} else {
					view.textInput.element.removeAttribute('disabled');
					view.menuButton.element.removeAttribute('disabled');
				}
            }
		}
	}
}
