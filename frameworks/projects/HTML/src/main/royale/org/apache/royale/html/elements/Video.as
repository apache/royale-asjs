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
package org.apache.royale.html.elements
{
    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
		import org.apache.royale.html.util.addElementToWrapper;
    }
    import org.apache.royale.html.NodeElementBase;

	/**
	 *  The Video class represents an HTML <video> element
     *  
	 *  
     *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.8
	 */
	public class Video extends NodeElementBase
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 */
		public function Video()
		{
			super();
		}

		COMPILE::SWF
        private var _autoplay:Boolean;

        /**
         *  Whether the video is autoplay
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.8
         */
        public function get autoplay():Boolean
        {
            COMPILE::SWF
            {
                return _autoplay;
            }

            COMPILE::JS
            {
                return (element as HTMLVideoElement).autoplay;
            }
        }

        public function set autoplay(value:Boolean):void
        {
            COMPILE::SWF
            {
                _autoplay = value;
            }
            COMPILE::JS
            {
                (element as HTMLVideoElement).autoplay = value;
            }
        }

        COMPILE::SWF
        private var _paused:Boolean;

        /**
         *  Whether the video is paused
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.8
         */
        public function get paused():Boolean
        {
            COMPILE::SWF
            {
                return _paused;
            }

            COMPILE::JS
            {
                return (element as HTMLVideoElement).paused;
            }
        }

        COMPILE::JS
        /**
         *  Start video
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.8
         */
        public function play()
        {
            COMPILE::JS
            {
                (element as HTMLMediaElement).play();
            }
        }

        COMPILE::JS
        /**
         *  Pause video
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.8
         */
        public function pause()
        {
            COMPILE::JS
            {
                (element as HTMLMediaElement).pause();
            }
        }

        COMPILE::JS
        /**
         *  Resets the media element to its initial state and begins the process of selecting
         *  a media source and loading the media in preparation for playback to begin at the beginning.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.8
         */
        public function load()
        {
            COMPILE::JS
            {
                (element as HTMLMediaElement).load();
            }
        }

        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			return addElementToWrapper(this,'video');
        }
    }
}
