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
package simple
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IDataProviderItemRendererMapper;
	import org.apache.royale.core.IItemRendererClassFactory;
	import org.apache.royale.core.IItemRendererParent;
	import org.apache.royale.core.IListPresentationModel;
	import org.apache.royale.core.ISelectableItemRenderer;
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.SimpleCSSStyles;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.ItemRendererEvent;
	import org.apache.royale.html.beads.IListView;

	[Event(name="itemRendererCreated",type="org.apache.royale.events.ItemRendererEvent")]

    /**
     *  The IRFactoryForArrayData class reads an
     *  array of data and creates an item renderer for every
     *  item in the array.  Other implementations of
     *  IDataProviderItemRendererMapper map different data
     *  structures or manage a virtual set of renderers.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class IRFactoryForArrayData extends EventDispatcher implements IBead, IDataProviderItemRendererMapper
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function IRFactoryForArrayData(target:Object=null)
		{
			super(target);
		}

		private var selectionModel:ISelectionModel;

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
			IEventDispatcher(value).addEventListener("beadsAdded",finishSetup);
			IEventDispatcher(value).addEventListener("initComplete",finishSetup);
		}

		private function finishSetup(event:Event):void
		{
			selectionModel = _strand.getBeadByType(ISelectionModel) as ISelectionModel;
			var listView:IListView = _strand.getBeadByType(IListView) as IListView;
			dataGroup = listView.dataGroup;
			selectionModel.addEventListener("dataProviderChanged", dataProviderChangeHandler);

			if (!itemRendererFactory)
			{
				_itemRendererFactory = new (ValuesManager.valuesImpl.getValue(_strand, "iItemRendererClassFactory")) as IItemRendererClassFactory;
				_strand.addBead(_itemRendererFactory);
			}

			dataProviderChangeHandler(null);
		}

		private var _itemRendererFactory:IItemRendererClassFactory;

        /**
         *  The org.apache.royale.core.IItemRendererClassFactory used
         *  to generate instances of item renderers.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function get itemRendererFactory():IItemRendererClassFactory
		{
			return _itemRendererFactory;
		}

        /**
         *  @private
         */
		public function set itemRendererFactory(value:IItemRendererClassFactory):void
		{
			_itemRendererFactory = value;
		}

        /**
         *  The org.apache.royale.core.IItemRendererParent that will
         *  parent the item renderers.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		protected var dataGroup:IItemRendererParent;

		private function dataProviderChangeHandler(event:Event):void
		{
			var dp:Array = selectionModel.dataProvider as Array;
			if (!dp)
				return;

			dataGroup.removeAllItemRenderers();

			var listView:IListView = _strand.getBeadByType(IListView) as IListView;
			var presentationModel:IListPresentationModel = _strand.getBeadByType(IListPresentationModel) as IListPresentationModel;

			// This needs to be re-thought. There should be a better way to move the
			// properties from the component to the renderers. At least a new interface
			// should be created.
			var list:GenericList = _strand as GenericList;

			var n:int = dp.length;
			for (var i:int = 0; i < n; i++)
			{
				var ir:ISelectableItemRenderer = itemRendererFactory.createItemRenderer(dataGroup) as ISelectableItemRenderer;
				dataGroup.addItemRenderer(ir);
				ir.index = i;
				ir.labelField = list.labelField;
				if (presentationModel) {
					var style:SimpleCSSStyles = new SimpleCSSStyles();
					style.marginBottom = presentationModel.separatorThickness;
					UIBase(ir).style = style;
					UIBase(ir).height = presentationModel.rowHeight;
					UIBase(ir).percentWidth = 100;
				}
				ir.data = dp[i];

				var newEvent:ItemRendererEvent = new ItemRendererEvent(ItemRendererEvent.CREATED);
				newEvent.itemRenderer = ir;
				dispatchEvent(newEvent);
			}

			IEventDispatcher(_strand).dispatchEvent(new Event("itemsCreated"));
		}
	}
}
