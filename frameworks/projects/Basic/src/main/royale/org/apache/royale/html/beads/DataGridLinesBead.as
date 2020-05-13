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
	import org.apache.royale.collections.ArrayList;
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IBeadModel;
	import org.apache.royale.core.IDataGridModel;
	import org.apache.royale.core.ILayoutHost;
	import org.apache.royale.core.IParentIUIBase;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.svg.CompoundGraphic;
	import org.apache.royale.graphics.IStroke;
	import org.apache.royale.graphics.SolidColor;
	import org.apache.royale.graphics.SolidColorStroke;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.html.beads.DataGridView;
	import org.apache.royale.html.beads.models.DataGridPresentationModel;
	import org.apache.royale.html.supportClasses.DataGridColumn;
	
	/**
	 * The DataGridLinesBead is an add on bead for the DataGrid. This bead
	 * adds horizontal and vertical grid lines to a DataGrid. The size and
	 * color of the lines is specified by the stroke property (defaults to
	 * a thin dark line). 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class DataGridLinesBead implements IBead
	{
		/**
		 * Constructor. 
	     *  
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion Royale 0.0
		 */
		public function DataGridLinesBead()
		{
			// Set default separator line stroke.
			var lineStroke:SolidColorStroke = new SolidColorStroke();
			lineStroke.color = 0x333333;
			lineStroke.alpha = 1.0;
			lineStroke.weight = 1;
			stroke = lineStroke;
		}
		
		protected var _strand:IStrand;
		
        private var _view:DataGridView;
        
		/**
		 * @copy org.apache.royale.core.UIBase#strand
	     *  
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion Royale 0.0
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
            var host:UIBase = _strand as UIBase;
            _view = host.view as DataGridView; // need to get its initComplete handler to run first

			_overlay = new CompoundGraphic();
			
			IEventDispatcher(_strand).addEventListener("initComplete", handleInitComplete);
		}
		
		private var _stroke:IStroke;
		
		/**
		 * Describes the line style used to separate the rows and columns.
	     *  
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion Royale 0.0
		 */
		public function get stroke():IStroke
		{
			return _stroke;
		}
		public function set stroke(value:IStroke):void
		{
			_stroke = value;
		}
		
		protected var _overlay:CompoundGraphic;
		protected var _area:UIBase;
		
		/**
		 * Invoked when all of the beads have been added to the DataGrid. This
		 * function seeks the Container that parents the lists that are the DataGrid's
		 * columns. An overlay GraphicContainer is added to this Container so that the
		 * grid lines will scroll with the rows.
	     *  
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion Royale 0.0
		 */
		protected function handleInitComplete(event:Event):void
		{
			var host:UIBase = _strand as UIBase;
            _area = _view.listArea as UIBase;
			_area.addElement(_overlay);
            COMPILE::JS
            {
                _overlay.element.style.pointerEvents = "none";        
            }

			// Now set up listeners to handle changes in the size of the DataGrid.
			IEventDispatcher(_strand).addEventListener("sizeChanged", drawLines);
			IEventDispatcher(_strand).addEventListener("widthChanged", drawLines);
			IEventDispatcher(_strand).addEventListener("heightChanged", drawLines);
			
			// Also set up a listener on the model to know when the dataProvider has
			// changed which might affect the number of rows/columns and thus the
			// grid lines.
			var model:IBeadModel = _strand.getBeadByType(IBeadModel) as IBeadModel;
			IEventDispatcher(model).addEventListener("dataProviderChanged", drawLines);
		}
		
        protected function getDataProviderLength():int
        {
            var sharedModel:IDataGridModel = _strand.getBeadByType(IBeadModel) as IDataGridModel;
            var arrayList:ArrayList = sharedModel.dataProvider as ArrayList;
            return arrayList.length;            
        }
        
		/**
		 * This event handler is invoked whenever something happens to the DataGrid. This
		 * function draws the lines either using a default stroke or the one specified by
		 * the stroke property.
	     *  
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion Royale 0.0
		 */
		protected function drawLines(event:Event):void
		{
			var sharedModel:IDataGridModel = _strand.getBeadByType(IBeadModel) as IDataGridModel;
			var presentationModel:DataGridPresentationModel = _strand.getBeadByType(DataGridPresentationModel) as DataGridPresentationModel;
			var layoutParent:ILayoutHost = _area.getBeadByType(ILayoutHost) as ILayoutHost;
			var contentView:IParentIUIBase = layoutParent.contentView as IParentIUIBase;
			
			var columns:Array = sharedModel.columns;			
			var rowHeight:Number = presentationModel.rowHeight;
            var n:int = getDataProviderLength();
			var totalHeight:Number = n * rowHeight;
			var columnWidth:Number = _area.width / columns.length;
			
			// translate the stroke to a fill since rectangles are used for the grid
			// lines and not lines.
			var lineFill:SolidColor = new SolidColor();
			var weight:Number = 1;
			lineFill.color = (stroke as SolidColorStroke).color;
			lineFill.alpha = (stroke as SolidColorStroke).alpha;
			weight = (stroke as SolidColorStroke).weight;
			_overlay.fill = lineFill;
			
			columnWidth = (columns[0] as DataGridColumn).columnWidth;
			var xpos:Number = isNaN(columnWidth) ? _area.width / columns.length : columnWidth;
			
			_overlay.clear();
			
			// draw the verticals
			for (var i:int=1; i < columns.length; i++) {
				_overlay.drawRect(xpos, 0, weight, totalHeight);
				columnWidth = (columns[i] as DataGridColumn).columnWidth;
				xpos += isNaN(columnWidth) ? _area.width / columns.length : columnWidth;
			}
			
			// draw the horizontals
			for (i=1; i < n+1; i++) {
				_overlay.drawRect(0, i*rowHeight, _area.width, weight);
			}
		}
	}
}
