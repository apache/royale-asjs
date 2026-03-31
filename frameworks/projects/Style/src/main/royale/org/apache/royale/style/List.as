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
package org.apache.royale.style
{
	import org.apache.royale.core.IRollOverModel;
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.html.IListPresentationModel;
	import org.apache.royale.style.util.StyleManager;

	/**
	 *  Indicates that the initialization of the list is complete.
	 *
	 *  @toplevel
	 *  @langversion 3.0
	 *  @productversion Royale 1.0.0
	 */
	[Event(name="initComplete", type="org.apache.royale.events.Event")]

	/**
	 * The selectionChange event is dispatched whenever the list's selection changes.
	 *
	 *  @langversion 3.0
	 *  @productversion Royale 1.0.0
	 */
	//[Event(name="selectionChange", type="org.apache.royale.events.Event")]
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
	 *  @productversion Royale 1.0.0
	 */
	public class List extends DataContainer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @productversion Royale 1.0.0
		 */
		public function List()
		{
			super();
			register();
			// typeNames += " List";
		}
		private static var _registered:Boolean = false;
		private static function register():void
		{
			if(!_registered){
				var sel:String = "menu, ol, ul";
				StyleManager.addStyle(sel, sel, "list-style: none; margin: 0; padding: 0;");
				_registered = true;
			}
		}

		/**
		 *  The index of the currently selected item. Changing this value
		 *  also changes the selectedItem property.
		 *
		 *  @langversion 3.0
		 *  @productversion Royale 1.0.0
		 *  @royaleignorecoercion org.apache.royale.core.ISelectionModel
		 */
		//[Bindable("selectionChange")]
		[Bindable("change")]
		public function get selectedIndex():int
		{
			return (model as ISelectionModel).selectedIndex;
		}

		/**
		 * @royaleignorecoercion org.apache.royale.core.ISelectionModel
		 */
		public function set selectedIndex(value:int):void
		{
			(model as ISelectionModel).selectedIndex = value;
		}

		/**
		 *  The index of the item currently below the pointer.
		 *
		 *  @langversion 3.0
		 *  @productversion Royale 1.0.0
		 *  @royaleignorecoercion org.apache.royale.core.IRollOverModel
		 */
		public function get rollOverIndex():int
		{
			return (model as IRollOverModel).rollOverIndex;
		}

		/**
		 * @royaleignorecoercion org.apache.royale.core.IRollOverModel
		 */
		public function set rollOverIndex(value:int):void
		{
			(model as IRollOverModel).rollOverIndex = value;
		}

		/**
		 *  The default height of each cell in every column
		 *
		 *  @langversion 3.0
		 *  @productversion Royale 1.0.0
		 *  @royaleignorecoercion org.apache.royale.html.IListPresentationModel
		 */
		public function get rowHeight():Number
		{
			return (presentationModel as IListPresentationModel).rowHeight;
		}

		/**
		 *  @royaleignorecoercion org.apache.royale.html.IListPresentationModel
		 */
		public function set rowHeight(value:Number):void
		{
			(presentationModel as IListPresentationModel).rowHeight = value;
		}

		/**
		 *  The item currently selected. Changing this value also
		 *  changes the selectedIndex property.
		 *
		 *  @langversion 3.0
		 *  @productversion Royale 1.0.0
		 *  @royaleignorecoercion org.apache.royale.core.ISelectionModel
		 */
	//	[Bindable("selectionChange")]
		[Bindable("change")]
		public function get selectedItem():Object
		{
			return (model as ISelectionModel).selectedItem;
		}

		/**
		 * @royaleignorecoercion org.apache.royale.core.ISelectionModel
		 */
		public function set selectedItem(value:Object):void
		{
			(model as ISelectionModel).selectedItem = value;
		}
		override protected function getTag():String
		{
			return "ul";
		}

    public function get focusParent():IStyleUIBase
    {
      return this;
    }

	}
}
