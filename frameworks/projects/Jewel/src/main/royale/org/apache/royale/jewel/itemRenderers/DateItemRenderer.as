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
package org.apache.royale.jewel.itemRenderers
{
    import org.apache.royale.core.IStrandWithModel;
	import org.apache.royale.jewel.beads.models.DateChooserModel;
	import org.apache.royale.jewel.beads.itemRenderers.ClassSelectorListSelectableItemRendererBead;

	/**
	 *  The DateItemRenderer class renders date values for the DateChooser.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class DateItemRenderer extends TableItemRenderer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function DateItemRenderer()
		{
			super();

			typeNames = "jewel tableitem calendar";
			
			addBead(new ClassSelectorListSelectableItemRendererBead());
		}

		/**
		 *  Sets the data value and uses the String version of the data for display.
		 *
		 *  @param Object data The object being displayed by the itemRenderer instance.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		override public function set data(value:Object):void
		{
			super.data = value;

            var model:DateChooserModel = (itemRendererOwnerView.host.parent as IStrandWithModel).model as DateChooserModel;
			//itemRendererOwnerView.parent is DateChooser
			var viewState:int = model.viewState;

			if (value[labelField] is Date) {
				if(viewState == 0)
				{
					text = String( (value[labelField] as Date).getDate());
				} else if(viewState == 1)
				{
					text = String( (value[labelField] as Date).getFullYear());
				} else {
					var monthNames:Array = model.monthNames;
					text = String(monthNames[(value[labelField] as Date).getMonth()]);
				}

				COMPILE::SWF {
					mouseEnabled = true;
					mouseChildren = true;
				}
			} else {
				text = "";

				COMPILE::SWF {
					mouseEnabled = false;
					mouseChildren = false;
				}

				className = "empty-cell";
			}
		}
	}
}
