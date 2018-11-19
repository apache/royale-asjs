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
package org.apache.royale.jewel.beads.controls.drawer
{	
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.jewel.Drawer;
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
	public class ResponsiveDrawer implements IBead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function ResponsiveDrawer()
		{
		}

		private var drawer:Drawer;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion HTMLInputElement
		 *  @royaleignorecoercion org.apache.royale.core.UIBase;
		 */
		public function set strand(value:IStrand):void
		{
			drawer = value as Drawer;

			if(drawer)
			{
				updateDrawer();
			}
			else
			{
				throw new Error ("ResponsiveDrawer must be used with Drawer class");
			}
		}

		protected var _auto:Boolean = false;
        /**
		 *  A boolean flag to activate "auto" effect selector.
		 *  Optional. Makes the drawer auto adapt using 
		 *  a float behaviour on mobile and tablets and fixed
		 *  behaviour on desktop.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
        public function get auto():Boolean
        {
            return _auto;
        }
        public function set auto(value:Boolean):void
        {
            if (_auto != value)
            {
                _auto = value;

                updateDrawer();
            }
        }

		private function updateDrawer():void
		{
			if (drawer)
            {
				COMPILE::JS
				{
				if(_auto)
				{
					window.addEventListener('resize', autoResizeHandler, false);
				}
				else
				{
					window.removeEventListener('resize', autoResizeHandler, false);
				}
				}

                drawer.toggleClass("auto", _auto);
				autoResizeHandler();
            }
		}

		/**
		 *  When set to "auto" this resize handler monitors the width of the app window
		 *  and switch between fixed and float modes.
		 * 
		 *  Note:This could be done with media queries, but since it handles open/close
		 *  maybe this is the right way
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
				var outerWidth:Number = document.body.getBoundingClientRect().width;
				var tmpFixed:Boolean = drawer.fixed;

				// Desktop width size
				if(outerWidth > ResponsiveSizes.DESKTOP_BREAKPOINT)
				{
					drawer.fixed = true;
					if(tmpFixed != drawer.fixed)
					{
						drawer.open();
					}
				}
				else
				{
					drawer.fixed = false;
					if(tmpFixed != drawer.fixed)
					{
						drawer.close();
					}
				}

			}
		}
	}
}
