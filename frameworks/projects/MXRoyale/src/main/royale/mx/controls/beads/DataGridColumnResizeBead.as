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
package mx.controls.beads
{
    import mx.collections.ICollectionView;
    import mx.controls.AdvancedDataGrid;

    import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
    import mx.controls.dataGridClasses.DataGridColumn;
    import mx.controls.listClasses.ListBase;
    import mx.core.ScrollPolicy;
    import mx.events.AdvancedDataGridEvent;
    
    import org.apache.royale.core.IBead;
    import org.apache.royale.core.IBeadModel;
    import org.apache.royale.core.IDataGridModel;
    import org.apache.royale.core.ILayoutHost;
    import org.apache.royale.core.IParentIUIBase;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.UIBase;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.events.MouseEvent;
    import org.apache.royale.graphics.IStroke;
    import org.apache.royale.graphics.SolidColor;
    import org.apache.royale.graphics.SolidColorStroke;
    import org.apache.royale.html.DataGridButtonBar;
    import org.apache.royale.html.beads.DataGridLinesBead;
    import org.apache.royale.html.beads.DataGridView;
    import org.apache.royale.html.beads.models.DataGridPresentationModel;
    import org.apache.royale.svg.CompoundGraphic;
    

    
	public class DataGridColumnResizeBead implements IBead
	{
		public function DataGridColumnResizeBead()
		{
			super();
            // Set default separator line stroke.
            var lineStroke:SolidColorStroke = new SolidColorStroke();
            lineStroke.color = 0xFF0000; //0x333333;
            lineStroke.alpha = 1.0;
            lineStroke.weight = 3;
            stroke = lineStroke;
		}

        protected var _strand:IStrand;
        
        private var _view:org.apache.royale.html.beads.DataGridView;
        
        private var gridBase:ListBase;
        
        /**                         	
         *  @copy org.apache.royale.core.IBead#strand
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
            _view = host.view as org.apache.royale.html.beads.DataGridView; // need to get its initComplete handler to run first
            
            _overlay = new CompoundGraphic();
            
            IEventDispatcher(_strand).addEventListener("initComplete", handleInitComplete);

            gridBase = value as ListBase;
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
        protected var _header:UIBase;
        protected var _dragGraphic:CompoundGraphic;
        
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
        private function handleInitComplete(event:Event):void
        {
            var host:UIBase = _strand as UIBase;
            _header = _view.header as UIBase;
            _header.addElement(_overlay);
            _overlay.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler, false);
            
            // Now set up listeners to handle changes in the size of the DataGrid.
            IEventDispatcher(_strand).addEventListener("sizeChanged", drawLines);
            IEventDispatcher(_strand).addEventListener("widthChanged", drawLines);
            IEventDispatcher(_strand).addEventListener("heightChanged", drawLines);
            
            // Also set up a listener on the model to know when the dataProvider has
            // changed which might affect the number of rows/columns and thus the
            // grid lines.
            var model:IBeadModel = _strand.getBeadByType(IBeadModel) as IBeadModel;
            IEventDispatcher(model).addEventListener("dataProviderChanged", drawLines);
            
            // if the headerText gets changed, the overlay is removed, so re-apply it
            IEventDispatcher(_header.model).addEventListener("dataProviderChanged", onHeaderDataProviderChange);
        }


        protected function onHeaderDataProviderChange(event:Event):void{
            if (!_overlay.parent) _header.addElement(_overlay);
            drawLines(event);
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
         * 
         *  @royaleignorecoercion Array
         *  @royaleignorecoercion SVGElement
         */
        protected function drawLines(event:Event):void
        {
            var sharedModel:IDataGridModel = _strand.getBeadByType(IBeadModel) as IDataGridModel;
            var columns:Array = sharedModel.columns;			
            var totalHeight:Number = _header.height;
            
            // translate the stroke to a fill since rectangles are used for the grid
            // lines and not lines.
            var lineFill:SolidColor = new SolidColor();
            var weight:Number = 1;
            lineFill.color = (stroke as SolidColorStroke).color;
            lineFill.alpha = 0; //(stroke as SolidColorStroke).alpha;  // invisible overlay over each column boundary
            weight = (stroke as SolidColorStroke).weight;
            _overlay.fill = lineFill;
            COMPILE::JS
            {
                _overlay.element.style.position = "absolute";        
                _overlay.element.style.pointerEvents = "none";
                // turn off drag select of header text
                _header.element.style["user-select"] = "none";
                _header.element.style["-webkit-touch-callout"] = "none";
                _header.element.style["-webkit-user-select"] = "none";
                _header.element.style["-moz-user-select"] = "none";
                _header.element.style["-ms-user-select"] = "none";
            }
            
            var xpos:Number = 0;
            
            _overlay.clear();
            
            var firstOne:Boolean = true;
            // draw the verticals
	    if(columns == null){
	       return;
	    }
            for (var i:int=0; i < columns.length; i++) {
                //var column:AdvancedDataGridColumn = columns[i] as AdvancedDataGridColumn;
                var column:DataGridColumn = columns[i] as DataGridColumn;
                if (column.visible)
                {
                    // if a column is visible, don't draw a resize target unless
                    // there is a column to its right that is visible
                    if (firstOne)
                        firstOne = false;
                    else
                        _overlay.drawRect(xpos - (weight / 2), 0, weight, totalHeight);
                    xpos += column.columnWidth;
                }
            }
            COMPILE::JS
            {
                var rects:Array = _overlay.element.childNodes as Array; 
                var n:int = rects.length;
                for (i = 0; i < n; i++)
                {
                    var e:SVGElement = rects[i] as SVGElement;
                    e.style.pointerEvents = "auto";
                }
            }
            
            /*
            // draw the horizontals
            for (i=1; i < n+1; i++) {
                _overlay.drawRect(0, i*rowHeight, _area.width, weight);
            }
            */
        }
        
        private var columnIndex:int;
        
        /**
         * @private
         */
        private function mouseOverHandler(event:MouseEvent):void
        {
            var sharedModel:IDataGridModel = _strand.getBeadByType(IBeadModel) as IDataGridModel;
            var columns:Array = sharedModel.columns;			
            var totalHeight:Number = _header.height;
            
            _overlay.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler, false);
            _overlay.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false);
            
            // translate the stroke to a fill since rectangles are used for the grid
            // lines and not lines.
            var lineFill:SolidColor = new SolidColor();
            var weight:Number = 1;
            lineFill.color = (stroke as SolidColorStroke).color;
            lineFill.alpha = (stroke as SolidColorStroke).alpha;
            weight = (stroke as SolidColorStroke).weight;
            
            var xpos:Number = 0;

            columnIndex = -1;
            for (var i:int=0; i < columns.length - 1; i++) {
                //var column:AdvancedDataGridColumn = columns[i] as AdvancedDataGridColumn;
                var column:DataGridColumn = columns[i] as DataGridColumn;
                if (column.visible)
                {
                    xpos += column.columnWidth;
                }
                else
                    continue;
                var left:Number = xpos - (weight / 2);
                var right:Number = left + weight;
                if (left < event.localX && event.localX < right)
                {
                    columnIndex = i;
                    break;
                }
            }
            if (columnIndex == -1)
                return;
            
            _dragGraphic = new CompoundGraphic();
            _header.addElement(_dragGraphic);
            _dragGraphic.fill = lineFill;
            COMPILE::JS
            {
                _dragGraphic.element.style.position = "absolute";
                _dragGraphic.element.style.pointerEvents = "none";
            }
            _dragGraphic.clear();
            _dragGraphic.drawRect(weight / 2, 0, weight, totalHeight);
            _dragGraphic.drawRect(0, (totalHeight / 2) - (weight / 2),
                weight * 2, weight);
            
            _dragGraphic.x = xpos - weight;
        }

        /**
         * @private
         */
        private function mouseOutHandler(event:MouseEvent):void
        {
            if (_dragGraphic)
            {
                _header.removeElement(_dragGraphic);
                _dragGraphic = null;
            }
            _overlay.removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler, false);
            _overlay.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false);
        }

        private var lastX:Number = -1;
        private var startX:Number;
        
        /**
         * @private
         */
        private function mouseDownHandler(event:MouseEvent):void
        {
            _overlay.removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler, false);
            _header.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false);
            _header.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, false);
            var localX:Number = event.localX;
            COMPILE::JS{
                //adjust for the left scroll position of the underlying header
                localX -= this._header.element.scrollLeft;
            }
            startX = lastX = localX;
        }

        /**
         * @private
         */
        private function mouseMoveHandler(event:MouseEvent):void
        {
            if (!_dragGraphic) return;
            var deltaX:Number = event.localX - lastX;
            lastX = event.localX;
            _dragGraphic.x += deltaX;            
        }
        
        /**
         * @private
         */
        private function mouseUpHandler(event:MouseEvent):void
        {
            if (_dragGraphic)
            {
                _header.removeElement(_dragGraphic);
                _dragGraphic = null;
            }
            _header.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false);
            _header.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, false);

            if (columnIndex == -1)
                return;
            
            var sharedModel:IDataGridModel = _strand.getBeadByType(IBeadModel) as IDataGridModel;
            var columns:Array = sharedModel.columns;
            var oldWidth:Number = columns[columnIndex].columnWidth;
            var deltaWidth:Number = lastX - startX;
            // set column.width to column.columnWidth.  The DG may scale
            // columns to fit.
            for (var i:int = 0; i < columns.length; i++)
            {
                columns[i].width = columns[i].columnWidth;
            }
            if (columns[columnIndex].width + deltaWidth < columns[columnIndex].minWidth)
            {
                deltaWidth = columns[columnIndex].minWidth - columns[columnIndex].width;
            }
            columns[columnIndex].width += deltaWidth;
            columns[columnIndex].columnWidth += deltaWidth;
            if (gridBase.horizontalScrollPolicy == ScrollPolicy.OFF)
            {
                columns[columnIndex + 1].columnWidth -= deltaWidth;
                columns[columnIndex + 1].width -= deltaWidth;
            }
            gridBase.dispatchEvent(new Event("layoutNeeded"));
            drawLines(null);
        }
        
	}
}
