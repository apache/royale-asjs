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
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.events.ItemRendererEvent;
	import org.apache.flex.html.List;
	
	import org.apache.flex.core.IList;
	import org.apache.flex.core.IChild;
	import org.apache.flex.core.ILayoutHost;
	import org.apache.flex.core.IParentIUIBase;
    import org.apache.flex.html.supportClasses.DataItemRenderer;

    [Event(name="itemRendererCreated",type="org.apache.flex.events.ItemRendererEvent")]
	
    /**
     *  The DataItemRendererFactoryForArrayData class reads an
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
	public class DataItemRendererFactoryForArrayData extends EventDispatcher implements IBead, IDataProviderItemRendererMapper
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function DataItemRendererFactoryForArrayData(target:Object=null)
		{
			super(target);
		}

		protected var dataProviderModel:IDataProviderModel;
		protected var dataFieldProvider:DataFieldProviderBead;
		
		protected var labelField:String;
        protected var dataField:String;

		private var _strand:IStrand;
		
        /**
         *  @copy org.apache.flex.core.IBead#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			IEventDispatcher(value).addEventListener("initComplete",finishSetup);
		}
		
		/**
		 * @private
		 */
		private function finishSetup(event:Event):void
		{			
			dataProviderModel = _strand.getBeadByType(IDataProviderModel) as IDataProviderModel;
			dataProviderModel.addEventListener("dataProviderChanged", dataProviderChangeHandler);
			labelField = dataProviderModel.labelField;

            dataFieldProvider = _strand.getBeadByType(DataFieldProviderBead) as DataFieldProviderBead;
			if (dataFieldProvider)
            {
                dataField = dataFieldProvider.dataField;
            }

			// if the host component inherits from DataContainerBase, the itemRendererClassFactory will 
			// already have been loaded by DataContainerBase.addedToParent function.
			_itemRendererFactory = _strand.getBeadByType(IItemRendererClassFactory) as IItemRendererClassFactory;
			if (itemRendererFactory == null) {
				_itemRendererFactory = new (ValuesManager.valuesImpl.getValue(_strand, "iItemRendererClassFactory")) as IItemRendererClassFactory;
				_strand.addBead(_itemRendererFactory);
			}
			
			dataProviderChangeHandler(null);
		}
		
		private var _itemRendererFactory:IItemRendererClassFactory;
		
        /**
         *  The org.apache.flex.core.IItemRendererClassFactory used 
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
         *  The org.apache.flex.core.IItemRendererParent that will
         *  parent the item renderers.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */		
		protected function dataProviderChangeHandler(event:Event):void
		{
			var dp:Array = dataProviderModel.dataProvider as Array;
			if (!dp)
				return;
			
			var list:IList = _strand as IList;
			var dataGroup:IItemRendererParent = list.dataGroup;
			
			dataGroup.removeAllItemRenderers();
			
			var presentationModel:IListPresentationModel = _strand.getBeadByType(IListPresentationModel) as IListPresentationModel;
			
			var n:int = dp.length; 
			for (var i:int = 0; i < n; i++)
			{				
				var ir:ISelectableItemRenderer = itemRendererFactory.createItemRenderer(dataGroup) as ISelectableItemRenderer;
                var dataItemRenderer:DataItemRenderer = ir as DataItemRenderer;

				dataGroup.addItemRenderer(ir);
				ir.index = i;
				ir.labelField = labelField;
                if (dataItemRenderer)
                {
                    dataItemRenderer.dataField = dataField;
                }

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
