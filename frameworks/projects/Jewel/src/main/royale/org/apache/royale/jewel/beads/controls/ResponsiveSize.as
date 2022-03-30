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
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.StyledUIBase;
    import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.Event;
	import org.apache.royale.jewel.supportClasses.ResponsiveSizes;

	/**
	 *  The ResponsiveSize bead class is a specialty bead that can be used to change the 
     *  size of a Jewel control depending on responsiveness.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.8
	 */
	public class ResponsiveSize implements IBead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 */
		public function ResponsiveSize()
		{
		}

		private var _phoneWidth:Number;
        /**
         * the width of this control in phones
         */
        public function get phoneWidth():Number {
            return _phoneWidth;
        }
        public function set phoneWidth(value:Number):void {
            _phoneWidth = value;
        }

		private var _phonePercentWidth:Number;
        /**
         * the percent width of this control in phones
         */
        public function get phonePercentWidth():Number {
            return _phonePercentWidth;
        }
        public function set phonePercentWidth(value:Number):void {
            _phonePercentWidth = value;
        }

        private var _phoneHeight:Number;
        /**
         * the height of this control in phones
         */
        public function get phoneHeight():Number {
            return _phoneHeight;
        }
        public function set phoneHeight(value:Number):void {
            _phoneHeight = value;
        }
		
        private var _phonePercentHeight:Number;
        /**
         * the percent height of this control in phones
         */
        public function get phonePercentHeight():Number {
            return _phonePercentHeight;
        }
        public function set phonePercentHeight(value:Number):void {
            _phonePercentHeight = value;
        }

        private var _tabletWidth:Number;
        /**
         * the width of this control in tablets
         */
        public function get tabletWidth():Number {
            return _tabletWidth;
        }
        public function set tabletWidth(value:Number):void {
            _tabletWidth = value;
        }
		
        private var _tabletPercentWidth:Number;
        /**
         * the percent width of this control in tablets
         */
        public function get tabletPercentWidth():Number {
            return _tabletPercentWidth;
        }
        public function set tabletPercentWidth(value:Number):void {
            _tabletPercentWidth = value;
        }

        private var _tabletHeight:Number;
        /**
         * the height of this control in tablets
         */
        public function get tabletHeight():Number {
            return _tabletHeight;
        }
        public function set tabletHeight(value:Number):void {
            _tabletHeight = value;
        }
        
        private var _tabletPercentHeight:Number;
        /**
         * the percent height of this control in tablets
         */
        public function get tabletPercentHeight():Number {
            return _tabletPercentHeight;
        }
        public function set tabletPercentHeight(value:Number):void {
            _tabletPercentHeight = value;
        }

        private var _desktopWidth:Number;
        /**
         * the width of this control in desktops
         */
        public function get desktopWidth():Number {
            return _desktopWidth;
        }
        public function set desktopWidth(value:Number):void {
            _desktopWidth = value;
        }
		
        private var _desktopPercentWidth:Number;
        /**
         * the percent width of this control in desktops
         */
        public function get desktopPercentWidth():Number {
            return _desktopPercentWidth;
        }
        public function set desktopPercentWidth(value:Number):void {
            _desktopPercentWidth = value;
        }

        private var _desktopHeight:Number;
        /**
         * the height of this control in desktops
         */
        public function get desktopHeight():Number {
            return _desktopHeight;
        }
        public function set desktopHeight(value:Number):void {
            _desktopHeight = value;
        }
        
        private var _desktopPercentHeight:Number;
        /**
         * the percent height of this control in desktops
         */
        public function get desktopPercentHeight():Number {
            return _desktopPercentHeight;
        }
        public function set desktopPercentHeight(value:Number):void {
            _desktopPercentHeight = value;
        }

        private var _widescreenWidth:Number;
        /**
         * the width of this control in widescreens
         */
        public function get widescreenWidth():Number {
            return _widescreenWidth;
        }
        public function set widescreenWidth(value:Number):void {
            _widescreenWidth = value;
        }
		
        private var _widescreenPercentWidth:Number;
        /**
         * the percent width of this control in widescreens
         */
        public function get widescreenPercentWidth():Number {
            return _widescreenPercentWidth;
        }
        public function set widescreenPercentWidth(value:Number):void {
            _widescreenPercentWidth = value;
        }

        private var _widescreenHeight:Number;
        /**
         * the height of this control in widescreens
         */
        public function get widescreenHeight():Number {
            return _widescreenHeight;
        }
        public function set widescreenHeight(value:Number):void {
            _widescreenHeight = value;
        }

        private var _widescreenPercentHeight:Number;
        /**
         * the percent height of this control in widescreens
         */
        public function get widescreenPercentHeight():Number {
            return _widescreenPercentHeight;
        }
        public function set widescreenPercentHeight(value:Number):void {
            _widescreenPercentHeight = value;
        }

        private var control:StyledUIBase;
        private var originalWidth:Number = NaN;
        private var originalHeight:Number = NaN;
        private var originalPercenWidth:Number = NaN;
        private var originalPercenHeight:Number = NaN;
        
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 *  @royaleignorecoercion org.apache.royale.core.IStrand;
		 */
		public function set strand(value:IStrand):void
		{
            control = value as StyledUIBase;
            if(control.width != 0)
                originalWidth = control.width;
            if(control.height != 0)
                originalHeight = control.height;
            if(control.percentWidth != 0)
                originalPercenWidth = control.percentWidth;
            if(control.percentHeight != 0)
                originalPercenHeight = control.percentHeight;

            COMPILE::JS
            {
            window.addEventListener('resize', resizeHandler, false);
            }
            
            resizeHandler();
        }

        /**
         * to check only width
         */
        private var outerWidth:Number;

        /**
		 *  Make the strand change size as browser is resized
		 */
        private function resizeHandler(event:Event = null):void
        {
            COMPILE::JS
            {
                var widthall:Number =  document.body.getBoundingClientRect().width;
                if(outerWidth == widthall)
                    return;

                outerWidth = widthall;
                
                var responsiveFlag:Boolean = false;

                if(outerWidth < ResponsiveSizes.FULL_BREAKPOINT && outerWidth >= ResponsiveSizes.WIDESCREEN_BREAKPOINT)
                {
                    if(!isNaN(widescreenWidth) || !isNaN(widescreenHeight))
                    {
                        // trace("WIDESCREEN");
                        if(widescreenWidth != originalWidth)
                            control.width = widescreenWidth;
                        if(widescreenHeight != originalHeight)
                            control.height = widescreenHeight;
                        responsiveFlag = true;
                    
                    }                    
                    if( !isNaN(widescreenPercentWidth) || !isNaN(widescreenPercentHeight) )
                    {
                        if(widescreenPercentWidth != originalPercenWidth)
                            control.percentWidth = widescreenPercentWidth;
                        if(widescreenPercentHeight != originalPercenHeight)
                            control.percentHeight = widescreenPercentHeight;
                        responsiveFlag = true;

                    }
                } 
                else if(outerWidth < ResponsiveSizes.WIDESCREEN_BREAKPOINT && outerWidth >= ResponsiveSizes.DESKTOP_BREAKPOINT)
                {
                    if(!isNaN(desktopWidth) || !isNaN(desktopHeight))
                    {
                        // trace("DESKTOP");
                        if(desktopWidth != originalWidth)
                            control.width = desktopWidth;
                        if(desktopHeight != originalHeight)
                            control.height = desktopHeight;
                        responsiveFlag = true;
                    
                    }
                    if( !isNaN(desktopPercentWidth) || !isNaN(desktopPercentHeight) )
                    {
                        if(desktopPercentWidth != originalPercenWidth)
                            control.percentWidth = desktopPercentWidth;
                        if(desktopPercentHeight != originalPercenHeight)
                            control.percentHeight = desktopPercentHeight;
                        responsiveFlag = true;

                    }
                }
                else if(outerWidth < ResponsiveSizes.DESKTOP_BREAKPOINT && outerWidth >= ResponsiveSizes.TABLET_BREAKPOINT)
                {
                    if(!isNaN(tabletWidth) || !isNaN(tabletHeight))
                    {
                        // trace("TABLET");
                        if(tabletWidth != originalWidth)
                            control.width = tabletWidth;
                        if(tabletHeight != originalHeight)
                            control.height = tabletHeight;
                        responsiveFlag = true;
                    
                    }
                    if( !isNaN(tabletPercentWidth) || !isNaN(tabletPercentHeight) )
                    {
                        if(tabletPercentWidth != originalPercenWidth)
                            control.percentWidth = tabletPercentWidth;
                        if(tabletPercentHeight != originalPercenHeight)
                            control.percentHeight = tabletPercentHeight;
                        responsiveFlag = true;

                    }
                }
                else if(outerWidth < ResponsiveSizes.TABLET_BREAKPOINT && outerWidth >= ResponsiveSizes.PHONE_BREAKPOINT)
                {
                    if(!isNaN(phoneWidth) || !isNaN(phoneHeight))
                    {
                        // trace("PHONE");
                        if(phoneWidth != originalWidth)
                            control.width = phoneWidth;
                        if(phoneHeight != originalHeight)
                            control.height = phoneHeight;
                        responsiveFlag = true;
                    
                    }
                    if( !isNaN(phonePercentWidth) || !isNaN(phonePercentHeight) )
                    {
                        if(phonePercentWidth != originalPercenWidth)
                            control.percentWidth = phonePercentWidth;
                        if(phonePercentHeight != originalPercenHeight)
                            control.percentHeight = phonePercentHeight;
                        responsiveFlag = true;
                    }
                }

                if(!responsiveFlag)
                {
                    if( !isNaN(originalHeight) || !isNaN(originalWidth) )
                    {
                        if(control.width != originalWidth)
                            control.width = originalWidth;
                        
                        if(control.height != originalHeight)
                            control.height = originalHeight;
                    }
                    if( !isNaN(originalPercenHeight) || !isNaN(originalPercenWidth) )
                    {
                        if(control.percentWidth != originalPercenWidth)
                            control.percentWidth = originalPercenWidth;
                        if(control.percentHeight != originalPercenHeight)
                            control.percentHeight = originalPercenHeight;
                    }

                }
            }
        }
	}
}
