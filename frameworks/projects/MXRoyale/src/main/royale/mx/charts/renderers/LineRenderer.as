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

import mx.charts.chartClasses.GraphicsUtilities;
import mx.core.IDataRenderer;
import mx.graphics.IStroke;
import mx.skins.ProgrammaticSkin;
COMPILE::JS
{
    import org.apache.royale.core.WrappedHTMLElement;
}

/**
 *  A simple implementation of a line segment renderer
 *  that is used by LineSeries objects.
 *  This class renders a line on screen using the stroke and form defined by
 *  the owning series's <code>lineStroke</code> and <code>form</code> styles,
 *  respectively.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class LineRenderer extends ProgrammaticSkin implements IDataRenderer
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
	public function LineRenderer() 
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
	 *  The chart item that this renderer represents.
	 *  LineRenderers assume that this value is an instance of LineSeriesItem.
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

		var stroke:IStroke = getStyle("lineStroke");		
		var form:String = getStyle("form");

		graphics.clear();

		GraphicsUtilities.drawPolyLine(graphics, _data.items,
									   _data.start, _data.end + 1,"x","y",
									   stroke,form);

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
