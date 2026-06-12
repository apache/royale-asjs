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
package org.apache.royale.style.beads
{
	import org.apache.royale.html.beads.IndexedItemRendererInitializer;
	import org.apache.royale.core.IIndexedItemRenderer;
	import org.apache.royale.collections.TreeData;
	import org.apache.royale.html.supportClasses.TreeListData;
	import org.apache.royale.core.IListDataItemRenderer;

	public class TreeItemRendererInitializer extends IndexedItemRendererInitializer
	{
		public function TreeItemRendererInitializer()
		{
			super();
		}
		/**
		 * @royaleignorecoercion org.apache.royale.collections.TreeData
		 * @royaleignorecoercion org.apache.royale.core.IListDataItemRenderer
		 */
		override public function initializeIndexedItemRenderer(ir:IIndexedItemRenderer, data:Object, index:int):void
		{
			if (!dataProviderModel)
				return;
			
			super.initializeIndexedItemRenderer(ir, data, index);
			
			var treeData:TreeData = dataProviderModel.dataProvider as TreeData;
			var depth:int = treeData.getDepth(data);
			var isOpen:Boolean = treeData.isOpen(data);
			var hasChildren:Boolean = treeData.hasChildren(data);
			
			// Set the listData with the depth of this item
			var treeListData:TreeListData = new TreeListData();
			treeListData.depth = depth;
			treeListData.isOpen = isOpen;
			treeListData.hasChildren = hasChildren;
			
			(ir as IListDataItemRenderer).listData = treeListData;
		}		
	}
}