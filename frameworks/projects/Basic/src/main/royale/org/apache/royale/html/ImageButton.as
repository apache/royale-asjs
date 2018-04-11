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
package org.apache.royale.html
{
    import org.apache.royale.core.SimpleCSSStyles;
	import org.apache.royale.events.Event;
    import org.apache.royale.html.beads.models.ImageModel;

    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
        import org.apache.royale.html.util.addElementToWrapper;
    }

    /**
     *  The ImageButton class presents an image as a button.
     *
     *  @toplevel
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class ImageButton extends Button
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function ImageButton()
		{
			super();
            typeNames = "ImageButton";
		}

		/**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         */
		COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			addElementToWrapper(this,'button');
            element.setAttribute('type', 'button');
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
                var inner:String = '';
                if (url)
                    inner = "<img src='" + url + "'/>";
                element.innerHTML = inner;
            }

			dispatchEvent(new Event("srcChanged"));
        }
	}
}
