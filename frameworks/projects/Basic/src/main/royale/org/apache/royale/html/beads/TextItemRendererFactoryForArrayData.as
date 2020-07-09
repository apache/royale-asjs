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
package org.apache.royale.html.beads
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IDataProviderItemRendererMapper;
	import org.apache.royale.core.IItemRendererClassFactory;
	import org.apache.royale.core.IItemRendererOwnerView;
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IStrandWithModelView;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.events.ItemRendererEvent;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.beads.IListView;
	import org.apache.royale.utils.loadBeadFromValuesManager;
	import org.apache.royale.core.DispatcherBead;
	import org.apache.royale.utils.sendStrandEvent;
	import org.apache.royale.core.ILabelFieldItemRenderer;
	import org.apache.royale.core.IIndexedItemRenderer;

	[Event(name="itemRendererCreated",type="org.apache.royale.events.ItemRendererEvent")]

	/**
	 *  The TextItemRendererFactoryForArrayData class is the
	 *  IDataProviderItemRendererMapper for creating
	 *  ITextItemRenderers and assigning them data from an array.
	 *  Other IDataProviderItemRendererMapper implementations
	 *  assign specific array or vector types to item
	 *  renderers expecting those types.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	public class TextItemRendererFactoryForArrayData extends DispatcherBead implements IDataProviderItemRendererMapper
	{
		/**
		 *  Constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function TextItemRendererFactoryForArrayData(target:Object=null)
		{
			super(target);
		}

		private var selectionModel:ISelectionModel;

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			listenOnStrand("initComplete",finishSetup);
		}

		/**
		 * @royaleignorecoercion org.apache.royale.core.IItemRendererClassFactory
		 * @royaleignorecoercion org.apache.royale.core.ISelectionModel
		 */
		private function finishSetup(event:Event):void
		{
			selectionModel = _strand.getBeadByType(ISelectionModel) as ISelectionModel;
			selectionModel.addEventListener("dataProviderChanged", dataProviderChangeHandler);

			// if the host component inherits from DataContainerBase, the itemRendererClassFactory will
			// already have been loaded by DataContainerBase.addedToParent function.
			if (!itemRendererFactory)
			{
				_itemRendererFactory = loadBeadFromValuesManager(IItemRendererClassFactory, "iItemRendererClassFactory", _strand) as IItemRendererClassFactory;
			}

			dataProviderChangeHandler(null);
		}

		private var _itemRendererFactory:IItemRendererClassFactory;

		/**
		 *  An IItemRendererClassFactory that should generate ITextItemRenderers
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 *  @royaleignorecoercion org.apache.royale.core.IItemRendererClassFactory
		 */
		public function get itemRendererFactory():IItemRendererClassFactory
		{
			if(!_itemRendererFactory)
				_itemRendererFactory = loadBeadFromValuesManager(IItemRendererClassFactory, "iItemRendererClassFactory", _strand) as IItemRendererClassFactory;
			
			return _itemRendererFactory
		}

		/**
		 *  @private
		 */
		public function set itemRendererFactory(value:IItemRendererClassFactory):void
		{
			_itemRendererFactory = value;
		}

		/**
		 *  The IItemRendererOwnerView that should parent the ITextItemRenderers
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 *  @royaleignorecoercion Array
		 *  @royaleignorecoercion org.apache.royale.core.ILabelFieldItemRenderer
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 *  @royaleignorecoercion org.apache.royale.core.IStrandWithModelView
		 *  @royaleignorecoercion org.apache.royale.html.beads.IListView
		 *  @royaleignorecoercion org.apache.royale.core.IIndexedItemRenderer
		 */
		private function dataProviderChangeHandler(event:Event):void
		{
			var dp:Array = selectionModel.dataProvider as Array;
			if (!dp)
				return;

			var view:IListView = (_strand as IStrandWithModelView).view as IListView;
			var dataGroup:IItemRendererOwnerView = view.dataGroup;

			dataGroup.removeAllItemRenderers();

			var n:int = dp.length;
			for (var i:int = 0; i < n; i++)
			{
				var ir:IIndexedItemRenderer = itemRendererFactory.createItemRenderer() as IIndexedItemRenderer;
				var tf:ILabelFieldItemRenderer = ir as ILabelFieldItemRenderer;
				ir.index = i;
				dataGroup.addItemRenderer(ir, false);
				if (tf && selectionModel.labelField) {
					tf.labelField = selectionModel.labelField;
				}
				ir.data = dp[i];

				var newEvent:ItemRendererEvent = new ItemRendererEvent(ItemRendererEvent.CREATED);
				newEvent.itemRenderer = ir;
				dispatchEvent(newEvent);
			}

			sendStrandEvent(_strand,"itemsCreated");
		}

	}
}
