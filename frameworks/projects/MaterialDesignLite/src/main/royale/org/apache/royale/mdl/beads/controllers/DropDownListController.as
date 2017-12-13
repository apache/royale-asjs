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
package org.apache.royale.mdl.beads.controllers
{
    import org.apache.royale.core.IBeadController;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.mdl.DropDownList;
    import org.apache.royale.events.Event;
    import org.apache.royale.mdl.beads.models.DropDownListModel;
    import org.apache.royale.mdl.beads.models.IDropDownListModel;

    /**
	 *  The DropDownListController class bead handles mouse events on the
     *  drop down list component parts and dispatches change event on behalf of the DropDownList
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	public class DropDownListController implements IBeadController
	{
		/**
		 *  constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function DropDownListController()
		{
		}
		
        /**
         *  Model
         *   
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
         */
		protected var model:DropDownListModel;
		protected var _strand:IStrand;

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;

            var dropDownList:DropDownList = (value as DropDownList);

            model = _strand.getBeadByType(IDropDownListModel) as DropDownListModel;

			COMPILE::JS
            {
                dropDownList.dropDown.element.addEventListener(Event.CHANGE, onSelectChanged, false);
            }
		}

		COMPILE::JS
        private function onSelectChanged(event:Event):void
        {
            var eventTarget:Object = event.target;
			var selectedIndex:int = eventTarget.selectedIndex - 1;

			if (model.selectedIndex != selectedIndex)
            {
                model.selectedIndex = selectedIndex;
                model.selectedItem = model.dataProvider[selectedIndex];
				model.selectedValue = eventTarget.value;
            }
        }
    }
}
