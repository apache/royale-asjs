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
    public class ContactChip
    {
        private var _contactText:String = "";

        public function ContactChip()
        {

        }

        public function set contactText(value:String):void
        {
            _contactText = value;
        }
    }

    COMPILE::JS
    public class ContactChip implements IBead
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

        private var _contactText:String = "";

        private var contact:HTMLSpanElement;
        private var textNode:Text;

        private var _strand:IStrand;

        /**
         * @flexjsignorecoercion HTMLElement
         * @flexjsignorecoercion HTMLSpanElement
         * @flexjsignorecoercion Text
         * @flexjsignorecoercion HTMLButtonElement
         *
         * @param value
         */
        public function set strand(value:IStrand):void
        {
            _strand = value;

            COMPILE::JS
            {
                var host:UIBase = value as UIBase;
                var element:HTMLElement = host.element as HTMLElement;
                var isValidElement:Boolean = element is HTMLSpanElement || element is HTMLButtonElement;

                if (isValidElement && element.className.search("mdl-chip") > -1)
                {
                    element.classList.add("mdl-chip--contact");

                    textNode = document.createTextNode('') as Text;
                    textNode.nodeValue = _contactText;
                    
                    contact = document.createElement("span") as HTMLSpanElement;
                    contact.classList.add("mdl-chip__contact");
                    contact.appendChild(textNode);

                    element.appendChild(contact);
                }
                else
                {
                    throw new Error("Host component must be an MDL Host for Chips.");
                }
            }
        }

        public function set contactText(value:String):void
        {
            _contactText = value;
        }
    }
}
