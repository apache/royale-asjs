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
	COMPILE::SWF
	{
		import flash.display.Sprite;
	}
	COMPILE::JS
	{
		import org.apache.flex.core.WrappedHTMLElement;
		import org.apache.flex.html.beads.controllers.ItemRendererMouseController;
	}
	import org.apache.flex.core.ValuesManager;

	/**
	 *  The DataItemRenderer class is the base class for most itemRenderers. This class
	 *  extends org.apache.flex.html.supportClasses.UIItemRendererBase and
	 *  includes row and column index values.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class DataItemRenderer extends UIItemRendererBase
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function DataItemRenderer()
		{
			super();
		}

		private var _columnIndex:int;

		/**
		 *  The index of the column the itemRenderer represents.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get columnIndex():int
		{
			return _columnIndex;
		}
		public function set columnIndex(value:int):void
		{
			_columnIndex = value;
		}

		private var _rowIndex:int;

		/**
		 *  The index of the row the itemRenderer represents.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get rowIndex():int
		{
			return _rowIndex;
		}
		public function set rowIndex(value:int):void
		{
			_rowIndex = value;
		}

		private var _dataField:String;

		/**
		 *  The name of the field within the data the itemRenderer should use.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get dataField():String
		{
			return _dataField;
		}
		public function set dataField(value:String):void
		{
			_dataField = value;
		}

		COMPILE::SWF
		private var background:Sprite;

		COMPILE::JS
		private var controller:ItemRendererMouseController;

		/**
		 * @private
		 */
		COMPILE::SWF
		override public function addedToParent():void
		{
			super.addedToParent();

			background = new Sprite();
			$sprite.addChild(background);
		}

		/**
		 * @private
		 */
		override public function updateRenderer():void
		{
			COMPILE::SWF
			{
				super.updateRenderer();

				background.graphics.clear();
				background.graphics.beginFill(useColor, (down||selected||hovered)?1:0);
				background.graphics.drawRect(0, 0, width, height);
				background.graphics.endFill();
			}
			COMPILE::JS
			{
				if (selected)
					element.style.backgroundColor = '#9C9C9C';
				else if (hovered)
					element.style.backgroundColor = '#ECECEC';
				else
					element.style.backgroundColor = null;
			}
		}

		/**
		 * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
		 *
		 */
		COMPILE::JS
		override protected function createElement():WrappedHTMLElement
		{
			element = document.createElement('div') as WrappedHTMLElement;
			positioner = element;
			

			element.flexjs_wrapper = this;
			className = 'DataItemRenderer';

			controller = new ItemRendererMouseController();
			controller.strand = this;

			return element;
		}


	}
}
