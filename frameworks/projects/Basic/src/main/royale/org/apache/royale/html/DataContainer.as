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
	import org.apache.royale.core.DataContainerBase;
	
	import org.apache.royale.core.ContainerBaseStrandChildren;
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IContentViewHost;
	import org.apache.royale.core.IChild;
	import org.apache.royale.core.IDataProviderItemRendererMapper;
	import org.apache.royale.core.IFactory;
	import org.apache.royale.core.IItemRendererClassFactory;
	import org.apache.royale.core.IItemRenderer;
	import org.apache.royale.core.IItemRendererOwnerView;
	import org.apache.royale.core.ILayoutView;
	import org.apache.royale.core.IStrandWithPresentationModel;
	import org.apache.royale.core.IRollOverModel;
	import org.apache.royale.core.IDataProviderModel;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.utils.loadBeadFromValuesManager;
    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
        import org.apache.royale.html.beads.ListView;
        import org.apache.royale.html.supportClasses.DataGroup;
    }
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.beads.models.ListPresentationModel;
	import org.apache.royale.html.beads.IListView;
	import org.apache.royale.core.IListWithPresentationModel;

	/**
	 *  Indicates that the initialization of the list is complete.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	[Event(name="initComplete", type="org.apache.royale.events.Event")]

	/**
	 *  The DataContainer class is a component that displays multiple data items. The DataContainer uses
	 *  the following bead types:
	 *
	 *  org.apache.royale.core.IBeadModel: the data model, which includes the dataProvider.
	 *  org.apache.royale.core.IBeadView:  the bead that constructs the visual parts of the list.
	 *  org.apache.royale.core.IBeadController: the bead that handles input and output.
	 *  org.apache.royale.core.IBeadLayout: the bead responsible for the size and position of the itemRenderers.
	 *  org.apache.royale.core.IDataProviderItemRendererMapper: the bead responsible for creating the itemRenders.
	 *  org.apache.royale.core.IItemRenderer: the class or factory used to display an item in the list.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class DataContainer extends DataContainerBase implements IStrandWithPresentationModel, IListWithPresentationModel
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function DataContainer()
		{
			super();
            typeNames = "DataContainer";
		}

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
		 *  @royaleignorecoercion org.apache.royale.html.IListPresentationModel
		 */
		public function get presentationModel():IBead
		{
			var presModel:IListPresentationModel = getBeadByType(IListPresentationModel) as IListPresentationModel;
			if (presModel == null) {
			    presModel = loadBeadFromValuesManager(IListPresentationModel, "iListPresentationModel", this) as IListPresentationModel;
				if (presModel == null)
				{		
					presModel = new ListPresentationModel();
					addBead(presModel);
				}
			}
			return presModel;
		}
   	}
}
