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

package org.apache.royale.graphics
{
    import org.apache.royale.geom.Point;
    import org.apache.royale.geom.Rectangle;
    import org.apache.royale.utils.CSSUtils;

    COMPILE::SWF
    {
        import flash.display.CapsStyle;
        import flash.display.Graphics;
        import flash.display.JointStyle;
    }

    public class SolidColorStroke implements IStroke
    {
        public function SolidColorStroke(color:uint = 0x000000,weight:Number = 1, alpha:Number = 1.0)
        {
            _color = isNaN(color) ? 0 : color;
            _weight = isNaN(weight) ? 1 : weight;
            _alpha = isNaN(alpha) ? 1 : alpha;
            COMPILE::SWF
            {
                _lineCap = "none";
            }

            COMPILE::JS
            {
                _lineCap = "butt";
            }
        }
        //----------------------------------
        //  alpha
        //----------------------------------
        private var _alpha:Number = 1.0;
        
        //----------------------------------
        //  color
        //----------------------------------
        private var _color:uint = 0x000000;
        
        //----------------------------------
        //  weight
        //----------------------------------
        private var _weight:Number = 1;
        
        /**
         *  The transparency of a color.
         *  Possible values are 0.0 (invisible) through 1.0 (opaque). 
         *  
         *  @default 1.0
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.3
         */
        public function get alpha():Number
        {
            return _alpha;
        }
        
        public function set alpha(value:Number):void
        {
            var oldValue:Number = _alpha;
            if (value != oldValue)
            {
                _alpha = value;
            }
        }
        
        /**
         *  A color value. 
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Royale 0.3
         */
        public function get color():uint
        {
            return _color;
        }
        
        public function set color(value:uint):void
        {
			if(value < 0 || value > 0xffffff)
				throw new Error("Color values must be between 0 and 0xFFFFFF");
			
            var oldValue:uint = _color;
            if (value != oldValue)
            {
                _color = value;
            }
        }

        public function get weight():Number
        {
            return _weight;
        }

        /**
         *  A color value. 
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Royale 0.3
         */
        public function set weight(value:Number):void
        {
            _weight = value;
        }
        
        COMPILE::SWF
        public function apply(g:Graphics, targetBounds:Rectangle = null, targetOrigin:Point = null):void
        {
            g.lineStyle(weight,color,alpha,false,"normal",CapsStyle.SQUARE,JointStyle.MITER);
        }
        
        /**
         * addStrokeAttrib()
         * 
         * @param value The IGraphicShape object on which the stroke must be added.
         * @return {string}
         */
        COMPILE::JS
        public function addStrokeAttrib(value:IGraphicShape):String
        {
            var att:Array = [
                'stroke:' + CSSUtils.attributeFromColor(color),
                'stroke-width:' + weight,
                'stroke-opacity:' + alpha,
                'stroke-linecap:' + lineCap,
                'stroke-linejoin:' + lineJoin,
                'stroke-miterlimit:' + miterLimit
            ];
            if(lineDash && lineDash.length)
                att.push('stroke-dasharray:' + lineDash.join(","));
            return att.join(";");
        };

        private var _lineCap:String;
        /**
         *  The cap type on line segments.
         *  Possible values are butt round and square. 
         *  
         *  @default butt
         *
         *  @see org.apache.royale.graphics.LineStyle
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.3
         */        
        public function get lineCap():String
        {
            return _lineCap;
        }
        public function set lineCap(val:String):void
        {
            COMPILE::SWF
            {
                switch(val)
                {
                    case "butt":
                        _lineCap = "none";
                        break;
                    default:
                        _lineCap = val;
                        break;
                }
            }
            COMPILE::JS
            {
                _lineCap = val;
            }

        }
        private var _lineJoin:String = "miter";

        /**
         *  The join type of two segments.
         *  Possible values are miter round and bevel. 
         *  
         *  @default miter
         *
         *  @see org.apache.royale.graphics.LineStyle
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.7
         */        
        public function get lineJoin():String
        {
            return _lineJoin;
        }
        public function set lineJoin(val:String):void
        {
            _lineJoin = val;
        }
        private var _miterLimit:Number = 4;
        /**
         *  The miter limit at the join of two segments.
         *  
         *  @default 4
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.7
         */        
        public function get miterLimit():Number
        {
            return _miterLimit;
        }
        public function set miterLimit(val:Number):void
        {
            _miterLimit = val;
        }

        private var _lineDash:Array;
        /**
         *  An array describing the pattern of line dashes.
         *  
         *  @default [none]
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.7
         */        
        public function get lineDash():Array
        {
            return _lineDash;
        }
        public function set lineDash(val:Array):void
        {
            _lineDash = val;
        }
		
		public function setLineStyle(weight:Number=NaN,color:uint=0,alpha:Number = NaN,caps:String = null, joints:String = null, miterLimit:Number = NaN):void
		{
			if(!isNaN(weight))
				_weight = weight;
			_color = color;
			if(!isNaN(alpha))
				_alpha = alpha;
			if(caps)
				_lineCap = caps;
			if(joints)
				_lineJoin = joints;
			if(!isNaN(miterLimit))
				_miterLimit = miterLimit;
		}

    }
}
