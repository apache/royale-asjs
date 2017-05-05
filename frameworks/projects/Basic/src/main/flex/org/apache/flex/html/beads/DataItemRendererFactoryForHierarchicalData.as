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
package org.apache.flex.html.beads
{
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IDataProviderItemRendererMapper;
	import org.apache.flex.core.IItemRendererClassFactory;
	import org.apache.flex.core.IItemRendererParent;
	import org.apache.flex.core.IListPresentationModel;
	import org.apache.flex.core.ISelectableItemRenderer;
	import org.apache.flex.core.IDataProviderModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.SimpleCSSStyles;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.EventDispatcher;
	import org.apache.flex.events.ItemRendererEvent;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.List;
	import org.apache.flex.html.supportClasses.TreeListData;
	import org.apache.flex.collections.FlattenedList;
	
	[Event(name="itemRendererCreated",type="org.apache.flex.events.ItemRendererEvent")]

    /**
     *  The DataItemRendererFactoryForHierarchicalData class reads a
     *  HierarchicalData object and creates an item renderer for every
     *  item in the array.  Other implementations of
     *  IDataProviderItemRendererMapper map different data
     *  structures or manage a virtual set of renderers.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class DataItemRendererFactoryForHierarchicalData extends DataItemRendererFactoryForArrayList
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function DataItemRendererFactoryForHierarchicalData()
		{
			super();
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
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			
			super.strand = value;
		}
		
		/**
		 * Sets the itemRenderer's data with additional tree-related data.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
		 */
		override protected function setData(ir:ISelectableItemRenderer, data:Object, index:int):void
		{
			// Set the listData with the depth of this item
			var flatList:FlattenedList = dataProviderModel.dataProvider as FlattenedList;
			var depth:int = flatList.getDepth(data);
			var isOpen:Boolean = flatList.isOpen(data);
			var hasChildren:Boolean = flatList.hasChildren(data);
			
			var treeData:TreeListData = new TreeListData();
			treeData.depth = depth;
			treeData.isOpen = isOpen;
			treeData.hasChildren = hasChildren;
			
			ir.listData = treeData;
			
			super.setData(ir, data, index);
		}
	}
}
