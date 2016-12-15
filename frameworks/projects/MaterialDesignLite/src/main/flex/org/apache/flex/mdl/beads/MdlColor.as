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
package org.apache.flex.mdl.beads
{
    import org.apache.flex.core.IBead;
    import org.apache.flex.core.IStrand;
    import org.apache.flex.core.UIBase;
    import org.apache.flex.mdl.supportClasses.IMdlColor;


    /**
     *  The MdlColor bead apply color and colorWeight provided by google style color.
     *
     *  https://material.google.com/style/color.html#color-color-palette
     *  https://gitlab.com/material/colors/blob/master/colors.html
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    COMPILE::SWF
    public class MdlColor implements IMdlColor
    {
        private var _color:String;
        private var _colorWeight:String;

        /**
         *  constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function MdlColor()
        {

        }

        /**
         * @inheritDoc
         */
        public function get color():String
        {
            return _color;
        }

        public function set color(value:String):void
        {
            _color = value;
        }

        /**
         * @inheritDoc
         */
        public function get colorWeight():String
        {
            return _colorWeight;
        }

        public function set colorWeight(value:String):void
        {
            _colorWeight = value;
        }
    }

    COMPILE::JS
    public class MdlColor implements IBead, IMdlColor
    {
        public function MdlColor()
        {
        }

        private var _color:String = "";
        private var _colorWeight:String = "";

        private var _strand:IStrand;

        /**
         * @flexjsignorecoercion HTMLElement
         *
         * @param value
         */
        public function set strand(value:IStrand):void
        {
            _strand = value;

            var host:UIBase = value as UIBase;
            var element:HTMLElement = host.element as HTMLElement;

            var elementColor:String = getMdlElementColor();
            element.classList.toggle(elementColor, hasColor || hasColorWeight);
        }

        public function get color():String
        {
            return _color;
        }

        public function set color(value:String):void
        {
            _color = value;
        }

        public function get colorWeight():String
        {
            return _colorWeight;
        }

        public function set colorWeight(value:String):void
        {
            _colorWeight = value;
        }

        private function get hasColor():Boolean
        {
            return _color != null && _color != "";
        }

        private function get hasColorWeight():Boolean
        {
            return _colorWeight != null && _colorWeight != "";
        }

        private function getMdlElementColor():String
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
