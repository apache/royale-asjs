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
package org.apache.royale.storage
{
	import org.apache.royale.storage.providers.LocalStorageProvider;
	import org.apache.royale.core.ValuesManager;

/**
 *  The LocalStorage class allows apps to store small amounts of data
 *  locally, in the browser's permitted storage area. This data will persist
 *  between browser invocations. The data is stored in key=value pairs.
 *
 *  This class uses the ValuesManager to determine a storage provider - an implementation
 *  class the actually does the storing and retrieving. To change the provider implementation,
 *  set a ClassReference for the LocalStorage CSS style. The default is the
 *  org.apache.royale.storage.providers.LocalStorageProvider class.
 *
 *  @see org.apache.royale.storage.IWebStorage
 *  @see org.apache.royale.storage.provides.LocalStorageProvider
 *  @langversion 3.0
 *  @playerversion Flash 10.2
 *  @playerversion AIR 2.6
 *  @productversion Royale 0.0
 */
public class LocalStorage
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
	public function LocalStorage()
	{
		storageProvider = ValuesManager.valuesImpl.newInstance(this, "iStorageProvider") as IWebStorage;
	}

	/**
	 * The implementation of the storage system.
	 */
	private var storageProvider:IWebStorage;

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
		return storageProvider.storageAvailable();
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
	public function setItem(key:String, value:Object) : Boolean
	{
		// turn the value into a string in some fashion, if possible, return
		// the knowlege of what type value really is for getItem().
		var valueAsString:String = value.toString();
		return storageProvider.setItem(key, valueAsString);
	}

	/**
	 * Returns the value associated with the key, or undefined if there is
	 * no value stored. Note that a String version of the value may have been
	 * stored, depending on the platform.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 *  @royaleignoreimport window
	 */
	public function getItem(key:String) : Object
	{
		var value:Object = storageProvider.getItem(key);
		// perhaps figure out what value is exactly and return that
		// object.
		return value;
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
		return storageProvider.removeItem(key);
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
		return storageProvider.hasItem(key);
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
		storageProvider.clear();
	}
}
}
