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

    /**
     *  The ContactImageChip bead class is a specialty bead that can be used to add additional
     *  button to Chip MDL control.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     */
    public class ContactImageChip implements IBead
    {
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        public function ContactImageChip()
        {
            super();
        }

        /**
         * The image contact
         */
        COMPILE::JS
        protected var contact:HTMLImageElement;

        private var _strand:IStrand;

        protected var _imageWidth:Number = 32;
        protected var _imageHeight:Number = 32;

        /**
         * Specifies the width of the image Chip, in pixels.
         *
         * @default 32px
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.9.1
         */
        public function set imageWidth(value:Number):void
        {
            _imageWidth = value;
        }

        /**
         * Specifies the height of the image Chip, in pixels.
         *
         * @default 32px
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.9.1
         */
        public function set imageHeight(value:Number):void
        {
            _imageHeight = value;
        }

        /**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
         *  @royaleignorecoercion HTMLElement
         *  @royaleignorecoercion HTMLSpanElement
         *  @royaleignorecoercion HTMLButtonElement
         *  @royaleignorecoercion HTMLImageElement
         *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function set strand(value:IStrand):void
        {
            _strand = value;

            var host:UIBase = value as UIBase;

            COMPILE::JS
            {
                var element:HTMLElement = host.element as HTMLElement;
                var isValidElement:Boolean = element is HTMLSpanElement || element is HTMLButtonElement;

                if (isValidElement && element.className.search("mdl-chip") > -1)
                {
                    element.classList.add("mdl-chip--contact");

                    contact = document.createElement("img") as HTMLImageElement;
                    contact.classList.add("mdl-chip__contact");
                    contact.src = _source;
                    contact.style["width"] = isNaN(_imageWidth) ? "32px" : String(_imageWidth) + "px";
                    contact.style["height"] = isNaN(_imageHeight) ? "32px" : String(_imageHeight) + "px";

                    element.insertBefore(contact, host["chipTextSpan"]);
                }
                else
                {
                    throw new Error("Host component must be an MDL Host for Chips.");
                }
            }
        }

        private var _source:String = "";
        /**
         *  Source for displayed image
         *
         *  @param value
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        public function set source(value:String):void
        {
            _source = value;
        }
    }
}
