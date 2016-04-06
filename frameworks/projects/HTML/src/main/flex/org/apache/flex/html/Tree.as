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
package org.apache.flex.html
{
	import org.apache.flex.collections.FlattenedList;
	import org.apache.flex.collections.HierarchicalData;

	/**
	 *  The Tree component displays structured data. The Tree uses a HierarchicalData
	 *  object as its data provider. 
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class Tree extends List
	{
		/**
		 * Constructor.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function Tree()
		{
			super();
		}

		private var _hierarchicalData:HierarchicalData;
		private var _flatList:FlattenedList;

		/**
		 * The dataProvider should be of type HierarchicalData.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 *  @see org.apache.flex.collections.HierarchicalData.
		 */
		override public function get dataProvider():Object
		{
			return _hierarchicalData;
		}
		override public function set dataProvider(value:Object):void
		{
			_hierarchicalData = value as HierarchicalData;

			_flatList = new FlattenedList(_hierarchicalData);

			super.dataProvider = _flatList;
		}
	}
}
