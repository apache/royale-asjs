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
//import flash.filters.ColorMatrixFilter;
import mx.filters.BaseFilter;
import mx.filters.IBitmapFilter;
/**
 *  The ColorMatrixFilter class lets you apply a 4 x 5 matrix transformation on the 
 *  RGBA color and alpha values of every pixel in the input image to produce a result 
 *  with a new set of RGBA color and alpha values. It allows saturation changes, hue 
 *  rotation, luminance to alpha, and various other effects. You can apply the filter 
 *  to any display object (that is, objects that inherit from the DisplayObject class), 
 *  such as MovieClip, SimpleButton, TextField, and Video objects, as well as to 
 *  BitmapData objects.
 * 
 *  @mxml 
 *  <p>The <code>&lt;s:ColorMatrixFilter&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;s:ColorMatrixFilter
 *    <strong>Properties</strong>
 *    matrix="[1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0]"
 *  /&gt;
 *  </pre>
 * 
 *  @see flash.filters.ColorMatrixFilter
 * 
 *  @includeExample examples/ColorMatrixFilterExample.mxml
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public class ColorMatrixFilter extends BaseFilter implements IBitmapFilter
{
    /**
     * Constructor.
     *
     * @tiptext Initializes a new ColorMatrixFilter instance.
     *
     * @param matrix An array of 20 items arranged as a 4 x 5 matrix.
     *
     * @langversion 3.0
     * @playerversion Flash 10
     * @playerversion AIR 1.5
     * @productversion Flex 4
     */
    
    public function ColorMatrixFilter(matrix:Array = null)
    {
        super();
        
        if (matrix != null)
        {
            this.matrix = matrix;
        } 
    }
    
    //----------------------------------
    //  matrix
    //----------------------------------
    
    private var _matrix:Array =  [1,0,0,0,0,0,
                                  1,0,0,0,0,0,
                                  1,0,0,0,0,0,
                                  1,0];
    
    /**
     *  A comma delimited list of 20 doubles that comprise a 4x5 matrix applied to the 
     *  rendered element.  The matrix is in row major order -- that is, the first five 
     *  elements are multipled by the vector [srcR,srcG,srcB,srcA,1] to determine the 
     *  output red value, the second five determine the output green value, etc.
     * 
     *  <p>The value must either be an array or comma delimited string of 20 numbers. </p>
     *
     *  @default [1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0]
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get matrix():Object
    {
        return _matrix;
    }
    
    public function set matrix(value:Object):void
    {
        if (value != _matrix)
        {
            if (value is Array)
            {
                _matrix = value as Array;
            }
            else if (value is String)
            {
                _matrix = String(value).split(',');
            }
            
            notifyFilterChanged();
        }
    }
    
    /**
     * Returns a copy of this filter object.
     *
     * @return A new ColorMatrixFilter instance with all of the same
     * properties as the original one.
     *
     * @langversion 3.0
     * @playerversion Flash 10
     * @playerversion AIR 1.5
     * @productversion Flex 4
     */
    
    public function clone():Object
    {
        //return new flash.filters.ColorMatrixFilter(_matrix);
	return null;
    }
    
}
}
