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
package org.apache.royale.cordova.geolocation
{
	/**
	 * Geolocation provides the interface to the Cordova Geolocation plugin.
	 */

	[Mixin]
	/**
	 * The Geolocation class implements Cordova geolocation plugin
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10.2
	 * @playerversion AIR 2.6
	 * @productversion Royale 0.0
	 * @royalecordovaplugin cordova-plugin-geolocation
	 * @royaleignorecoercion FileEntry
	 * @royaleignorecoercion FileWriter
	 * @royaleignorecoercion window
     * @royaleignorecoercion Blob
	 */
	public class Geolocation
	{
		/**
		 * Constructor
		 */
		public function Geolocation()
		{
		}

		/**
		 * Gets the device current location. If successful, the onSuccess function is
		 * called with position parameter (see Cordova documentation). If failure, the
		 * onError function is called with an error parameter (.code and .message members).
		 */
		public function getCurrentPosition(onSuccess:Function, onError:Function):void
		{
			COMPILE::JS {
				// TODO: (pent) Cordova externs
				navigator["geolocation"].getCurrentPosition(onSuccess, onError);
			}
		}
	}
}
