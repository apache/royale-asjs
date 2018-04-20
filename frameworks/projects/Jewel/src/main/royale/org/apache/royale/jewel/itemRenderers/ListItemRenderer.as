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
package org.apache.royale.jewel.itemRenderers
{
    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
		import org.apache.royale.html.util.addElementToWrapper;
        import org.apache.royale.utils.cssclasslist.toggleStyle;
    }

	import org.apache.royale.html.supportClasses.MXMLItemRenderer;
    
	/**
	 *  The ListItemRenderer defines the basic Item Renderer for a Jewel List Component.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.3
	 */
	public class ListItemRenderer extends MXMLItemRenderer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function ListItemRenderer()
		{
			super();

            typeNames = "jewel item";
		}
		
		private var _text:String = "";

        /**
         *  The text of the renderer
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.3
         */
		public function get text():String
		{
            return _text;
		}

		public function set text(value:String):void
		{
             _text = value;
		}

		COMPILE::JS
        private var textNode:Text;

		/**
		 *  Sets the data value and uses the String version of the data for display.
		 * 
		 *  @param Object data The object being displayed by the itemRenderer instance.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		override public function set data(value:Object):void
		{
			super.data = value;

            var text:String;
			if (labelField || dataField) {
                text = String(value[labelField]);
            } else {
                text = String(value);
            }
            
			COMPILE::JS
			{
				if(textNode != null)
				{
					textNode.nodeValue = text;
				}	
			}
		}

        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 * @royaleignorecoercion Text
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			addElementToWrapper(this,'li');
            
			if(MXMLDescriptor == null)
			{
				textNode = document.createTextNode('') as Text;
				element.appendChild(textNode);
			}
            return element;
        }

        /**
		 * @private
		 */
		override public function updateRenderer():void
		{
			// if (down)
			// 	useColor = downColor;
			// else if (hovered)
			// 	useColor = highlightColor;
			// else 
            //if (selected)
            // 	useColor = selectedColor;
			//else
			// 	useColor = backgroundColor;

            COMPILE::JS
            {
                //element.className = "jewel item selected";
                toggleStyle(this, "selected", selected);
            }
		}

		private var _twoLine:Boolean;
        /**
         *  Activate "twoline" class selector, for use in list item.
		 *  Optional Two Line List Variant
         *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
         */
        public function get twoLine():Boolean
        {
            return _twoLine;
        }
        public function set twoLine(value:Boolean):void
        {
            _twoLine = value;

            COMPILE::JS
            {
                element.classList.toggle("twoline", _twoLine);
            }
        }

		private var _threeLine:Boolean;
        /**
         *  Activate "threeline" class selector, for use in list item.
		 *  Optional Three Line List Variant
         *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
         */
        public function get threeLine():Boolean
        {
            return _threeLine;
        }
        public function set threeLine(value:Boolean):void
        {
            _threeLine = value;

            COMPILE::JS
            {
                element.classList.toggle("threeline", _threeLine);
            }
        }
	}
}
