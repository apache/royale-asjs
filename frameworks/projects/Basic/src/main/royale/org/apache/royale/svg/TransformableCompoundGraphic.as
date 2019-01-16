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

    /**
     * TransformableCompoundGraphic adds a <g> element in which drawn elements are nested. 
	 * This is useful for applying transforms and other low level operations not available on SVG elements.
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.3
     */
	COMPILE::JS 
	{
		import org.apache.royale.core.WrappedHTMLElement;
        import org.apache.royale.html.util.createSVG;
	}
    public class TransformableCompoundGraphic extends CompoundGraphic
    {
		COMPILE::JS
		private var _groupElement:WrappedHTMLElement;

		/*
         *  @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		*/
		COMPILE::JS
		override protected function addElementToSurface(e:WrappedHTMLElement):void
		{
			_groupElement.appendChild(e);
		}
		
        /**
         *  Clears all of the drawn path data.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.3
         */
        override public function clear():void
        {
            COMPILE::SWF
            {
				super.clear();
            }
            COMPILE::JS
            {
                while (transformElement.lastChild) {
                    transformElement.removeChild(transformElement.lastChild);
                }
            }
        }
		
		/**
		 * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 */
		COMPILE::JS
		override protected function createElement():WrappedHTMLElement
		{
			super.createElement();
			_groupElement = createSVG('g') as WrappedHTMLElement;
			element.appendChild(_groupElement);
			return element;
		}

		/**
		 * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 */
		COMPILE::JS
		override public function get transformElement():WrappedHTMLElement
		{
			return _groupElement;
		}


    }
}
