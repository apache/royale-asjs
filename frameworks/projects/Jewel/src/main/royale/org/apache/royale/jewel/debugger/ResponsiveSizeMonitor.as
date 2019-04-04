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
package org.apache.royale.jewel.debugger
{	
	import org.apache.royale.events.Event;
	import org.apache.royale.jewel.Label;
	import org.apache.royale.jewel.supportClasses.ResponsiveSizes;
	
	/**
	 *  The ResponsiveDrawer class is a bead to use with Jewel Drawer to make it fixed or
	 *  float depending on the screen size.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class ResponsiveSizeMonitor extends Label
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function ResponsiveSizeMonitor()
		{
            typeNames="responsiveSizeMonitor";
            multiline = true;

            text="ResponsiveSizeMonitor";

            //style= "background:rgba(0,0,0,0.8);color:white;padding:10px;position:fixed;bottom:0;width:250px";
		}

        override public function addedToParent():void
        {
            super.addedToParent();
            setUpListener();
        }

		private function setUpListener():void
		{
            COMPILE::JS
            {
            window.addEventListener('resize', autoResizeHandler, false);
            }
            autoResizeHandler();
		}
		private function removeListener():void
		{
            COMPILE::JS
            {
                window.removeEventListener('resize', autoResizeHandler, false);
            }
		}

		/**
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		private function autoResizeHandler(event:Event = null):void
        {
			COMPILE::JS
			{
				// Desktop width size
				//if(outerWidth > ResponsiveSizes.DESKTOP_BREAKPOINT)
				html = "<strong>Screen size (px):</strong> " + document.body.getBoundingClientRect().width + "x" + document.body.getBoundingClientRect().height + "</br>";
				html += "<strong>PHONE_BREAKPOINT: </strong> " + ResponsiveSizes.PHONE_BREAKPOINT + "</br>";
				html += "<strong>TABLET_BREAKPOINT:</strong> " + ResponsiveSizes.TABLET_BREAKPOINT + "</br>";
				html += "<strong>DESKTOP_BREAKPOINT:</strong> " + ResponsiveSizes.DESKTOP_BREAKPOINT + "</br>";
				html += "<strong>WIDESCREEN_BREAKPOINT:</strong> " + ResponsiveSizes.WIDESCREEN_BREAKPOINT + "</br>";
			}
		}
	}
}
