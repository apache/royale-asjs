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

package spark.primitives
{
/* 
import flash.display.Graphics;
import flash.display.GraphicsStroke;
import flash.display.IGraphicsData;
import flash.geom.Point;
import flash.geom.Rectangle;

import spark.primitives.supportClasses.StrokedElement; */
import org.apache.royale.events.EventDispatcher;
import mx.core.mx_internal;
import mx.graphics.IStroke;
import mx.graphics.IFill;

use namespace mx_internal;

/**
 *  The Line class is a graphic element that draws a line between two points.
 *  
 *  <p>The default stroke for a line is undefined; therefore, if you do not specify
 *  the stroke, the line is invisible.</p>
 *  
 *  @see mx.graphics.Stroke
 *  
 *  @includeExample examples/LineExample.mxml
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
public class Line extends EventDispatcher
{ //extends StrokedElement
  //  include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     *  @royalesuppresspublicvarwarning
	*/
    public function Line()
    {
        super();
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  xFrom
    //----------------------------------

    private var _xFrom:Number = 0;
    
    [Inspectable(category="General")]

    /**
    *  The starting x position for the line.
    *
    *  @default 0
    *  
    *  @langversion 3.0
    *  @playerversion Flash 10
    *  @playerversion AIR 1.5
    *  @productversion Royale 0.9.4
    */
    
    public function get xFrom():Number 
    {
        return _xFrom;
    }
    
    /**
     *  @private 
     */
    public function set xFrom(value:Number):void
    {
        if (value != _xFrom)
        {
            _xFrom = value;
          //  invalidateSize();
          //  invalidateDisplayList();
        }
    }
    
    //----------------------------------
    //  xTo
    //----------------------------------

    private var _xTo:Number = 0;
    
    [Inspectable(category="General")]

    /**
    *  The ending x position for the line.
    *
    *  @default 0
    *  
    *  @langversion 3.0
    *  @playerversion Flash 10
    *  @playerversion AIR 1.5
    *  @productversion Royale 0.9.4
    */
    
    public function get xTo():Number 
    {
        return _xTo;
    }
    
    /**
     *  @private 
     */
    public function set xTo(value:Number):void
    {        
        if (value != _xTo)
        {
            _xTo = value;
           // invalidateSize();
           // invalidateDisplayList();
        }
    }
    
    //----------------------------------
    //  yFrom
    //----------------------------------

    private var _yFrom:Number = 0;
    
    [Inspectable(category="General")]

    /**
    *  The starting y position for the line.
    *
    *  @default 0
    *  
    *  @langversion 3.0
    *  @playerversion Flash 10
    *  @playerversion AIR 1.5
    *  @productversion Royale 0.9.4
    */
    
    public function get yFrom():Number 
    {
        return _yFrom;
    }
    
    /**
     *  @private 
     */
    public function set yFrom(value:Number):void
    {
        if (value != _yFrom)
        {
            _yFrom = value;
           // invalidateSize();
           // invalidateDisplayList();
        }
    }
    
    //----------------------------------
    //  yTo
    //----------------------------------

    private var _yTo:Number = 0;
    
    [Inspectable(category="General")]

    /**
    *  The ending y position for the line.
    *
    *  @default 0
    *  
    *  @langversion 3.0
    *  @playerversion Flash 10
    *  @playerversion AIR 1.5
    *  @productversion Royale 0.9.4
    */
    
    public function get yTo():Number 
    {
        return _yTo;
    }
    
    /**
     *  @private 
     */
    public function set yTo(value:Number):void
    {        
        if (value != _yTo)
        {
            _yTo = value;
          //  invalidateSize();
           // invalidateDisplayList();
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* override protected function canSkipMeasurement():Boolean
    {
        // Since our measure() is quick, we prefer to call it always instead of
        // trying to detect cases where measuredX and measuredY would change.
        return false;
    } */

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* override protected function measure():void
    {
        measuredWidth = Math.abs(xFrom - xTo);
        measuredHeight = Math.abs(yFrom - yTo);
        measuredX = Math.min(xFrom, xTo);
        measuredY = Math.min(yFrom, yTo);
    } */

    /**
     * @private 
     */
    /* override protected function beginDraw(g:Graphics):void
    {
        var graphicsStroke:GraphicsStroke; 
        if (stroke)
            graphicsStroke = GraphicsStroke(stroke.createGraphicsStroke(new 
            					Rectangle(drawX + measuredX, drawY + measuredY, 
            					Math.max(width, stroke.weight), Math.max(height, stroke.weight)),
                                new Point(drawX + measuredX, drawY + measuredY))); 
        
        // If the stroke returns a valid graphicsStroke object which is the 
        // Drawing API-2 drawing commands to render this stroke, use that 
        // to draw the stroke to screen 
        if (graphicsStroke)
            g.drawGraphicsData(new <IGraphicsData>[graphicsStroke]);
        else 
            super.beginDraw(g);
    } */

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
   /*  override protected function draw(g:Graphics):void
    {
        // Our bounding box is (x1, y1, x2, y2)
        var x1:Number = measuredX + drawX;
        var y1:Number = measuredY + drawY;
        var x2:Number = measuredX + drawX + width;
        var y2:Number = measuredY + drawY + height;    
        
        // Which way should we draw the line?
        if ((xFrom <= xTo) == (yFrom <= yTo))
        { 
            // top-left to bottom-right
            g.moveTo(x1, y1);
            g.lineTo(x2, y2);
        }
        else
        {
            // bottom-left to top-right
            g.moveTo(x1, y2);
            g.lineTo(x2, y1);
        }
    } */
	
	//----------------------------------
    //  height copied from GraphicElement
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the height property.
     */
    /* mx_internal */ private var _height:Number = 0;

    [Bindable("propertyChange")]
    [Inspectable(category="General")]
    [PercentProxy("percentHeight")]

    /**
     *  The height of the graphic element.
     *
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     *  @royalesuppresspublicvarwarning
	 */
    public function get height():Number
    {
        return _height;
    }

    /**
     *  @private
     */
    
    public function set height(value:Number):void
    {
       // explicitHeight = value;

        if (_height == value)
            return;

        var oldValue:Number = _height;
        _height = value;
       // dispatchPropertyChangeEvent("height", oldValue, value);

        // Invalidate the display list, since we're changing the actual height
        // and we're not going to correctly detect whether the layout sets
        // new actual height different from our previous value.
       // invalidateDisplayList();
    }
	
	
	 //----------------------------------
    //  visible copied from GraphicElement
    //----------------------------------

    /**
     *  @private
     *  Storage for the visible property.
     */
    private var _visible:Boolean = true;
    
    
    /**
     *  @private
     *  The actual 'effective' visibility of this
     *  element, one that considers the visibility of
     *  the owning design layer parent (if any).
     */
   // protected var _effectiveVisibility:Boolean = true;
    
    /**
     *  @private
     */
  //  private var visibleChanged:Boolean;

    [Inspectable(category="General")]

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     *  @royalesuppresspublicvarwarning
	*/
    public function get visible():Boolean
    {
        return _visible;
    }

    /**
     *  @private
     */
    public function set visible(value:Boolean):void
    {
        _visible = value;
        
        /* if (designLayer && !designLayer.effectiveVisibility)
            value = false; 
        
        if (_effectiveVisibility == value)
            return;
        
        _effectiveVisibility = value;
        visibleChanged = true;
        invalidateProperties(); */
    }
	
	//----------------------------------
    //  width copied from GraphicElement
    //----------------------------------

    /**
     *  @private
     *  Storage for the width property.
     */
     /* mx_internal */ private var _width:Number = 0;

    [Bindable("propertyChange")]
    [Inspectable(category="General")]
    [PercentProxy("percentWidth")]

    /**
     *  The width of the graphic element.
     *
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     *  @royalesuppresspublicvarwarning
	*/
    public function get width():Number
    {
        return _width;
    }

    /**
     *  @private
     */
    public function set width(value:Number):void
    {
       // explicitWidth = value;

        if (_width == value)
            return;

        var oldValue:Number = _width;
        _width = value;

        // The width is needed for the mirroring transform.
      /*   if (layoutFeatures)
        {
            layoutFeatures.layoutWidth = value;
            invalidateTransform();
        }        

        dispatchPropertyChangeEvent("width", oldValue, value);

        // Invalidate the display list, since we're changing the actual width
        // and we're not going to correctly detect whether the layout sets
        // new actual width different from our previous value.
        invalidateDisplayList(); */
    }
	
	
	/**
     *  @private
     *  storage for the x property. This property is used when a GraphicElement has a simple transform.
     */
    private var _x:Number = 0;

    /**
     *  @private
     *  storage for the y property. This property is used when a GraphicElement has a simple transform.
     */
    private var _y:Number = 0;
	
	//----------------------------------
    //  x Copied From GraphicElement
    //----------------------------------  

    [Bindable("propertyChange")]
    [Inspectable(category="General")]
    
    /**
     *  The x position of the graphic element.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get x():Number
    {
        // return (layoutFeatures == null)? _x:layoutFeatures.layoutX;
		return 0;
    }

    /**
     *  @private
     */
    public function set x(value:Number):void
    {
       /*  var oldValue:Number = x;
        if (oldValue == value)
            return;

        if (layoutFeatures != null)
            layoutFeatures.layoutX = value;
        else
            _x = value;
            
        dispatchPropertyChangeEvent("x", oldValue, value);
        invalidateTransform(false); */
    }

    //----------------------------------
    //  y Copied From GraphicElement
    //----------------------------------   

    [Bindable("propertyChange")]
    [Inspectable(category="General")]
    
    /**
     *  The y position of the graphic element.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get y():Number
    {
        // return (layoutFeatures == null)? _y:layoutFeatures.layoutY;
		return 0;
    }

    /**
     *  @private
     */
    public function set y(value:Number):void
    {
       /*  var oldValue:Number = y;
        if (oldValue == value)
            return;

        if (layoutFeatures != null)
            layoutFeatures.layoutY = value;
        else
            _y = value;
        dispatchPropertyChangeEvent("y", oldValue, value);
        invalidateTransform(false); */
    }
	
	
	//----------------------------------
    //  stroke copied from StrokedElement
    //----------------------------------

    /**
     *  @private
     */
     /* mx_internal */ private var _stroke:IStroke;
    
    [Bindable("propertyChange")]    
    [Inspectable(category="General")]

    /**
     *  The stroke used by this element.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
	 *  @royalesuppresspublicvarwarning
	*/
    public function get stroke():IStroke
    {
        return _stroke;
    }
    
    /**
     *  @private
     */
    public function set stroke(value:IStroke):void
    {
       /*  var strokeEventDispatcher:EventDispatcher;
        var oldValue:IStroke = _stroke;
        
        strokeEventDispatcher = _stroke as EventDispatcher;
        if (strokeEventDispatcher)
            strokeEventDispatcher.removeEventListener(
                PropertyChangeEvent.PROPERTY_CHANGE, 
                stroke_propertyChangeHandler); */
            
        _stroke = value;
        
        /* strokeEventDispatcher = _stroke as EventDispatcher;
        if (strokeEventDispatcher)
            strokeEventDispatcher.addEventListener(
                PropertyChangeEvent.PROPERTY_CHANGE, 
                stroke_propertyChangeHandler);
     
     	dispatchPropertyChangeEvent("stroke", oldValue, _stroke);
     
        invalidateDisplayList();
        // Parent layout takes stroke into account
        invalidateParentSizeAndDisplayList(); */
    }

	
}

}
