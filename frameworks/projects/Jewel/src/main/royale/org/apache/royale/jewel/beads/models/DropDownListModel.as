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
    import org.apache.royale.events.Event;
    import org.apache.royale.html.beads.models.ArraySelectionModel;

    /**
     *  The DropDownListModel class defines the data associated with an org.apache.royale.jewel.DropDownListModel
     *  component.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
     */
    public class DropDownListModel extends ArraySelectionModel implements IDropDownListModel
    {
        public function DropDownListModel()
        {
            super();
        }

        private var offset:int = 1;

        private var _dataProvider:IArrayList;

		[Bindable("dataProviderChanged")]
        /**
         *  @copy org.apache.royale.core.ISelectionModel#dataProvider
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		override public function get dataProvider():Object
		{
			return _dataProvider;
		}

        /**
         *  @private
         */
		override public function set dataProvider(value:Object):void
		{
            if (value == _dataProvider) return;

            _dataProvider = value as IArrayList;
			if(!_dataProvider || _selectedIndex >= _dataProvider.length + offset)
				_selectedIndex = -1;
            
			_selectedItem = _selectedIndex == -1 ? null : _dataProvider.getItemAt(_selectedIndex - offset);
			
			dispatchEvent(new Event("dataProviderChanged"));
		}

		private var _selectedIndex:int = -1;

        /**
         *  @copy org.apache.royale.core.ISelectionModel#selectedIndex
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		override public function get selectedIndex():int
		{
			return _selectedIndex;
		}

        /**
         *  @private
         */
		override public function set selectedIndex(value:int):void
		{
            if (value == _selectedIndex) return;

			_selectedIndex = value;
			_selectedItem = (value == -1 || _dataProvider == null) ? null : (value < _dataProvider.length + offset) ? _dataProvider.getItemAt(value - offset) : null;
			dispatchEvent(new Event("selectedIndexChanged"));
		}

        private var _selectedItem:Object;

        /**
         *  @copy org.apache.royale.core.ISelectionModel#selectedItem
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		override public function get selectedItem():Object
		{
			return _selectedItem;
		}

        /**
         *  @private
         */
		override public function set selectedItem(value:Object):void
		{
            if (value == _selectedItem) return;

			_selectedItem = value;
			var n:int = _dataProvider.length + offset;
			for (var i:int = 1; i < n; i++)
			{
				if (_dataProvider.getItemAt(i) == value)
				{
					_selectedIndex = i - offset;
					break;
				}
			}
			dispatchEvent(new Event("selectedItemChanged"));
			dispatchEvent(new Event("selectedIndexChanged"));
		}
    }
}
