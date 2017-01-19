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
	import org.apache.flex.core.ContainerBase;
	import org.apache.flex.mdl.Application;
	import org.apache.flex.core.IPopUp;
    
    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;
    }
    
	/**
	 *  The Dialog class
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class Dialog extends ContainerBase implements IPopUp
	{
		/**
		 *  constructor.
         *  
         *  <inject_html>
         *  <link rel="stylesheet" href="http://cdn.bootcss.com/dialog-polyfill/0.4.5/dialog-polyfill.min.css">
         *  <link rel="stylesheet" href="http://cdn.bootcss.com/dialog-polyfill/0.4.5/dialog-polyfill.min.js">
         *  </inject_html>
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function Dialog()
		{
			super();

			className = ""; //set to empty string avoid 'undefined' output when no class selector is assigned by user;
		}

		COMPILE::JS
		private var dialog:HTMLDialogElement;

        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
		 * @flexjsignorecoercion HTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			typeNames = "mdl-dialog";
            
            dialog = document.createElement('dialog') as HTMLDialogElement;
			element = dialog as WrappedHTMLElement;

			positioner = element;
            
            // absolute positioned children need a non-null
            // position value in the parent.  It might
            // get set to 'absolute' if the container is
            // also absolutely positioned
            element.flexjs_wrapper = this;

            return element;
        }

		/**
		 * flag to ensure only one dialog is created
		 */
		private var lockDialogCreation:Boolean = false;

		/**
		 *  This function make the dialog be added to document.body only once
		 *  The parent in MDL must be the Application (IPopUpHost) as MDL requisite
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function showModal():void
		{
			COMPILE::JS
			{
				if(!lockDialogCreation)
				{
					lockDialogCreation = true;

					if(Application.topLevelApplication != null)
					{
						Application.topLevelApplication.addElement(this);
					}
				}
				
				if (! dialog.showModal) {
					//dialogPolyfill.registerDialog(dialog);
				}

				dialog.showModal();
			}
		}
		
		/**
		 * show
		 */
		public function show():void
		{
			COMPILE::JS
			{
				dialog.show();
			}
		}

		/**
		 * close
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
