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
package org.apache.royale.crux.storage
{
	public interface IAMFStorageBean
	{
		/**
		 *
		 * @param path AMFStorage localPath value. default is "/"
		 *
		 */
		function set localPath( path : String ):void;
		
		/**
		 *
		 * @param name AMFStorage name value.
		 *
		 */
		function set name( name : String ):void;
		
		/**
		 *
		 * @return Size of the AMFStorage
		 *
		 */
		// function get size():Number;
		
		/**
		 * clears the AMFStorage data
		 */
		function clear():void;
		
		/**
		 *
		 * @param name Name of the value
		 * @return True if the value already exists. False if the value does not exist.
		 *
		 */
		function hasValue( name : String ):Boolean;
		
		/**
		 *
		 * @param name Value name
		 * @param initValue Optional initial value. Default is null.
		 * @return Untyped value
		 *
		 */
		function getValue( name : String, initValue : * = null ):*;
		
		/**
		 *
		 * @param name Value name
		 * @param value String value
		 *
		 */
		function setValue( name : String, value : * ):void;
		
		/**
		 *
		 * @param name Value name
		 * @param initValue Optional initial value. Default is null.
		 * @return String value
		 *
		 */
		function getString( name : String, initValue : String = null ):String;
		
		/**
		 *
		 * @param name Value name
		 * @param value String value
		 *
		 */
		function setString( name : String, value : String ):void;
		
		/**
		 *
		 * @param name Value name
		 * @param initValue Optional initial value. Default is false.
		 * @return Boolean value
		 *
		 */
		function getBoolean( name : String, initValue : Boolean = false ):Boolean;
		
		/**
		 *
		 * @param name Value name
		 * @param value Boolean value
		 *
		 */
		function setBoolean( name : String, value : Boolean ):void;
		
		/**
		 *
		 * @param name Value name
		 * @param initValue Optional initial value. Default is NaN.
		 * @return Number value
		 *
		 */
		function getNumber( name : String, initValue : Number = NaN ):Number;
		
		/**
		 *
		 * @param name Value name
		 * @param value Number value
		 *
		 */
		function setNumber( name : String, value : Number ):void;
		
		/**
		 *
		 * @param name Value name
		 * @param initValue Optional initial value. Default is -1.
		 * @return Integer value
		 *
		 */
		function getInt( name : String, initValue : int = -1 ):int;
		
		/**
		 *
		 * @param name Value name
		 * @param value Integer value
		 *
		 */
		function setInt( name : String, value : int ):void;
	}
}