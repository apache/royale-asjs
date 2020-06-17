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
  import org.apache.royale.core.IBead;
  import org.apache.royale.jewel.ComboBox;
  import org.apache.royale.core.IStrand;
  import org.apache.royale.collections.CollectionUtils;
  import org.apache.royale.collections.ArrayList;
  import org.apache.royale.events.Event;
  
  /**
	 *  The ComboBoxItemByField class is a specialty bead that can be used with
	 *  any ComboBox control. This bead allows to select an item by field
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */

  public class ComboBoxItemByField implements IBead{

      protected var comboBox:ComboBox;

	  
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
      public function ComboBoxItemByField()
		{
		}
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
        public function set strand(value:IStrand):void
		{
			comboBox = value as ComboBox;
			comboBox.addEventListener("selectionChanged", selectionChangedHandler);
			updateHost();
		}

        private var _valueField:String;
        /**
		 *  The string that will be used for comparison field name
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
        public function get valueField():String
        {
            return _valueField;
        }
        public function set valueField(value:String):void
        {
            _valueField = value;
			updateHost();
        }

        private var _selectedValue:*;
		
		/**
		 *  Any kind of object to perform the comparison or select
		 *  the item with this value in the field.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
        public function get selectedValue():*{
            return _selectedValue;
        }

        public function set selectedValue(value:*):void{
            _selectedValue = value;
            updateHost();
        }
		
		/**
		 *  This bead allows update the selected item of the combobox through the entered field 
		 */
        protected function updateHost():void
		{
			if(comboBox && valueField != "" && selectedValue != null){
			    var aux:* = CollectionUtils.getItemByField(comboBox.dataProvider as ArrayList,valueField,selectedValue);
                if(aux == null){
                    comboBox.selectedItem = null;
                    comboBox.selectedIndex = -1;
                } else if (aux!==comboBox.selectedItem){
                    comboBox.selectedItem = aux;
                }
            }
		}
		
		/**
		 *  Select the right item for the combobox.
		 * 
		 *  @param event 
		 */
        protected function selectionChangedHandler(event:Event):void{
            if(valueField != "" && comboBox){
                var selectedItem:Object = comboBox.selectedItem;
                if(selectedItem != null && selectedValue !== selectedItem[valueField])
                    selectedValue = selectedItem[valueField];
            }
        }

  }   
}