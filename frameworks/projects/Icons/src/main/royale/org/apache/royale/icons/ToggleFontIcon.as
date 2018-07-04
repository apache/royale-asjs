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
     *  Icons can be used alone or in buttons and other controls 
     * 
     *  This class could be used with any icon family out there and with
     *  its text property
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.3
     */
    public class ToggleFontIcon extends FontIcon implements ISelectable
    {
        /**
         *  constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.3
         */
        public function ToggleFontIcon()
        {
            super();
        }

        private var _selected:Boolean = false;
        
        /**
         *  <code>true</code> if the Button is selected.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.3
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

        private var _selectedText:String = "";
        /**
         *  The selectedText of the icon
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.3
         */
		public function get selectedText():String
		{
            return _selectedText;            
		}
        public function set selectedText(value:String):void
		{
            _selectedText = value;
            internalSelected();
		}

        override public function set text(value:String):void
		{
            _text = value;
            internalSelected();
		}

        private function internalSelected():void
        {
            COMPILE::JS
			{
                textNode.nodeValue = _selected ? _selectedText : _text;	
			}
        }
        
        /**
         *  The icon text
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.3
         */
        override protected function get iconText():String
        {
            return selected ? selectedText : text;
        }
    }
}
