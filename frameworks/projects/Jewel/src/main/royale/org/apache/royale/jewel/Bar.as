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
	import org.apache.royale.core.IChild;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.events.Event;

	COMPILE::SWF
    {
		import org.apache.royale.core.IRenderedObject;
        import flash.display.DisplayObject;
    }
    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
		import org.apache.royale.html.util.addElementToWrapper;
    }

	/**
	 *  The Bar class is a container component for different items like
	 *  a title, navigation icon, and/or icon buttons.
	 *  Normaly is located at the top or bottom of a container and use to fill all 
	 *  horizontal availale space. It's responsive as screen size changes
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class Bar extends Group
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function Bar()
		{
			super();

            typeNames = "jewel bar";
		}

		COMPILE::JS
		protected var header:HTMLElement;

		protected function get headerClassName():String
		{
			return "barHeader";
		}

		/**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			header = addElementToWrapper(this,'header');
			header.className = headerClassName;
			
			var div:HTMLDivElement = document.createElement('div') as HTMLDivElement;
			div.appendChild(header);

			positioner = div as WrappedHTMLElement;
			positioner.royale_wrapper = this;

			return element;
        }

		/**
         *  @copy org.apache.royale.core.IParent#addElement()
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.core.IUIBase
         */
		override public function addElement(c:IChild, dispatchEvent:Boolean = true):void
		{
            COMPILE::SWF
            {
                if (c is IUIBase)
                {
                    if (c is IRenderedObject)
                        $sprite_addChild(IRenderedObject(c).$displayObject);
                    else
                        $sprite_addChild(c as DisplayObject);                        
                    IUIBase(c).addedToParent();
                }
                else
                    $sprite_addChild(c as DisplayObject);
            }
            COMPILE::JS
            {
                header.appendChild(c.positioner);
                (c as IUIBase).addedToParent();
            }
		}
	}
}
