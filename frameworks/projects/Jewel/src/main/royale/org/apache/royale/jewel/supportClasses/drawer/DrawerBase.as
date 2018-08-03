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
package org.apache.royale.jewel.supportClasses.drawer
{
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.IChild;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.jewel.Group;

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
     *  Dispatched when the drawer open
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.3
     */
	[Event(name="openDrawer", type="org.apache.royale.events.Event")]

	/**
     *  Dispatched when the drawer close
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.3
     */
	[Event(name="closeDrawer", type="org.apache.royale.events.Event")]

	/**
	 *  The DrawerBase class is the base class for a container component 
	 *  used for navigation.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.3
	 */
	public class DrawerBase extends Group
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function DrawerBase()
		{
			super();

            typeNames = "jewel drawer";
		}

		COMPILE::JS
		protected var nav:HTMLElement;

		/**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			nav = addElementToWrapper(this,'nav');
			nav.className = "drawermain";
			
			var aside:HTMLElement = document.createElement('aside') as HTMLElement;
			aside.appendChild(nav);

			positioner = aside as WrappedHTMLElement;
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
                nav.appendChild(c.positioner);
                (c as IUIBase).addedToParent();
            }
		}
	}
}
