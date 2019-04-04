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
package org.apache.royale.storage.file
{
import org.apache.royale.events.EventDispatcher;
import org.apache.royale.events.IEventDispatcher;
import org.apache.royale.storage.events.FileEvent;
import org.apache.royale.storage.events.FileErrorEvent;

COMPILE::SWF {
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.errors.IOError;
}

/**
 * Instances of the DataOutput stream are created by the storage provider when a file
 * is opened for output streaming. Events are dispatches as the file is opened, written to,
 * and finally closed.
 * 
 * @langversion 3.0
 * @playerversion Flash 10.2
 * @playerversion AIR 2.6
 * @productversion Royale 0.0
 */
public class DataOutputStream extends EventDispatcher implements IDataOutput
{
	/**
	 * Constructor.
	 * 
	 *  @param target The object to as the event dispatch target.
	 *  @param fileHandle A reference to a platform-specific file object.
	 *  @param fileWriter A reference to a platform-specific file object.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public function DataOutputStream(target:IEventDispatcher, fileHandle:Object, fileWriter:Object)
	{
		super();
		
		_target = target;
		
		COMPILE::JS {
			_fileHandle = fileHandle as FileEntry;
			_fileWriter = fileWriter as FileWriter;
			
			var self:DataOutputStream = this;
			
			_fileWriter.onwriteend = function (e:Event):void {
				var newEvent:FileEvent = new FileEvent("WRITE");
				newEvent.stream = self;
				_target.dispatchEvent(newEvent);
			};
			
			_fileWriter.onerror = function (e:Event):void {
				var newEvent:FileErrorEvent = new FileErrorEvent("ERROR");
				newEvent.stream = self;
				newEvent.errorMessage = "Failed to write the file.";
				_target.dispatchEvent(newEvent);
			};
			
			_fileWriter.truncate(0);
		}
			
		COMPILE::SWF {
			_fileHandle = fileHandle as File;
			_fileWriter = fileWriter as FileStream;
		}
	}
	
	/**
	 * @private
	 */
	private var _target:IEventDispatcher;
	
	COMPILE::JS {
		private var _fileHandle:FileEntry;
		private var _fileWriter:FileWriter;
	}
	COMPILE::SWF {
		private var _fileHandle:File;
		private var _fileWriter:FileStream;
	}
		
	/**
	 * Writes a chunk of text into the file. When the file is ready to accept the nex
	 * chunk, a FileEvent "WRITE" event is dispatched.
	 * 
	 *  @param text The string to write into the file.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public function writeText(text:String):void
	{
		COMPILE::JS {
			var blob:Blob = new Blob([text], new BlobPlainTextOptions());
			_fileWriter.write(blob);
		}
		COMPILE::SWF {
			try {
				_fileWriter.writeUTFBytes(text);
				
				var newEvent:FileEvent = new FileEvent("WRITE");
				newEvent.stream = this;
				_target.dispatchEvent(newEvent);
				
			} catch(ioerror:IOError) {
				var ioEvent:FileErrorEvent = new FileErrorEvent("ERROR");
				ioEvent.errorMessage = "I/O Error";
				ioEvent.errorCode = 2;
				_target.dispatchEvent(ioEvent);
			} catch(secerror:SecurityError) {
				var secEvent:FileErrorEvent = new FileErrorEvent("ERROR");
				secEvent.errorMessage = "Security Error";
				secEvent.errorCode = 3;
				_target.dispatchEvent(secEvent);
			}
		}
	}
	
	/**
	 * Closes the file and dispatches a FileEvent "COMPLETE" event.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public function close():void
	{
		COMPILE::SWF {
			_fileWriter.close();
		}
			
		var newEvent:FileEvent = new FileEvent("COMPLETE");
		newEvent.stream = this;
		_target.dispatchEvent(newEvent);
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

