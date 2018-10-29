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
import mx.charts.series.items.HLOCSeriesItem;
import mx.core.IDataRenderer;
import mx.graphics.IFill;
import mx.graphics.IStroke;
import mx.graphics.SolidColor;
import mx.skins.ProgrammaticSkin;
import org.apache.royale.utils.ColorUtil;


/**
 *  The default itemRenderer
 *  for a CandlestickSeries object.
 *  This class renders a standard CandlestickChart item by using the <code>stroke</code>,
 *  <code>boxStroke</code>, <code>fill</code>, and <code>declineFill</code> styles of its associated series.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class CandlestickItemRenderer extends ProgrammaticSkin
									 implements IDataRenderer
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
	public function CandlestickItemRenderer() 
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
	private var _data:HLOCSeriesItem;

	[Inspectable(environment="none")]

	/**
	 *  The chart item that this renderer represents.
	 *  CandlestickItemRenderers assume that this value
	 *  is an instance of HLOCSeriesItem.
	 *  This value is assigned by the owning series.
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
		_data = value as HLOCSeriesItem;
			
		invalidateDisplayList();
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
		
		var stroke:IStroke = getStyle("stroke");
		var boxStroke:IStroke = getStyle("boxStroke");
		
		var fill:IFill;
		var w:Number = boxStroke ? boxStroke.weight / 2 : 0;
		var rc:Rectangle;
		var g:Graphics = graphics;
		var state:String;
		
		if (_data)
		{
			fill = data.fill;
			state = data.currentState;	
			
			var color:uint;
			
			switch (state)
			{
				case ChartItem.FOCUSED:
				case ChartItem.ROLLOVER:
					if (styleManager.isValidStyleValue(getStyle('itemRollOverColor')))
						color = getStyle('itemRollOverColor');
					else
						color = ColorUtil.adjustBrightness2(GraphicsUtilities.colorFromFill(fill),-20);
					fill = new SolidColor(color);
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
					break;
			}

			var min:Number;
			var max:Number;
			
			if(_data.high > _data.low) // if axis is inverted
			{
				min = Math.max(_data.high,Math.max(_data.close,_data.open));
				max = Math.min(_data.low,Math.min(_data.open,_data.close));
			}
			else
			{
				max = Math.min(_data.high,Math.min(_data.close,_data.open));
				min = Math.max(_data.low,Math.max(_data.open,_data.close));
			}
			var boxMin:Number = Math.min(_data.open, _data.close);
			var boxMax:Number = Math.max(_data.open, _data.close);
	
			var candlestickHeight:Number = min- max;
			var heightScaleFactor:Number = height / candlestickHeight;
			
			rc = new Rectangle(w,
							   (boxMin - max) *
							   heightScaleFactor + w,
							   width - 2 * w,
							   (boxMax - boxMin) * heightScaleFactor - 2 * w);

			g.clear();		
			g.moveTo(rc.left,rc.top);
			if (boxStroke)
				boxStroke.apply(g,null,null);
			else
				g.lineStyle(0,0,0);
			if (fill)
				fill.begin(g,rc,null);
			g.lineTo(rc.right, rc.top);
			g.lineTo(rc.right, rc.bottom);
			g.lineTo(rc.left, rc.bottom);
			g.lineTo(rc.left, rc.top);
			if (fill)
				fill.end(g);
			if (stroke)
			{
				stroke.apply(g,null,null);
				g.moveTo(width / 2, 0);
				g.lineTo(width / 2, (boxMin - max) * heightScaleFactor);
				g.moveTo(width / 2, (boxMax - max) * heightScaleFactor);
				g.lineTo(width / 2, height);
			}
		}
		else
		{
			fill = GraphicsUtilities.fillFromStyle(getStyle("declineFill"));
			var declineFill:IFill = GraphicsUtilities.fillFromStyle(getStyle("fill"));
			
			rc = new Rectangle(0, 0, unscaledWidth, unscaledHeight);
			
			g.clear();		
			g.moveTo(width, 0);
			if (fill)
				fill.begin(g, rc,null);
			g.lineStyle(0, 0, 0);
			g.lineTo(0, height);			
			if (boxStroke)
				boxStroke.apply(g,null,null);
			g.lineTo(0, 0);
			g.lineTo(width, 0);
			if (fill)
				fill.end(g);
			if (declineFill)
				declineFill.begin(g, rc, null);
			g.lineTo(width, height);
			g.lineTo(0, height);
			g.lineStyle(0, 0, 0);
			g.lineTo(width, 0);			
			if (declineFill)
				declineFill.end(g);
		}
	}
}

}
