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
    /**
     *  The IClassSelectorList interface stablish the contract methods
     *  for componnets that use ClassSelectorList to deal with class selector names
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.3
     */
	public interface IClassSelectorListSupport
	{
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
		function addClass(name:String):void
		
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
		function removeClass(name:String):void
		
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
		function toggleClass(name:String, value:Boolean):void

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
		function containsClass(name:String):Boolean

        /**
		 *  Replace a class for a new one. If new class is not set, use the old one instead
		 *
         *  @param oldClass Name of selector to remove.
         *  @param newClass Name of selector to set.
         * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.10.0
		 */
        function replaceClass(oldClass:String, newClass:String = null):void
	}
}
