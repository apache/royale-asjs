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
	COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
        import org.apache.royale.html.util.addElementToWrapper;
    }
	import org.apache.royale.core.IPopUp;
	import org.apache.royale.core.StyledUIBase;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;

	/**
	 * The openPopUp event is dispatched when the we want to open the popup
	 */
	[Event(name="openPopUp", type="org.apache.royale.events.Event")]
	
	/**
	 * The closePopUp event is dispatched when the we want to close the popup
	 */
	[Event(name="closePopUp", type="org.apache.royale.events.Event")]
	
	/**
	 *  Indicates that the initialization of the list is complete.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	[Event(name="initComplete", type="org.apache.royale.events.Event")]
	
	/**
	 *  The PopUp class is a component that can popup another component declared as IPopUp
	 *  
     *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.6
	 */
	public class PopUp extends StyledUIBase implements IPopUp
	{
		/**
		 *  constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
		public function PopUp()
		{
			super();
			
			typeNames = "jewel popup";
		}

		/**
		 * open the popup content
		 */
		public function open():void
		{
			dispatchEvent(new Event("openPopUp"));
		}
		
		/**
		 * close the popup content
		 */
		public function close():void
		{
			dispatchEvent(new Event("closePopUp"));
		}

		private var _content:UIBase;

		/**
		 * the content to be instantiated inside the popup.
		 * Instead of setup this property, it can be declared through
		 * CSS using IPopUP royale bead css selector.
		 */
		public function get content():UIBase
		{
			return _content;
		}
		public function set content(value:UIBase):void
		{
			_content = value;
		}
		
		/**
		 * The method called when added to a parent. The PopUp class uses
		 * this opportunity to install additional beads.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
		override public function addedToParent():void
		{
			super.addedToParent();
			
			dispatchEvent(new Event("initComplete"));
		}

		/**
		 * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 * @royaleignorecoercion org.apache.royale.html.util.addElementToWrapper
         */
		COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			addElementToWrapper(this, 'div');
            positioner = element;
            return element;
        }
	}
}
