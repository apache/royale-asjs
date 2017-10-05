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
package org.apache.royale.mdl.beads.models
{
    import org.apache.royale.events.Event;
    import org.apache.royale.html.beads.models.ArraySelectionModel;

    /**
     *  The DropDownListModel class defines the data associated with an org.apache.royale.mdl.DropDownListModel
     *  component.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9
     */
    public class DropDownListModel extends ArraySelectionModel implements IDropDownListModel
    {
        public function DropDownListModel()
        {
            super();
        }

        private var _selectedValue:String = "";

        /**
         *  @copy org.apache.royale.mdl.beads.models.IDropDownListModel#selectedValue
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
         */
        public function get selectedValue():String
        {
            return _selectedValue;
        }

        public function set selectedValue(value:String):void
        {
            if (_selectedValue != value)
            {
                _selectedValue = value;
                dispatchEvent(new org.apache.royale.events.Event("selectedValueChanged"));
            }
        }
    }
}
