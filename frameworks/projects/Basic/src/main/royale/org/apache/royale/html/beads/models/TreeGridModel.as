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
	import org.apache.royale.collections.ArrayList;
	import org.apache.royale.collections.FlattenedList;
	import org.apache.royale.collections.HierarchicalData;
	import org.apache.royale.utils.ObjectMap;

	/**
	 * The data model for the TreeGrid. This contains the list of TreeGridColumn
	 * definitions, the HierarchicalData used to populate the TreeGrid, and
	 * the FlattendList of the HD which is actually displayed.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	public class TreeGridModel extends ArrayListSelectionModel
	{
		/**
		 * Constructor.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function TreeGridModel()
		{
			super();
		}
		
		private var _columns:Array;
		
		/**
		 * The TreeGridColumn definitions.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function get columns():Array
		{
			return _columns;
		}
		public function set columns(value:Array):void
		{
			_columns = value;
		}
		
		private var _hierarchicalData:HierarchicalData;
		
		/**
		 * @private
		 */
		override public function get dataProvider():Object
		{
			return _hierarchicalData;
		}
		override public function set dataProvider(value:Object):void
		{
			if (value == _hierarchicalData) return;
			
			_hierarchicalData = value as HierarchicalData;
			
			_flatList = new FlattenedList(_hierarchicalData);
			super.dataProvider = _flatList;
		}
		
		private var _flatList:FlattenedList;
		
		/**
		 * @private
		 */
		public function get flatList():FlattenedList
		{
			return _flatList;
		}
	}
}