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
package org.apache.royale.util
{
    /**
     *  The UIBase class is the base class for most composite user interface
     *  components.  For the Flash Player, Buttons and Text controls may
     *  have a different base class and therefore may not extend UIBase.
     *  However all user interface components should implement IUIBase.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class ClassListUtil
	{
        COMPILE::JS
        {
            import org.apache.royale.core.UIBase;
            import org.apache.royale.core.WrappedHTMLElement;
        }

        /**
         *  Add one or more styles to the component. If the specified class already 
         *  exist, the class will not be added.
         *  
         *  @param value, a String with the style (or styles separated by an space) to
         *  add from the component. If the string is empty doesn't perform any action
         *  
         *  @langversion 3.0
         *  @productversion Royale 0.9.3
         */
        COMPILE::JS
        public static function addStyles(wrapper:UIBase, value:String):void
        {
            if (value == "") return;
            
            if (value.indexOf(" ") >= 0)
            {
                var classes:Array = value.split(" ");
                wrapper.element.classList.add.apply(wrapper.element.classList, classes);
            } else
            {
                wrapper.element.classList.add(value);
            }
        }

        /**
         *  Removes one or more styles from the component. Removing a class that does not 
         *  exist, does not throw any error
         * 
         *  @param value, a String with the style (or styles separated by an space) to 
         *  remove from the component. If the string is empty doesn't perform any action
         *  
         *  @langversion 3.0
         *  @productversion Royale 0.9.3
         */
        COMPILE::JS
        public static function removeStyles(wrapper:UIBase, value:String):void
        {
            if (value == "") return;

            if (value.indexOf(" ") >= 0)
            {
                var classes:Array = value.split(" ");
                wrapper.element.classList.remove.apply(wrapper.element.classList, classes);
            } else
            {
                wrapper.element.classList.remove(value);
            }
        }

        /**
         *  Adds or removes a single style. 
         * 
         *  The first parameter removes the style from an element, and returns false.
         *  If the style does not exist, it is added to the element, and the return value is true.
         * 
         *  The optional second parameter is a Boolean value that forces the class to be added 
         *  or removed, regardless of whether or not it already existed.
         * 
         *  @langversion 3.0
         *  @productversion Royale 0.9.3
         */
        COMPILE::JS
        public static function toggleStyle(wrapper:UIBase, value:String, force:Boolean = false):Boolean
        {
            return wrapper.element.classList.toggle(value, force);
        }

        /**
         *  Removes all styles that are not in typeNames
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        COMPILE::JS
        public static function removeAllStyles(wrapper:UIBase):void
        {
            var classList:DOMTokenList = wrapper.element.classList;
            var i:int;
            for( i = classList.length; i > 0; i-- )
            {
                if(wrapper.typeNames.indexOf(classList[i]) != 0)
                {
                    classList.remove(classList[i]);
                }
            }
        }

    }
}