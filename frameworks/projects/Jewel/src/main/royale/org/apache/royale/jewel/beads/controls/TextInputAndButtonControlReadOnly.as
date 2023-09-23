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
package org.apache.royale.jewel.beads.controls
{
	COMPILE::JS
	{
	import org.apache.royale.core.HTMLElementWrapper;
    import org.apache.royale.jewel.beads.views.IViewWithTextInputAndButton;
	}
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.jewel.beads.controls.ReadOnly;
	import org.apache.royale.core.UIBase;
	
	/**
	 *  The TextInputAndButtonControlReadOnly bead class is a generic ReadOnly bead that can be used to lock a 
	 *  Jewel control that implements the IViewWithTextInputAndButton interface.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.6
	 */
	public class TextInputAndButtonControlReadOnly extends ReadOnly
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.9
		 */
		public function TextInputAndButtonControlReadOnly()
		{
		}

		COMPILE::JS
		protected var lastTextInputElementTabVal:String = null;
		COMPILE::JS
		protected var lastButtonElementTabVal:String = null;

		override protected function updateHost():void
		{
			COMPILE::JS
			{
			var view:IViewWithTextInputAndButton = (_strand as UIBase).view as IViewWithTextInputAndButton;

			if (view) {
				var pos:HTMLElement = (_strand as IUIBase).positioner;
				
				if(!initialized)
				{
					initialized = true;
					lastElementTabVal = (_strand as HTMLElementWrapper).element.getAttribute("tabindex");
					lastTextInputElementTabVal = view.textinput.element.getAttribute("tabindex");
					lastButtonElementTabVal = view.button.element.getAttribute("tabindex");
				}
				
                if(readOnly) {
					setReadOnlyAndTabIndex(pos, true);
					setReadOnlyAndTabIndex(view.textinput.positioner, true);
					setReadOnlyAndTabIndex(view.textinput.element);
					setReadOnlyAndTabIndex(view.button.positioner, true);
					setReadOnlyAndTabIndex(view.button.element);
				} else {
					removeReadOnlyAndTabIndex(pos, true);
					removeReadOnlyAndTabIndex(view.textinput.positioner, true);
					removeReadOnlyAndTabIndex(view.textinput.element, false, lastTextInputElementTabVal);
					removeReadOnlyAndTabIndex(view.button.positioner, true);
					removeReadOnlyAndTabIndex(view.button.element, false, lastButtonElementTabVal);
				}
            }
			}
		}
	}
}
