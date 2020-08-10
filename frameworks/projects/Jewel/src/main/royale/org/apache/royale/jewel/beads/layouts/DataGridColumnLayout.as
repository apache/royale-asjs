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
package org.apache.royale.jewel.beads.layouts
{
	import org.apache.royale.core.IBeadLayout;
	import org.apache.royale.core.ILayoutChild;
	import org.apache.royale.core.ILayoutView;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.IStyleableObject;
	import org.apache.royale.events.Event;
	import org.apache.royale.html.beads.models.ButtonBarModel;
	import org.apache.royale.html.beads.IDataGridView;
	import org.apache.royale.jewel.supportClasses.datagrid.DataGridColumnWidth;
	import org.apache.royale.jewel.supportClasses.datagrid.IDataGridColumn;

	/**
	 *  The Jewel ButtonBarLayout class bead sizes and positions the button
	 *  elements that make up a org.apache.royale.jewel.ButtonBar.
	 *  
	 *  This bead arranges the Buttons horizontally and makes them all the same width 
	 *  (widthType = NaN) unless the buttonWidths property has been set in which case
	 *  the values stored in that array are used.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.7
	 *
	 *  @royalesuppressexport
	 */
	public class DataGridColumnLayout extends HorizontalLayout  implements IBeadLayout
	{



		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function DataGridColumnLayout()
		{
			super();
		}

		/**
		 * @royalesuppresspublicvarwarning
		 */
		public static const LAYOUT_TYPE_NAMES:String = "layout horizontal";

		private var model:ButtonBarModel;
		/**
		 *  Add class selectors when the component is addedToParent
		 *  Otherwise component will not get the class selectors when 
		 *  perform "removeElement" and then "addElement"
		 * 
 		 *  @langversion 3.0
 		 *  @playerversion Flash 10.2
 		 *  @playerversion AIR 2.6
 		 *  @productversion Royale 0.9.7
 		 */
		override public function beadsAddedHandler(event:Event = null):void
		{
			super.beadsAddedHandler();

			model = (host as IStrand).getBeadByType(ButtonBarModel) as ButtonBarModel;
			hostComponent.addEventListener("headerLayout", onHeaderLayoutCheck);
			hostComponent.addEventListener("headerLayoutReset", onHeaderLayoutCheck);
		}

		/**
		 * @royaleignorecoercion org.apache.royale.core.UIBase
		 */
		protected function get datagrid():UIBase
		{
			return (_strand as UIBase).parent as UIBase;
		}

		COMPILE::JS
		private var _vScrollerHOffset:Number = 0;

		COMPILE::JS
		private var _vScrollChange:Boolean;


		/**
		 *
		 * @royaleignorecoercion org.apache.royale.html.beads.IDataGridView
		 */
		private function onHeaderLayoutCheck(event:Event):void{
			var view:IDataGridView = datagrid.view as IDataGridView;
			var listArea:IUIBase = view.listArea;
			COMPILE::JS {
				var LA_Element:HTMLElement = listArea.element;
				var latestHOffset:Number = LA_Element.offsetWidth - LA_Element.clientWidth;
				var reset:Boolean = event.type == 'headerLayoutReset';
				if (latestHOffset != _vScrollerHOffset || reset) {
					_vScrollerHOffset = latestHOffset;
					_vScrollChange = true;
					if (!reset) layout();
				}
			}

		}


		private var _defaultWidth:DataGridColumnWidth;

		public function get defaultWidth():DataGridColumnWidth{
			return _defaultWidth;
		}

		public function set defaultWidth(value:DataGridColumnWidth):void{
			_defaultWidth = value;
		}


		/**
		 * @copy org.apache.royale.core.IBeadLayout#layout
		 * @royaleignorecoercion org.apache.royale.core.ILayoutChild
		 * @royaleignorecoercion org.apache.royale.core.IStrand
		 * @royaleignorecoercion org.apache.royale.html.beads.models.ButtonBarModel
		 */
		override public function layout():Boolean
		{
			var contentView:ILayoutView = layoutView;
			var n:int = contentView.numElements;
			if (n <= 0) return false;
			var last:ILayoutChild;
			var lastWidthConfig:DataGridColumnWidth;
			for (var i:int=0; i < n; i++)
			{	
				var ilc:ILayoutChild = contentView.getElementAt(i) as ILayoutChild;
				if (ilc == null || !ilc.visible) continue;
				if (!(ilc is IStyleableObject)) continue;
				last = ilc;
				COMPILE::JS
				{
					// otherwise let the flexbox layout handle matters on its own.
					if (model.buttonWidths) {
						lastWidthConfig = model.buttonWidths[i];
						lastWidthConfig.configureWidth(ilc);
					} else {
						if (_defaultWidth) {
							_defaultWidth.configureWidth(ilc);
							lastWidthConfig = _defaultWidth;
						}
					}
				}
			}
			COMPILE::JS{
				if (last && (_vScrollChange || _vScrollerHOffset)) {
					lastWidthConfig.applyRightOffset(last, _vScrollerHOffset);
					_vScrollChange = false;
				}
			}

			// now let the horizontal layout take care of things.
			return super.layout();
		}
	}
}
