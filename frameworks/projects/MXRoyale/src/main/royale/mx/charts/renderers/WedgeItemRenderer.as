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
import org.apache.royale.geom.Point;
import org.apache.royale.geom.Rectangle;
import mx.charts.chartClasses.GraphicsUtilities;
import mx.charts.series.items.PieSeriesItem;
import mx.core.IDataRenderer;
import mx.graphics.IFill;
import mx.graphics.IStroke;
import mx.graphics.SolidColor;
import mx.skins.ProgrammaticSkin;
import org.apache.royale.utils.ColorUtil;
import mx.charts.ChartItem;

/**
 *  The default itemRenderer for a PieSeries object.
 *  This class renders a wedge using the <code>stroke</code> and <code>radialStroke</code> styles
 *  of the owning series to draw the inner and outer edges and side edges
 *  of the wedge, respectively.
 *	The wedge is filled using the value of the <code>fill</code> property
 *  of the associated chart item.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class WedgeItemRenderer extends ProgrammaticSkin implements IDataRenderer
{
//    include "../../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	private static const SHADOW_INSET:Number = 8;

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
	public function WedgeItemRenderer() 
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
	private var _data:PieSeriesItem;
	
	[Inspectable(environment="none")]

	/**
	 *  The chart item that this renderer represents.
	 *  WedgeItemRenderers assume that this value
	 *  is an instance of PieSeriesItem.
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
		_data = PieSeriesItem(value);

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

		var g:Graphics = graphics;
		g.clear();		
		
		if (!_data)
			return;

		var stroke:IStroke = getStyle("stroke");		
		var radialStroke:IStroke = getStyle("radialStroke");		
				
		var outerRadius:Number = _data.outerRadius;
		var innerRadius:Number = _data.innerRadius;
		var origin:Point = _data.origin;
		var angle:Number = _data.angle;
		var startAngle:Number = _data.startAngle;
				
		if (stroke && !isNaN(stroke.weight))
			outerRadius -= Math.max(stroke.weight/2,SHADOW_INSET);
		else
			outerRadius -= SHADOW_INSET;
						
		outerRadius = Math.max(outerRadius, innerRadius);
		
		var rc:Rectangle = new Rectangle(origin.x - outerRadius,
										 origin.y - outerRadius,
										 2 * outerRadius, 2 * outerRadius);
		
		var fill:IFill = _data.fill;
		var state:String = _data.currentState;
		
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
		
		var startPt:Point = new Point(
			origin.x + Math.cos(startAngle) * outerRadius,
			origin.y - Math.sin(startAngle) * outerRadius);

		var endPt:Point = new Point(
			origin.x + Math.cos(startAngle + angle) * outerRadius,
			origin.y - Math.sin(startAngle + angle) * outerRadius);

		g.moveTo(endPt.x, endPt.y);

		fill.begin(g,rc,null);

		GraphicsUtilities.setLineStyle(g, radialStroke);

		if (innerRadius == 0)
		{
			g.lineTo(origin.x, origin.y);
			g.lineTo(startPt.x, startPt.y);
		}
		else
		{
			var innerStart:Point = new Point(
				origin.x + Math.cos(startAngle + angle) * innerRadius,
				origin.y - Math.sin(startAngle + angle) * innerRadius);

			g.lineTo(innerStart.x, innerStart.y);			

			GraphicsUtilities.setLineStyle(g, stroke);
			GraphicsUtilities.drawArc(g, origin.x, origin.y,
									  startAngle + angle, -angle,
									  innerRadius, innerRadius, true);

			GraphicsUtilities.setLineStyle(g, radialStroke);
			g.lineTo(startPt.x, startPt.y);
		}

		GraphicsUtilities.setLineStyle(g, stroke);

		GraphicsUtilities.drawArc(g, origin.x, origin.y,
								  startAngle, angle,
								  outerRadius, outerRadius, true);

		fill.end(g);
	}
}

}
