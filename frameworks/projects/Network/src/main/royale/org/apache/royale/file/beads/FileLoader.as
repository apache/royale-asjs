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
package org.apache.royale.file.beads
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.file.FileProxy;
	import org.apache.royale.file.IFileModel;
	import org.apache.royale.utils.BinaryData;

	COMPILE::SWF
	{
		import flash.events.Event;
	}
	COMPILE::JS
	{
		import org.apache.royale.events.Event;
		import goog.events;
	}
	
	/**
	 *  The FileLoader class is a bead which adds to UploadImageProxy
	 *  the ability to browse the file system and select a file.
	 *  
	 *
	 *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	public class FileLoader extends EventDispatcher implements IBead
	{
		private var _strand:IStrand;

		
		/**
		 *  Load the file to the model's blob.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function load():void
		{
			COMPILE::SWF
			{
				fileModel.fileReference.addEventListener(Event.COMPLETE, fileLoadHandler);
				fileModel.fileReference.load();
			}
			COMPILE::JS 
			{
				var reader:FileReader = new FileReader();
				goog.events.listen(reader, 'load', fileLoadHandler);
				reader.readAsArrayBuffer(fileModel.fileReference);
			}
		}
		
		COMPILE::SWF 
		protected function fileLoadHandler(event:flash.events.Event):void
		{
			fileModel.fileReference.removeEventListener(Event.COMPLETE, fileLoadHandler);
			fileModel.fileContent = new BinaryData(fileModel.fileReference.data);
		}
		
		COMPILE::JS 
		protected function fileLoadHandler(event:Event):void
		{
			fileModel.fileContent = new BinaryData(event.target.result);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
		}
		/**
		 *  @royaleignorecoercion org.apache.royale.file.IFileModel
		 *  @royaleignorecoercion org.apache.royale.file.FileProxy
		 */
		protected function get fileModel():IFileModel
		{
			return (_strand as FileProxy).model as IFileModel;
		}
		
	}
}
