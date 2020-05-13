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
package org.apache.royale.jewel.beads.views
{
    COMPILE::SWF
	{
    import flash.utils.setTimeout;
	}
    COMPILE::JS
	{
    import org.apache.royale.core.UIBase;
    }
    import org.apache.royale.core.BeadViewBase;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.events.Event;
    import org.apache.royale.jewel.Snackbar;
    import org.apache.royale.jewel.beads.models.SnackbarModel;

    /**
	 *  The SnackbarView class creates the visual elements of the org.apache.royale.jewel.Snackbar 
	 *  component. The job of the view bead is to put together the parts of the Snackbar such as the message
	 *  text and action clicked dispatches action event on behalf of the Snackbar.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class SnackbarView extends BeadViewBase
	{
		/**
		 *  constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function SnackbarView()
		{
            super();
		}

        /**
		 * The Snackbar component
		 */
        protected var host:Snackbar;

        /**
		 * The action element that parents the action
		 */
        COMPILE::JS
		protected var actionElement:Element;
		
        /**
         *  @copy org.apache.royale.core.IBead#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;

            host = value as Snackbar;
            var model:SnackbarModel = host.model as SnackbarModel;
            model.addEventListener("messageChange", messageChangeHandler);
            model.addEventListener("actionChange", actionChangeHandler);

            COMPILE::JS
            {
                var messageElement:Element = document.createElement("div");
                messageElement.className = "jewel snackbar-message";
                messageElement.innerHTML = model.message;

                var contentElement:Element = document.createElement("div");
                contentElement.className = "jewel snackbar-content";
                contentElement.appendChild(messageElement);

                host.element.appendChild(contentElement);
            }

            if (model.action) actionChangeHandler(null);

            setTimeout(prepareForPopUp,  300);
        }

        private function prepareForPopUp():void
        {
			COMPILE::JS
			{
				UIBase(_strand).element.classList.add("open");
			}
		}


        /**
         *  Update the text when message changed. 
         */
        private function messageChangeHandler(event:Event):void {
            COMPILE::JS
            {
                HTMLElement(host.element.firstChild.firstChild).innerHTML = SnackbarModel(host.model).message;
            }
        }

        /**
         *  Show the action element or remove it, based on action text.
         */
        private function actionChangeHandler(event:Event):void {
            var model:SnackbarModel = host.model as SnackbarModel;

            COMPILE::JS
            {
            if (model.action) {
				if (!actionElement) {
					actionElement = document.createElement("div");
					actionElement.className = "jewel snackbar-action";
					actionElement.addEventListener("click", actionClickHandler);
					host.element.firstChild.appendChild(actionElement);
				}
				actionElement.innerText = model.action;
			} else {
				if (actionElement) {
					actionElement.removeEventListener("click", actionClickHandler);
					host.element.firstChild.removeChild(actionElement);
					actionElement = null;
				}
			}
            }
        }

        /**
         *  Trigger event and dismiss the host when action clicked.
         */
        private function actionClickHandler(event:Event):void {
            COMPILE::JS
            {
            actionElement.removeEventListener("click", actionClickHandler);
            host.dispatchEvent(new Event(Snackbar.ACTION));
            SnackbarModel(host.model).duration = -1; // set -1 to dismiss
            }
        }

    }
}
