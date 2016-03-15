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
	
	COMPILE::AS3 {
		import flash.filesystem.File;
		import flash.filesystem.FileMode;
		import flash.filesystem.FileStream;
		import flash.utils.ByteArray;
		import flash.errors.IOError;
	}

	import org.apache.flex.storage.events.FileReadEvent;
	import org.apache.flex.storage.events.FileWriteEvent;

	/**
	 * The AirStorageProvider class implements the IPermanentStorageProvider
	 * interface for saving files to a mobile device using the Adobe(tm) AIR platform. 
	 * 
	 * @flexjsignorecoercion FileEntry
	 * @flexjsignorecoercion FileWriter
	 * @flexjsignorecoercion window
	 * @flexjsignorecoercion Blob
	 */
	public class AirStorageProvider extends EventDispatcher implements IPermanentStorageProvider
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
		public function AirStorageProvider(target:IEventDispatcher=null)
		{
			super();
			_target = target;
		}

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
		 * @private
		 */
		private var _target:IEventDispatcher;
		
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
			COMPILE::AS3 {
				var file:File = File.applicationStorageDirectory.resolvePath(fileName);
				
				if (!file.exists) {
					var errEvent:FileReadEvent = new FileReadEvent("ERROR");
					errEvent.errorMessage = "File does not exist.";
					_target.dispatchEvent(errEvent);
					return;
				}
				
				var stream:FileStream = new FileStream();
				
				stream.open(file, FileMode.READ);
				var bytes:ByteArray = new ByteArray();
				stream.readBytes(bytes);
				stream.close();
				
				var text:String = new String(bytes);
				
				var newEvent:FileReadEvent = new FileReadEvent("COMPLETE");
				newEvent.data = text;
				_target.dispatchEvent(newEvent);
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
			COMPILE::AS3 {
				var file:File = File.applicationStorageDirectory.resolvePath(fileName);
				var stream:FileStream = new FileStream();
				
				try {
					stream.open(file, FileMode.WRITE);
					stream.writeUTFBytes(text);
					stream.close();
				} catch(ioerror:IOError) {
					var ioEvent:FileWriteEvent = new FileWriteEvent("ERROR");
					ioEvent.errorMessage = "I/O Error";
					_target.dispatchEvent(ioEvent);
					return;
				} catch(secerror:SecurityError) {
					var secEvent:FileWriteEvent = new FileWriteEvent("ERROR");
					secEvent.errorMessage = "Security Error";
					_target.dispatchEvent(secEvent);
					return;
				}
				
				var newEvent:FileWriteEvent = new FileWriteEvent("COMPLETE");
				_target.dispatchEvent(newEvent);
			}
		}
	}
}
