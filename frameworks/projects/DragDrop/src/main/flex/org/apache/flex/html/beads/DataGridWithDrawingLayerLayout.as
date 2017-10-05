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
package org.apache.flex.html.beads
{
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.html.beads.IDataGridView;
	import org.apache.flex.html.beads.layouts.VerticalFlexLayout;

	COMPILE::SWF {
		import org.apache.flex.html.supportClasses.ScrollingViewport;
		import org.apache.flex.html.supportClasses.ScrollBar;
	}

	/**
	 * DataGridWithDrawingLayerLayout is a class that extends VerticalFlexLayout
	 * and positions the drawing layer created by a DataGridDrawingLayerBead.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class DataGridWithDrawingLayerLayout extends VerticalFlexLayout
	{
		/**
		 *  constructor
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function DataGridWithDrawingLayerLayout()
		{
			super();
		}

		private var _strand:IStrand;

		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			_strand = value;
		}

		/**
		 * @private
		 */
		override public function layout():Boolean
		{
			// If there is a drawing layer, remove it so the super.layout function
			// will not include it.
			var layerBead:IDrawingLayerBead = _strand.getBeadByType(IDrawingLayerBead) as IDrawingLayerBead;
			if (layerBead != null && layerBead.layer != null) {
				UIBase(_strand).removeElement(layerBead.layer);
			}

			// Run the actual layout
			var result:Boolean = super.layout();

			// Put the drawing layer back, sizing it to fit over the listArea.
			if (layerBead != null && layerBead.layer != null) {
				UIBase(_strand).addElement(layerBead.layer);

				var layerX:Number = 0;
				var layerY:Number = 0;
				var useWidth:Number = UIBase(_strand).width;
				var useHeight:Number = UIBase(_strand).height;

				var view:IDataGridView = UIBase(_strand).view as IDataGridView;
				var listArea:UIBase = view.listArea;

				COMPILE::SWF {
					var scrollViewport:ScrollingViewport = listArea.getBeadByType(ScrollingViewport) as ScrollingViewport;
					if (scrollViewport) {
						var vbar:ScrollBar = scrollViewport.verticalScroller as ScrollBar;
						if (vbar != null && vbar.visible) useWidth -= vbar.width;
						var hbar:ScrollBar = scrollViewport.horizontalScroller as ScrollBar;
						if (hbar != null && hbar.visible) useHeight -= hbar.height;
					}
				}

				layerBead.layer.x = layerX;
				layerBead.layer.y = layerY;
				layerBead.layer.setWidthAndHeight(useWidth, useHeight, true);

			}
			return result;
		}
	}
}
