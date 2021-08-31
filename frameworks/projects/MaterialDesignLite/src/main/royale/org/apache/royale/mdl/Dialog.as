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
package org.apache.royale.mdl
{
	import org.apache.royale.html.Group;
	import org.apache.royale.mdl.Application;
	import org.apache.royale.core.IPopUp;
	import org.apache.royale.events.Event;

    COMPILE::JS
    {
      import org.apache.royale.core.WrappedHTMLElement;
			import org.apache.royale.html.util.addElementToWrapper;
			import org.apache.royale.html.util.DialogPolyfill;
    }

     [Event(name="close", type="org.apache.royale.events.Event")]

	/**
	 *  The MDL Dialog class creates modal windows for dedicated user input.
	 *  The Material Design Lite (MDL) dialog component allows for verification of user actions, simple data input,
	 *  and alerts to provide extra information to users.
	 *
	 *  Note: Dialogs use the HTML <dialog> element, which currently has very limited cross-browser support.
	 *  To ensure support across all modern browsers, we use use dialogPolyfill extern or creating your own.
	 *  There is no polyfill included with MDL.
	 *
	 *  Use DialogContent to insert content and DialogActions for the buttons to allow user interaction
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	public class Dialog extends Group implements IPopUp
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function Dialog()
		{
			super();

            typeNames = "mdl-dialog";
        }

		/**
		 * The html dialog component that parents the dialog content
		 */
		COMPILE::JS
		private var dialog:HTMLDialogElement;

        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 * @royaleignorecoercion HTMLDialogElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
            dialog = addElementToWrapper(this,'dialog') as HTMLDialogElement;
            return element;
        }

		/**
		 * flag to ensure only one dialog is created
		 */
		private var lockDialogCreation:Boolean = false;

		/**
		 *  This function make the dialog be added to document.body only once
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		private function prepareDialog():void
		{
			COMPILE::JS
			{
				if(!lockDialogCreation)
				{
					lockDialogCreation = true;
					var body:HTMLElement = document.getElementsByTagName('body')[0];
					body.appendChild(element);
					this.addedToParent();

					if (!("showModal" in dialog))
					{
						DialogPolyfill.registerDialog(dialog);
					}

				}
			}
		}

		/**
		 *  Displays the dialog element and makes it the top-most modal dialog.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function showModal():void
		{
			prepareDialog();
			_open = true;

			COMPILE::JS
			{
				dialog.showModal()
			}
		}

		/**
		 *  Displays the dialog element.
		 *
		 *  Note: It seems MDL does not support non modal dialogs, since there's no examples
		 *  and dialogs are always added to "document.body".
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function show():void
		{
			prepareDialog();
			_open = true;

			COMPILE::JS
			{
				dialog.show();
			}
		}

		/**
		 *  Closes the dialog element.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function close():void
		{
			_open = false;
			COMPILE::JS
			{
				dialog.close();
			}
			dispatchEvent(new Event("close"));
		}
		
		private var _open:Boolean;
		/**
		 *  Indicates whether the dialog is open.
		 *  see https://developer.mozilla.org/en-US/docs/Web/API/HTMLDialogElement/open
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function get open():Boolean
		{
			return _open;
		}
		
		override public function get visible():Boolean{
			return _open;
		}
		override public function set visible(value:Boolean):void{
			if(value)
				show();
			else
				close();
		}
	}
}
