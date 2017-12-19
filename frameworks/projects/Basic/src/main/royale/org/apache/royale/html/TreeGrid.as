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
	import org.apache.royale.core.UIBase;
	import org.apache.royale.html.beads.models.TreeGridModel;
	
	/**
	 * A TreeGrid is a combination of a Tree and a DataGrid. The first column of the
	 * TreeGrid is a Tree; the remaining columns are Lists. Each column of the TreeGrid
	 * is defined by the TreeGridColumn, which names the data field within each datum 
	 * to be displayed. The dataProvider should be a HierarchicalData object with
	 * "children" properties to build the tree.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	public class TreeGrid extends UIBase
	{
		/**
		 * Constructor.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function TreeGrid()
		{
			super();
		}
		
		/**
		 * The dataProvider should be of type HierarchicalData.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 *  @see org.apache.royale.collections.HierarchicalData.
		 */
		public function get dataProvider():Object
		{
			return (model as TreeGridModel).dataProvider;
		}
		public function set dataProvider(value:Object):void
		{
			(model as TreeGridModel).dataProvider = value;
		}
		
		/**
		 * The TreeGridColumns that define each column displayed.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function get columns():Array
		{
			return (model as TreeGridModel).columns;
		}
		public function set columns(value:Array):void
		{
			(model as TreeGridModel).columns = value;
		}
	}
}