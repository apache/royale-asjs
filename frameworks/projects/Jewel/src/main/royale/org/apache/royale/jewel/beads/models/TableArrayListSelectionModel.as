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
package org.apache.royale.jewel.beads.models
{
	import org.apache.royale.collections.IArrayList;

    /**
     *  The ArrayListSelectionModel class is a selection model for
     *  a dataProvider that is an ArrayList. It assumes that items
     *  can be fetched from the dataProvider using dataProvider.getItemAt(index).
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
     */
	public class TableArrayListSelectionModel extends ArrayListSelectionModel
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		public function TableArrayListSelectionModel()
		{
		}

        /**
         *  @private
         */
		override public function set dataProvider(value:Object):void
		{
            if (value == _dataProvider) return;

            _dataProvider = value as IArrayList;
			if(!_dataProvider || _selectedIndex >= _dataProvider.length)
				_selectedIndex = -1;
            
			_selectedItem = _selectedIndex == -1 ? null : _dataProvider.getItemAt(_selectedIndex);
			
			dispatchChange("dataProviderChanged");
		}

        /**
         *  @private
         */
		override public function set selectedIndex(value:int):void
		{
            if (value == _selectedIndex) return;

			_selectedIndex = value;
			_selectedItem = (value == -1 || _dataProvider == null) ? null : (value < _dataProvider.length) ? _dataProvider.getItemAt(value) : null;
			dispatchChange("selectionChanged");
		}
		
        /**
         *  @private
         */
		override public function set selectedItem(value:Object):void
		{
            if (value == _selectedItem) return;

			_selectedItem = value;
			var n:int = _dataProvider.length;
			for (var i:int = 0; i < n; i++)
			{
				if (_dataProvider.getItemAt(i) == value)
				{
					_selectedIndex = i;
					break;
				}
			}
			dispatchChange("selectionChanged");
		}

		// private var _selectedString:String;

        /**
         *  @private
         */
	// 	public function set selectedString(value:String):void
	// 	{
	// 		_selectedString = value;
	// 		var n:int = _dataProvider.length;
	// 		for (var i:int = 0; i < n; i++)
	// 		{
	// 			if (String(_dataProvider.getItemAt(i)) == value)
	// 			{
	// 				_selectedIndex = i;
	// 				break;
	// 			}
	// 		}
	// 		dispatchChange("selectionChanged");
	// 	}
	}
}
