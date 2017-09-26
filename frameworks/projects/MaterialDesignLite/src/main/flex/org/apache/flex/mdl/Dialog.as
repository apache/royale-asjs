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
package org.apache.flex.mdl
{
	import org.apache.flex.html.Group;
	import org.apache.flex.mdl.Application;
	import org.apache.flex.core.IPopUp;

    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;
		import org.apache.flex.html.addElementToWrapper;
    }

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
	 *  @productversion FlexJS 0.8
	 */
	public class Dialog extends Group implements IPopUp
	{
		/**
		 *  constructor.
         *
         *  <inject_html>
         *  <link rel="stylesheet" type="text/css" href="//cdnjs.cloudflare.com/ajax/libs/dialog-polyfill/0.4.5/dialog-polyfill.min.css">
         *  <script src="//cdnjs.cloudflare.com/ajax/libs/dialog-polyfill/0.4.5/dialog-polyfill.min.js"></script>
         *  </inject_html>
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function Dialog()
		{
			super();

			className = ""; //set to empty string avoid 'undefined' output when no class selector is assigned by user;
		}

		/**
		 * The html dialog component that parents the dialog content
		 */
		COMPILE::JS
		private var dialog:HTMLDialogElement;

        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
		 * @flexjsignorecoercion HTMLDialogElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			typeNames = "mdl-dialog";

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
		 *  @productversion FlexJS 0.8
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
						dialogPolyfill["registerDialog"](dialog);
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
		 *  @productversion FlexJS 0.8
		 */
		public function showModal():void
		{
			prepareDialog();

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
		 *  @productversion FlexJS 0.8
		 */
		public function show():void
		{
			prepareDialog();

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
		 *  @productversion FlexJS 0.8
		 */
		public function close():void
		{
			COMPILE::JS
			{
				dialog.close();
			}
		}
	}
}
