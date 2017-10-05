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
    import org.apache.royale.mdl.NavigationLink;
    import org.apache.royale.mdl.supportClasses.IMaterialIconProvider;

    /**
     *  The DeletableLinkChip bead class is a specialty bead that can be used to add additional
     *  link button to Chip MDL control.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     */
    public class DeletableLinkChip implements IBead
    {
        /**
         *  constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        public function DeletableLinkChip()
        {
        }

        private var linkElement:NavigationLink;
        private var _href:String;
        private var _strand:IStrand;

        /**
         * @copy org.apache.royale.core.IBead#strand
         * 
         * @royaleignorecoercion HTMLElement
         * @royaleignorecoercion HTMLSpanElement
         * @royaleignorecoercion HTMLButtonElement
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
            COMPILE::JS
            {
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
         * The link
         * 
         * @param value
         * 
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.8
         */
        public function set href(value:String):void
        {
           _href = value;
        }

        /**
         * @royaleignorecoercion HTMLElement
         *
         * @return Link represents cancel icon
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.8
         */
        COMPILE::JS
        private function createLinkElement():NavigationLink
        {
            var materialIcon:IMaterialIconProvider = _strand as IMaterialIconProvider;

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
