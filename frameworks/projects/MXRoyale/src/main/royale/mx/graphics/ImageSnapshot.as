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

/*import flash.display.IBitmapDrawable;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Stage;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.system.Capabilities;
import flash.utils.ByteArray;
import flash.utils.getDefinitionByName;*/

import mx.geom.Matrix;
/*
import mx.core.IFlexDisplayObject;
import mx.core.IUIComponent;
import mx.core.UIComponent;
import mx.graphics.codec.IImageEncoder;
import mx.graphics.codec.PNGEncoder;
import mx.utils.Base64Encoder;
*/
//[RemoteClass(alias="flex.graphics.ImageSnapshot")]

/**
 *  A helper class used to capture a snapshot of any Flash component 
 *  that implements <code>flash.display.IBitmapDrawable</code>,
 *  including Flex UIComponents.
 *
 *  <p>An instance of this class can be sent as a RemoteObject
 *  to Adobe's LiveCycle Data Services to generate
 *  a PDF file of a client-side image.
 *  If you need to specify additional properties of the image
 *  beyond its <code>contentType</code>, <code>width</code>,
 *  and <code>height</code> properties, you should set name/value pairs
 *  on the <code>properties</code> object.</p>
 *
 *  <p>In earlier versions of Flex, you set these additional
 *  properties on the ImageSnapshot instance itself.
 *  This class is still dynamic in order to allow that,
 *  but in a future version of Flex it might no longer be dynamic.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public dynamic class ImageSnapshot
{
   // include "../core/Version.as";

    
    //--------------------------------------------------------------------------
    //
    //  Class methods
    // 
    //--------------------------------------------------------------------------

    /**
     *  A utility method to grab a raw snapshot of a UI component as BitmapData.
     * 
     *  @param source An object that implements the
     *    <code>flash.display.IBitmapDrawable</code> interface.
     *
     *  @param matrix A Matrix object used to scale, rotate, or translate
     *  the coordinates of the captured bitmap.
     *  If you do not want to apply a matrix transformation to the image,
     *  set this parameter to an identity matrix,
     *  created with the default new Matrix() constructor, or pass a null value.
     *
     *  @param colorTransform A ColorTransform 
     *  object that you use to adjust the color values of the bitmap. If no object 
     *  is supplied, the bitmap image's colors are not transformed. If you must pass 
     *  this parameter but you do not want to transform the image, set this parameter 
     *  to a ColorTransform object created with the default new ColorTransform() constructor.
     *
     *  @param blendMode A string value, from the flash.display.BlendMode 
     *  class, specifying the blend mode to be applied to the resulting bitmap.
     *
     *  @param clipRect A Rectangle object that defines the 
     *  area of the source object to draw. If you do not supply this value, no clipping 
     *  occurs and the entire source object is drawn.
     *
     *  @param smoothing A Boolean value that determines whether a 
     *  BitmapData object is smoothed when scaled.
     *
     *  @return A BitmapData object representing the captured snapshot or null if 
     *  the source has no visible bounds.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function captureBitmapData(
                                source:Object, matrix:Matrix = null,
                                colorTransform:Object = null,
                                blendMode:String = null,
                                clipRect:Object = null,
                                smoothing:Boolean = false):Object
    {
        var data:Object;
		trace("ImageSnapshot::captureBitmapData not implemented");

        return data;
    }

  
}

}
