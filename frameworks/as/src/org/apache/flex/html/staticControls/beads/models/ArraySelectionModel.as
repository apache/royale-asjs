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
package org.apache.flex.html.staticControls.beads.models
{
	import org.apache.flex.core.IRollOverModel;
	import org.apache.flex.core.ISelectionModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.EventDispatcher;
			
	public class ArraySelectionModel extends EventDispatcher implements ISelectionModel, IRollOverModel
	{
		public function ArraySelectionModel()
		{
		}

		private var _strand:IStrand;
		
		public function set strand(value:IStrand):void
		{
			_strand = value;
		}
		
		private var _dataProvider:Object;
        
		public function get dataProvider():Object
		{
			return _dataProvider;
		}
		public function set dataProvider(value:Object):void
		{
            _dataProvider = value;
			dispatchEvent(new Event("dataProviderChanged"));
		}

		private var _selectedIndex:int = -1;
		private var _rollOverIndex:int = -1;
		
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		public function set selectedIndex(value:int):void
		{
			_selectedIndex = value;
			_selectedItem = (value == -1) ? null : (value < _dataProvider.length) ? _dataProvider[value] : null;
			dispatchEvent(new Event("selectedIndexChanged"));			
		}
		
		public function get rollOverIndex():int
		{
			return _rollOverIndex;
		}
		public function set rollOverIndex(value:int):void
		{
			_rollOverIndex = value;
			dispatchEvent(new Event("rollOverIndexChanged"));			
		}
		
		private var _selectedItem:Object;
		
		public function get selectedItem():Object
		{
			return _selectedItem;
		}
		public function set selectedItem(value:Object):void
		{
			_selectedItem = value;	
			var n:int = _dataProvider.length;
			for (var i:int = 0; i < n; i++)
			{
				if (_dataProvider[i] == value)
				{
					_selectedIndex = i;
					break;
				}
			}
			dispatchEvent(new Event("selectedItemChanged"));			
			dispatchEvent(new Event("selectedIndexChanged"));
		}
		
		private var _selectedString:String;
		
		public function get selectedString():String
		{
			return String(_selectedItem);
		}
		public function set selectedString(value:String):void
		{
			_selectedString = value;
			var n:int = _dataProvider.length;
			for (var i:int = 0; i < n; i++)
			{
				if (String(_dataProvider[i]) == value)
				{
					_selectedIndex = i;
					break;
				}
			}
			dispatchEvent(new Event("selectedItemChanged"));			
			dispatchEvent(new Event("selectedIndexChanged"));			
		}
	}
}