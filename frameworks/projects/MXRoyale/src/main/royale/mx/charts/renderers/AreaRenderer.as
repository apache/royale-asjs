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

import mx.charts.chartClasses.GraphicsUtilities;
import mx.core.IDataRenderer;
import mx.graphics.IFill;
import mx.graphics.IStroke;
import mx.graphics.SolidColorStroke;
import mx.skins.ProgrammaticSkin;
COMPILE::JS
{
    import org.apache.royale.core.WrappedHTMLElement;
}

/**
 *  The default class used to render the area
 *  beneath the dataPoints of an AreaSeries object.
 *  This class renders the area using the fill, stroke, and line type
 *  as specified by the AreaSeries object's <code>areaFill</code>, <code>areaStroke</code>,
 *  and <code>form</code> styles, respectively.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class AreaRenderer extends ProgrammaticSkin implements IDataRenderer
{
//    include "../../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class variables
    //
    //--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	private static var noStroke:SolidColorStroke = new SolidColorStroke(0, 0, 0);

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
	public function AreaRenderer() 
	{
		super();
	}
	
    COMPILE::JS
    override protected function createElement():WrappedHTMLElement
    {
        var element:WrappedHTMLElement = super.createElement();
        positioner.style.left = "0px";
        positioner.style.top = "0px";
        return element;
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
	 *  The data that the AreaRenderer renders.
	 *  The AreaRenderer expects this property to be assigned an instance
	 *  of mx.charts.series.renderData.AreaRenderData.
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
		_data = value;

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
	
		var fill:IFill = GraphicsUtilities.fillFromStyle(getStyle("areaFill"));
		var stroke:IStroke = getStyle("areaStroke");
		var form:String = getStyle("form");

		var g:Graphics = graphics;
		g.clear();
		
		if (!_data)
			return;
			
		var boundary:Array /* of Object */ = _data.filteredCache;
		var n:int = boundary.length;
		if (n == 0)
			return;
			
		var xMin:Number;
		var xMax:Number = xMin = boundary[0].x;
		var yMin:Number;
		var yMax:Number = yMin = boundary[0].y;

		var v:Object;
		
		for (var i:int = 0; i < n; i++)
		{
			v = boundary[i];
			
			xMin = Math.min(xMin, v.x);
			yMin = Math.min(yMin, v.y);
			xMax = Math.max(xMax, v.x);
			yMax = Math.max(yMax, v.y);
			
			if (!isNaN(v.min))
			{
				yMin = Math.min(yMin, v.min);
				yMax = Math.max(yMax, v.min);
			}
		}

		if (fill)
			fill.begin(g, new Rectangle(xMin, yMin, xMax - xMin, yMax - yMin),null);
		
		GraphicsUtilities.drawPolyLine(g, boundary, 0, n,
										"x", "y", stroke, form);
		
		g.lineStyle(0,0,0);	
			
		if (boundary[0].element.minField != null && boundary[0].element.minField != "")
		{
			g.lineTo(boundary[n - 1].x, boundary[n - 1].min);		
			
			GraphicsUtilities.drawPolyLine(g, boundary, n - 1, -1,
											"x", "min", noStroke, form, false);
		}
		else
		{
			g.lineTo(boundary[n - 1].x, _data.renderedBase);		
			g.lineTo(boundary[0].x, _data.renderedBase);
		}

		g.lineStyle(0, 0, 0);
		g.lineTo(boundary[0].x, boundary[0].y);

		g.endFill();
	}
    
    override public function addedToParent():void
    {
        super.addedToParent();
        COMPILE::JS
            {
                element.style.position = "absolute";
            }
    }
}

}
