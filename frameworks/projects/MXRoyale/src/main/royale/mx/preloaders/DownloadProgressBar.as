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

package mx.preloaders
{
	import mx.events.ProgressEvent;
	
	/**
	 *  The DownloadProgressBar class displays download progress.
	 *  It is used by the Preloader control to provide user feedback
	 *  while the application is downloading and loading. 
	 *
	 *  <p>The download progress bar displays information about 
	 *  two different phases of the application: 
	 *  the download phase and the initialization phase. </p>
	 *
	 *  <p>In the Application container, use the 
	 *  the <code>preloader</code> property to specify the name of your subclass.</p>
	 *
	 *  <p>You can implement a custom download progress bar component 
	 *  by creating a subclass of the DownloadProgressBar class. 
	 *  Do not implement a download progress bar as an MXML component 
	 *  because it loads too slowly.</p>
	 *
	 *  @see mx.core.Application
	 *  @see mx.preloaders.IPreloaderDisplay
	 *  @see mx.preloaders.Preloader
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public class DownloadProgressBar
	{
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  The minimum number of milliseconds
		 *  that the display should appear visible.
		 *  If the downloading and initialization of the application
		 *  takes less time than this value, then Flex pauses for this amount
		 *  of time before dispatching the <code>complete</code> event.
		 *
		 *  @default 0
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		protected var MINIMUM_DISPLAY_TIME:uint = 0;
		
		//----------------------------------
		//  downloadingLabel
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the downloadingLabel property.
		 */
		private var _downloadingLabel:String = "Loading";
		
		/**
		 *  The string to display as the label while in the downloading phase.
		 *
		 *  @default "Loading"
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		protected function get downloadingLabel():String
		{
			return _downloadingLabel;   
		}
		
		/**
		 *  @private
		 */
		protected function set downloadingLabel(value:String):void
		{
			_downloadingLabel = value;
		}
		
		//----------------------------------
		//  initializingLabel
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the initializingLabel property.
		 */
		private static var _initializingLabel:String = "Initializing";
		
		/**
		 *  The string to display as the label while in the initializing phase.
		 *
		 *  @default "Initializing"
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function get initializingLabel():String
		{
			return _initializingLabel;  
		}
		
		/**
		 *  @private
		 */
		public static function set initializingLabel(value:String):void
		{
			_initializingLabel = value;
		}   
		
		/**
		 *  Defines the algorithm for determining whether to show
		 *  the download progress bar while in the download phase.
		 *
		 *  @param elapsedTime number of milliseconds that have elapsed
		 *  since the start of the download phase.
		 *
		 *  @param event The ProgressEvent object that contains
		 *  the <code>bytesLoaded</code> and <code>bytesTotal</code> properties.
		 *
		 *  @return If the return value is <code>true</code>, then show the 
		 *  download progress bar.
		 *  The default behavior is to show the download progress bar 
		 *  if more than 700 milliseconds have elapsed
		 *  and if Flex has downloaded less than half of the bytes of the SWF file.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		protected function showDisplayForDownloading(elapsedTime:int,
													 event:ProgressEvent):Boolean
		{
			return elapsedTime > 700 &&
				event.bytesLoaded < event.bytesTotal / 2;
		}
		
		/**
		 *  Defines the algorithm for determining whether to show the download progress bar
		 *  while in the initialization phase, assuming that the display
		 *  is not currently visible.
		 *
		 *  @param elapsedTime number of milliseconds that have elapsed
		 *  since the start of the download phase.
		 *
		 *  @param count number of times that the <code>initProgress</code> event
		 *  has been received from the application.
		 *
		 *  @return If <code>true</code>, then show the download progress bar.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		protected function showDisplayForInit(elapsedTime:int, count:int):Boolean
		{
			return elapsedTime > 300 && count == 2;
		}
		
	}
}