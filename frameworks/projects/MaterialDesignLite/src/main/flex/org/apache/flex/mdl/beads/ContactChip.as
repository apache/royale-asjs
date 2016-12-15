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
    import org.apache.flex.html.Span;
    import org.apache.flex.mdl.supportClasses.IMdlColor;
    import org.apache.flex.mdl.supportClasses.IMdlTextColor;
    import org.apache.flex.utils.StrandUtils;

    COMPILE::JS
    {
        import org.apache.flex.core.UIHTMLElementWrapper;
        import org.apache.flex.core.UIBase;
        import org.apache.flex.core.WrappedHTMLElement;
    }
    /**
     *  The ContactChip bead class is a specialty bead that can be used to add additional
     *  button to Chip MDL control.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    COMPILE::SWF
    public class ContactChip implements IMdlTextColor
    {
        private var _textColor:String;
        private var _textColorWeight:String;

        private var _contactText:String;

        public function ContactChip()
        {

        }

        public function set contactText(value:String):void
        {
            _contactText = value;
        }

        /**
         * @inheritDoc
         */
        public function get textColor():String
        {
            return _textColor;
        }

        public function set textColor(value:String):void
        {
            _textColor = value;
        }

        /**
         * @inheritDoc
         */
        public function get textColorWeight():String
        {
            return _textColorWeight;
        }

        public function set textColorWeight(value:String):void
        {
            _textColorWeight = value;
        }
    }

    COMPILE::JS
    public class ContactChip implements IBead, IMdlTextColor
    {
        /**
         *  constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function ContactChip()
        {
        }

        private var _textColor:String = "";
        private var _textColorWeight:String = "";
        private var _contactText:String = "";

        private var contact:Span;
        private var textNode:Text;

        private var _strand:IStrand;

        /**
         * @flexjsignorecoercion HTMLElement
         * @flexjsignorecoercion HTMLSpanElement
         * @flexjsignorecoercion Text
         * @flexjsignorecoercion HTMLButtonElement
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         *
         * @param value
         */
        public function set strand(value:IStrand):void
        {
            _strand = value;
            
            var host:UIBase = value as UIBase;
            var element:HTMLElement = host.element as HTMLElement;
            var isValidElement:Boolean = element is HTMLSpanElement || element is HTMLButtonElement;

            if (isValidElement && element.className.search("mdl-chip") > -1)
            {
                element.classList.add("mdl-chip--contact");

                textNode = document.createTextNode('') as Text;
                textNode.nodeValue = _contactText;

                contact = new Span();
                contact.element.classList.add("mdl-chip__contact");

                loadColorBead();

                var contactTextColor:String = getContactTextColor();

                contact.element.classList.toggle(contactTextColor, _textColor);

                contact.element.appendChild(textNode);

                element.insertBefore(contact.element, host["chipTextSpan"]);
            }
            else
            {
                throw new Error("Host component must be an MDL Host for Chips.");
            }
        }

        private function loadColorBead():void
        {
            var mdlColorBead:IBead = StrandUtils.loadBead(MdlColor, "MdlColor", _strand);

            if (mdlColorBead != null)
            {
                //Maybe removing also css manually from strand is a solution ?
               _strand.removeBead(mdlColorBead);
               contact.addBead(mdlColorBead);
            }
        }

        public function set contactText(value:String):void
        {
            _contactText = value;
        }

        /**
         * @inheritDoc
         */
        public function get textColor():String
        {
            return _textColor;
        }

        public function set textColor(value:String):void
        {
            _textColor = value;
        }

        /**
         * @inheritDoc
         */
        public function get textColorWeight():String
        {
            return _textColorWeight;
        }

        public function set textColorWeight(value:String):void
        {
            _textColorWeight = value;
        }
        
        private function getContactTextColor():String
        {
            return _textColorWeight ?
                    "mdl-color-text--".concat(_textColor, "-", _textColorWeight) :
                    "mdl-color-text--".concat(_textColor);
        }
    }
}
