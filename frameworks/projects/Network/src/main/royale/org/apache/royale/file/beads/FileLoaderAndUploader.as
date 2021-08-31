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
	import org.apache.royale.events.Event;
	import org.apache.royale.file.FileProxy;
	import org.apache.royale.file.IFileModel;

	/**
	 *  The FileLoaderAndUploader is a compound bead that allows you
	 *  to load a file and upload it in one operation.
	 *  
	 *
	 *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	public class FileLoaderAndUploader implements IBead
	{
		private var _loader:FileLoader;
		private var _uploader:FileUploader;
		private var _url:String;
		private var _strand:IStrand;
		public function FileLoaderAndUploader()
		{
			super();
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
			_loader = value.getBeadByType(FileLoader) as FileLoader;
			if (!_loader)
			{
				_loader = new FileLoader();
				value.addBead(_loader);
			}
			_uploader = value.getBeadByType(FileUploader) as FileUploader;
			if (!_uploader)
			{
				_uploader = new FileUploader();
				value.addBead(_uploader);
			}
		}
		
		/**
		 *  Upload a file to the specified url. If file hasn't been loaded already it will be.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		
		public function upload(url:String):void
		{
			var fileModel:IFileModel = (_strand as FileProxy).model as IFileModel;
			if (fileModel.size <= 0)
			{
				_url = url;
				(_strand as FileProxy).model.addEventListener("blobChanged", blobChangedHandler);
				_loader.load();
			} else
			{
				_uploader.upload(url);
			}
		}
		
		/**
		 * @private
		 */
		public function cancel():void
		{
			_uploader.cancel();
		}

		private function blobChangedHandler(e:Event):void
		{
			(_strand as FileProxy).model.removeEventListener('blobChanged', blobChangedHandler);
			_uploader.upload(_url);
		}
		
	}
}
