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

package org.apache.royale.media
{
	import org.apache.royale.media.MediaElement;
	
	COMPILE::JS
    {
		import org.apache.royale.core.WrappedHTMLElement;
		import org.apache.royale.html.util.addElementToWrapper;
    }

	public class VideoElement extends MediaElement
	{


		public function VideoElement()
		{
			super();
		}
		
		/**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {			
            addElementToWrapper(this, 'video');

			element.addEventListener("abort",handleEvent);
			element.addEventListener("canplay",handleEvent);
			element.addEventListener("canplaythrough",handleEvent);
			element.addEventListener("durationchange",handleEvent);
			element.addEventListener("emptied",handleEvent);
			element.addEventListener("ended",handleEvent);
			element.addEventListener("loadeddata",handleEvent);
			element.addEventListener("loadedmetadata",handleEvent);
			element.addEventListener("loadstart",handleEvent);
			element.addEventListener("pause",handleEvent);
			element.addEventListener("play",handleEvent);
			element.addEventListener("playing",handleEvent);
			element.addEventListener("progress",handleEvent);
			element.addEventListener("ratechange",handleEvent);
			element.addEventListener("seeked",handleEvent);
			element.addEventListener("seeking",handleEvent);
			element.addEventListener("stalled",handleEvent);
			element.addEventListener("suspend",handleEvent);
			element.addEventListener("timeupdate",handleEvent);
			element.addEventListener("volumechange",handleEvent);
			element.addEventListener("waiting",handleEvent);
			element.addEventListener("error",handleEvent);
			
            return element;
        }


		COMPILE::JS
		private function handleEvent(e:Event):void{
			dispatchEvent(new Event(e.type));
		}

		COMPILE::JS
		public function get videoHeight():uint
		{
			return (element as HTMLVideoElement).videoHeight;
		}

		COMPILE::JS
		public function get videoWidth():uint
		{
			return (element as HTMLVideoElement).videoWidth;
		}

		/*COMPILE::JS
		public function set disablePictureInPicture(value:Boolean):void
		{
			(element as HTMLVideoElement).disablePictureInPicture = value;
		}


        COMPILE::JS
		public function get disablePictureInPicture():Boolean
		{
			return(element as HTMLVideoElement).disablePictureInPicture;
		}*/




	}
}