/*
 *
 *  Licensed to the Apache Software Foundation (ASF) under one or more
 *  contributor license agreements.  See the NOTICE file distributed with
 *  this work for additional information regarding copyright ownership.
 *  The ASF licenses this file to You under the Apache License, Version 2.0
 *  (the "License"); you may not use this file except in compliance with
 *  the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.apache.royale.display
{
    /**
     * @royalesuppresspublicvarwarning
     * @royalesuppressexport
     */
    public class GraphicsStroke implements IGraphicsStroke, IGraphicsData
    {
        private static const VALID_CAPS:Array = [CapsStyle.ROUND, CapsStyle.NONE, CapsStyle.SQUARE];
        private static const VALID_JOINTS:Array = [JointStyle.ROUND, JointStyle.BEVEL, JointStyle.MITER];
        private static const VALID_SCALE_MODES:Array = [LineScaleMode.NORMAL, LineScaleMode.HORIZONTAL, LineScaleMode.NONE, LineScaleMode.VERTICAL];
        
        private var _caps:String;
        /**
         * Specifies the type of caps at the end of lines. Valid values are: CapsStyle.NONE, CapsStyle.ROUND, and CapsStyle.SQUARE. If a value is not indicated, Flash uses round caps.
         */
        public function get caps():String
        {
            return _caps ? _caps : (_caps = VALID_CAPS[0]);
        }
        
        public function set caps(value:String):void
        {
            if (VALID_CAPS.indexOf(value) != -1)
            {
                _caps = value;
            } else throw new Error('Error #2008: Parameter caps must be one of the accepted values.')
        }
        
        /**
         * Specifies the instance containing data for filling a stroke. An IGraphicsFill instance can represent a series of fill commands.
         */
        public var fill:IGraphicsFill;
        
        private var _joints:String;
        /**
         * Specifies the type of joint appearance used at angles. Valid values are: JointStyle.BEVEL, JointStyle.MITER, and JointStyle.ROUND. If a value is not indicated, Flash uses round joints.
         */
        public function get joints():String
        {
            return _joints ? _joints : (_joints = VALID_JOINTS[0]);
        }
        
        public function set joints(value:String):void
        {
            if (VALID_JOINTS.indexOf(value) != -1)
            {
                _joints = value;
            } else throw new Error('Error #2008: Parameter joints must be one of the accepted values.')
        }
        
        /**
         * Indicates the limit at which a miter is cut off. Valid values range from 1 to 255 (and values outside that range are rounded to 1 or 255).
         * This value is only used if the jointStyle is set to "miter". The miterLimit value represents the length that a miter can extend beyond the point at which the lines meet to form a joint. The value expresses a factor of the line thickness. For example, with a miterLimit factor of 2.5 and a thickness of 10 pixels, the miter is cut off at 25 pixels.
         */
        public var miterLimit:Number = 3;
        /**
         * Specifies whether to hint strokes to full pixels. This affects both the position of anchors of a curve and the line stroke size itself.
         * With pixelHinting set to true, Flash Player hints line widths to full pixel widths. With pixelHinting set to false, disjoints can appear for curves and straight lines.
         * For example, the following illustrations show how Flash Player renders two rounded rectangles that are identical,
         * except that the pixelHinting parameter used in the lineStyle() method is set differently (the images are scaled by 200%, to emphasize the difference):
         */
        public var pixelHinting:Boolean = false;
        
        private var _scaleMode:String;
        
        public function get scaleMode():String
        {
            return _scaleMode ? _scaleMode : (_scaleMode = VALID_SCALE_MODES[0]);
        }
        
        public function set scaleMode(value:String):void
        {
            if (VALID_SCALE_MODES.indexOf(value) != -1)
            {
                _scaleMode = value;
            } else throw new Error('Error #2008: Parameter scaleMode must be one of the accepted values.')
        }
        
        
        public var thickness:Number = NaN;
        
        
        public function GraphicsStroke(thickness:Number = NaN, pixelHinting:Boolean = false, scaleMode:String = "normal", caps:String = "none", joints:String = "round", miterLimit:Number = 3.0, fill:IGraphicsFill = null)
        {
            this.thickness = thickness;
            this.pixelHinting = pixelHinting;
            this.scaleMode = scaleMode;
            this.caps = caps;
            this.joints = joints;
            this.miterLimit = miterLimit;
            this.fill = fill;
        }
        
        
        COMPILE::JS
        public function apply(graphics:Graphics, element:SVGPathElement):SVGPathElement
        {
            //@todo remember that 0 ('hairline') width is not the same as zero in SVG
            //NaN thickness is equivalent to 'no' stroke
            var thickness:Number = this.thickness;
            if (isNaN(thickness))
            {
                element.setAttributeNS(null, 'stroke', 'none');
                return element;
            }
            //allow the fill the chance to spawn a new stroke target (e.g. interpolationMethod emulation in gradients)
            element = fill.applyStroke(graphics, element);
            
            if (thickness < 0) thickness = 0; //match swf (observed)
            if (thickness > 255) thickness = 255;//match swf (observed)
            if (thickness == 0)
            {
                //in swf it is 'hairline'
                element.setAttributeNS(null, 'vector-effect', 'non-scaling-stroke');
                element.setAttributeNS(null, 'stroke-width', '0.5');
            } else {
                element.setAttributeNS(null, 'stroke-width', '' + thickness);
            }
            
            //some things are only useful for actual 'path', so check first
    
            var str_val:String = caps;
            if (str_val == CapsStyle.NONE) str_val = 'butt'; //this is also the default in svg, so could avoid setting in this case.
            element.setAttributeNS(null, 'stroke-linecap', str_val);
            //stroke-linejoin default is miter
            str_val = joints;
            element.setAttributeNS(null, 'stroke-linejoin', str_val);
            if (str_val == JointStyle.MITER)
            {
                //apply miter limit
                var mVal:Number = miterLimit;
                if (mVal < 1) mVal = 1;
                if (mVal > 255) mVal = 255;
                element.setAttributeNS(null, 'stroke-miterlimit', mVal.toString());
            }
            
            str_val = scaleMode;
            if (str_val == LineScaleMode.NONE && thickness > 0)
            {
                //we can't do 'horizontal' and 'vertical' stroke scaling in svg
                element.setAttributeNS(null, 'vector-effect', 'non-scaling-stroke');
            }
            
            return element;
        }
    }
    
}


