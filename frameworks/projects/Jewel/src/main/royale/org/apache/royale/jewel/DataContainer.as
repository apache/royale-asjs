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
package org.apache.royale.jewel
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IDataProviderModel;
	import org.apache.royale.core.IListWithPresentationModel;
	import org.apache.royale.jewel.beads.models.ListPresentationModel;
	import org.apache.royale.jewel.supportClasses.container.DataContainerBase;
	import org.apache.royale.jewel.supportClasses.list.IListPresentationModel;

	/**
	 * The default property uses when additional MXML content appears within an element's
	 * definition in an MXML file.
	 */
	[DefaultProperty("dataProvider")]

	/**
	 *  The Jewel DataContainer class is a component that displays multiple data items.
	 * 
	 *  This component gets the data through its `dataProvider` property that receives 
	 *  an `ArrayList` of data objects. To represent each item the component use 
	 *  an [ItemRenderer](/features/item-renderers) class that can be configured and customized. 
	 * 
	 *  The component generate dynamically as many instances of ItemRenderer as items in the 
	 *  data provider array and fill each instance with the appropiate data. 
	 *  By default it uses `StringItemRenderer` as the item renderer.
	 * 
	 *  By default items are layout vertically using Jewel `VerticalLayout`. This component 
	 *  has a `Viewport` that clip generated items.
	 *  
	 *  The DataContainer uses the following bead types:
	 *
	 *  org.apache.royale.core.IBeadModel: the data model, which includes the dataProvider.
	 *  org.apache.royale.core.IBeadView:  the bead that constructs the visual parts of the list.
	 *  org.apache.royale.core.IBeadLayout: the bead responsible for the size and position of the itemRenderers.
	 *  org.apache.royale.core.IDataProviderItemRendererMapper: the bead responsible for creating the itemRenders.
	 *  org.apache.royale.core.IItemRendererClassFactory: the factory for the itemrenders.
	 *  org.apache.royale.core.IItemRenderer: the class that describes the each piece of data.
	 *  org.apache.royale.core.IItemRendererInitializer: the class that initialize the renderer and provide additional configuration.
	 *  org.apache.royale.core.IViewport: the class that defines the area that display content
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class DataContainer extends DataContainerBase implements IListWithPresentationModel
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function DataContainer()
		{
			super();
            typeNames = "jewel datacontainer";
		}

		[Bindable("labelFieldChanged")]
		/**
		 *  The name of field within the data used for display. Each item of the
		 *  data should have a property with this name.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 *  @royaleignorecoercion org.apache.royale.core.IDataProviderModel
		 */
		public function get labelField():String
		{
			return IDataProviderModel(model).labelField;
		}
		/**
		 * @royaleignorecoercion org.apache.royale.core.IDataProviderModel
		 */
		public function set labelField(value:String):void
		{
            IDataProviderModel(model).labelField = value;
		}

		[Bindable("dataProviderChanged")]
		/**
		 *  The data being display by the List.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 *  @royaleignorecoercion org.apache.royale.core.IDataProviderModel
		 */
        public function get dataProvider():Object
        {
            return IDataProviderModel(model).dataProvider;
        }
		/**
		 * @royaleignorecoercion org.apache.royale.core.IDataProviderModel
		 */
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
		 *  @productversion Royale 0.9
		 *  @royaleignorecoercion org.apache.royale.jewel.supportClasses.list.IListPresentationModel
		 */
		public function get presentationModel():IBead
		{
			var presModel:IListPresentationModel = getBeadByType(IListPresentationModel) as IListPresentationModel;
			if (presModel == null) {
				presModel = new ListPresentationModel();
				addBead(presModel);
			}
			return presModel;
		}
   	}
}
