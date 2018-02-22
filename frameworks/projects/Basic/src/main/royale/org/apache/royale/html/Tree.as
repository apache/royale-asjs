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
package org.apache.royale.html
{
//	import org.apache.royale.collections.FlattenedList;
	import org.apache.royale.collections.HierarchicalData;
	import org.apache.royale.collections.TreeData;
	import org.apache.royale.html.beads.models.TreeModel;

	/**
	 *  The Tree component displays structured data. The Tree uses a HierarchicalData
	 *  object as its data provider. 
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class Tree extends List
	{
		/**
		 * Constructor.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function Tree()
		{
			super();
			typeNames += " Tree";
		}
		
		/**
		 * The dataProvider for a Tree is TreeData which is created
		 * from HierarchicalData. You can set the dataProvider with
		 * TreeData or HierarchicalData and it will create a TreeData
		 * from that.
		 */
		override public function set dataProvider(value:Object):void
		{
			if (value is HierarchicalData) {
				var treeData:TreeData = new TreeData(value as HierarchicalData);
				super.dataProvider = treeData;
			} else {
				super.dataProvider = value;
			}
		}
	}
}
