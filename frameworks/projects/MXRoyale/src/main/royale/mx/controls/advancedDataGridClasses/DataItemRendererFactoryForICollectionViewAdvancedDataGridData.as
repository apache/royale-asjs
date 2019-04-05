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
package mx.controls.advancedDataGridClasses
{
	import mx.collections.ICollectionView;
	import mx.collections.IViewCursor;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumnList;
	import mx.core.IUIComponent;
	
	import org.apache.royale.collections.FlattenedList;
	import org.apache.royale.collections.HierarchicalData;
	import org.apache.royale.collections.ITreeData;
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IBeadModel;
	import org.apache.royale.core.IDataProviderItemRendererMapper;
	import org.apache.royale.core.IDataProviderModel;
	import org.apache.royale.core.IItemRendererClassFactory;
	import org.apache.royale.core.IItemRendererParent;
	import org.apache.royale.core.IListPresentationModel;
	import org.apache.royale.core.ISelectableItemRenderer;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.SimpleCSSStyles;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.CollectionEvent;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.ItemRendererEvent;
	import org.apache.royale.html.List;
	import org.apache.royale.html.beads.DataItemRendererFactoryForCollectionView;
	import org.apache.royale.html.supportClasses.TreeListData;
	
	[Event(name="itemRendererCreated",type="org.apache.royale.events.ItemRendererEvent")]

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
     *  @productversion Royale 0.0
     */
	public class DataItemRendererFactoryForICollectionViewAdvancedDataGridData extends DataItemRendererFactoryForCollectionView
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function DataItemRendererFactoryForICollectionViewAdvancedDataGridData()
		{
			super();
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
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			
			super.strand = value;
		}
        
        /**
         * @private
         * @royaleignorecoercion mx.collections.ICollectionView
         * @royaleignorecoercion org.apache.royale.core.IListPresentationModel
         * @royaleignorecoercion org.apache.royale.core.ISelectableItemRenderer
         * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
         */
        override protected function dataProviderChangeHandler(event:Event):void
        {
            if (!dataProviderModel)
                return;
            var dp:ICollectionView = dataProviderModel.dataProvider as ICollectionView;
            if (!dp)
                return;
            
            // listen for individual items being added in the future.
            var dped:IEventDispatcher = dp as IEventDispatcher;
            dped.addEventListener(CollectionEvent.ITEM_ADDED, itemAddedHandler);
            dped.addEventListener(CollectionEvent.ITEM_REMOVED, itemRemovedHandler);
            dped.addEventListener(CollectionEvent.ITEM_UPDATED, itemUpdatedHandler);
            
            dataGroup.removeAllItemRenderers();
            
            var presentationModel:IListPresentationModel = _strand.getBeadByType(IListPresentationModel) as IListPresentationModel;
            labelField = dataProviderModel.labelField;
            
            var n:int = dp.length;
            var cursor:IViewCursor = dp.createCursor();
            for (var i:int = 0; i < n; i++)
            {
                var ir:ISelectableItemRenderer = itemRendererFactory.createItemRenderer(dataGroup) as ISelectableItemRenderer;
                var item:Object = cursor.current;
                cursor.moveNext();
                fillRenderer(i, item, ir, presentationModel);
            }
            
            IEventDispatcher(_strand).dispatchEvent(new Event("itemsCreated"));
        }

		
		/**
		 * Sets the itemRenderer's data with additional tree-related data.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
		 */
		override protected function setData(ir:ISelectableItemRenderer, data:Object, index:int):void
		{
            if (!(_strand as AdvancedDataGridColumnList).adg) return;
            
			var depth:int = (_strand as AdvancedDataGridColumnList).adg.getDepth(data);
			var isOpen:Boolean = (_strand as AdvancedDataGridColumnList).adg.isItemOpen(data);
			var hasChildren:Boolean = (_strand as AdvancedDataGridColumnList).adg.hasChildren(data);
            var listID:String = (_strand as AdvancedDataGridColumnList).id;
            var firstColumn:Boolean =  listID == "dataGridColumn0";
			
			// Set the listData with the depth of this item
			var treeListData:AdvancedDataGridListData = new AdvancedDataGridListData("", "", firstColumn ? 0 : 1, "", (_strand as AdvancedDataGridColumnList).adg, index);
			treeListData.depth = depth;
			treeListData.open = isOpen;
			treeListData.hasChildren = hasChildren;
			
			ir.listData = treeListData;
            if (firstColumn && (_strand as AdvancedDataGridColumnList).adg.groupLabelField)
                ir.labelField = (_strand as AdvancedDataGridColumnList).adg.groupLabelField;
			
			super.setData(ir, data, index);
		}
	}
}
