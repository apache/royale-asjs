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

package mx.charts.effects.effectClasses
{

import org.apache.royale.geom.Point;
import org.apache.royale.geom.Rectangle;

/**
 *  The SeriesZoomInstance class implements the instance class
 *  for the SeriesZoom effect.
 *  Flex creates an instance of this class when it plays a SeriesZoom effect;
 *  you do not create one yourself.
 *
 *  @see mx.charts.effects.SeriesZoom
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 * 
 *  @royalesuppresspublicvarwarning
 */  
public class SeriesZoomInstance extends SeriesEffectInstance
{
//    include "../../../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private static var BOTH:uint = 0;
    
    /**
     *  @private
     */
    private static var HORIZONTAL:uint = 1;
    
    /**
     *  @private
     */
    private static var VERTICAL:uint = 2;

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *  
     *  @param target The target of the effect.  
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function SeriesZoomInstance(target:Object)
    {
        super(target);
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private var _direction:uint;
    
    /**
     *  @private
     */
    private var _elementBounds:Array /* of Rectangle */;
    
    /**
     *  @private
     */
    private var _slideDistance:Number;  
    
    /**
     *  @private
     */
    private var _zoomPoints:Array /* of Point */;
    
    /**
     *  @private
     */
    private var seriesRenderData:Object;


    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  horizontalFocus
    //----------------------------------

    [Inspectable(category="General", enumeration="left,center,right")]

    /**
     *  Defines the location of the focul point of the zoom.
     *
     *  <p>Valid values of <code>horizontalFocus</code> are
     *  <code>"left"</code>, <code>"center"</code>, <code>"right"</code>,
     *  and <code>null</code>.</p>
     *  The default value is <code>"center"</code>.
     *
     *  <p>You combine the <code>horizontalFocus</code> and
     *  <code>verticalFocus</code> properties to define where the data series
     *  zooms in and out from.
     *  For example, set <code>horizontalFocus</code> to <code>"left"</code>
     *  and <code>verticalFocus</code> to <code>"top"</code> to zoom
     *  the series data to and from the top left corner of either the element
     *  or the chart (depending on the setting of the
     *  <code>relativeTo</code> property).</p>
     *
     *  <p>If you specify only one of these two properties, then the focus
     *  is a horizontal or vertical line rather than a point.
     *  For example, when you set <code>horizontalFocus</code> to
     *  <code>"left"</code> but <code>verticalFocus</code> to
     *  <code>null</code>, the element zooms to and from a vertical line
     *  along the left edge of its bounding box.
     *  Set <code>verticalFocus</code> to <code>"center"</code> to zoom
     *  chart elements to and from a horizontal line along the middle
     *  of the chart's bounding box.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var horizontalFocus:String;

    //----------------------------------
    //  relativeTo
    //----------------------------------

    [Inspectable(category="General", enumeration="series,chart", defaultValue="series")]

    /**
     *  Controls the bounding box that Flex uses to calculate 
     *  the focal point of the zooms.
     *
     *  <p>Valid values for <code>relativeTo</code> are
     *  <code>"series"</code> and <code>"chart"</code>.
     *  The default value is <code>"series"</code>.</p>
     *
     *  <p>Set to <code>"series"</code> to zoom each element
     *  relative to itself.
     *  For example, each column of a ColumnChart zooms from the top left
     *  of the column, the center of the column, and so on.</p>
     *
     *  <p>Set to <code>"chart"</code> to zoom each element
     *  relative to the chart area.
     *  For example, each column zooms from the top left of the axes,
     *  the center of the axes, and so on.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var relativeTo:String = "series";

    //----------------------------------
    //  verticalFocus
    //----------------------------------

    [Inspectable(category="General", enumeration="top,center,bottom")]

    /**
     *  Defines the location of the focul point of the zoom.
     *
     *  <p>Valid values of <code>verticalFocus</code> are
     *  <code>"top"</code>, <code>"center"</code>, <code>"bottom"</code>,
     *  and <code>null</code>.
     *  The default value is <code>"center"</code>.</p>
     *
     *  <p>For more information, see the description of the
     *  <code>horizontalFocus</code> property.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var verticalFocus:String;

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override public function play():void
    {       
        seriesRenderData = targetSeries.getRenderDataForTransition(type);       
        
        targetSeries.getElementBounds(seriesRenderData);
        var elementBounds:Array /* of Rectangle */ = _elementBounds =
            seriesRenderData.elementBounds;
        
        var activeBounds:Array /* of Rectangle */ = [];
        var zoomPoints:Array /* of Point */ = [];
        
        var n:int = elementBounds.length;
        var i:int;
        var pt:Point;
        var v:Rectangle;
        
        if (relativeTo == "series")
        {
            loadSeriesRelativePoints(zoomPoints, elementBounds);
        }
        else
        {
            loadChartRelativePoints(zoomPoints, elementBounds,
                                    seriesRenderData.visibleRegion);
        }

        if (type == "show")
        {
            switch (_direction)
            {
                case BOTH:
                {
                    for (i = 0; i < n; i++)
                    {
                        pt = zoomPoints[i];
                        activeBounds[i] = new Rectangle(pt.x, pt.y, 0, 0);
                    }
                    break;
                }

                case HORIZONTAL:
                {
                    for (i = 0; i < n; i++)
                    {
                        pt = zoomPoints[i];
                        v = elementBounds[i];
                        activeBounds[i] =
                            new Rectangle(pt.x, v.top, 0, v.height);
                    }
                    break;
                }

                case VERTICAL:
                {
                    for (i = 0; i < n; i++)
                    {
                        pt = zoomPoints[i];
                        v = elementBounds[i];
                        activeBounds[i] =
                            new Rectangle(v.left, pt.y, v.width, 0);
                    }
                    break;
                }
            }
        }
        else
        {
            for (i = 0; i < n; i++)
            {
                v = elementBounds[i];
                activeBounds[i] = elementBounds[i].clone();
            }
        }       

        seriesRenderData.elementBounds = activeBounds;
        targetSeries.transitionRenderData = seriesRenderData;
        _zoomPoints = zoomPoints;
        
        beginTween(n);
    }
    
    /**
     *  @private
     */
    override public function onTweenUpdate(value:Object):void
    {
        super.onTweenUpdate(value);

        var elementBounds:Array /* of Rectangle */ = _elementBounds;
        var activeBounds:Array /* of Rectangle */ = seriesRenderData.elementBounds;
        var zoomPoints:Array /* of Point */ = _zoomPoints;
        
        var n:int = elementBounds.length;
        var base:Number = 0;
        var scale:Number = 1;
        var i:int;
        var v:Rectangle;
        var pt:Point;
        var interpolation:Number;
        
        if (type == "hide")
        {
            base = 1;
            scale = -1;
        }
        {
            switch (_direction)
            {
                case BOTH:
                {
                    for (i = 0; i < n; i++)
                    {
                        interpolation = base + scale * interpolationValues[i];
                        v = elementBounds[i];

                        pt = zoomPoints[i];
                        activeBounds[i] = new Rectangle(
                            pt.x + (v.left - pt.x) * interpolation,
                            pt.y + (v.top - pt.y) * interpolation,
                            v.width * interpolation,
                            v.height * interpolation);
                    }
                    break;
                }
                
                case HORIZONTAL:
                {
                    for (i = 0; i < n; i++)
                    {
                        interpolation = base + scale * interpolationValues[i];
                        v = elementBounds[i];

                        pt = zoomPoints[i];
                        activeBounds[i] = new Rectangle(
                            pt.x + (v.left - pt.x) * interpolation, v.top,
                            v.width *interpolation, v.height);
                    }
                    break;
                }
                
                case VERTICAL:
                {
                    for (i = 0; i < n; i++)
                    {
                        interpolation = base + scale * interpolationValues[i];
                        v = elementBounds[i];

                        pt = zoomPoints[i];
                        activeBounds[i] = new Rectangle(
                            v.left, pt.y + (v.top - pt.y) * interpolation,
                            v.width, v.height * interpolation);
                    }
                    break;
                }
            }
        }

        targetSeries.invalidateDisplayList();
    }
    
    /**
     *  @private
     */
    override public function onTweenEnd(value:Object):void 
    {
        super.onTweenEnd(value);

        targetSeries.transitionRenderData = null;
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private function loadChartRelativePoints(zoomPoints:Array /* of Point */,
                                             elementBounds:Array /* of Rectangle */,
                                             visibleRegion:Rectangle):void
    {
        var n:int = elementBounds.length;
        var i:int; 
        var pt:Point;
        
        if (!visibleRegion)
            visibleRegion = new Rectangle(0, 0,
                                          targetSeries.width / Math.abs(targetSeries.scaleX),
                                          targetSeries.height / Math.abs(targetSeries.scaleY));
        
        switch (horizontalFocus)
        {       
            case "left":
            {
                switch (verticalFocus)
                {
                    case "top":
                    {
                        _direction = BOTH;
                        pt = visibleRegion.topLeft;
                        for (i = 0; i < n; i++)
                        {
                            zoomPoints[i] = pt;
                        }
                        break;
                    }

                    case "center":
                    {
                        _direction = BOTH;
                        pt = new Point(visibleRegion.left,
                                       visibleRegion.top +
                                       visibleRegion.height / 2);
                        for (i = 0; i < n; i++)
                        {
                            zoomPoints[i] = pt;
                        }
                        break;
                    }

                    case "bottom":
                    {
                        _direction = BOTH;
                        pt = new Point(visibleRegion.left,
                                       visibleRegion.bottom);
                        for (i = 0; i < n; i++)
                        {
                            zoomPoints[i] = pt;
                        }
                        break;
                    }

                    default:
                    {
                        _direction = HORIZONTAL;
                        pt = new Point(visibleRegion.left, NaN);
                        for (i = 0; i < n; i++)
                        {
                            zoomPoints[i] = pt;
                        }
                        break;
                    }
                }
                break;
            }

            case "right":
            {
                switch (verticalFocus)
                {
                    case "top":
                    {
                        _direction = BOTH;
                        pt = new Point(visibleRegion.right,
                                       visibleRegion.top);
                        for (i = 0; i < n; i++)
                        {
                            zoomPoints[i] = pt;
                        }
                        break;
                    }

                    case "center":
                    {
                        _direction = BOTH;
                        pt = new Point(visibleRegion.right,
                                       visibleRegion.top +
                                       visibleRegion.height / 2);
                        for (i = 0; i < n; i++)
                        {
                            zoomPoints[i] = pt;
                        }
                        break;
                    }

                    case "bottom":
                    {
                        _direction = BOTH;
                        pt = visibleRegion.bottomRight;
                        for (i = 0; i < n; i++)
                        {
                            zoomPoints[i] = pt;
                        }
                        break;
                    }

                    default:
                    {
                        _direction = HORIZONTAL;
                        pt = new Point(visibleRegion.right, NaN);
                        for (i = 0; i < n; i++)
                        {
                            zoomPoints[i] = pt;
                        }
                        break;
                    }
                }
                break;
            }

            case "center":
            {
                switch (verticalFocus)
                {
                    case "top":
                    {
                        _direction = BOTH;
                        pt = new Point(visibleRegion.left +
                                       visibleRegion.width / 2,
                                       visibleRegion.top);
                        for (i = 0; i < n; i++)
                        {
                            zoomPoints[i] = pt;
                        }
                        break;
                    }

                    case "center":
                    {
                        _direction = BOTH;
                        pt = new Point(visibleRegion.left +
                                       visibleRegion.width / 2,
                                       visibleRegion.top +
                                       visibleRegion.height / 2);
                        for (i = 0; i < n; i++)
                        {
                            zoomPoints[i] = pt;
                        }
                        break;
                    }

                    case "bottom":
                    {
                        _direction = BOTH;
                        pt = new Point(visibleRegion.left +
                                       visibleRegion.width / 2,
                                       visibleRegion.bottom);
                        for (i = 0; i < n; i++)
                        {
                            zoomPoints[i] = pt;
                        }
                        break;
                    }

                    default:
                    {
                        _direction = HORIZONTAL;
                        pt = new Point(visibleRegion.left +
                                       visibleRegion.width / 2,
                                       NaN);
                        for (i = 0; i < n; i++)
                        {
                            zoomPoints[i] = pt;
                        }
                        break;
                    }
                }
                break;
            }

            default:
            {
                switch (verticalFocus)
                {
                    case "top":
                    {
                        _direction = VERTICAL;
                        pt = new Point(NaN, visibleRegion.top);
                        for (i = 0; i < n; i++)
                        {
                            zoomPoints[i] = pt;
                        }
                        break;
                    }

                    case "center":
                    {
                        _direction = VERTICAL;
                        pt = new Point(NaN,
                                       visibleRegion.top +
                                       visibleRegion.height / 2);
                        for (i = 0; i < n; i++)
                        {
                            zoomPoints[i] = pt;
                        }
                        break;
                    }

                    case "bottom":
                    {
                        _direction = VERTICAL;
                        pt = new Point(NaN, visibleRegion.bottom);
                        for (i = 0; i < n; i++)
                        {
                            zoomPoints[i] = pt;
                        }
                        break;
                    }

                    default:
                    {
                        _direction = BOTH;
                        pt = new Point(visibleRegion.left +
                                       visibleRegion.width / 2,
                                       visibleRegion.top +
                                       visibleRegion.height / 2);
                        for (i = 0; i < n; i++)
                        {
                            zoomPoints[i] = pt;
                        }
                        break;
                    }
                }
                break;
            }
        }
    }

    /**
     *  @private
     */
    private function loadSeriesRelativePoints(zoomPoints:Array /* of Point */,
                                              elementBounds:Array /* of Rectangle */):void
    {
        var n:int = elementBounds.length;
        var i:int;
        var v:Rectangle;
        var pt:Point;
        
        switch (horizontalFocus)
        {       
            case "left":
            {
                switch (verticalFocus)
                {
                    case "top":
                    {
                        _direction= BOTH;
                        for (i = 0; i < n; i++)
                        {
                            v = elementBounds[i];
                            zoomPoints[i] = new Point(v.left, v.top);
                        }
                        break;
                    }

                    case "center":
                    {
                        _direction = BOTH;
                        for (i = 0; i < n; i++)
                        {
                            v = elementBounds[i];
                            zoomPoints[i] = new Point(v.left,
                                                      (v.top + v.bottom) / 2);
                        }
                        break;
                    }

                    case "bottom":
                    {
                        _direction = BOTH;
                        for (i = 0; i < n; i++)
                        {
                            v = elementBounds[i];
                            zoomPoints[i] = new Point(v.left, v.bottom);
                        }
                        break;
                    }

                    default:
                    {
                        _direction = HORIZONTAL;
                        for (i = 0; i < n; i++)
                        {
                            v = elementBounds[i];
                            zoomPoints[i] = new Point(v.left,NaN);
                        }
                        break;
                    }
                }
                break;
            }

            case "right":
            {
                switch (verticalFocus)
                {
                    case "top":
                    {
                        _direction = BOTH;
                        for (i = 0; i < n; i++)
                        {
                            v = elementBounds[i];
                            zoomPoints[i] = new Point(v.right, v.top);
                        }
                        break;
                    }

                    case "center":
                    {
                        _direction = BOTH;
                        for (i = 0; i < n; i++)
                        {
                            v = elementBounds[i];
                            zoomPoints[i] = new Point(v.right,
                                                      (v.top + v.bottom) / 2);
                        }
                        break;
                    }

                    case "bottom":
                    {
                        _direction = BOTH;
                        for (i = 0; i < n; i++)
                        {
                            v = elementBounds[i];
                            zoomPoints[i] = new Point(v.right, v.bottom);
                        }
                        break;
                    }

                    default:
                    {
                        _direction = HORIZONTAL;
                        for (i = 0; i < n; i++)
                        {
                            v = elementBounds[i];
                            zoomPoints[i] = new Point(v.right,NaN);
                        }
                        break;
                    }
                }
                break;
            }

            case "center":
            {
                switch (verticalFocus)
                {
                    case "top":
                    {
                        _direction = BOTH;
                        for (i = 0; i < n; i++)
                        {
                            v = elementBounds[i];
                            zoomPoints[i] = new Point((v.left + v.right) / 2, 
                                                      v.top);
                        }
                        break;
                    }

                    case "center":
                    {
                        _direction = BOTH;
                        for (i = 0; i < n; i++)
                        {
                            v = elementBounds[i];
                            zoomPoints[i] = new Point((v.left + v.right) / 2, 
                                                      (v.top + v.bottom) / 2);
                        }
                        break;
                    }

                    case "bottom":
                    {
                        _direction = BOTH;
                        for (i = 0; i < n; i++)
                        {
                            v = elementBounds[i];
                            zoomPoints[i] = new Point((v.left + v.right) / 2,
                                                      v.bottom);
                        }
                        break;
                    }

                    default:
                    {
                        _direction = HORIZONTAL;
                        for (i = 0; i < n; i++)
                        {
                            v = elementBounds[i];
                            zoomPoints[i] = new Point((v.right + v.left) / 2,
                                                      NaN);
                        }
                        break;
                    }
                }
                break;
            }

            default:
            {
                switch (verticalFocus)
                {
                    case "top":
                    {
                        _direction = VERTICAL;
                        for (i = 0; i < n; i++)
                        {
                            v = elementBounds[i];
                            zoomPoints[i] = new Point(NaN, v.top);
                        }
                        break;
                    }

                    case "center":
                    {
                        _direction = VERTICAL;
                        for (i = 0; i < n; i++)
                        {
                            v = elementBounds[i];
                            zoomPoints[i] = new Point(NaN,
                                                      (v.top + v.bottom) / 2);
                        }
                        break;
                    }

                    case "bottom":
                    {
                        _direction = VERTICAL;
                        for (i = 0; i < n; i++)
                        {
                            v = elementBounds[i];
                            zoomPoints[i] = new Point(NaN, v.bottom);
                        }
                        break;
                    }

                    default:
                    {
                        _direction = BOTH;
                        for (i = 0; i < n; i++)
                        {
                            v = elementBounds[i];
                            zoomPoints[i] = new Point((v.left + v.right) / 2,
                                                      (v.top + v.bottom) / 2);
                        }
                        break;
                    }
                }
                break;
            }
        }
    }
}

}
