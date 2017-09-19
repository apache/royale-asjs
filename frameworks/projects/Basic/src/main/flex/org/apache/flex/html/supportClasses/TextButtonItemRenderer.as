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
package org.apache.flex.html.supportClasses
{
	import org.apache.flex.core.IItemRenderer;
	import org.apache.flex.core.IItemRendererParent;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.SimpleCSSStylesWithFlex;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.MouseEvent;
	import org.apache.flex.html.TextButton;
	import org.apache.flex.html.beads.ITextItemRenderer;
	import org.apache.flex.events.ItemClickedEvent;

	COMPILE::JS
	{
		import org.apache.flex.core.WrappedHTMLElement;
	}

	/**
	 * The TextButtonItemRenderer class extends TextButton and turns it into an itemRenderer
	 * suitable for use in most DataContainer/List/DataGrid applications.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
	 */
	public class TextButtonItemRenderer extends TextButton implements ITextItemRenderer
	{
		public function TextButtonItemRenderer()
		{
			super();

			style = new SimpleCSSStylesWithFlex();

			addEventListener('click',handleClickEvent);
		}

		private var _data:Object;

		/**
		 *  The data to be displayed as the text value. Use this in conjunction with
		 *  the labelField property to select an item from the dataProvider record to use
		 *  as the text value of the button.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function get data():Object
		{
			return _data;
		}
		public function set data(value:Object):void
		{
			_data = value;

			updateButtonLabelFromData();
		}

		private function updateButtonLabelFromData():void
		{
			var valueAsString:String;

			if (data == null) return;

			if (data is String) {
				valueAsString = data as String;
			}
			else if (labelField != null) {
				valueAsString = String(data[labelField]);
			}
			else if (data.hasOwnProperty("label")) {
				valueAsString = String(data["label"]);
			}
			else if (data.hasOwnProperty("title")) {
				valueAsString = String(data["title"]);
			}

			if (valueAsString) text = valueAsString;
		}

		/**
		 * @private
		 */
		protected function handleClickEvent(event:MouseEvent):void
		{
			var newEvent:ItemClickedEvent = new ItemClickedEvent("itemClicked");
			newEvent.multipleSelection = event.shiftKey;
			newEvent.index = index;
			newEvent.data = data;
			dispatchEvent(newEvent);
		}

		/*
		 * IItemRenderer, ISelectableItemRenderer
		 */

		private var _itemRendererParent:Object;

		/**
		 * The parent container for the itemRenderer instance.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function get itemRendererParent():Object
		{
			return _itemRendererParent;
		}
		public function set itemRendererParent(value:Object):void
		{
			_itemRendererParent = value;
		}

		private var _labelField:String = null;

		/**
		 * The name of the field within the data to use as a label. Some itemRenderers use this field to
		 * identify the value they should show while other itemRenderers ignore this if they are showing
		 * complex information.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function get labelField():String
		{
			return _labelField;
		}
		public function set labelField(value:String):void
		{
			_labelField = value;
			updateButtonLabelFromData();
		}

		private var _listData:Object;

		[Bindable("__NoChangeEvent__")]
		/**
		 *  Additional data about the list structure the itemRenderer may
		 *  find useful.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function get listData():Object
		{
			return _listData;
		}
		public function set listData(value:Object):void
		{
			_listData = value;
		}

		private var _index:int;

		/**
		 *  The position with the dataProvider being shown by the itemRenderer instance.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function get index():int
		{
			return _index;
		}
		public function set index(value:int):void
		{
			_index = value;
		}

		private var _hovered:Boolean;

		/**
		 *  Whether or not the itemRenderer is in a hovered state.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function get hovered():Boolean
		{
			return _hovered;
		}
		public function set hovered(value:Boolean):void
		{
			_hovered = value;
		}

		private var _selected:Boolean;

		/**
		 *  Whether or not the itemRenderer is in a selected state.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function get selected():Boolean
		{
			return _selected;
		}
		public function set selected(value:Boolean):void
		{
			_selected = value;
		}

		private var _down:Boolean;

		/**
		 *  Whether or not the itemRenderer is in a down (or pre-selected) state.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function get down():Boolean
		{
			return _down;
		}
		public function set down(value:Boolean):void
		{
			_down = value;
		}
	}
}
