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
package org.apache.flex.cordova
{
	import org.apache.flex.events.Event;
	import org.apache.flex.core.Application;
	import org.apache.flex.core.IFlexInfo;

	/**
	 *  A customized Application that dispatches the Cordova deviceReady event
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class Application extends org.apache.flex.core.Application implements IFlexInfo
	{
		/**
		 * FalconJX will inject html into the index.html file.  Surround with
		 * "inject_html" tag as follows:
		 *
		 * <inject_html>
		 * <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
		 * <script type="text/javascript" src="cordova.js"></script>
		 * </inject_html>
		 */
		public function Application()
		{
			super();
		}
		
		public var isDeviceReady:Boolean = false
		
		/**
		 * @private
		 */
		COMPILE::JS
		override public function start():void
		{
			// listen for Cordova's deviceReady event
			document.addEventListener("deviceReady", startOnReady, false);
			
			// listen for preinitialize event which will be cancelled until
			// the Cordova 'deviceReady' event is received.
			addEventListener("preinitialize", handlePreInit);
			
			super.start();
		}
		
		/**
		 * @private
		 */
		private function handlePreInit(event:Event):void
		{
			if (!isDeviceReady) {
				event.preventDefault(); // basically, cancel the event until the device is ready
			}
		}
		
		/**
		 * @private
		 */
		private function startOnReady(event:*):void
		{
			isDeviceReady = true;
			removeEventListener("preinitialize", handlePreInit);
		}
	}
}
