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

package mx.controls.beads.controllers
{

import org.apache.royale.core.IStrand;
import org.apache.royale.events.IEventDispatcher;
import org.apache.royale.events.MouseEvent;
import org.apache.royale.core.IBeadController;
import mx.controls.RadioButton;
import org.apache.royale.events.MouseEvent;
import mx.events.ItemClickEvent;
import mx.controls.RadioButtonGroup;

/**
 *  The RadioButtonMouseController is the default controller for the radio button emulation class.
 *  It is responsible for creating the item click event
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */

	public class RadioButtonMouseController implements IBeadController
	{
        public function set strand(value:IStrand):void
        {
            (value as IEventDispatcher).addEventListener(MouseEvent.CLICK, clickHandler);
        }

        protected function clickHandler(event:MouseEvent):void
        {
            // Dispatch an itemClick event from the RadioButtonGroup.
            var radioButton:RadioButton = event.target as RadioButton;
            var group:RadioButtonGroup = radioButton.group;
            var itemClickEvent:ItemClickEvent =
                new ItemClickEvent(ItemClickEvent.ITEM_CLICK);
            itemClickEvent.label = radioButton.label;
            // TODO is this worth the performance price?
            itemClickEvent.index = getRadioIndex(radioButton, group);
            itemClickEvent.relatedObject = radioButton;
            itemClickEvent.item = radioButton.value;
            if (!radioButton.selected)
            {
                radioButton.selected = true;
            }
    	    if(group != null)
            {
                group.dispatchEvent(itemClickEvent);
                group.setSelection(radioButton);
            }
        }

        private function getRadioIndex(radioButton:RadioButton, group:RadioButtonGroup):int
        {
	    if(group != null)
            for (var i:int = 0; i < group.numRadioButtons; i++)
            {
                if (group.getRadioButtonAt(i) == radioButton)
                {
                    return i;
                }
            }
            return -1;
        }

	}

}
