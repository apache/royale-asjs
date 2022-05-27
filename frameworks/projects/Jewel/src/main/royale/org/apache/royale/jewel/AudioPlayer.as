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
	COMPILE::JS{		
		import org.apache.royale.html5.AudioElement;
	}


	/**
	 *  AudioPlayer let you to play audio with segments progressive download.
	 *  You can also seek to an unloaded part and change playback rate.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 0.0
	 *  @playerversion AIR 0.0
	 *  @productversion Royale 0.0
	 */
	COMPILE::JS
	public class AudioPlayer extends AudioElement 
	{


		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 0.0
		 *  @playerversion AIR 0.0
		 *  @productversion Royale 0.0
		 */
		public function AudioPlayer()
		{
			super();
            typeNames = "jewel audioplayer";
		}
	
        
/*		COMPILE::JS
		public function showJewelControl(value:Boolean):void
		{
		}
*/
        
	}

	COMPILE::SWF	
	public class AudioPlayer{}
}
