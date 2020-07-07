/*
 *
 *  Licensed to the Apache Software Foundation (ASF) under one or more
 *  contributor license agreements.  See the NOTICE file distributed with
 *  this work for additional information regarding copyright ownership.
 *  The ASF licenses this file to You under the Apache License, Version 2.0
 *  (the "License"); you may not use this file except in compliance with
 *  the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.apache.royale.svg
{
	import org.apache.royale.core.ImageBase;

	COMPILE::JS
	{
		import org.apache.royale.core.WrappedHTMLElement;
    import org.apache.royale.html.util.addSvgElementToWrapper;
    import org.apache.royale.html.util.createSVG;
	}
    public class Image extends ImageBase
    {
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7
		 */
        public function Image()
        {
			super();
       }
		
		/**
		 * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 */
		COMPILE::JS
		override protected function createElement():WrappedHTMLElement
		{
			addSvgElementToWrapper(this, 'svg') as WrappedHTMLElement;
			element.setAttribute('x', 0);
			element.setAttribute('y', 0);
			//element.offsetParent = null;
			addImageElement();
			return element;
		}
		
		COMPILE::JS
		protected var _image:WrappedHTMLElement;
		
		/**
		 * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 */
		COMPILE::JS
		protected function addImageElement():void
		{
			if (_image == null) {
				_image = createSVG('image') as WrappedHTMLElement;
				_image.setAttribute("width", "100%");
				_image.setAttribute("height", "100%");
				_image.royale_wrapper = this;
				element.appendChild(_image);
			}
		}
		
		COMPILE::JS
		override public function get imageElement():Element
		{
			return _image;
		}
		
		COMPILE::JS
		override public function get transformElement():WrappedHTMLElement
		{
			return _image;
		}
		/**
		 *  @royaleignorecoercion SVGImageElement
		 */
		COMPILE::JS
		override public function applyImageData(binaryDataAsString:String):void
		{
			(_image as SVGImageElement).setAttributeNS('http://www.w3.org/1999/xlink','href', binaryDataAsString);
		}
		COMPILE::JS
		override public function setWidth(value:Number, noEvent:Boolean=false):void
		{
			super.setWidth(value, noEvent);
			positioner.setAttribute("width", value);
		}

		COMPILE::JS
		override public function setHeight(value:Number, noEvent:Boolean=false):void
		{
			super.setHeight(value, noEvent);
			positioner.setAttribute("height", value);
		}
		
		COMPILE::JS
		override public function setX(value:Number):void
		{
			super.setX(value);
			positioner.setAttribute("x", value);

		}
		COMPILE::JS
		override public function setY(value:Number):void
		{
			super.setY(value);
			positioner.setAttribute("y", value);
			
		}
		
		COMPILE::JS
		override public function set x(value:Number):void
		{
			super.x = value;
			positioner.setAttribute("x", value);
		}
		
		COMPILE::JS
		override public function set y(value:Number):void
		{
			super.y = value;
			positioner.setAttribute("y", value);
		}
    }
}
