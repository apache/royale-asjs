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

import mx.charts.ChartItem;
import mx.charts.series.items.HLOCSeriesItem;
import mx.core.IDataRenderer;
import mx.graphics.IStroke;
import mx.graphics.LinearGradientStroke;
import mx.graphics.SolidColorStroke;
import mx.skins.ProgrammaticSkin;
import org.apache.royale.utils.ColorUtil;

/**
 *  The default item renderer for an HLOCSeries object.
 *  This class renders a vertical line from high to low
 *  with tick marks at the open and close points of the chart item.
 *  
 *  <p>The vertical line is rendered by using the value of the owning series's
 *  <code>stroke</code> style. 
 *  The open and close tick marks are rendered by using the owning series's
 *  <code>openTickStroke</code> and <code>closeTickStroke</code> styles,
 *  respectively.
 *  The lengths of the open and close tick marks are determined by the
 *  owning series's <code>openTickLength</code> and
 *  <code>closeTickLength</code>styles, respectively.</p>
 *
 *  <p>Both the open tick and close tick values are optional;
 *  an HLOCItemRenderer only renders the tick marks if the open and close
 *  values on the associated chart item are non-<code>NaN</code> values.</p>
 * 
 *  @see mx.charts.series.HLOCSeries
 *  @see mx.charts.series.HLOCSeriesItem
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class HLOCItemRenderer extends ProgrammaticSkin implements IDataRenderer
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
    public function HLOCItemRenderer() 
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
     *  HLOCItemRenderers assume this value
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

        var istroke:IStroke = getStyle("stroke");
        
        var stroke:SolidColorStroke;
        var lgstroke:LinearGradientStroke;
        
        if (istroke is SolidColorStroke)
        	stroke = SolidColorStroke(istroke);
        else if (istroke is LinearGradientStroke)
        	lgstroke = LinearGradientStroke(istroke);
        else
        	stroke = new SolidColorStroke(getStyle('hlocColor'), istroke.weight);
        
        var iOpenTickStroke:IStroke = getStyle("openTickStroke");
        
        var openTickStroke:SolidColorStroke;
        var lgOpenTickStroke:LinearGradientStroke;
        
        if (iOpenTickStroke is SolidColorStroke)
        	openTickStroke = SolidColorStroke(iOpenTickStroke);
       else if (iOpenTickStroke is LinearGradientStroke)
        	lgOpenTickStroke = LinearGradientStroke(iOpenTickStroke);
        else
        	openTickStroke = new SolidColorStroke(getStyle('hlocColor'), iOpenTickStroke.weight, 1, false, "normal", "none");
        	
        var iCloseTickStroke:IStroke = getStyle("closeTickStroke");
        
        var closeTickStroke:SolidColorStroke;
        var lgCloseTickStroke:LinearGradientStroke;
        
        if (iCloseTickStroke is SolidColorStroke)
        	closeTickStroke = SolidColorStroke(iCloseTickStroke);
        else if (iCloseTickStroke is LinearGradientStroke)
        	lgCloseTickStroke = LinearGradientStroke(iCloseTickStroke);
        else
        	closeTickStroke = new SolidColorStroke(getStyle('hlocColor'), iCloseTickStroke.weight, 1, false, "normal", "none");
        	
        var w2:Number = unscaledWidth / 2;

        var openTickLen:Number = Math.min(w2, getStyle("openTickLength"));
        var closeTickLen:Number = Math.min(w2, getStyle("closeTickLength"));
        
        var openTick:Number;
        var closeTick:Number;
        
        var state:String = "";
        var oldColor:uint;
        var oldOpenTickColor:uint;
        var oldCloseTickColor:uint;
        var strokeColor:uint;
        var openTickColor:uint;
        var closeTickColor:uint;
                
        if (_data)
        {
            var lowValue:Number = Math.max(_data.low,Math.max(_data.high,_data.close));
            var highValue:Number = Math.min(_data.low,Math.min(_data.high,_data.close));
            if (!isNaN(_data.open)) 
            {
                lowValue = Math.max(lowValue,_data.open);
                highValue = Math.min(highValue,_data.open);
            }
    
            var HLOCHeight:Number = lowValue - highValue;
            var heightScaleFactor:Number = (HLOCHeight > 0)? (height / HLOCHeight):0;

            openTick = (_data.open - highValue) *
                       heightScaleFactor;
            closeTick = (_data.close - highValue) *
                        heightScaleFactor;
            
            state = _data.currentState;
            
            if (state && state != "")
        	{
        		if (stroke)
        		{
               		strokeColor = stroke.color;
               		oldColor = stroke.color;
          		}
                /*
            	else if (lgstroke.entries.length > 0)
            	{
            		strokeColor = lgstroke.entries[0].color;
            		oldColor = lgstroke.entries[0].color;
            	}*/	
            	if (openTickStroke)
            	{
            		openTickColor = openTickStroke.color;
            		oldOpenTickColor = openTickStroke.color;
            	}
                /*
            	else if (lgOpenTickStroke.entries.length > 0)
            	{
                	openTickColor = lgOpenTickStroke.entries[0].color;
                	oldOpenTickColor = lgOpenTickStroke.entries[0].color;
             	}*/
            	if (closeTickStroke)
            	{
                	closeTickColor = closeTickStroke.color;
                	oldCloseTickColor = closeTickStroke.color;
             	}
                /*
            	else if (lgCloseTickStroke.entries.length > 0)
            	{
                	closeTickColor = lgCloseTickStroke.entries[0].color;
                	oldCloseTickColor = lgCloseTickStroke.entries[0].color;
             	}*/
         	}           
            switch (state)
            {
                case ChartItem.FOCUSED:
                case ChartItem.ROLLOVER:
                    if (styleManager.isValidStyleValue(getStyle('itemRollOverColor')))
                    {
                    	strokeColor = getStyle('itemRollOverColor');
                    }
                    else
                    {
                    	strokeColor = ColorUtil.adjustBrightness2(strokeColor, -20);
                    }
                    openTickColor = ColorUtil.adjustBrightness2(openTickColor, -20);
                    closeTickColor = ColorUtil.adjustBrightness2(closeTickColor, -20);
                    break;
                    
                case ChartItem.DISABLED:
                    if (styleManager.isValidStyleValue(getStyle('itemDisabledColor')))
                    {
                    	strokeColor = getStyle('itemDisabledColor');
                    }
                    else
                    {
                    	strokeColor = ColorUtil.adjustBrightness2(strokeColor, 20);
                    }
                    openTickColor = ColorUtil.adjustBrightness2(openTickColor, 20);
                    closeTickColor = ColorUtil.adjustBrightness2(closeTickColor, 20);
                    break;
                    
                case ChartItem.FOCUSEDSELECTED:
                case ChartItem.SELECTED:
                    if (styleManager.isValidStyleValue(getStyle('itemSelectionColor')))
                    {
                    	strokeColor = getStyle('itemSelectionColor');
                    }
                    else
                    {
                    	strokeColor = ColorUtil.adjustBrightness2(strokeColor, -30);
                    }
                    openTickColor = ColorUtil.adjustBrightness2(openTickColor, -30);
                    closeTickColor = ColorUtil.adjustBrightness2(closeTickColor, -30);
                    break;
            }
        }
        else
        {
            openTick = 0.75 * height;
            closeTick = 0.25 * height;
        }
        if (state && state != "")
        {
        	if (stroke)
           		stroke.color = strokeColor;
        	/*else if (lgstroke.entries.length > 0)
           		lgstroke.entries[0].color = strokeColor;*/
        	if (openTickStroke)
            	openTickStroke.color = openTickColor;
        	/*else if (lgOpenTickStroke.entries.length > 0)
            	lgOpenTickStroke.entries[0].color = openTickColor;*/
        	if (closeTickStroke)
            	closeTickStroke.color = closeTickColor;
        	/*else if (lgCloseTickStroke.entries.length > 0)
            	lgCloseTickStroke.entries[0].color = closeTickColor;*/
        }
        var g:Graphics = graphics;
        g.clear();
        if (stroke)              
        	stroke.apply(g,null,null);
        else
        	lgstroke.apply(g,null,null);
        g.moveTo(w2, 0);
        g.lineTo(w2, height);
        if (!isNaN(openTick))
        {
            if (openTickStroke)
            	openTickStroke.apply(g,null,null);
            else
            	lgOpenTickStroke.apply(g,null,null);
            g.moveTo(w2, openTick);
            g.lineTo(w2 - openTickLen, openTick);
        }
        if (!isNaN(closeTick))
        {
            if (closeTickStroke)
            	closeTickStroke.apply(g,null,null);
            else
            	lgCloseTickStroke.apply(g,null,null);
            g.moveTo(w2, closeTick);
            g.lineTo(w2 + closeTickLen, closeTick); 
        }
        
        // Restore to old colors - after selection drawing is done.
        if (state && state != "")
        {
        	if (stroke)
               	stroke.color = oldColor;
            /*else if (lgstroke.entries.length > 0)
               	lgstroke.entries[0].color = oldColor;*/
            if (openTickStroke)
                openTickStroke.color = oldOpenTickColor;
            /*else if (lgOpenTickStroke.entries.length > 0)
                lgOpenTickStroke.entries[0].color = oldOpenTickColor;*/
            if (closeTickStroke)
                closeTickStroke.color = oldCloseTickColor;
            /*else if (lgCloseTickStroke.entries.length > 0)
                lgCloseTickStroke.entries[0].color = oldCloseTickColor;*/
        }
    }
}

}
