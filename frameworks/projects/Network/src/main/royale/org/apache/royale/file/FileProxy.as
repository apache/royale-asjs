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
package org.apache.royale.file
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IDocument;
	import org.apache.royale.core.StrandWithModel;
	import org.apache.royale.utils.BinaryData;

	COMPILE::SWF
	{
		import flash.net.FileReference;
	}
	
	/**
	 *  Indicates that the model has changed
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	[Event(name="modelChanged", type="org.apache.royale.events.Event")]
	/**
	 *  The FileProxy class is where beads regarding file operations are added.
	 *  Information about operations can be queried in the file model, or by
	 *  listenening to events dispatched by beads.
	 *
	 *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	public class FileProxy extends StrandWithModel implements IDocument, IFileModel
	{
		private var _document:Object;
		public function FileProxy()
		{
			super();
		}
		

		/**
		 * @private
		 */
		public function setDocument(document:Object, id:String = null):void
		{
			_document = document;
			for each (var bead:IBead in beads)
			{
				addBead(bead);
			}
		}

		/**
		 *  @copy org.apache.royale.file.IFileModel#lastModified
		 *  @royaleignorecoercion org.apache.royale.file.IFileModel
		 */
		public function get lastModified():uint
		{
			return (model as IFileModel).lastModified;
		}
		
		/**
		 *  @copy org.apache.royale.file.IFileModel#name
		 *  @royaleignorecoercion org.apache.royale.file.IFileModel
		 */
		public function get name():String
		{
			return (model as IFileModel).name;
		}
		
		/**
		 *  @copy org.apache.royale.file.IFileModel#type
		 *  @royaleignorecoercion org.apache.royale.file.IFileModel
		 */
		public function get type():String
		{
			return (model as IFileModel).type;
		}

		/**
		 *  @copy org.apache.royale.file.IFileModel#size
		 *  @royaleignorecoercion org.apache.royale.file.IFileModel
		 */
		public function get size():Number
		{
			return (model as IFileModel).size;
		}

		/**
		 *  @copy org.apache.royale.file.IFileModel#blob
		 *  @royaleignorecoercion org.apache.royale.file.IFileModel
		 */
		public function get blob():Object
		{
			return (model as IFileModel).blob;
		}

		/**
		 *  @copy org.apache.royale.file.IFileModel#fileContent
		 *  @royaleignorecoercion org.apache.royale.file.IFileModel
		 */
		public function set fileContent(value:BinaryData):void
		{
			(model as IFileModel).fileContent = value;
		}
		
		/**
		 *  @copy org.apache.royale.file.IFileModel#fileReference
		 */
		COMPILE::SWF
		public function get fileReference():FileReference
		{
			return (model as IFileModel).fileReference;
		}
		/**
		 *  @royaleignorecoercion org.apache.royale.file.IFileModel
		 */
		COMPILE::JS
		public function get fileReference():File
		{
			return (model as IFileModel).fileReference;
		}
		
		COMPILE::SWF
		public function set fileReference(value:FileReference):void
		{
			(model as IFileModel).fileReference = value;
		}

		/**
		 *  @royaleignorecoercion org.apache.royale.file.IFileModel
		 */
		COMPILE::JS
		public function set fileReference(value:File):void
		{
			(model as IFileModel).fileReference = value;
		}
		
	}
}
