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
package org.apache.royale.core
{
COMPILE::SWF
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
}
	import org.apache.royale.events.IEventDispatcher;
	
    /**
     *  The IInitialViewApplication interface is the interface for 
	 *  applications with a single initial views.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public interface IInitialViewApplication extends IEventDispatcher
	{
        /**
         *  The application's initial view.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        function get initialView():IApplicationView;

        /**
         *  @private
         */
        COMPILE::SWF
		function get stage():Stage;
		
        /**
         *  @private
         */
        COMPILE::SWF
		function get $displayObject():DisplayObject;
		
        /**
         *  @private
         */
        COMPILE::JS
		function get element():WrappedHTMLElement;

    }
}
