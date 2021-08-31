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
package org.apache.royale.utils
{
import org.apache.royale.core.HTMLElementWrapper;
import org.apache.royale.core.IUIBase;

    /**
	 *  The ClassSelectorList class is used to manage the list of class selectors
     *  applied to a component.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.3
	 */
	public class ClassSelectorList
	{
		public function ClassSelectorList(component:IUIBase)
		{
            this.component = component;
		}

        private var component:IUIBase;

        COMPILE::JS
        private var _override:HTMLElement

        COMPILE::JS
        private function get classSelectorTarget():HTMLElement{
            return _override || component.positioner;
        }

        /**
         * @royaleignorecoercion HTMLElement
         */
        public function setOverride(value:Object):void{
            COMPILE::JS{
                _override = value as HTMLElement;
            }
        }
        
        private var startIndex:int = 0;
        private var count:int = 0;
        
        /**
         * Add a class selector to the list.
         * 
         * @param name Name of selector to add.
         * 
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.9.3
         */
        public function add(name:String):void
        {
            COMPILE::JS
            {
            classSelectorTarget.classList.add(name);
            if (!component.parent)
                startIndex++;
            }
        }
        
        /**
         * Removes a class selector from the list.
         * 
         * @param name Name of selector to remove.
         *
         * @royaleignorecoercion HTMLElement
         * @royaleignorecoercion DOMTokenList
         * 
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.9.3
         */
        public function remove(name:String):void
        {
            COMPILE::JS
            {
            var positioner:HTMLElement = classSelectorTarget as HTMLElement;
            var classList:DOMTokenList = positioner.classList;
            for (var i:int = 0; i < startIndex; i++)
            {
                if (classList.item(i) == name)
                    startIndex--;
            }
            positioner.classList.remove(name);
            }
        }

        /**
         * Add or remove a class selector to/from the list.
         * 
         * @param name Name of selector to add or remove.
         * @param value True to add, False to remove.
         * 
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.9.3
         */
        public function toggle(name:String, value:Boolean):void
        {
            COMPILE::JS
            {
            //IE11 does not support second value so instead of
            //component.positioner.classList.toggle(name, value);
            if(value)
                classSelectorTarget.classList.add(name);
            else
                classSelectorTarget.classList.remove(name);

            if (!component.parent && value)
                startIndex++;
            }
        }

        /**
		 *  Search for the name in the element class list 
		 *
         *  @param name Name of selector to find.
         *  @return return true if the name is found or false otherwise.
         * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function contains(name:String):Boolean
        {
            COMPILE::JS
            {
            return classSelectorTarget.classList.contains(name);
            }
            COMPILE::SWF
            {//not implemented
            return false;
            }
        }
        
        
        /**
         * Add a space-separated list of names.
         * @param names Space-separated list of names to add.
         * 
         * @royaleignorecoercion HTMLElement
         * @royaleignorecoercion DOMTokenList
         * 
         * @langversion 3.0
		 * @playerversion Flash 10.2
		 * @playerversion AIR 2.6
		 * @productversion Royale 0.9.3
         */
        public function addNames(names:String):void
        {
            COMPILE::JS
            {
                var positioner:HTMLElement = classSelectorTarget as HTMLElement;
                var classList:DOMTokenList = positioner.classList;
                if (component.parent)
                {
                    // remove names that were set last time
                    while (count > 0)
                    {
                        var name:String = classList.item(startIndex);
                        classList.remove(name);
                        count = classList.length - startIndex;
                    }
                }

                if (startIndex > 0)
                {
                    positioner.className += " " + names;
                }
                else
                {
                    positioner.className = names;
                }
                count = classList.length - startIndex;
            }
        }
    }
}
