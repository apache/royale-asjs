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
	import org.apache.royale.core.Strand;
	import org.apache.royale.file.beads.FileModel;
	
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
	public class FileProxy extends Strand implements IDocument, IFileModel
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
		 */
		public function get lastModified():uint
		{
			return (model as FileModel).lastModified;
		}
		
		/**
		 *  @copy org.apache.royale.file.IFileModel#name
		 */
		public function get name():String
		{
			return (model as FileModel).name;
		}
		
		/**
		 *  @copy org.apache.royale.file.IFileModel#type
		 */
		public function get type():String
		{
			return (model as FileModel).type;
		}
		
	}
}
