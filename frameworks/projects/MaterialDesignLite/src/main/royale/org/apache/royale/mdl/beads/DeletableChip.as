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
    import org.apache.royale.mdl.Button;
    import org.apache.royale.mdl.supportClasses.IMaterialIconProvider;

    /**
     *  The DeletableChip bead class is a specialty bead that can be used to add additional
     *  button to Chip MDL control.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     */
    public class DeletableChip implements IBead
    {
        /**
         *  constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        public function DeletableChip()
        {

        }

        private var deleteButton:Button;
        private var _strand:IStrand;

        /**
         * @copy org.apache.royale.core.IBead#strand
         * 
         * @royaleignorecoercion HTMLElement
         * @royaleignorecoercion HTMLSpanElement
         * @royaleignorecoercion HTMLButtonElement
         *
         * @param value
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
                    deleteButton = createDeleteButton();
                    element.appendChild(deleteButton.element as HTMLElement);
                }
                else
                {
                    throw new Error("Host component must be an MDL Host for Chips.");
                }
            }
        }

        /**
         * @royaleignorecoercion HTMLElement
         *
         * @return Button represents cancel icon
         */
        COMPILE::JS
        private function createDeleteButton():Button
        {
            var materialIcon:IMaterialIconProvider = _strand as IMaterialIconProvider;

            if (materialIcon == null)
            {
                throw new Error("Missing material icon");
            }

            var delButton:Button = new Button();
            delButton.materialIcon = materialIcon.materialIcon;

            var htmlButton:HTMLElement = (delButton.element as HTMLElement);
            htmlButton.classList.remove("mdl-button", "mdl-js-button");
            htmlButton.classList.add("mdl-chip__action");

            return delButton;
        }
    }
}
