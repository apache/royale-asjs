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
    public class GraphicsSolidFill implements IGraphicsFill, IGraphicsData
    {
        public var alpha:Number = 1.0;
        public var color:uint = 0;
        
        public function GraphicsSolidFill(color:uint = 0, alpha:Number = 1.0)
        {
            this.color = color;
            this.alpha = alpha;
        }
        
        COMPILE::JS
        public function apply(graphics:Graphics, element:SVGPathElement):void
        {
            var hex:String = '#' + ('00000' + color.toString(16)).substr(-6);
            element.setAttributeNS(null, 'fill', hex);
            var alpha:Number = this.alpha;
            if (alpha < 0) alpha = 0;
            if (alpha < 1)
            {
                element.setAttributeNS(null, 'fill-opacity', alpha.toString());
            }
        }
        
        COMPILE::JS
        public function applyStroke(graphics:Graphics, element:SVGPathElement):SVGPathElement
        {
            var hex:String = '#' + ('00000' + color.toString(16)).substr(-6);
            element.setAttributeNS(null, 'stroke', hex);
            var alpha:Number = this.alpha;
            if (alpha < 0) alpha = 0;
            if (alpha < 1)
            {
                element.setAttributeNS(null, 'stroke-opacity', alpha.toString());
            }
            return element;
        }
        
    }
    
}


