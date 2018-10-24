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

package mx.charts.renderers
{

import mx.display.Graphics;
import org.apache.royale.geom.Rectangle;
import mx.charts.ChartItem;
import mx.charts.chartClasses.GraphicsUtilities;
import mx.core.IDataRenderer;
import mx.graphics.IFill;
import mx.graphics.IStroke;
import mx.skins.ProgrammaticSkin;
import mx.graphics.SolidColor;
import org.apache.royale.utils.ColorUtil;

/**
 *  A simple chart itemRenderer implementation
 *  that fills a rectangular area. 
 *  This class is the default itemRenderer for ColumnSeries and BarSeries objects.
 *  It can be used as an itemRenderer for ColumnSeries, BarSeries, AreaSeries,
 *  LineSeries, PlotSeries, and BubbleSeries objects.
 *  This class renders its area on screen using the <code>fill</code> and <code>stroke</code> styles
 *  of its associated series.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class BoxItemRenderer extends ProgrammaticSkin implements IDataRenderer
{
//    include "../../core/Version.as";

	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
	
	/**
	 *  Constructor.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function BoxItemRenderer() 
	{
		super();
	}
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
	//  data
    //----------------------------------

	/**
	 *  @private
	 *  Storage for the data property.
	 */
	private var _data:Object;
	
	[Inspectable(environment="none")]
	
   	/**
	 *  The chartItem that this itemRenderer is displaying.
	 *  This value is assigned by the owning series
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get data():Object
	{
		return _data;
	}

	/**
	 *  @private
	 */
	public function set data(value:Object):void
	{
		if (_data == value)
			return;
		_data = value;
	}
	
	//--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	override protected function updateDisplayList(unscaledWidth:Number,
												  unscaledHeight:Number):void
	{
		super.updateDisplayList(unscaledWidth, unscaledHeight);
				
		var fill:IFill;
		var state:String = "";
		
		if (_data is ChartItem && _data.hasOwnProperty('fill'))
		{
			state = _data.currentState;
			fill = _data.fill;
		}	 	
		else
		 	fill = GraphicsUtilities.fillFromStyle(getStyle('fill'));

		var color:uint;
		var adjustedRadius:Number = 0;
		
		switch (state)
		{
			case ChartItem.FOCUSED:
			case ChartItem.ROLLOVER:
					if (styleManager.isValidStyleValue(getStyle('itemRollOverColor')))
						color = getStyle('itemRollOverColor');
					else
						color = ColorUtil.adjustBrightness2(GraphicsUtilities.colorFromFill(fill),-20);
					fill = new SolidColor(color);		
					adjustedRadius = getStyle('adjustedRadius');
					if (!adjustedRadius)
						adjustedRadius = 0;
					break;
			case ChartItem.DISABLED:
					if (styleManager.isValidStyleValue(getStyle('itemDisabledColor')))
						color = getStyle('itemDisabledColor');
					else
						color = ColorUtil.adjustBrightness2(GraphicsUtilities.colorFromFill(fill),20);
					fill = new SolidColor(GraphicsUtilities.colorFromFill(color));
					break;
			case ChartItem.FOCUSEDSELECTED:
			case ChartItem.SELECTED:
					if (styleManager.isValidStyleValue(getStyle('itemSelectionColor')))
						color = getStyle('itemSelectionColor');
					else
						color = ColorUtil.adjustBrightness2(GraphicsUtilities.colorFromFill(fill),-30);
					fill = new SolidColor(color);				
					adjustedRadius = getStyle('adjustedRadius');
					if (!adjustedRadius)
						adjustedRadius = 0;
					break;
		}
		
		var stroke:IStroke = getStyle("stroke");
				
		var w:Number = stroke ? stroke.weight / 2 : 0;
		
		var rc:Rectangle = new Rectangle(w - adjustedRadius, w - adjustedRadius, width - 2 * w + adjustedRadius * 2, height - 2 * w + adjustedRadius * 2);
		
		var g:Graphics = graphics;
		g.clear();		
		g.moveTo(rc.left,rc.top);
		if (stroke)
			stroke.apply(g,null,null);
		if (fill)
			fill.begin(g,rc,null);
		g.lineTo(rc.right,rc.top);
		g.lineTo(rc.right,rc.bottom);
		g.lineTo(rc.left,rc.bottom);
		g.lineTo(rc.left,rc.top);
		if (fill)
			fill.end(g);
	}
}

}
