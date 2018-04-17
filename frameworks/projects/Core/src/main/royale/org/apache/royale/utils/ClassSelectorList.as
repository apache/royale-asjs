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
    import org.apache.royale.core.IUIBase;

    /**
	 *  The ClassSelectorList class is used to manage the list of class selectors
     *  applied to a component.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 1.0.0
	 *  @productversion Royale 0.0
	 */
	public class ClassSelectorList
	{
		public function ClassSelectorList(component:IUIBase)
		{
            this.component = component;
		}

        private var component:IUIBase;
        
        private var startIndex:int = 0;
        private var count:int = 0;
        
        /**
         * Add a class selector to the list.
         * @param name Name of selector to add.
         */
        public function add(name:String):void
        {
            COMPILE::JS
            {
            component.positioner.classList.add(name);
            if (!component.parent)
                startIndex++;
            }
        }
        
        /**
         * Add a class selector to the list.
         * @param name Name of selector to remove.
         */
        public function remove(name:String):void
        {
            COMPILE::JS
            {
            var positioner:HTMLElement = component.positioner as HTMLElement;
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
         * @param name Name of selector to add or remove.
         * @param value True to add, False to remove.
         */
        public function toggle(name:String, value:Boolean):void
        {
            COMPILE::JS
            {
            component.positioner.classList.toggle(name, value);
            if (!component.parent && value)
                startIndex++;
            }
        }
        
        
        /**
         * Add a space-separated list of names.
         * @param names Space-separated list of names to add.
         * @royaleignorecoercion HTMLElement
         */
        public function addNames(names:String):void
        {
            COMPILE::JS
            {
            var positioner:HTMLElement = component.positioner as HTMLElement;
            var classList:DOMTokenList = positioner.classList;
            if (component.parent)
            {
                // remove names that were set last time
                while (count > 0)
                {
                    var name:String = classList.item(startIndex);
                    classList.remove(name);
                }
            }
            if (startIndex > 0)
                positioner.className += " " + names;
            else
                positioner.className = names;
            count = classList.length - startIndex;
            }
        }
    }
}
