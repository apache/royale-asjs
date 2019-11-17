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
    
    import org.apache.royale.core.IBeadModel;
    import org.apache.royale.core.IDataGridModel;
    import org.apache.royale.core.ILayoutHost;
    import org.apache.royale.core.IParentIUIBase;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.graphics.SolidColor;
    import org.apache.royale.graphics.SolidColorStroke;
    import org.apache.royale.html.beads.DataGridLinesBead;
    import org.apache.royale.html.beads.models.DataGridPresentationModel;
    import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
    
	public class DataGridLinesBeadForICollectionView extends DataGridLinesBead
	{
		public function DataGridLinesBeadForICollectionView()
		{
			super();
		}
        
        override protected function handleInitComplete(event:Event):void
        {
            super.handleInitComplete(event);
            // column resizing
            IEventDispatcher(_strand).addEventListener("layoutNeeded", drawLines);
        }

		
        override protected function getDataProviderLength():int
        {
            var sharedModel:IDataGridModel = _strand.getBeadByType(IBeadModel) as IDataGridModel;
            var arrayList:ICollectionView = sharedModel.dataProvider as ICollectionView;
            return arrayList ? arrayList.length : 0;            
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
        override protected function drawLines(event:Event):void
        {
            var sharedModel:IDataGridModel = _strand.getBeadByType(IBeadModel) as IDataGridModel;
            var presentationModel:DataGridPresentationModel = _strand.getBeadByType(DataGridPresentationModel) as DataGridPresentationModel;
            var layoutParent:ILayoutHost = _area.getBeadByType(ILayoutHost) as ILayoutHost;
            var contentView:IParentIUIBase = layoutParent.contentView as IParentIUIBase;
            
            var columns:Array = sharedModel.columns;			
            var rowHeight:Number = presentationModel.rowHeight;
            var n:int = getDataProviderLength();
            var totalHeight:Number = n * rowHeight;
            
            // translate the stroke to a fill since rectangles are used for the grid
            // lines and not lines.
            var lineFill:SolidColor = new SolidColor();
            var weight:Number = 1;
            lineFill.color = (stroke as SolidColorStroke).color;
            lineFill.alpha = (stroke as SolidColorStroke).alpha;
            weight = (stroke as SolidColorStroke).weight;
            _overlay.fill = lineFill;
            COMPILE::JS
            {
                _overlay.element.style.position = "absolute";        
            }
            
            var xpos:Number = 0;
            
            _overlay.clear();
            
            // draw the verticals
            for (var i:int=0; i < columns.length - 1; i++) {
                var column:AdvancedDataGridColumn = columns[i] as AdvancedDataGridColumn;
                if (column.visible)
                {
                    xpos += column.columnWidth;
                    _overlay.drawRect(xpos - 1, 0, weight, totalHeight);
                }
            }
            
            /*
            // draw the horizontals
            for (i=1; i < n+1; i++) {
                _overlay.drawRect(0, i*rowHeight, _area.width, weight);
            }
            */
        }

	}
}