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

    /**
     *  The DropDownListModel class defines the data associated with an org.apache.royale.jewel.DropDownListModel
     *  component.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
     */
    public class DropDownListModel extends ArrayListSelectionModel implements IDropDownListModel
    {
        public function DropDownListModel()
        {
            super();
        }


        private var _offset:int = 1;
        public function get offset():int{
            return _offset;
        }

        private var _processingInteractiveChange:Boolean = false;
        public function set processingInteractiveChange(value:Boolean):void{
            _processingInteractiveChange = value;
        }


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
            var itemChanged:Boolean;
            const oldIndex:int = _selectedIndex;
            if (_dataProvider) {
                if (_selectedItem) {
                    _selectedIndex = _dataProvider.getItemIndex(_selectedItem);

                    if (_selectedIndex == -1) {
                        _selectedItem = null;
                        itemChanged = true;
                    }
                } else {
                    if (_selectedIndex != -1) {
                        if (_selectedIndex < _dataProvider.length) {
                            _selectedItem = _dataProvider.getItemAt(_selectedIndex);
                            itemChanged = true;
                        } else {
                            _selectedIndex = -1;
                        }
                    }
                }
            } else {
				itemChanged = _selectedItem != null;
                _selectedItem = null;
				_selectedIndex = -1;
			}

            dispatchEvent(new Event("dataProviderChanged"));
            if (itemChanged)
                dispatchEvent(new Event("selectedItemChanged"));
            if (oldIndex != _selectedIndex)
                dispatchEvent(new Event("selectedIndexChanged"));
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

            if (!_dataProvider) {
                _selectedIndex = value;
                return;
            }
            if (value == _selectedIndex) return;

            const oldItem:Object = _selectedItem;
            _selectedIndex = value < _dataProvider.length ? value : _dataProvider.length - 1;
            if (_selectedIndex != -1) {
                _selectedItem = _dataProvider.getItemAt(_selectedIndex);
            } else {
                _selectedItem = null;
            }

			if ( oldItem != _selectedItem)
                dispatchEvent(new Event("selectedItemChanged"));
            dispatchEvent(new Event("selectedIndexChanged"));
            if (!_processingInteractiveChange) {
                dispatchEvent(new Event("change"));
            }
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
            if (_dataProvider) {
                const indexChanged:Boolean = _selectedIndex != (_selectedIndex = _dataProvider.getItemIndex(value));

                dispatchEvent(new Event("selectedItemChanged"));
                if (indexChanged)
                    dispatchEvent(new Event("selectedIndexChanged"));
                if (!_processingInteractiveChange) {
                    dispatchEvent(new Event("change"));
                }
            }
		}
    }
}
