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
    import org.apache.flex.html.Image;

    /**
     *  The ContactImageChip bead class is a specialty bead that can be used to add additional
     *  button to Chip MDL control.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    COMPILE::SWF
    public class ContactImageChip
    {
        private var _source:String;

        public function ContactImageChip()
        {

        }

        public function set source(value:String):void
        {
            _source = value;
        }
    }

    COMPILE::JS
    public class ContactImageChip implements IBead
    {
        public function ContactImageChip()
        {
            super();
        }

        private var _source:String = "";
        private var _strand:IStrand;

        private var contact:Image;

        public function set strand(value:IStrand):void
        {
            _strand = value;

            var host:UIBase = value as UIBase;
            var element:HTMLElement = host.element as HTMLElement;
            var isValidElement:Boolean = element is HTMLSpanElement || element is HTMLButtonElement;

            if (isValidElement && element.className.search("mdl-chip") > -1)
            {
                element.classList.add("mdl-chip--contact");

                contact = new Image();
                contact["applyImageData"](_source);

                contact["imageElement"].classList.add("mdl-chip__contact");

                element.insertBefore(contact["imageElement"], host["chipTextSpan"]);
            }
            else
            {
                throw new Error("Host component must be an MDL Host for Chips.");
            }
        }

        public function set source(value:String):void
        {
            _source = value;
        }
    }
}
