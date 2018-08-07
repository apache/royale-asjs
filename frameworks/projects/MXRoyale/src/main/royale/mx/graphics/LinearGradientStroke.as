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
 
/* import flash.display.GradientType;
import flash.display.Graphics;
import flash.display.GraphicsGradientFill;
import flash.display.GraphicsStroke;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
 */
// import org.apache.royale.graphics.GradientBase;
import mx.core.mx_internal;
import mx.graphics.SolidColorStroke;

use namespace mx_internal; 
/**
 *  The LinearGradientStroke class lets you specify a gradient filled stroke.
 *  You use the LinearGradientStroke class, along with the GradientEntry class,
 *  to define a gradient stroke.
 *  
 *  @see mx.graphics.Stroke
 *  @see mx.graphics.GradientEntry
 *  @see mx.graphics.RadialGradient 
 *  @see flash.display.Graphics
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class LinearGradientStroke extends SolidColorStroke
{	/* extends GradientStroke */
    //include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  @param weight Specifies the line weight, in pixels.
     *  This parameter is optional,
     *  with a default value of <code>1</code>. 
     *
     *  @param pixelHinting A Boolean value that specifies
     *  whether to hint strokes to full pixels.
     *  This affects both the position of anchors of a curve
     *  and the line stroke size itself.
     *  With <code>pixelHinting</code> set to <code>true</code>,
     *  Flash Player and AIR hint line widths to full pixel widths.
     *  With <code>pixelHinting</code> set to <code>false</code>,
     *  disjoints can  appear for curves and straight lines. 
     *  This parameter is optional,
     *  with a default value of <code>false</code>. 
     *
     *  @param scaleMode A value from the LineScaleMode class
     *  that specifies which scale mode to use.
     *  Valid values are <code>LineScaleMode.HORIZONTAL</code>,
     *  <code>LineScaleMode.NONE</code>, <code>LineScaleMode.NORMAL</code>,
     *  and <code>LineScaleMode.VERTICAL</code>.
     *  This parameter is optional,
     *  with a default value of <code>LineScaleMode.NONE</code>. 
     *
     *  @param caps A value from the CapsStyle class
     *  that specifies the type of caps at the end of lines.
     *  Valid values are <code>CapsStyle.NONE</code>,
     *  <code>CapsStyle.ROUND</code>, and <code>CapsStyle.SQUARE</code>.
     *  A <code>null</code> value is equivalent to
     *  <code>CapsStyle.ROUND</code>.
     *  This parameter is optional,
     *  with a default value of <code>CapsStyle.ROUND</code>. 
     *
     *  @param joints A value from the JointStyle class
     *  that specifies the type of joint appearance used at angles.
     *  Valid values are <code>JointStyle.BEVEL</code>,
     *  <code>JointStyle.MITER</code>, and <code>JointStyle.ROUND</code>.
     *  A <code>null</code> value is equivalent to
     *  <code>JointStyle.ROUND</code>.
     *  This parameter is optional,
     *  with a default value of <code>JointStyle.ROUND</code>. 
     *
     *  @param miterLimit A number that indicates the limit
     *  at which a miter is cut off. 
     *  Valid values range from 1 to 255
     *  (and values outside of that range are rounded to 1 or 255). 
     *  This value is only used if the <code>jointStyle</code> property 
     *  is set to <code>miter</code>.
     *  The <code>miterLimit</code> value represents the length that a miter
     *  can extend beyond the point at which the lines meet to form a joint.
     *  The value expresses a factor of the line <code>thickness</code>.
     *  For example, with a <code>miterLimit</code> factor of 2.5 and a 
     *  <code>thickness</code> of 10 pixels, the miter is cut off at 25 pixels. 
     *  This parameter is optional,
     *  with a default value of <code>3</code>.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function LinearGradientStroke(weight:Number = 1,
                                         pixelHinting:Boolean = false,
                                         scaleMode:String = "normal",
                                         caps:String = "round",
                                         joints:String = "round",
                                         miterLimit:Number = 3)
    {
       // super(weight, pixelHinting, scaleMode, caps, joints, miterLimit);
    }

	
	
	
    /**
     *  @private
     */
   // private static var commonMatrix:Matrix = new Matrix();
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
	
	
	
    //----------------------------------
    //  rotation
    //----------------------------------
    public function get rotation():Number
	{
	return 0;
	}
    public function set rotation(value:Number):void
	{
	}
    //----------------------------------
    //  matrix
    //----------------------------------
    
    /**
     *  @private
     */
   /*  override public function set matrix(value:Matrix):void
    {
        scaleX = NaN;
        super.matrix = value;
    } */

    //----------------------------------
    //  scaleX
    //----------------------------------
    
  /*   private var _scaleX:Number;
    
    [Bindable("propertyChange")]
    [Inspectable(category="General")]
     */
    /**
     *  The horizontal scale of the gradient transform, which defines the width of the (unrotated) gradient
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
   /*  public function get scaleX():Number
    {
        return compoundTransform ? compoundTransform.scaleX : _scaleX;
    } */
    
    /**
     *  @private
     */
   /*  public function set scaleX(value:Number):void
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
            dispatchGradientChangedEvent("scaleX", oldValue, value);
        }
    }    */  
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
   /*  override public function apply(graphics:Graphics, targetBounds:Rectangle, targetOrigin:Point):void
    {
        commonMatrix.identity();
        
        graphics.lineStyle(weight, 0, 1, pixelHinting, scaleMode,
                    caps, joints, miterLimit);
        
        if (targetBounds)
            calculateTransformationMatrix(targetBounds, commonMatrix, targetOrigin); 
        
        graphics.lineGradientStyle(GradientType.LINEAR, colors,
                            alphas, ratios,
                            commonMatrix, spreadMethod,
                            interpolationMethod);                        
    } */
    
    /**
     *  @private
     */
   /*  override public function createGraphicsStroke(targetBounds:Rectangle, targetOrigin:Point):GraphicsStroke
    {
        // The parent class sets the gradient stroke properties common to 
        // LinearGradientStroke and RadialGradientStroke 
        var graphicsStroke:GraphicsStroke = super.createGraphicsStroke(targetBounds, targetOrigin); 
        
        if (graphicsStroke)
        {
            // Set other properties specific to this LinearGradientStroke  
            GraphicsGradientFill(graphicsStroke.fill).type = GradientType.LINEAR; 
            calculateTransformationMatrix(targetBounds, commonMatrix, targetOrigin);
            GraphicsGradientFill(graphicsStroke.fill).matrix = commonMatrix; 
        }
        
        return graphicsStroke; 
    } */
    
    /**
     *  @private
     *  Calculates this LinearGradientStroke's transformation matrix.  
     */
    /* private function calculateTransformationMatrix(targetBounds:Rectangle, matrix:Matrix, targetOrigin:Point):void
    {        
        matrix.identity();
        
        if (!compoundTransform)
        {
            var tx:Number = x;
            var ty:Number = y;
            var length:Number = scaleX;
            
            if (isNaN(length))
            {
                // Figure out the two sides
                if (rotation % 90 != 0)
                {           
                    // Normalize angles with absolute value > 360 
                    var normalizedAngle:Number = rotation % 360;
                    // Normalize negative angles
                    if (normalizedAngle < 0)
                        normalizedAngle += 360;
                    
                    // Angles wrap at 180
                    normalizedAngle %= 180;
                    
                    // Angles > 90 get mirrored
                    if (normalizedAngle > 90)
                        normalizedAngle = 180 - normalizedAngle;
                    
                    var side:Number = targetBounds.width;
                    // Get the hypotenuse of the largest triangle that can fit in the bounds
                    var hypotenuse:Number = Math.sqrt(targetBounds.width * targetBounds.width + targetBounds.height * targetBounds.height);
                    // Get the angle of that largest triangle
                    var hypotenuseAngle:Number =  Math.acos(targetBounds.width / hypotenuse) * 180 / Math.PI;
                    
                    // If the angle is larger than the hypotenuse angle, then use the height 
                    // as the adjacent side of the triangle
                    if (normalizedAngle > hypotenuseAngle)
                    {
                        normalizedAngle = 90 - normalizedAngle;
                        side = targetBounds.height;
                    }
                    
                    // Solve for the hypotenuse given an adjacent side and an angle. 
                    length = side / Math.cos(normalizedAngle / 180 * Math.PI);
                }
                else 
                {
                    // Use either width or height based on the rotation
                    length = (rotation % 180) == 0 ? targetBounds.width : targetBounds.height;
                }
            }
            
            // If only x or y is defined, force the other to be set to 0
            if (!isNaN(tx) && isNaN(ty))
                ty = 0;
            else if (isNaN(tx) && !isNaN(ty))
                tx = 0;
            
            // If x and y are specified, then move the gradient so that the
            // top left corner is at 0,0
            if (!isNaN(tx) && !isNaN(ty))
                matrix.translate(GRADIENT_DIMENSION / 2, GRADIENT_DIMENSION / 2); // 1638.4 / 2
            
            // Force the length to a absolute minimum of 2. Values of 0, 1, or -1 have undesired behavior   
            if (length >= 0 && length < 2)
                length = 2;
            else if (length < 0 && length > -2)
                length = -2;
            
            // Scale the gradient in the x direction. The natural size is 1638.4px. No need
            // to scale the y direction because it is infinite
            matrix.scale (length / GRADIENT_DIMENSION, 1 / GRADIENT_DIMENSION);
            
            matrix.rotate (!isNaN(_angle) ? _angle : rotationInRadians);
            if (isNaN(tx))
                tx = targetBounds.left + targetBounds.width / 2;
            else
                tx += targetOrigin.x;
            if (isNaN(ty))
                ty = targetBounds.top + targetBounds.height / 2;
            else
                ty += targetOrigin.y;
            matrix.translate(tx, ty);   
        }
        else
        {
            matrix.translate(GRADIENT_DIMENSION / 2, GRADIENT_DIMENSION / 2);
            matrix.scale(1 / GRADIENT_DIMENSION, 1 / GRADIENT_DIMENSION);
            matrix.concat(compoundTransform.matrix);
            matrix.translate(targetOrigin.x, targetOrigin.y);
        }               
    } */
	
    
}

}
