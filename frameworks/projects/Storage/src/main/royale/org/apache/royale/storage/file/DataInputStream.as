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

COMPILE::SWF {
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.errors.IOError;
}

/**
 * Instances of the DataInputStream by the storage provider are created when a 
 * file is opened for input streaming. That is, its contents are read in chunks. 
 * Events are dispatched when a chunk has been read, if there is an error, and 
 * when the file has been read completely.
 * 
 * @langversion 3.0
 * @playerversion Flash 10.2
 * @playerversion AIR 2.6
 * @productversion Royale 0.0
 */
public class DataInputStream extends EventDispatcher implements IDataInput
{
	/**
	 * Constructor.
	 *
	 *  @param target The object to use as the event dispatch target.
	 *  @param fileHandle A platform-specific handle to the file system
	 *  @param fileReader A platform-specific handle to the file system
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public function DataInputStream(target:IEventDispatcher, fileHandle:Object, fileReader:Object)
	{
		super();
		
		_target = target;
		
		COMPILE::JS {
			_fileHandle = fileHandle as File;
			_fileReader = fileReader as FileReader;
			
			var self:DataInputStream = this;
			
			_fileReader.onloadend = function (e:Event):void {
				var streamEvent:FileEvent = new FileEvent("READ");
				streamEvent.stream = self;
				streamEvent.data = this.result;
				_target.dispatchEvent(streamEvent);
				
				self.close();
			};
		}
			
		COMPILE::SWF {
			_fileHandle = fileHandle as File;
			_fileReader = fileReader as FileStream;
		}
	}
	
	/**
	 * @target
	 */
	private var _target:IEventDispatcher;
	
	COMPILE::JS {
		private var _fileHandle:File;
		private var _fileReader:FileReader;
	}
	COMPILE::SWF {
		private var _fileHandle:File;
		private var _fileReader:FileStream;
	}
		
	/**
	 * Reads a chunk of text. A FileEvent "READ" event is dispatched when
	 * the chunk is read.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public function readText():void
	{
		COMPILE::JS {
			_fileReader.readAsText(_fileHandle);
		}
		COMPILE::SWF {
			var bytes:ByteArray = new ByteArray();
			_fileReader.readBytes(bytes);
			
			var text:String = new String(bytes);
			
			var newEvent:FileEvent = new FileEvent("READ");
			newEvent.data = text;
			_target.dispatchEvent(newEvent);
		}
	}
	
	/**
	 * Closes the file (and dispatches a FileEvent "COMPLETE" event).
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public function close():void
	{
		COMPILE::SWF {
			_fileReader.close();
		}
		
		var endEvent:FileEvent = new FileEvent("COMPLETE");
		endEvent.stream = this;
		_target.dispatchEvent(endEvent);
	}
}

}
