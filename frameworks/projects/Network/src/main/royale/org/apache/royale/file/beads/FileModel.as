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
	COMPILE::SWF
	{
		import flash.net.FileReference;
	}
	import org.apache.royale.core.IBeadModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.file.IFileModel;
	import org.apache.royale.utils.BinaryData;

	COMPILE::SWF
	{
		import flash.net.FileReference;
	}
	
	/**
	 *  The FileModel class is a bead that contains basic information
	 *  on the file referenced by FileProxy
	 *  
	 *
	 *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	public class FileModel extends EventDispatcher implements IBeadModel, IFileModel
	{
		private var _strand:IStrand;
		private var _blob:BinaryData;
		COMPILE::SWF
		{
			private var _data:FileReference;
		}
		COMPILE::JS
		{
			private var _data:File;
		}
	
		/**
		 *  Constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function FileModel()
		{
		}
		
		COMPILE::JS
		public function set fileReference(value:File):void
		{
			_data = value;
		}
		
		COMPILE::SWF
		public function set fileReference(value:FileReference):void
		{
			_data = value;
		}
		
		/**
		 *  @copy org.apache.royale.file.IFileModel#size
		 */
		public function get size():Number
		{
			COMPILE::SWF 
			{
				return _data.size;
			}
			COMPILE::JS 
			{
				return blob ? blob.length : -1;
			}
		}
		
		/**
		 *  @copy org.apache.royale.file.IFileModel#name
		 */
		public function get name():String
		{
			return _data.name;
		}
		
		// TODO this will give different results in flash and in JS (extension and MIME respectively). Fix this.
		/**
		 *  @copy org.apache.royale.file.IFileModel#type
		 */
		public function get type():String
		{
			return _data.type;
		}
		
		/**
		 *  @copy org.apache.royale.file.IFileModel#lastModified
		 */
		public function get lastModified():uint
		{
			COMPILE::SWF
			{
				return _data.modificationDate.milliseconds;
			}
			COMPILE::JS
			{
				return _data.lastModified;
			}
		}
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
		}
		
		/**
		 * @private
		 */
		COMPILE::SWF
		public function get fileReference():FileReference
		{
			return _data as FileReference;
		}
		
		/**
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 *  @royaleignorecoercion File
		 */
		COMPILE::JS
		public function get fileReference():File
		{
			return _data as File;
		}

        /**
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
		public function get blob():Object
		{
			return _blob;
		}
		
		public function set fileContent(value:BinaryData):void
		{
			_blob = value;
			dispatchEvent(new Event("blobChanged"));
		}
		
	}
}
