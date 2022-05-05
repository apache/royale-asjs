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
package org.apache.royale.jewel
{
	import org.apache.royale.media.VideoElement;
	import org.apache.royale.core.StyledUIBase;

    COMPILE::JS
    {
	import org.apache.royale.core.WrappedHTMLElement;
	import org.apache.royale.html.util.addElementToWrapper;
    }

	public class VideoPlayer extends VideoElement 
	{

		

		private var _scaleMode:String;

		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function VideoPlayer()
		{
			super();
            typeNames = "jewel videoplayer";
		}


		//letterbox
		//zoom
		//strech
		[Inspectable(category="General",enumeration="letterbox,zoom,strech")]
		public function set scaleMode(value:String):void
		{
			COMPILE::JS{
				if (_scaleMode == value) return;

				replaceClass(_scaleMode,value);
				_scaleMode = value;
			}
		}

		COMPILE::JS
		public function get scaleMode():String
		{
			return _scaleMode;
		}



        
		COMPILE::JS
		public function showNativeControl(value:Boolean):void
		{
		/*	if (value == true){
				if (element.hasAttribute("controls") == false) {
					element.setAttribute("controls","controls")   
				}
			}
			else{
				if (element.hasAttribute("controls")) {
					element.removeAttribute("controls")   
				} else {
					element.setAttribute("controls","controls")   
				}
			}*/
		}

        
	}
}
