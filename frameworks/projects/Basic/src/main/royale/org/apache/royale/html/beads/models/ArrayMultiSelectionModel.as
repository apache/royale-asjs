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
package org.apache.royale.html.beads.models
{
	import org.apache.royale.core.IRollOverModel;
	import org.apache.royale.core.IMultiSelectionModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
			
	/**
	 *  The ArrayMultiSelectionModel class is a selection model for
	 *  a dataProvider that is an array. It assumes that items
	 *  can be fetched from the dataProvider
	 *  dataProvider[index].  Other selection models
	 *  would support other kinds of data providers.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion 0.9.7
	 */

	public class ArrayMultiSelectionModel extends EventDispatcher implements IMultiSelectionModel, IRollOverModel
	{
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function ArrayMultiSelectionModel()
		{
		}

		private var _strand:IStrand;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
		}
		
		private var _dataProvider:Object;
        
		/**
		 *  @copy org.apache.royale.core.IMultiSelectionModel#dataProvider
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
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
			if (value == _dataProvider) return;
			_dataProvider = value;
			if(_dataProvider && _selectedIndices)
			{
				var indices:Array = [];
				var length:int = (value as Array).length;
				for (var i:int = 0; i < _selectedIndices.length; i++)
				{
					if (_selectedIndices[i] < length)
					{
						indices.push(value[_selectedIndices[i]]);
					}
					_selectedIndices = indices;
					syncItemsAndIndices();
				}
			}
			dispatchEvent(new Event("dataProviderChanged"));
		}

		private var _selectedIndices:Array = null;
		private var _rollOverIndex:int = -1;
		private var _labelField:String = null;
		
		/**
		 *  @copy org.apache.royale.core.IMultiSelectionModel#labelField
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
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
		 *  @copy org.apache.royale.core.IMultiSelectionModel#selectedIndices
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function get selectedIndices():Array
		{
			return _selectedIndices;
		}

		/**
		 *  @private
		 */
		public function set selectedIndices(value:Array):void
		{
			if (value == _selectedIndices) return;
			_selectedIndices = value;
			if (value == null || dataProvider == null)
			{
				_selectedItems = null;
			} else
			{
				syncItemsAndIndices();
			}
			dispatchEvent(new Event("selectedItemsChanged"));			
			dispatchEvent(new Event("selectedIndicesChanged"));
		}
		
		/**
		 *  @copy org.apache.royale.core.IRollOverModel#rollOverIndex
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
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
		
		private var _selectedItems:Array;
		
		/**
		 *  @copy org.apache.royale.core.IMultiSelectionModel#selectedItems
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function get selectedItems():Array
		{
			return _selectedItems;
		}

		/**
		 *  @private
		 */
		public function set selectedItems(value:Array):void
		{
			if (value == _selectedItems) return;

			_selectedItems = value;	
			_selectedIndices = [];
			var dp:Array = _dataProvider as Array;
			for (var i:int = 0; i < value.length; i++)
			{
				_selectedIndices.push(dp.indexOf(value[i]));
			}
			dispatchEvent(new Event("selectedItemsChanged"));			
			dispatchEvent(new Event("selectedIndicesChanged"));
		}
		

		private function syncItemsAndIndices():void
		{
				var items:Array = [];
				for (var i:int = 0; i < _selectedIndices.length; i++)
				{
					items.push(dataProvider[_selectedIndices[i]]);
				}
				_selectedItems = items;
		}
	}
}
