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
package org.apache.royale.mdl
{
    import org.apache.royale.mdl.supportClasses.ChipBase;

    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
        import org.apache.royale.html.util.addElementToWrapper;
    }

    /**
     *  ButtonChip class represents a MDL button chip variant
     *  Chips are complex entities in small blocks.
     *  
     *  The Material Design Lite (MDL) chip component is a small, interactive element.
     *  Chips are commonly used for contacts, text, rules, icons, and photos.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     */
    public class ButtonChip extends ChipBase
    {
        COMPILE::JS
        private var chip:HTMLButtonElement;

        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         * @royaleignorecoercion HTMLSpanElement
         * @royaleignorecoercion HTMLButtonElement
         * @royaleignorecoercion Text
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
            typeNames = "mdl-chip";

            chipTextSpan = document.createElement("span") as HTMLSpanElement;
            chipTextSpan.classList.add("mdl-chip__text");

            textNode = document.createTextNode('') as Text;
            chipTextSpan.appendChild(textNode);
            chip = addElementToWrapper(this,'button') as HTMLButtonElement;
            chip.appendChild(chipTextSpan);
            return element;
        }
    }
}
