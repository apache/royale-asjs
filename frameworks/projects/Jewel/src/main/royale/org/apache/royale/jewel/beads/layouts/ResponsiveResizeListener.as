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
package org.apache.royale.jewel.beads.layouts
{
    import org.apache.royale.core.Bead;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.UIBase;
    import org.apache.royale.events.Event;
    import org.apache.royale.jewel.supportClasses.ResponsiveSizes;
    import org.apache.royale.utils.sendStrandEvent;

    /**
     *  The ResponsiveResizeListener class listens for browser
     *  resizing and send events when browser cross a responsive breakpoint
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.10.0
     */
	public class ResponsiveResizeListener extends Bead
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.10.0
         */
		public function ResponsiveResizeListener()
		{
		}
		
        /**
         *  @copy org.apache.royale.core.IBead#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.10.0
         */
        override public function set strand(value:IStrand):void
        {
            super.strand = value as UIBase;
            COMPILE::JS
            {
            window.addEventListener('resize', resizeHandler, false);
            }
            listenOnStrand("beadsAdded", beadsAddedHandler);
        }

        public function beadsAddedHandler(event:Event):void
        {
            resizeHandler();
        }

        private var _currentResponsiveSize:String;
        /**
         * the current responsive size. read only
         */
        public function get currentResponsiveSize():String
        {
        	return _currentResponsiveSize;
        }
        
        /**
         * to check only width
         */
        private var outerWidth:Number;

		/**
		 *  Make the strand send events when browser is resized and cross a responsive breakpoint
		 */
        private function resizeHandler(event:Event = null):void
        {
            COMPILE::JS
            {
                if(outerWidth == document.body.getBoundingClientRect().width)
                    return;

                outerWidth = document.body.getBoundingClientRect().width;
                
                if(outerWidth > ResponsiveSizes.FULL_BREAKPOINT)
                {
                    if(currentResponsiveSize != ResponsiveSizes.FULL)
                    {
                        // trace("FULL");
                        _currentResponsiveSize = ResponsiveSizes.FULL;
                        sendStrandEvent(_strand, 'fullResponsiveSize');
                    }
                } else if(outerWidth < ResponsiveSizes.FULL_BREAKPOINT && outerWidth > ResponsiveSizes.WIDESCREEN_BREAKPOINT)
                {
                    if(currentResponsiveSize != ResponsiveSizes.WIDESCREEN)
                    {
                        // trace("WIDESCREEN");
                        _currentResponsiveSize = ResponsiveSizes.WIDESCREEN;
                        sendStrandEvent(_strand, 'widescreenResponsiveSize');
                    }
                } else if(outerWidth < ResponsiveSizes.WIDESCREEN_BREAKPOINT && outerWidth > ResponsiveSizes.DESKTOP_BREAKPOINT)
                {
                    if(currentResponsiveSize != ResponsiveSizes.DESKTOP)
                    {
                        // trace("DESKTOP");
                        _currentResponsiveSize = ResponsiveSizes.DESKTOP;
                        sendStrandEvent(_strand, 'desktopResponsiveSize');
                    }
                } else if(outerWidth < ResponsiveSizes.DESKTOP_BREAKPOINT && outerWidth > ResponsiveSizes.TABLET_BREAKPOINT)
                {
                    if(currentResponsiveSize != ResponsiveSizes.TABLET)
                    {
                        // trace("TABLET");
                        _currentResponsiveSize = ResponsiveSizes.TABLET;
                        sendStrandEvent(_strand, 'tabletResponsiveSize');
                    }
                } else if(outerWidth < ResponsiveSizes.TABLET_BREAKPOINT && outerWidth > ResponsiveSizes.PHONE_BREAKPOINT)
                {
                    if(currentResponsiveSize != ResponsiveSizes.PHONE)
                    {
                        // trace("PHONE");
                        _currentResponsiveSize = ResponsiveSizes.PHONE;
                        sendStrandEvent(_strand, 'phoneResponsiveSize');
                    }
                }
            }
        }
	}
}
