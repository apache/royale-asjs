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
/**
 * The IWebStorage interface provides a template for classes to use that wish
 * to allow storage of small amounts of data into a web browser or perhaps on a
 * mobile device.
 *
 *  @langversion 3.0
 *  @playerversion Flash 10.2
 *  @playerversion AIR 2.6
 *  @productversion Royale 0.0
 */
public interface IWebStorage
{
	/**
	 * Returns true if the platform provides local storage.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 *  @royaleignoreimport window
	 */
	function storageAvailable() : Boolean;

	/**
	 * Stores a value with a key.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 *  @royaleignoreimport window
	 */
	function setItem(key:String, value:String) : Boolean;

	/**
	 * Returns the value of a key, if present. If the key is not
	 * present in the storage area, null or undefined may be returned.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 *  @royaleignoreimport window
	 */
	function getItem(key:String) : String;

	/**
	 * Removes the key=value pair from storage.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 *  @royaleignoreimport window
	 */
	function removeItem(key:String) : Boolean;

	/**
	 * Returns true if there is a value associated with the key.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 *  @royaleignoreimport window
	 */
	function hasItem(key:String) : Boolean;

	/**
	 * Clears the storage area of all key=value pairs.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 *  @royaleignoreimport window
	 */
	function clear() : void;
}
}
