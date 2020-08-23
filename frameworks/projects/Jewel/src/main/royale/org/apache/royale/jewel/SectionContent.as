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
package org.apache.royale.jewel
{
    COMPILE::JS
    {
    import org.apache.royale.core.WrappedHTMLElement;
    import org.apache.royale.html.util.addElementToWrapper;
    }
    import org.apache.royale.jewel.supportClasses.ISelectableContent;
    
	/**
	 *  The Jewel SectionContent class is a Container component capable of parenting other
	 *  components. This class is used along with Tabs to separate content, 
	 *  present and organize data for the user.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class SectionContent extends Container implements ISelectableContent
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function SectionContent()
		{
			super();

            typeNames = "jewel section";

            // we need to add this for propoer sizing of content inside this container
            addClass("is-selected");
		}

        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			return addElementToWrapper(this, 'section');
        }

		private var _isSelected:Boolean;

        /**
         *  a boolean flag to indicate if the container is active or not
         *  defaults to false.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		public function get isSelected():Boolean
		{
            return _isSelected;
		}

		public function set isSelected(value:Boolean):void
		{
            if (_isSelected != value)
            {
                _isSelected = value;

                toggleClass("is-selected", _isSelected);
            }
		}
		
        private var _name:String;

        /**
         *  name is the name od this activable content
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
        COMPILE::SWF
		override public function get name():String
		{
            return _name;
		}

        COMPILE::SWF
		override public function set name(value:String):void
		{
            if (_name != value)
            {
                _name = value;
            }
		}

        COMPILE::JS
        public function get name():String
		{
            return _name;
		}

        COMPILE::JS
		public function set name(value:String):void
		{
            if (_name != value)
            {
                _name = value;
            }
		}
	}
}
