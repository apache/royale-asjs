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

package spark.filters
{
import org.apache.royale.events.IEventDispatcher;
import flash.filters.BevelFilter;
import mx.filters.BitmapFilter;
import mx.filters.BitmapFilterType;
import mx.filters.BaseDimensionFilter;
import mx.filters.IBitmapFilter;

/** 
 * The BevelFilter class lets you add a bevel effect to display objects.
 * A bevel effect gives objects such as buttons a three-dimensional look. You can customize
 * the look of the bevel with different highlight and shadow colors, the amount
 * of blur on the bevel, the angle of the bevel, the placement of the bevel, 
 * and a knockout effect.
 * You can apply the filter to any display object (that is, objects that inherit from the 
 * DisplayObject class), such as MovieClip, SimpleButton, TextField, and Video objects, 
 * as well as to BitmapData objects.
 *
 * <p>To create a new filter, use the constructor <code>new BevelFilter()</code>.
 * The use of filters depends on the object to which you apply the filter:</p>
 * <ul><li>To apply filters to movie clips, text fields, buttons, and video, use the
 * <code>filters</code> property (inherited from DisplayObject). Setting the <code>filters</code> 
 * property of an object does not modify the object, and you can remove the filter by clearing the
 * <code>filters</code> property. </li>
 * 
 * <li>To apply filters to BitmapData objects, use the <code>BitmapData.applyFilter()</code> method.
 * Calling <code>applyFilter()</code> on a BitmapData object takes the source BitmapData object 
 * and the filter object and generates a filtered image as a result.</li>
 * </ul>
 * 
 * <p>If you apply a filter to a display object, the value of the <code>cacheAsBitmap</code> property of the 
 * object is set to <code>true</code>. If you remove all filters, the original value of 
 * <code>cacheAsBitmap</code> is restored.</p>
 *
 * <p>This filter supports Stage scaling. However, it does not support general scaling, rotation, and 
 * skewing. If the object itself is scaled (if the <code>scaleX</code> and <code>scaleY</code> properties are 
 * not set to 100%), the filter is not scaled. It is scaled only when the user zooms in on the Stage.</p>
 * 
 * <p>A filter is not applied if the resulting image exceeds the maximum dimensions.
 * In  AIR 1.5 and Flash Player 10, the maximum is 8,191 pixels in width or height, 
 * and the total number of pixels cannot exceed 16,777,215 pixels. (So, if an image is 8,191 pixels 
 * wide, it can only be 2,048 pixels high.) If, for example, you zoom in on a large movie clip
 * with a filter applied, the filter is turned off if the resulting image exceeds the maximum dimensions.</p>
 *
 *  @mxml 
 *  <p>The <code>&lt;s:BevelFilter&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;s:BevelFilter 
 *    <strong>Properties</strong>
 *    angle="45"
 *    distance="4"
 *    highlightAlpha="1"
 *    highlightColor="0xFFFFFF"
 *    shadowAlpha="1"
 *    shadowColor="0x000000"
 *    type="inner"
 *  /&gt;
 *  </pre>
 * 
 * 
 * @langversion 3.0
 * @playerversion Flash 10
 * @playerversion AIR 1.5
 * @productversion Flex 4
 * 
 * @includeExample examples/BevelFilterExample.mxml
 *  
 * @see flash.filters.BevelFilter
 * @see flash.display.DisplayObject#filters
 * @see flash.display.DisplayObject#cacheAsBitmap
 * @see flash.display.BitmapData#applyFilter()
 */

public class BevelFilter extends BaseDimensionFilter implements IBitmapFilter
{
    /**
     * Constructor.
     *
     * @param distance The offset distance of the bevel, in pixels (floating point). 
     * @param angle The angle of the bevel, from 0 to 360 degrees. 
     * @param highlightColor The highlight color of the bevel, <i>0xRRGGBB</i>. 
     * @param highlightAlpha The alpha transparency value of the highlight color. Valid values are 0.0 to 
     * 1.0. For example,
     * .25 sets a transparency value of 25%. 
     * @param shadowColor The shadow color of the bevel, <i>0xRRGGBB</i>. 
     * @param shadowAlpha The alpha transparency value of the shadow color. Valid values are 0.0 to 1.0. For example,
     * .25 sets a transparency value of 25%. 
     * @param blurX The amount of horizontal blur in pixels. Valid values are 0 to 255.0 (floating point). 
     * @param blurY The amount of vertical blur in pixels. Valid values are 0 to 255.0 (floating point).
     * @param strength The strength of the imprint or spread. The higher the value, the more color is imprinted and the stronger the contrast between the bevel and the background. Valid values are 0 to 255.0. 
     * @param quality The quality of the bevel. Valid values are 0 to 15, but for most applications,
     * you can use <code>flash.filters.BitmapFilterQuality</code> constants:
     * <ul>
     * <li><code>BitmapFilterQuality.LOW</code></li>
     * <li><code>BitmapFilterQuality.MEDIUM</code></li>
     * <li><code>BitmapFilterQuality.HIGH</code></li>
     * </ul>
     * <p>Filters with lower values render faster. You can use
     * the other available numeric values to achieve different effects.</p>
     * @param type The type of bevel. Valid values are <code>flash.filters.BitmapFilterType</code> constants: 
     * <code>BitmapFilterType.INNER</code>, <code>BitmapFilterType.OUTER</code>, or 
     * <code>BitmapFilterType.FULL</code>. 
     * @param knockout Applies a knockout effect (<code>true</code>), which effectively 
     * makes the object's fill transparent and reveals the background color of the document.
     *
     * @see flash.filters.BitmapFilterQuality
     * @see flash.filters.BitmapFilterType
     *
     * @langversion 3.0
     * @playerversion Flash 10
     * @playerversion AIR 1.5
     * @productversion Flex 4
     */
    public function BevelFilter(distance:Number = 4.0, angle:Number = 45, 
                                highlightColor:uint = 0xFFFFFF, highlightAlpha:Number = 1.0, 
                                shadowColor:uint = 0x000000, shadowAlpha:Number = 1.0, 
                                blurX:Number = 4.0, blurY:Number = 4.0, strength:Number = 1, 
                                quality:int = 1, type:String = "inner", 
                                knockout:Boolean = false)
    {
        super();
        
        this.distance = distance;
        this.angle = angle;
        this.highlightColor = highlightColor;
        this.highlightAlpha = highlightAlpha;
        this.shadowColor = shadowColor;
        this.shadowAlpha = shadowAlpha;
        this.blurX = blurX;
        this.blurY = blurY;
        this.strength = strength;
        this.quality = quality;
        this.type = type;
        this.knockout = knockout;   
    }
    
    //----------------------------------
    //  angle
    //----------------------------------
    
    private var _angle:Number = 45;     
    
    /**
     *   The angle of the bevel, in degrees. Valid values are from 0 to 360. 
     *   The angle value represents the angle of the theoretical light source falling on the 
     *   object and determines the placement of the effect relative to the object. 
     *   If the distance property is set to 0, the effect is not offset from the object and, 
     *   therefore, the angle property has no effect.
     * 
     *   @default 45
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get angle():Number
    {
        return _angle;
    }
    
    public function set angle(value:Number):void
    {
        if (value != _angle)
        {
            _angle = value;
            notifyFilterChanged();
        }
    }
    
    //----------------------------------
    //  distance
    //----------------------------------
    
    private var _distance:Number = 4.0;
    
    /**
     *  The offset distance of the bevel. Valid values are in pixels (floating point). 
     *  @default 4
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get distance():Number
    {
        return _distance;
    }
    
    public function set distance(value:Number):void
    {
        if (value != _distance)
        {
            _distance = value;
            notifyFilterChanged();
        }
    }
    
    //----------------------------------
    //  highlightAlpha
    //----------------------------------
    
    private var _highlightAlpha:Number = 1.0;
    
    [Inspectable(minValue="0.0", maxValue="1.0")]           
    
    /**
     *  The alpha transparency value of the highlight color. The value is specified as a normalized 
     *  value from 0 to 1. For example, .25 sets a transparency value of 25%. 
     *  @default 1
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get highlightAlpha():Number
    {
        return _highlightAlpha;
    }
    
    public function set highlightAlpha(value:Number):void
    {
        if (value != _highlightAlpha)
        {
            _highlightAlpha = value;
            notifyFilterChanged();
        }
    }
    
    //----------------------------------
    //  highlightColor
    //----------------------------------
    
    private var _highlightColor:uint = 0xFFFFFF;
    
    /**
     *  The highlight color of the bevel. Valid values are in hexadecimal format, 0xRRGGBB. 
     *  @default 0xFFFFFF
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get highlightColor():uint
    {
        return _highlightColor;
    }
    
    public function set highlightColor(value:uint):void
    {
        if (value != _highlightColor)
        {
            _highlightColor = value;
            notifyFilterChanged();
        }
    }
    
    //----------------------------------
    //  shadowAlpha
    //----------------------------------
    
    private var _shadowAlpha:Number = 1.0;
    
    [Inspectable(minValue="0.0", maxValue="1.0")]    
    
    /**
     *  The alpha transparency value of the shadow color. This value is specified as a 
     *  normalized value from 0 to 1. For example, .25 sets a transparency value of 25%.
     * 
     *  @default 1
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get shadowAlpha():Number
    {
        return _shadowAlpha;
    }
    
    public function set shadowAlpha(value:Number):void
    {
        if (value != _shadowAlpha)
        {
            _shadowAlpha = value;
            notifyFilterChanged();
        }
    }
    
    //----------------------------------
    //  shadowColor
    //----------------------------------
    
    private var _shadowColor:uint = 0x000000;
    
    /**
     *  The shadow color of the bevel. Valid values are in hexadecimal format, 0xRRGGBB. 
     *  @default 0x000000
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get shadowColor():uint
    {
        return _shadowColor;
    }
    
    public function set shadowColor(value:uint):void
    {
        if (value != _shadowColor)
        {
            _shadowColor = value;
            notifyFilterChanged();
        }
    }
    
    //----------------------------------
    //  type
    //----------------------------------
    
    private var _type:String = BitmapFilterType.INNER;
    
    /**
     *  The placement of the filter effect. Possible values are 
     *  flash.filters.BitmapFilterType constants:
     *  <ul>
     *    <li><code>BitmapFilterType.OUTER</code> - 
     *      Glow on the outer edge of the object.</li>
     *    <li><code>BitmapFilterType.INNER</code> - 
     *      Glow on the inner edge of the object; the default.</li>
     *    <li><code>BitmapFilterType.FULL</code> - 
     *      Glow on top of the object.</li>
     *  </ul>
     *
     *  @default BitmapFilterType.INNER
     *
     *  @see flash.filters.BitmapFilterType
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get type():String
    {
        return _type;
    }
    
    public function set type(value:String):void
    {
        if (value != _type)
        {
            _type = value;
            notifyFilterChanged();
        }
    }
    
    /**
     * Returns a copy of this filter object.
     *
     * @langversion 3.0
     * @playerversion Flash 10
     * @playerversion AIR 1.5
     * @productversion Flex 4
     *  
     * @return A new BevelFilter instance with all the same properties as 
     * the original BevelFilter instance.
     */
    public function clone():IBitmapFilter 
    {
        return new spark.filters.BevelFilter(distance, angle, highlightColor, highlightAlpha,
                                             shadowColor, shadowAlpha, blurX, blurY, strength,
                                             quality, type, knockout);
    } 

}

}
