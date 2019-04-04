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
package org.apache.royale.storage.providers
{
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.events.IEventDispatcher;
	
	import org.apache.royale.storage.events.FileEvent;
	import org.apache.royale.storage.events.FileErrorEvent;
	import org.apache.royale.storage.file.DataInputStream;
	import org.apache.royale.storage.file.DataOutputStream;

	/**
	 * The WebStorageProvider class implements the IPermanentStorageProvider
	 * interface for saving files to a mobile device. 
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10.2
	 * @playerversion AIR 2.6
	 * @productversion Royale 0.0
	 * @royaleignorecoercion FileEntry
	 * @royaleignorecoercion FileWriter
	 * @royaleignorecoercion window
     * @royaleignorecoercion Blob
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
		 *  @productversion Royale 0.0
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
		 *  @productversion Royale 0.0
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
		 *  @productversion Royale 0.0
		 */
		public function readTextFromDataFile( fileName:String ) : void
		{
			COMPILE::JS {
				var fullPath:String = String(cordova["file"]["dataDirectory"]) + fileName;
				
				window.resolveLocalFileSystemURL(fullPath, function (fileEntry:FileEntry):void {
					fileEntry.file(function (file:File):void {
						var reader:FileReader = new FileReader();
						reader.onloadend = function (e:Event):void {
							var newEvent:FileEvent = new FileEvent("READ");
							newEvent.data = this.result;
							_target.dispatchEvent(newEvent);
							
							var finEvent:FileEvent = new FileEvent("COMPLETE");
							_target.dispatchEvent(finEvent);
						};
						reader.readAsText(file);
					}, function (e:Event):void {
						var err1Event:FileErrorEvent = new FileErrorEvent("ERROR");
						err1Event.errorMessage = "Cannot open file for reading";
						err1Event.errorCode = 2;
						_target.dispatchEvent(err1Event);
					});
				}, function (e:Event):void {
					var err2Event:FileErrorEvent = new FileErrorEvent("ERROR");
					err2Event.errorMessage = "File does not exist";
					err2Event.errorCode = 1;
					_target.dispatchEvent(err2Event);
				});
			}
		}
		
		/**
		 * Opens an input stream into a file in the data storage directory. A Ready
		 * event is dispatched when the stream has been opened. Use the stream to
		 * read data from the file.
		 * 
		 *  @param fileName The name of file.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function openInputDataStream( fileName:String ) : void
		{
			COMPILE::JS {
				var fullPath:String = String(cordova["file"]["dataDirectory"]) + fileName;
				
				window.resolveLocalFileSystemURL(fullPath, function (fileEntry:FileEntry):void {
					fileEntry.file(function (file:FileEntry):void {
						var inputStream:DataInputStream = new DataInputStream(_target, file, new FileReader());
						var newEvent:FileEvent = new FileEvent("READY");
						newEvent.stream = inputStream;
						_target.dispatchEvent(newEvent);
					}, function (e:Event):void {
						var err1Event:FileErrorEvent = new FileErrorEvent("ERROR");
						err1Event.errorMessage = "Cannot open file for reading";
						err1Event.errorCode = 2;
						_target.dispatchEvent(err1Event);
					});
				}, function (e:Event):void {
					var err2Event:FileErrorEvent = new FileErrorEvent("ERROR");
					err2Event.errorMessage = "File does not exist";
					err2Event.errorCode = 1;
					_target.dispatchEvent(err2Event);
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
		 *  @productversion Royale 0.0
		 */
		public function writeTextToDataFile( fileName:String, text:String ) : void
		{
			COMPILE::JS {
				var fullPath:String = String(cordova["file"]["dataDirectory"]) + fileName;
		
				window.resolveLocalFileSystemURL(cordova.file.dataDirectory, function (directoryEntry:DirectoryEntry):void {
					directoryEntry.getFile(fileName, new FileSystemCreateFlags(), function (fileEntry:FileEntry):void {
						fileEntry.createWriter(function (fileWriter:FileWriter):void {
							fileWriter.onwriteend = function (e:Event):void {
								var newEvent:FileEvent = new FileEvent("WRITE");
								_target.dispatchEvent(newEvent);
								
								var finEvent:FileEvent = new FileEvent("COMPLETE");
								_target.dispatchEvent(finEvent);
							};
							
							fileWriter.onerror = function (e:Event):void {
								var newEvent:FileErrorEvent = new FileErrorEvent("ERROR");
								newEvent.errorMessage = "Failed to write the file.";
								newEvent.errorCode = 3;
								_target.dispatchEvent(newEvent);
							};
							
							var blob:Blob = new Blob([text], new BlobPlainTextOptions());
							fileWriter.write(blob);
						}, function(e:Event):void {
							var errEvent:FileErrorEvent = new FileErrorEvent("ERROR");
							errEvent.errorMessage = "Cannot open file for writing.";
							errEvent.errorCode = 1;
							_target.dispatchEvent(errEvent);
						});
					}, function(e:Event):void {
						var errEvent:FileErrorEvent = new FileErrorEvent("ERROR");
						errEvent.errorMessage = "Cannot create file.";
						errEvent.errorCode = 4;
						_target.dispatchEvent(errEvent);
					});
				}, function(e:Event):void {
					var errEvent:FileErrorEvent = new FileErrorEvent("ERROR");
					errEvent.errorMessage = "Cannot create file.";
					errEvent.errorCode = 4;
					_target.dispatchEvent(errEvent);
				});
			}
		}
		
		/**
		 * Opens an output stream into a file in the data storage directory. A Ready
		 * event is dispatched when the stream has been opened. Use the stream to
		 * write data to the file.
		 * 
		 *  @param fileName The name of file.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function openOutputDataStream( fileName:String ) : void
		{
			COMPILE::JS {
				var fullPath:String = String(cordova["file"]["dataDirectory"]) + fileName;
				
				window.resolveLocalFileSystemURL(cordova.file.dataDirectory, function (directoryEntry:DirectoryEntry):void {
					directoryEntry.getFile(fileName, new FileSystemCreateFlags, function (fileEntry:FileEntry):void {
						fileEntry.createWriter(function (fileWriter:FileWriter):void {
							var outputStream:DataOutputStream = new DataOutputStream(_target, fileEntry, fileWriter);
							var newEvent:FileEvent = new FileEvent("READY");
							newEvent.stream = outputStream;
							_target.dispatchEvent(newEvent);
						});
					});
				});
			}
		}
	}
}

COMPILE::JS
class BlobPlainTextOptions implements BlobPropertyBag
{
    public function get type():String
    {
        return "text/plain";
    }
    
    public function set type(value:String):void
    {
        
    }
}

COMPILE::JS
class FileSystemCreateFlags implements FileSystemFlags
{
    public function get create():Boolean
    {
        return true;
    }
    
    public function set create(value:Boolean):void
    {
        
    }
    
    public function get exclusive():Boolean
    {
        return false;
    }
    
    public function set exclusive(value:Boolean):void
    {
        
    }
}
