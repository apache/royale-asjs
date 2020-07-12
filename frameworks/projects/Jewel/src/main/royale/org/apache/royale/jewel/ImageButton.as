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
package org.apache.royale.jewel
{
    COMPILE::SWF
    {
    import org.apache.royale.core.SimpleCSSStyles;
    }
    COMPILE::JS
    {
    import org.apache.royale.core.WrappedHTMLElement;
    import org.apache.royale.html.util.addElementToWrapper;
    }
    import org.apache.royale.core.IImageButton;
    import org.apache.royale.events.Event;
    import org.apache.royale.jewel.beads.models.ImageModel;

    /**
     *  The ImageButton class presents an image as a button.
     *  In html is an input type="image", this shows the hand pointer cursor
     *
     *  @toplevel
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class ImageButton extends Button implements IImageButton
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		public function ImageButton()
		{
			super();
            typeNames = "jewel imagebutton";
		}

		/**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         */
		COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			addElementToWrapper(this, 'input');
            element.setAttribute('type', 'image');
            return element;
        }

		[Bindable("srcChanged")]
		/**
		 * Sets the image for the button. This is a URL.
		 * TODO: figure out how to set the source in the style, rather than using
		 * backgroundImage behind the scenes.
         * @royaleignorecoercion org.apache.royale.html.beads.models.ImageModel
		 */
        public function get src():String
        {
            return ImageModel(model).url;
        }
        /**
         * @royaleignorecoercion org.apache.royale.html.beads.models.ImageModel
         */
        public function set src(url:String):void
        {
            ImageModel(model).url = url;
            COMPILE::SWF
            {
                if (!style)
                    style = new SimpleCSSStyles();
                style.backgroundImage = url;
            }

            COMPILE::JS
            {
                if(!_imageElement)
                {
                    (element as HTMLInputElement).src = url;
                    _imageElement = (element as HTMLInputElement);
                }
                if (_imageElement && url)
                {
                    (_imageElement as HTMLInputElement).src = url;
                }
            }

			dispatchEvent(new Event("srcChanged"));
        }

		COMPILE::JS
        private var _imageElement:Element;
		/**
		 *  Element image. HTMLInputElement.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.8
         *  @royaleignorecoercion org.apache.royale.core.IImageButton#imageElement
         *  @royaleignorecoercion Element
         */
        COMPILE::JS
		public function get imageElement():Element
		{
			return _imageElement;
		}
	}
}
