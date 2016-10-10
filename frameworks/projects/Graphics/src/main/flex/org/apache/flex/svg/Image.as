/**
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.apache.flex.svg
{
	import org.apache.flex.core.ImageBase;

	COMPILE::JS
	{
		import org.apache.flex.core.WrappedHTMLElement;            
	}
    public class Image extends ImageBase
    {
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.7
		 */
        public function Image()
        {
			super();
        }
		
		/**
		 * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
		 */
		COMPILE::JS
		override protected function createElement():WrappedHTMLElement
		{
			element = document.createElementNS('http://www.w3.org/2000/svg', 'svg') as WrappedHTMLElement;
			element.flexjs_wrapper = this;
			element.style.left = 0;
			element.style.top = 0;
			//element.offsetParent = null;
			positioner = element;
			positioner.style.position = 'relative';
			addImageElement();
			return element;
		}
		
		COMPILE::JS
		protected var _image:WrappedHTMLElement;
		
		/**
		 * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
		 */
		COMPILE::JS
		protected function addImageElement():void
		{
			if (_image == null) {
				_image = document.createElementNS('http://www.w3.org/2000/svg', 'image') as WrappedHTMLElement;
				_image.setAttribute("width", "100%");
				_image.setAttribute("height", "100%");
				_image.flexjs_wrapper = this;
				element.appendChild(_image);
			}
		}
		
		COMPILE::JS
		override public function get imageElement():Element
		{
			return _image;
		}

    }
}
