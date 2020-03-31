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
package org.apache.royale.icons
{
    import org.apache.royale.core.ISelectable;

    /**
     *  A FontAwesome based toggle icon can be used alone or in buttons and other controls.
     *  This icons has two states, selected and unselected showing different icons in each one.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.7
     */
    public class FontAwesomeToggleIcon extends FontAwesomeIcon implements ISelectable
    {
        /**
         *  constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
        public function FontAwesomeToggleIcon()
        {
            super();
        }

        private var _selected:Boolean = false;
        
        /**
         *  <code>true</code> if the icon is selected.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
        public function get selected():Boolean
        {
            return _selected;
        }

        /**
         *  @private
         */
        public function set selected(value:Boolean):void
        {
            _selected = value;
            internalSelected();
        }

        private var _selectedType:String = "";
        /**
         *  The selectedText of the icon
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
		public function get selectedType():String
		{
            return _selectedType;            
		}
        public function set selectedType(value:String):void
		{
            _selectedType = value;
            internalSelected();
		}

        private function internalSelected():void
        {
            removeClass('fa-' + _type);
            removeClass('fa-' + _selectedType);

            if(selected)
                addClass('fa-' + _selectedType);
            else
                addClass('fa-' + _type);
        }
    }
}
