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
package org.apache.royale.html.beads
{
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.html.beads.IDataGridView;
	import org.apache.royale.html.beads.layouts.DataGridLayout;

	COMPILE::SWF {
		import org.apache.royale.html.supportClasses.ScrollingViewport;
		import org.apache.royale.html.supportClasses.ScrollBar;
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
	public class DataGridWithDrawingLayerLayout extends DataGridLayout
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
		 *  @copy org.apache.royale.core.IBead#strand
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
		 *  @royaleignorecoercion org.apache.royale.core.UIBase
		 *  @royaleignorecoercion org.apache.royale.html.beads.IDataGridView
		 *  @royaleignorecoercion org.apache.royale.html.beads.IDrawingLayerBead
		 */
		override public function layout():Boolean
		{
			// Get the drawing layer, if there is one, so it can be positioned at the
			// top of the z-order and sized properly.
			var layerBead:IDrawingLayerBead = _strand.getBeadByType(IDrawingLayerBead) as IDrawingLayerBead;

			// Run the actual layout
			var result:Boolean = super.layout();
			// Put the drawing layer back, sizing it to fit over the listArea.
			if (result && layerBead != null && layerBead.layer != null) {
			var host:UIBase = _strand as UIBase;
				
				var view:IDataGridView = host.view as IDataGridView;
				var listArea:UIBase = view.listArea as UIBase;
				
				host.removeElement(layerBead.layer);
				host.addElement(layerBead.layer); // always keep it on top

				var layerX:Number = listArea.x;
				var layerY:Number = listArea.y;
				var useWidth:Number = listArea.width;
				var useHeight:Number = listArea.height;

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
