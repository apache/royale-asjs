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
	 *  The TopAppBar class is a container component for different items like
	 *  application title, navigation icon, and/or icon buttons.
	 *  Normaly is located at the top of an application and use to fill all 
	 *  horizontal availale space. It's responsive as screen size changes
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.3
	 */
	public class TopAppBar extends Group
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function TopAppBar()
		{
			super();

            typeNames = "jewel topappbar"
			setListenersForFixed();
		}

		COMPILE::JS
		private var currentOffset:Number = 0;
		COMPILE::JS
		private var lastPosition:Number = 0;

		private function setListenersForFixed():void
        {
			COMPILE::JS
			{
			if(_fixed)
			{
				header.classList.add("fixed");
				window.removeEventListener('scroll', scrollHandler, false);
			}
			else
			{
				header.classList.remove("fixed");
				window.addEventListener('scroll', scrollHandler, false);
			}
			}
		}

		/**
		 *  If not fixed this scroll handler manages that the top bar doesn't get lost above
		 *  and will get back to screen sooner since only get scroll up by its size
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		private function scrollHandler(event:Event = null):void
        {
			COMPILE::JS
            {
				var offset:Number;
				var currentPosition:Number = Math.max(window.pageYOffset, 0);
				var diff:Number = currentPosition - lastPosition;
				lastPosition = currentPosition;

				currentOffset -= diff;
				
				if (currentOffset > 0) {
					currentOffset = 0;
				} else if (Math.abs(currentOffset) > header.clientHeight) {
					currentOffset = -header.clientHeight;
				}

				offset = currentOffset;
				if (Math.abs(offset) >= header.clientHeight) {
					offset = -128;
				}
				
				header.style.top = offset + "px";
			}
		}


		protected var _fixed:Boolean = false;
        /**
		 *  A boolean flag to activate "fixed" effect selector.
		 *  Optional. Makes the header always visible.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
        public function get fixed():Boolean
        {
            return _fixed;
        }
        public function set fixed(value:Boolean):void
        {
            if (_fixed != value)
            {
                _fixed = value;

                //toggleClass("fixed", _fixed);
				setListenersForFixed();
            }
        }


		COMPILE::JS
		private var header:HTMLElement;

		/**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			header = addElementToWrapper(this,'header');
			header.className = "topBarAppHeader";
			header.style.top = "0px";
			
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
         *  @productversion Royale 0.9.3
		 *  @royaleignorecoercion org.apache.royale.core.IUIBase
         */
		override public function addElement(c:IChild, dispatchEvent:Boolean = true):void
		{
            COMPILE::SWF
            {
                if (c is IUIBase)
                {
                    if (c is IRenderedObject)
                        $addChild(IRenderedObject(c).$displayObject);
                    else
                        $addChild(c as DisplayObject);                        
                    IUIBase(c).addedToParent();
                }
                else
                    $addChild(c as DisplayObject);
            }
            COMPILE::JS
            {
                header.appendChild(c.positioner);
                (c as IUIBase).addedToParent();
            }
		}

		private var _hasDrawer:Boolean;

        /**
         *  a boolean flag to indicate if the container needs to make some room
		 *  for a Drawer so content doesn't get lost on the right
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.3
         */
		public function get hasDrawer():Boolean
		{
            return _hasDrawer;
		}

		public function set hasDrawer(value:Boolean):void
		{
            if (_hasDrawer != value)
            {
                _hasDrawer = value;

                COMPILE::JS
                {
				if(_hasDrawer)
				{
					header.classList.add("has-drawer");
				}
				else
				{
					header.classList.remove("has-drawer");
				}
                }
            }
		}
	}
}
