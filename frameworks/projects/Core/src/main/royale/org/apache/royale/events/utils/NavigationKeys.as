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
package org.apache.royale.events.utils
{
	/**
	 *  This class holds constants for keyboard navigation
     *  See: https://w3c.github.io/uievents-key/#keys-navigation
     *  See: https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent/key/Key_Values#Navigation_keys
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
    public class NavigationKeys
    {
        /**
         * The down arrow key.
         */
        public static const DOWN:String = "ArrowDown";
        /**
         * The left arrow key.
         */
        public static const LEFT:String = "ArrowLeft";
        /**
         * The right arrow key.
         */
        public static const RIGHT:String = "ArrowRight";
        /**
         * The up arrow key.
         */
        public static const UP:String = "ArrowUp";
        /**
         * The End key. Moves to the end of content.
         */
        public static const END:String = "End";
        /**
         * The Home key. Moves to the start of content.
         */
        public static const HOME:String = "Home";
        /**
         * The Page Down (or PgDn) key. Scrolls down or displays the next page of content.
         */
        public static const PAGE_DOWN:String = "PageDown";
        /**
         * The Page Up (or PgUp) key. Scrolls up or displays the previous page of content.
         */
        public static const PAGE_UP:String = "PageUp";
    }
}
