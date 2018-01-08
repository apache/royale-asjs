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
package org.apache.royale.collections
{
	/**
	 * The ICollectionView interface is implemented by classes that provide
	 * collection data.
	 */
	public interface ICollectionView extends ICollection
	{
		function get length():int;
		function getItemIndex(item:Object):int;
		function addItem(item:Object):void;
		function addItemAt(item:Object, index:int):void;
		function setItemAt(item:Object, index:int):Object;
		function removeItem(item:Object):Boolean;
		function removeItemAt(index:int):Object;
		function removeAll():void;
		function itemUpdated(item:Object):void;
		function itemUpdatedAt(index:int):void;
	}
}