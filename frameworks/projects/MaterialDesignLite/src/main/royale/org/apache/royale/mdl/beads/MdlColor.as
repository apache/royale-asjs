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
package org.apache.royale.mdl.beads
{
    import org.apache.royale.core.IBead;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.UIBase;
    import org.apache.royale.mdl.supportClasses.IMdlColor;

    /**
     *  The MdlColor bead apply color and colorWeight provided by google style color.
     *
     *  https://material.google.com/style/color.html#color-color-palette
     *  https://gitlab.com/material/colors/blob/master/colors.html
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     */
    public class MdlColor implements IBead, IMdlColor
    {
        /**
         *  constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        public function MdlColor()
        {

        }

        private var _color:String = "";
        /**
         *  @copy org.apache.royale.mdl.supportClasses.IMdlColor#color
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        public function get color():String
        {
            return _color;
        }

        public function set color(value:String):void
        {
            _color = value;
        }

        private var _colorWeight:String = "";
        /**
         *  @copy org.apache.royale.mdl.supportClasses.IMdlColor#colorWeight
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        public function get colorWeight():String
        {
            return _colorWeight;
        }

        public function set colorWeight(value:String):void
        {
            _colorWeight = value;
        }
        
        private var _strand:IStrand;
        /**
         * @copy org.apache.royale.core.IBead#strand
         * 
         * @royaleignorecoercion HTMLElement
         *
         * @param value
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.8
         */
        public function set strand(value:IStrand):void
        {
            _strand = value;

            var host:UIBase = value as UIBase;
            var elementColor:String = getMdlElementColor();

            COMPILE::JS
            {
                var element:HTMLElement = host.element as HTMLElement;
                element.classList.toggle(elementColor, hasColor || hasColorWeight);
            }
        }

        /**
         *  has color
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        private function get hasColor():Boolean
        {
            return _color != null && _color != "";
        }

        /**
         *  has color weight
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        private function get hasColorWeight():Boolean
        {
            return _colorWeight != null && _colorWeight != "";
        }

        /**
         *  get mdl element color
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        public function getMdlElementColor():String
        {
            if (hasColor && hasColorWeight)
            {
               return "mdl-color--".concat(_color, "-", _colorWeight);
            }
            else if (hasColor)
            {
               return "mdl-color--".concat(_color);
            }

            return "";
        }
    }
}
