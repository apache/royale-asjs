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
package mx.supportClasses
{
	import org.apache.royale.core.IItemRenderer;
	import org.apache.royale.core.IItemRendererOwnerView;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.SimpleCSSStylesWithFlex;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.html.beads.ITextItemRenderer;
	import org.apache.royale.events.ItemClickedEvent;
	import org.apache.royale.html.util.getLabelFromData;
	import mx.controls.Button;

	COMPILE::JS
	{
		import org.apache.royale.core.WrappedHTMLElement;
	}

	/**
	 * The ButtonItemRenderer class extends Button and turns it into an itemRenderer
	 * suitable for use in most DataContainer/List/DataGrid applications.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
	 */
	public class ButtonItemRenderer extends Button implements ITextItemRenderer
	{
		public function ButtonItemRenderer()
		{
			super();

			addEventListener('click',handleClickEvent);
		}

		/**
		 * @royaleignorecoercion String
		 */
		protected function updateButtonLabelFromData():void
		{
			var valueAsString:String;

			if (data == null) return;
			valueAsString = getLabelFromData(this,data);
			if (!valueAsString && data.hasOwnProperty("title")) {
				valueAsString = "" + data["title"];
			}

			if (valueAsString) text = valueAsString;
		}

		/**
		 * @private
		 */
		public function set text(value:String):void
		{
			label = value;
		}

		/**
		 * @private
		 */
		public function get text():String
		{
			return label;
		}


		/**
		 * @private
		 */
		protected function handleClickEvent(event:MouseEvent):void
		{
			var newEvent:ItemClickedEvent = new ItemClickedEvent("itemClicked");
			newEvent.index = index;
			newEvent.data = data;
			dispatchEvent(newEvent);
		}

		/*
		 * IItemRenderer, ISelectableItemRenderer
		 */

		private var _labelField:String = null;

		/**
		 * The name of the field within the data to use as a label. Some itemRenderers use this field to
		 * identify the value they should show while other itemRenderers ignore this if they are showing
		 * complex information.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
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

		override public function set data(value:Object):void
		{
			super.data = value;
			updateButtonLabelFromData();
		}
	}
}
