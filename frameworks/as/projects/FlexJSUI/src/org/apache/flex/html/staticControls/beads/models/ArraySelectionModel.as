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
			
    /**
     *  The ArraySelectionModel class is a selection model for
     *  a dataProvider that is an array. It assumes that items
     *  can be fetched from the dataProvider
     *  dataProvider[index].  Other selection models
     *  would support other kinds of data providers.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class ArraySelectionModel extends EventDispatcher implements ISelectionModel, IRollOverModel
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function ArraySelectionModel()
		{
		}

		private var _strand:IStrand;
		
        /**
         *  @copy org.apache.flex.core.IBead#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function set strand(value:IStrand):void
		{
			_strand = value;
		}
		
		private var _dataProvider:Object;
        
        /**
         *  @copy org.apache.flex.core.ISelectionModel#dataProvider
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function get dataProvider():Object
		{
			return _dataProvider;
		}

        /**
         *  @private
         */
		public function set dataProvider(value:Object):void
		{
            _dataProvider = value;
			dispatchEvent(new Event("dataProviderChanged"));
		}

		private var _selectedIndex:int = -1;
		private var _rollOverIndex:int = -1;
		private var _labelField:String = null;
		
        /**
         *  @copy org.apache.flex.core.ISelectionModel#labelField
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function get labelField():String
		{
			return _labelField;
		}

        /**
         *  @private
         */
		public function set labelField(value:String):void
		{
			if (value != _labelField) {
				_labelField = value;
				dispatchEvent(new Event("labelFieldChanged"));
			}
		}
		
        /**
         *  @copy org.apache.flex.core.ISelectionModel#selectedIndex
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}

        /**
         *  @private
         */
		public function set selectedIndex(value:int):void
		{
			_selectedIndex = value;
			_selectedItem = (value == -1) ? null : (value < _dataProvider.length) ? _dataProvider[value] : null;
			dispatchEvent(new Event("selectedIndexChanged"));			
		}
		
        /**
         *  @copy org.apache.flex.core.IRollOverModel#rollOverIndex
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function get rollOverIndex():int
		{
			return _rollOverIndex;
		}

        /**
         *  @private
         */
		public function set rollOverIndex(value:int):void
		{
			_rollOverIndex = value;
			dispatchEvent(new Event("rollOverIndexChanged"));			
		}
		
		private var _selectedItem:Object;
		
        /**
         *  @copy org.apache.flex.core.ISelectionModel#selectedItem
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function get selectedItem():Object
		{
			return _selectedItem;
		}

        /**
         *  @private
         */
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
		
        /**
         *  An alternative to selectedItem for strongly typing the
         *  the selectedItem if the Array is an Array of Strings.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function get selectedString():String
		{
			return String(_selectedItem);
		}

        /**
         *  @private
         */
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