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
	
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
		
    /**
     *  The StringSelectionModel class is a selection model for
     *  selecting a single string from a vector of strings. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class StringSelectionModel extends EventDispatcher implements ISelectionModel
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function StringSelectionModel()
		{
		}

		private var _strand:IStrand;
		
        /**
         *  @copy org.apache.royale.core.IBead#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function set strand(value:IStrand):void
		{
			_strand = value;
		}
		
		private var _strings:Vector.<String>;

        /**
         *  The vector of strings.  This is the same
         *  as the dataProvider property but is
         *  strongly typed.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function get strings():Vector.<String>
		{
			return _strings;
		}
        
        /**
         *  @private
         */
		public function set strings(value:Vector.<String>):void
		{
			_strings = value;
			dispatchEvent(new Event("dataProviderChanged"));
		}

        /**
         *  The dataProvider, which is a
         *  Vector.&lt;String&gt;.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function get dataProvider():Object
		{
			return _strings;
		}

        /**
         *  @private
         */
		public function set dataProvider(value:Object):void
		{
			_strings = value as Vector.<String>;
			dispatchEvent(new Event("dataProviderChanged"));
		}

		private var _selectedIndex:int = -1;
		
        /**
         *  @copy org.apache.royale.core.ISelectionModel#selectedIndex
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
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
			_selectedString = (value == -1) ? null : (value < _strings.length) ? _strings[value] : null;
			dispatchEvent(new Event("selectedIndexChanged"));			
		}
		private var _selectedString:String;
		
        /**
         *  @copy org.apache.royale.core.ISelectionModel#selectedItem
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function get selectedItem():Object
		{
			return _selectedString;
		}
        
        /**
         *  @private
         */
		public function set selectedItem(value:Object):void
		{
			selectedString = String(value);	
		}

        /**
         *  The selected string.  This is the same as the
         *  selectedItem, but is strongly-typed.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function get selectedString():String
		{
			return _selectedString;
		}
        
        /**
         *  @private
         */
		public function set selectedString(value:String):void
		{
			_selectedString = value;
			var n:int = _strings.length;
			for (var i:int = 0; i < n; i++)
			{
				if (_strings[i] == value)
				{
					_selectedIndex = i;
					break;
				}
			}
			dispatchEvent(new Event("selectedItemChanged"));			
		}
		
		
		private var _labelField:String;
		
        /**
         *  The labelField, which is not used in this
         *  implementation.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
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
	}
}
