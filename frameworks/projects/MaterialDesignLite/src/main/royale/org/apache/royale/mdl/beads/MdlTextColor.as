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
    import org.apache.royale.mdl.supportClasses.IMdlTextColor;

    /**
     *  The MdlTextColor apply textColor and textColorWeight provided by google style color.
     *
     *  https://material.google.com/style/color.html#color-color-palette
     *  https://gitlab.com/material/colors/blob/master/colors.html
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     */
    public class MdlTextColor implements IBead, IMdlTextColor
    {
        public function MdlTextColor()
        {

        }

        private var _textColor:String = "";
        /**
         *  @copy org.apache.royale.mdl.supportClasses.IMdlTextColor#textColor
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        public function get textColor():String
        {
            return _textColor;
        }

        public function set textColor(value:String):void
        {
            _textColor = value;
        }

        private var _textColorWeight:String = "";
        /**
         *  @copy org.apache.royale.mdl.supportClasses.IMdlTextColor#textColorWeight
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        public function get textColorWeight():String
        {
            return _textColorWeight;
        }

        public function set textColorWeight(value:String):void
        {
            _textColorWeight = value;
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
            var elementColor:String = getMdlElementTextColor();

            COMPILE::JS
            {
                var element:HTMLElement = host.element as HTMLElement;
                element.classList.toggle(elementColor, hasTextColor || hasTextColorWeight);
            }
        }

        /**
         *  has text color
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        private function get hasTextColor():Boolean
        {
            return _textColor != null && _textColor != "";
        }

        /**
         *  has text color weight
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        private function get hasTextColorWeight():Boolean
        {
            return _textColorWeight != null && _textColorWeight != "";
        }

        /**
         *  get mdl element text color
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        public function getMdlElementTextColor():String
        {
            if (hasTextColor && hasTextColorWeight)
            {
                return "mdl-color-text--".concat(_textColor, "-", _textColorWeight);
            }
            else if (hasTextColor)
            {
                return "mdl-color-text--".concat(_textColor);
            }

            return "";
        }
    }
}
