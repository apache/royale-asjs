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
	import org.apache.royale.core.supportClasses.StyledImageBase;

    COMPILE::JS
    {
	import org.apache.royale.core.WrappedHTMLElement;
	import org.apache.royale.html.util.addElementToWrapper;
    }

	/**
	 *  Report the image was loaded
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.10.0
	 */
	[Event(name="loadComplete", type="org.apache.royale.events.Event")]
	
	  /**
	   *  The Jewel Image is a simple component that loads an Image.
	   *  For button images use ImageButton
	   *
	   *  @toplevel
	   *  @langversion 3.0
	   *  @playerversion Flash 10.2
	   *  @playerversion AIR 2.6
	   *  @productversion Royale 0.9.4
	   */
	public class Image extends StyledImageBase
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function Image()
		{
			super();
            typeNames = "jewel image";
		}

        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {			
            addElementToWrapper(this, 'img');
            return element;
        }

		COMPILE::JS
		override public function get imageElement():Element
		{
			return element;
		}

		/**
		 * @royaleignorecoercion HTMLImageElement
		 */
		COMPILE::JS
		override public function applyImageData(binaryDataAsString:String):void
		{
			(element as HTMLImageElement).src = binaryDataAsString;
		}
	}
}
