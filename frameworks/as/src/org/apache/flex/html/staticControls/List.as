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
package org.apache.flex.html.staticControls
{
	import org.apache.flex.core.IInitSkin;
	import org.apache.flex.core.ISelectionModel;
	import org.apache.flex.core.UIBase;
	
	/**
	 *  Label probably should extend TextField directly,
	 *  but the player's APIs for TextLine do not allow
	 *  direct instantiation, and we might want to allow
	 *  Labels to be declared and have their actual
	 *  view be swapped out.
	 */
	public class List extends UIBase implements IInitSkin
	{
		public function List()
		{
			super();
		}
		
		public function get selectedIndex():int
		{
			return ISelectionModel(model).selectedIndex;
		}
		public function set selectedIndex(value:int):void
		{
			ISelectionModel(model).selectedIndex = value;
		}
		
		public function get selectedItem():Object
		{
			return ISelectionModel(model).selectedItem;
		}
		public function set selectedItem(value:Object):void
		{
			ISelectionModel(model).selectedItem = value;
		}
		
		override public function initModel():void
		{
		}
		
		public function initSkin():void
		{
		}
	}
}