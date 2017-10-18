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
package org.apache.royale.storage.providers
{
	import org.apache.royale.storage.IWebStorage;

COMPILE::SWF {
	import flash.net.SharedObject;
}

/**
 *  The LocalStorageProvider class allows apps to store small amounts of data
 *  locally, in the browser's permitted storage area. This data will persist
 *  between browser invocations. The data is stored in key=value pairs and the
 *  value must be a string.
 *
 *  @langversion 3.0
 *  @playerversion Flash 10.2
 *  @playerversion AIR 2.6
 *  @productversion Royale 0.0
 *  @royaleignoreimport window
 */
public class LocalStorageProvider implements IWebStorage
{

	/**
	 * Constructor.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 *  @royaleignoreimport window
	 */
	public function LocalStorageProvider()
	{
		COMPILE::SWF {
			try {
				sharedObject = SharedObject.getLocal("royale","/",false);
			} catch(e) {
				sharedObject = null;
			}
		}
	}

	COMPILE::SWF
	private var sharedObject:SharedObject;

	/**
	 * Returns true if the platform provides local storage.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 *  @royaleignoreimport window
	 */
	public function storageAvailable():Boolean
	{
		var result:Boolean = false;

		COMPILE::SWF {
			result = (sharedObject != null);
		}

		COMPILE::JS {
			try {
				result = 'localStorage' in window && window['localStorage'] !== null;
			} catch(e) {
				result = false;
			}
		}

		return result;
	}

	/**
	 * Stores a value with a key.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 *  @royaleignoreimport window
	 */
	public function setItem(key:String, value:String) : Boolean
	{
		if (!storageAvailable()) return false;

		COMPILE::SWF {
			sharedObject.data[key] = value;
			sharedObject.flush();
		}

		COMPILE::JS {
			window.localStorage.setItem(key, value);
		}

		return true;
	}

	/**
	 * Returns the value associated with the key, or undefined if there is
	 * no value stored. Note that a String version of the value is stored.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 *  @royaleignoreimport window
	 */
	public function getItem(key:String) : String
	{
		if (!storageAvailable()) return null;

		var result:String = null;

		COMPILE::SWF {
			result = sharedObject.data[key] as String;
		}

		COMPILE::JS {
			result = window.localStorage.getItem(key);
		}

		return result;
	}

	/**
	 * Removed the value and, possibly, the key from local storage. On some
	 * platforms, retriving the value after removing it will be an error, on
	 * others it may return undefined or null.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 *  @royaleignoreimport window
	 */
	public function removeItem(key:String) : Boolean
	{
		if (!storageAvailable()) return null;

		COMPILE::SWF {
			delete sharedObject.data[key];
			sharedObject.flush();
		}

		COMPILE::JS {
			window.localStorage.removeItem(key);
		}

		return true;
	}

	/**
	 * Returns true if there is a value stored for the key.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 *  @royaleignoreimport window
	 */
	public function hasItem(key:String) : Boolean
	{
		if (!storageAvailable()) return false;

		var result:Boolean = false;

		COMPILE::SWF {
			result = sharedObject.data.hasOwnProperty(key);
		}

		COMPILE::JS {
			result = (window.localStorage[key] !== null);
		}

		return result;
	}

	/**
	 * Clears all values from local storage.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 *  @royaleignoreimport window
	 */
	public function clear() : void
	{
		if (!storageAvailable()) return;

		COMPILE::SWF {
			sharedObject.clear();
		}

		COMPILE::JS {
			window.localStorage.clear();
		}
	}
}
}
