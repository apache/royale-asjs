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
package org.apache.royale.core
{
COMPILE::SWF
{
    import flash.events.Event;
    import flash.external.ExternalInterface;
    import flash.utils.getQualifiedClassName;
}
COMPILE::JS
{
    import org.apache.royale.utils.BrowserInfo;
}
    import org.apache.royale.utils.OSUtils;
    import org.apache.royale.utils.sendStrandEvent;

    /**
     *  The BrowserOrientation class listens for browser
     *  resizing (only in devices) and dispatchh orientation change events.
     *   - if orientation is portratit it dispatches: 'orientationPortrait'
     *   - if orientation is ladspace it dispatches: 'orientationLandscape'
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.6
     */
	public class BrowserOrientation implements IBead
	{
        public static const LANDSCAPE:String = "Landscape";
        public static const PORTRAIT:String = "Portrait";
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
		public function BrowserOrientation()
		{
		}
		
        private var host:IUIBase;
        private var _strand:IStrand;
        
        /**
         *  @copy org.apache.royale.core.IBead#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         *  @royaleignorecoercion org.apache.royale.core.IInitialViewApplication
         */
        public function set strand(value:IStrand):void
        {
            _strand = value;
            host = value as IUIBase;
            if(OSUtils.getOS() == OSUtils.ANDROID_OS || OSUtils.getOS() == OSUtils.IOS_OS)
            {
            COMPILE::SWF
            {
                //host.$displayObject.stage.addEventListener("resize", resizeHandler);
            }
            COMPILE::JS
            {
                window.addEventListener('resize', resizeHandler);
                resizeHandler();
            }
            }
        }

        /**
         * store current device orientation. Values can be 'Landscape' or 'Portrait'
         */
        private var _orientation:String;

        [Bindable(event='orientationChanged')]
        public function get orientation():String
        {
        	return _orientation;
        }

        public function set orientation(value:String):void
        {
        	_orientation = value;
            sendStrandEvent(_strand,"orientationChanged");
        }
        
		/**
		 * @royaleignorecoercion org.apache.royale.core.ILayoutChild
		 */
        private function resizeHandler(event:Event  = null):void
        {
            COMPILE::SWF
            {
                // SWF to be implemented
            }
            COMPILE::JS
            {
                var outerWidth:Number = document.body.getBoundingClientRect().width;
                var outerHeight:Number = document.body.getBoundingClientRect().height;
                
                if(OSUtils.getOS() == OSUtils.IOS_OS)
                {
                    if (orientation != PORTRAIT && outerHeight > outerWidth) {
                        orientation = PORTRAIT;
                    } else if (orientation != LANDSCAPE && outerHeight < outerWidth) {
                        orientation = LANDSCAPE;
                    }
                } else if(OSUtils.getOS() == OSUtils.ANDROID_OS)
                {
                    if(orientation != PORTRAIT && screen.orientation.type.indexOf("portrait") != -1 ) {
                        orientation = PORTRAIT;
                    } else if (orientation != LANDSCAPE && screen.orientation.type.indexOf("landscape") != -1) {
                        orientation = LANDSCAPE;
                    }
                }
            }
        }
	}
}
