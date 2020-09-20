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

package mx.graphics
{

import mx.display.Bitmap;
import org.apache.royale.BitmapData;
import mx.core.UIComponent;
import mx.display.Graphics;
import org.apache.royale.events.Event;
import org.apache.royale.events.EventDispatcher;
import mx.events.IOErrorEvent;
import mx.events.SecurityErrorEvent;
import flash.geom.ColorTransform;
import org.apache.royale.geom.Matrix;
import org.apache.royale.geom.Point;
import org.apache.royale.geom.Rectangle;
import org.apache.royale.net.URLRequest;
import flash.system.LoaderContext;

import mx.events.PropertyChangeEvent;
import mx.geom.CompoundTransform;
import mx.utils.MatrixUtil;



/** 
 *  Defines a set of values used to fill an area on screen
 *  with a bitmap or other DisplayObject.
 *  
 *  @see mx.graphics.IFill
 *  @see mx.display.Bitmap
 *  @see org.apache.royale.BitmapData
 *  @see mx.core.UIComponent
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class BitmapFill extends EventDispatcher implements IFill
{
    include "../core/Version.as";

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
    public function BitmapFill()
    {
        super();
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    private static const RADIANS_PER_DEGREES:Number = Math.PI / 180;
    private static var transformMatrix:Matrix = new Matrix();
    private var nonRepeatAlphaSource:BitmapData;
    private var _bitmapData:BitmapData;
    
    private var regenerateNonRepeatSource:Boolean = true;
    private var lastBoundsWidth:Number = 0;
    private var lastBoundsHeight:Number = 0;
    private var applyAlphaMultiplier:Boolean = false;
    private var nonRepeatSourceCreated:Boolean = false;
    private var bitmapDataCreated:Boolean = false;
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  alpha
    //----------------------------------
    
    private var _alpha:Number = 1;
        
    /**
     *  The transparency of a fill.
     *  Possible values are 0.0 (invisible) through 1.0 (opaque). 
     *  
     *  @default 1.0. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get alpha():Number
    {
        return _alpha;
    }
    
    /**
     *  @private
     */
    public function set alpha(value:Number):void
    {
        if (_alpha == value)
            return;
        
        var oldValue:Number = _alpha;
        
        _alpha = value;
             
        applyAlphaMultiplier = true;
        
        if (_bitmapData && !_bitmapData.transparent && _alpha < 1 && oldValue == 1)
        {
            // If alpha is not opaque, then reapply the source because we might need 
            // to clone it. 
            var s:Object = _source;
            _source = null;
            source = s;
        }
        
        dispatchFillChangedEvent("alpha", oldValue, value);
    }
    
    //----------------------------------
    //  compoundTransform
    //----------------------------------
    
    /**
     *  Holds the matrix and the convenience transform properties (<code>x</code>, <code>y</code>, and <code>rotation</code>).
     *  The compoundTransform is only created when the <code>matrix</code> property is set. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected var compoundTransform:CompoundTransform;        
    
    //----------------------------------
    //  matrix
    //----------------------------------
    
    [Inspectable(category="General")]
    
    /**
     *  An array of values used for matrix transformation.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get matrix():Matrix
    {
        return compoundTransform ? compoundTransform.matrix : null;
    }
    
    /**
     *  @private
     */
    public function set matrix(value:Matrix):void
    {
        var oldValue:Matrix = matrix;
        
        var oldX:Number = x;
        var oldY:Number = y;
        var oldRotation:Number = rotation;
        var oldScaleX:Number = scaleX;
        var oldScaleY:Number = scaleY;
        
        if (value == null)
        {
            compoundTransform = null;
        }   
        else
        {
            // Create the transform if none exists. 
            if (compoundTransform == null)
                compoundTransform = new CompoundTransform();
            compoundTransform.matrix = value; // CompoundTransform will create a clone
            
            dispatchFillChangedEvent("x", oldX, compoundTransform.x);
            dispatchFillChangedEvent("y", oldY, compoundTransform.y);
            dispatchFillChangedEvent("scaleX", oldScaleX, compoundTransform.scaleX);
            dispatchFillChangedEvent("scaleY", oldScaleY, compoundTransform.scaleY);
            dispatchFillChangedEvent("rotation", oldRotation, compoundTransform.rotationZ);
        }
    }
    
    //----------------------------------
    //  originX
    //----------------------------------

    private var _originX:Number = 0;

    [Bindable("propertyChange")]
    [Inspectable(category="General")]   
    [Deprecated(replacement="transformX", since="4.0")]
    
    /**
     *  The horizontal origin for the bitmap fill.
     *  The bitmap fill is offset so that this point appears at the origin.
     *  Scaling and rotation of the bitmap are performed around this point.
     *
     *  @default 0 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get originX():Number
    {
        return transformX;
    }
    
    public function set originX(value:Number):void
    {
        transformX = value;
    }
    
    //----------------------------------
    //  originY
    //----------------------------------

    private var _originY:Number = 0;

    [Bindable("propertyChange")]
    [Inspectable(category="General")]   
    [Deprecated(replacement="transformY", since="4.0")]
    
    /**
     *  The vertical origin for the bitmap fill.
     *  The bitmap fill is offset so that this point appears at the origin.
     *  Scaling and rotation of the bitmap are performed around this point.
     *
     *  @default 0 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get originY():Number
    {
        return transformY;
    }
    
    public function set originY(value:Number):void
    {
        transformY = value;
    }

    //----------------------------------
    //  offsetX
    //----------------------------------

    [Bindable("propertyChange")]
    [Inspectable(category="General")]   
    [Deprecated(replacement="x", since="4.0")]
    
    /**
     *  How far the bitmap is horizontally offset from the origin.
     *  This adjustment is performed after rotation and scaling.
     *
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get offsetX():Number
    {
        return isNaN(x) ? 0 : x;
    }
    
    public function set offsetX(value:Number):void
    {
        var oldValue:Number = isNaN(x) ? 0 : x; // Avoid warning since the offsetY getter is deprecated
        x = value;
        dispatchFillChangedEvent("offsetX", oldValue, value);
    }

    //----------------------------------
    //  offsetY
    //----------------------------------

    [Bindable("propertyChange")]
    [Inspectable(category="General")]   
    [Deprecated(replacement="y", since="4.0")]
    
    /**
     *  How far the bitmap is vertically offset from the origin.
     *  This adjustment is performed after rotation and scaling.
     *
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get offsetY():Number
    {
        return isNaN(y) ? 0 : y;
    }
    
    public function set offsetY(value:Number):void
    {
        var oldValue:Number = isNaN(y) ? 0 : y; // Avoid warning since the offsetY getter is deprecated
        y = value;
        dispatchFillChangedEvent("offsetY", oldValue, value);
    }

    //----------------------------------
    //  repeat
    //----------------------------------

    [Bindable("propertyChange")]
    [Inspectable(category="General")]

    [Deprecated(replacement="fillMode", since="4.0")]
    
    /**
     *  Whether the bitmap is repeated to fill the area.
     *  Set to <code>true</code> to cause the fill to tile outward
     *  to the edges of the filled region.
     *  Set to <code>false</code> to end the fill at the edge of the region.
     *
     *  @default true
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get repeat():Boolean
    {
        return _fillMode == BitmapFillMode.REPEAT; 
    }
    
    public function set repeat(value:Boolean):void
    {
        var oldValue:Boolean = (_fillMode == BitmapFillMode.REPEAT);  
        if (value != oldValue)
        {
            //Setting repeat just sets fillMode to repeat 
            fillMode = value ? BitmapFillMode.REPEAT : BitmapFillMode.SCALE; 
            dispatchFillChangedEvent("repeat", oldValue, value);
        }
    }
    
    //----------------------------------
    //  fillMode
    //----------------------------------

    /**
     *  @private
     */
    protected var _fillMode:String = BitmapFillMode.SCALE;
    
    [Inspectable(category="General", enumeration="clip,repeat,scale", defaultValue="scale")]
    
    /**
     *  Determines how the bitmap fills in the dimensions. If you set the value
     *  of this property in a tag, use the string (such as "repeat"). If you set the value of 
     *  this property in ActionScript, use the constant (such as <code>BitmapFillMode.CLIP</code>).
     * 
     *  When set to <code>BitmapFillMode.CLIP</code> ("clip"), the bitmap
     *  ends at the edge of the region.
     * 
     *  When set to <code>BitmapFillMode.REPEAT</code> ("repeat"), the bitmap 
     *  repeats to fill the region.
     *
     *  When set to <code>BitmapFillMode.SCALE</code> ("scale"), the bitmap
     *  stretches to fill the region.
     * 
     *  @default <code>BitmapFillMode.SCALE</code>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get fillMode():String 
    {
        return _fillMode; 
    }
    
    /**
     *  @private
     */
    public function set fillMode(value:String):void
    {
        var oldValue:String = _fillMode; 
        if (value != _fillMode)
        {
            _fillMode = value;
            dispatchFillChangedEvent("fillMode", oldValue, value);
        }
    }

    //----------------------------------
    //  rotation
    //----------------------------------
    
    private var _rotation:Number = 0;

    [Bindable("propertyChange")]
    [Inspectable(category="General")]   
    
    /**
     *  The number of degrees to rotate the bitmap.
     *  Valid values range from 0.0 to 360.0.
     *  
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get rotation():Number
    {
        return compoundTransform ? compoundTransform.rotationZ : _rotation;
    }
    
    public function set rotation(value:Number):void
    {      
        if (value != rotation)
        {
            var oldValue:Number = rotation;
            
            if (compoundTransform)
                compoundTransform.rotationZ = value;
            else
                _rotation = value;   
            dispatchFillChangedEvent("rotation", oldValue, value);
        }
    }

    //----------------------------------
    //  scaleX
    //----------------------------------
    
    private var _scaleX:Number;
    
    [Bindable("propertyChange")]
    [Inspectable(category="General")]   
    
    /**
     *  The percent to horizontally scale the bitmap when filling,
     *  from 0.0 to 1.0.
     *  If 1.0, the bitmap is filled at its natural size.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get scaleX():Number
    {
        return compoundTransform ? compoundTransform.scaleX : _scaleX;
    }
    
    /**
     *  @private
     */  
    public function set scaleX(value:Number):void
    {
        if (value != scaleX)
        {
            var oldValue:Number = scaleX;

            if (compoundTransform)
            {
                // If we have a compoundTransform, only non-NaN values are allowed
                if (!isNaN(value))
                    compoundTransform.scaleX = value;
            }
            else
            {
                _scaleX = value;
            }
            dispatchFillChangedEvent("scaleX", oldValue, value);
        }
    }

    //----------------------------------
    //  scaleY
    //----------------------------------
    
    private var _scaleY:Number;
    
    [Bindable("propertyChange")]
    [Inspectable(category="General")]   
    
    /**
     *  The percent to vertically scale the bitmap when filling,
     *  from 0.0 to 1.0.
     *  If 1.0, the bitmap is filled at its natural size.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get scaleY():Number
    {
        return compoundTransform ? compoundTransform.scaleY : _scaleY;
    }
    
    /**
     *  @private
     */ 
    public function set scaleY(value:Number):void
    {
        if (value != scaleY)
        {
            var oldValue:Number = scaleY;
            
            if (compoundTransform)
            {
                // If we have a compoundTransform, only non-NaN values are allowed
                if (!isNaN(value))
                    compoundTransform.scaleY = value;
            }
            else
            {
                _scaleY = value;
            }
            dispatchFillChangedEvent("scaleY", oldValue, value);
        }
    }

    //----------------------------------
    //  source
    //----------------------------------

    private var _source:Object;

    [Inspectable(category="General")]

    /**
     *  The source used for the bitmap fill.
     *  The fill can render from various graphical sources,
     *  including the following: 
     *  <ul>
     *   <li>A Bitmap or BitmapData instance.</li>
     *   <li>A class representing a subclass of DisplayObject.
     *   The BitmapFill instantiates the class
     *   and creates a bitmap rendering of it.</li>
     *   <li>An instance of a DisplayObject.
     *   The BitmapFill copies it into a Bitmap for filling.</li>
     *  </ul>
     *
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get source():Object 
    {
        return _source;
    }
    
    /**
     *  @private
     */
    public function set source(value:Object):void
    {
        if (value != _source)
        {
            var tmpSprite:DisplayObject;
            var oldValue:Object = _source;
            _source = value;
            
            var bitmapData:BitmapData;    
            var bitmapCreated:Boolean = false; 
            
            if (value is Class)
            {
                var cls:Class = Class(value);
                value = new cls();
                bitmapCreated = true;
            } 
            
            if (value is BitmapData)
            {
                bitmapData = BitmapData(value);
            }
            else if (value is Bitmap)
            {
                bitmapData = value.bitmapData;
            }
            else if (value is DisplayObject)
            {
                tmpSprite = value as DisplayObject;
            }
            else if (value == null)
            {
                // This will set source to null
            }
            else
            {
                return;
            }
                
            if (!bitmapData && tmpSprite)
            {
                bitmapData = new BitmapData(tmpSprite.width, tmpSprite.height, true, 0);
                bitmapData.draw(tmpSprite, new Matrix());
                bitmapCreated = true;
            }
            
            // If the bitmapData isn't transparent (ex. JPEG) and alpha != 1, 
            // then copy it into a transparent bitmapData
            if (bitmapData && !bitmapData.transparent && alpha != 1)
            {
                var transparentBitmap:BitmapData = new BitmapData(bitmapData.width, bitmapData.height, true);
                transparentBitmap.draw(bitmapData);
                bitmapCreated = true;
                bitmapData = transparentBitmap;
            }
            
            setBitmapData(bitmapData, bitmapCreated);
                        
            dispatchFillChangedEvent("source", oldValue, value);
        }
    }

    //----------------------------------
    //  smooth
    //----------------------------------

    private var _smooth:Boolean = false;
    
    [Inspectable(category="General")]
    [Bindable("propertyChange")]    
    
    /**
     *  A flag indicating whether to smooth the bitmap data
     *  when filling with it.
     *
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get smooth():Boolean
    {
        return _smooth;
    }
    
    public function set smooth(value:Boolean):void
    {
        var oldValue:Boolean = _smooth;
        if (value != oldValue)
        {
            _smooth = value;
            dispatchFillChangedEvent("smooth", oldValue, value);
        }
    }
    
    //----------------------------------
    //  transformX
    //----------------------------------
    
    private var _transformX:Number = 0;
    
    [Inspectable(category="General")]

    /**
     *  The x position transform point of the fill.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get transformX():Number
    {
        return compoundTransform ? compoundTransform.transformX : _transformX;
    }

    /**
     *  @private
     */
    public function set transformX(value:Number):void
    {
        if (transformX == value)
            return;
                
        var oldValue:Number = transformX;   
        
        if (compoundTransform)
            compoundTransform.transformX = value;
        else
            _transformX = value;
        
        dispatchFillChangedEvent("transformX", oldValue, value);
    }

    //----------------------------------
    //  transformY
    //----------------------------------
    
    private var _transformY:Number = 0;
    
    [Inspectable(category="General")]

    /**
     *  The y position transform point of the fill.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get transformY():Number
    {
        return compoundTransform ? compoundTransform.transformY : _transformY;
    }

    /**
     *  @private
     */
    public function set transformY(value:Number):void
    {
        if (transformY == value)
            return;
        
        var oldValue:Number = transformY;    
        
        if (compoundTransform)
            compoundTransform.transformY = value;
        else
            _transformY = value;
        
        dispatchFillChangedEvent("transformY", oldValue, value);
    }

    
    //----------------------------------
    //  x
    //----------------------------------
    
    private var _x:Number;
    
    [Bindable("propertyChange")]
    [Inspectable(category="General")]
    
    /**
     *  The distance by which to translate each point along the x axis.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get x():Number
    {
        return compoundTransform ? compoundTransform.x : _x;
    }
    
    /**
     *  @private
     */
    public function set x(value:Number):void
    {
        var oldValue:Number = x;
        if (value != oldValue)
        {
            if (compoundTransform)
            {
                // If we have a compoundTransform, only non-NaN values are allowed
                if (!isNaN(value))
                    compoundTransform.x = value; 
            }
            else
            {
                _x = value;
            }
            dispatchFillChangedEvent("x", oldValue, value);
        }
    }
    
    //----------------------------------
    //  y
    //----------------------------------
    
    private var _y:Number;
    
    [Bindable("propertyChange")]
    [Inspectable(category="General")]
    
    /**
     *  The distance by which to translate each point along the y axis.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get y():Number
    {
        return compoundTransform ? compoundTransform.y : _y;
    }
    
    /**
     *  @private
     */
    public function set y(value:Number):void
    {
        var oldValue:Number = y;
        if (value != oldValue)
        {
            if (compoundTransform)
            {
                // If we have a compoundTransform, only non-NaN values are allowed
                if (!isNaN(value))
                    compoundTransform.y = value;
            }
            else
            {
                _y = value;                
            }
            
            dispatchFillChangedEvent("y", oldValue, value);
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    public function begin(target:Graphics, targetBounds:Rectangle, targetOrigin:Point):void
    {       
        var sourceAsBitmapData:BitmapData = _bitmapData;
        
        if (!sourceAsBitmapData)
            return;        
        
        var repeatFill:Boolean = (fillMode == BitmapFillMode.REPEAT); 
        
        // If we need to apply the alpha, we need to make another clone. So dispose of the old one.
        if (nonRepeatAlphaSource && applyAlphaMultiplier)
        {
            nonRepeatAlphaSource.dispose();
            nonRepeatAlphaSource = null;
        }

        if (compoundTransform)
        {
            transformMatrix = compoundTransform.matrix;
            transformMatrix.translate(targetOrigin.x, targetOrigin.y);
        }
        else
        {
            // Calculate default scaleX, scaleY
            var defaultScaleX:Number = scaleX;
            var defaultScaleY:Number = scaleY;

            // If fillMode is scale then scale to fill the content area  
            if (fillMode == BitmapFillMode.SCALE)
            {
                // calculate defaultScaleX only if explicit scaleX is not specified
                if (isNaN(scaleX) && sourceAsBitmapData.width > 0)
                    defaultScaleX = targetBounds.width / sourceAsBitmapData.width;
                
                // calculate defaultScaleY if it's not already specified
                if (isNaN(scaleY) && sourceAsBitmapData.height > 0)
                    defaultScaleY = targetBounds.height / sourceAsBitmapData.height;
            }

            if (isNaN(defaultScaleX))
                defaultScaleX = 1;
            if (isNaN(defaultScaleY))
                defaultScaleY = 1;

            // Calculate default x, y
            var regX:Number =  !isNaN(x) ? x + targetOrigin.x : targetBounds.left;
            var regY:Number =  !isNaN(y) ? y + targetOrigin.y : targetBounds.top;

            transformMatrix.identity();
            transformMatrix.translate(-transformX, -transformY);
            transformMatrix.scale(defaultScaleX, defaultScaleY);
            transformMatrix.rotate(rotation * RADIANS_PER_DEGREES);
            transformMatrix.translate(regX + transformX, regY + transformY);
        }

        // If repeat is true, fillMode is repeat, or if the source bitmap size  
        // equals or exceeds the targetBounds, just use the source bitmap
        if (repeatFill || 
            (MatrixUtil.isDeltaIdentity(transformMatrix) && 
             transformMatrix.tx == targetBounds.left &&
             transformMatrix.ty == targetBounds.top &&
             targetBounds.width <= sourceAsBitmapData.width && 
             targetBounds.height <= sourceAsBitmapData.height))
        {
            if (nonRepeatAlphaSource && nonRepeatSourceCreated)
            {
                nonRepeatAlphaSource.dispose();
                nonRepeatAlphaSource = null;
                applyAlphaMultiplier = alpha != 1;
            }
            
            nonRepeatSourceCreated = false;
        }
        else if (fillMode == BitmapFillMode.CLIP)
        {
            // Regenerate the nonRepeatSource if it wasn't previously created or if the bounds 
            // dimensions have changed.
            if (regenerateNonRepeatSource || 
                lastBoundsWidth != targetBounds.width || 
                lastBoundsHeight != targetBounds.height)
            {
                // Release the old bitmap data
                if (nonRepeatAlphaSource)
                    nonRepeatAlphaSource.dispose();
                
                var bitmapTopLeft:Point = new Point();
                // We want the top left corner of the bitmap to be at (0,0) when we copy it. 
                // Save the translation and reapply it after the we have copied the bitmap
                var tx:Number = transformMatrix.tx;
                var ty:Number = transformMatrix.ty; 
                
                transformMatrix.tx = 0;
                transformMatrix.ty = 0;
                
                // Get the bounds of the transformed bitmap (minus translation)
                var bitmapSize:Point = MatrixUtil.transformBounds(
                                        sourceAsBitmapData.width, sourceAsBitmapData.height, 
                                        transformMatrix, 
                                        bitmapTopLeft);
                
                // Get the size of the bitmap using the bounds              
                // Pad the new bitmap size so that the borders are empty
                var newW:Number = Math.ceil(bitmapSize.x) + 2;
                var newY:Number = Math.ceil(bitmapSize.y) + 2;
      
                // Translate a rotated bitmap to ensure that the top left post-transformed corner is at (1,1)
                transformMatrix.translate(1 - bitmapTopLeft.x, 1 - bitmapTopLeft.y);
                
                // Draw the transformed bitmapData into a new bitmapData that is the size of the bounds
                // This will prevent the edge pixels getting repeated to fill the empty space
                nonRepeatAlphaSource = new BitmapData(newW, newY, true, 0xFFFFFF);
                nonRepeatAlphaSource.draw(sourceAsBitmapData, transformMatrix, null, null, null, smooth);
                
                // The transform matrix has already been applied to the source, so just use identity
                // for the beginBitmapFill call
                transformMatrix.identity();
                // We need to restore both the matrix translation and the rotation translation
                transformMatrix.translate(tx + bitmapTopLeft.x - 1, ty + bitmapTopLeft.y - 1);
                // Save off the bounds so we can compare it the next time this function is called
                lastBoundsWidth = targetBounds.width;
                lastBoundsHeight = targetBounds.height;
                
                nonRepeatSourceCreated = true;
                
                // Reapply the alpha if alpha is not 1.
                applyAlphaMultiplier = alpha != 1;
            }   
        }
        
        // Apply the alpha to a clone of the source. We don't want to modify the actual source because applying the alpha 
        // will modify the source and we have no way to restore the source back its original alpha value. 
        if (applyAlphaMultiplier)
        {
            // Clone the bitmapData if we didn't already make a copy for CLIP mode
            if (!nonRepeatAlphaSource)
                nonRepeatAlphaSource = sourceAsBitmapData.clone();
            
            var ct:ColorTransform = new ColorTransform();
            ct.alphaMultiplier = alpha;
            
            nonRepeatAlphaSource.colorTransform(new Rectangle(0, 0, nonRepeatAlphaSource.width, nonRepeatAlphaSource.height), ct);
            applyAlphaMultiplier = false;
        }
        
        // If we have a nonRepeatAlphaSource, then use it. Otherwise, we just use the source. 
        if (nonRepeatAlphaSource)
            sourceAsBitmapData = nonRepeatAlphaSource;
        
        target.beginBitmapFill(sourceAsBitmapData, transformMatrix, repeatFill, smooth);
    }
    
    /**
     *  @private
     */
    public function end(target:Graphics):void
    {
        target.endFill();
    }
    
    /**
     *  @private
     */
    private function dispatchFillChangedEvent(prop:String, oldValue:*,
                                              value:*):void
    {
        dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, prop,
                                                            oldValue, value));
        regenerateNonRepeatSource = true;
    }
    
    /**
     *  @private
     *  Utility function that sets the underlying bitmapData property.
     */
    private function setBitmapData(bitmapData:BitmapData, internallyCreated:Boolean = false):void
    {         
        // Clear previous bitmapData
        if (_bitmapData)
        {
            if (bitmapDataCreated) // Dispose the bitmap if we created it
                _bitmapData.dispose();
            _bitmapData = null;
        }
        
        bitmapDataCreated = internallyCreated;         
        applyAlphaMultiplier = alpha != 1;
        _bitmapData = bitmapData;
        
        dispatchFillChangedEvent("bitmapData", null, null);
    }
}

}
