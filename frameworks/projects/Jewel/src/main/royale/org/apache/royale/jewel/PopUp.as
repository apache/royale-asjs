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
	import org.apache.royale.events.Event;
	import org.apache.royale.core.UIBase;

	
	/**
	 * The change event is dispatched when the selectedDate is changed.
	 */
	[Event(name="change", type="org.apache.royale.events.Event")]
	
	/**
	 * The PopUp class provides an input field where a date can be entered
	 * and a pop-up calendar control for picking a date as an alternative to
	 * the text field.
	 *  
     *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class PopUp extends StyledUIBase implements IPopUp
	{
		/**
		 *  constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function PopUp()
		{
			super();
			
			typeNames = "jewel popup";//layout itemsCenter
		}

		public function show():void
		{
			dispatchEvent(new Event("showPopUp"));
		}

		// private var _content:UIBase;

		// public function get content():UIBase
		// {
		// 	return _content;
		// }
		// public function set content(value:UIBase):void
		// {
		// 	_content = value;
		// }
		
		/**
		 * The method called when added to a parent. The PopUp class uses
		 * this opportunity to install additional beads.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
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
