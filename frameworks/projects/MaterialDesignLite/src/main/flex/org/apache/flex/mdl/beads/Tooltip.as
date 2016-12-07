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
    import org.apache.flex.html.Div;

    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;            
    }

	/**
	 *  The Tooltip class represents
     *  
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class Tooltip implements IBead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function Tooltip()
		{
			
		}

        private var _strand:IStrand;
        private var _text:String = "";

        /**
         *  The text of the heading
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
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
		 *  The id value of the associated button that opens this menu.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
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
		 *  @productversion FlexJS 0.0
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
		 *  @productversion FlexJS 0.0
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
		 *  @productversion FlexJS 0.0
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
		 *  @productversion FlexJS 0.0
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
		 *  @productversion FlexJS 0.0
		 */
        public function get bottomPosition():Boolean
        {
            return _bottomPosition;
        }
        public function set bottomPosition(value:Boolean):void
        {
             _bottomPosition = value;
        }

        /**
         * @flexjsignorecoercion HTMLElement
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

                var divElemet:HTMLDivElement = document.createElement("div") as HTMLDivElement;

                divElemet.classList.add("mdl-tooltip");
                divElemet.classList.toggle("mdl-tooltip--top", _topPosition);
                divElemet.classList.toggle("mdl-tooltip--left", _leftPosition);
                divElemet.classList.toggle("mdl-tooltip--right", _rightPosition);
                divElemet.classList.toggle("mdl-tooltip--bottom", _bottomPosition);

                divElemet.classList.toggle("mdl-tooltip--large", _large);
                divElemet.setAttribute('for', host.id);

                var textNode:Text = document.createTextNode('');
                textNode.nodeValue = _text;
                divElemet.appendChild(textNode);

                element.parentElement.appendChild(divElemet);
            }
        }
    }
}
