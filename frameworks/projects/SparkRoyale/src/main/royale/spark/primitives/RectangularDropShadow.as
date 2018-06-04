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
    import mx.core.UIComponent;
  //  import mx.graphics.RectangularDropShadow;
    
    /**
     *  <p>This class optimizes drop shadows for the common case.
     *  If you are applying a drop shadow to a rectangularly-shaped object
     *  whose edges fall on pixel boundaries, then this class should
     *  be used instead of using a DropShadowFilter directly.</p>
     *
     *  <p>This class accepts the first four parameters that are passed
     *  to DropShadowFilter: <code>alpha</code>, <code>angle</code>,
     *  <code>color</code>, and <code>distance</code>.
     *  In addition, this class accepts the corner radii for each of the four
     *  corners of the rectangularly-shaped object that is casting a shadow.</p>
     *
     *  <p>Once those 8 values have been set,
     *  this class pre-computes the drop shadow in an offscreen Bitmap.
     *  When the <code>drawShadow()</code> method is called, pieces of the
     *  precomputed drop shadow are copied onto the passed-in Graphics object.</p>
     *  
     *  @see spark.filters.DropShadowFilter
     *  @see flash.display.DisplayObject
     *  
     *  @includeExample examples/RectangularDropShadowExample.mxml
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public class RectangularDropShadow extends UIComponent
    {
       // include "../core/Version.as";
            
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
         *  @playerversion AIR 1.1
         *  @productversion Royale 0.9.4
         */   
        public function RectangularDropShadow()
        {
            mouseEnabled = false;
            super();
        }
        
        //--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------
    
        /**
         *  @private
         */
     //   private var dropShadow:mx.graphics.RectangularDropShadow;
        
        //--------------------------------------------------------------------------
        //
        //  Properties
        //
        //--------------------------------------------------------------------------
    
        //----------------------------------
        //  alpha
        //----------------------------------
    
        /**
         *  @private
         *  Storage for the alpha property.
         */
        private var _alpha:Number = 0.4;
    
        [Inspectable]
    
        /**
         *  @copy spark.filters.DropShadowFilter#alpha
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Royale 0.9.4
         */
        override public function get alpha():Number
        {
            return _alpha;
        }
    
        /**
         *  @private
         */
        override public function set alpha(value:Number):void
        {
            if (_alpha != value)
            {
                _alpha = value;
             //   invalidateDisplayList();
            }
        }
    
        //----------------------------------
        //  angle
        //----------------------------------
    
        /**
         *  @private
         *  Storage for the angle property.
         */
        private var _angle:Number = 45.0;
    
        [Inspectable]
    
        /**
         *  @copy spark.filters.DropShadowFilter#angle
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Royale 0.9.4
         */
        public function get angle():Number
        {
            return _angle;
        }
    
        /**
         *  @private
         */
        public function set angle(value:Number):void
        {
            if (_angle != value)
            {
                _angle = value;
              //  invalidateDisplayList();
            }
        }
    
        
    
        //----------------------------------
        //  distance
        //----------------------------------
    
        /**
         *  @private
         *  Storage for the distance property.
         */
        private var _distance:Number = 4.0;
    
        [Inspectable]
    
        /**
         *  @copy flash.filters.DropShadowFilter#distance
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Royale 0.9.4
         */
        public function get distance():Number
        {
            return _distance;
        }
    
        /**
         *  @private
         */
        public function set distance(value:Number):void
        {
            if (_distance != value)
            {
                _distance = value;
               // invalidateDisplayList();
            }
        }
    
        //----------------------------------
        //  tlRadius
        //----------------------------------
    
        /**
         *  @private
         *  Storage for the tlRadius property.
         */
        private var _tlRadius:Number = 0;
    
        [Inspectable]
    
        /**
         *  The corner radius of the top left corner
         *  of the rounded rectangle that is casting the shadow.
         *  May be zero for non-rounded rectangles.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Royale 0.9.4
         */
        public function get tlRadius():Number
        {
            return _tlRadius;
        }
    
        /**
         *  @private
         */
        public function set tlRadius(value:Number):void
        {
            if (_tlRadius != value)
            {
                _tlRadius = value;
              //  invalidateDisplayList();
            }
        }
    
        //----------------------------------
        //  trRadius
        //----------------------------------
    
        /**
         *  @private
         *  Storage for the trRadius property.
         */
        private var _trRadius:Number = 0;
    
        [Inspectable]
    
        /**
         *  The corner radius of the top right corner
         *  of the rounded rectangle that is casting the shadow.
         *  May be zero for non-rounded rectangles.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Royale 0.9.4
         */
        public function get trRadius():Number
        {
            return _trRadius;
        }
    
        /**
         *  @private
         */
        public function set trRadius(value:Number):void
        {
            if (_trRadius != value)
            {
                _trRadius = value;
               // invalidateDisplayList();
            }
        }
    
        //----------------------------------
        //  blRadius
        //----------------------------------
    
        /**
         *  @private
         *  Storage for the blRadius property.
         */
        private var _blRadius:Number = 0;
    
        [Inspectable]
    
        /**
         *  The corner radius of the bottom left corner
         *  of the rounded rectangle that is casting the shadow.
         *  May be zero for non-rounded
         *  rectangles.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Royale 0.9.4
         */
        public function get blRadius():Number
        {
            return _blRadius;
        }
    
        /**
         *  @private
         */
        public function set blRadius(value:Number):void
        {
            if (_blRadius != value)
            {
                _blRadius = value;
               // invalidateDisplayList();
            }
        }
    
        //----------------------------------
        //  brRadius
        //----------------------------------
    
        /**
         *  @private
         *  Storage for the brRadius property.
         */
        private var _brRadius:Number = 0;
    
        [Inspectable]
    
        /**
         *  The corner radius of the bottom right corner
         *  of the rounded rectangle that is casting the shadow.
         *  May be zero for non-rounded rectangles.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Royale 0.9.4
         */
        public function get brRadius():Number
        {
            return _brRadius;
        }
    
        /**
         *  @private
         */
        public function set brRadius(value:Number):void
        {
            if (_brRadius != value)
            {
                _brRadius = value;
                //invalidateDisplayList();
            }
        }
    
        //----------------------------------
        //  blurX
        //----------------------------------
    
        /**
         *  @private
         *  Storage for the brRadius property.
         */
        private var _blurX:Number = 4;
    
        [Inspectable]
    
        /**
         *  The amount of horizontal blur.
         *  @default 4
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Royale 0.9.4
         */
        public function get blurX():Number
        {
            return _blurX;
        }
    
        /**
         *  @private
         */
        public function set blurX(value:Number):void
        {
            if (_blurX != value)
            {
                _blurX = value;
              //  invalidateDisplayList();
            }
        }
    
        //----------------------------------
        //  blurY
        //----------------------------------
    
        /**
         *  @private
         *  Storage for the brRadius property.
         */
        private var _blurY:Number = 4;
    
        [Inspectable]
    
        /**
         *  The amount of vertical blur.
         *  @default 4
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Royale 0.9.4
         */
        public function get blurY():Number
        {
            return _blurY;
        }
    
        /**
         *  @private
         */
        public function set blurY(value:Number):void
        {
            if (_blurY != value)
            {
                _blurY = value;
               // invalidateDisplayList();
            }
        }
    
        /**
         *  @private
         */
       /*  override protected function updateDisplayList(unscaledWidth:Number,
                                                      unscaledHeight:Number):void
        {
            super.updateDisplayList(unscaledWidth, unscaledHeight);

            graphics.clear();

            if (!dropShadow)
                dropShadow = new mx.graphics.RectangularDropShadow();

            dropShadow.distance = _distance;
            dropShadow.angle = _angle;
            dropShadow.color = _color;
            dropShadow.blurX = _blurX;
            dropShadow.blurY = _blurY;
            dropShadow.alpha = _alpha;

            dropShadow.tlRadius = isNaN(_tlRadius) ? 0 : _tlRadius;
            dropShadow.trRadius = isNaN(_trRadius) ? 0 : _trRadius;
            dropShadow.blRadius = isNaN(_blRadius) ? 0 : _blRadius;
            dropShadow.brRadius = isNaN(_brRadius) ? 0 : _brRadius;

            dropShadow.drawShadow(graphics, 0, 0, unscaledWidth, unscaledHeight);
        } */
    
    }
}
