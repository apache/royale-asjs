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
	import org.apache.flex.core.ContainerBaseStrandChildren;
	import org.apache.flex.core.IContentViewHost;
	import org.apache.flex.core.IDataProviderItemRendererMapper;
	import org.apache.flex.core.IFactory;
	import org.apache.flex.core.IItemRendererClassFactory;
	import org.apache.flex.core.IItemRendererProvider;
	import org.apache.flex.core.IListPresentationModel;
	import org.apache.flex.core.IRollOverModel;
	import org.apache.flex.core.IDataProviderModel;
	import org.apache.flex.core.ListBase;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;
        import org.apache.flex.html.beads.ListView;
        import org.apache.flex.html.supportClasses.DataGroup;
    }
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.beads.models.ListPresentationModel;
	
	/**
	 *  Indicates that the initialization of the list is complete.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	[Event(name="initComplete", type="org.apache.flex.events.Event")]
	
	/**
	 *  The List class is a component that displays multiple data items. The List uses
	 *  the following bead types:
	 * 
	 *  org.apache.flex.core.IBeadModel: the data model, which includes the dataProvider.
	 *  org.apache.flex.core.IBeadView:  the bead that constructs the visual parts of the list.
	 *  org.apache.flex.core.IBeadController: the bead that handles input and output.
	 *  org.apache.flex.core.IBeadLayout: the bead responsible for the size and position of the itemRenderers.
	 *  org.apache.flex.core.IDataProviderItemRendererMapper: the bead responsible for creating the itemRenders.
	 *  org.apache.flex.core.IItemRenderer: the class or factory used to display an item in the list.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class DataContainer extends ListBase implements IItemRendererProvider
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function DataContainer()
		{
			super();
			addEventListener("beadsAdded", beadsAddedHandler);
		}
		
		/**
		 *  The name of field within the data used for display. Each item of the
		 *  data should have a property with this name.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get labelField():String
		{
			return IDataProviderModel(model).labelField;
		}
		public function set labelField(value:String):void
		{
            IDataProviderModel(model).labelField = value;
		}
		
		/**
		 *  The data being display by the List.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
        public function get dataProvider():Object
        {
            return IDataProviderModel(model).dataProvider;
        }
        public function set dataProvider(value:Object):void
        {
            IDataProviderModel(model).dataProvider = value;
        }

			
		/**
		 *  The presentation model for the list.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get presentationModel():IListPresentationModel
		{
			var presModel:IListPresentationModel = getBeadByType(IListPresentationModel) as IListPresentationModel;
			if (presModel == null) {
				presModel = new ListPresentationModel();
				addBead(presModel);
			}
			return presModel;
		}
		
		/**
		 *  The default height of each cell in every column
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get rowHeight():Number
		{
			return presentationModel.rowHeight;
		}
		public function set rowHeight(value:Number):void
		{
			presentationModel.rowHeight = value;
		}
				
		private var _itemRenderer:IFactory;
		
		/**
		 *  The class or factory used to display each item.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get itemRenderer():IFactory
		{
			return _itemRenderer;
		}
		public function set itemRenderer(value:IFactory):void
		{
			_itemRenderer = value;
		}
		
		/**
		 * Returns whether or not the itemRenderer property has been set.
		 *
		 *  @see org.apache.flex.core.IItemRendererProvider
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get hasItemRenderer():Boolean
		{
			var result:Boolean = false;
			
			COMPILE::SWF {
				result = _itemRenderer != null;
			}
			
			COMPILE::JS {
				var test:* = _itemRenderer;
				result = _itemRenderer !== null && test !== undefined;
			}
			
			return result;
		}
		
		
		/**
		 * @private
		 */
		override public function addedToParent():void
		{
            super.addedToParent();
            		
			dispatchEvent(new Event("initComplete"));
		}
        
		/**
		 * @private
		 */
	    private function beadsAddedHandler(e:Event):void
		{
            if (getBeadByType(IDataProviderItemRendererMapper) == null)
            {
                var mapper:IDataProviderItemRendererMapper = new (ValuesManager.valuesImpl.getValue(this, "iDataProviderItemRendererMapper")) as IDataProviderItemRendererMapper;
                addBead(mapper);
            }
			var itemRendererFactory:IItemRendererClassFactory = getBeadByType(IItemRendererClassFactory) as IItemRendererClassFactory;
			if (!itemRendererFactory)
			{
				itemRendererFactory = new (ValuesManager.valuesImpl.getValue(this, "iItemRendererClassFactory")) as IItemRendererClassFactory;
				addBead(itemRendererFactory);
			}
		}
		
        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
            super.createElement();
            className = 'List';
            
            return element;
        }        

        /**
         * @flexjsignorecoercion org.apache.flex.html.beads.ListView 
         * @flexjsignorecoercion org.apache.flex.html.supportClasses.DataGroup 
         */
        COMPILE::JS
        override public function internalChildren():Array
        {
            var listView:ListView = getBeadByType(ListView) as ListView;
            var dg:DataGroup = listView.dataGroup as DataGroup;
            var renderers:Array = dg.internalChildren();
            return renderers;
        };
   	}
}
