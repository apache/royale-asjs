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
    import org.apache.flex.mdl.NavigationLink;
    import org.apache.flex.mdl.materialIcons.IMaterialIcon;

    /**
     *  The DeletableLinkChip bead class is a specialty bead that can be used to add additional
     *  link button to Chip MDL control.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    public class DeletableLinkChip implements IBead
    {
        /**
         *  constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function DeletableLinkChip()
        {
        }

        private var linkElement:NavigationLink;
        private var _href:String;
        private var _strand:IStrand;

        /**
         * @copy org.apache.flex.core.IBead#strand
         * 
         * @flexjsignorecoercion HTMLElement
         * @flexjsignorecoercion HTMLSpanElement
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
                    element.classList.add("mdl-chip--deletable");

                    linkElement = createLinkElement();
                    linkElement.href = _href;

                    element.appendChild(linkElement.element as HTMLElement);
                }
                else
                {
                    throw new Error("Host component must be an MDL Host for Chips.");
                }
            }
        }

        /**
         * 
         * Link
         * 
         * @param value
         * 
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion FlexJS 0.0
         */
        public function set href(value:String):void
        {
           _href = value;
        }

        /**
         * @flexjsignorecoercion HTMLElement
         *
         * @return Link represents cancel icon
         */
        COMPILE::JS
        private function createLinkElement():NavigationLink
        {
            var materialIcon:IMaterialIcon = _strand as IMaterialIcon;

            if (materialIcon == null)
            {
                throw new Error("Missing material icon");
            }

            var link:NavigationLink = new NavigationLink();
            link.addElement(materialIcon.materialIcon);

            var linkElement:HTMLElement = (link.element as HTMLElement);
            linkElement.classList.remove("mdl-navigation__link");
            linkElement.classList.add("mdl-chip__action");

            return link;
        }
    }
}
