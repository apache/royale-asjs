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
    import org.apache.royale.core.IUIBase;
    }
    import org.apache.royale.core.IIcon;
    import org.apache.royale.core.IIconSupport;

    /**
     *  The IconTextInput class implements is a TextInput that supports
     *  an icon that can be positionend to the left or to the right of text
     *  content
     *
     *  @toplevel
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
     */
	public class IconTextInput extends TextInput implements IIconSupport
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		public function IconTextInput()
		{
			super();
		}
        
        private var _icon:IIcon;
        /**
		 *  The icon to use with the button.
         *  Optional
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
        public function get icon():IIcon
        {
            return _icon;
        }
        public function set icon(value:IIcon):void
        {
            _icon = value;

            toggleClass("icon", (_icon != null));
            
            COMPILE::JS
            {
            // insert the icon before the text
            if(rightPosition)
            {
                positioner.insertBefore(_icon.positioner, null);
            } else
            {
                positioner.insertBefore(_icon.positioner, element);
            }
            (_icon as IUIBase).addedToParent();
            }
        }
        
        private var _rightPosition:Boolean;
        /**
		 *  icon's position regarding the text content 
         *  Can be false ("left") or true ("right"). defaults to false ("left")
         *  Optional
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
        public function get rightPosition():Boolean
        {
            return _rightPosition;
        }
        public function set rightPosition(value:Boolean):void
        {
            _rightPosition = value;

            toggleClass("right", _rightPosition);
        }
	}
}
