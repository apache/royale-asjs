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
    import org.apache.royale.events.Event;

    import org.apache.royale.core.IBead;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.UIBase;

	/**
	 *  The Tooltip class provides useful information on hover.
     *  
     *  The Material Design Lite (MDL) tooltip component is an enhanced version of the 
     *  standard HTML tooltip as produced by the title attribute. A tooltip consists 
     *  of text and/or an image that clearly communicates additional information 
     *  about an element when the user hovers over or, in a touch-based UI, 
     *  touches the element.
	 *  
     *  The MDL tooltip component is pre-styled (colors, fonts, and other settings)
     *  to provide a vivid, attractive visual element that displays related but 
     *  typically non-essential content, e.g., a definition, clarification, 
     *  or brief instruction.
     *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	public class Tooltip implements IBead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function Tooltip()
		{
			
		}

        private var _host:UIBase;

        COMPILE::JS
        private var _tooltipDiv:HTMLDivElement;

        private var _text:String = "";
        /**
         *  The text of the tooltip
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
		public function get text():String
		{
            return _text;
		}

		public function set text(value:String):void
		{
            _text = value;
		}

        private var _dataMdlFor:String;
		/**
		 *  The id value of the associated control for this tooltip
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function get dataMdlFor():String
		{
			return _dataMdlFor;
		}
		public function set dataMdlFor(value:String):void
		{
			_dataMdlFor = value;
		}

        private var _large:Boolean = false;
        /**
		 *  A boolean flag to activate "mdl-tooltip--large" effect selector.
		 *  Applies large-font effect. Optional
         *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function get large():Boolean
        {
            return _large;
        }
        public function set large(value:Boolean):void
        {
             _large = value;
        }

        private var _leftPosition:Boolean = false;
        /**
		 *  A boolean flag to activate "mdl-tooltip--left" effect selector.
		 *  Positions the tooltip to the left of the target. Optional
         *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function get leftPosition():Boolean
        {
            return _large;
        }
        public function set leftPosition(value:Boolean):void
        {
             _leftPosition = value;
        }

        private var _rightPosition:Boolean = false;
        /**
		 *  A boolean flag to activate "mdl-tooltip--right" effect selector.
		 *  Positions the tooltip to the right of the target. Optional
         *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function get rightPosition():Boolean
        {
            return _rightPosition;
        }
        public function set rightPosition(value:Boolean):void
        {
             _rightPosition = value;
        }

        private var _topPosition:Boolean = false;
        /**
		 *  A boolean flag to activate "mdl-tooltip--top" effect selector.
		 *  Positions the tooltip to the top of the target. Optional
         *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function get topPosition():Boolean
        {
            return _topPosition;
        }
        public function set topPosition(value:Boolean):void
        {
             _topPosition = value;
        }

        private var _bottomPosition:Boolean = false;
        /**
		 *  A boolean flag to activate "mdl-tooltip--bottom" effect selector.
		 *  Positions the tooltip to the bottom of the target. Optional
         *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function get bottomPosition():Boolean
        {
            return _bottomPosition;
        }
        public function set bottomPosition(value:Boolean):void
        {
             _bottomPosition = value;
        }

        private var _strand:IStrand;
        /**
         *  @royaleignorecoercion HTMLElement
         *  @royaleignorecoercion HTMLDivElement
         *  @royaleignorecoercion Text
         *
         *  @param value
         *  
         *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
         */
        public function set strand(value:IStrand):void
        {
            _strand = value;

            _host = value as UIBase;
            COMPILE::JS
            {
                _tooltipDiv = document.createElement("div") as HTMLDivElement;

                _tooltipDiv.classList.add("mdl-tooltip");
                _tooltipDiv.classList.toggle("mdl-tooltip--top", _topPosition);
                _tooltipDiv.classList.toggle("mdl-tooltip--left", _leftPosition);
                _tooltipDiv.classList.toggle("mdl-tooltip--right", _rightPosition);
                _tooltipDiv.classList.toggle("mdl-tooltip--bottom", _bottomPosition);

                _tooltipDiv.classList.toggle("mdl-tooltip--large", _large);
                _tooltipDiv.setAttribute('for', _host.id);

                var textNode:Text = document.createTextNode('');
                textNode.nodeValue = _text;
                _tooltipDiv.appendChild(textNode);

                var isElementAdded:Boolean = addTooltipToParent();
                if (!isElementAdded)
                {
                    _host.addEventListener("beadsAdded", beadsAddedHandler);
                }
            }
        }

        COMPILE::JS
        private function beadsAddedHandler(event:Event):void
        {
            var host:UIBase = _strand as UIBase;
            host.removeEventListener("beadsAdded", beadsAddedHandler);

            addTooltipToParent();
            upgradeTooltip();
        }

        COMPILE::JS
        private function addTooltipToParent():Boolean
        {
            var element:HTMLElement = _host.element as HTMLElement;

            if (!element.parentElement)
            {
                return false;
            }

            element.parentElement.appendChild(_tooltipDiv);
            return true;
        }

        COMPILE::JS
        private function upgradeTooltip():void
        {
            var componentHandler:Object = window["componentHandler"];

            if (componentHandler && _tooltipDiv)
            {
                componentHandler["upgradeElement"](_tooltipDiv);
            }
        }
    }
}
