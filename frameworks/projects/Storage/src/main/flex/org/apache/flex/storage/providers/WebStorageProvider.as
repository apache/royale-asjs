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
package org.apache.flex.storage.providers
{
	import org.apache.flex.events.EventDispatcher;
	import org.apache.flex.events.IEventDispatcher;

	import org.apache.flex.storage.events.FileReadEvent;
    import org.apache.flex.storage.events.FileWriteEvent;

	/**
	 * The WebStorageProvider class implements the IPermanentStorageProvider
	 * interface for saving files to a mobile device. 
	 * 
	 * @flexjsignorecoercion FileEntry
	 * @flexjsignorecoercion FileWriter
	 * @flexjsignorecoercion window
     * @flexjsignorecoercion Blob
	 */
	public class WebStorageProvider extends EventDispatcher implements IPermanentStorageProvider
	{
		/**
		 * Constructor.
		 * 
		 * @param target The target dispatcher for events as files are read and written.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function WebStorageProvider(target:IEventDispatcher=null)
		{
			super();
			_target = target;
		}

		/**
		 * @private
		 */
		private var _target:IEventDispatcher;

		/**
		 * The target dispatcher for events as files are read and written.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get target():IEventDispatcher
		{
			return _target;
		}
		public function set target(value:IEventDispatcher):void
		{
			_target = value;
		}
		
		/**
		 * A convenience function to read an entire file as a single 
		 * string of text. The file is storaged in the application's
		 * data storage directory. Dispatches a FileRead event once
		 * the data is available.
		 * 
		 *  @param fileName The name of the file.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function readTextFromDataFile( fileName:String ) : void
		{
			COMPILE::JS {
				var fullPath:String = String(cordova["file"]["dataDirectory"]) + fileName;
				
				window.resolveLocalFileSystemURL(fullPath, function (fileEntry):void {
					fileEntry.file(function (file):void {
						var reader:FileReader = new FileReader();
						reader.onloadend = function (e):void {
							var newEvent:FileReadEvent = new FileReadEvent("COMPLETE");
							newEvent.data = this.result;
							_target.dispatchEvent(newEvent);
						};
						reader.readAsText(file);
					}, function (e):void {
						var errEvent:FileReadEvent = new FileReadEvent("ERROR");
						errEvent.errorMessage = "Cannot open file for reading";
						_target.dispatchEvent(errEvent);
					});
				}, function (e):void {
					var errEvent:FileReadEvent = new FileReadEvent("ERROR");
					errEvent.errorMessage = "File does not exist";
					_target.dispatchEvent(errEvent);
				});
			}
		}
		
		/**
		 * A convenience function write a string into a file that resides in the
		 * application's data storage directory. If the file already exists it is 
		 * replaced with the string. Dispatches a FileWrite event once the file
		 * has been written.
		 * 
		 *  @param fileName The name of file.
		 *  @param text The string to be stored.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function writeTextToDataFile( fileName:String, text:String ) : void
		{
			COMPILE::JS {
				var fullPath:String = String(cordova["file"]["dataDirectory"]) + fileName;
		
				window.resolveLocalFileSystemURL(cordova.file.dataDirectory, function (directoryEntry):void {
					directoryEntry.getFile(fileName, { 'create': true }, function (fileEntry):void {
						fileEntry.createWriter(function (fileWriter):void {
							fileWriter.onwriteend = function (e):void {
								var newEvent:FileWriteEvent = new FileWriteEvent("COMPLETE");
								_target.dispatchEvent(newEvent);
							};
							
							fileWriter.onerror = function (e):void {
								var newEvent:FileWriteEvent = new FileWriteEvent("ERROR");
								newEvent.errorMessage = "Failed to write the file.";
								_target.dispatchEvent(newEvent);
							};
							
							var blob:Blob = new Blob([text], { type: 'text/plain' });
							fileWriter.write(blob);
						}, function(e):void {
							var errEvent:FileWriteEvent = new FileWriteEvent("ERROR");
							errEvent.errorMessage = "Cannot open file for writing.";
							_target.dispatchEvent(errEvent);
						});
					}, function(e):void {
						var errEvent:FileWriteEvent = new FileWriteEvent("ERROR");
						errEvent.errorMessage = "Cannot create file.";
						_target.dispatchEvent(errEvent);
					});
				}, function(e):void {
					var errEvent:FileWriteEvent = new FileWriteEvent("ERROR");
					errEvent.errorMessage = "Cannot create file.";
					_target.dispatchEvent(errEvent);
				});
			}
		}
	}
}
