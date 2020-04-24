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
	import org.apache.royale.core.IBeadKeyController;
	import org.apache.royale.core.IDataProviderModel;
	import org.apache.royale.core.IRollOverModel;
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.core.IStrandWithPresentationModel;
	import org.apache.royale.jewel.beads.layouts.IVariableRowHeight;
	import org.apache.royale.jewel.beads.models.ListPresentationModel;
	import org.apache.royale.jewel.beads.views.IScrollToIndexView;
	import org.apache.royale.jewel.supportClasses.container.DataContainerBase;
	import org.apache.royale.jewel.supportClasses.list.IListPresentationModel;
	import org.apache.royale.utils.loadBeadFromValuesManager;

	/**
	 *  Indicates that the initialization of the list is complete.
	 *
     *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	[Event(name="initComplete", type="org.apache.royale.events.Event")]

	/**
	 *  The change event is dispatched whenever the list's selection changes.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
    [Event(name="change", type="org.apache.royale.events.Event")]

	/**
	 *  The List class is a component that displays multiple data items. The List uses
	 *  the following bead types:
	 *
	 *  org.apache.royale.core.IBeadModel: the data model, which includes the dataProvider, selectedItem, and
	 *  so forth.
	 *  org.apache.royale.core.IBeadView:  the bead that constructs the visual parts of the list.
	 *  org.apache.royale.core.IBeadController: the bead that handles input and output.
	 *  org.apache.royale.core.IBeadLayout: the bead responsible for the size and position of the itemRenderers.
	 *  org.apache.royale.core.IDataProviderItemRendererMapper: the bead responsible for creating the itemRenders.
	 *  org.apache.royale.core.IItemRenderer: the class or factory used to display an item in the list.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class List extends DataContainerBase implements IStrandWithPresentationModel, IVariableRowHeight
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function List()
		{
			super();
            typeNames = "jewel list";
			// rowHeight is not set by default, so set it to NaN
			rowHeight = NaN;

			tabIndex = 0;
		}

        [Bindable("labelFieldChanged")]
		/**
		 *  The name of field within the data used for display. Each item of the
		 *  data should have a property with this name.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
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
		 *  @productversion Royale 0.9.4
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
		 *  The index of the currently selected item. Changing this value
		 *  also changes the selectedItem property.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.core.ISelectionModel
		 */
		[Bindable("selectionChanged")]
        public function get selectedIndex():int
		{
			return ISelectionModel(model).selectedIndex;
		}
		/**
		 * @royaleignorecoercion org.apache.royale.core.ISelectionModel
		 */
		public function set selectedIndex(value:int):void
		{
			ISelectionModel(model).selectedIndex = value;
		}

        [Bindable("rollOverIndexChanged")]
		/**
		 *  The index of the item currently below the pointer.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.core.IRollOverModel
		 */
        public function get rollOverIndex():int
		{
			return IRollOverModel(model).rollOverIndex;
		}
		/**
		 * @royaleignorecoercion org.apache.royale.core.IRollOverModel
		 */
		public function set rollOverIndex(value:int):void
		{
			IRollOverModel(model).rollOverIndex = value;
		}

		/**
		 *  The default height of each cell in every column
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.core.IListPresentationModel
		 */
        public function get rowHeight():Number
        {
            return (presentationModel as IListPresentationModel).rowHeight;
        }
        public function set rowHeight(value:Number):void
        {
            (presentationModel as IListPresentationModel).rowHeight = value;
        }

		/**
		 *  The item currently selected. Changing this value also
		 *  changes the selectedIndex property.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.core.ISelectionModel
		 */
        [Bindable("selectionChanged")]
		public function get selectedItem():Object
		{
			return ISelectionModel(model).selectedItem;
		}
		/**
		 * @royaleignorecoercion org.apache.royale.core.ISelectionModel
		 */
		public function set selectedItem(value:Object):void
		{
			ISelectionModel(model).selectedItem = value;
		}
		
		protected var _variableRowHeight:Boolean;
		/**
		 *  Specifies whether layout elements are allocated their preferred height.
		 *  Setting this property to false specifies fixed height rows.
		 *  
		 *  If false, the actual height of each layout element is the value of rowHeight.
		 *  The default value is true. 
		 *  
		 *  Note: From Flex but we should see what to do in Royale -> Setting this property to false causes the layout to ignore the layout elements' percentHeight property.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		[Bindable("variableRowHeightChanged")]
        public function get variableRowHeight():Boolean
        {
			return (presentationModel as IListPresentationModel).variableRowHeight;
        }
        public function set variableRowHeight(value:Boolean):void
        {
			(presentationModel as IListPresentationModel).variableRowHeight = value;
        }

		/**
		 *  The presentation model for the list.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.core.IListPresentationModel
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

		/**
		 *  Ensures that the data provider item at the given index is visible.
		 *  
		 *  @param index The index of the item in the data provider.
		 *
		 *  @return <code>true</code> if the scroll changed.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.9.7
		 */
		public function scrollToIndex(index:int):Boolean
		{
			return (view as IScrollToIndexView).scrollToIndex(index);
		}

		/**
		 * @private
		 */
		override public function addedToParent():void
		{
			super.addedToParent();

			loadBeadFromValuesManager(IBeadKeyController, "iBeadKeyController", this);
		}
   	}
}
