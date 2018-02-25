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
package org.apache.royale.mdl.supportClasses
{
    import org.apache.royale.mdl.Button;

    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
    }

    /**
     *  ChipBase class is the base class for Chip and ButtonChip
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
    public class ChipBase extends Button
    {
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        public function ChipBase()
        {
            super();
        }
        
        /**
         * The chip span element
         * 
         * @royalesuppresspublicvarwarning
         */
        COMPILE::JS
        public var chipTextSpan:HTMLSpanElement;
        
        private var _text:String = "";
        /**
         *  The text of the chip
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
		override public function get text():String
		{
            return _text;            
		}
        override public function set text(value:String):void
		{
            _text = value;

			COMPILE::JS
			{
                if(textNode == null)
                {
                    textNode = document.createTextNode('') as Text;
                    element.appendChild(textNode);
                }
                
                textNode.nodeValue = value;	
			}
		}

        COMPILE::JS
        protected var textNode:Text;
    }
}
