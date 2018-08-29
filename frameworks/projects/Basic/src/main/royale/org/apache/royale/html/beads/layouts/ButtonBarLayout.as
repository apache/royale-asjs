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
package org.apache.royale.html.beads.layouts
{
	import org.apache.royale.core.IBeadLayout;
	import org.apache.royale.core.ILayoutChild;
	import org.apache.royale.core.ILayoutView;
	import org.apache.royale.core.IStyleableObject;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.html.beads.models.ButtonBarModel;
	import org.apache.royale.html.supportClasses.UIItemRendererBase;

	/**
	 *  The ButtonBarLayout class bead sizes and positions the button
	 *  elements that make up a org.apache.royale.html.ButtonBar. This bead arranges the Buttons
	 *  horizontally and makes them all the same width unless the buttonWidths property has been set in which case
	 *  the values stored in that array are used.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	public class ButtonBarLayout extends HorizontalFlexLayout implements IBeadLayout
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function ButtonBarLayout()
		{
			super();
		}

		private var _widthType:Number = ButtonBarModel.PIXEL_WIDTHS;
		private var _buttonWidths:Array = null;

		/**
		 *  An array of widths (Number), one per button. These values supersede the
		 *  default of equally-sized buttons.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function get buttonWidths():Array
		{
			return _buttonWidths;
		}
		public function set buttonWidths(value:Array):void
		{
			_buttonWidths = value;
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

			var model:ButtonBarModel = (host as IStrand).getBeadByType(ButtonBarModel) as ButtonBarModel;
			if (model) {
				buttonWidths = model.buttonWidths;
				_widthType = model.widthType;
			}

			var n:int = contentView.numElements;
			if (n <= 0) return false;

			for (var i:int=0; i < n; i++)
			{	
				var ilc:ILayoutChild = contentView.getElementAt(i) as ILayoutChild;
				if (ilc == null || !ilc.visible) continue;
				if (!(ilc is IStyleableObject)) continue;
				
				COMPILE::SWF {
					if (buttonWidths) {
						var widthValue:* = buttonWidths[i];

						if (_widthType == ButtonBarModel.PIXEL_WIDTHS) {
							if (widthValue != null) ilc.width = Number(widthValue);
							IStyleableObject(ilc).style.flexGrow = 0;
						}
						else if (_widthType == ButtonBarModel.PROPORTIONAL_WIDTHS) {
							if (widthValue != null) {
								IStyleableObject(ilc).style.flexGrow = Number(widthValue);
							}
						}
						else if (_widthType == ButtonBarModel.PERCENT_WIDTHS) {
							if (widthValue != null) ilc.percentWidth = Number(widthValue);
							IStyleableObject(ilc).style.flexGrow = 0;
						}
					} else if (!_widthType == ButtonBarModel.NATURAL_WIDTHS) {
						IStyleableObject(ilc).style.flexGrow = 1;
					}
				}

				COMPILE::JS {
					// otherwise let the flexbox layout handle matters on its own.
					if (buttonWidths) {
						var widthValue:* = buttonWidths[i];

						if (_widthType == ButtonBarModel.PIXEL_WIDTHS) {
							if (widthValue != null) ilc.width = Number(widthValue);
						}
						else if (_widthType == ButtonBarModel.PROPORTIONAL_WIDTHS) {
							if (widthValue != null) ilc.element.style["flex-grow"] = String(widthValue);
						}
						else if (_widthType == ButtonBarModel.PERCENT_WIDTHS) {
							if (widthValue != null) ilc.percentWidth = Number(widthValue);
						}
					} else if (!_widthType == ButtonBarModel.NATURAL_WIDTHS) {
						ilc.element.style["flex-grow"] = "1";
					}

                    if (!host.isHeightSizedToContent())
    					ilc.height = contentView.height;
				}
			}

			// now let the horizontal layout take care of things.
			return super.layout();
		}
	}
}
