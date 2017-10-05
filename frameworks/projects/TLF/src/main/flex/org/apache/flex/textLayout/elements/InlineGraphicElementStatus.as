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
package org.apache.royale.textLayout.elements
{
    /** The InlineGraphicElementStatus class defines a set of constants for checking the value of
     * <code>InlineGraphicElement.status</code>.
     *
     * @playerversion Flash 10
     * @playerversion AIR 1.5
     * @langversion 3.0
     *
     * @see InlineGraphicElement#status
     */
    public final class InlineGraphicElementStatus
    {
    	/** Graphic element is an URL that has not been loaded.  
    	 *
    	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 */
        public static const LOAD_PENDING:String = "loadPending";
        
        /** Load has been initiated (but not completed) on a graphic element that is a URL.  
         *
         * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 */
	 
        public static const LOADING:String  	= "loading";
        
        /** 
         * Graphic element with auto or percentage width/height has completed loading but has not been recomposed.  At the next 
         * recompose the actual size of the graphic element is calculated. 
         *
         * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 */
	 
        public static const SIZE_PENDING:String = "sizePending";
        
	/** Graphic is completely loaded and properly sized. 
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 */
	 
        public static const READY:String = "ready";
        
        /** An error occurred during loading of a referenced graphic. 
         *
         * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 */
	 
        public static const ERROR:String = "error";
    }
}
